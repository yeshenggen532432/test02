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
		<div >
			<input type="hidden" id="stkUnit" value="${stkUnit}"/>
			<input type="hidden" id="outType" value="${outType}"/>
			<input type="hidden" id="wtype" value="${wtype}"/>
			<input type="hidden" id="regionId" value="${regionId}"/>
			<input type="hidden" id="timeType" value="${timeType}"/>
			<div style="display: none">
			单据日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}"  readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			</div>
			费用科目: <input type="text" id="itemName" name="itemName"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</div>
		<table id="datagrid" class="easyui-datagrid" style="width:700px;"
    data-options="fitColumns:true,singleSelect:true,onDblClickRow: onDblClickRow">
		<thead>
				
		</thead>	
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
						field: 'pro_name',
						title: '往来单位',
						width: 100,
						align:'center'

					};
					cols.push(col);
					var col = {
						field: 'biz_type',
						title: '业务类型',
						width: 100,
						align:'center',
						formatter:amtformatterType
					};
					cols.push(col);
		    	    var col = {
							field: 'bill_no',
							title: '单据号',
							width: 140,
							align:'center'
											
					};
		    	    cols.push(col);
					var col = {
						field: 'item_name',
						title: '费用科目',
						width: 100,
						align:'center'

					};
					cols.push(col);

		    	    var col = {
							field: 'amt',
							title: '金额',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/cstSaleInputAmtList",
		    	    	queryParams:{
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							outType:$("#outType").val(),
							stkUnit:$("#stkUnit").val(),
							timeType:$("#timeType").val(),
							regionId:$("#regionId").val(),
							itemName:$("#itemName").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
			}

			function query(){
				$('#datagrid').datagrid({
					url:"manager/cstSaleInputAmtList",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						outType:$("#outType").val(),
						stkUnit:$("#stkUnit").val(),
						timeType:$("#timeType").val(),
						itemName:$("#itemName").val()
					}});
			}

			function onDblClickRow(rowIndex, rowData)
		    {
				var typeId = rowData.type_id;
				var typeName = rowData.type_name;
				var sdate = $('#sdate').val();
				var edate = $('#edate').val();
				if(typeId==undefined){
					return;
				}
				parent.closeWin(typeName+'-费用细项统计');
		    	parent.add(typeName+'-费用明细项统计','manager/toFinRptCostTotalItems?typeId='+typeId+'&sdate='+sdate+'&edate='+edate+'');
					
		    }
		    function amtformatterType(v,row){

				if(v=="FYBX"){
					return "费用报销";
				}else if(v=="SHHK"){
					return "收货货款核销";
				}
		    	return "";
			}

			function amtformatter(v,row)
			{
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}
			initGrid();
			
		</script>
	</body>
</html>
