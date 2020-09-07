<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>出入库记录</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="query">
        <input type="hidden" uglcw-model="wareId" value="${wareId}" uglcw-role="textbox">
        <input type="hidden" uglcw-model="stkId" value="${stkId}" uglcw-role="textbox">
        <input type="hidden" uglcw-model="billId" value="${billId}" uglcw-role="textbox">
        <input type="hidden" id="billName" uglcw-model="billName" uglcw-role="textbox" value="${billName}"/>
        <input uglcw-model="sdate" type="hidden" uglcw-role="textbox" value="${sdate}">
        <input uglcw-model="edate" type="hidden" uglcw-role="textbox" value="${edate}">
        <input uglcw-model="status" type="hidden" uglcw-role="textbox" value="0">
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:[40],
                    dblclick:function(row){
                      showBill(row);
                    },
                    loadFilter:{
                        data: function(resp){
                            var rows = resp.rows || [];
                            rows.splice(rows.length - 1, 1);
                            return rows;
                        },
                        aggregates: function(resp){
                            var agg = {inQty: 0, outQty: 0,minInQty:0,minOutQty:0};
                            if(resp.rows && resp.rows.length>0){
                                agg = uglcw.extend(agg, resp.rows[resp.rows.length - 1]);
                            }
                            return agg;
                        }
                    },
                    aggregate:[
                        {field: 'inQty', aggregate: 'sum'},
                        {field: 'outQty', aggregate: 'sum'},
                        {field: 'minInQty', aggregate: 'sum'},
                        {field: 'minOutQty', aggregate: 'sum'}
                    ],
                    url: '${base}manager/queryIoDetailList',
                    criteria: '.query'
             ">
                <div data-field="ioTimeStr" uglcw-options="width:160, footerTemplate: '合计:'">日期</div>
                <div data-field="billNo" uglcw-options="width:170,
                        template: uglcw.util.template($('#formatterEvent').html())">单号
                </div>
                <div data-field="stkUnit" uglcw-options="width:120">往来单位</div>
                <div data-field="wareNm" uglcw-options="width:140">商品名称</div>
                <div data-field="unitName" uglcw-options="width:100">单位</div>
                <div data-field="inQty"
                     uglcw-options="width:140, footerTemplate: '#= uglcw.util.toString(data.inQty.sum !== undefined ? data.inQty.sum : data.inQty,\'n2\')#'">
                    入库数量
                </div>
                <div data-field="outQty"
                     uglcw-options="width:100, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty,\'n2\')#'">
                    出库数量
                </div>
                <div data-field="minUnitName" uglcw-options="width:100">单位(小)</div>
                <div data-field="minInQty"
                     uglcw-options="width:140, footerTemplate: '#= uglcw.util.toString(data.minInQty.sum !== undefined ? data.minInQty.sum : data.minInQty,\'n2\')#'">
                    入库数量(小)
                </div>
                <div data-field="minOutQty"
                     uglcw-options="width:100, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minOutQty,\'n2\')#'">
                    出库数量(小)
                </div>
                <div data-field="billName"
                     uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.billName,\'n2\')#'">出入库类型
                </div>
                <div data-field=""
                    >&nbsp;
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="formatterEvent">
    <a style="color: blue" href="javascript:showSourceBill(#= data.billId#, '#= data.billName#')">#=data.billNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })

    function showSourceBill(id, name) {
        showBill({
            billId: id,
            billName: name
        });
    }

    function showBill(row) {
        var billName = row.billName;
        if ("正常销售" == billName || "促销折让" == billName || "消费折让" == billName || "费用折让" == billName || "其他销售" == billName) {
            uglcw.ui.openTab('销售出库详细' + row.billId, '${base}manager/showstkout?dataTp=1&billId=' + row.billId);
            return;
        }

        if ('其它出库' == billName) {
            uglcw.ui.openTab('其它出库明细' + row.billId, '${base}manager/showstkout?billId=' + row.billId);
        } else if ('报损出库' == billName) {
            uglcw.ui.openTab('报损出库明细' + row.billId, '${base}manager/showstkout?billId=' + row.billId);
        } else if ('借出出库' == billName) {
            uglcw.ui.openTab('借出出库明细' + row.billId, '${base}manager/showstkout?billId=' + row.billId);
        } else if ('领用出库' == billName) {
            uglcw.ui.openTab('领用出库明细' + row.billId, '${base}manager/showstkout?billId=' + row.billId);
        } else if ('移库出库' == billName) {
            uglcw.ui.openTab('移库出库明细' + row.billId, '${base}manager/stkMove/show?billId=' + row.billId);
        } else if ('拆卸出库' == billName) {
            uglcw.ui.openTab('拆卸出库明细' + row.billId, '${base}manager/stkZzcx/show?billId=' + row.billId);
        } else if ('组装出库' == billName) {
            uglcw.ui.openTab('领用出库明细' + row.billId, '${base}manager/stkZzcx/show?billId=' + row.billId);
        } else if ('领料出库' == billName) {
            uglcw.ui.openTab('领料出库明细' + row.billId, '${base}manager/stkPickup/show?billId=' + row.billId);
        } else if ('盘亏' == billName) {
            uglcw.ui.openTab('盘亏出库详细' + row.billId, '${base}manager/showStkcheck?billId=' + row.billId);
        } else if ('销售退货'.indexOf(billName) !== -1) {
            uglcw.ui.openTab('销售出库详细' + row.billId, '${base}manager/showstkin?dataTp=1&billId=' + row.billId);
        } else if ('采购退货'.indexOf(billName) !== -1) {
            uglcw.ui.openTab('采购退货详细' + row.billId, '${base}manager/showstkin?dataTp=1&billId=' + row.billId);
        } else if ('其它入库' === billName) {
            uglcw.ui.openTab('其它入库详细' + row.billId, '${base}manager/showstkin?dataTp=1&billId=' + row.billId);
        } else if ('采购入库' === billName) {
            uglcw.ui.openTab('采购入库详细' + row.billId, '${base}manager/showstkin?dataTp=1&billId=' + row.billId);
        } else if ('移库入库' === billName) {
            uglcw.ui.openTab('移库入库详细' + row.billId, '${base}manager/stkMove/show?billId=' + row.billId);
        } else if ('拆卸入库' === billName) {
            uglcw.ui.openTab('拆卸入库详细' + row.billId, '${base}manager/stkZzcx/show?billId=' + row.billId);
        } else if ('组装入库' === billName) {
            uglcw.ui.openTab('组装入库详细' + row.billId, '${base}manager/stkZzcx/show?billId=' + row.billId);
        } else if ('初始化入库' === billName) {
            uglcw.ui.openTab('初始化入库详细' + row.billId, '${base}manager/showStkcheckInit?billId=' + row.billId);
        } else if ('盘盈' === billName) {
            uglcw.ui.openTab('盘盈入库详细' + row.billId, '${base}manager/showStkcheck?billId=' + row.billId);
        } else if ('生产入库' === billName) {
            uglcw.ui.openTab('生产入库详细' + row.billId, '${base}manager/stkProduce/show?billId=' + row.billId);
        } else if ('领料回库' === billName) {
            uglcw.ui.openTab('领料回库详细' + row.billId, '${base}manager/showStkLlhkIn?billId=' + row.billId);
        }
    }
</script>
</body>
</html>
