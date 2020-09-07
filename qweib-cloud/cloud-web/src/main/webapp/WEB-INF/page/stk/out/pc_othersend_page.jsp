<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
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
		<table id="datagrid"  fit="true" singleSelect="false"
			 title=""  border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		<div style="margin-bottom:5px"> 
		<tag:permission name="其它出库开单" image="icon-add" onclick="javascript:newOtherBill();"   buttonCode="stk.stkOut.createother"></tag:permission>
		<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newLossBill();">报损开单</a>
		<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newBorrowBill();">借出开单</a>
		<%--<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newCollarBill();">领用开单</a>--%>
		<tag:permission name="销货商品信息" image="icon-add" onclick="javascript:toOutWareSale();"   buttonCode="stk.stkOut.ghwaredesc"></tag:permission>
		<tag:permission name="批量打印" image="icon-add" onclick="javascript:printBattch();"   buttonCode="stk.stkOut.ghwaredesc"></tag:permission>
		<%--
		<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newOut(0);">销售开单</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newOtherBill();">其它出库开单</a>
			<a id = "cancelBtn" class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toOutWareSale();">销货商品信息</a> 
	 --%>
		</div>
		<div>
		     发票单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		    发票类型: <select name="outType" id="outType">
	                    <option value=""></option>	                   
	                    <option value="其它出库">其它出库</option>
	                    <option value="报损出库">报损出库</option>
	                    <%--<option value="领用出库">领用出库</option>--%>
	                    <option value="借出出库">借出出库</option>
	                </select>  
		     客户类型: <select name="customerType" id="customerType" style="width: 80px;"></select>
			客户名称: <input name="khNm" id="khNm" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
			所属二批: <input name="epCustomerName" id="epCustomerName" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员名称: <input name="memberNm" id="memberNm" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
			发票状态: <select name="orderZt" id="billStatus">
	         			<option value="">全部</option>
	         			 <option value="暂存">暂存</option>	   
	                    <option value="未发货">未发货</option>	                   
	                    <option value="已发货">已发货</option>
	                    <option value="作废">作废</option>
	                     <option value="终止未发完">终止未发完</option>
	                </select>	
	            <br/>    
			发票日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 80px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 80px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        配送指定: <select name="pszd" id="pszd">
	                    <option value="">全部</option>
	                    <option value="公司直送">公司直送</option>
	                    <option value="直供转单二批">直供转单二批</option>
	                </select>	 
	             <c:set var="datas" value="${fns:loadListByParam('stk_storage','id,stk_name,sale_car','')}"/>
			<%--仓库：<select id="stkId" name="stkId">
					<option value="-1">--请选择--</option>
				<c:forEach items="${datas}" var="map">
					<option value="${map['id']}">${map['stk_name']}${(map['sale_car'] eq '1')?"_车销":""}</option>
				</c:forEach>
				</select> 
			 --%>	   
	      仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage"
						 whereBlock="status=1 or status is null"
						 headerKey="-1" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>
	     <select name="saleCar" id="saleCar" style="display: none"  onchange="queryorder()">
                   <option value="">全部</option>
                   <option value="1">是</option>
                   <option value="0">否</option>
	     </select>		
	   商品名称: <input name="wareNm" id="wareNm" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
	    备注: <input name="remarks" id="remarks" style="width:80px;height: 20px;" />
	   <input type="checkbox"  id="showNoModify" name="showNoModify" style="display: none " onclick="queryorder()"  value="1"/>
	     显示商品信息:<input type="checkbox"  id="showWareCheck" name="showWareCheck" onclick="queryorder()" value="1"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			
			
			
			
			
			<!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->
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
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
		    $("#billStatus").val("${billStatus}");
		    $("#saleCar").val("0");
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
							field: 'billNo',
							title: '发票单号',
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
							field: 'billStatus',
							title: '发票状态',
							width: 60,
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
							field: 'staff',
							title: '业务员',
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
		    	    var showNoModify = "";
		    	    if($('#showNoModify').is(':checked')) {
		    	    	showNoModify ="1";
		    	    }
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkOtherPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							khNm:$("#khNm").val(),
							memberNm:$("#memberNm").val(),
							billStatus:$("#billStatus").val(),
							pszd:$("#pszd").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							outType:$("#outType").val(),
							customerType:$("#customerType").val(),
							epCustomerName:$("#epCustomerName").val(),
							wareNm:$("#wareNm").val(),
							stkId:$("#stkId").val(),
							remarks:$("#remarks").val(),
							showNoModify:showNoModify,
							saleCar:$("#saleCar").val()
		    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	],
		    	       onLoadSuccess:function(data){   	  	
		    	    	   var rows=$('#datagrid').datagrid("getRows");
		    	    	   if (rows.length > 0) {
		    	    		   for(var i=0;i<rows.length;i++){
		    	    			   $.ajax( {
		    	    					url : "manager/sysPrintRecord/queryPrintCount",
		    	    					data :  {fdSourceId:rows[i].id,fdModel:'com.cnlife.stk.model.StkOutsub'},
		    	    					type : "post",
		    	    					async : true,
		    	    					success : function(json) {
		    	    						    	document.getElementById("print"+json.id).value="打印("+json.count+")";
		    	    						    }
		    	    					});
		    	    		   }
		    	    	   }
		    	      	 }
		    	    	}
		    	    );
		    	    
	    	    if($('#showWareCheck').is(':checked')) {
					$('#datagrid').datagrid('showColumn','count');
				}else{
					$('#datagrid').datagrid('hideColumn','count');
				}
			}
			function queryorder(){
				var showNoModify = "";
	    	    if($('#showNoModify').is(':checked')) {
	    	    	showNoModify ="1";
	    	    }
				$("#datagrid").datagrid('load',{
					url:"manager/stkOtherPage?database="+database,
					jz:"1",
					billNo:$("#orderNo").val(),
					khNm:$("#khNm").val(),
					memberNm:$("#memberNm").val(),
					billStatus:$("#billStatus").val(),
					pszd:$("#pszd").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					wareNm:$("#wareNm").val(),
					outType:$("#outType").val(),
					stkId:$("#stkId").val(),
					customerType:$("#customerType").val(),
					epCustomerName:$("#epCustomerName").val(),
					remarks:$("#remarks").val(),
					showNoModify:showNoModify,
					saleCar:$("#saleCar").val()
				});
				  if($('#showWareCheck').is(':checked')) {
						$('#datagrid').datagrid('showColumn','count');
					}else{
						$('#datagrid').datagrid('hideColumn','count');
					}
			}
			function formatterSt3(val,row){
				 if(row.outType==""||row.outType==null||row.outType==undefined){
					return "";
				 }
		      	var ret = "<input style='width:60px;height:27px' id='print"+row.id+"' type='button' value='打印' onclick='printBill("+row.id+")'/>";
		      	
		      	if(row.billStatus=='作废'){
		      		ret += "<br/><input style='width:60px;height:27px' type='button' value='复制' onclick='copyBill(\""+row.id+"\",\""+row.orderId+"\",\""+row.outType+"\")'/>";
		      	}
		      	if(row.billStatus=='暂存'){
		      		ret += "<br/><input style='width:60px;height:27px' type='button' value='审批' onclick='auditDraftStkOut(\""+row.id+"\",\""+row.billStatus+"\",\""+row.billNo+"\")'/>";
		      	}
		      	return ret;
		   } 
			function formatternt(val,row){
				 if(row.outType==""||row.outType==null||row.outType==undefined){
						return "";
					 }
				 if(val==""||val==null||val==undefined){
					return "未修改";
				 }
		      	return "已修改";
		   } 
			 function printBill(billId)
			    {	    	
				 if(billId==""||billId==0){
						return "";
					}
			    	parent.closeWin('发票信息' + billId);
			    	parent.add('发票信息' + billId,'manager/showstkoutprint?fromFlag=1&billId=' + billId);
			    }
			 
			 function printBattch()
			    {	    	
				 	var ids = "";
					var rows = $("#datagrid").datagrid("getSelections");
					for ( var i = 0; i < rows.length; i++) {
						//ids.push(rows[i].id);
						if(ids!=""){
							ids +=","; 
						}
						ids +=rows[i].id;
					}
					if(ids=="")
						{
							$.messager.alert('消息','请选择发票','info');
							return;
						}
					parent.closeWin('批量打印发票');
			    	parent.add('批量打印发票','manager/showstkoutbatchprint?printType=1&fromFlag=1&billIds=' + ids);
			    }
			 
			 function copyBill(billId,orderId,title)
			    {	    	
				 if(orderId==""||orderId==0){
						parent.closeWin(title);
				    	parent.add(title,'manager/copystkout?billId=' + billId);
				  }else{
					  $.ajax({
							url:"manager/checkOrderIsUse",
							type:"post",
							data:"orderId="+orderId,
							success:function(data){
								if(!data.state){
									parent.closeWin(title);
									parent.add(title,'manager/copystkout?billId=' + billId);
								}else{
									$.messager.alert('消息','该单据是由销售订单生成的销售发票单，不能复制，只有作废该发票单，才能复制!','info');
									return;
								}
							}
						});
				  }
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
			function formatterSt(v,row){
				if(row.list==null||row.list==undefined){
					return "";
				}
				var hl='<table>';
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>商品名称</b></td>';
			        hl +='<td width="80px;"><b>销售类型</b></td>';
			        hl +='<td width="60px;"><b>单位</font></b></td>';
			        hl +='<td width="80px;"><b>规格</font></b></td>';
			        hl +='<td width="60px;"><b>数量</font></b></td>';
			        hl +='<td width="60px;"><b>单价</font></b></td>';
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
			        hl +='<td>'+row.list[i].qty+'</td>';
			        hl +='<td>'+row.list[i].price+'</td>';
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
				parent.closeWin('销售发票');
				parent.add('销售发票','manager/pcstkout?orderId=0');
			}
			
			function newOtherBill()
			{
				parent.closeWin('其它出库');
				parent.add('其它出库','manager/pcotherstkout');
			}
			function newLossBill()
			{
				parent.closeWin('报损出库');
				parent.add('报损出库','manager/pclossstkout');
			}
			function newBorrowBill()
			{
				parent.closeWin('借出出库');
				parent.add('借出出库','manager/pcborrowstkout');
			}
			function newCollarBill(){
				parent.closeWin('领用出库');
				parent.add('领用出库','manager/pccollarstkout');
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

		    function showCheck()
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
				/*if(rows[0].billStatus == "已审")
					{
						alert("该单据已经审核");
						return;
					}*/
					parent.closeWin('发货' + ids[0]);
				parent.add('发货' + ids[0],'manager/showstkoutcheck?dataTp=1&billId=' + ids[0]);
			}
		    function onDblClickRow(rowIndex, rowData)
		    {
		  /*   if(rowData.outType == "销售出库")
		    	parent.add('销售发票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id);
		    else if(rowData.outType == "报损出库")
		    	parent.add('报损发票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id);
		    else
		    	parent.add('其它发票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id); */
		    	parent.closeWin('发票信息' + rowData.id);
		    	parent.add('发票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id);
		    }
		    

			function toOutWareSale(){
				  var billNos = "";
					var rows = $("#datagrid").datagrid("getSelections");
					for(var i=0;i<rows.length;i++){
						if(billNos.length>0){
							billNos = billNos + ",";
						}
						billNos = billNos+"'"+rows[i].billNo+"'";
					}
					if(billNos==""){
						$.messager.alert('消息','请勾选行！','info');
						return;
					}
				parent.add('销货商品信息','manager/outWareListForGs?billNo='+billNos);
			}
			
		    
		    function newOut(orderId)
			{
		    	parent.closeWin("销售开单");
				parent.add("销售开单","manager/pcstkout?orderId=" + orderId);
			}
		    
		  
		    function auditDraftStkOut(billId,status,billNo)
		    {
		    	if(status!='暂存'){
		    		 $.messager.alert('消息','只有暂存的单据才需要审批!','info');
					 return;
				}
		        $.messager.confirm('确认', '是否确定审核'+billNo+'?',function(r){
		    		if(r){
		    		    var path = "manager/auditDraftStkOut";
		    		    $.ajax({
		    		        url: path,
		    		        type: "POST",
		    		        data : {"token":"","billId":billId,"changeOrderPrice":0},
		    		        dataType: 'json',
		    		        async : false,
		    		        success: function (json) {
		    		        	if(json.state){
		    		        		 //$.messager.alert('消息','审核成功','info');
		    		        		 queryorder();
		    		        	}
		    		        	else
		    		        	{
		    		        		 $.messager.alert('消息','审核失败','info');
		    		        	}
		    		        	}
		    		    	});
		        }});
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
