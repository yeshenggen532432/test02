<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>优惠券类型设置</title>
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
            <%--&lt;%&ndash;表格：头部start&ndash;%&gt;--%>
            <%--<div class="layui-card header">--%>
            <%--<div class="layui-card-body">--%>
            <%--<div class="form-horizontal query">--%>
            <%--<div class="form-group" style="margin-bottom: 10px;">--%>
            <%--<div class="col-xs-4">--%>
            <%--<input uglcw-model="shopName" uglcw-role="textbox" placeholder="门店名称">--%>
            <%--</div>--%>
            <%--<div class="col-xs-4">--%>
            <%--<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>--%>
            <%--<button id="reset" class="k-button" uglcw-role="button">重置</button>--%>
            <%--</div>--%>
            <%--</div>--%>
            <%--</div>--%>
            <%--</div>--%>
            <%--</div>--%>
            <%--表格：头部end--%>

            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                            responsive:[40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/pos/queryTicketType',
                    		criteria: '.query',
                    	">
                        <div data-field="ticketName" uglcw-options="width:'auto'">类型名称</div>
                        <div data-field="ticketNo" uglcw-options="width:'auto'">前缀编号</div>
                        <div data-field="seqLen" uglcw-options="width:'auto'">流水号长度</div>
                        <div data-field="amt" uglcw-options="width:'auto'">面值</div>
                        <div data-field="remarks" uglcw-options="width:'auto'">备注</div>
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


<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <input uglcw-role="textbox" uglcw-model="status" type="hidden">
                    <%--<input uglcw-role="textbox" uglcw-model="wareType" type="hidden">--%>
                    <label class="control-label col-xs-8">*类型名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="ticketName" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">前缀编号</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="ticketNo" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">流水号长度</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="seqLen" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">面值</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="amt" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="remarks" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">限制消费商品类别</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-role="dropdowntree" uglcw-model="wareType"
                               uglcw-options="url: '${base}manager/syswaretypes' "
                        >
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

        // //查询
        // uglcw.ui.get('#search').on('click', function () {
        // 	uglcw.ui.get('#grid').reload();
        // })
        //
        // //重置
        // uglcw.ui.get('#reset').on('click', function () {
        // 	uglcw.ui.clear('.query');
        // 	uglcw.ui.get('#grid').reload();
        // })

        uglcw.ui.loaded();
    })
    //-----------------------------------------------------------------------------------------

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

    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm("您确认想要删除记录吗？", function () {
                $.ajax({
                    url: "${base}manager/pos/deletePosTicketType",
                    data: {
                        id: selection[0].id,
                    },
                    type: 'post',
                    success: function (response) {
                        if (response == 1) {
                            uglcw.ui.success("删除成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error("删除失败");
                        }
                    }
                });
            })
        } else {
            uglcw.ui.warning("请选择要删除的数据！")
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
                    url: '${base}manager/pos/saveTicketType',
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
                        // if (resp === '1') {
                        // 	uglcw.ui.success('添加成功');
                        // 	uglcw.ui.get('#grid').reload();
                        // 	uglcw.ui.Modal.close();
                        // } else if (resp === '2') {
                        // 	uglcw.ui.success('修改成功');
                        // 	uglcw.ui.get('#grid').reload();
                        // 	uglcw.ui.Modal.close();
                        // } else if (resp === '3') {
                        // 	uglcw.ui.error('会员等级名称已存在');
                        // } else {
                        // 	uglcw.ui.error('操作失败');
                        // }
                    }
                })
                return false;
            }
        })
    }


</script>
</body>
</html>
