<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
	<%@include file="/WEB-INF/view/v2/include/header.jsp" %>
	<link rel="stylesheet" href="${base}/static/uglcs/lib/extend/formSelects-v4.css" media="all">
</head>
<body>
<div class="layui-card">
	<div class="layui-card-body">
		<div class="layui-form" lay-filter="" style="width: 80%;">
			<div class="layui-form-item">
				<input type="hidden" name="id" id="id" value="${model.id}"/>
				<label class="layui-form-label">充值面额:</label>
				<div class="layui-input-inline">
					<input type="text" name="czAmount" lay-verify="required|number" placeholder="请输入数字" autocomplete="off"
						   value="${model.czAmount}" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">赠送面额:</label>
				<div class="layui-input-inline">
					<input type="text" name="zsAmount" lay-verify="" placeholder="请输入数字" autocomplete="off"
						   value="${model.zsAmount}" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label"></label>
				<div class="layui-input-block">
					<button class="layui-btn layui-btn-sm" lay-submit lay-filter="save">保存</button>
					<button id="cancel" class="layui-btn layui-btn-sm layui-btn-primary">取消</button>
				</div>
			</div>
		</div>
	</div>
</div>

<script src="${base}/static/uglcs/layui/layui.js"></script>
<script>
	var dataTp = '${dataTp}';
	layui.config({
		base: '/static/uglcs/' //静态资源所在路径
	}).extend({
		index: 'lib/index' //主入口模块
	}).use(['index', 'form', 'formSelects'], function () {
		var form = layui.form;
		var $ = layui.$, layer = parent.layer === undefined ? layui.layer : top.layer;

		form.on('submit(save)', function (data) {
			var index = top.layer.msg('数据提交中，请稍候', {icon: 16, time: false, shade: 0.8});
			$.ajax({
				type: 'post',
				url: 'manager/shopRechargeAmount/update',
				data: data.field,
				success: function (res) {
					top.layer.close(index)
					if (res == '1') {
						top.layer.msg('添加成功')
						setTimeout(function () {
							parent.layer.closeAll();
							parent.location.reload();
						}, 1500)

					} else if (res == '2') {
						top.layer.msg('修改成功')
						setTimeout(function () {
							parent.layer.closeAll();
							parent.location.reload();
						}, 1500)
					}else {
						top.layer.msg('操作失败')
					}
				},
				error: function () {
					top.layer.close(index)
				}
			})
		})

		$('#cancel').on('click', function () {
			parent.layer.closeAll();
		})
	})
	;


</script>
</body>
</html>
