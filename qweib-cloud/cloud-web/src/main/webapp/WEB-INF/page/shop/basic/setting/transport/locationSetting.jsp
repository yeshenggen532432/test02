<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>同城配送设置</title>
    <%@include file="/WEB-INF/page/include/source.jsp"%>
</head>
<body>
<div class="box">
    <form action="manager/shopSetting/edit" id="storeLocationFrm" method="post">
        <input  type="hidden" name="name" id="name" value="store_location"/>
        <dl id="dl">
            <dt class="f14 b">同城限制：<span id="store_location"><span id="provinceId"></span><span id="cityId"></span><span id="areaId"></span></span>
                &nbsp;&nbsp;<a href="javascript:toSubmit('storeLocationFrm');">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:gray;">限制地区,例只选择省时用户同省收货地址时所有商品运费使用同城标准</span></dt>
        </dl>
    </form>
    <form action="manager/shopSetting/edit" id="locationTransportFrm" method="post">
        <input  type="hidden" name="name" id="name" value="location_transport"/>
        <dd>
            <span class="title">限制</span>
            <input type="radio" name="limit_type" value="1" <c:if test="${model==null ||  model.limit_type==null || model.limit_type=='1'}">checked</c:if> >同时满足&nbsp;&nbsp;
            <input type="radio" name="limit_type" value="2" <c:if test="${model!=null && model.limit_type=='2'}">checked</c:if>>满足数量&nbsp;&nbsp;
            <input type="radio" name="limit_type" value="3" <c:if test="${model!=null && model.limit_type=='3'}">checked</c:if>>满足金额&nbsp;&nbsp;
            <input type="radio" name="limit_type" value="4" <c:if test="${model!=null && model.limit_type=='4'}">checked</c:if> title="如果数量或金额有一项为空时则等于不限制">满足任意一项&nbsp;&nbsp;
        </dd>
        <dl id="dl">
            <dd>
                <span class="title">起送量(大于等于)：</span>
                <input type="number" class="reg_input" name="limit_number" id="limit_number" value="${model.limit_number}" maxlength="5"/>件 <span style="color:gray;">(空或0不限制)</span>
                <span id="minNumTip" class="onshow"></span>
            </dd>
            <dd>
                <span class="title">起送金额(大于等于)：</span>
                <input type="number" class="reg_input" name="limit_money" id="limit_money" value="${model.limit_money}" maxlength="5"/>元 <span style="color:gray;">(空或0不限制)</span>
                <span id="minMoneyTip" class="onshow"></span>
            </dd>

            <dd>
                <span class="title">未达到：</span>
                <input type="radio" name="failType" value="0" <c:if test="${model.failType==null || model.failType==0}">checked</c:if>>不可下单&nbsp;&nbsp;&nbsp;<span style="color:gray;">(备注:运费按照商品金额-优惠-促销)</span>
            </dd>
            <dd>
                <span class="title"></span>
                <input type="radio" name="failType" value="1" <c:if test="${model.failType==1}">checked</c:if>>可下单、另加运费
                <input type="number" class="reg_input" name="failFreight" id="failFreight" value="${model.failFreight}" maxlength="5"/>
                <span id="failFreightTip" class="onshow"></span>
            </dd>

            <dd>
                <span class="title">已达到：</span>
                <input type="radio" name="successType" value="0" <c:if test="${model.successType==null || model.successType==0}">checked</c:if>>免运费、送货上门
            </dd>
            <dd>
                <span class="title"></span>
                <input type="radio" name="successType" value="1" <c:if test="${ model.successType==1}">checked</c:if>>送货上门、加运费
                <input type="number" class="reg_input" name="successFreight" id="successFreight" value="${model.successFreight}" maxlength="5"/>
                <span id="freightTip" class="onshow"></span>
            </dd>
        </dl>
        <div class="f_reg_but" style="clear:both">
            <input type="button" value="保存" class="l_button" onclick="toSubmit('locationTransportFrm');"/>
            <input type="reset" value="重置" class="b_button"/>
        </div>
    </form>
