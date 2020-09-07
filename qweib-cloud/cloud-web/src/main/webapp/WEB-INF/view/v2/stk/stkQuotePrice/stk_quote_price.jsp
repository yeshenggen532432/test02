<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户商品报价单</title>
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
                <c:if test="${stkQuotePrice.status eq -2}">
                    <li onclick="drageSave()" id="btndraft" class="k-info" data-icon="save">暂存</li>
                </c:if>
                <%--<c:if test="${permission:checkUserFieldPdm('stk.stkQuotePrice.audit')}">--%>
                <li onclick="audit()" id="btnaudit" class="k-info" data-icon="track-changes-accept"
                    style="display: ${(stkQuotePrice.id ne 0 and stkQuotePrice.status eq -2)?'':'none'}">审批
                </li>
                <%--</c:if>--%>
                <%--<c:if test="${permission:checkUserFieldPdm('stk.stkQuotePrice.cancel')}">--%>
                <%--<li onclick="cancel()" id="btncancel" class="k-info" data-icon="delete" style="display: ${stkQuotePrice.id eq 0 or stkQuotePrice.status eq 2 or stkQuotePrice.status eq 1?'none':''}">作废</li>--%>
                <%--</c:if>--%>
                <c:if test="${stkQuotePrice.status ne -2 }">
                <li onclick="toPrint()" id="btnprict" class="k-info" data-icon="print" style="display: ${stkQuotePrice.id eq 0?'none':''}">打印</li>
                </c:if>
            </ul>
            <div class="bill-info">
                <div class="no" style="color:green;"><span id="billNo" uglcw-model="billNo" style="height: 25px;"
                                                           readonly uglcw-role="textbox">${stkQuotePrice.billNo}</span>
                </div>
                <div class="status" style="color:red;">
                    <c:choose>
                        <c:when test="${stkQuotePrice.status eq -2 and not empty stkQuotePrice.id and stkQuotePrice.id ne 0}"><span
                                id="billStatus" style="height: 25px;width: 80px" uglcw-model="billstatus"
                                uglcw-role="textbox">暂存</span></c:when>
                        <c:when test="${stkQuotePrice.status eq 1}"><span id="billStatus" style="height: 25px;width: 80px"
                                                                      uglcw-model="billstatus"
                                                                      uglcw-role="textbox">已审批</span></c:when>
                        <c:when test="${stkQuotePrice.status eq 2}"><span id="billStatus" style="height: 25px;width: 80px"
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
                <input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="${stkQuotePrice.id}"/>
                <input type="hidden" uglcw-model="bizType" uglcw-role="textbox" id="bizType" value="${stkQuotePrice.bizType}"/>
                <input type="hidden" uglcw-model="proId" uglcw-role="textbox" id="proId" value="${stkQuotePrice.proId}"/>
                <input type="hidden" uglcw-model="proType" uglcw-role="textbox" id="proType" value="${stkQuotePrice.proType}"/>
                <input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status" value="${stkQuotePrice.status}"/>
                <label class="control-label col-xs-3">客户名称</label>
                <div class="col-xs-4">
                    <input uglcw-role="gridselector" uglcw-model="proName" id="proName" value="${stkQuotePrice.proName}"
                           uglcw-validate="required"
                           tabindex="2"
                           uglcw-options="click:function(){
								selectSender();
							}">
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">报价时间</label>
                    <div class="col-xs-4">
                        <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="inDate" value="${stkQuotePrice.inDate}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                    <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${stkQuotePrice.remarks}</textarea>
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
                            }, row);
                          },
                          editable: true,
                          dragable: true,
                          toolbar: kendo.template($("#toolbar").html()),
                          height:400,
                          navigatable: true,
                          dataSource:${fns:toJson(stkQuotePrice.list)}
                        '
            >
                <div data-field="wareCode" uglcw-options="
                                 width: 120,
                                 hidden: true,
                                 editable: false,
                            ">产品编号
                </div>
                <div data-field="wareNm" uglcw-options="width: 200">产品名称
                </div>
                <div data-field="wareGg" uglcw-options="width: 120,hidden: true, editable: false">产品规格</div>
                <div data-field="unitName" uglcw-options="width: 100">单位
                </div>
                <div data-field="beUnit" uglcw-options="width: 100,hidden:true">单位
                </div>
                <div data-field="zxPrice"
                     uglcw-options="width: 100">
                    执行价(大)
                </div>
                <div data-field="newHisPrice"
                     uglcw-options="width: 100">
                    最新历史价(大)
                </div>
                <div data-field="disPrice"
                     uglcw-options="width: 100;display:none">
                    加减价+-
                </div>
                <div data-field="price"
                     uglcw-options="width: 100,schema:{ type:'number',decimals:10}">
                   报价(大)
                </div>
                <div data-field="minPrice"
                     uglcw-options="width: 100,schema:{ type:'number',decimals:10}">
                    报价(小)
                </div>
                <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:showProductSelector()" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-search"></span>批量添加
    </a>
