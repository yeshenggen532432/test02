<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售出库成本单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcu/css/bill-common.css" media="all">
    <style>
        .uglcw-search input, select {
            height: 30px;
        }

        .layui-card-header.btn-group {
            padding-left: 0px;
            line-height: inherit;
            height: inherit;
        }

        .dropdown-header {
            border-width: 0 0 1px 0;
            text-transform: uppercase;
        }

        .dropdown-header > span {
            display: inline-block;
            padding: 10px;
        }

        .dropdown-header > span:first-child {
            width: 50px;
        }

        .k-list-container > .k-footer {
            padding: 10px;
        }

        .k-grid .k-command-cell .k-button {
            padding-top: 2px;
            padding-bottom: 2px;
        }

        .k-grid tbody tr {
            cursor: move;
        }

        .k-tabstrip .criteria .k-textbox {
            width: 200px;
        }

        .k-tabstrip .criteria {
            margin-bottom: 5px;
        }

        .k-tabstrip .criteria .search {

        }

    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card master">
            <div class="layui-card-header btn-group">
                <ul uglcw-role="buttongroup">
                </ul>
                <div class="bill-info">
                    <span class="no" style="color: green;">${main.billType}-成本单 ${main.billNo}</span>
                </div>
            </div>
            <div class="layui-card-body">
                <div class="form-horizontal" uglcw-role="validator">
                    <div class="form-group">
                        <label class="control-label col-xs-3">往来单位</label>
                        <div class="col-xs-4">
                            <input uglcw-role="gridselector" id="proName" uglcw-model="proName" value="${main.proName}"
                                   uglcw-validate="required"
                                   >
                        </div>
                        <label class="control-label col-xs-3">成本日期</label>
                        <div class="col-xs-4">
                            <input uglcw-role="datetimepicker" uglcw-validate="required" value="${main.billTime}" uglcw-model="outDate"
                                   uglcw-options="format:'yyyy-MM-dd HH:mm',template: uglcw.util.template($('#time-tpl').html())">
                        </div>

                        <label class="control-label col-xs-3">单据状态</label>
                        <div class="col-xs-4">
                            <select uglcw-role="combobox" uglcw-model="status"
                               uglcw-options="value:${main.status}"
                             >
                                <option value="0">正常单</option>
                                <option value="3">被冲红单</option>
                                <option value="4">冲红单</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-3">出货仓库</label>
                        <div class="col-xs-4">
                            <select id="stkId" uglcw-role="combobox" uglcw-validate="required" uglcw-model="stkId,stkName"
                                    uglcw-options="
                                value:${main.stkId},
                                url: '${base}manager/queryBaseStorage',
                                index:0,
                                dataTextField: 'stkName',
                                dataValueField: 'id'
                            "></select>
                        </div>
                        <label class="control-label col-xs-3">关联发货单号</label>
                        <div class="col-xs-4">
                            <input uglcw-role="textbox" id="ioBillNo" uglcw-model="ioBillNo" value="${main.ioBillNo}"
                                   readonly
                            >
                        </div>
                        <label class="control-label col-xs-3">关联单号</label>
                        <div class="col-xs-4">
                            <input uglcw-role="textbox" id="sourceBillNo" uglcw-model="sourceBillNo" value="${main.sourceBillNo}"
                                   readonly
                            >
                        </div>

                    </div>
                </div>
            </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid-advanced"
                 uglcw-options='
                         responsive:[".master",40],
                          lockable: false,
                          rowNumber: true,
                          checkbox: false,
                          dragable: true,
                          navigatable: true,
                          aggregate: [
                            {field: "outQty", aggregate: "sum"},
                            {field: "inAmt", aggregate: "sum"}
                          ],
                          dataSource: gridDataSource
                        '
            >
                <div data-field="wareNm" uglcw-options="width:180">产品名称
                </div>
                <div data-field="unitName" uglcw-options="width: 80">单位
                </div>
                <div data-field="billName" uglcw-options="width: 100">销售类型
                </div>
                <div data-field="outQty" uglcw-options="width: 100">
                    出库数量
                </div>
                <div data-field="inPrice" uglcw-options="width: 100">
                    成本单价
                </div>
                <div data-field="inAmt" uglcw-options="width: 100">成本金额
                </div>
                <div data-field="productDate" uglcw-options="width: 120">生产日期
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="time-tpl">
    <span>#= uglcw.util.toString(new Date(data.billTime), 'yyyy-MM-dd HH:mm')#</span>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var gridDataSource = ${fns:toJson(sublist)};
    $(function () {
        uglcw.ui.init();
        setTimeout(uglcw.ui.loaded, 210);
    })

    function scrollToGridBottom() {
        uglcw.ui.get('#grid').scrollBottom()
    }

    function scrollToGridTop() {
        uglcw.ui.get('#grid').scrollTop()
    }

    function saveChanges() {
        uglcw.ui.get('#grid').commit();
    }

    function showSourceBillNo(id) {
        uglcw.ui.openTab('发票信息' + id, "${base}manager/showstkout?dataTp=1&billId=" + id)
    }
    function showIoBillNo(id) {
        uglcw.ui.openTab('发货信息' + id, "${base}manager/lookstkoutcheck?sendId="+id)
    }
</script>
</body>
</html>
