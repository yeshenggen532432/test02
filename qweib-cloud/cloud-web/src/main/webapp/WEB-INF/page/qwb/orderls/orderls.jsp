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
			url="manager/orderlsPage1?database=${database}" title="订单列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						订单id
					</th>
					<th field="oddate" width="135" align="center">
						订单时间
					</th>
					<th field="khNm" width="120" align="center" >
						客户名称
					</th>
					<th field="memberNm" width="100" align="center" >
						业务员名称
					</th>
					<th field="count" width="620" align="center" formatter="formatterSt">
						订单信息
					</th>
					<th field="orderZt" width="100" align="center" formatter="formatterSt2">
						订单状态
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员名称: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			订单时间: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	          订单状态: <select name="orderZt" id="orderZt">
	                    <option value="">全部</option>
	                    <option value="审核">审核</option>
	                    <option value="未审核">未审核</option>
	                </select>		  
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			<!--<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>-->
			<!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->
			<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:jiesuan();">结算</a>
		</div>
		<div id="jiesuanDiv" class="easyui-window" style="width:400px;height:300px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/updateOrderBbJg" id="jiesuanFrm" name="jiesuanFrm" method="post">
				<input type="hidden" name="orderId" id="orderId"/>
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
						    是否已结：
							<input type="radio" name="isJs" id="isJs1" value="结算" checked="checked"/>是
							<input type="radio" name="isJs" id="isJs2" value="未结算" />否
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
		<script type="text/javascript">
		    var database="${database}";
		    //查询物流公司
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/orderlsPage1?database="+database,
					khNm:$("#khNm").val(),
					memberNm:$("#memberNm").val(),
					orderZt:$("#orderZt").val(),
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
			//导出
			function myexport(){
			     exportData('sysBforderService','queryBforderPage','com.cnlife.qwb.model.SysBforder',"{khNm:'"+$("#khNm").val()+"',memberNm:'"+$("#memberNm").val()+"',database:'"+database+"',sdate:'"+$("#sdate").val()+"',edate:'"+$("#edate").val()+"'}","销售订单记录");
  			}
			function formatterSt(v,row){
				var hl='<table>';
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="170px;"><b>商品名称</b></td>';
			        hl +='<td width="90px;"><b>总回率</font></b></td>';
			        hl +='<td width="90px;"><b>旅社率</font></b></td>';
			        hl +='<td width="90px;"><b>导游率</font></b></td>';
			        hl +='<td width="90px;"><b>司机率</font></b></td>';
			        hl +='<td width="90px;"><b>全陪率</font></b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].wareNm+'</td>';
			        hl +='<td>'+row.list[i].zh+'</td>';
			        hl +='<td>'+row.list[i].ls+'</td>';
			        hl +='<td>'+row.list[i].dy+'</td>';
			        hl +='<td>'+row.list[i].sj+'</td>';
			        hl +='<td>'+row.list[i].qp+'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}
			function formatterSt2(val,row){
			  if(row.list.length>0){
			    if(val=='未审核'){
		            return "<input style='width:60px;height:27px' type='button' value='未审核' onclick='updateOrderSh(this, "+row.id+")'/>";
			     }else{
			        return val;   
			     }
			  }
		    } 
		    //修改审核
		    function updateOrderSh(_this,id){
				$.ajax({
					url:"manager/updateOrderlsSh",
					type:"post",
					data:"id="+id+"&sh=审核",
					success:function(data){
						if(data=='1'){
						    alert("操作成功");
							queryorder();
						}else{
							alert("操作失败");
							return;
						}
					}
				});
			 }
			 //导出成excel
		    function toLoadExcel(){
		        $('#orderNo2').val($('#orderNo').val());
				$('#khNm2').val($('#khNm').val());
				$('#memberNm2').val($('#memberNm').val());   
				$('#sdate2').val($('#sdate').val()); 
				$('#edate2').val($('#edate').val());
				$('#orderZt2').val($('#orderZt').val());  
				$('#pszd2').val($('#pszd').val()); 
				$('#loadfrm').form('submit',{
					success:function(data){
						alert(data);
					}
				});
			}
			//删除
		    function toDel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].orderZt=='审核'){
					   alert("该订单审核了，不能删除");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/deleteOrder",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
										showMsg("删除失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要删除的数据");
				}
			}
			//获取选中行的值
			function jiesuan(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
				    if(row.orderZt=='未审核'){
					    alert("该订单未审核不能结算");
					    return;
				    }
					$.ajax({
						url:"manager/getOrderBb",
						data:"id="+row.id,
						type:"post",
						success:function(json){
							if(json){
							    $("#orderId").val(row.id);
								$("#awJg").val(0);
								$("#bwJg").val(0);
								$("#cwJg").val(0);
								$("#dwJg").val(0);
								$("#ewJg").val(0);
								$("#fwJg").val(0);
								jiesuanWin("结算");
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
			    var awJg = $("#awJg").val();
				if(!awJg){
					alert("A其他啤酒不能为空");
					return;
				}
				var bwJg = $("#bwJg").val();
				if(!bwJg){
					alert("B小商品不能为空");
					return;
				}
				var cwJg = $("#cwJg").val();
				if(!cwJg){
					alert("C化妆品不能为空");
					return;
				}
				var dwJg = $("#dwJg").val();
				if(!dwJg){
					alert("D衣服燕窝不能为空");
					return;
				}
				var ewJg = $("#ewJg").val();
				if(!ewJg){
					alert("E酵素不能为空");
					return;
				}
				var fwJg = $("#fwJg").val();
				if(!fwJg){
					alert("F乳液不能为空");
					return;
				}
				$('#jiesuanFrm').form('submit', {
					success:function(data){
						$("#jiesuanDiv").window('close');
						if(data=="-1"){
							alert("结算失败");
					        return;
						}else{
						    alert("结算成功");
						    $('#datagrid').datagrid('reload');
						}
					}
				});
			}
		</script>
	</body>
</html>
