<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>月期间为处理完单据查询</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>

	<body>
		<div id="tb" >
		月结期间:
	    <input name="sdate" id="sdate"  onClick="WdatePicker();"  value="${sdate}" readonly="readonly"/>
			-
	     <input name="edate" id="edate"  onClick="WdatePicker();" value="${edate}" readonly="readonly"/>
		业务类型: <select name="bizType" id="bizType" onchange="query()">
			<option value=""></option>
			<option value="采购入库">采购入库</option>
			<option value="采购退货">采购退货</option>
			<option value="其它入库">其它入库</option>
			<option value="销售出库">销售出库</option>
			<option value="其它出库">其它出库</option>
			<option value="报损出库">报损出库</option>
			<option value="领用出库">领用出库</option>
			<option value="借出出库">借出出库</option>
			<option value="移库管理">移库管理</option>
			<option value="组装入库">组装入库</option>
			<option value="拆卸出库">拆卸出库</option>
			<option value="领料出库">领料出库</option>
			<option value="领料回库">领料回库</option>
			<option value="盘点单">盘点单</option>
		</select>
		<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:batchCancel();">批量作废</a>
		</div>
   		 <table id="datagrid"  fit="true" singleSelect="false"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onDblClickRow: onDblClickRow">
		</table>
		<script type="text/javascript">
		    function initGrid()
		    {
		    	    var cols = new Array();
					var col = {
						field: 'ck',
						checkbox: true
					};
					cols.push(col);
		    	    var col = {
							field: 'bill_id',
							title: 'bill_id',
							width: 100,
							align:'center',
							hidden:'true'				
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'bill_no',
							title: '单据号',
							width: 130,
							align:'center'
					};
		    	    cols.push(col);

					var col = {
						field: 'bill_time',
						title: '单据日期',
						width: 130,
						align:'center'
					};
					cols.push(col);

		    	    var col = {
							field: 'bill_name',
							title: '业务名称',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);

					var col = {
						field: 'status',
						title: '状态',
						width: 100,
						align:'center',
						formatter:formatterSt
					};
					cols.push(col);

				$('#datagrid').datagrid({
		    	    	url:"manager/jxcBillForMonthBalanceRpt",
		    	    	queryParams:{
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							billType:$("#bizType").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
			}
			function query(){
		    	var bizType=$("#bizType").val();
				$("#datagrid").datagrid('load',{
					url:"manager/jxcBillForMonthBalanceRpt",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					billType:bizType
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}
			function onDblClickRow(rowIndex, rowData)
		    {
		    	var billName = "";
			var path = "";
			if(rowData.bill_name == "销售出库")
			{
				billName = "销售出库";
				//path = "showstkout";
				path ="showstkout?billId="+rowData.bill_id;
			}
			if(rowData.bill_name == "其它出库")
			{
				billName = "其它出库";
				//path = "showstkout";
				path ="showstkout?billId="+rowData.bill_id;
			}
			if(rowData.bill_name == "报损出库")
			{
				billName = "报损出库";
				//path = "showstkout";
				path ="showstkout?billId="+rowData.bill_id;
			}
			if(rowData.bill_name == "领用出库")
			{
				billName = "领用出库";
				//path = "showstkout";
				path ="showstkout?billId="+rowData.bill_id;
			}
			if(rowData.bill_name == "借出出库")
			{
				billName = "借出出库";
				path ="showstkout?billId="+rowData.bill_id;
			}
			if(rowData.bill_name == "生产入库")
			{
				billName = "生产入库";
				path ="stkProduce/show?billId="+rowData.bill_id;
			}
			if(rowData.bill_name == "其他入库")
			{
				billName = "其他入库";
				path ="showstkin?billId="+rowData.bill_id;
			}
			if(rowData.bill_name == "采购入库")
			{
				billName = "采购入库";
				path ="showstkin?billId="+rowData.bill_id;
			}
			if(rowData.bill_name == "销售退货")
			{
				billName = "销售退货";
				path ="showstkin?billId="+rowData.bill_id;
			}
			if(rowData.bill_name == "采购退货")
			{
				billName = "采购退货";
				path ="showstkin?billId="+rowData.bill_id;
			}
			if(rowData.bill_name == "移库管理")
			{
				billName = "移库管理";
				path ="stkMove/show?billId="+rowData.bill_id;
			}

			if(rowData.bill_name == "组装入库")
			{
				billName = "组装入库";
				path ="stkZzcx/show?billId="+rowData.bill_id;
			}

			if(rowData.bill_name == "拆卸出库")
			{
				billName = "拆卸出库";
				path ="stkZzcx/show?billId="+rowData.bill_id;
			}

			if(rowData.bill_name == "领料回库")
			{
				billName = "领料回库";
				path ="showStkLlhkIn?billId="+rowData.bill_id;
			}

			if(rowData.bill_name == "领料出库")
			{
				billName = "领料出库";
				path ="stkPickup/show?billId="+rowData.bill_id;
			}

				if(rowData.bill_name == "销售返利")
				{
					billName = "销售返利";
					path ="stkRebateOut/show?billId="+rowData.bill_id;
				}

				if(rowData.bill_name == "采购返利")
				{
					billName = "采购返利";
					path ="stkRebateIn/show?billId="+rowData.bill_id;
				}
				if(rowData.bill_name == "盘点单")
				{
					billName = "盘点单";
					path ="stkCheck/showcheck?billId="+rowData.bill_id;
				}
			if(path != "")
				{
					parent.closeWin(billName);
					parent.add(billName,'<%=basePath %>/manager/'+path);
			  	}
		    }

			function formatterSt(val,rowData){

		    	var html ="";
				if(rowData.bill_name == "销售出库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未发货";
					}
				}
				if(rowData.bill_name == "其它出库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未发货";
					}
				}
				if(rowData.bill_name == "报损出库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未发货";
					}
				}
				if(rowData.bill_name == "领用出库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未发货";
					}
				}
				if(rowData.bill_name == "借出出库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未发货";
					}
				}
				if(rowData.bill_name == "生产入库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未入库";
					}
				}
				if(rowData.bill_name == "其他入库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未收货";
					}
				}
				if(rowData.bill_name == "采购入库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未收货";
					}
				}
				if(rowData.bill_name == "销售退货")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未收货";
					}
				}
				if(rowData.bill_name == "采购退货")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未收货";
					}
				}
				if(rowData.bill_name == "移库管理")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="暂存";
					}
				}

				if(rowData.bill_name == "组装入库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未收货";
					}
				}

				if(rowData.bill_name == "拆卸出库")
				{

					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未发货";
					}
				}

				if(rowData.bill_name == "领料回库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未收货";
					}
				}

				if(rowData.bill_name == "领料出库")
				{
					if(val==-2){
						html="暂存";
					}else if(val==0){
						html="未发货";
					}
				}

				if(rowData.bill_name == "销售返利")
				{
					if(val==-2){
						html="暂存";
					}
				}

				if(rowData.bill_name == "采购返利")
				{
					if(val==-2){
						html="暂存";
					}
				}

				return html;
			}
			
			function batchCancel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				var bizType="";
				for (var i = 0; i < rows.length; i++) {
					ids.push(rows[i].bill_id);
					if(bizType!=""&&bizType!=rows[i].bill_name){
						alert("请选择相同的业务类型作废！");
						return;
					}
					if(i==0){
						bizType = rows[i].bill_name;
					}
				}

				if(window.confirm("是否确定作废!")){
					var billName="";
					var path = "";
					if(bizType == "销售出库")
					{
						billName = "销售出库";
						path ="cancelStkOut";
					}
					if(bizType == "其它出库")
					{
						billName = "其它出库";
						path ="cancelStkOut";
					}
					if(bizType == "报损出库")
					{
						billName = "报损出库";
						path ="cancelStkOut";
					}
					if(bizType == "领用出库")
					{
						billName = "领用出库";
						path ="cancelStkOut";
					}
					if(bizType == "借出出库")
					{
						billName = "借出出库";
						path ="cancelStkOut";
					}
					if(bizType == "生产入库")
					{
						billName = "生产入库";
						path ="stkProduce/cancel";
					}
					if(bizType == "其它入库")
					{
						billName = "其它入库";
						path ="cancelProc";
					}
					if(bizType == "采购入库")
					{
						billName = "采购入库";
						path ="cancelProc";
					}
					if(bizType == "销售退货")
					{
						billName = "销售退货";
						path ="cancelProc";
					}
					if(bizType == "采购退货")
					{
						billName = "采购退货";
						path ="cancelProc";
					}
					if(bizType == "移库管理")
					{
						billName = "移库管理";
						path ="stkMove/cancel";
					}

					if(bizType == "组装入库")
					{
						billName = "组装入库";
						path ="stkZzcx/cancel";
					}

					if(bizType == "拆卸出库")
					{
						billName = "拆卸出库";
						path ="stkZzcx/cancel";
					}

					if(bizType == "领料回库")
					{
						billName = "领料回库";
						path ="cancelStkLlhkInByBillId";
					}
					if(bizType == "领料出库")
					{
						billName = "领料出库";
						path ="stkPickup/cancel?token=''";
					}

					if(bizType == "销售返利")
					{
						billName = "销售返利";
						path ="stkRebateOut/cancel";
					}

					if(bizType == "采购返利")
					{
						billName = "采购返利";
						path ="stkRebateIn/cancel";
					}
					if(bizType == "盘点单")
					{
						billName = "盘点单";
						path ="cancelCheck";
					}
					$.ajaxSettings.async = false;
					for (var i = 0; i < rows.length; i++) {
						var billId = ids[i];
						$.ajax({
							url: "<%=basePath%>/manager/"+path,
							type: "POST",
							data : {"billId":billId},
							dataType: 'json',
							async : false,
							success: function (json) {
								if(json.state){
								}
							}
						});
					}
					query();
				}

			}
			initGrid();
		</script>
	</body>
</html>
