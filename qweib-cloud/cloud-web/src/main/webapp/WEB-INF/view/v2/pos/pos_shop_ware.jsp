<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>门店销售商品</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-header">
                    库存商品类
                </div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">
                    <div id="tree" uglcw-role="tree"
                         uglcw-options="
                        url:'${base}manager/syswaretypes',
                        expandable:function(node){return node.id == '0'},
                        loadFilter: function (response) {
                            $(response).each(function (index, item) {
                                if (item.text == '根节点') {
                                    item.text = '库存商品类'
                                }
                            })
                            return response;
                            },
                        select: function(e){
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#wareType').value(node.id);
                            uglcw.ui.get('#grid').reload();
                        }
                    "
                    >
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" id="wareType" uglcw-model="wareType" uglcw-role="textbox">
                            <tag:select2 name="shopNo" id="shopNo" tableName="pos_shopinfo" displayKey="shop_no"
                                         displayValue="shop_name" index="0"/>
                        </li>
                        <li>
                            <input type="checkbox" id="allWareCheck"
                                   uglcw-options="type:'number'"
                                   uglcw-model="paramValue" uglcw-value="0" uglcw-role="checkbox" onchange="updateData()">
                            <label style="margin-top: 10px;" for="allWareCheck">销售全部商品</label>
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="defaultUnit">
                                <option value="-1">全部单位</option>
                                <option value="1">大单位</option>
                                <option value="0">小单位</option>

                            </select>
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                        <li>
                           批量修改默认单位 <select uglcw-role="combobox" onchange="changeDefaultUnit()" id="defaultUnit1">
                            <option value=""></option>
                            <option value="1">大单位</option>
                                <option value="0">小单位</option>

                            </select>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                    responsive:['.header',60],
                    id:'id',
                    checkbox:true,
                    toolbar: kendo.template($('#toolbar').html()),
                    url: '${base}manager/pos/queryPosShopWare',
                    criteria: '.form-horizontal',
                    pageable: true,
                    ">

                        <div data-field="wareNm" uglcw-options="width:150,tooltip:true">商品名称</div>
                        <div data-field="posWareNm" uglcw-options="
								width:150,
								headerTemplate: uglcw.util.template($('#header_posWareNm').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.posWareNm, data: row, field:'posWareNm'})
								}
								">
                        </div>
                        <div data-field="wareDw" uglcw-options="width:80">大单位</div>
                        <div data-field="minUnit" uglcw-options="width:80">小单位</div>
                        <div data-field="defaultUnit" uglcw-options="
								width:150,
								headerTemplate: uglcw.util.template($('#header_defaultUnit').html()),
								template:templateUnit

								">
                        </div>
                        <div data-field="posPrice1" uglcw-options="
								width:150,
								headerTemplate: uglcw.util.template($('#header_lsPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.posPrice1, data: row, field:'posPrice1'})
								}
								">
                        </div>
                        <div data-field="posPrice2" uglcw-options="
								width:150,
								headerTemplate: uglcw.util.template($('#header_minLsPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.posPrice2, data: row, field:'posPrice2'})
								}
								">
                        </div>
                        <div data-field="disPrice1" uglcw-options="width:150">大单位促销价</div>
                        <div data-field="disPrice2" uglcw-options="width:150">小单位促销价</div>
                        <div data-field="wareDj" uglcw-options="width:150">大单位批发价</div>
                        <div data-field="sunitPrice" uglcw-options="width:150">小单位批发价</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:showProductSelector();" class="k-button k-button-icontext">
        <span class="k-icon k-i-add"></span>选择商品
    </a>
    <a role="button" href="javascript:del();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>删除商品
    </a>
</script>

<script id="header_defaultUnit" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('defaultUnit');">默认单位✎</span>
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('posPrice1');">大单位零售价✎</span>
</script>
<script id="header_minLsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('posPrice2');">小单位零售价✎</span>
</script>
<script id="header_posWareNm" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('posWareNm');">门店别称✎</span>
</script>

<script id="price" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #

    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric" uglcw-validate="number"
           style="height:25px;display:none" onchange="changePrice(this,'#= field #',#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>
</script>
<%--<script id="defaultUnit" type="text/x-uglcw-template">--%>
<%--# var wareId = data.wareId #--%>
<%--# var flag = false; #--%>
<%--# var defaultUnit = "小单位"; #--%>
<%--# if(val == '1'){ #--%>
<%--# defaultUnit = "大单位"; #--%>
<%--# flag = true; #--%>
<%--# } #--%>
<%--<select class="#=field#_select" id="#=field#_select_#=wareId#" style="display:none" onchange="changePrice(this,'#= field #',#= wareId #)">--%>
<%--<option value="0" <c:if test="#flag#">selected</c:if>>小单位</option>--%>
<%--<option value="1" >大单位</option>--%>
<%--</select>--%>
<%--<span class="#=field#_span" id="#=field#_span_#=wareId#" >#= defaultUnit #</span>--%>
<%--</script>--%>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {

        })

        // uglcw.ui.get('#hideZero').on('change', function(){ //实时监听
        //     uglcw.ui.get('#grid').reload();
        // })

        uglcw.ui.loaded()
    })

    //=======================================================================================
    function operatePrice(field) {
        if (field == 'defaultUnit') {
            //默认单位
            var display = $("." + field + "_select").css('display');
            if (display == 'none') {
                $("." + field + "_select").show();
                $("." + field + "_span").hide();
            } else {
                $("." + field + "_select").hide();
                $("." + field + "_span").show();
            }
        } else {
            var display = $("." + field + "_input").css('display');
            if (display == 'none') {
                $("." + field + "_input").show();
                $("." + field + "_span").hide();
            } else {
                $("." + field + "_input").hide();
                $("." + field + "_span").show();
            }
        }
    }

    function changeDefaultUnit() {

        var defaultUnit = $("#defaultUnit1").val();
        if(defaultUnit=="")return;
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var wareIds = '';
            for (var i = 0; i < selection.length; i++) {
                if (wareIds == '') {
                    wareIds = selection[i].wareId;
                } else {
                    wareIds += ',' + selection[i].wareId;
                }
            }

            uglcw.ui.confirm("确定批量修改所选记录吗？", function () {
                $.ajax({
                    url: "${base}manager/pos/updateBatDefaultUnit",
                    data: {
                        shopNos: uglcw.ui.get('#shopNo').value(),
                        wareIds: wareIds,
                        defaultUnit:defaultUnit
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success("修改成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error("修改失败");
                        }
                    }
                });
            })
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    function changePrice(o, field, wareId) {
      /*  if (isNaN(o.value)) {
            uglcw.ui.toast("请输入数字")
            return;
        }*/
        $.ajax({
            url: "${base}manager/pos/updateShopWare2",
            type: "post",
            data: {
                shopNo: $("#shopNo").val(),
                wareId: wareId,
                field: field,
                val: o.value,
            },
            success: function (data) {
                if (data == '1') {
                    $("#" + field + "_span_" + wareId).text(o.value);
                    // uglcw.ui.toast("价格保存成功");
                } else {
                    uglcw.ui.error("价格保存失败");
                }
            }
        });
    }

    //------------------------------------------------------------------------------------------------------------
    function showProductSelector() {
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                url: '${base}manager/waretypes',
                model: 'waretype',
                id: 'id',
                expandable: function (node) {
                    return node.id == 0;
                },
                loadFilter: function (response) {
                    $(response).each(function (index, item) {
                        if (item.text == '根节点') {
                            item.text = '商品分类'
                        }
                    })
                    return response;
                },
            },
            width: 900,
            id: 'wareId',
            pageable: true,
            url: '${base}manager/dialogWarePage',
            query: function (params) {
                params.stkId = 0
            },
            checkbox: true,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
            columns: [
                {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
                {
                    field: 'wareNm', title: '商品名称', width: 120, tooltip: true
                },
                {field: 'wareGg', title: '规格', width: 120},
                {field: 'inPrice', title: '采购价格', width: 120},
                {field: 'stkQty', title: '库存数量', width: 120},
                {field: 'wareDw', title: '大单位', width: 120},
                {field: 'minUnit', title: '小单位', width: 120},
                {field: 'maxUnitCode', title: '大单位代码', width: 120, hidden: true},
                {field: 'minUnitCode', title: '小单位代码', width: 120, hidden: true},
                {field: 'hsNum', title: '换算比例', width: 120, hidden: true},
                {field: 'sunitFront', title: '开单默认选中小单位', width: 240, hidden: true}
            ],
            yes: function (data) {
                if (data) {
                    $(data).each(function (i, row) {
                        row.id = 0;
                        row.wareId = row.wareId;
                        row.wareNm = row.wareNm;
                        row.wareDw = row.wareDw;
                        row.minUnit = row.minUnit;
                        row.defaultUnit = 0;
                        row.posPrice1 = row.posPrice1;
                        row.posPrice2 = row.posPrice1;
                    })
                    callBackFun(data);
                }
            }
        })
    }

    function callBackFun(data) {
        var shopNos = uglcw.ui.get("#shopNo").value();
        $.ajax({
            url: "${base}manager/pos/addBatShopWare",
            data: "shopNos=" + shopNos + "&wareStr=" + JSON.stringify(data),
            type: "post",
            success: function (json) {
                if (json.state) {
                    uglcw.ui.toast("保存成功");
                    uglcw.ui.get('#grid').addRow(data)
                    uglcw.ui.get('#grid').scrollBottom();
                } else {
                    uglcw.ui.toast("保存失败");
                }
            }
        });
    }

    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var wareIds = '';
            for (var i = 0; i < selection.length; i++) {
                if (wareIds == '') {
                    wareIds = selection[i].wareId;
                } else {
                    wareIds += ',' + selection[i].wareId;
                }
            }

            uglcw.ui.confirm("确定删除所选记录吗？", function () {
                $.ajax({
                    url: "${base}manager/pos/deleteShopWare",
                    data: {
                        shopNos: uglcw.ui.get('#shopNo').value(),
                        wareIds: wareIds
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


    function updateData() {
        var flag = 0;
        if (document.getElementById("allWareCheck").checked) flag = 0;
        else flag = 1;
        $.ajax({
            url: "${base}manager/pos/updateParams",
            type: "post",
            data: {
                "paramName": "门店销售商品",
                "paramValue": flag,
                "shopNo": '9999'
            },
            success: function (data) {
                if (data.state) {
                    uglcw.ui.toast("操作成功");
                    uglcw.ui.get("#wareType").value(0);
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.toast("操作失败")
                }
            }
        });
    }

    //
    function templateUnit(row) {
        var defaultUnit = "小单位";
        var val = row.defaultUnit;
        var wareId = row.wareId;
        if (val == 1) defaultUnit = "大单位";
        var html = '';
        html += '<select class="defaultUnit_select" id="defaultUnit_select_' + wareId + '" style="display:none" onchange="changePrice2(this,' + row.wareId + ')" >';
        if (val == 1) {
            html += '<option value="0">小单位</option>';
            html += '<option value="1" selected>大单位</option>';
        } else {
            html += '<option value="0" selected>小单位</option>';
            html += '<option value="1">大单位</option>';
        }
        html += '</select>';
        html += '<span id="defaultUnit_span_' + wareId + '" class="defaultUnit_span">' + defaultUnit + '</span>';
        return html;
    }

    function changePrice2(o, wareId) {
        $.ajax({
            url: "${base}manager/pos/updateShopWare2",
            type: "post",
            data: {
                shopNo: $("#shopNo").val(),
                wareId: wareId,
                field: 'defaultUnit',
                val: o.value,
            },
            success: function (data) {
                if (data == '1') {
                    if (o.value == '1') {
                        $("#defaultUnit_span_" + wareId).text('大单位');
                    } else {
                        $("#defaultUnit_span_" + wareId).text('小单位');
                    }

                    uglcw.ui.toast("价格保存成功");
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }


</script>
</body>
</html>
