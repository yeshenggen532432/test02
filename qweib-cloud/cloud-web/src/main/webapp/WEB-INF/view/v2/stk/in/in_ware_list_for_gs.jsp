<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="query">
    <input type="hidden" value="${billNo}" uglcw-model="billNo" uglcw-role="textbox"/>
</div>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                    responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    criteria: '.query',
                    url: '${base}manager/queryInWareListForGs',
                    pageable: false
                    ">
                        <div data-field="ck" uglcw-options="
                        width:50, selectable: true, type: 'checkbox',
                        headerAttributes: {'class': 'uglcw-grid-checkbox'}
                        "></div>
                        <div data-field="bill_no" uglcw-options="width:160">单据号</div>
                        <div data-field="be_pack_bar_code" uglcw-options="width:180">食品条形码</div>
                        <div data-field="ware_nm" uglcw-options="width:160">食品名称</div>
                        <div data-field="ware_dw" uglcw-options="width:160">单位</div>
                        <div data-field="qty" uglcw-options="width:160">单据数量</div>
                        <div data-field="in_qty" uglcw-options="width:160">进货数量</div>
                        <div data-field="price" uglcw-options="width:160">单价</div>
                        <div data-field="product_date" uglcw-options="width:160">生产日期</div>
                        <div data-field="pro_no" uglcw-options="width:200, tooltip: true">供应商注册号/信用代码</div>
                        <div data-field="pro_name" uglcw-options="width:160">供应商名称</div>
                        <div data-field="in_time" uglcw-options="width:160">进货日期</div>
                        <div data-field="remarks" uglcw-options="width:160, tooltip:true">进货日期</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:exportToExcel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>导出为EXCEL
    </a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#grid').on('dataBound', function () {
            setTimeout(function () {
                uglcw.ui.get('#grid').k().select('tr');
            }, 200)
        })
        uglcw.ui.loaded();
    })


    function exportToExcel() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection || selection.length < 1) {
            return uglcw.ui.warning('请勾选要导出的数据');
        }
        uglcw.ui.confirm('是否导出数据？', function () {
            window.location.href = '${base}manager/downloadInWareListForGsToExcel?subIds=' + $.map(selection, function (item) {
                return item.sub_id
            }).join(',');
        })
    }


</script>
</body>
</html>
