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

		 	 业务员: <input name="driverName" id="driverName" value="${driverName }" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	         客户名称: <input name="customerName" id="customerName"  style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		 	 品名: <input name="wareNm" id="wareNm" value="${wareNm }" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>

			出库类型:<tag:outtype id="outType" name="outType" style="width:100px" onchange="changeOutType()"></tag:outtype>
			销售类型:<tag:saleType id="billName" name="billName"></tag:saleType>
		 	 <%--<br/>--%>
		 	 <%--销售类型:<select name="billName" id="billName">--%>
	                  <%--<option value="">全部</option>--%>
	                  <%--<option value="正常销售">正常销售</option>--%>
	                   <%--<option value="促销折让">促销折让</option>--%>
	                   <%--<option value="消费折让">消费折让</option>--%>
	                   <%--<option value="费用折让">费用折让</option>--%>
	                   <%--<option value="其他销售">其他销售</option>--%>
			           <%--<option value="其它出库">其它出库</option>--%>
						<%--<option value="借出出库">借出出库</option>--%>
						<%--&lt;%&ndash;<option value="领用出库">领用出库</option>&ndash;%&gt;--%>
						<%--<option value="报损出库">报损出库</option>--%>
	                   <%--<option value="销售退货">销售退货</option>--%>
	               <%--</select>--%>
	               <%--<script type="text/javascript">--%>
	               <%--if('${billName}'!=''){--%>
	            	   <%--document.getElementById("billName").value='${billName}';--%>
	               <%--}--%>
	               <%--</script>--%>
	              <%--  <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:editPrice();">编辑单件费用</a>--%>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:editRptData();">编辑业务员客户销售统计表</a>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</div>
		<script type="text/javascript">
		   //查询
		   //initGrid();
		   function initGrid()
		   {
			   var cols = new Array(); 
			   var col = {
						field: 'driverName',
						title: '业务员',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	   var col = {
						field: 'customerName',
						title: '销售客户',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'wareNm',
						title: '品项',
						width: 80,
						align:'left'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'billName',
						title: '销售类型',
						width: 80,
						align:'left'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'unitName',
						title: '单位',
						width: 80,
						align:'left'
						
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
						field: 'tcAmt',
						title: '单位提成费用',
						width: 100,
						align:'right',
						formatter:amtformatter
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'ioPrice',
						title: '提成额',
						width: 80,
						align:'right',
						formatter:amtformatter
				};
	    	    cols.push(col);
			    var billName = $('#billName').combobox('getValues')+"";
				$('#datagrid').datagrid({
					url:"manager/querySaleCustomerStatPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						customerName:$("#customerName").val(),
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
		  
		   function changePrice(obj,index){
				document.getElementById("vitems"+index+"unitAmt").innerHTML=''+obj.value;
			}
			function query(){
				var billName = $('#billName').combobox('getValues')+"";
				$("#datagrid").datagrid('load',{
					url:"manager/querySaleCustomerStatPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					customerName:$("#customerName").val(),
					wareNm:$("#wareNm").val(),
					driverName:$("#driverName").val(),
					outType:$("#outType").val(),
					billName:billName,
					formatter:amtformatter
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
			
			
			function onDblClickRow(rowIndex, rowData)
		    {
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var vehNo = $("#vehNo").val();
		    	var driverName = $("#driverName").val();
		    	var wareNm = rowData.wareNm;
		    	var billName = rowData.billName
		    	var customerName = rowData.customerName;
		    	parent.closeWin('业务员客户细项统计表');
		    	parent.add('业务员客户细项统计表','manager/querySaleCustomerItemStat?sdate=' + sdate + '&edate=' + edate +'&billName='+billName+'&vehNo=' + vehNo + '&driverName=' + driverName+"&wareNm="+wareNm+"&customerName="+customerName);
		    }
			
			function editRptData()
		    {
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var vehNo = $("#vehNo").val();
		    	var driverName = $("#driverName").val();
		    	var wareNm = $("#wareNm").val();
		    	var billName =  $("#billName").val();
		    	var customerName =  $("#customerName").val();
		    	parent.closeWin('编辑业务员客户统计表');
		    	parent.add('编辑业务员客户细项统计表','manager/querySaleCustomerStatList?sdate=' + sdate + '&edate=' + edate +'&billName='+billName+'&vehNo=' + vehNo + '&driverName=' + driverName+"&wareNm="+wareNm+"&customerName="+customerName);
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
