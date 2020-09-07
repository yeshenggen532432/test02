<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>单据查询</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li >
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li style="width: 200px;">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="请输入单据号">
                </li>
                <li>
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="billType" placeholder="业务类型">
                        <option value="">--业务类型--</option>
                        <option value="采购入库">采购入库</option>
                        <option value="其它入库">其它入库</option>
                        <option value="采购退货">采购退货</option>
                        <option value="销售退货">销售退货</option>
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>
                        <option value="报损出库">报损出库</option>
                        <option value="借出出库">借出出库</option>
                        <option value="移库管理">移库单据</option>
                        <option value="组装入库">组装入库</option>
                        <option value="拆卸出库">拆卸出库</option>
                        <option value="生产入库">生产入库</option>
                        <option value="领料出库">领料出库</option>
                        <option value="领料回库">领料回库</option>
                        <option value="付货货款">付货货款</option>
                        <option value="收货货款">收货货款</option>
                        <option value="杂费单">杂费单</option>
                        <option value="杂费结算">杂费结算</option>
                        <option value="采购返利">采购返利</option>
                        <option value="变动费用">变动费用</option>
                        <option value="固定费用">固定费用</option>
                        <option value="费用报销">费用报销</option>
                        <option value="费用付款">费用付款</option>
                        <option value="借入还款">借入还款</option>
                        <option value="借出回款">借出回款</option>
                        <option value="往来借入">往来借入</option>
                        <option value="往来借出">往来借出</option>
                        <option value="内部转存">内部转存</option>
                        <option value="其它收入">其它收入</option>
                        <option value="往来预收">往来预收</option>
                        <option value="往来预付">往来预付</option>
                        <option value="预收还款">预收还款</option>
                        <option value="预付回款">预付回款</option>
                        <option value="股东权益">股东权益</option>
                        <option value="利润分配">利润分配</option>
                    </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">查询</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                     pageable: true,
                    dblclick:onDblClickRow,
                    url: 'manager/businessBillRptList',
                    criteria: '.form-horizontal',
                    ">
                <div data-field="bill_no" >单据号</div>
                <div data-field="new_time" >时间</div>
                <div data-field="bill_name" >业务名称</div>
                <div data-field="pro_name" >往来单位</div>
            </div>
        </div>
    </div>
