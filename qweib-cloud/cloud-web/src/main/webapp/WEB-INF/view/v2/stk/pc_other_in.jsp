<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>其他入库</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcu/css/bill-common.css" media="all">
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card master">
        <div class="layui-card-header btn-group">
            <ul uglcw-role="buttongroup">
                <li onclick="add()" data-icon="add" class="k-info" id="btnnew">新建</li>
                <c:if test="${status eq -2}">
                    <li onclick="draftSave()" class="k-info" data-icon="save" id="btndraft">暂存</li>
                </c:if>
                <c:if test="${status eq -2}">
                    <li onclick="audit()" class="k-info" data-icon="track-changes-accept"  id="btndraftaudit" style="display: ${billId eq 0?'none':''}">审批</li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkIn.save')}">
                    <li onclick="submitStk()" class="k-info" data-icon="save"  id="btnsave"  style="display: ${(status eq -2 and billId eq 0)?'':'none'}">保存并审批</li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkIn.shouhuo')}">
                    <li onclick="auditClick()" class="k-info" id="btnaudit" style="display: ${(status eq -2 or billId eq 0 or status eq 1  or status eq 2)?'none':''}">收货</li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkIn.cancel')}">
                    <li onclick="cancelClick()" class="k-error" id="btncancel"  data-icon="delete" style="display: ${billId eq 0 or status eq 2?'none':''}">作废</li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkIn.print')}">
                    <li onclick="toPrint()" class="k-info" id="btnprint" data-icon="print" style="display: ${billId eq 0?'none':''}">打印</li>
                </c:if>
            </ul>
            <div class="bill-info">
            <span class="no" style="color: green;"><span id="billNo" uglcw-model="billNo" style="height: 25px;" uglcw-role="textbox"/>${billNo}</span>
                <span class="status" style="color:red;"><span id="billStatus" style="height: 25px;width: 100px" uglcw-model="billstatus" uglcw-role="textbox">${billstatus}</span>
            </div>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="inType" value="其它入库"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="proType" value="${proType}"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="proId" value="${proId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
                <div class="form-group">
                    <label class="control-label col-xs-3">发货单位</label>
                    <div class="col-xs-4">
                        <input uglcw-role="gridselector" id="proName" uglcw-model="proName" value="${proName}"
                               uglcw-validate="required"
                               uglcw-options="click:function(){
								selectSender();
							}"
                        >
                    </div>
                    <label class="control-label col-xs-3">入库时间</label>
                    <div class="col-xs-4">
                        <input uglcw-validate="required"  id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="inDate" value="${inTime}">
                    </div>
                    <label class="control-label col-xs-3">入库仓库</label>
                    <div class="col-xs-4">
                        <input uglcw-validate="required" uglcw-role="combobox" id="stkId" value="${stkId}"
                               uglcw-options="
                                    url: '${base}manager/queryBaseStorage',
                                    dataTextField: 'stkName',
                                    index: 0,
                                    dataValueField: 'id'"
                               uglcw-model="stkId"/>
                    </div>
                </div>
                <div class="form-group" style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}">
                    <label class="control-label col-xs-3">合计金额</label>
                    <div class="col-xs-4">
                        <input id="totalAmount" uglcw-options="spinners: false, format: 'n2'" uglcw-role="numeric"
                               uglcw-model="totalmt" value="${totalamt}"
                               disabled>
                    </div>
                    <label class="control-label col-xs-3" style="display: none">整单折扣</label>
                    <div class="col-xs-4" style="display:none;">
                        <input id="discount" uglcw-role="numeric" uglcw-model="discount" value="${discount}">
                    </div>
                    <label class="control-label col-xs-3">单据金额</label>
                    <div class="col-xs-4">
                        <input id="discountAmount"
                               uglcw-options="spinners: false, format: 'n2'"
                               uglcw-role="numeric" uglcw-model="disamt" disabled
                               value="${disamt}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                    <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${remarks}</textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options='
                  responsive:[".master",40],
                          id: "id",
                          editable: true,
                          dragable: true,
                          checkbox: false,
                          toolbar: kendo.template($("#toolbar").html()),
                          add: function(row){
                            return uglcw.extend({
                                qty:1,
                                amt: 0,
                                price:0,
                            }, row);
                          },
                          rowNumber:true,
                          navigatable:true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource: gridDataSource
                        '
            >
                <div data-field="wareCode" uglcw-options="
                            width: 100,
                            editable: false
                        ">产品编号
                </div>
                <div data-field="wareNm" uglcw-options="width: 180,
                            schema:{
                                validation:{
                                    required: true,
                                    warecodevalidation:function(input){
                                        input.attr('data-warecodevalidation-msg', '请选择商品');
                                        if(!uglcw.ui.get(input).value()){
                                            uglcw.ui.toast('请选择商品');
                                        }
                                        return true;
                                    }
                                }
                            },
                            editor: function(container, options){
                                var model = options.model;
                                var rowIndex = $(container).closest('tr').index();
                                var cellIndex = $(container).index();
                                var input = $('<input name=\'_wareCode\' data-bind=\'value: wareNm\' placeholder=\'输入商品名称、商品代码、商品条码\' />');
                                input.appendTo(container);
                                $('<span data-for=\'_wareCode\' class=\'k-widget k-tooltip k-tooltip-validation k-invalid-msg\'>请选择商品</span>').appendTo(container);
                                new uglcw.ui.AutoComplete(input).init({
                                    highlightFirst: true,
                                    dataTextField: 'wareNm',
                                    autoWidth: true,
                                    url: '${base}manager/dialogWarePage',
                                     selectable: true,
                                    click: function () {
                                        showProductSelectorForRow(model, rowIndex, cellIndex);
                                    },
                                    data: function(){
                                        return {
                                            page:1, rows: 20,
                                            waretype: '',
                                            stkId: uglcw.ui.get('#stkId').value(),
                                            wareNm: uglcw.ui.get(input).value()
                                        }
                                    },
                                    loadFilter:{
                                        data: function(response){
                                          return response.rows || [];
                                        }
                                    },
                                    template: '<div><span>#= data.wareNm#</span><span style=\'float: right\'>#= data.wareGg#</span></div>',
                                    select: function (e) {
                                        var item = e.dataItem;
                                        var model = options.model;
                                        model.hsNum = item.hsNum;
                                        model.wareCode = item.wareCode;
                                        model.wareGg = item.wareGg;
                                        model.wareNm = item.wareNm;
                                        model.wareDw = item.wareDw;
                                        model.price = item.inPrice;
                                        model.qty = 1;
                                        model.amt = model.price * model.qty;
                                        model.beUnit = item.maxUnitCode;
                                        model.wareId = item.wareId;
                                        model.minUnit = item.minUnit;
                                        model.minUnitCode = item.minUnitCode;
                                        model.maxUnitCode = item.maxUnitCode;
                                        model.productDate = '';
                                        model.amt = parseFloat(model.qty)*parseFloat(model.price);
                                        uglcw.ui.get('#grid').commit();
                                        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
                                    }
                                });
                           }
                ">产品名称
                </div>
                <div data-field="wareGg" uglcw-options="width: 100,editable: false">产品规格</div>
                <div data-field="beUnit" uglcw-options="width: 80,
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
                              dataSource:[
                              { text: model.wareDw, value:model.maxUnitCode },
                              { text: model.minUnit, value:model.minUnitCode}
                              ]
                             })
                            }
                        ">单位
                </div>
                <c:if test="${permission:checkUserFieldPdm('stk.stkIn.lookqty')}">
                    <div data-field="qty" uglcw-options="width: 100,
                            aggregates: ['sum'],
                            schema:{ type: 'number',decimals:10},
                            hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookqty')},
                            footerTemplate: '#= (sum || 0) #'
                    ">入库数量
                    </div>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkIn.lookprice')}">
                    <div data-field="price"
                         uglcw-options="width: 100,
                         hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookprice')},
                         schema:{type:'number',decimals:10}">
                        单价
                    </div>
                </c:if>
                <div data-field="amt" uglcw-options="width: 100,
                            format:'{0:n2}',
                             editable:false,
                             aggregates: ['sum'],
                             hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')},
                            footerTemplate: '#= (sum || 0) #'">入库金额
                </div>
                <div data-field="productDate" uglcw-options="width: 120, format: 'yyyy-MM-dd',
                             schema:{ type: 'date'},
                             editor: function(container, options){
                                var model = options.model;
                                var input = $('<input  data-bind=\'value:productDate\' />');
                                input.appendTo(container);
                                var picker = new uglcw.ui.DatePicker(input);
                                picker.init({
                                    format: 'yyyy-MM-dd',
                                    value: model.productDate ? model.productDate : new Date()
                                });
                                picker.k().open();
                             }
                            ">生产日期
                </div>
             <%--   <div data-field="remarks"
                     uglcw-options="width: 140, editable: true">
                    备注
                </div>--%>
                <div data-field="options" uglcw-options="width: 100, command:'destroy'">操作</div>
            </div>
        </div>
    </div>
