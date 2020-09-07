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

	<body class="easyui-layout" onload="formload()">
	<input type="hidden" id="typeId" value=${typeId} />
	<input type="hidden" id="itemId" value=${itemId} />
		<div data-options="region:'north'" style="height:50px">
		<div style="margin-top:10px"> 
		<%--<a class="easyui-linkbutton" iconCls="icon-add"  href="javascript:addTypeClick();">增加科目类型</a>--%>
		<a class="easyui-linkbutton" iconCls="icon-add"  href="javascript:addItemClick();">增加科目明细</a>
		<%--<a class="easyui-linkbutton" iconCls="icon-add"  href="javascript:addTemplate();">数据参考</a>--%>
		</div>
		</div>
		<div data-options="region:'west',split:true,title:'往来科目'"
			style="width:300px;padding-top: 5px;">
			<table id="costTypeId" class="easyui-datagrid" fit="true" singleSelect="true"
					url="manager/queryIoTypeList" title="" iconCls="icon-save" border="false" rownumbers="true"
			 		fitColumns="true" data-options="onClickRow: onClickRow1">
					<thead>
					<tr>
				    <th field="id" width="80" align="center" hidden="true">
						编号
					</th>
					 <th field="typeName" width="100" align="center">
						科目名称
					</th>
					
					</tr>
					</thead>
			
					</table>
			
		</div>
		<div id="wareTypeDiv" data-options="region:'center'" title="明细科目">
			<table id="itemgrid" class="easyui-datagrid" fit="true" singleSelect="true"
					url="manager/queryIoItemList" title="" iconCls="icon-save" border="false" rownumbers="true"
			 		fitColumns="true" >
					<thead>
					<tr>
				    <th field="id" width="80" align="center" hidden="true">
						编号
					</th>
					 
					<th field="itemName" width="150" align="center">
						明细科目名称
					</th>
					
					 <th field="remarks" width="150" align="center">
						备注
					</th>
					<th field="_operator" width="150" align="center" formatter="formatterSt4">
						操作
					</th>
					</tr>
					</thead>
			
					</table>
		</div>
		<div id="dlg" closed="true" class="easyui-dialog" title="往来类别" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						editCostType();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
		科目名称: <input name="typeName" id="typeName" value="${typeName}" style="width:120px;height: 20px;"/>
		
		</div>
		<div id="itemdlg" closed="true" class="easyui-dialog" title="明细科目" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						editCostItem();
					}
				},{
					text:'取消',
					handler:function(){
						$('#itemdlg').dialog('close');
					}
				}]
			">
		明细科目名称: <input name="itemName" id="itemName" value="${itemName}" style="width:120px;height: 20px;"/>
		科目名称: <select name="typeSel" id="typeSel">
	                </select>
	    <br>
	    
	    <br>
	             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备注: <input name="remarks" id="remarks" value="${remarks}" style="width:220px;height: 20px;"/>
		</div>
		<script type="text/javascript">
			//点击商品分类树查询
			
			function formload()
			{
				querycosttype();
			}
			
			
			function onDblClickRow(rowIndex, rowData)
		    {
		    	
		    		
		    	//parent.add('发货' + rowData.id,'manager/showstkoutcheck?dataTp=1&billId=' + rowData.id);
		    }
			
			function addTypeClick()
			{
				$("#typeId").val(0);
				$('#dlg').dialog('open');
			}
			
			function addItemClick()
			{
				$("#itemId").val(0);
				$('#itemdlg').dialog('open');
			}
			
			function editCostType()
			{
				var typeName = $("#typeName").val();
				if(typeName == "")
					{
					 	alert("请输入科目名称");
					 	return ;
					}
				var id=$("#typeId").val();
				
				$.ajax( {
					url : "manager/saveIoType",
					data : "id=" + id + '&typeName=' + typeName,
					type : "post",
					success : function(json) {
						if (json.state) {
							showMsg("保存成功");
							$('#dlg').dialog('close');
							$("#costTypeId").datagrid("reload");
							querycosttype();
							
						} else{
							showMsg("保存失败" + json.msg);
						}
					}
				});
			}
			
			function editCostItem()
			{
				var itemName = $("#itemName").val();
				if(itemName == "")
					{
					 	alert("请输入明细科目名称");
					 	return ;
					}
				var typeId = $("#typeSel").val();
				if(typeId==""){
					alert("请选择科目名称");
					return ;
				}
				var id=$("#itemId").val();
				var remarks = $("#remarks").val();
				$.ajax( {
					url : "manager/saveFinIoItem",
					data : "id=" + id + '&itemName=' + itemName + '&remarks=' + remarks +'&typeId=' + typeId,
					type : "post",
					success : function(json) {
						if (json.state) {
							showMsg("保存成功");
							$('#itemdlg').dialog('close');
							$("#itemgrid").datagrid("reload");
						} else{
							showMsg("保存失败" + json.msg);
						}
					}
				});
			}
			
			function formatterSt3(val,row){
			     
		      	var ret = "<input style='width:60px;height:27px' type='button' value='修改' onclick='toEditType("+row.id + ")'/>"
		      	 + "<br/><input style='width:60px;height:27px' type='button' value='删除' onclick='deleteCostType("+row.id+")'/>"
	      	       ;
	      	        return ret;
		      		
		   } 
			
			function formatterSt4(val,row){
				var ret = "";
				if(row.systemId==""||row.systemId==null){
					ret = "<input style='width:60px;height:27px' type='button' value='修改' onclick='toEditItem("+row.id + ")'/>"
							+ "<br/><input style='width:60px;height:27px' type='button' value='删除' onclick='deleteCostItem("+row.id+")'/>"
					;
				}
				return ret;
		   }
			
			function toEditType(typeId)
			{
				
				$("#typeId").val(typeId);
				var typeName = "";
				$.ajax( {
					url : "manager/queryIoTypeById",
					data : "typeId=" + typeId,
					type : "post",
					success : function(json) {
						
						if (json.state) {
							typeName = json.typeName;
							$("#typeName").val(typeName);
							$('#dlg').dialog('open');
							
						} else{
							showMsg("删除失败" + json.msg);
						}
					}
				});
				
				
			}
			
			function toEditItem(itemId)
			{
				
				$("#itemId").val(itemId);
				var itemName = "";
				var typeId = 0;
				var remarks = "";
				$.ajax( {
					url : "manager/queryIoItemById",
					data : "itemId=" + itemId,
					type : "post",
					success : function(json) {
						
						if (json.state) {
							itemName = json.itemName;
							typeId = json.typeId;
							remarks = json.remarks;
							$("#itemName").val(itemName);
							$("#typeSel").val(typeId);
							$("#remarks").val(remarks);
							$('#itemdlg').dialog('open');
						} else{
							showMsg("删除失败" + json.msg);
						}
					}
				});
				
				
			}
			
			function deleteCostType(typeId)
			{
				if(!confirm('是否确认删除该类别？'))return;
				$.ajax( {
					url : "manager/deleteIoType",
					data : "id=" + typeId,
					type : "post",
					success : function(json) {
						
						if (json.state) {
							showMsg("删除成功");
							//$('#dlg').dialog('close');
							$("#costTypeId").datagrid("reload");
							querycosttype();
						} else{
							showMsg("删除失败" + json.msg);
						}
					}
				});
			}
			
			function deleteCostItem(itemId)
			{
				if(!confirm('是否确认删除该类别？'))return;
				$.ajax( {
					url : "manager/deleteIoItem",
					data : "id=" + itemId,
					type : "post",
					success : function(json) {
						
						if (json.state) {
							showMsg("删除成功");
							//$('#dlg').dialog('close');
							$("#itemgrid").datagrid("reload");
						} else{
							showMsg("删除失败" + json.msg);
						}
					}
				});
			}
			
			
			function querycosttype(){
				var path = "manager/queryIoTypeList";
				//var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token11":""},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		
			        		var size = json.rows.length;
			        		$("#typeSel").empty();
			        		
			        		var objSelect = document.getElementById("typeSel");
			        		objSelect.options.add(new Option(''),'');
			        		
			        		for(var i = 0;i < size; i++)
			        			{
			        				objSelect.options.add( new Option(json.rows[i].typeName,json.rows[i].id));
			        				if(i == 0)
			    					{
			        					
			        					
			    						
			    						//$("#stkId").val(json.list[i].id);
			    						//$("#stkNamespan").text(json.list[i].stkName);
			    						$("#typesel").val(json.rows[i].id);
			    							
			    						
			    						
			    					}
			        				
			        			}
			        		
							
			        		
			        	}
			        }
			    });
			}
			function onClickRow1(index, row){
				
				queryItem(row.id);
			}

			function queryItem(typeId){
				$("#itemgrid").datagrid('load',{
					url:"manager/queryIoItemList",
					typeId:typeId
				});
			}
			
			function addTemplate(){
				parent.closeWin('项目参考数据');
				parent.add('项目参考数据','manager/toFinIoItemTemplate');
			}
		</script>
	</body>
</html>
