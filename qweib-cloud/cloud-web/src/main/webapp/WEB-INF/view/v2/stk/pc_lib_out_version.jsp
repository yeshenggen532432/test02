<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcu/css/biz/salesorder.css?v=20190705" media="all">
    <style>
        .uglcw-grid td {
            padding-top: .5em;
            padding-bottom: .5em;
        }

        .layui-fluid {
            padding: 5px 15px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card master">
        <form class="form-horizontal" uglcw-role="validator">
            <div class="actionbar layui-card-header">
                <div style="padding-left: 40px;font-family: Arial">
                    操作人：${reauditDesc} &nbsp;操作时间：${relaTime}
                    <div class="bill-info" style="margin-top: 10px">
                    <span class="no" style="color: green;"><div id="billNo" uglcw-model="billNo" style="height: 10px;"
                                                                uglcw-role="textbox">${billNo}</div></span>
                        <span class="status" style="color:red;"><div id="billStatus" style="height: 25px;width: 80px"
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
                    </div>
                </div>
            </div>
            <div class="layui-card-body">
                <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="pszd" id="outType" value="销售出库"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="pszd" id="pszd" value="${pszd}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="proType" id="proType" value="${proType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="autoPrice" id="autoPrice" value="${autoPrice}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="isSUnitPrice" id="isSUnitPrice"
                       value="${isSUnitPrice}">
                <input type="hidden" uglcw-role="textbox" uglcw-model="saleType" id="saleType" value="${saleType}"/>
                <div class="form-group">
                    <label class="control-label col-xs-3">销售订单</label>
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="orderId" id="orderId" value="${orderId}"/>
                        <input uglcw-role="textbox" uglcw-model="orderNo" value="${orderNo}" placeholder="请选择订单"/>
                    </div>
                    <label class="control-label col-xs-3">销售日期</label>
                    <div class="col-xs-4">
                        <input uglcw-role="datetimepicker" uglcw-model="outDate" value="${outTime}" placeholder="销售日期"
                               uglcw-options="format: 'yyyy-MM-dd HH:mm'" readonly/>
                    </div>
                    <label class="control-label col-xs-3">配送指定</label>
                    <div class="col-xs-4">
                        <select uglcw-role="combobox" uglcw-model="pszd"
                                uglcw-options="
                                value: '${pszd}',
                                change: function(){
                                    if(this.value() === '直供转单二批'){
                                        $('#ep-customer').show();
                                    }else{
                                        $('#ep-customer').hide();
                                    }
                                }
                                "
                                placeholder="配送指定">
                            <option value="公司直送">公司直送</option>
                            <option value="直供转单二批">直供转单二批</option>
                        </select>
                    </div>
                    <div id="ep-customer" style="display: none; padding-left: 0px;" class="col-xs-3">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="epCustomerId" value="${epCustomerId}"/>
                        <input uglcw-role="textbox"
                               placeholder="二批客户"
                               uglcw-model="epCustomerName" value="${epCustomerName}"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">客户名称</label>
                    <div class="col-xs-4">
                        <input id="cstId" uglcw-role="textbox" uglcw-model="cstId" type="hidden" value="${cstId}"/>
                        <input uglcw-role="textbox" uglcw-model="khNm" id="khNm" value="${khNm}"/>
                    </div>
                    <label class="control-label col-xs-3">配送地址</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="address" value="${address}"/>
                    </div>
                    <label class="control-label col-xs-3">联系电话</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="tel" value="${tel}"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">出货仓库</label>
                    <div class="col-xs-4">
                        <select id="stkId" uglcw-validate="required" id="providers" uglcw-role="combobox"
                                uglcw-options="
                                            url: '${base}manager/queryBaseStorage',
                                            dataTextField: 'stkName',
                                            dataValueField: 'id',
                                            index: 0,
                                            value: '${proId}'
                                        "
                                uglcw-model="stkId,stkName"></select>
                    </div>
                    <label class="control-label col-xs-3">业务员</label>
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-model="empId" uglcw-role="textbox" id="empId" value="${empId}"/>
                        <input uglcw-role="gridselector" uglcw-model="staff" value="${staff}"
                               placeholder="请选择业务员"
                               uglcw-validate="required"
                        />
                    </div>
                    <label class="control-label col-xs-3">联系电话</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="stafftel" value="${stafftel}"/>
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
                    <label class="control-label col-xs-3">车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辆</label>
                    <div class="col-xs-4">
                        <tag:select2 name="vehId" id="vehId" tclass="pcl_sel" value="${vehId }" headerKey=""
                                     headerValue="" tableName="stk_vehicle" displayKey="id" displayValue="veh_no"/>
                    </div>
                    <label class="control-label col-xs-3">司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机</label>
                    <div class="col-xs-4">
                        <tag:select2 name="driverId" id="driverId" tclass="pcl_sel" value="${driverId }" headerKey=""
                                     headerValue="" tableName="stk_driver" displayKey="id" displayValue="driver_name"/>
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
            <div id="grid" uglcw-role="grid"
                 uglcw-options='
                          lockable: false,
                          responsive:[".master",22],
                          id: "id",
                          minHeight: 250,
                          rowNumber: true,
                          add: function(row){
                            return uglcw.extend({
                                xsTp: "正常销售",
                                qty:1,
                                amt: 0
                            }, row);
                          },
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource: gridDataSource
                        '
            >
                <div data-field="wareCode" uglcw-options="
                            width: 100,
                            filterable:{ multi: true, search: true},
                            footerTemplate: '合计：',
                            template: uglcw.util.template($('#product-code-tpl').html()),
                        ">产品编号
                </div>
                <div data-field="wareNm" uglcw-options="width: 180,
                            tooltip: true,
                            filterable:{ multi: true, search: true},
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
                                    highlightFirst: true,
                                    selectable: true,
                                    click: function(){
                                        showProductSelectorForRow(model, rowIndex, cellIndex);
                                    },
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
                                        uglcw.ui.get('#grid').commit();
                                        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
                                    }
                                });
                           }">产品名称
                </div>

                <div data-field="wareGg" uglcw-options="width: 100, editable: false">产品规格</div>
                <div data-field="xsTp" uglcw-options="width: 100, editor: function(container, options){
                        var model = options.model;
                        var input = $('<input name=\'xsTp\' data-bind=\'value:xsTp\'>');
                        input.appendTo(container);
                        var widget = new uglcw.ui.ComboBox(input);
                        widget.init({
                            dataSource: [
                            {text:'正常销售',value: '正常销售'},
                            {text: '促销折让', value: '促销折让'},
                            {text: '消费折让', value: '消费折让'},
                            {text:'费用折让', value: '费用折让'},
                            {text:'其他销售', value: '其他销售'}]
                        });

                }">
                    销售类型
                </div>
                <div data-field="beUnit" uglcw-options="width: 80,
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
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.lookqty')}">
                    <div data-field="qty" uglcw-options="width: 100,
                                aggregates: ['sum'],
                                schema:{ type: 'number'},
                                footerTemplate: '#= (sum||0) #'
                        ">销售数量
                    </div>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.lookprice')}">
                    <div data-field="price"
                         uglcw-options="width: 100, format:'{0:n2}',
                     schema:{
                        type:'number'
                     }">
                        单价
                    </div>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.lookamt')}">
                    <div data-field="amt" uglcw-options="width: 120,
                            format:'{0:n2}',
                            aggregates: ['sum'],
                            editable: false,
                            footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#'">销售金额
                    </div>
                </c:if>
                <c:if test="${fns:checkFieldBool('sys_config','*','code=\"CONFIG_IN_FANLI_PRICE\" and status =1')}">
                    <div data-field="rebatePrice"
                         uglcw-options="width: 150, schema:{type: 'number'}">
                        返利单价
                    </div>
                </c:if>
                <div data-field="productDate" uglcw-options="width: 130,
                             template: uglcw.util.template($('#product-date-tpl').html()),
                            ">生产日期
                </div>
                <div data-field="qualityDays" uglcw-options="width: 80">有效期</div>
                <div data-field="edtRemarks" uglcw-options="width: 80">备注</div>
                <div data-field="sunitQty" uglcw-options="width: 80, hidden: true">小单位数量</div>
                <div data-field="sunitJiage" uglcw-options="width: 80, hidden: true">小单位价格</div>
                <c:if test="${fns:checkFieldBool('sys_config','*','code=\"CONFIG_SALE_SHOW_HELP_UNIT\"  and status=1')}}">
                    <div data-field="helpQty" uglcw-options="width: 80, hidden: true">辅助销售数量</div>
                    <div data-field="helpUnit" uglcw-options="width: 80, hidden: true">辅助销售单位</div>
                </c:if>
            </div>
        </div>
    </div>
</div>
<!--模板-->
<%@include file="/WEB-INF/view/v2/include/biz/salesorder/templates.jsp" %>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var gridDataSource = ${fns:toJson(warelist)};
    $(function () {
        uglcw.ui.init();
        //监听页面垂直滚动并处理顶部按钮组置顶
        var scrollTimer;
        $(window).on('scroll', function () {
            clearTimeout(scrollTimer);
            scrollTimer = setTimeout(actionBarScrolling, 100);
        });
        actionBarScrolling();
        if (uglcw.ui.get('#orderId').value() && !uglcw.ui.get('#billId').value()) {
            queryOrderDetail();
        }
        uglcw.ui.loaded();
    })

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

</script>
</body>
</html>
