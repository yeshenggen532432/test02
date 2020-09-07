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
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">
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
                            <input uglcw-model="sdate" id="sdate" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" id="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <input type="hidden" uglcw-model="branchId" value="" id="branchId" uglcw-role="textbox">
                            <input uglcw-role="textbox" id="memberNm" uglcw-model="memberNm" placeholder="员工姓名">
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
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    url: '${base}manager/kqrpt/queryKqStat',
                    criteria: '.form-horizontal',
                    pageable: true,
                    checkbox: true
                    ">
                        <div data-field="memberNm" uglcw-options="width:80">姓名</div>
                        <div data-field="pbDays" uglcw-options="width:80">排班天数</div>
                        <div data-field="monthDays" uglcw-options="width:80">实际出勤</div>
                        <div data-field="cdQty" uglcw-options="width:80">迟到次数</div>
                        <div data-field="cdMinute" uglcw-options="width:80">迟到分钟</div>
                        <div data-field="ztQty" uglcw-options="width:80">早退次数</div>
                        <div data-field="ztMinute" uglcw-options="width:80">早退分钟</div>
                        <div data-field="lkQty" uglcw-options="width:80">漏卡次数</div>
                        <div data-field="kgQty" uglcw-options="width:80">旷工次数</div>
                        <div data-field="outOfQty" uglcw-options="width:100">考勤地点错误</div>
                        <div data-field="workHours" uglcw-options="width:80">工作小时数</div>
                        <div data-field="qjQty" uglcw-options="width:80">请假小时数</div>
                        <div data-field="jbQty" uglcw-options="width:80">加班小时数</div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript: toPrint();" class="k-button k-button-icontext">
        <span class="k-icon k-i-print"></span>打印
    </a>
</script>
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
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - $('.k-grid-toolbar').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

    function toPrint() {
        /*var params=uglcw.ui.bind('.query');*/
        var branchId = $("#branchId").val();
        var params = "branchId=" + branchId + "&memberNm=" + $("#memberNm").val() + "&sdate=" + $("#sdate").val() + "&edate=" + $("#edate").val() + "&billName=考勤汇算表";
        uglcw.ui.openTab('考勤汇算表打印', '${base}manager/kqrpt/toKqStatPrint?' + params);
    }

</script>
</body>
</html>
