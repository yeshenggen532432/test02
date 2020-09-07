<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="vehNo" uglcw-role="textbox" placeholder="车牌号">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="状态">
                        <option value="1" selected>正常</option>
                        <option value="2">已禁用</option>
                    </select>
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
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/queryVehiclePage',
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="vehNo" uglcw-options="width:'auto'">车牌号</div>
                <div data-field="vehType" uglcw-options="width:'auto'">车型</div>
                <div data-field="driverName" uglcw-options="width: 'auto'">关联司机</div>
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
    <a role="button" href="javascript:updateVehicleState(1);" class="k-button k-button-icontext">
        <span class="k-icon k-i-checkmark"></span>启用</a>
    <a role="button" href="javascript:updateVehicleState(2);" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>禁用</a>
</script>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input type="hidden" uglcw-model="status" uglcw-role="textbox" value="1">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <label class="control-label col-xs-8">车牌号</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="vehNo" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">车型</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="vehType" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">关联司机</label>
                    <div class="col-xs-16">
                        <tag:select2 width="200px" name="driverId" id="driverId" tableName="stk_driver" headerKey="-1"
                                     headerValue="--请选择--"
                                     displayKey="id" displayValue="driver_name" whereBlock=" status is null or status !=2 "/>
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
            uglcw.ui.warning('请先选择');
        }
    }

    function edit(row) {
        uglcw.ui.Modal.open({
            title: row ? '编辑车辆' : '添加车辆',
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
                    url: '${base}manager/saveVehicle',
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
                        } else if (resp === '3') {
                            uglcw.ui.error('该手机号已存在');
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
        if (selection) {
            uglcw.ui.confirm('确定删除所选车辆吗？', function () {
                $.ajax({
                    url: '${base}manager/deleteVehicle',
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

        } else {
            uglcw.ui.warning('请先选择');
        }
    }

    function updateVehicleState(status) {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if(selection){
            $.ajax({
                url: '${base}manager/updateVehicleStatus',
                type: 'post',
                data: {id:selection[0].id , status: status},
                async: false,
                success: function (data) {
                    if (data == '1') {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else if(data == '2'){
                        uglcw.ui.error('已是当前状态不能重复操作');
                    }  else{
                        uglcw.ui.error('操作失败');
                        return;
                    }
                }
            })
        }else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }
</script>
</body>
</html>
