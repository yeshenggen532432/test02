<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>公司角色管理</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.product-grid td {
			padding: 0;
		}
	</style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<%--2右边：表格start--%>
		<div class="layui-col-md12">
			<%--表格：头部start--%>
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal query">
						<div class="form-group" style="margin-bottom: 10px;">
							<div class="col-xs-4">
								<input uglcw-model="roleNm" uglcw-role="textbox" placeholder="角色名称">
							</div>
							<div class="col-xs-4">
								<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
								<button id="reset" class="k-button" uglcw-role="button">重置</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%--表格：头部end--%>

			<%--表格：start--%>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							<%--checkbox:true,--%>
							pageable: true,
                    		url: '${base}manager/rolepages_company',
                    		criteria: '.query',
                    	">
						<div data-field="roleNm" uglcw-options="width:100">角色名称</div>
						<div data-field="oper" uglcw-options="width:100,template: uglcw.util.template($('#oper').html())">分配权限</div>
						<div data-field="areaName" uglcw-options="width:100, template: uglcw.util.template($('#areaName').html())">分配用户</div>
					</div>
				</div>
			</div>
			<%--表格：end--%>
		</div>
		<%--2右边：表格end--%>
	</div>
</div>

<script type="text/x-kendo-template" id="toolbar">
	<a role="button" href="javascript:add();" class="k-button k-button-icontext">
		<span class="k-icon k-i-plus-outline"></span>添加
	</a>
	<a role="button" href="javascript:update();" class="k-button k-button-icontext">
		<span class="k-icon k-i-edit"></span>修改
	</a>
	<a role="button" href="javascript:del();" class="k-button k-button-icontext">
		<span class="k-icon k-i-delete"></span>删除
	</a>
</script>
<%--启用操作--%>
<script id="oper" type="text/x-uglcw-template">
	# if(data.roleCd == "company_creator"){ #
	<button onclick="javascript:torolemenuapply(#= data.idKey#,1,'company_creator');" class="k-button k-info">分配菜单</button>
	<button onclick="javascript:torolemenuapply(#= data.idKey#,2,'company_creator');" class="k-button k-info">分配应用</button>
	# }else if (data.roleCd == "company_admin"){ #
	<button onclick="javascript:torolemenuapply(#= data.idKey#,1,'company_admin');" class="k-button k-info">分配菜单</button>
	<button onclick="javascript:torolemenuapply(#= data.idKey#,2,'company_admin');" class="k-button k-info">分配应用</button>
	# }else{ #
	<button onclick="javascript:torolemenuapply(#= data.idKey#,1);" class="k-button k-info">分配菜单</button>
	<button onclick="javascript:torolemenuapply(#= data.idKey#,2);" class="k-button k-info">分配应用</button>
	# } #
</script>
<script id="areaName" type="text/x-uglcw-template">
	# if(data.roleCd == "company_creator"){ #
	<span>创建者：${companyCreator.name}</span>
	# }else if (data.roleCd == "company_admin"){ #
	<button onclick="javascript:toRoleManager(#= data.idKey#);" class="k-button k-info">移除管理员</button>
	<button onclick="javascript:toRoleTransferManager(#= data.idKey#);" class="k-button k-info">转移管理员</button>
	# }else{ #
	<button onclick="javascript:toroleusr(#= data.idKey#);" class="k-button k-info">分配用户</button>
	# } #
