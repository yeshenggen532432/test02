<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>库存明细</title>
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
		<table id="datagrid" fit="true" singleSelect="true"
			url="manager/queryStorageWareList?stkId=${stkId}&wareId=${wareId}&scope=${scope}" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow:checkBiz">

		</table>

		<div id="dlg" closed="true" class="easyui-dialog" title="更新生产日期" style="width:200px;height:120px;padding:10px"
			data-options="
				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						produceDate();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
			<input name="produceDate" id="produceDate"  onClick="WdatePicker();" style="width: 100px;"  />
			<input type="hidden" name="sswId" id="sswId" />
	</div>

		<script type="text/javascript">
		    var database="${database}";
			var showMinUnit = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_STORAGE_SHOW_MINUNIT\"  and status=1")}';
		    initGrid();
			   function initGrid()
			   {
				   var cols = new Array();
				   var col = {
							field: 'stkId',
							title: 'stkId',
							width: 100,
							align:'center',
							hidden:true
					};
				   cols.push(col);
				   var col = {
							field: 'wareId',
							title: 'wareId',
							width: 100,
							align:'center',
							hidden:true


					};
				   cols.push(col);

		    	    var col = {
							field: 'wareNm',
							title: '商品名称',
							width: 100,
							align:'center'


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'unitName',
							title: '单位',
							width: 80,
							align:'center'


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'qty',
							title: '数量',
							width: 80,
							align:'center',
							formatter:amtformatter


					};
		    	    cols.push(col);

						var col = {
								field: 'inPrice',
								title: '单价',
								width: 100,
								align:'center',
								formatter:amtformatter,
								hidden:${!permission:checkUserFieldPdm("stk.storageWare.showprice")}


						};
			    	    cols.push(col);

					var col = {
							field: 'amt',
							title: '金额',
							width: 100,
							align:'center',
							formatter:amtformatter,
							hidden:${!permission:checkUserFieldPdm("stk.storageWare.showamt")}


					};
		    	    cols.push(col);

					var col = {
							field: 'inTimeStr',
							title: '入库日期',
							width: 130,
							align:'center'
					};
		    	    cols.push(col);
		    		var col = {
							field: 'productDate',
							title: '生产日期',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
				   if(showMinUnit==""){//显示小单位
					   var col = {
						   field: 'minUnitName',
						   title: '小单位',
						   width: 100,
						   align:'center'
					   };
					   cols.push(col);

					   var col = {
						   field: 'minSumQty',
						   title: '小单位数量',
						   width: 100,
						   align:'center',
						   formatter:amtformatter
					   };
					   cols.push(col);
				   }
		    	    var col = {
							field: '_oper',
							title: '操作',
							width: 100,
							align:'center',
							formatter:formatterOper
					};
		    	    cols.push(col);
					/*var col = {
							field: 'count',
							title: '批次信息',
							width: 400,
							align:'center',
							formatter:formatterSt


					};
		    	    cols.push(col);*/

					$('#datagrid').datagrid({
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	    $('#datagrid').datagrid('reload');
			   }
			function formatterSt(v,row){
				var hl='<table>';
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>日期</b></td>';
			        if(${stkRight.priceFlag} == 1)
			        hl +='<td width="80px;"><b>价格</b></td>';
			        if(${stkRight.qtyFlag} == 1)
			        hl +='<td width="60px;"><b>数量</font></b></td>';


			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].inTimeStr+'</td>';
			        if(${stkRight.priceFlag} == 1)
			        hl +='<td>'+ numeral(row.list[i].inPrice).format("0,0.00")+'</td>';
			        if(${stkRight.qtyFlag} == 1)
			        hl +='<td>'+numeral(row.list[i].qty).format("0,0.00")+'</td>';

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

			function formatterOper(rowIndex, rowData){
      	       var ret= "<input style='width:80px;height:27px' type='button' value='更新日期' onclick='toProduceDate("+rowData.id+",\""+rowData.productDate+"\")'/>";
      	       return ret;
			}

			function toProduceDate(billId,date)
			{

				$("#produceDate").val(date);
				$("#sswId").val(billId);
				$('#dlg').dialog('open');
			}

			function produceDate()
			{
				 var produceDate=$("#produceDate").val();
				 var sswId = $("#sswId").val();
				 var msg="是否确定更新？";
				$.messager.confirm('确认', msg, function(r) {
					if (r) {
						$.ajax( {
							url : "manager/updateProduceDate",
							data : "sswId=" + sswId + "&produceDate=" +produceDate,
							type : "post",
							success : function(json) {
								if (json.state) {
									$.messager.alert('消息',"更新成功",'info');
									$('#dlg').dialog('close');
									$("#sswId").val("");
									$("#produceDate").val("");
									$("#datagrid").datagrid("reload");
								} else{
									$.messager.alert('消息',"更新失败"+json.msg,'info');
								}
								$("#sswId").val("");
								$("#produceDate").val("");
							}
						});
					}
				});

			}

		    function onDblClickRow(rowIndex, rowData)
		    {
			    parent.closeWin('入库单详细' + rowData.billId);
				parent.add('入库单详细' + rowData.billId,'manager/showstkin?dataTp=1&billId=' + rowData.billId);
		    }

		    function checkBiz(rowIndex, rowData)
			{
				$.ajax( {
					url : "manager/checkBiz",
					data : "batId=" + rowData.id + "&billId=" +rowData.billId,
					type : "post",
					success : function(json) {
						if (json.state) {
							var billName = json.data.billName;
							if("销售退货".indexOf(billName)!=-1){
								parent.closeWin('销售退货详细' + rowData.billId);
								parent.add('销售退货详细' + rowData.billId,'manager/showstkin?dataTp=1&billId=' + rowData.billId);
							}else if(billName=="其它入库"){
								parent.closeWin('其它入库详细' + rowData.billId);
								parent.add('其它入库详细' + rowData.billId,'manager/showstkin?dataTp=1&billId=' + rowData.billId);
							}
							else if(billName=="采购入库"){
								parent.closeWin('采购入库详细' + rowData.billId);
								parent.add('采购入库详细' + rowData.billId,'manager/showstkin?dataTp=1&billId=' + rowData.billId);
							}
							else if(billName=="移库入库"){
								parent.closeWin('移库入库详细' + rowData.billId);
								parent.add('移库入库详细' + rowData.billId,'manager/stkMove/show?billId=' + rowData.billId);
							}else if("拆卸入库".indexOf(billName)!=-1){
								parent.closeWin('拆卸入库详细' + rowData.billId);
								parent.add('拆卸入库详细' + rowData.billId,'manager/stkZzcx/show?billId=' + rowData.billId);
							}else if("组装入库"==billName){
								parent.closeWin('组装入库详细' + rowData.billId);
								parent.add('组装入库详细' + rowData.billId,'manager/stkZzcx/show?billId=' + rowData.billId);
							}
							else if("初始化入库"==billName){
								parent.closeWin('初始化入库详细' + rowData.billId);
								parent.add('初始化入库详细' + rowData.billId,'manager/showStkcheckInit?billId=' + rowData.billId);
							}else if("盘盈"==billName){
								parent.closeWin('盘盈入库详细' + rowData.billId);
								parent.add('盘盈入库详细' + rowData.billId,'manager/showStkcheck?billId=' + rowData.billId);
							}
							else if(billName=="生产入库"){
								parent.closeWin('生产入库详细' + rowData.billId);
								parent.add('生产入库详细' + rowData.billId,'manager/stkProduce/show?billId=' + rowData.billId);
							}
							else if(billName=="领料回库"){
								parent.closeWin('领料回库详细' + rowData.billId);
								parent.add('领料回库详细' + rowData.billId,'manager/showStkLlhkIn?billId=' + rowData.billId);
							}
							/*
							1.采购入库【stk_in】
							2.其它入库【stk_in】
							3.销售退货【stk_in】
							4.移库入库【stk_move】
							5.组装入库【stk_zzcx】
							6.拆卸入库【stk_zzcx】
							7.生产入库【stk_produce】
							8.初始化入库【stk_check】
							9.盘盈【stk_check】
							10.领料回库【stk_llhk_in】
							*/
						} else{
							$.messager.alert('消息',"未找到单据",'info');
						}
					}
				});
			}
		</script>
	</body>
</html>
