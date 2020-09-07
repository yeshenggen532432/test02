var BILL_STATES = {
    NEW: 11, //新建
    STAGING: 903, //暂存
    UNSHIPPED: 481, //未发货
    SHIPPED: 449, //已发货
    CANCELLED: 1, //已作废
    TERMINATED: 1 //已终止
};

//单据配置
var config = {
    productCheckCounter: 99999,
    enterSubmit: false
};

function toCurrency(data) {
    return uglcw.util.toString(data, 'n2');
}

function pageState(state) {
    $('.actionbar').find('[uglcw-state]').each(function (i, el) {
        var tempState = uglcw.ui.attr(el, 'state');
        tempState = tempState === undefined ? 7 : uglcw.util.toInt(tempState);
        var show = (tempState & state) > 0;
        if (show) {
            $(el).show();
        } else {
            $(el).hide();
        }
    })
}

function add() {
    uglcw.ui.openTab('销售单', CTX + 'manager/pcstkout?orderId=0&r=' + new Date().getTime());
}

/**
 * 商品明细显示历史价格
 */
function showHistoryPrices(el) {
    var row = uglcw.ui.get('#grid').k().dataItem($(el).closest('tr'));
    uglcw.ui.Modal.showGridSelector({
        title: '商品历史价格',
        area: ['650px', '300px'],
        btns: false,
        url: CTX + 'manager/dialogCustomerWarePricePage',
        query: function (params) {
            params.wareId = row.wareId;
            params.customerId = uglcw.ui.get('#cstId').value();
            return params;
        },
        columns: [
            {title: '销售商品', field: 'ware_nm', width: 150, tooltip: true},
            {title: '销售单位', field: 'ware_dw', width: 140},
            {title: '销售价格', field: 'price', width: 70},
            {title: '销售数量', field: 'qty', width: 70}
        ]
    })
}

function maxMin() {
    var $master = $('.main-form');
    var grid = uglcw.ui.get('#grid');
    if ($master.is(':visible')) {
        $master.slideUp();
    } else {
        $master.slideDown();
    }
    $('.uglcw-grid-maxmin').toggleClass('ion-md-expand ion-md-contract');
    setTimeout(function () {
        grid.resize();
    }, 400);
}

/**
 * 显示客户欠款信息
 * @returns {{isVisible}|*|void}
 */
function showCustomerDebt() {
    //获取并检查客户ID

    var customerId = uglcw.ui.get('#cstId').value();
    if (!customerId && xsfpQuickBill == 'none') {
        return uglcw.ui.warning('请先选择客户');
    }
    //生成查询条件默认日期范围
    var sdate = uglcw.util.toString(new Date(), 'yyyy-MM-01');
    var edate = uglcw.util.toString(new Date(), 'yyyy-MM-dd');
    uglcw.ui.Modal.showGridSelector({
        title: '客户欠款单据',
        area: ['650px', '350px'],
        url: CTX + 'manager/queryUnRecPage',
        query: function (params) {
            params.cstId = customerId;
            return params;
        },
        criteria: '<input uglcw-role="datepicker" uglcw-model="sdate" value="' + sdate + '">' +
            '<input uglcw-role="datepicker" uglcw-model="edate" value="' + edate + '">' +
            '<input uglcw-role="textbox" placeholder="发票单号" uglcw-model="billNo">',
        columns: [
            {field: 'billNo', title: '发票单号', width: 120},
            {field: 'khNm', title: '往来单位', width: 100},
            {field: 'outDate', title: '发票日期', width: 120},
            {field: 'needRec', title: '未收金额', width: 80, format: '{0:n2}'},
            {field: 'disAmt', title: '发票金额', width: 80, format: '{0:n2}'},
            {field: 'disAmt1', title: '发货金额', width: 80, format: '{0:n2}'},
            {field: 'recAmt', title: '已收金额', width: 80, format: '{0:n2}'},
            {field: 'freeAmt', title: '核销金额', width: 80, format: '{0:n2}'},
            {field: 'recStatus', title: '收款状态', width: 80}
        ],
        btns: []
    })

}

function quickAddNewCustomer(customerName, callback) {
    addNewCustomer(customerName, function () {
        $.ajax({
            url: CTX + 'manager/customerPage',
            data: {
                page: 1,
                rows: 1
            },
            type: 'get',
            success: function (response) {
                if (response.rows && response.rows.length > 0) {
                    var customer = response.rows[0];
                    uglcw.ui.bind('body', {cstId: customer.id});
                    if ($.isFunction(callback)) {
                        callback(customer);
                    }
                } else {
                    if ($.isFunction(callback)) {
                        callback();
                    }
                }
            },
            error: function () {
                if ($.isFunction(callback)) {
                    callback();
                }
            }
        })
    })
}

function addRow() {
    var grid = uglcw.ui.get('#grid');
    grid.addRow({
        id: kendo.guid()
    });
    setTimeout(function () {
        var $cell = $('#grid tr:last-child td.cell-product-name');
        grid.k().current($cell);
        grid.k().editCell($cell);
    }, 50)
}

function calTotalAmount() {
    var ds = uglcw.ui.get('#grid').k().dataSource;
    var data = ds.data().toJSON();
    var total = 0;
    $(data).each(function (idx, item) {
        total += (Number(item.price || 0) * Number(item.qty || 0))
    })
    uglcw.ui.get('#totalAmount').value(toCurrency(total));
    var discount = uglcw.ui.get('#discount').value() || 0;
    var freight = uglcw.ui.get("#freight").value()||0;
    var disAmt = parseFloat(total)-parseFloat(discount)+parseFloat(freight);
    uglcw.ui.get('#discountAmount').value(toCurrency(disAmt));
}

function initTooltips() {
    $('#grid .k-grid-content').kendoTooltip({
        filter: '.product-code-tooltip',
        position: 'top',
        content: '历史价格',
        onShow: function (e) {
            this.popup.element.addClass('uglcw-tooltip');
        }
    })
    var snapshotTips;
    $('#snapshot').on('mouseenter', function () {
        layer.tips('当产品明细行数达到20后，单据变动将自动保存快照', $('#snapshot'));
    }).on('mouseleave', function () {
        layer.close(snapshotTips)
    });

    var addressTip;
    $('.main-form').on('mouseenter', '.address', function () {
        var address = uglcw.ui.get('[uglcw-model=address]').value();
        if (address) {
            addressTip = layer.tips(uglcw.ui.get('[uglcw-model=address]').value(), $('.address'), {
                maxWidth: 300,
                tips: 1
            });
        }
    }).on('mouseleave', '.address', function () {
        layer.close(addressTip);
    })

    $('#grid .k-grid-header').kendoTooltip({
        filter: '.product-date-tip',
        position: 'top',
        onShow: function (e) {
            this.popup.element.addClass('uglcw-tooltip');
        },
        content: '<div><p>点击[关联]可以选中具体批次的商品生产日期，</p><p>且该批次生产日期的商品将会被占用</p></div>'
    })

    $('#help-info').kendoTooltip({
        position: 'bottom',
        content: $('#help-info-tpl').html()
    });
}

var addingProduct = false;

/**
 * 快速添加商品
 */
