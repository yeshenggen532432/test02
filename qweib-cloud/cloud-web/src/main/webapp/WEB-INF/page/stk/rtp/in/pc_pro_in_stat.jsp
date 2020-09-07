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
			rownumbers="true" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
			 <input type="hidden" id="timeType" name="timeType" value="2"/>
		   发票日期: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        采购类型:<select name="inType" id="inType">
	                  <option value="">全部</option>
	                  <option value="采购入库">采购入库</option>
					  <option value="其它入库">其它入库</option>
					  <option value="采购退货">采购退货</option>
	               </select>
	        往来单位: <input name="proName" id="proName" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
			商品名称: <input name="wareNm" id="wareNm" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
			显示商品明细：
			<input type="checkbox" id="showWareCheck" name="showWareCheck" onclick="query()" value="1"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</div>
		<script type="text/javascript">
		   //查询
		   function initGrid()
		   {
			   var cols = new Array();
	    	   var col = {
						field: 'pro_name',
						title: '往来单位',
						width: 100,
						align:'center'
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'total_qty',
						title: '发票数量',
						width: 80,
						align:'center',
						sortable:true,
						formatter:amtformatter
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'dis_amt',
						title: '发票金额',
						width: 80,
						align:'center',
						sortable:true,
						formatter:amtformatter
				};
	    	    cols.push(col);

			   var col = {
				   field: 'total_in_qty',
				   title: '收货数量',
				   width: 80,
				   align:'center',
				   sortable:true,
				   formatter:amtformatter
			   };
			   cols.push(col);

			   var col = {
				   field: 'dis_amt1',
				   title: '收货金额',
				   width: 80,
				   align:'center',
				   sortable:true,
				   formatter:amtformatter
			   };
			   cols.push(col);

			   var col = {
				   field: 'count',
				   title: '商品明细',
				   width:600,
				   align: 'center',
				   formatter:formatterItems
			   };
			   cols.push(col);

			   var col = {
				   field: 'pay_amt',
				   title: '已付款',
				   width: 80,
				   align:'center',
				   sortable:true,
				   formatter:amtformatter
			   };
			   cols.push(col);

			   var col = {
				   field: 'free_amt',
				   title: '核销金额',
				   width: 80,
				   align:'center',
				   sortable:true,
				   formatter:amtformatter
			   };
			   cols.push(col);


			   var col = {
				   field: 'un_pay_amt',
				   title: '未付金额',
				   width: 80,
				   align:'center',
				   sortable:true,
				   formatter:amtformatter
			   };
			   cols.push(col);



			   $('#datagrid').datagrid({
				   url:"manager/queryInPageStat",
				   queryParams:{
					   sdate:$("#sdate").val(),
					   edate:$("#edate").val(),
					   inType:$("#inType").val(),
					   proName:$("#proName").val(),
					   wareNm:$("#wareNm").val(),
					   timeType:$("#timeType").val()
				   },
				   columns:[
					   cols
				   ]
			   });

			   if ($('#showWareCheck').is(':checked')) {
				   $('#datagrid').datagrid('showColumn', 'count');
			   } else {
				   $('#datagrid').datagrid('hideColumn', 'count');
			   }

		   }
			function query(){
				initGrid();
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
			function formatterItems(v,row,rowIndex){

				var titles="";
				var values="";
                if(rowIndex==0){
					titles="<td width='120px'>商品名称</td><td width='60px'>单位</td><td width='60px'>单价</td><td width='80px'>发票数量</td><td width='80px'>发票金额</td><td width='80px'>收货数量</td><td width='80px'>收货金额</td>";
				}
				var values="";
                var datas =row.subList;
               if(datas && datas.length>0){
                	for(var i=0;i<datas.length;i++){
                		var data = datas[i];
						values += "<tr><td width='120px' style='word-wrap:break-word;'>"+data['ware_nm']+"</td><td width='60px' >"+data['unit_name']+"</td><td width='60px' style='text-align: left;padding-left: 2px'>"+data['price']+"</td><td width='80px' style='text-align: left;padding-left: 2px'>"+data['qty']+"</td><td width='80px' style='text-align: left;padding-left: 2px'>"+data['amt']+"</td><td width='80px' style='text-align: left;padding-left: 2px'>"+data['in_qty']+"</td><td width='80px' style='text-align: left;padding-left: 2px'>"+data['in_amt']+"</td></tr>";
					}
				}
				var html="<table width='100%' style='table-layout:fixed;'>";
                if(titles!=""){
					html+="<tr>"+titles+"</tr>";
				}
				html+=values;
				html+="</table>";
				return html;
			}


			// function onDblClickRow(rowIndex, rowData)
		    // {
		    // 	var sdate = $("#sdate").val();
		    // 	var edate = $("#edate").val();
		    // 	var outType = $("#xsTp").val();
		    // 	var timeType = $("#timeType").val();
			// 	var	regionId=$("#regionId").val();
		    // 	var epCustomerName=$("#epCustomerName").val();
			// 	var	wtype =$("#wtype").val();
		    // 	parent.closeWin('客户毛利明细统计');
		    // 	parent.add('客户毛利明细统计','manager/queryCstStatDetail?sdate=' + sdate + '&regionId='+regionId+'&timeType='+timeType+'&wtype='+wtype+'&epCustomerName='+epCustomerName+'&edate=' + edate +'&outType=' + outType + '&stkUnit=' + rowData.stkUnit);
		    // }
			
		</script>
	</body>
</html>
