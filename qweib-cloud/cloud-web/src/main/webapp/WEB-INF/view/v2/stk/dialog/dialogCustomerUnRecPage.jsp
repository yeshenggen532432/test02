<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>驰用T3</title>

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
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" >
		</table>
		<div id="tb" style="padding:5px;height:auto">
			 <input name="cstId" id="cstId" style="width:120px;height: 20px;display: none" value="${cstId}" onkeydown="toQuery(event);"/>
			日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;"  />
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" />
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
         	单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
             <input name="memberNm" id="memberNm" style="width:120px;height: 20px;display: none" onkeydown="toQuery(event);"/>	  
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
		</div>
     </div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    initGrid();
		   //queryorder();
		    function initGrid()
		    {
		    	    var cols = new Array(); 
		    	    var col = {
							field: 'id',
							title: 'id',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '单号',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'khNm',
							title: '往来单位',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
					
		    	    var col = {
							field: 'outDate',
							title: '发票日期',
							width: 120,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'needRec',
							title: '未收金额',
							width: 60,
							align:'center',
							formatter:amtformatter
											
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
								field: 'disAmt1',
								title: '发货金额',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);

			    	    var col = {
								field: 'recAmt',
								title: '已收金额',
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
								field: 'recStatus',
								title: '收款状态',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);
			    	
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/queryUnRecPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							cstId:$("#cstId").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    
		    	    );
			}
		  
			function queryorder(){
		    	
				$("#datagrid").datagrid('load',{
					url:"manager/queryUnRecPage",
					billNo:$("#orderNo").val(),
					cstId:$("#cstId").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
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
