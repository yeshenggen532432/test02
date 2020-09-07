<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>客户销售统计表</title>
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
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onLoadSuccess: onLoadSuccess,onDblClickRow:onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		时间类型:<select name="timeType" id="timeType">
	                  <option value="1">发货时间</option>
	                  <option value="2">发票时间</option>
	            </select> 
		   : <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	            <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
			   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			出库类型:<tag:outtype id="outType" name="outType" onchange="changeOutType()"/>
			销售类型:<tag:saleType id="xsTp" name="xsTp"/>
            客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
	        客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	       商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	        车辆：<tag:select name="carId" id="carId" tableName="stk_vehicle" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="veh_no"/>
			资产类型:<tag:zctype id="isType" name="isType"></tag:zctype>
			商品类别: <input name="wtype" type="hidden" id="wtype" />
			<input name="wtypeName" ondblclick="setWareType('','')" readonly="true"  style="width:80px" id="wtypeName" />
			<a onclick="selectWareType()" href="javascript:;;">选择</a>
			客户所属区域:
			<select id="regioncomb" class="easyui-combotree" style="width:200px;"
					data-options="url:'manager/sysRegions',animate:true,dnd:true,onClick: function(node){
							setRegion(node.id);
							}"></select>
			<input type="hidden" name="regionId" id="regionId" />
			所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	          显示商品信息:<input type="checkbox"  id="showWareCheck" name="showWareCheck" onclick="queryData()" value="1"/> 
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>
	               <a class="easyui-linkbutton" href="javascript:createRptData();">生成报表</a>
	               <a class="easyui-linkbutton" href="javascript:queryRpt();">查询生成的报表</a>
			业务类型：
			<select id="saleType" name="saleType" onchange="queryData()">
				<option value="">全部</option>
				<option value="001">传统业务类</option>
				<option value="003">线上商城</option>
			</select>
		</div>
		<div id="wareTypeDlg" closed="true" class="easyui-dialog"   title="选择商品类别" style="width:250px;height:450px;padding:10px">
			<iframe  name="wareTypefrm" id="wareTypefrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
		   //查询
		   //initGrid();
		   function initGrid()
		   {
			   var cols = new Array(); 
	    	   var col = {
						field: 'khNm',
						title: '客户名称',
						width: 140,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'address',
						title: '客户地址',
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


			   var col = {
				   field: 'epCustomerName',
				   title: '所属二批',
				   width: 120,
				   align:'center'
			   };
			   cols.push(col);

				$('#datagrid').datagrid({
    	    		columns:[
    	    		  		cols
    	    		  	]
						}
    	    );
				  if($('#showWareCheck').is(':checked')) {
						$('#datagrid').datagrid('showColumn','wareNm');
						$('#datagrid').datagrid('showColumn','unitName');
						$('#datagrid').datagrid('showColumn','xsTp');
						$('#datagrid').datagrid('showColumn','price');
					}else{
						$('#datagrid').datagrid('hideColumn','wareNm');
						$('#datagrid').datagrid('hideColumn','unitName');
						$('#datagrid').datagrid('hideColumn','xsTp');
						$('#datagrid').datagrid('hideColumn','price');
					} 
		   }
		   function queryData(){
			   
			   var showWareCheck="";
			   
			  if($('#showWareCheck').is(':checked')){
				  showWareCheck="1";
			  }
			   var xsTp = $('#xsTp').combobox('getValues')+"";
			   var wtype = $("#wtype").val();
			   $('#datagrid').datagrid({
					url:"manager/queryCstStatMast",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						outType:$("#outType").val(),
						xsTp:xsTp,
						khNm:$("#khNm").val(),
						epCustomerName:$("#epCustomerName").val(),
						customerType:$("#customerType").val(),
						timeType:$("#timeType").val(),
						wareNm:$("#wareNm").val(),
						carId:$("#carId").val(),
						isType:$("#isType").val(),
						showWareCheck:showWareCheck,
						wtype:wtype,
						regionId:$("#regionId").val(),
						saleType:$("#saleType").val()
						}
						}
   	   			 );
			    if($('#showWareCheck').is(':checked')) {
					$('#datagrid').datagrid('showColumn','wareNm');
					$('#datagrid').datagrid('showColumn','unitName');
					$('#datagrid').datagrid('showColumn','xsTp');
					$('#datagrid').datagrid('showColumn','price');
				}else{
					$('#datagrid').datagrid('hideColumn','wareNm');
					$('#datagrid').datagrid('hideColumn','unitName');
					$('#datagrid').datagrid('hideColumn','xsTp');
					$('#datagrid').datagrid('hideColumn','price');
				} 
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
			   	if (row != null) {
			           return numeral(v).format("0,0.00");
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
		    	var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var xsTp = rowData.xsTp;
		    	var cstId=rowData.cstId;
				var wareId = rowData.wareId;
				var wtype = $("#wtype").val();
				var isType=$("#isType").val();
				if(xsTp == undefined)xsTp = "";
				if(cstId == undefined)cstId = 0;
				if(wareId == undefined)wareId = 0;
		    	parent.closeWin('客户销售统计明细');
		    	parent.add('客户销售统计明细','manager/toStkCstStatDetail?sdate=' + sdate + '&edate=' + edate +'&cstId='+cstId+'&xsTp=' + xsTp + '&wareId=' + wareId + '&isType=' + isType + '&wtype=' + wtype);
		    }
		    
		    function onLoadSuccess(data) {
		    	  if($('#showWareCheck').is(':checked')) {
        		var start = 0;
       	 		var end = 0;
        		if (data.total > 0) {
            	var temp = data.rows[0].khNm;
            	for (var i = 1; i < data.rows.length; i++) {
                if (temp == data.rows[i].khNm) {
                    end++;
                } else {
                    if (end > start) {
                         $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'khNm'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'address'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'epCustomerName'
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
                    temp = data.rows[i].khNm;
                    start = i;
                    end = i;
                }
            	}
            /*这里是为了判断重复内容出现在最后的情况，如ABCC*/
            	if (end > start) {
                 		$("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'khNm'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'address'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'epCustomerName'
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
			
			// function showMainDetail(){
			// 	var sdate = $("#sdate").val();
		    // 	var edate = $("#edate").val();
		    // 	var xsTp = $("#xsTp").val();
		    // 	var stkUnit = $("#khNm").val();
		    //     var carId = $("#carId").val();
		    // 	var epCustomerName = $("#epCustomerName").val();
		    // 	var customerType = $("#customerType").val();
			// 	var wtype = $("#wtype").val();
		    // 	parent.closeWin('客户毛利明细统计表');
		    // 	parent.add('客户毛利明细统计表','manager/queryAutoCstStatDetail?sdate=' + sdate + '&wtype='+wtype+'&edate=' + edate +'&epCustomerName='+epCustomerName+'&xsTp=' + xsTp + '&carId='+carId+'&customerType='+customerType+'&stkUnit=' + stkUnit);
			// }
			
			
			function createRptData()
		    {
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var outType = $("#outType").val();
				var xsTp = $('#xsTp').combobox('getValues');
		    	var stkUnit = $("#khNm").val();
		    	var epCustomerName = $("#epCustomerName").val();
		    	var customerType = $("#customerType").val();
		    	var dateType = $("#timeType").val();
		    	var wareNm = $("#wareNm").val();
		    	var carId = $("#carId").val();
				var wtype = $("#wtype").val();
				var regionId = $("#regionId").val();
		    	parent.closeWin('生成客户费用统计表');
		    	parent.add('生成客户费用统计表','manager/toStkCstStatSave?sdate=' + sdate + '&wtype='+wtype+'&regionId='+regionId+'&carId='+carId+'&edate=' + edate +'&outType='+outType+'&khNm=' + stkUnit+'&customerType='+customerType+'&epCustomerName='+epCustomerName + '&timeType=' + dateType + '&xsTp=' + xsTp + '&wareNm=' + wareNm);
		    }
			
			function queryRpt()
		    {
		    	parent.closeWin('生成的统计表');
		    	parent.add('生成的统计表','manager/toStkCstStatQuery?rptType=6');
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
			    }
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
		 function setRegion(regionId){
			 $("#regionId").val(regionId);
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
