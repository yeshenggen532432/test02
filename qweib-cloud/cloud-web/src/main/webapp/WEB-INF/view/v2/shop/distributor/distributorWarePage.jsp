<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>分销商品设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
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
                 uglcw-options="editable: true,
						    responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							pageable: true,
							checkbox:true,
                    		url: '${base}/manager/shopDistributorWare/pageList',
                    		criteria: '.form-horizontal',
                    	">
                <div data-field="wareNm" uglcw-options="width:200">商品名称</div>
                <div data-field="shopBaseMaxLsPrice" uglcw-options="width:100">零售价(大)</div>
                <div data-field="shopBaseMinLsPrice" uglcw-options="width:100">零售价(小)</div>
                <div data-field="putOn"
                     uglcw-options="width:100, template: uglcw.util.template($('#putOn').html())">上架状态
                </div>
                <%--<div data-field="firstAgent"
                     uglcw-options="width: 100,schema:{editable: true, type: 'number',validation:{min:0.01,max:99.99}}">
                    一级分销金额
                </div>--%>
                <div data-field="firstScale"
                     uglcw-options="width: 120,schema:{editable: true, type: 'number',validation:{min:0.01,max:99.99}}">
                    一级分销比例(%)
                </div>
                <%--<div data-field="secondAgent"
                     uglcw-options="width: 100,schema:{editable: false, type: 'number',validation:{min:0.01,max:99.99}}">
                    二级分销金额
                </div>--%>
                <div data-field="secondScale"
                     uglcw-options="width: 120,schema:{editable: true, type: 'number',validation:{min:0.01,max:99.99}}">
                    二级分销比例(%)
                </div>
                <%--<div data-field="thirdAgent"
                     uglcw-options="width: 100,schema:{editable: false, type: 'number',validation:{min:0.01,max:99.99}}">
                    三级分销金额
                </div>--%>
                <div data-field="thirdScale"
                     uglcw-options="width: 120,schema:{editable: true, type: 'number',validation:{min:0.01,max:99.99}}">
                    三级分销比例(%)
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:openWindow();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:todel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>移除
    </a>
    <span style="color: red">注:佣金比例为空时使用系统设置的提成比例计算佣金,为0时不计算佣金</span>
</script>
<script id="putOn" type="text/x-uglcw-template">
    <span>#= data.putOn == '1' ? '已上架' : '未上架' #</span>
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
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange') {
                var item = e.items[0];
                var field = e.field;
                var value = item[field];
                updateWare(field, value, item);
            }
        });
        uglcw.ui.loaded();
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
            url: 'manager/shopDistributorWare/shopSelectWareData?putOn=1',
            query: function (params) {
                //params.stkId = uglcw.ui.get('#stkId').value()
            },
            persistSelection: false,
            //btns: ["加入同城商品库", "取消"],
            checkbox: true,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
            columns: [
                {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
                {field: 'wareNm', title: '商品名称', width: 250},
                {field: 'wareDw', title: '大单位', width: 120},
                {field: 'minUnit', title: '小单位', width: 120}
            ],
            yes: addWare
        })
    }


    //增加分销商品
    function addWare(data) {
        if (!data || data.length == 0) {
            uglcw.ui.toast("请勾选您要操作的行！")
            return;
        }
        var ids = "";
        $(data).each(function (i, item) {
            if (ids != "") {
                ids += "," + item.wareId;
            } else {
                ids = item.wareId;
            }
        })
        //uglcw.ui.confirm("是否确认加入",function(){
        uglcw.ui.loading();
        $.ajax({
            url: "${base}/manager/shopDistributorWare/add",
            data: {"wareIds": ids},
            type: "post",
            success: function (data) {
                uglcw.ui.loaded();
                if (data.state) {
                    uglcw.ui.success('加入成功');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error('加入失败！');
                }
                return false;
            }
        });
        //});
    }

    //删除
    function todel() {
        var ids = "";
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            $(selection).each(function (idx, item) {
                if (ids != "") {
                    ids += "," + item.wareId;
                } else {
                    ids = item.wareId;
                }
            })
        } else {
            uglcw.ui.toast("请勾选你要操作的行！");
            return false;
        }
        uglcw.ui.confirm("是否要移出选中商品吗?", function () {
            $.ajax({
                url: "manager/shopDistributorWare/del",
                data: "wareIds=" + ids,
                type: "post",
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.toast("移除成功");
                        //uglcw.ui.get('#grid').k().dataSource.read();
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error("移除失败");
                    }
                }
            });
        });
    }

    //更新
    function updateWare(field, value, item) {
        $.ajax({
            url: "${base}/manager/shopDistributorWare/updateField",
            data: {"id": item.id, "field": field, "value": value},
            type: "post",
            success: function (data) {
                uglcw.ui.loaded();
                if (data.state) {
                    uglcw.ui.success('修改成功');
                } else {
                    uglcw.ui.error('修改失败！');
                }
                return false;
            }
        });
        //});
    }
</script>
</body>
</html>
