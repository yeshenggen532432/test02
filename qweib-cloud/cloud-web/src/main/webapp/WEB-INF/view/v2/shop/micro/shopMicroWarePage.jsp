<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>分销商品列表</title>
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

        <div class="layui-card">
            <div class="layui-card-body full">
                <div class="form-horizontal query" style="display: none">
                    <div class="form-group">
                        <div class="col-xs-4">
                            <input uglcw-model="mobile" uglcw-role="textbox" placeholder="手机号">
                        </div>
                        <div class="col-xs-4">
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </div>
                    </div>
                </div>
                <div id="grid" uglcw-role="grid"
                     uglcw-options="
                             toolbar: kendo.template($('#toolbar').html()),
                             id:'id',
                             responsive:[35],
                             editable: true,
							checkbox:true,
							autoAppendRow: false,
							pageable: false,
                    		url: '${base}/manager/shopMicroWare/pageList?microId=${microId}',
                    		criteria: '.query',
                    	">
                    <div data-field="wareCode" uglcw-options="width:100">编号</div>
                    <div data-field="wareNm" uglcw-options="width:150">商品名称</div>
                    <div data-field="wareDw" uglcw-options="width:150">单位(大)</div>
                    <div data-field="wareGg" uglcw-options="width:150">规格(大)</div>
                    <div data-field="minUnit" uglcw-options="width:150">单位(小)</div>
                    <div data-field="minWareGg" uglcw-options="width:150">规格(小)</div>

                    <div data-field="options" uglcw-options="width: 120, command:'destroy'">操作</div>
                </div>
            </div>
        </div>
        <%--表格：end--%>
    </div>
    <%--2右边：表格end--%>
</div>
</div>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:openWindow();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加商品
    </a>
    <a role="button" href="javascript:batchRemove();" class="k-button k-button-icontext">
        <span class="k-icon k-i-trash"></span>批量删除
    </a>
    <a role="button" href="javascript:save();" class="k-button k-button-icontext">
        <span class="k-icon k-i-save"></span>确认保存
    </a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    function onTabLeave(promise) {
        if ($('#grid').data('_change')) {
            uglcw.ui.confirm('当前修改未保存，是否保存？', function () {
                save()
            }, function () {
                promise.resolve();
            })
        } else {
            promise.resolve();
        }
    }

    function save() {
        var data = uglcw.ui.get('#grid').value();
        if (!data || data.length == 0) {
            uglcw.ui.error("请选择商品");
            return false;
        }
        uglcw.ui.confirm('是否确定保存?', function () {
            uglcw.ui.loading()
            $.ajax({
                url: '${base}manager/shopMicroWare/saveOrUpdate?microId=${microId}',
                data: JSON.stringify(data),
                type: 'post',
                contentType: 'application/json',
                success: function (resp) {
                    uglcw.ui.loaded();
                    if (resp.state) {
                        $('#grid').removeData('_change');
                        uglcw.ui.success('保存成功！');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(resp.message)
                    }
                }, error: function () {
                    uglcw.ui.error("出现错误")
                }
            })
        })
    }

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

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            if (e.action) {
                $('#grid').data('_change', true);
            }
        });
    })


    //选择商品加入模版或所有商品对应的运费模版
    function openWindow() {
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                url: '${base}manager/shopWareNewType/shopWaretypesExists',
                lazy: false,
                model: 'waretype',
                id: 'id',
                expandable: function (node) {
                    return node.id == 0;
                },
                loadFilter: function (response) {
                    $(response).each(function (index, item) {
                        if (item.text == '根节点') {
                            item.text = '商品分类'
                        }
                    })
                    return response;
                },
            },
            title: "选择商品",
            width: 900,
            id: 'wareId',
            pageable: true,
            url: '${base}manager/shopWare/page?loadGlobalLsRate=1',
            query: function (params) {
                //params.stkId = uglcw.ui.get('#stkId').value()
            },
            persistSelection: false,
            checkbox: true,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
            columns: [
                {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
                {field: 'wareNm', title: '商品名称', width: 250},
                {field: 'wareDw', title: '大单位', width: 120},
                {field: 'minUnit', title: '小单位', width: 120}
            ],
            yes: addDetail
        })
    }

    //增加订单商品明细
    function addDetail(data) {
        if (data) {
            data = $.map(data, function (item) {
                item.wareUnit = item.maxUnitCode;

                item.maxPrice = item.shopBaseMaxLsPrice;
                item.minPrice = item.shopBaseMinLsPrice;
                item.defDw = item.wareDw || item.wareGg;
                item.defPrice = item.maxPrice;
                /*

                if (!(item.wareDw && item.wareGg)) {
                    item.wareUnit = item.minUnitCode;
                    item.defDw = item.minUnit || item.minWareGg;
                    item.defPrice = item.minLsPrice;
                }*/
                //item.id = uglcw.util.uuid();
                item.sort = 1;
                return item.toJSON();
            })
            uglcw.ui.get('#grid').addRow(data);//添加到表单
        }
    }

    //批量删除
    function batchRemove() {
        uglcw.ui.confirm("是否确定批量删除", function () {
            uglcw.ui.get('#grid').removeSelectedRow(true);
        })
    }
</script>


</body>
</html>
