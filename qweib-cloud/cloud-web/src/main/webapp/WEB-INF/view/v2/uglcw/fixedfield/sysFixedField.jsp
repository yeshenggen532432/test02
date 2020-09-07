<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>固定费用设置</title>
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
            <div class="layui-card header">
                <div class="layui-card-body">
                    <div class="form-horizontal query">
                        <div class="form-group" style="margin-bottom: 0px;">
                            <div class="col-xs-24">
                                <ul class="uglcw-query query">
                                    <li>
                                        <select uglcw-model="status" uglcw-role="combobox" placeholder="科目状态">
                                            <option value="1" selected>启用</option>
                                            <option value="0">禁用</option>
                                        </select>
                                    </li>
                                    <li>
                                        <button class="k-info search" uglcw-role="button">搜索</button>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
						    responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							 url: '${base}manager/fixedField/toFixedFieldPage',
							rowNumber: true,
							criteria: '.query',

                    	">
                        <div data-field="name" uglcw-options="width:260">名称</div>
                        <div data-field="fdWay" uglcw-options="width:260,template: uglcw.util.template($('#fdWay').html())">
                            核算方式
                        </div>

                        <div data-field="costTypeName" uglcw-options="width:200">
                            默认总账科目
                        </div>
                        <div data-field="costItemName" uglcw-options="width:200">
                            默认科目明细
                        </div>

                        <div data-field="mergeToRec"
                             uglcw-options="width:150, template: uglcw.util.template($('#formatterMergeToRec').html())">是否合并到收付款
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-file-add"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:update();">
        <span class="k-icon k-i-edit"></span>修改</a>
    <a role="button" href="javascript:updateStatus(1);" class="k-button k-button-icontext">
        <span class="k-icon k-i-checkmark"></span>启用</a>
    <a role="button" href="javascript:updateStatus(0);" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>禁用</a>
</script>

<script id="fdWay" type="text/x-uglcw-template">
    # if(data.fdWay == '00'){ #
    金额核算
    # }else if(data.fdWay == '01'){ #
    数量核算
    # }#
</script>

<script type="text/x-kendo-template" id="formatterMergeToRec">
    #if (data.mergeToRec == 1) {#
    是
    #} else {#
    否
    #}#
</script>

<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <input uglcw-role="textbox" uglcw-model="status" value="1" type="hidden">
                    <label class="control-label col-xs-7">*费用名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="name" uglcw-role="textbox" uglcw-validate="required"
                               placeholder="请输入费用名称">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-7">核算方式</label>
                    <div class="col-xs-16">
                        <select uglcw-model="fdWay" uglcw-role="combobox" style="width: 200px;">
                            <option value="00">金额核算</option>
                            <option value="01">数量核算</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-xs-7">默认总账科目</label>
                    <div class="col-xs-16">
                        <select uglcw-role="combobox" id="costTypeId" uglcw-model="costTypeId"  style="width:140px !important;"
                                uglcw-options="
                                  url: '${base}manager/queryUseCostTypeList',
                                  loadFilter:{
                                    data: function(response){
                                    var itemId = '';
                                    $(response.rows).each(function (i, row) {
                                           if(row.typeName=='经营费用'){
                                                itemId = row.id;
                                           }
                                       });
                                       if(uglcw.ui.get('#costTypeId').value()==''){
                                       uglcw.ui.get('#costTypeId').value(itemId);
                                       }
                                       var costItemId =  uglcw.ui.get('#costItemId').value();
                                      loadItemList(costItemId);
                                    return response.rows ||[];
                                    }
                                  },
                                  change:function(){
                                    loadItemList();
                                  },
                                  dataTextField: 'typeName',
                                  dataValueField: 'id'
                                "
                        >
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-xs-7">科目明细</label>
                    <div class="col-xs-16">
                        <input uglcw-role="combobox" id="costItemId" placeholder="科目明细" uglcw-model="costItemId"
                               style="width:140px !important;"
                               uglcw-options="dataTextField: 'itemName',
						dataValueField: 'id'"
                        >
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-xs-7">是否合并到收付款</label>
                    <div class="col-xs-4">
                        <ul uglcw-role="radio" uglcw-model="mergeToRec"
                            uglcw-value="1"
                            uglcw-options='layout:"horizontal",
                                                             dataSource:[{"text":"是","value":"1"},{"text":"否","value":"0"}]
                                                 '></ul>
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
        uglcw.ui.get('.search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });
        uglcw.ui.loaded();
    })

    //-----------------------------------------------------------------------------------------
    //删除
    function del(id) {
        //var selection = uglcw.ui.get('#grid').selectedRow();
        //if (selection) {
        uglcw.ui.confirm("是否要删除选中的费用名称?", function () {
            $.ajax({
                url: "${base}manager/fixedField/deleteById",
                data: {
                    id: id,
                },
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response == "1") {
                        uglcw.ui.success("删除成功");
                        load();
                    } else {
                        uglcw.ui.error("删除失败");
                    }
                }
            });
        })
    }

    //添加
    function add() {
        uglcw.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                var items = uglcw.ui.get('#grid').value();
                var exists = false;
                $(items).each(function (i, item) {
                    if (data.name == item.name) {
                        exists = true; //标记已存在
                        return false; //跳出循环
                    }
                })
                if (exists) {
                    uglcw.ui.error('[' + data.name + ']已存在，请勿重复添加');
                    return false;
                }
                $.ajax({
                    url: '${base}manager/fixedField/updateFixedField',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        if (resp === '1') {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '3') {
                            uglcw.ui.error('该名称不可用');
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })
    }

    //修改
    function update() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.Modal.open({
                content: $('#form').html(),
                success: function (container) {
                    uglcw.ui.init($(container));
                    uglcw.ui.bind($(container), selection[0]);
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('form')).validate();
                    if (!valid) {
                        return false;
                    }
                    var data = uglcw.ui.bind($(container).find('form'));
                    $.ajax({
                        url: '${base}manager/fixedField/updateFixedField',
                        type: 'post',
                        data: data,
                        async: false,
                        success: function (resp) {
                            if (resp === '2') {
                                uglcw.ui.success('修改成功！');
                                uglcw.ui.Modal.close();
                                uglcw.ui.get('#grid').reload();
                            } else {
                                uglcw.ui.error('操作失败');
                            }
                        }
                    })
                    return false;
                }
            });
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    function updateStatus(state) {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            $.ajax({
                url: '${base}manager/fixedField/updateStatus',
                type: 'post',
                data: {fixedId:selection[0].id, status: state},
                async: false,
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message || '操作失败');
                        return;
                    }
                }
            })
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function loadItemList(costItemId){
        var costTypeId = $("#costTypeId").val();
        var costTypeName =uglcw.ui.get("#costTypeId").k().text();
        uglcw.ui.get("#costItemId").value("");
        var w =  uglcw.ui.get("#costItemId").k();
        w.setDataSource({
            data:[]
        })
        $.ajax({
            url: "${base}/manager/queryUseCostItemList",
            type: "POST",
            data: {"typeId": costTypeId},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.rows != undefined) {
                    w.setDataSource({
                        data:json.rows
                    })
                    if(costItemId!=null&&costItemId!=""&&costItemId!=undefined){
                        uglcw.ui.get('#costItemId').value(costItemId);
                        //uglcw.ui.get("#costItemId").value(costItemId);
                    }
                }
            }
        })

    }



</script>
</body>
</html>
