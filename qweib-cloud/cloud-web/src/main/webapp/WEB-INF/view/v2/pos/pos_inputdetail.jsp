<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>各门店报表-充值查询</title>
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
                <li>
                    <input type="hidden" uglcw-model="ioFlag" uglcw-role="textbox" value="1"/>
                    <input type="hidden" id="cardId" value="${cardId}" uglcw-role="textbox" uglcw-model="cardId"/>
                    <select uglcw-role="combobox" uglcw-model="shopNo" uglcw-options="
                                                value:'${shopNo}',
                                                url: '${base}manager/pos/queryPosShopInfoPage',
                                                placeholder: '门店',
                                                dataTextField: 'shopName',
                                                dataValueField: 'shopNo',
                                                loadFilter:{
                                                    data: function(response){
                                                        return response.rows || [];
                                                    }
                                                }
                                             ">
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="cardType" uglcw-options="
                                                url: '${base}manager/pos/queryMemberTypeList',
                                                placeholder: '卡类型',
                                                dataTextField: 'typeName',
                                                dataValueField: 'id',
                                                loadFilter:{
                                                    data: function(response){
                                                        return response.rows || [];
                                                    }
                                                }
                                             ">
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="operator" placeholder="收银员">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="name" placeholder="姓名">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="mobile" placeholder="电话">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="cardNo" placeholder="卡号">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
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
                 uglcw-options="{
                    responsive:['.header',40],
                    id:'id',
                    url: 'manager/pos/queryPosMemberIo',
                    criteria: '.form-horizontal',

                    }">

                <div data-field="ioTimeStr" uglcw-options="width:160">充值时间</div>
                <div data-field="cardNo" uglcw-options="width:100">卡号</div>
                <div data-field="typeName" uglcw-options="width:100">卡类型</div>
                <div data-field="inputCash"
                     uglcw-options="width:100,template: '#= data.inputCash ? uglcw.util.toString(data.inputCash,\'n2\'): \' \'#'">
                    充值金额
                </div>

                <div data-field="freeCost"
                     uglcw-options="width:100,template: '#= data.freeCost ? uglcw.util.toString(data.freeCost,\'n2\'): \' \'#'">
                    赠送金额
                </div>

                <div data-field="operator" uglcw-options="width:100">收银员</div>

                <div data-field="cashPay"
                     uglcw-options="width:80,template: '#= data.cashPay ? uglcw.util.toString(data.cashPay,\'n2\'): \' \'#'">
                    现金支付
                </div>

                <div data-field="bankPay"
                     uglcw-options="width:100,template: '#= data.bankPay ? uglcw.util.toString(data.bankPay,\'n2\'): \' \'#'">
                    银行卡支付
                </div>

                <div data-field="wxPay"
                     uglcw-options="width:100,template: '#= data.wxPay ? uglcw.util.toString(data.wxPay,\'n2\'): \' \'#'">
                    微信支付
                </div>

                <div data-field="zfbPay"
                     uglcw-options="width:100,template: '#= data.zfbPay ? uglcw.util.toString(data.zfbPay,\'n2\'): \' \'#'">
                    支付宝
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


</script>
</body>
</html>
