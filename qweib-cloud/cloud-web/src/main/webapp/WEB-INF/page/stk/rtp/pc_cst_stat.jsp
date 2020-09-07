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
		<table id="datagrid" class="easyui-datagrid"  singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onDblClickRow: onDblClickRow">

		</table>
		<div id="tb" style="padding:5px;height:auto">
		   时间类型:<select name="timeType" id="timeType">
			 		 <option value="2">发票时间</option>
	                 <option value="1">发货时间</option>
	           	   </select>
		   时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>

			出库类型:<tag:outtype id="outType" name="outType" style="width:100px" onchange="changeOutType()"></tag:outtype>
			销售类型:<tag:saleType id="xsTp" name="xsTp"></tag:saleType>

	        <%--销售类型:<select name="xsTp" id="xsTp">--%>
	                  <%--<option value="">全部</option>--%>
	                  <%--<option value="正常销售">正常销售</option>--%>
					  <%--<option value="促销折让">促销折让</option>--%>
					  <%--<option value="消费折让">消费折让</option>--%>
					  <%--<option value="费用折让">费用折让</option>--%>
					  <%--<option value="其他销售">其他销售</option>--%>
					  <%--<option value="其它出库">其它出库</option>--%>
					  <%--<option value="销售退货">销售退货</option>--%>
	               <%--</select>--%>
	        客户名称: <input name="khNm" id="khNm" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
		    业务员: <input name="staff" id="staff" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
			资产类型:<tag:zctype id="isType" name="isType"></tag:zctype>
			商品类别: <input name="wtype" type="hidden" id="wtype" />
			<input name="wtypeName" ondblclick="setWareType('','')" readonly="true"  style="width:80px" id="wtypeName" />
			<a onclick="selectWareType()" href="javascript:;;">选择</a>
			客户所属区域:
			<select id="regioncomb" class="easyui-combotree" style="width:200px;"
					data-options="url:'manager/sysRegions',animate:true,dnd:true,onClick: function(node){
							setRegion(node.id);
							}"></select>
			<input type="hidden" name="regionId" id="regionId"/>
			所属二批: <input name="epCustomerName" id="epCustomerName" style="width:60px;height: 20px;" onkeydown="toQuery(event);"/>
			业务类型：
			<select id="saleType" name="saleType">
				<option value="">全部</option>
				<option value="001">传统业务类</option>
				<option value="003">线上商城</option>
			</select>
			显示投入费用列:
			<input type="checkbox" id="showItems" name="showItems" onclick="querycpddtj()" value="1"/>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querycpddtj();">查询</a>
	                <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>
			<a href="javascript:showMainDetail();">显示所有明细</a>
		</div>

		<div id="wareTypeDlg" closed="true" class="easyui-dialog"   title="选择商品类别" style="width:250px;height:450px;padding:10px">
			<iframe  name="wareTypefrm" id="wareTypefrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<input type="hidden" id="database" value="${database}"/>
		<script type="text/javascript">
		   //查询
		   //initGrid();
		   function initGrid()
		   {
			   var cols = new Array();
	    	   var col = {
						field: 'stkUnit',
						title: '客户名称',
						width: 100,
						align:'center'


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'sumQty',
						title: '销售数量',
						width: 80,
						align:'center',
						sortable:true,
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'sumAmt',
						title: '销售收入',
						width: 80,
						align:'center',
						sortable:true,
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'avgPrice',
						title: '平均单位售价',
						width: 100,
						align:'center',
						sortable:true,
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'discount',
						title: '整单折扣',
						width: 80,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'inputAmt',
						title: '销售投入费用',
						width: 80,
						align:'center',
						formatter:amtformatterInput
				};
	    	    cols.push(col);

			   var col = {
				   field: 'showItems',
				   title: '费用明细列',
				   width: 300,
				   align: 'center',
				   formatter:formatterItems
			   };
			   cols.push(col);

	    	    var col = {
						field: 'sumCost',
						title: '销售成本',
						width: 80,
						align:'center',
						sortable:true,
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'disAmt',
						title: '销售毛利',
						width: 100,
						align:'center',
						sortable:true,
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'avgAmt',
						title: '平均单位毛利',
						width: 100,
						align:'center',
						sortable:true,
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'rate',
						title: '毛利率',
						width: 80,
						align:'center',
						sortable:true,
						formatter:rateformatter
				};
	    	    cols.push(col);

	    	    /*var col = {
						field: 'epCustomerName',
						title: '所属二批',
						width: 100,
						align:'center'
				};
	    	    cols.push(col);*/

	    	    var showItems=0;
			   if ($('#showItems').is(':checked')) {
				   showItems=1;
			   }


			   $('#datagrid').datagrid({
						   columns: [
							   cols
						   ]
					   }
			   );

			   if ($('#showItems').is(':checked')) {
				   $('#datagrid').datagrid('showColumn', 'showItems');
			   } else {
				   $('#datagrid').datagrid('hideColumn', 'showItems');
			   }

		   }
			function querycpddtj(){
				//$('#datagrid').datagrid('reload');
				var xsTp = $('#xsTp').combobox('getValues')+"";

				var showItems=0;
				if ($('#showItems').is(':checked')) {
					showItems=1;
				}
				$('#datagrid').datagrid({
					url:"manager/queryCstStatPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						epCustomerName:$("#epCustomerName").val(),
						outType:$("#outType").val(),
						stkUnit:$("#khNm").val(),
						staff:$("#staff").val(),
						timeType:$("#timeType").val(),
						wtype:$("#wtype").val(),
						xsTp:xsTp,
						regionId:$("#regionId").val(),
						showItems:showItems,
						saleType:$("#saleType").val(),
					}
				});
				if ($('#showItems').is(':checked')) {
					$('#datagrid').datagrid('showColumn', 'showItems');
				} else {
					$('#datagrid').datagrid('hideColumn', 'showItems');
				}
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

		   function amtformatterInput(v,row)
		   {
			   if(v==""){
				   return "";
			   }
			   if(v=="0E-7"){
				   return "0.00";
			   }
			   if(v==0.0){
			   	return v;
			   }
			   if (row != null) {
			   	   var amt = numeral(v).format("0,0.00");
				   return "<a href='javascript:;;' onclick='showInputAmt(\""+row.stkUnit+"\")'>"+amt+"</a>";
			   }
		   }

		   function showInputAmt(stkUnit){
			   var sdate = $("#sdate").val();
			   var edate = $("#edate").val();
			   var outType = $("#outType").val();
			   var timeType = $("#timeType").val();
			   var	regionId=$("#regionId").val();
			   var epCustomerName=$("#epCustomerName").val();
			   var	wtype =$("#wtype").val();
			   parent.closeWin('客户销售投入费用明细');
			   parent.add('客户销售投入费用明细','manager/toCstSaleInputAmtList?sdate=' + sdate + '&regionId='+regionId+'&timeType='+timeType+'&wtype='+wtype+'&epCustomerName='+epCustomerName+'&edate=' + edate +'&outType=' + outType + '&stkUnit=' + stkUnit);
		   }

			function rateformatter(v,row)
			{
				if(v==""){
					return "";
				}
				if(v=="0E-7"){
					return "0.00%";
				}
				if (row != null) {
                    return numeral(v).format("0,0.00") + "%";
                }
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querycpddtj();
				}
			}
			function formatterItems(v,row,rowIndex){
				var map = row.autoMap;
				var titles="";
				var values="";
				for(var key in map){
					if(rowIndex==0){
						titles +="<td width='50px'>"+key+"</td>";
					}

					var val = "&nbsp;";
					if(map[key]!=0){
						val = map[key];
					}

					values +="<td width='50px'>"+val+"</td>";
				}
				var html="<table width='100%'>";

				html+="<tr>"+titles+"</tr>";
				html+="<tr>"+values+"</tr>";
				html+="</table>";
				return html;
			}


			function onDblClickRow(rowIndex, rowData)
		    {
		    	var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var outType = $("#outType").val();
		    	var timeType = $("#timeType").val();
				var	regionId=$("#regionId").val();
		    	var epCustomerName=$("#epCustomerName").val();
				var	wtype =$("#wtype").val();
		    	parent.closeWin('客户毛利明细统计');
		    	parent.add('客户毛利明细统计','manager/queryCstStatDetail?sdate=' + sdate + '&regionId='+regionId+'&timeType='+timeType+'&wtype='+wtype+'&epCustomerName='+epCustomerName+'&edate=' + edate +'&outType=' + outType + '&stkUnit=' + rowData.stkUnit);
		    }

			function showMainDetail(){
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var outType = $("#xsTp").val();
		    	var stkUnit = $("#khNm").val();
		    	var epCustomerName=$("#epCustomerName").val();
		    	var staff = $("#staff").val();
		    	var timeType = $("#timeType").val();
				var	wtype =$("#wtype").val();
		    	parent.closeWin('查看客户毛利明细');
		    	parent.add('查看客户毛利明细','manager/queryCstStatDetailList?sdate=' + sdate + '&timeType='+timeType+'&wtype='+wtype+'&epCustomerName='+epCustomerName+'&edate=' + edate +'&outType=' + outType + '&stkUnit=' + stkUnit + '&staff=' + staff);
			}

			function myexport(){
				var database = $("#database").val();
				var sdate=$("#sdate").val();
				var edate=$("#edate").val();
				var epCustomerName=$("#epCustomerName").val();
				var outType=$("#outType").val();
				var stkUnit=$("#khNm").val();
				var staff=$("#staff").val();
				var timeType = $("#timeType").val();
				var columns =$("#datagrid").datagrid("options");
				var order = columns.sortOrder;
				var sort = columns.sortName;
				var	wtype =$("#wtype").val();
				var	regionId=$("#regionId").val();

				var json = JSON.stringify({
					sdate:sdate,
					timeType:timeType,
					edate: edate,
					wtype: wtype,
					database: database,
					regionId:regionId,
					epCustomerName: epCustomerName,
					outType: outType,
					stkUnit: stkUnit,
					staff: staff,
					order: order,
					sort: sort
				})
				exportData('incomeStatService','sumCstIncome','com.qweib.cloud.biz.erp.model.CstInComeVo', json,"客户销售毛利统计表");
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

  			<%--function selectWareType() {--%>
				<%--document.getElementById("wareTypefrm").src='${base}/manager/selectDialogWareType';--%>
				<%--$('#wareTypeDlg').dialog('open');--%>
			<%--}--%>

		   <%--function setWareType(id,name) {--%>
				<%--$("#wtype").val(id);--%>
			    <%--$("#wtypeName").val(name);--%>
		   <%--}--%>

		   function setRegion(regionId){
			   $("#regionId").val(regionId);
		   }
		</script>
	</body>
</html>
