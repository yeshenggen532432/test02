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
	<div class="layui-card">
		<div class="layui-card header">
			<div class="layui-card-body">
				<ul class="uglcw-query form-horizontal query">
					<li>
						<input uglcw-model="name" uglcw-role="textbox" placeholder="名称">
					</li>
					<li>
						<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
						<button id="reset" class="k-button" uglcw-role="button">重置</button>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<div class="layui-card">
		<div class="layui-card-body full">
			<div id="grid" uglcw-role="grid"
				 uglcw-options="{
				  <%--dblclick:function(row){--%>
              	  <%--uglcw.ui.openTab('供应商类别信息'+row.id, '${base}manager/stkProviderType/edit?id='+ row.id+$.map( function(v, k){  //取行数的id--%>
                  <%--return k+'='+(v||'');--%>
            	  <%--}).join('&'));--%>
       			  <%--},--%>
                    responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}/manager/stkProviderType/pages',
                    criteria: '.query',
                    pageable: true,

                    }">

				<div data-field="name" uglcw-options="width:200">名称</div>
				<div data-field="remark" uglcw-options="width:200">备注</div>
			</div>
		</div>
	</div>
</div>
<script type="text/x-kendo-template" id="toolbar">
	<a role="button" href="javascript:toAdd();" class="k-button k-button-icontext">
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
					<label class="control-label col-xs-8">名称：</label>
					<div class="col-xs-14">
						<input class="form-control" uglcw-role="textbox" uglcw-model="name" id="name"
							   uglcw-validate="required">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-8">备注</label>
					<div class="col-xs-14">
						<textarea class="form-control" uglcw-role="textbox" uglcw-model="remark" id="remark"></textarea>
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

	function toAdd() {//添加
		uglcw.ui.Modal.open({  //弹框当前页面div
			area: '500px',
			content: $('#t').html(),
			success: function (container) {
				uglcw.ui.init($(container)); //初始化页面
			},
			yes: function (container) {
				var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
				if (valid) {
					$.ajax({
						url: '${base}/manager/stkProviderType/save',
						type: 'post',
						data: uglcw.ui.bind(container),
						success: function (state) {
							if (state) {
								uglcw.ui.success("添加成功");
								uglcw.ui.get('#grid').reload();//刷新页面数据

							} else {
								uglcw.ui.error('添加失败');//错误提示
								return;
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
	//获取选中行的值
	function getSelected() {
		var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
		if (selection) {
			uglcw.ui.Modal.open({  //弹框当前页面div
				area: '500px',
				content: $('#t').html(),
				success: function (container) {
					uglcw.ui.init($(container)); //初始化页面
					uglcw.ui.bind($(container).find('#bind'), selection[0]);//绑定数据
				},
				yes: function (container) {
					var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
					if (valid) {
						$.ajax({
							url: '${base}//manager/stkProviderType/save',
							type: 'post',
							data: uglcw.ui.bind(container),
							success: function (state) {
								if (state) {
									uglcw.ui.success("修改成功");
									uglcw.ui.get('#grid').reload();//刷新页面数据
								} else {
									uglcw.ui.error('失败');//错误提示
									return;
								}
							}
						})
					} else {
						uglcw.ui.error('失败');
						return false;
					}

				}
			});
		} else {
			uglcw.ui.warning('请选择要修改的行！');
		}
	}


</script>
</body>
</html>
