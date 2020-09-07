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
                    <ul class="uglcw-query form-horizontal" id="export">
                        <li>
                            <input uglcw-model="name" uglcw-role="textbox" placeholder="模板名称">
                            <input uglcw-model="delFlag" uglcw-role="textbox" value="0" type="hidden">
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
                            checkbox:'true',
                            responsive:['.header',40],
                            id:'id',
                            toolbar: kendo.template($('#toolbar').html()),
                            url: 'manager/queryAuditModelPage',
                            criteria: '.uglcw-query',
                            pageable: true,
                        }">
                        <div data-field="name" uglcw-options="width:160,tooltip:true">模板名称</div>
                        <div data-field="detailName" uglcw-options="width:100,tooltip:true">详情</div>
                        <div data-field="amountName" uglcw-options="width:80,tooltip:true">金额</div>
                        <div data-field="timeName" uglcw-options="width:140,tooltip:true">时间</div>
                        <div data-field="typeName" uglcw-options="width:80,tooltip:true">类型</div>
                        <div data-field="objectName" uglcw-options="width:80,tooltip:true">对象</div>
                        <div data-field="accountName" uglcw-options="width:80,tooltip:true">账户</div>
                        <div data-field="orderName" uglcw-options="width:80,tooltip:true">关联单</div>
                        <div data-field="remarkName" uglcw-options="width:80,tooltip:true">备注</div>
                        <div data-field="isNormal" uglcw-options="width:100,tooltip:true, template: uglcw.util.template($('#formatterIsNormal').html())">是否系统默认</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="formatterIsNormal">
    # if('1' == data.isNormal ){ #
    是
    # }else{ #
    否
    # } #
</script>

<script type="text/x-kendo-template" id="toolbar">
    <%--<a role="button" class="k-button k-button-icontext"--%>
       <%--href="javascript:toAdd();">--%>
        <%--<span class="k-icon k-i-plus"></span>添加审批--%>
    <%--</a>--%>
    <%--<a role="button" href="javascript:toUpdate();" class="k-button k-button-icontext">--%>
        <%--<span class="k-icon k-i-edit"></span>修改审批--%>
    <%--</a>--%>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
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