</div>
</div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded()
    })

    function onDblClickRow(rowData) {
        var billName = "";
        var path = "";
        if (rowData.bill_name == "销售出库") {
            billName = "销售出库";
            path = "showstkout";
            if(rowData.bill_no.indexOf("FH")!=-1){
                path = "${base}manager/lookstkoutcheck?billId=0&sendTime=''&sendId="+rowData.bill_id;
                uglcw.ui.openTab(billName, path);
                return;
            }
        }
        if (rowData.bill_name == "其它出库") {
            billName = "其它出库";
            path = "showstkout";
            if(rowData.bill_no.indexOf("FH")!=-1){
                path = "${base}manager/lookstkoutcheck?billId=0&sendTime=''&sendId="+rowData.bill_id;
                uglcw.ui.openTab(billName, path);
                return;
            }
        }
        if (rowData.bill_name == "报损出库") {
            billName = "报损出库";
            path = "showstkout";
            if(rowData.bill_no.indexOf("FH")!=-1){
                path = "${base}manager/lookstkoutcheck?billId=0&sendTime=''&sendId="+rowData.bill_id;
                uglcw.ui.openTab(billName, path);
                return;
            }
        }
        if (rowData.bill_name == "借出出库") {
            billName = "借出出库";
            path = "showstkout";
            if(rowData.bill_no.indexOf("FH")!=-1){
                path = "${base}manager/lookstkoutcheck?billId=0&sendTime=''&sendId="+rowData.bill_id;
                uglcw.ui.openTab(billName, path);
                return;
            }
        }
        if (rowData.bill_name == "采购入库") {
            billName = "采购入库";
            path = "showstkin";
            if(rowData.bill_no.indexOf("SH")!=-1){
                path = "showstkinchecklook";
            }
        }
        if (rowData.bill_name == "其它入库") {
            billName = "其它入库";
            path = "showstkin";
            if(rowData.bill_no.indexOf("SH")!=-1){
                path = "showstkinchecklook";
            }
        }
        if (rowData.bill_name == "销售退货") {
            billName = "销售退货";
            path = "showstkin";
            if(rowData.bill_no.indexOf("SH")!=-1){
                path = "showstkinchecklook";
            }
        }
        if (rowData.bill_name == "采购退货") {
            billName = "采购退货";
            path = "showstkin";
            if(rowData.bill_no.indexOf("FH")!=-1){
                path = "showstkinchecklook";
            }
        }

        if (rowData.bill_name == "移库管理") {
            billName = "移库管理";
            path = "stkMove/show";
        }
        if (rowData.bill_name == "组装入库") {
            billName = "组装入库";
            path = "stkZzcx/show";
        }
        if (rowData.bill_name == "拆卸出库") {
            billName = "拆卸出库";
            path = "stkZzcx/show";
        }

        if (rowData.bill_name == "领料出库") {
            billName = "领料出库";
            path = "stkPickup/show";
        }

        if (rowData.bill_name == "领料回库") {
            billName = "领料回库";
            path = "showStkLlhkIn";
        }

        if (rowData.bill_name == "生产入库") {
            billName = "生产入库";
            path = "stkProduce/show";
            var url = '${base}manager/' + path + '?_sticky=v1&billId=' + rowData.bill_id;
            uglcw.ui.openTab(billName, url);
            return;
        }

        if (rowData.bill_name == "收货货款") {
            billName = "收货货款";
            path = "showStkpay";
        }
        if (rowData.bill_name == "付货货款") {
            billName = "付货货款";
            path = "showStkPayMast";
        }

        if (rowData.bill_name == "杂费单") {
            billName = "杂费单";
            path = "stkExtrasFee/show";
        }

        if (rowData.bill_name == "杂费结算") {
            billName = "杂费结算";
            path = "stkExtrasCarryOver/show";
        }

        if (rowData.bill_name == "采购返利") {
            billName = "采购返利";
            path = "stkRebateIn/show";
        }

        if (rowData.bill_name == "变动费用") {
            billName = "变动费用";
            path = "stkRebateOut/show";
        }

        if (rowData.bill_name == "固定费用") {
            billName = "固定费用";
            path = "stkFixedFee/show";
        }

        if (rowData.bill_name == "费用报销") {
            billName = "费用报销";
            path = "showFinCostEdit";
        }
        if (rowData.bill_name == "费用付款") {
            billName = "费用付款";
            path = "showFinPayEdit";
        }
        if (rowData.bill_name == "往来借出") {
            billName = "往来借出单";
            path = "showFinOutEdit";
        }
        if (rowData.bill_name == "往来借入") {
            billName = "往来借入单";
            path = "showFinInEdit";
        }
        if (rowData.bill_name == "借出回款") {
            billName = "借出回款";
            path = "showFinOutReturn";
        }
        if (rowData.bill_name == "借入还款") {
            billName = "借入还款";
            path = "showFinInReturn";
        }

        if (rowData.bill_name == "股东权益") {
            billName = "股东权益";
            path = "showFinEquityEdit";
        }


        if (rowData.bill_name == "其它收入") {
            billName = "其它收款";
            path = "showFinRecEdit";
        }
        if (rowData.bill_name == "内部转存") {
            billName = "内部转存";
            path = "showFinTransEdit";
        }

        if (rowData.bill_name == "往来预收") {
            billName = "往来预收";
            path = "showFinPreInEdit";
        }

        if (rowData.bill_name == "预收还款") {
            billName = "预收还款";
            path = "showFinPreInReturn";
        }

        if (rowData.bill_name == "往来预付") {
            billName = "往来预付";
            path = "showFinPreOutEdit";
        }

        if (rowData.bill_name == "预付回款") {
            billName = "预付回款";
            path = "showFinPreOutReturn";
        }
        if (rowData.bill_name == "股东权益") {
            billName = "股东权益";
            path = "showFinEquityEdit";
        }

        if (rowData.bill_name == "利润分配") {
            billName = "利润分配";
            path = "finEquityProfit/show";
        }

        if (rowData.bill_name == "资金初始化") {
            billName = "资金初始化";
            path = "finInitMoney/edit";
            var url = '${base}manager/' + path + '?id=' + rowData.bill_id;
            uglcw.ui.openTab(billName, url);
            return;
        }
        if (path != "") {
            var url = '${base}manager/' + path + '?billId=' + rowData.bill_id;
            uglcw.ui.openTab(billName, url);
        }

    }
</script>
</body>
</html>
