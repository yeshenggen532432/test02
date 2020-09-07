<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>门店操作员设置</title>
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
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-header">部门分组</div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">
                    <div uglcw-role="tree" id="wareGroupTree"
                         uglcw-options="
							url: 'manager/departs?dataTp=1',
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#branchId').value(node.id);
								uglcw.ui.get('#grid').reload();
                       		}
                    	">
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <%--表格：头部start--%>
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="depart" id="depart" uglcw-role="textbox" value="${branchId}">
                            <input type="hidden" uglcw-model="branchId" id="branchId" uglcw-role="textbox"
                                   value="${branchId}">

                            <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="姓名">
                        </li>
                        <li>
                            <input uglcw-model="memberMobile" uglcw-role="textbox" placeholder="手机号码">
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
							pageable:true,
                    		url: '${base}manager/pos/queryShopEmpPage?memberUse=1',
                    		criteria: '.form-horizontal',
                    	">
                        <div data-field="memberNm" uglcw-options="width:150">姓名</div>
                        <div data-field="memberMobile" uglcw-options="width:150">手机号码</div>
                        <div data-field="shopName" uglcw-options="width:150,tooltip:true">店名</div>
                        <div data-field="groupName" uglcw-options="width:150">角色名称</div>
                        <%--<div data-field="isPay" uglcw-options="width:100,align:'center',template: uglcw.util.template($('#isPay').html())">付款状态</div>--%>
                    </div>
                </div>
            </div>
            <%--表格：end--%>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:openDialogRule();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>分配门店
    </a>
</script>

<%--分配门店--%>
<script type="text/x-uglcw-template" id="form-rule">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-8">选择门店</label>
                    <div class="col-xs-12">
                        <tag:select2 name="shopselect" id="shopselect" tableName="pos_shopinfo" whereBlock="status=1"
                                     headerKey="0" headerValue="--不分配--" displayKey="id" displayValue="shop_name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">选择角色</label>
                    <div class="col-xs-12">
                        <tag:select2 name="groupselect" id="groupselect" tableName="pos_group" whereBlock=""
                                     headerKey="0" headerValue="--不分配--" displayKey="id" displayValue="group_name"/>
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
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })

    //===================================================================
    function getIds() {
        var ids = '';
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            for (var i = 0; i < selection.length; i++) {
                if (ids != '') {
                    ids = ids + ",";
                }
                ids += selection[i].memberId;
            }
        }
        return ids;
    }

    //对话框：会员等级
    function openDialogRule() {
        var ids = getIds();
        if (ids == '') {
            uglcw.ui.toast("请勾选你要操作的行！")
            return;
        }

        uglcw.ui.Modal.open({
            content: $('#form-rule').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                // if (row) {
                //     uglcw.ui.bind($(container), row);
                // }
            },
            yes: function (container) {
                // var valid = uglcw.ui.get($(container).find('#form-xxzf')).validate();
                // if (!valid) {
                //     return false;
                // }var ids = "";
                var shopId = uglcw.ui.get("#shopselect").value();
                var groupId = uglcw.ui.get("#groupselect").value();
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/pos/savePosShopEmp',
                    type: 'post',
                    data: {ids: ids, shopId: shopId, groupId: groupId},
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp.state) {
                            uglcw.ui.success('操作成功');
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
