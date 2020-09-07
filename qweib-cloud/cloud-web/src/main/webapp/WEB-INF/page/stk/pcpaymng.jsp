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
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow,onSelect: onSelect,onUnselect:onUnselect,onCheckAll:onCheckAll,onUncheckAll:onUnCheckAll,onLoadSuccess:loadData">
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
		     发票单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			供应商名称: <input name="proName" id="proName" value="${proName}" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			
			发票日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="true" />
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" readonly="true" value="${edate}" />
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	  		入库类型: <select name="inType" id="inType">
	                    <option value="">全部</option>
	                    <option value="采购入库">采购入库</option>
	                    <option value="其它入库">其它入库</option>
	                    <option value="采购退货">采购退货</option>
	                    <option value="销售退货">销售退货</option>
	                </select>	  		        
	        付款状况: <select name="orderZt" id="payStatus">
	                    <option value="未付款">未付款</option>
	                    <option value="">全部</option>
	                    <option value="已付款">已付款</option>
	                   <option value="作废">作废</option>
	                </select>
			发票金额范围:<input name="beginAmt" id="beginAmt" onkeyup="CheckInFloat(this)" style="width:60px;" />
			到<input name="endAmt" onkeyup="CheckInFloat(this)" id="endAmt" style="width:60px;" />
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			<br/>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:showInfo();">查看发票</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:showPayStat();">付款统计</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:showNeedPayStat();">应付款统计</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:showPayHisList();">付款记录</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:toBatchPay();">批量付款</a>
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
		核销日期: <input name="payTime" id="payTime"  onClick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm'});" value="${payTime}" style="width: 120px;"  readonly="readonly"/>
		<br/>
		费用科目: <input name="itemName" id="itemName" readonly="readonly" style="width:120px;height: 20px;"/> <a href="javascript:;;" onclick="dialogCostType()">选择</a>
		<input type="hidden" name="costId" id="costId" style="width:120px;height: 20px;"/>
		<br/>
		备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注: <textarea rows="4" cols="45"  name="hxRemark" id="hxRemark"></textarea>
		<input type="hidden" id="chooseId" value="0"/>
	</div>
	
	<c:set var="datas" value="${fns:loadListByParam('fin_income_item','id,item_name','item_name=\"核销未付款项\"')}"/>
	<c:forEach items="${datas}" var="map" varStatus="s">
		<c:if test="${s.index eq 0 }">
			<script type="text/javascript">
			$("#costId").val("${map['id']}");
			$("#itemName").val("${map['item_name']}");
			</script>
		</c:if>
	</c:forEach>
	
	<div id="costTypeDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="费用科目选择" iconCls="icon-edit">
	
	<div id="paydlg" closed="true" class="easyui-dialog"  maximized="true" title="付款单" style="width:600px;height:400px;padding:10px">
			<iframe  name="payfrm" id="payfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
     </div>
     <div id="accDlg" closed="true" class="easyui-dialog" title="批量付款" style="width:300px;height:200px;padding:10px"
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
		付款账号: <tag:select name="accId" id="accId" tableName="fin_account" headerKey="" whereBlock="status=0" headerValue="--请选择--" displayKey="id" displayValue="acc_name"/>
		备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注: <textarea rows="4" cols="40"  name="remarks" id="remarks"></textarea>
	</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
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
							field: 'proId',
							title: 'proId',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '发票单号',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'inDate',
							title: '发票日期',
							width: 120,
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
							title: '付款对象',
							width: 100,
							align:'center'
											
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
			    	    /* var col = {
								field: 'disAmt1',
								title: '实际入库金额',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);*/
			    	    

			    	    var col = {
								field: 'payAmt',
								title: '已付款',
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
								title: '未付金额',
								width: 60,
								align:'center',
								formatter:amtformatter
												
						};
			    	    cols.push(col);
		    	    var col = {
							field: 'billStatus',
							title: '收货状态',
							width: 60,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'payStatus',
							title: '付款状态',
							width: 60,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: '_operator',
							title: '操作',
							width: 200,
							align:'center',
							formatter:formatterSt3
							
											
					};
		    	    cols.push(col);

		    	    var sts = $("#payStatus").val();
					var inType = $("#inType").val();
			    	var isPay = -1;
			    	if(sts == "已付款")isPay = 1;
			    	if(sts == "未付款")isPay = 0;
			    	if(sts == "作废")isPay = 2;
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkInForPayPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							proName:$("#proName").val(),					
							isPay:isPay,
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							beginAmt:$("#beginAmt").val(),
							endAmt:$("#endAmt").val(),
							inType:inType+""
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    $('#datagrid').datagrid('reload'); 
			}
		    //查询物流公司
			function queryorder(){
				var sts = $("#payStatus").val();
				var inType = $("#inType").val();
		    	var isPay = -1;
		    	if(sts == "已付款")isPay = 1;
		    	if(sts == "未付款")isPay = 0;
		    	if(sts == "作废")isPay = 2;
				$("#datagrid").datagrid('load',{
					url:"manager/stkInForPayPage?database="+database,
					jz:"1",
					billNo:$("#orderNo").val(),
					proName:$("#proName").val(),
					beginAmt:$("#beginAmt").val(),
					endAmt:$("#endAmt").val(),
					isPay:isPay,
					inType:inType,
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
			     exportData('StkInService','stkInPage','com.cnlife.stk.model.StkIn',"{proName:'"+$("#proName").val()+"',memberNm:'"+$("#memberNm").val()+"',database:'"+database+"',sdate:'"+$("#sdate").val()+"',edate:'"+$("#edate").val()+"'}","入库单记录");
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
			function toPay(billId,inType,billNo){
				if(inType=="应付往来单位初始化"){
					document.getElementById("payfrm").src='${base}/manager/finInitWlYwMain/toPayInit?billId=' + billId;
				}else{
					document.getElementById("payfrm").src='${base}/manager/stkpay?billId=' + billId;
				}
				$('#paydlg').dialog('open');
			}
			
			function getNowFormatDate() {
			    var date = new Date();
			    var seperator1 = "-";
			    var seperator2 = ":";
			    var month = date.getMonth() + 1;
			    var strDate = date.getDate();
			    if (month >= 1 && month <= 9) {
			        month = "0" + month;
			    }
			    if (strDate >= 0 && strDate <= 9) {
			        strDate = "0" + strDate;
			    }
			    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
			            + " " + date.getHours() + seperator2 + date.getMinutes()
			            + seperator2 + date.getSeconds();
			    return currentdate;
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
				var inType = "";
				var amt = 0;
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id!= billId)continue;
					/*if(rows[i].billStatus!='已收货'){
					   alert("该订单未审核，不可支付");
					   return;
					}*/
					amt = Math.abs(rows[0].disAmt) - Math.abs(rows[0].payAmt + rows[0].freeAmt);
					inType=rows[0].inType;
				}
				
				if(amt<= 0)
					{
						alert("该单已支付完成，不需要核销");
						return;
					}
				var freeAmt = $("#freeAmt").val();
				var hxRemark = $("#hxRemark").val();
				var payTime = $("#payTime").val();
				var costId = $("#costId").val();
				var url = '${base}manager/updateFreeAmt';
				if(inType=='应付往来单位初始化'){
					url = '${base}manager/finInitWlYwMain/updateInitYfFreeAmt';
				}
				var msg = "是否确定核销?";
				$.messager.confirm('确认', msg, function(r) {
					if (r) {
						$.ajax( {
							url : url,
							data : "billId=" + billId + '&freeAmt=' + freeAmt+"&payTime="+payTime+"&remarks="+hxRemark+"&costId="+costId,
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
					var row= rows[i];
					if(row.inType=="应付供货商初始化"){
						return;
					}
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
								url : "manager/updateOrderZf",
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
			
		    function newBill()
			{
				
		    	parent.closeWin('采购入库');
				parent.add('采购入库','manager/pcstkin');
			}
			
			function newOtherBill()
			{
				parent.closeWin('其它入库');
				parent.add('其它入库','manager/pcotherstkin');
			}
			
			
			
			function onDblClickRow(rowIndex, rowData)
		    {
				if(rowData.inType=='应付供货商初始化'){
					return;
				}
				
				parent.closeWin('入库单信息' + rowData.id);
				parent.add('入库单信息' + rowData.id,'manager/showstkin?dataTp=1&billId=' + rowData.id);
		    	//parent.add('付款记录' + rowData.id,'manager/queryPayPageByBillId?dataTp=1&billId=' + rowData.id);
		    }
		    
		    function showPayList(billId,inType,billNo)
		    {
		    	var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();

		    	parent.closeWin('付款记录' + billId);
		    	parent.add('付款记录' + billId,'manager/queryPayPageByBillId?dataTp=1&sdate='+sdate+'&edate='+edate+'&sourceBillNo='+billNo+'&billId=' + billId);
		    }
		    
		    function showPayHisList()
		    {
		    	parent.closeWin('付款记录');
		    	parent.add('付款记录','manager/queryPayPageByBillId?dataTp=1');
		    }
		    
		    function showPayStat()
		    {
		    	parent.closeWin('付款统计');
		    	parent.add('付款统计','manager/toPayStat?dataTp=1');
		    }
		    
		    function showNeedPayStat()
		    {
		    	parent.closeWin('付款统计');
		    	parent.add('付款统计','manager/toNeedPayStat?dataTp=1');
		    }
		    
		    
			function formatterSt3(val,row){
				if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
				
				// if(row.inType=="应付供货商初始化"){
				// 	var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='showPayList("+row.id+",\""+row.inType+"\",\""+row.billNo+"\")'/>"
			    //   	 + "<input style='width:60px;height:27px' type='button' value='付款' onclick='toPay("+row.id+",\""+row.inType+"\",\""+row.billNo+"\")'/>";
		      	//         return ret;
				// }
				
		      	var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='showPayList("+row.id+",\""+row.inType+"\",\""+row.billNo+"\")'/>"
		      	 + "<input style='width:60px;height:27px' type='button' value='付款' onclick='toPay("+row.id+",\""+row.inType+"\",\""+row.billNo+"\")'/>"
	      	        +"<input style='width:60px;height:27px' type='button' value='核销' onclick='toFreePay("+row.id+")'/>";
	      	        return ret;
		      		
		   } 
			
			function dialogCostType(){
		    	$('#costTypeDlg').dialog({
		            title: '选择费用科目',
		            iconCls:"icon-edit",
		            width: 800,
		            height: 400,
		            modal: true,
		            href: "<%=basePath %>/manager/toDialogOtherCostType",
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
					url:"<%=basePath%>/manager/queryIncomeItemList",
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
				// var rows = $("#datagrid").datagrid("getSelections");
				// for ( var i = 0; i < rows.length; i++) {
				// 	if(ids!=""){
				// 		ids = ids +",";
				// 	}
				// 	ids += rows[i].id;
				// 	if(rows[i].inType=="应付供货商初始化"){
				// 		alert("有应付供货商初始化，不允许批量收款")
				// 		return;
				// 	}
				// }


				if(billList!=undefined&&billList.length>0){
					for(var k=0;k<billList.length;k++){
						var data = billList[k];
						if(ids!=""){
							ids = ids +",";
						}
						ids += data.id;
						if(data.inType=="应付供货商初始化"){
							alert("有应付供货商初始化，不允许批量收款");
							return;
						}
					}
				}

				if(ids==""){
					alert("请选择发票单据!");
					return;
				}
				var accId = $("#accId").val();
				if(accId==""){
					alert("请选择付款账号");
					return;
				}
				var remarks = $("#remarks").val();
				$.messager.confirm('确认', '您确认批量付款吗？', function(r) {
					if (r) {
						$.ajax( {
							url : "manager/batchInPay",
							data : "ids=" + ids+"&accId="+accId+"&remarks="+remarks,
							type : "post",
							success : function(json) {
								if (json.state) {
									alert(json.msg);
									 $("#accId").val("");
									 $("#remarks").val("");
									billList = new Array();
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


			var  billList = new Array();
			function onSelect(rowIndex, rowData){
				var data = {
					id:rowData.id,
					billNo:rowData.billNo,
					inType:rowData.inType
				};
				var flag = true;
				if(billList!=null){
					for(var i=0;i<billList.length;i++){
						var t = billList[i];
						if(rowData.billNo==t.billNo){
							flag=false;
							break;
						}
					}
				}
				if(flag){
					billList.push(data);
				}
			}
			function onUnselect(rowIndex, rowData){
				if(billList!=null){
					var list = billList;
					for(var k=0;k<list.length;k++){
						var data = list[k];
						if(rowData.billNo==list[k].billNo){
							list.splice(k,1);
							break;
						}
					}
					billList=list;
				}
			}
			/**
			 初始化选中
			 **/
			function loadData(){
				var list = billList;
				var rows =  $('#datagrid').datagrid('getRows');
				if(list!=null){
					for(var i=0;i<rows.length;i++){
						var data = rows[i];
						for(var k=0;k<list.length;k++){
							var json = list[k];
							if(json.billNo==data.billNo){
								$('#datagrid').datagrid('selectRow',i);
								break;
							}
						}
					}
				}
			}
			function onCheckAll()
			{
				var rows =  $('#datagrid').datagrid('getRows');
				for(var i=0;i<rows.length;i++){
					var data = rows[i];
					onSelect(i,data);
				}
			}
			function onUnCheckAll(){
				var rows =  $('#datagrid').datagrid('getRows');
				for(var i=0;i<rows.length;i++){
					var data = rows[i];
					onUnselect(i,data);
				}
			}
		</script>
	</body>
</html>
