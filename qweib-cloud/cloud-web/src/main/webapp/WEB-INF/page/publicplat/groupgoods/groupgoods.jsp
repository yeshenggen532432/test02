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
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/groupgoodsPage" title="商品列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="ck" checkbox="true"></th>
					<th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="gname" width="180" align="center">
						商品名称
					</th>
					<th field="yprice" width="80" align="center" >
						原价
					</th>
					<th field="xprice" width="80" align="center" >
						现价
					</th>
					<th field="stock" width="80" align="center" >
						库存
					</th>
					<th field="humennum" width="80" align="center" >
						人气
					</th>
					<th field="salesvolume" width="80" align="center" >
						销量
					</th>
					<th field="isrx" width="60" align="center" formatter="formatterSt">
						是否热销
					</th>
					<th field="stime" width="180" align="center" >
						开始时间
					</th>
					<th field="etime" width="180" align="center" >
						结束时间
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			商品名称: <input name="gname" id="gname" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querygroupgoods();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddgroupgoods();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-tip" plain="true" href="javascript:toxq();">详情</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
		</div>
		<script type="text/javascript">
		    function formatterSt(val,row){
				if(val=='1'){
					return "是";
				}else{
				   return "否";
				}
				
			}
			//查询商品
			function querygroupgoods(){
				$("#datagrid").datagrid('load',{
					url:"manager/groupgoodsPage",
					gname:$("#gname").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querygroupgoods();
				}
			}
			//添加
			function toaddgroupgoods(){
				location.href="${base}/manager/toopergroupgoods";
			}
			//修改
			function getSelected(){
			  var rows = $("#datagrid").datagrid("getSelections");
			  if(rows.length<=1){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					location.href="${base}/manager/toopergroupgoods?Id="+row.id;
				}else{
					alert("请选择要修改的行！");
				}
			  }else{
			       alert("不能选择多行");
			  }	
			}
			//详情
			function toxq(){
			     var rows = $("#datagrid").datagrid("getSelections");
			     if(rows.length<=1){
				      var row = $('#datagrid').datagrid('getSelected');
					  if (row){
					     window.parent.parent.add(row.gname,"${base}/manager/groupgoodsxq?Id="+row.id);
					  }else{
						alert("请选择行");
					  }
				  }else{
			       alert("不能选择多行");
			     }
			 }
			//删除
			function toDel(){
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for(var i=0;i<rows.length;i++){
					ids.push(rows[i].id);
				}
				if(ids.length>0){
					if(confirm("确认要删除该商品吗?")){
						$.ajax({
							url:"manager/delgroupgoods",
							data:"id="+ids,
							type:"post",
							success:function(json){
								if(json=="1"){
								    alert("删除成功");
								    querygroupgoods();
								}else{
								    alert("删除失败");
								    return;
								}
							}
						});
					}
				}else{
					alert("请选择行");
				}
			}
		</script>
	</body>
</html>
