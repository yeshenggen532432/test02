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
			url="manager/orderlsBbPage1?database=${database}" title="结算订单列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true">
			<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						结算订单id
					</th>
					<th field="orderId" width="50" align="center" hidden="true">
						订单id
					</th>
					<th field="isJs" width="50" align="center" hidden="true">
						isJs
					</th>
					<th field="orderNo" width="135" align="center">
						订单号
					</th>
					<th field="odate" width="135" align="center">
						结算时间
					</th>
					<th field="khNm" width="120" align="center" >
						客户名称
					</th>
					<th field="memberNm" width="100" align="center" >
						业务员名称
					</th>
					<th field="awJg" width="80" align="center" >
						A其他啤酒
					</th>
					<th field="bwJg" width="80" align="center" >
						B小商品
					</th>
					<th field="cwJg" width="80" align="center" >
						C化妆品
					</th>
					<th field="dwJg" width="80" align="center" >
						D衣服燕窝
					</th>
					<th field="ewJg" width="80" align="center" >
						E酵素
					</th>
					<th field="fwJg" width="80" align="center" >
						F乳液
					</th>
					<th field="allJg" width="80" align="center" >
						合计金额
					</th>
					<th field="zhJg" width="80" align="center" formatter="formatterSt">
						总回
					</th>
					<th field="lsJg" width="80" align="center" >
						旅社
					</th>
					<th field="dyJg" width="80" align="center" >
						导游
					</th>
					<th field="sjJg" width="80" align="center" >
						司机
					</th>
					<th field="qpJg" width="80" align="center" >
						全陪
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		      订单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		     客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员名称: <input name="memberNm" id="memberNm" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
			结算状态：<select name="isJs" id="isJs">
			             <option value="">全部</option>
			             <option value="结算">已结算</option>
			             <option value="未结算">未结算</option>
			        </select>
			结算时间: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 80px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 80px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
	        <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>
		</div>
		<div id="jiesuanDiv" class="easyui-window" style="width:400px;height:475px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/updateOrderBb" id="jiesuanFrm" name="jiesuanFrm" method="post">
				<input type="hidden" name="id" id="id"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				    <tr height="30px">
						<td align="center">
						   A其他啤酒：
							<input class="reg_input" name="awJg" id="awJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
				    <tr height="30px">
						<td align="center">
						   &nbsp;&nbsp;&nbsp;
						    B小商品：
							<input class="reg_input" name="bwJg" id="bwJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					<tr height="30px">
						<td align="center">
						    &nbsp;&nbsp;&nbsp;
						    C化妆品：
							<input class="reg_input" name="cwJg" id="cwJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
				    <tr height="30px">
						<td align="center">
						    D衣服燕窝：
							<input class="reg_input" name="dwJg" id="dwJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					<tr height="30px">
						<td align="center">
						   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						    E酵素：
							<input class="reg_input" name="ewJg" id="ewJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
				    <tr height="30px">
						<td align="center">
						   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						    F乳液：
							<input class="reg_input" name="fwJg" id="fwJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					 <tr height="30px">
						<td align="center">
						   &nbsp;&nbsp;
						    合计金额：
							<input class="reg_input" name="allJg" id="allJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					 <tr height="30px">
						<td align="center">
						   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						    总回：
							<input class="reg_input" name="zhJg" id="zhJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					 <tr height="30px">
						<td align="center">
						   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						    旅社：
							<input class="reg_input" name="lsJg" id="lsJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					 <tr height="30px">
						<td align="center">
						   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						    导游：
							<input class="reg_input" name="dyJg" id="dyJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					 <tr height="30px">
						<td align="center">
						   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						    司机：
							<input class="reg_input" name="sjJg" id="sjJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					 <tr height="30px">
						<td align="center">
						   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						    全陪：
							<input class="reg_input" name="qpJg" id="qpJg" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					<tr height="30px">
						<td align="center">
						   &nbsp;&nbsp;
						    是否已结：
							<input type="radio" name="isJs2" id="isJs1" value="结算"/>是
							<input type="radio" name="isJs2" id="isJs2" value="未结算" />否
							 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						    </td>
					</tr>
					<tr height="40px">
						<td align="center">
							<a class="easyui-linkbutton" href="javascript:addQdtype();">保存</a>
							<a class="easyui-linkbutton" href="javascript:hideRoleWin();">关闭</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>	
		<script type="text/javascript">
		    var database="${database}";
		    //查询物流公司
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/orderlsBbPage1?database="+database,
					khNm:$("#khNm").val(),
					orderNo:$("#orderNo").val(),
					memberNm:$("#memberNm").val(),
					isJs:$("#isJs").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
				}
			}
			function formatterSt(val,row){
			  if(row.isJs=='结算'){
			     return "<font color='blue'>"+val+"</font>";
			  }else{
			     return "<font color='red'>"+val+"</font>";
			  }
		    } 
		    //导出
			function myexport(){
			    var khNm=$("#khNm").val();
			    var orderNo=$("#orderNo").val();
			    var memberNm=$("#memberNm").val();
			    var isJs=$("#isJs").val();
			    var sdate=$("#sdate").val();
			    var edate=$("#edate").val();
				exportData('bscOrderlsService','queryOrderlsBbPage1','com.cnlife.qwb.model.BscOrderlsBb',"{khNm:'"+khNm+"',orderNo:'"+orderNo+"',memberNm:'"+memberNm+"',isJs:'"+isJs+"',sdate:'"+sdate+"',edate:'"+edate+"',database:'"+database+"'}","结算订单记录");
  			}
  			//获取选中行的值
			function getSelected(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
				    if(row.orderZt=='未审核'){
					    alert("该订单未审核不能结算");
					    return;
				    }
					$.ajax({
						url:"manager/getOrderBb2",
						data:"id="+row.id,
						type:"post",
						success:function(json){
							if(json){
							    $("#id").val(row.id);
								$("#awJg").val(json.awJg);
								$("#bwJg").val(json.bwJg);
								$("#cwJg").val(json.cwJg);
								$("#dwJg").val(json.dwJg);
								$("#ewJg").val(json.ewJg);
								$("#fwJg").val(json.fwJg);
								$("#allJg").val(json.allJg);
								$("#zhJg").val(json.zhJg);
								$("#lsJg").val(json.lsJg);
								$("#dyJg").val(json.dyJg);
								$("#sjJg").val(json.sjJg);
								$("#qpJg").val(json.qpJg);
								var isJs=json.isJs;
								if(isJs=='结算'){
								   document.getElementById("isJs1").checked=true;
								}else{
								   document.getElementById("isJs2").checked=true;
								}
								jiesuanWin("修改结算订");
							}
						}
					});
				}else{
					alert("请选择要结算的数据");
				}
			}
			function jiesuanWin(){
				$("#jiesuanDiv").window('close');
			}
			function jiesuanWin(title){
				$("#jiesuanDiv").window({title:title});
				$("#jiesuanDiv").window('open');
			}
			function addQdtype(){
			    $('#jiesuanFrm').form('submit', {
					success:function(data){
						$("#jiesuanDiv").window('close');
						if(data=="-1"){
							alert("修改结算订单失败");
					        return;
						}else{
						    alert("修改结算订单成功");
						    $('#datagrid').datagrid('reload');
						}
					}
				});
			}
		</script>
	</body>
</html>
