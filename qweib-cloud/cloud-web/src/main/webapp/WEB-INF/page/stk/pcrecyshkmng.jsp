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
		<table id="datagrid"  fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		    发票单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>		
			客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>   
			往来单位: <input name="khNm" id="khNm" style="width:120px;height: 20px;" value="${khNm }" onkeydown="toQuery(event);"/>
			所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;" value="${epCustomerName}" onkeydown="toQuery(event);"/>
			发票日期: <input name="sdate" id="sdate" readonly="readonly"  onClick="WdatePicker();" style="width: 100px;"  />
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate" readonly="readonly"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" />
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        	 出库类型: <select name="outType" id="outType">
	                    <option value="">全部</option>
	                    <option value="销售出库">销售出库</option>
	                    <option value="其它出库">其它出库</option>
	                </select>	
                  <select name="sendStatus" id="sendStatus" style="display: none">
                    <option value="0">包含未发货</option>
                    <option value="1" selected="selected">已发货</option>
                </select>	  		  
	        	 <select name="orderZt" id="payStatus" style="display: none">
	                    <option value="未收款">未收款</option>
	                    <option value="">全部</option>
	                    <option value="已收款">已收款</option>
	                    <option value="作废">作废</option>
	                   <option value="需退款">需退款</option>
	                </select>	
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
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
		备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注: <textarea rows="4" cols="45"  name="hxRemark" id="hxRemark"></textarea>
		<input type="hidden" id="chooseId" value="0"/>
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
							field: 'id',
							title: 'id',
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
							field: 'proName',
							title: '往来单位',
							width: 100,
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

		    	    	var col = {
								field: 'disAmt',
								title: '发票金额',
								width: 60,
								align:'center',
								formatter:amtformatter
												
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
								field: 'disAmt1',
								title: '已发货金额',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);
			    	    
			    	    var col = {
								field: 'needRec',
								title: '未发货金额',
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
							field: '_operator',
							title: '操作',
							width: 280,
							align:'center',
							formatter:formatterSt3
							
											
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
		    	    	url:"manager/stkOutYshkPage",
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
							needRtn:needRtn,
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
					url:"manager/stkOutYshkPage?database="+database,
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
					needRtn:needRtn,
					recStatus:"-2"
				});
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
			function todetail(title,id){
				window.parent.add(title,"manager/queryBforderDetailPage?orderId="+id);
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
				window.location.href='${base}/manager/stkrec?billId=' + billId;
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
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id!= billId)continue;
					amt = rows[i].disAmt1 - rows[i].recAmt - rows[i].freeAmt;
					
				}
				
				 
				if(amt<= 0)
					{
						alert("该单已支付完成，不需要核销");
						return;
					}
				var freeAmt = $("#freeAmt").val();
				var msg = "是否确定核销?";
				var hxRemark = $("#hxRemark").val();
				$.messager.confirm('确认', msg, function(r) {
					if (r) {
						$.ajax( {
							url : "manager/updateOutFreeAmt",
							data : "billId=" + billId + "&freeAmt=" +freeAmt+"&remarks="+hxRemark,
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
		    	//parent.add('收款记录' + rowData.id,'manager/queryRecPageByBillId?dataTp=1&billId=' + rowData.id);
		    	//if(rowData.outType == "销售出库")
		    	//parent.closeWin('销售开票信息' + rowData.id);
		    	//parent.add('销售开票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id);
		    	//else
		    	//	parent.add('其它出库开票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id);
		    	var rows = $("#datagrid").datagrid("getRows");
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id != rowData.id)continue;
					if(rows[i].billStatus == "作废")
						{
							alert("作废单据不能收款");
							return;
						}
				}
				window.location.href='${base}/manager/stkrec?billId=' + rowData.id;
		    
		    }
		    function showPayList(billId)
		    {
		    	parent.closeWin('收款记录' + billId);
		    	parent.add('收款记录' + billId,'manager/queryRecPageByBillId?dataTp=1&billId=' + billId);
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
		      	var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='showPayList("+row.id+")'/>";
		      	        return ret;
		      		
		   } 
		    function formatterEvent(v,row){
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
	 loadCustomerType();
		</script>
	</body>
</html>
