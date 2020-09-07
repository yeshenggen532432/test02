<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>临时客户</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .query .k-widget.k-numerictextbox {
            display: none;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <input type="hidden" uglcw-role="numeric" uglcw-model="isDb" id="isDb" value="0">
                <input type="hidden" uglcw-role="textbox" uglcw-model="database" id="database" value="${datasource}">
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="isDb" placeholder="客户状态">
                        <option value="">全部</option>
                        <option value="0" selected="selected">正常</option>
                        <option value="1">移除</option>
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
                    responsive:['.header',40],
                    id:'id',
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    url: '${base}manager/queryCustomerTmpPage?dataTp=${dataTp}',
                    criteria: '.query',
                    pageable: true,
                    checkbox: true,
                    dblclick: function(row){
                        <%--toUpdatecustomer(row);--%>
                    }
                    ">
                <div data-field="khNm" uglcw-options="width:160">客户名称</div>
                <div data-field="address" uglcw-options="width:160">地址</div>
                <div data-field="memberNm" uglcw-options="width:100">业务员</div>
                <div data-field="branchName" uglcw-options="width:100">部门</div>
                <div data-field="longitude" uglcw-options="width:120">经度</div>
                <div data-field="latitude" uglcw-options="width:120">纬度</div>
                <div data-field="isDb" uglcw-options="width:120,template: uglcw.util.template($('#formatterDb').html())">
                    客户状态
                </div>
                <div data-field="createTime" uglcw-options="width:160">创建日期</div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:updateToNormalCustomer();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-redo"></span>转正式客户
    </a>
</script>

<script type="text/x-kendo-template" id="formatterDb">
    #if (data.isDb==0) {#
    正常
    # }else if(data.isDb=='1'){#
    移除
    # } #
</script>

<%--转为正式客户--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <label class="col-xs-8">确定转为正常客户吗？</label>
                </div>
                <div class="form-group">
                    <label class="col-xs-4">客户名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
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
        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })
        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    });

    /**
     * 转为正式客户
     */
    function updateToNormalCustomer(row) {
        // uglcw.ui.confirm('确定转为正常客户吗？', function () {
        // })
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection) {
            uglcw.ui.toast("请勾选你要操作的行！")
            return
        }
        var row = uglcw.ui.get('#grid').selectedRow()[0];
        if(row.isDb == 1){
            uglcw.ui.toast("该临时客户已转为'正式客户'，不能再操作！")
            return;
        }
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
                console.log("data", data);
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/addCustomerTmpToCustomer',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '-1') {
                            uglcw.ui.error('该客户名称已存在');
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
