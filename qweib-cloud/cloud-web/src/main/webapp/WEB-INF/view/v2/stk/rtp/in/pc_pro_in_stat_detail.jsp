<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>业务员提成详情</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        ::-webkit-input-placeholder {
            color: black;
        }

        .biz-type.k-combobox {
            font-weight: bold;

        }

        .biz-type .k-input {
            color: black;
            background-color: rgba(0, 123, 255, .35);
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input uglcw-model="beginDate" id="beginDate" uglcw-role="datepicker" value="${query.beginDate}">
                </li>
                <li>
                    <input uglcw-model="endDate" id="endDate" uglcw-role="datepicker" value="${query.endDate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="inType" id="inType" uglcw-options="value:'${query.inType}'" placeholder="单据类型">
                        <option value="">--单据类型--</option>
                        <option value="采购入库">采购入库</option>
                        <option value="其它入库">其它入库</option>
                        <option value="采购退货">采购退货</option>
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" type="hidden" uglcw-model="proId" id="proId" value="${query.proId}"/>
                    <input uglcw-role="textbox" type="hidden" uglcw-model="proType" id="proType" value="${query.proType}"/>
                    <input uglcw-role="textbox" uglcw-model="proName" id="proName" value="${proName}" readonly/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="wareName" id="wareName" value="${query.wareName}" placeholder="商品名称"/>
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
                 uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    type: 'post',
                    criteria: '.uglcw-query',
                    url: '${base}manager/in_page_stat/detail',
                    contentType: 'application/json',
                    parameterMap: function(o){
                        return JSON.stringify(o);
                    },
                    pageable: true,
                    serverAggregates: true,
                    aggregate:[
                        {field: 'qty', aggregate: 'sum'},
                        {field: 'disAmt', aggregate: 'sum'},
                        {field: 'inQty', aggregate: 'sum'},
                        {field: 'disAmt1', aggregate: 'sum'},
                        {field: 'payAmt', aggregate: 'sum'},
                        {field: 'freeAmt', aggregate: 'sum'},
                        {field: 'unPayAmt', aggregate: 'sum'}
                    ],
                    dblclick: function(row) {
                        if (row.inType == '采购入库') {
                            uglcw.ui.openTab('采购开票信息' + row.id,'${base}manager/showstkin?dataTp=1&billId='+row.id);
                        } else if (row.inType == '采购退货') {
                            uglcw.ui.openTab('采购退货信息' + row.id,'${base}manager/showstkin?dataTp=1&billId='+row.id);
                        } else {
                            uglcw.ui.openTab('其它入库单信息' + row.id,'${base}manager/showstkin?dataTp=1&billId='+row.id);
                        }
                    },
                    loadFilter: {
                      data: function (response) {
                        if(response.code == 200) {
                            var page = response.data.page;
                            return page.rows || [];
                        } else {
                            uglcw.ui.error(response.message);
                            return [];
                        }
                      },
                      total: function(response){
                        return response.code == 200 ? response.data.page.total : 0;
                      },
                      aggregates: function(response){
                        var aggregate = {
                            qty: 0,
                            disAmt: 0,
                            inQty:0,
                            disAmt1: 0,
                            payAmt: 0,
                            freeAmt: 0,
                            unPayAmt: 0
                        };
                        if (response.code == 200) {
                            aggregate = uglcw.extend(aggregate, response.data.stat);
                        }
                        return aggregate;
                      }
                     }
                    ">
                <div data-field="proName">往来单位</div>
                <div data-field="inType">单据类型</div>
                <div data-field="billNo">单号</div>
                <div data-field="inType">单据时间</div>
                <div data-field="qty"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.qty || 0, \'n2\')#'">
                    单据数量
                </div>
                <div data-field="disAmt"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.disAmt || 0, \'n2\')#'">
                    单据金额
                </div>
                <div data-field="inQty"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.inQty || 0, \'n2\')#'">
                    收货数量
                </div>
                <div data-field="disAmt1"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.disAmt1 || 0, \'n2\')#'">
                    收货金额
                </div>
                <div data-field="payAmt"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.payAmt || 0, \'n2\')#'">
                    已付款
                </div>
                <div data-field="freeAmt"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.freeAmt || 0, \'n2\')#'">
                    核销金额
                </div>
                <div data-field="unPayAmt"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.unPayAmt || 0, \'n2\')#'">
                    未付金额
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {beginDate: '${query.beginDate}',endDate: '${query.endDate}', inType: '${query.inType}', proId: '${query.proId}', proType: '${query.proType}', proName: '${proName}', wareName: '${query.wareName}'});
        })

        uglcw.ui.loaded()
    })
</script>
</body>
</html>
