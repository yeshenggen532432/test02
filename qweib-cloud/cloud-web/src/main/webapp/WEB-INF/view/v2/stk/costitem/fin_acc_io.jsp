<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>收入支出</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .row-color-blue {
            color: blue;
            text-decoration: line-through;
            font-weight: bold;
        }

        .row-color-pink {
            color: #FF00FF !important;
            font-weight: bold;
        }

        .row-color-red {
            color: red  !important;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal" id="export">
                        <li>
                            <input type="hidden" uglcw-model="accId" id="accId" value="${accId}" uglcw-role="textbox">
                            <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">

                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                        <li style="padding-top: 5px">
                            <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>&nbsp;<span
                                style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                         loadFilter: {
                         data: function (response) {
                         response.rows.splice( response.rows.length - 1, 1);
                         return response.rows || []
                       },
                       aggregates: function (response) {
                         var aggregate = {
                                inAmt:0,
                                outAmt:0
                         };
                       if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1])
                       }
                        return aggregate;
                       }
                     },
                      dblclick: onDblClickRow,
                    pageable: true,
                    responsive:['.header',40],
                    id:'id',
                    url: 'manager/queryAccIoPage',
                    criteria: '.form-horizontal',
                    dataBound: function(){
                        var data = this.dataSource.view();
                        $(data).each(function(idx, row){
                            var clazz = ''
                            if(row.status == 2){
                                clazz = 'row-color-blue';
                            }else if(row.status == 3){
                                clazz = 'row-color-pink';
                            }else if(row.status == 4){
                                clazz = 'row-color-red';
                            }
                            $('#grid tr[data-uid='+row.uid+']').addClass(clazz);
                        })
                    },
                      aggregate:[
                     {field: 'inAmt', aggregate: 'SUM'},
                     {field: 'outAmt', aggregate: 'SUM'}
                    ],
                    }">

                        <div data-field="remarks" uglcw-options="width:100">类型</div>
                        <div data-field="billNo" uglcw-options="width:170,tooltip: true">单号</div>
                        <div data-field="accTimeStr"
                             uglcw-options="width:160,footerTemplate: '合计：'">日期
                        </div>
                        <div data-field="objName" uglcw-options="width:160,tooltip: true">往来单位</div>
                        <div data-field="inAmt"
                             uglcw-options="width:120,footerTemplate: '#= uglcw.util.toString(data.inAmt,\'n2\')#'">收入金额
                        </div>
                        <div data-field="outAmt"
                             uglcw-options="width:120,footerTemplate: '#= uglcw.util.toString(data.outAmt,\'n2\')#'">支出金额
                        </div>
                        <div data-field="leftAmt" uglcw-options="width:120">余额</div>
                        <div data-field="remarks1" uglcw-options="width:120">备注</div>
                        <div data-field="operator" uglcw-options="width:120">操作员</div>
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

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


    function onDblClickRow(row) {
        var billName = "";
        var path = "";
        if (row.remarks == "销售收入") {
            billName = "销售发票";
            //path = "showstkout";
            path = "showstkoutNo";
        }
        if (row.remarks == "收货款单") {
            billName = "收货款单";
            //path = "showstkout";
            path = "showstkoutNo";
        }
        if (row.remarks == "收货货款") {
            billName = "收货货款";
            //path = "showstkout";
            path = "showStkpay";
        }
        if (row.remarks == "付货货款") {
            billName = "付货货款";
            //path = "showstkout";
            path = "showStkPayMast";
        }
        if (row.remarks == "付货款单") {
            billName = "付货款单";
            //path = "showstkout";
            path = "showStkPayMast";
        }

        if (row.remarks == "采购支出") {
            billName = "采购发票";
            path = "showstkin";
        }
        if (row.remarks == "销售退货支出") {
            billName = "销售退货发票";
            path = "showstkin";
        }
        if (row.remarks == "往来预收") {
            billName = "往来预收";
            path = "showFinPreInEdit";
        }
        if (row.remarks == "往来预付") {
            billName = "往来预付";
            path = "showFinPreOutEdit";
        }
        if (row.remarks == "往来借出") {
            billName = "往来借出单";
            path = "showFinOutEdit";
        }
        if (row.remarks == "往来借入") {
            billName = "往来借入单";
            path = "showFinInEdit";
        }
        if (row.remarks == "借款收回") {
            billName = "借款收回";
            path = "showFinOutReturn";
        }
        if (row.remarks == "还款支出") {
            billName = "还款支出";
            path = "showFinInReturn";
        }
        if (row.remarks == "支出") {
            billName = "付款单";
            path = "showFinPayEdit";
        }
        if (row.remarks == "费用支付") {
            billName = "费用支付";
            path = "showFinPayEdit";
        }
        if (row.remarks == "收入") {
            billName = "收款单";
            path = "showFinRecEdit";
        }
        if (row.remarks == "其它收款") {
            billName = "其它收款";
            path = "showFinRecEdit";
        }
        if (row.remarks == "转入" || row.remarks == "转出") {
            billName = "内部转存";
            path = "showFinTransEdit";
        }
        if (row.remarks == "内部转入" || row.remarks == "内部转出") {
            billName = "内部转存";
            path = "showFinTransEdit";
        }
        if (row.remarks == "资金初始化") {
            billName = "资金初始化";
            path = "finInitMoney/edit";
            var url = 'manager/' + path + '?id=' + row.billId;
            uglcw.ui.openTab(billName, url);
            return;
        }
        if (path != "") {
            var url = 'manager/' + path + '?billId=' + row.billId;
            if (row.remarks == "销售收入") {
                url = 'manager/' + path + '?billNo=' + row.billNo;
            }
            if (row.remarks == "还款支出") {
                url = 'manager/' + path + '?remarks=还款支出&billId=' + row.billId;
            }
            uglcw.ui.openTab(billName, url);
        }

    }
</script>
</body>
</html>
