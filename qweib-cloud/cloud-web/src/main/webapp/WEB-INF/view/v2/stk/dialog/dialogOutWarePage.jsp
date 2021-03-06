<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>驰用T3</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/dialogOutWarePage?stkId=${stkId}&customerId=${customerId }&waretype=${waretype}" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb"  data-options="onDblClickRow: onDblClickRow,onSelect: onSelect,onUnselect:onUnselect,onCheckAll:onCheckAll,onUncheckAll:onUnCheckAll,onLoadSuccess:loadData">
			<thead>
				<tr>
					<th  field="wareId" checkbox="true"></th>
					<th field="wareCode" width="80" align="center" >
						商品编码
					</th>
					<th field="wareNm" width="150" align="left">
						商品名称
					</th>
					<th field="wareGg" width="80" align="center">
						规格
					</th>
					<th field="stkQty" width="100" formatter="formatterQty">
						实际数量
					</th>
					<th field="occQty" width="100" hidden="true" formatter="formatterQty">
						占用数量
					</th>
					<th field="_xnQty" width="100" hidden="true" formatter="formatterQty">
						虚拟库存
					</th>
					<th field="wareDj" width="70" align="center">
						销售价
					</th>
					<th field="wareDw" width="60" align="center">
						大单位
					</th>
					<th field="minUnit" width="100" align="center">
						小单位
					</th>
					<th field="maxUnitCode" width="100" hidden="true">
						大单位代码
					</th>
					<th field="minUnitCode" width="100" hidden="true">
						小单位代码
					</th>
					<th field="hsNum" width="100" hidden="true">
						换算比例
					</th>
					<th field="sunitFront" width="100" hidden="true">
						开单默认选中小单位
					</th>
					<th field="productDate" width="100" hidden="true">
						生产日期
					</th>
					<th field="qualityDays" width="100" hidden="true">
					   有效期
					</th>
					<th field="sunitPrice" width="100" hidden="true">
					  小单位价格
					</th>
					<th field="inPrice" width="100" ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_SALE_SHOW_INPRICE\"  and status=1") eq 'none'?'hidden=true':""} >
					 成本价
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onclick="funCellClick(this)" onkeydown="queryWareNm();"/>
			<input type="hidden" name="waretype" id="waretype" value="${waretype}"/>
			<input type="hidden" name="stkId" id="stkId" value="${stkId}"/>
			<input type="hidden" name="customerId" id="customerId" value="${customerId}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-select" href="javascript:confirmSelectWare();">确定选择</a>
		</div>
		<script type="text/javascript">
		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/dialogOutWarePage",
					   wareNm:$("#wareNm").val()
				});
			}
		    
		    function queryWareNm(){
		    	var v=window.event.keyCode;
		        if(v==13){
		        	queryWare()
		        }
		    	
		    }
		    
			function formatType(val,row,index){
				return row.waretypeNm;
			}
			
			function confirmSelectWare(){
				var rows = $('#datagrid').datagrid('getSelections');
				var json = {};
				var  wareList = parent.wareList;
				json ={
						list:wareList
				}
				window.parent.callBackFun(json);
				window.parent.$('#wareDlg').dialog('close');
			}
			
			function onDblClickRow(rowIndex, rowData)
		    {
				var json = {};
				 var  wareList = new Array();
				var data = {
						waretypePath:rowData.waretypePath,
						wareId:rowData.wareId,
						wareNm:rowData.wareNm,
						wareGg:rowData.wareGg,
						wareCode:rowData.wareCode,
						maxNm:rowData.wareDw,
						minNm:rowData.minUnit,
						minUnitCode:rowData.minUnitCode,
						maxUnitCode:rowData.maxUnitCode,
						hsNum:rowData.hsNum,
						stkQty:rowData.stkQty,
						wareDj:rowData.wareDj,
						sunitFront:rowData.sunitFront,
						sunitPrice:rowData.sunitPrice,
						qualityDays:rowData.qualityDays,
						productDate:rowData.productDate,
						inPrice:rowData.inPrice
				};
				wareList.push(data); 
				json ={
						list:wareList
				}
				window.parent.callBackFun(json);
		    }
			function onSelect(rowIndex, rowData){
				var data = {
						waretypePath:rowData.waretypePath,
						wareId:rowData.wareId,
						wareNm:rowData.wareNm,
						wareGg:rowData.wareGg,
						wareCode:rowData.wareCode,
						maxNm:rowData.wareDw,
						minNm:rowData.minUnit,
						minUnitCode:rowData.minUnitCode,
						maxUnitCode:rowData.maxUnitCode,
						hsNum:rowData.hsNum,
						stkQty:rowData.stkQty,
						wareDj:rowData.wareDj,
						sunitFront:rowData.sunitFront,
						sunitPrice:rowData.sunitPrice,
						qualityDays:rowData.qualityDays,
						productDate:rowData.productDate,
						inPrice:rowData.inPrice
				};
				var flag = true;
				if(parent.wareList!=null){
					for(var i=0;i<parent.wareList.length;i++){
						var t = parent.wareList[i];
						if(rowData.wareId==t.wareId){
							flag=false;
							break;
						}
					}
				}
				if(flag){
					parent.wareList.push(data);
				}
			}
			function onUnselect(rowIndex, rowData){
				if(parent.wareList!=null){
					var wareList = parent.wareList;
					for(var k=0;k<wareList.length;k++){
						var data = wareList[k];
						 if(rowData.wareId==wareList[k].wareId){
							wareList.splice(k,1);
							break;
						} 
					}
					parent.wareList=wareList;
				}
			}
		function formatterQty(v,row) {
			var hsNum=row.hsNum;
			if(hsNum>1){
				var str = v+"";
				if(str.indexOf(".")!=-1){
					var nums = str.split(".");
					var num1 = nums[0];
					var num2 = nums[1];
					if(parseFloat(num2)>0){
						var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);
						minQty = minQty.toFixed(2);
						return num1+""+row.wareDw+""+minQty+""+row.minUnit;
					}
				}
			}
			return v+row.wareDw;

		}	
			
		/**
			初始化选中
		**/
		function loadData(){
			var wareList = parent.wareList;
			var rows =  $('#datagrid').datagrid('getRows');
			 if(wareList!=null){
				for(var i=0;i<rows.length;i++){
					 	var data = rows[i];
						for(var k=0;k<wareList.length;k++){
							var json = wareList[k];
							if(json.wareId==data.wareId){
							 $('#datagrid').datagrid('selectRow',i);
							 break;
							}
					} 
				}
			} 
			//alert(wareList.length+":"+rows.length);
		}
		function onCheckAll()
		{
			 var rows =  $('#datagrid').datagrid('getRows');
			for(var i=0;i<rows.length;i++){
			 	var data = rows[i];
			 	onSelect(i,data);
			} 
		}
		function onUnCheckAll(){
			var rows =  $('#datagrid').datagrid('getRows');
			for(var i=0;i<rows.length;i++){
			 	var data = rows[i];
			 	onUnselect(i,data);
			} 
		}
		function fmtQty(val,row,index){
			var stkQty = 0;
			var occQty = 0; 
			if(row.stkQty!=null&&row.stkQty!=undefined){
				stkQty = row.stkQty;
			}
			if(row.occQty!=null&&row.occQty!=undefined){
				occQty = row.occQty;
			}
			var qty = parseFloat(stkQty)-parseFloat(occQty)
			return qty.toFixed(2);
		}
			function funCellClick(o){
				o.select();
			}
		</script>
	</body>
</html>
