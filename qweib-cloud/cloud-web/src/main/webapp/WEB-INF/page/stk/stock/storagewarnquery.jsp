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

	<body onload="initGrid()">
		<table id="datagrid"  fit="true" singleSelect="true"
			 iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb"
			>
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
			<input type="hidden" name="waretype" value="${waretype}" id="waretype" />
			<input type="hidden" name="isType" value="${isType}" id="isType" />
		     商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		     预警状态: <select name="scope" id="scope">
	                    <option value="">全部</option>
	                    <option value="1" >正常</option>
	                    <option value="2" selected="selected">预警</option>
	                </select>	
	          勾选过滤库存数量为0：<input type="checkbox" id="flag" onchange="querydata()"/>      
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querystorage();">查询</a>
		</div>
		<script type="text/javascript">
		    var database="${database}";
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'wareId',
							title: 'wareId',
							width: 100,
							align:'center',
							hidden:true
					};
				   cols.push(col);
		    	    var col = {
							field: 'wareNm',
							title: '商品名称',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'wareGg',
							title: '规格',
							width: 80,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'unitName',
							title: '单位',
							width: 80,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'sumQty',
							title: '库存数量',
							width: 80,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'warnQty',
							title: '预警数量',
							width: 80,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: '_status',
							title: '状态',
							width: 80,
							align:'center',
							formatter:amtformatterStatus
					};
		    	    cols.push(col);
		    	    
		    	    var scope=$("#scope").val();
		    	    var flag = 0;
			    	if(document.getElementById("flag").checked)flag = 1;
					$('#datagrid').datagrid({
						url:"manager/queryStorageWareWarnPage",
						queryParams:{
							waretype:"${waretype}",
							isType:"${isType}",
							scope:scope,
							flag:flag
			    	    	},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
			   }
			function querystorage(wareType,isType){
				if(wareType!=undefined&&(wareType!=""||wareType==0)){
					$("#waretype").val(wareType)
				}
				if(isType!=undefined&&isType!=""||isType==0){
					$("#isType").val(isType)
				}
				var scope=$("#scope").val();
				var flag = 0;
			    if(document.getElementById("flag").checked)flag = 1;
				$("#datagrid").datagrid('load',{
					url:"manager/queryStorageWareWarnPage?database="+database,
					wareNm:$("#wareNm").val(),
					waretype:$("#waretype").val(),
					isType:$("#isType").val(),
					scope:scope,
					flag:flag
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querystorage();
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
			function amtformatterStatus(v,row)
			{
				 if(parseFloat(row.sumQty)>=parseFloat(row.warnQty)){
					return "正常";
				}else{
					return "预警";
				}  
			}
		</script>
	</body>
</html>
