<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>组团方案列表</title>
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
            <ul class="uglcw-query query">
                <li>
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="组团名称">
                </li>
                <%--<li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="状态"
                            uglcw-options="value:''">
                        <option value="">全部</option>
                        <option value="1">启用</option>
                        <option value="0">禁用</option>
                    </select>
                </li>--%>
                <li>
                    <button uglcw-role="button" class="k-info" id="search">搜索</button>
                    <button uglcw-role="button" id="reset">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                            toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/shopHeadTourPlan/pages',
                    		criteria: '.query',
                    	">
                <div data-field="name" uglcw-options="width:150">组图名称</div>
                <div data-field="startTime" uglcw-options="width:120">开始时间</div>
                <div data-field="endTime" uglcw-options="width:120">结束时间</div>
                <div data-field="opt" uglcw-options="width:200,template: uglcw.util.template($('#opt_tpl').html())">
                    操作
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加组团方案
    </a>
</script>
<script type="text/x-uglcw-template" id="opt_tpl">
    <button class="k-button k-success" type="button" onclick="toWareList('#=data.name#','#=data.id#')">设置商品
    </button>
    <button class="k-button k-success" type="button" onclick="edit(#=data.id#)">编辑</button>
</script>

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
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        //resize();
        //$(window).resize(resize);
        uglcw.ui.loaded();

        uglcw.io.on('shop_head_tour_plan_chage', function (data) {
            location.href = location.href;
        });
    })


    function edit(id) {
        uglcw.ui.openTab('组团方案' + id, '${base}manager/shopHeadTourPlan/edit?id=' + id);
    }

    function toWareList(name, id) {
        uglcw.ui.openTab(name + '_商品列表', '${base}/manager/shopHeadTourPlan/wareList?planId=' + id);
    }

    function add() {
        uglcw.ui.openTab('添加组团方案', '${base}manager/shopHeadTourPlan/add');
    }

</script>

</body>
</html>
