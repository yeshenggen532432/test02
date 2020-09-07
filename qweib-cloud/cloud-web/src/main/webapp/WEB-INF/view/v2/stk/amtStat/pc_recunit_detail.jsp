<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>付货款管理</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-card">
		<div class="layui-card-body full">
			<div class="query" style="display: none;">
				<input type="hidden" uglcw-role="textbox" uglcw-model="ioType" value="${ioType}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="proId" value="${unitId}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="amtType" value="${amtType}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="sdate" value="${sdate}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="edate" value="${edate}"/>
			</div>
			<div id="grid" uglcw-role="grid"
				 uglcw-options="
                    dblclick: function(row){
                         uglcw.ui.openTab('采购开单信息'+row.billId, '${base}manager/showstkin?dataTp=1&billId='+row.billId);
                    },
                    url: '${base}manager/queryRecDetailPage',
                    criteria: '.query'
                    ">
				<div data-field="khNm">客户名称</div>
				<div data-field="recTimeStr">收款日期</div>
				<div data-field="memberNm">付款人</div>
				<c:if test="${stkRight.amtFlag == 1}">
					<div data-field="sumAmt">总收款/核销金额</div>
					<div data-field="cash">现金</div>
					<div data-field="bank">银行转账</div>
					<div data-field="wx">微信</div>
					<div data-field="zfb">支付宝</div>
				</c:if>
				<div data-field="remarks">备注</div>
				<div data-field="billTypeStr">类型</div>
				<div data-field="billStatus">状态</div>
			</div>
		</div>
	</div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		uglcw.ui.init();
		uglcw.ui.loaded()
	});
</script>
</body>
</html>
