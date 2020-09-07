<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<title>企微宝</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<%@include file="/WEB-INF/page/include/source.jsp"%>
<style type="text/css">
	.divDel{
		position: relative;
		width:160px;
		height:160px;
		margin:15px 0px 5px;
	}
	.imgDel{
		width:20px;
		height:20px;
		position: absolute;
		right: 5px;
		top: 5px;
	}
</style>
</head>

<body class="easyui-layout">
	<div data-options="region:'west',split:true,title:'区域'"
		style="width:150px;padding-top: 5px;">
		<ul id="regiontree" class="easyui-tree"
			data-options="url:'manager/sysRegions',animate:true,dnd:true,onClick: function(node){
					loadRegion(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
		</ul>
	</div>
	<div data-options="region:'center',split:true" >
	
	<form action="manager/operRegion" name="regionfrm" id="regionfrm" method="post" enctype="multipart/form-data">
		<div id="easyTabs" class="easyui-tabs" style="width:auto;height:auto;">
			<div id="RegionDiv" title="区域信息" style="padding:20px;">
				<div style="padding-left: 10px;padding-top: 10px;">
					上级区域：<span id="upRegionSpan">无</span>
				</div>

				<input type="hidden" name="regionId" id="regionId" /> <input
					type="hidden" name="regionPid" id="regionPid" />
				<table id="opertable" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<th>名称：</th>
						<td><input name="regionNm" id="regionNm"
							class="easyui-validatebox" data-options="required:true"
							maxlength="30" onkeydown="if(event.keyCode==13)return false;" />
						</td>
					</tr>
					<tr>
						<th></th>
						<td>
							<a class="easyui-linkbutton" href="javascript:addRegion();">新增一级区域</a>
							&nbsp; <a id="nextTypea" class="easyui-linkbutton"
							href="javascript:addNextType();">新增下级区域</a>
						</td>
					</tr>
				</table>

			</div>
		</div>
		<div class="f_reg_but" style="clear:both">
			<a href="javascript:saveRegion();" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
			<a href="javascript:deleteRegion();" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
		</div>
	</form>
	</div>

	<script type="text/javascript">
		$(function() {
			loadRegion("");
		});
		function loadRegion(id) {
			//显示新增下级区域
			$("#nextTypea").show();
			$.ajax({
				url : "manager/getRegion",
				type : "post",
				data : "id=" + id,
				success : function(json) {
					if (json) {
						$('#regionfrm').form('load', {
							regionId : json.regionId,
							regionPid : json.regionPid,
							regionNm : json.regionNm
						});
						if (json.upRegionNm) {
							$("#upRegionSpan").html(json.upRegionNm);
						} else {
							$("#upRegionSpan").html("无");
						}
					} else {
						$("#upRegionSpan").html("无");
					}
				}
			});
		}

		//恢复默认数量
		function resetDefaultData(num){
			delPicIds="";
			$("#dl2").empty();//清空
			index=num;
			len=num;
			picNum=num;
		}

		//保存
		function saveRegion() {
			//easyUi的from表单的ajax请求接口
			$("#regionfrm").form('submit',{
				type:"POST",
				url:"<%=basePath%>/manager/operRegion",
				success:function(data){
					if (data == "2") {
						alert("修改成功");
						$('#regiontree').tree('reload');
						loadRegion($("#regionId").val());
					} else if (data == "-1") {
						alert("操作失败");
					} else if (data == "-2") {
						alert("区域不能超过2级");
					} else if (data == "-3") {
						alert("该区域名称已经存在");
					} else {
						alert("添加成功");
						$('#regiontree').tree('reload');
						$("#regionId").val(data);
						loadRegion($("#regionId").val());
					}
				}
			});
		}

		//删除区域
		function deleteRegion() {
			var regionId = $("#regionId").val();
			if (regionId) {
				if (confirm("是否要删除该区域?")) {
					$.ajax({
						url : "manager/deleteRegion",
						type : "post",
						data : "id=" + regionId,
						success : function(data) {
							if (data) {
								$('#regiontree').tree('reload');
								loadRegion("");
								if (data == "1") {
									alert("删除成功");
								} else if (data == "2") {
									alert("该区域下有商品不能删除");
								} else if (data == "3") {
									alert("该区域下有区域不能删除");
								} else {
									alert("删除失败");
								}
							}
						}
					});
				}
			}
		}
		
		//新增一级区域
		function addRegion() {
			//titile为：区域信息
			$("#upRegionSpan").html("无");
			//隐藏新增下级区域
			$("#nextTypea").hide();
			$("#regionId").val("");
			$("#regionPid").val("");
			document.getElementById("regionfrm").reset();

		}
		
		//新增下级区域
		function addNextType() {
			//没有id不执行
			var regionId = $("#regionId").val();
			if (regionId) {
				$("#upRegionSpan").html($("#regionNm").val());
				document.getElementById("regionfrm").reset();
				$("#regionPid").val(regionId);
				$("#regionId").val("");
			}
		}
	</script>
</body>
</html>
