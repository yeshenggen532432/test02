<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>理货记录</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .row-color-blue {
            color: blue;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query">
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
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
                    url: '${base}manager/stkWaitCrew/page',
                    criteria: '.uglcw-query',
                    pageable: true,
                    ">
                <div data-field="inDate" uglcw-options="width:140">操作日期</div>
                <div data-field="stkName" uglcw-options="width:120">仓库</div>
                <div data-field="outStkName" uglcw-options="width:120">出仓库位</div>
                <div data-field="inStkName" uglcw-options="width:120">入仓库位</div>
                <div data-field="createName" uglcw-options="width:120">创建人</div>
                <div data-field="wareNm" uglcw-options="width:120">商品名称</div>
                <div data-field="qty" uglcw-options="width:120">数量</div>

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
        })
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query');
        })
        uglcw.ui.loaded()
    })

</script>
</body>
</html>
