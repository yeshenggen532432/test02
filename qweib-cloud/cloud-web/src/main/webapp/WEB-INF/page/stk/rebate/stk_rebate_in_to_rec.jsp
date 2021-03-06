<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
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
		<table id="datagrid"  fit="true" singleSelect="false"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
		<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						出库单id
					</th>
					<th field="billNo" width="135" align="center">
						发票单号
					</th>

					<th field="inDate" width="80" align="center">
						发票日期
					</th>
					<th field="proName" width="100" align="center" >
						供应商
					</th>

				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     单号: <input name="billNo" id="billNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			往来单位: <input name="proName" id="proName" value="${proName}" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>

			单据日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" readonly="readonly" value="${sdate}"  style="width: 100px;"  />
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif"  width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();"  readonly="readonly" style="width: 100px;" value="${edate}" />
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	  		单据状态: <select name="status" id="status">
      					<option value="">全部</option>
	                    <option value="-2">暂存</option>
	                    <option value="1">已审批</option>
	                     <option value="2">作废</option>
	                </select>
	  		收款状况: <select name="payStatus" id="payStatus">
                   <option value="未收款">未收款</option>
                   <option value="">全部</option>
                   <option value="已收款">已收款</option>
               </select>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:showRecHisList();">收款记录</a>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:toBatchPay();">批量收款</a>
		</div>

	  	<div id="dlg" closed="true" class="easyui-dialog" title="核销" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						freePay();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
		核销金额: <input name="freeAmt" id="freeAmt" style="width:120px;height: 20px;"/>
		<br/>
		费用科目: <input name="itemName" id="itemName" readonly="readonly" style="width:120px;height: 20px;"/> <a href="javascript:;;" onclick="dialogCostType()">选择</a>
		<input type="hidden" name="costId" id="costId" style="width:120px;height: 20px;"/>

		<br/>
		备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注: <textarea rows="4" cols="45"  name="hxRemark" id="hxRemark"></textarea>
		<input type="hidden" id="chooseId" value="0"/>
	</div>

	<c:set var="datas" value="${fns:loadListByParam('fin_income_item','id,item_name','mark=1')}"/>
	<c:forEach items="${datas}" var="map" varStatus="s">
		<c:if test="${s.index eq 0 }">
			<script type="text/javascript">
			$("#costId").val("${map['id']}");
			$("#itemName").val("${map['item_name']}");
			</script>
		</c:if>
	</c:forEach>

	<div id="accDlg" closed="true" class="easyui-dialog" title="批量收款" style="width:300px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						batchPay();
					}
				},{
					text:'取消',
					handler:function(){
						$('#accDlg').dialog('close');
					}
				}]
			">
		收款账号: <tag:select name="accId" id="accId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="acc_name"/>
		备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注: <textarea rows="4" cols="40"  name="remarks" id="remarks"></textarea>
	</div>

	<div id="costTypeDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="费用科目选择" iconCls="icon-edit">
     </div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    initGrid();
		    function initGrid()
		    {
		    	    var cols = new Array();
		    	    var col = {
							   field : 'ck',
				               checkbox : true
						};
			    	    cols.push(col);
		    	    var col = {
							field: 'id',
							title: 'id',
							width: 50,
							align:'center',
							hidden:'true'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '返利单号',
							width: 135,
							align:'center',
							formatter:formatterEvent

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'inDate',
							title: '单据日期',
							width: 120,
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
							field: 'disAmt',
							title: '返利金额',
							width: 60,
							align:'center',
							formatter:amtformatter

					};
		    	    cols.push(col);

			    	    var col = {
								field: 'payAmt',
								title: '已收金额',
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
								field: 'needPay',
								title: '未收金额',
								width: 60,
								align:'center',
								formatter:amtformatter

						};
			    	    cols.push(col);
			    	   var col = {
								field: 'status',
								title: '单据状态',
								width: 60,
								align:'center',
								formatter:amtformatterStatus

						};
			    	    cols.push(col);

		    	    var col = {
							field: 'payStatus',
							title: '收款状态',
							width: 60,
							align:'center'

					};
		    	    cols.push(col);

		    	    var col = {
							field: '_operator',
							title: '操作',
							width: 100,
							align:'center',
							formatter:formatterSt3


					};
		    	    cols.push(col);

		    	    var sts = $("#payStatus").val();
			    	var isPay = -1;
			    	if(sts == "已收款")isPay = 1;
			    	if(sts == "未收款")isPay = 0;
			    	if(sts == "作废")isPay = 2;
			    	if(sts == "需退款")needRtn = 1;

		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkRebateIn/stkRebateInForRecPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#billNo").val(),
							proName:$("#proName").val(),
							isPay:isPay,
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							status:$("#status").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    $('#datagrid').datagrid('reload');
			}

			function queryorder(){
				var sts = $("#payStatus").val();
		    	var isPay = -1;
		    	if(sts == "已收款")isPay = 1;
		    	if(sts == "未收款")isPay = 0;
		    	if(sts == "作废")isPay = 2;
				$("#datagrid").datagrid('load',{
					url:"manager/stkRebateIn/stkRebateInForRecPage",
					jz:"1",
					billNo:$("#billNo").val(),
					proName:$("#proName").val(),
					isPay:isPay,
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					status:$("#status").val()
				});
			}

			 function formatterEvent(v,row){
				 return '<a href="javascript:;;" onclick="showSourceBill('+row.id+')">'+v+'</a>';
			 }
		    function showSourceBill(sourceBillId){
				parent.closeWin('采购返利信息' + sourceBillId);
		    	parent.add('采购返利信息' + sourceBillId,'manager/stkRebateIn/show?dataTp=1&billId=' + sourceBillId);
			 }

		    function amtformatterStatus(v,row){
		    	if(v==-2){
		    		return "暂存";
		    	}
		    	if(v==1){
		    		return "已审批";
		    	}
		    	if(v==2){
		    		return "已作废";
		    	}
		    }

			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
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
			function toPay(billId){
				var rows = $("#datagrid").datagrid("getRows");
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id != billId)continue;
					if(rows[i].billStatus == "作废")
						{
							alert("该单据已经作废");
							return;
						}

				}
				window.location.href='${base}/manager/stkrec?billId=' + billId;
			}

			function toFreePay(billId)
			{
				var rows = $("#datagrid").datagrid("getRows");
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id != billId)continue;
					if(rows[i].billStatus == "作废")
					{
						alert("该单据已经作废");
						return;
					}
					$("#freeAmt").val(rows[i].needPay);
					$("#chooseId").val(billId);

				}
				$('#dlg').dialog('open');
			}

			function freePay()
			{

				var billId = $("#chooseId").val();
				var rows = $("#datagrid").datagrid("getRows");
				var amt = 0;
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id!= billId)continue;
					amt = rows[0].disAmt - rows[0].payAmt - rows[0].freeAmt;
				}

				if(amt<= 0)
					{
						alert("该单已支付完成，不需要核销");
						return;
					}
				var freeAmt = $("#freeAmt").val();
				var hxRemark = $("#hxRemark").val();
				var costId = $("#costId").val();
				var msg = "是否确定核销?";
				$.messager.confirm('确认', msg, function(r) {
					if (r) {
						$.ajax( {
							url : "manager/updateOutFreeAmt",
							data : "billId=" + billId + '&freeAmt=' + freeAmt+"&remarks="+hxRemark+"&costId="+costId,
							type : "post",
							success : function(json) {
								if (json.state) {
									showMsg("核销成功");
									$('#dlg').dialog('close');
									$("#datagrid").datagrid("reload");
								} else{
									showMsg("核销失败" + json.msg);
								}
								$("#hxRemark").val("");
							}
						});
					}
				});

			}


			function onDblClickRow(rowIndex, rowData)
		    {

		    }

		    function showRecList(billId)
		    {
		    	parent.closeWin('收款记录' + billId);
		    	parent.add('收款记录' + billId,'manager/queryRecPageByBillId?outType=2&dataTp=1&billId=' + billId);
		    }
		    function showRecHisList()
		    {
		    	parent.closeWin('收款记录');
		    	parent.add('收款记录','manager/queryRecPageByBillId?outType=2&dataTp=1');
		    }
			function formatterSt3(val,row){
				if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
				if(row.status==-2){
					return "";
				}
				if(row.status==2){
					return "<input style='width:60px;height:27px' type='button' value='复制' onclick='copy("+row.id+")'/>";
				}
				var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='showRecList("+row.id+")'/>";
				ret += "<br/><input style='width:60px;height:27px' type='button' value='收款' onclick='toRec("+row.id+")'/>";
				//ret +="<br/><input style='width:60px;height:27px' type='button' value='核销' onclick='toFreePay("+row.id+")'/>";
      	        return ret;

		   }

			function copy(billId){
				$.messager.confirm('确认', '是否确定复制?',function(r){
					if(r){
						parent.closeWin('复制采购返利单');
			    		parent.add('复制采购返利单','manager/stkRebateIn/copy?billId=' + billId);
					}});
			}

		   function toRec(billId){

				var rows = $("#datagrid").datagrid("getRows");
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id != billId)continue;
					if(rows[i].billStatus == "作废")
						{
							alert("作废单据不能收款");
							return;
						}
				}
				parent.closeWin('返利收款' + billId);
		    	parent.add('返利收款' + billId,'manager/stkRebateIn/toRecRebetaIn?billId=' + billId);
			}

			function dialogCostType(){
		    	$('#costTypeDlg').dialog({
		            title: '选择费用科目',
		            iconCls:"icon-edit",
		            width: 800,
		            height: 400,
		            modal: true,
		            href: "<%=basePath %>/manager/toDialogCostType",
		            onClose: function(){
		            }
		        });
		    	$('#costTypeDlg').dialog('open');
		  }
		  function onClickRow1(index, row){
				queryItem(row.id);
			}
			function queryItem(typeId){
				$("#itemgrid").datagrid('load',{
					url:"<%=basePath%>/manager/queryCostItemList",
					typeId:typeId
				});
			}
			function dialogCostOnDblClickRow(index, row){
				$("#costId").val(row.id);
				$("#itemName").val(row.itemName);
				$('#costTypeDlg').dialog('close');
			}

			 function toBatchPay()
				{
					$('#accDlg').dialog('open');
				}
			 function batchPay(){
				    var ids = "";
					var rows = $("#datagrid").datagrid("getSelections");
					for ( var i = 0; i < rows.length; i++) {
						if(ids!=""){
							ids = ids +",";
						}
						ids += rows[i].id;
					}
					if(ids==""){
						alert("请选择发票单据!");
						return;
					}
					var accId = $("#accId").val();
					if(accId==""){
						alert("请选择收款账号");
						return;
					}
					var remarks = $("#remarks").val();
					$.messager.confirm('确认', '您确认批量收款吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/stkRebateIn/batchRebateInRec",
								data : "ids=" + ids+"&accId="+accId+"&remarks="+remarks,
								type : "post",
								success : function(json) {
									if (json.state) {
										alert(json.msg);
										 $("#accId").val("");
										 $("#remarks").val("");
										$("#datagrid").datagrid("reload");
									} else {
										alert(json.msg);
									}
									 $('#accDlg').dialog('close');
								}
							});
						}
					});
					 $('#accDlg').dialog('close');

			  }

		</script>

	</body>
</html>
