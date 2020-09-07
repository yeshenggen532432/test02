<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>发货明细</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body full">
            <div class="query">
                <input type="hidden" uglcw-role="textbox" uglcw-model="billName" value="${billName}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="stkId" value="${stkId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="billId" value="${billId}"/>
            </div>
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                        id:'id',
                        align:'center',
                        dblclick: function(row){
                          showDetail(row.id, row.outType, row.outId);
                        },
                        url: '${base}manager/querySendDetailList',
                        criteria: '.query',
                    ">
                <div data-field="voucherNo" uglcw-options="width:160">发货单号</div>
                <div data-field="billNo" uglcw-options="width:160">单号</div>
                <div data-field="sendTimeStr" uglcw-options="width:120">发货日期</div>
                <div data-field="khNm" uglcw-options="width:140, tooltip:true">往来单位</div>
                <div data-field="vehNo" uglcw-options="width:120">运输车辆</div>
                <div data-field="driverName" uglcw-options="width:120">司机</div>
                <div data-field="count"
                     uglcw-options="width:450, template: uglcw.util.template($('#product-tpl').html()) ">商品信息
                </div>
                <div data-field="billStatus" uglcw-options="width:120">状态</div>
                <div data-field="typeStr" uglcw-options="width:120">类型</div>
                <div data-field="remarks"
                     uglcw-options="width:140,  template: uglcw.util.template($('#op-tpl').html())">操作
                </div>
            </div>
        </div>
    </div>
</div>
<script id="op-tpl" type="text/x-uglcw-template">
    <c:if test="${permission:checkUserFieldPdm('stk.stkSend.cancel')}">
        #if (data.billStatus!=='作废'){#
        <button class="k-button k-info" onclick="cancelBill(#= data.id#, '#= data.billStatus#', '#= data.typeStr#')"><i
                class="k-icon k-i-cancel"></i>作废
        </button>
        #}#
    </c:if>
    <button class="k-button k-info" onclick="toPrint(#= data.id#)"><i
            class="k-icon k-i-cancel"></i>打印
    </button>
</script>
<script id="product-tpl" type="text/x-uglcw-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 100px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 60px;">发货数量</td>
        </tr>
        #var list = data.subList#
        #for (var i=0; i< list.length; i++) { #
        <tr>
            <td>#= list[i].wareNm #</td>
            <td>#= list[i].unitName #</td>
            <td>#= list[i].outQty #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })

    function cancelBill(id, billStatus, type) {
        if (billStatus === '作废') {
            return uglcw.util.error('该单据已作废！');
        }
        var url = '${base}manager/cancelStkOut1';
        if (type === '退货') {
            url = '${base}manager/cancelStkOutRtn';
        }
        uglcw.ui.confirm('确认作废出库单吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: url,
                data: {billId: id},
                type: 'post',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('作废成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.warning('作废失败' || response.msg);
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function showDetail(id, outType, outId) {
        uglcw.ui.openTab('单据信息' + id, '${base}manager/lookstkoutcheck?dataTp=1&billId=' + outId + '&sendId=' + id)
    }

    function toPrint(id)
    {
        uglcw.ui.openTab('发货单打印', '${base}manager/showstksendprint?dataTp=1&billId=' + id);
    }
</script>
</body>
</html>
