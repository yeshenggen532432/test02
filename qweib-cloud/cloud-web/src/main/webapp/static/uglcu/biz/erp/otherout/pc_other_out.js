var config = {
    editors: {
        beUnit: function (container, options) {
            var model = options.model;
            if (!model.wareId) {
                $(container).html('<span>请先选择产品</span>');
                return;
            }
            var input = $('<input name="beUnit" data-bind="value:beUnit">');
            input.appendTo(container);
            var widget = new uglcw.ui.ComboBox(input);
            widget.init({
                dataSource: [
                    {text: model.wareDw, value: model.maxUnitCode},
                    {text: model.minUnit, value: model.minUnitCode}
                ]
            })
        },
        wareNm: function (container, options) {
            var model = options.model;
            var row = $(container).closest('tr');
            var input = $('<input data-model="wareNm"  placeholder="输入商品名称、商品代码、商品条码" />');
            input.appendTo(container);
            var ac = new uglcw.ui.AutoComplete(input) ;
            ac.init({
                value: model.wareNm,
                dataTextField: 'wareNm',
                autoWidth: true,
                selectable: true,
                click: function () {
                    showProductSelectorForRow(model, rowIndex, cellIndex);
                },
                url: '/manager/dialogWarePage',
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
                template: '<div><span>#= data.wareNm#</span><span class="float: right">#data.wareGg#</span></div>',
                select: function (e) {
                    var item = e.dataItem;
                    model.hsNum = item.hsNum;
                    model.wareCode = item.wareCode;
                    model.wareGg = item.wareGg;
                    model.wareNm = item.wareNm;
                    model.wareDw = item.wareDw;
                    model.price = 0;
                    model.qty = 1;
                    model.beUnit = item.maxUnitCode;
                    model.wareId = item.wareId;
                    model.minUnit = item.minUnit;
                    model.minUnitCode = item.minUnitCode;
                    model.maxUnitCode = item.maxUnitCode;
                    model.remarks = item.remarks || '';
                    model.productDate = item.productDate || '';
                    model.qualityDays = item.qualityDays;
                    model.dirty=true;
                    model.set('amt', parseFloat(model.qty) * parseFloat(model.price));
                    uglcw.ui.get('#grid')._renderRow(row);
                    this.close();
                }
            });
        },
        productDate: function (container, options) {
            var model = options.model;
            var input = $('<input  data-bind="value:productDate" />');
            input.appendTo(container);
            var picker = new uglcw.ui.DatePicker(input);
            picker.init({
                format: 'yyyy-MM-dd',
                value: model.productDate ? model.productDate : new Date()
            });
            picker.k().open();
        }
    },
    dataBound:function(){

    }
}