</script>
<script src="${base}/resource/stkstyle/js/Map.js"></script>
<tag:compositive-selector-template index="2" tabs="2"/>
<tag:product-in-selector-template query="onQueryProduct"/>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        <c:if test="${stkQuotePrice.inDate == null}">
        uglcw.ui.get('#inDate').value(new Date());
        </c:if>
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
                if ( e.field === 'price') {
                   var newHisPrice = item.newHisPrice;
                   var price = item.price;
                   var disPrice = parseFloat(price)-parseFloat(newHisPrice);
                   item.set('disPrice',disPrice);
                }
            }
        })
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        uglcw.ui.loaded();
    });


    function selectSender() {
        <tag:compositive-selector-script title="客户信息" callback="onSenderSelect" />
    }

    function onSenderSelect(id, name, type) {
        uglcw.ui.bind('body', {
            proId: id,
            proName: name,
            proType: type
        })
    }

    var delay;
    function refreshGrid(){
        clearTimeout(delay);
        delay = setTimeout(function(){
            uglcw.ui.get("#grid").k().refresh();
        }, 50);
    }


    function showProductSelector() {
        if (!uglcw.ui.get('#proId').value()) {
            return uglcw.ui.error('请选择客户');
        }
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
                row.price = 0;
                row.newHisPrice = 0;
                row.unitName = row.wareDw;
                row.beUnit = row.maxUnitCode;
                return row;
            })
            loadCustomerWarePrices(data)
        }
    }

    function add() {
        uglcw.ui.openTab('客户商品报价单', '${base}manager/stkQuotePrice/add?billId=0&r=' + new Date().getTime());
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
            url: '${base}manager/stkQuotePrice/save',
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
                    //uglcw.ui.replaceCurrentTab('理货信息' + response.id, '${base}manager/stkQuotePrice/show?billId=' + response.id)
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
        uglcw.ui.confirm('是否确定审批？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkQuotePrice/audit',
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
        uglcw.ui.openTab('打印客户商品报价单${stkQuotePrice.id}', '${base}manager/stkQuotePrice/print?billId=' + billId);
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
                url: '${base}manager/stkQuotePrice/cancel',
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

    function loadCustomerWarePrices(datas) {
        var wareIds = $.map(datas, function (row) {
            return "" + row.wareId + "";
        }).join(',');
        var customerId = uglcw.ui.get('#proId').value();
        if (customerId) {
            $.ajax({
                url: '${base}manager/loadCustomerWarePrices',
                type: 'post',
                data: {
                    customerId: customerId,
                    wareIds:wareIds
                },
                success: function (response) {
                    var map = new Map();
                    if(response.rows&&response.rows.length>0){
                        var list = response.rows;
                        for(var i=0;i<list.length;i++){
                            var json = list[i];
                             map.put(json.wareId,json);
                        }
                    }
                    $.map(datas, function (data) {
                        var wareId = data.wareId;
                        data.zxPrice = data.wareDj;
                        data.price = 0;
                        data.newHisPrice = 0;
                        if(map.containsKey(wareId)){
                            var json = map.get(wareId);
                            var maxHisPfPrice = json.maxHisPfPrice;
                            var minHisPfPrice = json.minHisPfPrice;
                            var wareDj = json.wareDj;//大单位单价 执行价
                            data.zxPrice = wareDj;
                            if(maxHisPfPrice!=""&&maxHisPfPrice!=undefined){
                                data.newHisPrice = maxHisPfPrice;
                                data.price = maxHisPfPrice;
                            }
                        }
                        data.disPrice = 0;
                        return data;
                    });
                    uglcw.ui.get('#grid').addRow(datas);
                    uglcw.ui.get('#grid').commit();
                    uglcw.ui.get('#grid').scrollBottom();
                }
            })
        }
    }
</script>
</body>
</html>
