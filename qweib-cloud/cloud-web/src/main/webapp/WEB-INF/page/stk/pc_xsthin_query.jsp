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
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
		<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						出库单id
					</th>
					<th field="billNo" width="135" align="center">
						单号
					</th>

					<th field="inDate" width="80" align="center">
						入库日期
					</th>
					<th field="inType" width="80" align="center">
						入库类型
					</th>

					<th field="proName" width="100" align="center" >
						往来单位
					</th>
					<th field="memberNm" width="80" align="center" >
						业务员名称
					</th>
					<th field="count" width="400" align="center" formatter="formatterSt">
						商品信息
					</th>



				</tr>
			</thead>
		</table>

		<div id="tb" style="padding:5px;height:auto">
		<div style="margin-bottom:5px">
		 <tag:permission name="销售退货" image="icon-add" onclick="javascript:newXsthBill();"   buttonCode="stk.stkThIn.createth"></tag:permission>
		 <tag:permission name="查看" image="icon-add" onclick="javascript:showInfo();"   buttonCode="stk.stkThIn.show"></tag:permission>
		 <tag:permission name="作废" image="icon-add" onclick="javascript:newXsthBill();"   buttonCode="stk.stkThIn.cancel"></tag:permission>

			<a class="easyui-linkbutton" plain="true"
			   style="display: ${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_ORDER_AUTO_CREATE_TH\'  and status=1')}"
			iconCls="icon-search" href="javascript:queryPendThOrderPage();">待处理退货订单</a>
		 <%--
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newXsthBill();">销售退货开单</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:showInfo();">查看</a>
			<a id = "cancelBtn" class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toZf();">作废</a>
		--%>
		</div>
		<div>
		     单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			往来单位: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员名称: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			入库日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         发票状态: <select name="orderZt" id="billStatus">
	                    <option value="">全部</option>
	                    <option value="暂存">暂存</option>
	                    <option value="已收货">已收货</option>
	                    <option value="未收货">未收货</option>
	                    <option value="作废">作废</option>
	                </select>
	          显示商品信息:<input type="checkbox"  id="showWareCheck" name="showWareCheck" onclick="queryorder()" value="1"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>

			<!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->
			<!--<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toLoadExcel();">导出</a>-->
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
			$("#billStatus").val("${billStatus}");
		    initGrid();
		    function initGrid()
		    {

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
							field: 'status',
							title: 'status',
							width: 50,
							align:'center',
							hidden:'true'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '单号',
							width: 135,
							align:'center'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'inDate',
							title: '入库日期',
							width: 100,
							align:'center'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'inType',
							title: '入库类型',
							width: 80,
							align:'center'

					};
		    	    cols.push(col);

		    	    var col = {
							field: 'proName',
							title: '往来单位',
							width: 100,
							align:'center'

					};
		    	    cols.push(col);

		    	    var col = {
							field: 'empNm',
							title: '业务员',
							width: 80,
							align:'center'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'count',
							title: '商品信息',
							width: 400,
							align:'center',
							formatter:formatterSt


					};
		    	    cols.push(col);

					var col = {
							field: 'totalAmt',
							title: ' 合计金额',
							width: 60,
							align:'center',
							formatter:amtformatter

					};
					cols.push(col);
					var col = {
							field: 'disAmt',
							title: '发票金额',
							width: 60,
							align:'center',
							formatter:amtformatter

					};
					cols.push(col);

					var col = {
							field: 'payAmt',
							title: '已付金额',
							width: 60,
							align:'center',
							formatter:amtformatter

					};
					cols.push(col);
					var col = {
							field: 'freeAmt',
							title: '核销金额',
							width: 60,
							align:'center',
							formatter:amtformatter

					};
					cols.push(col);
		    	    var col = {
							field: 'billStatus',
							title: '单据状态',
							width: 60,
							align:'center'

					};
		    	    cols.push(col);

		    	    var col = {
							field: 'remarks',
							title: '备注',
							width: 200,
							align:'center'

					};
		    	    cols.push(col);
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkXsThInPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							proName:$("#proName").val(),
							memberNm:$("#memberNm").val(),
							billStatus:$("#billStatus").val(),
							inType:"销售退货",
							sdate:$("#sdate").val(),
							edate:$("#edate").val()

			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    //$('#datagrid').datagrid('reload');
		    	     if($('#showWareCheck').is(':checked')) {
						$('#datagrid').datagrid('showColumn','count');
					}else{
						$('#datagrid').datagrid('hideColumn','count');
					}
			}
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkXsThInPage?database="+database,
					jz:"1",
					billNo:$("#orderNo").val(),
					proName:$("#proName").val(),
					memberNm:$("#memberNm").val(),
					billStatus:$("#billStatus").val(),
					iinType:"销售退货",
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
				 if($('#showWareCheck').is(':checked')) {
						$('#datagrid').datagrid('showColumn','count');
					}else{
						$('#datagrid').datagrid('hideColumn','count');
					}
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
			     exportData('StkInService','stkInPage','com.cnlife.stk.model.StkIn',"{proName:'"+$("#proName").val()+"',memberNm:'"+$("#memberNm").val()+"',database:'"+database+"',sdate:'"+$("#sdate").val()+"',edate:'"+$("#edate").val()+"'}","入库单记录");
  			}
			function formatterSt(v,row){
				if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
				var hl='<table>';
				var rowIndex = $("#datagrid").datagrid("getRowIndex",row);
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>商品名称</b></td>';

			        hl +='<td width="60px;"><b>单位</font></b></td>';
			        hl +='<td width="80px;"><b>规格</font></b></td>';
			        hl +='<td width="60px;"><b>数量</font></b></td>';
			        hl +='<td width="60px;"><b>单价</font></b></td>';
			        hl +='<td width="60px;"><b>总价</font></b></td>';
			        hl +='<td width="60px;"><b>已收数量</font></b></td>';
			        hl +='<td width="60px;"><b>未收数量</font></b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].wareNm+'</td>';

			        hl +='<td>'+row.list[i].unitName+'</td>';
			        hl +='<td>'+row.list[i].wareGg+'</td>';
			        hl +='<td>'+row.list[i].qty+'</td>';
			        hl +='<td>'+row.list[i].price+'</td>';
			        hl +='<td>'+toThousands(row.list[i].amt) +'</td>';
			        hl +='<td>'+row.list[i].inQty+'</td>';
			        hl +='<td>'+row.list[i].inQty1+'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}



			function amtformatter(v,row)
			{
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}


			function toPay(){
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].billStatus!='已审'){
					   alert("该订单未审核，不可支付");
					   return;
					}
				}
				if(ids.length > 1)
					{
						alert("只能选择一张入库单");
						return;
					}
				window.location.href='${base}/manager/stkpay?billId=' + ids[0];
			}
			function freePay()
			{
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].billStatus!='已审'){
					   alert("该订单未审核，不可支付");
					   return;
					}
				}
				if(ids.length > 1)
					{
						alert("只能选择一张入库单");
						return;
					}
				var amt = rows[0].disAmt - rows[0].payAmt - rows[0].freeAmt;
				if(amt<= 0)
					{
						alert("该单已支付完成，不需要核销");
						return;
					}
				var msg = "核销金额" + amt + ",是否确定枋销?";
				$.messager.confirm('确认', msg, function(r) {
					if (r) {
						$.ajax( {
							url : "manager/updateFreeAmt",
							data : "billId=" + ids,
							type : "post",
							success : function(json) {
								if (json.state) {
									showMsg("核销成功");
									$("#datagrid").datagrid("reload");
								} else{
									showMsg("核销失败");
								}
							}
						});
					}
				});

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
					if(rows[i].orderZt=='已审'){
					   alert("该单不能删除");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/deleteStkIn",
								data : "ids=" + ids,
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									} else{
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
			function showInfo()
			{
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);

				}
				if(ids.lenth > 1)
					{
					 	alert("只能选择一条记录");
					 	return;
					}
				if(ids.length == 0)
					{
					alert("请选择要查看的记录");
				 	return;
					}
				parent.closeWin('采购入库'  + ids[0]);
				parent.add('采购入库'  + ids[0],'manager/showstkin?dataTp=1&billId=' + ids[0]);
			}

			function showCheck()
			{
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);


				}
				if(ids.lenth > 1)
					{
					 	alert("只能选择一条记录");
					 	return;
					}
				if(ids.length == 0)
					{
					alert("请选择要查看的记录");
				 	return;
					}
				/*if(rows[0].billStatus == "已审")
					{
						alert("该单据已经审核");
						return;
					}*/
					parent.closeWin('采购入库审核' + ids[0]);
				parent.add('采购入库审核' + ids[0],'manager/showstkincheck?dataTp=1&billId=' + ids[0]);
			}
			//作废
		    function toZf() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].status!= 0){
					   alert("该订单不能作废");
					   return;
					}

				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要作废该记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/cancelProc",
								data : "billId=" + ids[0],
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else  {
										showMsg("作废失败" + json.msg);
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要作废的数据");
				}
			}


			function onDblClickRow(rowIndex, rowData)
		    {

					parent.closeWin('销售退货单信息' + rowData.id);
					parent.add('销售退货单信息' + rowData.id,'manager/showstkin?dataTp=1&billId=' + rowData.id);

		    }
			  //销售退货
		    function newXsthBill()
			{
				parent.add('销售退货开单','manager/pcxsthin');
			}

			function toThousands(num1) {

				if(num1 == null)return "";
				if(num1=="0E-7"){
					return "0.00";
				}
				if (num1 != null) {
					return numeral(num1).format("0,0.00");
				}

			}

			function queryPendThOrderPage() {
				parent.closeWin("销售退货订单列表");
				parent.add("销售退货订单列表", "manager/queryPendThOrderPage?dataTp=0");
			}

		</script>
	</body>
</html>
