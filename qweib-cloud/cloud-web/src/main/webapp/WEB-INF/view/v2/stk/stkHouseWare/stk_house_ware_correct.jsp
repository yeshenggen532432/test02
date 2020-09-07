<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>库位纠正</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .row-color-blue {
            color: blue;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query">
                <li>
                    <%--<uglcw:storage-select--%>
                            <%--base="${base}"--%>
                            <%--id="stkId"--%>
                            <%--name="stkId"--%>
                            <%--status="1"--%>
                    <%--/>--%>
                    <uglcw:storage-house-temp-select
                            base="${base}"
                            id="stkId"
                            name="stkId"
                            houseId="houseId"
                            houseName="houseId"/>

                </li>
                <li>
                    <button id="search" uglcw-role="button" onclick="saveData();" class="k-button k-info">保存并确定纠正</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive: ['.header', 40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    rowNumber: true,
                     autoBind: false,
                     editable: true,
                    id:'id'
                    ">
                <div data-field="wareNm" uglcw-options="width:120">商品名称</div>
                <div data-field="beUnit" uglcw-options="width:120,hidden:true">单位</div>
                <div data-field="stkQty" uglcw-options="width:120,
                    headerTemplate: uglcw.util.template($('#header_stkQty_title').html())
                ">库存数量▷</div>
                <div data-field="minStkQty" uglcw-options="width:120,hidden:true">库存数量(小)</div>
                <div data-field="qty" uglcw-options="width:120,
                    headerTemplate: uglcw.util.template($('#header_qty_title').html())">仓位数▷</div>
                <div data-field="minQty" uglcw-options="width:120,hidden:true">仓位数(小)</div>
                <div data-field="rlt" uglcw-options="width:100,template:uglcw.util.template($('#resultTpl').html())">
                    库存库位对比
                </div>
                <div data-field="checkQty" uglcw-options="width:120">实际数量</div>
                <div data-field="realQty" uglcw-options="
                            width:120,
                            schema:{ type: 'number',decimals:10}
                            ">实际数量(大)</div>
                <div data-field="unitName" uglcw-options="width:60">大单位</div>
                <div data-field="minRealQty" uglcw-options="width:120,
                            schema:{ type: 'number',decimals:10}">实际数量(小)</div>
                <div data-field="minUnit" uglcw-options="width:60">小单位</div>
                <div data-field="disQty" uglcw-options="width:120">纠正数±</div>
                <div data-field="minDisQty" uglcw-options="width:120,hidden:true">纠正数小±</div>
                <div data-field="disStkQty" uglcw-options="width:120">盘盈亏±</div>
                <div data-field="minDisStkQty" uglcw-options="width:120,hidden:true">盘盈亏(小)</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">

    <a role="button" class="k-button k-button-icontext"
       href="javascript:showProductSelector();">
        <span class="k-icon k-i-search"></span>选择商品
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:laodStkWare();">
        <span class="k-icon k-i-search"></span>加载当前库存商品
    </a>
    <span style="color: red">注:实际数量请分别填入商品大小单位实际库存数，确认后将自动纠正库位数及及时库存数量</span>
    <%--<button id="crewBtn" class="k-button" uglcw-role="button">确定纠正</button>--%>
    <%--<button id="crewHisBtn" class="k-button" uglcw-role="button">纠正历史</button>--%>
</script>

<script id="resultTpl" type="text/x-uglcw-template">
    #if(data.minStkQty!=data.minQty){#
      不一致
    #}else{#
    一致
    #}#
</script>

<script id="header_stkQty_title" type="text/x-uglcw-template">
    <span onclick="javascript:filterColumn('stkQty');">库存数量<span style="color:blue;font-weight: bold">▷</span><div style="display: none"><input type="checkbox" id="stkQty_chk"></div></span>
</script>
<script id="header_qty_title" type="text/x-uglcw-template">
    <span onclick="javascript:filterColumn('qty');">仓位数<span style="color:blue;font-weight: bold">▷</span><div style="display: none"><input type="checkbox" id="qty_chk"></div></span>
</script>
<tag:product-in-selector-template query="onQueryProduct"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        // uglcw.ui.get('#search').on('click', function () {
        //     uglcw.ui.get('#grid').reload();
        // })
        // uglcw.ui.get('#reset').on('click', function () {
        //     uglcw.ui.clear('.uglcw-query');
        // })
        <%--uglcw.ui.get('#crewBtn').on('click', function () {--%>
            <%--saveData();--%>
        <%--})--%>
        <%--uglcw.ui.get('#crewHisBtn').on('click', function () {--%>
            <%--uglcw.ui.openTab('纠正历史', '${base}manager/stkCrewCheck/topage');--%>
        <%--})--%>

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange' && (e.field == 'minRealQty' || e.field =='realQty')) {
                var item = e.items[0];
                onRowChange(item);
                item.set('checkQty', item.checkQty);
                item.set('disStkQty', item.disStkQty);
                item.set('minDisStkQty', item.minDisStkQty);
                item.set('disQty',  item.disQty);
                item.set('minDisQty', item.minDisQty);
                item.checkQty=item.checkQty;
                uglcw.ui.get("#grid").commit();
            }
        });

        uglcw.ui.loaded()
    })

    function laodStkWare(){
        uglcw.ui.confirm('加载库存商品,当前列表数据将会重新加载？', function () {
            uglcw.ui.get('#grid').bind([]);
            loadData("");
        });
    }

    function onQueryProduct(param) {
         param.stkId = uglcw.ui.get('#stkId').value();
        return param;
    }
    function showProductSelector() {
        // if (!uglcw.ui.get('#stkId').value()) {
        //     return uglcw.ui.error('请选择仓库');
        // }

        <tag:product-out-selector-script selection="#grid"  callback="onProductSelect"/>

    }

    function currectHis(){
        uglcw.ui.openTab('纠正历史', '${base}manager/stkCrewCheck/topage');
    }

    function onProductSelect(data) {
        if (data) {
            if($.isFunction(data.toJSON)){
                data = data.toJSON();
            }
            var wareIds = $.map(data, function (row) {
                return "'" + row.wareId + "'";
            }).join(',');
            var wareNms = $.map(data, function (row) {
                return "" + row.wareNm + "";
            }).join(',');
            $("#wareIds").val(wareIds);
            $("#wareNms").val(wareNms);

            if(wareIds!=""){
                loadData(wareIds);
            }

        }
    }

    function onRowChange(item) {

        var hsNum = item.hsNum || 1;
        var hsQty = item.minRealQty / hsNum;
        var checkQty = parseFloat(item.realQty)+parseFloat(hsQty);

        item.checkQty = (Math.floor(checkQty * 100) / 100)|| 0;

        var minHsQty = item.realQty*hsNum;
        var minCheckQty = parseFloat(item.minRealQty)+parseFloat(minHsQty);
        var disStkQty = parseFloat(checkQty)-parseFloat(item.stkQty);
        var minDisStkQty = parseFloat(minCheckQty)-parseFloat(item.minStkQty);
        var disQty = parseFloat(checkQty)-parseFloat(item.qty);
        var minDisQty = parseFloat(minCheckQty)-parseFloat(item.minQty);

        item.disStkQty =  (Math.floor(disStkQty * 100) / 100)|| 0;
        item.minDisStkQty =  (Math.floor(minDisStkQty * 100) / 100)|| 0;
        item.disQty =  (Math.floor(disQty * 100) / 100)|| 0;
        item.minDisQty =  (Math.floor(minDisQty * 100) / 100)|| 0;
    }


    function filterColumn(field){
        var grid = uglcw.ui.get('#grid');
        var chk=$('#'+field+"_chk").is(':checked');
        if(chk){
            $('#'+field+"_chk").prop("checked",false);
        }else{
            $('#'+field+"_chk").prop("checked",true);
        }
        if(field=='stkQty'){
            if(!chk){
                grid.showColumn('minStkQty');
            }else{
                grid.hideColumn('minStkQty');
            }
        }else if(field=='qty'){
            if(!chk){
                grid.showColumn('minQty');
            }else{
                grid.hideColumn('minQty');
            }
        }
    }

    function saveData(){
        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 1) {
            return uglcw.ui.error('请选择商品');
        }
        uglcw.ui.confirm('是否确定纠正？', function () {
            var stkId = $("#stkId").val();
            var houseId = $("#houseId").val();
            var data = {
                "houseId":houseId,
                "stkId":stkId
            };
            var list = uglcw.ui.get('#grid').bind();
            $(list).each(function (idx, item) {
                $.map(item, function (v, k) {
                    data['list[' + idx + '].' + k] = v;
                })
            });
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkCrewCheck/save',
                type: 'post',
                data: data,
                async: false,
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        setTimeout(function () {
                            uglcw.ui.closeCurrentTab();
                        },2000)
                    } else {
                        uglcw.ui.error('更新失败');
                    }

                }
            })
        });
    }


    function loadData(wareIds){
            var stkId = $("#stkId").val();
            var houseId = $("#houseId").val();
            var params={
                stkId:stkId,
                houseId:houseId,
                wareIds:wareIds
            };
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkHouseWare/listForCorrect',
                type: 'post',
                data: params,
                async: false,
                success: function (response) {
                    uglcw.ui.loaded();
                    var data = uglcw.ui.get('#grid').bind();
                    if (response.state) {
                        response.rows = response.rows || []
                        $.map(response.rows, function (item) {
                            var realQty = parseInt(item.minStkQty/item.hsNum);
                            var minRealQty = item.minStkQty%item.hsNum;
                            item.realQty = realQty;
                            item.minRealQty = Math.floor(minRealQty * 100000) / 100000 ;
                            item.checkQty = item.stkQty;
                            var hit = false;
                            $(data).each(function (j, row) {
                                if (row.wareId == item.wareId) {
                                    hit = true;
                                    return false;
                                }
                            })
                            if (!hit) {
                                uglcw.ui.get('#grid').addRow(item);
                            }
                        });
                    } else {
                        uglcw.ui.error('更新失败');
                    }
                }
            })
    }

</script>
</body>
</html>
