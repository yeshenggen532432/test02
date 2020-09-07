<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>杂费明细设置</title>
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
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 250px;display: none">
            <input type="hidden" uglcw-model="typeId" value=${typeId} id="typeId" uglcw-role="textbox">
            <input type="hidden" uglcw-model="itemId" value=${itemId} id="itemId" uglcw-role="textbox">
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                         responsive:[40],
                    id:'id',
                    url: '${base}manager/queryInCostTypeList',
                    criteria: '.form-horizontal',
                    dataBound: function(){
                       this.select(this.table.find('tr:eq(0)'))
                     }
                    }">
                        <div data-field="typeName" uglcw-options="width:120">科目名称</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-container">
            <div class="layui-card">
                <div class="layui-card-body full">
                    <form style="display: none" class="query">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="typeId">
                    </form>
                    <div id="wareTypeDiv" uglcw-role="grid"
                         uglcw-options="{
                    autoBind:false,
                    responsive:[40],
                    toolbar: kendo.template($('#toolbar_cost').html()),
                    id:'id',
                    url: '${base}manager/queryInCostItemList',
                    criteria: '.query',
                    rowNumber:true,
                    }">
                        <div data-field="itemName" uglcw-options="width:120">杂费明细名称</div>
                        <div data-field="_operator"
                             uglcw-options="width:220, template: uglcw.util.template($('#formatterSt4').html())">
                            操作
                        </div>
                        <div data-field="remarks" uglcw-options="width:120">备注</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar_cost">
    <a role="button" href="javascript:addItemClick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>增加杂费明细
    </a>
</script>

<script type="text/x-kendo-template" id="formatterSt4">
    #if(data.systemId!=""&&data.systemId!=null){#

    #}else{#
    <button class="k-button k-info" onclick="toEditItem(this,#= data.id#)">修改</button>
    <button class="k-button k-error" onclick="deleteCostItem(#= data.id#)">删除
    </button>
    #if(data.status==1){#
    <button class="k-button" onclick="updateEquityItemStatus(#= data.id#,0)">禁用</button>
    #}else{#
    <button class="k-button" onclick="updateEquityItemStatus(#= data.id#,1)">启用</button>
    #}#
    #}#
