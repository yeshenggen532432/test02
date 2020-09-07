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
                    id:'id',
                    url: 'manager/pos/queryPosSaleSub?mastId=${mastId}',
                    criteria: '.form-horizontal',

                    }">
                        <div data-field="wareNm" uglcw-options="width:100"> 商品名称 </div>
                        <div data-field="unitName" uglcw-options="width:100,format: '{0:n2}'">单位</div>
                        <div data-field="qty" uglcw-options="width:100,format: '{0:n2}'">数量</div>
                        <div data-field="disPrice" uglcw-options="width:100,format: '{0:n2}'">单价</div>
                        <div data-field="disAmt" uglcw-options="width:100,format: '{0:n2}'">金额</div>

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
            var padding = 55;
            var height = $(window).height() - padding - $('.header').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

</script>
</body>
</html>
