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
		     发票单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		     客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
			客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员名称: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			下单日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	       
	         发票状态: <select name="orderZt" id="billStatus">
	                    <option value="未发货">未发货</option>	                   
	                    <option value="已发货">已发货</option>
	                    <option value="作废">作废</option>
	                    <option value="终止未发完">终止未发完</option>
	                </select>	
	          发票类型: <select name="outType" id="outType">
	                    <option value=""></option>	                   
	                    <option value="销售出库">销售出库</option>
	                    <option value="其它出库">其它出库</option>
						<option value="报损出库">报损出库</option>
						<option value="借出出库">借出出库</option>
						<option value="领用出库">领用出库</option>

	                </select>     
	       收款状况: <select name="orderZt" id="payStatus">
	                <option value="">全部</option>
	                    <option value="未收款">未收款</option>	                    
	                    <option value="已收款">已收款</option>	                   
	                </select>	
	   商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>	  
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询11</a>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:showOutListQuery();">发货明细查询</a>
			
			
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
	  	<div id="dlg" closed="true" class="easyui-dialog" title="完结" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						closeBill();
					}
				},{
					text:'取消',
					handler:function(){
						document.getElementById('wjRemark').value='';
						$('#dlg').dialog('close');
					}
				}]
			">
		备注: <textarea rows="7" cols="50"  name="wjRemark" id="wjRemark"></textarea>
	</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
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
							field: 'billNo',
							title: '单号1',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'outType',
							title: '发票类型',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);

					var col = {
						field: 'sumQty',
						title: 'sumQty',
						width: 100,
						align:'center'

					};
					cols.push(col);

					var col = {
						field: 'sumOutQty',
						title: 'sumOutQty',
						width: 100,
						align:'center'
					};
					cols.push(col);

		    	    var col = {
							field: 'pszd',
							title: '配送指定',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'outDate',
							title: '发票日期',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'khNm',
							title: '客户名称',
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
							field: 'staff',
							title: '业务员',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: '_operator',
							title: '操作',
							width:80,
							align:'center',
							formatter:formatterSt3
							
											
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
							title: '合计金额',
							width: 60,
							align:'center',
							formatter:amtformatter

					};
					cols.push(col);
					var col = {
							field: 'discount',
							title: '整单折扣',
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
							field: 'billStatus',
							title: '发票状态',
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

		    	    var col = {
							field: 'shr',
							title: '收货人',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'tel',
							title: '电话',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'address',
							title: '地址',
							width: 150,
							align:'center'
											
					};
		    	    cols.push(col);		    	   

		    	    var isPay = -1;			    	
			    	if(sts == "已收款")isPay = 1;
			    	if(sts == "未收款")isPay = 0;
			    	
		    	    $('#datagrid').datagrid({
		    	    	 url:"manager/stkOutPage",
		    	    	 queryParams:{
		    	    		 jz:"1",
		    	    		 isPay:isPay,
		 					billNo:$("#orderNo").val(),
		 					khNm:$("#khNm").val(),
		 					staff:$("#memberNm").val(),
		 					billStatus:$("#billStatus").val(),					
		 					sdate:$("#sdate").val(),
		 					edate:$("#edate").val(),
		 					wareNm:$("#wareNm").val(),
		 					outType:$("#outType").val(),
		 					customerType:$("#customerType").val(),
		 					epCustomerName:$("#epCustomerName").val()
		    	    	 },
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
			}
		    //查询物流公司
			function queryorder(){
				var isPay = -1;			    	
		    	if(sts == "已收款")isPay = 1;
		    	if(sts == "未收款")isPay = 0;
				$("#datagrid").datagrid('load',{
					url:"manager/stkOutPage",
					jz:"1",
					isPay:isPay,
					billNo:$("#orderNo").val(),
					khNm:$("#khNm").val(),
					staff:$("#memberNm").val(),
					billStatus:$("#billStatus").val(),					
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					wareNm:$("#wareNm").val(),
 					outType:$("#outType").val(),
 					customerType:$("#customerType").val(),
 					epCustomerName:$("#epCustomerName").val()
 					
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
			     exportData('StkOutService','queryOutPage','com.cnlife.stk.model.StkOut',"{khNm:'"+$("#khNm").val()+"',memberNm:'"+$("#memberNm").val()+"',database:'"+database+"',sdate:'"+$("#sdate").val()+"',edate:'"+$("#edate").val()+"'}","出库单记录");
  			}
			
			
			
			function formatterSt3(val,row){
				if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
		      	var ret = "<input style='width:60px;height:27px' type='button' value='发货明细' onclick='showOutList("+row.id+")'/>";
		      	if(${stkRight.auditFlag} == 1)
		      		{
		      		if(row.billStatus!='作废'){
		      			ret = ret + "<br/><input style='width:60px;height:27px;margin-top:2px;' type='button' value='发货' onclick='showCheck(\""+row.id+"\",\""+row.outType+"\")'/>";
		      		}
		      				ret = ret + "<br/><input style='width:60px;height:27px;margin-top:2px;' type='button' value='退货' onclick='showRtn("+row.id+")'/>";
		      			
		      		}
	      		
		      	if(row.status == 0)
		      	ret = ret + "<br/><input style='width:60px;height:27px;margin-top:2px;' type='button' value='完结' onclick='wanjieBill(\""+row.id+"\",\""+row.remarks+"\")'/>";
	      	        return ret;
		      		
		   } 
			
			function formatterSt(v,row){
				if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
				var hl='<table>';
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>商品名称</b></td>';
			        hl +='<td width="80px;"><b>销售类型</b></td>';
			        hl +='<td width="60px;"><b>单位</font></b></td>';
			        hl +='<td width="80px;"><b>规格</font></b></td>';
			        if(${stkRight.qtyFlag} == 1)
			        hl +='<td width="60px;"><b>数量</font></b></td>';
			        if(${stkRight.priceFlag} == 1)
			        hl +='<td width="60px;"><b>单价</font></b></td>';
			        if(${stkRight.amtFlag} == 1)
			        hl +='<td width="60px;"><b>总价</font></b></td>';
			        hl +='<td width="60px;"><b>已发数量</font></b></td>';
			        hl +='<td width="60px;"><b>未发数量</font></b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].wareNm+'</td>';
			        hl +='<td>'+row.list[i].xsTp+'</td>';
			        hl +='<td>'+row.list[i].unitName+'</td>';
			        hl +='<td>'+row.list[i].wareGg+'</td>';
			        if(${stkRight.qtyFlag} == 1)
			        hl +='<td>'+row.list[i].qty+'</td>';
			        if(${stkRight.priceFlag} == 1)
			        hl +='<td>'+row.list[i].price+'</td>';
			        if(${stkRight.amtFlag} == 1)
			        hl +='<td>'+numeral(row.list[i].qty *row.list[i].price).format("0,0.00") +'</td>';
			        hl +='<td>'+row.list[i].outQty+'</td>';
			        hl +='<td>'+row.list[i].outQty1+'</td>';
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
				var msg = "核销金额" + amt + ",是否确定核销?";
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
				
				parent.closeWin('销售出库');
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
			
			var billId=0;
			function wanjieBill(id,remarks){
				billId=id;
				if(remarks==undefined){
					remarks="";
				}
				document.getElementById("wjRemark").value = remarks;
				$('#dlg').dialog('open');
			}
			
		    function closeBill() {
		    	if(billId==0){
		    		return;
		    	}
		    	$('#dlg').dialog('close');
		    	var remarks = document.getElementById("wjRemark").value;
		    	//$('#dlg').dialog('open');
		    	$.messager.confirm('确认', '您确认想要完结该记录吗？', function(r) {
					if (r) {
						$.ajax( {
							url : "manager/closeStkOut",
							data : "billId=" + billId+"&remarks="+remarks,
							type : "post",
							success : function(json) {
								if(json.state) {
									showMsg("完结成功");
									$("#datagrid").datagrid("reload");
								} else if (json == -1) {
									showMsg("完结失败" + json.msg);
								}
								billId=0;
								document.getElementById("wjRemark").value="";
							}
						});
					}
				});	
			}

		    function showCheck(billId,outType)
			{
					if(outType == "销售出库")
		    		{
		    		parent.closeWin('发货开单');
		    		parent.add('发货开单','manager/showstkoutcheck?dataTp=1&billId=' + billId);
		    		}
		    	else
		    		{
		    		parent.closeWin('其它发货开单');
		    		parent.add('其它发货开单','manager/showstkoutcheck?dataTp=1&billId=' + billId);
		    		}
			}

			function showRtn(billId)
			{
				parent.closeWin('退货' + billId);
				parent.add('退货' + billId,'manager/showstkoutrtn?dataTp=1&billId=' + billId);
			}
		    function onDblClickRow(rowIndex, rowData)
		    {
		    	if(rowData.outType == "销售出库")
		    		{
		    		parent.closeWin('发货开单');
		    	parent.add('发货开单','manager/showstkoutcheck?dataTp=1&billId=' + rowData.id);
		    		}
		    	else
		    		{
		    		parent.closeWin('其它发货开单');
		    		parent.add('其它发货开单','manager/showstkoutcheck?dataTp=1&billId=' + rowData.id);
		    		}
		    }
		    
		    function showOutList(billId)
		    {	    	
			   
		    	parent.closeWin('发货明细' + billId);
		    	parent.add('发货明细' + billId,'manager/toOutList?billId=' + billId);
		    }

		    function showOutListQuery()
		    {	    	
		    	parent.closeWin('发货明细查询');
		    	parent.add('发货明细查询','manager/outdetailquery');
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