</div>
<tag:compositive-selector-template index="0"/>
<tag:product-in-selector-template query="onQueryProduct"/>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:addRow();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-add"></span>增行
    </a>
    <a role="button" href="javascript:showProductSelector()" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-search"></span>批量添加
    </a>
    <a role="button" href="javascript:batchRemove();" class="k-button k-button-icontext k-grid-add-purchase" style="display: none">
        <span class="k-icon k-i-delete"></span>批量删除
    </a>
    <input uglcw-role="autocomplete"
           uglcw-options="
             highlightFirst: true,
             dataTextField: 'wareNm',
             autoWidth: true,
             url: '${base}manager/dialogWarePage',
             data: function(){
                  return {
                    page:1, rows: 20,
                    waretype: '',
                    stkId: uglcw.ui.get('\\#stkId').value(),
                    wareNm: uglcw.ui.get('\\#autocomplete').value()
                }
            },
            loadFilter:{
                  data: function(response){
                   return response.rows || [];
                   }
             },
             change: function(){this.value('')},
             select: function(e){
                var item = e.dataItem.toJSON();
                var grid = uglcw.ui.get('\\#grid');
                item.qty = 1;
                item.price = item.inPrice||'0';
                item.unitName = item.wareDw;
                item.beUnit = item.maxUnitCode;
                item.qty = item.qty || item.stkQty || 1;
                item.amt = parseFloat(item.qty) * parseFloat(item.price);
                grid.addRow(item,{move:false});
             }
            "
           id="autocomplete" class="autocomplete" placeholder="搜索产品..." style="width: 250px;">
    <%--<a role="button" href="javascript:scrollToGridTop();" class="k-button k-button-icontext k-grid-add-purchase">--%>
        <%--<span class="k-icon k-i-arrow-end-up"></span>--%>
    <%--</a>--%>
    <%--<a role="button" href="javascript:scrollToGridBottom();" class="k-button k-button-icontext k-grid-add-purchase">--%>
        <%--<span title="滚动至底部" class="k-icon k-i-arrow-end-down"></span>--%>
    <%--</a>--%>
    <%--<a role="button" href="javascript:saveChanges();" class="k-button k-button-icontext k-grid-add-purchase">--%>
        <%--<span title="滚动至顶部" class="k-icon k-i-check"></span>--%>
    <%--</a>--%>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/biz/erp/util.js?v=20191120"></script>
