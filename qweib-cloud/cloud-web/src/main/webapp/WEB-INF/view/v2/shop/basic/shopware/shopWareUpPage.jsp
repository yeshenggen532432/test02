<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品分组-商品列表</title>
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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input type="hidden" uglcw-model="wtype" id="wareType" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="groupIds" id="groupIds" value="${groupIds}" uglcw-role="textbox">
                    <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
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
                    		url: '${base}manager/shopWare/uppage',
                    		criteria: '.form-horizontal',
                    	">
                <div data-field="wareNm">商品名称</div>
                <div data-field="wareGg">规格</div>
                <div data-field="wareDw">单位</div>
                <div data-field="wareDj">批发价</div>
                <div data-field="lsPrice">原价</div>
                <div data-field="shopWarePrice">商城批发价(大)</div>
                <div data-field="shopWareLsPrice">商城零售价(大)</div>
            </div>
        </div>
    </div>
</div>
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
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.loaded();
    })

</script>
</body>
</html>
