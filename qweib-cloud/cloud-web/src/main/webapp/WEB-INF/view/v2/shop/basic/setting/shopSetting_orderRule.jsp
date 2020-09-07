<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>收货与支付时长设置</title>

    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <div class="form-horizontal" uglcw-role="validator" novalidate id="bind">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="name" id="name" value="${name}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-4">支付成功后-自动收货时长设置：</label>
                            <div class="col-xs-4">
                                <input id="automatic_delivery" uglcw-role="numeric" title="最少1天"
                                        maxlength="3" uglcw-options="min: 1, max: 500"
                                       uglcw-model="automatic_delivery"
                                       value="${model.automatic_delivery}">
                            </div>
                            <label class="col-xs-4">天(默认 7 天)</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">未支付（普通订单） - 自动取消设置：</label>
                            <div class="col-xs-4">
                                <input id="overdue_order_cancel" uglcw-role="numeric" title="最少1天"
                                        maxlength="3" uglcw-options="min: 1, max: 50"
                                       uglcw-model="overdue_order_cancel"
                                       value="${model.overdue_order_cancel}">
                            </div>
                            <label class="col-xs-4">天(默认 3 天内,未支付订单自动取消)</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">未支付（餐饮订单） - 自动取消设置：</label>
                            <div class="col-xs-4">
                                <input id="dining_overdue_order_cancel" uglcw-role="numeric" title="最少5分钟"
                                        maxlength="3" uglcw-options="min: 5, max: 500"
                                       uglcw-model="dining_overdue_order_cancel"
                                       value="${model.dining_overdue_order_cancel}">
                            </div>
                            <label class="col-xs-4">天(默认 12小时内,未支付订单自动取消)</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">未支付（秒杀订单） - 自动取消设置：</label>
                            <div class="col-xs-4">
                                <input id="flash_overdue_order_cancel" uglcw-role="numeric" title="最少5分钟"
                                        maxlength="3" uglcw-options="min: 5, max: 500"
                                       uglcw-model="flash_overdue_order_cancel"
                                       value="${model.flash_overdue_order_cancel}">
                            </div>
                            <label class="col-xs-4">分钟(默认 30 分钟内,未支付订单自动取消)</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">未支付（拼团订单） - 自动取消设置：</label>
                            <div class="col-xs-4">
                                <input id="tour_overdue_order_cancel" uglcw-role="numeric" title="最少5分钟"
                                        maxlength="3" uglcw-options="min: 5, max: 500"
                                       uglcw-model="tour_overdue_order_cancel"
                                       value="${model.tour_overdue_order_cancel}">
                            </div>
                            <label class="col-xs-4">分钟(默认 30 分钟内,未支付订单自动取消)</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">未支付（组团订单） - 自动取消设置：</label>
                            <div class="col-xs-4">
                                <input id="head_tour_overdue_order_cancel" uglcw-role="numeric" title="最少5分钟"
                                        maxlength="3" uglcw-options="min:5, max: 500"
                                       uglcw-model="head_tour_overdue_order_cancel"
                                       value="${model.head_tour_overdue_order_cancel}">
                            </div>
                            <label class="col-xs-4">分钟(默认 30 分钟内,未支付订单自动取消)</label>
                        </div>
                        <div class="form-group">
                            <div class="control-label col-xs-8">
                                <button uglcw-role="button" class="k-success" onclick="save();">保存</button>
                            </div>
                        </div>

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
    })

    function save() {
        if (isNaN($("#automatic_delivery").val())) {
            uglcw.ui.error('请输入正整数');
            return;
        }
        $.ajax({
            url: '${base}/manager/shopSetting/edit',
            data: uglcw.ui.bind($("#bind")),  //绑定值
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
        })
    }

</script>
</body>
</html>
