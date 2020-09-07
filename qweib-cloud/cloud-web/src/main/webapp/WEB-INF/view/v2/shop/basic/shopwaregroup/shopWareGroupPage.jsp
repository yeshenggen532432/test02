<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品分组</title>
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
        <%--2右边：表格start--%>
        <div class="layui-col-md12">
            <%--表格：头部start--%>
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal query">
                        <li>
                            <input uglcw-model="name" uglcw-role="textbox" placeholder="分组名称">
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <%--表格：头部end--%>

            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
						    responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							editable: true,
							pageable: true,
							autoMove: false,
							autoAppendRow: false,
                    		url: '${base}manager/shopWareGroup/page',
                    		criteria: '.query',
                    	">
                        <div data-field="name" uglcw-options="width:100,align:'center'">分组名称</div>
                        <%--<div data-field="sort" uglcw-options="width:100,align:'center'">排序</div>--%>
                        <div data-field="sort"
                             uglcw-options="width:80,
                             editor: function(container, options){
                             var model = options.model;
                             var input = $('<input name=\'sort\' data-bind=\'value:sort\'>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.Numeric(input);
                             widget.init({
                              value: model.sort,
                              change: function(){
                                changeSort(this.value(),model.id,model);
                              }
                             })
                             }"
                        >排序
                        </div>
                        <%--<div data-field="status" uglcw-options="width:100,align:'center',template: uglcw.util.template($('#status').html())">状态</div>--%>
                        <div data-field="qyOper"
                             uglcw-options="width:100,align:'center', template: uglcw.util.template($('#qyOper').html())">
                            操作
                        </div>
                        <div data-field="oper"
                             uglcw-options="width:100,align:'center', template: uglcw.util.template($('#oper').html())">操作
                        </div>
                        <div data-field="remark" uglcw-options="width:300,">备注</div>
                    </div>
                </div>
            </div>
            <%--表格：end--%>
        </div>
        <%--2右边：表格end--%>
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
<%--&lt;%&ndash;启用状态&ndash;%&gt;--%>
<%--<script id="status" type="text/x-uglcw-template">--%>
<%--<span>#= data.status == '1' ? '已启用' : '未启用' #</span>--%>
<%--</script>--%>
<%--启用操作--%>
<script id="qyOper" type="text/x-uglcw-template">
    # if(data.status=='0'){ #
    <button onclick="javascript:updateStatus(#= data.id#,1);" class="k-button k-info">不启用</button>
    # }else{ #
    <button onclick="javascript:updateStatus(#= data.id#,0);" class="k-button k-info">启用</button>
    # } #
</script>
<%--操作：商品信息--%>
<script id="oper" type="text/x-uglcw-template">
    <button onclick="javascript:showWareGroups(#= data.id#,'#=data.name#');" class="k-button k-info">商品列表</button>
</script>
<%--添加分组或修改分组--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                <div class="form-group">
                    <label class="control-label col-xs-6">分组名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="name" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">排序</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="sort" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-16">
                        <textarea uglcw-model="remark" uglcw-role="textbox"></textarea>
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
    //修改启用状态
    function updateStatus(id, status) {
        var str = status ? '启用' : '不启用';
        uglcw.ui.confirm("是否确定" + str + "操作?", function () {
            $.ajax({
                url: '${base}manager/shopWareGroup/updateStatus',
                data: {
                    id: id,
                    status: status
                },
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response == "1") {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                        uglcw.io.emit('listen_wareGroupChange');//使用监听自动刷新商品目录中商品分组
                    } else {
                        uglcw.ui.error("操作失败");
                    }
                }
            })
        })
    }

    //打开分组对应的商品列表
    function showWareGroups(id, name) {
        uglcw.ui.openTab(name + '_商品列表', '${base}manager/shopWare/toUpPage?_sticky=v2&groupIds=' + id);
    }

    //添加
    function add() {
        edit()
    }

    //修改
    function update() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            if (selection[0].name == '热销商品' || selection[0].name == '常售商品') {
                uglcw.ui.toast("热销商品、常售商品为系统默认，不允许操作!")
                return;
            }
            edit(selection[0]);
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            if (selection[0].name == '热销商品' || selection[0].name == '常售商品') {
                uglcw.ui.toast("热销商品、常售商品为系统默认，不允许操作!")
                return;
            }
            uglcw.ui.confirm("确认删除该分组吗？", function () {
                $.ajax({
                    url: "${base}manager/shopWareGroup/delete",
                    data: {
                        id: selection[0].id,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success("操作成功");
                            uglcw.ui.get('#grid').reload();
                            uglcw.io.emit('listen_wareGroupChange');//使用监听自动刷新商品目录中商品分组
                        } else {
                            uglcw.ui.error(response.message);
                        }
                    }
                });
            })
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //添加分组或修改分组
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
                    url: '${base}manager/shopWareGroup/editGroup',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        uglcw.io.emit('listen_wareGroupChange');//使用监听自动刷新商品目录中商品分组
                        if (resp === '1') {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '2') {
                            uglcw.ui.success('修改成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '3') {
                            uglcw.ui.error('该分组名称已存在');
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })
    }

    //列表编辑框数据修改回调方法
    function changeSort(value, id, model) {
        if (value && isNaN(value)) {
            uglcw.ui.error("请输入正整数");
            return;
        }
        $.ajax({
            url: "manager/shopWareGroup/updateBase",
            type: "post",
            data: "id=" + id + "&sort=" + value,
            success: function (data) {
                if (data.state) {
                    uglcw.ui.success("操作成功");
                    model.set('sort', value);
                    model.set('dirty', false)
                } else {
                    uglcw.ui.error(data.msg);
                }
            }
        });
    }

</script>
</body>
</html>
