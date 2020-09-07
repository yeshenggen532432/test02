<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>收货地址编辑</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <%--<title>收货地址</title>--%>
    <style>

        /*.mui-input-group .mui-input-row{
            height: 50px;
        }*/

        .mui-input-row label {
            font-size: 15px;
        }

        .mui-input-row input {
            font-size: 15px;
        }

        .mui-btn-block {
            padding: 8px;
            margin-top: 20px;
        }

        .mui-badge1 {
            padding: 0px;
            width: 65%;
            float: right;
            line-height: 42px;
            font-size: 14px;
        }
    </style>
</head>

<!-- --------body开始----------- -->
<body>
<header class="mui-bar mui-bar-nav">
    <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
    <h1 class="mui-title">收货地址</h1>
</header>

<div class="mui-content">
    <form class="mui-input-group" action="" name="addfrm" id="addfrm" method="post">
        <input name="id" id="id" type="text" hidden="true" value="${id}"/>
        <input name="areaInfo" id="areaInfo" value="" type="hidden">
        <div class="mui-input-row">
            <label>收货人：</label>
            <input name="linkman" id="linkman" type="text" class="mui-input-clear" placeholder="请输入收货人姓名">
        </div>
        <div class="mui-input-row">
            <label>联系方式：</label>
            <input name="mobile" id="mobile" type="text" class="mui-input-clear" placeholder="请输入联系方式"
                   oninput="value=value.replace(/[^\d]/g,'')" maxlength="11">
        </div>
        <%--<div class="mui-input-row">
            <label>联系方式：</label>
            <span id="province"></span><span id="city"></span><span id="area"></span>

        </div>--%>
        <div class="mui-input-group">
            <div class="mui-input-row">
                <label>选择省</label>
                <span class="mui-badge1" id="provinceId"></span>
            </div>
        </div>
        <div class="mui-input-group">
            <div class="mui-input-row">
                <label>选择市</label>
                <span class="mui-badge1" id="cityId"></span>
            </div>
        </div>
        <div class="mui-input-group">
            <div class="mui-input-row">
                <label>选择区</label>
                <span class="mui-badge1" id="areaId"></span>
            </div>
        </div>

        <div class="mui-input-row">
            <label>详细地址：</label>
            <input name="address" id="address" type="text" class="mui-input-clear" placeholder="请输入详细地址">
        </div>
    </form>

    <div class="action-btns mui-content-padded">
        <button id="save" type="button" class="mui-btn mui-btn-primary mui-btn-block">保存</button>
        <button id="delete" type="button" class="mui-btn mui-btn-block"
                style="<c:if test="${id ==null || id ==0}">display:none</c:if>">删除
        </button>
    </div>
</div>

<script>
    mui.init();

    $(document).ready(function () {
        //$.wechatShare();//分享
        //id!=null && id!=0：修改地址
        var id =${id};
        if (id != null && id != 0) {
            $.ajax({
                type: "POST",
                dataType: "json",
                url: "<%=basePath %>/web/shopMemberAddressMobile/queryMemberAddressWebById",
                data: "token=${token}&id=" + id,
                success: function (result) {
                    if (result != null && result.state) {
                        result = result.obj;
                        $("#linkman").val(result.linkman);
                        $("#mobile").val(result.mobile);
                        $("#address").val(result.address);
                        loadProvince(result.provinceId, result.cityId, result.areaId);
                        $("#areaInfo").val(result.areaInfo);
                    }
                },
                error: function () {
                    mui.toast('异常');
                }
            });
        } else {
            loadProvince(0);
        }

    })

    //添加；修改公用：以id区分
    mui(".action-btns").on('tap', "#save", function () {
        console.log('save tap');
        var linkman = $("#linkman").val();
        var mobile = $("#mobile").val();
        var address = $("#address").val();
        if (linkman == "" || linkman == null) {
            mui.alert("请输入联系人姓名");
            return;
        }
        if (mobile == "" || mobile == null) {
            mui.alert("请输入联系方式");
            return;
        }
        if (address == "" || address == null) {
            mui.alert("请输入详细地址");
            return;
        }
        var provinceId = $("[name=provinceId]").val();
        var cityId = $("[name=cityId]").val();
        var areaId = $("[name=areaId]").val();
        if (!provinceId) {
            mui.alert("请选择省");
            return;
        }
        if (!cityId) {
            mui.alert("请选择市");
            return;
        }
        if (!areaId) {
            mui.alert("请选择区");
            return;
        }

        var provinceT = $("[name=provinceId]").find("option:selected").text();
        var cityT = $("[name=cityId]").find("option:selected").text();
        var areaT = $("[name=areaId]").find("option:selected").text();
        $("#areaInfo").val(provinceT + cityT + areaT);

        mui("#save").button("loading");
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "<%=basePath %>/web/shopMemberAddressMobile/addAddress?token=${token}",
            data: $('#addfrm').serialize(), //提交的数据
            success: function (result) {
                if (result != null && result.state) {
                    history.back();
                }
                mui.toast(result.message);
                mui("#save").button("reset");
            },
            error: function () {
                mui("#save").button("reset");
                mui.toast('异常');
            }
        });
    });
    mui(".action-btns").on('tap', '#delete', function () {
        console.log('delete tap');
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "<%=basePath %>/web/shopMemberAddressMobile/deleteMemberAddressWeb?token=${token}&id=${id}",
            success: function (result) {
                mui.alert(result.message, function () {
                    if (result != null && result.state) {
                        history.back();
                    }
                });
                /*mui.toast(result.message);
                if(result!=null && result.state){
                    setTimeout(function () {
                        history.back();
                    },1000)
                }*/
            },
            error: function () {
                mui.toast(result.message);
            }
        });
    });


    //获取店铺地址
    function loadProvince(provinceId, cityId, areaId) {
        getChild("0", "provinceId", provinceId);
        getChild(provinceId, "cityId", cityId);
        getChild(cityId, "areaId", areaId);
    }


    function getChild(parentId, name, selectId) {
        if (parentId != null && parentId != '') {
            $.get("${base}/web/shopMemberAddressMobile/shopArea/getChild?parentId=" + parentId, function (data) {
                $("#" + name).html(getSelect(data, name, selectId));
            });
        }
    }

    //根据城市接口返回数据后转成select
    function getSelect(data, name, selectId) {
        var html = "<select name='" + name + "' onchange='changeSelect(this)'>";
        html += '<option value="">请选择</option>';
        if (data && data.state && data.obj) {
            var array = data.obj;
            for (var i = 0; i < array.length; i++) {
                var obj = array[i];
                var selectStr = "";
                if (selectId && obj.areaId == selectId)
                    selectStr = "selected";
                html += '<option value="' + obj.areaId + '" data-parentId="' + obj.areaParentId + '" ' + selectStr + '>' + obj.areaName + '</option>';
            }
        }
        html += "</select>";
        return html;
    }

    //改变事件
    function changeSelect(th) {
        var value = $(th).val();
        //if(!value)$(th).parent().next().html("");//$(th).parent().next().remove()
        var name = $(th).attr("name");
        if (name == 'areaId') return;
        if (name == 'provinceId') {
            name = "cityId";
            if (!value) {
                $("#cityId").html("");
            }
            $("#areaId").html("");
        } else if (name == 'cityId') {
            name = "areaId";
            if (!value)
                $("#areaId").html("");
        }
        getChild(value, name);

    }
</script>

</body>
</html>
