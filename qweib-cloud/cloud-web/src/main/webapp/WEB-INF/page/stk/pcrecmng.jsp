<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>待收款列表</title>

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
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
			<input name="proType" type="hidden" id="proType" value="${proType}"/>
			客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>   
			往来单位: <input name="khNm" id="khNm" style="width:120px;height: 20px;" value="${khNm }" onkeydown="toQuery(event);"/>
			所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;" value="${epCustomerName}" onkeydown="toQuery(event);"/>
			时间类型:<select name="timeType" id="timeType">
			 		 <option value="2">发票时间</option>
	                 <option value="1">发货时间</option>
	           	   </select>  
			日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}"   />
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" />
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         		  <br/>
         	发票单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>		  
       	 	出库类型: <select name="outType" id="outType">
                   <option value="">全部</option>
                   <option value="销售出库">销售出库</option>
                   <option value="其它出库">其它出库</option>
               </select>	
            发货状态: <select name="sendStatus" id="sendStatus">
                  <option value="0">包含未发货</option>
                  <option value="1" selected="selected">已发货</option>
             	 </select>	
       		收款状况: <select name="orderZt" id="payStatus">
                   <option value="未收款">未收款</option>
                   <option value="">全部</option>
                   <option value="已收款">已收款</option>
                   <option value="作废">作废</option>
                  <option value="需退款">需退款</option>
               </select>	
             仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage"
							whereBlock="status=1 or status is null"
							headerKey="" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>
			仓库类型：
			<select id="saleCar" name="saleCar" onchange="queryorder()">
				<option value="">全部</option>
				<option value="0" selected>正常仓库</option>
				<option value="1">车销仓库</option>
				<option value="2">门店仓库</option>
			</select>
             车辆:<tag:select name="carId" id="carId" tableName="stk_vehicle" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="veh_no"/>
             业务员: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			<br/>
			发票金额范围:<input name="beginAmt" id="beginAmt" onkeyup="CheckInFloat(this)" style="width:60px;" />
					到<input name="endAmt" onkeyup="CheckInFloat(this)" id="endAmt" style="width:60px;" />

			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:toBatchPay();">批量收款</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:queryorder();">查询</a>
		</div>
	  	<div id="dlg" closed="true" class="easyui-dialog" title="核销" style="width:400px;height:300px;padding:10px"
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
		核销日期: <input name="recTime" id="recTime"  onClick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm'});" value="${recTime}" style="width: 120px;"  readonly="readonly"/>
		<br/>
		费用科目: <input name="itemName" id="itemName" readonly="readonly" style="width:120px;height: 20px;"/> <a href="javascript:;;" onclick="dialogCostType()">选择</a>
		<input type="hidden" name="costId" id="costId" style="width:120px;height: 20px;"/>
		<br/>
		备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注: <textarea rows="4" cols="45"  name="hxRemark" id="hxRemark"></textarea>
		<input type="hidden" id="chooseId" value="0"/>
	</div>
	
	<c:set var="datas" value="${fns:loadListByParam('fin_costitem','id,item_name','item_name=\"核销未收款\"')}"/>
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
		收款账号: <tag:select name="accId" id="accId" tableName="fin_account" headerKey="" whereBlock="status=0" headerValue="--请选择--" displayKey="id" displayValue="acc_name"/>
		备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注: <textarea rows="4" cols="40"  name="remarks" id="remarks"></textarea>
	</div>
	<div id="costTypeDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="费用科目选择" iconCls="icon-edit">
     </div>
     
      <div id="paydlg" closed="true" class="easyui-dialog" maximized="true" title="收款单" style="width:600px;height:500px;padding:10px">
			<iframe  name="payfrm" id="payfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	</div>
     <div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
		    initGrid();
		   //queryorder();
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
							field: 'khId',
							title: 'khId',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '发票单号',
							width: 135,
							align:'center',
							formatter:formatterEvent
											
					};
		    	    cols.push(col);
		    	   
		    	    
		    	    var col = {
							field: 'khNm',
							title: '往来单位',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
					 
		    	    var col = {
							field: 'outDate',
							title: '发票日期',
							width: 120,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'outType',
							title: '出库类型',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'stkName',
							title: '仓库',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'staff',
							title: '业务员',
							width: 100,
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

		    	    	var col = {
								field: 'disAmt',
								title: '发票金额',
								width: 60,
								align:'center',
								formatter:amtformatter
												
						};
		    	    	cols.push(col);
			    	   
			    	    var col = {
								field: 'disAmt1',
								title: '发货金额',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);

			    	    var col = {
								field: 'recAmt',
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
								field: 'needRec',
								title: '未收金额',
								width: 60,
								align:'center',
								formatter:amtformatter
												
						};
			    	    cols.push(col);
			    	    var col = {
								field: 'billStatus',
								title: '发货状态',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);
			    	    
			    	    var col = {
								field: 'recStatus',
								title: '收款状态',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);
			    	    var col = {
								field: 'epCustomerName',
								title: '所属二批',
								width: 100,
								align:'center'
												
						};
			    	    cols.push(col);

		    	    var sts = $("#payStatus").val();
			    	var outType = $("#outType").val();
			    	var isPay = -1;
			    	var needRtn = 0;
			    	if(sts == "已收款")isPay = 1;
			    	if(sts == "未收款")isPay = 0;
			    	if(sts == "作废")isPay = 2;
			    	if(sts == "需退款")needRtn = 1;
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkOutPageForRec",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							khNm:$("#khNm").val(),
							memberNm:$("#memberNm").val(),					
							isPay:isPay,
							pszd:$("#pszd").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							epCustomerName:$("#epCustomerName").val(),
							customerType:$("#customerType").val(),
							outType:outType,
							sendStatus:$("#sendStatus").val(),
							stkId:$("#stkId").val(),
							carId:$("#carId").val(),
							timeType:$("#timeType").val(),
							needRtn:needRtn,
							saleCar:$("#saleCar").val(),
							beginAmt:$("#beginAmt").val(),
							endAmt:$("#endAmt").val(),
							recStatus:"-2"   //recStatus ==-2 排除暂存的单据
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    
		    	    );
		    	    //$('#datagrid').datagrid('reload'); 
			}
		  
			function queryorder(){
		    	var sts = $("#payStatus").val();
		    	var outType = $("#outType").val();
		    	var isPay = -1;
		    	var needRtn = 0;
		    	if(sts == "已收款")isPay = 1;
		    	if(sts == "未收款")isPay = 0;
		    	if(sts == "作废")isPay = 2;
		    	if(sts == "需退款")needRtn = 1;
				$("#datagrid").datagrid('load',{
					url:"manager/stkOutPageForRec?database="+database,
					jz:"1",
					billNo:$("#orderNo").val(),
					khNm:$("#khNm").val(),
					memberNm:$("#memberNm").val(),					
					isPay:isPay,
					pszd:$("#pszd").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					epCustomerName:$("#epCustomerName").val(),
					customerType:$("#customerType").val(),
					sendStatus:$("#sendStatus").val(),
					outType:outType,
					carId:$("#carId").val(),
					saleCar:$("#saleCar").val(),
					stkId:$("#stkId").val(),
					timeType:$("#timeType").val(),
					needRtn:needRtn,
					beginAmt:$("#beginAmt").val(),
					endAmt:$("#endAmt").val(),
					recStatus:"-2"
				});
				billList = new Array();
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
			
			function toRec(billId,outType,billNo){
				//window.location.href='${base}/manager/stkrec?billId=' + billId;
				if(outType=="应收往来单位初始化"){
					document.getElementById("payfrm").src='${base}/manager/finInitWlYwMain/stkrecInit?billId=' + billId;
				}else{
					document.getElementById("payfrm").src='${base}/manager/stkrec?billId=' + billId;
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

			function toRecRtn(billId)
			{
				var rows = $("#datagrid").datagrid("getRows");
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id != billId)continue;
					if(rows[i].billStatus == "作废")
						{
							alert("作废单据不能收款");
							return;
						}
				}
				
				window.location.href='${base}/manager/stkrecrtn?billId=' + billId;
			}
			
			function toFreePay(billId)
			{
				var rows = $("#datagrid").datagrid("getRows"); 
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id != billId)continue;
					if(rows[i].billStatus == "作废")
						{
							alert("作废单据不能核销");
							return;
						}
					$("#freeAmt").val(rows[i].needRec);
					$("#chooseId").val(billId);
					
				}
				$('#dlg').dialog('open');
			}

			function freePay()
			{
				var billId = $("#chooseId").val();
				var rows = $("#datagrid").datagrid("getRows");
				var amt = 0;
				var outType="";
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id!= billId)continue;
					amt = rows[i].disAmt1 - rows[i].recAmt - rows[i].freeAmt;
					outType=rows[i].outType;
				}
				if(amt<= 0)
					{
						alert("该单已支付完成，不需要核销");
						return;
					}
				var freeAmt = $("#freeAmt").val();
				var msg = "是否确定核销?";
				var hxRemark = $("#hxRemark").val();
				var recTime=$("#recTime").val();
				var costId = $("#costId").val();
				var url = '${base}manager/updateOutFreeAmt';
				if(outType=='应收往来单位初始化'){
					url = '${base}manager/updateInitYsFreeAmt';
				}
				$.messager.confirm('确认', msg, function(r) {
					if (r) {
						$.ajax( {
							url : url,
							data : "billId=" + billId + "&freeAmt=" +freeAmt+"&recTime="+recTime+"&remarks="+hxRemark+"&costId="+costId,
							type : "post",
							success : function(json) {
								if (json.state) {
									showMsg("核销成功");
									$('#dlg').dialog('close');
									$("#costId").val("");
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

				if(rowData.outType=="应收往来单位初始化"){
					document.getElementById("payfrm").src='${base}/manager/finInitWlYwMain/stkrecInit?billId=' + rowData.id;;
				}else{
					document.getElementById("payfrm").src='${base}/manager/stkrec?billId=' + rowData.id;;
				}
				$('#paydlg').dialog('open');
				
		    
		    }
		    function showPayList(billId,outType,billNo)
		    {
		    	if(outType=="应收往来单位初始化"){
		    		parent.closeWin('收款记录' + billId);
			    	parent.add('收款记录' + billId,'manager/queryRecPageByBillId?dataTp=1&billId=&sourceBillNo=' + billNo);
		    	}else{
		    		parent.closeWin('收款记录' + billId);
			    	parent.add('收款记录' + billId,'manager/queryRecPageByBillId?dataTp=1&billId=' + billId);
		    	}
		    	
		    }

		   
		    
		    function showNeedRecStat()
		    {
		    	parent.closeWin('应收货款统计');
		    	parent.add('应收货款统计','manager/toNeedRecStat?dataTp=1');
		    }
		    
		    function formatterSt3(val,row){
		    	if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
		    	
		   	 if(row.outType=="应收往来单位初始化"){
		   		var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='showPayList("+row.id+",\""+row.outType+"\",\""+row.billNo+"\")'/>"
      	        + "<br/><input style='width:60px;height:27px' type='button' value='收款' onclick='toRec("+row.id+",\""+row.outType+"\",\""+row.billNo+"\")'/>"
				+"<br/><input style='width:60px;height:27px' type='button' value='核销' onclick='toFreePay("+row.id+",\""+row.outType+"\")'/>";
		   		 return ret;
		   	 }
		    	
		    	
		      	var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='showPayList("+row.id+",\""+row.outType+"\",\""+row.billNo+"\")'/>"
		      	        + "<br/><input style='width:60px;height:27px' type='button' value='收款' onclick='toRec("+row.id+",\""+row.outType+"\",\""+row.billNo+"\")'/>"
		      	        +"<br/><input style='width:60px;height:27px' type='button' value='核销' onclick='toFreePay("+row.id+",\""+row.outType+"\")'/>";
		      	       if(row.needRtn == 1)ret = ret + "<br/><input style='width:60px;height:27px' type='button' value='退款' onclick='toRecRtn("+row.id+")'/>";
		      	        return ret;
		      		
		   } 
		    function formatterEvent(v,row){
		    	 if(row.outType=="应收往来单位初始化"){
		    		 return v;
		    	 }
		    	
				 return '<a href="javascript:;;" onclick="showSourceBill('+row.id+')">'+v+'</a>';
			 }
		    function showSourceBill(sourceBillId){
				parent.closeWin('发票信息' + sourceBillId);
		    	parent.add('发票信息' + sourceBillId,'manager/showstkout?dataTp=1&billId=' + sourceBillId);
		 }
		  function loadCustomerType(){
				$.ajax({
					url:"manager/queryarealist1",
					type:"post",
					success:function(data){
						if(data){
						   var list = data.list1;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						      if(list[i].qdtpNm!=''){
						           img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
						       }
						    }
						   $("#customerType").html(img);
						 }
					}
				});
			}
		  
		  function toBatchPay()
			{
				$('#accDlg').dialog('open');
				
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
			
		  function batchPay(){
			    var ids = "";

			  if(billList!=undefined&&billList.length>0){
				  for(var k=0;k<billList.length;k++){
					  var data = billList[k];
					  	if(ids!=""){
					  		ids = ids +",";
					  	}
					  ids += data.id;
					  if(data.outType=="应收往来单位初始化"){
						  alert("存在应收往来单位初始化，不允许批量收款");
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
					alert("请选择收款账号");
					return;
				}
				var remarks = $("#remarks").val();
				$.messager.confirm('确认', '您确认批量收款吗？', function(r) {
					if (r) {
						$.ajax( {
							url : "manager/batchRec",
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
	 loadCustomerType();

	//显示弹出窗口
		function showWindow(title){
			$("#choiceWindow").window({
				title:title,
				top:getScrollTop()+50
			});
			$("#choiceWindow").window('open');
		}

			var  billList = new Array();
			function onSelect(rowIndex, rowData){
				var data = {
					id:rowData.id,
					billNo:rowData.billNo,
					outType:rowData.outType
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
