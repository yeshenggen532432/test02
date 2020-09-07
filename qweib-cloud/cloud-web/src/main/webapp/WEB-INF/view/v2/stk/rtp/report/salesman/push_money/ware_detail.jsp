<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>业务员提成计算表</title>
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
                    <select uglcw-model="timeType" uglcw-options="placeholder: '时间类型', value:'${timeType}'" id="timeType" uglcw-role="combobox">
                        <option value="1" selected>发货单</option>
                        <option value="2">销售单</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="beginDate" uglcw-role="datepicker" value="${beginDate}">
                </li>
                <li>
                    <input uglcw-model="endDate" uglcw-role="datepicker" value="${endDate}">
                </li>
                <li>
                    <select uglcw-model="billType" uglcw-options="placeholder: '销售类型', value: '${billType}'" id="xsTp" uglcw-role="combobox">
                        <option value="正常销售" selected>正常销售</option>
                        <option value="促销折让">促销折让</option>
                        <option value="消费折让">消费折让</option>
                        <option value="费用折让">费用折让</option>
                        <option value="其他销售">其他销售</option>
                        <option value="其它出库">其它出库</option>
                        <option value="借用出库">借用出库</option>
                        <option value="领用出库">领用出库</option>
                        <option value="报损出库">报损出库</option>
                        <option value="销售退货">销售退货</option>
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" type="hidden" uglcw-model="salesmanId" value="${salesmanId}"/>
                    <input uglcw-role="textbox" uglcw-model="salesmanName" value="${salesmanName}" readonly/>
                </li>
                <li>
                    <input uglcw-role="textbox" type="hidden" uglcw-model="customerId" value="${customerId}"/>
                    <input uglcw-role="textbox" uglcw-model="customerName" value="${customerName}" readonly/>
                </li>
                <li>
                    <input uglcw-role="textbox" type="hidden" uglcw-model="wareId" value="${wareId}"/>
                    <input uglcw-role="textbox" uglcw-model="wareName" value="${wareName}" readonly/>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li style="width: 200px;">
                    <select class="biz-type" id="type" uglcw-model="type" uglcw-role="combobox"
                            uglcw-options="placeholder:'提成类型类型', value: '${configType}'">
                        <c:forEach var="data" items="${pushMoneyTypeList}">
                        <option value="${data.value}">${data.name}</option>
                        </c:forEach>
                    </select>
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
                    url: '${base}manager/report/salesman/push_money/ware',
                    contentType: 'application/json',
                    parameterMap: function(o){
                        return JSON.stringify(o);
                    },
                    serverAggregates: false,
                    aggregate:[
                        {field: 'quantity', aggregate: 'sum'},
                        {field: 'amount', aggregate: 'sum'},
                        {field: 'pushMoney', aggregate: 'sum'},
                    ],
                    loadFilter: {
                      data: function (response) {
                        if(response.code != 200) {
                            uglcw.ui.error(response.message);
                            return [];
                        } else {
                            return response.data;
                        }
                      }
                     }
                    ">
                <div data-field="billNo">单据号</div>
                <div data-field="salesmanName">业务员</div>
                <div data-field="customerName">销售客户</div>
                <div data-field="wareName">品项</div>
                <div data-field="billType">销售类型</div>
                <div data-field="unitName">单位</div>
                <div data-field="quantity"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(sum || 0, \'n2\')#'">
                    数量
                </div>
                <div data-field="amount"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(sum || 0, \'n2\')#'">
                    金额
                </div>
                <div data-field="pushMoney"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(sum || 0, \'n2\')#'">
                    提成金额
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
            uglcw.ui.clear('.form-horizontal', {sdate: '${beginDate}', edate: '${endDate}'});
        })

        uglcw.ui.loaded()
    })
</script>
</body>
</html>
