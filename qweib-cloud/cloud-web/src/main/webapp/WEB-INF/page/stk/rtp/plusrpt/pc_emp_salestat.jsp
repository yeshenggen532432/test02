<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>业务销售统计表</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
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
	                  <option value="1">发货时间</option>
	                  <option value="2">发票时间</option>
	                  <option value="3">收款时间</option>
	            </select>
		   : <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 70px;" value="${sdate}" readonly="readonly"/>
	            <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 70px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			出库类型:<tag:outtype id="outType" name="outType" style="width:100px" onchange="changeOutType()"></tag:outtype>
			销售类型:<tag:saleType id="xsTp" name="xsTp"></tag:saleType>
			业务员: <input name="staff" id="staff" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
	    	商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			资产类型:<tag:zctype id="isType" name="isType"></tag:zctype>
			商品类别: <input name="wtype" type="hidden" id="wtype" />
			<input name="wtypeName" ondblclick="setWareType('','')" readonly="true"  style="width:80px" id="wtypeName" />
			<a onclick="selectWareType()" href="javascript:;;">选择</a>

	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>
	               <a class="easyui-linkbutton" id="expandBtn" iconCls="icon-edit" href="javascript:expandClick();">展开/收起</a>
	               <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>
	               <a class="easyui-linkbutton" href="javascript:createRptData();">生成报表</a>
	               <a class="easyui-linkbutton" href="javascript:queryRpt();">查询生成的报表</a>
		</div>
		<div id="wareTypeDlg" closed="true" class="easyui-dialog"   title="选择商品类别" style="width:250px;height:450px;padding:10px">
			<iframe  name="wareTypefrm" id="wareTypefrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<input type="hidden" id="isExpand" value="1"/>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		 var autoTitleDatas = eval('${autoTitleJson}');
		 var autoPriceDatas = eval('${autoPriceJson}');
		   //查询
		   //initGrid();
		   function initGrid()
		   {
			   var cols = new Array();
	    	   var col = {
						field: 'staff',
						title: '业务员',
						width: 140,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'branchName',
						title: '部门',
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
						field: 'recAmt',
						title: '回款金额',
						width: 100,
						align:'center',
						formatter:amtformatter
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
	    	    $('#datagrid').datagrid({
	                columns:[[]]

	            });
				$('#datagrid').datagrid({
    	    		columns:[
    	    		  		cols
    	    		  	]
						}
    	    );
			var isExpand = $("#isExpand").val();
			if(isExpand == "1")
				{
				$('#datagrid').datagrid('hideColumn', 'wareNm');//列的field值
	   			$('#datagrid').datagrid('hideColumn', 'xsTp');//列的field值
	   			$('#datagrid').datagrid('hideColumn', 'unitName');//列的field值
	   			$('#datagrid').datagrid('hideColumn', 'price');//列的field值
				}
		   }
		   function expandClick()
		   {
			   var isExpand = $("#isExpand").val();
			   if(isExpand == "1")
				   {
				   		$("#isExpand").val(0);
				   		$('#datagrid').datagrid('showColumn', 'wareNm');//列的field值
			   			$('#datagrid').datagrid('showColumn', 'xsTp');//列的field值
			   			$('#datagrid').datagrid('showColumn', 'unitName');//列的field值
			   			$('#datagrid').datagrid('showColumn', 'price');//列的field值
				   		//$("#expandBtn").text("收起");
				   }
			   else
				   {
				   		$("#isExpand").val(1);
			   			//$("#expandBtn").text("展开");
			   			$('#datagrid').datagrid('hideColumn', 'wareNm');//列的field值
			   			$('#datagrid').datagrid('hideColumn', 'xsTp');//列的field值
			   			$('#datagrid').datagrid('hideColumn', 'unitName');//列的field值
			   			$('#datagrid').datagrid('hideColumn', 'price');//列的field值
				   }
			   queryData();


		   }

		   function queryData(){
			   var isExpand = $("#isExpand").val();

			   var xsTp = $('#xsTp').combobox('getValues')+"";
			   $('#datagrid').datagrid({
					url:"manager/queryEmptatMast",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						outType:$("#outType").val(),
						xsTp:xsTp,
						staff:$("#staff").val(),
						timeType:$("#timeType").val(),
						wareNm:$("#wareNm").val(),
						isExpand:isExpand,
						isType:$("#isType").val(),
						waretype:$("#wtype").val()
						}
						}
   	   			 );
		   }
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
				if(v == null)return "";
			   	if(v=="0E-7"){
			   		return "0.00";
			   	}
			   	var ret = "";
			   	if (row != null) {
			           ret= numeral(v).format("0,0.00");
			    }

				return '<u style="color:blue;cursor:pointer">' + ret + '</u>';
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
				var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				var xsTp = rowData.xsTp;
				var empId=rowData.empId;
				var wareId = rowData.wareId;
				if(xsTp == undefined)xsTp = "";
				if(empId == undefined)empId = 0;
				if(wareId == undefined)wareId = 0;
				var timeType = $("#timeType").val();
                var isType = $("#isType").val();
				parent.closeWin('业务销售统计明细');
				parent.add('业务销售统计明细','manager/toStkEmpStatDetail?sdate=' + sdate + '&edate=' + edate +'&empId='+empId+'&xsTp=' + xsTp + '&wareId=' + wareId + '&timeType=' + timeType + '&isType=' + isType);
		    }

		    function onLoadSuccess(data) {
		    	var isExpand = $("#isExpand").val();
		    	if(isExpand == "1")return;
        		var start = 0;
       	 		var end = 0;
        		if (data.total > 0) {
            	var temp = data.rows[0].staff;
            	for (var i = 1; i < data.rows.length; i++) {
                if (temp == data.rows[i].staff) {
                    end++;
                } else {
                    if (end > start) {
                         $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'staff'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'branchName'
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
                    }
                    temp = data.rows[i].staff;
                    start = i;
                    end = i;
                }
            	}

            	if (end > start) {
                 		$("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'staff'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'branchName'
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
			//
			// function showMainDetail(){
			// 	var sdate = $("#sdate").val();
		    // 	var edate = $("#edate").val();
		    // 	var outType = $("#xsTp").val();
		    // 	var stkUnit = $("#khNm").val();
		    // 	var epCustomerName = $("#epCustomerName").val();
		    // 	var customerType = $("#customerType").val();
		    // 	parent.closeWin('客户毛利明细统计表');
		    // 	parent.add('客户毛利明细统计表','manager/queryAutoCstStatDetail?sdate=' + sdate + '&edate=' + edate +'&epCustomerName='+epCustomerName+'&outType=' + outType + '&customerType='+customerType+'&stkUnit=' + stkUnit);
			// }
			//

			function createRptData()
		    {
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var outType = $("#outType").val();
		    	var staff = $("#staff").val();
		    	//var xsTp = $("#xsTp").val();
                var isType =$("#isType").val();
				var xsTp = $('#xsTp').combobox('getValues')+"";
		    	var dateType = $("#timeType").val();
		    	var wareNm = $("#wareNm").val();
		    	parent.closeWin('生成业务销售统计汇总表');
		    	parent.add('生成业务销售统计汇总表','manager/toStkEmpStatSave?sdate=' + sdate + '&edate=' + edate +'&outType='+outType+'&staff=' + staff + '&timeType=' + dateType + '&xsTp=' + xsTp + '&wareNm=' + wareNm + '&isType=' + isType);
		    }

			function queryRpt()
		    {
		    	parent.closeWin('生成的统计表');
		    	parent.add('生成的统计表','manager/toStkCstStatQuery?rptType=7');
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
			 function addDate(date, days) {
		            if (days == undefined || days == '') {
		                days = 1;
		            }
		            var date = new Date(date);
		            date.setDate(date.getDate() + days);
		            var month = date.getMonth() + 1;
		            var day = date.getDate();
		            return date.getFullYear() + '-' + getFormatDate(month) + '-' + getFormatDate(day);
		        }
			 function getFormatDate(arg) {
		            if (arg == undefined || arg == '') {
		                return '';
		            }

		            var re = arg + '';
		            if (re.length < 2) {
		                re = '0' + re;
		            }

		            return re;
		        }
			 function myexport(){
					var database = $("#database").val();
					var sdate=$("#sdate").val();
					var edate=$("#edate").val();
					edate = addDate(edate,1);
					var outType=$("#outType").val();
					var staff=$("#staff").val();
					var xsTp=$("#xsTp").val();
					var timeType= $("#timeType").val();
					var wareNm= $("#wareNm").val();
					var isExpand= $("#isExpand").val();
                 var isType = $("#isType").val();

					var c = {
						database: database,
						sdate: sdate,
						edate: edate,
						outType: outType,
						staff: staff,
						xsTp: xsTp,
						timeType: timeType,
						wareNm: wareNm,
						isExpand: parseInt(isExpand),
                        isType:isType
					}
					exportData('incomeStatService','sumEmpStatMast','com.qweib.cloud.biz.erp.model.StkOut',JSON.stringify(c),"业务销售统计表");

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


		 function selectWareType() {
			 var isType=$("#isType").val();
			 document.getElementById("wareTypefrm").src='${base}/manager/selectDialogWareType?isType='+isType;
			 $('#wareTypeDlg').dialog('open');
		 }
		 function setWareType(id,name) {
			 if(id==0){
				 id="";
			 }
			 $("#wtype").val(id);
			 $("#wtypeName").val(name);
		 }


		 function onClickCell(index, field, value) {
			 var rows = $("#datagrid").datagrid("getRows");
			 var row = rows[index];
			 var sdate = $("#sdate").val();
			 var edate = $("#edate").val();
			 var xsTp = row.xsTp;
			 var empId=row.empId;
			 var wareId = row.wareId;
             var isType = $("#isType").val();
			 if(xsTp == undefined)xsTp = "";
			 if(empId == undefined)empId = 0;
			 if(wareId == undefined)wareId = 0;
			 var timeType = $("#timeType").val();
			 if (field == "qty"||field=="amt") {

				 parent.closeWin('业务销售统计明细');
				 parent.add('业务销售统计明细','manager/toStkEmpStatDetail?sdate=' + sdate + '&edate=' + edate +'&empId='+empId+'&xsTp=' + xsTp + '&wareId=' + wareId + '&timeType=' + timeType + '&isType=' + isType);
			 }
			 if (field == "outQty"||field=="outAmt") {

				 parent.closeWin('业务销售发货明细');
				 parent.add('业务销售发货明细','manager/toStkEmpSendDetail?sdate=' + sdate + '&edate=' + edate +'&empId='+empId+'&xsTp=' + xsTp + '&wareId=' + wareId + '&timeType=' + timeType+ '&_sticky=v2' + '&isType=' + isType);
			 }

			 if (field == "recAmt") {

				 parent.closeWin('业务销售收款明细');
				 parent.add('业务销售收款明细','manager/toStkEmpRecDetail?sdate=' + sdate + '&edate=' + edate +'&empId='+empId+'&xsTp=' + xsTp + '&wareId=' + wareId + '&timeType=' + timeType + '&_sticky=v2' + '&isType=' + isType);
			 }
		 }
		</script>
	</body>
</html>
