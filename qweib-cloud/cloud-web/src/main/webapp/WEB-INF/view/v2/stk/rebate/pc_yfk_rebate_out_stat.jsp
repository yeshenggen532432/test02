<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>变动费用待收款管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <select uglcw-role="combobox" uglcw-model="customerType"
                            placeholder="客户类型"
                            uglcw-options="
										url: '${base}manager/queryarealist1',
										index: -1,
										loadFilter:{
											data: function(response){
												return response.list1 || []
											}
										},
										dataTextField: 'qdtpNm',
										dataValueField: 'qdtpNm'
									"></select>
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li style="width: 70px;">
                    <input uglcw-role="numeric" data-min="0" uglcw-model="beginAmt" placeholder="金额范围">
                </li>
                <li style="width: 70px;">
                    <input uglcw-role="numeric" uglcw-model="endAmt" placeholder="金额范围">
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
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    dblclick: function(row){
                       var q = uglcw.ui.bind('.query');
                       q.khNm=row.khNm
                       q.epCustomerName=row.epCustomerName
                       uglcw.ui.openTab('待付款返利单据', '${base}manager/stkRebateOut/toRebateOutPayList?'+ $.map(q, function(v, k){
                      return k + '=' + (v || '');
                       }).join('&'));
                    },
                    url: '${base}manager/stkRebateOut/queryRebateOutStatPage',
                    aggregate:[
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'recAmt', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'},
                     {field: 'totalAmt', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	disAmt: 0,
                        	recAmt: 0,
                        	freeAmt: 0,
                        	totalAmt: 0,
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate =uglcw.extend(aggregate, response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     },
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="khNm" uglcw-options="width:180,tooltip: true, footerTemplate: '合计'">往来单位</div>
                <div data-field="disAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.disAmt || 0#'">费用金额
                </div>
                <div data-field="recAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.recAmt || 0#'">已付金额
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.freeAmt || 0#'">核销金额
                </div>
                <div data-field="totalAmt"
                     uglcw-options="width:140, format: '{0:n2}', footerTemplate: '#= data.totalAmt || 0#'">剩余应付
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();" class="primary k-button k-button-icontext" style="color: \\#FFF;background: \\#38F;">
        <span class="k-icon k-i-plus-outline"></span>费用开单
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showPayList();">
        <span class="k-icon k-i-search"></span>付款记录
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toUnitRecPage();">
        <span class="k-icon k-i-search"></span>待付款变动费用单据
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toUnitAuditPage();">
        <span class="k-icon k-i-search"></span>待审变动费用单据
    </a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })

        uglcw.ui.loaded()
    })

    function add() {
        uglcw.ui.openTab('变动费用开单', '${base}manager/stkRebateOut/add?r=' + new Date().getTime());
    }

    function showPayList() {
        uglcw.ui.openTab('付款记录', '${base}manager/queryPayPageByBillId?dataTp=1&inType=2')
    }

    function toUnitRecPage() {
        var query = uglcw.ui.bind('.query');
        query.status=1;
        query.payStatus='0';
        query.tabType='0';
        uglcw.ui.openTab('待付款变动费用单据', '${base}manager/stkRebateOut/toRebateOutPayList?' + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function toUnitAuditPage() {
        var query = uglcw.ui.bind('.query');
        query.status=-2;
        query.payStatus=-1;
        query.tabType=1;
        uglcw.ui.openTab('待审变动费用单据', '${base}manager/stkRebateOut/toRebateOutPayList?' + $.map(query, function (v, k) {
            return k + '=' + v;
        }).join('&'));
    }

</script>
</body>
</html>