function addProduct(model, name) {
    addingProduct = true;
    var addProductDialog = uglcw.ui.Modal.open({
        title: '商品快速添加',
        maxmin: false,
        content: $('#add-product-tpl').html(),
        area: '600px',
        btns: ['确定并关闭', '确定并继续', '取消'],
        success: function (c) {
            //初始化弹框内的uglcw控件
            uglcw.ui.init(c);
            uglcw.ui.bind(c, {wareNm: name || ''})
        },
        yes: function (c) {
            $form = $(c).find('.add-product-form');
            if (!uglcw.ui.get($form).validate()) {
                return false;
            }
            var data = uglcw.ui.bind($form);
            uglcw.extend(data, {
                putOn: 0,
                status: 1,
                isCy: 1
            })
            uglcw.ui.loading();
            saveProduct(data, model, function (m, ware) {
                if (model) {
                    onProductSelect2([ware]);
                } else {
                    uglcw.ui.get('#grid').addRow(ware);
                }
                uglcw.ui.Modal.close(addProductDialog);
                addingProduct = false;
            });
            return false;
        },
        btn2: function () {
            uglcw.ui.toast('确定并继续');
            return false;
        }
    })
}

function addProductOnNoFound(value) {
    saveProduct({wareNm: value}, window.model, function (model, ware) {
        onProductSelect2([ware]);
        addingProduct = false
    })
}

function saveProduct(data, model, callback) {
    data = uglcw.extend(data, {
        putOn: 0,
        status: 1,
        isCy: 1
    });
    $.ajax({
        url: CTX + 'manager/saveQuickWare',
        type: 'post',
        data: data,
        success: function (response) {
            uglcw.ui.loaded();
            if (response.state) {
                uglcw.ui.success('添加成功');
                var ware = response.ware;
                ware.qty = data.initQty;
                ware.price = ware.inPrice;
                ware.maxNm = ware.wareDw;
                ware.minNm = ware.minUnit;
                if ($.isFunction(callback)) {
                    callback(model, ware);
                }
            }
        },
        error: function () {
            uglcw.ui.loaded();
            uglcw.ui.error('添加失败');
        }
    });
}

/**
 * 顶部按钮组滚动置顶处理
 */
function actionBarScrolling() {
    var scrollTop = $(window).scrollTop();
    if (scrollTop > 5 && $('.actionbar-fixed').length < 1) {
        var $actionbar = $('.actionbar');
        var fixedActionBar = $actionbar.clone().addClass('actionbar-fixed');
        fixedActionBar.insertAfter($actionbar);
        uglcw.ui.init($(fixedActionBar).find('.bill-info'));
        fixedActionBar.slideDown(100);
    } else {
        $('.actionbar-fixed').remove();
    }
}


var delay, gridDataBoundDelay;

function onGridDataBound() {
    clearTimeout(gridDataBoundDelay);
    gridDataBoundDelay = setTimeout(doGridDataBound, 50);
}

function doGridDataBound() {
    kendo.ui.uglcwGrid.fn._handleEscKey = function () {
    }
    kendo.ui.uglcwGrid.fn._handleEnterKey = function (cell, table, editor) {
        if ($('#grid').data('_stop_enter_move_tick')) {
            $('#grid').removeData('_stop_enter_move_tick');
            return;
        }
        var lastRow = $(cell).closest('tr').is(':last-child');
        //最后一个单元格
        if (lastRow && $(cell).is('.uglcw-cell-speedy:last')) {
            //商品校验时 不自动增行 焦点移至商品校验输入框
            if (uglcw.ui.get('#checkProduct').value()) {
                this.closeCell($(cell));
                setTimeout(function () {
                    uglcw.ui.get('#autocomplete').k().element.focus();
                }, 50);
                return;
            } else if (config.enterSubmit) {
                var row = uglcw.ui.get('#grid').k().dataItem($(cell).closest('tr'));
                if (!row.wareId) {
                    //最后一行空数据
                    event.stopPropagation();
                    draftSaveStk();
                    return;
                }
            }
        }
        if ($(cell).hasClass('cell-product-name') && $(cell).hasClass('k-edit-cell')) {
            if ($(cell).data('scanner')) {
                return;
            }
        }
        _handleEnterKey.call(this, cell, table, editor);
    };
    var grid = uglcw.ui.get('#grid');
    if (markProductChecked()) {
        setTimeout(function () {
            uglcw.ui.get('#checkProduct').value(1);
            $('#checkProduct').trigger('change');
            var targetRow = $('#grid .k-grid-content tr.uglcw-product-checked:last');
            var scrollContentOffset = grid.k().element.find("tbody").offset().top;
            var selectContentOffset = targetRow.offset().top;
            var distance = selectContentOffset - scrollContentOffset;
            grid.k().element.find(".k-grid-content").animate({
                scrollTop: distance
            }, 400);
        }, 200)
    }
    checkPriceDiff();
    checkProductDate();
}

function onGridNavigate(e) {
    var target = e.element;
    var row = $(target).closest('tr');
    row.click();
}

var priceCache = {};

/**
 * 加载商品明细库存和价格
 * @param row 商品数据
 * @param callback 回调
 * @param sync 是否同步
 * @param autoPrice 价格类型 1.客户历史价 0.客户执行价
 */
function loadProductInfo(row, callback, sync, autoPrice) {
    var stkId = uglcw.ui.get('#stkId').value() || '';
    var action = 'querySaleCustomerHisWareStockPrice';
    if (autoPrice == 1) {
        action = 'querySaleCustomerHisWarePrice';
    } else if (autoPrice == 0) {
        action = 'queryCustomerWarePrice';
    }
    if (action == 'querySaleCustomerHisWarePrice') {
        var payload = priceCache[row.wareId + '_' + stkId];
        //商品库存及价格缓存(60s)
        if (payload && (new Date().getTime() - (payload.timestamp || 0) < 60 * 1000)) {
            if ($.isFunction(callback)) {
                callback.call(payload, payload);
                return;
            }
        }
    }

    if (row && row.wareId) {
        var customerId = uglcw.ui.get('#cstId').value();
        $.ajax({
            url: CTX + 'manager/' + action,
            type: 'post',
            async: !!!sync,
            data: {
                stkId: stkId,
                cid: customerId,
                customerId: customerId,
                wareId: row.wareId,
                isCalOcc: uglcw.ui.get('#loadStock').value() || 0
            },
            success: function (response) {
                if (response.state) {
                    var hsNum = row.hsNum;
                    var bUnit = row.wareDw;
                    var sUnit = row.minUnit;
                    var occQty = parseFloat(response.minOccQty);
                    var stkQty = parseFloat(response.minStkQty);
                    var xnQty = parseFloat(response.minXnQty);
                    // minOccQty = Math.floor(minOccQty * 100) / 100;
                    // stkQty = Math.floor(stkQty * 100) / 100;
                    // xnQty = Math.floor(xnQty * 100) / 100;
                    // var occQty = "<span style='color:orangered;font-size:12px'>" + formatterQty(response.occQty, hsNum, bUnit, sUnit) + (minOccQty ? "</span>&nbsp;<span style='color:blue;font-size:10px'>" + (minOccQty || 0) + "<span style='font-size:6px'>" + sUnit + "</span></span>" : '');
                    // var xnQty = "<span style='color:orangered;font-size:12px'>" + formatterQty(response.xnQty, hsNum, bUnit, sUnit) + (xnQty ? "</span>&nbsp;<span style='color:blue;font-size:10px'>" + (xnQty || 0) + "<span style='font-size:6px'>" + sUnit + "</span></span>" : '');
                    // var stkQty = "<span style='color:orangered;font-size:12px'>" + formatterQty(response.stkQty, hsNum, bUnit, sUnit) + (stkQty ? "</span>&nbsp;<span style='color:blue;font-size:10px'>" + (stkQty || 0) + "<span style='font-size:6px'>" + sUnit + "</span></span>" : '');

                     occQty = "<span style='color:orangered;font-size:12px'>" + formatterQty(occQty, hsNum, bUnit, sUnit) + "</span>";
                     xnQty = "<span style='color:orangered;font-size:12px'>" + formatterQty(xnQty, hsNum, bUnit, sUnit) +"</span>";
                     stkQty = "<span style='color:orangered;font-size:12px'>" + formatterQty(stkQty, hsNum, bUnit, sUnit) +"</span>";

                    var payload = {
                        raw: response,
                        wareId: row.wareId,
                        timestamp: new Date().getTime(), //缓存时间
                        hisPrice: response.hisPrice || '',
                        minHisPrice:response.minHisPrice||'',
                        zxPrice: response.zxPrice,
                        orgPrice: row.orgPrice || response.orgPrice,
                        inPrice: response.inPrice || '-',
                        occQty: occQty,
                        xnQty: xnQty,
                        stkQty: stkQty
                    };
                    //缓存数据
                    if (action === 'querySaleCustomerHisWareStockPrice') {
                        priceCache[row.wareId + '_' + stkId] = payload;
                    }
                    if ($.isFunction(callback)) {
                        callback.call(response, payload);
                    }
                }
            }
        })
    }
}
//
// function formatterQty(v, hsNum, bUnit, sUnit) {
//     if (parseFloat(hsNum) > 1) {
//         var str = v + "";
//         if (str.indexOf(".") != -1) {
//             var nums = str.split(".");
//             var num1 = nums[0];
//             var num2 = nums[1];
//             if (parseFloat(num2) > 0) {
//                 var minQty = parseFloat(0 + "." + (num2 || 0)) * parseFloat(hsNum || 0);
//                 minQty = Math.floor(minQty * 100) / 100
//                 return (num1 || 0) + "" + bUnit + "" + (minQty || 0) + "" + sUnit;
//             }
//         }
//     }
//     return (v === undefined ? '' : v) + "<span style='font-size:8px'>" + (bUnit === undefined ? '' : bUnit) + "</span>";
//
// }

