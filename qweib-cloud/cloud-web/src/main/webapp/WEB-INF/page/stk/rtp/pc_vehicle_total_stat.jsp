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
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onDblClickRow: onDblClickRow">
		</table>
		<div id="tb" style="padding:5px;height:auto">
		   时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			出库类型:<tag:outtype id="outType" name="outType" style="width:100px" onchange="changeOutType()"></tag:outtype>
			销售类型:<tag:saleType id="billName" name="billName"></tag:saleType>
	         车牌号: <input name="vehNo" id="vehNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		 	 送货人: <input name="driverName" id="driverName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		 	 品名: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		 	 	   <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryRpt();">查看生成的报表</a>
		 	 	   <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:toRptData();">车辆客户统计表</a>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</div>
		<script type="text/javascript">
		   //查询
		   function initGrid()
		   {
			   var cols = new Array(); 
	    	   var col = {
						field: 'vehNo',
						title: '车牌号',
						width: 100,
						align:'center'
						
										
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'outQty',
						title: '发货数量',
						width: 100,
						align:'right',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'ioPrice',
						title: '配送费用',
						width: 80,
						align:'right',
						formatter:amtformatter
				};
	    	    cols.push(col);
			    var billName = $('#billName').combobox('getValues')+"";
				$('#datagrid').datagrid({
					url:"manager/queryVehicleTotalStatPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						customerName:$("#customerName").val(),
						vehNo:$("#vehNo").val(),
						wareNm:$("#wareNm").val(),
						driverName:$("#driverName").val(),
						outType:$("#outType").val(),
						billName:billName
						},
    	    		columns:[
    	    		  		cols
    	    		  	]
						}
    	    );
		   }
			function query(){
				var billName = $('#billName').combobox('getValues')+"";
				$("#datagrid").datagrid('load',{
					url:"manager/queryVehicleTotalStatPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					customerName:$("#customerName").val(),
					vehNo:$("#vehNo").val(),
					wareNm:$("#wareNm").val(),
					driverName:$("#driverName").val(),
					outType:$("#outType").val(),
					billName:billName
				});
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
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}
			

			function toRptData()
		    {
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var vehNo = $("#vehNo").val();
		    	var driverName = $("#driverName").val();
		    	var wareNm = $("#wareNm").val();
		    	var billName =  $('#billName').combobox('getValues')+"";
		    	var customerName =  $("#customerName").val();
		    	parent.closeWin('车辆配送客户统计表');
		    	parent.add('车辆配送客户统计表','manager/queryVehicleCustomerStat?sdate=' + sdate + '&edate=' + edate +'&vehNo=' + vehNo + '&driverName=' + driverName+"&wareNm="+wareNm);
		    }
			
			function onDblClickRow(rowIndex, rowData)
		    {
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var vehNo = rowData.vehNo;
		    	var driverName = $("#driverName").val();
		    	var wareNm = $("#wareNm").val();
		    	var billName =  $('#billName').combobox('getValues')+"";
		    	var customerName =  $("#customerName").val();
		    	parent.closeWin('车辆配送客户统计表');
		    	parent.add('车辆配送客户统计表','manager/queryVehicleCustomerStat?sdate=' + sdate + '&edate=' + edate +'&vehNo=' + vehNo + '&driverName=' + driverName+"&wareNm="+wareNm);
		    }
			
			function queryRpt()
		    {
		    	parent.closeWin('车辆配送客户生成的统计表');
		    	parent.add('车辆配送客户生成的统计表','manager/querySaveRptDataStat?rptType=1');
		    }

		   function changeOutType(){
			   var v = $("#outType").val();
			   $('#billName').combobox('loadData',{});
			   $('#billName').combobox('setValue', '');
			   // if(v==""){
			   //    $('#xsTp').combobox('loadData',allData);
			   // }else
			   //
			   if(v=="销售出库"){
				   $('#billName').combobox('loadData',outData);
			   }else if(v=="其它出库"){
				   $('#billName').combobox('loadData',otherData);
			   }
		   }
		   $(function(){
			   $("#billName").combobox('loadData', outData);
		   })

		</script>
	</body>
</html>
