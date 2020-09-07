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
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script type="text/javascript" src="resource/dtree.js"></script>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	    </style>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/pos/queryGroupList" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="false" 
			toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					
					<th field="groupName" width="120" align="center">
						门店角色名称
					</th>
					
					<th field="remarks" width="120" align="center">
						备注
					</th>
					
					<th field="isSupper" width="60" align="center"  formatter="formatterSt1">
						超级用户否
					</th>
					
					
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		   
			
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryGroup();">刷新</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddGroup();">添加</a>
			
				
				
				
				  <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
				  <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
				  
				  
				
			
		</div>
	
		<script type="text/javascript">

		    //查询商品
			function queryGroup(){
			  
				$("#datagrid").datagrid('load',{
					url:"manager/pos/queryGroupList?",
							shopName:$("#shopName").val()
					
					
				});
			  
			  
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryGroup();
				}
			}
			//添加
			function toaddGroup(){
				location.href="${base}/manager/pos/toPosGroupEdit?id=0";
			}
			//修改
			function getSelected(){
			    var row = $('#datagrid').datagrid('getSelected');
				if (row){
					
					  location.href="${base}/manager/pos/toPosGroupEdit?id="+row.id;
				 }else{
					alert("请选择要修改的行！");
				}
			}

		    //删除
		    function toDel() {
				var ids = 0;
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids = rows[i].id;
					break;
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/pos/deletePosGroup",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									}else{
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
		    
		    function formatterSt1(val,row){
		    	if(val == 0)return "普通用户";
		    	if(val ==  1)return "超级用户";
		    }
		    
		</script>
	</body>
</html>
