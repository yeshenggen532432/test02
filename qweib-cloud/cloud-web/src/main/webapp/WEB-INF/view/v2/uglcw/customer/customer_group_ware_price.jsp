<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户价格档案-选择商品</title>
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
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input type="hidden" uglcw-model="wareId" id="wareId" uglcw-role="textbox">
                    <input uglcw-role="gridselector" uglcw-model="wareNm" id="wareNm"
                           uglcw-options="click:function(){selectWare();}" placeholder="商品名称" readonly>
                </li>
                <li style="width: 400px">
                    <span style="background-color:#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>商品原价
                    <span style="background-color:rebeccapurple">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>客户类型价
                    <span style="background-color:#4db3ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>客户等级价
                    <span style="background-color:green">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>客户商品价
                </li>
            </ul>
        </div>
    </div>
    <%--表格：头部end--%>

    <%--表格：start--%>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
							id:'id',
							<%--checkbox:true,--%>
							pageable: true,
                    		url: '${base}manager/customerGroupWarePrice',
                    		criteria: '.form-horizontal',
                    		dblclick: dblclick,
                    	">
                <div data-field="wareNm" uglcw-options="width:150,tooltip:true">商品名称</div>
                <div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
                <div data-field="wareGg" uglcw-options="width:110,tooltip:true">规格</div>
                <div data-field="wareDw" uglcw-options="width:60">大单位</div>
                <div data-field="minUnit" uglcw-options="width:60">小单位</div>
                <div data-field="wareDj" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_pfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.wareDj, data: row, field:'wareDj', wareSource:row.pfPriceType})
								}
								">
                </div>
                <%--<div data-field="lsPrice" uglcw-options="--%>
                <%--width:120,--%>
                <%--headerTemplate: uglcw.util.template($('#header_lsPrice').html()),--%>
                <%--template:function(row){--%>
                <%--return uglcw.util.template($('#price').html())({val:row.lsPrice, data: row, field:'lsPrice', wareSource:row.lsPriceType})--%>
                <%--}--%>
                <%--">--%>
                <%--</div>--%>
                <%--<div data-field="fxPrice" uglcw-options="--%>
                <%--width:120,--%>
                <%--headerTemplate: uglcw.util.template($('#header_fxPrice').html()),--%>
                <%--template:function(row){--%>
                <%--return uglcw.util.template($('#price').html())({val:row.fxPrice, data: row, field:'fxPrice', wareSource:row.fxPriceType})--%>
                <%--}--%>
                <%--">--%>
                <%--</div>--%>
                <%--<div data-field="cxPrice" uglcw-options="--%>
                <%--width:120,--%>
                <%--headerTemplate: uglcw.util.template($('#header_cxPrice').html()),--%>
                <%--template:function(row){--%>
                <%--return uglcw.util.template($('#price').html())({val:row.cxPrice, data: row, field:'cxPrice', wareSource:row.cxPriceType})--%>
                <%--}--%>
                <%--">--%>
                <%--</div>--%>
                <div data-field="sunitPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_minPfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.sunitPrice, data: row, field:'sunitPrice', wareSource:row.minPfPriceType})
								}
								">
                </div>
                <%--<div data-field="minLsPrice" uglcw-options="--%>
                <%--width:120,--%>
                <%--headerTemplate: uglcw.util.template($('#header_minLsPrice').html()),--%>
                <%--template:function(row){--%>
                <%--return uglcw.util.template($('#price').html())({val:row.minLsPrice, data: row, field:'minLsPrice', wareSource:row.minLsPriceType})--%>
                <%--}--%>
                <%--">--%>
                <%--</div>--%>
                <%--<div data-field="minFxPrice" uglcw-options="--%>
                <%--width:120,--%>
                <%--headerTemplate: uglcw.util.template($('#header_minFxPrice').html()),--%>
                <%--template:function(row){--%>
                <%--return uglcw.util.template($('#price').html())({val:row.minFxPrice, data: row, field:'minFxPrice', wareSource:row.minFxPriceType})--%>
                <%--}--%>
                <%--">--%>
                <%--</div>--%>
                <%--<div data-field="minCxPrice" uglcw-options="--%>
                <%--width:120,--%>
                <%--headerTemplate: uglcw.util.template($('#header_minCxPrice').html()),--%>
                <%--template:function(row){--%>
                <%--return uglcw.util.template($('#price').html())({val:row.minCxPrice, data: row, field:'minCxPrice', wareSource:row.minCxPriceType})--%>
                <%--}--%>
                <%--">--%>
                <%--</div>--%>
            </div>
        </div>
    </div>
    <%--表格：end--%>
