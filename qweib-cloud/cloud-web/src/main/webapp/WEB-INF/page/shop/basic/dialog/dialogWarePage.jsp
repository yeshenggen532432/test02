<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>

	<body scrolling="no">
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/shopWare/dialogWarePage?waretype=${wareType}" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			   <%--data-options="onDblClickRow: onDblClickRow,onSelect: onSelect,onUnselect:onUnselect,onCheckAll:onCheckAll,onUncheckAll:onUnCheckAll,onLoadSuccess:loadData">--%>
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
					<th field="wareDw" width="60" align="center">
						大单位
					</th>
					<th field="minUnit" width="100" align="center">
						小单位
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="queryWare();"/>
			<input type="hidden" name="wareType" id="wareType" value="${wareType}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-select" href="javascript:confirmSelectWare();">确定选择</a>
		</div>
		<script type="text/javascript">
		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopWare/dialogWarePage",
					wareNm:$("#wareNm").val()
				});
			}

			function confirmSelectWare(){
				var rows = $('#datagrid').datagrid('getSelections');
				var wareId = rows[0].wareId;
				var wareNm = rows[0].wareNm;
				window.parent.callBackFun(wareId,wareNm);
				window.parent.$('#wareDlg').dialog('close');
			}
			
		// 	function onDblClickRow(rowIndex, rowData)
		//     {
		// 		var json = {};
		// 		 var  wareList = new Array();
		// 		var data = {
		// 				waretypePath:rowData.waretypePath,
		// 				wareId:rowData.wareId,
		// 				wareNm:rowData.wareNm,
		// 				wareGg:rowData.wareGg,
		// 				wareCode:rowData.wareCode,
		// 				wareDw:rowData.wareDw,
		// 				minUnit:rowData.minUnit,
		// 				minUnitCode:rowData.minUnitCode,
		// 				maxUnitCode:rowData.maxUnitCode,
		// 				hsNum:rowData.hsNum,
		// 				stkQty:rowData.stkQty,
		// 				price:rowData.inPrice,
		// 				sunitFront:rowData.sunitFront
		// 		};
		// 		wareList.push(data);
		// 		json ={
		// 				list:wareList
		// 		}
		// 		window.parent.callBackFun(json);
		//     }
		// 	function onSelect(rowIndex, rowData){
		// 		var data = {
		// 				waretypePath:rowData.waretypePath,
		// 				wareId:rowData.wareId,
		// 				wareNm:rowData.wareNm,
		// 				wareGg:rowData.wareGg,
		// 				wareCode:rowData.wareCode,
		// 				wareDw:rowData.wareDw,
		// 				minUnit:rowData.minUnit,
		// 				minUnitCode:rowData.minUnitCode,
		// 				maxUnitCode:rowData.maxUnitCode,
		// 				hsNum:rowData.hsNum,
		// 				stkQty:rowData.stkQty,
		// 				price:rowData.inPrice,
		// 				sunitFront:rowData.sunitFront
		// 		};
		// 		var flag = true;
		// 		if(parent.wareList!=null){
		// 			for(var i=0;i<parent.wareList.length;i++){
		// 				var t = parent.wareList[i];
		// 				if(rowData.wareId==t.wareId){
		// 					flag=false;
		// 					break;
		// 				}
		// 			}
		// 		}
		// 		if(flag){
		// 			parent.wareList.push(data);
		// 		}
		// 	}
		// 	function onUnselect(rowIndex, rowData){
		// 		if(parent.wareList!=null){
		// 			var wareList = parent.wareList;
		// 			for(var k=0;k<wareList.length;k++){
		// 				var data = wareList[k];
		// 				 if(rowData.wareId==wareList[k].wareId){
		// 					wareList.splice(k,1);
		// 					break;
		// 				}
		// 			}
		// 			parent.wareList=wareList;
		// 		}
		// 	}
		// /**
		// 	初始化选中
		// **/
		// function loadData(){
		// 	var wareList = parent.wareList;
		// 	var rows =  $('#datagrid').datagrid('getRows');
		// 	 if(wareList!=null){
		// 		for(var i=0;i<rows.length;i++){
		// 			 	var data = rows[i];
		// 				for(var k=0;k<wareList.length;k++){
		// 					var json = wareList[k];
		// 					if(json.wareId==data.wareId){
		// 					 $('#datagrid').datagrid('selectRow',i);
		// 					 break;
		// 					}
		// 			}
		// 		}
		// 	}
		// 	//alert(wareList.length+":"+rows.length);
		// }
		// function onCheckAll()
		// {
		// 	 var rows =  $('#datagrid').datagrid('getRows');
		// 	for(var i=0;i<rows.length;i++){
		// 	 	var data = rows[i];
		// 	 	onSelect(i,data);
		// 	}
		// }
		// function onUnCheckAll(){
		// 	var rows =  $('#datagrid').datagrid('getRows');
		// 	for(var i=0;i<rows.length;i++){
		// 	 	var data = rows[i];
		// 	 	onUnselect(i,data);
		// 	}
		// }
		// function funCellClick(o){
		// 	o.select();
		// }
		</script>
	</body>
</html>
