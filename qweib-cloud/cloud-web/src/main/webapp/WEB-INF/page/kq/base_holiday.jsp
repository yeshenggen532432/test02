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
			url="manager/kqholiday/queryHolidayPage" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="dayName" width="120" align="center">
						节假日名称
					</th>
					<th field="startDate" width="120" align="center">
						开始日期
					</th>
					<th field="endDate" width="120" align="center">
						结束日期
					</th>
					
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     节假日名称: <input name="dayName" id="dayName" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryHolidayPage();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddholiday();">添加</a>
			
				
				
				
				  <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
				  <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
				  
				  
				
			
		</div>
	
		<script type="text/javascript"><!--

		    //查询商品
			function queryHolidayPage(){
			  
				$("#datagrid").datagrid('load',{
					url:"manager/kqholiday/queryHolidayPage?",
							dayName:$("#dayName").val()
					
					
				});
			  
			  
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryHolidayPage();
				}
			}
			//添加
			function toaddholiday(){
				location.href="${base}/manager/kqholiday/toBaseHolidayEdit?id=0";
			}
			//修改
			function getSelected(){
			    var row = $('#datagrid').datagrid('getSelected');
				if (row){
					
					  location.href="${base}/manager/kqholiday/toBaseHolidayEdit?id="+row.id;
				 }else{
					alert("请选择要修改的行！");
				}
			}

		    //删除
		    function toDel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/kqholiday/deleteHoliday",
								data : "ids=" + ids,
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
		   
		   

		</script>
	</body>
</html>
