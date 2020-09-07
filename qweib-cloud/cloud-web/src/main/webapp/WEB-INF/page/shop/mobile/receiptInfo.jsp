<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>${distributionMode==1?'收货':'提货'}地址列表</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <%--<title>收货地址</title>--%>
    <style>
        .mui-content {
            padding-bottom: 53px;
        }

        .mui-table h4, .mui-table h5, .mui-table p {
            margin-top: 0;
        }

        .mui-table h4 {
            line-height: 21px;
            font-weight: normal;
            font-size: 16px;
        }

        .mui-h5 {
            display: inline-block;
            height: 40px;
            width: 40px;
            color: red;
        }

        .mui-content-padded {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            margin: 0px 10px;
        }

        .mui-btn-block {
            padding: 8px;
        }
    </style>
</head>

<!-- --------body开始----------- -->
<body>

<header class="mui-bar mui-bar-nav">
    <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
    <h1 class="mui-title">${distributionMode==1?'收货':'提货'}地址列表</h1>
</header>
<div class="mui-content">
    <ul id="addressList" class="mui-table-view mui-table-view-striped mui-table-view-condensed">
        <%--<li class="mui-table-view-cell">
            <div class="mui-table">
                <div class="mui-table-cell mui-col-xs-10">
                    <h4 class="mui-ellipsis">叶生根 13910104779</h4>
                    <h5 class="mui-ellipsis">>余斌小学余斌小学余斌小学余斌小学余斌小学余斌小学余斌小学余斌小学余斌小学余斌小学</h5>
                </div>
                <div class="mui-table-cell mui-col-xs-2 mui-text-right">
                    <span class="mui-h5">编辑</span>
                </div>
            </div>
        </li>--%>
    </ul>
    <c:if test="${distributionMode!=2}">
        <div class="mui-content-padded">
            <button type="button" class="mui-btn mui-btn-primary mui-btn-block" onclick="javaScript:toAddress();">
                新增收货地址
            </button>
        </div>
    </c:if>
</div>

</body>

<script>
    mui.init();

    /*$(document).ready(function() {
        $.wechatShare();//分享
    })*/

    $(function () {
        //解决ios返回页面无法刷新的问题-start
        var isPageHide = false;
        window.addEventListener('pageshow', function () {
            if (isPageHide) {
                window.location.reload();
            }
        });
        window.addEventListener('pagehide', function () {
            isPageHide = true;
        });
        //解决ios返回页面无法刷新的问题-end

        var lng = getCache('lng');
        var lat = getCache('lat');
        if (lng, lat) {
            g_callMapData(lng, lat);
            removeCache('lng');
            removeCache('lat');
            removeCache('addressList')
        } else {
            getAddressList();
        }
    })

    //获取地址列表
    function getAddressList() {
        var data = {distributionMode: '${distributionMode}'};
        var location = getCache('location');//用户当前经纬度
        if (location)
            Object.assign(data, JSON.parse(location));
        $.ajax({
            url: "<%=basePath%>/web/shopMemberAddressMobile/queryMemberAddress",
            data: data,
            type: "POST",
            success: function (json) {
                if (json.state) {
                    var datas = json.obj;
                    if ('${distributionMode}' == '2') {
                        setCache('addressList', JSON.stringify(datas));
                    }
                    var str = "";
                    if (datas != null && datas != undefined && datas.length > 0) {
                        for (var i = 0; i < datas.length; i++) {
                            var data = datas[i];

                            //入口：1:我的2：下单（更新默认收货地址）
                            var type = ${type};
                            var typeStr = '';
                            var navigationStr = '';
                            if (type == '2') {
                                typeStr = "javaScript:setNormalAddress(" + data.id + ");"
                                navigationStr = "javaScript:toNavigation(" + data.longitude + ',' + data.latitude + ");"
                            }

                            str += "<li class=\"mui-table-view-cell\">";
                            str += "<div class=\"mui-table\">";
                            str += "<div class=\"mui-table-cell mui-col-xs-10\">";
                            str += "<h4 class=\"mui-ellipsis\"  onclick='" + typeStr + "'>" + data.linkman + "  " + data.mobile + "</h4>";
                            var areaInfo = data.areaInfo ? data.areaInfo : "";
                            str += "<h5 class=\"mui-ellipsis\" onclick='" + typeStr + "'>" + areaInfo + data.address + "</h5>";
                            if (data.latitude && data.longitude) {
                                str += "<h5 class=\"mui-ellipsis\" style='color: red;'>";
                                if (data.userRadius)
                                    str += "<span onclick='" + navigationStr + "'>距离:" + (data.userRadius || '') + "</span>";
                                str += "<span onclick='" + navigationStr + "'>导航</span>";
                                str += "</h5>";
                            }
                            str += "</div>";
                            <c:if test="${distributionMode!=2}">
                            str += "<div class=\"mui-table-cell mui-col-xs-2 mui-text-right\" onclick='javaScript:event.stopPropagation();edit(" + data.id + ");'>";
                            str += "<span class=\"mui-h5\">编辑</span>";
                            str += "</div>";
                            </c:if>

                            str += "</div>";
                            str += "</li>";
                        }
                    }
                    $("#addressList").html(str);
                }
            },
            error: function (data) {
                mui.toast("异常");
            }
        });
    }

    //编辑地址
    function edit(id) {
        //防止事件冒泡
        event.stopPropagation();
        <%--window.location.href = "<%=basePath %>/web/shopMemberAddressMobile/toNewAddress?id="+id;--%>
        toPage("<%=basePath %>/web/shopMemberAddressMobile/toNewAddress?token=${token}&id=" + id);
    }

    //新增地址
    function toAddress() {
        <%--window.location.href = "<%=basePath %>/web/shopMemberAddressMobile/toNewAddress?type=1";--%>
        toPage("<%=basePath %>/web/shopMemberAddressMobile/toNewAddress?token=${token}&type=1");
    }

    //设置为默认地址
    function setNormalAddress(id) {
        setCache('selectAddressId', id);
        setCache('distributionMode', '${distributionMode}');
        history.back();
    }

    //地图导航
    function toNavigation(longitude, latitude) {
        if (longitude && latitude) {
            var location = getCache('location');//用户当前经纬度
            var str = '';
            if (location) {
                location = JSON.parse(location);
                str = '&mylatitude=' + location.latitude + '&mylongitude=' + location.longitude;
            }
            var url = '<%=basePath %>/web/shopMemberAddressMobile/toNavigation?latitude=' + latitude + '&longitude=' + longitude + str;
            //location.href = url;
            toPage(url);
        }
    }

    /**
     * 地图回调
     * @param lng
     * @param lat
     */
    function g_callMapData(lng, lat) {
        var addressList = getCache('addressList');
        if (addressList) addressList = JSON.parse(addressList);
        if (addressList && addressList.length > 0 && lng && lat) {
            addressList.forEach(function (item) {
                if (item.longitude == lng && item.latitude == lat) {
                    setNormalAddress(item.id);
                    return;
                }
            })
        }
    }
</script>


</html>
