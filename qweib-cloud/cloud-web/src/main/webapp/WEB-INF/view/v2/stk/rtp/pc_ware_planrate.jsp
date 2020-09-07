<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>按客户等级设置商品销售价格</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="uglcw-layout-container">
		<div class="uglcw-layout-fixed" style="width:200px">
			<div class="layui-card">
				<div class="layui-card-header">
					商品分类
				</div>
				<div class="layui-card-body">
					<div id="tree" uglcw-role="tree"
						 uglcw-options="
                        url:'manager/waretypes',
                        expandable:function(node){return node.id == '0'},
                        select: function(e){
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#wtype').value(node.id);
                            uglcw.ui.get('#grid').reload();
                        }
                    "
					>
					</div>
				</div>
			</div>
		</div>
		<div class="uglcw-layout-content">
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal">
						<div class="form-group" style="margin-bottom: 10px;">
							<div class="col-xs-4">
								<input type="hidden" uglcw-model="wtype" id="wtype" uglcw-role="textbox">
								<input type="hidden" uglcw-model="billId" id="billId" uglcw-role="textbox">
								<input uglcw-model="remarks" id="remarks" uglcw-role="textbox" placeholder="备注">
							</div>
							<div class="col-xs-10">
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
					responsive:['.header',40],
                    id:'id',
                    url: 'manager/wares',
                    criteria: '.form-horizontal',
                    pageable: true,

                    ">
						<div data-field="checkbox" uglcw-options="
                        width:50, selectable: true, type: 'checkbox', locked: true,
                        headerAttributes: {'class': 'uglcw-grid-checkbox'}
                        "></div>
						<div data-field="wareCode" uglcw-options="width:120">商品编码</div>
						<div data-field="wareNm" uglcw-options="width:120">商品名称</div>
						<div data-field="price" uglcw-options="width:120">计划倍价</div>
						<div data-field="inPrice" uglcw-options="width:100">计划进价</div>
						<div data-field="discount2" uglcw-options="width:80">计划促销2</div>
						<div data-field="discount3" uglcw-options="width:80">计划促销3</div>
						<div data-field="discount4" uglcw-options="width:80">计划促销4</div>
						<div data-field="startTime" uglcw-options="width:80">开始日期</div>
						<div data-field="endTime" uglcw-options="width:80">结束日期</div>
						<div data-field="disAmt" uglcw-options="width:80">计划毛利</div>


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
		uglcw.ui.loaded()

	})

</script>
</body>
</html>
