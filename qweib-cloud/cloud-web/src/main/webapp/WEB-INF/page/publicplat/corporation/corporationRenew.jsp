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
			url="manager/corporationRenewPage" title="公司续费记录" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="deptNm" width="150" align="center">
						公司名称
					</th>
					<th field="memberNm" width="80" align="center" >
						操作人
					</th>
					<th field="renewTime" width="120" align="center" >
						续费时间
					</th>
					<th field="operTime" width="120" align="center" >
						操作时间
					</th>
					<th field="endDate" width="120" align="center" >
						到期日期
					</th>
			    </tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			公司名称: <input name="deptNm" id="deptNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			续费时间:<select name="renewTime" id="renewTime">
			              <option value="">全部</option>
			              <option value="一个月">一个月</option>
			              <option value="一季度">一季度</option>
			              <option value="半年">半年</option>
			              <option value="一年">一年</option>
			              <option value="二年">二年</option>
			              <option value="三年">三年</option>
			       </select>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querycorporation();">查询</a>
			
		</div>
		
		<script type="text/javascript">
			
			//查询公司续费记录
			function querycorporation(){
				$("#datagrid").datagrid('load',{
					url:"manager/corporationRenewPage",
					deptNm:$("#deptNm").val(),
					renewTime:$("#renewTime").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querycorporation();
				}
			}
			
		</script>
	</body>
</html>
