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
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                            responsive:[40],
                            id:'id',
                            url: 'manager/queryMapGjPage?dataTp=${dataTp}',
                            criteria: '.query',
                            pageable: true,

                    }">

                        <div data-field="userNm" uglcw-options="width:140">业务员名称</div>
                        <div data-field="userTel" uglcw-options="width:160">电话</div>
                        <div data-field="times" uglcw-options="width:160">时间</div>
                        <div data-field="address" uglcw-options="width:275">地址</div>
                        <div data-field="zt" uglcw-options="width:120">状态</div>
                        <div data-field="userHead"
                             uglcw-options="width:200, template: uglcw.util.template($('#formatterSt').html())">操作
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/x-kendo-template" id="formatterSt">
    <a style="color: blue;text-decoration:underline" href="javascript:todetail('#=data.userNm#','#=data.userId#')">轨迹回放</a>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.loaded()
    })

    function todetail(title, id) {
        uglcw.ui.openTab(title, '${base}manager/queryMapGjOne?mid=' + id);
    }

</script>
</body>
</html>
