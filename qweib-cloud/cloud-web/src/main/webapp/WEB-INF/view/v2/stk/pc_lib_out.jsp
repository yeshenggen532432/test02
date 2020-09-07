<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售开单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcu/plugins/intro/introjs.min.css" media="all">
    <link rel="stylesheet" href="${base}/static/uglcu/css/biz/salesorder.css?v=20191224" media="all">
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card master">
        <div class="actionbar layui-card-header btn-group">
            <ul uglcw-role="buttongroup">
                <li uglcw-state="1" onclick="add()" data-icon="add" class="k-info " id="btnnew">新建</li>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.dragsave')}">
                    <li uglcw-state="2" onclick="draftSaveStk()" class="k-info" data-icon="save" id="btndraft">暂存</li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.audit')}">
                    <li uglcw-state="4" onclick="auditDraftStkOut()" class="k-info "
                        data-icon="track-changes-accept"
                        id="btndraftaudit">审批
                    </li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.saveaudit')}">
                    <li uglcw-state="8"
                        onclick="submitStk()" class="k-info " data-icon="save" id="btnsave">
                        保存并审批
                    </li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.onepost')}">
                    <li uglcw-state="2" onclick="postAccDialog()" class="k-info " data-icon=" ion-md-card">
                        一键过账
                    </li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.fahuo')}">
                    <li uglcw-state="32" onclick="auditClick()" class="k-info " data-icon="check" id="btnaudit">
                        发货
                    </li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.cancel')}">
                    <li uglcw-state="128" onclick="cancelClick()" id="btncancel" class="k-error "
                        data-icon="delete">作废
                    </li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.print')}">
                    <li uglcw-state="256" onclick="printClick()" class="k-info " id="btnprint"
                        data-icon="print">打印
                    </li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.reaudit')}">
                    <li uglcw-state="64" onclick="reAudit()" data-icon="undo"
                        class="k-info "
                        style="display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_XSFP_AUTO_REAUDIT\'  and status=1')}">
                        反审批
                    </li>
                </c:if>
                <c:if test="${status eq -2 and billId ne 0 and not empty newTime}">
                    <li id="unLockBill" onclick="unLockBill(${billId})"
                        class="k-info " >
                        解锁
                    </li>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.createconfig')}">
                    <li class="k-info ghost"
                        data-intro="销售开单配置"
                        onclick="customSetting()">
                        <i class="k-icon k-i-gear"></i>
                    </li>
                </c:if>
                <li id="help-info" onclick="initIntro()" class="k-info ghost ">
                    <i class="k-icon k-i-info"></i>
                </li>
            </ul>

            <div class="bill-info">
                <span style="width: 50px;color: red;font-weight: bold;display:${redMark eq 1?'':'none'}">红字单</span>
