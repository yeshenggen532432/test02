<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企业行为分析</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>

	<body onload="query()">
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/sysCompanyUseLogPage"  border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			<thead>
				<tr>
					<th field="fd_company_nm" width="120" align="center" >
						公司名称
					</th>
					<th field="renchi" width="150" align="center">
						人数
					</th>
					<th field="zongchisu" width="120" align="center" >
						访问服务器次数
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			公司名称: <input name="fdCompanyNm" id="fdCompanyNm" style="width:156px;height: 20px;" value="${fdCompanyNm }" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:showMember();">企业用户使用分析</a>
		</div>
		
		<script type="text/javascript">
			
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/sysCompanyUseLogPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					fdCompanyNm:$("#fdCompanyNm").val()
				});
			}

			function showMember(){
				var sdate=$("#sdate").val();
				var edate=$("#edate").val();
				var fdCompanyNm=$("#fdCompanyNm").val();
		    	parent.closeWin('企业用户使用分析');
		    	parent.add('企业用户使用分析','manager/querymembersysuselog?sdate='+sdate+'&edate='+edate+'&fdCompanyNm='+fdCompanyNm+'');
			}
			
			function onDblClickRow(rowIndex, rowData)
		    {
				var sdate=$("#sdate").val();
				var edate=$("#edate").val();
				var fdCompanyNm=rowData.fd_company_nm;
		    	parent.closeWin('企业用户使用分析');
		    	parent.add('企业用户使用分析','manager/querymembersysuselog?sdate='+sdate+'&edate='+edate+'&fdCompanyNm='+fdCompanyNm+'');
		    }
			
			function show(){
		    	parent.closeWin('企业行为详细');
		    	parent.add('企业行为详细','manager/querysysuselogdetail');
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}
		</script>
	</body>
</html>
