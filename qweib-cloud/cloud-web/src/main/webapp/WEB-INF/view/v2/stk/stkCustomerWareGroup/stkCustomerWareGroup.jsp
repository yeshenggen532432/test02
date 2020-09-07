<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>打印模板</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive: [40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/stkCustomerWareGroup/toWareGroupPage?customerId=${param.cstId}',
                    criteria: '.query',
                    pageable: true,
                    dblclick:function(row){
                        edit(row);
                    }
                    ">
                <div data-field="name" uglcw-options="
                        width:'auto'
                        ">名称
                </div>
                <div data-field="asn" uglcw-options="
                        width:'auto'
                        ">条码
                </div>
                <div data-field="_oper" uglcw-options="
                        width:'auto',
                        template: uglcw.util.template($('#opt-template').html())
                        ">操作
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:toEdit();">
        <span class="k-icon k-i-edit"></span>修改</a>
    <a role="button" class="k-button k-button-icontext" href="javascript:remove();">
        <span class="k-icon k-i-delete"></span>删除
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:refresh();">
        <span class="k-icon k-i-refresh"></span>刷新
    </a>
</script>

<script type="text/x-uglcw-template" id="opt-template">
    <button class="k-button" onclick="showWareItems(#= data.id#)"><i class="k-icon k-i-eye"></i>查看商品</button>
    <button class="k-button" onclick="addWare(#= data.id#)"><i class="k-icon k-i-add"></i>添加商品</button>
</script>

<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <label class="control-label col-xs-6">名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="name" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">条码</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="asn" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>

<script type="text/x-uglcw-template" id="ware-items-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="item-query">
                <input type="hidden" uglcw-model="groupId" uglcw-role="textbox">
                <input type="hidden" uglcw-model="customerId" uglcw-role="textbox" value="${param.cstId}">
            </div>
            <div uglcw-role="grid" id="item-grid" uglcw-options="
            url: '${base}manager/stkCustomerWareGroup/items',
            criteria: '.item-query',
            autoBind: false,
            loadFilter:{
                data:function(response){
                    return response.data || [];
                }
            },
            rowNumber: true,
            pageable: false
        ">
                <div data-field="wareNm" uglcw-options="width: 'auto'">商品名称</div>
                <div data-field="op"
                     uglcw-options="width: 'auto', template: '<button class=\'k-button\' onclick=\'removeItem(#= data.id#)\'>删除</button>'">
                    操作
                </div>
            </div>
        </div>
    </div>
</script>
<tag:product-in-selector-template query="onQueryProduct"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    })

    function refresh(){
        uglcw.ui.get('#grid').reload();
    }

    function add() {
        edit();
    }

    function toEdit() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的分组');
        }
    }

    function edit(row) {
        uglcw.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                if (row) {
                    uglcw.ui.bind($(container), row);
                }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/stkCustomerWareGroup/updateWareGroup?customerId=${param.cstId}',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                        } else if (resp === '2') {
                            uglcw.ui.success('修改成功');
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error('操作失败');
                            return false;
                        }
                    }
                })
            }
        })
    }

    function remove() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection && selection.length > 0) {
            selection = selection[0];
            uglcw.ui.confirm('是否要删除选中的分组名称？', function () {
                $.ajax({
                    url: '${base}manager/stkCustomerWareGroup/deleteWareGroupById',
                    type: 'post',
                    data: {
                        id: selection.id
                    },
                    success: function (response) {
                        if (response === '1') {
                            uglcw.ui.success('删除成功');
                            uglcw.ui.get('#grid').reload();
                        } else if (response === '-1') {
                            uglcw.ui.error('删除失败');
                        }
                    }
                })
            })

        }
    }


    function showWareItems(id) {
        uglcw.ui.Modal.open({
            title: '查看商品',
            content: $('#ware-items-template').html(),
            width: 350,
            success: function (c) {
                uglcw.ui.init(c);
                uglcw.ui.bind(c, {groupId:id});
                uglcw.ui.get('#item-grid').k().setOptions({
                    autoBind: true
                })
            }
        })
    }

    function removeItem(id) {
        uglcw.ui.confirm('确定删除该商品吗？', function () {
            $.ajax({
                url: '${base}manager/stkCustomerWareGroup/deleteWareItemsById',
                type: 'post',
                data: {id: id},
                success: function (response) {
                    if (response && response === '1') {
                        uglcw.ui.toast('删除成功');
                        uglcw.ui.get('#item-grid').reload();
                    } else {
                        uglcw.ui.error('删除失败');
                    }
                }
            })
        })
    }

    var groupId;

    function addWare(id) {
        groupId = id;

        <tag:product-out-selector-script fullscreen="true" callback="onProductSelect"/>
        <%--<tag:product-selector query="onProductQuery"  callback="onProductSelect"/>--%>
    }

    function onProductQuery(query) {
        query = query || {};
        query.stkId = 0;
        return query;
    }

    function onQueryProduct(param) {
        param.stkId = 0;
        return param;
    }


    function onProductSelect(products) {
        if (products && products.length > 0) {
            var wareIds = $.map(products, function (product) {
                return product.wareId;
            });
            uglcw.ui.confirm('是否确定保存选中的商品？', function () {
                $.ajax({
                    url: '${base}manager/stkCustomerWareGroup/addBatchWareItems',
                    type: 'post',
                    data: {
                        wareIds: wareIds.join(','),
                        customerId: '${param.cstId}',
                        groupId: groupId,
                    },
                    success: function (response) {
                        if (response == '1') {
                            uglcw.ui.success('保存成功');
                        } else {
                            uglcw.ui.error("保存失败");
                        }
                    }
                })
            })
        }
    }

</script>
</body>
</html>
