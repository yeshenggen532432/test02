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
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width:200px">
            <div class="layui-card">
                <div class="layui-card-header">
                    部门-员工
                </div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:[75]">
                    <div id="tree" uglcw-role="tree"
                         uglcw-options="
                        url:'manager/departs?depart=${depart }&dataTp=1',
                        initLevel: 1,
                        select: function(e){
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#branchId').value(node.id);
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
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <input type="hidden" uglcw-model="branchId" id="branchId" uglcw-role="textbox" value="">
                            <input uglcw-role="textbox" uglcw-model="memberNm" placeholder="员工姓名">
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
                    url: '${base}manager/kqrpt/queryKqRecord',
                    criteria: '.form-horizontal',
                    pageable: true,
                    checkbox: true
                    ">
                        <div data-field="memberNm" uglcw-options="width:120">姓名</div>
                        <div data-field="kqDate" uglcw-options="width:160">日期</div>
                        <div data-field="time1" uglcw-options="width:160">时间1</div>
                        <div data-field="time2" uglcw-options="width:160">时间2</div>
                        <div data-field="time3" uglcw-options="width:160">时间3</div>
                        <div data-field="time4" uglcw-options="width:160">时间4</div>
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
        uglcw.layout.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {
                sdate: '${sdate}', edate: '${edate}'
            });
        })
        uglcw.ui.loaded()
    })


</script>
</body>
</html>
