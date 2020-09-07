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
	<input type="hidden" id="wareId" value="${wareId}"/>
			<input type="hidden" id="billName" value="${billName}"/>
			<input type="hidden" id="stkId" value="${stkId}"/>
			<input type="hidden" id="billId" value="${billId}"/>

		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/queryInDetailList1?billId=${billId}" title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false"
			toolbar="#tb" data-options="onClickCell: onClickCell,onDblClickRow: onDblClickRow">

		</table>
		<div id="tb" style="padding:5px;height:auto">
		<!--时间: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>




			  <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>-->

			  <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:cancelOut();">批量作废</a>

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
		    //queryBasestorage();

		    initGrid();
		    //querydata;
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
							field: 'ioTimeStr',
							title: '日期',
							width: 100,
							align:'center'


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'billNo',
							title: '单号',
							width: 120,
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
							field: 'stkUnit',
							title: '往来单位',
							width: 100,
							align:'center'


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
							width: 50,
							align:'center'


					};
		    	    cols.push(col);

	    	    var col = {
						field: 'inQty',
						title: '收货数量',
						width: 80,
						align:'center',
						formatter:function(value,row,index){
							return  '<span style="color:blue">'+value+'</span>';
							 }


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
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	    $('#datagrid').datagrid('reload');
			   }
		    //查询物流公司
			function querydata(){

				$("#datagrid").datagrid('load',{
					url:"manager/queryInDetailList1?billId="+${billId},
					wareId:wareId,
					stkId:stkId,
					sdate:sdate,
					edate:edate,
					billName:$("#billName").val()

				});
			}

			function queryBasestorage(){
		    	var path = "manager/queryBaseStorage";
		    	//var token = $("#tmptoken").val();


		    	$.ajax({
		            url: path,
		            type: "POST",
		            data : {"token11":""},
		            dataType: 'json',
		            async : false,
		            success: function (json) {
		            	if(json.state){

		            		var size = json.list.length;
		            		//gstklist = json.list;

		            		var objSelect = document.getElementById("stkId");
		            		//objSelect.options.add(new Option('合部','0'));

		            		for(var i = 0;i < size; i++)
		            			{
		            				objSelect.options.add( new Option(json.list[i].stkName,json.list[i].id));

		            			}


		            	}
		            }
		        });
		    }
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querystorage();
				}
			}
			//导出
			function myexport(){
			     exportData('StkQueryService','queryStorageWarePage','com.cnlife.stk.model.StkStorageVo;',"{wareNm:'"+$("#wareNm").val()+"',stkId:'"+$("#stkId").val()+"',database:'"+database+"}","库存记录");
  			}
			function formatterSt(v,row){
				if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
				var hl='<table>';
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>入库日期</b></td>';
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
			        hl +='<td>'+row.list[i].inPrice+'</td>';
			        if(${stkRight.qtyFlag} == 1)
			        hl +='<td>'+row.list[i].qty+'</td>';

			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}
			function todetail(title,id){
				window.parent.add(title,"manager/queryBforderDetailPage?orderId="+id);
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
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].orderZt=='审核'){
					   alert("该订单审核了，不能删除");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/deleteOrder",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
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
		    function queryBasestorage(){
		    	var path = "manager/queryBaseStorage";
		    	//var token = $("#tmptoken").val();
		    	//alert(token);

		    	$.ajax({
		            url: path,
		            type: "POST",
		            data : {"token11":""},
		            dataType: 'json',
		            async : false,
		            success: function (json) {
		            	if(json.state){

		            		var size = json.list.length;
		            		//gstklist = json.list;

		            		var objSelect = document.getElementById("stkId");
		            		objSelect.options.add(new Option(''),'');
		            		for(var i = 0;i < size; i++)
		            			{
		            				objSelect.options.add( new Option(json.list[i].stkName,json.list[i].id));

		            			}


		            	}
		            }
		        });
		    }
		    function onClickCell(index, field, value){
		    	var rows = $("#datagrid").datagrid("getRows");
		    	var row = rows[index];
		    	if(field == "inQty")
		    	{
		    		//alert(row.wareNm);
		    	}
		    	if(field == "outQty")
		    	{

		    	}
		    }

		    function onDblClickRow(rowIndex, rowData)
		    {
		    //alert(rowData.inQty);
				if(rowData.inQty == 0)
		    	parent.add('销售开票信息' + rowData.billId,'manager/showstkout?dataTp=1&billId=' + rowData.billId);
				else
					parent.add('其它入库单信息' + rowData.billId,'manager/showstkin?dataTp=1&billId=' + rowData.billId);
		    }

		    function cancelOut()
			{
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].billStatus=='作废'){
					   alert("该单已经作废");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '是否确认作废该收货明细？', function(r) {
						if (r) {
							for ( var i = 0; i < rows.length; i++) {
							$.ajax( {
								url : "manager/cancelStkIn",
								data : "billId=" + ids[i],
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
						}
					});
				} else {
					showMsg("请选择要作废的数据");
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

					$.messager.confirm('确认', '是否确认作废收货明细？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/cancelStkIn",
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

		      	var ret = "<input style='width:60px;height:27px' type='button' value='作废' onclick='cancelOut1("+row.id+")'/>";

	      	        return ret;

		   }
		</script>
	</body>
</html>
