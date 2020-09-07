<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>采购入库单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcu/css/bill-common.css" media="all">
    <style>
        .uglcw-search input, select {
            height: 30px;
        }
        .snapshot-badge-dot{
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
                    <li onclick="add()" data-icon="add" class="k-info" id="btnnew">新建</li>
                    <c:if test="${status eq -2}">
                        <li onclick="draftSave()" class="k-info" data-icon="save" id="btndraft">暂存</li>
                    </c:if>

                    <c:if test="${status eq -2 and status ne 2}">
                        <c:if test="${permission:checkUserFieldPdm('stk.stkIn.audit')}">
                        <li onclick="audit()" class="k-info" data-icon="track-changes-accept" id="btndraftaudit"
                            style="display: ${billId eq 0?'none':''}">审批
                        </li>
                        </c:if>
                    </c:if>
                    <c:if test="${status eq -2}">
                    <li uglcw-state="2" onclick="postAccDialog()" id="btnPostAcc" class="k-info" data-icon=" ion-md-card">
                        一键过账
                    </li>
                    </c:if>
                    <c:if test="${permission:checkUserFieldPdm('stk.stkIn.save')}">
                        <li onclick="submitStk()" class="k-info" data-icon="save" id="btnsave"
                            style="display: ${(status eq -2 and billId eq 0)?'':'none'}">保存并审批
                        </li>
                    </c:if>
                    <c:if test="${permission:checkUserFieldPdm('stk.stkIn.shouhuo')}">
                        <li onclick="auditClick()" class="k-info" id="btnaudit"
                            style="display: ${(status eq -2 or billId eq 0 or status eq 1 or status eq 2 )?'none':''}">
                            收货
                        </li>
                    </c:if>
                    <c:if test="${permission:checkUserFieldPdm('stk.stkIn.cancel')}">
                        <li onclick="cancelClick()" id="btncancel" class="k-error" data-icon="delete"
                            style="display: ${billId eq 0 or status eq 2?'none':''}">作废
                        </li>
                    </c:if>
                    <c:if test="${status eq 0 or status eq 1}">
                        <c:if test="${permission:checkUserFieldPdm('stk.stkIn.reaudit')}">
                        <li onclick="reAudit()" data-icon="undo"
                            style="display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_CGFP_AUTO_REAUDIT\'  and status=1')}">
                            反审批
                        </li>
                        </c:if>
                    </c:if>
                    <c:if test="${permission:checkUserFieldPdm('stk.stkIn.print')}">
                        <li onclick="toPrint()" id="btnprint" data-icon="print"
                            style="display: ${billId eq 0?'none':''}">打印
                        </li>
                    </c:if>
                    <div class="k-button k-button-icontext"
                         style="display: ${(fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_CGFP_OPEN_ZFJS\'  and status=1') eq '')?'':'none'}">
                        <input type="checkbox" uglcw-role="checkbox" uglcw-model="openZfjzChk"
                               uglcw-options="type:'number'"
                               class="k-checkbox" id="openZfjz"
                               uglcw-value="${openZfjz}">
                        <label style="margin-bottom: 0px;" class="k-checkbox-label" for="openZfjz">开启采购杂费运算</label>
                    </div>

                </ul>
                <div class="bill-info">
                    <span class="no" style="color: green;"><div id="billNo" uglcw-model="billNo" style="height: 25px;"
                                                                uglcw-role="textbox">${billNo}</div></span>
                    <span class="status" style="color:red;"><div id="billStatus" style="height: 25px;width: 80px"
                                                                 uglcw-model="billstatus"
                                                                 uglcw-role="textbox">${billstatus}</div></span>
                    <%--<c:if test="${not empty verList}">--%>
                    <%--<a onclick="show('billVersion')">查看反审批版本</a>--%>
                    <%--</c:if>--%>
                    <c:if test="${not empty verList}">
                        <a uglcw-role="tooltip" uglcw-options="
                        autoHide: false,
                        content: $('#billVersion').html(),
                        position: 'bottom'
                    ">查看反审批版本</a>
                    </c:if>

                </div>
            </div>
            <div class="layui-card-body master">
                <input uglcw-role="textbox" type="hidden" uglcw-model="snapshotId" id="snapshotId"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="inType" value="采购入库"/>
                <%--<input uglcw-role="textbox" type="hidden" uglcw-model="proType" value="0"/>--%>
                <input uglcw-role="textbox" type="hidden" uglcw-model="proId" id="proId" value="${proId}"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="proType" id="proType" value="${proType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="stkName" id="stkName" value="${stkName}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
                <div class="form-group">
                    <label class="control-label col-xs-3">发货单位</label>
                    <div class="col-xs-4">
                        <input uglcw-role="gridselector" uglcw-model="proName" id="proName" value="${proName}"
                               uglcw-validate="required"
                               uglcw-options="click:function(){
								selectSender();
							}"
                        >
                    </div>
                    <%--</div>--%>
                    <label class="control-label col-xs-3">单据时间</label>
                    <div class="col-xs-4">
                        <input uglcw-validate="required" id="inDate" uglcw-role="datetimepicker"
                               uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="inDate" value="${inTime}">
                    </div>
                    <label class="control-label col-xs-3">入库仓库</label>

                    <div class="col-xs-4 uglcw-grid-editable k-edit-cell">
                        <input uglcw-validate="required" uglcw-role="combobox" id="stkId"
                               uglcw-options="
                                    value: '${stkId}',
                                    url: '${base}manager/queryBaseStorage',
                                    loadFilter:{
                                    data:function(response){
                                        var data = response.list || [];
                                        data.sort(function(a, b){
                                            return (b.isSelect || 0) - (a.isSelect||0);
                                        });
                                        return data;
                                    },
                                },
                                    dataTextField: 'stkName',
                                    index: 0,
                                    dataValueField: 'id'"
                               uglcw-model="stkId,stkName"/>
                    </div>


                </div>
                <div class="form-group" style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}">
                    <label class="control-label col-xs-3">合计金额</label>
                    <div class="col-xs-4">
                        <input id="totalAmount" uglcw-options="spinners: false, format: 'n2'" uglcw-role="numeric"
                               uglcw-model="totalmt" value="${totalamt}"
                               disabled>
                    </div>
                    <label class="control-label col-xs-3">整单折扣</label>
                    <div class="col-xs-4">
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
                                inTypeCode: 10001,
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
                            template: '#= data.beUnit == data.maxUnitCode ? data.wareDw||\'\' : data.minUnit||\'\' #',
                            editor: unitEditor
                        ">单位
                </div>
                <div data-field="qty" uglcw-options="width: 100,
                            hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookqty')},
                            aggregates: ['sum'],
                            schema:{type: 'number',decimals:10},
                            attributes:{
                                class: 'cell-product-name uglcw-cell-speedy'
                            },
                            footerTemplate: '#= (sum||0) #'
                    ">采购数量
                </div>
                <div data-field="price"
                     uglcw-options="width: 100,
                      hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookprice')},
                      attributes:{
                          class: 'uglcw-cell-speedy dirty-cell'
                      },
                      schema:{type: 'number',decimals:10}">
                    单价
                </div>
                <div data-field="amt" uglcw-options="width: 100,
                            format:'{0:n2}',
                            aggregates: ['sum'],
                            schema: {type: 'number', decimals: 10},
                            hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')},
                            footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#'">采购金额
                </div>
                <div data-field="rebatePrice"
                     uglcw-options="width: 150, schema:{type: 'number'},hidden:!${fns:checkFieldBool('sys_config','*','code=\'CONFIG_IN_FANLI_PRICE\' and status =1')}">
                    应付返利单价
                </div>
                <div data-field="productDate" uglcw-options="width: 120,
                             schema:{ type: 'date'},
                             editor: productDateEditor
                            ">生产日期
                </div>
                <div data-field="inTypeCode"
                     uglcw-options="width: 80, editable: true, values: [{text: '正常采购', value: '10001'}, {text: '其他', value: '10005'}]">
                    采购类型
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

