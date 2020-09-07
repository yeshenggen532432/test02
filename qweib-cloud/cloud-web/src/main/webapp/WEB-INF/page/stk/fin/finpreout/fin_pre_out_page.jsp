<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>预付款支出查询</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		
	</head>

	<body onload="initGrid()">
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
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
				</tr>
			</thead>	
		</table>
		
		<div id="tb" style="padding:5px;height:auto">	
		<div style="margin-bottom:5px">   
		<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newBill();">往来预付开单</a>
		<a class="easyui-linkbutton" iconCls="icon-search" plain="true"  href="javascript:showPayStat();">预付款统计</a>
		</div>	
		<div>
		     单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			往来单位: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			明细科目名称:  <input name="itemName" id="itemName" style="width:100px;height: 20px;"/>
			单据日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	  
	         状态: <select name="orderZt" id="billStatus">
	                    <option value="-1">全部</option>
	                    <option value="1">已审核</option>
	                    <option value="0">未审核</option>
	                    <option value="2">作废</option>
	                    <option value="3">被冲红单</option>
	                    <option value="4">冲红单</option>
	                </select>		  
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:initGrid();">查询</a>
			&nbsp;
			<span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>&nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>&nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
			</div>
		</div>
		<input type="hidden" id="checkId" />
		</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
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
							title: '预付金额',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'payAmt',
							title: '已抵扣金额',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'status',
							title: '状态',
							width: 80,
							align:'center',
							formatter:formatterStatus
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
		    	    	url:"manager/queryFinPreOutPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							proName:$("#proName").val(),
							status:$("#billStatus").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	],
	    	    		  	 rowStyler:function(index,row){    
			    	    		  	 if (row.status==2){      
			   	    		             return 'color:blue;text-decoration:line-through;font-weight:bold;';      
			   	    		         } 
			   	    		         if (row.status==3){      
			   	    		             return 'color:#FF00FF;font-weight:bold;';      
			   	    		         }  
			   	    		         if (row.status==4){      
			   	    		             return 'color:red;font-weight:bold;';      
			   	    		         }
	    	    		     } 
		    	    }
		    	    );
			}
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryFinPreOutPage",
					jz:"1",
					billNo:$("#orderNo").val(),
					proName:$("#proName").val(),
					status:$("#billStatus").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					initGrid();
				}
			}
			
			function formatterSt(v,row){
				var hl='<table>';
				var rowIndex = $("#datagrid").datagrid("getRowIndex",row);
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>明细科目名称</b></td>';
			        hl +='<td width="60px;"><b>预付金额</font></b></td>';
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
		      	if(row.status ==1||row.status ==0)
		      	ret = "<input style='width:60px;height:27px' type='button' value='作废' onclick='cancelBill("+row.id+")'/>";
		      	if(row.status == 0)
		      	ret = ret + "<input style='width:60px;height:27px' type='button' value='审核' onclick='auditBill("+row.id+")'/>";
	      	    return ret;
		   } 
			
		    function cancelBill(id){
			      $.messager.confirm('确认', '您确认要作废吗？', function(r) {
				  if (r) {
					$.ajax({
						url:"manager/cancelFinPreOut",
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
			      $.messager.confirm('确认', '您确认要审核吗？', function(r) {
				  if (r) {
					$.ajax({
						url:"manager/updateFinPreOutAudit",
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
			
		    function newBill()
			{
		    	parent.closeWin('往来预付开单');
				parent.add('往来预付开单','manager/toFinPreOutEdit');
			}
			
			function onDblClickRow(rowIndex, rowData)
		    {
					parent.closeWin('往来预付信息' + rowData.id);
		    		parent.add('往来预付信息' + rowData.id,'manager/showFinPreOutEdit?billId=' + rowData.id);
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

			function showPayStat()
		    {
		    	parent.closeWin('预付款统计');
		    	parent.add('预付款统计','manager/toFinPreOutUnitStat?dataTp=1');
		    }
			
		    function formatterStatus(v,row){
				   if(v==0){
					   return "未审批";
				   }else if(v==1){
					   return "已审批";
				   }else if(v==2){
					   return "作废";
				   }else if(v==3){
					   return "被冲红单";
				   }else if(v==4){
					   return "冲红单";
				   }
				   
			   }
		</script>
	</body>
</html>
