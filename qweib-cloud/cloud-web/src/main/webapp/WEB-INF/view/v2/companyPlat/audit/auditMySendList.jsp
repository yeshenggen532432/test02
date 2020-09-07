<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>我发起的列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-panelbar .k-tabstrip > .k-content, .k-tabstrip > .k-content {
            position: static;
            border-style: solid;
            border-width: 1px;
            margin: 0;
            padding: 0;
            zoom: 1;
        }

        /*.uglcw-tabstrip .k-state-disabled {*/
            /*opacity: 1;*/
        /*}*/

    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body full">
            <div uglcw-role="tabs" uglcw-options="select: function(e){
                var index = $(e.item).index();
                <%--if(index > 0){--%>
                    <%--$('.level').hide();--%>
                    <%--$('.non-level').show();--%>
                <%--}else{--%>
                    <%--$('.level').show();--%>
                    <%--$('.non-level').hide();--%>
                <%--}--%>
                var grid = $('#grid'+index).data('kendoGrid');
                if(grid){
                    uglcw.ui.get('#grid'+index).reload({stay: true});
                }
            }">
                <ul>
                    <li>审批中</li>
                    <li>审批完成</li>
                </ul>
                <div>
                    <ul class="uglcw-query query0">
                        <li class="level">
                            <input uglcw-model="search" uglcw-role="textbox" placeholder="标题;详情;">
                        </li>
                        <li class="level">
                            <input uglcw-model="time" uglcw-role="datepicker">
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                    <div id="grid0" uglcw-role="grid"
                         uglcw-options="
						    responsive:['.header',80],
							id:'id',
							pageable: true,
                    		url: '${base}manager/queryMySendPage?isOver=2',
                    		criteria: '.query0',
                    		dblclick:function(row){
                    		    toTab(row)
                    		}
                    	">
                        <div data-field="auditNo" uglcw-options="width:160,tooltip:true">审批编号</div>
                        <div data-field="title" uglcw-options="width:160,tooltip:true">标题</div>
                        <div data-field="stime" uglcw-options="width:160,tooltip:true">申请时间</div>
                        <div data-field="checkNm" uglcw-options="width:160,tooltip:true">等待审批人</div>
                    </div>
                </div>
                <div>
                    <ul class="uglcw-query query1">
                        <li class="level">
                            <input uglcw-model="search" uglcw-role="textbox" placeholder="标题;详情;">
                        </li>
                        <li class="level">
                            <input uglcw-model="time" uglcw-role="datepicker">
                        </li>
                        <li>
                            <button id="search1" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset1" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                    <div id="grid1" uglcw-role="grid"
                         uglcw-options="
						    responsive:['.header',80],
							id:'id',
							autoBind:false,
							pageable: true,
                    		url: '${base}manager/queryMySendPage?isOver=1',
                    		criteria: '.query1',
                    		dblclick:function(row){
                    		    toTab(row)
                    		}
                    	">
                        <div data-field="auditNo" uglcw-options="width:160,tooltip:true">审批编号</div>
                        <div data-field="title" uglcw-options="width:160,tooltip:true">标题</div>
                        <div data-field="stime" uglcw-options="width:160,tooltip:true">申请时间</div>
                        <div data-field="isOver"
                             uglcw-options="width:70, template: uglcw.util.template($('#formatterIsOver').html())">审批完成
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="formatterIsOver">
    # if('1-3' == data.isOver){ #
    撤销
    # } else if('1-2' == data.isOver){ #
    拒绝
    # } else if('1-1' == data.isOver){ #
    同意
    # } else if('2' == data.isOver){ #
    未完成
    # } #
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {

        uglcw.ui.init();
        uglcw.ui.loaded();
        $('#search').on('click', function () {
            uglcw.ui.get('.uglcw-grid:visible').reload();
        })
        $('#reset').on('click', function () {
            uglcw.ui.clear('.query', {wareId: '', wareNm: ''});
            uglcw.ui.get('.uglcw-grid:visible').reload();
        })
        $('#search1').on('click', function () {
            uglcw.ui.get('.uglcw-grid:visible').reload();
        })
        $('#reset1').on('click', function () {
            uglcw.ui.clear('.query1', {wareId: '', wareNm: ''});
            uglcw.ui.get('.uglcw-grid:visible').reload();
        })

    })

    //-----------------------------------------------------------------------------------------

    function toTab(row) {
        uglcw.ui.openTab("审批详情-" + row.auditNo, "${base}/manager/toAuditDetailOperation?type=1&auditNo=" + row.auditNo)
    }

</script>
</body>
</html>