<tag:compositive-selector-template index="0"/>
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
             url: '${base}manager/dialogWarePage',
             loadFilter:{
                data: function(response){
                    return response.rows || [];
                }
            },
             data: function(){
               return {
                page:1, rows: 20,
                waretype: '',
                stkId: uglcw.ui.get('\\#stkId').value(),
                wareNm: uglcw.ui.get('\\#autocomplete').value()
               }
             },
             template: kendo.template($('\\#autocomplete-template').html()),
             <%--headertemplate: kendo.template($('\\#autocomplete-header-template').html()),--%>
             <%--footerTemplate: kendo.template($('\\#autocomplete-footer-template').html()),--%>
             change: function(){this.value('')},

             select: function(e){
                var item = e.dataItem.toJSON();
                var grid = uglcw.ui.get('\\#grid');
                item.inTypeCode = 10001;
                item.qty = 1;
                item.price = item.inPrice||'0';
                item.unitName = item.wareDw;
                item.beUnit = item.maxUnitCode;
                item.qty = item.qty || item.stkQty || 1;
                item.amt = parseFloat(item.qty) * parseFloat(item.price);
                item.productDate='';
                 laodHisInPrice(item);
                grid.addRow(item,{move:false});
             }
            "
           id="autocomplete" class="autocomplete" placeholder="搜索产品..." style="width: 250px;">
    <div class="k-button k-button-icontext">
        <input type="checkbox" uglcw-role="checkbox" uglcw-model="update-price"
               uglcw-options="type:'number'"
               class="k-checkbox" id="update-price"
               uglcw-value="${(fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_CLOSE_CGPRICE_AUTO_WRITE\'  and status=1') eq '')?'1':'0'}">
        <label style="margin-bottom: 0px;" class="k-checkbox-label" for="update-price">自动更新采购价</label>
    </div>
