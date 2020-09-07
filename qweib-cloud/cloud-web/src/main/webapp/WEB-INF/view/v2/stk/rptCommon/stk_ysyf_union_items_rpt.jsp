<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>应收应付统计</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <div class="form-horizontal query">
                <div class="form-group" style="margin-bottom: 0px;">
                    <div class="col-xs-8">
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
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                        <input uglcw-model="proName" value="${proName}" uglcw-role="textbox" placeholder="往来单位">
                    </div>
                    <div class="col-xs-4">
                        <input uglcw-model="billNo" uglcw-role="textbox" placeholder="发票单号">
                    </div>
                    <div class="col-xs-4">
                        <input id="sdate" uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                    </div>
                    <div class="col-xs-4">
                        <input id="edate" uglcw-model="edate" uglcw-role="datepicker" placeholder="结束时间" value="${edate}">
                    </div>
                    <div class="col-xs-4">
                        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                         autoBind: false,
                    id:'id',
                    dblclick: function(row){
                         <%--var q = uglcw.ui.bind('.query');--%>
                         <%--var query = {--%>
                            <%--sdate: q.sdate,--%>
                            <%--edate: q.edate--%>
                         <%--};--%>
                         <%--query.proName=row.pro_name--%>
                         <%--uglcw.ui.openTab('应收应付账款明细', '${base}manager/toQueryYsYfUnionItemsPage?' + $.map(query, function (v, k) {--%>
                            <%--return k + '=' + (v || '');--%>
                        <%--}).join('&'));--%>

                        showItems(row.bill_type,row.bill_id);
                    },
                    checkbox: true,
                    url: '${base}manager/queryYsYfUnionItemsPage',
                    aggregate:[
                     {field: 'sum_amt', aggregate: 'SUM'}
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
                        sum_amt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     },
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="bill_no" uglcw-options="width:160, footerTemplate: '合计'">单号</div>
                <div data-field="bill_type" uglcw-options="width:100">类型</div>
                <div data-field="pro_name" uglcw-options="width:180,tooltip: true">往来单位</div>
                <div data-field="dis_amt"
                     uglcw-options="width:'auto', format: '{0:n2}'">单据金额
                </div>
                <div data-field="dis_amt1"
                     uglcw-options="width:'auto', format: '{0:n2}'">
                    发货金额
                </div>
                <div data-field="occ_amt"
                     uglcw-options="width:'auto', format: '{0:n2}'">已收金额
                </div>
                <div data-field="free_amt"
                     uglcw-options="width:'auto', format: '{0:n2}'">核销金额
                </div>
                <div data-field="sum_amt"
                     uglcw-options="width:'auto', format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.sum_amt, \'n2\')#'">
                    欠款金额
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

        resize();
        $(window).resize(resize)
        uglcw.ui.loaded()
    })

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 55;
            var height = $(window).height() - padding - $('.header').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

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


    function showItems(billType,billId){

        if(billType=='采购入库'||billType=='销售退货'||billType=='其它入库'||billType=='采购退货'){
            uglcw.ui.openTab(billType+""+billId, '${base}manager/showstkin?billId='+billId);
        }
        if(billType=='销售出库'||billType=='借出出库'||billType=='报损出库'||billType=='其它出库'){
            uglcw.ui.openTab(billType+""+billId, "${base}manager/showstkout?billId=" + billId)
        }
        if(billType=='应付供应商初始化'){

        }
        if(billType=='应收客户初始化'){

        }

    }


</script>
</body>
</html>
