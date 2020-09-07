<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>生成的统计表</title>
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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" uglcw-model="rptType" value="${rptType}" uglcw-role="textbox">
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input uglcw-model="rptTitle" uglcw-role="textbox" placeholder="标题">
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
             uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    url: '${base}manager/querySaveRptDataStatPage',
                    criteria: '.query',
                    pageable: true,
                     dblclick:function(row){
                       uglcw.ui.openTab(row.rptTitle, '${base}manager/toStkCstStatView?id='+ row.id+$.map( function(v, k){  //只带id
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    loadFilter: {
                      data: function (response) {
                        return response.rows || [];
                      },
                     }
                    ">
            <div data-field="rptTitle" uglcw-options="width:350, tooltip: true">标题</div>
            <div data-field="sdate" uglcw-options="width: 200">日期</div>
            <div data-field="operName"
                 uglcw-options="width:120">
                操作人
            </div>
            <div data-field="remark" uglcw-options="width:'auto'">备注</div>
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
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        });
        uglcw.ui.loaded()
    })


</script>
</body>
</html>
