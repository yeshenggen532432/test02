<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>借出回款</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-xs-8">
                    回款单号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.billNo}" readonly>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    单据状态
                </label>
                <div class="col-xs-16">
                    <c:if test="${model.status eq -2 }">暂存</c:if>
                    <c:if test="${model.status eq 1 }">已审批</c:if>
                    <c:if test="${model.status eq 2 }"><span
                            style="color:blue;text-decoration:line-through;font-weight:bold;">作废单</span></c:if>
                    <c:if test="${model.status eq 3 }"><span style="color:#FF00FF;font-weight:bold;">被冲红单</span></c:if>
                    <c:if test="${model.status eq 4 }"><span style="color:red;font-weight:bold;">冲红单</span></c:if>
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
                    <c:if test="${model.billType eq 1}">
                        核销金额
                    </c:if>
                    <c:if test="${model.billType eq 0}">
                        已收款
                    </c:if>
                    <c:if test="${model.billType eq 2}">
                        已收款
                    </c:if>
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.sumAmt}" readonly>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    <c:if test="${model.billType eq 1}">
                        核销时间
                    </c:if>
                    <c:if test="${model.billType eq 0}">
                        收款时间
                    </c:if>
                    <c:if test="${model.billType eq 2}">
                        收款时间
                    </c:if>
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="datetimepicker" uglcw-options="format: 'yyyy-MM-dd HH:mm'" value="${model.billTime}">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                   收款账号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" readonly value="${model.accName}">
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
