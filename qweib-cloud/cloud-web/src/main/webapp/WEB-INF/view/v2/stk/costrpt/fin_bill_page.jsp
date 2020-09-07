<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>费用单据查询</title>
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
            color: #FF00FF;
            font-weight: bold;
        }

        .row-color-red {
            color: red;
            font-weight: bold;
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
                    <input type="hidden" uglcw-model="costType" value="${costType}" uglcw-role="textbox"/>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}" >
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <c:if test="${empty costType}">
                        <select uglcw-role="combobox" uglcw-model="rptType" placeholder="单据类型" uglcw-options="value:''">
                            <option value="11">报销单据</option>
                            <option value="12">付款单据-未关联报销单</option>
                            <option value="13">报销单-核销单</option>
                            <option value="22">回款单-未关联科目</option>
                            <option value="21">回款单-核销单</option>
                            <option value="23">报损出库</option>
                            <option value="24">借出出库</option>
                            <option value="25">盘盈盘亏</option>
                            <option value="26">销售返利</option>
                            <option value="27">其它出库</option>
                        </select>
                    </c:if>

                    <c:if test="${costType eq 1}">
                    <select uglcw-role="combobox" uglcw-model="rptType" placeholder="单据类型" uglcw-options="value:''">
                        <option value="11">报销单据</option>
                        <option value="12">付款单据-未关联报销单</option>
                    </select>
                    </c:if>
                <c:if test="${costType eq 2}">
                    <select uglcw-role="combobox" uglcw-model="rptType" placeholder="单据类型" uglcw-options="value:''">
                        <option value="13">报销单-核销单</option>
                        <option value="22">回款单-未关联科目</option>
                        <option value="21">回款单-核销单</option>
                        <option value="23">报损出库</option>
                        <option value="24">借出出库</option>
                        <option value="25">盘盈盘亏</option>
                        <option value="26">销售返利</option>
                        <option value="27">其它出库</option>
                    </select>
                </c:if>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="往来单位">
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
                    pageable: true,
                    rowNumber: true,
                    criteria: '.form-horizontal',
                    url: 'manager/queryFinBillPage',
                    dblclick:function(row){
                      showDetail(row.rpt_type,row.bill_id);
                    },
                     loadFilter:{
                        data: function(resp){
                            var rows = resp.rows || [];
                            rows.splice(rows.length - 1, 1);
                            return rows;
                        },
                          aggregates: function (response) {
                        var aggregate = {
                            amt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                     }
                    },
                     aggregate:[
                            {field: 'amt', aggregate: 'sum'}
                         ],
                    criteria: '.form-horizontal'
                    }">
                <div data-field="rpt_type" uglcw-options="width:160,template: uglcw.util.template($('#formatterType').html())">单据类型</div>
                <div data-field="bill_no" uglcw-options="width:160, footerTemplate: '合计'">单据号</div>
                <div data-field="bill_time" uglcw-options="width:160">单据日期</div>
                <div data-field="pro_name" uglcw-options="width:130">往来单位</div>
                <div data-field="amt" uglcw-options="width:100,footerTemplate: '#=data.amt#'">金额</div>

                <c:if test="${costType eq 2}">
                    <div data-field="type_name" uglcw-options="width:130">费用科目</div>
                    <div data-field="item_name" uglcw-options="width:140">明细科目</div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="formatterType">
    #if(data.rpt_type==11){#
    报销单据
    #}else if(data.rpt_type==12){#
    付款单据-未关联报销单
    #}else if(data.rpt_type==13){#
    报销单-核销单
    #}else if(data.rpt_type==21){#
    回款单-核销单
    #}else if(data.rpt_type==22){#
    回款单-未关联科目
    #}else if(data.rpt_type==23){#
    报损出库
    #}else if(data.rpt_type==24){#
    借出出库
    #}else if(data.rpt_type==25){#
    盘盈盘亏
    #}else if(data.rpt_type==26){#
    销售返利
    #}else if(data.rpt_type==27){#
    其它出库
    #}#
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

    function showDetail(rptType,billId) {
        var title="";
        var url = "";
        if(rptType==11){
            title="报销单据";
            url = '${base}manager/showFinCostEdit?billId=' + billId;
        }else if (rptType==12){
            title="付款单据-未关联报销单";
            url = '${base}manager/showFinPayEdit?billId=' + billId;
        }else if (rptType==13){
            title="报销单-核销单";
            url = '${base}manager/showFinPayEdit?billId=' + billId;
        }
        else if (rptType==21){
            title="回款单-核销单";
            url = '${base}manager/showStkpay?outType=1&billId=' + billId;
        }else if (rptType==22){
            title=" 回款单-未关联科目";
            url = '${base}manager/showStkpay?outType=1&billId=' + billId;
        }else if (rptType==23){
            title="报损出库";
            url = '${base}manager/showstkout?billId=' + billId;
        }else if (rptType==24){
            title="借出出库";
            url = '${base}manager/showstkout?billId=' + billId;
        }else if (rptType==25){
            title="盘盈盘亏";
            url = '${base}manager/showStkcheck?billId=' + billId;
        }else if (rptType==26){
            title="销售返利";
            url = '${base}manager/stkRebateOut/show?billId=' + billId;
        }else if (rptType==27){
            title="其它出库";
            url = '${base}manager/showstkout?billId=' + billId;
        }
        uglcw.ui.openTab(title, url);
    }
</script>
</body>
</html>
