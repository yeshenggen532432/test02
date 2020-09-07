<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>确认订单页面</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <%--<title>收货地址</title>--%>
    <style type="text/css">
        input {
            border: none;
            outline: none;
            font-size: 14px;
            color: #333333;
        }

        .mui-media {
            font-size: 14px;
        }

        .mui-table-view .mui-media-object {
            max-width: initial;
            width: 90px;
            height: 70px;
        }

        .meta-info {
            position: absolute;
            left: 115px;
            right: 15px;
            top: 40px;
            color: #8f8f94;
        }

        .meta-info .author,
        .meta-info .time {
            display: inline-block;
        }

        .meta-info .author {
            width: 70%;
            font-size: 12px;
            color: #8f8f94;
        }

        .meta-info .time {
            float: right;
            width: 30%;
            text-align: right;
            font-size: 12px;
            color: #8f8f94;
        }

        .mui-table-view:before,
        .mui-table-view:after {
            height: 0;
        }

        .mui-content > .mui-table-view:first-child {
            margin-top: 0px;
        }

        .meta-money {
            position: absolute;
            left: 115px;
            right: 15px;
            bottom: 8px;
            color: red;
            font-size: 12px;
        }

        .mui-content {
            padding-bottom: 80px;
        }

        .my-footer {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            height: 40px;
        }

        .my-footer2 {
            position: fixed;
            bottom: 40px;
            left: 0;
            right: 0;
            /*height: 40px;*/
        }

        .red {
            color: red;
            font-size: 16px;
        }

        #shr {
            display: inline-block;
            width: 100px;
        }

        #tel {
            display: inline-block;
        }

        input#address {
            display: block;
            width: 100%;
            font-size: 12px;
            color: #8f8f94;
        }

        #hasAddress {
            display: none;
        }

        .mui-badge1 {
            padding-left: 15px;
            width: 98%;
            float: left;
            line-height: 42px;
            font-size: 14px;
        }

        #selfMentioningLi input {
            margin-bottom: 0px
        }
    </style>
</head>

<!-- --------body开始----------- -->
<body>
<header class="mui-bar mui-bar-nav">
    <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
    <h1 class="mui-title">订单提交</h1>
</header>


