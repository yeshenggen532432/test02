<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员分页</title>
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
			   title="" iconCls="icon-save" border="false"
			   rownumbers="true" fitColumns="false" pagination="true"
			   pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" >
		</table>

		<div id="tb" style="padding:5px;height:auto">
			会员名称: <input name="name" id="name" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			  手机号: <input name="mobile" id="mobile" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			充值日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
					<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
					-
					<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
					<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>

			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</div>


		<%--js--%>
		<script type="text/javascript">
		    //查询会员
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/pos/queryPosMemberIo",
					name:$("#name").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					mobile:$("#mobile").val(),
					ioFlag:1,
				});
			}

			initGrid();
			function initGrid(){
				var cols = new Array();
				var col = {
					field: 'id',
					title: 'id',
					width: 50,
					align:'center',
					hidden:'true'
				};
				cols.push(col);

				var col = {
					field: 'ioTimeStr',
					title: '充值时间',
					width: 135,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'name',
					title: '会员名称',
					width: 100,
					align:'center'

				};
				cols.push(col);
				var col = {
					field: 'mobile',
					title: '会员电话',
					width: 100,
					align:'center'
				};
				cols.push(col);

				var col = {
					field: 'inputCash',
					title: '充值金额',
					width: 80,
					align:'center',
					formatter:amtformatter
				};
				cols.push(col);
				var col = {
					field: 'freeCost',
					title: '赠送金额',
					width: 80,
					align:'center',
					formatter:amtformatter
				};
				cols.push(col);
				var col = {
					field: 'cashPay',
					title: '现金支付',
					width: 80,
					align:'center',
					formatter:amtformatter
				};
				cols.push(col);
				var col = {
					field: 'bankPay',
					title: '银行卡支付',
					width: 80,
					align:'center',
					formatter:amtformatter
				};
				cols.push(col);
				var col = {
					field: 'wxPay',
					title: '微信支付',
					width: 80,
					align:'center',
					formatter:amtformatter
				};
				cols.push(col);
				var col = {
					field: 'zfbPay',
					title: '支付宝',
					width: 100,
					align:'center',
					formatter:amtformatter
				};
				cols.push(col);

				$('#datagrid').datagrid({
					url:"manager/pos/queryPosMemberIo",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						mobile:$("#mobile").val(),
						name:$("#name").val(),
						ioFlag:1
					},
					columns:[
						cols
					]}
				);
			}

			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}

			//微信支付，支付宝支付等等
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
		</script>
	</body>
</html>
