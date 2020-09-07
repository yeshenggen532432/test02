<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/toKhlevelPage" title="客户等级列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="qdtpNm" width="280" align="center">
						客户类型名称
					</th>
					<th field="khdjNm" width="280" align="center">
						客户等级名称
					</th>
					<th field="_operater" width="380" align="center" formatter="formatterOper">
						操作
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			客户等级名称: <input name="khdjNm" id="khdjNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryKhlevel();">查询</a>
			<%--
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:setLevelPrice();">按客户等级设置商品销售价格</a>
			--%>
		</div>

		<script type="text/javascript">
			
			//查询客户等级
			function queryKhlevel(){
				$("#datagrid").datagrid('load',{
					url:"manager/toKhlevelPage",
					khdjNm:$("#khdjNm").val()
					
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryKhlevel();
				}
			}

			function formatterOper(val,row){
				var html = "<a href='javascript:;;' onclick='setWareTypeRate(\""+row.id+"\",\""+row.khdjNm+"\")'>设置商品类别价格折扣率<a/>";
				html+="&nbsp;|"+"<a href='javascript:;;' onclick='setWarePrice(\""+row.id+"\",\""+row.khdjNm+"\")'>设置商品价格<a/>";
				html+="&nbsp;|"+"<a href='javascript:;;' onclick='showCustomers(\""+row.id+"\",\""+row.khdjNm+"\")'>客户信息列表<a/>";
				return html;
			}
			function setWareTypeRate(id,name){
				window.parent.close(name+"_设置商品类别折扣率");
				window.parent.add(name+"_设置商品类别折扣率","${base}manager/customerlevelratewaretype?_sticky=v2&relaId="+id);
			}

			function setWarePrice(id,name){
				window.parent.close(name+"_设置商品价格");
				window.parent.add(name+"_设置商品价格","manager/toCustomerLevelSetWareTree?_sticky=v2&levelId="+id);
			}

			function showCustomers(id,name){
				window.parent.close(name+"_客户信息列表");
				window.parent.add(name+"_客户信息列表","manager/toCustomerLevelPage?khdjNm="+name);
			}


		</script>
	</body>
</html>
