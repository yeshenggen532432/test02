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

	<body class="easyui-layout">
	<div data-options="region:'west',split:true,title:''"
			style="width:150px;padding-top: 5px;">
			<div class="easyui-layout" data-options="fit:true">  
			<div data-options="region:'north',title:'',split:true" style="height:400px;">
			<table id="dg" class="easyui-datagrid" title="" fit="true" fitColumns="true" url="manager/pos/queryGroupList"
			data-options="
				iconCls: 'icon-save',
				singleSelect: true,				
				onClickRow: onClickRow, onLoadSuccess:onLoadSuccess
			">
			<!--  <table id="empdatagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/rolepages_company?page=1&rows=20" title="公司角色列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" 
			toolbar="#tb" onClickRow=onClickRow>-->
			<thead>
				<tr>
				<th field="id" width="50" align="center" hidden="true">
						id
					</th>
				    <th field="groupName" width="50" align="center">
						用户组名称
					</th>
					
					
					
				</tr>
			</thead>
		</table>
		</div>
		<div data-options="region:'center',title:''" style="padding:5px;">
		<table id="dgModule" class="easyui-datagrid" title="" fit="true" fitColumns="true" url="manager/pos/getModuleList"
			data-options="
				iconCls: 'icon-save',
				singleSelect: true,				
				onClickRow: onClickRow2,
				onLoadSuccess:onLoadSuccess2
			">
			<!--  <table id="empdatagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/rolepages_company?page=1&rows=20" title="公司角色列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" 
			toolbar="#tb" onClickRow=onClickRow>-->
			<thead>
				<tr>
				<th field="id" width="50" align="center" hidden="true">
						id
					</th>
				    <th field=moduleName width="50" align="center">
						模块名称
					</th>
					
					
					
				</tr>
			</thead>
		</table>
		
		</div>  
		</div>
		
	</div>
	<div id="wareTypeDiv" data-options="region:'center'" title="功能弄表">
	<input  type="hidden" name="groupid" id="groupId" value="0"/>
	<input  type="hidden" name="moduleId" id="moduleId" value="0"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			  border="false"
			rownumbers="true" fitColumns="false" pagination="false" data-options="onClickRow: onClickRow1,onLoadSuccess:onLoadSuccess1"
			 toolbar="#tb" >
			<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="funcName" width="200" align="center">
						功能名称
					</th>
					
					<th data-options="field:'checkStr',width:80,align:'center',editor:{type:'checkbox',options:{on:'√',off:'X'}}">
						权限
					</th>
					
					
					
					
				</tr>
			</thead>
		</table>
		
		<div id="tb" style="padding:5px;height:auto">
		
		    
	         
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:addRight();">授权</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true"  href="javascript:decRight();">取消授权</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:submitOneRight(1);">保存</a>
			
			
			
		</div>
		</div>
		<div>
		  	<form action="manager/orderExcel" name="loadfrm" id="loadfrm" method="post">
		  		<input type="text" name="orderNo2" id="orderNo2"/>
				<input type="text" name="khNm2" id="khNm2"/>
				<input type="text" name="memberNm2" id="memberNm2"/>
				<input type="text" name="sdate2" id="sdate2"/>
				<input type="text" name="edate2" id="edate2"/>
				<input type="text" name="orderZt2" id="orderZt2"/>
				<input type="text" name="pszd2" id="pszd2"/>
		  	</form>
	  	</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
		    
		    //查询物流公司
			function queryMenu(){
		    	var groupId = $("#groupId").val();
		    	
				if(groupId == 0)
				{
					var roleArr =  $('#dg').datagrid('getData');
					groupId = roleArr.rows[0].id;
					
				}
				var moduleId = $("#moduleId").val();
				if(moduleId == 0)
				{
					var roleArr =  $('#dgModule').datagrid('getData');
					if(roleArr.rows.length> 0)
					moduleId = roleArr.rows[0].id;
					
				}
				
				$('#datagrid').datagrid({
					url:"manager/pos/getFunctionList",
					queryParams:{					
					groupId:groupId,
					moduleId:moduleId
					
					}
					
				});
			}

			function onLoadSuccess(data)
			{
				//var roleArr =  $('#dg').datagrid('getData');
				
			}
			function onLoadSuccess1(data)
			{
				

			}
			function onLoadSuccess2(data)
			{
				queryMenu();
				
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
				}
			}
			
			function formatterSt(v,row){
				var hl='<table>';
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>商品名称</b></td>';
			        
			        hl +='<td width="60px;"><b>单位</font></b></td>';
			        hl +='<td width="80px;"><b>规格</font></b></td>';
			        hl +='<td width="60px;"><b>数量</font></b></td>';
			        hl +='<td width="60px;"><b>单价</font></b></td>';
			        hl +='<td width="60px;"><b>总价</font></b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].wareNm+'</td>';
			        
			        hl +='<td>'+row.list[i].unitName+'</td>';
			        hl +='<td>'+row.list[i].wareGg+'</td>';
			        hl +='<td>'+row.list[i].qty+'</td>';
			        hl +='<td>'+row.list[i].price+'</td>';
			        hl +='<td>'+row.list[i].qty *row.list[i].price +'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}
			function toPay(){
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].billStatus!='已审'){
					   alert("该订单未审核，不可支付");
					   return;
					}
				}
				if(ids.length > 1)
					{
						alert("只能选择一张入库单");
						return;
					}
				window.location.href='${base}/manager/stkpay?billId=' + ids[0];
			}
			function formatterSt2(val,row){
			  if(row.list.length>0){
			    if(val=='未审核'){
		            return "<input style='width:60px;height:27px' type='button' value='未审核' onclick='updateOrderSh(this, "+row.id+")'/>";
			     }else{
			        return val;   
			     }
			  }
		    } 
		    //修改审核
		    function updateOrderSh(_this,id){
		      $.messager.confirm('确认', '您确认要审核吗？', function(r) {
			  if (r) {
				$.ajax({
					url:"manager/updateOrderSh",
					type:"post",
					data:"id="+id+"&sh=审核",
					success:function(data){
						if(data=='1'){
						    alert("操作成功");
							queryorder();
						}else{
							alert("操作失败");
							return;
						}
					}
				});
			  }
			 });
			 }
			 //导出成excel
		    function toLoadExcel(){
		        $('#orderNo2').val($('#orderNo').val());
				$('#khNm2').val($('#khNm').val());
				$('#memberNm2').val($('#memberNm').val());   
				$('#sdate2').val($('#sdate').val()); 
				$('#edate2').val($('#edate').val());
				$('#orderZt2').val($('#orderZt').val());  
				$('#pszd2').val($('#pszd').val()); 
				$('#loadfrm').form('submit',{
					success:function(data){
						alert(data);
					}
				});
			}
			//删除
		    function toDel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].orderZt=='已审'){
					   alert("该单不能删除");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/deleteStkIn",
								data : "ids=" + ids,
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									} else{
										showMsg("删除失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要删除的数据");
				}
			}
			function showInfo()
			{
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					
				}
				if(ids.lenth > 1)
					{
					 	alert("只能选择一条记录");
					 	return;
					}
				if(ids.length == 0)
					{
					alert("请选择要查看的记录");
				 	return;
					}
				
				parent.add('采购入库','manager/showstkin?dataTp=1&billId=' + ids[0]);
			}
			//作废
		    function toZf() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].orderZt=='未审核'){
					   alert("该订单未审核，不能作废");
					   return;
					}
					if(rows[i].orderZt=='已作废'){
					   alert("该订单已作废，不能再作废");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要作废该记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/updateOrderZf",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
										showMsg("作废失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要作废的数据");
				}
			}
			function onClickRow(rowNum,record)
			{
				$("#groupId").val(record.id);
				
				queryMenu();
			}
			
			function onClickRow2(rowNum,record)
			{
				$("#moduleId").val(record.id);
				
				queryMenu();
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
					
					submitOneRight(0);
					return true;
				} else {
					return false;
				}
			}
			function onClickRow1(index){
				if (editIndex != index){
					if (endEditing()){
						$('#datagrid').datagrid('selectRow', index)
								.datagrid('beginEdit', index);
						editIndex = index;
						
					} else {
						$('#datagrid').datagrid('selectRow', editIndex);
					}
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
				alert(22);
			}
			function getChanges(){
				var rows = $('#datagrid').datagrid('getChanges');
				alert(rows.length+' rows are changed!');
				
			}
			
			function submitOneRight(ope)
			{
				var roleArr =  $('#dg').datagrid('getData');
				var groupId = $("#groupId").val();
				if(groupId == 0)
				{
					groupId = roleArr.rows[0].id;
					
				}
				var rows = $('#datagrid').datagrid('getChanges');
				if(rows.length == 0)return;
				var funcId = rows[0].id;
				var isCheck = 0;
			    if(rows[0].checkStr == "√")isCheck = 1;
			    
			    $.ajax( {
					url : "manager/pos/saveGroupRight1",
					data : "groupId=" + groupId+"&funcId=" + funcId + "&isCheck=" + isCheck,
					type : "post",
					success : function(json) {
						if (json.state) {
							if(ope == 1)
							showMsg("保存成功");
							//$("#datagrid").datagrid("reload");
						} else{
							showMsg("提交失败");
						}
					}
				});
			    accept();
			    
			}

			function submitRight(checkFlag)
			{
				
				var arr =  $('#datagrid').datagrid('getData');
				var roleArr =  $('#dg').datagrid('getData');
				var groupId = $("#groupId").val();
				if(groupId == 0)
				{
					groupId = roleArr.rows[0].id;
					
				}
				var moduleId = $("#moduleId").val();
				if(moduleId == 0)
				{
					var roleArr =  $('#dgModule').datagrid('getData');
					if(roleArr.rows.length> 0)
					moduleId = roleArr.rows[0].id;
					
				}
				var rightList = new Array();
				if(checkFlag == 1)
				{
				for (var i=0;i<arr.rows.length;i++) {
					//var amtFlag = 0;
					//if(arr.rows[i].checkStr == "√") amtFlag = 1;
					
					var menuId = arr.rows[i].id;
					 var subObj = {
								groupId: groupId,
								funcId: menuId,
								isCheck: checkFlag
												
						};
					rightList.push(subObj);
				}
				}
				
				
				$.ajax( {
					url : "manager/pos/saveGroupRight",
					data : {"groupId":groupId,"moduleId":moduleId,"rightStr":JSON.stringify(rightList)},
					type : "post",
					success : function(json) {
						if (json.state) {
							showMsg("保存成功");
							//$("#datagrid").datagrid("reload");
							queryMenu();
						} else{
							showMsg("提交失败");
						}
					}
				});
				accept();
				
			}

			function addRight()
			{
				/*var rows = $("#datagrid").datagrid("getRows");
				for ( var i = 0; i < rows.length; i++) {
					var index=$('#datagrid').datagrid('getRowIndex',rows[i]);					
					$('#datagrid').datagrid('selectRow', index)
					.datagrid('beginEdit', index);
					$('#datagrid').datagrid('getRows')[index]['checkStr'] = "√";
					
					$('#datagrid').datagrid('endEdit', index);
				}*/
				submitRight(1);
				queryMenu();
				//$("#datagrid").datagrid("reload");
				
				
				
			}

			function decRight()
			{
				/*var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					var index=$('#datagrid').datagrid('getRowIndex',rows[i]);
					
					$('#datagrid').datagrid('selectRow', 1)
					.datagrid('beginEdit', index);
					$('#datagrid').datagrid('getRows')[1]['checkStr'] = "X";
					
					$('#datagrid').datagrid('endEdit', 1);
				}*/
				submitRight(0);
				queryMenu();
				//$("#datagrid").datagrid("reload");
				
			}
		</script>
	</body>
</html>
