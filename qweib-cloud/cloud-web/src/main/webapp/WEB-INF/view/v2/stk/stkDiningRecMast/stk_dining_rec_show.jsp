<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>餐饮收款记录</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-xs-8">
                    收款单号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.billNo}" readonly>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-xs-8">
                    订单号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="gridselector" value="${model.orderNo}">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    单据状态
                </label>
                <div class="col-xs-16">
                    <c:if test="${model.status eq -2}">未收款</c:if>
                    <c:if test="${model.status eq 1}">已收款</c:if>
                    <c:if test="${model.status eq 3}">已入账</c:if>
                    <c:if test="${model.status eq 2 }"><span
                            style="color:blue;text-decoration:line-through;font-weight:bold;">作废单</span></c:if>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    往来单位
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" readonly value="${model.proName}">
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
                    收款时间
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="datetimepicker" value="<fmt:formatDate value="${model.recTime}" pattern="yyyy-MM-dd HH:mm:ss"/>">
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
            <div class="form-group">
                <label class="control-label col-xs-6">
                </label>
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
