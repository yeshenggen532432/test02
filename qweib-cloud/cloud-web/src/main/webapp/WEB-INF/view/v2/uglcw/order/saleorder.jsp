<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-in {
            width: 100%;
            margin-right: 10px;
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
                <c:if test="${bforder.orderZt == '未审核'}">
                    <li onclick="saveAudit()" class="k-info" data-icon="save">保存</li>
                </c:if>
            </ul>
            <div class="bill-info">
                <span class="status" id="orderNo" style="color:green;">${bforder.orderNo}</span>
                <span class="status" id="divOrderStatus" style="color:green;">${bforder.orderZt}</span>
            </div>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${bforder.id}"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="pszd" value="${bforder.pszd}"/>
                <input uglcw-role="textbox" type="hidden" uglcw-model="proType" value="${bforder.proType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="orderZt" id="orderZt"
                       value="${bforder.orderZt}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="orderTp" id="orderTp"
                       value="${bforder.orderTp}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="orderLb" id="orderLb"
                       value="${bforder.orderLb}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="shopMemberId" id="shopMemberId"
                       value="${bforder.shopMemberId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="shopMemberName" id="shopMemberName"
                       value="${bforder.shopMemberName}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status"
                       value="${bforder.status}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="isPay" id="isPay" value="${bforder.isPay}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="payType" id="payType"
                       value="${bforder.payType}"/>


                <input type="hidden" uglcw-role="textbox" uglcw-model="isSend" id="isSend"
                       value="${bforder.isSend}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="isFinish" id="isFinish"
                       value="${bforder.isFinish}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="payTime" id="payTime"
                       value="${bforder.payTime}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="transportName" id="transportName"
                       value="${bforder.transportName}"/>
                <%--<input  type="hidden" uglcw-role="textbox" uglcw-model="finishTime" id="finishTime" value="${bforder.finishTime}"/>
                <input  type="hidden" uglcw-role="textbox" uglcw-model="cancelTime" id="cancelTime" value="${bforder.cancelTime}"/>--%>
                <input type="hidden" uglcw-role="textbox" uglcw-model="cancelRemo" id="cancelRemo"
                       value="${bforder.cancelRemo}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="transportCode" id="transportCode"
                       value="${bforder.transportCode}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="freight" id="freight"
                       value="${bforder.freight}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="couponCost" id="couponCost"
                       value="${bforder.couponCost}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="token" id="token"
                       value="${token}"/>

                <div class="form-group">
                    <label class="control-label col-xs-3">客户名称</label>
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-model="cid" uglcw-role="textbox" id="cid" value="${bforder.cid}">
                        <input uglcw-role="gridselector" uglcw-validate="required" uglcw-options="click: function(){
                                    querycustomer();
                                }" uglcw-model="khNm" value="${bforder.khNm}"/>
                    </div>
                    <label class="control-label col-xs-3">送货日期</label>
                    <div class="col-xs-4">
                        <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="shTime" value="${bforder.shTime}">
                    </div>
                    <label class="control-label col-xs-3">订单日期</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="oddate" readonly uglcw-model="oddate"
                               value="${bforder.oddate}"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">收货人</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="shr" uglcw-model="shr"
                               value="${bforder.shr}"/>
                    </div>
                    <label class="control-label col-xs-3">客户地址</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="address" uglcw-model="address"
                               value="${bforder.address}"/>
                    </div>
                    <label class="control-label col-xs-3">联系电话</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="tel" uglcw-model="tel"
                               value="${bforder.tel}"/>
                    </div>

                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">配送指定</label>
                    <div class="col-xs-4">
                        <select uglcw-role="combobox" uglcw-model="pszd"
                                uglcw-role="combobox" value="${bforder.pszd}">
                            <option value="公司直送">公司直送</option>
                            <option value="转二批配送">转二批配送</option>
                        </select>
                    </div>
                    <label class="control-label col-xs-3">业务员</label>
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-model="mid" uglcw-role="textbox" id="mid" value="${bforder.mid}">
                        <input uglcw-role="gridselector" uglcw-validate="required" uglcw-options="click: function(){
                                    queryMemberByName();
                                }" uglcw-model="memberNm" value="${bforder.memberNm}"/>
                    </div>
                    <label class="control-label col-xs-3">仓库</label>
                    <div class="col-xs-4">
                        <tag:select2 name="stkId" id="stkId" tclass="pcl_sel" index="0"
                                     value="${bforder.stkId }"
                                     whereBlock="status=1 or status is null"
                                     tableName="stk_storage" displayKey="id" displayValue="stk_name"/>

                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 10px;">
                    <label class="control-label col-xs-3">商品总价</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="zje" readonly uglcw-model="zje"
                               value="${bforder.zje}"/>
                    </div>
                    <label class="control-label col-xs-3">整单折扣</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="zdzk" uglcw-model="zdzk"
                               value="${bforder.zdzk}"/>
                    </div>

                    <label class="control-label col-xs-3">商品净收入总额</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="cjje" readonly uglcw-model="cjje"
                               value="${bforder.cjje}"/>
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 10px;">
                    <label class="control-label col-xs-3">促销总额</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="promotionCost" readonly uglcw-model="promotionCost"
                               value="${bforder.promotionCost}"/>
                    </div>
                    <label class="control-label col-xs-3">运费</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="freight" readonly uglcw-model="freight"
                               value="${bforder.freight}"/>
                    </div>

                    <label class="control-label col-xs-3">订单实付</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="orderAmount" readonly uglcw-model="orderAmount"
                               value="${bforder.orderAmount}"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                    <div class="col-xs-18">
                                <textarea uglcw-role="textbox" uglcw-model="remo"
                                          style="width: 100%;">${bforder.remo}</textarea>
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
						  toolbar: uglcw.util.template($("#toolbar").html()),
                          id: "id",
                          editable: true,
                          add: function(row){
                            row = uglcw.extend({
                                xsTp: "正常销售",
                                id: uglcw.util.uuid()
                            }, row);
                            row.beUnit = row.maxUnitCode;
                            return row;
                          },
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "wareZj", aggregate: "sum"},
                            {field: "wareNum", aggregate: "sum"}
                          ],
                          <%--change: calTotalAmount,--%>
                          dataSource: gridDataSource
                        '
            >
                <div data-field="wareNm" uglcw-options="width: 210,
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
                                var rowIndex = $(container).closest('tr').index();
                                var cellIndex = $(container).index();
                                var input = $('<input name=\'_wareCode\' data-bind=\'value: wareNm\' placeholder=\'输入商品名称、商品代码、商品条码\' />');
                                input.appendTo(container);
                                $('<span data-for=\'_wareCode\' class=\'k-widget k-tooltip k-tooltip-validation k-invalid-msg\'>请选择商品</span>').appendTo(container);
                                new uglcw.ui.AutoComplete(input).init({
                                    highlightFirst: true,
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
                                    template: '<div><span>#= data.wareNm#</span><span style=\'float: right\'>#= data.wareGg#</span></div>',
                                    select: function (e) {
                                        var item = e.dataItem;
                                        var model = options.model;
                                        model.xsTp = '正常销售';
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
                                        model.productDate = item.productDate || new Date();
                                        uglcw.ui.get('#grid').commit();
                                        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
                                    }
                                });
                           }
                        ">产品名称
                </div>
                <div data-field="wareGg" uglcw-options="width: 120, schema:{editable: false}">产品规格</div>
                <%--<div data-field="detailWareGg" uglcw-options="width: 120,editable: false">产品规格</div>--%>
                <div data-field="xsTp"
                     uglcw-options="width: 120, editor: function(container, options){
                                       var rowIndex = $(container).closest('tr').index();
                                        var cellIndex = $(container).index();
                                        var input = $('<input data-bind=\'value:xsTp\' />')
                                        input.appendTo(container);
                                        var widget = new uglcw.ui.ComboBox(input);
                                        widget.init({
                                            value: options.model.xsTp,
                                            dataTextField: 'text',
                                            dataValueField: 'value',
                                            dataSource:[{text:'正常销售',value:'正常销售'},{text:'促销折让',value:'促销折让'},
                                            {text:'消费折让',value:'消费折让'},{text:'费用折让',value:'费用折让'},{text:'其他销售',value:'其他销售'}],
                                            change: function(){
                                              uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
                                            }

                                        })
                                     }">
                    销售类型
                </div>
                <div data-field="beUnit" uglcw-options="width: 80,  template: '#= data.beUnit == data.maxUnitCode ? data.wareDw||\'\' : data.minUnit||\'\' #',
                            editor: function(container, options){
                              var rowIndex = $(container).closest('tr').index();
                                var cellIndex = $(container).index();
                             var model = options.model;

                             if(!model.wareId){
                                $(container).html('<span>请先选择产品</span>')
                                return ;
                             }

                             var input = $('<input name=\'beUnit\'>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.ComboBox(input);
                             widget.init({
                              value: model.beUnit || model.maxUnitCode,
                              dataSource:[
                              { text: model.wareDw, value:model.maxUnitCode },
                              { text: model.minUnit, value:model.minUnitCode}
                              ],
                              change: function(){
                                   uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
                              }
                             })
                            }">单位
                </div>
                <div data-field="wareDj"
                     uglcw-options="width: 80, schema:{editable: true,type: 'number',decimals:10}">单价
                </div>
                <div data-field="wareNum"

                     uglcw-options="width: 80,
                                     aggregates: ['sum'],
                                     schema:{ type: 'number',decimals:10},
                                     footerTemplate: '#= (sum||0) #'
                                    ">订单数量
                </div>
                <div data-field="wareZj"
                     uglcw-options="width: 100,
                                        format:'{0:n2}',
                                        schema:{ type: 'number'},
                                        aggregates: ['sum'],
                                         footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#'"
                >
                    订单金额
                </div>
                <div data-field="remark" uglcw-options="width: 120,schema:{editable: true}">备注</div>
                <div data-field="options" uglcw-options="width: 120, command:'destroy'">操作</div>
                <%--  <div data-field="detailWareNm" uglcw-options="hidden:true"/>
                  <div data-field="detailWareGg" uglcw-options="hidden:true"/>
                  <div data-field="detailShopWareAlias" uglcw-options="hidden:true"/>
                  <div data-field="detailWareDesc" uglcw-options="hidden:true"/>
                  <div data-field="wareDjFinal" uglcw-options="hidden:true"/>
                  <div data-field="detailPromotionCost" uglcw-options="hidden:true"/>
                  <div data-field="detailCouponCost" uglcw-options="hidden:true"/>--%>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:showWare();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加商品

    </a>
    <div class="k-button k-button-icontext">
        <input type="checkbox" uglcw-role="checkbox"
               uglcw-options="type:'number'"
               class="k-checkbox" id="load-price">
        <label style="margin-bottom: 0px;" class="k-checkbox-label" for="load-price">加载最新销售价</label>
    </div>
    <div class="k-button k-button-icontext ware-price" style="padding: 5px 14px 2px 14px;" id="showHisPriceDiv">
        <div id="history-price" class="price"><label>历史价</label><span></span></div>
        <div id="latest-price" class="price"><label>执行价</label><span></span></div>
        <div id="product-price" class="price"><label>商品价</label><span></span></div>
    </div>

</script>
<tag:compositive-selector-template/>
<tag:costitem-selector-template/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var gridDataSource = ${fns:toJson(warelist)};
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange') {
                var item = e.items[0];
                var commit = false;
                if (e.field == 'wareNum' || e.field == 'wareDj') {
                    var wareZj = Number(item.wareDj * item.wareNum).toFixed(2);
                    item.set('wareZj', Number(item.wareDj * item.wareNum).toFixed(2));
                    commit = true;
                } else if (e.field === 'xsTp') { //销售类型
                    if (item.xsTp === '促销折让') {
                        item.set('wareDj', 0);
                        item.set('wareZj', 0);
                        commit = true;
                    }
                }
                if (commit) {
                    uglcw.ui.get('#grid').commit();
                }
                calTotalAmount();
                //uglcw.ui.get('#grid').commit();
            }
        });

        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        $('#zdzk').on('change', calTotalAmount);
        //setTimeout(uglcw.ui.loaded, 210);
        var loadDelay;
        $('#grid').on('mouseover', 'tbody tr', function () {
            var that = this;
            if (!$('#load-price').is(':checked')) {
                return
            }
            if (!uglcw.ui.get('#cid').value()) {
                return
            }
            if (loadDelay) {
                clearTimeout(loadDelay)
            }
            loadDelay = setTimeout(function () {//延迟加载
                var row = uglcw.ui.get('#grid').k().dataItem($(that));//获取当前行数据
                if (row.wareId) {
                    loadSalePrice(row.wareId, function (data) {//data回调显示对应的字段
                        $('#history-price span').text(uglcw.util.toString(data.hisPrice, 'n2'));
                        $('#latest-price span').text(uglcw.util.toString(data.zxPrice, 'n2'));
                        $('#product-price span').text(uglcw.util.toString(data.orgPrice, 'n2'));
                    })
                }
            }, 200)
        })
        uglcw.ui.loaded();
    })

    //加载最新销售价
    function loadSalePrice(wareId, callback) {
        var cid = uglcw.ui.get('#cid').value();
        $.ajax({
            url: '${base}manager/queryOrderSaleCustomerHisWarePrice',
            type: 'get',
            data: {cid: cid, wareId: wareId},
            dataType: 'json',
            success: function (response) {
                if (response.state) {
                    callback(response);
                }
            }
        })
    }


    function add() {
        uglcw.ui.openTab('销售订单', '${base}manager/addorder?r=' + new Date().getTime());
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
            total += (Number(item.wareZj));
        })
        uglcw.ui.get('#zje').value(total);
        uglcw.ui.get('#cjje').value(total - (uglcw.ui.get('#zdzk').value() || 0));
        $('#orderAmount').val(Number($('#cjje').val()) + Number($('#freight').val() || 0));
    }


    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }

    function querycustomer() {//客户名称
        uglcw.ui.Modal.showGridSelector({
            width: 900,
            pageable: true,
            type: "POST",
            url: '${base}manager/stkchoosecustomer',
            data: {},
            query: function (params) {
            },
            checkbox: true,
            criteria: '<input uglcw-role="textbox" placeholder="搜索" uglcw-model="khNm">',
            columns: [
                {field: 'khNm', title: '客户名称', width: 140, tooltip: true},
                {field: 'mobile', title: '电话', width: 120, tooltip: true},
                {field: 'address', title: '地址', width: 175, tooltip: true},
                {field: 'linkman', title: '联系人', width: 120},
                {field: 'branchName', title: '部门', width: 120},
                {field: 'memberNm', title: '业务员', width: 120},
                {field: 'shZt', title: '状态', width: 120},
            ],
            yes: function (data) {
                if (data && data.length > 0) {
                    uglcw.ui.bind('form', {
                        khNm: data[0].khNm, cid: data[0].id, address: data[0].address,
                        shr: data[0].linkman, memberNm: data[0].memberNm, mid: data[0].memId, tel: data[0].mobile
                    });

                }
            }
        })
    }


    function saveAudit() {//保存
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');
        if (form.mid == "") {
            return uglcw.ui.warning('请选择业务员！');
        }
        if (form.orderZt == '审核') {
            return uglcw.ui.warning('该订单已审核');
        }
        if (form.payType && form.payType != '0' && form.payType != '1') {
            return uglcw.ui.warning("该订单已提交支付系统不可修改");
        }
        form.id = form.id;

        form.orderTp = form.orderTp || "销售订单";
        form.orderLb = form.orderLb || "电话单";

        var row = uglcw.ui.get('#grid').bind();//绑定表单数据
        if (row.length == 0) {
            uglcw.ui.warning("请选择商品！");
            return false;
        }
        row = $.map(row, function (product) {
            product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
            if (product.wareId) {
                return product;
            }
        });
        form.wareStr = JSON.stringify(row);
        uglcw.ui.confirm('保存后将不能修改，是否确定保存?', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/saveSaleorder',
                type: 'post',
                dataType: 'json',
                data: form,
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.success(json.msg);
                        if (json.status == '审核') {
                            $("#orderZt").val("审核");
                            $("#divOrderStatus").html("审核");
                        } else {
                            $("#divOrderStatus").html("提交成功");
                        }
                    } else {
                        uglcw.ui.error(json.msg || '保存失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded()
                }
            })
        })

    }

    function audit() {
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            uglcw.ui.error('该单据已审批,不能操作');
            return;
        }
        if (status == 2) {
            uglcw.ui.error('该单据已作废，不能操作！');
            return;
        }
        uglcw.ui.confirm('是否确定审批？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/updateFinRecAudit',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value(), costTerm: 1},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('审批成功');
                        $('#billStatus').text('审批成功');
                        uglcw.ui.get('#status').value(1);
                    }
                }
            })

        })
    }

    function toPrint() {
        uglcw.ui.openTab('采购开单${billId}打印', '${base}manager/showstkinprint?billId=${billId}');
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

    }

    function showWare() {//添加商品
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择仓库！');
        }
        uglcw.ui.Modal.showTreeGridSelector({
            title: false,
            tree: {
                url: '${base}manager/waretypes',
                model: 'waretype',
                expandable: function (node) {
                    return node.id === 0;
                },
                loadFilter: function (response) {
                    $(response).each(function (index, item) {
                        if (item.text == '根节点') {
                            item.text = '库存商品类';
                        }
                    })
                    return response;
                },
                id: 'id'
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
                {field: 'wareDj', title: '销售价格', width: 120},
                {field: 'stkQty', title: '库存数量', width: 120},
                {field: 'wareDw', title: '大单位', width: 120},
                {field: 'minUnit', title: '小单位', width: 120},
                {field: 'maxUnitCode', title: '大单位代码', width: 120, hidden: true},
                {field: 'minUnitCode', title: '小单位代码', width: 120, hidden: true},
                {field: 'hsNum', title: '换算比例', width: 120, hidden: true},
                {field: 'inPrice', title: '采购价', width: 120, hidden: true},
                {field: 'sunitFront', title: '开单默认选中小单位', width: 240, hidden: true}
            ],
            yes: function (data) {
                if (data) {
                    $(data).each(function (i, row) {
                        row.wareNum = 1;
                        row.wareDj = row.wareDj;
                        row.unitName = row.wareDw;
                        row.beUnit = row.maxUnitCode;
                        row.detailWareGg = row.wareGg;
                        row.wareZj = parseFloat(row.wareNum) * parseFloat(row.wareDj);
                        return row;
                    })
                    uglcw.ui.get('#grid').addRow(data);//添加到表单
                    uglcw.ui.get('#grid').scrollBottom();
                    uglcw.ui.get('#grid').commit();
                    calTotalAmount();//触发成交金额总金额
                }
            }
        })
    }

    function queryMemberByName() {//业务员
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
                        memberNm: employee.memberNm,
                        mid: employee.memberId,
                    })
                }
            }
        })
    }

</script>
</body>
</html>
