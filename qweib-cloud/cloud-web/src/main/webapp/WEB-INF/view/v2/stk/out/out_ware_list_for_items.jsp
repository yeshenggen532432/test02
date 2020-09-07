<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售明细下载</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body full">
            <div class="uglcw-query" style="display: none;">
                <input type="hidden" uglcw-model="billNo" uglcw-role="textbox" value="${billNo}"/>
            </div>
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header', 50],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/queryOutWareListForGs',
                    criteria: '.uglcw-query',
                    pageable: false,
                    rowNumber: true
                    ">
                <div data-field="bill_no" uglcw-options="width:160">单号
                </div>
                <div data-field="be_pack_bar_code" uglcw-options="width:170">条形码</div>
                <div data-field="ware_nm" uglcw-options="width:180, tooltip: true">商品名称</div>
                <div data-field="ware_dw" uglcw-options="width:90">单位</div>
                <div data-field="ware_gg" uglcw-options="width:90">规格</div>
                <div data-field="qty" uglcw-options="width:90">单据数量</div>
                <div data-field="price" uglcw-options="width:90">单价</div>
                <div data-field="amt" uglcw-options="width:90">金额</div>
                <div data-field="product_date" uglcw-options="width:120">生产日期</div>
                <div data-field="kh_nm" uglcw-options="width:120, tooltip: true">客户名称</div>
                <div data-field="out_time" uglcw-options="width:120">下单日期</div>
                <div data-field="remarks" uglcw-options="width:320">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:downloadDetails();">
        <span class="k-icon k-i-download"></span>下载销售明细
    </a>
</script>
<script id="bill-no" type="text/x-kendo-template">
    <span style="color:\\#337ab7;font-size: 12px; font-weight: bold;">#=data.bill_no#</span>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    });

    function downloadDetails() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection && selection.length > 0) {
            uglcw.ui.confirm('是否下载数据？', function () {
                var ids = $.map(selection, function (row) {
                    return row.sub_id;
                }).join(',');
                window.location.href = '${base}manager/downloadOutWareListForBillToExcel?subIds=' + ids;
            })
        } else {
            uglcw.ui.error('请选择要导出的数据！');
        }
    }
</script>
</body>
</html>
