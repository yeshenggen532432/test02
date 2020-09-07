<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>门店用户组设置</title>
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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="groupName" uglcw-role="textbox" placeholder="门店角色名称">
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
						    responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/pos/queryGroupList',
                    		criteria: '.query',
                    	">
                <div data-field="groupName" uglcw-options="width:'auto',tooltip:true">门店角色名称</div>
                <div data-field="isSupper"
                     uglcw-options="width:'auto',template: uglcw.util.template($('#isSupper').html())">超级用户否
                </div>
                <div data-field="remarks" uglcw-options="width:'auto'">备注</div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:update();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>修改
    </a>
    <a role="button" href="javascript:del();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>删除
    </a>
</script>

<script id="isSupper" type="text/x-uglcw-template">
    # if(data.isSupper === 0){ #
    普通用户
    # }else if(data.isSupper === 1){ #
    超级用户
    # } #
</script>

<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <label class="control-label col-xs-6">*门店角色名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="groupName" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="remarks" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6" for="isSupper2">超级用户否</label>
                    <div class="col-xs-16">
                        <input type="checkbox" id="isSupper2" uglcw-model="isSupper" uglcw-role="checkbox"
                               uglcw-options="type:'number'">
                        <label for="isSupper2"></label>
                    </div>
                </div>
            </form>
        </div>
    </div>
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
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })


        uglcw.ui.loaded();
    })


    //-----------------------------------------------------------------------------------------

    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm("确定删除所选记录吗？", function () {
                $.ajax({
                    url: "${base}manager/pos/deletePosGroup",
                    data: {
                        id: selection[0].id,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success("删除成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error("删除失败");
                        }
                    }
                });
            })
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //添加
    function add() {
        edit()
    }

    //修改
    function update() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //添加或修改
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
                    url: '${base}manager/pos/savePosGroup',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp == '1') {
                            uglcw.ui.success('保存成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else {
                            uglcw.ui.error('操作失败');
                        }

                    }
                })
                return false;
            }
        })
    }


</script>
</body>
</html>
