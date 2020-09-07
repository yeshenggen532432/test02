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
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/stkCustomerWareGroup/toWareGroupPage?customerId=${param.cstId}" title="客户商品分组" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="name" width="280" align="center">
						名称
					</th>
					<th field="asn" width="280" align="center">
						条码
					</th>
					<th field="_oper" width="280" align="center" formatter="formatterOper">
						操作
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toAdd();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
		</div>
		<div id="baseModelDiv" class="easyui-window" style="width:400px;height:150px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/stkCustomerWareGroup/updateWareGroup?customerId=${param.cstId}" id="baseModelFrm" name="baseModelFrm" method="post">
				<input type="hidden" name="id" id="id"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				    
				    <tr height="30px">
						<td align="center">
						    名称：
							<input class="reg_input" name="name" id="name" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					 <tr height="30px">
						<td align="center">
						    条码：
							<input class="reg_input" name="asn" id="asn" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
				    <tr height="40px">
						<td align="center">
							<a class="easyui-linkbutton" href="javascript:addForm();">保存</a>
							<a class="easyui-linkbutton" href="javascript:hideWin();">关闭</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
        </div>
        <div id="wareItems" closed="true" class="easyui-dialog" style="width:300px; height:200px;" title="商品列表" iconCls="icon-edit">
        </div>
        
		<script type="text/javascript">
			function queryData(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkCustomerWareGroup/toWareGroupPage?customerId=${param.cstId}"
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryAutoField();
				}
			}
			function toAdd(){
			    $("#id").val("");
			    toreset('baseModelFrm');
			    showWin("添加分组名称");
			}
			function hideWin(){
				$("#baseModelDiv").window('close');
			}
			function showWin(title){
				$("#baseModelDiv").window({title:title});
				$("#baseModelDiv").window('open');
			}
			function addForm(){
			    var name = $("#name").val();
				if(!name){
					alert("名称不能为空");
					return;
				}
				 var asn = $("#asn").val();
				if(!asn){
					alert("条码不能为空");
					return;
				}
				$('#baseModelFrm').form('submit', {
					success:function(data){
						$("#baseModelDiv").window('close');
						if(data=="1" || data=="2"){
							queryData();
						}else{
						    alert("操作失败");
					        return;
						}
					}
				});
			}
			//获取选中行的值
			function getSelected(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					$.ajax({
						url:"manager/stkCustomerWareGroup/getWareGroupById",
						data:"id="+row.id,
						type:"post",
						success:function(json){
							if(json){
							    $("#id").val(json.id);
								$("#name").val(json.name);
								$("#asn").val(json.asn);
								showWin("修改分组名称");
							}
						}
					});
				}else{
					alert("请选择行");
				}
			}
		
			//删除
			function toDel(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(confirm("是否要删除选中的分组名称?")){
						$.ajax({
							url:"manager/stkCustomerWareGroup/deleteWareGroupById",
							data:"id="+row.id,
							type:"post",
							success:function(json){
								if(json){
								    if(json=='1'){
								      alert("删除成功");
								      queryData();
								    }else{
								      alert("删除失败");
					                  return;
								    }
								}
							}
						});
					}
				}
			}
			
			var groupId = "";
			function dialogSelectWare(id){
		 	$('#wareDlg').dialog({
		         title: '商品选择',
		         iconCls:"icon-edit",
		         width: 800,
		         height: 400,
		         modal: true,
		         href: "<%=basePath %>/manager/dialogWareTypeGroup?groupId="+id,
		         onClose: function(){
		         }
		     });
		 	groupId = id;
		 	$('#wareDlg').dialog('open');
		   }
			
			function callBackFun(json){
				var size = json.list.length;
				if(size>0){
					var wareIds = "";
					for(var i=0;i<size;i++){
						if(wareIds!=""){
							wareIds = wareIds  + ",";
						}
						wareIds += json.list[i].wareId;
					}
					var customerId='${param.cstId}';
					if (wareIds!=""){
						if(confirm("是否确认保存选中的商品?")){
							$.ajax({
								url:"manager/stkCustomerWareGroup/addBatchWareItems",
								data:"wareIds="+wareIds+"&groupId="+groupId+"&customerId="+customerId,
								type:"post",
								success:function(json){
									if(json){
									    if(json=='1'){
									      alert("保存成功");
									    }else{
									      alert("保存失败");
						                  return;
									    }
									}
								}
							});
						}
					}
				}
			}
			
			function toDelItems(id,o){
					if(confirm("是否要删除该商品")){
						$.ajax({
							url:"manager/stkCustomerWareGroup/deleteWareItemsById",
							data:"id="+id,
							type:"post",
							success:function(json){
								if(json){
								    if(json=='1'){
								      alert("删除成功");
								      $(o).parents('tr').remove();
								    }else{
								      alert("删除失败");
					                  return;
								    }
								}
							}
						});
					}
			}

			 function formatterOper(val,row){
		    	if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
		      	var ret = "<input style='width:60px;height:27px' type='button' value='查看商品' onclick='showWareItems("+row.id+")'/>"
		      	        + "<input style='width:60px;height:27px' type='button' value='添加商品' onclick='dialogSelectWare("+row.id+")'/>";
		      	        return ret;
			      		
			   }
			 
			 function showWareItems(id){
					$('#wareItems').dialog({
				         title: '商品查看',
				         iconCls:"icon-edit",
				         width: 300,
				         height: 400,
				         modal: true,
				         href: "<%=basePath %>/manager/stkCustomerWareGroup/stkWareItemsList?customerId=${cstId}&groupId="+id,
				         onClose: function(){
				         }
				     });
				 	$('#wareItems').dialog('open');
			 }
		</script>
	</body>
</html>
