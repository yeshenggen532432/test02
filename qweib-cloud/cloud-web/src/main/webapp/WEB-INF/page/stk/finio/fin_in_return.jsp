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

	<body onload="initGrid()">
		<table id="datagrid"  fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
		<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="billNo" width="135" align="center">
						单号
					</th>
					
					<th field="costTimeStr" width="80" align="center">
						费用日期
					</th>
					<th field="proName" width="100" align="center">
						报销人员
					</th>
					
					<th field=branchName width="100" align="center" >
						部门
					</th>
					<th field="totalAmt" width="80" align="center" >
						费用金额
					</th>
					<th field="count" width="400" align="center" formatter="formatterSt">
						商品信息
					</th>
					<th field="remarks" width="80" align="center" >
						备注
					</th>
					
					
					
				</tr>
			</thead>	
		</table>
		
		<div id="tb" style="padding:5px;height:auto">	
		<div style="margin-bottom:5px">   
		
			
			
		</div>	
		<div>
		     单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			往来单位: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			科目名称:  <input name="itemName" id="itemName" style="width:100px;height: 20px;"/>
			单据日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	  
	         状态: <select name="orderZt" id="billStatus">
	                    <option value="-1">全部</option>
	                    <option value="0">未还清</option>
	                    <option value="1">已还清</option>
	                    
	                </select>		  
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:showTotal();">应还款统计</a>
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
	  	<div id="dlg" closed="true" class="easyui-dialog" title="银行账号" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						auditBill1();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
		费用摊销期数: <input name="termQty" id="termQty" value="1" style="width:220px;height: 20px;"/>
		
		<input type="hidden" id="checkId" />
		
		</div>

		<div id="freeDlg" closed="true" class="easyui-dialog" title="核销" style="width:400px;height:250px;padding:10px"
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
						$('#freeDlg').dialog('close');
					}
				}]
			">
			核销金额: <input name="freeAmt" id="freeAmt" style="width:120px;height: 20px;"/>
			<br/>
			<%--
			费用科目: <input name="itemName" id="itemName" readonly="readonly" style="width:120px;height: 20px;"/> <a href="javascript:;;" onclick="dialogCostType()">选择</a>
			--%>
			<input type="hidden" name="costId" id="costId" />
			<br/>
			备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注: <textarea rows="4" cols="45"  name="hxRemark" id="hxRemark"></textarea>
			<input type="hidden" id="billId" value="0"/>
		</div>

		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
		   //$("#billStatus").val("未收货");
		    //initGrid();
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
							field: 'billTimeStr',
							title: '单据日期',
							width: 100,
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
							field: 'accName',
							title: '账户名称',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'totalAmt',
							title: '借入金额',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: '_upayAmt',
							title: '未还金额',
							width: 80,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'payAmt',
							title: '还出金额',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
					var col = {
						field: 'freeAmt',
						title: '核销金额',
						width: 80,
						align:'center'

					};
					cols.push(col);
		    	    var col = {
							field: 'count',
							title: '科目信息',
							width: 200,
							align:'center',
							formatter:formatterSt
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: '_operator',
							title: '操作',
							width: 210,
							align:'center',
							formatter:formatterSt3
							
											
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
		    	    	url:"manager/queryFinInPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							proName:$("#proName").val(),
							isNeedPay:0,
							status:1,
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							itemName:$("#itemName").val()
			    	    	
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    //$('#datagrid').datagrid('reload'); 
		    	    $("#billStatus").val(0);
			}
		    //查询物流公司
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryFinInPage?database="+database,
					jz:"1",
					status:1,
					billNo:$("#orderNo").val(),
					proName:$("#proName").val(),
					isNeedPay:$("#billStatus").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					itemName:$("#itemName").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
				}
			}

			function formatterSt(v,row){
				var hl='<table>';
				var rowIndex = $("#datagrid").datagrid("getRowIndex",row);
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>科目名称</b></td>';
			        
			        hl +='<td width="60px;"><b>借入金额</font></b></td>';
			        
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].itemName+'</td>';
			        
			        hl +='<td>'+row.list[i].amt+'</td>';
			        
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}

			
			
			function amtformatter(v,row)
			{
				if (row != null) {
                    return toThousands(v);//numeral(v).format("0,0.00");
                }
			}

			
			

			function formatterSt3(val,row){
			     
		      	var ret ="";
		      	if(parseFloat(row.totalAmt)> parseFloat(row.payAmt)){
					ret = "<input style='width:60px;height:27px' type='button' value='还款' onclick='toFinReturn("+row.id+")'/>";
					ret =ret+"<input style='width:60px;height:27px' type='button' value='核销' onclick='toFreePay("+row.id+")'/>";
				}
		      	if(row.payAmt > 0)
		      	ret = ret + "<input style='width:60px;height:27px' type='button' value='还款明细' onclick='showDetail("+row.id+")'/>";
				return ret;
		      		
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
		    function toFinReturn(id){
			     
		    	parent.closeWin('往来还出单');
				parent.add('往来还出单','manager/fininreturn?billId=' + id);
				  
				
				 }

		    function auditBill(id){
		    	$("#checkId").val(id);
		    	$('#dlg').dialog('open');
			     
				 }
		    function auditBill1(id){
			      $.messager.confirm('确认', '您确认要审核吗？', function(r) {
				  if (r) {
					$.ajax({
						url:"manager/updateFinOutAudit",
						type:"post",
						data:"billId="+id,
						success:function(json){
							if(json.state){
							    alert("操作成功");
							    $('#datagrid').datagrid('reload'); 
							    $('#dlg').dialog('close');
							}else{
								alert("操作失败" + json.msg);
								return;
							}
						}
					});
				  }
				 });
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
				parent.closeWin('往来借出'  + ids[0]);
				parent.add('往来借出'  + ids[0],'manager/showstkin?dataTp=1&billId=' + ids[0]);
			}


			
		    function newBill()
			{
				
		    	parent.closeWin('往来借出开单');
				parent.add('往来借出开单','manager/toFinInEdit');
			}
			
		    function showDetail(id)
			{
				
		    	parent.closeWin('还款明细');
				parent.add('还款明细','manager/finaccio1?remarks=还款支出&billId=' + id);
			}
			
			
			function onDblClickRow(rowIndex, rowData)
		    {
				
				parent.closeWin('往来借入开单' + rowData.id);
		    	parent.add('往来借入开单' + rowData.id,'manager/showFinInEdit?billId=' + rowData.id);
					
		    }
			
			function toThousands(num1) {
			    var num = (num1|| 0).toString(), result = '';
			    while (num.length > 3) {
			        result = ',' + num.slice(-3) + result;
			        num = num.slice(0, num.length - 3);
			    }
			    if (num) { result = num + result; }
			    return result;
			}
			function amtformatter(v,row)
			{
				var upay = row.totalAmt-row.payAmt-row.freeAmt;
				if (row != null) {
					upay = parseFloat(upay);
                    return upay.toFixed(2);
                }
			}
			 function showTotal()
				{
			    	parent.closeWin('应还款统计');
					parent.add('应还款统计','manager/toFinInTotal');
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
					var upay = rows[i].totalAmt-rows[i].payAmt-rows[i].freeAmt;
					$("#freeAmt").val(upay);
					$("#billId").val(billId);
				}
				$('#freeDlg').dialog('open');
			}


			function freePay()
			{
				var billId = $("#billId").val();
				var rows = $("#datagrid").datagrid("getRows");
				var amt = 0;
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id!= billId)continue;
					amt = rows[i].totalAmt -rows[i].payAmt- rows[i].freeAmt;
				}
				if(amt<= 0)
				{
					alert("该单已支付完成，不需要核销");
					return;
				}
				var freeAmt = $("#freeAmt").val();
				var msg = "是否确定核销?";
				var hxRemark = $("#hxRemark").val();
				var costId = "";
				$.messager.confirm('确认', msg, function(r) {
					if (r) {
						$.ajax( {
							url : "manager/updateFinInFreeAmt",
							data : "billId=" + billId + "&freeAmt=" +freeAmt+"&remarks="+hxRemark+"&costId="+costId,
							type : "post",
							success : function(json) {
								if (json.state) {
									showMsg("核销成功");
									$('#freeDlg').dialog('close');
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
		</script>
	</body>
</html>