</script>


<script id="accDlg" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="col-xs-8 control-label required">付款账号</label>
                    <div class="col-xs-12">
                        <tag:select2 validate="required" name="accId" id="accId" tableName="fin_account" headerKey=""
                                     whereBlock="status=0"
                                     headerValue="--请选择--" displayKey="id" displayValue="acc_name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-xs-8 control-label required">付款金额</label>
                    <div class="col-xs-12">
                        <input uglcw-role="numeric" uglcw-model="payAmt">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<script type="text/x-uglcw-template" id="autocomplete-template">
    <div><span>#= data.wareNm#</span><span style="float: right">#= data.wareGg#</span></div>
</script>
<script src="${base}static/uglcu/biz/erp/stkin/pc_lib_in.js?v=20191120"></script>
<script src="${base}static/uglcu/biz/erp//util.js?v=20191120"></script>
<tag:product-in-selector-template query="onQueryProduct"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<tag:bill-snapshot type="stkin" collect="onSnapshotSave" load="onSnapshotLoad" billId="billId" title="proName"/>
<script>
    var dataSource = ${fns:toJson(warelist)};
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
                if ((e.field === 'qty' || e.field === 'price')) {
                    if (changedFields.indexOf('qty') != -1 || changedFields.indexOf('price') != -1) {
                        item.set('amt', Number((item.qty * item.price).toFixed(2)));
                        commit = true;
                    }
                } else if (e.field === 'beUnit') {
                    if (item.beUnit === 'B') {
                        //切换至大单位 价格=小单位单价*转换比例
                        item.set('price', Number(item.price * item.hsNum).toFixed(2));
                    } else if (item.beUnit === 'S') {
                        item.set('price', Number(item.price / item.hsNum).toFixed(2));
                    }
                    item.set('amt', Number((item.qty * item.price).toFixed(2)));
                } else if (e.field === 'amt') {
                    if (item.amt) {
                        if (changedFields.indexOf('amt') != -1) {
                            item.set('price', (parseFloat(item.amt) / parseFloat(item.qty)));
                        }
                    }
                }
                /*if (commit) {
                    uglcw.ui.get('#grid').commit();
                }*/
            }
            $('#grid').data('_change', true);
            calTotalAmount();
            if(action === 'itemchange' || action === 'add' || action === 'remove'){
                snapshot.save();
            }
        });
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        uglcw.ui.get('#discount').on('change', calTotalAmount);
        //grid渲染后对toolbar上的控件进行初始化
        uglcw.ui.loaded();
    })

    function onSnapshotLoad(data) {
        if (data) {
            uglcw.ui.bind('.master', data.master);
            uglcw.ui.get('#grid').value(data.rows);
        }
    }

    function onSnapshotSave() {
        var master = uglcw.ui.bind('.master');
        if (master.status != -2) {
            return false;
        }
        delete master['billNo'];
        delete master['snapshotId'];
        delete master['status'];
        delete master['billstatus'];

        var rows = uglcw.ui.get('#grid').value();
        rows = $.map(rows, function(row){
            if(row.wareId){
                delete row['id'];
                delete row['_kendo_devtools_id'];
                return row;
            }
        })
        return {
            master: master,
            rows: rows
        }
    }

    var isModify = false;

    function add() {
        uglcw.ui.openTab('采购单据', '${base}manager/pcstkin?r=' + new Date().getTime());
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
            inTypeCode: 10001,
            qty: 1,
            price: 0,
            amt: 0,
            productDate: null,
        });
    }


    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }


    function draftSave() {//暂存
        var status = uglcw.ui.get('#status').value();
        if (status != -2) {
            uglcw.ui.warning('单据不在暂存状态，不能保存！')
        }
        if (!uglcw.ui.get('form').validate()) {
            return;
        }

        var proName = uglcw.ui.get("#proName").value();
        var stkId = uglcw.ui.get("#stkId").value();
        var inDate = uglcw.ui.get("#inDate").value();
        if (proName == "") {
            return uglcw.ui.error('请选择发货单位');
        }

        if (inDate == "") {
            return uglcw.ui.error('请选择时间');
        }

        <%--if (${fns:isUseKuwei()}) {--%>
        <%--var kwBool = checkStkTemp();--%>
        <%--if (!kwBool) {--%>
        <%--uglcw.ui.error('未设置临时仓库，，请<a href=\'javascript:toSetStorage()\'>设置</a>');--%>
        <%--return;--%>
        <%--}--%>
        <%--}--%>
        if (stkId == "") {
            return uglcw.ui.error('请选择仓库');
        }
        var data = uglcw.ui.bind('form');
        data.checkAutoPrice = uglcw.ui.get('#update-price').value();
        var products = uglcw.ui.get('#grid').bind();
        if (products.length < 1) {
            uglcw.ui.error('请选择商品');
            return;
        }
        var bool = checkFormQtySign(products,1);
        if(!bool){
            return;
        }
        data.id = data.billId;
        products = $.map(products, function (product) {
            product.qty = product.qty || 0;
            product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
            if (product.wareId) {
                return product;
            }
        });
        data.wareStr = JSON.stringify(products);
        data.openZfjz = uglcw.ui.get('#openZfjz').value();

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
    }

    function submitStk() {
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var proName = uglcw.ui.get("#proName").value();
        var stkId = uglcw.ui.get("#stkId").value();
        var inDate = uglcw.ui.get("#inDate").value();
        if (proName == "") {
            return uglcw.ui.error('请选择发货单位');
        }
        if (stkId == "") {
            return uglcw.ui.error('请选择仓库');
        }
        if (inDate == "") {
            return uglcw.ui.error('请选择时间');
        }

        var form = uglcw.ui.bind('form');
        form.id = form.billId;
        form.checkAutoPrice = uglcw.ui.get('#update-price').value();

        form.openZfjz = uglcw.ui.get('#openZfjz').value();

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
                    $("#btnPostAcc").hide();
                    if (json.autoSend == 1) {
                        $("#btnaudit").hide();
                    }
                    $('#grid').data('_change', true);
                    isModify = false;
                } else {
                    uglcw.ui.error(json.msg);
                }
                uglcw.ui.loaded();
                isModify = false;

            },
            error: function () {
                uglcw.ui.loaded();
                uglcw.ui.error('提交失败');
            }
        })

    }

    function showProductSelector() {
        if (!uglcw.ui.get('#stkId').value()) {
            return uglcw.ui.error('请选择仓库');
        }
        <tag:product-out-selector-script fullscreen="true" callback="onProductSelect"/>
    }


    function onQueryProduct(param) {
        param.stkId = uglcw.ui.get('#stkId').value();
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
            data = $.map(data, function (item) {
                var row = item;
                if ($.isFunction(item.toJSON)) {
                    row = item.toJSON();
                }
                row.id = uglcw.util.uuid();
                row.price = row.inPrice || '0';
                row.unitName = row.wareDw;
                row.beUnit = row.maxUnitCode;
                row.qty = 1;
                row.amt = parseFloat(row.qty) * parseFloat(row.price);
                row.productDate = '';
                laodHisInPrice(row);
                return row;
            })
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
                        $("#btnPostAcc").hide();
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

    function toPrint() {
        var billId = uglcw.ui.get('#billId').value();
        uglcw.ui.openTab('采购单打印', '${base}manager/showstkinprint?billId=' + billId);
    }

    function reAudit() {
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (billId == 0) {
            uglcw.ui.warning('没有可反审批的单据');
            return;
        }
        if (status == 2) {
            uglcw.ui.error('该单据已作废');
            return;
        }
        uglcw.ui.confirm('确定反审批吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}/manager/reAuditStkIn',
                type: 'post',
                dataType: 'json',
                data: {billId: billId},
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('反审批成功！')
                        setTimeout(function () {
                            window.location.href = "${base}/manager/showstkin?billId=" + billId;
                        }, 1500);
                    } else {
                        uglcw.ui.error(response.msg || '反审批失败');
                    }
                },
                error: function () {
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
                        $("#btnPostAcc").hide();
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

    function show(id) {
        var display = $("#" + id + "").css('display');
        if (display == 'none') {
            $("#" + id + "").show();
            $("#" + id + "").css("left", event.clientX);
            $("#" + id + "").css("top", event.clientY + 10);
        } else {
            $("#" + id + "").hide();
        }
    }

    function showVersion(id) {
        uglcw.ui.openTab('采购版本记录' + id, '${base}manager/showstkinversion?billId=' + id);
    }

    function auditProc(billId) {
        $.ajax({
            url: '${base}/manager/stkExtrasCarryOver/checkInUse',
            data: {
                billId: billId
            },
            type: 'post',
            dataType: 'json',
            success: function (response) {
                if (response.state) {
                    var billId = $("#billId").val();
                    if (billId == 0) {
                        uglcw.ui.warning("没有可收货的单据");
                        return;
                    }
                    uglcw.ui.openTab('采购入库收货' + billId, '${base}manager/showstkincheck?dataTp=1&billId=' + billId);
                } else {
                    uglcw.ui.error("已生成结算单，请到结算单界面收货！");
                }
            }
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
        laodHisInPrice(model);
        uglcw.ui.get('#grid').commit();
        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
    }

    function laodHisInPrice(row){
        var action = "queryInProHisWarePrice";
        var proId = uglcw.ui.get('#proId').value();
        var proType = uglcw.ui.get('#proType').value();
        if(proId==""||proId==0){
            return;
        }
        $.ajax({
            url: CTX + 'manager/' + action,
            type: 'post',
            async: false,
            data: {
                proId: proId,
                proType: proType,
                wareId: row.wareId
            },
            success: function (response) {
                if (response.state) {
                    var hsNum = row.hsNum;
                    setPrice(row,response);
                }
            }
        })
    }

    function setPrice(row, data) {
        var hsNum = row.hsNum || 1;
         if (data.hisPrice != undefined && data.hisPrice != '' && data.hisPrice != 0) {
             row.bUnitPrice = data.hisPrice;
            if(!data.minHisPrice){
                row.sUnitPrice = row.bUnitPrice / hsNum;
            }
        }
        if (data.minHisPrice != undefined && data.minHisPrice != '' && data.minHisPrice != 0) {
            row.sUnitPrice = data.minHisPrice;
            if(!data.hisPrice){
                row.bUnitPrice = row.minHisPrice * hsNum;
            }
        }
        //row.price = ((row.sunitFront == 1 || row.beUnit == 'S') ? row.sUnitPrice : row.bUnitPrice)||0;
        if(row.bUnitPrice!=undefined&&row.bUnitPrice!=''&&row.bUnitPrice!=0){
            row.price = row.bUnitPrice;
        }
        row.amt = parseFloat(row.qty) * parseFloat(row.price);
    }


    function postAccDialog() {
        if ($('#grid').data('_change')) {
            return uglcw.ui.warning('单据有变动请先【暂存】');
        }
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (billId == 0 || status != -2) {
            return uglcw.ui.info('没有可过账的单据');
        }
        var payAmt = uglcw.ui.get('#discountAmount').value();
        var form = {
            payAmt: payAmt
        }
        var win = uglcw.ui.Modal.open({
            title: '一键过账',
            content: $('#accDlg').html(),
            success: function (c) {
                uglcw.ui.init(c);
                uglcw.ui.bind(c, form);
            },
            yes: function (c) {
                if (status == 0 || status == 1) {
                    return uglcw.ui.info('该单据已审批');
                }
                if ($('#grid').data('_change')) {
                    return uglcw.ui.info('产品明细已更新请先暂存');
                }
                if (!uglcw.ui.get($(c).find('.form-horizontal')).validate()) {
                    return false;
                }
                var data = uglcw.ui.bind(c);
                data.billId = billId;
                // data.payAmt = payAmt;
                if (parseFloat(data.payAmt) > parseFloat(payAmt)) {
                    uglcw.ui.info('付款金额不能大于' + payAmt)
                    return false;
                }

                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/postDraftStkIn',
                    type: 'POST',
                    data: data,
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.state) {
                            uglcw.ui.success(response.msg);
                            $("#btndraft").hide();
                            $("#btndraftaudit").hide();
                            $("#btnsave").hide();
                            $("#btnprint").show();
                            $("#btncancel").show();
                            $("#btnaudit").hide();
                            if (response.autoCome == 1) {
                                $("#btnaudit").hide();
                            }
                            $("#btnPostAcc").hide();
                            uglcw.ui.get('#billStatus').value(response.msg);
                            uglcw.ui.Modal.close(win);
                        } else {
                            uglcw.ui.error(response.msg || '一键过账失败');
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('操作失败，请稍后再试');
                    }
                })

                return false;
            }
        })
    }

</script>
</body>
</html>
