<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>同城配送设置</title>

    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">

                    <div class="form-horizontal" uglcw-role="validator" novalidate id="bind1">
                        <span style="text-align: right;font-size: 15px;color: blue">同城限制：</span>
                        <div class="form-group">
                            <form id="store_locationForm" >
                                <input uglcw-role="textbox" type="hidden" uglcw-model="name" value="store_location"/>
                            <label class="control-label col-xs-4">限制：</label>
                            <div>
                            <span id="provinceId"></span><span id="cityId"></span><span id="areaId"></span>
                            &nbsp;&nbsp;
                                <button type="button" uglcw-role="button" class="k-success" onclick="save('store_locationForm');">修改</button>
                            </div>
                            <label class="">限制地区,例只选择省时用户同省收货地址时所有商品运费使用同城标准</label>
                            </form>
                        </div>
                    </div>

                    <div class="form-horizontal" uglcw-role="validator" novalidate id="bind">
                        <form id="location_transportForm" >
                        <input uglcw-role="textbox" type="hidden" uglcw-model="name" value="location_transport"/>
                        <span style="text-align: right;font-size: 15px;color: blue">同城配送设置</span>
                        <div class="form-group">
                            <label class="control-label col-xs-4">限制：</label>
                            <div>
                                <input type="radio" name="limit_type" value="1" <c:if test="${model==null ||  model.limit_type==null || model.limit_type=='1'}">checked</c:if> >同时满足可下单&nbsp;&nbsp;
                                <input type="radio" name="limit_type" value="2" <c:if test="${model!=null && model.limit_type=='2'}">checked</c:if>>满足数量可下单&nbsp;&nbsp;
                                <input type="radio" name="limit_type" value="3" <c:if test="${model!=null && model.limit_type=='3'}">checked</c:if>>满足金额可下单&nbsp;&nbsp;
                                <input type="radio" name="limit_type" value="4" <c:if test="${model!=null && model.limit_type=='4'}">checked</c:if> title="如果数量或金额有一项为空时则等于不限制">满足任意一项可下单&nbsp;&nbsp;
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">数量(大于等于)</label>
                            <div class="col-xs-4">
                                <input id="limit_number"  uglcw-role="numeric"
                                       maxlength="10" uglcw-options="min: 1"
                                       uglcw-model="limit_number"
                                       value="${model.limit_number}">
                            </div>
                            <label class="col-xs-4">件(0不限制)</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">金额(大于等于)</label>
                            <div class="col-xs-4">
                                <input id="limit_money"  uglcw-role="numeric"
                                       maxlength="10" uglcw-options="min: 1"
                                       uglcw-model="limit_money"
                                       value="${model.limit_money}">
                            </div>
                            <label class="col-xs-4">元(0不限制)</label>
                        </div>


                        <div class="form-group">
                            <label class="control-label col-xs-4">未达到：</label>
                            <div class="col-xs-4">
                                <input type="radio" name="failType" value="0" <c:if test="${model.failType==null || model.failType==0}">checked</c:if>>不可下单&nbsp;&nbsp;&nbsp;<span style="color:gray;">(备注:运费按照商品金额-优惠-促销)</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4"></label>
                            <div class="col-xs-4">
                                <input type="radio" name="failType" value="1" <c:if test="${model.failType==1}">checked</c:if>>可下单、另加运费
                                <input id="failFreight"  uglcw-role="numeric"
                                       maxlength="10" uglcw-options="min: 1"
                                       uglcw-model="failFreight"
                                       value="${model.failFreight}" style="width:150px">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-4">已达到：</label>
                            <div class="col-xs-4">
                                <input type="radio" name="successType" value="0" <c:if test="${model.successType==null || model.successType==0}">checked</c:if>>免运费、送货上门
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4"></label>
                            <div class="col-xs-4">
                                <input type="radio" name="successType" value="1" <c:if test="${ model.successType==1}">checked</c:if>>送货上门、加运费
                                <input id="successFreight"  uglcw-role="numeric"
                                       maxlength="10" uglcw-options="min: 1"
                                       uglcw-model="successFreight"
                                       value="${model.successFreight}" style="width:150px">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="control-label col-xs-8">
                                <button type="button" uglcw-role="button" class="k-success" onclick="save('location_transportForm');">保存</button>
                            </div>
                        </div>
                        </form>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
        $("[name=failType]").change(function () {
            changeType();
        });
        $("[name=successType]").change(function () {
            changeType();
        });
        changeType();
        loadProvince();
    })

    function changeType() {
        if($("[name=failType]:checked").val()==1)
            $("#failFreight").prop("disabled",false);
        else
            $("#failFreight").prop("disabled",true);

        if($("[name=successType]:checked").val()==1)
            $("#successFreight").prop("disabled",false);
        else
            $("#successFreight").prop("disabled",true);
    }

    function save(id) {
        $.ajax({
            url: '${base}/manager/shopSetting/edit',
            data:$("#"+id).serialize(),  //绑定值
            type: 'post',
            success: function (data) {
                if (data.success) {
                    uglcw.ui.success('修改成功');
                    /*setTimeout(function () {
                        uglcw.ui.reload();
                    }, 1000)*/
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })
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
