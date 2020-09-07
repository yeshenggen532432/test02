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
						报销日期
					</th>
					<th field="proName" width="100" align="center">
						报销人员
					</th>
					
					<th field=branchName width="100" align="center" >
						部门
					</th>
					<th field="totalAmt" width="80" align="center" >
						报销金额
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
		<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newBill();">填写报销单</a>
		</div>
		<div>
		     单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			报销人员: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			明细科目名称:  <input name="itemName" id="itemName" style="width:100px;height: 20px;"/>
			报销日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	    部门：
		        		   	<select id="branchId2" class="easyui-combotree" style="width:200px;"   
	        					data-options="url:'manager/departs?dataTp=1',onClick: function(node){
									depart(node.id);}">
							</select>    
	         状态: <select name="orderZt" id="billStatus">
	                    <option value="-1">全部</option>
	                    <option value="1">已审核</option>
	                    <option value="0">未审核</option>
	                    <option value="2">作废</option>
	                    <option value="3">已支付</option>
	                </select>		  
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
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
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
							field: 'costTimeStr',
							title: '报销日期',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'proName',
							title: '报销对象',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'operator',
							title: '经办人',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'totalAmt',
							title: '报销金额',
							width: 80,
							align:'center'
											
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
		    	    	url:"manager/queryFinCostPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							proName:$("#proName").val(),
							status:0,
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
					url:"manager/queryFinCostPage?database="+database,
					jz:"1",
					billNo:$("#orderNo").val(),
					proName:$("#proName").val(),
					status:$("#billStatus").val(),
					depId:$("branchId2").val(),
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
			//导出
			function myexport(){
			     exportData('StkInService','stkInPage','com.qweib.stk.model.StkIn',"{proName:'"+$("#proName").val()+"',memberNm:'"+$("#memberNm").val()+"',database:'"+database+"',sdate:'"+$("#sdate").val()+"',edate:'"+$("#edate").val()+"'}","入库单记录");
  			}
			function formatterSt(v,row){
				var hl='<table>';
				var rowIndex = $("#datagrid").datagrid("getRowIndex",row);
				if(row.list.length>0){
			        hl +='<tr>';

			        hl +='<td width="60px;"><b>费用金额</font></b></td>';
			        
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
		      	if(row.status != 2)
		      	ret = "<input style='width:60px;height:27px' type='button' value='作废' onclick='cancelBill("+row.id+")'/>";
		      	
		      	if(row.status == 0)
		      	ret = ret + "<input style='width:60px;height:27px' type='button' value='审核' onclick='auditBill("+row.id+")'/>";
		      	
		    	if(row.status == 1)
			      	ret = ret + "<input style='width:60px;height:27px' type='button' value='付款' onclick='payBill("+row.id+")'/>";
	      	        return ret;
		   }
			
			function payBill(id){
				
				parent.closeWin('付款凭证');
		    	parent.add('付款凭证','manager/toFinPayEdit?costBillId=' + id);
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
		    function cancelBill(id){
			      $.messager.confirm('确认', '您确认要作废吗？', function(r) {
				  if (r) {
					$.ajax({
						url:"manager/cancelFinCost",
						type:"post",
						data:"billId="+id,
						success:function(json){
							if(json.state){
							    alert("操作成功");
							    $('#datagrid').datagrid('reload'); 
							}else{
								alert("操作失败" + json.msg);
								return;
							}
						}
					});
				  }
				 });
				 }

		    function auditBill(id){
		    	$("#checkId").val(id);
		    	$('#dlg').dialog('open');
			     
				 }
		    function auditBill1(){
		    	var id = $("#checkId").val();
		    	var costTerm = $("#termQty").val();
		    	
		    	if(costTerm < 1)
		    		{
		    			alert("期数输入错误 ");
		    			return;
		    		}
			      $.messager.confirm('确认', '您确认要审核吗？', function(r) {
				  if (r) {
					$.ajax({
						url:"manager/updateCostAudit",
						type:"post",
						data:"billId="+id+"&costTerm=" + costTerm,
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
			
		    function newBill()
			{
				
		    	parent.closeWin('费用开单');
				parent.add('费用开单','manager/toFinCostEdit');
			}
			
			function onDblClickRow(rowIndex, rowData)
		    {
				
				parent.closeWin('费用报销' + rowData.id);
		    	parent.add('费用报销' + rowData.id,'manager/showFinCostEdit?billId=' + rowData.id);
					
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
		</script>
	</body>
</html>
