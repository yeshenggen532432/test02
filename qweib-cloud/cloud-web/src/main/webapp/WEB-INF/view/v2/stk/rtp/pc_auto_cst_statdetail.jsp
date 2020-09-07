<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售客户毛利统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <select uglcw-role="combobox" uglcw-model="timeType"
                            uglcw-options="placeholder:'时间类型'">
                        <option value="2">销售时间</option>
                        <option value="1">发货时间</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-model="outType" id="xsTp" uglcw-role="combobox">
                        <option value="">--销售类型--</option>
                        <option value="正常销售">正常销售</option>
                        <option value="促销折让">促销折让</option>
                        <option value="消费折让">消费折让</option>
                        <option value="费用折让">费用折让</option>
                        <option value="其他销售">其他销售</option>
                        <option value="其它出库">其它出库</option>
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="khNm" placeholder="客户名称"/>
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
                    <select uglcw-role="dropdowntree" uglcw-options="
											placeholder:'客户所属区域',
											url: '${base}manager/sysRegions',
											dataTextField: 'text',
											dataValueField: 'id'
										" uglcw-model="regionId"></select>
                </li>
                <li>

                    <input uglcw-role="textbox" uglcw-model="epCustomerName" placeholder="所属二批"/>
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
                    url: '${base}manager/queryCstStatPage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    aggregate:[
                     {field: 'sumQty', aggregate: 'SUM'},
                     {field: 'sumAmt', aggregate: 'SUM'},
                     {field: 'avgPrice', aggregate: 'SUM'},
                     {field: 'discount', aggregate: 'SUM'},
                     {field: 'inputAmt', aggregate: 'SUM'},
                     {field: 'sumCost', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'avgAmt', aggregate: 'SUM'},
                     {field: 'rate', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        if(!response || !response.rows || response.rows.length <1){
                            return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            sumQty:0,
                            sumAmt:0,
                            avgPrice:0,
                            discount:0,
                            inputAmt:0,
                            sumCost:0,
                            disAmt:0,
                            avgAmt:0,
                            rate:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="stkUnit" uglcw-options="width: 150">客户名称</div>
                <div data-field="wareNm" uglcw-options="width: 150">商品名称</div>
                <div data-field="sumQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.sumQty || 0, \'n2\')#'">
                    销售数量
                </div>
                <div data-field="sumAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate:'#= uglcw.util.toString(data.sumAmt || 0, \'n2\')#'">
                    销售收入
                </div>
                <div data-field="avgPrice"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.avgPrice || 0, \'n2\')#'">
                    平均单位售价
                </div>
                <div data-field="sumCost"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.sumCost || 0, \'n2\')#'">
                    销售成本
                </div>
                <div data-field="disAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.disAmt || 0, \'n2\')#'">
                    销售毛利
                </div>
                <div data-field="avgAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.avgAmt || 0, \'n2\')#'">
                    平均单位毛利
                </div>
                <div data-field="epCustomerName" uglcw-options="width:120">所属二批</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:editRptData();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>编辑
    </a>
    <a role="button" href="javascript:createRptData();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>生成报表
    </a>
    <a role="button" href="javascript:queryRpt();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>查询生成的报表
    </a>
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


    function editRptData() {
        var q = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('编辑客户毛利明细统计表', '${base}manager/queryAutoCstStatDetailListToSave?' + $.map(q, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function createRptData() {
        var q = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('客户毛利费用统计表生成', '${base}manager/createAutoCstStatListRpt?' + $.map(q, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function queryRpt() {
        uglcw.ui.openTab('生成的统计表', '${base}manager/toStkCstStatQuery?rptType=3');
    }

</script>
</body>
</html>
