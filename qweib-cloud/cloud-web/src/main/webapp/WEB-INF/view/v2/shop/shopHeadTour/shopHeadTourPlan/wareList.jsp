<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>拼团方案关联商品列表设置</title>
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
                <div id="grid" uglcw-role="grid"
                     uglcw-options="
                             id:'id',
                             responsive:[35],
                            toolbar: kendo.template($('#toolbar').html()),
                            editable: true,
							checkbox:true,
							autoAppendRow: false,
							pageable: false,
                    		url: '${base}/manager/shopHeadTourWare/list?planId=${plan.id}',
                    		criteria: '.query',
                    		loadFilter: {
                    		    data: function(response){
                    		        return response.state ? (response.obj || []) : [];
                    		    }
                    		}
                    	">
                    <div data-field="name" uglcw-options="width:150,schema:{editable: true}">组团名称</div>
                    <div data-field="wareNm" uglcw-options="width:150">商品名称</div>
                    <div data-field="unitName"
                         uglcw-options="width:100,
                             editor: function(container, options){
                             var model = options.model;
                             if(model.status!=0){
                                 $('<span>'+model.unitName+'</span>').appendTo(container);
                                return ;
                             }
                             var input = $('<input name=\'wareUnit\' data-bind=\'value:wareUnit\'>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.ComboBox(input);
                             var dataSource=[];
                             dataSource.push({ text: model.wareDw, value:model.maxUnitCode});
                             if(model.minUnit)
                                dataSource.push({ text: model.minUnit, value:model.minUnitCode});

                             widget.init({
                              dataTextFiled: 'text',
                              dataValueField: 'value',
                              change: function(){
                                    model.set('unitName', this.text());
                                    model.set('wareUnit', this.value());
                                    var salePrice = model.shopBaseMaxLsPrice;
                                    if (this.value() != 'B') {
                                        salePrice = model.shopBaseMinLsPrice;
                                    }
                                    model.set('shopPrice', salePrice);
                                    model.set('price', salePrice);
                              },
                              dataSource:dataSource
                             })
                             }">单位
                    </div>
                    <div data-field="shopPrice"
                         uglcw-options="width:100,
                         template: uglcw.util.template($('#shopPrice_tpl').html())">商城零售价
                    </div>
                    <div data-field="price"
                         uglcw-options="width: 100, schema:{editable: true, type: 'number',validation:{required:true, min:0.1}},
                             editor: function(container, options){
                             var model = options.model;
                             if(model.status!=0){
                                 $('<span>'+model.price+'</span>').appendTo(container);
                                return ;
                             }
                              var input = $('<input name=\'price\' data-bind:\'value:price\'>');
                                input.appendTo(container);
                                var widget = new uglcw.ui.Numeric(input);
                                widget.init({
                                 value: model.price
                                })
                             }">
                        组团价格
                    </div>
                    <div data-field="headPrice"
                         uglcw-options="width: 100, schema:{editable: true, type: 'number',validation:{required:true, min:0.1}},
                             editor: function(container, options){
                             var model = options.model;
                             if(model.status!=0){
                                 $('<span>'+model.headPrice+'</span>').appendTo(container);
                                return ;
                             }
                              var input = $('<input name=\'headPrice\' data-bind:\'value:headPrice\'>');
                                input.appendTo(container);
                                var widget = new uglcw.ui.Numeric(input);
                                widget.init({
                                 value: model.headPrice
                                })
                             }">
                        团长价格
                    </div>
                    <div data-field="count"
                         uglcw-options="width: 80,schema:{editable: true, type: 'number',validation:{min:0.1}},
                            editor: function(container, options){
                             var model = options.model;
                             if(model.status!=0){
                                 $('<span>'+model.count+'</span>').appendTo(container);
                                return ;
                             }
                             var input = $('<input name=\'count\' data-bind:\'value:count\'>');
                                input.appendTo(container);
                                var widget = new uglcw.ui.Numeric(input);
                                widget.init({
                                 value: model.count
                                })
                             }">参团人数
                    </div>
                    <div data-field="limitQty"
                         uglcw-options="width: 80,schema:{editable: true, type: 'number',validation:{min:0.1}},
                            editor: function(container, options){
                             var model = options.model;
                             if(model.status!=0){
                                 $('<span>'+model.limitQty+'</span>').appendTo(container);
                                return ;
                             }
                              var input = $('<input name=\'limitQty\' data-bind:\'value:limitQty\'>');
                                input.appendTo(container);
                                var widget = new uglcw.ui.Numeric(input);
                                widget.init({
                                 value: model.limitQty
                                })
                             }">限购数量
                    </div>
                    <div data-field="orderCd"
                         uglcw-options="width: 60,schema:{editable: true, type: 'number',validation:{min:0.1}},
                            editor: function(container, options){
                             var model = options.model;
                             if(model.status!=0){
                                 $('<span>'+model.orderCd+'</span>').appendTo(container);
                                return ;
                             }
                              var input = $('<input name=\'orderCd\' data-bind:\'value:orderCd\'>');
                                input.appendTo(container);
                                var widget = new uglcw.ui.Numeric(input);
                                widget.init({
                                 value: model.orderCd
                                })
                             }">排序
                    </div>
                    <div data-field="hasCount" uglcw-options="width: 80">团长人数</div>
                    <div data-field="status"
                         uglcw-options="width:60, template: uglcw.util.template($('#status_tpl').html())">
                        状态
                    </div>
                    <%--<div data-field="options" uglcw-options="width: 120, command:'destroy'">操作</div>--%>
                    <div data-field="options"
                         uglcw-options="width:100,template: uglcw.util.template($('#options_tpl').html())">操作
                    </div>
                </div>
            </div>
        </div>
        <%--表格：end--%>
    </div>
    <%--2右边：表格end--%>
</div>
</div>

<script id="shopPrice_tpl" type="text/x-uglcw-template">
    #if(data.status==1){#
    #=(data.wareUnit == 'B')?data.shopBaseMaxLsPrice||'暂无':data.shopBaseMinLsPrice||'暂无'#
    #}else{#
    #=data.shopPrice||'暂无'#
    #}#
</script>

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

<%--启用操作--%>
<script id="status_tpl" type="text/x-uglcw-template">
    #='<span>'#
    #if(data.status != 0){#
        #='<span style="color:red;">'#
    #}#
    #=(data.status == 1)?'开':((data.status == 0)?'关':'已结束')+'</span>'#
</script>

<script id="options_tpl" type="text/x-uglcw-template">
    #if(data.status==0){#
    <button class="k-button k-success" type="button" onclick="deleteRow(this)">删除</button>
    #}#
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    function save() {
        var data = uglcw.ui.get('#grid').value();
        if (!data || data.length == 0) {
            uglcw.ui.error("请选择商品");
            return false;
        }
        for (var i = 0; i < data.length; i++) {
            var item = data[i];
            if (!item.price) {
                uglcw.ui.error((i + 1) + "行,请输入组团价格");
                return false;
            }
            if (!item.count) {
                uglcw.ui.error((i + 1) + "行,请输入参团人数");
                return false;
            }
            for (var j = 0; j < data.length; j++) {
                if (i != j && item.wareId == data[j].wareId && item.wareUnit == data[j].wareUnit) {
                    uglcw.ui.error((i + 1) + "行与" + (j + 1) + '行,同规格商品请修改');
                    return false;
                }
            }
            item.planId =${plan.id};
            /*if (item.startTime)
                item.startTime = uglcw.util.toString(new Date(item.startTime), 'yyyy-MM-dd HH:mm')
            if (item.endTime)
                item.endTime = uglcw.util.toString(new Date(item.endTime), 'yyyy-MM-dd HH:mm')
            if (item.finalTime)
                item.finalTime = uglcw.util.toString(new Date(item.finalTime), 'yyyy-MM-dd HH:mm')*/
        }

        uglcw.ui.confirm('是否确定保存?', function () {
            uglcw.ui.loading()
            $.ajax({
                url: '${base}manager/shopHeadTourWare/saveBatch?planId=' +${plan.id},
                data: JSON.stringify(data),
                type: 'post',
                contentType: 'application/json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.code === 200) {
                        uglcw.ui.confirm('保存成功！是否直接返回', function () {
                            $('#grid').removeData('_change');
                            uglcw.ui.closeCurrentTab();
                        }, function () {
                            uglcw.ui.get('#grid').reload();
                        })
                    } else {
                        uglcw.ui.error(response.message)
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

        // //查询
        // uglcw.ui.get('#search').on('click', function () {
        //     uglcw.ui.get('#grid').reload();
        // })
        //
        // //重置
        // uglcw.ui.get('#reset').on('click', function () {
        //     uglcw.ui.clear('.query');
        //     uglcw.ui.get('#grid').reload();
        // })

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

    //增加商品明细
    function addDetail(data) {
        if (data) {
            data = $.map(data, function (item) {
                item.wareUnit = item.maxUnitCode;

                /*item.maxPrice = item.lsPrice;
                if (item.shopWareLsPrice || item.shopWareSmallLsPrice) {
                    item.maxPrice = item.shopWareLsPrice ? item.shopWareLsPrice : (item.shopWareSmallLsPrice * this.hsNum).toFixed(2);
                }
                item.minPrice = item.minLsPrice;
                if (item.shopWareLsPrice || item.shopWareSmallLsPrice) {
                    item.minPrice = item.shopWareSmallLsPrice ? item.shopWareSmallLsPrice : (item.shopWareLsPrice / item.hsNum).toFixed(2);
                }*/
                item.maxPrice = item.shopBaseMaxLsPrice;
                item.minPrice = item.shopBaseMinLsPrice;

                item.unitName = item.wareDw || item.wareGg;
                item.shopPrice = item.maxPrice;
                item.price = item.maxPrice;
                item.orderCd = 1;
                item.status = 0;
                item.count = '${plan.count}';
                item.limitQty = '${plan.limitQty}';
                item.name = '${plan.name}';
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

    //删除行
    function deleteRow(th) {
        var row = uglcw.ui.get('#grid').k().dataItem($(th).closest('tr'));
        if (row && row.id && row.status) {
            uglcw.ui.error('已开启或结束拼团数据不可删除')
            return false;
        }

        uglcw.ui.get('#grid').k().dataSource.remove(row);
    }
</script>


</body>
</html>
