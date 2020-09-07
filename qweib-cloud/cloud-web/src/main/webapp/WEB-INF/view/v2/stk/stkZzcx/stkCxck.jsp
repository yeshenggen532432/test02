<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-tabstrip .k-content {
            padding: 0px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card master">
        <div class="layui-card-header btn-group">
            <ul uglcw-role="buttongroup">
                <li onclick="add()" data-icon="add" class="k-info">新建</li>
                <c:if test="${stkZzcx.status eq -2}">
                    <li onclick="submitStk()" class="k-info" data-icon="save">暂存</li>
                </c:if>
                <c:if test="${stkZzcx.status eq -2 and  stkZzcx.id ne 0}">
                    <li onclick="audit()" class="k-info" data-icon="track-changes-accept">确定拆卸产品出库</li>
                </c:if>
                <c:if test="${stkZzcx.status eq 0}">
                    <li onclick="auditRk()" class="k-info" data-icon="track-changes-accept">原料入库</li>
                </c:if>
                <c:if test="${stkZzcx.status ne 2 and  stkZzcx.id ne 0}">
                    <li onclick="cancelClick()" class="k-info" data-icon="delete">作废</li>
                </c:if>
            </ul>
            <div class="bill-info">
                <div class="no" style="color:green;">${stkZzcx.billName} ${stkZzcx.billNo}</div>
                <div class="status" id="billstatus" style="color:red;">
                    <c:choose>
                        <c:when test="${stkZzcx.status eq -2}">暂存</c:when>
                        <c:when test="${stkZzcx.status eq 0}">原料待入库</c:when>
                        <c:when test="${stkZzcx.status eq 1}">已入库</c:when>
                        <c:when test="${stkZzcx.status eq 2}">已作废</c:when>
                        <c:otherwise>
                            新建
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input type="hidden" uglcw-role="textbox" uglcw-model="id" id="billId" value="${stkZzcx.id}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="bizType" id="bizType"
                       value="${stkZzcx.bizType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="stkName" id="stkName"
                       value="${stkZzcx.stkName}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="stkInName" id="stkInName"
                       value="${stkZzcx.stkInName}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="proName" id="proName"
                       value="${stkZzcx.proName}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="proId" id="proId" value="${stkZzcx.proId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="proType" id="proType"
                       value="${stkZzcx.proType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status"
                       value="${stkZzcx.status}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="ioMark" id="ioMark"
                       value="${stkZzcx.ioMark}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="billName" id="billName"
                       value="${stkZzcx.billName}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="billNo" id="billNo"
                       value="${stkZzcx.billNo}"/>
                <div class="form-group">
                    <label class="control-label col-xs-3">单据时间</label>
                    <div class="col-xs-4">
                        <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="inDate" value="${stkZzcx.inDate}">
                    </div>
                    <label class="control-label  col-xs-3">拆卸仓库</label>
                    <div class="col-xs-4">
                        <tag:select2 index="0" name="stkId" id="stkId" tclass="pcl_sel"
                                     whereBlock="status=1 or status is null"
                                     tableName="stk_storage"
                                     value="${stkZzcx.stkId }" displayKey="id" displayValue="stk_name"/>
                    </div>
                    <label class="control-label  col-xs-3">原料仓库</label>
                    <div class="col-xs-4">
                        <tag:select2 index="0" name="stkInId" id="stkInId" tclass="pcl_sel"
                                     tableName="stk_storage"
                                     whereBlock="status=1 or status is null"
                                     value="${stkZzcx.stkInId }" displayKey="id"
                                     displayValue="stk_name"/>
                    </div>
                </div>
                <div class="form-group" style="display: none;">
                    <label class="control-label col-xs-3">合计金额</label>
                    <div class="col-xs-4">
                        <input id="totalAmt" uglcw-role="textbox" uglcw-model="totalAmt"
                               value="${stkZzcx.totalAmt}"
                               readonly>
                        <input type="hidden" id="discount" uglcw-role="textbox" uglcw-model="discount"
                               value="${stkZzcx.discount}">
                    </div>
                    <label class="control-label col-xs-3">拆卸金额</label>
                    <div class="col-xs-4">
                        <input id="disAmt" uglcw-role="textbox" uglcw-model="disAmt" readonly
                               value="${stkZzcx.disAmt}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">备注</label>
                    <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${stkZzcx.remarks}</textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div uglcw-role="tabs">
                <ul>
                    <li>拆卸商品</li>
                    <li id="relate-tab">关联原料</li>
                </ul>
                <div>
                    <div id="grid" uglcw-role="grid-advanced"
                         uglcw-options='
                          id: "id",
                          autoAppendRow: false,
                           speedy:{
                            className: "uglcw-cell-speedy"
                          },
                          add: function(row){
                            return uglcw.extend({
                                qty:1,
                                amt: 0,
                                price:0
                            }, row);
                          },
                          editable: true,
                          toolbar: uglcw.util.template($("#toolbar").html())({el: "grid", title: "拆卸商品", multiple: false}),
                          height:400,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource:${fns:toJson(stkZzcx.subList)}
                        '
                    >
                        <div data-field="wareCode" uglcw-options="
                                    width: 150,editable: false
                                 ">产品编号
                        </div>
                        <div data-field="wareNm" uglcw-options="width: 210,editable:false
                         ">产品名称
                        </div>

                        <div data-field="wareGg" uglcw-options="width: 150">产品规格</div>
                        <div data-field="beUnit" uglcw-options="width: 150,
                                        template: '#= data.beUnit == data.maxUnitCode ? data.wareDw||\'\' : data.minUnit||\'\' #',
                                        editor: function(container, options){
                                         var model = options.model;
                                         if(!model.wareId){
                                            $(container).html('<span>请先选择产品</span>')
                                            return ;
                                         }
                                         var input = $('<input name=\'beUnit\' data-bind:\'value:beUnit\'>');
                                         input.appendTo(container);
                                         var widget = new uglcw.ui.ComboBox(input);
                                         widget.init({
                                          value: model.maxUnitCode,
                                          dataSource:[
                                          { text: model.wareDw, value:model.maxUnitCode },
                                          { text: model.minUnit, value:model.minUnitCode}
                                          ]
                                         })
                                        }
                                    ">单位
                        </div>
                        <div data-field="qty" uglcw-options="
                                 schema:{ type: 'number'},
                                  width: 150,
                                  attributes:{
                                        class: 'uglcw-cell-speedy'
                                  },
                            ">数量
                        </div>
                        <div data-field="price"
                             uglcw-options="width: 150, hidden: ${stkZzcx.status eq -2}, editable: false">
                            单价
                        </div>
                        <div data-field="amt" uglcw-options="width: 150,
                                    hidden: ${stkZzcx.status eq -2},
                                    editable: false,
                                    aggregates: ['sum'],
                                    footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\') #'">金额
                        </div>
                        <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
                    </div>
                </div>
                <div>
                    <div id="grid2" uglcw-role="grid-advanced"
                         uglcw-options='
                          id: "id",
                           speedy:{
                            className: "uglcw-cell-speedy"
                          },
                          add: function(row){
                            return uglcw.extend({
                                qty:1,
                                amt: 0,
                                price:0
                            }, row);
                          },
                          editable: true,
                          toolbar: uglcw.util.template($("#toolbar2").html())({el: "grid2", title: "关联原料", multiple: true}),
                          height:400,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource:${fns:toJson(stkZzcx.itemList)}
                        '
                    >
                        <div data-field="wareCode" uglcw-options="
                                 width: 150,editable: false,
                                 ">产品编号
                        </div>
                        <div data-field="wareNm" uglcw-options="width: 150,editable:false">产品名称
                        </div>

                        <div data-field="wareGg" uglcw-options="width: 150">产品规格</div>
                        <div data-field="beUnit" uglcw-options="width: 150,
                                template: '#= data.beUnit == data.maxUnitCode ? data.wareDw||\'\' : data.minUnit||\'\' #',
                                editor: function(container, options){
                                var model = options.model;
                                if(!model.wareId){
                                    $(container).html('<span>请先选择产品</span>')
                                    return ;
                                 }
                                 var input = $('<input name=\'beUnit\' data-bind:\'value:beUnit\'>');
                                 input.appendTo(container);
                                 var widget = new uglcw.ui.ComboBox(input);
                                 widget.init({
                                  value: model.maxUnitCode,
                                  dataSource:[
                                  { text: model.wareDw, value:model.maxUnitCode },
                                  { text: model.minUnit, value:model.minUnitCode}
                                  ]
                                 })
                                }
                            ">单位
                        </div>
                        <div data-field="qty" uglcw-options="
                                 schema:{ type: 'number',decimals:10},
                                  width: 150,
                                  aggregates: ['sum'],
                                  attributes:{
                                        class: 'uglcw-cell-speedy'
                                  },
                                  footerTemplate: '#= uglcw.util.toString(sum || 0, \'n2\')#'
                            ">数量
                        </div>
                        <div data-field="price"
                             uglcw-options="width: 150, hidden: ${stkZzcx.status eq -2},
                              schema:{type:'number',decimals:10}">
                            单价
                        </div>

                        <div data-field="amt" uglcw-options="width: 150,
                                editable: false,  hidden: ${stkZzcx.status eq -2},
                                aggregates: ['sum'],
                                format:'{0:n2}',
                                footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\') #'">金额
                        </div>
                        <div data-field="relaWareNm" uglcw-options="width:150,editable: false">拆卸产品</div>
                        <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <c:if test="${empty stkZzcx.id or stkZzcx.id eq 0}">
        <a role="button" href="javascript:addProduct('#= data.el#', #= data.multiple#);"
           class="k-button k-button-icontext k-grid-add-purchase">
            <span class="k-icon k-i-plus-circle"></span>添加#= data.title#
        </a>
    </c:if>
</script>

<tag:product-in-selector-template query="onQueryProduct" />

<script type="text/x-kendo-template" id="toolbar2">
    <%--<c:if test="${empty stkZzcx.id or stkZzcx.id eq 0}">--%>
        <a href="javascript:addProduct('#= data.el#', #= data.multiple#);"
           class="addBtnClass k-button k-button-icontext">
            <span class="k-icon k-i-plus-circle"></span>添加#= data.title#
        </a>
    <%--</c:if>--%>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/biz/erp/util.js?v=20191120"></script>
<script>
    $(function () {
        uglcw.ui.init();
        <c:if test="${empty stkZzcx.inDate}">
        uglcw.ui.get('#inDate').value(uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm'));
        </c:if>

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
                if (e.field == 'qty') {
                    resetStkWareTplList(item.wareId, item.qty);
                } else if (e.field === 'beUnit') {
                    if (item.beUnit === 'B') {
                        //切换至大单位 价格=小单位单价*转换比例
                        var price =  Number(item.price*item.hsNum).toFixed(2);
                        item.set('price', price);
                    } else if (item.beUnit === 'S') {
                        var price = Number(item.price / item.hsNum).toFixed(2);
                        item.set('price', price);
                    }
                }
                item.set('amt', Number((item.qty * item.price).toFixed(2)))
                uglcw.ui.get('#grid').commit();
            }
            compute();
        });

        uglcw.ui.get('#grid2').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
                if (e.field === 'beUnit') {
                    if (item.beUnit === 'B') {
                        //切换至大单位 价格=小单位单价*转换比例
                        var price =  Number(item.price*item.hsNum).toFixed(2);
                        item.set('price', price);
                    } else if (item.beUnit === 'S') {
                        var price = Number(item.price / item.hsNum).toFixed(2);
                        item.set('price', price);
                    }
                }
                item.set('amt', Number((item.qty * item.price).toFixed(2)));
                uglcw.ui.get('#grid2').commit();
            }
        });
        <c:if test="${stkZzcx.id>0}">
        var data = uglcw.ui.get('#grid2').k().dataSource.data();
        var rela = uglcw.ui.get('#grid').value();
        $(data).each(function (i, item) {
            $.map(rela, function (row) {
                if ((item.relaWareId === row.wareId)) {
                    item.set('relaWareNm', row.wareNm);
                }
            })

        })
        // $(".addBtnClass").hide();
        // uglcw.ui.get('#grid2').hideColumn('options');

        uglcw.ui.get('#grid2').commit();
        </c:if>
        uglcw.ui.loaded();
    })

    function compute() {
        var data = uglcw.ui.get('#grid').bind();
        var totalAmt = 0;
        $.map(data, function (row) {
            totalAmt += (parseFloat(row.qty) * parseFloat(row.price));
        })
        uglcw.ui.get('#totalAmt').value(Number(totalAmt).toFixed(2));
        uglcw.ui.get('#disAmt').value(Number(totalAmt).toFixed(2));
    }

    function add() {
        uglcw.ui.openTab('拆分单', '${base}manager/stkZzcx/add?bizType=${param.bizType}');
    }

    var currentGrid, checkbox;

    function addProduct(el, multiple) {
        currentGrid = el;
        checkbox = multiple;
        if (!uglcw.ui.get('#stkId').value()) {
            return uglcw.ui.warning('请选择仓库');
        }
        <tag:product-out-selector-script callback="onProductSelect" onCheckbox="showCheckbox"/>
    }

    function showCheckbox() {
        return !!checkbox;
    }

    function onQueryProduct(params) {
        params.stkId = uglcw.ui.get('#stkId').value();
        return params
    }

    function onProductSelect(rows) {
        var mainProducts = uglcw.ui.get('#grid').value();
        console.table(rows);
        rows = $.map(rows, function (row) {
            if($.isFunction(row.toJSON)){
                row = row.toJSON();
            }
            row.qty = 1;
            row.price = row.inPrice || 0;
            row.bPrice = row.price;
            row.beUnit = row.maxUnitCode;
            if (row.sunitFront == 1) {
                //如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助
                row.beUnit = row.minUnitCode;
            }
            if (row.beUnit === 'S') {
                row.price = Number(row.bPrice / row.hsNum).toFixed(2);
            }
            row.amt = row.price * row.qty;
            if (currentGrid === 'grid2' && mainProducts && mainProducts.length > 0) {
                row.relaWareId = mainProducts[0].wareId;
                row.relaWareNm = mainProducts[0].wareNm;
            }
            delete row['productDate']
            return row;
        })
        if (currentGrid === 'grid') {
            //商品只允许一条记录
            var exists = uglcw.ui.get('#grid').value();
            if (exists && exists.length > 0) {
                //先清空
                uglcw.ui.get('#grid').value([]);
                uglcw.ui.get('#grid2').value([]);
            } else {
                //更新原料关联商品
                var data = uglcw.ui.get('#grid2').k().dataSource.data();
                if (data && data.length > 0) {
                    $.map(data, function (r) {
                        r.relaWareId = rows[0].wareId;
                        r.relaWareNm = rows[0].wareNm;
                    })
                    uglcw.ui.get('#grid2').commit();
                }
            }
        }
        uglcw.ui.get('#' + currentGrid).addRow(rows, {move: false});
        if (currentGrid === 'grid') {
            $.map(rows, function (row) {
                getStkWareTplList(row.wareId);
            })

        }
    }

    function submitStk() {
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return
        }
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            return uglcw.ui.warning('该单据已审批，不能保存!');
        }
        if (status == 2) {
            return uglcw.ui.warning('该单据已作废，不能保存!');
        }
        uglcw.ui.get('#grid').commit();
        var status = uglcw.ui.get('#status').value();
        if (status != -2) {
            uglcw.ui.warning('发票不在暂存状态，不能保存！')
        }

        var data = uglcw.ui.bind('form');

        var products = uglcw.ui.get('#grid').bind();
        if (products.length < 1) {
            return uglcw.ui.error('请添加明细');
        }
        var bool = checkFormQtySign(products,1);
        if(!bool){
            return;
        }
        valid = true;
        $(products).each(function (idx, row) {
            if (!checkWare(row.wareId)) {
                uglcw.ui.error('商品[' + row.wareNm + ']未关联原料!不能保存！');
                valid = false;
                return false;
            }
            $.map(row, function (v, k) {
                data['subList[' + idx + '].' + k] = v;
            })
        })
        if (!valid) {
            return;
        }
        items = uglcw.ui.get('#grid2').bind();
        var bool = checkFormQtySign(items,1);
        if(!bool){
            return;
        }
        $(items).each(function (idx, row) {
            $.map(row, function (v, k) {
                data['itemList[' + idx + '].' + k] = v;
            })
        })

        uglcw.ui.confirm('保存后将不能修改，是否确定保存？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkZzcx/save',
                type: 'post',
                data: data,
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('暂存成功');
                        setTimeout(function () {
                            uglcw.ui.replaceCurrentTab('拆分单' + response.id, '${base}manager/stkZzcx/show?billId=' + response.id);
                        }, 1000);
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function auditRk() {
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return
        }
        var billId = $("#billId").val();
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            return uglcw.ui.warning('原料已入库，不能再次入库!');
        }
        if (status == 2) {
            return uglcw.ui.warning('该单据已作废，无法审批!');
        }
        uglcw.ui.get('#grid').commit();

        var data = uglcw.ui.bind('form');

        var products = uglcw.ui.get('#grid').bind();
        if (products.length < 1) {
            return uglcw.ui.error('请添加明细');
        }

        valid = true;
        $(products).each(function (idx, row) {
            if (!checkWare(row.wareId)) {
                uglcw.ui.error('商品[' + row.wareNm + ']未关联原料!不能保存！');
                valid = false;
                return false;
            }
            $.map(row, function (v, k) {
                data['subList[' + idx + '].' + k] = v;
            })
        })
        if (!valid) {
            return;
        }
        var items = uglcw.ui.get('#grid2').bind();
        $(items).each(function (idx, row) {
            $.map(row, function (v, k) {
                data['itemList[' + idx + '].' + k] = v;
            })
        })

        uglcw.ui.confirm('是否确定入库?', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkZzcx/auditRk',
                type: 'post',
                data: data,
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('原料入库成功');
                        setTimeout(function () {
                            uglcw.ui.replaceCurrentTab('拆分单' + billId, '${base}manager/stkZzcx/show?billId=' + billId);
                        }, 1000);
                    } else {
                        uglcw.ui.error(response.msg || '原料入库成功');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function checkWare(wareId) {
        var rows = uglcw.ui.get('#grid2').bind();
        var ok = false;
        $.map(rows, function (row) {
            if (row.relaWareId == wareId) {
                ok = true;
                return false;
            }
        })
        return ok;
    }

    function checkAmount(wareId, amt) {
        var rows = uglcw.ui.get('#grid2').bind();
        var ok = false;
        var totalAmt = 0;
        $.map(rows, function (row) {
            if (row.relaWareId == wareId) {
                totalAmt += row.amt;
            }
        });
        return totalAmt == amt;
    }


    function audit() {//审批
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (status == 1 || status == 0) {
            uglcw.ui.error('单据已审批，不能在审批!');
            return;
        }
        if (status == 2) {
            return uglcw.ui.error('单据已作废，不能在拆卸出库!');
        }

        uglcw.ui.confirm('是否确定拆卸产品出库?确定完成后在点击【原料入库】按钮,关联原料将会进入库存.', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkZzcx/audit',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value()},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('拆卸产品出库成功');
                        setTimeout(function () {
                            uglcw.ui.reload();
                        }, 1000);
                    } else {
                        uglcw.ui.error(response.msg);
                    }
                }
            })

        })
    }

    function cancelClick() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.warning('没有可作废单据');
        }
        var billStatus = uglcw.ui.get('#status').value();
        if (billStatus == 2) {
            return uglcw.ui.error('该单据已作废');
        }
        uglcw.ui.confirm('确定作废吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}/manager/stkZzcx/cancel',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('作废成功');
                        setTimeout(function () {
                            uglcw.ui.reload();
                        }, 1000);
                    } else {
                        uglcw.ui.error(response.msg || '作废失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function getStkWareTplList(relaWareId) {
        var data = uglcw.ui.get('#grid').value();
        $.ajax({
            url: '${base}manager/stkZzcx/getStkWareTplList',
            type: 'post',
            data: {relaWareId: relaWareId},
            dataType: 'json',
            success: function (response) {
                if (response && response.list) {
                    layer.tips('共找到[' + response.list.length + ']个关联原料', '#relate-tab', {
                        tips: 1
                    });
                    $(response.list).each(function (index, row) {
                        row.qty = row.stkQty;
                        delete row['productDate']
                        row.relaWareId = relaWareId;
                        row.price = row.inPrice || 0;
                        row.amt = Number(row.qty * row.price).toFixed(2);
                    })

                    var list = $.map(response.list, function (item) {
                        var hit = {};
                        $(data).each(function (idx, row) {
                            if (row.wareId === relaWareId) {
                                hit = row;
                                row.beUnit = item.relaBeUnit;
                                return false;
                            }
                        })
                        item.id = "";
                        item.relaWareNm = hit.wareNm;
                        return item;
                    })
                    uglcw.ui.get('#grid').bind(data);
                    uglcw.ui.get('#grid').commit();
                    uglcw.ui.get('#grid2').addRow(list, {move: false});
                    // if (list.length > 0) {
                    //     $(".addBtnClass").hide();
                    //     uglcw.ui.get('#grid2').hideColumn('options');
                    // }else{
                    //     $(".addBtnClass").show();
                    //     uglcw.ui.get('#grid2').showColumn('options');
                    // }
                }
            }
        })
    }

    function resetStkWareTplList(relaWareId, qty) {
        qty = qty || 0;
        $.ajax({
            url: '${base}manager/stkZzcx/getStkWareTplList',
            type: 'post',
            data: {relaWareId: relaWareId},
            dataType: 'json',
            success: function (response) {
                if (response && response.list) {
                    var data = uglcw.ui.get('#grid2').k().dataSource.data();
                    $(response.list).each(function (i, row) {
                        $(data).each(function (j, item) {
                            if (item.relaWareId == relaWareId && item.wareId == row.wareId) {
                                var tempQty = parseFloat(qty) * parseFloat(row.stkQty);
                                item.qty = tempQty.toFixed(2);
                            }
                        })
                    })
                    uglcw.ui.get('#grid2').bind(data);
                    uglcw.ui.get('#grid2').commit();
                }
            }
        })
    }
</script>
</body>
</html>
