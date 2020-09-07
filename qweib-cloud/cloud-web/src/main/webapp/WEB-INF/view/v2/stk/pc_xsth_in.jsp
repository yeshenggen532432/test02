<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售退货编辑页</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcu/css/bill-common.css" media="all">
    <style>
        .price {
            margin-left: 10px;
        }
    </style>
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
                    <c:if test="${permission:checkUserFieldPdm('stk.stkThIn.audit')}">
                    <li onclick="audit()" class="k-info" data-icon="track-changes-accept" id="btndraftaudit"
                        style="display: ${billId eq 0?'none':''}">审批
                    </li>
                    </c:if>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkThIn.save')}">
                    <li onclick="submitStk()" class="k-info" data-icon="save" id="btnsave"
                        style="display: ${(status eq -2 and billId eq 0)?'':'none'}">保存并审批
                    </li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkThIn.shouhuo')}">
                    <li onclick="auditClick()" class="k-info" id="btnaudit"
                        style="display: ${(status eq -2 or billId eq 0 or status eq 1 or status eq 2)?'none':''}">收货
                    </li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkThIn.cancel')}">
                    <li onclick="cancelClick()" id="btncancel" class="k-error" data-icon="delete"
                        style="display: ${billId eq 0 or status eq 2?'none':''}">作废
                    </li>
                </c:if>
                <c:if test="${status eq 0 or status eq 1}">
                    <c:if test="${permission:checkUserFieldPdm('stk.stkThIn.reaudit')}">
                    <li onclick="reAudit()" data-icon="undo"
                        style="display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_XSTH_AUTO_REAUDIT\'  and status=1')}">
                        反审批
                    </li>
                    </c:if>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkThIn.print')}">
                    <li onclick="toPrint()" id="btnprint" data-icon="print" style="display: ${billId eq 0?'none':''}">
                        打印
                    </li>
                </c:if>
            </ul>


            <div class="bill-info">
                <span id="billNo" uglcw-model="billNo" style="width: 200px;color:green;height: 25px;"
                      uglcw-role="textbox">${billNo}</span>
                <span class="status" style="color:red;"><span id="billStatus" style="height: 25px;width: 80px"
                                                              uglcw-model="billstatus" uglcw-role="textbox"
                >${billstatus}</span></span>&nbsp;&nbsp;
                <c:if test="${not empty verList}">
                    <a uglcw-role="tooltip" uglcw-options="
                        autoHide: false,
                        content: $('#billVersion').html(),
                        position: 'bottom'
                    ">查看反审批版本</a>
                </c:if>

            </div>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="${billId}"/>
                <input type="hidden" uglcw-model="orderId" uglcw-role="textbox" id="orderId" value="${orderId}"/>
                <input type="hidden" uglcw-model="proType" uglcw-role="textbox" id="proType" value="${proType}"/>
                <input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status" value="${status}"/>
                <input type="hidden" uglcw-model="isSUnitPrice" uglcw-role="textbox" id="isSUnitPrice"
                       value="${isSUnitPrice}">
                <div class="form-group">
                    <label class="control-label col-xs-3">退货单位</label>
                    <div class="col-xs-4">
                        <input type="hidden" id="proId" uglcw-model="proId" uglcw-role="textbox" value="${proId}"/>
                        <input uglcw-role="gridselector" id="proName" uglcw-model="proName" value="${proName}"
                               uglcw-validate="required"
                               uglcw-options="click:function(){
								selectSender();
							}"
                        >
                    </div>
                    <label class="control-label col-xs-3">退货时间</label>
                    <div class="col-xs-4">
                        <input uglcw-validate="required" uglcw-role="datetimepicker" id="inDate" value="${inTime}"
                               uglcw-model="inDate"
                               uglcw-options="format:'yyyy-MM-dd HH:mm'">
                    </div>
                    <label class="control-label col-xs-5 col-xs-3">入库仓库</label>
                    <div class="col-xs-7 col-xs-4">

                        <input uglcw-validate="required" uglcw-role="combobox" id="stkId" value="${stkId}"
                               uglcw-options="
                                    url: '${base}manager/queryBaseStorage',
                                    dataTextField: 'stkName',
                                    index: 0,
                                    dataValueField: 'id'"
                               uglcw-model="stkId"/>

                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">业&nbsp;&nbsp;务&nbsp;&nbsp;员</label>
                    <div class="col-xs-4">
                        <input type="hidden" id="empId" uglcw-model="empId" uglcw-role="textbox" value="${empId}"/>
                        <input id="salesman" uglcw-role="gridselector" uglcw-model="empNm" value="${empNm}"
                               uglcw-options="click: selectEmployee"
                        />
                    </div>
                    <label class="control-label col-xs-3">车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辆</label>
                    <div class="col-xs-4">
                        <tag:select2 name="vehId,vehNo" id="vehId" tclass="pcl_sel" value="${vehId}"
                                     headerKey="" headerValue="" tableName="stk_vehicle" displayKey="id"
                                     displayValue="veh_no"/>
                    </div>
                    <label class="control-label col-xs-3">司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机</label>
                    <div class="col-xs-4">
                        <tag:select2 name="driverId,driverName" id="driverId" tclass="pcl_sel"
                                     value="${driverId }" headerKey="" headerValue="" tableName="stk_driver"
                                     displayKey="id" displayValue="driver_name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">合计金额</label>
                    <div class="col-xs-4">
                        <input id="totalAmt" uglcw-model="totalamt" uglcw-role="numeric" value="${totalamt}"
                               readonly>
                    </div>
                    <label class="control-label col-xs-3" style="display: none">折扣金额</label>
                    <div class="col-xs-4" style="display: none">
                        <input id="discount" uglcw-model="discount" uglcw-role="numeric" value="${discount}">
                    </div>
                    <label class="control-label col-xs-3">单据金额</label>
                    <div class="col-xs-4">
                        <input id="disAmt" uglcw-model="disamt" uglcw-role="numeric" value="${disamt}"
                               readonly>
                    </div>
                    <label class="control-label col-xs-3">订&nbsp;&nbsp;单&nbsp;&nbsp;号</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="orderNo" readonly="readonly" value="${orderNo}"/>
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
            <div id="grid" uglcw-role="grid-advanced"
                 uglcw-options='
                          responsive:[".master",40],
                          id: "id",
                          lockable: false,
                          rowNumber: true,
                          checkbox: false,
                          add: function(row){
                            return uglcw.extend({
                                qty:1,
                                amt: 0,
                                price:0
                            }, row);
                          },
                          speedy:{
                            className: "uglcw-cell-speedy"
                          },
                          editable: true,
                          draggable: true,
                          toolbar: uglcw.util.template($("#toolbar").html()),
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource: gridDataSource
                        '
            >
                <div data-field="wareCode" uglcw-options="
                            width: 120,
                            editable: false,
                        ">产品编号
                </div>
                <div data-field="wareNm" uglcw-options="width: 200,
                        attributes: {class: 'uglcw-cell-speedy'},
                        schema:{
                                validation:{
                                    required: true,
                                    warenmvalidation:function(input){
                                        if(input.is('[data-model=wareNm]')){
                                            input.closest('td').find('.warenmvalidation').attr('data-warenmvalidation-msg', '请选择商品');
                                            var row = uglcw.ui.get('\\#grid').k().dataItem(input.closest('tr'));
                                            if(!row.wareId){
                                                  var k = layer.tips('请选择商品', $(input.closest('td')), {
                                                        maxWidth: 300,
                                                        tips: 1
                                                  });
                                                  setTimeout(function(){
                                                      layer.close(k)
                                                  }, 1000)
                                                return true
                                            }
                                            return true;
                                        }
                                        return true;
                                    }
                                }
                            },
                            editor: function(container, options){
                                var grid = uglcw.ui.get('#grid');
                                var model =options.model;
                                var rowIndex = $(container).closest('tr').index();
                                var cellIndex = $(container).index();
                                var input = $('<input data-model=\'wareNm\' placeholder=\'输入商品名称、商品代码、商品条码\' />');
                                input.appendTo(container);
                                new uglcw.ui.AutoComplete(input).init({
                                    dataTextField: 'wareNm',
                                    autoWidth: true,
                                    selectable: true,
                                    value: model.wareNm,
                                    click: function () {
                                        showProductSelectorForRow(model, rowIndex, cellIndex);
                                    },
                                    url: '${base}manager/dialogWarePage',
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
                                    template: '<div><span>#= data.wareNm#</span><span class=\'float: right\'>#data.wareGg#</span></div>',
                                    select: function (e) {
                                        var item = e.dataItem;
                                        var model = options.model;
                                        model.hsNum = item.hsNum;
                                        model.wareCode = item.wareCode;
                                        model.wareGg = item.wareGg;
                                        model.wareNm = item.wareNm;
                                        model.wareDw = item.wareDw;
                                        model.sunitFront = item.sunitFront;
                                        model.qty = 1;
                                        model.wareId = item.wareId;
                                        model.minUnit = item.minUnit;
                                        model.minUnitCode = item.minUnitCode;
                                        model.maxUnitCode = item.maxUnitCode;
                                        loadProductInfo(model, function(payload){
                                            setPrice(model, payload);
                                        }, true);
                                         model.amt = parseFloat(model.qty)*parseFloat(model.price);
                                        setUnit(model)
                                        calTotalAmount();
                                        kendoFastReDrawRow(grid.k(), $(container).closest('tr'));
                                        this.close();
                                        uglcw.ui.get('#grid').commit();
                                        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex-1);
                                    }
                                });
                           }">产品名称
                </div>

                <div data-field="wareGg" uglcw-options="width: 100,editable:false">产品规格</div>
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
                             var dataSource = [];
                             if(model.wareDw){
                                dataSource.push({ text: model.wareDw, value:model.maxUnitCode });
                             }
                             if(model.minUnit){
                                dataSource.push({ text: model.minUnit, value:model.minUnitCode});
                             }
                             widget.init({
                              dataSource: dataSource
                             })
                            }
                        ">单位
                </div>
                <div data-field="qty" uglcw-options="width: 100,
                            aggregates: ['sum'],
                            attributes: {class: 'uglcw-cell-speedy'},
                            schema:{ type: 'number',decimals:10},
                            footerTemplate: '#= (sum || 0) #'
                    ">退货数量
                </div>
                <div data-field="price"
                     uglcw-options="width: 100,
                      attributes: {class: 'uglcw-cell-speedy'},
                      schema:{type:'number',decimals:10}">
                    退货单价
                </div>
                <div data-field="amt" uglcw-options="width: 100,
                            attributes: {class: 'k-dirty-cell'},
                            editor: amtEditor,
                            aggregates: ['sum'],
                            footerTemplate: '#= uglcw.util.toString((sum || 0),\'n2\') #'">退货金额
                </div>
                <div data-field="productDate" uglcw-options="width: 120,format: 'yyyy-MM-dd',
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
                             }">生产日期
                </div>
                <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
            </div>
        </div>
    </div>
