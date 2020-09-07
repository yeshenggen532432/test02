<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
	<title>驰用T3</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.product-grid td {
			padding: 0;
		}
	</style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-card">
		<div class="layui-card-body full">
			<div class="form-horizontal">
				<div class="form-group" style="margin-bottom: 10px;">
					<input type="hidden" uglcw-model="accType" value="${amtType}" uglcw-role="textbox">
					<input type="hidden" uglcw-model="proId" value="${unitId}" uglcw-role="textbox">
					<input type="hidden" uglcw-model="sdate" value="${sdate}" uglcw-role="textbox">
					<input type="hidden" uglcw-model="edate" value="${edate}" uglcw-role="textbox">
				</div>
			</div>
			<div id="grid" uglcw-role="grid"
				 uglcw-options="{
                    loadFilter: {
                         data: function (response) {
                        response.rows.splice( response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      },
                     dblclick:function(row){
                       uglcw.ui.openTab('往来借出开单', '${base}manager/showFinInEdit?billId='+ row.id);
                     },

                    id:'id',
                    url: 'manager/queryFinInPage1',
                    criteria: '.form-horizontal',

                    }">

				<div data-field="proName" uglcw-options="width:160">往来单位</div>
				<div data-field="billTimeStr" uglcw-options="width:160">收款日期</div>
				<div data-field="accName" uglcw-options="width:120">收款账户</div>
				<div data-field="totalAmt" uglcw-options="width:140">总金额</div>
				<div data-field="remarks" uglcw-options="width:120">备注</div>
				<div data-field="billStatus" uglcw-options="width:100">状态</div>
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
