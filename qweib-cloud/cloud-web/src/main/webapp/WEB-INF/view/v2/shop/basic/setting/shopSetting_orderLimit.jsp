<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>批发购物下单限制设置</title>

    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="form-group">
            <div class="control-label col-xs-8">
                <button uglcw-role="button" class="k-success" onclick="save();">保存</button>
            </div>
        </div>
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <div class="form-horizontal" uglcw-role="validator" novalidate id="bind">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="name" id="name" value="order_limit"/>
                        <span style="text-align: right;font-size: 15px;color: blue">(默认)批发购物下单限制设置</span>
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
                    </div>

                <c:set var="datas" value="${fns:loadListByParam('shop_member_grade','','status=1 and is_jxc=1')}"/>
                <c:forEach items="${datas}" var="data">
                    <c:set value="_gradeId${data.id}" var="key"/>
                    <c:set value="${modelGrade[key]}" var="gmodel"/>

                    <div class="form-horizontal" gradeId="${key}" uglcw-role="validator" novalidate id="bind">
                        <span style="text-align: right;font-size: 15px;color: blue">${data.grade_name}-限制设置&nbsp;&nbsp;&nbsp;&nbsp;是否启用：<input type="checkbox" value="1" name="is_open" <c:if test="${gmodel.is_open}">checked</c:if>></span>
                        <div class="form-group">
                            <label class="control-label col-xs-4">限制：</label>
                            <div>
                                <input type="radio" name="limit_type${key}" value="1" <c:if test="${gmodel==null ||  gmodel.limit_type==null || gmodel.limit_type=='1'}">checked</c:if> >同时满足可下单&nbsp;&nbsp;
                                <input type="radio" name="limit_type${key}" value="2" <c:if test="${gmodel!=null && gmodel.limit_type=='2'}">checked</c:if>>满足数量可下单&nbsp;&nbsp;
                                <input type="radio" name="limit_type${key}" value="3" <c:if test="${gmodel!=null && gmodel.limit_type=='3'}">checked</c:if>>满足金额可下单&nbsp;&nbsp;
                                <input type="radio" name="limit_type${key}" value="4" <c:if test="${gmodel!=null && gmodel.limit_type=='4'}">checked</c:if> title="如果数量或金额有一项为空时则等于不限制">满足任意一项可下单&nbsp;&nbsp;
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">数量(大于等于)</label>
                            <div class="col-xs-4">
                                <input uglcw-role="numeric"
                                       maxlength="10" uglcw-options="min: 1"
                                       uglcw-model="limit_number"
                                       value="${gmodel.limit_number}">
                            </div>
                            <label class="col-xs-4">件(0不限制)</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">金额(大于等于)</label>
                            <div class="col-xs-4">
                                <input uglcw-role="numeric"
                                       maxlength="10" uglcw-options="min: 1"
                                       uglcw-model="limit_money"
                                       value="${gmodel.limit_money}">
                            </div>
                            <label class="col-xs-4">元(0不限制)</label>
                        </div>
                    </div>
                </c:forEach>
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
    })

    function save() {
        if(isNaN($("#limit_number").val())||isNaN($("#limit_money").val())){
            uglcw.ui.error('请输入正整数');return;
        }
        var datas=[];
        $(".form-horizontal").each(function (i,item) {
            var gradeId=$(this).attr("gradeId")
            if(!gradeId)gradeId="";
            var data={};
            data.name="order_limit"+gradeId;
            data.is_open=$('[name=is_open]',this).is(":checked");
            data.limit_type=$("[name=limit_type"+gradeId+"]:checked",this).val();
            data.limit_number=$('[name=limit_number]',this).val();
            data.limit_money=$('[name=limit_money]',this).val();
            datas.push(data);
        })
        console.log(datas);
        var msg="";
        var state=false;
        $(datas).each(function (i,item) {
            $.ajax({
                type:"post",
                url:"${base}/manager/shopSetting/edit",
                data:item,
                async:false,
                success:function (data) {
                    if(data) {
                        msg = data.msg;
                        state=data.success;
                    }
                }
            });
        })
        if (state) {
            uglcw.ui.success('修改成功');
            setTimeout(function () {
                uglcw.ui.reload();
            }, 1000)
        } else {
            uglcw.ui.error('操作失败');
        }
       /* $.ajax({
            url: '${base}/manager/shopSetting/edit',
            data: {"name":"${name}","limit_type":$("[name=limit_type]:checked").val(),"limit_number":$("#limit_number").val(),"limit_money":$("#limit_money").val()},  //绑定值
            type: 'post',
            success: function (data) {
                if (data.success) {
                    uglcw.ui.success('修改成功');
                    setTimeout(function () {
                        uglcw.ui.reload();
                    }, 1000)
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })*/
    }

</script>
</body>
</html>
