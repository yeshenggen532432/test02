<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>门店促销设置</title>
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
        <div class="layui-card header">
            <div class="layui-card-body">
                <ul class="uglcw-query form-horizontal query">
                    <li>
                        <tag:select2 name="shopNo" id="shopNo" tableName="pos_shopinfo" displayKey="shop_no"
                                     displayValue="shop_name" index="0"/>
                    </li>
                    <li>
                        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </li>
                </ul>
            </div>
        </div>
        <%--表格：start--%>
        <div class="layui-card">
            <div class="layui-card-body full">
                <div id="grid" uglcw-role="grid"
                     uglcw-options="
                            responsive:['.header',60],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							pageable: true,
                    		url: '${base}manager/pos/queryPosCardDisSet',
                    		criteria: '.query',
                    	">
                    <div data-field="typeName" uglcw-options="width:150">卡类型</div>
                    <div data-field="rateType"
                         uglcw-options="width:150,template: uglcw.util.template($('#rateType').html())">打折类型
                    </div>
                    <div data-field="objName" uglcw-options="width:150">打折对象</div>
                    <div data-field="rate" uglcw-options="width:100">折扣%</div>
                    <div data-field="startTimeStr" uglcw-options="width:200">开始时间</div>
                    <div data-field="endTimeStr" uglcw-options="width:200">结束时间</div>
                    <div data-field="status" uglcw-options="width:100,template: uglcw.util.template($('#status').html())">
                        状态
                    </div>
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
<%--启用状态--%>
<script id="status" type="text/x-uglcw-template">
    # if(data.status == 0){ #
    无效
    # }else if(data.status == 1){ #
    有效
    # } #
