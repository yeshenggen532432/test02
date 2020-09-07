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
			url="manager/queryWarePage?stkId=${stkId}&waretype=${waretype}" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb"  data-options="onLoadSuccess:loadData">
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
					<th field="hsNum" width="100" hidden="true">
						换算比例
					</th>
					<th field="stkQty" width="100" hidden="true">
						库存数量
					</th>
					<th field="waretypePath" width="100" hidden="true">
						商品类别
					</th>
					<th field="inPrice" width="100" hidden="true">
						大单位价格
					</th>
					<th field="sunitPrice" width="100" hidden="true">
						小单位价格
					</th>
					<th field="productDate" width="100" >
						生产日期
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="queryWare();"/>
			<input type="hidden" name="waretype" id="waretype" value="${waretype}"/>
			<input type="hidden" name="stkId" id="stkId" value="${stkId}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-select" href="javascript:confirmSelectWare();">确定选择</a>
		   
		</div>
		<script type="text/javascript">
		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryWarePage",
					   wareNm:$("#wareNm").val()
				});
			}
			function formatType(val,row,index){
				return row.waretypeNm;
			}
			
			function confirmSelectWare(){
				var rows = $('#datagrid').datagrid('getSelections');
				var json = {};
				var  wareList = new Array();
				for(var i=0;i<rows.length;i++){
					var sunitPrice = rows[i].sunitPrice;
					if(sunitPrice==undefined){
						sunitPrice = "";
					}
					var data = {
							waretypePath:rows[i].waretypePath,
							wareId:rows[i].wareId,
							wareNm:rows[i].wareNm,
							wareGg:rows[i].wareGg,
							wareCode:rows[i].wareCode,
							wareDw:rows[i].wareDw,
							minUnit:rows[i].minUnit,
							hsNum:rows[i].hsNum,
							stkQty:rows[i].stkQty,
							inPrice:rows[i].inPrice,
							sunitPrice:sunitPrice,
							productDate:rows[i].productDate
					};
					wareList.push(data);
				}
				json ={
						list:wareList
				}
				window.parent.setCheckWareData(json);
			}
			/**
				初始化选中
			**/
			function loadData(){
				var wareList =  window.parent.gwareList;
				var rows =  $('#datagrid').datagrid('getRows');
				if(wareList!=null){
					for(var k=0;k<wareList.length;k++){
						var json = wareList[k];
						for(var i=0;i<rows.length;i++){
							var data = rows[i];
							if(json.wareId ==data.wareId){
								 $('#datagrid').datagrid('selectRow',i);
							}
						}
					}
				}
			}
		</script>
	</body>
</html>