function formatterQty(minSumQty, hsNum, bUnit, sUnit) {
     hsNum = hsNum || 1;
    var minSumQty = parseFloat(minSumQty);
    var result = "";
    var remainder = minSumQty % (hsNum);
    if((hsNum+"").indexOf(".")!=-1){
        var sumQty = parseFloat(minSumQty*10000)/parseFloat(hsNum*10000);
        var str = sumQty+"";
        if(str.indexOf(".")!=-1){
            var nums = str.split(".");
            var num1 = nums[0];
            var num2 = nums[1];
            if(parseFloat(num2)>0){
                var minQty = uglcw.util.multiply(0+"."+num2,hsNum);
                //parseFloat(0+"."+num2)*parseFloat(hsNum);
                minQty = minQty.toFixed(2);
                minQty = uglcw.util.toString(minQty,'n2');
                result = num1+""+bUnit+""+minQty+""+sUnit;
            }
        }else{
            result = sumQty+bUnit;
        }
    }else {
        if (remainder === 0) {
            //整数件
            result += '<span style=\'font-size:8px\'>' + minSumQty / hsNum + '</span>' + bUnit;
        } else if (remainder === minSumQty) {
            //不足一件
            var minQty = uglcw.util.toString(minSumQty,'n2');//Math.floor(minSumQty * 100) / 100;
            result += '&nbsp;<span style=\'color:blue;font-size:10px\'>' + minQty + '<span style=\'font-size:6px\'>' + sUnit + '</span></span>';
        } else {
            //N件有余
            var minQty =uglcw.util.toString(remainder,'n2'); //Math.floor(remainder * 100) / 100;//&nbsp;<span style='color:blue;font-size:10px'>" + (minOccQty || 0) + "<span style='font-size:6px'>" + sUnit + "</span>
            result += '<span>' + parseInt(minSumQty / hsNum) + '</span>' + bUnit + '&nbsp;<span style=\'color:blue;font-size:10px\'>' + minQty + '<span style=\'font-size:6px\'>' + sUnit + '</span></span>';
        }
    }
    return result;

}

