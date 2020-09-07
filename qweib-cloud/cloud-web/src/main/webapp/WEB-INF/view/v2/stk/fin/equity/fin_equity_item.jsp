<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>股东权益科目</title>
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
        <div class="uglcw-layout-fixed" style="width: 250px">
            <input type="hidden" uglcw-model="typeId" value=${typeId} id="typeId" uglcw-role="textbox">
            <input type="hidden" uglcw-model="itemId" value=${itemId} id="itemId" uglcw-role="textbox">
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                         responsive:[40],
                    id:'id',
                    url: '${base}manager/queryEquityTypeList',
                    dataBound: function(){
                       this.select(this.table.find('tr:eq(0)'));
                     }
                    }">
                        <div data-field="typeName" uglcw-options="width:120">科目名称</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-container">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <select uglcw-model="status" uglcw-role="combobox" placeholder="明细科目状态">
                        <option value="1" selected>启用</option>
                        <option value="0">禁用</option>
                    </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                </li>
            </ul>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <form style="display: none" class="query">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="typeId">
                    </form>
                    <div id="wareTypeDiv" uglcw-role="grid"
                         uglcw-options="{
                    autoBind:false,
                    responsive:['.query',40],
                    toolbar: kendo.template($('#toolbar_cost').html()),
                    id:'id',
                    url: '${base}manager/queryEquityItemList',
                    criteria: '.query',
                    rowNumber:true,
                    }">
                        <div data-field="itemName" uglcw-options="width:260,
	                    headerTemplate: uglcw.util.template($('#header_itemName').html()),
                        "></div>
                        <%-- <div data-field="_operator"
                              uglcw-options="width:220, template: uglcw.util.template($('#formatterSt4').html())">
                             操作
                         </div>--%>
                        <div data-field="remarks" uglcw-options="width:260">备注</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar_cost">
    <a role="button" href="javascript:addItemClick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>增加明细科目
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:toEditItem();">
        <span class="k-icon k-i-edit"></span>修改</a>
    <a role="button" href="javascript:updateEquityItemStatus(1);" class="k-button k-button-icontext">
        <span class="k-icon k-i-checkmark"></span>启用</a>
    <a role="button" href="javascript:updateEquityItemStatus(0);" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>禁用</a>
</script>

<script id="header_itemName" type="text/x-uglcw-template">
    <span id="title_itemName">股东明细</span>
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
                    <label class="control-label col-xs-8">明细科目名称</label>
                    <div class="col-xs-14">
                        <input type="hidden" uglcw-model="id" uglcw-role="textbox"/>
                        <input uglcw-role="textbox" uglcw-model="itemName" id="itemName" value="${itemName}"
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">科目名称</label>
                    <div class="col-xs-14">
                        <select id="typeSel" uglcw-role="combobox"
                                uglcw-options="dataTextField:'typeName', dataValueField:'id'"
                                uglcw-model="typeId" uglcw-validate="required">

                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-14">
                        <textarea uglcw-role="textbox" uglcw-model="remarks" value="${remarks}"></textarea>
                        <input type="hidden" uglcw-role="textbox" id="status" uglcw-model="status" value="${status}"/>
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

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#wareTypeDiv').reload();
        });

        uglcw.ui.get('#grid').on('change', function (e) {
            var row = this.dataItem(this.select());//获取所有的数据
            console.log(row);//输出信息
            uglcw.ui.bind('.query', {typeId: row.id});//绑定id
            uglcw.ui.get('#wareTypeDiv').reload(); //加载数据

            if(row.typeName=="实收资本"){
                $("#title_itemName").text("股东明细");
            }else{
                $("#title_itemName").text("科目明细");
            }

        })

        uglcw.ui.loaded()

    })


    function deleteCostType(typeId) {
        uglcw.ui.confirm('是否确认删除该类别？', function () {
            $.ajax({
                url: "manager/deleteEquityType",
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
            title: '修改科目明细',
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), row);//把数据赋值给弹框
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var data = uglcw.ui.bind($("#category_name"));
                    $.ajax({
                        url: "manager/saveEquityType",
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
                        url: "manager/saveEquityType",
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


    function addItemClick() {//增加明细科目
        uglcw.ui.Modal.open({
            title: '增加明细科目',
            area: '500px',
            content: $('#distinction').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.get('#typeSel').k().setDataSource(uglcw.ui.get('#grid').bind());//作为typeSel的数据源
                var selectedRows = uglcw.ui.get('#grid').selectedRow();//获取选中的行 是个数组
                if (selectedRows && selectedRows.length > 0) {
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
                        url: '${base}/manager/saveFinEquityItem',
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

    function validate(callback) {
        var selection = uglcw.ui.get('#wareTypeDiv').selectedRow();
        if (selection) {
            if (selection[0].systemId) {
                uglcw.ui.warning("系统默认科目不能修改")
                return;
            }
            callback(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的科目名称');
        }

    }

    function toEditItem() {//修改
        validate(function (row) {
            uglcw.ui.Modal.open({
                content: $('#distinction').html(),
                title: '修改明细科目',
                success: function (container) {
                    uglcw.ui.init($(container));
                    uglcw.ui.get('#typeSel').k().setDataSource(uglcw.ui.get('#grid').bind());
                    uglcw.ui.bind($(container), row);//把数据赋值给弹框
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        var data = uglcw.ui.bind($("#itemdlg"));
                        $.ajax({
                            url: '${base}manager/saveFinEquityItem',
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
        })
    }

    function updateEquityItemStatus(status) {
        validate(function (row) {
            $.ajax({
                url: "${base}manager/updateEquityItemStatus",
                data: {id: row.id, status: status},
                type: "post",
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.info('操作成功');
                        uglcw.ui.get('#wareTypeDiv').reload();
                    } else {
                        uglcw.ui.error(response.message || '操作失败');
                        return;
                    }
                }
            });
        })
    }

    /*    function deleteCostItem(itemId) {
            uglcw.ui.confirm('是否确认删除该明细科目？', function () {
                $.ajax({
                    url: "manager/deleteEquityItem",
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
        }*/
</script>
</body>
</html>
