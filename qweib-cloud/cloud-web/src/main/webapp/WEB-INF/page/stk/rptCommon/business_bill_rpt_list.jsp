<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body>
		<div id="tb" >
		&nbsp;&nbsp;&nbsp;&nbsp;
		 <input name="billNo" id="billNo" placeholder="请输入单据号"   style="width: 150px;height: 20px"/>
	    <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 150px;display: none" value="${sdate}" readonly="readonly"/>
	     <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 150px;display: none" value="${edate}" readonly="readonly"/>
		<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>

		</div>
   		 <table id="datagrid"  fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onDblClickRow: onDblClickRow">
		</table>
		<script type="text/javascript">
		    function initGrid()
		    {
		    	    var cols = new Array();

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
							field: 'bill_name',
							title: '业务名称',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);

		    	    $('#datagrid').datagrid({
		    	    	url:"manager/businessBillRptList",
		    	    	queryParams:{
							billNo:$("#billNo").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
			}
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/businessBillRptList",
					billNo:$("#billNo").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
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
		    {var billName = "";
			var path = "";
			if(rowData.bill_name == "销售出库")
			{
				billName = "销售出库";
				//path = "showstkout";
				path ="showstkout";
			}
			if(rowData.bill_name == "其它出库")
			{
				billName = "其它出库";
				//path = "showstkout";
				path ="showstkout";
			}
			if(rowData.bill_name == "报损出库")
			{
				billName = "报损出库";
				//path = "showstkout";
				path ="showstkout";
			}
			if(rowData.bill_name == "领用出库")
			{
				billName = "领用出库";
				//path = "showstkout";
				path ="showstkout";
			}
			if(rowData.bill_name == "借出出库")
			{
				billName = "借出出库";
				path ="showstkout";
			}
			if(rowData.bill_name == "生产入库")
			{
				billName = "生产入库";
				path ="showstkin";
			}
			if(rowData.bill_name == "采购入库")
			{
				billName = "采购入库";
				path ="showstkin";
			}
			if(rowData.bill_name == "销售退货")
			{
				billName = "销售退货";
				path ="showstkin";
			}
			if(rowData.bill_name == "采购退货")
			{
				billName = "采购退货";
				path ="showstkin";
			}
			if(rowData.bill_name == "移库管理")
			{
				billName = "移库管理";
				path ="stkMove/show";
			}

			if(rowData.bill_name == "其它入库")
				{
					billName = "其它入库";
					//path = "showstkout";
					path ="showstkin";
				}
			if(rowData.bill_name == "收货款单")
			{
				billName = "收货款单";
				//path = "showstkout";
				path ="showstkoutNo";
			}
			if(rowData.bill_name == "收货货款")
			{
				billName = "收货货款";
				//path = "showstkout";
				path ="showStkpay";
			}
			if(rowData.bill_name == "付货货款")
			{
				billName = "付货货款";
				//path = "showstkout";
				path ="showstkoutNo";
			}
			if(rowData.bill_name == "付货款单")
			{
				billName = "付货款单";
				//path = "showstkout";
				path ="showstkoutNo";
			}

			if(rowData.bill_name == "采购支出")
				{
					billName = "采购发票";
					path = "showstkin";
				}
			if(rowData.bill_name == "销售退货支出")
			{
				billName = "销售退货发票";
				path = "showstkin";
			}
			if(rowData.bill_name == "往来借出")
				{
					billName = "往来借出单";
					path = "showFinOutEdit";
				}
			if(rowData.bill_name == "往来借入")
				{
					billName = "往来借入单";
					path = "showFinInEdit";
				}
			if(rowData.bill_name == "借款收回")
				{
				billName = "往来借出单";
				path = "showFinOutEdit";
				}
			if(rowData.bill_name == "还款支出")
			{
				billName = "往来借入单";
				path = "finaccio1";
			}
			if(rowData.bill_name == "支出")
			{
				billName = "付款单";
				path = "showFinPayEdit";
			}
			if(rowData.bill_name == "费用支付")
			{
				billName = "费用支付";
				path = "showFinPayEdit";
			}
			if(rowData.bill_name == "收入")
			{
				billName = "收款单";
				path = "showFinRecEdit";
			}
			if(rowData.bill_name == "其它收款")
			{
				billName = "其它收款";
				path = "showFinRecEdit";
			}
			if(rowData.bill_name == "转入"||rowData.bill_name == "转出")
			{
				billName = "内部转存";
				path = "showFinTransEdit";
			}
			if(rowData.bill_name == "内部转入"||rowData.bill_name == "内部转出")
			{
				billName = "内部转存";
				path = "showFinTransEdit";
			}
			if(rowData.bill_name == "资金初始化")
			{
				billName = "资金初始化";
				path = "finInitMoney/edit";
				var url = 'manager/' + path + '?id=' + rowData.bill_id;
				parent.closeWin(billName);
				parent.add(billName,url);
				return;
			}
			if(path != "")
				{
				parent.closeWin(billName);
				var url = 'manager/' + path + '?billId=' + rowData.bill_id;
				if(rowData.bill_name == "还款支出"){
					url = 'manager/' + path + '?remarks=还款支出&billId=' + rowData.bill_id;
				}
	    		parent.add(billName,url);
			  }

		    }
			initGrid();

		</script>
	</body>
</html>
