<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>应收应付统计</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-query > li{
            width: 130px;
        }
        .uglcw-query .uglcw-radio .k-radio-label{
            padding-left: 18px;
        }
        .uglcw-query .uglcw-radio{
            margin-top: 5px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body" style="padding-right: 2px;">
            <ul class="uglcw-query form-horizontal query">
                <li style="width: 380px !important;">
                    <ul id="proType" uglcw-role="radio" uglcw-model="proType" uglcw-options="
									layout: 'horizontal',
									value: '-1',
									dataSource:[
									{text:'全部', value:'-1'},
									{text:'供应商', value:'0'},
									{text:'客户', value:'2'},
									{text:'员工', value:'1'},
									{text:'其它往来', value:'3'},
									{text:'会员', value:'4'},
									]
								"></ul>
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input id="sdate" uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input id="edate" uglcw-model="edate" uglcw-role="datepicker" placeholder="结束时间" value="${edate}">
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
                    dblclick: function(row){
                         var q = uglcw.ui.bind('.query');
                         var query = {
                            sdate: q.sdate,
                            edate: q.edate
                         };
                         query.proName=row.pro_name
                         uglcw.ui.openTab('应收应付账款明细', '${base}manager/toQueryYsYfUnionItemsPage?' + $.map(query, function (v, k) {
                            return k + '=' + (v || '');
                        }).join('&'));
                    },
                    url: '${base}manager/queryYsYfUnionPage',
                    aggregate:[
                     {field: '_bq_rec_amt', aggregate: 'SUM'},
                     {field: '_bq_pay_amt', aggregate: 'SUM'},
                     {field: 'sale_rec_amt', aggregate: 'SUM'},
                     {field: 'init_rec_amt', aggregate: 'SUM'},
                     {field: 'cg_pay_amt', aggregate: 'SUM'},
                     {field: 'init_pay_amt', aggregate: 'SUM'},
                     {field: 'qm_amt', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        $(response.rows).each(function(idx, row){
                        	row._bq_rec_amt = row.sale_rec_amt+row.init_rec_amt;
                        	row._bq_pay_amt = row.cg_pay_amt+row.init_pay_amt;
                        })
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                            aggregate._bq_rec_amt = aggregate.sale_rec_amt+aggregate.init_rec_amt;
                        	aggregate._bq_pay_amt = aggregate.cg_pay_amt+aggregate.init_pay_amt;
                        }
                        return aggregate;
                      }
                     },
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="pro_name" uglcw-options="width:180,tooltip: true, footerTemplate: '合计'">往来单位</div>
                <div data-field="qc_amt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.qc_amt#'">期初余额
                </div>
                <div data-field="_bq_rec_amt"
                     uglcw-options="width:120, format: '{0:n2}', template: uglcw.util.template($('#amtformatterBqYsAmt').html()),  footerTemplate: '#= data._bq_rec_amt#'">
                    本期应收
                </div>
                <div data-field="sale_rec_amt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.sale_rec_amt#'">销售应收
                </div>
                <div data-field="init_rec_amt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.init_rec_amt#'">初始化应收
                </div>
                <div data-field="_bq_pay_amt"
                     uglcw-options="width:120, format: '{0:n2}', template: uglcw.util.template($('#amtformatterBqYfAmt').html()), footerTemplate: '#= data._bq_pay_amt#'">
                    本期应付
                </div>
                <div data-field="cg_pay_amt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.cg_pay_amt#'">采购应付
                </div>
                <div data-field="init_pay_amt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.init_pay_amt#'">初始化应付
                </div>
                <div data-field="qm_amt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.qm_amt#'">期末余额
                </div>
            </div>
        </div>
    </div>
</div>
<script id="amtformatterBqYsAmt" type="text/x-uglcw-template">
    <a style="font-weight: bold; color: blue; text-decoration: none;"
       href="javascript:showBqYs(#= data.pro_id#, '#= data.pro_name#');">#= data._bq_rec_amt#</a>
</script>
<script id="amtformatterBqYfAmt" type="text/x-uglcw-template">
    <a style="font-weight: bold; color: blue; text-decoration: none;"
       href="javascript:showBqYf(#= data.pro_id#, '#= data.pro_name#');">#= data._bq_pay_amt#</a>
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

        uglcw.ui.get('#proType').on('change', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded()
    })


    /**
     * 查看应收单据
     * @param proId
     * @param proName
     */
    function showBqYs(proId, proName) {
        var sdate = uglcw.ui.get("#sdate").value();
        var edate = uglcw.ui.get("#edate").value();
        uglcw.ui.openTab('待收款单据', '${base}manager/toUnitRecPage?sdate=' + sdate + '&edate=' + edate + '&unitName=' + proName);
    }

    /**
     * 查看应付单据
     * @param proId
     * @param proName
     */
    function showBqYf(proId, proName) {
        var sdate = uglcw.ui.get("#sdate").value();
        var edate = uglcw.ui.get("#edate").value();
        uglcw.ui.openTab('待付款单据', '${base}manager/toUnitPayPage?dataTp=1&sdate=' + sdate + '&edate=' + edate + '&proName=' + proName);

    }


</script>
</body>
</html>