</div>

<!-- ===================================以下是：js===================================================-->
<script type="text/javascript">
    //表单验证
    $(function(){
        /*$.formValidator.initConfig();
        $("#num").formValidator({ onShow: "请输入数字", onCorrect: "通过" }).regexValidator({ regExp: "num", dataType: "enum", onError: "数字格式不正确" });
        $("#money").formValidator({ onShow: "请输入数字", onCorrect: "通过" }).regexValidator({ regExp: "num", dataType: "enum", onError: "数字格式不正确" });
        $("#freight").formValidator({ onShow: "请输入数字", onCorrect: "通过" }).regexValidator({ regExp: "num", dataType: "enum", onError: "数字格式不正确" });*/
        $("[name=failType]").change(function () {
            changeType();
        });
        $("[name=successType]").change(function () {
            changeType();
        });
        changeType();
        loadProvince();
    });

    //提交数据
    function toSubmit(name){
        if("storeLocationFrm"==name){
            var province=$("[name=province]").val();
            var city=$("[name=city]").val();
            var area=$("[name=area]").val();
            //if(!city){   $.messager.alert('消息','请选择完整');return false;}
            //if(!area){$.messager.alert('消息','请选择完整');return false;}
        }
        //if ($.formValidator.pageIsValid()==true){
            $("#"+name).form('submit',{
                dataType: 'json',
                success:function(data){
                    if(data)
                        $.messager.alert('消息',JSON.parse(data).msg,'info');
                    else
                        $.messager.alert('Error',"操作失败");
                }
            });
        //}
    }

    function changeType() {
        if($("[name=failType]:checked").val()==1)
            $("#failFreight").attr("disabled",false);
        else
            $("#failFreight").attr("disabled",true);

        if($("[name=successType]:checked").val()==1)
            $("#successFreight").attr("disabled",false);
        else
            $("#successFreight").attr("disabled",true);
    }


    //获取店铺地址
    function loadProvince() {
        var provinceId='${storeLocationMap.provinceId}';
        var cityId='${storeLocationMap.cityId}';
        var areaId='${storeLocationMap.areaId}';
        $("#provinceId").html(getChild("0","provinceId",provinceId));
        $("#cityId").html(getChild(provinceId,"cityId",cityId));
        $("#areaId").html(getChild(cityId,"areaId",areaId));
    }


    function getChild(parentId,name,selectId) {
        if(parentId!=null && parentId !=''){
            $.get("${base}/manager/shopArea/getChild?parentId="+parentId,function (data) {
                $("#"+name).html(getSelect(data,name,selectId));
            });
        }
    }

    //根据城市接口返回数据后转成select
    function getSelect(data,name,selectId) {
        var html="<select name='"+name+"' onchange='changeSelect(this)'>";
        html += '<option value="">请选择</option>';
        if(data && data.state && data.obj) {
            var array=data.obj;
            for (var i = 0; i < array.length; i++) {
                var obj=array[i];
                var selectStr="";
                if(selectId && obj.areaId==selectId)
                    selectStr="selected";
                html += '<option value="' + obj.areaId + '" data-parentId="' + obj.areaParentId + '" '+selectStr+'>' + obj.areaName + '</option>';
            }
        }
        html+="</select>";
        return html;
    }

    //改变事件
    function changeSelect(th) {
        var value=$(th).val();
        //if(!value)$(th).parent().next().html("");//$(th).parent().next().remove()
        var name=$(th).attr("name");
        if(name=='areaId')return;
        if(name=='provinceId'){
            name="cityId";
            if(!value) {
                $("#cityId").html("");
            }
            $("#areaId").html("");
        }else if(name=='cityId') {
            name = "areaId";
            if(!value)
                $("#areaId").html("");
        }
        getChild(value,name);

    }
</script>
</body>
</html>
