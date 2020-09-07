<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>待收货采购发票列表</title>
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
		<thead>
				<tr>

				</tr>
			</thead>	
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     发票单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			 往来单位: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员名称: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			发票日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        发票类型: <select name="inType" id="inType">
	                    <option value="">全部</option>
	                    <option value="采购入库">采购入库</option>
	                    <option value="其它入库">其它入库</option>
	                    <option value="销售退货">销售退货</option>
	                    <option value="采购退货">采购退货</option>
	                </select>	  		  
	         发票状态: <select name="orderZt" id="billStatus">
	                    <option value="未收货">未收货</option>
	                    <option value="">全部</option>
	                    <option value="已收货">已收货</option>
	                    <option value="作废">作废</option>
	                </select>		  
	           商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>	     
	           显示商品信息:<input type="checkbox"  id="showWareCheck" name="showWareCheck" onclick="queryorder()" value="1"/>      
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
		
		   <tag:permission name="收货明细查询" image="icon-search" onclick="javascript:showIndetailquery();"   buttonCode="stk.stkCome.items"></tag:permission>
		</div>
		<script type="text/javascript">
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
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'inDate',
							title: '发票日期',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);

					var col = {
						field: 'operator',
						title: '创建人',
						width: 80,
						align:'center'

					};
					cols.push(col);

		    	    var col = {
							field: 'inType',
							title: '发票类型',
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
						field: 'sumQty',
						title: 'sumQty',
						width: 100,
						align:'center',
						hidden:'true'

					};
					cols.push(col);

				var col = {
					field: 'sumInQty',
					title: 'sumInQty',
					width: 100,
					align:'center',
					hidden:'true'

				};
				cols.push(col);

		    	    var col = {
							field: 'memberNm',
							title: '业务员',
							width: 80,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: '_operator',
							title: '操作',
							width: 80,
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
							field: 'billStatus',
							title: '单据状态',
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
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkInForShPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							proName:$("#proName").val(),
							memberNm:$("#memberNm").val(),
							billStatus:$("#billStatus").val(),
							inType:$("#inType").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
			    	    	wareNm:$("#wareNm").val()
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
			}
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkInForShPage",
					jz:"1",
					billNo:$("#orderNo").val(),
					proName:$("#proName").val(),
					memberNm:$("#memberNm").val(),
					billStatus:$("#billStatus").val(),
					inType:$("#inType").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
	    	    	wareNm:$("#wareNm").val()
				});
				  if($('#showWareCheck').is(':checked')) {
						$('#datagrid').datagrid('showColumn','count');
					}else{
						$('#datagrid').datagrid('hideColumn','count');
					}
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
				}
			}

			function formatterSt(v,row){
				if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
				var hl='<table id="wareTab_'+row.id+'">';
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>商品名称</b></td>';
			        
			        hl +='<td width="60px;"><b>单位</b></td>';
			        hl +='<td width="80px;"><b>规格</b></td>';
			        hl +='<td width="100px;"><b>采购类型</b></td>';
			        hl +='<td width="60px;"><b >数量</b></td>';
			        hl +='<td width="60px;"><b >已收数量</b></td>';
			        hl +='<td width="60px;"><b>未收数量</b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].wareNm+'</td>';
			        
			        hl +='<td>'+row.list[i].unitName+'</td>';
			        hl +='<td>'+row.list[i].wareGg+'</td>';
			        hl +='<td>'+row.list[i].inTypeName+'</td>';
			        hl +='<td class="qtyClass_'+row.id+'">'+row.list[i].qty+'</td>';
			        hl +='<td class="inQtyClass_'+row.id+'">'+row.list[i].inQty+'</td>';
			        hl +='<td>'+row.list[i].inQty1+'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}
			
			function showCheck(billId,title,status)
			{

			   if(status!='未收货'){
				   alert(status+"单据,不能操作");
				   return;
			   }
			   
				parent.closeWin(title+'_收货确认' +billId);
				parent.add(title+'_收货确认' +billId,'manager/showstkincheck?dataTp=1&billId=' + billId);
			}

			
			function onDblClickRow(rowIndex, rowData)
		    {
				   if(rowData.billStatus!='未收货'){
					   alert(rowData.billStatus+"单据,不能操作");
					   return;
				   }
				parent.closeWin('收货入库确认' + rowData.id);
		    	parent.add('收货入库确认' + rowData.id,'manager/showstkincheck?dataTp=1&billId=' + rowData.id);
				
		    }
			
			function showInList(billId)
		    {
		    	parent.closeWin('收货明细' + billId);
		    	parent.add('收货明细' + billId,'manager/indetailquery?billId=' + billId);
		    }
		    function showIndetailquery()
		    {
		    	parent.closeWin('收货明细查询');
		    	parent.add('收货明细查询','manager/indetailquery');
		    	
		    }
			
			
			function formatterSt3(val,row){

				var ret ="";

				if(row.id==""||row.id==null||row.id==undefined){
					ret = "";
					return ret;
				}

				 if(row.sumInQty!=0&&row.sumQty>=row.sumInQty){
					 ret = "<input style='width:60px;height:27px;;display:${permission:checkUserFieldDisplay('stk.stkCome.items')}' type='button' value='收货明细' onclick='showInList("+row.id+")'/>";
				 }

				 if(${stkRight.auditFlag} == 1)
					{
					   if(row.billStatus !='作废'&&row.billStatus=='未收货'){
						 ret = ret + "<br/><input style='width:60px;height:27px;margin-top:2px;;display:${permission:checkUserFieldDisplay('stk.stkCome.shouhuo')}' type='button' value='收货' onclick='showCheck("+row.id+",\""+row.inType+"\",\""+row.billStatus+"\")'/>";
					   }
					}
				return ret;
		   } 
		</script>
	</body>
</html>
