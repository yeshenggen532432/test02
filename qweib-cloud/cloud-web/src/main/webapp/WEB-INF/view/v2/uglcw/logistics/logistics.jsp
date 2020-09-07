<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
	<title>驰用T3</title>
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
		<div class="layui-col-md12">
			<div class="layui-card">
				<div class="layui-card header">
					<div class="layui-card-body">
						<div class="form-horizontal query">
							<div class="form-group" style="margin-bottom: inherit;">
								<div class="col-xs-4">
									<input uglcw-model="wlNm" uglcw-role="textbox" placeholder="名称">
								</div>
								<div class="col-xs-4">
									<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
									<button id="reset" class="k-button" uglcw-role="button">重置</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="{
					responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}/manager/logisticsPage',
                    criteria: '.query',
                    pageable: true,

                    }">
						<div data-field="wlNm" uglcw-options="width:160">名称</div>
						<div data-field="dcode" uglcw-options="width:160">代码</div>
						<div data-field="linkman" uglcw-options="width:160">联系人</div>
						<div data-field="tel" uglcw-options="width:160">联系电话</div>
						<div data-field="address" uglcw-options="width:160">地址</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/x-kendo-template" id="toolbar">
	<a role="button" href="javascript:toaddJxsjb();" class="k-button k-button-icontext">
		<span class="k-icon k-i-plus"></span>添加
	</a>
	<a role="button" class="k-button k-button-icontext"
	   href="javascript:getSelected();">
		<span class="k-icon k-i-pencil"></span>修改
	</a>
</script>

<script id="t" type="text/uglcw-template">
	<div class="layui-card">
		<div class="layui-card-body">
			<div class="form-horizontal" uglcw-role="validator" id="bind">
				<div class="form-group">
					<input type="hidden" uglcw-role="textbox" uglcw-model="id" id="id">
					<label class="control-label col-xs-8">名称</label>
					<div class="col-xs-14">
						<input class="form-control" uglcw-role="textbox" uglcw-model="wlNm" uglcw-validate="required">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-8">代码</label>
					<div class="col-xs-14">
						<input class="form-control" uglcw-role="textbox" uglcw-model="dcode" uglcw-validate="required">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-8">联系人</label>
					<div class="col-xs-14">
						<input class="form-control" uglcw-role="textbox" uglcw-model="linkman" uglcw-validate="required">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-8">联系电话</label>
					<div class="col-xs-14">
						<input class="form-control" uglcw-role="textbox" uglcw-model="tel" uglcw-validate="required">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-8">地址</label>
					<div class="col-xs-14">
						<input class="form-control" uglcw-role="textbox" uglcw-model="address" uglcw-validate="required">
					</div>
				</div>
			</div>
		</div>
	</div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	$(function () {
		uglcw.ui.init();

		uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
			uglcw.ui.get('#grid').k().dataSource.read();
		})

		uglcw.ui.get('#reset').on('click', function () {    //重置（清除搜索输入框数据）
			uglcw.ui.clear('.form-horizontal');
		})

		uglcw.ui.loaded()
	})



	function toaddJxsjb() {//添加客户等级
		uglcw.ui.Modal.open({
			area: '500px',
			content: $('#t').html(),
			success: function (container) {
				uglcw.ui.init($(container));
			},
			yes: function (container) {
				var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
				if (valid) {
					$.ajax({
						url: '${base}/manager/operlogistics',
						data: uglcw.ui.bind(container),  //绑定值
						type: 'post',
						success: function (data) {
							if(data == "1" || data == "2") {
								uglcw.ui.get('#grid').reload();//刷新页面数据
							}else{
								alert("操作失败");
							}
						}
					})
				} else {
					uglcw.ui.error('失败');
					return false;
				}
			}
		});
	}

	function getSelected() {//修改
		var selection = uglcw.ui.get('#grid').selectedRow();
		if (selection) {
			uglcw.ui.Modal.open({
				area: '500px',
				content: $('#t').html(),
				success: function (container) {
					uglcw.ui.init($(container));//初始化
					uglcw.ui.bind($(container).find('#bind'), selection[0]);//邦定数据
				},
				yes: function (container) {
					var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
					if (valid) {
						$.ajax({
							url: '${base}/manager/operlogistics',
							data: uglcw.ui.bind(container),  //绑定值
							type: 'post',
							success: function (data) {
								if(data == "1" || data == "2"){
									uglcw.ui.get('#grid').reload();//刷新页面数据
								}else{
									alert("操作失败");
								}
							}
						})
					} else {
						uglcw.ui.error('失败');
						return false;
					}
				}
			});
		}else{
			uglcw.ui.warning('请选择要修改的行！');
		}
	}


</script>
</body>
</html>
