<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-i-success {
            color: green;
        }

        .k-i-error {
            color: red;
        }

        .k-grid td {
            padding-top: .5em;
            padding-bottom: .5em;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">

    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-header">
                    公司角色列表
                </div>
                <div class="layui-card-body full" uglcw-role="resizable" uglcw-options="responsive: [75]">
                    <div uglcw-role="grid" id="grid1"
                         uglcw-options="
                        url: '${base}manager/rolepages_company?page=1&rows=20'
                        "
                    >
                        <div data-field="roleNm">角色名称</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="form-horizontal query">
                <input type="hidden" uglcw-role="textbox" uglcw-model="roleId" id="roleId">
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                    toolbar: kendo.template($('#toolbar').html()),
                    responsive:[40],
                    editable: true,
                    navigatable: true,
                    id:'id',
                    url: '${base}manager/rightList',
                    criteria: '.query',
                    pageable: true,
                    ">
                        <div data-field="applyName" uglcw-options="schema:{editable: false}">报表名称</div>
                        <div data-field="amtFlag" uglcw-options="
                        schema:{type:'boolean'},
                        template: '<i class=\'k-icon #= data.amtFlag ? \'k-i-success\' : \'k-i-error\'#\'></i>'
                        ">金额查看
                        </div>
                        <div data-field="priceFlag" uglcw-options="
                        schema:{type:'boolean'},
                        template: '<i class=\'k-icon #= data.priceFlag ? \'k-i-success\' : \'k-i-error\'#\'></i>'
                        ">价格查看
                        </div>
                        <div data-field="qtyFlag" uglcw-options="
                        schema:{type:'boolean'},
                        template: '<i class=\'k-icon #= data.qtyFlag ? \'k-i-success\' : \'k-i-error\'#\'></i>'
                        ">数量查看
                        </div>
                        <div data-field="auditFlag" uglcw-options="
                        schema:{type:'boolean'},
                        template: '<i class=\'k-icon #= data.auditFlag ? \'k-i-success\' : \'k-i-error\'#\'></i>'
                        ">收发货
                        </div>
                        <div data-field="printFlag" uglcw-options="
                        schema:{type:'boolean'},
                        template: '<i class=\'k-icon #= data.printFlag ? \'k-i-success\' : \'k-i-error\'#\'></i>'
                        ">打印
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:grant();" class="k-button k-info k-button-icontext">
        <span class="k-icon k-i-success"></span>授权
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:revoke();">
        <span class="k-icon k-i-error"></span>取消授权</a>
    <a role="button" class="k-button k-button-icontext" href="javascript:submit();">
        <span class="k-icon k-i-save"></span>提交
    </a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#grid1').on('dataBound', function () {
            console.log('dataBound');
            uglcw.ui.get('#roleId').value(uglcw.ui.get('#grid1').bind()[0].idKey);
            setTimeout(function () {
                uglcw.ui.get('#grid1').k().select('tr:eq(0)');
            }, 200);
            uglcw.ui.get('#grid').reload();
        });

        var grid = uglcw.ui.get('#grid1').k();
        $('#grid1 tbody').on('click', 'tr', function (e) {
            var item = grid.dataItem($(this));
            uglcw.ui.get('#roleId').value(item.idKey);
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })


    function grant() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var row = selection[0];
            row.priceFlag = 1;
            row.amtFlag = 1;
            row.qtyFlag = 1;
            row.auditFlag = 1;
            row.printFlag = 1;
            uglcw.ui.get('#grid').commit();
        } else {
            uglcw.ui.error('请选择报表')
        }
    }

    function revoke() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var row = selection[0];
            row.priceFlag = 0;
            row.amtFlag = 0;
            row.qtyFlag = 0;
            row.auditFlag = 0;
            row.printFlag = 0;
            uglcw.ui.get('#grid').commit();
        } else {
            uglcw.ui.error('请选择报表')
        }
    }

    function submit() {
        uglcw.ui.confirm('确定提交吗？', function () {
            uglcw.ui.loading();
            var roleId = uglcw.ui.get('#roleId').value();
            var rows = uglcw.ui.get('#grid').bind();
            var data = $.map(rows, function (row) {
                return {
                    roleId: roleId,
                    menuId: row.menuId,
                    priceFlag: uglcw.util.toInt(row.priceFlag),
                    amtFlag: uglcw.util.toInt(row.priceFlag),
                    qtyFlag: uglcw.util.toInt(row.priceFlag),
                    auditFlag: uglcw.util.toInt(row.priceFlag),
                    printFlag: uglcw.util.toInt(row.priceFlag),
                }
            })
            $.ajax({
                url: '${base}manager/saveStkRight',
                type: 'post',
                data: {
                    roleId: roleId,
                    rightStr: JSON.stringify(data)
                },
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('提交成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('提交失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function remove() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm('确定删除所选司机吗？', function () {
                $.ajax({
                    url: '${base}manager/deleteDriver',
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
        uglcw.ui.confirm('确定' + type + '该供司机吗？', function () {
            $.ajax({
                url: '${base}manager/updateDriverStatus',
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
</script>
</body>
</html>
