<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>内部转存</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-card">
    <div class="layui-card-body">

        <div class="form-horizontal" uglcw-role="validator" id="transfer_order">
            <div class="form-group">
                <label class="col-xs-8 control-label">转存单号</label>
                <div class="col-xs-14" style="margin-top: 7px; font-weight: bold">
                    <span>${billNo}</span> <span style="color:red;">${billStatus}</span></div>
            </div>
            <div class="form-group">
                <input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="0">
                <input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status" value="0">
                <label class="control-label col-xs-8">转出账户</label>
                <div class="col-xs-14">
                    ${accName1}
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">转入账户</label>
                <div class="col-xs-14">
                   ${accName2}
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">转移金额</label>
                <div class="col-xs-14">
                   ${transAmt}
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">收款时间</label>
                <div class="col-xs-14">
                    ${transTimeStr}
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">备注</label>
                <div class="col-xs-14">
                    ${remarks}
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