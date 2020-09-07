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
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal query">
                        <li>
                            <input uglcw-model="dayNum" uglcw-role="textbox" placeholder="几天以上没拜访">
                        </li>
                        <li>
                            <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
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
                         uglcw-options="{
                    responsive:['.header',40],
                    id:'id',
                     toolbar: kendo.template($('#toolbar').html()),
                    url: '${base}manager/customerdayPage?dataTp=${dataTp}',
                    criteria: '.form-horizontal',
                    pageable: true,

                    }">

                        <div data-field="khNm" uglcw-options="width:160">客户名称</div>
                        <div data-field="mobile" uglcw-options="{width:160}">客户电话</div>
                        <div data-field="address" uglcw-options="{width:275}">客户地址</div>
                        <div data-field="memberNm" uglcw-options="{width:120}">业务员名称</div>
                        <div data-field="scbfDate" uglcw-options="{width:140}">最后拜访日期</div>
                        <div data-field="dayNum" uglcw-options="{width:120}">几天以上没拜访</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript: toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-download"></span>导出
    </a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<tag:exporter service="sysKhBfDayService" method="queryKhBfDay"
              bean="com.qweib.cloud.core.domain.SysKhBfDay"
              condition=".query" description="多久没拜访客户记录"

/>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


</script>
</body>
</html>