<%--                ${redMark eq 1?'color: red':''}--%>
                    <span class="no" style="color:${(priceFlag eq 1 and status ne -2)?'red':'green'};"><div id="billNo"  uglcw-model="billNo" style="height: 25px;${redMark eq 1?'color: red':''}" uglcw-role="textbox">${billNo}</div></span>
                    <span class="status" style="color:red;"><div id="billStatus" style="height: 25px;"
                                                             uglcw-model="billstatus"
                                                             uglcw-role="textbox">${billstatus}</div></span>
                <span class="status" style="color:green;"><div id="paystatus" style="height: 25px;width: 80px"
                                                               uglcw-model="paystatus"
                                                               uglcw-role="textbox">${paystatus}</div></span>
                <c:if test="${not empty verList}">
                        <span uglcw-role="tooltip" uglcw-options="
                            content: $('#bill-version-tpl').html(),
                            showOn: 'click',
                            autoHide: false
                    ">查看反审批版本</span>
                </c:if>
                <div id="snapshot"
                     style="color:#38F;border:none;display: ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_ORDER_AUTO_SNAPSHOT\" and status=1")}"
                     onclick="showSnapshot()">
                    快照<i class="k-icon k-i-clock"></i>
                    <sup class="snapshot-badge-dot"></sup>
                </div>
            </div>
        </div>
        <form class="main-form form-horizontal" uglcw-role="validator">
            <div class="layui-card-body">
                <input uglcw-role="textbox" type="hidden" uglcw-model="page_token" id="page_token" value="${page_token}"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="snapshotId" id="snapshotId"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="redMark" id="redMark" value="${redMark}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="outType" id="outType" value="销售出库"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
                <input type="hidden" name="empType" id="empType" value="${empType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="proType" id="proType" value="${proType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="autoPrice" id="autoPrice" value="${autoPrice}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="isSUnitPrice" id="isSUnitPrice"
                       value="${isSUnitPrice}">
                <input type="hidden" uglcw-role="textbox" uglcw-model="saleType" id="saleType" value="${saleType}"/>
                <input type="hidden" uglcw-model="autoCreateFhd" uglcw-role="textbox" id="autoCreateFhd" value="1"/>
                <div class="form-group">
                    <label class="control-label col-xs-3 required">
                        <i uglcw-role="tooltip" data-intro="查看客户欠款" uglcw-options="content: '查看客户欠款'"
                           onclick="showCustomerDebt()"
                           style="color: red; cursor: pointer;margin-bottom: 3px;" id="customer-dept-tip"
                           class="k-icon k-i-info"></i>
                        客户名称
                    </label>
                    <div class="col-xs-4">
                        <input id="cstId" uglcw-role="textbox" uglcw-model="cstId" type="hidden"
                               value="${cstId}"/>
                        <input uglcw-role="autocomplete" uglcw-model="khNm" id="khNm"
                               placeholder="请选择客户名称"
                               uglcw-validate="required"
                               uglcw-options="
                                selectable: true,
                                noDataTemplate: $('#customer-no-result-tpl').html(),
                                click: function(){ selectCustomer(true)},
                                value: '${khNm}',
                                dataTextField: 'khNm',
                                dataValueField: 'id',
                                url: '${base}manager/stkchoosecustomer',
                                data: function(){
                                    return {
                                        page: 1,
                                        rows: 20,
                                        khNm: uglcw.ui.get('#khNm').value()
                                    }
                                },
                                loadFilter:{
                                    data: function(response){
                                        return response.rows || [];
                                    }
                                },
                                highlightFirst: false,
                                select: function(e){
                                    var item = e.dataItem;
                                     onCustomerSelect(item.id, item.khNm, 2, item);
                                     this.trigger('change');
                                },
                                change: function(){
                                    var found = false;
                                    var value = this.value();
                                    var data = this.dataSource.view();
                                    for(var idx = 0, length = data.length; idx < length; idx++) {
                                        if (data[idx].khNm === value) {
                                            found = true;
                                            break;
                                        }
                                     }
                                     if(!found && xsfpQuickBill == 'none'){
                                        this.value('');
                                        uglcw.ui.get('#cstId').value('');
                                     }

                                    if(!this.value()){
                                        uglcw.ui.bind('form',{
                                            cstId: '',
                                            staff: '',
                                            empId: '',
                                            tel: '',
                                            linkman: '',
                                            address: '',
                                            stafftel: ''
                                        })
                                    }
                                }
                        "/>
                    </div>
                    <label class="control-label col-xs-3 required">销售日期</label>
                    <div class="col-xs-4">
                        <input uglcw-role="datetimepicker" uglcw-model="outDate" value="${outTime}"
                               placeholder="单据日期"
                               uglcw-validate="required"
                               uglcw-options="format: 'yyyy-MM-dd HH:mm'"/>
                    </div>
                    <label class="control-label col-xs-3">销售订单</label>
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="orderId" id="orderId"
                               value="${orderId}"/>
                        <input uglcw-role="gridselector" uglcw-model="orderNo" value="${orderNo}"
                               placeholder="请选择订单"
                               uglcw-options="allowInput: false,
                               <c:if test="${not empty orderNo}">
                                clearButton: false,
                                   </c:if>
                                 click: selectSaleOrder"/>
                    </div>
                </div>
                <div class="form-collapsable">

                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">备&nbsp;&nbsp;注</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" uglcw-model="remarks"
                               style="width: 100%;" value="${remarks}" placeholder="备注"/>
                    </div>
                </div>

            </div>
            <div class="master-toggle-bar">
                <div class="toggle-button-wrapper">
                        <span data-intro="点击折叠虚线区域<br>试试快捷键[CTRL+空格]吧"
                              class="toggle-button k-icon k-i-arrow-chevron-up"></span>
                </div>
            </div>
        </form>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div class="uglcw-grid k-grid">
                <div class="k-header k-grid-toolbar" id="toolbar" style="padding: 0;border-bottom: none;"></div>
            </div>
            <div id="grid" uglcw-role="grid-advanced"
                 data-intro="产品编辑, 可以尝试使用右键菜单查看历史价格、切换单位、增删行数据"
                 uglcw-options='
                          draggable: true,
                          lockable: false,
                          reorderable: true,
                          sortable: {
                            mode: "multiple",
                            allowUnsort: true
                          },
                          speedy:{
                            className: "uglcw-cell-speedy"
                          },
                          onInsert:function(rowIndex){

                          },
                          add: function(row){
                            return uglcw.extend({
                                xsTp: "正常销售",
                                qty: 0,
                                price: 0,
                                amt: 0,
                                id: uglcw.util.uuid()
                            }, row);
                          },
                          responsive:[".master",22, "#toolbar"],
                          id: "id",
                          minHeight: 250,
                          rowNumber: true,
                          editable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"},
                            {field: "sunitQty", aggregate: "sum"},
                            {field: "helpQty", aggregate: "sum"}
                          ],
                         loadFilter:function (datas) {
                            var rows = datas;
                            $(rows).each(function(idx,row){
                                   var bUnitSummary=   __formatStkQty(row,true);
                                    row.bUnitSummary = bUnitSummary;
                                    return row;
                                } )
                             return rows;
                          },
                          dataSource: dataSource,
                          dataBound: onGridDataBound
                        '
            >

            </div>
        </div>
    </div>
</div>
<!--模板-->
<%@include file="/WEB-INF/view/v2/include/biz/salesorder/templates.jsp" %>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}/resource/stkstyle/js/Map.js"></script>
<script src="${base}/static/uglcu/plugins/intro/intro.min.js"></script>
<script src="${base}static/uglcs/jquery/jquery.hotkeys.js"></script>
<script src="${base}static/uglcu/biz/erp/salesorder.js?v=20200408"></script>
<script src="${base}/static/uglcu/plugins/jquery.scannerdetection.js"></script>
<script src="${base}/static/uglcu/biz/common.js"></script>
<script src="${base}static/uglcu/biz/erp/util.js?v=20200616"></script>
<script>
    var productDateConfig = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_OUT_PRODUCT_DATE\"  and status=1")}';
    var xsfpQuickBill = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_XSFP_QUICK_BILL\" and status=1")}';
    var AUTO_CREATE_XSFP = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_ORDER_AUTO_CREATE_XSFP\" and status=1")}';
    var NEW_STOCK_CAL = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_USE_NEW_STOCK_CAL\" and status=1")}';
    var AUTO_CREATE_FHD = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_XSFP_AUTO_CREATE_FHD\" and status=1")}';

    var COMPARE_ZX_PRICE = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_XSFP_COMPARE_ZX_PRICE\" and status=1")}';
    var COMPARE_HIS_PRICE = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_XSFP_COMPARE_HIS_PRICE\" and status=1")}';
    var AUTO_SNAPSHOT = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_ORDER_AUTO_SNAPSHOT\" and status=1")}';
    var dataSource = ${fns:toJson(warelist)};
