<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/queryStkWares?wtype=${wtype}&status=1" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onClickCell: onClickRow1">
			<thead>
				<tr>
				<th field="id" width="10" align="center" hidden="true">
						商品id
					</th>
				    <th field="wareId" width="10" align="center" hidden="true">
						商品id
					</th>
					<th data-options="field:'chooseStr',width:30,align:'center',editor:{type:'checkbox',options:{on:'√',off:'X'}}" formatter="formatter1">
						选择
					</th>
					<th field="wareCode" width="80" align="center">
						商品编码
					</th>
					<th field="wareNm" width="100" align="center">
						商品名称
					</th>				
					
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="queryWare();"/>
			<input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>	
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:addChoose();">全选</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true"  href="javascript:decChoose();">取消选择</a>		
			
			
		</div>
		<script type="text/javascript">
		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryStkWares",
					   wareNm:$("#wareNm").val(),
					   status:1
				});
			}		
			
		    function formatter1(value,row,index)
		    {
		    	return  '<u style="color:blue;cursor:pointer">'+value+'</u>';
		    }
			
		  
		   
		   var editIndex = undefined;
			function endEditing(){
				if (editIndex == undefined){return true}
				if ($('#datagrid').datagrid('validateRow', editIndex)){
					//var ed = $('#datagrid').datagrid('getEditor', {index:editIndex,field:'menuId'});
					//var productname = $(ed.target).combobox('getText');
					//$('#datagrid').datagrid('getRows')[editIndex]['productname'] = productname;
					$('#datagrid').datagrid('endEdit', editIndex);
					editIndex = undefined;
					return true;
				} else {
					return false;
				}
			}
		   
		   function onClickRow1(index, field, value){
			  // alert(field);
			   if(field != 'chooseStr')return;
				//if (editIndex != index){
					
					if (endEditing()){
						$('#datagrid').datagrid('selectRow', index)
								.datagrid('beginEdit', index);
						editIndex = index;
						var ss = "√";
						if($('#datagrid').datagrid('getRows')[index]['chooseStr'] == "√")ss = "X";
						
						$('#datagrid').datagrid('getRows')[index]['chooseStr'] = ss;
						$('#datagrid').datagrid('updateRow',{index:index,row:{chooseStr:ss}});
						var choose = 1;
						if(ss == "X")choose = 0;
						updateOneWare($('#datagrid').datagrid('getRows')[index]['wareId'],choose);
						
					} else {
						$('#datagrid').datagrid('selectRow', editIndex);
						
					}
				//}
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
			
			function submitWare()
			{
				accept();
				var arr =  $('#datagrid').datagrid('getData');
				
				
				var wareList = new Array();
				for (var i=0;i<arr.rows.length;i++) {				
					
					var chooseFlag = 0;
					if(arr.rows[i].chooseStr == "√")chooseFlag = 1;
					 var subObj = {
								wareId: arr.rows[i].wareId,
								chooseFlag: chooseFlag
												
						};
					wareList.push(subObj);
				}
				
				$.ajax( {
					url : "manager/updateChooseWare",
					data : {"wareStr":JSON.stringify(wareList)},
					type : "post",
					success : function(json) {
						if (json.state) {
							//showMsg("保存成功");
							//$("#datagrid").datagrid("reload");
						} else{
							showMsg("提交失败");
						}
					}
				});
				
			}
			
			function updateOneWare(wareId,choose)
			{

				
				$.ajax( {
					url : "manager/updateChooseWare1",
					data : {"wareId":wareId,"choose":choose},
					type : "post",
					success : function(json) {
						if (json.state) {
							//showMsg("保存成功");
							//$("#datagrid").datagrid("reload");
						} else{
							showMsg("提交失败");
						}
					}
				});
			}

			function addChoose()
			{
				var rows = $("#datagrid").datagrid("getRows");
				
				for ( var i = 0; i < rows.length; i++) {
					//var index=$('#datagrid').datagrid('getRowIndex',rows[i]);
					
					$('#datagrid').datagrid('selectRow', i)
					.datagrid('beginEdit', i);
					$('#datagrid').datagrid('getRows')[i]['chooseStr'] = "√";
					
					$('#datagrid').datagrid('updateRow',{index:i,row:{chooseStr:'√'}});
					$('#datagrid').datagrid('endEdit', i);
				}
				submitWare();
				
			}

			function decChoose()
			{
				var rows = $("#datagrid").datagrid("getRows");
				for ( var i = 0; i < rows.length; i++) {
					var index=$('#datagrid').datagrid('getRowIndex',rows[i]);
					
					$('#datagrid').datagrid('selectRow', i)
					.datagrid('beginEdit', i);
					$('#datagrid').datagrid('getRows')[i]['chooseStr'] = "X";
					
					$('#datagrid').datagrid('updateRow',{index:i,row:{chooseStr:'X'}});
					$('#datagrid').datagrid('endEdit', i);
				}
				submitWare();
				
			}

		</script>
	</body>
</html>
