function onGridDataBound() {
    var init = $('#grid').data('toolbarInit');
    if (!init) {
        uglcw.ui.init('#grid .k-grid-toolbar');
        $('#grid').data('toolbarInit', true);
    }
}

function productNameEditor(container, options) {
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
                stkId: uglcw.ui.get('#stkId').value(),
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
            var item = e.dataItem;
            var model = options.model;
            model.inTypeCode = 10001;
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
            laodHisInPrice(model);
            uglcw.ui.get('#grid').commit();
            uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex-1);
        }
    });
}

function unitEditor(container, options) {
    var model = options.model;
    if (!model.wareId) {
        $(container).html('<span>请先选择产品</span>');
        return;
    }
    var input = $('<input name=\'beUnit\' data-bind:\'value:beUnit\'>');
    input.appendTo(container);
    var widget = new uglcw.ui.ComboBox(input);
    widget.init({
        dataSource: [
            {text: model.wareDw, value: model.maxUnitCode},
            {text: model.minUnit, value: model.minUnitCode}
        ]
    })
}

function productDateEditor(container, options){
    var model = options.model;
    var input = $('<input data-bind="value:productDate" name="productDate"/>');
    input.appendTo(container);
    var picker = new uglcw.ui.DatePicker(input);
    picker.init({
        format: 'yyyy-MM-dd',
    });
    picker.k().open();
}