</script>
<script>
    //保存grid原有回车处理函数
    var _handleEnterKey = kendo.ui.uglcwGrid.fn._handleEnterKey;
    $(function () {
        renderPage();
        uglcw.ui.init();
        //地址数据绑定
        uglcw.ui.bind('.form-collapsable', _master_tpl_data);
        //监听页面垂直滚动并处理顶部按钮组置顶
        var scrollTimer;
        $(window).on('scroll', function () {
            clearTimeout(scrollTimer);
            scrollTimer = setTimeout(actionBarScrolling, 100);
        });
        actionBarScrolling();
        //监听行数据变化
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
                if (AUTO_SNAPSHOT !== 'none') {
                    saveSnapshot();
                }
            }
            if (action === 'itemchange') {
                var item = e.items[0];
                var changedFields = $('#grid').data('changedFields') || [];
                if ((e.field === 'qty' || e.field === 'price')) {
                    //修改数量或者单价时才更新amt
                    if (changedFields.indexOf('qty') !== -1 || changedFields.indexOf('price') !== -1) {
                        item.set('amt', Number(item.qty * item.price).toFixed(2));
                    }
                    item.sunitJiage = item.sUnitPrice;
                    if (item.beUnit == 'S') {
                        item.sunitQty = item.qty
                    } else {
                        item.sunitQty = item.qty / item.hsNum
                    }

                } else if (e.field === 'beUnit') {
                    if (item.beUnit === 'B') {
                        //切换至大单位 价格=小单位单价*转换比例
                        item.set('price', item.bUnitPrice ? item.bUnitPrice : Number(item.price * item.hsNum));
                    } else if (item.beUnit === 'S') {
                        //小单位开单
                        item.set('price', item.sUnitPrice ? item.sUnitPrice : Number(item.price / item.hsNum));
                    }
                    item.set('amt', Number(item.qty * item.price).toFixed(2));
                    item.sunitJiage = item.sUnitPrice;
                    if (item.beUnit == 'S') {
                        item.sunitQty = item.qty;
                    } else {
                        item.sunitQty = item.qty / item.hsNum;
                    }
                } else if (e.field === 'xsTp') {
                    if (item.xsTp !== '正常销售') {
                        item._oldPrice = item.price;
                        item.price = 0;
                    } else if (item._oldPrice) {
                        item.price = item._oldPrice;
                        item._oldPrice = undefined;
                    }
                    item.set('amt', Number(item.qty * item.price).toFixed(2));
                } else if (e.field === 'amt') {
                    if (item.amt) {
                        if (changedFields.indexOf('amt') !== -1) {
                            item.price = (parseFloat(item.amt) / parseFloat(item.qty))
                        }
                    }
                } else if (e.field === 'sunitJiage') {
                    if (item.beUnit == 'S') {
                        item.price = item.sunitJiage;
                    } else {
                        var price = (parseFloat(item.sunitJiage) * parseFloat(item.hsNum)).toFixed(5);
                        price = parseFloat(price);
                        item.price = price;
                    }
                }
                if (e.field === 'qty' || e.field === 'beUnit' || e.field === 'amt') {
                    __formatStkQty(item);
                }
            }
            calTotalAmount();
        });

        $('#autocomplete').scannerDetection({
            timeBeforeScanTest: 100,
            avgTimeByChar: 40,
            endChar: [13],
            onComplete: function (barcode, qty) {
                $('#autocomplete').data('scanner', true);
            },
            onError: function (string, qty) {
            }
        });

        uglcw.ui.get('#discount').on('change', calTotalAmount);

        uglcw.ui.get('#freight').on('change', calTotalAmount);

        if (uglcw.ui.get('#orderId').value() && uglcw.ui.get('#billId').value() == '0') {
            queryOrderDetail();
        }

        $('.main-form [uglcw-role][uglcw-model]').each(function (i, w) {
            var model = uglcw.ui.attr(w, 'model');
            if (model !== 'page_token' && model !== 'snapshotId') {
                uglcw.ui.get(w).on('change', function () {
                    $('#grid').data('_change', true);
                })
            }
        })

        initTooltips();
        initGridContextMenu();
        bindHotKeys();
        //客户变更
        uglcw.ui.get('#cstId').on('change', function () {
            var cstId = uglcw.ui.get('#cstId').value();
            var data = uglcw.ui.get('#grid').value();
            if (cstId && data && data.length > 0) {
                var hasProduct = false;
                $(data).each(function (i, row) {
                    if (row.wareId) {
                        hasProduct = true;
                        return false;
                    }
                });
                if (hasProduct && !$('#cstId').data('silent')) {
                    uglcw.ui.confirm('客户已变更，是否清空商品明细', function () {
                        uglcw.ui.get('#grid').bind([]);
                    })
                }
            }
        })
        var addingCustomer = false;
        var ac = uglcw.ui.get('#khNm');
        if (ac.value()) {
            //默认加入数据源用于判断是否是新增客户
            ac.k().dataSource.add({
                khNm: ac.value(),
                id: uglcw.ui.get('#cstId').value()
            })
            ac.k().dataSource.one('sync')
        }
        $('#khNm').on('keydown', function (e) {
            if (e.keyCode == 13 && !addingCustomer) {
                var value = ac.value();
                if (value) {
                    var dataSource = ac.k().dataSource.data().toJSON(), hit = false;
                    $(dataSource).each(function (i, p) {
                        if (p.khNm === value) {
                            hit = true;
                            return false;
                        }
                    })
                    if (!hit) {
                        setTimeout(function () {
                            addingCustomer = true;
                            uglcw.ui.confirm('未找到[' + value + '],是否立即添加？', function () {
                                window.model = model;
                                quickAddNewCustomer(value, function (customer) {
                                    if (customer) {
                                        ac.k().dataSource.add(customer);
                                        ac.k().dataSource.one('sync', function () {
                                            ac.k().close();
                                        });
                                        focusTable();
                                    }
                                    addingCustomer = false;
                                })
                            }, function () {
                                addingCustomer = false;
                            })
                        })

                    } else {
                        focusTable();
                    }
                }
            }
        })

        //订单变更
        uglcw.ui.get('#orderId').on('change', queryOrderDetail);
        //商品校验
        uglcw.ui.get('#checkProduct').on('change', function () {
            var $ac = $('#autocomplete'), ac = uglcw.ui.get($ac);
            var checked = uglcw.ui.get('#checkProduct').value();
            if (!checked) {
                ac.k().dataSource.transport.options.read.url = '${base}manager/dialogOutWarePage';
                $ac.attr('placeholder', '请输入商品名称、商品代码、商品条码');
                uglcw.ui.get('#grid').clearSelection();
                var grid = uglcw.ui.get('#grid');
                $('#grid tr.uglcw-product-checked').each(function (i, tr) {
                    $(this).removeClass('uglcw-product-checked');
                    var row = grid.k().dataItem($(this));
                    delete row['checkWare'];
                })
            } else {
                markProductChecked();
                ac.k().dataSource.transport.options.read.url = '${base}manager/queryStkWarePageForBar';
                $ac.attr('placeholder', '请刷条码');
                $ac.focus();

            }
        });
        uglcw.ui.get('#loadStock').on('change', function () {
            $('.stock-info').toggle();
        });
        var $toggleBar = $('.master-toggle-bar');
        $toggleBar.on('click', function () {
            var $area = $('.form-collapsable');
            $(this).find('.toggle-button').toggleClass('k-i-arrow-chevron-up k-i-arrow-chevron-down');
            if ($area.is(':visible')) {
                $area.slideUp();
            } else {
                $area.slideDown();
            }
            setTimeout(function () {
                uglcw.ui.get('#grid').resize();
            }, 500)
        });
        initPageState();
        uglcw.ui.loaded();
    });

    function initIntro() {
        introJs().setOptions({
            nextLabel: '下一个',
            prevLabel: '上一个',
            skipLabel: '跳过',
            doneLabel: '结束'
        }).start();

    }


    function initPageState() {
        /*
        -2 暂存 或新建
        0 未发货
        1 已发货
        1 作废
        3 终止未作废
        */
        <c:choose>
        <c:when test="${status == -2}">
        <c:if test="${billId == 0}">
        pageState(BILL_STATES.NEW);
        </c:if>
        <c:if test="${billId > 0}">
        pageState(BILL_STATES.STAGING);
        </c:if>
        </c:when>
        <c:when test="${status ==0 || status== 3}">
        pageState(BILL_STATES.UNSHIPPED);
        </c:when>
        <c:when test="${status ==1}">
        pageState(BILL_STATES.SHIPPED);
        </c:when>
        <c:when test="${status ==2}">
        pageState(BILL_STATES.CANCELLED);
        </c:when>
        </c:choose>
    }

    /**
     * 挑选客户
     */
    var add_row = true;
    var showCustomerDialog = false;

    function selectCustomer(addRow) {
        if ($('.consignee-selector').length > 0) {
            return
        }
        add_row = addRow;
        <tag:compositive-selector-script  title="请选择客户" callback="onCustomerSelect" />
        showCustomerDialog = true;
    }

    /**
     * 客户挑选回调
     */
    function onCustomerSelect(id, name, type, item) {
        var tel = item.mobile;
        if(type == 0){
            tel = item.tel;
        }else if(type == 1){
            tel = item.memberMobile;
        }
        uglcw.ui.bind('.master', {
            cstId: id,
            khNm: name,
            proType: type,
            address: item.address,
            tel: tel
        });
        debugger;
        if (item.memId) {
            loadEmployeeInfo(item.memId);
        }
        focusTable();
        showCustomerDialog = false;
    }

    function focusTable() {
        var grid = uglcw.ui.get('#grid');
        var cell;
        if (uglcw.ui.get('#grid').value().length === 0) {
            grid.addRow();
            add_row = true;
            cell = $('#grid .k-grid-content tr:last .cell-product-name');
        } else {
            cell = $('#grid .k-grid-content tr:eq(0) td.cell-product-name');
            add_row = false;
        }
        setTimeout(function () {
            grid.k().current(cell);
            grid.k().editCell(cell);
            uglcw.ui.get(cell.find('input[data-role=autocomplete]')).k().focus()
            add_row = true;
        }, 50)
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
                        staff: response.member.memberNm,
                        stafftel: response.member.memberMobile
                    });
                }
            }
        })
    }

    /**
     * 订单挑选
     */
    function selectSaleOrder() {
        uglcw.ui.Modal.showGridSelector({
            title: '请选择销售订单',
            closable: false,
            width: 800,
            height: 400,
            checkbox: false,
            url: '${base}/manager/willOutPage',
            criteria: '<input style="width: 120px;" uglcw-role="textbox" uglcw-model="orderNo" placeholder="订单号">' +
                '<input style="width: 120px;" uglcw-role="textbox" uglcw-model="khNm" placeholder="客户">' +
                '<input style="width: 120px;" uglcw-role="textbox" uglcw-model="memberNm" placeholder="业务员">' +
                '<input style="width: 120px;" uglcw-role="datepicker" value="${sdate}" uglcw-model="sdate" placeholder="开始时间">' +
                '<input style="width: 120px;" uglcw-role="datepicker" value="${edate}" uglcw-model="edate" placeholder="结束时间">'
            ,
            query: function (params) {
                params.jz = 0;
                return params;
            },
            aggregate: [
                {field: 'wareZj', aggregate: 'sum'},
                {field: 'zje', aggregate: 'sum'},
            ],
            loadFilter: {
                data: function (response) {
                    if (response && response.rows && response.rows.length > 0) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                    }
                    return [];
                },
                total: function (response) {
                    return response.total || 0;
                },
                aggregates: function (response) {
                    var aggregate = {};
                    if (response && response.rows && response.rows.length > 0) {
                        aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]['list']);
                    }
                    return aggregate;
                }
            },
            columns: [
                {title: '订单号', field: 'orderNo', width: 150, tooltip: true},
                {title: '配送指定', field: 'pszd', width: 80},
                {title: '下单日期', field: 'oddate', width: 100},
                {title: '时间', field: 'odtime', width: 80},
                {title: '送货时间', field: 'shTime', width: 120},
                {title: '客户名称', field: 'khNm', width: 120, tooltip: true},
                {title: '业务员名称', field: 'memberNm', width: 120},
                {title: '总金额', field: 'zje', width: 80},
                {title: '整单折扣', field: 'zdzk', width: 80},
                {title: '成交金额', field: 'cjje', width: 80},
                {title: '备注', field: 'remo', width: 120, tooltip: true},
                {title: '收货人', field: 'shr', width: 80, tooltip: true},
                {title: '电话', field: 'tel', width: 120, tooltip: true},
                {title: '地址', field: 'address', width: 120, tooltip: true}
            ],
            yes: function (data) {
                if (data && data.length > 0) {
                    var order = data[0];
                    //标记客户不触发变更提示
                    var $cstId = $('#cstId');
                    $cstId.data('silent', true);
                    uglcw.ui.bind('.master', {
                        orderNo: order.orderNo, //订单号
                        orderId: order.id, //订单ID
                        address: order.address,//客户地址
                        tel: order.tel,//客户电话
                        pszd: order.pszd,//配送指定
                        khNm: order.khNm, //客户名称
                        cstId: order.cid,//客户ID
                        staff: order.memberNm, //业务员
                        stafftel: order.memberMobile, //业务员电话
                        remarks: order.remo, //
                        discount: order.zdzk,
                        empId: order.mid
                    })
                    //清除客户不触发变更提示
                    $cstId.removeData('silent');
                }
            }
        })
    }

    /**
     * 业务员挑选弹框
     */
    function selectEmployee() {
        <tag:dept-employee-selector checkbox="false" callback="onEmployeeSelect"/>
    }

    /**
     * 业务员挑选回调
     */
    function onEmployeeSelect(data) {
        if (data && data.length > 0) {
            var employee = data[0];
            uglcw.ui.bind('.master', {
                empId: employee.memberId,
                staff: employee.memberNm,
                stafftel: employee.memberMobile
            })
        }
    }

    var isModify = false;


    function showProductSelector() {
        if (!uglcw.ui.get('#stkId').value()) {
            uglcw.ui.get('#stkId').K().open();
            return uglcw.ui.warning('请选择仓库');
        }
        if (!uglcw.ui.get('#cstId').value() && xsfpQuickBill == 'none') {
            selectCustomer(false);
            return uglcw.ui.warning('请选择客户');
        }
        <tag:product-out-selector-script fullscreen="true" callback="onProductSelect"/>
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
        model.xsTp = '正常销售';
        model.hsNum = item.hsNum;
        model.wareCode = item.wareCode;
        model.wareGg = item.wareGg;
        model.wareNm = item.wareNm;
        model.wareDw = item.wareDw;
        model.qty = 1;
        var redMark =$('#redMark').val();
        if(redMark==1){
            model.qty = -1;
        }
        model.sunitFront = item.sunitFront;
        model.wareId = item.wareId;
        model.minUnit = item.minUnit;
        model.minUnitCode = item.minUnitCode;
        model.maxUnitCode = item.maxUnitCode;
        model.beBarCode = item.beBarCode;
        model.packBarCode = item.packBarCode;
        model.activeDate = item.activeDate || item.qualityDays || '';
        item.unitName = item.wareDw;
        model.beUnit = item.maxUnitCode;
        model.productDate = item.productDate || '';
        model.sswId = item.sswId;
        var autoPrice = uglcw.ui.get('#autoPrice').value();
        loadProductInfo(model, function (payload) {
            setPrice(model, payload.raw)
        }, true, autoPrice == '1');
        setUnit(model);
        model.amt = model.price * model.qty;
        __formatStkQty(model);
        var grid = uglcw.ui.get('#grid');
        grid.commit();
        var $current = $('#grid .k-grid-content tr:eq(' + rowIndex + ') td.cell-product-name');
        if ($current.length == 0) {
            $current = $('#grid .k-grid-content tr:last-child td.cell-product-name');
        }
        var $next = grid.getNextEditableCell($current, rowIndex);
        grid.k().current($next);
        grid.k().editCell($next);
    }

    function checkAndCloseCell(grid) {
        if (!grid) {
            grid = uglcw.ui.get('#grid').k();
        }
        if ($('#grid_active_cell').length > 0) {
            grid.closeCell($('#grid_active_cell'));
        }
    }

    function onQueryProduct(param) {
        param.stkId = uglcw.ui.get('#stkId').value();
        param.customerId = uglcw.ui.get('#cstId').value();
        param.proType = uglcw.ui.get('#proType').value();
        return param;
    }

    /**
     * 产品选择回调
     */
    function onProductSelect(data) {
        var autoPrice = uglcw.ui.get('#autoPrice').value();
        if (data && data.length > 0) {
            data = $.map(data, function (row) {
                var item;
                if ($.isFunction(row.toJSON)) {
                    item = row.toJSON();
                } else {
                    item = row;
                }
                item.xsTp = '正常销售';
                item.qty = 1;
                var redMark =$('#redMark').val();
                if(redMark==1){
                    item.qty = -1;
                }
                item.id = uglcw.util.uuid();
                item.price = item.inPrice || '0';
                loadProductInfo(item, function (payload) {
                    setPrice(item, payload.raw)
                }, true, autoPrice == '1');
                item.unitName = item.wareDw;
                item.beUnit = item.maxUnitCode;
                item.activeDate = item.activeDate || item.qualityDays || '';
                setUnit(item);
                item.qty = item.qty || item.stkQty || 1;
                item.amt = parseFloat(item.qty) * parseFloat(item.price || 0);
                item.productDate = item.productDate || '';
                __formatStkQty(item, true);
                return item;
            });
            var grid = uglcw.ui.get('#grid');
            var rows = grid.k().dataSource.data();
            //优先填充空行
            var i = 0;
            $(rows).each(function (index, r) {
                if (!r.wareId && i < data.length) {
                    //表格中已存在的空行,copy属性
                    uglcw.extend(r, data[i]);
                    //标记挑选的已添加的下标
                    i++;
                }
            });
            data = $.map(data, function (item, j) {
                if (j >= i) {
                    //忽略上面已填充的数据
                    return item;
                }
            });
            rows = rows.toJSON();
            grid.bind(rows.concat(data));
            //grid.addRow(data);
            //先关闭
            checkAndCloseCell(grid.k());
            grid.scrollBottom();
            //grid.commit();
            var tips = '本次共';
            if (i > 0) {
                tips += '填充[' + i + ']行';
            }
            if (data.length > 0) {
                tips += ' 新增[' + data.length + ']行'
            }
            uglcw.ui.success(tips);
        }
    }

    function setUnit(item, specUnit) {
        if (item.wareDw && !item.minUnit) {
            item.beUnit = specUnit || item.maxUnitCode;
            return;
        } else if (item.minUnit && !item.wareDw) {
            item.beUnit = specUnit || item.minUnitCode;
            item.price = item.sUnitPrice || 0;
            item.sunitJiage = item.sUnitPrice || 0;
            item.sunitQty = item.qty;
            return;
        }

        var beUnit;
        //开启小单位开单或者商品小单位开单
        var isSUnitPrice = uglcw.ui.get('#isSUnitPrice').value();
        if (item.sunitFront == 1 && isSUnitPrice == 1) {
            beUnit = item.minUnitCode;
            item.price = item.sUnitPrice || 0;
        } else {
            beUnit = item.maxUnitCode;
        }
        item.beUnit = specUnit || beUnit;
        item.sunitJiage = item.sUnitPrice || 0;
        item.sunitQty = item.beUnit === 'S' ? item.qty : item.qty / item.hsNum;
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
        if (payload.hisPrice != undefined && payload.hisPrice != '' && payload.hisPrice != 0) {
            item.bUnitPrice = payload.hisPrice;
            if (!payload.minHisPrice) {
                item.sUnitPrice = item.bUnitPrice / hsNum;
            }
        }

        if (payload.minHisPrice != undefined && payload.minHisPrice != '' && payload.minHisPrice != 0) {
            item.sUnitPrice = payload.minHisPrice;
            if (!payload.hisPrice) {
                item.bUnitPrice = item.minHisPrice * hsNum;
            }
        }
        item.price = ((item.sunitFront == 1 || item.beUnit == 'S') ? item.sUnitPrice : item.bUnitPrice) || 0
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
                params.customerId = uglcw.ui.get('#cstId').value();
                params.wareId = row.wareId;
                return params;
            },
            columns: [
                {title: '商品名称', field: 'wareNm', width: 120, tooltip: true},
                {title: '单位', field: 'unitName', width: 70},
                {title: '数量', field: 'qty', width: 70, format: '{0:n2}'},
                // {title: '入库日期', field: 'inTimeStr', width: 150},
                {title: '生产日期', field: 'productDate', width: 120}
            ],
            yes: function (data) {
                if (data && data.length > 0) {
                    var r = data[0];
                    //row.productDate = r.productDate;
                    row.set("productDate", r.productDate);
                    if (productDateConfig == '') {
                        row.sswId = r.id;
                    }
                    checkProductDate();
                }
            }
        })
    }

    /**
     * 加载订单明细
     */
    function queryOrderDetail() {
        var orderId = uglcw.ui.get('#orderId').value();
        if (orderId) {
            $.ajax({
                url: '${base}manager/queryOrderSub',
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
                            //TODO loadProductDate
                        });
                        uglcw.ui.get('#grid').bind(response.rows);
                        checkPriceDiff();
                    }
                }
            })
        }
    }


    function draftSaveStk() {//暂存
        var status = uglcw.ui.get('#status').value();
        if (status == 0) {
            return uglcw.ui.warning('该单据已审批,不能暂存!')
        }
        if (!uglcw.ui.get('form').validate()) {
            return;
        }
        uglcw.ui.get('#grid').commit();
        var data = uglcw.ui.bind('form');
        data.cstId = data.cstId || 0;
        data.proType = data.proType || 2;
        data.staffTel = data.stafftel || '';
        data.shr = data.khNm;
        if (data.pszd != '公司直送' && !data.epCustomerId) {
            //TODO 是否返回
            return uglcw.ui.notice({
                title: '提示',
                desc: '当配送指定为【直供转单二批】时，请选择二批客户'
            })
        }
        var products = uglcw.ui.get('#grid').k().dataSource.view().toJSON();
        if (products.length < 1) {
            uglcw.ui.error('请选择商品');
            return;
        }
        var bool = true;
        if('${redMark}'=='1'){
            bool =  checkFormQtySign(products,-1);
        }else{
          bool =  checkFormQtySign(products,1);
        }
        if(!bool){
            return;
        }
        data.id = data.billId;
        products = $.map(products, function (product) {
            product.productDate = product.productDate || "";
            product.activeDate = product.activeDate || "";
            product.remarks = product.remarks || "";
            product.price = product.price || 0;
            product.checkWare = product.checkWare ? 1 : 0;
            product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
            if (product.wareId) {
                return product;
            }
        });
        if (products.length < 1) {
            uglcw.ui.error('请选择商品');
            return;
        }
        data.wareStr = JSON.stringify(products);
        data.checkAutoPrice = uglcw.ui.get('#wareXsPrice').value();
        data.checkCustomerPrice = uglcw.ui.get('#wareCustomerPrice').value();

        $.ajaxSettings.async = false;
        var bool = true;
        if (productDateConfig == '') {
            bool = checkSubmitData();
            if (!bool) {
                uglcw.ui.confirm('是否继续暂存？', function () {
                    checkProductStock(data.stkId, products, function () {
                        uglcw.ui.loading();
                        uglcw.ui.Modal.close();
                        $.ajax({
                            url: '${base}manager/draftSaveStkOut',
                            type: 'post',
                            data: data,
                            dataType: 'json',
                            success: function (json) {
                                uglcw.biz.refreshPageToken();
                                if (json.state) {
                                    uglcw.ui.info('暂存成功');
                                    pageState(BILL_STATES.STAGING);
                                    json.billId = json.id;
                                    uglcw.ui.get('#billStatus').value('暂存成功');
                                    uglcw.ui.bind('body', json);
                                    $('#grid').data('_change', false);
                                }
                                isModify = false;
                                var snpashotId = uglcw.ui.get('#snapshotId').value();
                                if (snpashotId) {
                                    removeSnapshot(null, snpashotId);
                                    uglcw.ui.get('#snapshotId').value('');
                                }
                                $('.snapshot-badge-dot').hide();
                                uglcw.ui.loaded();
                            },
                            error: function () {
                                uglcw.ui.loaded();
                                uglcw.ui.error('暂存失败');
                            }
                        })
                    }, '暂存');
                    return false;
                })
            }
        }

        if (bool) {
            uglcw.ui.confirm('是否确定暂存？', function () {
                checkProductStock(data.stkId, products, function () {
                    uglcw.ui.loading();
                    uglcw.ui.Modal.close();
                    $.ajax({
                        url: '${base}manager/draftSaveStkOut',
                        type: 'post',
                        data: data,
                        dataType: 'json',
                        success: function (json) {
                            uglcw.biz.refreshPageToken();
                            if (json.state) {
                                uglcw.ui.info('暂存成功');
                                pageState(BILL_STATES.STAGING);
                                json.billId = json.id;
                                uglcw.ui.get('#billStatus').value('暂存成功');
                                uglcw.ui.bind('body', json);
                                $('#grid').data('_change', false);
                            }
                            isModify = false;
                            var snapshotId = uglcw.ui.get('#snapshotId').value();
                            if (snapshotId) {
                                removeSnapshot(null, snapshotId);
                                uglcw.ui.get('#snapshotId').value('');
                            }
                            $('.snapshot-badge-dot').hide();
                            uglcw.ui.loaded();
                        },
                        error: function () {
                            uglcw.ui.loaded();
                            uglcw.ui.error('暂存失败');
                        }
                    })
                }, '暂存');
                return false;
            })
        }
    }

    /**
     * 保存并审批
     */
    function submitStk() {
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');
        form.id = form.billId;
        form.proType = form.proType || 2;
        form.checkAutoPrice = uglcw.ui.get('#wareXsPrice').value();
        var products = uglcw.ui.get('#grid').k().dataSource.view().toJSON();
        if (products.length < 1) {
            uglcw.ui.error('请选择商品');
            return;
        }
        var bool = true;
        if('${redMark}'=='1'){
            bool =  checkFormQtySign(products,-1);
        }else{
            bool =  checkFormQtySign(products,1);
        }
        if(!bool){
            return;
        }
        if (!form.cstId) {
            form.cstId = 0;
        }
        form.staffTel = form.stafftel || '';
        form.shr = form.khNm;
        $("#autoCreateFhd").val(1);
        if ($("#autoCreateFhd1").val() != undefined && $("#autoCreateFhd1").is(":checked") == true) {
            $("#autoCreateFhd").val(0);
        }
        products = $.map(products, function (product) {
            product.productDate = product.productDate || "";
            product.activeDate = product.activeDate || "";
            product.remarks = product.remarks || "";
            product.price = product.price || 0;
            product.checkWare = product.checkWare ? 1 : 0;
            product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
            if (product.wareId) {
                return product;
            }
        });
        form.wareStr = JSON.stringify(products);
        form.autoCreateFhd = $("#autoCreateFhd").val();

        $.ajaxSettings.async = false;
        var bool = true;
        if (productDateConfig == '') {
            bool = checkSubmitData();
            if (!bool) {
                uglcw.ui.confirm('是否继续操作？', function () {
                    checkProductStock(form.stkId, products, function () {
                        uglcw.ui.loading();
                        $.ajax({
                            url: '${base}manager/addStkOut',
                            type: 'post',
                            dataType: 'json',
                            data: form,
                            success: function (json) {
                                if (json.state) {
                                    uglcw.ui.info('提交成功');
                                    //uglcw.ui.get('#billStatus').value('提交成功');
                                    uglcw.ui.get("#status").value(0);
                                    uglcw.ui.get("#billId").value(json.id);
                                    uglcw.ui.get("#billNo").value(json.billNo);
                                    if (json.autoSend) {
                                        pageState(BILL_STATES.SHIPPED);
                                        uglcw.ui.get('#billStatus').value('已发货')
                                    } else {
                                        pageState(BILL_STATES.UNSHIPPED);
                                        uglcw.ui.get('#billStatus').value('提交成功')
                                    }

                                    $('#grid').data('_change', false);
                                    uglcw.biz.refreshPageToken();
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
                    }, '保存并审批');
                    return false;
                })
            }
        }
        if (bool) {
            checkProductStock(form.stkId, products, function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/addStkOut',
                    type: 'post',
                    dataType: 'json',
                    data: form,
                    success: function (json) {
                        if (json.state) {
                            uglcw.ui.info('提交成功');
                            //uglcw.ui.get('#billStatus').value('提交成功');
                            uglcw.ui.get("#status").value(0);
                            uglcw.ui.get("#billId").value(json.id);
                            uglcw.ui.get("#billNo").value(json.billNo);
                            if (json.autoSend) {
                                pageState(BILL_STATES.SHIPPED);
                                uglcw.ui.get('#billStatus').value('已发货')
                            } else {
                                pageState(BILL_STATES.UNSHIPPED);
                                uglcw.ui.get('#billStatus').value('提交成功')
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
                        uglcw.ui.error('提交失败');
                    }
                })
            }, '保存并审批')
        }
    }

    //审批
    function auditDraftStkOut() {
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
            return uglcw.ui.warning('单据有变动请先【暂存】');
        }
        var billId = uglcw.ui.get('#billId').value();
        $("#autoCreateFhd").val(1);
        if ($("#autoCreateFhd1").val() != undefined && $("#autoCreateFhd1").is(":checked") == true) {
            $("#autoCreateFhd").val(0);
        }
        var products = uglcw.ui.get('#grid').bind();
        if (products.length < 1) {
            uglcw.ui.error('请选择商品');
            return;
        }
        products = $.map(products, function (product) {
            product.productDate = product.productDate || "";
            product.activeDate = product.activeDate || "";
            product.remarks = product.remarks || "";
            product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
            if (product.wareId) {
                return product;
            }
        });
        var stkId = uglcw.ui.get('#stkId').value();
        var autoCreateFhd = $("#autoCreateFhd").val();
        if ('${reAudit}' == 0 || autoCreateFhd == 0) {
            uglcw.ui.confirm('是否确定审核？', function () {
                toAudit(stkId, products, billId, "");
            })
        } else {
            var win = uglcw.ui.Modal.open({
                title: '审批',
                //content: $('#auditDraftStkOut').html(),
                content:$('#reAuditDlg').html(),
                success: function (c) {
                    uglcw.ui.init(c);
                },
                yes: function (c) {
                    var data = uglcw.ui.bind(c);
                    var sendTime = data.sendTime;
                    toAudit(stkId, products, billId, sendTime);
                    uglcw.ui.Modal.close(win);
                }
            })
        }
    }

    function toAudit(stkId, products, billId, sendTime) {
        checkProductStock(stkId, products, function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/auditDraftStkOut',
                type: 'post',
                data: {
                    billId: billId,
                    autoCreateFhd: $("#autoCreateFhd").val(),
                    sendTime: sendTime,
                    changeOrderPrice: uglcw.ui.get('#changeOrderPrice').value()
                },
                dataType: 'json',
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.info('审批成功');
                        uglcw.ui.get('#billStatus').value('审批成功')
                        uglcw.ui.get('#status').value(0)
                        if (json.autoSend) {
                            pageState(BILL_STATES.SHIPPED);
                            uglcw.ui.get('#billStatus').value('已发货')
                        } else {
                            pageState(BILL_STATES.UNSHIPPED);
                            uglcw.ui.get('#billStatus').value('未发货')
                        }
                        $('#grid').data('_change', false);
                    } else {
                        uglcw.ui.error('审核失败!');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        }, '审批');
    }

    //检查产品库存
    function checkProductStock(stkId, products, callback, op) {
        $.ajax({
            url: '${base}manager/checkStorageWare',
            type: 'POST',
            data: {
                stkId: stkId,
                wareStr: JSON.stringify(products)
            },
            success: function (response) {
                //TODO clearStockTips
                if (response && response.state) {
                    var checkAuto = false;//是否分配发货
                    if ($("#autoCreateFhd1").val() != undefined && $("#autoCreateFhd1").is(":checked") == true) {
                        checkAuto = true;
                    }
                    if ((op == '暂存' || checkAuto) && response.msg) {
                        uglcw.ui.confirm(response.msg + '是否继续?', function () {
                            callback();
                        }, null, {maxHeight: 450})
                        return;
                    }

                    var stockIds = response.stockIds;
                    if (stockIds && AUTO_CREATE_FHD == '' && NEW_STOCK_CAL == 'none') {
                        uglcw.ui.notice({
                            type: 'error',
                            title: '提示',
                            desc: '以下商品库存不足:' + stockIds + ',不允许' + op + '！'
                        });
                        return;
                    }
                    if (response.changeWareIds) {
                        uglcw.ui.confirm("以下无库存商品未设置采购价:" + response.msg2 + " 是否去设置", function () {
                            showWareInPriceSetting(response.changeWareIds);
                            return;
                        }, function () {
                        }, {
                            title: '库存校验提示',
                            maxHeight: 400,
                            btn: ['去设置', '取消']
                        })
                    }

                    if(response.msg3){
                        uglcw.ui.notice({
                            type: 'error',
                            title: '提示',
                            desc: response.msg3 +',不允许' + op + '！'
                        });
                        return;
                    }

                    if (response.msg) {
                        uglcw.ui.confirm(response.msg + '<span style="float:right">是否继续？</span>', function () {
                            callback();
                        }, function () {
                        }, {
                            title: '库存校验提示',
                            btn: ['继续', '取消'],
                            maxHeight: 400
                        });
                        showWareStockTip(response.wareIds);
                    } else {
                        callback();
                    }
                } else {
                    uglcw.ui.error(response.msg || '库存校验失败');
                    callback();
                }
            }
        })
    }

    function showWareStockTip(wareIds) {
        //FIXME 提示库存不足？
    }


    function printClick() {
        var status = uglcw.ui.get('#status').value();
        if (status == 2) {
            return uglcw.ui.warning('单据已作废');
        }
        if ($('#grid').data('_change')) {
            return uglcw.ui.warning('单据有变动请先【暂存】');
        }

        var billId = uglcw.ui.get('#billId').value();
        //uglcw.ui.openTab('打印销售发票[' + billId + ']', '${base}manager/showstkoutprint?fromFlag=0&billId=' + billId);
        window.location.href = '${base}manager/showstkoutprint?fromFlag=0&billId=' + billId;
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
                url: '${base}/manager/reAuditStkOut',
                type: 'post',
                dataType: 'json',
                data: {billId: billId},
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('反审批成功！');
                        pageState(BILL_STATES.STAGING);
                        setTimeout(function () {
                            window.location.href = '${base}/manager/showstkout?billId=' + uglcw.ui.get('#billId').value();
                        }, 1000);
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
                url: '${base}/manager/cancelStkOut',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('作废成功');
                        pageState(BILL_STATES.CANCELLED);
                        uglcw.ui.get('#billStatus').value('作废');
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

    function auditProc(billId) {
        uglcw.ui.openTab('发货单', '${base}manager/showstkoutcheck?dataTp=1&billId=' + billId);
    }

    //采购价设置
    function showWareInPriceSetting(ids) {
        uglcw.ui.Modal.open({
            title: '请设置采购价',
            resizable: false,
            maxmin: false,
            btns: false,
            content: uglcw.util.template($('#wareinprice-setting-tpl').html())({ids: ids}),
            success: function (c) {
                uglcw.ui.init(c);
                var grid = uglcw.ui.get($(c).find('.uglcw-grid'));
                grid.k().dataSource.bind('change', function (e) {
                    var action = e.action;
                    if (action === 'itemchange') {
                        var item = e.items[0];
                        if (e.field === 'inPrice') {
                            $.ajax({
                                url: '${base}manager/updateWareInPrice',
                                type: 'POST',
                                data: {
                                    id: item.wareId,
                                    inPrice: item.inPrice
                                },
                                success: function (response) {
                                    if (response == '1') {
                                        uglcw.ui.toast('保存成功');
                                    } else {
                                        uglcw.ui.toast('保存失败');
                                    }
                                }
                            })
                        }
                    }
                })
            }
        })
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
        var stkId = uglcw.ui.get('#stkId').value();
        var recAmt = uglcw.ui.get('#discountAmount').value();
        var form = {
            recAmt: recAmt
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

                var products = uglcw.ui.get('#grid').bind();
                if (products.length < 1) {
                    uglcw.ui.error('请选择商品');
                    return;
                }
                products = $.map(products, function (product) {
                    product.productDate = product.productDate || "";
                    product.activeDate = product.activeDate || "";
                    product.remarks = product.remarks || "";
                    product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
                    if (product.wareId) {
                        return product;
                    }
                });
                if (!uglcw.ui.get($(c).find('.form-horizontal')).validate()) {
                    return false;
                }
                var data = uglcw.ui.bind(c);
                data.billId = billId;
                if (parseFloat(data.recAmt) > parseFloat(recAmt)) {
                    uglcw.ui.info('收款金额不能大于' + recAmt)
                    return false;
                }
                if('${reAudit}' == 0 || data.autoSend == 2){
                    postAccData(stkId,products,data,win);
                }else{
                    var subWin = uglcw.ui.Modal.open({
                        title: '过账发货日期',
                        content:$('#reAuditDlg').html(),
                        success: function (c) {
                            uglcw.ui.init(c);
                        },
                        yes: function (c) {
                            var subData = uglcw.ui.bind(c);
                            data.sendTime = subData.sendTime;
                            postAccData(stkId,products,data,win);
                            uglcw.ui.Modal.close(subWin);
                        }
                    })
                }
                return false;
            }
        })
    }

    function  postAccData(stkId,products,data,win) {
        checkProductStock(stkId, products, function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/postDraftStkOut',
                type: 'POST',
                data: data,
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success(response.msg);
                        pageState(BILL_STATES.SHIPPED);
                        uglcw.ui.get('#paystatus').value('已结清');
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
        }, '一键过账');
    }

    function unLockBill(billId){
        uglcw.ui.confirm('是否确认解锁该订单，解锁后，已修改信息无效！', function () {
            $.ajax({
                url: '${base}manager/unLockBill',
                type: 'POST',
                data: {
                    billId:billId
                },
                success: function (response) {
                    if(response.state){
                        uglcw.ui.info("操作成功");
                        $("#unLockBill").hide();
                    }else{
                        uglcw.ui.info("操作失败");
                    }
                }
            })
        });
    }

</script>
</body>
</html>