</div>
<tag:compositive-selector-template index="2"/>
<tag:product-out-selector-template query="onQueryProduct"/>

<script id="billVersion" type="text/x-uglcw-template">
    <c:if test="${not empty verList}">
        <div style="display: grid; color: #fff;">
            <c:forEach items="${verList}" var="ver" varStatus="s">
                <span style="cursor: pointer;" onclick="showVersion(${ver.id})">${ver.relaTime}</span>
            </c:forEach>
        </div>

    </c:if>
</script>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:addRow();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-add"></span>增行
    </a>
    <a role="button" href="javascript:showProductSelector()" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-search"></span>批量添加
    </a>
    <a role="button" href="javascript:batchRemove();" class="k-button k-button-icontext k-grid-add-purchase"
       style="display: none">
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
                item.price = item.sunitFront === 1 ? ((item.wareDj||item.inPrice||0)/ item.hsNum) : (item.wareDj||item.inPrice||0);
                item.unitName = item.wareDw;
                item.beUnit = item.sunitFront === 1 ? item.minUnitCode : item.maxUnitCode;
                item.qty = item.qty || item.stkQty || 1;
                loadProductInfo(item, function(payload){
                    setPrice(item, payload)
                },true);
                setUnit(item);
                item.amt = parseFloat(item.qty) * parseFloat(item.price);
                grid.addRow(item,{move:false});
             }
            "
           id="autocomplete" class="autocomplete" placeholder="搜索产品..." style="width: 250px;">
    <div class="k-button k-button-icontext">
        <input type="checkbox" uglcw-role="checkbox"
               uglcw-options="type:'number'"
               class="k-checkbox" id="load-price">
        <label style="margin-bottom: 0px;" class="k-checkbox-label" for="load-price">加载最新销售价</label>
    </div>
    <div class="k-button k-button-icontext ware-price" style="display: none;padding: 5px 14px 2px 14px;">
        <div id="history-price" class="price"><label>历史价</label><span></span></div>
        <div id="latest-price" class="price"><label>最新价</label><span></span></div>
        <div id="product-price" class="price"><label>商品价</label><span></span></div>
    </div>
