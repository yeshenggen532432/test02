<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>商品分组分页</title>
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
			url="manager/shopWareGroup/page" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th  field="id" checkbox="true"></th>
					<th field="name" width="80" align="center" >
						分组名称
					</th>
					<%--<th field="groupStyleName" width="150" align="center" formatter="formatStype">
						<span onclick="javascript:editStype();">模块样式✎</span>
					</th>--%>
					<th field="sort" width="120" align="center" formatter="formatSort">
						<span onclick="javascript:editSort();" title="越小越前">排序✎</span>
					</th>
					<th field="status" width="100" align="center" formatter="formatterStatus">
						状态
					</th>
					<th field="_oper" width="100" align="center" formatter="formatterOper">
						操作
					</th>
					<th field="remark" width="100" align="center">
						备注
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     分组名称: <input name="name" id="name" style="width:156px;height: 20px;" />
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:query();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toadd();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toedit();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:todel();">删除</a>
		</div>

		<script type="text/javascript">
			//--------------模版板式修改开始
			var styleHtml='<select name="groupStyleId" style="display: none" onchange="changeStyle(this)">';
			<c:forEach items="${groupStyleList}" var="groupStyle">
			styleHtml+='<option value="${groupStyle.groupStyleId}" <c:if test="${groupStyle.groupStyleId==model.groupStyleId}">selected</c:if> >${groupStyle.groupStyleName}</option>';
			</c:forEach>
			styleHtml+='</select>';

			function formatStype(val,row) {
                if(!val)val="";
				return styleHtml+"<span name='styleSpan' data-groupStyleId='"+row.groupStyleId+"'>" + val + "</span>";
			}
			function editStype() {
				var groupStyleId = document.getElementsByName("groupStyleId");
				var styleSpan = document.getElementsByName("styleSpan");
				var isShow=groupStyleId[0].style.display;
				for (var i = 0; i < groupStyleId.length; i++) {
					if (isShow=='none') {
						groupStyleId[i].style.display = '';
						styleSpan[i].style.display = 'none';
						$(groupStyleId[i]).val($(styleSpan[i]).attr("data-groupStyleId"));//回显下拉
					} else {
						groupStyleId[i].style.display = 'none';
						styleSpan[i].style.display = '';
					}
				}
			}

			function changeStyle(obj){
				var value=obj.value;
				var id=$(obj).parents('tr').find("[name='id']").val();//修改对象ID
				var text=$(obj).find("option:selected").text();//选中的内容
				$(obj).parent("div").find("span").text(text);//修改隐藏对象内容方便回显
				$(obj).parent("div").find("span").attr("data-groupStyleId",value);
				$.ajax({
					url: "manager/shopWareGroup/updateBase",
					type: "post",
					data: "id=" + id + "&groupStyleId=" + value,
					success: function (data) {
						if (data.state) {
							//alert("操作成功");
						} else {
							alert(data.msg);
							return;
						}
					}
				});
			}
			//--------------模版板式结束

			//--------------排序修改开始
			function formatSort(val,row){
			    if(!val)val="";
				return "<input type='text' class='number' style='display:none' size='5' maxlength='5'  onchange='changeSort(this," + row.id + ")' name='sortInput' value='" + val + "'/><span name='sortSpan'>" + val + "</span>";
			}
			function editSort() {
				var sortInput = document.getElementsByName("sortInput");
				var sortSpan = document.getElementsByName("sortSpan");
				var isShow=sortInput[0].style.display;
				for (var i = 0; i < sortInput.length; i++) {
					if (isShow=='none') {
						sortInput[i].style.display = '';
						sortSpan[i].style.display = 'none';
					} else {
						sortInput[i].style.display = 'none';
						sortSpan[i].style.display = '';
					}
				}
			}
			function changeSort(obj, id) {
				var value=obj.value;
				if(value&&!isNumber(value)){
					alert("请输入正整数");
					return false;
				}

				$(obj).parent("div").find("span").text(value);
				$.ajax({
					url: "manager/shopWareGroup/updateBase",
					type: "post",
					data: "id=" + id + "&sort=" + value,
					success: function (data) {
						if (data.state) {
							//alert("操作成功");
						} else {
							alert(data.msg);
							return;
						}
					}
				});
			}
			//--------------排序修改结束

		    //查询
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopWareGroup/page",
					   name:$("#name").val(),
					   mobile:$("#mobile").val()
				});
			}
			//添加
			function toadd(){
				  window.location.href="${base}/manager/shopWareGroup/add";
			}
			//修改
			function toedit(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(row.name=='热销商品'||row.name=='常售商品'){
						 alert("热销商品、常售商品系统默认不允许修改!");
						return;
					}
				    var id = row.id;
					window.location.href="${base}/manager/shopWareGroup/edit?id="+id;
				}else{
					alert("请选择行");
				}
			}
			
			//删除
			function todel(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(row.name=='热销商品'||row.name=='常售商品'){
						 alert("热销商品、常售商品系统默认不允许修改!");
						return;
					}
					if(confirm("是否要删除选中的分组?")){
						$.ajax({
							url:"manager/shopWareGroup/delete",
							data:"id="+row.id,
							type:"post",
							success:function(json){
								if(json=="1"){
								    alert("删除成功");
								    query();
								}else{
								    alert("删除失败");
								    return;
								}
							}
						});
					}
				}
			}
			function formatterStatus(val,row){
				var html ="";
				if(row.status=='1'){
					html= "<input value='不启用' style='width: 50px' type='button' onclick='updateStatus("+row.id+",0)'/>";
				}else{
					html="<input value='启用'  style='width: 50px' type='button' onclick='updateStatus("+row.id+",1)'/>";
				}
				return html;
			     /* if(val=='0'){
			             return "未启用";
			       }else if(val=='1'){
			             return "已启用";
			       }*/
			   } 
			function updateStatus(id,status){
					if(confirm("是否确定操作?")){
						$.ajax({
							url:"manager/shopWareGroup/updateStatus",
							data:"id="+id+"&status="+status,
							type:"post",
							success:function(json){
								if(json=="1"){
								    alert("操作成功!");
								    query();
								}else{
								    alert("操作失败");
								    return;
								}
							}
						});
					}
			}
			function formatterOper(val,row){
				return "<input value='商品信息' type='button' onclick='showWareGroups("+row.id+",\""+row.name+"\")'/>";
			}
			
			function showWareGroups(id,name){
				parent.closeWin(name+'_商品信息');
		    	parent.add(name+'_商品信息','manager/shopWare/toUpPage?groupIds='+id);
			}
			
		</script>
	</body>
</html>
