<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px;">
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
                    <ul class="uglcw-query form-horizontal query">
                        <li>
                            <input uglcw-model="sdate" id="sdate" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" id="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <input type="hidden" uglcw-model="branchId" value="" id="branchId" uglcw-role="textbox">
                            <input uglcw-role="textbox" id="memberNm" uglcw-model="memberNm" placeholder="姓名">
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                        <li style="width: 400px !important;padding-top: 5px">
                            <span>&nbsp; &nbsp;正常√&nbsp; &nbsp;</span><span>迟到L&nbsp; &nbsp;</span><span>缺勤×&nbsp; &nbsp;</span><span>备注≠&nbsp; &nbsp;</span>
                            <span>早退E&nbsp; &nbsp;</span><span>漏卡■&nbsp; &nbsp;</span><span>考勤地点错误O</span>

                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid-container">

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="grid-template">
    <div id="grid" uglcw-role="grid"
         uglcw-options="
                    responsive:['.header',40],
                    align: 'center',
                    pageable: true,
                    toolbar: uglcw.util.template($('\\#toolbar').html()),
                    url: '${base}manager/kqrpt/queryKqResult',
                    criteria: '.query',
                    loadFilter:{
                      data: function(response){
                        var rows = response.rows || [];
                        $.map(rows, function(row){
                            $(row.dayStr).each(function(i, v){
                                row['day'+i] = v;
                            });
                        })
                        return rows;
                      }
                    }
                    ">
        <div data-field="memberNm" uglcw-options="width:80">姓名</div>
        # for(var i= 0; i<=days; i++){ #
        # var day = i+1; day = day <10 ? '0'+ day: day#
        <div data-field="day#= i#" uglcw-options="width: 60">#= day #</div>
        #}#
    </div>
</script>
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
            initGrid();
        })
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
        })
        initGrid();
        uglcw.ui.loaded()
    })

    function initGrid() {
        var query = uglcw.ui.bind('.query');
        var dayDiff = (new Date(query.edate) - new Date(query.sdate)) / 1000 / 60 / 60 / 24;
        var gridHtml = uglcw.util.template($('#grid-template').html())({days: dayDiff});
        $('#grid-container').html(gridHtml);
        uglcw.ui.init('#grid-container');
    }


    function toPrint() {
        var branchId = $("#branchId").val();
        var params = "branchId=" + branchId + "&memberNm=" + $("#memberNm").val() + "&sdate=" + $("#sdate").val() + "&edate=" + $("#edate").val() + "&billName=考勤签注表";
        uglcw.ui.openTab('考勤签注表打印', '${base}manager/kqrpt/toKqResultPrint?' + params);
    }

</script>
</body>
</html>
