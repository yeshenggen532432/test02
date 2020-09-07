<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>车销配货</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-search input, select {
            height: 30px;
        }

        .layui-card-header.btn-group {
            padding-left: 0px;
            line-height: inherit;
            height: inherit;
        }

        .dropdown-header {
            border-width: 0 0 1px 0;
            text-transform: uppercase;
        }

        .dropdown-header > span {
            display: inline-block;
            padding: 10px;
        }

        .dropdown-header > span:first-child {
            width: 50px;
        }

        .k-list-container > .k-footer {
            padding: 10px;
        }

        .k-grid .k-command-cell .k-button {
            padding-top: 2px;
            padding-bottom: 2px;
        }

        .k-grid tbody tr {
            cursor: move;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card master">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <li onclick="add()" data-icon="add" class="k-info">新建</li>
                        <c:if test="${permission:checkUserFieldPdm('stk.stkMove.save') and stkMove.status eq -2}">
                            <li onclick="drageSave()" id="btndraft" class="k-info" data-icon="save">暂存</li>
                        </c:if>
                        <c:if test="${permission:checkUserFieldPdm('stk.stkMove.audit')}">
                            <li onclick="audit()" id="btnaudit" class="k-info" data-icon="track-changes-accept" style="display: ${(stkMove.id ne 0 and stkMove.status eq -2)?'':'none'}">审批</li>
                        </c:if>
                        <c:if test="${permission:checkUserFieldPdm('stk.stkMove.cancel')}">
                            <li onclick="cancel()" id="btncancel" class="k-info" data-icon="delete" style="display: ${stkMove.id eq 0 or stkMove.status eq 2?'none':''}">作废</li>
                        </c:if>
                        <c:if test="${stkMove.status ne -2 }">
                            <c:if test="${permission:checkUserFieldPdm('stk.stkMove.print')}">
                                <li onclick="toPrint()" id="btnprict" class="k-info" data-icon="print" style="display: ${stkMove.id eq 0?'none':''}">打印</li>
                            </c:if>
                        </c:if>
                    </ul>
                    <div class="bill-info">
                        <div class="no" style="color:green;"><input id="billNo" uglcw-model="billNo" style="height: 25px;" readonly  uglcw-role="textbox" value="${stkMove.billNo}"/></div>
                        <div class="status"  style="color:red;">
                            <c:choose>
                                <c:when test="${stkMove.status eq -2 and not empty stkMove.id and stkMove.id ne 0}"><input id="billStatus" style="height: 25px;width: 80px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="暂存"></c:when>
                                <c:when test="${stkMove.status eq 1}"><input id="billStatus" style="height: 25px;width: 80px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="已审批"></c:when>
                                <c:when test="${stkMove.status eq 2}"><input id="billStatus" style="height: 25px;width: 80px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="已作废"></c:when>
                                <c:otherwise>
                                    <input id="billStatus" style="height: 25px;width: 80px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="新建">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="${stkMove.id}"/>
                        <input type="hidden" uglcw-model="billType" uglcw-role="textbox" id="billType" value="${stkMove.billType}"/>
                        <input type="hidden" uglcw-model="bizType" uglcw-role="textbox" id="bizType"
                               value="${stkMove.bizType}"/>
                        <input type="hidden" uglcw-model="proName" uglcw-role="textbox" id="proName"
                               value="${stkMove.proName}"/>
                        <input type="hidden" uglcw-model="proId" uglcw-role="textbox" id="proId" value="${stkMove.proId}"/>
                        <input type="hidden" uglcw-model="proType" uglcw-role="textbox" id="proType"
                               value="${stkMove.proType}"/>
                        <input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status"
                               value="${stkMove.status}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-5 col-md-3">单据时间</label>
                            <div class="col-xs-7 col-md-4">
                                <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                                       uglcw-model="inDate" value="${stkMove.inDate}">
                            </div>
                            <label class="control-label col-xs-5 col-md-3">出库仓库</label>
                            <div class="col-xs-7 col-md-4">
                                <tag:select2 validate="required" name="stkId,stkName" id="stkId" tclass="pcl_sel"
                                             tableName="stk_storage"
                                             value="${stkMove.stkId }" headerKey="" headerValue="--请选择--"
                                             displayKey="id" displayValue="stk_name"/>
                            </div>
                            <label class="control-label col-xs-5 col-md-3">车销仓库</label>
                            <div class="col-xs-7 col-md-4">
                                       <tag:select2 validate="required" name="stkInId,stkInName" id="stkInId" tclass="pcl_sel"
                                                    tableName="stk_storage"
                                                    whereBlock="sale_car=1"
                                                    value="${stkMove.stkInId }" headerKey="" headerValue="--请选择--"
                                                    displayKey="id" displayValue="stk_name"/>

                            </div>
                        </div>
                        <div class="form-group" style="display: none;">
                            <label class="control-label col-md-3">合计金额</label>
                            <div class="col-md-4">
                                <input id="totalAmt" uglcw-model="totalAmt" uglcw-role="numeric" value="${stkMove.totalAmt}"
                                       readonly>
                            </div>
                            <label class="control-label col-md-3">配货金额</label>
                            <div class="col-md-4">
                                <input id="disAmt" uglcw-model="disAmt" uglcw-role="numeric" value="${stkMove.disAmt}"
                                       readonly>
                                <input id="discount" type="hidden" uglcw-role="numeric" uglcw-model="discount"
                                       value="${stkMove.discount}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${stkMove.remarks}</textarea>
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
                          rowNumber: true,
                          checkbox: false,
                          add: function(row){
                          return uglcw.extend({
                                inTypeCode: 10001,
                                qty:1,
                                amt: 0,
                                price: 0
                            }, row);
                          },
                          editable: true,
                          dragable: true,
                          toolbar: kendo.template($("#toolbar").html()),
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource:${fns:toJson(stkMove.list)}
                        '
                    >
                        <div data-field="wareCode" uglcw-options="
                                 width: 120,
                                 editable: false,
                            ">产品编号
                        </div>
                        <div data-field="wareNm" uglcw-options="width: 200,
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
                                    dataTextField: 'wareNm',
                                    autoWidth: true,
                                    selectable: true,
                                    click: function () {
                                        showProductSelectorForRow(model, rowIndex, cellIndex);
                                    },
                                    url: '${base}manager/dialogWarePage',
                                    data: function(){
                                      var stkId= uglcw.ui.get('#stkId').value();
                                      if(stkId == ''){
                                      return uglcw.ui.warning('请选择出库仓库');
                                      }
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
                                    template: '<div><span>#= data.wareNm#</span><span class=\'float: right\'>#data.wareGg#</span></div>',
                                    select: function (e) {
                                        var item = e.dataItem;
                                        var model = options.model;
                                        model.wareCode = item.wareCode;
                                        model.wareGg = item.wareGg;
                                        model.wareNm = item.wareNm;
                                        model.wareDw = item.wareDw;
                                        model.price = item.inPrice;
                                        model.qty = 1;
                                        model.beUnit = item.maxUnitCode;
                                        model.wareId = item.wareId;
                                        model.minUnit = item.minUnit;
                                        model.minUnitCode = item.minUnitCode;
                                        model.maxUnitCode = item.maxUnitCode;
                                        model.amt = parseFloat(model.qty)*parseFloat(model.price);
                                        uglcw.ui.get('#grid').commit();
                                        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
                                    }
                                });
                           }
                        ">产品名称
                        </div>
                        <div data-field="wareGg" uglcw-options="width: 120, editable: false">产品规格</div>
                        <div data-field="beUnit" uglcw-options="width: 100,
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
                        <div data-field="qty" uglcw-options="width: 100,
                            aggregates: ['sum'],
                            schema:{ type: 'number',decimals:10},
                            footerTemplate: '#= (sum || 0) #'
                    ">配货数量
                        </div>
                        <div data-field="price"
                             uglcw-options="width: 100, hidden: true, schema:{ type:'number',decimals:10,}">
                            单价
                        </div>
                        <div data-field="amt" uglcw-options="width: 100,
                            schema:{editable: true},
                            hidden: true,
                            aggregates: ['sum'],
                            editor: function(container, options){ $('<span>'+options.model.amt+'</span>').appendTo(container)},
                            footerTemplate: '#= (sum || 0) #'">配货金额
                        </div>
                        <div data-field="productDate" uglcw-options="
                             width: 120,
                             template: uglcw.util.template($('\\#product-date-tpl').html()),
                             editor: productDateEditor,
                             attributes: {class: 'cell-product-date'},
                             headerAttributes:{
                                'data-intro': '点击[关联]可以选中具体批次的商品生产日期，</p><p>且该批次生产日期的商品将会被占用'
                             }
                            ">生产日期
                        </div>
                        <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:addRow();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-add"></span>增行
    </a>
    <a role="button" href="javascript:showProductSelector()" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-search"></span>批量添加
    </a>
    <%--
    <a role="button" href="javascript:batchRemove();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-delete"></span>批量删除
    </a>
    --%>
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
   <%--
    <a role="button" href="javascript:scrollToGridTop();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-arrow-end-up"></span>
    </a>
    <a role="button" href="javascript:scrollToGridBottom();" class="k-button k-button-icontext k-grid-add-purchase">
        <span title="滚动至底部" class="k-icon k-i-arrow-end-down"></span>
    </a>
    <a role="button" href="javascript:saveChanges();" class="k-button k-button-icontext k-grid-add-purchase">
        <span title="滚动至顶部" class="k-icon k-i-check"></span>
    </a>
    --%>
