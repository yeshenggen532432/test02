]<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员管理</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body class="easyui-layout" fit="true">
		<div data-options="region:'west',split:true,title:'部门分类树'"
			style="width:150px;padding-top: 5px;">
			<div id="divHYGL" style="overflow: auto;">
				<ul id="departtree" class="easyui-tree" fit="true"
					data-options="url:'manager/departs?depart=${depart }&dataTp=${dataTp }',animate:true,dnd:false,onClick: function(node){
						loaddepart(node.id);
					},onDblClick:function(node){
						$(this).tree('toggle', node.target);
					}">
				</ul>
			</div>
		</div>
		<div id="departDiv" data-options="region:'center'" title="部门分类信息">
			<div style="padding-left: 10;padding-top: 10px;">上级分类：<span id="updepartSpan">无</span></div>
			<form action="manager/operdepart" name="departfrm" id="departfrm" method="post">
				<input type="hidden" name="branchId" id="branchId"/>
				<input type="hidden" name="parentId" id="parentId"/>
				<input type="hidden" name="branchLeaf" id="branchLeaf"/>
				<input type="hidden" name="branchPath" id="branchPath"/>
				<input type="hidden" name="branchName1" id="branchName1"/>
				<table id="opertable" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<th>
							部门名称：
						</th>
						<td>
							<input name="branchName" id="branchName"  maxlength="30"/>
						</td>
					</tr>
					<tr>
						<th>
							上午上班时间：
						</th>
						<td>
							<input name="swSb" id="swSb"  maxlength="5" style="width: 60px;"/>&nbsp;<font color="red">格式:00:00</font>
						</td>
					</tr>
					<tr>
						<th>
							上午下班时间：
						</th>
						<td>
							<input name="swXb" id="swXb"  maxlength="5" style="width: 60px;"/>&nbsp;<font color="red">格式:00:00</font>
						</td>
					</tr>
					<tr>
						<th>
							下午上班时间：
						</th>
						<td>
							<input name="xwSb" id="xwSb"  maxlength="5" style="width: 60px;"/>&nbsp;<font color="red">格式:00:00</font>
						</td>
					</tr>
					<tr>
						<th>
							下午下班时间：
						</th>
						<td>
							<input name="xwXb" id="xwXb"  maxlength="5" style="width: 60px;"/>&nbsp;<font color="red">格式:00:00</font>
						</td>
					</tr>
					<tr>
					   <th>
						   备注：
					   </th>
					   <td>
					        <textarea rows="50" cols="3" name="branchMemo" id="branchMemo"></textarea>
					   </td>
					</tr>
					<tr>
						<th>
							分配部门权限：
						</th>
						<td>
							<a id="btn" href="javascript:todeptpower('1');" class="easyui-linkbutton" data-options="iconCls:'icon-add'">可见人员</a>
							<a id="btn" href="javascript:todeptpower('2');" class="easyui-linkbutton" data-options="iconCls:'icon-add'">不可见人员</a>    
					  	 </td>
					</tr>
					<tr>
						<th>
							
						</th>
						<td>
							<a class="easyui-linkbutton" href="javascript:savedepart();">保存</a>
							&nbsp;
							<a class="easyui-linkbutton" href="javascript:deletedepart();">删除</a>
							&nbsp;
							<a class="easyui-linkbutton" href="javascript:adddepart();">新增一级分类</a>
							&nbsp;
							<a id="nextTypea" class="easyui-linkbutton" href="javascript:addNextType();">新增下级分类</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript">
			$(function(){
				var dataTp = "${dataTp}";
				if (dataTp=='1') {
					loaddepart("");
				} else {
					$("#departDiv").hide();
				}
			});
			function loaddepart(id){
				$("#departDiv").show();
				//显示新增下级分类
			    $("#nextTypea").show();
				$.ajax({
					url:"manager/getdepart",
					type:"post",
					data:"id="+id,
					success:function(json){
						if(json){
							$('#departfrm').form('load',{
								branchId:json.branchId,
								parentId:json.parentId,
								branchLeaf:json.branchLeaf,
								branchPath:json.branchPath,
								branchName:json.branchName,
								branchName1:json.branchName,
								swSb:json.swSb,
								swXb:json.swXb,
								xwSb:json.xwSb,
								xwXb:json.xwXb,
								branchMemo:json.branchMemo
							});
							if(json.branchPName){
								$("#updepartSpan").html(json.branchPName);
							}else{
								$("#updepartSpan").html("无");
							}
						}else{
							$("#updepartSpan").html("无");
						}
					}
				});
			}
			//保存
			function savedepart(){
				$('#departfrm').form('submit', {
					success:function(data){
						if(data=="0"){
							alert("修改成功");
							var node = $('#departtree').tree('getSelected');
							if (node){
								$('#departtree').tree('update', {
									target: node.target,
									text: $("#branchName").val()
								});
							}
						}else if(data=="-1"){
							alert("操作失败");
						}//else if(data=="-2"){
							//alert("已经最后一级不能在添加下级");
						//}
						else if(data=="-3"){
							alert("该部门名称存在，请重新输入");
						}else{
							alert("添加成功");
							$('#departtree').tree('reload');
							$("#branchId").val(data);
							//显示新增下级分类
			    			$("#nextTypea").show();
						}
					}
				});
			}
			//删除
			function deletedepart(){
				var branchId = $("#branchId").val();
				if(branchId){
					if(confirm("是否要删除该分类?")){
						$.ajax({
							url:"manager/deletedepart",
							type:"post",
							data:"id="+branchId,
							success:function(data){
								if(data){
									$('#departtree').tree('reload');
									loaddepart("");
									if(data=="1"){
									   alert("删除成功");
									}else{
									   alert("底下有分类不能删除");
									}
								}
							}
						});
					}
				}
			}
			//新增一级分类
			function adddepart(){
				//titile为：商品分类信息
				$("#updepartSpan").html("无");
			    //隐藏新增下级分类
			    $("#nextTypea").hide();
				$("#branchId").val("");
				$("#parentId").val("");
				document.getElementById("departfrm").reset();
			}
			//新增下级分类
			function addNextType(){
				//没有id不执行
				var departId = $("#branchId").val();
				if(departId){
					//var branchPath = $("#branchPath").val();
					//var arr = new Array();
                    //arr = branchPath.split("-");
                    //if(arr.length>=6){
						//alert("已经最后一级不能在添加下级");
						//return;
					//}
					$("#updepartSpan").html($("#branchName").val());
					document.getElementById("departfrm").reset();
					$("#parentId").val(departId);
					$("#branchId").val("");
				}
			}
			//分配部门权限
			function todeptpower(tp){
				var deptId = $("#branchId").val();
				window.parent.todeptpower(deptId, tp);
			}
		</script>
	</body>
</html>
