<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>秒杀商品列表</title>
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
                             responsive:[35],
                            <c:if test="${!isRun}">editable: true,</c:if>
							checkbox:true,
							rowNumber: true,
							autoAppendRow: false,
							pageable: false,
                    		url: '${base}/manager/promotion/shopFlashWare/queryList?flashId=${flashId}&timeId=${timeId}',
                    		criteria: '.query',
                    	">
                <div data-field="wareCode" uglcw-options="width:100">编号</div>
                <div data-field="wareNm" uglcw-options="width:150">商品名称</div>
                <%--<div data-field="defDw" uglcw-options="width:150">单位</div>--%>
                <div data-field="defDw"
                     uglcw-options="width:150,
                             editor: function(container, options){
                             var model = options.model;
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
                                    model.set('defDw', this.text());
                                    model.set('wareUnit', this.value());
                                    var defPrice = model.maxPrice;
                                    if (this.value() != 'B') {
                                        defPrice = model.minPrice;
                                    }
                                    model.set('defPrice', defPrice);
                              },
                              dataSource:dataSource
                             })
                             }">单位
                </div>
                <div data-field="defPrice" uglcw-options="width:100">商城零售价</div>
                <div data-field="flashPrice"
                     uglcw-options="width: 100, schema:{editable: true, type: 'number',validation:{required:true, min:1}}">
                    秒杀价
                </div>
                <div data-field="flashCount"
                     uglcw-options="width: 100,schema:{editable: true, type: 'number',validation:{min:1}}">秒杀总数量
                </div>
               <%-- <div data-field="flashLimit"
                     uglcw-options="width: 100,schema:{editable: true, type: 'number',validation:{min:1}}">每次限购数量
                </div>--%>
                <div data-field="flashAllLimit"
                     uglcw-options="width: 100,schema:{editable: true, type: 'number',validation:{min:1}}">每人总限购数量
                </div>
                <div data-field="sort"
                     uglcw-options="width: 100,schema:{editable: true, type: 'number',validation:{min:1}}">排序
                </div>
                <div data-field="flashSurplusCount"
                     uglcw-options="width:100,schema:{editable: true, type: 'number',validation:{min:1}}">剩余数量
                </div>
                <c:if test="${!isRun}">
                    <div data-field="options" uglcw-options="width: 120, command:'destroy'">操作</div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="toolbar">
    <c:if test="${!isRun}">
        <a role="button" href="javascript:openWindow();" class="k-button k-button-icontext">
            <span class="k-icon k-i-plus-outline"></span>添加商品
        </a>
        <a role="button" href="javascript:batchRemove();" class="k-button k-button-icontext">
            <span class="k-icon k-i-trash"></span>批量删除
        </a>
        <a role="button" href="javascript:save();" class="k-button k-button-icontext">
            <span class="k-icon k-i-save"></span>确认保存
        </a>
    </c:if>
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
        var isRun = ${isRun};
        if (isRun) {
            uglcw.ui.error("进行中的活动不可编辑");
            return false;
        }
        var data = uglcw.ui.get('#grid').value();
        if (!data || data.length == 0) {
            uglcw.ui.error("请选择商品");
            return false;
        }
        for (var i = 0; i < data.length; i++) {
            var item = data[i];
            if (!item.flashPrice) {
                uglcw.ui.error((i + 1) + "行,请输入秒杀价");
                return false;
            }

            if (item.flashLimit && item.flashAllLimit && item.flashAllLimit < item.flashLimit) {
                uglcw.ui.error((i + 1) + "行,每人总限购数量不能小于每次限购数量");
                return false;
            }
            if (item.flashCount && item.flashAllLimit && item.flashAllLimit > item.flashCount) {
                uglcw.ui.error((i + 1) + "行,每人总限购数量不能大于秒杀总数量");
                return false;
            }
            if (item.flashCount && item.flashSurplusCount && item.flashSurplusCount > item.flashCount) {
                uglcw.ui.error((i + 1) + "行,剩余数量不能大于秒杀总数量");
                return false;
            }
            for (var j = 0; j < data.length; j++) {
                if (i != j && item.wareId == data[j].wareId && item.wareUnit == data[j].wareUnit) {
                    uglcw.ui.error((i + 1) + "行与" + (j + 1) + '行,同规格商品请修改');
                    return false;
                }
            }
            item.flashId =${flashId};
            item.flashTimeId =${timeId};
        }

        uglcw.ui.confirm('是否确定保存?', function () {
            uglcw.ui.loading()
            $.ajax({
                url: '${base}manager/promotion/shopFlashWare/saveOrUpdate?flashId=${flashId}&flashTimeId=${timeId}',
                data: JSON.stringify(data),
                type: 'post',
                contentType: 'application/json',
                success: function (resp) {
                    uglcw.ui.loaded();
                    if (resp.state) {
                        $('#grid').removeData('_change');
                        uglcw.io.emit('refreshFlash${flashId}');//发布事件
                        uglcw.ui.confirm('保存成功！是否直接返回', function () {
                            uglcw.ui.closeCurrentTab();
                        }, function () {
                            uglcw.ui.get('#grid').reload();
                        })
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
                /*if (item.shopWareLsPrice || item.shopWareSmallLsPrice) {
                    item.maxPrice = item.shopWareLsPrice ? item.shopWareLsPrice : (item.shopWareSmallLsPrice * this.hsNum).toFixed(2);
                }*/
                item.minPrice = item.shopBaseMinLsPrice;
                /*if (item.shopWareLsPrice || item.shopWareSmallLsPrice) {
                    item.minPrice = item.shopWareSmallLsPrice ? item.shopWareSmallLsPrice : (item.shopWareLsPrice / item.hsNum).toFixed(2);
                }*/
                item.defDw = item.wareDw || item.wareGg;
                item.defPrice = item.maxPrice;
                /*

                if (!(item.wareDw && item.wareGg)) {
                    item.wareUnit = item.minUnitCode;
                    item.defDw = item.minUnit || item.minWareGg;
                    item.defPrice = item.minLsPrice;
                }*/
                //item.id = uglcw.util.uuid();
                item.flashLimit = 1;
                item.flashAllLimit = 1;
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
