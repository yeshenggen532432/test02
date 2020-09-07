<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>充值规则设置</title>
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

			<%--表格：start--%>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
						   responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/shopRechargeAmount/page',
                    		criteria: '.query',
                    	">
						<div data-field="czAmount" uglcw-options="width:100">充值面额</div>
						<div data-field="zsAmount" uglcw-options="width:100">赠送面额</div>
						<div data-field="sumAmount" uglcw-options="width:100,template: uglcw.util.template($('#sumAmount').html())">总面额</div>
						<%--<div data-field="status" uglcw-options="width:100, template: uglcw.util.template($('#status').html())">启用状态</div>--%>
						<div data-field="oper" uglcw-options="width:100,template: uglcw.util.template($('#oper').html())">启用操作</div>
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
<%--总面额--%>
<script id="sumAmount" type="text/x-uglcw-template">
	<span>#= data.zsAmount?data.czAmount+data.zsAmount:data.czAmount #</span>
</script>
<%--启用状态--%>
<%--<script id="status" type="text/x-uglcw-template">--%>
	<%--<span>#= data.status == "1" ? "正常":"未启用" #</span>--%>
<%--</script>--%>
<%--启用操作--%>
<script id="oper" type="text/x-uglcw-template">
	# if(data.status == 0){ #
	<button onclick="javascript:updateStatus(#= data.id#,1);" class="k-button k-info">不启用</button>
	# }else if(data.status==1){ #
	<button onclick="javascript:updateStatus(#= data.id#,0);" class="k-button k-info">启用</button>
	# } #
</script>
<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
	<div class="layui-card">
		<div class="layui-card-body">
			<form class="form-horizontal" uglcw-role="validator">
				<div class="form-group">
					<input uglcw-role="textbox" uglcw-model="id" type="hidden">
					<label class="control-label col-xs-6">充值面额</label>
					<div class="col-xs-16">
						<input style="width: 200px;" uglcw-model="czAmount" uglcw-role="numeric" uglcw-validate="required|number" placeholder="请输入数字">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-6">赠送面额</label>
					<div class="col-xs-16">
						<input style="width: 200px;" uglcw-model="zsAmount" uglcw-role="numeric" uglcw-validate="number" placeholder="请输入数字">
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
		uglcw.ui.loaded();
	})


	//-----------------------------------------------------------------------------------------
	//修改启用状态
	function updateStatus(id,status){
		uglcw.ui.confirm("是否确定操作?", function () {
			$.ajax({
				url: '${base}manager/shopRechargeAmount/updateStatus',
				data: {
					id:id,
					status:status
				},
				type: 'post',
				dataType: 'json',
				success: function (response) {
					if(response == "1"){
						uglcw.ui.success("操作成功");
						uglcw.ui.get('#grid').reload();
					}else{
						uglcw.ui.error("操作失败");
					}
				}
			})
		})
	}

	//添加
	function add(){
		edit()
	}

	//修改
	function update(){
		var selection = uglcw.ui.get('#grid').selectedRow();
		if (selection) {
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
					url: '${base}manager/shopRechargeAmount/update',
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

	//删除(单个)
	function del() {
		var selection = uglcw.ui.get('#grid').selectedRow();
		if (selection) {
			uglcw.ui.confirm("确定删除所选记录吗？", function () {
				$.ajax({
					url:"${base}manager/shopRechargeAmount/delete",
					data: {
						id:selection[0].id,
					},
					type: 'post',
					dataType: 'json',
					success: function (response) {
						if(response == "1"){
							uglcw.ui.success("操作成功");
							uglcw.ui.get('#grid').reload();
						}else{
							uglcw.ui.error("操作失败");
						}
					}
				});
			})
		}else{
			uglcw.ui.toast("请勾选你要操作的行！")
		}
	}


</script>
</body>
</html>
