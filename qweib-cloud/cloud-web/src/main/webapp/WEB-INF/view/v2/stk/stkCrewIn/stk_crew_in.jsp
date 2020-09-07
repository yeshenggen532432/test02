<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>商品入仓单</title>
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
    <div class="layui-card master">
        <div class="layui-card-header btn-group">
            <ul uglcw-role="buttongroup">
                <li onclick="add()" data-icon="add" class="k-info">新建</li>
                <c:if test="${stkCrewIn.status eq -2}">
                    <li onclick="drageSave()" id="btndraft" class="k-info" data-icon="save">暂存</li>
                </c:if>
                <%--<c:if test="${permission:checkUserFieldPdm('stk.stkCrewIn.audit')}">--%>
                <li onclick="audit()" id="btnaudit" class="k-info" data-icon="track-changes-accept"
                    style="display: ${(stkCrewIn.id ne 0 and stkCrewIn.status eq -2)?'':'none'}">审批
                </li>
                <%--</c:if>--%>
                <%--<c:if test="${permission:checkUserFieldPdm('stk.stkCrewIn.cancel')}">--%>
                <%--<li onclick="cancel()" id="btncancel" class="k-info" data-icon="delete" style="display: ${stkCrewIn.id eq 0 or stkCrewIn.status eq 2 or stkCrewIn.status eq 1?'none':''}">作废</li>--%>
                <%--</c:if>--%>
                <%--<c:if test="${stkCrewIn.status ne -2 }">--%>
                <%--<c:if test="${permission:checkUserFieldPdm('stk.stkCrewIn.print')}">--%>
                <%--<li onclick="toPrint()" id="btnprict" class="k-info" data-icon="print" style="display: ${stkCrewIn.id eq 0?'none':''}">打印</li>--%>
                <%--</c:if>--%>
                <%--</c:if>--%>
            </ul>
            <div class="bill-info">
                <div class="no" style="color:green;"><span id="billNo" uglcw-model="billNo" style="height: 25px;"
                                                           readonly uglcw-role="textbox">${stkCrewIn.billNo}</span>
                </div>
                <div class="status" style="color:red;">
                    <c:choose>
                        <c:when test="${stkCrewIn.status eq -2 and not empty stkCrewIn.id and stkCrewIn.id ne 0}"><span
                                id="billStatus" style="height: 25px;width: 80px" uglcw-model="billstatus"
                                uglcw-role="textbox">暂存</span></c:when>
                        <c:when test="${stkCrewIn.status eq 1}"><span id="billStatus" style="height: 25px;width: 80px"
                                                                      uglcw-model="billstatus"
                                                                      uglcw-role="textbox">已审批</span></c:when>
                        <c:when test="${stkCrewIn.status eq 2}"><span id="billStatus" style="height: 25px;width: 80px"
                                                                      uglcw-model="billstatus"
                                                                      uglcw-role="textbox">已作废</span></c:when>
                        <c:otherwise>
                            <span id="billStatus" style="height: 25px;width: 80px" uglcw-model="billstatus"
                                  uglcw-role="textbox">新建</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="${stkCrewIn.id}"/>
                <input type="hidden" uglcw-model="bizType" uglcw-role="textbox" id="bizType"
                       value="${stkCrewIn.bizType}"/>
                <input type="hidden" uglcw-model="proName" uglcw-role="textbox" id="proName"
                       value="${stkCrewIn.proName}"/>
                <input type="hidden" uglcw-model="proId" uglcw-role="textbox" id="proId" value="${stkCrewIn.proId}"/>
                <input type="hidden" uglcw-model="proType" uglcw-role="textbox" id="proType"
                       value="${stkCrewIn.proType}"/>
                <input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status"
                       value="${stkCrewIn.status}"/>
                <div class="form-group">
                    <label class="control-label col-xs-3">入库时间</label>
                    <div class="col-xs-4">
                        <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="inDate" value="${stkCrewIn.inDate}">
                    </div>
                    <label class="control-label col-xs-3">仓库</label>
                    <div class="col-xs-4">
                        <uglcw:storage-select base="${base}" id="stkId" name="stkId" type="0" value="${stkCrewIn.stkId}"
                                            dataBound="loadDataInit" change="loadDataInit()"/>
                    </div>
                    <label class="control-label col-xs-3">入库单</label>
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="sourceId" id="sourceId"
                               value="${stkCrewIn.sourceId}"/>
                        <input uglcw-role="textbox" uglcw-model="sourceNo" value="${stkCrewIn.sourceNo}"
                               readonly
                        <%--uglcw-options="allowInput: false,--%>
                        <%--<c:if test="${not empty sourceNo}">--%>
                        <%--clearButton: false,--%>
                        <%--</c:if>--%>
                        <%--click: showBillInfo"--%>
                        />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                    <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${stkCrewIn.remarks}</textarea>
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
                          dataSource:${fns:toJson(stkCrewIn.list)}
                        '
            >

                <div data-field="wareCode" uglcw-options="
                                 width: 120,
                                 hidden: true,
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
                                        model.inQty = 0;
                                        uglcw.ui.get('#grid').commit();
                                        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
                                    }
                                });
                           }
                        ">产品名称
                </div>
                <div data-field="wareGg" uglcw-options="width: 120,hidden: true, editable: false">产品规格</div>
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
                <div data-field="inStkId" uglcw-options="width: 150,
                                     template: '#= data.inStkName||\'\'#',
									 editor: function(container, options){
										var input = $('<input>');
										input.appendTo(container);
										var model = options.model;
										var selector = new uglcw.ui.ComboBox(input);
										selector.init({
										    value: model.inStkId,
											dataSource:itemsJson,
											dataTextField: 'houseName',
											dataValueField: 'id',
											select: function(e){
												var item = e.dataItem;
												model.inStkId = item.id,
												model.inStkName = item.houseName;
											}
										});
										//selector.value(tempHouseId);
									}">移入库位
                </div>
                <div data-field="price"
                     uglcw-options="width: 100, hidden: true, schema:{ type:'number',decimals:10}">
                    单价
                </div>
                <div data-field="qty" uglcw-options="width: 100,
                            aggregates: ['sum'],
                            schema:{ type: 'number',decimals:10},
                            footerTemplate: '#= (sum || 0) #'
                       ">移入数量
                </div>
                <div data-field="inQty" uglcw-options="width: 120,editable: false,hidden:${empty stkCrewIn.sourceId?true:false}">待入仓
                </div>
                <div data-field="inQty1" uglcw-options="width: 120,hidden: true,editable: false">待入数量2
                </div>
                <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
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
                item.inQty = item.qty || item.stkQty || 1;
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
<script>
    $(function () {
        uglcw.ui.init();

        <c:if test="${stkCrewIn.inDate == null}">
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
                if(e.field === 'qty') {
                    var sourceId =$("#sourceId").val();
                    if(sourceId!=""){
                        dealDataTab(item.wareId);
                    }else{
                        uglcw.ui.get('#grid').commit();
                    }
                }
            }

        })
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        uglcw.ui.loaded();
        //uglcw.ui.get('#sourceId').on('change', laodBillSub);
        <c:if test="${not empty stkCrewIn.sourceId and stkCrewIn.id eq 0}">
        laodBillSub();
        </c:if>
    });


    function dealDataTab(wareId) {
        var datas = uglcw.ui.get('#grid').bind();
        var sumQty = 0;
        var sumInQty = 0;
        var sumInQty1 = 0;
        for (var i = 0; i < datas.length; i++) {
            var item = datas[i];
            if (item.wareId == wareId) {
                sumQty = sumQty + parseFloat(item.qty || 0);
                sumInQty1 = sumInQty1 + parseFloat(item.inQty1 || 0);
            }
        }
        sumInQty = parseFloat(sumInQty1) - parseFloat(sumQty);
        $(datas).each(function (i, item) {
            if (item.wareId == wareId) {
                item.inQty = sumInQty;
            }
            return item;
        });
        uglcw.ui.get('#grid').bind(datas);
        refreshGrid();
    }

    var delay;
    function refreshGrid(){
        clearTimeout(delay);
        delay = setTimeout(function(){
            uglcw.ui.get("#grid").k().refresh();
        }, 50);
    }


    function showProductSelector() {
        // if (!uglcw.ui.get('#stkId').value()) {
        //     return uglcw.ui.error('请选择仓库');
        // }
        <tag:product-out-selector-script callback="onProductSelect"/>
    }


    function onQueryProduct(param) {
        // param.stkId = uglcw.ui.get('#stkId').value();
        param.stkId = 0;
        return param;
    }


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

                // "price": json.list[i].wareDj,
                //     "sunitFront": json.list[i].sunitFront,
                //     "sunitPrice":json.list[i].sunitPrice,
                row.price = row.wareDj || '0';
                row.unitName = row.wareDw;
                row.beUnit = row.maxUnitCode;
                row.qty = 1;
                row.inQty = 1;
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
        uglcw.ui.openTab('商品入仓单', '${base}manager/stkCrewIn/add?billId=0&r=' + new Date().getTime());
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

    function addRow() {
        uglcw.ui.get('#grid').addRow({});
    }


    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }

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
        // if (form.stkId == form.stkInId) {
        //     return uglcw.ui.error('出入仓库不能相同！');
        // }

        if (form.stkId == 0 || form.stkId == "") {
            return uglcw.ui.error('仓库不能位空！')
        }

        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 1) {
            return uglcw.ui.error('请添加明细');
        }

        for (var i = 0; i < list.length; i++) {
            var item = list[i];
            if (item.wareId == "") {
                bool = true;
                return uglcw.ui.error('第("' + (i + 1) + '")行，未关联商品');
            }
            if (item.qty == "" || item.qty == 0) {
                bool = true;
                return uglcw.ui.error('第("' + (i + 1) + '")行，存放数量不能为0');
            }
            if (
                item.inStkId == ""
                || item.inStkId == 0
                || item.inStkId == undefined) {
                bool = true;
                return uglcw.ui.error('第("' + (i + 1) + '")行，移入库位不能位空');
            }
        }
        var bool = false;
        $(list).each(function (idx, item) {
            delete item['productDate'];
            delete item['id'];
            $.map(item, function (v, k) {
                form['list[' + idx + '].' + k] = v;
            })
        });
        if (bool) {
            return;
        }
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/stkCrewIn/save',
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
                    //uglcw.ui.replaceCurrentTab('理货信息' + response.id, '${base}manager/stkCrewIn/show?billId=' + response.id)
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
                url: '${base}manager/stkCrewIn/audit',
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
        uglcw.ui.openTab('打印商品出仓单${stkCrewIn.id}', '${base}manager/stkCrewIn/print?billId=' + billId);
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
                url: '${base}manager/stkCrewIn/cancel',
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

    var itemsJson = [];
    var tempHouseId = 0;

    function loadDataInit() {
        var stkId = $("#stkId").val();
        if (stkId) {
            $.ajax({
                url: "${base}/manager/stkHouse/dataList",
                type: "POST",
                data: {"stkId": stkId, "status": 1},
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.list != undefined) {
                        itemsJson = json.list;
                        for (var i = 0; i < json.list.length; i++) {
                            var item = json.list[i];
                            if (item.houseName == "临时库位") {
                                tempHouseId = item.id;
                            }
                        }
                        if(${stkCrewIn.id}==0){
                            var list = uglcw.ui.get('#grid').bind();
                            $(list).each(function (idx, item) {
                                item.inStkId = tempHouseId;
                                item.inStkName = '临时库位';
                                return item;
                            });
                            uglcw.ui.get('#grid').value(list);
                            uglcw.ui.get('#grid').commit();
                        }
                    }
                }
            })
        }
    }

    function selectInBill() {
        var sdate = uglcw.util.toString(new Date(), "yyyy-MM-01");
        var edate = uglcw.util.toString(new Date(), "yyyy-MM-dd");
        uglcw.ui.Modal.showGridSelector({
            title: '请选择入库发票',
            closable: false,
            width: 800,
            height: 400,
            checkbox: false,
            url: '${base}/manager/queryPageForCrew',
            criteria: '<input style="width: 120px;" uglcw-role="textbox" uglcw-model="billNo" placeholder="发票单号">' +
                '<input style="width: 120px;" uglcw-role="textbox" uglcw-model="proName" placeholder="供应商">' +
                '<input style="width: 120px;" uglcw-role="datepicker" value="' + sdate + '" uglcw-model="sdate" placeholder="开始时间">' +
                '<input style="width: 120px;" uglcw-role="datepicker" value="' + edate + '"  uglcw-model="edate" placeholder="结束时间">'
            ,
            query: function (params) {
                return params;
            },
            columns: [
                {title: '发票单号', field: 'billNo', width: 150, tooltip: true},
                {title: '发票日期', field: 'inDate', width: 100},
                {title: '供应商', field: 'proName', width: 120, tooltip: true},
                {title: '入库类型', field: 'inType', width: 120, tooltip: true},
                {title: '仓库', field: 'stkName', width: 120, tooltip: true},
                {title: '创建人', field: 'operator', width: 80, tooltip: true},
                {title: '发票状态', field: 'billStatus', width: 120, tooltip: true},
                {title: '备注', field: 'remarks', width: 120, tooltip: true}
            ],
            yes: function (data) {
                if (data && data.length > 0) {
                    var bill = data[0];
                    var $proId = $('#proId');
                    $proId.data('silent', true);
                    uglcw.ui.bind('.master', {
                        sourceId: bill.id,
                        sourceNo: bill.billNo,
                        proId: bill.proId,
                        proName: bill.proName,
                        proType: bill.proType,
                        stkId: bill.stkId
                    })
                    //清除客户不触发变更提示
                    $proId.removeData('silent');
                }
            }
        })
    }

    function laodBillSub() {
        var sourceId = $("#sourceId").val();
        if (sourceId) {
            $.ajax({
                url: "${base}/manager/stkCrewIn/getBillInfo",
                type: "POST",
                data: {"billId": sourceId},
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.state) {
                        var stkIn = json.stkIn;
                        var $proId = $('#proId');
                        $proId.data('silent', true);
                        uglcw.ui.bind('.master', {
                            sourceId: stkIn.id,
                            sourceNo: stkIn.billNo,
                            proId: stkIn.proId,
                            proName: stkIn.proName,
                            proType: stkIn.proType,
                            stkId: stkIn.stkId
                        });
                        //清除客户不触发变更提示
                        $proId.removeData('silent');
                        var list = stkIn.list;
                        // var stkId = stkIn.stkId;
                        // var stkName = stkIn.stkName;
                        if (list) {
                            list = $.map(list, function (item) {
                                var row = item;
                                if ($.isFunction(item.toJSON)) {
                                    row = item.toJSON();
                                }
                                row.price = item.price;
                                row.unitName = item.unitName;
                                row.beUnit = item.beUnit;
                                //row.qty = item.inQty1;
                                row.qty = 0;
                                //row.qty = item.qty;
                                row.inQty = item.inQty1;
                                row.inQty1 = item.inQty1;
                                row.amt = parseFloat(row.qty) * parseFloat(row.price);
                                row.productDate = item.productDate;
                                return row;
                            })
                            uglcw.ui.get('#grid').value(list);
                            uglcw.ui.get('#grid').commit();
                            uglcw.ui.get('#grid').scrollBottom();
                        }
                        //loadDataInit();
                    } else {
                        uglcw.ui.error("明细加载失败");
                    }
                }
            })
        }
    }

    function loadStkWareQty(model, wareId, stkId) {
        if (wareId && stkId) {
            $.ajax({
                url: "${base}/manager/getStorageWareQty",
                type: "POST",
                data: {"wareId": wareId, "stkId": stkId},
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.state) {
                        var stkQty = json.stkQty;
                        if (stkQty < 0) {
                            uglcw.ui.error("当前库位该商品位0!");
                            model.set("qty", 0);
                            model.set("inQty", 0);
                        } else {
                            model.set("qty", stkQty);
                            model.set("inQty", stkQty);
                        }
                    } else {
                        uglcw.ui.error("明细加载失败");
                    }
                }
            })
        }
    }

    function showBillInfo() {
        var sourceId = $("#sourceId").val();

    }

</script>
</body>
</html>
