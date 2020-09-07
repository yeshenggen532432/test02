<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>各门店报表-订单查询</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query" id="export">
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="database" id="database" value="${database}">
                    <select uglcw-role="combobox" uglcw-model="shopNo" uglcw-options="
                                                value:'${shopNo}',
                                                url: '${base}manager/pos/queryPosShopInfoPage',
                                                placeholder: '门店',
                                                dataTextField: 'shopName',
                                                dataValueField: 'shopNo',
                                                loadFilter:{
                                                    data: function(response){
                                                        return response.rows || [];
                                                    }
                                                }
                                             ">
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="docNo" placeholder="单号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="cardNo" placeholder="卡号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="operator" placeholder="收银员">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${param.sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" id="edate" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="billStatus">
                        <option value="全部">单据类型-全部</option>
                        <option value="销售单">销售单</option>
                        <option value="退货单">退货单</option>
                        <option value="撤单">撤单</option>
                    </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                         loadFilter: {
                         data: function (response) {
                         response.rows.splice( response.rows.length - 1, 1);
                         return response.rows || []
                         },
                         aggregates: function (response) {
                          var aggregate = {totalAmt: 0, freeAmt:0, needPay:0,cashPay:0,cardPay:0,wxPay:0};
                         if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                         }
                         return aggregate;
                        }
                        },
                        responsive:['.header',40],
                        toolbar: kendo.template($('#toolbar').html()),
                        id:'id',
                        url: 'manager/pos/queryPosSalePage',
                        criteria: '.form-horizontal',
                        pageable: true,
                        query: function(param){
                            param.edate+=' 23:59:00';
                            return param;
                        },
                    aggregate:[
                     {field: 'totalAmt', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'},
                     {field: 'needPay', aggregate: 'SUM'},
                     {field: 'cashPay', aggregate: 'SUM'},
                     {field: 'cardPay', aggregate: 'SUM'},
                     {field: 'wxPay', aggregate: 'SUM'}
                    ],
                    }">
                <div data-field="docNo" uglcw-options="width:160,footerTemplate: '销售合计'">单号</div>
                <div data-field="billDate" uglcw-options="width:160">时间</div>
                <div data-field="totalAmt"
                     uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.totalAmt,\'n2\')#'">
                    总金额
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:100,template: '#= data.freeAmt ? uglcw.util.toString(data.freeAmt,\'n2\'): \' \'#',
                                            footerTemplate: '#= uglcw.util.toString(data.freeAmt,\'n2\')#'">优惠金额
                </div>
                <div data-field="needPay"
                     uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.needPay,\'n2\')#'">
                    折后金额
                </div>
                <div data-field="cashPay"
                     uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.cashPay,\'n2\')#'">
                    现金支付
                </div>
                <div data-field="cardPay"
                     uglcw-options="width:100,template: '#= data.cardPay ? uglcw.util.toString(data.cardPay, \'n2\'): \' \'#',
                                            footerTemplate: '#= uglcw.util.toString(data.cardPay,\'n2\')#'">
                    会员卡支付
                </div>
                <div data-field="wxPay"
                     uglcw-options="width:100,template: '#= data.wxPay ? uglcw.util.toString(data.wxPay, \'n2\'): \' \'#',
                                            footerTemplate: '#= uglcw.util.toString(data.wxPay,\'n2\')#'">
                    微信支付
                </div>
                <div data-field="zfbPay"
                     uglcw-options="width:100,template: '#= data.zfbPay ? uglcw.util.toString(data.zfbPay,\'n2\'): \' \'#'">
                    支付宝
                </div>
                <div data-field="status"
                     uglcw-options="width:100,template: uglcw.util.template($('#formatterStatus').html())">状态
                </div>
                <div data-field="cstName" uglcw-options="width:100">客户姓名</div>
                <div data-field="tel" uglcw-options="width:100">电话</div>
                <div data-field="docType"
                     uglcw-options="width:100,template: uglcw.util.template($('#formatterDocType').html())">类型
                </div>
                <div data-field="_operator"
                     uglcw-options="width:100,template: uglcw.util.template($('#formatterSt3').html())">操作
                </div>

            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-download"></span>导出
    </a>

</script>
<script type="text/x-kendo-template" id="formatterStatus">
    #if (data.status == -1){#
    作废
    #}#
    #if (data.status == 0){#
    未结
    #}#
    #if (data.status == 1){#
    已结
    #}#
</script>
<script type="text/x-kendo-template" id="formatterDocType">
    #if (data.docType == 0){#
    销售单
    #}#
    #if (data.docType == 1){#
    退货单
    #}#

</script>
<script type="text/x-kendo-template" id="formatterSt3">
    #if (data.id == 0){#
    ""
    #}#
    <button class="k-button k-info" onclick="todetail(#= data.id#)">查看明细</button>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<tag:exporter service="posSaleService" method="querySalePage"
              bean="com.qweib.cloud.biz.pos.model.PosSale"
              condition=".query" description="单据查询"
              beforeExport="beforeExport"
/>
<script>
    function beforeExport(param) {//构造参数
        param.edate = param.edate + '23:59:00';
        return param;

    }
</script>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


    function todetail(id) {//查看明细
        uglcw.ui.openTab('单据明细' + id, '${base}manager/pos/toPosShopBillDetail?mastId=' + id);
    }
</script>
</body>
</html>
