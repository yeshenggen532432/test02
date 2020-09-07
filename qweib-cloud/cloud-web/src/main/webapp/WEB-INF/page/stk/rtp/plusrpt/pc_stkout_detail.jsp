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
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body onload="initGrid()">
		<table id="datagrid"  fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onClickCell: onClickCell,onLoadSuccess: onLoadSuccess,onDblClickRow:onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">

			时间类型:<select name="timeType" id="timeType">
			<option value="2">发票时间</option>
			<option value="1">发货时间</option>
			<option value="3">收款时间</option>
		</select>
			: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	            <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			出库类型:<tag:outtype id="outType" name="outType" style="width:100px" onchange="changeOutType()"></tag:outtype>
			销售类型:<tag:saleType id="xsTp" name="xsTp"></tag:saleType>

        仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage" headerKey="-1" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>    
	        业务员: <input name="staff" id="staff" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	     客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
	        客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	        所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	        商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			显示发货日期:<input type="checkbox"   id="showSendDate" name="showWareCheck" onclick="queryData()" value="1"/>
			显示收款日期:<input type="checkbox"   id="showRecDate" name="showWareCheck" onclick="queryData()" value="1"/>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>
	               <a class="easyui-linkbutton" href="javascript:createRptData();">生成报表</a>
	               <a class="easyui-linkbutton" href="javascript:queryRpt();">查询生成的报表</a>
			<a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>
			业务类型：
			<select id="saleType" name="saleType" onchange="queryData()">
				<option value="">全部</option>
				<option value="001">传统业务类</option>
				<option value="003">线上商城</option>
				<option value="004">线下门店</option>
			</select>
		</div>
		<input type="hidden" id="database" value="${database}"/>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		   //查询
		   //initGrid();
		   function initGrid()
		   {
			   var cols = new Array(); 
	    	   var col = {
						field: 'docNo',
						title: '单号',
						width: 140,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'khNm',
						title: '客户名称',
						width: 140,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    
	    	    var col = {
						field: 'wareNm',
						title: '商品名称',
						width: 120,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'xsTp',
						title: '销售类型',
						width: 100,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'unitName',
						title: '计量单位',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'price',
						title: '销售单价',
						width: 100,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'qty',
						title: '发票数量',
						width: 100,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'amt',
						title: '发票金额',
						width: 100,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'outQty',
						title: '发货数量',
						width: 100,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);
				var col = {
						field: 'outAmt',
						title: '发货金额',
						width: 100,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);

			   var col = {
				   field: 'sendTimeStr',
				   title: '发货时间',
				   width: 80,
				   align:'center',
				   formatter:sendformatter
			   };
			   cols.push(col);

	    	    
	    	    var col = {
						field: 'recAmt',
						title: '回款金额',
						width: 100,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);

			   var col = {
				   field: 'recTimeStr',
				   title: '回款时间',
				   width: 80,
				   align:'center',
				   formatter:recformatter
			   };
			   cols.push(col);
	    	    
	    	    var col = {
						field: 'needRec',
						title: '未回款金额',
						width: 100,
						align:'center',
						formatter:amtformatter
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
						field: 'vehNos',
						title: '配送车辆',
						width: 140,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'epCustomerName',
						title: '所属二批',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'remarks',
						title: '备注',
						width: 100,
						align:'center'
				};
	    	    cols.push(col);
				$('#datagrid').datagrid({
    	    		columns:[
    	    		  		cols
    	    		  	]
						}
    	    );


			   if($('#showSendDate').is(':checked')) {
				   $('#datagrid').datagrid('showColumn','sendTimeStr');

			   }else{
				   $('#datagrid').datagrid('hideColumn','sendTimeStr');

			   }

			   if($('#showRecDate').is(':checked')) {
				   $('#datagrid').datagrid('showColumn','recTimeStr');

			   }else{
				   $('#datagrid').datagrid('hideColumn','recTimeStr');

			   }



		   }
		   function queryData(){
			   var showSendDateCheck="0";

			   if($('#showSendDate').is(':checked')){
				   showSendDateCheck="1";
			   }

			   var showRecDateCheck="0";

			   if($('#showRecDate').is(':checked')){
				   showRecDateCheck="1";
			   }

			   $('#datagrid').datagrid({
					url:"manager/queryStkOutDetail",
					queryParams:{
						stkId:$("#stkId").val(),
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						outType:$("#outType").val(),
						xsTp:$('#xsTp').combobox('getValues')+"",
						staff:$("#staff").val(),
						saleType:$("#saleType").val(),
						khNm:$("#khNm").val(),
						customerType:$("#customerType").val(),
						epCustomerName:$("#epCustomerName").val(),
						wareNm:$("#wareNm").val(),
						isShowRecDate:showRecDateCheck,
						timeType:$("#timeType").val()
						}
						}
   	   			 );

			   if($('#showSendDate').is(':checked')) {
				   $('#datagrid').datagrid('showColumn','sendTimeStr');

			   }else{
				   $('#datagrid').datagrid('hideColumn','sendTimeStr');

			   }

			   if($('#showRecDate').is(':checked')) {
				   $('#datagrid').datagrid('showColumn','recTimeStr');

			   }else{
				   $('#datagrid').datagrid('hideColumn','recTimeStr');

			   }

		   }

		   function changeOutType(){
			   var v = $("#outType").val();
			   $('#xsTp').combobox('loadData',{});
			   $('#xsTp').combobox('setValue', '');
			   // if(v==""){
			   //    $('#xsTp').combobox('loadData',allData);
			   // }else
			   //
			   if(v=="销售出库"){
				   $('#xsTp').combobox('loadData',outData);
			   }else if(v=="其它出库"){
				   $('#xsTp').combobox('loadData',otherData);
			   }
		   }
		   $(function(){
			   $("#xsTp").combobox('loadData', outData);
		   })
		   function formatterMny(v)
			{
				if (v != null) {
                   return numeral(v).format("0,0.00");
               }else{
            	   return v; 
               }
			}
			function amtformatter(v,row)
			{
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}

		   function sendformatter(v,row)
		   {
			   if (row != null) {
			   	if(v == undefined)return "";
				   if(row.isMutiSend == 0)return v;
				   else
				   return '<u style="color:blue;cursor:pointer">' + v + '</u>';
			   }
		   }

		   function recformatter(v,row)
		   {
			   if (row != null) {
				   if(v == undefined)return "";
				   if(row.isMutiRec == 0)return v;
				   else
				   return '<u style="color:blue;cursor:pointer">' + v + '</u>';
			   }
		   }
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					 queryData();
				}
			}
			
			function onDblClickRow(rowIndex, rowData)
		    {
				if(rowData.xsTp == "销售退货")
				{
					parent.add('销售退货开单','manager/showstkin?billId='+rowData.id);
				}
				else if(rowData.xsTp != "终端零售"){
					parent.closeWin('发票信息' + rowData.id);
					parent.add('发票信息' + rowData.id, 'manager/showstkout?dataTp=1&billId=' + rowData.id);
				}
				else if(rowData.xsTp == "终端零售")
				{
					parent.closeWin('终端零售' + rowData.id);
					parent.add("终端零售" + rowData.id, "manager/pos/toPosShopBillDetail?mastId=" + rowData.id);

				}
		    }
		    
		    function onLoadSuccess(data) {
		    	
        		var start = 0;
       	 		var end = 0;
        		if (data.total > 0) {
            	var temp = data.rows[0].docNo;
            	for (var i = 1; i < data.rows.length; i++) {
                if (temp == data.rows[i].docNo) {
                    end++;
                } else {
                    if (end > start) {
                         $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'docNo'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'khNm'
                        });
                        
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'recAmt'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'needRec'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'staff'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'vehNos'
                        });

						$("#datagrid").datagrid('mergeCells', {
							index: start,
							rowspan: end - start + 1,
							field: 'sendTimeStr'
						});

						$("#datagrid").datagrid('mergeCells', {
							index: start,
							rowspan: end - start + 1,
							field: 'recTimeStr'
						});
                        
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'epCustomerName'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'remarks'
                        });
                    }
                    temp = data.rows[i].docNo;
                    start = i;
                    end = i;
                }
            	}
            
            	if (end > start) {
            		$("#datagrid").datagrid('mergeCells', {
                        index: start,
                        rowspan: end - start + 1,
                        field: 'docNo'
                    });
                    $("#datagrid").datagrid('mergeCells', {
                        index: start,
                        rowspan: end - start + 1,
                        field: 'khNm'
                    });
                    
                    $("#datagrid").datagrid('mergeCells', {
                        index: start,
                        rowspan: end - start + 1,
                        field: 'recAmt'
                    });
                    $("#datagrid").datagrid('mergeCells', {
                        index: start,
                        rowspan: end - start + 1,
                        field: 'needRec'
                    });
                    $("#datagrid").datagrid('mergeCells', {
                        index: start,
                        rowspan: end - start + 1,
                        field: 'staff'
                    });
                    $("#datagrid").datagrid('mergeCells', {
                        index: start,
                        rowspan: end - start + 1,
                        field: 'vehNos'
                    });
					$("#datagrid").datagrid('mergeCells', {
						index: start,
						rowspan: end - start + 1,
						field: 'sendTimeStr'
					});

					$("#datagrid").datagrid('mergeCells', {
						index: start,
						rowspan: end - start + 1,
						field: 'recTimeStr'
					});
                    
                    $("#datagrid").datagrid('mergeCells', {
                        index: start,
                        rowspan: end - start + 1,
                        field: 'epCustomerName'
                    });
                    $("#datagrid").datagrid('mergeCells', {
                        index: start,
                        rowspan: end - start + 1,
                        field: 'remarks'
                    });
            		}
        		}
    		}
			
			function mergeCol(data,colName){
				var start = 0;
       	 		var end = 0;
        		if (data.total > 0) {
            	var temp = data.rows[0][colName];
            	for (var i = 1; i < data.rows.length; i++) {
                if (temp == data.rows[i][colName]) {
                    end++;
                } else {
                    if (end > start) {
                         $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: colName
                        });
                    }
                    temp = data.rows[i][colName];
                    start = i;
                    end = i;
                }
            	}
            /*这里是为了判断重复内容出现在最后的情况，如ABCC*/
            	if (end > start) {
                 $("#datagrid").datagrid('mergeCells', {
                    index: start,
                    rowspan: end - start + 1,
                    field: colName
                });
            		}
        		}
        		
			}

			
			function createRptData()
		    {
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var outType = $("#outType").val();
		    	var staff = $("#staff").val();
		    	var khNm = $("#khNm").val();
		    	var customerType = $("#customerType").val();
		    	var epCustomerName = $("#epCustomerName").val();
		    	var xsTp = $('#xsTp').combobox('getValues')+"";
		    	var wareNm = $("#wareNm").val();
				var saleType=$("#saleType").val();
				var timeType=$("#timeType").val();
		    	//alert(outType);

		    	var paramStr = 'sdate=' + sdate + '&edate=' + edate +'&outType=' + outType+'&staff=' + staff + '&khNm=' + khNm + '&customerType=' + customerType+'&saleType='+saleType+'&epCustomerName=' + epCustomerName + '&xsTp=' + xsTp + '&wareNm=' + wareNm + '&timeType=' + timeType;
		    	parent.closeWin('生成销售票据明细表');
		    	//parent.add('生成销售票据明细表','manager/toStkOutDetailSave?sdate=' + sdate + '&edate=' + edate +'&outType=销售出库'+'&staff=' + staff + '&khNm=' + khNm + '&customerType=' + customerType+'&epCustomerName=' + epCustomerName);
		    	parent.add('生成销售票据明细表','manager/toStkOutDetailSave?' + paramStr);
		    }
			
			function queryRpt()
		    {
		    	parent.closeWin('生成的统计表');
		    	parent.add('生成的统计表','manager/toStkCstStatQuery?rptType=8');
		    }
			
			 function formatAutoAmt(val,row,index){
			    	var price = "";
			    	var map = row.autoMap
			    	var html ="";	
			    	for(var key in map){
			    		  if(key==this.value){
			    			  html = map[key];
			    		  }
			    		}
			    	return formatterMny(html);
;
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

		   function myexport(){
			   var database = $("#database").val();
			   var showSendDateCheck="0";

			   if($('#showSendDate').is(':checked')){
				   showSendDateCheck="1";
			   }

			   var showRecDateCheck="0";

			   if($('#showRecDate').is(':checked')){
				   showRecDateCheck="1";
			   }

			   var stkId = $("#stkId").val();
			   var  sdate =$("#sdate").val();
			   var edate=$("#edate").val();
			   var outType=$("#outType").val();
			   var xsTp =$('#xsTp').combobox('getValues')  +"";
			   var staff =$("#staff").val();
			   var saleType =$("#saleType").val();
			   var khNm=$("#khNm").val();
			   var customerType =$("#customerType").val();
			   var epCustomerName=$("#epCustomerName").val();
			   var wareNm =$("#wareNm").val();

			   var c = {
				   database: database,
				   stkId: stkId,
				   sdate: sdate,
				   edate: edate,
				   outType: outType,
				   xsTp:xsTp,
				   staff: staff,
				   xsTp: xsTp,
				   saleType:saleType,
				   khNm:khNm,
				   customerType:customerType,
				   epCustomerName:epCustomerName,
				   wareNm: wareNm,
				   isShowRecDate:showRecDateCheck,
				   timeType:$("#timeType").val()

			   }

			   exportData('incomeStatService','sumStkOutMast','com.qweib.cloud.biz.erp.model.StkOut',JSON.stringify(c),"销售票据明细表");


		   }

		   function onClickCell(index, field, value) {
			   var rows = $("#datagrid").datagrid("getRows");
			   var row = rows[index];
			   if (field == "sendTimeStr"&&row.isMutiSend == 1) {
			   	  if(row.xsTp!="销售退货") {

					  parent.add('发货明细' + row.mastId, 'manager/toOutList?billId=' + row.mastId);
				  }
			   	  else {
					  parent.add('收货明细' + row.mastId, 'manager/indetailquery?billId=' + row.mastId);
				  }
			   }
			   if(field == "recTimeStr"&&row.isMutiRec == 1)
			   {
				   if(row.xsTp!="销售退货") {
					   parent.closeWin('收款记录' + row.mastId);
					   parent.add('收款记录' + row.mastId, 'manager/queryRecPageByBillId?dataTp=1&billId=' + row.mastId);
				   }
				   else
				   {
					   parent.closeWin('付款记录' + row.mastId);
					   parent.add('付款记录' + row.mastId,'manager/queryPayPageByBillId?dataTp=1&sourceBillNo='+row.docNo+'&billId=' + row.mastId);
				   }
			   }
		   }
		</script>
	</body>
</html>