<script>
    var gridDataSource = ${fns:toJson(warelist)};
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#discount').on('change', calTotalAmount);
        //grid渲染后对toolbar上的控件进行初始化

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
                var commit = false;
                if ((e.field === 'qty' || e.field === 'price')) {
                    item.set('amt', Number((item.qty * item.price).toFixed(2)));
                    commit = true;
                } else if (e.field === 'beUnit') {
                    if (item.beUnit === 'B') {
                        //切换至大单位 价格=小单位单价*转换比例
                        item.set('price', Number(item.price * item.hsNum).toFixed(2));
                    } else if (item.beUnit === 'S') {
                        item.set('price', Number(item.price / item.hsNum).toFixed(2));
                    }
                    commit = true;
                }
                if (commit) {
                    uglcw.ui.get('#grid').commit();
                }
            }
            calTotalAmount();
        });
        isModify=false;
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        uglcw.ui.loaded();
    })
    var isModify=false;
    function add() {
        uglcw.ui.openTab('其他入库开单', '${base}manager/pcotherstkin?r=' + new Date().getTime());
    }

    function selectSender() {
        <tag:compositive-selector-script title="发货单位" callback="onSenderSelect"/>
    }

    function onSenderSelect(id, name, type) {
        uglcw.ui.bind('body', {
            proId: id,
            proName: name,
            proType: type
        })
    }

    function scrollToGridBottom() {
        uglcw.ui.get('#grid').scrollBottom()
    }

    function scrollToGridTop() {
        uglcw.ui.get('#grid').scrollTop()
    }

    function saveChanges() {
        uglcw.ui.get('#grid').commit();
    }

    function calTotalAmount() {
        var ds = uglcw.ui.get('#grid').k().dataSource;
        var data = ds.data().toJSON();
        var total = 0;
        $(data).each(function (idx, item) {
            total += (Number(item.price || 0) * Number(item.qty || 0))
        })
        uglcw.ui.get('#totalAmount').value(total.toFixed(2));
        var discount = uglcw.ui.get('#discount').value() || 0;
        uglcw.ui.get('#discountAmount').value((total - discount).toFixed(2));
    }

    function addRow() {
        uglcw.ui.get('#grid').addRow({
            id: kendo.guid(),
            qty: 1,
            amt: 0,
        });
    }


    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }

    function showProductSelector() {
        if (!uglcw.ui.get('#stkId').value()) {
            return uglcw.ui.error('请选择仓库');
        }
        <tag:product-out-selector-script callback="onProductSelect"/>
    }

    function onQueryProduct(param) {
        param.stkId = uglcw.ui.get('#stkId').value();
        return param;
    }

    /**
     * 产品选择回调
     */
    // function onProductSelect(data) {
    //     if (data) {
    //         $(data).each(function (i, row) {
    //             row.id = uglcw.util.uuid();
    //             row.price = row.inPrice || '0';
    //             row.unitName = row.wareDw;
    //             row.beUnit = row.maxUnitCode;
    //             row.qty = 1;
    //             row.amt = parseFloat(row.qty) * parseFloat(row.price);
    //             row.productDate = '';
    //         })
    //         uglcw.ui.get('#grid').addRow(data);
    //         uglcw.ui.get('#grid').commit();
    //         uglcw.ui.get('#grid').scrollBottom();
    //     }
    // }

    function onProductSelect(data) {
        if (data) {
            if($.isFunction(data.toJSON)){
                data = data.toJSON();
            }
            data = $.map(data, function (item) {
                var row = item;
                if($.isFunction(item.toJSON)){
                    row = item.toJSON();
                }
                row.id = uglcw.util.uuid();
                row.price = row.inPrice || '0';
                row.unitName = row.wareDw;
                row.beUnit = row.maxUnitCode;
                row.qty = 1;
                row.amt = parseFloat(row.qty) * parseFloat(row.price);
                row.productDate = '';
                return row;
            })
            uglcw.ui.get('#grid').addRow(data);
            uglcw.ui.get('#grid').commit();
            uglcw.ui.get('#grid').scrollBottom();
        }
    }


    function draftSave() {//暂存
        uglcw.ui.get('#grid').commit();
        var status = uglcw.ui.get('#status').value();
        if (status != -2) {
            uglcw.ui.warning('单据不在暂存状态，不能保存！')
        }
        if (!uglcw.ui.get('form').validate()) {
            return;
        }
        var data = uglcw.ui.bind('form');
        var proName = uglcw.ui.get("#proName").value();
        var stkId = uglcw.ui.get("#stkId").value();
        var inDate = uglcw.ui.get("#inDate").value();
        if(proName==""){
            return   uglcw.ui.error('请选择发货单位');
        }

        if(inDate==""){
            return   uglcw.ui.error('请选择时间');
        }

        <%--if(${fns:isUseKuwei()}){--%>
            <%--var kwBool = checkStkTemp();--%>
            <%--if(!kwBool){--%>
                <%--uglcw.ui.error('未设置临时仓库，，请<a href=\'javascript:toSetStorage()\'>设置</a>');--%>
                <%--return;--%>
            <%--}--%>
        <%--}--%>
        if(stkId==""){
            return   uglcw.ui.error('请选择仓库');
        }
        var products = uglcw.ui.get('#grid').bind();
        if (products.length < 1) {
            uglcw.ui.error('请选择商品');
            return;
        }
        var bool = checkFormQtySign(products,1);
        if(!bool){
            return;
        }
        products = $.map(products, function (product) {
            product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
            if(product.wareId){
                return product;
            }
        });
        data.id = data.billId;
        data.wareStr = JSON.stringify(products);

        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/dragSaveStkIn',
            type: 'post',
            data: data,
            dataType: 'json',
            success: function (json) {
                if(json.state){
                    uglcw.ui.info('暂存成功');
                    $("#btnsave").hide();
                    $("#btndraftaudit").show();
                    $("#btnprint").show();
                    $("#btncancel").show();
                    $("#btnaudit").hide();
                    uglcw.ui.get('#billStatus').value("暂存成功");
                    uglcw.ui.get('#billId').value(json.id);
                    uglcw.ui.get('#billNo').value(json.billNo);

                }
                isModify=false;
                uglcw.ui.loaded();
            },
            error: function () {
                uglcw.ui.loaded();
            }
        })
    }

    function submitStk() {//提交
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var proName = uglcw.ui.get("#proName").value();
        var stkId = uglcw.ui.get("#stkId").value();
        var inDate = uglcw.ui.get("#inDate").value();
        if(proName==""){
            return   uglcw.ui.error('请选择发货单位');
        }

        if(inDate==""){
            return   uglcw.ui.error('请选择时间');
        }
        <%--if(${fns:isUseKuwei()}){--%>
            <%--var kwBool = checkStkTemp();--%>
            <%--if(!kwBool){--%>
                <%--uglcw.ui.error('未设置临时仓库，，请<a href=\'javascript:toSetStorage()\'>设置</a>');--%>
                <%--return;--%>
            <%--}--%>
        <%--}--%>
        if(stkId==""){
            return   uglcw.ui.error('请选择仓库');
        }
        var form = uglcw.ui.bind('form');
        form.id = form.billId;
        var products = uglcw.ui.get('#grid').bind();
        if (products.length < 1) {
            uglcw.ui.error('请选择商品');
            return;
        }
        var bool = checkFormQtySign(products,1);
        if(!bool){
            return;
        }
        products = $.map(products, function (product) {
            product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
            if (product.wareId) {
                return product;
            }
        });
        form.wareStr = JSON.stringify(products);
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/addStkIn',
            type: 'post',
            dataType: 'json',
            data: form,
            success: function (json) {
                if(json.state){
                    uglcw.ui.info('提交成功');
                    uglcw.ui.get('#billStatus').value('提交成功');
                    uglcw.ui.get("#status").value(0);
                    uglcw.ui.get("#billId").value(json.id);
                    uglcw.ui.get("#billNo").value(json.billNo);
                    $("#btndraft").hide();
                    $("#btndraftaudit").hide();
                    $("#btnsave").hide();
                    $("#btnprint").show();
                    $("#btncancel").show();
                    $("#btnaudit").show();
                    if(json.autoSend==1){
                        $("#btnaudit").hide();
                    }
                    isModify = false;
                }
                else
                {
                    uglcw.ui.error(json.msg);
                }
                uglcw.ui.loaded();
                isModify=false;
            },
            error: function () {
                uglcw.ui.loaded()
            }
        })

    }

    function audit() {
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (status == 0) {
            uglcw.ui.error('该单据已审核');
            return;
        }
        if (billId == 0 || status != -2) {
            uglcw.ui.error('单据已作废，不能审批！');
            return;
        }
        if (status == 2) {
            uglcw.ui.error('单据已作废，不能审批');
            return;
        }

        uglcw.ui.confirm('是否确定审核？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/auditDraftStkIn',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value()},
                dataType: 'json',
                success: function (json) {
                    if(json.state){
                        uglcw.ui.info('审批成功');
                        uglcw.ui.get('#billStatus').value('审批成功');
                        uglcw.ui.get("#status").value(0);
                        $("#btndraft").hide();
                        $("#btndraftaudit").hide();
                        $("#btnsave").hide();
                        $("#btnprint").show();
                        $("#btncancel").show();
                        $("#btnaudit").show();
                        if(json.autoSend==1){
                            $("#btnaudit").hide();
                        }
                        isModify=false;
                    }
                    else
                    {
                        uglcw.ui.error('审核失败!');
                        //$.messager.alert('消息','审核失败','info');
                    }
                    uglcw.ui.loaded();
                }
            })

        })
    }

    function toPrint() {
        var status = $("#status").val();
        if(status == 2)
        {
            //alert("单据已经作废");
            //return uglcw.ui.warning('没有可作废单据');
        }
        var billId = $("#billId").val();
        if(billId == 0)
        {
            return  uglcw.ui.warning('没有可打印的单据');
        }
        if(status==-2&&isModify){
            return  uglcw.ui.warning('单据已修改，请先暂存');
        }
        top.layui.index.openTabsPage('${base}manager/showstkinprint?billId=' + billId + '&fromFlag=0', '其他入库打印');
    }

    function cancelClick() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.warning('没有可作废单据');
        }
        var status = uglcw.ui.get('#status').value();
        if (status == 2) {
            return uglcw.ui.error('该单据已作废');
        }
        uglcw.ui.confirm('确定作废吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}/manager/cancelProc',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.info('作废成功');
                        uglcw.ui.get('#billStatus').value('作废成功');
                        uglcw.ui.get('#status').value(2);
                        $("#btndraft").hide();
                        $("#btndraftaudit").hide();
                        $("#btnsave").hide();
                        $("#btnprint").show();
                        $("#btncancel").hide();
                        $("#btnaudit").hide();
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

    function auditClick() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.info('请先保存');
        }
        var status = uglcw.ui.get('#status').value();
        if(status == -2){
            return uglcw.ui.warning('该单据未审批');
        }
        if (status == 1) {
            return uglcw.ui.warning('该单据已收货');
        }
        if (status == 2) {
            return uglcw.ui.warning('该单据已作废');
        }
        auditProc(billId);
    }

    function auditProc(billId) {
        uglcw.ui.openTab('其他入库收货' + billId, '${base}manager/showstkincheck?dataTp=1&billId=' + billId);
    }
    /**
     * 行内挑选框
     */
    var model, rowIndex, cellIndex;

    function showProductSelectorForRow(m, r, c) {
        model = m;
        rowIndex = r;
        cellIndex = c;
        <tag:product-out-selector-script checkbox="false" callback="onProductSelect2"/>
    }

    function onProductSelect2(data) {
        if (!data || data.length < 1) {
            return;
        }
        var item = data[0];
        model.hsNum = item.hsNum;
        model.wareCode = item.wareCode;
        model.wareGg = item.wareGg;
        model.wareNm = item.wareNm;
        model.wareDw = item.wareDw;
        model.price = item.inPrice;
        model.qty = 1;
        model.sunitFront = item.sunitFront;
        model.beUnit = item.maxUnitCode;
        model.wareId = item.wareId;
        model.minUnit = item.minUnit;
        model.minUnitCode = item.minUnitCode;
        model.maxUnitCode = item.maxUnitCode;
        model.productDate = '';
        item.unitName = item.wareDw;
        model.amt = model.price * model.qty;
        uglcw.ui.get('#grid').commit();
        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
    }

</script>
</body>
</html>
