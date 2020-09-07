<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>同城商品选择</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
	<body>
	<%--备注：class="easyui-datagrid" 默认会请求一次数据--%>
	<%--url="manager/shopWare/page?wtype=${wtype}&groupIds=${groupIds}" class="easyui-datagrid"--%>
		<%--<input type="hidden" name="wtype" id="wtype" value="${wareType}"/>--%>
		<table id="datagrid"  fit="true"  singleSelect="false" border="false"
			   url="manager/shopCityWare/shopSelectWareData?waretype=${waretype}"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="if(event.keyCode==13)queryWare();"/>
			<input type="hidden" name="waretype" id="waretype" value="${waretype}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true"  href="javascript:queryWare();">查询</a>&nbsp;&nbsp;
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true"  href="javascript:addCityWare();">加入同城商品库</a>
		</div>
	</div>
		
		<script type="text/javascript">
			$(function(){
				initGrid();
			})

			function initGrid(){
				var cols = new Array();
				var col = {
					field: 'wareId',
					title: 'id',
					width: 50,
					align:'center',
					checkbox:'true'
				};
				cols.push(col);
				var col = {
					field: 'wareNm',
					title: '商品名称',
					width: 150,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'wareGg',
					title: '规格',
					width: 100,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'wareDj',
					title: '批发价',
					width: 100,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'lsPrice',
					title: '零售价',
					width: 100,
					align:'center'
				};
				cols.push(col);
				$('#datagrid').datagrid({
					url:"manager/shopCityWare/shopSelectWareData?waretype=${waretype}",
					columns:[
						cols
					]}
				);
			}

		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopCityWare/shopSelectWareData",
					   wareNm:$("#wareNm").val(),
				});
			}

			//更新运费模版
			function addCityWare(){
				var rows = $('#datagrid').datagrid('getSelections');
				var ids = "";
				for(var i=0;i<rows.length;i++){
					if(ids!=''){
						ids=ids+",";
					}
					ids=ids+rows[i].wareId;
				}
				if(ids==""){
					$.messager.alert('Warning','请选择商品！');
					return;
				}
				//$.messager.confirm('Confirm',"是否确认加入",function(r){
				//	if (r){
						$.ajax({
							url:"${base}/manager/shopCityWare/add",
							data:{"wareIds":ids},
							type:"post",
							success:function(data){
								if(data.state){
									//alert("更新成功");
									//$.messager.alert('消息','加入成功!','info');
									queryWare();
								}else{
									$.messager.alert('Error','商品类别更新失败！');
									return;
								}
							}
						});
					//}
				//});
			}

		</script>
	</body>
</html>
