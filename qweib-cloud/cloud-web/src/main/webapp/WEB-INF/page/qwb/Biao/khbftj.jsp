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

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/khbftjPage?dataTp=${dataTp }" title="客户拜访统计表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						客户id
					</th>
					<th field="khTp" width="50" align="center" hidden="true">
						客户种类
					</th>
				    <th field="khNm" width="120" align="center" formatter="formatterSt1">
						客户名称
					</th>
					<th field="memberNm" width="100" align="center">
						业务员名称
					</th>
					<th field="khdjNm" width="80" align="center">
						客户等级
					</th>
					<th field="createTime" width="80" align="center">
						建立时间
					</th>
					<th field="scbfDate" width="60" align="center">
						拜访日期
					</th>
					<th field="bfsc" width="60" align="center">
						时长
					</th>
					<th field="bfpl" width="60" align="center">
						拜访频率
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		   拜访日期: <input name="stime" id="stime"  onClick="WdatePicker();" style="width: 100px;" value="${stime}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="etime"  onClick="WdatePicker();" style="width: 100px;" value="${etime}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        业务员名称: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>  	   
	        客户等级: <select name="khdjNm" id="khdjNm">
	                  <option value="">全部</option>
	                  <c:forEach items="${list}" var="list">
						<option value="${list.khdjNm}">${list.khdjNm}</option>
					  </c:forEach>
	               </select>
		   拜访频率: <input name="bfpl" id="bfpl" style="width:60px;height: 20px;" onkeydown="toQuery(event);"/>   
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querykhbftj();">查询</a>
		</div>
		<script type="text/javascript">
		   //查询
			function querykhbftj(){
				$("#datagrid").datagrid('load',{
					url:"manager/khbftjPage",
					stime:$("#stime").val(),
					etime:$("#etime").val(),
					memberNm:$("#memberNm").val(),
					khdjNm:$("#khdjNm").val(),
					bfpl:$("#bfpl").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querykhbftj();
				}
			}
			function formatterSt1(v,row){
				return '<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:todetail(\''+v+'\','+row.id+','+row.khTp+');">'+v+'</a>';
			}
			function todetail(title,id,khTp){
			    window.parent.add(title,"manager/tocustomerxq?khTp="+khTp+"&Id="+id);
			}
			
		</script>
	</body>
</html>
