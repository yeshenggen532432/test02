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
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		    发货单号: <input name="voucherNo" id="voucherNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		    发票单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		    客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
			客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			车号: <input name="vehNo" id="vehNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			<br/>
			下单日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	         状态: <select name="orderZt" id="billStatus">
	                    <option value="-1">全部</option>	                   
	                    <option value="0">正常</option>
	                    <option value="2">作废</option>
	                </select>		  
	  出库类型:<select name="xsTp" id="xsTp" value="${billName}">
	                  <option value="">全部</option>	                  
	                  <option value="正常销售">正常销售</option>
	                  <option value="促销折让">促销折让</option>
	                  <option value="消费折让">消费折让</option>
	                  <option value="费用折让">费用折让</option>
	                  <option value="其他销售">其他销售</option>
	                  <option value="其它出库">其它出库</option>
	               </select>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:initGrid();">查询</a>
			
			
			
			<!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->
			
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
		    initGrid();
		    //queryorder();
		    function initGrid()
		    {
		    	var cols = new Array(); 
				   var col = {
							field: 'id',
							title: 'id',
							width: 100,
							align:'center',
							hidden:true				
					};
				   cols.push(col);	
				   	
				   var col = {
							field: 'outId',
							title: 'outId',
							width: 100,
							align:'center',
							hidden:true				
					};
				   cols.push(col);	
				   
				   var col = {
							field: 'sendTimeStr',
							title: '日期',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'voucherNo',
							title: '发货单号',
							width: 130,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'billNo',
							title: '发票单号',
							width: 130,
							align:'center'
							
											
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
							field: 'epCustomerName',
							title: '所属二批',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'vehNo',
							title: '运输车辆',
							width: 80,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'driverName',
							title: '司机',
							width: 80,
							align:'center'
							
											
					};
		    	    cols.push(col);
				   
		    	    var col = {
							field: 'count',
							title: '商品信息',
							width: 300,
							align:'center',
							formatter:formatterSt
							
											
					};
		    	    cols.push(col);
		    	    
	    	    
	    	    
	    	    var col = {
						field: 'billStatus',
						title: '状态',
						width: 80,
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
	    	   
					$('#datagrid').datagrid({
						url:"manager/queryOutDetailList1",
						queryParams:{
							jz:"1",
							billNo:$("#orderNo").val(),
							voucherNo:$("#voucherNo").val(),
							stkUnit:$("#khNm").val(),												
							billName:$("#xsTp").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							ioType:1,
							status:$("#billStatus").val(),
							wareNm:$("#wareNm").val(),
							vehNo:$("#vehNo").val(),
							customerType:$("#customerType").val(),
							epCustomerName:$("#epCustomerName").val()
							},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	   // $('#datagrid').datagrid('reload');  
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					initGrid();
				}
			}
			//导出
			function myexport(){
			     exportData('StkOutService','queryOutPage','com.cnlife.stk.model.StkOut',"{khNm:'"+$("#khNm").val()+"',memberNm:'"+$("#memberNm").val()+"',database:'"+database+"',sdate:'"+$("#sdate").val()+"',edate:'"+$("#edate").val()+"'}","出库单记录");
  			}
			
			function cancelOut1(id)
			{
				
				var rows = $("#datagrid").datagrid("getRows");
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id!= id)continue;
					if(rows[i].billStatus=='作废'){
					   alert("该单已经作废");
					   return;
					}
				}
				
					$.messager.confirm('确认', '是否确认作废出库单？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/cancelStkOut1",
								data : "billId=" + id,
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else{
										showMsg("作废失败:" + json.msg);
									}
								}
							});
						}
					});
				
			}
		    
			
			function formatterSt3(val,row){
			     if(row.status == 2)return "";
			     if(row.billNo == ""||row.billNo == null)return "";
				var ret = "<input style='width:60px;height:27px' type='button' value='作废' onclick='cancelOut1("+row.id+")'/>";
		      	
      	        return ret;
		      		
		   } 
			
			function formatterSt(v,row){
				var hl='<table>';
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>商品名称</b></td>';
			       
			        hl +='<td width="60px;"><b>单位</font></b></td>';
			        hl +='<td width="60px;"><b>销售类型</font></b></td>';
			        hl +='<td width="60px;"><b>发货数量</font></b></td>';
			        
			        
			        if(${stkRight.priceFlag} == 1)
				        hl +='<td width="60px;"><b>单价</font></b></td>';
				    if(${stkRight.amtFlag} == 1)
				        hl +='<td width="60px;"><b>总价</font></b></td>';
			        
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].wareNm+'</td>';
			        
			        hl +='<td>'+row.list[i].unitName+'</td>';
			        hl +='<td>'+row.list[i].billName+'</td>';
			        hl +='<td>'+numeral(row.list[i].outQty).format("0,0.00")+'</td>';
			        
			        if(${stkRight.priceFlag} == 1)
				        hl +='<td>'+row.list[i].ioPrice+'</td>';
				        if(${stkRight.amtFlag} == 1)
				        hl +='<td>'+numeral(row.list[i].outQty *row.list[i].ioPrice).format("0,0.00") +'</td>';
			        
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
			function todetail(title,id){
				window.parent.add(title,"manager/queryBforderDetailPage?orderId="+id);
			}
			function toRec(){
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
				window.location.href='${base}/manager/stkrec?billId=' + ids[0];
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
				var amt = rows[0].disAmt - rows[0].recAmt - rows[0].freeAmt;
				if(amt<= 0)
					{
						alert("该单已支付完成，不需要核销");
						return;
					}
				var msg = "核销金额" + amt + ",是否确定枋销?";
				$.messager.confirm('确认', msg, function(r) {
					if (r) {
						$.ajax( {
							url : "manager/updateOutFreeAmt",
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
				var ids = "";
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					if(ids == "")ids = rows[i].id;
					else ids = ids + "," + rows[i].id;
					
					if(rows[i].billStatus=='已审'||rows[i].billStatus=='作废'){
					   alert("该单不能删除");
					   return;
					}
				}
				if (ids != "") {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/deleteStkOut",
								data : "ids=" + ids,
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									} else {
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
				parent.closeWin('销售出库' + ids[0]);
				parent.add('销售出库' + ids[0],'manager/showstkout?dataTp=1&billId=' + ids[0]);
			}
			
			function newBill()
			{
				
				parent.closeWin('销售开单');
				parent.add('销售开单','manager/pcstkout?orderId=0');
			}
			
			function newOtherBill()
			{
				parent.closeWin('其它出库开单');
				parent.add('其它出库开单','manager/pcotherstkout');
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

		    function showCheck(billId)
			{
				
				
				/*if(rows[0].billStatus == "已审")
					{
						alert("该单据已经审核");
						return;
					}*/
					parent.closeWin('发货' + billId);
				parent.add('发货' + billId,'manager/showstkoutcheck?dataTp=1&billId=' + billId);
			}
		    function onDblClickRow(rowIndex, rowData)
		    {
		    	if(rowData.outType == "销售出库")
		    		{
		    		parent.closeWin('发货单信息' + rowData.outId);
		    		parent.add('发货单信息' + rowData.outId,'manager/lookstkoutcheck?dataTp=1&billId=' + rowData.outId+'&sendId='+rowData.id);
		    		}
		    	else
		    		{
		    		parent.closeWin('其它发货单' + rowData.outId);
		    		parent.add('其它发货单' + rowData.outId,'manager/lookstkoutcheck?dataTp=1&billId=' + rowData.outId+'&sendId='+rowData.id);
		    		}
		    	//parent.add('发货' + rowData.id,'manager/showstkoutcheck?dataTp=1&billId=' + rowData.id);
		    }
		    
		    function showOutList(billId)
		    {	    	
		    	parent.closeWin('发货明细' + billId);
		    	parent.add('发货明细' + billId,'manager/toOutList?billId=' + billId);
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
