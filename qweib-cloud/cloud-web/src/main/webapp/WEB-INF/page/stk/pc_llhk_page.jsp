<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>领料回库分页查询</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
		<thead>
				<tr>

				</tr>
			</thead>	
		</table>
		
		<div id="tb" style="padding:5px;height:auto">	
		<div style="margin-bottom:5px">   

		</div>	
		<div>
			单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			车间: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	        <select style="display: none" name="inType" id="inType">
	                    <option value="领料回库">全部</option>

	                </select>	  		  
	         发票状态: <select name="orderZt" id="billStatus"> 
	                    <option value="">全部</option>
	                    <option value="暂存">暂存</option>
	                    <option value="已收货">已收货</option>
	                    <option value="作废">作废</option>
	                </select>
	          发票日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 70px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 70px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>     		
	          商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>	
	          显示商品信息:<input type="checkbox"  id="showWareCheck" name="showWareCheck" onclick="queryorder()" value="1"/>          
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>

			</div>
		</div>
		<script type="text/javascript">
		    var database="${database}";
		   $("#billStatus").val("暂存");
		    initGrid();
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
							field: 'inDate',
							title: '入库日期',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'inType',
							title: '入库类型',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'proName',
							title: '车间',
							width: 100,
							align:'center'
											
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
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkLlhkPage",
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
		    	    //$('#datagrid').datagrid('reload'); 
		    	    if($('#showWareCheck').is(':checked')) {
						$('#datagrid').datagrid('showColumn','count');
					}else{
						$('#datagrid').datagrid('hideColumn','count');
					}
			}
		   
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkLlhkPage",
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
				var hl='<table>';
				var rowIndex = $("#datagrid").datagrid("getRowIndex",row);
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>商品名称</b></td>';

			        hl +='<td width="60px;"><b>单位</font></b></td>';
			        hl +='<td width="80px;"><b>规格</font></b></td>';

			        hl +='<td width="60px;"><b>数量</font></b></td>';
					hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].wareNm+'</td>';
			        hl +='<td>'+row.list[i].unitName+'</td>';
			        hl +='<td>'+row.list[i].wareGg+'</td>';
			        hl +='<td >'+row.list[i].qty+'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}

			
			
			function amtformatter(v,row)
			{
				if (row != null) {
                    return toThousands(v);
                }
			}


			function onDblClickRow(rowIndex, rowData)
		    {

					parent.closeWin('领料回库单信息' + rowData.id);
					parent.add('领料回库单信息' + rowData.id,'manager/showStkLlhkIn?dataTp=1&billId=' + rowData.id);
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