</div>
<%--2右边：表格end--%>
</div>
</div>

<script id="header_pfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('wareDj');">大单位批发价</span>
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('lsPrice');">大单位零售价</span>
</script>
<script id="header_fxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('fxPrice');">大单位分销价</span>
</script>
<script id="header_cxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('cxPrice');">大单位促销价</span>
</script>
<script id="header_minPfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('sunitPrice');">小单位批发价</span>
</script>
<script id="header_minLsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minLsPrice');">小单位零售价</span>
</script>
<script id="header_minFxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minFxPrice');">小单位分销价</span>
</script>
<script id="header_minCxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minCxPrice');">小单位促销价</span>
</script>
<script id="price" type="text/x-uglcw-template">
    # if(val!=null && val!=undefined && val!="" && val!="undefined"){ #
    # }else{ #
    # val = "" #
    # } #

    # if(wareSource == 0){ #
    <span style="color: \\#000;">#= val #</span>
    # }else if(wareSource == 1){ #
    <span style="color: rebeccapurple;">#= val #</span>
    # }else if(wareSource == 2){ #
    <span style="color: \\#4db3ff;">#= val #</span>
    # }else if(wareSource == 3){ #
    <span style="color: green;">#= val #</span>
    # } #


</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {

        //ui:初始化
        uglcw.ui.init();

        // //查询
        // uglcw.ui.get('#search').on('click', function () {
        // 	uglcw.ui.get('#grid').reload();
        // })
        //
        // //重置
        // uglcw.ui.get('#reset').on('click', function () {
        // 	uglcw.ui.clear('.form-horizontal');
        // 	uglcw.ui.get('#grid').reload();
        // })

        resize();
        $(window).resize(resize);
        uglcw.ui.loaded();
    })

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - 40;
            grid.setOptions({
                height: height,
                autoBind: true
            })
            //设置tree高度
            var treeHeight = $(window).height() - $("div.layui-card-header").height() - 60;
            $("#tree").height(treeHeight + "px");
        }, 200)
    }

    //---------------------------------------------------------------------------------------------------------------
    function selectWare() {
        <tag:product-selector query="onQueryProduct" callback="onProductSelect"/>
    }

    function onQueryProduct(params) {
        params.stkId = '0';
        return params;
    }

    function onProductSelect(rows) {
        if (rows) {
            uglcw.ui.get('#wareNm').value(rows[0].wareNm);
            uglcw.ui.get('#wareId').value(rows[0].wareId);
            uglcw.ui.get('#grid').reload();
        }
    }

    function dblclick(row) {
        var wareId = row.wareId;
        var wareDj = row.wareDj;
        var lsPrice = row.lsPrice;
        var fxPrice = row.fxPrice;
        var cxPrice = row.cxPrice;
        var sunitPrice = row.sunitPrice;
        var minLsPrice = row.minLsPrice;
        var minFxPrice = row.minFxPrice;
        var minCxPrice = row.minCxPrice;

        var param = "wareId=" + wareId;
        param += "&wareDj=" + wareDj;
        param += "&lsPrice=" + lsPrice;
        param += "&fxPrice=" + fxPrice;
        param += "&cxPrice=" + cxPrice;
        param += "&sunitPrice=" + sunitPrice;
        param += "&minLsPrice=" + minLsPrice;
        param += "&minFxPrice=" + minFxPrice;
        param += "&minCxPrice=" + minCxPrice;
        uglcw.ui.openTab("客户列表信息", "${base}manager/toCustomerGroupWarePriceList?" + param);
    }


</script>
</body>
</html>