</script>
<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
	<div class="layui-card">
		<div class="layui-card-body">
			<form class="form-horizontal" uglcw-role="validator">
				<div class="form-group">
					<input uglcw-role="textbox" uglcw-model="idKey" type="hidden">
					<label class="control-label col-xs-6">角色名称</label>
					<div class="col-xs-16">
						<input style="width: 200px;" uglcw-model="roleNm" uglcw-role="textbox" uglcw-validate="required" placeholder="请输入角色名称">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-6">角色描述</label>
					<div class="col-xs-16">
						<input style="width: 200px;" uglcw-model="remo" uglcw-role="textbox" uglcw-validate="required" placeholder="">
					</div>
				</div>
			</form>
		</div>
	</div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		//ui:初始化
		uglcw.ui.init();

		//查询
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#grid').reload();
		})

		//重置
		uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.query');
			uglcw.ui.get('#grid').reload();
		})

		resize();
		$(window).resize(resize);
		uglcw.ui.loaded();
	})

	var delay;
	function resize() {
		if (delay) {
			clearTimeout(delay);
		}
		delay = setTimeout(function () {
			var grid = uglcw.ui.get('#grid').k();
			var padding = 15;
			var height = $(window).height() - padding - $('.header').height() - 40;
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}

	//-----------------------------------------------------------------------------------------
	//删除
	function del() {
		var selection = uglcw.ui.get('#grid').selectedRow();
		if (selection) {
			var roleCd =selection[0].roleCd;
			if (roleCd == 'company_creator' || roleCd == 'company_admin') {
				uglcw.ui.toast('系统角色不可删除')
				return;
			}
			uglcw.ui.confirm("确定删除所选记录吗？", function () {
				$.ajax({
					url:"${base}manager/delrole_company",
					data: {
						id:selection[0].idKey,
					},
					type: 'post',
					dataType: 'json',
					success: function (response) {
						if(response.code == 200){
							uglcw.ui.success("删除成功");
							uglcw.ui.get('#grid').reload();
						}else{
							uglcw.ui.error(response.message);
						}
					}
				});
			})
		}else{
			uglcw.ui.toast("请勾选你要操作的行！")
		}
	}
	//添加
	function add(){
		edit()
	}
	//修改
	function update(){
		var selection = uglcw.ui.get('#grid').selectedRow();
		if (selection) {
			if(selection[0].name=='热销商品'||selection[0].name=='常售商品'){
				uglcw.ui.toast("热销商品、常售商品为系统默认，不允许操作!")
				return;
			}
			edit(selection[0]);
		}else{
			uglcw.ui.toast("请勾选你要操作的行！")
		}
	}

	//添加或修改
	function edit(row) {
		uglcw.ui.Modal.open({
			content: $('#form').html(),
			success: function (container) {
				uglcw.ui.init($(container));
				if (row) {
					uglcw.ui.bind($(container), row);
				}
			},
			yes: function (container) {
				var valid = uglcw.ui.get($(container).find('form')).validate();
				if (!valid) {
					return false;
				}
				var data = uglcw.ui.bind($(container).find('form'));
				uglcw.ui.loading();
				$.ajax({
					url: '${base}manager/operCompanyrole_company',
					type: 'post',
					data: data,
					async: false,
					success: function (resp) {
						uglcw.ui.loaded();
						if (resp === '1') {
							uglcw.ui.success('添加成功');
							uglcw.ui.get('#grid').reload();
							uglcw.ui.Modal.close();
						} else if (resp === '2') {
							uglcw.ui.success('修改成功');
							uglcw.ui.get('#grid').reload();
							uglcw.ui.Modal.close();
						} else {
							uglcw.ui.error('操作失败');
						}
					}
				})
				return false;
			}
		})
	}


	//------------------------------------------------------------------------------------------------------------
	//移除管理员
	function toRoleManager(idKey){
		uglcw.ui.confirm("确定移除管理员吗？", function () {
			$.ajax({
				url:"${base}manager/member/has_admin",
				// data: {
				// 	id:selection[0].idKey,
				// },
				type: 'get',
				dataType: 'json',
				success: function (response) {
					if(response.code == 200){
						// uglcw.ui.success("移除管理员");
						// uglcw.ui.get('#grid').reload();
						window.parent.toRoleManager(idKey);
					}else{
						uglcw.ui.toast(response.message);
					}
				}
			});
		})
	}
	//转移管理员
	function toRoleTransferManager(idKey){
		uglcw.ui.confirm("确定转移管理员吗？", function () {
			$.ajax({
				url:"${base}manager/member/has_admin",
				// data: {
				// 	id:selection[0].idKey,
				// },
				type: 'get',
				dataType: 'json',
				success: function (response) {
					if(response.code == 200){
						window.parent.toRoleTransferManager(idKey);
						// uglcw.ui.success("移除管理员");
						// uglcw.ui.get('#grid').reload();
					}else{
						uglcw.ui.toast(response.message);
					}
				}
			});
		})
	}
	//分配权限
	function torolemenuapply(idKey, tp, creatorAndAdmin){
		window.parent.torolemenuapply(idKey, tp, creatorAndAdmin);
	}

	//分配用户
	function toroleusr(idKey){
		// $("#divHYGL_tree").empty();
		// $("#roleid").val(idKey);
		// $("#opertype").val("usr");
		// $.ajax({
		// 	type:"post",
		// 	url:"manager/usrtree_company",
		// 	data:"id="+idKey,
		// 	success:function(data){
		// 		if(data){
		// 			loadTree_usr("divHYGL","divHYGL_tree","分配用户",data);
		// 		}
		// 	}
		// });
		// $("#treeDiv").window({title:"分配用户"});
		// $("#treeDiv").window('open');

		uglcw.ui.Modal.showTreeSelector({
			url: '${base}manager/usrtree_company',
			data:"id="+idKey,
			yes: function (nodes) {
				console.log(nodes);
				uglcw.ui.toast(nodes);
			}
		})
	}




</script>
</body>
</html>
