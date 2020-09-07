<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>发货出库明细</title>

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
			仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage" headerKey="-1" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>
			<br/>
			下单日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			配送单号: <input name="deliveryNo" id="deliveryNo" value="${deliveryNo}" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
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
	      显示商品信息:<input type="checkbox"  id="showWareCheck" name="showWareCheck" onclick="initGrid()" value="1"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:initGrid();">查询</a>
		</div>

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
							deliveryNo:$("#deliveryNo").val(),
							stkUnit:$("#khNm").val(),												
							billName:$("#xsTp").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							ioType:1,
							status:$("#billStatus").val(),
							wareNm:$("#wareNm").val(),
							vehNo:$("#vehNo").val(),
							customerType:$("#customerType").val(),
							epCustomerName:$("#epCustomerName").val(),
		 					stkId:$("#stkId").val()
							},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
					if($('#showWareCheck').is(':checked')) {
						$('#datagrid').datagrid('showColumn','count');
					}else{
						$('#datagrid').datagrid('hideColumn','count');
					}
	    	   // $('#datagrid').datagrid('reload');  
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					initGrid();
				}
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
				var ret = "<input style='width:60px;height:27px;display:${permission:checkUserFieldDisplay('stk.stkSend.cancel')}' type='button' value='作废' onclick='cancelOut1("+row.id+")'/>";
		      	
      	        return ret;
		      		
		   } 
			
			function formatterSt(v,row){
				var hl='<table>';
				if(row.subList.length>0){
			        hl +='<tr>';
			        hl +='<td width="140px;"><b>商品名称</b></td>';
			       
			        hl +='<td width="60px;"><b>单位</font></b></td>';
			        hl +='<td width="60px;"><b>销售类型</font></b></td>';
			        hl +='<td width="60px;"><b>发货数量</font></b></td>';
			        
			        hl +='<td width="60px;" style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookprice")}"><b>单价</font></b></td>';
			        hl +='<td width="60px;" style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookamt")}"><b>总价</font></b></td>';
			        
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.subList.length;i++){
		            hl +='<tr>';
			        hl +='<td style="text-align:left">'+row.subList[i].wareNm+'</td>';
			        
			        hl +='<td>'+row.subList[i].unitName+'</td>';
			        hl +='<td>'+row.subList[i].xsTp+'</td>';
			        hl +='<td>'+numeral(row.subList[i].outQty).format("0,0.00")+'</td>';
			        
				        hl +='<td style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookprice")}">'+row.subList[i].price+'</td>';
				        hl +='<td style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookamt")}">'+numeral(row.subList[i].outQty *row.subList[i].price).format("0,0.00") +'</td>';
			        
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


		    function onDblClickRow(rowIndex, rowData)
		    {
		    	if(rowData.outType == "销售出库")
		    		{
		    		parent.closeWin('单据信息' + rowData.outId);
		    		parent.add('单据信息' + rowData.outId,'manager/lookstkoutcheck?dataTp=1&billId=' + rowData.outId+'&sendId='+rowData.id);
		    		}
		    	else
		    		{
		    		parent.closeWin('单据信息' + rowData.outId);
		    		parent.add('单据信息' + rowData.outId,'manager/lookstkoutcheck?dataTp=1&billId=' + rowData.outId+'&sendId='+rowData.id);
		    		}
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
