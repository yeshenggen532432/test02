<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>卡宝包</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	</head>
	<script type="text/javascript">
		function vgroupDesc(val){
			if(val!=""&& typeof(val)!="undefined"){
				if(val.length>20){
					return val.substring(0,20)+"...";
				}else{
					return val;
				}
			}else{
				return "-";
			}
		}
		function toDel(){
			if(confirm("是否删除?")){
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for(var i=0;i<rows.length;i++){
					ids.push(rows[i].groupId);
				}
				if(ids.length>0){
				   $.ajax({
						url:"manager/delempgroup",
						data:"ids="+ids,
						type:"post",
						success:function(json){
							if(json==1){	
								alert("删除成功");
								query();
							}else{
								alert("删除失败");
							}
						}
					});
			    }else{
			    	alert("请选择行");
			    }
		    }
		}
		//回车查询
		function toQuery(e){
			var key = window.event?e.keyCode:e.which;
			if(key==13){
				query();
			}
		}
		//查询
		function query(){
			$("#datagrid").datagrid('load',{
				url:"manager/empgroupPage",
				groupNm:$("#groupNm").val()
			});
		}
	</script>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/empgroupPage" title="任务列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="groupId" width="50" align="center" hidden="true">
						idKey
					</th>
					<th field="ck" checkbox="true"></th>
					<th field="groupNm" width="280" align="center">
						圈名称
					</th>
					<th field="groupDesc" width="180" align="center" formatter="vgroupDesc">
						圈介绍
					</th>
					<th field="memberNm" width="180" align="center">
						创建人
					</th>
					<th field="creatime" width="180" align="center">
						创建时间
					</th>
					<th field="groupNum" width="180" align="center">
						总人数
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			圈名称: <input name="groupNm" id="groupNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
		</div>
	</body>
</html>
