<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>生产入库管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card master">
        <div class="layui-card-header btn-group">
            <ul uglcw-role="buttongroup">
                <li onclick="add()" data-icon="add" class="k-info">新建</li>
                <c:if test="${stkProduce.status eq -2}">
                    <li onclick="draftSave()" class="k-info" data-icon="save">暂存</li>
                    <c:if test="${stkProduce.id > 0}">
                        <li onclick="audit()" class="k-info" data-icon="track-changes-accept">审批</li>
                    </c:if>
                </c:if>
                <c:if test="${stkProduce.status eq 0}">
                    <li onclick="auditSh()" data-icon="check">确认入库</li>
                </c:if>
                <c:if test="${stkProduce.status ne -2 and stkProduce.status ne 2}">
                    <li onclick="cancelClick()" class="k-info" data-icon="delete">作废</li>
                </c:if>
            </ul>
            <div class="bill-info">
                <span class="no" style="color: green;">${stkProduce.billName} ${stkProduce.billNo}</span>
                <span class="status" style="color:red;">
                     <c:choose>
                         <c:when test="${stkProduce.status eq -2}">暂存</c:when>
                         <c:when test="${stkProduce.status eq 0}">未入库</c:when>
                         <c:when test="${stkProduce.status eq 1}">已入库</c:when>
                         <c:when test="${stkProduce.status eq 2}">已作废</c:when>
                         <c:otherwise>
                             新建
                         </c:otherwise>
                     </c:choose>
                </span>
            </div>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input type="hidden" uglcw-role="textbox" uglcw-model="id" id="billId" value="${stkProduce.id}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="bizType" id="bizType" value="${stkProduce.bizType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="stkName" id="stkName" value="${stkProduce.stkName}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="proName" id="proName" value="${stkProduce.proName}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="proType" id="proType" value="5"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${stkProduce.status}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="ioMark" id="ioMark" value="${stkProduce.ioMark}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="billName" id="billName"
                       value="${stkProduce.billName}"/>
                <div class="form-group">
                    <label class="control-label  col-md-3">单据时间</label>
                    <div class=" col-md-4">
                        <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="inDate" value="${stkProduce.inDate}">
                    </div>
                    <label class="control-label col-md-3">仓&nbsp;&nbsp;&nbsp;&nbsp;库</label>
                    <div class=" col-md-4">
                        <tag:select2 name="stkId" id="stkId" tclass="pcl_sel" tableName="stk_storage" index="0"
                                     value="${stkProduce.stkId }" displayKey="id"
                                     whereBlock="status=1 or status is null"
                                     displayValue="stk_name"/>
                    </div>
                    <label class="control-label col-md-3">车&nbsp;&nbsp;&nbsp;&nbsp;间</label>
                    <div class="col-md-4">
                        <tag:select2 name="proId" id="proId" tclass="pcl_sel" tableName="sys_depart" index="0"
                                     value="${stkProduce.proId }" displayKey="branch_id" displayValue="branch_name"/>
                    </div>
                </div>
                <div class="form-group"
                     style="display: ${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2 )?'':'none' }">
                    <label class="control-label col-xs-3">制造费用</label>
                    <div class="col-xs-4">
                        <input id="totalAmount" readonly uglcw-options="spinners: false, format: 'n2'"
                               uglcw-role="numeric"
                               uglcw-model="referCostAmt" value="${stkProduce.referCostAmt}"
                        >
                    </div>
                    <label class="control-label col-xs-3">本次分摊</label>
                    <div class="col-xs-4">
                        <input id="discount" uglcw-role="numeric" uglcw-model="costAmt" value="${stkProduce.costAmt}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">备注</label>
                    <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${stkProduce.remarks}</textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div uglcw-role="tabs">
                <ul>
                    <li>入库产品</li>
                    <li>原料总消耗</li>
                    <li>各产品材料消耗</li>
                </ul>
                <div>
                    <div id="grid" uglcw-role="grid"
                         uglcw-options='
                          id: "id",
                          editable: true,
                          dragable: true,
                          toolbar: kendo.template($("#toolbar").html()),
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource: gridDataSource
                        '
                    >
                        <div data-field="checkbox"
                             uglcw-options=" width: 50,
                            selectable: true,
                            type: 'checkbox',
                            headerAttributes: {'class': 'uglcw-grid-checkbox'}"
                        ></div>
                        <div data-field="wareCode" uglcw-options="
                            width: 150,
                            editor: function(container, options){
                                var input = $('<input placeholder=\'输入关键字\' />');
                                input.appendTo(container);
                                new uglcw.ui.AutoComplete(input).init({
                                    dataTextField: 'wareNm',
                                    autoWidth: true,
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
                                        model.inTypeCode = 10001;
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
                                        model.productDate = item.productDate || new Date();
                                        uglcw.ui.get('#grid').commit();
                                    }
                                });
                           }
                        ">产品编号
                        </div>
                        <div data-field="wareNm" uglcw-options="width: 150, schema:{editable: false}">产品名称</div>
                        <div data-field="wareGg" uglcw-options="width: 150, schema:{editable: false}">产品规格</div>
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
                              dataSource:[
                              { text: model.wareDw, value:model.maxUnitCode },
                              { text: model.minUnit, value:model.minUnitCode}
                              ]
                             })
                            }
                        ">单位
                        </div>
                        <c:if test="${permission:checkUserFieldPdm('stk.stkIn.lookqty')}">
                            <div data-field="qty" uglcw-options="width: 150,
                            aggregates: ['sum'],
                            footerTemplate: '#= (sum || 0) #'
                    ">入库数量
                            </div>
                        </c:if>
                        <c:if test="${permission:checkUserFieldPdm('stk.stkIn.lookprice')}">
                            <div data-field="price"
                                 uglcw-options="width: 150, format:'{0: n2}', schema:{editable: true, type:'number', validation:{required:true, min:0}}">
                                单价
                            </div>
                        </c:if>
                        <div data-field="amt" uglcw-options="width: 150,
                            format:'{0: n2}',
                            schema:{editable: true},
                            aggregates: ['sum'],
                            editor: function(container, options){ $('<span>'+options.model.amt+'</span>').appendTo(container)},
                            footerTemplate: '#= (sum || 0) #'">入库金额
                        </div>
                        <div data-field="productDate" uglcw-options="width: 150, format: 'yyyy-MM-dd',
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
                        <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
                    </div>
                </div>
                <div>
                    <div id="grid2" uglcw-role="grid"
                         uglcw-options='
                          id: "id",
                          editable: true,
                          dragable: true,
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource:${fns:toJson(combItems)}
                        '
                    >
                        <div data-field="checkbox"
                             uglcw-options=" width: 50,
                            selectable: true,
                            type: 'checkbox',
                            headerAttributes: {'class': 'uglcw-grid-checkbox'}"
                        ></div>
                        <div data-field="wareCode">原料编号</div>
                        <div data-field="wareNm">原料名称</div>
                        <div data-field="wareGg">原料规格</div>
                        <div data-field="beUnit"
                             uglcw-options=" template: '#= data.beUnit == data.maxUnitCode ? data.wareDw||\'\' : data.minUnit||\'\' #',">
                            单位
                        </div>
                        <div data-field="planQty">计划数量</div>
                        <div data-field="qty">实际数量</div>
                        <c:if test="${stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2}">
                            <div data-field="price">直接成本价</div>
                            <div data-field="amt">直接成本金额</div>
                        </c:if>
                    </div>
                </div>
                <div>
                    <div id="grid3" uglcw-role="grid"
                         uglcw-options='
                          id: "id",
                          editable: true,
                          dragable: true,
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource:${fns:toJson(stkProduce.itemList)}
                        '
                    >
                        <div data-field="checkbox"
                             uglcw-options=" width: 50,
                            selectable: true,
                            type: 'checkbox',
                            headerAttributes: {'class': 'uglcw-grid-checkbox'}"
                        ></div>
                        <div data-field="relaWareId"
                             uglcw-options="values: relaWareValues">入库产品
                        </div>
                        <div data-field="wareCode">原料编号</div>
                        <div data-field="wareNm">原料名称</div>
                        <div data-field="wareGg">原料规格</div>
                        <div data-field="beUnit"
                             uglcw-options=" template: '#= data.beUnit == data.maxUnitCode ? data.wareDw||\'\' : data.minUnit||\'\' #',">
                            单位
                        </div>
                        <div data-field="planQty">计划数量</div>
                        <div data-field="qty">实际数量</div>
                        <c:if test="${stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2}">
                            <div data-field="price">成本单价</div>
                            <div data-field="amt">成本金额</div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<tag:compositive-selector-template/>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:addRow();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-add"></span>加一行
    </a>
    <a role="button" href="javascript:showProductSelector()" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-cart"></span>添加商品
    </a>
    <a role="button" href="javascript:batchRemove();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-delete"></span>批量删除
    </a>
    <a role="button" href="javascript:scrollToGridTop();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-arrow-end-up"></span>
    </a>
    <a role="button" href="javascript:scrollToGridBottom();" class="k-button k-button-icontext k-grid-add-purchase">
        <span title="滚动至底部" class="k-icon k-i-arrow-end-down"></span>
    </a>
    <a role="button" href="javascript:saveChanges();" class="k-button k-button-icontext k-grid-add-purchase">
        <span title="滚动至顶部" class="k-icon k-i-check"></span>
    </a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var gridDataSource = ${fns:toJson(warelist)};
    var relaWareValues = [];
    $(function () {
        relaWareValues = $.map(${empty stkProduce.subList ? '[]' : fns:toJson(stkProduce.subList)}, function(item){
            return {
                text: item.wareId,
                value: item.wareNm
            }
        });
        uglcw.ui.init();
        //uglcw.ui.get('#discount').on('change', calTotalAmount);
        //grid渲染后对toolbar上的控件进行初始化

        <c:if test="${stkProduce.inDate == ''}">
        uglcw.ui.get('#inDate').value(uglcw.ui.toString(new Date(), 'yyyy-MM-dd HH:mm'));
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
                    //uglcw.ui.get('#grid').commit();
                }
            }
            calTotalAmount();
        });
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.loaded();
    })

    function add() {
        uglcw.ui.openTab('其他入库开单', '${base}manager/pcotherin?r=' + new Date().getTime());
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

    function showProductSelector() {
        if (!uglcw.ui.get('#stkId').value()) {
            return uglcw.ui.warning('请选择入库仓库');
        }
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                url: '${base}manager/companyWaretypes',
                model: 'waretype',
                id: 'id',
                expandable:function(node){
                    return node.id == '0';
                },
                loadFilter:function(response){
                    $(response).each(function(index,item){
                        if(item.text=='根节点'){
                            item.text='库存商品类'
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
                        row.inTypeCode = 10001;
                        row.qty = 1;
                        row.price = row.inPrice;
                        row.unitName = row.wareDw;
                        row.beUnit = row.maxUnitCode;
                        row.qty = row.qty || row.stkQty || 1;
                        row.amt = parseFloat(row.qty) * parseFloat(row.price);
                    })
                    uglcw.ui.get('#grid').addRow(data);
                    uglcw.ui.get('#grid').commit();
                    uglcw.ui.get('#grid').scrollBottom();
                }
            }
        })
    }

    function draftSave() {
        uglcw.ui.get('#grid').commit();
        var status = uglcw.ui.get('#status').value();
        if (status != -2) {
            uglcw.ui.warning('发票不在暂存状态，不能保存！')
        }
        if (!uglcw.ui.get('form').validate()) {
            return;
        }
        var data = uglcw.ui.bind('form');

        var products = uglcw.ui.get('#grid').bind();
        if (products.length < 1) {
            uglcw.ui.error('请选择商品');
            return;
        }
        data.id = data.billId;
        data.wareStr = JSON.stringify(products);

        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/dragSaveStkIn',
            type: 'post',
            data: data,
            dataType: 'json',
            success: function (response) {
                uglcw.ui.loaded();
                if (response.state) {
                    uglcw.ui.success('暂存成功');
                    uglcw.io.emit('pcstkinreload');
                    setTimeout(function () {
                        uglcw.ui.replaceCurrentTab('其他入库' + response.id, '${base}manager/showstkin?dataTp=${dataTp}&billId=' + response.id)
                    }, 1000)
                }
            },
            error: function () {
                uglcw.ui.loaded();
            }
        })
    }

    function submitStk() {
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');
        form.id = form.billId;
        form.wareStr = JSON.stringify(uglcw.ui.get('#grid').bind());
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/addStkIn',
            type: 'post',
            dataType: 'json',
            data: form,
            success: function (response) {
                uglcw.ui.loaded();
                if (response.state) {
                    uglcw.ui.success('提交成功');
                    response.billId = response.id;
                    response.billStatus = '提交成功';
                    uglcw.ui.bind('form', response);
                } else {
                    uglcw.ui.error('提交失败')
                }
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
            uglcw.ui.error('发票已作废，不能审批！');
            return;
        }
        if (status == 2) {
            uglcw.ui.error('发票已作废，不能审批');
            return;
        }

        uglcw.ui.confirm('是否确定审核？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/auditDraftStkIn',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value()},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('审批成功');
                        uglcw.ui.get('#billStatus').value('审批成功');
                        uglcw.ui.get('#status').value(0);
                    }
                }
            })

        })
    }

    function toPrint() {
        top.layui.index.openTabsPage('${base}manager/showstkinprint?billId=${billId}', '其他入库${billId}打印');
    }

    function cancelClick() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.warning('没有可作废单据');
        }
        var billStatus = uglcw.ui.get('#billStatus').value();
        if (billStatus == 2) {
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
                        uglcw.ui.reload();
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
        var status = uglcw.ui.get('#billStatus').value();
        if (status == '已审') {
            return uglcw.ui.warning('该单据已审核');
        }
        if (status == '作废') {
            return uglcw.ui.warning('该单据已作废');
        }
        auditProc(billId);
    }

    function auditProc(billId) {
        uglcw.ui.openTab('其他入库收货' + billId, '${base}manager/showstkincheck?dataTp=1&billId=' + billId);
    }
</script>
</body>
</html>
