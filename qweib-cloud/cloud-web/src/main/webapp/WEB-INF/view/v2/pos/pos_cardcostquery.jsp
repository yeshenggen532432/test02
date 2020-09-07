<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>各分店报表-扣款查询</title>
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
                    url: 'manager/pos/sumCardCostPage',
                    criteria: '.form-horizontal',
                     aggregate:[
                     {field: 'costQty', aggregate: 'sum'},
                     {field: 'costAmt', aggregate: 'sum'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
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
                            costQty:0,
                            costAmt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     }


                    }">
                <div data-field="cardNo" uglcw-options="width:100">卡号</div>
                <div data-field="typeName" uglcw-options="width:100">卡类型</div>
                <div data-field="cstName" uglcw-options="width:100">姓名</div>
                <div data-field="mobile" uglcw-options="width:120">电话</div>

                <div data-field="costQty" uglcw-options="width:100,template: uglcw.util.template($('#formatterqty').html())  , footerTemplate: '#= uglcw.util.toString(data.costQty || 0, \'n2\')#'">消费次数</div>

                <div data-field="costAmt"
                     uglcw-options="width:100,template: '#= data.costAmt ? uglcw.util.toString(data.costAmt,\'n2\'): \' \'#' , footerTemplate: '#= uglcw.util.toString(data.costAmt || 0, \'n2\')#' ">
                    消费金额
                </div>

                <div data-field="status" uglcw-options="width:100,template: uglcw.util.template($('#formatterSt3').html())">
                    操作
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%--数量--%>
<script id="formatterqty" type="text/x-uglcw-template">
    # if(data.costQty > 1){ #
    <u style="color:blue"  onclick="javascript:todetail(#= data.cardId#);"> #=data.costQty # </u>
    # }else{ #
    #=data.costQty #
    # } #
</script>
<%--启用状态--%>
<script id="formatterSt3" type="text/x-uglcw-template">

    <button onclick="javascript:todetail(#= data.cardId#);" class="k-button k-info">查看明细</button>

</script>
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
    });

    function todetail(id) {
        var q = uglcw.ui.bind('.uglcw-query');
        var sdate = q.sdate;
        var edate = q.edate;
        var operator = q.operator;
        var shopNo = q.shopNo;


        uglcw.ui.openTab('会员消费明细', '${base}manager/pos/toPosCardCostDetail?cardId=' + id + '&sdate=' + sdate + '&edate=' + edate + '&operator=' + operator
            +'&shopNo=' + shopNo );

    }


</script>
</body>
</html>
