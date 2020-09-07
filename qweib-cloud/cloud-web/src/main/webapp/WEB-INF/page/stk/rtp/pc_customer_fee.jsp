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

	<body >
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onClickRow:onClickRow1">
			<thead>
				<tr>
				<th field="khId" width="10" align="center" hidden="true">
						khid
					</th>
				    
					<th field="khNm" width="120" align="left">
						客户名称
					</th>
					<th field="epCustomerName" width="120" align="left">
						所属二批
					</th>
					
					
					<th data-options="field:'fee',width:80,align:'center',editor:{type:'text'}" formatter="amtformatter"> 
						固定费用
					</th>
					
				</tr>
			</thead>
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		  客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
	    
	            
	    
	        客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		    所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		    
		           
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>
	                <a class="easyui-linkbutton" iconCls="icon-save" href="javascript:submitFee();">保存</a>注：只保存本页数据
		</div>
		
		<script type="text/javascript">
		   //查询
		   //initGrid();
		   
			function queryData(){
				$('#datagrid').datagrid({
					url:"manager/queryCustomerFeePage",
					queryParams:{							
						epCustomerName:$("#epCustomerName").val(),
						qdtpNm:$("#customerType").val(),
						khNm:$("#khNm").val()
						
					}
					
				});			
				
				
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
			
			
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryData();
				}
			}
			
			
			
			function onDblClickRow(rowIndex, rowData)
		    {
		    	
		    }
			
			function loadCustomerType(){
				$.ajax({
					url:"manager/queryarealist1",
					type:"post",
					success:function(data){
						if(data){
						   var list = data.list1;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						      if(list[i].qdtpNm!=''){
						           img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
						       }
						    }
						   $("#customerType").html(img);
						 }
					}
				});
			}
	 loadCustomerType();

	 var editIndex = undefined;
		function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#datagrid').datagrid('validateRow', editIndex)){
				$('#datagrid').datagrid('acceptChanges');
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
	 function onClickRow1(index){
		   var editor=	$('#datagrid').datagrid('selectRow', index)
			.datagrid('beginEdit', index); 
		  
			if (editIndex != index){
				if (endEditing()){
					 var editor=	$('#datagrid').datagrid('selectRow', index)
							.datagrid('beginEdit', index); 
				} else {
					$('#datagrid').datagrid('selectRow', editIndex);
					var editor=	$('#datagrid').datagrid('selectRow', index)
					.datagrid('beginEdit', index); 
				}
				editIndex = index;
			}else{
				endEditing();
				var editor=	$('#datagrid').datagrid('selectRow', index)
				.datagrid('beginEdit', index); 
			}
			 
			 
		}
	   
	   function accept(){
			if (endEditing()){
				$('#datagrid').datagrid('acceptChanges');
			}
		}
		function reject(){
			$('#datagrid').datagrid('rejectChanges');
			editIndex = undefined;
		}
		function getChanges(){
			var rows = $('#datagrid').datagrid('getChanges');
			
			alert(rows.length+' rows are changed!');
		}
		
		function submitFee()
		{
			var rows = $('#datagrid').datagrid('getRows');
			var path = "manager/SaveCustomerFee";
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"feeStr":JSON.stringify(rows)},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		//$("#billId").val(json.id);
		        		//window.parent.location.href='manager/showStkcheckInit?billId=' + json.id;
		        		alert('保存成功');
		        	}
		        }
		    });
		}
		</script>
	</body>
</html>
