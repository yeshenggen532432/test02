<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
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
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px;">
            <div class="layui-card">
                <div class="layui-card-header">商品分类</div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">
                    <div uglcw-role="tree"
                         uglcw-options="
                           url: '${base}manager/companyWaretypes',
                           select: function(e){
                                var node = this.dataItem(e.node);
                                uglcw.ui.get('#wareType').value(node.id);
                                uglcw.ui.get('#grid').reload();
                           },
                           expandable: function(node){
                                return node.id == 0;
                           }
                    "
                    ></div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="wtype" id="wareType" uglcw-role="textbox">
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称/商品编码">
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                            responsive: ['.header', 40],
                            id:'id',
                            pageable:{
                                pageSize: 20
                            },
                            url: '${base}manager/queryStkWares',
                            criteria: '.form-horizontal'
                    ">
                        <div data-field="wareCode">商品编码</div>
                        <div data-field="wareNm" uglcw-options="tooltip: true">商品名称</div>
                        <div data-field="wareGg" uglcw-options="tooltip: true">规格</div>
                        <div data-field="inPrice">采购单价</div>
                        <div data-field="wareDw">单位</div>
                        <div data-field="py">助记码</div>
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
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        });
        uglcw.ui.loaded()
    })
</script>
</body>
</html>
