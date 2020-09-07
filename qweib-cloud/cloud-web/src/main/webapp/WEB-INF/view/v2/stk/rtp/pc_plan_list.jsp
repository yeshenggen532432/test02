<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>计划单位产品毛利统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
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
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/queryPlanList',
                    criteria: '.form-horizontal',
                    pageable: true,
                    dblclick: function(row){
                        uglcw.ui.openTab('产品计划毛利-'+row.id, '${base}manager/showplan?dataTp=1&billId='+ row.id);
                    },
                    loadFilter: {
                      data: function (response) {
                        if(!response.rows || response.rows.length<1){
                            return [];
                        }
                        return response.rows;
                      },
                      total: function (response) {
                        return response.total;
                      }
                     }
                    ">
                <div data-field="planTimeStr" uglcw-options="width:160">日期</div>
                <div data-field="remarks" uglcw-options="width:120, tooltip: true">备注</div>
                <div data-field="operator" uglcw-options="width:160">操作员</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:newBill();" class="k-button k-button-icontext">
        <span class="k-icon k-i-file-add"></span>开单
    </a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        $('.q-box-arrow').on('click', function () {
            $(this).find('i').toggleClass('k-i-arrow-chevron-left k-i-arrow-chevron-down');
            $('.q-box-more').toggle();
            $('.q-box-wrapper').closest('.layui-card').toggleClass('box-shadow')
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })


        uglcw.ui.loaded()
    })


    function newBill() {
        uglcw.ui.openTab('产品计划毛利统计开单', '${base}manager/queryPlanWare');
    }


</script>
</body>
</html>
