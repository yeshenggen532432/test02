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

	<body>
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
			<input type="hidden" name="proId" id="proId" value="${proId }"/>
		     单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			往来单位: <input name="proName" id="proName" value="${ proName}" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			
			单据日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			<!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->
			<!--<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toLoadExcel();">导出</a>-->
			</div>
		</div>
		
	  
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
							field: 'payAmt',
							title: '还出金额',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'needPay',
							title: '未还款金额',
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
							field: 'remarks',
							title: '备注',
							width: 200,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    $('#datagrid').datagrid({
		    	    	url:"manager/queryFinInPageTotalItem",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							proName:$("#proName").val(),
							proId:$("#proId").val(),
							isNeedPay:0,
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
					url:"manager/queryFinInPageTotalItem?database="+database,
					jz:"1",
					billNo:$("#orderNo").val(),
					proName:$("#proName").val(),
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
			function formatterSt(v,row){
				if(row.id==undefined){
					return "";
				}
				var hl='<table>';
				var rowIndex = $("#datagrid").datagrid("getRowIndex",row);
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>明细科目名称</b></td>';
			        
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
				if(row.id==undefined){
					return "";
				}
				if (row != null) {
                    return toThousands(v);//numeral(v).format("0,0.00");
                }
			}

			
			

			function formatterSt2(val,row){
				if(row.id==undefined){
					return "";
				}
			  if(row.list.length>0){
			    if(val=='未审核'){
		            return "<input style='width:60px;height:27px' type='button' value='未审核' onclick='updateOrderSh(this, "+row.id+")'/>";
			     }else{
			        return val;   
			     }
			  }
		    } 
		  
		 
			
			function onDblClickRow(rowIndex, rowData)
		    {
				if(rowData.id==undefined){
					return ;
				}
					parent.closeWin('往来借入' + rowData.id);
		    	parent.add('往来借入' + rowData.id,'manager/showFinInEdit?billId=' + rowData.id);
					
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
			initGrid();
		</script>
	</body>
</html>