</script>
<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="category_name">
                <div class="form-group">
                    <label class="control-label col-xs-8">科目名称</label>
                    <div class="col-xs-14">
                        <input type="hidden" uglcw-model="id" uglcw-role="textbox"/>
                        <input uglcw-role="textbox" uglcw-model="typeName" id="typeName" value="${typeName}"
                               uglcw-validate="required">

                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<script id="distinction" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="itemdlg">
                <div class="form-group">
                    <label class="control-label col-xs-8">杂费明细名称</label>
                    <div class="col-xs-14">
                        <input type="hidden" uglcw-model="id" uglcw-role="textbox"/>
                        <input uglcw-role="textbox" uglcw-model="itemName" id="itemName" value="${itemName}"
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group" style="display: none">
                    <label class="control-label col-xs-8">科目名称</label>
                    <div class="col-xs-14">
                        <select id="typeSel" uglcw-role="combobox"
                                uglcw-options="dataTextField:'typeName', dataValueField:'id'"
                                uglcw-model="typeId"  uglcw-validate="required">

                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-14">
                        <textarea uglcw-role="textbox" uglcw-model="remarks" value="${remarks}"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#grid').on('change', function (e) {
            var row = this.dataItem(this.select());//获取所有的数据
            console.log(row);//输出信息
            uglcw.ui.bind('.query', {typeId: row.id});//绑定id
            uglcw.ui.get('#wareTypeDiv').reload(); //加载数据
        })

        uglcw.ui.loaded()

    })


    function deleteCostType(typeId) {
        uglcw.ui.confirm('是否确认删除该类别？', function () {
            $.ajax({
                url: "manager/deleteInCostType",
                type: "post",
                data: "id=" + typeId,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('删除成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('删除失败' + json.msg);
                        return;
                    }
                }
            });
        });
    }

    function toEditType(e) {//修改
        var btn = e;
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr')); //获取点击行的数据
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#t').html(),
            title:'修改杂费明细',
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), row);//把数据赋值给弹框
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var data = uglcw.ui.bind($("#category_name"));
                    $.ajax({
                        url: "manager/saveInCostType",
                        type: "post",
                        data: data,
                        success: function (json) {
                            if (json.state) {
                                uglcw.ui.success('操作成功');
                                uglcw.ui.get('#grid').reload();
                            } else {
                                uglcw.ui.error('操作失败' + json.msg);
                                return;
                            }
                        }
                    });
                } else {
                    uglcw.ui.error('校验失败');
                    return false;
                }

            }
        });

    }

    function addTypeClick() {//增加类型
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#t').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var id = $("#typeId").val();
                    var data = uglcw.ui.bind($("#category_name"));
                    data.id = id;
                    $.ajax({
                        url: "manager/saveInCostType",
                        type: "post",
                        data: data,
                        success: function (json) {
                            if (json.state) {
                                uglcw.ui.success('添加成功');
                                uglcw.ui.get('#grid').reload();
                            } else {
                                uglcw.ui.error('操作失败' + json.msg);
                                return;
                            }
                        }
                    });

                } else {
                    uglcw.ui.error('校验失败');
                    return false;
                }

            }
        });
    }

    function updateEquityItemStatus(id, status) {
        $.ajax({
            url: "manager/updateInCostItemStatus",
            data: "id=" + id + "&status=" + status,
            type: "post",
            success: function (json) {
                if (json.state) {
                    uglcw.ui.info('操作成功');
                    uglcw.ui.get('#wareTypeDiv').reload();
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }

    function addItemClick() {//增加明细科目
        uglcw.ui.Modal.open({
            title:'增加杂费明细',
            area: '500px',
            content: $('#distinction').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.get('#typeSel').k().setDataSource(uglcw.ui.get('#grid').bind());//作为typeSel的数据源
                var selectedRows = uglcw.ui.get('#grid').selectedRow();//获取选中的行 是个数组
                if(selectedRows && selectedRows.length>0){
                    uglcw.ui.bind(container, {
                        typeId: selectedRows[0].id
                    })
                }

            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var data = uglcw.ui.bind($("#itemdlg"));

                    var items = uglcw.ui.get('#wareTypeDiv').value();
                    var exists = false;
                    $(items).each(function (i, item) {
                        if (data.itemName == item.itemName) {
                            exists = true; //标记已存在
                            return false; //跳出循环

                        }
                    })
                    if (exists) {
                        uglcw.ui.error('[' + data.itemName + ']已存在，请勿重复添加');
                        return false;
                    }
                    $.ajax({
                        url: '${base}/manager/saveFinInCostItem',
                        type: "post",
                        data: data,
                        success: function (json) {
                            if (json.state) {
                                uglcw.ui.success('保存成功');
                                uglcw.ui.get('#wareTypeDiv').reload();
                            } else {
                                uglcw.ui.error('保存失败' + json.msg);
                                return;
                            }
                        }
                    });
                } else {
                    uglcw.ui.error('校验失败');
                    return false;
                }

            }
        });
    }

    function toEditItem(e) {//修改
        var btn = e;
        var row = uglcw.ui.get('#wareTypeDiv').k().dataItem($(btn).closest('tr')); //获取点击行的数据
        uglcw.ui.Modal.open({
            content: $('#distinction').html(),
            title:'修改杂费明细',
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.get('#typeSel').k().setDataSource(uglcw.ui.get('#grid').bind());
                uglcw.ui.bind($(container), row);//把数据赋值给弹框
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var data = uglcw.ui.bind($("#itemdlg"));
                /*    var items = uglcw.ui.get('#wareTypeDiv').value();
                    var exists = false;
                    $(items).each(function (i, item) {
                        if (data.itemName == item.itemName) {
                            exists = true;
                            return false;
                        }
                    })
                    if (exists) {
                        uglcw.ui.error('[' + data.itemName + ']已存在，请勿重复添加');
                        return false;
                    }
*/
                    $.ajax({
                        url: '${base}/manager/saveFinInCostItem',
                        type: "post",
                        data: data,
                        success: function (json) {
                            if (json.state) {
                                uglcw.ui.success('保存成功');
                                uglcw.ui.get('#wareTypeDiv').reload();
                            } else {
                                uglcw.ui.error('保存失败' + json.msg);
                                return;
                            }
                        }
                    });
                } else {
                    uglcw.ui.error('校验失败');
                    return false;
                }

            }
        });

    }

    function deleteCostItem(itemId) {
        uglcw.ui.confirm('是否确认删除该杂费明细？', function () {
            $.ajax({
                url: "manager/deleteInCostItem",
                type: "post",
                data: "id=" + itemId,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('删除成功');
                        uglcw.ui.get('#wareTypeDiv').reload();
                    } else {
                        uglcw.ui.error('删除失败' + json.msg);
                        return;
                    }
                }
            });
        });
    }
</script>
</body>
</html>
