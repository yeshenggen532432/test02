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
	</head>

	<body onload="initGrid()">
		<table id="datagrid" fit="true" singleSelect="false"
		 title=""  border="false"
			rownumbers="true" fitColumns="false"
			toolbar="#tb" >
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		<input type="hidden" value="${billNo }"  name="billNo" id="billNo"/>
		<div style="display: none">
		时间: <input  name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	<img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			 客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			 产品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			  <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>
			</div>  
			  <a class="easyui-linkbutton" iconCls="icon-download" href="javascript:toDownloadDataExcel();">下载EXCEL</a>
		</div>
		<div>
	  	</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    
			   function initGrid()
			   {
				   var cols = new Array(); 
		    	   
				   var col = {
						   field : 'ck',
			               checkbox : true
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
							field: 'sub_id',
							title: 'sub_id',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'be_pack_bar_code',
							title: '食品条形码',
							width: 120,
							align:'center'
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'ware_nm',
							title: '食品名称',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
				   
		    	    var col = {
							field: 'ware_dw',
							title: '单位',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'qty',
							title: '发票数量',
							width: 50,
							align:'center'
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'out_qty',
							title: '销货数量',
							width: 50,
							align:'center'
					};
		    	    cols.push(col);
    
	    	    var col = {
						field: 'price',
						title: '单价',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'product_date',
						title: '生产日期',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'kh_code',
						title: '货商注册号/社会信用代码',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'kh_nm',
						title: '购货商名称',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'out_time',
						title: '销货日期',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
				$('#datagrid').datagrid({
						url:"manager/queryOutWareListForGs",
						queryParams:{
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							wareNm:$("#wareNm").val(),
							khNm:$("#khNm").val(),
							billNo:$("#billNo").val()
							},
	    	    		columns:[
	    	    		  		cols
	    	    		  	],
							onLoadSuccess:function(){
		                        $('#datagrid').datagrid('selectAll');
		                    }	
							}
	    	    );
	    	    $('#datagrid').datagrid('reload'); 
			   }
			function querydata(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryOutWareListForGs",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					wareNm:$("#wareNm").val(),
					khNm:$("#khNm").val(),
					billNo:$("#billNo").val()
				});
			}
			  function toDownloadDataExcel() {
				    var ids = "";
					var rows = $("#datagrid").datagrid("getSelections");
					for(var i=0;i<rows.length;i++){
						if(ids.length>0){
							ids = ids + ",";
						}
						ids = ids+rows[i].sub_id;
					}
					if(ids==""){
						$.messager.alert('消息','请选中要导出的行！','info');
						return;
					}
				  
				  var  sdate=$("#sdate").val();
				  var  edate=$("#edate").val();
				  var  wareNm=$("#wareNm").val();
				  var  khNm=$("#khNm").val();
                  if(confirm("是否下载数据?")){
					window.location.href="manager/downloadOutWareListForGsToExcel?sdate="+sdate+"&edate="+edate+"&wareNm="+wareNm+"&khNm="+khNm+"&subIds="+ids+"";
				}
	
           }
		</script>
	</body>
</html>
