<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>驰用T3</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/willOutPage?dataTp=${dataTp }" title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]"  toolbar="#mytoolbar" data-options="onDblClickRow: parent.setValueFromOrder">
			<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						订单id
					</th>
					<th field="orderNo" width="135" align="center">
						订单号
					</th>
					<th field="pszd" width="100" align="center">
						配送指定
					</th>
					<th field="oddate" width="80" align="center">
						下单日期
					</th>
					<th field="odtime" width="80" align="center">
						时间
					</th>
					<th field="shTime" width="120" align="center">
						送货时间
					</th>
					<th field="khNm" width="100" align="center" >
						客户名称
					</th>
					<th field="memberNm" width="80" align="center" >
						业务员名称
					</th>
					<th field="zje" width="60" align="center",formatter="amtformatter" >
						总金额
					</th>
					<th field="zdzk" width="60" align="center",formatter="amtformatter" >
						整单折扣
					</th>
					<th field="cjje" width="60" align="center",formatter="amtformatter" >
						成交金额
					</th>
					<th field="remo" width="200" align="center" >
						备注
					</th>
					<th field="shr" width="80" align="center" >
						收货人
					</th>
					<th field="tel" width="100" align="center" >
						电话
					</th>
					<th field="address" width="275" align="center" >
						地址
					</th>
				</tr>
			</thead>
		</table>
		<div id="mytoolbar" style="padding:5px;height:auto">
		<div style="margin-bottom:5px">   
		</div>
		<div>
		    &nbsp;订单号: <input name="orderNo" id="orderNo" style="width:120px;" onkeydown="toQuery(event);"/>
			客户: <input name="khNm" id="khNm" style="width:80px;" value="${khNm}" onkeydown="toQuery(event);"/>
			业务: <input name="memberNm" id="memberNm" style="width:60px;;" onkeydown="toQuery(event);"/>
			日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 70px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="<%=basePath %>/resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 70px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="<%=basePath %>/resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
					  <a class="easyui-linkbutton" iconCls="icon-search" plain="true"  href="javascript:querydata();">查询</a>
		</div>	
		</div>
		<script type="text/javascript">
			function querydata(){
				$("#datagrid").datagrid('load',{
					url:"<%=basePath %>/manager/willOutPage",
					jz:"0",
					orderNo:$("#orderNo").val(),
					khNm:$("#khNm").val(),
					memberNm:$("#memberNm").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			}
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querydata();
				}
			}
			
			function amtformatter(v,row)
			{
				if(v==""){
					return "";
				}
				if(v=="0E-7"){
					return "0.00";
				}
				if (row != null) {
                    return numeral(v).format("0,0.00");
                } 
			}
			querydata();
		</script>
	</body>
</html>
