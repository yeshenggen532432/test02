<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" uglcw-model="rptType" value="${rptType}" uglcw-role="textbox">
                    <input id="sdate" uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input id="edate" uglcw-model="edate" uglcw-role="datepicker" placeholder="结束时间" value="${edate}">
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
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                 responsive:['.header',40],
                    id:'id',
                    dblclick: function(row){
                         var q = uglcw.ui.bind('.query');
                         q.id=row.id;
                         delete q['sdate'];
                         delete q['edate'];
                         q.title=row.rptTitle
                         uglcw.ui.openTab(q.title, '${base}manager/querySaveRptDataItemStat?'+ $.map(q, function (v, k) {
                            return k + '=' + (v || '');
                        }).join('&'));
                    },
                    url: '${base}manager/querySaveRptDataStatPage',
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="rptTitle" uglcw-options="width:180">标题</div>
                <div data-field="sdate" uglcw-options="width:180">日期</div>
                <div data-field="operName" uglcw-options="width:180">操作人</div>
                <div data-field="remark" uglcw-options="width:180">备注</div>
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
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })

        uglcw.ui.loaded()
    })

</script>
</body>
</html>