<div class="mui-content ">
    <form action="" name="savefrm" id="savefrm" method="post">
        <div class="mui-input-row">
            <ul class="mui-table-view mui-table-view-chevron">
                <li class="mui-table-view-cell"<c:if test="${distributionMode!=2}"> style="display: none"</c:if>
                    id="selfMentioningLi">
                    <input id="takeName" name="takeName" value="${shopMember.name}" type="text" placeholder="提货人姓名"
                           style="width:40%">
                    <input id="takeTel" name="takeTel" value="${shopMember.mobile}" type="text" placeholder="提货人手机号"
                           style="width:50%">
                </li>
            </ul>
            <ul class="mui-table-view">
                <div>
                    <span class="mui-badge1">
                        <span id="distributionModeName">
                        <c:if test="${distributionMode==1||distributionMode==3}">送货点</c:if><c:if
                                test="${distributionMode==2}">自提点</c:if></span>
                        :<span style="float:right;">
                            <c:if test="${distributionMode==1 || distributionMode==3}"><input type="radio"
                                                                                              name="distributionMode"
                                                                                              value="1"
                                                                                              onclick="chanageDistributionMode()"
                                                                                              <c:if test="${distributionMode==1||distributionMode==3}">checked</c:if>>快递</c:if>&nbsp;&nbsp;&nbsp;
                            <c:if test="${distributionMode==2 || distributionMode==3}"><input type="radio"
                                                                                              name="distributionMode"
                                                                                              value="2"
                                                                                              onclick="chanageDistributionMode()"
                                                                                              <c:if test="${distributionMode==2}">checked</c:if>>自提</c:if>
                        </span>
                    </span>
                </div>
            </ul>
            <div class="mui-input-row">
                <ul class="mui-table-view mui-table-view-chevron">
                    <li class="mui-table-view-cell" id="mailAddress">
                        <a class="mui-navigate-right" href="javaScript:toSeleteAddress();">
                            <div class="mui-media-body" id="hasAddress">
                                <div>
                                    <span id="shr" class='mui-ellipsis'></span>
                                    <span id="tel" class='mui-ellipsis'></span>
                                </div>
                                <span id="address" class='mui-ellipsis'></span>
                                <input id="addressId" name="addressId" value="" type="hidden">
                                <input id="provinceId" name="provinceId" value="" type="hidden">
                                <input id="cityId" name="cityId" value="" type="hidden">
                                <input id="areaId" name="areaId" value="" type="hidden">
                            </div>
                            <div class="mui-media-body" id="noaddress">
                                ${(distributionMode==1 || distributionMode==3)?'设置收货地址':'选择自提点'}
                            </div>
                        </a>
                    </li>
                </ul>

                <ul class="mui-table-view">
                    <c:forEach items="${shopCartRewardFillVoList}" var="voList" varStatus="s">
                        <c:if test="${voList.rewardItemVo !=null}">
                            <li class="mui-table-view-cell mui-media" id="list"
                                style="background-color: antiquewhite;">${voList.rewardItemVo.memo}</li>
                        </c:if>
                        <c:forEach items="${voList.cartVoList}" var="item">
                            <li class="mui-table-view-cell mui-media" id="list">
                                    <%--<img class="mui-media-object mui-pull-left" src="item.cover">--%>
                                <c:choose>
                                    <c:when test="${ not empty item.warePicList}">
                                        <img class="mui-media-object mui-pull-left"
                                             src="<%=basePath%>/upload/${item.defWarePic.picMini}"
                                             wareId='${item.wareId}'>
                                    </c:when>
                                    <c:otherwise>
                                        <img class="mui-media-object mui-pull-left"
                                             src="<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg"
                                             wareId='${item.wareId}'>
                                    </c:otherwise>
                                </c:choose>
                                <div class="mui-media-body">
                                    <span class="mui-ellipsis">${item.wareNm}</span>
                                </div>
                                <div class="meta-info">
                                    <span class="author">规格：${item.defWareGg}</span>
                                    <span class="time">X ${item.shopCart.wareNum}</span>
                                </div>
                                <span class="meta-money">
                                        <c:choose>
                                            <c:when test="${item.defWarePriceFinal !=null}">
                                                <del>${item.defWarePrice}</del>
                                                &nbsp;&nbsp;${item.defWarePriceFinal}</c:when>
                                            <c:otherwise>${item.defWarePrice}</c:otherwise>
                                        </c:choose>
                                    </span>


                            </li>
                        </c:forEach>
                    </c:forEach>
                </ul>
            </div>

            <ul class="mui-table-view" style="margin-top: 10px">


                <div class="mui-input-group">
                    <div class="mui-input-row">
                        <input name="remo" id="remo" type="text" class="mui-input-clear" placeholder="备注"
                               maxlength="150"/>
                    </div>
                    <div class="mui-input-row">
                    <span class="mui-badge1">商品总价<span style="float:right;">￥<fmt:formatNumber type="number"
                                                                                               value="${zje}"
                                                                                               pattern="0.00"
                                                                                               maxFractionDigits="2"/></span></span>
                    </div>
                    <c:if test="${promot !=null && promot !=0}">
                        <div class="mui-input-row">
                        <span class="mui-badge1">促销<span style="float:right;">-￥<fmt:formatNumber type="number"
                                                                                                  value="${promot}"
                                                                                                  pattern="0.00"
                                                                                                  maxFractionDigits="2"/></span></span>
                        </div>
                    </c:if>
                    <div class="mui-input-row" id="getFreightDiv" style="display: none">
                        <%--<label>运费：￥</label>--%>
                        <div class="mui-input-row">
                            <span class="mui-badge1">运费<span style="float:right;" id="getFreight"></span></span>
                        </div>
                    </div>
                </div>
            </ul>
            <nav class="mui-table-view my-footer">
                <li class="mui-table-view-cell">
				<span class="red">
					实付款:￥<span id="zje"><fmt:formatNumber type="number" value="${amount}" pattern="0.00"
                                                          maxFractionDigits="2"/></span><%--<span style="font-size: 12px;">(含运费:${freight})</span>--%>
				</span>
                    <button type="button" class="mui-btn mui-btn-primary" onclick="javascript:toSumbit(false);">提交
                    </button>
                </li>
            </nav>

    </form>
