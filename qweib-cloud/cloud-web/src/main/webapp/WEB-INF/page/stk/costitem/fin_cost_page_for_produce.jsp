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
	 <a class="easyui-linkbutton" iconCls="icon-select" href="javascript:confirmData();">确定选择</a>
	 总金额：<span id="totalAmt"></span>
		<table id="datagrid"  fit="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
		<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					
				</tr>
			</thead>	
		</table>
		
		<div id="tb" style="padding:5px;height:auto">	
		<div style="margin-bottom:5px">   
		</div>	
		<div style="display: none">
		     单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" />
			<input name="proName" id="proName" style="width:120px;height: 20px;display: none" />
			报销日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	  	 	<div style="display: none">
	  	 	<tag:select name="branchId2" id="branchId2" tclass="pcl_sel"  tableName="sys_depart" value="${branchId2}"  displayKey="branch_id" displayValue="branch_name"/>   
	  	 	</div>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			</div>
		</div>
		<script type="text/javascript">
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
							title: '报销人员',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'branchName',
							title: '部门',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	   
		    	    var col = {
							field: 'totalAmt',
							title: '报销金额',
							width: 80,
							align:'center',
							formatter:formatterAmt
					};
		    	    cols.push(col);
		    	  
		    	    var col = {
							field: 'count',
							title: '费用信息',
							width: 200,
							align:'center',
							formatter:formatterSt,
							hidden:'true'
							
											
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
		    	    	url:"manager/queryFinCostPageForProduce",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							proName:$("#proName").val(),
							status:0,
							depId:$("#branchId2").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    $("#billStatus").val(0);
			}
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryFinCostPageForProduce",
					jz:"1",
					billNo:$("#orderNo").val(),
					proName:$("#proName").val(),
					status:$("#billStatus").val(),
					depId:$("#branchId2").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			}
			var totalAmt=0;
			function formatterAmt(v,row){
				totalAmt = parseFloat(totalAmt)+parseFloat(v);
				$("#totalAmt").html(totalAmt);
				return v;
			}
			
			function formatterSt(v,row){
				var hl='<table>';
				var rowIndex = $("#datagrid").datagrid("getRowIndex",row);
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>费用名称</b></td>';
			        
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
			
			 function confirmData(){
					var rows = $("#datagrid").datagrid("getSelections");
					var  wareList = new Array();
					for ( var i = 0; i < rows.length; i++) {
						var data = {
								costId:rows[i].id,
								voucherNo:rows[i].billNo,
								costAmt:rows[i].totalAmt
						};
						wareList.push(data); 
					}
					json ={
							list:wareList
					}
					
					window.parent.callBackFunCost(json);
					
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