</script>

<script type="text/x-uglcw-template" id="product-date-tpl">
    <div class="product-code">
        <span>#= data.productDate || ''#</span>
        # if(data.wareId) {#
        <span onclick="showRelatedProductDate(this)" class="product-date-tooltip"
              style="font-weight: bold;color: \\#1c77f0;">关联</span>
        #}#
    </div>
</script>

<%--<script type="text/x-uglcw-template" id="autocomplete-template">
    <span class="k-state-default"
          style="background-image: url('#: data.warePicList.length > 0 ? 'upload/'+data.warePicList[0].picMini: '' #')"></span>
    <span class="k-state-default"><h3>#: data.wareNm #</h3><p>#: data.wareCode # #: data.wareGg#</p></span>
</script>--%>
<%--<script type="text/x-uglcw-template" id="autocomplete-header-template">

</script>
<script type="text/x-uglcw-template" id="autocomplete-footer-template">
    共匹配 #: instance.dataSource.data().length #项商品
</script>--%>
<tag:product-in-selector-template query="onQueryProduct"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/biz/erp/util.js?v=20191120"></script>

<script>
    $(function () {
        uglcw.ui.init();

        <c:if test="${stkMove.inDate == null}">
        uglcw.ui.get('#inDate').value(new Date());
        </c:if>

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
                if ((e.field === 'qty' || e.field === 'price')) {
                    item.set('amt', Number((item.qty * item.price).toFixed(2)));
                } else if (e.field === 'beUnit') {
                    if (item.beUnit === 'B') {
                        //切换至大单位 价格=小单位单价*转换比例
                        item.set('price', Number(item.price * item.hsNum).toFixed(2));
                    } else if (item.beUnit === 'S') {
                        item.set('price', Number(item.price / item.hsNum).toFixed(2));
                    }
                }
                uglcw.ui.get('#grid').commit();
            }
            calTotalAmount();
        })
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        uglcw.ui.loaded();
    });

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

                // "price": json.list[i].wareDj,
                //     "sunitFront": json.list[i].sunitFront,
                //     "sunitPrice":json.list[i].sunitPrice,

                row.id = uglcw.util.uuid();
                row.price = row.wareDj || '0';
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

    /**
     * 产品选择回调
     */
    // function onProductSelect(data) {
    //     if (data) {
    //         $(data).each(function (i, row) {
    //             row.qty = 1;
    //             row.price = row.inPrice || '0';
    //             row.unitName = row.wareDw;
    //             row.beUnit = row.maxUnitCode;
    //             row.qty = row.qty || row.stkQty || 1;
    //             row.amt = parseFloat(row.qty) * parseFloat(row.price);
    //             row.productDate = '';
    //         })
    //         uglcw.ui.get('#grid').addRow(data);
    //         uglcw.ui.get('#grid').commit();
    //         uglcw.ui.get('#grid').scrollBottom();
    //     }
    // }

    function add() {
        uglcw.ui.openTab('移库开单', '${base}manager/stkMove/add?billType=1&billId=0&r=' + new Date().getTime());
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
        uglcw.ui.get('#totalAmt').value(total);
        var discount = uglcw.ui.get('#discount').value();
        uglcw.ui.get('#disAmt').value(total - discount);
    }

    function addRow() {
        uglcw.ui.get('#grid').addRow({
        });
    }


    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }
