<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcu/css/bill-common.css" media="all">
    <style>
        .uglcw-search input, select {
            height: 30px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid-advanced"
                 uglcw-options='
                          responsive:[25],
                          id: "id",
                          rowNumber: true,
                          checkbox: false,
                          url: "manager/queryStorageWareList?stkId=${stkId}&wareId=${wareId}&scope=${scope}"
                        '
            >
                <div data-field="wareNm" uglcw-options="width: 180,
                            tooltip: true,
                            align: 'left',
                            titleAlign: 'center',
                ">产品名称
                </div>
                <div data-field="unitName" uglcw-options="width: 80">单位
                </div>
                <div data-field="qty" uglcw-options="width: 100, format:'{0:n5}'">数量</div>
                <c:if test="${permission:checkUserFieldPdm('stk.storageWare.showprice')}">
                    <div data-field="inPrice" uglcw-options="width: 100, format:'{0:n5}'">单价</div>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.storageWare.showamt')}">
                    <div data-field="stkAmt" uglcw-options="width: 100,format:'{0:n2}'">金额</div>
                </c:if>
                <div data-field="inTimeStr" uglcw-options="width: 150">入库日期</div>
                <div data-field="productDate"
                     uglcw-options="width: 150, template: uglcw.util.template($('#product-date-tpl').html())">生产日期
                </div>
                <div data-field="minUnitName" uglcw-options="width: 120">小单位</div>
                <div data-field="minSumQty" uglcw-options="width: 120">小单位数量</div>
                <div data-field="billNo" uglcw-options="width: 140">单号</div>
            </div>
        </div>
    </div>
</div>


<script type="text/x-uglcw-template" id="product-date-tpl">
    <div class="product-code">
        <span>#= data.productDate || ''#</span>
        <span onclick="showRelatedProductDate(this)" class="product-date-tooltip"
              style="font-weight:bold;color: \\#1c77f0;">
            更新</span>
    </div>
</script>
<script type="text/x-uglcw-template" id="product-date-edit-tpl">
    <div class="layui-card">
        <div class="layui-card-body full">
            <input class="product-date-input" uglcw-role="datepicker" uglcw-model="productDate" placeholder="更新时间">
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
   // var showMinUnit = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_STORAGE_SHOW_MINUNIT\"  and status=1")}' === '';
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    })

    function showRelatedProductDate(el) {
        var row = uglcw.ui.get('#grid').k().dataItem($(el).closest('tr'));
        if (!row.wareId) {
            return uglcw.ui.warning('请选择商品');
        }

        var i = uglcw.ui.Modal.open({
            title: '更新日期',
            maxmin: false,
            content: $('#product-date-edit-tpl').html(),
            success: function (c) {
                uglcw.ui.init(c);
                uglcw.ui.bind(c, {
                    productDate: row.productDate
                })
            },
            yes: function (c) {
                var data = uglcw.ui.bind(c);
                uglcw.ui.confirm('确定更新日期吗？', function () {
                    $.ajax({
                        url: '${base}manager/updateProduceDate',
                        type: 'post',
                        data: {
                            sswId: row.id,
                            produceDate: data.productDate || ''
                        },
                        success: function (resp) {
                            if(resp.state){
                                uglcw.ui.success('更新成功');
                                uglcw.ui.get('#grid').reload();
                                uglcw.ui.Modal.close(i);
                            }else{
                                uglcw.ui.error(resp.message || '更新失败');
                            }
                        }
                    })
                })
                return false;
            }
        })
    }
</script>
</body>
</html>
