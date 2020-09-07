<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>基础照片墙管理</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="<%=request.getContextPath()%>/resource/WdatePicker.js"></script>
	</head>
	<body>
		<table  id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/photoWallPage" title="基础照片墙列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="wallId" width="50" align="center" hidden="true">
						wallId
					</th>
					<th field="memberId" width="50" align="center" hidden="true">
						memberId
					</th>
					<th field="memberNm" width="280" align="center">
						发表人
					</th>
					<th field="publishTime" width="280" align="center">
						发表时间
					</th>
					<th field="publishContent" width="280" align="center">
						发表内容
					</th>
					<th field="praiseNum" width="150" align="center">
						赞数
					</th>
					<th field='_operate' width="150" align="center" formatter="formatOper">
						图片
					</th>
					<th field="toTop" width="100" align="center" formatter="formatterTop">操作</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			发表人:<input name="memNm" id="memNm" style="width:76px;height: 20px;" onkeydown="toQuery(event);"/>
			时间: <input name="stime" id="stime" value="" maxlength="15" onClick="WdatePicker();" />
                  <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
				     -
				  <input name="etime" id="etime" value="" maxlength="15" onClick="WdatePicker();" />
                   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			<a class="easyui-linkbutton" iconCls="icon-search"  href="javascript:queryPtWall();">查询</a>
		</div>
		<script type="text/javascript">
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryPtWall();
				}
			}
			//查询
			function queryPtWall(){
				$("#datagrid").datagrid('load',{
					url:"manager/photoWallPage",
					memberNm:$("#memNm").val(),stime:$("#stime").val(),etime:$("#etime").val()
				});
			}
			function formatOper(val,row,index){  
			    return '<a href="javascript:void();" onclick="editUser('+index+')">查看</a>';  
			}  
			function editUser(index){  
			    $('#datagrid').datagrid('selectRow',index);// **  
			    var row = $('#datagrid').datagrid('getSelected');
			    if (row){  
			        window.parent.add('图片',"manager/toPicPage?wallId="+row.wallId);
			    	}  
	        } 

			//操作
			function formatterTop(val,row){
				return "<input type='button' value='置顶' onclick='toTop(this, "+row.wallId+")'/>";
				}
			//置顶
			function toTop(_this,wallId){
				$.ajax({
					url:"manager/PhotoWallToTop",
					type:"post",
					data:"wallId="+wallId,
					success:function(data){
						if(data=='1'){
							queryPtWall();
							}else{
							alert("置顶失败");
							}
					}
					})
				}
		</script>
	</body>
</html>
