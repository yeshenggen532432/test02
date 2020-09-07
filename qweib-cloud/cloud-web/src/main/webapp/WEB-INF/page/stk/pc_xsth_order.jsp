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
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/queryThOrderDatas?database=${database}&dataTp=${dataTp }" title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						订单id
					</th>
					<th field="orderNo" width="135" align="center">
						退货单号
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
						退货时间
					</th>
					<th field="khNm" width="100" align="center" >
						客户名称
					</th>
					<th field="memberNm" width="80" align="center" >
						业务员名称
					</th>
					<th field="count" width="520" align="center" formatter="stkwillout" hidden="true">
						商品信息
					</th>
					<th field="zje" width="60" align="center",formatter="amtformatter" >
						总金额
					</th>
					<th field="cjje" width="60" align="center",formatter="amtformatter" >
						退货金额
					</th>
					<th field="orderZt" width="75" align="center" formatter="formatterSt2">
						订单状态
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
		<div id="tb" style="padding:5px;height:auto">
		<div style="margin-bottom:5px">
		 <tag:permission name="销售退货" image="icon-add" onclick="javascript:newXsthBill();"   buttonCode="stk.stkThIn.createth"></tag:permission>
		 <tag:permission name="历史退货" image="icon-add" onclick="javascript:hisBill();"   buttonCode="stk.stkThIn.historybill"></tag:permission>
		 <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toZf();">作废</a>
		 <%--
		<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newXsthBill();">销售退货</a>
		<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:hisBill();">历史退货</a>
		<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toZf();">作废</a>
		 --%>
		</div>
		<div>
		     订单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员名称: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			退货日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         显示商品信息:<input type="checkbox"  id="showWareCheck" name="showWareCheck" onclick="queryorder()" value="1"/>  		  
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
		</div>	
		</div>
		<div>
		  	<form action="manager/orderExcel" name="loadfrm" id="loadfrm" method="post">
		  		<input type="text" name="orderNo2" id="orderNo2"/>
				<input type="text" name="khNm2" id="khNm2"/>
				<input type="text" name="memberNm2" id="memberNm2"/>
				<input type="text" name="sdate2" id="sdate2"/>
				<input type="text" name="edate2" id="edate2"/>
				<input type="text" name="orderZt2" id="orderZt2"/>
				<input type="text" name="pszd2" id="pszd2"/>
		  	</form>
	  	</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
		    //查询物流公司
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryThOrderDatas?database="+database,
					jz:"1",
					orderNo:$("#orderNo").val(),
					khNm:$("#khNm").val(),
					memberNm:$("#memberNm").val(),
					wareNm:$("#wareNm").val(),
					//orderZt:$("#orderZt").val(),
					//pszd:$("#pszd").val(),
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
			function stkwillout(v,row,index){
				var hl='<table>';
				
				if(row.list.length>0){
					if(index==0){
						 hl +='<tr>';
					        hl +='<td width="120px;"><b>商品名称</b></td>';
					        hl +='<td width="80px;"><b>销售类型</b></td>';
					        hl +='<td width="60px;"><b>单位</font></b></td>';
					        hl +='<td width="80px;"><b>规格</font></b></td>';
					        hl +='<td width="60px;"><b>数量</font></b></td>';
					        hl +='<td width="60px;"><b>单价</font></b></td>';
					        hl +='<td width="60px;"><b>总价</font></b></td>';
					        hl +='</tr>';
					}
		        }
				var color="style='background:#f5f5f5;font:normal 11px Microsoft YaHei;'";
		        for(var i=0;i<row.list.length;i++){
		        	if(i%2==0){
		        		color="style='background:#f5f5f5;font:normal 11px Microsoft YaHei;'"
		        	}else{
		        		color="style='font-size:12px;font:normal 11px Microsoft YaHei'";
		        	}
		            hl +='<tr '+color+'>';
			        hl +='<td width="120px;" height="25px">'+row.list[i].wareNm+'</td>';
			        hl +='<td width="80px;">'+row.list[i].xsTp+'</td>';
			        hl +='<td width="60px;">'+row.list[i].wareDw+'</td>';
			        hl +='<td width="80px;">'+row.list[i].wareGg+'</td>';
			        hl +='<td width="60px;">'+row.list[i].wareNum+'</td>';
			        hl +='<td width="60px;">'+row.list[i].wareDj+'</td>';
			        hl +='<td width="60px;">'+row.list[i].wareZj+'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
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
			
			function formatterSt2(val,row){
			  if(row.list.length>0){
			    if(val=='未审核'){
		            return "<input style='width:60px;height:27px' type='button' value='未审核' onclick='updateOrderSh(this, "+row.id+")'/>";
			     }else{
			        return val;   
			     }
			  }
		    } 
			
			  //销售退货
		    function newXsthBill()
			{
				parent.add('销售退货开单','manager/pcxsthin');
			}
		    //修改审核
		    function updateOrderSh(_this,id){
		      $.messager.confirm('确认', '您确认要审核吗？', function(r) {
			  if (r) {
				$.ajax({
					url:"manager/updateOrderSh",
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
			//作废
		    function toZf() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].orderZt=='未审核'){
					   alert("该订单未审核，不能作废");
					   return;
					}
					if(rows[i].orderZt=='已作废'){
					   alert("该订单已作废，不能再作废");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要作废该记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/thorder/updateOrderZf",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
										showMsg("作废失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要作废的数据");
				}
			}
			
		    function newOtherBill()
			{
				parent.add('其它出库开单','manager/pcotherstkout');
			}
		    function hisBill()
			{
				parent.add('历史退货','manager/queryStkXsThInPage');
			}
			
		    function onDblClickRow(rowIndex, rowData) { 
		    	parent.add('销售退货开单','manager/pcstkthin?orderId='+rowData.id);
		    }
		</script>
	</body>
</html>
