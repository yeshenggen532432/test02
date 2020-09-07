<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="供应商名称">
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
                 uglcw-options="
                    checkbox: true,
                    responsive: ['.header', 40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/providerPage',
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="proNo" uglcw-options="width:100">供应商编码</div>
                <div data-field="proName" uglcw-options="width:180">供应商名称</div>
                <div data-field="contact" uglcw-options="width:160">联系人</div>
                <div data-field="tel" uglcw-options="width:160">联系电话</div>
                <div data-field="mobile" uglcw-options="width:160">手机</div>
                <div data-field="uscCode" uglcw-options="width:160, tooltip: true">社会信用统一代码</div>
                <div data-field="address" uglcw-options="width:200, tooltip: true">地址</div>
                <div data-field="remarks" uglcw-options="width:120, tooltip: true">备注</div>
                <div data-field="remarks"
                     uglcw-options="width:120, template: uglcw.util.template($('#disable-template').html())">是否禁用
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
    <a role="button" class="k-button k-button-icontext" href="javascript:download();">
        <span class="k-icon k-i-download"></span>下载模板
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:showUpload();">
        <span class="k-icon k-i-upload"></span>导入供应商
    </a>
</script>

<script type="text/x-uglcw-template" id="disable-template">
    # if(data.status =='2'){ #
    <button class="k-button k-error" onclick="disable(#= data.id#, 1)"><i class="k-icon k-i-cancel"></i>已禁用</button>
    # }else { #
    <button class="k-button k-success" onclick="disable(#= data.id#, 2)"><i class="k-icon k-i-success"></i>正常</button>
    # } #
</script>

<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <label class="control-label col-xs-8">供应商编码</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="proNo" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">供应商名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="proName" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">联系人</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="contact" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">联系电话</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="tel" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">手机</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="mobile" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">社会信用统一代码</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="uscCode" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">地址</label>
                    <div class="col-xs-16">
                        <input uglcw-model="address" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-16">
                        <textarea uglcw-model="remarks" uglcw-role="textbox"></textarea>
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
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        });
        uglcw.ui.loaded();
    });

    function add() {
        edit();
    }

    function toEdit() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的数据');
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
                    url: '${base}manager/saveprovider',
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
                        } else if (resp === '-2') {
                            uglcw.ui.error('名称已存在');
                        }else if (resp === '-3') {
                            uglcw.ui.error('编码已存在');
                        }  else {
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
        if (selection) {
            uglcw.ui.confirm('确定删除所选供应商吗？', function () {
                $.ajax({
                    url: '${base}manager/deleteprovider',
                    type: 'post',
                    data: {
                        ids: $.map(selection, function (row) {
                            return row.id
                        }).join(',')
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

    function disable(id, state) {
        var type = state == 1 ? '启用' : '禁用';
        uglcw.ui.confirm('确定' + type + '该供应商吗？', function () {
            $.ajax({
                url: '${base}manager/updateProviderIsUse',
                type: 'post',
                data: {id: id, status: state},
                success: function (response) {
                    if (response === '1') {
                        uglcw.ui.success(type + '成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(type + '失败');
                    }
                }
            })
        })
    }

    function download() {
        uglcw.ui.confirm('是否下载供应商模板？', function () {
            window.location.href = '${base}manager/toProvierModel'
        })
    }

    function showUpload() {
        uglcw.ui.Modal.showUpload({
            url: '${base}manager/toUpProviderExcel',
            field: 'upFile',
            error: function () {
                console.log('error', arguments)
            },
            complete: function () {
                console.log('complete', arguments);
            },
            success: function (e) {
                if (e.response != '1') {
                    uglcw.ui.error(e.response);
                } else {
                    uglcw.ui.success('导入成功');
                    uglcw.ui.get('#grid').reload();
                }
            }
        })
    }

</script>
</body>
</html>
