<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>付货款管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li style="width: 70px;">
                    <input uglcw-role="numeric" data-min="0" uglcw-model="beginAmt" placeholder="返利金额">
                </li>
                <li style="width: 70px;">
                    <input uglcw-role="numeric" uglcw-model="endAmt" placeholder="返利金额">
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
                       q.proName=row.proName
                       uglcw.ui.openTab('待收款返利单据', '${base}manager/stkRebateIn/toRebateInList?'+ $.map(q, function(v, k){
                       	return k+'='+v;
                       }).join('&'));
                    },
                    url: '${base}manager/stkRebateIn/queryRebateInStatPage',
                    aggregate:[
                     {field: 'totalAmt', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'disAmt1', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'},
                     {field: 'payAmt', aggregate: 'SUM'}
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
                        	payAmt: 0,
                        	freeAmt: 0,
                        	totalAmt: 0,
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
                <div data-field="proName" uglcw-options="width:180,tooltip: true, footerTemplate: '合计'">往来单位</div>
                <div data-field="disAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.disAmt || 0#'">返利金额
                </div>
                <div data-field="payAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.payAmt || 0#'">已返金额
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.freeAmt||0#'">核销金额
                </div>
                <div data-field="totalAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.totalAmt||0#'">剩余应收返利
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showPayList();">
        <span class="k-icon k-i-search"></span>收款纪录
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toUnitRecPage();">
        <span class="k-icon k-i-search"></span>待收款返利单据
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toUnitAuditPage();">
        <span class="k-icon k-i-search"></span>待审返利单据
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
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })

    function toAutoRec(cstId, cstName, amt) {
        uglcw.ui.Modal.open({
            content: $('#rec-dialog').html(),
            title: '收款',
            success: function (container) {
                uglcw.ui.init(container);
                uglcw.ui.bind($(container).find('form'), {cstId: cstId, cstName: cstName, amt: amt, cash: amt});
            },
            yes: function (container) {
                var form = $(container).find('form');
                var validate = uglcw.ui.get(form).validate();
                if (validate) {
                    var data = uglcw.ui.bind(form);
                    if (parseFloat(data.cash) > parseFloat(data.amt)) {
                        uglcw.ui.info('本次收款不能大于' + data.amt);
                        return false;
                    }
                    uglcw.ui.confirm('确认收款吗？', function () {
                        $.ajax({
                            url: '${base}manager/autoRecBill',
                            data: data,
                            success: function (response) {
                                if (response.state) {
                                    uglcw.ui.success(response.msg);
                                    uglcw.ui.get('#grid').reload();
                                    uglcw.ui.Modal.close();
                                } else {
                                    uglcw.ui.error(response.msg);
                                }
                            }
                        })
                    })
                }
                return false;
            }
        })
    }

    function showPayList() {
        uglcw.ui.openTab('收款记录', '${base}manager/queryRecPageByBillId?dataTp=1&outType=2')
    }

    function toUnitRecPage() {
        var query = uglcw.ui.bind('.query');
        uglcw.ui.openTab('待收款返利单据', '${base}manager/stkRebateIn/toRebateInList?' + $.map(query, function (v, k) {
            return k + '=' + v;
        }).join('&'));
    }

    function toUnitAuditPage() {
        var query = uglcw.ui.bind('.query');
        query.status=-2;
        query.payStatus=-1;
        uglcw.ui.openTab('待审返利单据', '${base}manager/stkRebateIn/toRebateInList?' + $.map(query, function (v, k) {
            return k + '=' + v;
        }).join('&'));
    }

    function showRecStat() {
        uglcw.ui.openTab('收货款统计', '${base}manager/toRecStat?dataTp=1')
    }

    function showYshkStat() {
        uglcw.ui.openTab('预收货款信息', '${base}manager/toYshkPage?dataTp=1');
    }

</script>
</body>
</html>
