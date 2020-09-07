<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>变动费用单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcu/css/bill-common.css" media="all">
    <style>
        .uglcw-search input, select {
            height: 30px;
        }

        .snapshot-badge-dot {
            display: none;
            position: absolute;
            -webkit-transform: translateX(-50%);
            transform: translateX(-50%);
            -webkit-transform-origin: 0 center;
            transform-origin: 0 center;
            top: 4px;
            right: 8px;
            height: 8px;
            width: 8px;
            border-radius: 100%;
            background: #ed4014;
            z-index: 10;
            box-shadow: 0 0 0 1px #fff;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card master">
        <form class="form-horizontal" uglcw-role="validator">
            <div class="layui-card-header btn-group">
                <ul uglcw-role="buttongroup">
                    <li onclick="add()" data-icon="add" class="k-info">新建</li>
                    <c:if test="${rebateOut.status eq -2}">
                        <li onclick="draftSave()" class="k-info" data-icon="save" id="btndraft">暂存</li>
                    </c:if>
                    <c:if test="${rebateOut.status eq -2 and rebateOut.status ne 2}">
                        <li onclick="audit()" class="k-info" data-icon="track-changes-accept" id="btndraftaudit"
                            style="display: ${(rebateOut.id ne 0 and rebateOut.status eq -2 and rebateOut.status ne 2)?'':'none'}">审批
                        </li>
                    </c:if>

                    <li onclick="cancelClick()" id="btncancel" class="k-error" data-icon="delete"
                        style="display: ${rebateOut.id eq 0 or rebateOut.status eq 2?'none':''}">作废
                    </li>

                </ul>
                <div class="bill-info">
                    <span class="no" style="color: green;"><div id="billNo" uglcw-model="billNo" style="height: 25px;"
                                                                uglcw-role="textbox">${rebateOut.billNo}</div></span>
                    <span class="status" style="color:red;"><div id="billStatus" style="height: 25px;width: 80px"
                                                                 uglcw-model="billstatus"
                                                                 uglcw-role="textbox">${rebateOut.billStatus}</div></span>
                </div>
            </div>
            <div class="layui-card-body master">
                <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="billId" value="${rebateOut.id}"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="cstId" id="cstId" value="${rebateOut.cstId}"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="proType" id="proType" value="${rebateOut.proType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="recAmt" id="recAmt" value="${rebateOut.recAmt}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${rebateOut.status}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="disAmt" id="disAmt" value="${rebateOut.disAmt}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="disAmt1" id="disAmt1" value="${rebateOut.disAmt1}"/>

                <div class="form-group">
                    <label class="control-label col-xs-3">往来单位</label>
                    <div class="col-xs-4">
                        <input uglcw-role="gridselector" uglcw-model="khNm" id="khNm" value="${rebateOut.khNm}"
                               uglcw-validate="required"
                               uglcw-options="click:function(){
								selectSender();
							}"
                        >
                    </div>
                    <%--</div>--%>
                    <label class="control-label col-xs-3">费用归属时间</label>
                    <div class="col-xs-4">
                        <input uglcw-validate="required" id="outDate" uglcw-role="datetimepicker"
                               uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="outDate" value="${rebateOut.outDate}">
                    </div>
                    <label class="control-label col-xs-3">费用金额</label>
                    <div class="col-xs-4">
                        <input id="totalAmount" uglcw-options="spinners: false, format: 'n2'" uglcw-role="numeric"
                               uglcw-model="totalAmt" value="${rebateOut.totalAmt}"
                               disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">变动费用类型</label>
                    <div class="col-xs-4">
                        <select uglcw-role="combobox" uglcw-model="autoId" id="autoId"
                                placeholder="变动费用类型"
                                uglcw-options="
										value: '${rebateOut.autoId}',
										url: '${base}manager/autoFieldList?status=1',
										loadFilter:{
											data: function(response){
												return response.datas || []
											}
										},
										dataTextField: 'name',
										dataValueField: 'id'
									"></select>
                    </div>

                    <label class="control-label col-xs-3">费用区间</label>
                    <div class="col-xs-4">
                        <input uglcw-validate="required" id="sdate" uglcw-role="datetimepicker"
                               uglcw-options="format:'yyyy-MM-dd'"
                               uglcw-model="sdate" value="${rebateOut.sdate}">

                    </div>
                    <label class="control-label col-xs-3">到</label>
                    <div class="col-xs-4">
                        <input uglcw-validate="required" id="edate" uglcw-role="datetimepicker"
                               uglcw-options="format:'yyyy-MM-dd'"
                               uglcw-model="edate" value="${rebateOut.edate}">
                    </div>
                </div>
                    <div class="form-group">
                    <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                    <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${rebateOut.remarks}</textarea>
                    </div>
                    </div>
                </div>
        </form>
    </div>

    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid-advanced"
                 uglcw-options='
                          lockable: false,
                          draggable: true,
                          reorderable: true,
                          responsive:[".master",40],
                          id: "id",
                          sortable: {
                            mode: "multiple",
                            allowUnsort: true
                          },
                          rowNumber: true,
                          checkbox: false,
                          add: function(row){
                            return uglcw.extend({
                                id: uglcw.util.uuid(),
                                qty:1,
                                amt: 0
                            }, row);
                          },
                          editable: true,
                          toolbar: uglcw.util.template($("#toolbar").html()),
                          height:400,
                          speedy:{
                            className: "uglcw-cell-speedy"
                          },
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource: dataSource,
                          dataBound: onGridDataBound
                        '
            >
                <div data-field="wareCode" uglcw-options="
                            width: 100,
                            editable: false,
                        ">产品编号
                </div>
                <div data-field="wareNm" uglcw-options="width: 180,
                            tooltip: true,
                            align: 'left',
                            titleAlign: 'center',
                            attributes:{
                                class: 'cell-product-name uglcw-cell-speedy'
                            },
                            editor: productNameEditor
                ">产品名称
                </div>

                <div data-field="wareGg" uglcw-options="width: 100">产品规格</div>
                <div data-field="beUnit" uglcw-options="width: 80,
                            template: '#= data.beUnit == data.maxUnitCode ? data.wareDw||\'\' : data.minUnit||\'\' #'
                        ">单位
                </div>
                <div data-field="qty" uglcw-options="width: 100,
                            aggregates: ['sum'],
                            schema:{type: 'number',decimals:10},
                            attributes:{
                                class: 'cell-product-name uglcw-cell-speedy'
                            },
                            footerTemplate: '#= (sum||0) #'
                    ">数量
                </div>
                <div data-field="rebatePrice"
                     uglcw-options="width: 100,
                      attributes:{
                          class: 'uglcw-cell-speedy dirty-cell'
                      },
                      schema:{type: 'number',decimals:10}">
                    单位费用
                </div>
                <div data-field="amt" uglcw-options="width: 100,
                            format:'{0:n2}',
                            aggregates: ['sum'],
                            schema: {type: 'number', decimals: 10},
                            footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#'">费用金额
                </div>

                <div data-field="remarks"
                     uglcw-options="width: 140, editable: true">
                    备注
                </div>
                <div data-field="options" uglcw-options="width: 100, command:'destroy'">
                    操作
                </div>
            </div>
        </div>
    </div>
