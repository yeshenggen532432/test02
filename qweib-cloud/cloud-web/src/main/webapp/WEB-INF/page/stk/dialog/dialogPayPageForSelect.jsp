<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
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
		<table id="datagrid"  fit="true" singleSelect="false"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: setPreAmt">
		<thead>
		</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     发票单号: <input name="billNo" id="billNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			 <input name="proName" id="proName" value="${proName}" type="hidden" onkeydown="toQuery(event);"/>
			发票日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;"  />
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" />
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	  		<select style="display: none" name="inType" id="inType">
	                    <option value="">全部</option>
	                    <option value="采购入库">采购入库</option>
	                    <option value="其它入库">其它入库</option>
	                    <option value="采购退货">采购退货</option>
	                    <option value="销售退货">销售退货</option>
	                </select>	  		        
	        <select name="orderZt" style="display: none" id="payStatus">
	                    <option value="未付款">未付款</option>
	                </select>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>
			<br/>
		</div>
		<script type="text/javascript">
		    initGrid();
		    function initGrid()
		    {
		    	    var cols = new Array();
		    	    var col = {
							   field : 'ck',
				               checkbox : true
						};
			    	    cols.push(col);
		    	    var col = {
							field: 'id',
							title: 'id',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'proId',
							title: 'proId',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '发票单号',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'inDate',
							title: '发票日期',
							width: 120,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'inType',
							title: '入库类型',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	   

		    	    var col = {
							field: 'proName',
							title: '付款对象',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);

					var col = {
							field: 'disAmt',
							title: '发票金额',
							width: 60,
							align:'center',
							formatter:amtformatter

					};
					cols.push(col);

					var col = {
							field: 'payAmt',
							title: '已付款',
							width: 60,
							align:'center',
							formatter:amtformatter

					};
					cols.push(col);
					var col = {
							field: 'freeAmt',
							title: '核销金额',
							width: 60,
							align:'center',
							formatter:amtformatter

					};
					cols.push(col);

					var col = {
							field: 'needPay',
							title: '未付金额',
							width: 60,
							align:'center',
							formatter:amtformatter

					};
					cols.push(col);

		    	    var col = {
							field: 'billStatus',
							title: '收货状态',
							width: 60,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'payStatus',
							title: '付款状态',
							width: 60,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var sts = $("#payStatus").val();
					var inType = $("#inType").val();
			    	var isPay = -1;
			    	if(sts == "已付款")isPay = 1;
			    	if(sts == "未付款")isPay = 0;
			    	if(sts == "作废")isPay = 2;
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/selectPayPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#billNo").val(),
							proName:$("#proName").val(),					
							isPay:isPay,
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							inType:inType+""
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    $('#datagrid').datagrid('reload'); 
			}

			function querydata(){
				var sts = $("#payStatus").val();
				var inType = $("#inType").val();
		    	var isPay = -1;
		    	if(sts == "已付款")isPay = 1;
		    	if(sts == "未付款")isPay = 0;
		    	if(sts == "作废")isPay = 2;
				$("#datagrid").datagrid('load',{
					url:"manager/selectPayPage",
					jz:"1",
					billNo:$("#billNo").val(),
					proName:$("#proName").val(),					
					isPay:isPay,
					inType:inType,
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			}

			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querydata();
				}
			}

			function amtformatter(v,row)
			{
				if(v==""){
					return "";
				}
				if(v=="0E-7"){
					return "0.00";
				}
				if (row != null) {
                    return numeral(v).format("0,0.00");
                } 
			}
		</script>
	</body>
</html>