/*
    function showProductSelector() {
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择出库仓库！');
        }
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                url: '${base}manager/companyWaretypes',
                model: 'waretype',
                id: 'id'
            },
            width: 900,
            id: 'wareId',
            pageable: true,
            url: '${base}manager/dialogWarePage',
            query: function (params) {
                params.stkId = uglcw.ui.get('#stkId').value()
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
                        row.qty = 1;
                        row.price = row.inPrice || '0';
                        row.unitName = row.wareDw;
                        row.beUnit = row.maxUnitCode;
                        row.qty = row.qty || row.stkQty || 1;
                        row.amt = parseFloat(row.qty) * parseFloat(row.price);
                    })
                    uglcw.ui.get('#grid').addRow(data);
                    uglcw.ui.get('#grid').scrollBottom();
                }
            }
        })
    }*/

    function drageSave() {//暂存
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');

        var status = form.status;
        if (status == 1) {
            return uglcw.ui.error('该单据已审批，不能保存！');
        }
        if (status == 2) {
            return uglcw.ui.error('该单据已作废，不能保存!')
        }
        if (form.stkId == form.stkInId) {
            return uglcw.ui.error('出入仓库不能相同！');
        }
        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 1) {
            return uglcw.ui.error('请添加明细');
        }

        var bool = checkFormQtySign(list,1);
        if(!bool){
            return;
        }

        $(list).each(function (idx, item) {
            //delete item['productDate'];
            delete item['id']
            $.map(item, function (v, k) {
                form['list[' + idx + '].' + k] = v;
            })
        });
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/stkMove/save',
            type: 'post',
            dataType: 'json',
            data: form,
            success: function (response) {
                uglcw.ui.loaded();
                if (response.state) {
                    uglcw.ui.info('暂存成功');
                    uglcw.ui.get('#billStatus').value("暂存成功");
                    uglcw.ui.get('#billId').value(response.id);
                    uglcw.ui.get('#billNo').value(response.billNo);
                    $("#btnprint").show();
                    $("#btncancel").show();
                    $("#btnaudit").show();
                    //uglcw.ui.success('暂存成功');
                    //uglcw.ui.replaceCurrentTab('移库信息' + response.id, '${base}manager/stkMove/show?billId=' + response.id)
                } else {
                    uglcw.ui.error(response);
                }
            },
            error: function () {
                uglcw.ui.loaded()
            }
        })

    }

    function audit() {//审批
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            uglcw.ui.error('单据已审批，不能在审批!');
            return;
        }
        if (status == 2) {
            uglcw.ui.error('发票已作废，不能在审批');
            return;
        }
        //
        // if(!billId){
        //     return uglcw.ui.warning('单据已修改，请先保存!');
        // }
        uglcw.ui.confirm('是否确定审批？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkMove/audit',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value()},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('审批成功');
                        uglcw.ui.get('#status').value(1);
                        uglcw.ui.get('#billStatus').value("审批成功");
                        $("#btndraft").hide();
                        $("#btncancel").show();
                        $("#btnaudit").hide();

                    } else {
                        uglcw.ui.warning(response.msg || '操作失败');
                    }
                }
            })

        })
    }

    function toPrint() {

        var billId = uglcw.ui.get("#billId").value();
        uglcw.ui.openTab('打印车销配货${stkMove.id}', '${base}manager/stkMove/print?billId=' + billId);
    }

    function cancel() {
        var billId = uglcw.ui.get('#billId').value();
        if (!billId) {
            return uglcw.ui.warning('请先保存');
        }
        var billStatus = uglcw.ui.get('#status').value();
        if (billStatus == 2) {
            return uglcw.ui.error('该单据已作废');
        }
        uglcw.ui.confirm('确定作废吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkMove/cancel',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('作废成功');
                        uglcw.ui.get('#billStatus').value('作废成功');
                        uglcw.ui.get("#status").value(2);
                        $("#btndraft").hide();
                        $("#btnprint").hide();
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

    /**
     * 显示关联生产日期
     */
    function showRelatedProductDate(el) {
        event.stopPropagation();
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.warning('请选择仓库');
        }
        var row = uglcw.ui.get('#grid').k().dataItem($(el).closest('tr'));
        if (!row.wareId) {
            return uglcw.ui.warning('请选择商品');
        }
        uglcw.ui.Modal.showGridSelector({
            title: '商品生产日期',
            area: ['600px', '300px'],
            btns: false,
            url: '${base}manager/dialogWareBatchPage',
            query: function (params) {
                params.stkId = stkId;
                params.wareId = row.wareId;
                return params;
            },
            columns: [
                {title: '商品名称', field: 'wareNm', width: 120, tooltip: true},
                {title: '单位', field: 'unitName', width: 70},
                {title: '数量', field: 'qty', width: 70, format: '{0:n2}'},
                {title: '生产日期', field: 'productDate', width: 120}
            ],
            yes: function (data) {
                if (data && data.length > 0) {
                    var r = data[0];
                    row.set("productDate", r.productDate);
                }
            }
        })
    }

    //表格中生产日期编辑器
    function productDateEditor(container, options) {
        var model = options.model;
        var input = $('<input uglcw-role="combobox"  />');
        input.appendTo(container);
        var picker = new uglcw.ui.DatePicker(input);
        picker.init({
            format: 'yyyy-MM-dd',
            value: model.productDate ? model.productDate : null,
            change: function () {
                model.productDate = picker.value();
                model.dirty = true;
                model.sswId = "";
                //checkProductDate();
                $(container).closest('tr').find('td.cell-product-date').removeClass('produce-date-related')
            },
            select: function () {
                uglcw.ui.toast('selected')
            }
        });
        picker.k().open();
    }
</script>
</body>
</html>
