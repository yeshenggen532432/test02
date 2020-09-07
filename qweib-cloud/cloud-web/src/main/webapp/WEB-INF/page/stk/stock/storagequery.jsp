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
			 iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb"
			data-options="onDblClickRow: onDblClickRow">

		</table>
		<div id="tb" style="padding:5px;height:auto">
			<input type="hidden" name="waretype" value="${waretype}" id="waretype" />
			<input type="hidden" name="isType" value="${isType}" id="isType" />
		     商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>

	        仓库: <select name="wareStk" id="stkId">
	                    <option value="0">全部</option>

	                </select>
	        数据范围: <select name="scope" id="scope">
	                    <option value="">全部</option>
	                    <option value="1" selected="selected">实际库存</option>
	                    <option value="2">在途库存</option>
	                </select>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querystorage();">查询</a>
			<%--<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:myexport();">导出</a>--%>

			<a class="easyui-linkbutton"  ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_START_UP_STOCK_CORRECT\"  and status=1") eq 'none'?'style="display:none"':""} iconCls="icon-redo" plain="true" href="javascript:correctQty();">库存纠偏</a>
			<%@include file="/WEB-INF/page/export/export.jsp"%>
		</div>
		<script type="text/javascript">
		    queryBasestorage();
			var showMinUnit = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_STORAGE_SHOW_MINUNIT\"  and status=1")}';
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
					   field: 'hsNum',
					   title: 'hsNum',
					   width: 100,
					   align:'center',
					   hidden:true
				   };
				   cols.push(col);
				   var col = {
							field: 'stkName',
							title: '仓库名称',
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
							title: '大单位',
							width: 80,
							align:'center'


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'sumQty',
							title: '库存数量',
							width: 80,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);

				   var col = {
					   field: '_sumQty',
					   title: '大小数量',
					   width: 120,
					   align:'center',
					   formatter:formatterQty
				   };
				   cols.push(col);

					var col = {
							field: 'sumAmt',
							title: '总金额',
							width: 100,
							align:'center',
							formatter:amtformatter,
							hidden:${!permission:checkUserFieldPdm("stk.storageWare.showamt")}
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'avgPrice',
							title: '平均单价',
							width: 100,
							align:'center',
							formatter:amtformatter,
							hidden:${!permission:checkUserFieldPdm("stk.storageWare.showprice")}
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

					$('#datagrid').datagrid({
						url:"manager/queryStorageWarePage",
						queryParams:{
							waretype:"${waretype}",
							isType:"${isType}",
							scope:$("#scope").val()
			    	    	},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
			   }
			function querystorage(wareType,isType){
				if(wareType!=undefined&&(wareType!=""||wareType==0)){
					$("#waretype").val(wareType)
				}
				if(isType!=undefined&&isType!=""||isType==0){
					$("#isType").val(isType)
				}
				$("#datagrid").datagrid('load',{
					url:"manager/queryStorageWarePage",
					wareNm:$("#wareNm").val(),
					stkId:$("#stkId").val(),
					scope:$("#scope").val(),
					waretype:$("#waretype").val(),
					isType:$("#isType").val()
				});
			}

			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querystorage();
				}
			}

			function correctQty(){
			   	// var minStart = $("#minStart").val();
			   	// var minEnd = $("#minEnd").val();
			   	// var maxStart = $("#maxStart").val();
			   	// var maxEnd = $("#maxEnd").val();
				parent.parent.closeWin('库存纠偏');
				parent.parent.add('库存纠偏','manager/toCorrectWareQty');
			}
			function formatterQty(v,row) {
			   	if(row.stkName=="合计："){
					return "";
				}
				var hsNum=row.hsNum;
			   	var sumQty = row.sumQty;
				if(parseFloat(hsNum)>1){
					var str = sumQty+"";
					if(str.indexOf(".")!=-1){
						var nums = str.split(".");
						var num1 = nums[0];
						var num2 = nums[1];
						if(parseFloat(num2)>0){
							var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);
							minQty = minQty.toFixed(2);
							return num1+""+row.unitName+""+minQty+""+row.minUnitName;
						}
					}
				}
				sumQty=  Math.floor(sumQty * 100)/100;
				return sumQty+row.unitName;
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
                    //return numeral(v).format("0,0.00")+"--"+v;
					v=  Math.floor(v * 100)/100;
					return numeral(v).format("0,0.00");
                }
			}
			function todetail(title,id){
				window.parent.add(title,"manager/queryBforderDetailPage?orderId="+id);
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
			// //导出
			// function myexport(){
			// 	exportData('stkQueryService','queryStkPage','com.qweib.cloud.biz.erp.model.StkStorageWare',"{scope:'1',wareNm:'"+$("#wareNm").val()+"',stkId:'"+$("#stkId").val()+"',waretype:'"+$("#waretype").val()+"'}","库存记录");
			// }
		    //
		    function onDblClickRow(rowIndex, rowData)
		    {
			    parent.parent.closeWin('库存明细' + rowData.wareId);
				parent.parent.add('库存明细' + rowData.wareId,'manager/toStkDetail?stkId=' + rowData.stkId + '&wareId=' + rowData.wareId+"&scope="+$("#scope").val());
		    }
		</script>
	</body>
</html>
