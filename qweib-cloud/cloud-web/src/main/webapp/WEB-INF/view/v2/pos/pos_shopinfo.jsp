<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>门店设置</title>
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
                    <input uglcw-model="shopName" uglcw-role="textbox" placeholder="门店名称">
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
                    		url: '${base}manager/pos/queryPosShopInfoPage',
                    		criteria: '.query',
                    	">
                <div data-field="shopNo" uglcw-options="width:100">店号</div>
                <div data-field="shopName" uglcw-options="width:150,tooltip:true">店名</div>
                <div data-field="contact" uglcw-options="width:100">联系人</div>
                <div data-field="tel" uglcw-options="width:150">联系电话</div>
                <div data-field="address" uglcw-options="width:200,tooltip:true">地址</div>
                <div data-field="stkName" uglcw-options="width:120">仓库名称</div>
                <div data-field="canInput" uglcw-options="width:100,template: uglcw.util.template($('#canInput').html())">
                    可充值否
                </div>
                <div data-field="canCost" uglcw-options="width:100,template: uglcw.util.template($('#canCost').html())">
                    可消费否
                </div>
                <div data-field="status" uglcw-options="width:100,template: uglcw.util.template($('#formatterSt3').html())">
                    状态
                </div>
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
<%--启用状态--%>
<script id="formatterSt3" type="text/x-uglcw-template">
    # if(data.status == '2'){ #
    <button onclick="javascript:updateIsTy(#= data.id#,1);" class="k-button k-info">停用</button>
    # }else{ #
    <button onclick="javascript:updateIsTy(#= data.id#,2);" class="k-button k-info">启用</button>
    # } #
</script>
<script id="canInput" type="text/x-uglcw-template">
    # if(data.canInput === 0){ #
    不可充值
    # }else if(data.canInput === 1){ #
    可充值
    # } #
</script>
<script id="canCost" type="text/x-uglcw-template">
    # if(data.canCost === 0){ #
    不可消费
    # }else if(data.canCost === 1){ #
    可消费
    # } #
</script>

<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <%--<input uglcw-role="textbox" uglcw-model="canInput" id="canInput" type="hidden">--%>
                    <%--<input uglcw-role="textbox" uglcw-model="canCost" id="canCost" type="hidden">--%>
                    <label class="control-label col-xs-6">*店号</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="shopNo" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">*店名</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="shopName" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">联系人</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="contact" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">联系电话</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="tel" uglcw-role="textbox" uglcw-validate="mobile">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">地址</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="address" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">仓库</label>
                    <div class="col-xs-11">
                        <tag:select2 name="stkId" id="stkId" tableName="stk_storage"
                                     whereBlock="status=1 or status is null"
                                     headerKey="" headerValue="--选择仓库--"
                                     displayKey="id" displayValue="stk_name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6" for="canInput2">可充值否</label>
                    <div class="col-xs-16">
                        <input type="checkbox" id="canInput2" uglcw-model="canInput" uglcw-role="checkbox"
                               uglcw-options="type:'number'">
                        <label for="canInput2"></label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6" for="canCost2">可消费否</label>
                    <div class="col-xs-16">
                        <input type="checkbox" id="canCost2" uglcw-model="canCost" uglcw-role="checkbox"
                               uglcw-options="type:'number'">
                        <label for="canCost2"></label>
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


        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })


    //-----------------------------------------------------------------------------------------
    //修改启用状态
    function updateIsTy(id,status) {
        $.ajax( {
            url : "manager/pos/updateShopStatus",
            data : "id=" + id+"&status=" + status,
            type : "post",
            success : function(json) {
                if (json.state) {
                    //showMsg("删除成功");
                    uglcw.ui.get('#grid').reload();
                }else{
                    showMsg("修改失败");
                }
            }
        });

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

    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm("确定删除所选记录吗？", function () {
                $.ajax({
                    url: "${base}manager/pos/deletePosShopInfo",
                    data: {
                        id: selection[0].id,
                    },
                    type: 'post',
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
                    url: '${base}manager/pos/savePosShopInfo',
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