</div>

<tag:compositive-selector-template index="2"/>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:addRow();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-add"></span>增行
    </a>
    <a role="button" href="javascript:showProductSelector()" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-search"></span>批量添加
</script>

<script type="text/x-uglcw-template" id="autocomplete-template">
    <div><span>#= data.wareNm#</span><span style="float: right">#= data.wareGg#</span></div>
</script>
<tag:product-in-selector-template query="onQueryProduct"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}/resource/stkstyle/js/Map.js"></script>
<script>
    var dataSource = ${fns:toJson(rebateOut.list)};
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
            if (action === 'itemchange') {
                var item = e.items[0];
                var changedFields = $('#grid').data('changedFields') || [];
                var commit = false;
                if ((e.field === 'qty' || e.field === 'rebatePrice')) {
                    if (changedFields.indexOf('qty') != -1 || changedFields.indexOf('rebatePrice') != -1) {
                        item.set('amt', Number((item.qty * item.rebatePrice).toFixed(2)));
                        commit = true;
                    }
                } else if (e.field === 'beUnit') {
                    if (item.beUnit === 'B') {
                        //切换至大单位 价格=小单位单价*转换比例
                        item.set('rebatePrice', Number(item.rebatePrice * item.hsNum).toFixed(2));
                    } else if (item.beUnit === 'S') {
                        item.set('price', Number(item.rebatePrice / item.hsNum).toFixed(2));
                    }
                    item.set('amt', Number((item.qty * item.rebatePrice).toFixed(2)));
                } else if (e.field === 'amt') {
                    if (item.amt) {
                        if (changedFields.indexOf('amt') != -1) {
                            item.set('rebatePrice', (parseFloat(item.amt) / parseFloat(item.qty)));
                        }
                    }
                }
                /*if (commit) {
                    uglcw.ui.get('#grid').commit();
                }*/
            }
            $('#grid').data('_change', true);
            calTotalAmount();
        });
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        //grid渲染后对toolbar上的控件进行初始化
        uglcw.ui.loaded();
    })

    function onGridDataBound() {
        var init = $('#grid').data('toolbarInit');
        if (!init) {
            uglcw.ui.init('#grid .k-grid-toolbar');
            $('#grid').data('toolbarInit', true);
        }
    }

    function add() {
        uglcw.ui.openTab('变动费用开单', '${base}manager/stkRebateOut/add?r=' + new Date().getTime());
    }

    var isModify = false;

    function selectSender() {
        <tag:compositive-selector-script title="往来单位" callback="onSenderSelect"/>
    }

    function onSenderSelect(id, name, type) {
        uglcw.ui.bind('body', {
            cstId: id,
            khNm: name,
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
            total += (Number(item.rebatePrice || 0) * Number(item.qty || 0))
        })
        uglcw.ui.get('#totalAmount').value(total.toFixed(2));
        uglcw.ui.get('#disAmt').value(total.toFixed(2));
        uglcw.ui.get('#disAmt1').value(total.toFixed(2));
    }

    function addRow() {
        uglcw.ui.get('#grid').addRow({
            id: kendo.guid(),
            qty: 1,
            rebatePrice: 0,
            amt: 0
        });
    }


    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }


    function draftSave() {//暂存
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');

        var status = uglcw.ui.get('#status').value();
        if (status != -2) {
			return uglcw.ui.warning('单据不在暂存状态，不能保存！');
        }
		var autoId = uglcw.ui.get('#autoId').value();
		if (autoId =="") {
			return uglcw.ui.warning('请选择变动费用！')
		}

        var khNm = uglcw.ui.get("#khNm").value();
        var outDate = uglcw.ui.get("#outDate").value();
        if (khNm == "") {
            return uglcw.ui.error('请选择往来单位');
        }

        if (outDate == "") {
            return uglcw.ui.error('请选择费用归属日期');
        }

        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 1) {
            return uglcw.ui.error('请添加明细');
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
            url: '${base}manager/stkRebateOut/save',
            type: 'post',
            data: form,
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
    }

    var mmap = new Map();

    function onQueryProduct(param) {
		var autoId = uglcw.ui.get('#autoId').value();
		if (autoId =="") {
			return uglcw.ui.warning('请选择变动费用！')
		}
        param.stkId = 0;
        return param;
    }

    /**
     * 产品选择回调
     */
    function onProductSelect(data) {
        if (data) {
            if ($.isFunction(data.toJSON)) {
                data = data.toJSON();
            }
            var wareIds = "";
            data = $.map(data, function (item) {
                var row = item;
                if ($.isFunction(item.toJSON)) {
                    row = item.toJSON();
                }
                row.id = uglcw.util.uuid();
                row.rebatePrice = '0';
                row.unitName = row.wareDw;
                row.beUnit = row.maxUnitCode;
                row.qty = 1;
                row.amt = parseFloat(row.qty) * parseFloat(row.rebatePrice);
                row.productDate = '';
                if (wareIds != "") {
                    wareIds = wareIds + ",";
                }
                wareIds = wareIds + row.wareId;
                mmap.put(row.wareId, row);
                return row;
            })

            loadCusotmerFeePrice(wareIds);

            uglcw.ui.get('#grid').addRow(data);
            uglcw.ui.get('#grid').commit();
            uglcw.ui.get('#grid').scrollBottom();
        }
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

        if ($('#grid').data('_change')) {
            uglcw.ui.info('单据有变动，请先暂存');
            return;
        }

        uglcw.ui.confirm('是否确定审核？', function () {
            uglcw.ui.loading();
            var billId = uglcw.ui.get('#billId').value();
            $.ajax({
                url: '${base}manager/stkRebateOut/audit',
                type: 'post',
                data: {billId: billId},
                dataType: 'json',
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.info('审批成功');
                        uglcw.ui.get('#billStatus').value('审批成功');
                        uglcw.ui.get("#status").value(0);
                        $("#btndraftaudit").hide();
                        $("#btndraft").hide();
                        $("#btncancel").show();
                        isModify = false;
                    } else {
                        uglcw.ui.error('审核失败!');
                        //$.messager.alert('消息','审核失败','info');
                    }
                    uglcw.ui.loaded();
                }
            })

        })
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
                url: '${base}/manager/stkRebateOut/cancel',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.info('作废成功');
                        uglcw.ui.get('#billStatus').value('作废成功');
                        uglcw.ui.get('#status').value(2);
						$("#btndraftaudit").hide();
						$("#btndraft").hide();
                        $("#btncancel").hide();
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

    function showProductSelector() {
		var autoId = uglcw.ui.get('#autoId').value();
		if (autoId =="") {
			return uglcw.ui.warning('请选择变动费用！')
		}
        <tag:product-out-selector-script fullscreen="true" callback="onProductSelect"/>
    }

    function onProductSelect2(data) {
        if (!data || data.length < 1) {
            return;
        }
        var item = data[0];
        mmap = new Map();
        model.hsNum = item.hsNum;
        model.wareCode = item.wareCode;
        model.wareGg = item.wareGg;
        model.wareNm = item.wareNm;
        model.wareDw = item.wareDw;
        model.rebatePrice = 0;
        model.qty = 1;
        model.sunitFront = item.sunitFront;
        model.beUnit = item.maxUnitCode;
        model.wareId = item.wareId;
        model.minUnit = item.minUnit;
        model.minUnitCode = item.minUnitCode;
        model.maxUnitCode = item.maxUnitCode;
        model.productDate = '';
		model.unitName = item.wareDw;
        model.amt = model.rebatePrice * model.qty;
        mmap.put(model.wareId, model);
        loadCusotmerFeePrice(model.wareId);
        uglcw.ui.get('#grid').commit();
        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
    }

    function productNameEditor(container, options) {
		var autoId = uglcw.ui.get('#autoId').value();
		if (autoId =="") {
			return uglcw.ui.warning('请选择变动费用！')
		}
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
            selectable: true,
            click: function () {
                showProductSelectorForRow(model, rowIndex, cellIndex);
            },
            url: CTX + 'manager/dialogWarePage',
            data: function () {
                return {
                    page: 1, rows: 20,
                    waretype: '',
                    stkId: 0,
                    wareNm: uglcw.ui.get(input).value()
                }
            },
            loadFilter: {
                data: function (response) {
                    return response.rows || [];
                }
            },
            template: '<div><span>#= data.wareNm#</span><span style=\'float: right\'>#= data.wareGg#</span></div>',
            select: function (e) {
                mmap = new Map();
                var item = e.dataItem;
                var model = options.model;
                model.hsNum = item.hsNum;
                model.wareCode = item.wareCode;
                model.wareGg = item.wareGg;
                model.wareNm = item.wareNm;
                model.wareDw = item.wareDw;
                model.rebatePrice = 0;
                model.qty = 1;
                model.amt = model.rebatePrice * model.qty;
                model.beUnit = item.maxUnitCode;
                model.wareId = item.wareId;
                model.minUnit = item.minUnit;
                model.minUnitCode = item.minUnitCode;
                model.maxUnitCode = item.maxUnitCode;
                mmap.put(model.wareId, model);
                loadCusotmerFeePrice(model.wareId);
                uglcw.ui.get('#grid').commit();
                uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex - 1);
            }
        });
    }

    function loadCusotmerFeePrice(wareIds) {
        var action = "stkCustomerFeeCalculate/loadCusotmerFeePrice";
        var customerId = uglcw.ui.get('#cstId').value();
        var proType = uglcw.ui.get('#proType').value();
        var autoId = uglcw.ui.get('#autoId').value();
        $.ajax({
            url: CTX + 'manager/' + action,
            type: 'post',
            async: false,
            data: {
                customerId: customerId,
                wareIds: wareIds,
                autoId, autoId
            },
            success: function (response) {
                if (response.state) {
					response.wareList = $.map(response.wareList, function (item) {
                        var wareId = item.wareId;
                        if (mmap.containsKey(wareId)) {
							var row = mmap.get(wareId);
							row.rebatePrice=item.autoFee;
							row.amt = row.rebatePrice * row.qty;
                        }
                    })
                }
            }
        })
    }

</script>
</body>
</html>
