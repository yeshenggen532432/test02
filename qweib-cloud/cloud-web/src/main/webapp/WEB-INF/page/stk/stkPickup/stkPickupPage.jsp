<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>领料</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body >
		<table id="datagrid"  fit="true" singleSelect="false"
			 title=""  border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
			<div>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newBill('LLCK');">领料出库</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:showBill();">查看</a>
			</div>
			
		<div>
		   单据号: <input name="billNo" id="billNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		   日&nbsp;&nbsp;期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 80px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 80px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	       单据状态: <select name="status" id="status">
						<option value="">--请选择--</option>
						<option value="-2">暂存</option>
						<option value="1">已审批</option>
						<option value="2">已作废</option>
	                </select>
	       仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>	
	       显示商品信息:<input type="checkbox"  id="showWareCheck" name="showWareCheck" onclick="query()" value="1"/>	  
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</div>
		</div>
		<div>
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
							field: 'billNo',
							title: '单据单号',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billName',
							title: '单据类型',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	   
		    	    var col = {
							field: 'inDate',
							title: '单据日期',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'stkName',
							title: '仓库',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'proName',
							title: '车间',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'count',
							title: '商品信息',
							width: 400,
							align:'center',
							formatter:formatterWare
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'status',
							title: '单据状态',
							width: 80,
							align:'center',
							formatter:formatterStatus
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'operator',
							title: '创建人',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	  
		    	    var col = {
							field: 'remarks',
							title: '备注',
							width: 200,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkPickup/page",
		    	    	queryParams:{
							billNo:$("#billNo").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							stkId:$("#stkId").val(),
							stkInId:$("#stkInId").val(),
							status:$("#status").val(),
							bizType:$("#bizType").val()
		    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	],
		    	    		  	 rowStyler:function(index,row){    
			    	    		  	 if (row.status==2){      
			   	    		             return 'color:blue;';      
			   	    		         } 
	    	    		     }	  	
		    	    	}
		    	    );
		    	    if($('#showWareCheck').is(':checked')) {
						$('#datagrid').datagrid('showColumn','count');
					}else{
						$('#datagrid').datagrid('hideColumn','count');
					}
			}
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkPickup/page",
					billNo:$("#billNo").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					stkId:$("#stkId").val(),
					stkInId:$("#stkInId").val(),
					status:$("#status").val(),
					bizType:$("#bizType").val()
				});
				if($('#showWareCheck').is(':checked')) {
					$('#datagrid').datagrid('showColumn','count');
				}else{
					$('#datagrid').datagrid('hideColumn','count');
				}
			}
			
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}
			
			function formatterStatus(val,row){
				if(row.status==-2){
					return "暂存";
				}else if(row.status==1){
					return "已审批";
				}else if(row.status==2){
					return "已作废";
				}
				
			}

			function formatterWare(v,row){
				var hl= "";
				if($('#showWareCheck').is(':checked')) {
				if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
				 hl='<table>';
				if(row.subList.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>商品名称</b></td>';
			        hl +='<td width="60px;"><b>单位</font></b></td>';
			        hl +='<td width="80px;"><b>规格</font></b></td>';
			        hl +='<td width="60px;"><b>数量</font></b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.subList.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.subList[i].wareNm+'</td>';
			        hl +='<td>'+row.subList[i].unitName+'</td>';
			        hl +='<td>'+row.subList[i].wareGg+'</td>';
			        hl +='<td>'+row.subList[i].qty+'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
				}
				  return hl;
			}
			
			function newBill(bizType)
			{
				var billName="";
				if(bizType=="LLCK"){
					billName = "领料出库";
				}
				parent.closeWin(billName);
				parent.add(billName,'manager/stkPickup/add?bizType='+bizType);
			}
			
		    function onDblClickRow(rowIndex, rowData)
		    {
		    	var bizType=rowData.bizType;
		    	var billName="";
				if(bizType=="LLCK"){
					billName = "领料出库";
				}
		    	parent.closeWin(billName + rowData.id);
		    	parent.add(billName + rowData.id,'manager/stkPickup/show?billId=' + rowData.id);
		    }
		    
		    function showBill(){
		    	var row = $('#datagrid').datagrid('getSelected');
				if (row){
					var bizType=row.bizType;
			    	var billName="";
					if(bizType=="LLCK"){
						billName = "领料出库";
					}
					parent.closeWin(billName + row.id);
			    	parent.add(billName + row.id,'manager/stkPickup/show?billId=' + row.id);
				}else{
					alert("请选择行");
				}
		    }
		</script>
	</body>
</html>
