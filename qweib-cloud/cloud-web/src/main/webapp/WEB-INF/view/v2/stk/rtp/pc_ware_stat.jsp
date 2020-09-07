<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>驰用T3</title>

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
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" >

		</table>
		<div id="tb" style="padding:5px;height:auto">
		   时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        统计范围:
	        <%--
	        <select name="xsTp" id="xsTp">
	                  <option value="">全部</option>
	                  <option value="正常销售" selected="selected">正常销售</option>
	                  <option value="其它">其他类型</option>
	               </select>
	        --%>
	       <select id="xsTp" class="easyui-combobox" data-options="multiple:true,panelHeight:'auto'" name="xsTp" style="width:120px;">
			      <option value="">全部</option>
			     <option value="正常销售">正常销售</option>
				 <option value="促销折让">促销折让</option>
				 <option value="消费折让">消费折让</option>
				 <option value="费用折让">费用折让</option>
				 <option value="其他销售">其他销售</option>
				 <option value="其它出库">其它出库</option>
				 <option value="销售退货">销售退货</option>
		   </select>
			业务类型：
			<select id="saleType" name="saleType" onchange="queryData()">
				<option value="">全部</option>
				<option value="001">传统业务类</option>
				<option value="003">线上商城</option>
			</select>
	        商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		<input type="hidden" id="wtype" value="${wtype}"/>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>
		</div>
		<script type="text/javascript">
		   //查询


		   function initGrid()
		   {
			   var cols = new Array();
			   /*var col = {
						field: 'unitId',
						title: 'unitId',
						width: 100,
						align:'center',
						hidden:true



				};
	    	    cols.push(col);*/
			   var col = {
						field: 'wareId',
						title: '商品名称',
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
						field: 'sumQty',
						title: '销售数量',
						width: 80,
						align:'center',
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'avgPrice',
						title: '平均售价',
						width: 80,
						align:'center',
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'sumAmt',
						title: '销售金额',
						width: 80,
						align:'center',
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'sumCost',
						title: '销售成本',
						width: 80,
						align:'center',
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'avgCost',
						title: '平均成本',
						width: 80,
						align:'center',
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'disAmt',
						title: '销售毛利',
						width: 80,
						align:'center',
						formatter:amtformatter


				};
	    	    cols.push(col);

	    	    var col = {
						field: 'avgAmt',
						title: '平均单位毛利',
						width: 80,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);
	    	    var col = {
						field: '_avgRate',
						title: '毛利率',
						width: 80,
						align:'center',
						formatter:amtformatterRate
				};
	    	    cols.push(col);

	    	    var values = $('#xsTp').combobox('getValues')+"";
				//alert($("#wtype").val());
				//alert($("sdate").val());
				$('#datagrid').datagrid({
					url:"manager/queryWareStatPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						outType:values,
						wareNm:$("#wareNm").val(),
						wtype:$("#wtype").val()

						},
    	    		columns:[
    	    		  		cols
    	    		  	]}
    	    );
    	    $('#datagrid').datagrid('reload');
		   }

		   //initGrid();
		   function queryData(){

			   var values = $('#xsTp').combobox('getValues')+"";
				$("#datagrid").datagrid('load',{
					url:"manager/queryWareStatPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					outType:values,
					wareNm:$("#wareNm").val(),
					wtype:$("#wtype").val(),
					saleType:$("#saleType").val()
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

			function amtformatterRate(v,row)
			{
				var sumAmt = row.sumAmt;
				var disAmt = row.disAmt;
				if(disAmt==""){
					disAmt = 0;
				}
				if(sumAmt==""||sumAmt==0.0){
					return "";
				}
				if(disAmt=="0E-7"){
					disAmt=0.00;
				}
				var rate = (parseFloat(disAmt)/parseFloat(sumAmt))*100;
				return numeral(rate).format("0.00")+"%";
			}

			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryData();
				}
			}


		</script>
	</body>
</html>
