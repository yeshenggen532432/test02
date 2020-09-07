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
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/customerdayPage?dataTp=${dataTp }" title="多久没拜访列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    
					<th field="khNm" width="120" align="center" >
						客户名称
					</th>
					<th field="mobile" width="100" align="center" >
						客户电话
					</th>
					<th field="address" width="120" align="center" >
						客户地址
					</th>
					<th field="memberNm" width="120" align="center" >
						业务员名称
					</th>
					<th field="scbfDate" width="100" align="center" >
						最后拜访日期
					</th>
					<th field="dayNum" width="120" align="center" >
						几天以上没拜访
					</th>
					
			    </tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			几天以上没拜访: <input name="dayNum" id="dayNum" style="width:60px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员名称: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querycustomerday();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>
		</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>	
		<script type="text/javascript">
		    
		    //查询经销商
			function querycustomerday(){
				$("#datagrid").datagrid('load',{
					url:"manager/customerdayPage",
					dayNum:$("#dayNum").val(),
					memberNm:$("#memberNm").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querycustomerday();
				}
			}
			//导出
			function myexport(){
			    var dayNum=$("#dayNum").val();
			    if(!dayNum){
			      dayNum=0;
			    }
				var database="${datasource}";
				exportData('sysKhBfDayService','queryKhBfDay','com.cnlife.qwb.model.SysKhBfDay',"{dayNum:"+dayNum+",database:'"+database+"'}","多久没拜访客户记录");
  			}
		</script>
	</body>
</html>