</script>
<script id="rateType" type="text/x-uglcw-template">
    # if(data.rateType == 0){ #
    全店打折
    # }else if(data.rateType == 1){ #
    按类型打折
    # }else if(data.rateType == 2){ #
    按单品打折
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
                <input uglcw-role="textbox" uglcw-model="id" id="dialog-id" type="hidden">
                <div class="form-group">
                    <label class="control-label col-xs-6">*连&nbsp;&nbsp;锁&nbsp;&nbsp;店</label>
                    <div class="col-xs-16">
                        <tag:select2 name="shopNo" id="dialog-shopNo" index="0" tableName="pos_shopinfo"
                                     displayKey="shop_no" displayValue="shop_name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">*卡&nbsp;&nbsp;类&nbsp;&nbsp;型</label>
                    <div class="col-xs-16">
                        <tag:select2 name="id" id="dialog-cardType" index="0" tableName="shop_member_type"
                                     displayKey="id" displayValue="type_name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">*打折类型</label>
                    <div class="col-xs-16">
                        <select uglcw-role="combobox" uglcw-model="rateType" id="dialog-rateType"
                                onchange="changeDisType();" uglcw-validate="required">
                            <option value="0">全店打折</option>
                            <option value="1">按类型打折</option>
                            <option value="2">按单品打折</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <input type="hidden" id="objId" name="objId"/>
                    <label class="control-label col-xs-6">打折对象</label>
                    <div class="col-xs-16" id="qdDiv">
                        <input id="qdInput" uglcw-model="rate" uglcw-role="textbox" value="全店打折" readonly>
                    </div>
                    <div class="col-xs-16" id="typeDiv" style="display: none">
                        <input type="hidden" id="typeId" uglcw-model="typeId" uglcw-role="textbox"/>
                        <input id="typeInput" uglcw-role="dropdowntree" uglcw-model="wareType"
                               uglcw-options="
                               url: '${base}manager/syswaretypes',
                               select:function(e){
                                var node = this.dataItem($(e.node));
                                uglcw.ui.get('#typeId').value(node.id);
                               }
                        ">
                    </div>
                    <div class="col-xs-16" id="wareDiv" style="display: none">
                        <input type="hidden" id="wareId" model="wareId" uglcw-role="textbox"/>
                        <input id="wareInput" uglcw-role="gridselector" uglcw-model="wareNm"
                               uglcw-options="click: showConsignee">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">折&nbsp;扣(%)</label>
                    <div class="col-xs-16">
                        <input uglcw-model="rate" uglcw-role="numeric" id="dialog-rate" uglcw-validate="number">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">特&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价</label>
                    <div class="col-xs-16">
                        <input uglcw-model="disPrice" uglcw-role="numeric" id="dialog-disPrice" uglcw-validate="number">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">*开始时间</label>
                    <div class="col-xs-16">
                        <input uglcw-model="startTimeStr" uglcw-role="datetimepicker" id="dialog-startTimeStr"
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">*结束时间</label>
                    <div class="col-xs-16">
                        <input uglcw-model="endTimeStr" uglcw-role="datetimepicker" id="dialog-endTimeStr"
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">有&nbsp;&nbsp;效&nbsp;&nbsp;否</label>
                    <div class="col-xs-16">
                        <input type="checkbox" id="dialog-status" uglcw-model="status" uglcw-value="1" uglcw-role="checkbox"
                               uglcw-options="type:'number'">
                        <label for="dialog-status"></label>
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
                    url: "${base}manager/pos/deletePosShopRate",
                    data: {
                        id: selection[0].id,
                    },
                    type: 'post',
                    dataType: 'json',
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
                    var rateType = row.rateType;
                    var objName = row.objName;
                    var objId = row.objId;
                    if (rateType == 0) {
                        uglcw.ui.get("#qdInput").value('全店打折');
                        $("#qdDiv").show();
                        $("#typeDiv").hide();
                        $("#wareDiv").hide();
                    } else if (rateType == 1) {
                        uglcw.ui.get("#typeId").value(objId);
                        uglcw.ui.get("#typeInput").value(objName);
                        $("#qdDiv").hide();
                        $("#typeDiv").show();
                        $("#wareDiv").hide();
                    } else if (rateType == 2) {
                        uglcw.ui.get("#wareId").value(objId);
                        uglcw.ui.get("#wareInput").value(objName);
                        $("#qdDiv").hide();
                        $("#typeDiv").hide();
                        $("#wareDiv").show();
                    }
                }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var shopNo = uglcw.ui.get('#dialog-shopNo').value();
                if (shopNo == null || shopNo == undefined || shopNo == '') {
                    uglcw.ui.toast('请选择门店');
                    return false;
                }
                // var data = uglcw.ui.bind($(container).find('form'));
                var id = uglcw.ui.get('#dialog-id').value();
                var disPrice = uglcw.ui.get('#dialog-disPrice').value();
                var startTimeStr = uglcw.ui.get('#dialog-startTimeStr').value();
                var endTimeStr = uglcw.ui.get('#dialog-endTimeStr').value();
                var status = uglcw.ui.get('#dialog-status').value();
                var rate = uglcw.ui.get('#dialog-rate').value();
                var cardType = uglcw.ui.get('#dialog-cardType').value();

                var rateType = uglcw.ui.get("#dialog-rateType").value();
                // var typeInput = uglcw.ui.get("#typeInput").value();
                var objName;
                var objId;
                if (rateType == 0) {
                    var qdInput = uglcw.ui.get("#qdInput").value();
                    objName = qdInput;
                    objId = '';
                } else if (rateType == 1) {
                    var typeId = uglcw.ui.get("#typeId").value();
                    objName = '';
                    objId = typeId;
                } else if (rateType == 2) {
                    var wareId = uglcw.ui.get("#wareId").value();
                    var wareInput = uglcw.ui.get("#wareInput").value();
                    objName = wareInput;
                    objId = wareId;
                }
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/pos/savePosCardDisSet',
                    type: 'post',
                    data: {
                        id: id,
                        cardType: cardType,
                        shopNo: shopNo,
                        disPrice: disPrice,
                        rate: rate,
                        startTimeStr: startTimeStr,
                        endTimeStr: endTimeStr,
                        status: status,
                        rateType: rateType,
                        objName: objName,
                        objId: objId,
                    },
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

    //-------------------------------------------------------------
    function changeDisType() {
        var rateType = uglcw.ui.get("#dialog-rateType").value();
        if (rateType == 0) {
            $("#qdInput").val("全店打折");
            $("#qdDiv").show();
            $("#typeDiv").hide();
            $("#wareDiv").hide();
        }
        if (rateType == 1) {
            $("#qdInput").val("");
            $("#qdDiv").hide();
            $("#typeDiv").show();
            $("#wareDiv").hide();
        }
        if (rateType == 2) {
            $("#qdInput").val("");
            $("#qdDiv").hide();
            $("#typeDiv").hide();
            $("#wareDiv").show();
        }
    }

    function showConsignee() {
        <tag:product-selector query="onQueryProduct" callback="onProductSelect"/>
    }

    function onQueryProduct(params) {
        // params.stkId = uglcw.ui.get('#stkId').value();
        params.stkId = '0';
        return params
    }

    function onProductSelect(rows) {
        if (rows) {
            uglcw.ui.get('#wareInput').value(rows[0].wareNm);
            uglcw.ui.get('#wareId').value(rows[0].wareId);
        }
    }
</script>
</body>
</html>