</div>


<script>
    var distributionMode = '${distributionMode}';
    mui.init();
    var zje =${amount};
    $(document).ready(function () {
        //$.wechatShare();//分享
        //解决ios返回页面无法刷新的问题-start
        var isPageHide = false;
        window.addEventListener('pageshow', function () {
            if (isPageHide) {
                setTimeout(function () {
                    onLoad();
                }, 100)
            }
        });
        window.addEventListener('pagehide', function () {
            isPageHide = true;
        });
        //解决ios返回页面无法刷新的问题-end
        //如果是点餐时不需要收货地址
        onLoad();
    })

    function onLoad() {
        var diningid = getCache("diningid");
        if (!diningid) {
            //getDefaultAddress();
            chanageDistributionMode(1);
        } else {
            $(".mui-table-view-chevron").remove();
        }
    }

    //改变配送方式
    function chanageDistributionMode(auto) {
        var type = $('[name=distributionMode]:checked').val();
        var disStr = type == 1 ? 'none' : '';
        $('#selfMentioningLi').css("display", disStr);
        if (!auto)
            clearAddress(type);
        getDefaultAddress();
    }

    function clearAddress(type) {
        $('#shr').text('');
        $('#tel').text('');
        $('#address').text('');
        $('#addressId').val('');
        $('#provinceId').val('');
        $('#cityId').val('');
        $('#areaId').val('');
        $("#noaddress").text(type == 1 ? '选择收货地址' : '选择自提点');
        $("#distributionModeName").text(type == 1 ? '送货点' : '自提点');
        $("#noaddress").show();
        $('#hasAddress').hide();
    }


    //获取默认地址
    function getDefaultAddress() {

        //chanageDistributionMode(1);

        var selectAddressId = getCache('selectAddressId');
        var distributionMode = getCache('distributionMode');
        var type = $('[name=distributionMode]:checked').val();
        if (type != distributionMode) {
            selectAddressId = '';
            removeCache('selectAddressId');
            removeCache('distributionMode');
        }
        var url = '<%=basePath %>/web/shopMemberAddressMobile/queryMemberDefaultAddress';
        if (selectAddressId)
            url = '<%=basePath %>/web/shopMemberAddressMobile/queryMemberAddressWebById'
        var data = {id: selectAddressId, distributionMode: $('[name=distributionMode]:checked').val()};
        var location = getCache('location');//用户当前经纬度
        if (location)
            Object.assign(data, JSON.parse(location));
        $.ajax({
            type: "POST",                  //提交方式
            dataType: "json",              //预期服务器返回的数据类型
            url: url,
            data: data, //提交的数据
            success: function (json) {
                if (json.state) {
                    json = json.obj;
                    if (!json) return;
                    $("#shr").text(json.linkman);
                    $("#tel").text(json.mobile);
                    var areaInfo = json.areaInfo ? json.areaInfo : "";
                    $("#address").text(json.areaInfo + json.address);
                    $("#addressId").val(json.id);
                    $("#provinceId").val(json.provinceId);
                    $("#cityId").val(json.cityId);
                    $("#areaId").val(json.areaId);
                    $('#hasAddress').show();
                    $('#noaddress').hide()
                    if (json.cityId) {//地区不为空时查找运费模版
                        getFreight(json.provinceId, json.cityId, json.areaId);
                    } else {
                        mui.toast("请完善收货地址！");
                    }
                } else {
                    $('#hasAddress').hide();
                    $('#noaddress').show();
                }
            }
        });
    }

    var showMessage = null;

    //运费模版加载
    function getFreight(provinceId, cityId, areaId) {
        $.post("${base}/web/shopBforderMobile/getFreight?token=${token}", {
            "cartIds": "${cartIds}",
            "provinceId": provinceId,
            "cityId": cityId,
            "areaId": areaId
        }, function (data) {
            if (data.state) {
                $("#getFreightDiv").css("display", "");
                var obj = data.obj;
                $("#getFreight").html("+￥" + obj.freight.toFixed(2));
                $("#zje").html((obj.freight + zje).toFixed(2));
            } else {
                showMessage = data.message;
            }
        })
    }

    /**
     *跳到收货地址
     */
    function toSeleteAddress() {
        var distributionMode = $('[name=distributionMode]:checked').val();
        <%--window.location.href = '<%=basePath %>/web/shopMemberAddressMobile/toReceiptInfo?type=2';--%>
        toPage('<%=basePath %>/web/shopMemberAddressMobile/toReceiptInfo?token=${token}&type=2&distributionMode=' + distributionMode);
    }

    /**
     * 提交
     */
    function toSumbit(notstockContion) {
        //如果是点餐时不需要收货地址
        var diningid = getCache("diningid");
        if (!diningid) {
            var addressId = $("#addressId").val();
            if (!addressId) {
                mui.alert("请选择收货地址", function () {
                    //toPage('<%=basePath %>/web/shopMemberAddressMobile/toNewAddress?token=${token}&type=2');
                });
                return;
            }
            if (!$("#cityId").val()) {
                mui.alert("请完善收货地址", function () {
                    toPage('<%=basePath %>/web/shopMemberAddressMobile/toNewAddress?token=${token}&type=2&id=' + addressId);
                });
                return;
            }
        }

        if (showMessage) {
            mui.alert(showMessage);
            return null;
        }
        var distributionMode = $('[name=distributionMode]:checked').val();
        if (distributionMode && distributionMode == 2) {
            if (!$("#takeName").val()) {
                mui.alert('请输入提货人');
                return null;
            }
            if (!$("#takeTel").val()) {
                mui.alert('请输入提货电话');
                return null;
            }
        }
        mui(".mui-btn-primary").button("loading");
        $(".mui-btn-primary").prop("disabled", true);
        $.ajax({
            type: "POST",                  //提交方式
            dataType: "json",              //预期服务器返回的数据类型
            url: "<%=basePath %>/web/shopBforderMobile/addOrder?token=${token}&type=${type}&cartIds=${cartIds}&rewardItemIds=${rewardItemIds}&notstockContion=" + notstockContion + "&pid=" + getCache("pid") + "&diningid=" + diningid,
            data: $('#savefrm').serialize(), //提交的数据
            success: function (result) {
                if (result.state) {
                    <%--window.location.href="<%=basePath%>/web/shopBforderMobile/toOrderPay?id="+result.orderId;--%>
                    toPage("<%=basePath%>/web/shopBforderMobile/toOrderPay?token=${token}&id=" + result.obj.orderId);
                } else {
                    $(".mui-btn-primary").text("确认提交");
                    $(".mui-btn-primary").prop("disabled", false);
                    if (result.code && result.code == 100) {
                        mui.confirm(result.message + ",是否继续下单", '提醒', function (c) {
                            if (c.index)
                                toSumbit(c.index);
                        })
                    } else {
                        mui.alert(result.message);
                    }
                }
            },
            error: function () {
                mui.toast("异常！");
                $(".mui-btn-primary").text("确认提交");
                $(".mui-btn-primary").prop("disabled", false);
            }
        });
    }

    /**
     * 商品详情
     */
    mui("#list").on('tap', '.mui-media-object', function () {
        var wareId = this.getAttribute('wareId');
        toPage("<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId=" + wareId);
    })
</script>

</body>
</html>
