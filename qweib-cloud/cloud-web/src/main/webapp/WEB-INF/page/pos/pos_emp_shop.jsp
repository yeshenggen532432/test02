]<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员管理</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body class="easyui-layout" fit="true">
		<div data-options="region:'west',split:true,title:'部门分类树'"
			style="width:150px;padding-top: 5px;">
			<div id="divHYGL" style="overflow: auto;">
				<ul id="departtree" class="easyui-tree" fit="true"
					data-options="url:'manager/departs?depart=${depart }&dataTp=1',animate:true,dnd:false,onClick: function(node){
						queryEmpPageByBranchId(node.id);
					},onDblClick:function(node){
						$(this).tree('toggle', node.target);
					}">
				</ul>
			</div>
		</div>
		<div id="departDiv" data-options="region:'center'" title="部门员工信息">
			<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/pos/queryShopEmpPage?memberUse=1" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				<th field="ck" checkbox="true"></th>
				<th field="memberId" width="10" align="center" hidden="true">
					memberid
					</th>
				    <th field="shopId" width="10" align="center" hidden="true">
						Shopid
					</th>
					
					<th field="memberNm" width="100" align="center">
						姓名
					</th>
					
					<th field="memberMobile" width="100" align="center">
						手机号码
					</th>
					
					<th field="shopName" width="100" align="center">
						店名
					</th>
					<th field="groupName" width="100" align="center">
						角色名称
					</th>
					
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		    查询(姓名/手机号码): <input name="memberNm" id="memberNm" style="width:156px;height: 20px;" onkeydown="queryEmpPage();"/>
		       规则名称: <input name="shopName" id="shopName" style="width:156px;height: 20px;" onkeydown="queryEmpPage();"/>
			<input type="hidden" name="branchId" id="branchId" value="${branchId}"/>	
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryEmpPage();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:ruleclick();">分配门店</a>
		</div>
			
		</div>
		<div id="dlg" closed="true" class="easyui-dialog" title="请选择考勤规则" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						saveshopemp();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
			<div class="box">
			<dd>
		选择门店: <select id="shopselect" name="shopselect">			  					  
			  					  <option value="0">不分配</option>			  					  
			  					</select>
		</dd>
		<dd>
		选择角色: <select id="groupselect" name="groupselect">
			  					  <option value="0">请选择用户组</option>
			  					  <option value="0">不分配</option>			  					  
			  					</select>
		</dd>
		</div>
	        	
		
		
		
		</div>
		<script type="text/javascript">
			$(function(){
				loadShop();
				loadGroup();
			});
			
			function ruleclick()
			{
				var rows = $("#datagrid").datagrid("getSelections");
				if(rows.length == 0)
					{
					alert("请选择要分配的员工");
					return;
					}
				$('#dlg').dialog('open');
			}
			
			function queryEmpPageByBranchId(branchId){
				  
				$("#datagrid").datagrid('load',{
					url:"manager/pos/queryShopEmpPage",
							branchId:branchId,
							memberUse:1
					
					
				});
			  
			  
			}
			function loadShop(){
				
				var path = "manager/pos/queryPosShopInfoPage";
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"status":1},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		var size = json.rows.length;

			        		for(var i = 0;i<size;i++)
			        		$("#shopselect").append("<option value='"+json.rows[i].id+"'>"+json.rows[i].shopName+"</option>");  //.options.add( new Option(json.rows[i].bcName,json.rows[i].id));
			        		
			        	}
			        }
			    });
				
			}
			function loadGroup(){
				
				var path = "manager/pos/queryGroupList";
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"status":1},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		var size = json.rows.length;			        		
			        		for(var i = 0;i<size;i++)
			        		$("#groupselect").append("<option value='"+json.rows[i].id+"'>"+json.rows[i].groupName+"</option>");  //.options.add( new Option(json.rows[i].bcName,json.rows[i].id));
			        		
			        	}
			        }
			    });
				
			}
			function queryEmpPage()
			{
				$("#datagrid").datagrid('load',{
					url:"manager/pos/queryShopEmpPage",
							memberNm:$("#memberNm").val(),
							shopName:$("#shopName").val(),
							memberUse:1
					
					
				});
			}
			
			//保存
			function saveshopemp(){
				var ids = "";
				var shopId = $("#shopselect").val();
				var groupId = $("#groupselect").val();
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					if(i == 0)ids = rows[i].memberId;
					else ids = ids + "," + rows[i].memberId;
					
				}

				if (rows.length > 0) {
					var path = "manager/pos/savePosShopEmp";
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"ids":ids,"shopId":shopId,"groupId":groupId},
				        dataType: 'json',
				        async : false,
				        success: function (json) {
				        	if(json.state){
				        		$("#datagrid").datagrid("reload");
				        		$('#dlg').dialog('close');
				        		
				        	}
				        	else
				        		{
				        		alert("保存失败");
				        		}
				        }
				    });
				}
				
			}
			
			
			
			
		</script>
	</body>
</html>
