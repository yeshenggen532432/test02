<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>所属二批转单返利</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        ::-webkit-input-placeholder {
            color:black;
        }
        .biz-type.k-combobox{
            font-weight: bold;

        }
        .biz-type .k-input{
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
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" id="database" uglcw-model="database" uglcw-role="textbox" value="${database}">
                    <select uglcw-model="timeType" uglcw-role="combobox" id="timeType"
                            uglcw-options="placeholder:'时间类型'">
                        <option value="1" selected>发货时间</option>
                        <option value="2">销售时间</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li style="width: 180px!important;" class="xs-tp">
                    <input id="xsTp" uglcw-role="multiselect" uglcw-model="xsTp" uglcw-options="
                    placeholder:'销售类型',
                    tagMode: 'single',
                    tagTemplate: uglcw.util.template($('#xp-type-tag-template').html()),
                    autoClose: false,
                    url: '${base}manager/loadXsTp',
                    data: function(){
                        return {
                            outType: '销售出库'
                        }
                    },
                    loadFilter:{
                        data: function(response){
                            return response.list || []
                        }
                    },
                    dataTextField: 'xsTp',
                    dataValueField: 'xsTp'
                ">

                    <!--<select uglcw-model="xsTp" id="xsTp" uglcw-role="combobox" uglcw-options="placeholder:'销售类型', value:''">
                        <option value="正常销售">正常销售</option>
                        <option value="促销折让">促销折让</option>
                        <option value="消费折让">消费折让</option>
                        <option value="费用折让">费用折让</option>
                        <option value="其他销售">其他销售</option>
                        <option value="其它出库">其它出库</option>
                        <option value="销售退货">销售退货</option>
                    </select>-->
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="customerType" uglcw-options="
                                                url: '${base}manager/queryarealist1',
                                                placeholder: '客户类型',
                                                dataTextField: 'qdtpNm',
                                                dataValueField: 'qdtpNm',
                                                loadFilter:{
                                                    data: function(response){
                                                        return response.list1 || [];
                                                    }
                                                }
                                             ">
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="khNm" placeholder="客户名称"/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="epCustomerName" placeholder="所属二批"/>
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="商品名称" uglcw-model="wareNm">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li>
                    <select class="biz-type" id="saleType" uglcw-model="saleType" uglcw-role="combobox"
                            uglcw-options="placeholder:'业务类型', value: ''">
                        <option value="001" selected>传统业务类</option>
                        <option value="003">线上商城</option>
                    </select>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    autoBind: false,
                    responsive:['.header',40],
                    noRecords: true,
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/queryStkCstTransRebate',
                    criteria: '.form-horizontal',
                    pageable: true,

                    group:{
                    	field: 'epCustomerName',
                    	aggregates:[
                    	     {field: 'epCustomerName', aggregate: 'count'},
							 {field: 'amt', aggregate: 'sum'},
							 {field: 'outQty', aggregate: 'sum'},
							 {field: 'rate', aggregate: 'sum'}
                    	]
                    },
                    aggregate:[
                     {field: 'amt', aggregate: 'sum'},
                    ],
                    loadFilter: {
                      data: function (response) {
                        if(!response.rows || response.rows.length<2){
                            return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        var rows = []
                        $(response.rows).each(function(idx, row){
                            if(row.cstId){
                                rows.push(row);
                            }
                        })
                        return rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="epCustomerName" uglcw-options="width:160,
                        groupHeaderTemplate: '<span style=\'font-size:14px;font-weight:600;\'>所属二批客户名称：#= value#</span>',
                        hidden: true,
                        footerTemplate:'合计'">所属二批客户名称
                </div>
                <div data-field="khNm" uglcw-options="width:120, tooltip: true, footerTemplate:'合计：'">终端客户名称</div>
                <div data-field="wareNm" uglcw-options="width:120, tooltip: true, groupFooterTemplate: '小计：'">商品名称</div>
                <div data-field="outQty"
                     uglcw-options="width:120, format: '{0:n2}',
                             aggregates: ['sum'],
                             groupFooterTemplate: '#= uglcw.util.toString(sum, \'n2\')#'
                             ">
                    发货数量
                </div>
                <div data-field="rate"
                     uglcw-options="width:120, format: '{0:n2}',aggregates: ['sum'],groupFooterTemplate: '#= uglcw.util.toString(sum, \'n2\')#'">
                    单件返利
                </div>
                <div data-field="amt"
                     uglcw-options="width:120, format: '{0:n2}',aggregates: ['sum'], groupFooterTemplate: '#= uglcw.util.toString(sum, \'n2\')#',
                             footerTemplate: '#= uglcw.util.toString(data.amt.sum != undefined ? data.amt.sum : data.amt,\'n2\')#'">
                    返利总额
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<tag:exporter service="incomeStatService" method="sumTransEpCustomerRebate"
              bean="com.qweib.cloud.biz.erp.model.StkOut"
              condition=".query" description="所属二批转单返利"

/>

<script type="text/x-uglcw-template" id="xp-type-tag-template">
    <div style="width: 130px;
            text-overflow: ellipsis;
            white-space: nowrap">
        # for(var idx = 0; idx < values.length; idx++){ #
        #: values[idx]#
        # if(idx < values.length - 1) {# , # } #
        # } #
    </div>
</script>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>导出
    </a>
    <a role="button" href="javascript:createRptData();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>生成报表
    </a>
    <a role="button" href="javascript:queryRpt();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>查询生成的报表
    </a>
</script>
<script id="product-tpl" type="text/x-uglcw-template">
    <table class="product-grid" style="border-bottom:1px \\#3343a4 solid;padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">销售类型</td>
            <td style="width: 80px;">计量单位</td>
            <td style="width: 80px;">价格</td>
        </tr>
        #for (var i=0; i< data.products.length; i++) { #
        <tr>
            <td>#= data.products[i].wareNm #</td>
            <td>#= data.products[i].xsTp #</td>
            <td>#= data.products[i].unitName #</td>
            <td>#= uglcw.util.toString(data.products[i].price,'n2')#</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        $('.q-box-arrow').on('click', function () {
            $(this).find('i').toggleClass('k-i-arrow-chevron-left k-i-arrow-chevron-down');
            $('.q-box-more').toggle();
            $('.q-box-wrapper').closest('.layui-card').toggleClass('box-shadow')
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })


        uglcw.ui.loaded()
    })


    function createRptData() {
        var query = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('生成所属二批转单返利表', "${base}manager/toStkOutTransEpRebateSave?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function queryRpt() {
        uglcw.ui.openTab('生成的统计表', '${base}manager/toStkCstStatQuery?rptType=10');
    }

</script>
</body>
</html>
