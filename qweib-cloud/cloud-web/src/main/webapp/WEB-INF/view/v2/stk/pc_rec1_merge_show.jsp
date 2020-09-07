<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>收款记录</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-xs-8">
                    收款总单号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.billNo}" readonly>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    收款金额
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.sumAmt}" readonly>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-xs-8">
                    收款账号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.accNo}" readonly>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-xs-8">
                        收款时间
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="datetimepicker" uglcw-options="format: 'yyyy-MM-dd HH:mm'" value="${model.recTime}">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    备注
                </label>
                <div class="col-xs-16">
                    <textarea uglcw-role="textbox">${model.remarks}</textarea>
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
</script>
</body>
</html>