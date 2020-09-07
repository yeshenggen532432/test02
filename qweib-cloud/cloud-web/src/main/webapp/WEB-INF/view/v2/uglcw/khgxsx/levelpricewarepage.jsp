<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<div class="layui-col-md2">
			<div class="layui-card">
				<div class="layui-card-header">
					商品分类
				</div>
				<div class="layui-card-body">
					<div id="tree" uglcw-role="tree"
						 uglcw-options="
                        url:'manager/companyStockWaretypes',
                        select: function(e){
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#wareType').value(node.id);
                            uglcw.ui.get('#grid').reload();
                        }
                    "
					>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-col-md10">
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal">
						<div class="form-group" style="margin-bottom: 10px;">

							<div class="col-xs-4">
								<input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
								<input id="wtype" type="hidden" uglcw-model="wtype" uglcw-role="textbox">
								<input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
							</div>
							<div class="col-xs-4">
								<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
								<button id="reset" class="k-button" uglcw-role="button">重置</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
                    id:'id',
                    toolbar: kendo.template($('#toolbar').html()),
                    url: 'manager/wares',
                    criteria: '.form-horizontal',
                    pageable: true,

                    ">
						<div data-field="inDate" uglcw-options="
                        width:50, selectable: true, type: 'checkbox', locked: true,
                        headerAttributes: {'class': 'uglcw-grid-checkbox'}
                        "></div>
						<div data-field="wareCode" uglcw-options="width:180">商品编码</div>
						<div data-field="wareNm" uglcw-options="width:160">商品名称</div>
						<div data-field="waretypeNm" uglcw-options="width:160">所属分类</div>
						<div data-field="wareGg" uglcw-options="width:160">规格</div>
						<div data-field="wareDw" uglcw-options="width:160">单位</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		uglcw.ui.init();
		//显示商品
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#grid').k().dataSource.read();
		})

		uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.form-horizontal',{
				sdate: '${sdate}', edate: '${edate}'
			});
		})
		resize();
		$(window).resize(resize)
		uglcw.ui.loaded()
	})

	var delay;

	function resize() {
		if (delay) {
			clearTimeout(delay);
		}
		delay = setTimeout(function () {
			var grid = uglcw.ui.get('#grid').k();
			var padding = 100;
			var height = $(window).height() - padding - $('.header').height();
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}

</script>
</body>
</html>
