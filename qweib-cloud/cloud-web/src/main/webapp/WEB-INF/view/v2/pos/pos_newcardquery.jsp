<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>各分店报表-发卡记录</title>
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
                    <input type="hidden" uglcw-model="ioFlag" uglcw-role="textbox" value="0"/>

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

                    <select uglcw-role="combobox" id="cardType1" uglcw-model="cardType" uglcw-options="
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
            <ul>
                <li id="newCardSum">
                    <a>金卡3</a><a>金卡3</a><a>金卡3</a>

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
                    aggregate:[
                     {field: 'cardPay', aggregate: 'sum'},
                     {field: 'inputCash', aggregate: 'sum'},
                     {field: 'freeCost', aggregate: 'sum'},
                     {field: 'cashPay', aggregate: 'sum'},
                     {field: 'bankPay', aggregate: 'sum'},
                     {field: 'wxPay', aggregate: 'sum'},
                     {field: 'zfbPay', aggregate: 'sum'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        var lines = response.newCardInfo.split(',');
                        var cardTypes = response.cardTypes.split(',');
                        var html = '';
                        for(var i = 0;i<lines.length;i++)
                        {
                            if(i == 0)html = '<a onclick=\'chooseCardType(' + cardTypes[i] + ')\'>' + lines[i] + '</a>';
                            else html = html + '<a onclick=\'chooseCardType(' + cardTypes[i] + ')\'>' + lines[i] + '</a>';
                        }
                        $('#newCardSum').html(html);
                        //uglcw.ui.get('#remarks').value(response.newCardInfo);
                        var rows = []

                        $(response.rows).each(function(idx, row){
                            rows.push(row);
                        })

                        return rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            cardPay:0,
                            inputCash: 0,
                            freeCost: 0,
                            cashPay: 0,
                            bankPay: 0,
                            wxPay:0,
                            zfbPay:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     }

                    }">

                <div data-field="ioTimeStr" uglcw-options="width:160">发卡时间</div>
                <div data-field="cardNo" uglcw-options="width:100">卡号</div>
                <div data-field="typeName" uglcw-options="width:100">卡类型</div>

                <div data-field="cardPay"
                     uglcw-options="width:100,template: '#= data.cardPay ? uglcw.util.toString(data.cardPay,\'n2\'): \' \'#' , footerTemplate: '#= uglcw.util.toString(data.cardPay || 0, \'n2\')#' ">
                    工本费
                </div>

                <div data-field="inputCash"
                     uglcw-options="width:100,template: '#= data.inputCash ? uglcw.util.toString(data.inputCash,\'n2\'): \' \'#' , footerTemplate: '#= uglcw.util.toString(data.inputCash || 0, \'n2\')#' ">
                    充值金额
                </div>

                <div data-field="freeCost"
                     uglcw-options="width:100,template: '#= data.freeCost ? uglcw.util.toString(data.freeCost,\'n2\'): \' \'#' , footerTemplate: '#= uglcw.util.toString(data.freeCost || 0, \'n2\')#' ">
                    赠送金额
                </div>

                <div data-field="operator" uglcw-options="width:80">收银员</div>

                <div data-field="cashPay"
                     uglcw-options="width:120,template: '#= data.cashPay ? uglcw.util.toString(data.cashPay,\'n2\'): \' \'#' , footerTemplate: '#= uglcw.util.toString(data.cashPay || 0, \'n2\')#' ">
                    现金支付
                </div>

                <div data-field="bankPay"
                     uglcw-options="width:100,template: '#= data.bankPay ? uglcw.util.toString(data.bankPay,\'n2\'): \' \'#' , footerTemplate: '#= uglcw.util.toString(data.bankPay || 0, \'n2\')#' ">
                    银行卡支付
                </div>

                <div data-field="wxPay"
                     uglcw-options="width:100,template: '#= data.wxPay ? uglcw.util.toString(data.wxPay,\'n2\'): \' \'#' , footerTemplate: '#= uglcw.util.toString(data.wxPay || 0, \'n2\')#' ">
                    微信支付
                </div>

                <div data-field="zfbPay"
                     uglcw-options="width:100,template: '#= data.zfbPay ? uglcw.util.toString(data.zfbPay,\'n2\'): \' \'#' , footerTemplate: '#= uglcw.util.toString(data.zfbPay || 0, \'n2\')#' ">
                    支付宝
                </div>

            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="card-type-tag-template">
    <div style="width: 130px;
            text-overflow: ellipsis;
            white-space: nowrap">
        # for(var idx = 0; idx < values.length; idx++){ #
        #: values[idx].typeName#
        # if(idx < values.length - 1) {# , # } #
        # } #
    </div>
</script>
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

    function loadCardType(){
        $.ajax({
            url:"manager/pos/queryMemberTypeList",
            type:"post",
            success:function(data){
                if(data){
                    var list = data.rows;
                    var objSelect = document.getElementById("cardType");
                   // objSelect.options.add(new Option(''),'');
                    for(var i = 0;i < list.length; i++)
                    {
                        objSelect.options.add( new Option(list[i].typeName,list[i].id));

                    }


                }
            }
        });
    }

    function chooseCardType(id) {

        uglcw.ui.get('#cardType1').value(id);
        uglcw.ui.get('#grid').k().dataSource.read();

    }



</script>
</body>
</html>