</script>

<script type="text/x-uglcw-template" id="autocomplete-template">
    <span class="k-state-default"
          style="background-image: url('#: data.warePicList.length > 0 ? 'upload/'+data.warePicList[0].picMini: '' #')"></span>
    <span class="k-state-default"><h3>#: data.wareNm #</h3><p>#: data.wareCode # #: data.wareGg#</p></span>
</script>
<script type="text/x-uglcw-template" id="autocomplete-header-template">

</script>
<script type="text/x-uglcw-template" id="autocomplete-footer-template">
    共匹配 #: instance.dataSource.data().length #项商品
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/biz/erp/util.js?v=20191120"></script>
<script>
    var gridDataSource = ${fns:toJson(warelist)};
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#grid').on('save', function (e) {
            //判断当前修改的字段 qty amt price 这三个
            var values = e.values;
            if (values) {
                var fields = $.map(values, function (v, k) {
                    return k;
                });
                if (!$(e.container).data('changedFields')) {
                    $(e.container).data('changedFields', fields);
                } else {
                    fields = $(e.container).data('changedFields');
                }
                $('#grid').data('changedFields', fields);
            }
        });
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange' || action === 'add' || action === 'remove') {
                $('#grid').data('_change', true);
            }
            if (action === 'itemchange') {
                var item = e.items[0];
                var changedFields = $('#grid').data('changedFields') || [];
                if ((e.field === 'qty' || e.field === 'price')) {
                    item.set('amt', Number((item.qty * item.price).toFixed(2)));
                } else if (e.field === 'beUnit') {
                    if (item.beUnit === 'B') {
                        //切换至大单位 价格=小单位单价*转换比例
                        item.set('price', item.bUnitPrice);
                    } else if (item.beUnit === 'S') {
                        item.set('price', item.sUnitPrice);
                    }
                    item.amt = Number(item.price * item.qty).toFixed(2);
                } else if (e.field === 'amt') {
                    if (item.amt) {
                        if (changedFields.indexOf('amt') !== -1) {
                            item.price = (parseFloat(item.amt) / parseFloat(item.qty))
                        }
                    }
                }
                if (e.field === 'qty' || e.field === 'price' || e.field === 'beUnit' || e.field === 'amt') {
                    kendoFastReDrawRow(uglcw.ui.get('#grid').k(), $('#grid tr[data-uid=' + item.uid + ']'))
                }
            }
            calTotalAmount();
        });

        $('.form-horizontal [uglcw-role][uglcw-model]').each(function (i, w) {
            uglcw.ui.get(w).on('change', function () {
                $('#grid').data('_change', true);
            })
        })

        uglcw.ui.get('#discount').on('change', function () {
            calTotalAmount();
        })
        uglcw.ui.init('#grid .k-grid-toolbar');
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        $('#grid').on('change', ' #load-price', function () {
            var show = $('#load-price').is(':checked');
            if (show) {
                $('.ware-price').show()
            } else {
                $('.ware-price').hide()
            }
        })
        var loadDelay;
        $('#grid').on('mouseover', '.k-grid-content tbody tr', function () {
            var that = this;
            if (!$('#load-price').is(':checked')) {
                return
            }
            if (!uglcw.ui.get('#proId').value()) {
                return
            }
            if (loadDelay) {
                clearTimeout(loadDelay)
            }
            loadDelay = setTimeout(function () {
                var row = uglcw.ui.get('#grid').k().dataItem($(that));
                if (row.wareId) {
                    loadSalePrice(row.wareId, function (data) {
                        $('#history-price span').text(uglcw.util.toString(data.hisPrice, 'n2'));
                        $('#latest-price span').text(uglcw.util.toString(data.zxPrice, 'n2'));
                        $('#product-price span').text(uglcw.util.toString(data.orgPrice, 'n2'));
                    })
                }
            }, 200)
        })
        isModify = false;
        if (uglcw.ui.get('#orderId').value() && uglcw.ui.get('#billId').value() == '0') {
            queryOrderDetail();
        }

        uglcw.ui.loaded();
    });

    var isModify = false;

    function add() {
        uglcw.ui.openTab('销售退货开单', "${base}manager/pcxsthin?orderId=0");
    }

    function setUnit(item) {
        var beUnit = item.maxUnitCode;
        //开启小单位开单或者商品小单位开单
        if (item.sunitFront == 1) {
            beUnit = item.minUnitCode;
            item.price = item.sUnitPrice;
        } else {
            beUnit = item.maxUnitCode;
        }
        item.beUnit = beUnit;
    }


    function setPrice(item, payload) {
        var hsNum = item.hsNum || 1;
        if (payload.zxPrice != undefined && payload.zxPrice != '' && payload.zxPrice != 0) {
            item.price = payload.zxPrice;
            item.bUnitPrice = payload.zxPrice;
            if (!payload.minZxPrice) {
                item.sUnitPrice = parseFloat(item.bUnitPrice) / hsNum;
            }

        }
        if (payload.minZxPrice != undefined && payload.minZxPrice != "" && payload.minZxPrice != 0) {
            item.sUnitPrice = payload.minZxPrice;
            if (!payload.zxPrice) {
                item.bUnitPrice = item.sUnitPrice * hsNum;
            }
        }
        // if (payload.hisPrice != undefined && payload.hisPrice != '' && payload.hisPrice != 0) {
        //     item.bUnitPrice = payload.hisPrice;
        //     item.sUnitPrice = item.bUnitPrice / hsNum;
        // }

        if (payload.hisPrice != undefined && payload.hisPrice != '' && payload.hisPrice != 0) {
            item.bUnitPrice = payload.hisPrice;
            if(!payload.minHisPrice){
                item.sUnitPrice = item.bUnitPrice / hsNum;
            }
        }


        if (payload.minHisPrice != undefined && payload.minHisPrice != '' && payload.minHisPrice != 0) {
            item.sUnitPrice = payload.minHisPrice;
            if(!payload.hisPrice){
                item.bUnitPrice = item.minHisPrice * hsNum;
            }
        }

        item.price = item.sunitFront == 1 ? item.sUnitPrice : item.bUnitPrice
    }

    function loadProductInfo(row, callback, sync) {
        var stkId = uglcw.ui.get('#stkId').value() || '';
        var action = 'querySaleCustomerHisWareStockPrice';
        if (row && row.wareId) {
            var customerId = uglcw.ui.get('#proId').value();
            $.ajax({
                url: CTX + 'manager/' + action,
                type: 'post',
                async: !!!sync,
                data: {
                    stkId: stkId,
                    cid: customerId,
                    customerId: customerId,
                    wareId: row.wareId,
                },
                success: function (response) {
                    if (response.state) {
                        var hsNum = row.hsNum;
                        var bUnit = row.wareDw;
                        var sUnit = row.minUnit;
                        var minOccQty = parseFloat(response.occQty) * parseFloat(hsNum);
                        var stkQty = parseFloat(response.stkQty) * parseFloat(hsNum);
                        var xnQty = parseFloat(response.xnQty) * parseFloat(hsNum);
                        minOccQty = Math.floor(minOccQty * 100) / 100;
                        stkQty = Math.floor(stkQty * 100) / 100;
                        xnQty = Math.floor(xnQty * 100) / 100;
                        var occQty = "<span style='color:orangered;font-size:12px'>" + formatterQty(response.occQty, hsNum, bUnit, sUnit) + (minOccQty ? "</span>&nbsp;<span style='color:blue;font-size:10px'>" + (minOccQty || 0) + "<span style='font-size:6px'>" + sUnit + "</span></span>" : '');
                        var xnQty = "<span style='color:orangered;font-size:12px'>" + formatterQty(response.xnQty, hsNum, bUnit, sUnit) + (xnQty ? "</span>&nbsp;<span style='color:blue;font-size:10px'>" + (xnQty || 0) + "<span style='font-size:6px'>" + sUnit + "</span></span>" : '');
                        var stkQty = "<span style='color:orangered;font-size:12px'>" + formatterQty(response.stkQty, hsNum, bUnit, sUnit) + (stkQty ? "</span>&nbsp;<span style='color:blue;font-size:10px'>" + (stkQty || 0) + "<span style='font-size:6px'>" + sUnit + "</span></span>" : '');
                        var payload = {
                            raw: response,
                            wareId: row.wareId,
                            timestamp: new Date().getTime(), //缓存时间
                            hisPrice: response.hisPrice || '',
                            zxPrice: response.zxPrice,
                            orgPrice: row.orgPrice || response.orgPrice,
                            inPrice: response.inPrice || '-',
                            occQty: occQty,
                            xnQty: xnQty,
                            stkQty: stkQty
                        };
                        if ($.isFunction(callback)) {
                            callback.call(response, payload);
                        }
                    }
                }
            })
        }

    }

    function formatterQty(v, hsNum, bUnit, sUnit) {
        if (parseFloat(hsNum) > 1) {
            var str = v + "";
            if (str.indexOf(".") != -1) {
                var nums = str.split(".");
                var num1 = nums[0];
                var num2 = nums[1];
                if (parseFloat(num2) > 0) {
                    var minQty = parseFloat(0 + "." + (num2 || 0)) * parseFloat(hsNum || 0);
                    minQty = Math.floor(minQty * 100) / 100
                    return (num1 || 0) + "" + bUnit + "" + (minQty || 0) + "" + sUnit;
                }
            }
        }
        return (v === undefined ? '' : v) + "<span style='font-size:8px'>" + (bUnit === undefined ? '' : bUnit) + "</span>";
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
            id: kendo.guid(),
            inTypeCode: 10001,
            qty: 1,
            amt: 0,
        });
    }

    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }

    //加载最新销售价
    function loadSalePrice(wareId, callback) {
        var proId = uglcw.ui.get('#proId').value();
        $.ajax({
            url: '${base}manager/querySaleCustomerHisWarePrice',
            type: 'get',
            data: {cid: proId, wareId: wareId},
            dataType: 'json',
            success: function (response) {
                if (response.state) {
                    callback(response);
                }
            }
        })
    }

    function selectSender() {
        <tag:compositive-selector-script title="退货单位" callback="onSenderSelect"/>
    }

    function onSenderSelect(id, name, type, item) {
        uglcw.ui.bind('body', {
            proId: id,
            proName: name,
            proType: type,
            address: item.address,
            tel: item.mobile
        });
        if (item.memId) {
            loadEmployeeInfo(item.memId);
        }
    }

    //加载业务员资料
    function loadEmployeeInfo(id) {
        $.ajax({
            url: '${base}manager/getMemberInfo',
            type: 'get',
            data: {memberId: id},
            dataType: 'json',
            success: function (response) {
                if (response.state && response.member) {
                    uglcw.ui.bind('form', {
                        empId: id,
                        empNm: response.member.memberNm,
                    });
                }
            }
        })
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

    // /**
    //  * 产品选择回调
    //  */
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

    function onProductSelect(data) {
        if (data) {
            if ($.isFunction(data.toJSON)) {
                data = data.toJSON();
            }
            data = $.map(data, function (item) {
                var row = item;
                if ($.isFunction(item.toJSON)) {
                    row = item.toJSON();
                }
                row.id = uglcw.util.uuid();
                row.unitName = row.wareDw;
                row.beUnit = row.maxUnitCode;
                row.qty = 1;
                loadProductInfo(row, function (payload) {
                    setPrice(row, payload)
                }, true)
                setUnit(row);
                row.amt = parseFloat(row.qty) * parseFloat(row.price);
                row.productDate = '';
                return row;
            })
            uglcw.ui.get('#grid').addRow(data);
            uglcw.ui.get('#grid').commit();
            uglcw.ui.get('#grid').scrollBottom();
        }
    }


    function selectEmployee() {
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                loadFilter: function (response) {
                    return response.data || [];
                },
                url: '${base}manager/department/tree?dataTp=1',
                model: 'branchId',
                dataTextField: 'branchName',
                id: 'branchId'
            },
            width: 900,
            id: 'memberId',
            selectable: 'row',
            pageable: true,
            url: '${base}manager/stkMemberPage',
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="memberNm">',
            columns: [
                {field: 'memberNm', title: '姓名'},
                {field: 'memberMobile', title: '电话'}
            ],
            yes: function (data) {
                if (data) {
                    var employee = data[0];
                    uglcw.ui.bind('form', {
                        empNm: employee.memberNm,
                        empId: employee.memberId
                    })
                }
            }
        })

    }

    function draftSave() {//暂存
        var status = uglcw.ui.get('#status').value();
        if (status != -2) {
            return uglcw.ui.warning('单据不在暂存状态，不能保存！');
        }
        var valid = uglcw.ui.get('form').validate();
        if (valid) {
            var data = uglcw.ui.bind('form');

            var proName = uglcw.ui.get("#proName").value();
            var stkId = uglcw.ui.get("#stkId").value();
            var inDate = uglcw.ui.get("#inDate").value();
            if (proName == "") {
                return uglcw.ui.error('请选择退货单位');
            }

            if (inDate == "") {
                return uglcw.ui.error('请选择退货时间');
            }
            <%--if(${fns:isUseKuwei()}){--%>
            <%--var kwBool = checkStkTemp();--%>
            <%--if(!kwBool){--%>
            <%--uglcw.ui.error('未设置临时仓库，，请<a href=\'javascript:toSetStorage()\'>设置</a>');--%>
            <%--return;--%>
            <%--}--%>
            <%--}--%>
            if (stkId == "") {
                return uglcw.ui.error('请选择仓库');
            }
            var list = uglcw.ui.get('#grid').bind();
            if (!list || list.length < 1) {
                return uglcw.ui.error('请选择商品');
            }


            var bool = checkFormQtySign(list,1);
            if(!bool){
                return;
            }

            data.inType = '销售退货';
            data.shr = data.proName;
            list = $.map(list, function (product) {
                product.productDate = product.productDate ? uglcw.util.toString(product.productDate, 'yyyy-MM-dd') : '';
                product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
                if (product.wareId) {
                    return product;
                }
            });
            data.wareStr = JSON.stringify(list);
            uglcw.ui.confirm('是否确定暂存？', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/dragSaveStkIn',
                    type: 'post',
                    data: data,
                    dataType: 'json',
                    success: function (json) {
                        if (json.state) {
                            uglcw.ui.info('暂存成功');
                            $("#btnsave").hide();
                            $("#btndraftaudit").show();
                            $("#btnprint").show();
                            $("#btncancel").show();
                            $("#btnaudit").hide();
                            uglcw.ui.get('#billStatus').value("暂存成功");
                            uglcw.ui.get('#billId').value(json.id);
                            uglcw.ui.get('#billNo').value(json.billNo);
                            $('#grid').data('_change', false);
                        }
                        isModify = false;
                        uglcw.ui.loaded();
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('暂存失败');
                    }
                })
            })
        }
    }

    function audit() {//审批
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (status == 0) {
            return uglcw.ui.error('该单据已审批！');
        }
        if (billId == 0 || status != -2) {
            return uglcw.ui.warning('没有可审核的单据');
        }
        if ($('#grid').data('_change')) {
            return uglcw.ui.warning('单据有变动请先【暂存】');
        }
        uglcw.ui.confirm('是否确定审核？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/auditDraftStkIn',
                type: 'post',
                data: {billId: billId},
                dataType: 'json',
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.info('审批成功');
                        uglcw.ui.get('#billStatus').value('审批成功');
                        uglcw.ui.get("#status").value(0);
                        $("#btndraft").hide();
                        $("#btndraftaudit").hide();
                        $("#btnsave").hide();
                        $("#btnprint").show();
                        $("#btncancel").show();
                        $("#btnaudit").show();
                        if (json.autoSend == 1) {
                            $("#btnaudit").hide();
                        }
                        isModify = false;
                        $('#grid').data('_change', false);
                    } else {
                        uglcw.ui.error('审核失败!');
                        //$.messager.alert('消息','审核失败','info');
                    }
                    uglcw.ui.loaded();
                },
                error: function () {
                    uglcw.ui.loaded();
                    uglcw.ui.error('审批失败');
                }
            })
        })
    }

    function reAudit() {//反审批
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.warning('没有可反审批的单据');
        }
        var billStatus = uglcw.ui.get('#status').value();
        if (billStatus == 2) {
            uglcw.ui.warning("该单据已作废");
            return;
        }
        uglcw.ui.confirm('确定反审批？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/reAuditStkXsIn',
                type: 'post',
                data: {billId: billId},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('反审批成功！');
                        setTimeout(function () {
                            uglcw.ui.replaceCurrentTab('销售退货单信息' + billId, '${base}/manager/showstkin?billId=' + billId);
                        }, 1000);
                    } else {
                        uglcw.ui.error('反审批失败' + response.msg);
                    }
                },
            })
        })
    }

    function submitStk() {
        var valid = uglcw.ui.get('form').validate();
        if (valid) {
            var data = uglcw.ui.bind('form');

            var proName = uglcw.ui.get("#proName").value();
            var stkId = uglcw.ui.get("#stkId").value();
            var inDate = uglcw.ui.get("#inDate").value();
            if (proName == "") {
                return uglcw.ui.error('请选择退货单位');
            }
            if (inDate == "") {
                return uglcw.ui.error('请选择退货时间');
            }
            <%--if(${fns:isUseKuwei()}){--%>
            <%--var kwBool = checkStkTemp();--%>
            <%--if(!kwBool){--%>
            <%--uglcw.ui.error('未设置临时仓库，，请<a href=\'javascript:toSetStorage()\'>设置</a>');--%>
            <%--return;--%>
            <%--}--%>
            <%--}--%>
            if (stkId == "") {
                return uglcw.ui.error('请选择仓库');
            }
            var list = uglcw.ui.get('#grid').bind();
            if (!list || list.length < 1) {
                return uglcw.ui.error('请选择商品');
            }

            var bool = checkFormQtySign(list,1);
            if(!bool){
                return;
            }
            data.inType = '销售退货';
            data.shr = data.proName;
            list = $.map(list, function (product) {
                product.activeDate = product.activeDate ? uglcw.util.toString(row.activeDate, 'yyyy-MM-dd') : '';
                product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
                if (product.wareId) {
                    return product;
                }
            });
            data.wareStr = JSON.stringify(list);
            uglcw.ui.confirm('保存后将不能修改，是否确定保存？', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/addStkIn',
                    type: 'post',
                    data: data,
                    dataType: 'json',
                    success: function (json) {
                        if (json.state) {
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
                            if (json.autoSend == 1) {
                                $("#btnaudit").hide();
                            }
                            $('#grid').data('_change', false);
                            isModify = false;
                        } else {
                            uglcw.ui.error(json.msg);
                        }
                        uglcw.ui.loaded();
                        isModify = false;
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('审批失败');
                    }
                })
            })
        }
    }

    function auditProc() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.warning('没有可审核的单据');
        }
        uglcw.ui.openTab('退货入库收货', '${base}manager/showstkincheck?dataTp=1&billId=' + billId);
    }


    function toPrint() {
        var billId = uglcw.ui.get("#billId").value();
        if ($('#grid').data('_change')) {
            return uglcw.ui.warning('单据有变动请先【暂存】');
        }
        uglcw.ui.openTab('销售退货单打印', '${base}manager/showstkinprint?billId=' + billId);
    }


    function cancelClick() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.warning('没有可作废的单据');
        }
        var billStatus = uglcw.ui.get('#status').value();
        if (billStatus == 2) {
            return uglcw.ui.error('该单据已经作废');
        }
        uglcw.ui.confirm('确定作废吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/cancelProc',
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
        if (status == -2) {
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

    function showVersion(id) {
        uglcw.ui.openTab("销售退货版本记录", "${base}manager/showstkinversion?billId=" + id);
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
        model.price = item.sunitFront === 1 ? (item.wareDj || 0) / item.hsNum : (item.wareDj || 0);
        model.qty = 1;
        model.sunitFront = item.sunitFront;
        model.beUnit = item.sunitFront === 1 ? item.minUnitCode : item.maxUnitCode;
        model.wareId = item.wareId;
        model.minUnit = item.minUnit;
        model.minUnitCode = item.minUnitCode;
        model.maxUnitCode = item.maxUnitCode;
        model.productDate = '';
        model.unitName = item.wareDw;
        loadProductInfo(model, function (payload) {
            setPrice(model, payload);
        }, true);
        setUnit(model);
        model.amt = model.price * model.qty;
        uglcw.ui.get('#grid').commit();
        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
    }

    /**
     * 加载订单明细
     */
    function queryOrderDetail() {
        var orderId = uglcw.ui.get('#orderId').value();
        if (orderId) {
            $.ajax({
                url: '${base}manager/queryThOrderSub',
                type: 'post',
                data: {orderId: orderId},
                success: function (response) {
                    if (response.state && response.rows && response.rows.length > 0) {
                        $(response.rows).each(function () {
                            this.qty = this.wareNum;
                            this.price = this.wareDj;
                            this.amt = this.wareZj;
                            if (!this.beUnit) {
                                if (this.wareDw === this.wareDw2) {
                                    this.beUnit = this.maxUnitCode;
                                } else {
                                    this.beUnit = this.minUnitCode;
                                }
                            }
                        });
                        uglcw.ui.get('#grid').bind(response.rows);
                    }
                }
            })
        }
    }

    function kendoFastReDrawRow(grid, row) {
        var dataItem = grid.dataItem(row);
        var current = grid.current();
        var cellIndex = 0, rowIndex = $(row).index();
        if (current && current.length > 0) {
            cellIndex = $(current).index();
        }
        var rowChildren = $(row).children('td[role="gridcell"]');

        for (var i = 0; i < grid.columns.length; i++) {

            var column = grid.columns[i];
            var template = column.template;
            var cell = rowChildren.eq(i);

            if (template !== undefined) {
                var kendoTemplate = kendo.template(template);

                // Render using template
                cell.html(kendoTemplate(dataItem));
            } else {
                var fieldValue = dataItem[column.field];

                var format = column.format;
                var values = column.values;

                if (values !== undefined && values != null) {
                    // use the text value mappings (for enums)
                    for (var j = 0; j < values.length; j++) {
                        var value = values[j];
                        if (value.value == fieldValue) {
                            cell.html(value.text);
                            break;
                        }
                    }
                } else if (format !== undefined) {
                    // use the format
                    cell.html(kendo.format(format, fieldValue));
                } else {
                    // Just dump the plain old value
                    cell.html(fieldValue);
                }
            }
        }
        row.find('.row-number').text($(row).index() + 1);
        grid._footer();
        //grid.current($('#grid .k-grid-content tr:eq(' + rowIndex + ') td:eq(' + cellIndex + ')'));
        //grid.table.focus();
    }

    function amtEditor(container, options) {
        var input = $('<input uglcw-role="numeric" name="amt" data-bind="value:amt">');
        input.appendTo(container);
        var widget = new uglcw.ui.Numeric(input);
        widget.init({
            step: false,
            min: 0
        });
    }
</script>
</body>
</html>
