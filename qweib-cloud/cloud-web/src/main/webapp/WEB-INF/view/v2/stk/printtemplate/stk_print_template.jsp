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
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive: [40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: 'manager/stkPrintTemplate/toPage?fdType=${fdType}',
                    criteria: '.query',
                    pageable: true,
                    rowNumber: true,
                    dblclick:function(row){
                        edit(row);
                    }
                    ">
                <div data-field="fdName" uglcw-options="
                        width:'auto'
                        ">模板名称
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

<script type="text/x-uglcw-template" id="disable-template">
    <button class="k-button k-error"><i class="k-icon k-i-cancel"></i>禁用</button>
</script>

<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <input uglcw-role="textbox" value="${fdType}" uglcw-model="fdType" type="hidden">
                    <label class="control-label col-xs-6">模板名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="fdName" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>

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
            uglcw.ui.warning('请选择要修改的模板');
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
                    url: '${base}manager/stkPrintTemplate/update',
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
            if (selection.fdSubName === '发货单') {
                return uglcw.ui.warning('无法删除默认模板！');
            }
            uglcw.ui.confirm('确定删除所选模板吗？', function () {
                $.ajax({
                    url: '${base}manager/stkPrintTemplate/deleteById',
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

</script>
</body>
</html>