function productSchema() {
    return {
        validation: {
            required: true,
            warenmvalidation: function (input) {
                if (input.is("[data-model='wareNm']") && input.val() != "") {
                    uglcw.ui.toast('请选择商品');
                    return false;
                }
            }
        }
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

function productNameEditor(container, options) {
    var grid = uglcw.ui.get('#grid');
    var model = options.model;
    $(container).data('enter_count', 0);
    var rowIndex = $(container).closest('tr').index();
    var cellIndex = $(container).index();
    var input = $('<input data-model="wareNm" placeholder="输入商品名称、商品代码、商品条码" />');
    input.appendTo(container);
    var ac = new uglcw.ui.AutoComplete(input);
    ac.init({
        value: model.wareNm,
        highlightFirst: true,
        suggest: true,
        selectable: true,
        click: function () {
            showProductSelectorForRow(model, rowIndex, cellIndex);
        },
        noDataTemplate: function () {
            window.model = model;
            if(xsfpQuickBill !== 'none'){
                return uglcw.util.template($('#product-no-result-tpl').html())({value: ac.value()});
            }else{
                return '未找到该商品';
            }
        },
        dataTextField: 'wareNm',
        autoWidth: true,
        url: CTX + 'manager/dialogOutWarePage',
        data: function () {
            ac.keyword = $(input).val();
            return {
                page: 1, rows: 20,
                state: 1,
                waretype: '',
                stkId: uglcw.ui.get('#stkId').value(),
                wareNm: $(input).val(),
                customerId: uglcw.ui.get('#cstId').value()
            }
        },
        requestStart: function (e) {
            var stkId = uglcw.ui.get('#stkId').value();
            if (!stkId) {
                uglcw.ui.warning('请选择仓库');
                e.preventDefault();
            }
            var cstId = uglcw.ui.get('#cstId').value();
            if (!cstId && xsfpQuickBill == 'none') {
                uglcw.ui.warning('请选择客户');
                input.val('');
                selectCustomer(false);
                e.preventDefault();
            }
        },
        loadFilter: {
            data: function (response) {
                return response.rows || [];
            }
        },
        dataBound: function () {
            var data = this.dataSource.data();
            var val = input.val();
            if (data.length === 1 && $(container).data('scanner')) {
                this.select(this.ul.children().eq(0));
                this.trigger('select', {dataItem: data[0], input: val});
                var nextCell = grid.getNextEditable(container);
                grid.k().current(nextCell);
                grid.k().editCell(nextCell);
            } else if ($(container).data('scanner')) {
                input.val('');
                uglcw.ui.warning('无匹配结果')
            }
        },
        select: function (e) {
            var item = e.dataItem;
            model.hsNum = item.hsNum;
            model.wareCode = item.wareCode;
            model.beBarCode = item.beBarCode;
            model.packBarCode = item.packBarCode;
            model.wareGg = item.wareGg;
            model.sunitFront = item.sunitFront;
            model.wareNm = item.wareNm;
            model.wareDw = item.wareDw;
            model.minUnit = item.minUnit;
            model.minUnitCode = item.minUnitCode;
            model.maxUnitCode = item.maxUnitCode;
            model.wareId = item.wareId;
            model.qty = 1;
            var redMark =$('#redMark').val();
            if(redMark==1){
                model.qty = -1;
            }
            model.productDate = item.productDate || "";
            model.activeDate = item.activeDate || item.qualityDays || '';
            model.sswId = item.sswId || "";
            var input = e.input || (e.sender ? e.sender.element.val() : '');
            if (input === model.packBarCode) {
                model.beUnit = item.maxUnitCode;
                setUnit(model, model.beUnit);
            } else if (input === model.beBarCode) {
                model.beUnit = item.minUnitCode;
                setUnit(model, model.beUnit);
            }else{
                setUnit(model);
            }
            loadProductInfo(model, function (payload) {
                setPrice(model, payload.raw)
            }, true, uglcw.ui.get('#autoPrice').value());
            model.set('amt', model.price * model.qty);
            __formatStkQty(model, true);
            model.dirty = true;
            checkSingleProductDate(model);
            kendoFastReDrawRow(grid.k(), $(container).closest('tr'));
            this.close();
        }
    });
    input.scannerDetection({
        timeBeforeScanTest: 50,
        avgTimeByChar: 40,
        endChar: [13],
        onComplete: function (barcode, qty) {
            $(container).data('scanner', true);
        },
        onError: function (string, qty) {
            $(container).data('scanner', false);
        }
    })
    input.on('blur', function () {
        //uglcw.ui.success("blur"+ $(this).val())
    })
    if(xsfpQuickBill !== 'none'){
        input.on('keydown', function (e) {
        if (e.keyCode == 13 && !addingProduct) {
            var value = input.val();
            if (value && value !== model.wareNm) {
                var dataSource = ac.k().dataSource.data().toJSON(), hit = false;
                $(dataSource).each(function (i, p) {
                    if (p.wareNm === value) {
                        hit = true;
                        return false;
                    }
                })
                if (!hit) {
                    uglcw.ui.info('未找到[' + value + ']！');
                    input.focus();
                    return false;
                    // setTimeout(function () {
                    //     addingProduct = true;
                    //     uglcw.ui.confirm('未找到[' + value + '],是否立即添加？', function () {
                    //         window.model = model;
                    //         saveProduct({wareNm: value}, model, function (m, ware) {
                    //             onProductSelect2([ware]);
                    //             addingProduct = false;
                    //         })
                    //     }, function () {
                    //         addingProduct = false;
                    //     })
                    // })

                }
            }
        }
    })
    }
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

var loadProductInfoDelay;

function qtyEditor(container, options) {
    var model = options.model, input = $('<input uglcw-role="numeric" name="qty" data-bind="value:qty">');
    input.appendTo(container);
    if (model.wareId) {
        clearTimeout(loadProductInfoDelay);
        loadProductInfoDelay = setTimeout(function () {
            loadProductInfo(model, function (info) {
                info.showBlockQty = uglcw.ui.get('#loadStock').value();
                $('.k-animation-container .k-tooltip').remove();
                $(container).kendoTooltip({
                    position: 'top',
                    showOn: 'focus',
                    autoHide: false,
                    offset: 5,
                    content: uglcw.util.template($('#stock-info-tpl').html())({data: info})
                });
                $(container).data('kendoTooltip').show();
            }, false)
        }, 150)

    }
    var widget = new uglcw.ui.Numeric(input);
    widget.init({
        step: false,
        decimals: 10
    });
}

function rebatePriceEditor(container, options) {
    var model = options.model,
        input = $('<input uglcw-role="numeric" name="rebatePrice" data-bind="value: rebatePrice">');
    input.appendTo(container);
    var widget = new uglcw.ui.Numeric(input);
    widget.init({
        step: false,
        min: 0
    });
}

function priceEditor(container, options) {
    var model = options.model, input = $('<input uglcw-role="numeric" name="price" data-bind="value: price">');
    input.appendTo(container);
    if (model.wareId) {
        clearTimeout(loadProductInfoDelay);
        loadProductInfoDelay = setTimeout(function () {
            loadProductInfo(model, function (info) {
                $('.k-animation-container .k-tooltip').remove();
                if(model.beUnit=="S"){
                    if (info.minHisPrice != undefined && info.minHisPrice != '' && info.minHisPrice != 0) {
                        info.hisPrice = info.minHisPrice * model.hsNum;
                    }
                }
                info.hsNum = model.beUnit === 'S' ? model.hsNum : 1;
                info.status = uglcw.ui.get('#status').value();
                info.orgPrice = model.orgPrice || info.orgPrice;

                $(container).kendoTooltip({
                    position: 'top',
                    showOn: 'focus',
                    offset: 5,
                    autoHide: false,
                    content: uglcw.util.template($('#price-tpl').html())({data: info})
                });
                $(container).data('kendoTooltip').show();
            }, false)
        }, 150);

    }
    var widget = new uglcw.ui.Numeric(input);
    widget.init({
        step: false,
        decimals: 10,
        change: function () {

        }
    });
}

function xsTpEditor(container, options) {
    var model = options.model;
    var input = $('<input uglcw-role="combobox" name=\'xsTp\' data-bind=\'value:xsTp\'>');
    input.appendTo(container);
    var widget = new uglcw.ui.ComboBox(input);
    widget.init({
        clearButton: false,
        dataSource: [
            {text: '正常销售', value: '正常销售'},
            {text: '促销折让', value: '促销折让'},
            {text: '消费折让', value: '消费折让'},
            {text: '费用折让', value: '费用折让'},
            {text: '其他销售', value: '其他销售'}]
    });
}

function beUnitEditor(container, options) {
    var model = options.model;
    if (!model.wareId) {
        $(container).html('<span>请先选择产品</span>');
        return;
    }
    var input = $('<input uglcw-role="combobox" name="beUnit" data-bind:"value:beUnit">');
    input.appendTo(container);
    var widget = new uglcw.ui.ComboBox(input);
    var dataSource = [];
    if (model.wareDw) {
        dataSource.push({text: model.wareDw, value: model.maxUnitCode});
    }
    if (model.minUnit) {
        dataSource.push({text: model.minUnit, value: model.minUnitCode});
    }
    widget.init({
        clearButton: false,
        dataSource: dataSource
    })
}

//表格中生产日期编辑器
function productDateEditor(container, options) {
    var model = options.model;
    var gs = $('<input/>')
    gs.appendTo(container);
    var input = $('<input />');
    input.appendTo(container);
    var picker = new uglcw.ui.DatePicker(input);
    picker.init({
        /*popup:{
            appendTo: gs,
        },*/
        format: 'yyyy-MM-dd',
        value: model.productDate ? model.productDate : null,
        change: function () {
            //model.productDate = picker.value();
            //checkProductDate();
            $(container).closest('tr').find('td.cell-product-date').removeClass('produce-date-related')
            gridSelector.value(picker.value())
        },
        select: function () {
            uglcw.ui.toast('selected')
        }
    });
    //隐藏
    picker.element().hide();

    var gridSelector = new uglcw.ui.GridSelector(gs);
    gridSelector.init({
        icon: 'k-i-calendar',
        click: function(){
            picker.k().open();
        },
        value: model.productDate
    })
    gs.focus();
    gs.on('change', function(){
        console.log(gridSelector.value())
        model.dirty = true;
        model.sswId = "";
        model.productDate = gridSelector.value();
    })
}

//表格右键菜单初始化
function initGridContextMenu() {
    $('#grid-menu').kendoContextMenu({
        filter: ".k-grid-content td",
        target: '#grid',
        hideOnClick: true,
        dataSource: [
            {
                text: '插入',
                attr: {
                    action: 'insert'
                }
            },
            {
                text: '删除',
                attr: {
                    action: 'remove'
                }
            },
            {
                text: '切换大小单位',
                attr: {
                    action: 'toggle'
                }
            },
            {
                text: '历史价格',
                attr: {
                    action: 'history'
                }
            },
            {
                text: '复制名称',
                attr: {
                    action: 'copyName'
                }
            },
        ],
        select: function (e) {
            var grid = uglcw.ui.get('#grid');
            var target = $(e.target), row = target.closest('tr');
            var action = $(e.item).attr("action");
            switch (action) {
                case 'insert':
                    var rowIndex = $(row).index();
                    grid.addRow(null, {index: rowIndex + 1, move: false});
                    if ($.isFunction(grid.options.onInsert)) {
                        grid.options.onInsert.call(grid, rowIndex + 1);
                    }
                    break;
                case 'remove':
                    uglcw.ui.confirm('确定删除[' + ($(row).index() + 1) + ']行数据吗?', function () {
                        var rowData = grid.k().dataItem($(row));
                        grid.k().dataSource.remove(rowData);
                    });
                    break;
                case 'toggle':
                    var rowData = grid.k().dataItem($(row));
                    if (rowData.wareId) {
                        toggleUnit(rowData, row.index() + 1, grid.k(), row);
                    }
                    break;
                case 'history':
                    showHistoryPrices(target);
                    break;
                case 'copyName':
                    var rowData = grid.k().dataItem($(row));
                    var el = document.createElement('textarea');
                    el.value = rowData.wareNm;
                    document.body.appendChild(el);
                    el.select();
                    document.execCommand('copy');
                    document.body.removeChild(el);
                    uglcw.ui.success('复制[' + rowData.wareNm + ']成功!');
                    break;
                default:
                    break;
            }
        }
    })
}

//切换单位
function toggleUnit(row, rowNum, grid, tr, rowIndex, cellIndex) {
    if (!(row.wareDw && row.minUnit)) {
        return;
    }

    var tips = '', unit;
    //不移动单元格
    $('#grid').data('_stay_in_current_cell', true);
    if (row.beUnit === row.minUnitCode) {
        unit = row.maxUnitCode;
        tips = row.wareDw;
    } else {
        unit = row.minUnitCode;
        tips = row.minUnit;
    }
    $('#grid').data('_stop_enter_move_tick', true);
    uglcw.ui.confirm('确定切换单位至<span style="color:red; font-weight: bold;">[' + tips + ']</span>？', function () {
        row.beUnit = unit;
        kendoFastReDrawRow(grid, tr);
    }, function () {
    }, {
        title: false,
        closable: false
    });
}

//绑定快捷键
function bindHotKeys() {
    $(document).on('keyup', null, 'F2', function (e) {
        addRow();
    });
    $(document).on('keyup', null, 'ctrl+up', function (e) {
        maxMin();
    });
    $(document).on('keyup', null, 'ctrl+down', function (e) {
        maxMin();
    });
    $(document).on('keyup', null, 'ctrl+space', function (e) {
        $('.master-toggle-bar').click();
    });
    $(document).on('keyup', null, 'space', function (e) {

        var grid = uglcw.ui.get('#grid'), tr;
        var currentCell = grid.k().current();
        var rowIndex, cellIndex;
        if (!currentCell || currentCell.length < 1) {
            tr = $('#grid .k-grid-content tr.k-state-selected');
            rowIndex = tr.index();
        } else {
            tr = $(currentCell).closest('tr');
            rowIndex = tr.index();
            cellIndex = currentCell.index();
        }
        if (tr && tr.length > 0) {
            var row = grid.k().dataItem(tr);
            var rowNum = $(tr).index() + 1;
            if (!row || !row.wareId) {
                return;
            }
            e.stopPropagation();
            e.preventDefault();
            toggleUnit(row, rowNum, grid.k(), tr, rowIndex, cellIndex);
        }
    })
}

//标记表格商品校验
function markProductChecked() {
    var data = uglcw.ui.get('#grid').k().dataSource.data();
    var hit = false;
    var count = config.productCheckCounter;
    var checking = $('#grid').data('_checking');
    $(data).each(function (i, row) {
        if (row.checkWare) {
            if(!checking && row.checkWare == 1){
                row.checkWare = count;
                count-=1;
                $('#grid').data('product_check_count', count);
            }
            $('#grid .k-grid-content tr[data-uid=' + row.uid + ']').addClass('uglcw-product-checked');
            hit = true;
        }
    });
    return hit;
}


/**
 * 挑选二批客户
 */
function selectEpCustomer() {
    uglcw.ui.Modal.showGridSelector({
        title: false,
        area: ['700PX', '350px'],
        showHeader: false,
        url: CTX + 'manager/stkchoosecustomer',
        criteria: '<input style="width: 200px" placeholder="客户名称" uglcw-role="textbox" uglcw-model="khNm">',
        columns: [
            {title: '客户名称', field: 'khNm', width: 130, tooltip: true},
            {title: '手机号', field: 'mobile', width: 100, tooltip: true},
            {title: '地址', field: 'address', width: 150, tooltip: true},
            {title: '联系人', field: 'linkman', width: 100, tooltip: true},
            {title: '部门', field: 'branchName', width: 100, tooltip: true},
            {title: '状态', field: 'shZt', width: 70}
        ],
        success: function (c, grid) {
            var input = uglcw.ui.get($(c).find('[uglcw-model=khNm]'));
            var t;
            input.on('input', function () {
                clearTimeout(t);
                t = setTimeout(function () {
                    grid.reload();
                }, 200)
            })
        },
        btns: false,
        yes: function (data) {
            if (data && data.length > 0) {
                uglcw.ui.bind('.master', {
                    epCustomerId: data[0].id,
                    epCustomerName: data[0].khNm
                })
            }
        }
    })
}

//商品校验回调
function onProductCheck(e) {
    var item = e.dataItem.toJSON();
    var $input = $('#autocomplete');
    var redMark =$('#redMark').val();
    item.qty = 1;
    if(redMark==1){
        item.qty = -1;
    }
    item.price = item.inPrice || '0';
    item.unitName = item.wareDw;
    item.beUnit = item.maxUnitCode;
    item.maxNm = item.wareDw;
    item.minNm = item.minUnit;
    var autoPrice = uglcw.ui.get('#autoPrice').value();
    loadProductInfo(item, function (payload) {
        setPrice(item, payload.raw)
    }, true, autoPrice);
    item.qty = item.qty || item.stkQty || 1;

    var input = e.input || (e.sender ? e.sender.element.val() : '');
    if (input === item.packBarCode) {
        item.beUnit = item.maxUnitCode;
        setUnit(item, item.beUnit);
    } else if (input === item.beBarCode) {
        item.beUnit = item.minUnitCode;
        setUnit(item, item.beUnit);
    } else {
        setUnit(item);
    }
    item.amt = parseFloat(item.qty) * parseFloat(item.price);
    var grid = uglcw.ui.get('#grid');
    var data = grid.k().dataSource.data();
    if (uglcw.ui.get('#checkProduct').value()) {
        var hit = false;
        //校验排序处理
        var count = $('#grid').data('product_check_count') || config.productCheckCounter;
        $(data).each(function (i, row) {
            if (row.wareId == item.wareId) {
                hit = true;
                count -= 1;
                $('#grid').data('product_check_count', count);
                row.checkWare = count;
                $('#grid .k-grid-content tr[data-uid=' + row.uid + ']').addClass('uglcw-product-checked');
            }
        });
        if (hit) {
            //按校验产品排序
            $('#grid').data('_checking', true);
            grid.k().dataSource.sort([
                {field: 'checkWare', dir: 'desc'},
                {field: 'wareId', dir: 'desc'}]
            );
            grid.scrollTop();
        } else {
            uglcw.ui.notice({
                type: 'error',
                title: '商品校验提示',
                message: '未找到商品[' + item.wareNm + ']',
                audio: 1
            })
        }
    } else {
        var filled = false;
        //有空行直接填充
        $(data).each(function (index, row) {
            if (!row.wareId) {
                uglcw.extend(row, item);
                filled = true;
                grid.commit();//否则无法显示新增商品
                return false;
            }
        });
        if (!filled) {
            grid.addRow(item, {move: false});
        }
        // grid.commit();
    }
    $input.data('scanner', false);
    this.close();
    setTimeout(function () {
        $input.focus();
    }, 200);
}

function renderPage() {
    var render = function (config) {
        var columns = config.slave;
        var columnMap = {}, otherMap = {};
        $.map(columns, function (column) {
            columnMap[column.field] = column
        })
        var html = uglcw.util.template($('#slave-tpl').html())({data: columnMap});
        $(html).each(function (i, p) {
            var field = $(p).attr('data-field');
            if (field && columnMap[field]) {
                columnMap[field].html = p.outerHTML;
            }
        })
        var ps = [];
        //字段HTML排序
        $(columns).each(function (i, column) {
            ps.push(columnMap[column.field].html)
        });
        //将字段HTML拼接,插入#grid等待初始化
        $('#grid').html(ps.join(''));

        $.map(config.other, function (item) {
            otherMap[item.field] = item
        })
        otherMap.xsfpQuickBill = xsfpQuickBill === "";
        var toolbarTemplate = uglcw.util.template($('#toolbar-prototype').html())({data: otherMap});
        $('#toolbar').html(toolbarTemplate);
        renderMaster(config.master);
    };
    var templateConfig;
    $.ajax({
        async: false,
        url: CTX + 'static/uglcu/biz/erp/config.json',
        success: function (config) {
            templateConfig = config;
        }
    })
    $.ajax({
        url: CTX + 'manager/common/bill/config/xxfp',
        type: 'GET',
        async: false,
        success: function (response) {
            render(mergeConfig(response.data, templateConfig));
        }
    });
}

function mergeConfig(serverConfig, templateConfig) {
    serverConfig = serverConfig || {}
    serverConfig.master = serverConfig.master || [];
    serverConfig.other = serverConfig.other || [];
    serverConfig.slave = serverConfig.slave || [];
    delete serverConfig['namespace'];
    delete serverConfig['id'];
    $.map(templateConfig, function (configs, key) {
        $(configs).each(function (i, config) {
            var hit = false;
            $(serverConfig[key]).each(function (j, sc) {
                if (sc.field === config.field) {
                    hit = true;
                    return false;
                }
            });
            if (!hit) {
                serverConfig[key].push(config)
            }
        });
    })
    $.map(serverConfig, function (scs, key) {
        var removed = [];
        $(scs).each(function (k, sc) {
            var hit = false;
            $(templateConfig[key]).each(function (l, tc) {
                if (sc.field === tc.field) {
                    hit = true;
                    return false;
                }
            })
            if (!hit) {
                removed.push({
                    group: key,
                    field: sc.field
                })
            }
        })
        if (removed.length > 0) {
            $(removed).each(function (i, item) {
                var index = -1;
                $(serverConfig[item.group]).each(function (j, f) {
                    if (f.field === item.field) {
                        index = j;
                        return false;
                    }
                });
                if (index !== -1) {
                    serverConfig[item.group].splice(index, 1);
                }
            })
        }
    })
    refreshConfig(serverConfig.other);
    return serverConfig;
}

function refreshConfig(other) {
    $(other).each(function (i, item) {
        config[item.field] = !item.hidden
    })
}

function refreshToolbar(other) {
    var otherMap = {};
    $.map(other, function (item) {
        otherMap[item.field] = item
    });
    var toolbarTemplate = uglcw.util.template($('#toolbar-prototype').html())({data: otherMap});
    $('#grid .k-grid-toolbar').html(toolbarTemplate);
    uglcw.ui.init('#grid .k-grid-toolbar');
}

function refreshGrid(columns) {
    //排序 宽度 显示/隐藏
    var widget = uglcw.ui.get('#grid');
    var grid = widget.k();
    var currentColumns = grid.columns;
    var columnsMap = {};
    var newColumns = [];
    $(currentColumns).each(function (i, column) {
        columnsMap[column.field] = column;
        if (column.title === '#' || column.selectable) {
            newColumns.push(column);
        }
    });
    var c = []
    $(columns).each(function (i, column) {
        var newColumn = columnsMap[column.field];
        if (newColumn) {
            if (!column.hidden && newColumn.hidden) {
                c.push(column.field)
            } else {
                newColumn.hidden = column.hidden;
            }
            newColumn.width = column.width;
            newColumns.push(newColumn);
        }
    });
    grid.setOptions({columns: newColumns});
    if (c.length > 0) {
        $(c).each(function (i, field) {
            widget.showColumn(field);
        })
    }
    uglcw.ui.init('.k-grid-toolbar');
}

function renderMaster(master) {
    var masterMap = {};
    $.map(master, function (item) {
        masterMap[item.field] = item;
    });
    var masterHtml = uglcw.util.template($('#master-tpl').html())({data: masterMap});
    $(masterHtml).each(function (i, p) {
        var $p = $(p);
        var model = $p.attr('data-field'), span = $p.attr('data-span'), hide = $p.data('hide');
        if (model && masterMap[model]) {
            if (masterMap[model].hidden || hide) {
                $p.children().addClass('uglcw-hide');
            }
            masterMap[model].span = parseInt(span);
            masterMap[model].html = $p.html();
            masterMap[model].hide = hide;
        }
    });
    var models = [];
    var count = 0;
    var p = '';
    var hiddenFields = '';
    var formGroup = '';
    $(master).each(function (i, model) {
        var options = masterMap[model.field];
        if (!options.hidden && !options.hide) {
            if (count + options.span <= 24) {
                count += options.span;
                p += options.html;
            } else {
                formGroup = '<div class="form-group">' + p + '</div>';
                models.push(formGroup);
                count = options.span;
                p = options.html;
            }
        } else {
            hiddenFields += options.html;
        }
    });
    if (p) {
        formGroup = '<div class="form-group">' + p + '</div>';
        models.push(formGroup);
    }

    $('.form-collapsable').html(models.join(''));
    $(hiddenFields).appendTo($('.form-collapsable'));
}

function customSetting() {
    var modalIndex = uglcw.ui.Modal.open({
        maxmin: false,
        title: '销售开单个性配置',
        content: $('#custom-settings-tpl').html(),
        area: ['600px', '415px'],
        btns: ['保存', '恢复默认', '取消'],
        success: function (c) {
            uglcw.ui.init(c);
            var init = function (config, initialized) {
                $(c).data('initialized', initialized);
                uglcw.ui.get($(c).find('.uglcw-grid.grid-master')).value(config.master);
                uglcw.ui.get($(c).find('.uglcw-grid.grid-slave')).value(config.slave);
                uglcw.ui.get($(c).find('.uglcw-grid.grid-other')).value(config.other);
                $(c).find('.uglcw-grid').each(function () {
                    var that = $(this);
                    uglcw.ui.get(that).k().dataSource.bind("change", function () {
                        that.data('_changed', true);
                    })
                });
            };
            var templateConfig;
            $.ajax({
                async: false,
                url: CTX + 'static/uglcu/biz/erp/config.json',
                success: function (config) {
                    templateConfig = config;
                }
            })
            $.ajax({
                url: CTX + 'manager/common/bill/config/xxfp',
                type: 'GET',
                success: function (response) {
                    init(mergeConfig(response.data, templateConfig), !!response.data);
                }
            });
        },
        yes: function (c) {
            //保存
            uglcw.ui.confirm('确定保存配置吗', function () {
                var delta = [], initialized = $(c).data('initialized');
                var config = {};
                $(c).find('.uglcw-grid').each(function () {
                    var $grid = $(this), type = $grid.data('type'), name = $grid.data('name');
                    var data = $.map(uglcw.ui.get($grid).value(), function (item, index) {
                        item.sort = index;
                        item.type = type;
                        return item;
                    });
                    if (!initialized || (initialized && $grid.data('_changed'))) {
                        delta = delta.concat(data);
                        config[name] = data;
                    }
                });
                var method = initialized ? 'PUT' : 'POST';
                if (delta.length === 0) {
                    uglcw.ui.info('无修改');
                    return uglcw.ui.Modal.close(modalIndex);
                }
                uglcw.ui.loading();
                $.ajax({
                    url: CTX + 'manager/common/bill/config/xxfp',
                    type: method,
                    contentType: 'application/json',
                    data: JSON.stringify({items: delta}),
                    dataType: 'json',
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.success) {
                            uglcw.ui.success(response.message || '保存成功');
                            uglcw.ui.Modal.close();
                            if (config.master) {
                                var masterModels = uglcw.ui.bind('.form-collapsable');
                                renderMaster(config.master);
                                uglcw.ui.init('.form-collapsable');
                                uglcw.ui.bind('.form-collapsable', masterModels);
                            }
                            if (config.other) {
                                refreshToolbar(config.other);
                                refreshConfig(config.other);
                            }
                            if (config.slave) {
                                refreshGrid(config.slave);
                            }
                            uglcw.ui.Modal.close(modalIndex);
                        } else {
                            uglcw.ui.error(response.message || '保存失败');
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                    }
                })
            })
            return false;
        },
        btn2: function (c) {
            uglcw.ui.confirm('确定恢复默认设置吗？', function () {
                $.ajax({
                    url: CTX + 'manager/common/bill/config/xxfp',
                    type: 'DELETE',
                    success: function (response) {
                        if (response.success) {
                            uglcw.ui.success(response.message);
                            $.ajax({
                                async: false,
                                url: CTX + 'static/uglcu/biz/erp/config.json',
                                success: function (config) {
                                    var masterModels = uglcw.ui.bind('.form-collapsable');
                                    renderMaster(config.master);
                                    uglcw.ui.init('.form-collapsable');
                                    uglcw.ui.bind('.form-collapsable', masterModels);
                                    refreshToolbar(config.other);
                                    refreshGrid(config.slave);
                                    uglcw.ui.Modal.close(modalIndex);
                                }
                            });
                        } else {
                            uglcw.ui.error(response.message);
                        }
                    }
                })
            });
            return false;
        }
    })
}

function onCheckboxChange(el) {
    var grid = uglcw.ui.get($(el).closest('.uglcw-grid'));
    var row = grid.k().dataItem($(el).closest('tr'));
    row.set('hidden', !uglcw.util.toBoolean($(el).is(':checked')));
}


function changeVehicle(id) {
    $.ajax({
        url: CTX + '/manager/queryVehicleById?vehId=' + id,
        type: 'post',
        dataType: 'json',
        success: function (response) {
            if (response.state) {
                var data = response.vehicle;
                if (data.driverId != null && data.driverId != "") {
                    //$("#driverId").val(data.driverId);
                    uglcw.ui.get("#driverId").value(data.driverId);
                }
            }
        }
    })

}

var checkPriceDiffDelay;

function checkPriceDiff() {
    if (checkPriceDiffDelay) {
        clearTimeout(checkPriceDiffDelay);
    }
    checkPriceDiffDelay = setTimeout(doCheckPriceDiff, 200);
}

function doCheckPriceDiff() {
    if (uglcw.ui.get('#grid').value().length == 0) {
        return;
    }
    var status = $("#status").val();
    if (status != -2) {
        var data = uglcw.ui.get('#grid').k().dataSource.data();
        $(data).each(function (i, row) {
            if (row.priceFlag == 1) {
                $('#grid .k-grid-content tr[data-uid=' + row.uid + '] td.cell-price').addClass('ware-price-diff-tip')
            }else if(row.priceFlag == 2){
                $('#grid .k-grid-content tr[data-uid=' + row.uid + '] td.cell-price').addClass('ware-first-price-diff-tip')
            }
        })
        return;
    }
    var proType = uglcw.ui.get('#proType').value();
    if (proType != 2) {
        return;
    }
    var orderId = uglcw.ui.get('#orderId').value();
    var cstId = uglcw.ui.get('#cstId').value();
    var billId = uglcw.ui.get('#billId').value();
    var isOrder = "1";
    if (billId == 0 && orderId != 0 && orderId != null && orderId != undefined) {
        isOrder = "0";
        billId = orderId;
    }
    if (COMPARE_HIS_PRICE == 'none' && COMPARE_ZX_PRICE == 'none') {
        return;
    }
    var compareTo = 0;
    if (COMPARE_HIS_PRICE == '') {
        compareTo = 1;
    }
    if (billId == 0 || billId == null || billId == undefined) {
        return;
    }
    $.ajax({
        url: CTX + 'manager/checkOutSubPriceDiff',
        type: "POST",
        data: {"billId": billId, "isOrder": isOrder, "compareTo": compareTo, "customerId": cstId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                setWarePriceDiff(json.diffWareIds);
            }
        }
    });
}

//TODO单行优化
function checkProductDate() {
    if (productDateConfig == '') {
        var grid = uglcw.ui.get('#grid').k();
        var data = grid.dataSource.data();
        if (data.length == 0) {
            return;
        }
        $(data).each(function (i, row) {
             __formatStkQty(row);
            if (row.sswId) {
               // $('#grid tr[data-uid=' + row.uid + ']').find('td.cell-product-date').addClass('produce-date-related')
            }
        })
    }
}

function checkSingleProductDate(model) {
    if (model.sswId) {
        //$('#grid tr[data-uid=' + model.uid + ']').find('td.cell-product-date').addClass('produce-date-related')
    }
}

function setWarePriceDiff(wareIds) {
    wareIds = wareIds || '';
    var data = uglcw.ui.get('#grid').k().dataSource.data();
    $(data).each(function (i, row) {
        var wareId = '$' + row.wareId + ':normal:$';
        if (wareIds.indexOf(wareId) != -1) {
            $('#grid .k-grid-content tr[data-uid=' + row.uid + '] td.cell-price').addClass('ware-price-diff-tip')
        }
        wareId = '$' + row.wareId + ':first:$';
        if (wareIds.indexOf(wareId) != -1) {
            $('#grid .k-grid-content tr[data-uid=' + row.uid + '] td.cell-price').addClass('ware-first-price-diff-tip')
        }
    })
}

function showSnapshot() {
    uglcw.ui.Modal.open({
        title: '快照列表',
        area: ['600px', '350px'],
        content: $('#snapshot-tpl').html(),
        success: function (c) {
            uglcw.ui.init(c);
        },
        btns: false
    })
}

function getBillData() {
    var master = uglcw.ui.bind('.master');
    if (master.status != -2) {
        return false;
    }
    delete master['billNo'];
    delete master['billstatus'];
    delete master['paystatus'];
    var rows = uglcw.ui.get('#grid').value();
    rows = $.map(rows, function (row) {
        if (row.wareId) {
            delete row['id'];
            delete row['_kendo_devtools_id'];
            return row;
        }
    })
    if (rows.length < 20) {
        return false;
    }
    var bill = {master: master, rows: rows};
    return bill;
}

var rawBillData = {};

function loadSnapshot(id) {
    rawBillData = getBillData();
    $.ajax({
        url: CTX + 'manager/common/bill/snapshot/' + id,
        type: 'get',
        success: function (response) {
            if (response.success) {
                $('#cstId').data('silent', true);
                var bill = JSON.parse(response.data.data);
                bill.master.snapshotId = response.data.id;
                uglcw.ui.bind('.master', bill.master);
                uglcw.ui.get('#grid').value(bill.rows);
                uglcw.ui.success('快照加载成功');
                uglcw.ui.Modal.close();
            } else {
                uglcw.ui.error(response.message || '快照加载失败');
            }
        }
    })
}

function removeSnapshot(el, id) {
    var remove = function (e, id) {
        $.ajax({
            url: CTX + '/manager/common/bill/snapshot/' + id,
            type: 'delete',
            success: function (response) {
                if (response.success) {
                    if (e) {
                        uglcw.ui.get($(e).closest('.uglcw-grid')).reload();
                        uglcw.ui.success('快照删除成功');
                        var snapshotId = uglcw.ui.get('#snapshotId').value();
                        if (snapshotId === id) {
                            uglcw.ui.get('#snapshotId').value('');
                        }
                    }
                } else {
                    uglcw.ui.error(response.message || '快照删除失败');
                }
            }
        })
    }
    if (el) {
        uglcw.ui.confirm('确定删除快照吗？', function () {
            remove(el, id)
        })
    } else {
        remove(null, id);
    }

}

var saveSnapshotDelay;

function saveSnapshot() {
    window.clearTimeout(saveSnapshotDelay);
    saveSnapshotDelay = setTimeout(function () {
        var bill = getBillData();
        if (!bill) {
            return;
        }
        var billId = bill.master.billId;
        billId = (billId && billId != '0') ? billId : undefined;
        $.ajax({
            url: CTX + '/manager/common/bill/snapshot',
            contentType: 'application/json',
            type: 'POST',
            data: JSON.stringify({
                title: uglcw.ui.get('#khNm').value(),
                id: uglcw.ui.get('#snapshotId').value(),
                billType: 'xxfp',
                data: bill,
                billId: billId
            }),
            success: function (response) {
                if (response.success) {
                    $('.snapshot-badge-dot').show();
                    uglcw.ui.get('#snapshotId').value(response.data)
                }
            }
        })
    }, 1500);
}

function __formatStkQty(row, valueOnly) {
    if (!row.wareId) {
        row.bUnitSummary = '';
        return
    }
    if (!row.hsNum) {
        row.bUnitSummary = '-';
        return
    }
    var summary = '';
    if (row.beUnit === 'B') {
        summary = row.qty + row.wareDw
    } else {
        var str = (row.qty / row.hsNum) + "";
        if (str.indexOf(".") != -1) {
            var nums = str.split(".");
            var num1 = nums[0];
            var num2 = nums[1];
            summary = parseFloat(num1) > 0 ? (num1 + "" + row.wareDw + "") : ""
            if (parseFloat(num2) > 0) {
                var minQty = Number(parseFloat(0 + "." + num2) * parseFloat(row.hsNum)).toFixed(2);
                minQty = parseFloat(minQty);
                if (minQty > 0) {
                    summary += (parseFloat(minQty) + "" + row.minUnit)
                }
            }
        } else {
            summary = (parseFloat(Number(row.qty / row.hsNum)) || '') + (row.wareDw || '');
        }
    }
    row.bUnitSummary = summary;
    if (!valueOnly) {
        $('#grid .k-grid-content tr[data-uid="' + row.uid + '"] td.cell-unit-summary').html(summary);
    }
    return summary;
}

function checkSubmitData() {
    var m = new Map()
    //var sswIds = "";
    var productDates="";
    var products = uglcw.ui.get('#grid').bind();
    if (products.length < 1) {
        uglcw.ui.error('请选择商品');
        return;
    }
    $.map(products, function (product) {
        if (product.wareId && product.productDate) {
            var qty = product.qty;
            var sswId = product.sswId;
            var productDate = product.productDate;
            var beUnit = product.beUnit;
            var hsNum = product.hsNum;
            if (beUnit == 'S') {//计量单位
                var tempQty = 0;
                tempQty = qty / hsNum;
                tempQty = parseFloat(tempQty);
                qty = tempQty;
            }
            var key = product.wareId+"$"+ product.wareNm + "$" + productDate;
            if (m.containsKey(key)) {
                var tQty = m.get(key);
                tQty = parseFloat(tQty) + parseFloat(qty);
                m.put(key, tQty)
            } else {
                // if (sswIds != "") {
                //     sswIds = sswIds + ",";
                // }
                // sswIds = sswIds + sswId;
                if(productDates!=""){
                    productDates = productDates+",";
                }
                productDates = productDates + "'"+productDate+"'";
                m.put(key, qty);
            }
        }
    });
    var stkId = uglcw.ui.get('#stkId').value();
    //$.ajaxSettings.async = false;
    var bool = true;
    if (productDates != "") {
        $.ajax({
            url: CTX + "manager/queryByWareByIds",
            type: "POST",
            data: {"stkId": stkId, "productDates": productDates},
            dataType: 'json',
            async: false,
            success: function (json) {
                var mm = new Map();

                if (json.rows != undefined) {
                    var size = json.rows.length;
                    for (var i = 0; i < size; i++) {
                        var data = json.rows[i];
                        var key = data.wareId +"$"+data.wareNm+ "$" + data.productDate;
                        // if (m.containsKey(key)) {
                        //     var qty = m.get(key);
                        //     var stkQty = data.qty;
                        //     if (parseFloat(qty) > parseFloat(stkQty)) {
                        //         uglcw.ui.warning(data.wareNm + '数量大于该批次库存数量(' + stkQty + ')!');
                        //         bool = false;
                        //     }
                        // }
                        mm.put(key,data.qty);
                    }
                }

                for(var i = 0;i<m.keys.length;i++){
                    var key = m.keys[i];
                    var qty = m.get(key);
                    var o = key.split("$");
                    var stkQty = 0;
                    if(mm.containsKey(key)){
                        stkQty = mm.get(key);
                    }
                    if (parseFloat(qty) > parseFloat(stkQty)) {
                        uglcw.ui.warning(o[1] + '数量大于该批次库存数量(' + stkQty + ')!');
                        bool = false;
                    }
                }
            }
        })
    }
    return bool;
}
