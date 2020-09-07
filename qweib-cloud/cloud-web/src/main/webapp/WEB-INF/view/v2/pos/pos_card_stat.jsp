<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>各分店报表-会员卡汇总</title>
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
                    <input type="hidden" uglcw-model="ioFlag" uglcw-role="textbox" value="2"/>
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
                            url: 'manager/pos/getCardStatList',
                            criteria: '.form-horizontal',
                            }">
                <div data-field="statDate" uglcw-options="width:160">日期</div>
                <div data-field="newQty" uglcw-options="width:100">发卡数量</div>
                <div data-field="inputQty" uglcw-options="width:100">充值次数</div>
                <div data-field="inputCash"
                     uglcw-options="width:100,template: '#= data.inputCash ? uglcw.util.toString(data.inputCash,\'n2\'): \' \'#'">
                    充值金额
                </div>
                <div data-field="inputFree"
                     uglcw-options="width:100,template: '#= data.inputFree ? uglcw.util.toString(data.inputFree,\'n2\'): \' \'#'">
                    赠送金额
                </div>
                <div data-field="costQty" uglcw-options="width:100">消费次数</div>

                <div data-field="cardPay"
                     uglcw-options="width:100,template: '#= data.cardPay ? uglcw.util.toString(data.cardPay,\'n2\'): \' \'#'">
                    消费金额
                </div>
                <div data-field="disAmt"
                     uglcw-options="width:100,template: '#= data.disAmt ? uglcw.util.toString(data.disAmt,\'n2\'): \' \'#'">
                    差额
                </div>
                <div data-field="totalAmt"
                     uglcw-options="width:100,template: '#= data.disAmt ? uglcw.util.toString(data.disAmt,\'n2\'): \' \'#'">
                    总可消费金额
                </div>
                <div data-field="disAmt"
                     uglcw-options="width:100,template: '#= data.disAmt ? uglcw.util.toString(data.disAmt,\'n2\'): \' \'#'">
                    差额
                </div>
                <div data-field="disAmt"
                     uglcw-options="width:100,template: '#= data.disAmt ? uglcw.util.toString(data.disAmt,\'n2\'): \' \'#'">
                    差额
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
