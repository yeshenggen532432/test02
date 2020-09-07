<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>利润表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        tr {
            background-color: #FFF;
            height: 30px;
            vertical-align: middle;
            padding: 3px;
        }

        td {
            padding-left: 10px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query">
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" id="sdate" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" id="edate" value="${edate}">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">查询</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full" uglcw-role="resizable" uglcw-options="responsive:['.header', 75]" id="container">
            <table width="600px" border="1"
                   cellpadding="0" cellspacing="1">
                <tr>
                    <td style="font-weight: bold;color: blue;">一.销售毛利</td>
                    <td colspan="2" style="color:${datas["saleMargin"]>0?'blue':'red'}" id="saleMargin">
                        <fmt:formatNumber value='${datas["saleMargin"]}' pattern="#,#00.0#"></fmt:formatNumber></td>
                </tr>
                <tr>
                    <td width="150px">1.产品销售收入</td>
                    <td width="150px">
                        <a  style="color: black" id="saleAmt"
                           onclick="showDetail(1,'')"><fmt:formatNumber
                                value='${datas["saleAmt"]}' pattern="#,#00.0#"/></a>
                    </td>
                    <td>其中门店收入(<span id="saleShopAmt"> ${datas["saleShopAmt"]} </span>)</td>
                </tr>
                <tr>
                    <td>2.产品销售成本</td>
                    <td>
                        <a  style="color: black" id="saleCostAmt"
                           onclick="showDetail(2,'')"><fmt:formatNumber
                                value='${datas["saleCostAmt"]}' pattern="#,#00.0#"/></a>
                    </td>
                    <td>其中门店成本(<span id="saleShopCostAmt">${datas["saleShopCostAmt"]}</span>)</td>
                </tr>
                <tr>
                    <td>3.产品折扣</td>
                    <td>
                        <a  style="color: black" id="saleDiscount"
                           onclick="showDetail(3,'')"><fmt:formatNumber
                                value='${datas["saleDiscount"]}' pattern="#,#00.0#"/></a>
                    </td>
                    <td>其中门店折扣(<span id="saleShopDiscount">${datas["saleShopDiscount"]}</span>)</td>
                </tr>
                <c:set var="costAmtSum" value="0"/>
                <tr>
                    <td style="font-weight: bold;color: blue;">二.费用合计</td>
                    <td colspan="2" style="color:red;"><a  style="color: black"
                                                          onclick="showDetail(4,'')"><span id="costSumAmt"></span></a>
                    </td>
                </tr>
                <c:forEach items="${datas['costOut'] }" var="items" varStatus="s">
                    <tr>
                        <td>${s.index+1 }.${items['type_name'] }</td>
                        <td>
                            <a  style="color: black" id="total_amt"
                               onclick="showDetail(4,${items['type_id'] })"><fmt:formatNumber
                                    value='${items["total_amt"] }' pattern="#,#00.0#"/></a>
                        </td>
                        <c:set var="costAmtSum" value="${costAmtSum+items['total_amt']}"/>
                        <td></td>
                    </tr>
                </c:forEach>
                <script>
                    document.getElementById("costSumAmt").innerHTML = "<fmt:formatNumber value='${costAmtSum}' pattern='#,#00.0#'/>";
                </script>
                <tr>
                    <td style="font-weight: bold;color: blue;">三.其他净收入</td>
                    <td colspan="2" style="color:${(datas["qtSaleMargin"]+datas["qtSlSumAmt"])>0?'blue':'red'}"
                        id="netRevenue">

                        <fmt:formatNumber value='${datas["qtSaleMargin"]+datas["qtSlSumAmt"]}' pattern="#,#00.0#"/></td>
                </tr>
                <tr>
                    <td>1.其它销售收入</td>
                    <td>
                        <a  style="color: black" id="qtSaleAmt"
                           onclick="showDetail(5,'')"><fmt:formatNumber
                                value='${datas["qtSaleAmt"] }' pattern="#,#00.0#"/></a>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>2.其它销售成本</td>
                    <td>
                        <a  style="color: black" id="qtCostAmt" onclick="showDetail(6,'')">
                            <fmt:formatNumber value='${datas["qtCostAmt"] }' pattern="#,#00.0#"/>
                        </a>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>3.其它销售净收入</td>
                    <td id="qtSaleMargin">
                        <fmt:formatNumber value='${datas["qtSaleMargin"]}' pattern="#,#00.0#"/>
                    </td>
                    <td>其它销售收入-其它销售成本</td>
                </tr>
                <tr>
                    <td>4.其他收入项目</td>
                    <td>
                        <a  style="color: black" id="qtSlSumAmt" onclick="showDetail(7,'')">
                            <fmt:formatNumber value='${datas["qtSlSumAmt"] }' pattern="#,#00.0#"/>
                        </a>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td style="font-weight: bold;color: blue;">四.经营毛利</td>

                    <td style="color:${(datas["saleMargin"]+datas["qtSaleMargin"]+datas["qtSlSumAmt"]-costAmtSum)>0?'blue':'red'}"
                        id="costAmtSum">
                        <fmt:formatNumber
                                value='${datas["saleMargin"]+datas["qtSaleMargin"]+datas["qtSlSumAmt"]-costAmtSum}'
                                pattern="#,#00.0#"/>
                    </td>
                    <td>销售收入+其它销售净收入+其他收入项目-费用报销</td>
                </tr>
            </table>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="t">
    <table width="600px" border="1"
           cellpadding="0" cellspacing="1">
        <tr>
            <td style="font-weight: bold;color: blue;">一.销售毛利</td>
            <td colspan="2" style="color:#= (data.saleMargin > 0) ? 'blue': 'red'#">
                #= uglcw.util.toString(data.saleMargin, 'n2')#
            </td>
        </tr>
        <tr>
            <td width="150px">1.产品销售收入</td>
            <td width="150px">
                <a  style="color: black" onclick="showDetail(1,'')">
                    #= uglcw.util.toString(data.saleAmt, 'n2')#</a>
            </td>
            <td>其中门店收入(#= uglcw.util.toString(data.saleShopAmt, 'n2')#)</td>
        </tr>
        <tr>
            <td>2.产品销售成本</td>
            <td>
                <a  style="color: black" onclick="showDetail(2,'')">
                    #= uglcw.util.toString(data.saleCostAmt, 'n2')#</a>
            </td>
            <td>其中门店成本(#= uglcw.util.toString(data.saleShopCostAmt, 'n2')#)</td>
        </tr>
        <tr>
            <td>3.产品折扣</td>
            <td>
                <a  style="color: black" onclick="showDetail(3,'')">
                    #= uglcw.util.toString(data.saleDiscount, 'n2')#</a>
            </td>
            <td>其中门店折扣(#= uglcw.util.toString(data.saleShopDiscount, 'n2')#)</td>
        </tr>
        #var costAmtSum=0;#
        # for(var i=0; i < data.costOut.length; i++){#
            # var item=data.costOut[i]#
            # costAmtSum +=parseFloat(item.total_amt); #
        #}#

        <tr>
            <td style="font-weight: bold;color: blue;">二.费用合计</td>
            <td colspan="2" style="color:red;"><a  style="color: black"
                                                  onclick="showDetail(4,'')"><span>#= uglcw.util.toString(costAmtSum, 'n2')#</span></a>
            </td>
        </tr>
        # for(var i=0; i < data.costOut.length; i++){ #
        # var item=data.costOut[i]#
        <tr>
            <td>#= item.type_name#</td>
            <td>
                <a  style="color: black"
                   onclick="showDetail(4,#= item.type_id#)">
                    #= uglcw.util.toString(item.total_amt, 'n2')#</a>
            </td>
        </tr>
        # } #
        <tr>
            <td style="font-weight: bold;color: blue;">三.其他净收入</td>
            <td colspan="2" style="color:#= data.qtSaleMargin + data.qtSlSumAmt > 0 ? 'blue' : 'red'#">
                #= uglcw.util.toString(data.qtSaleMargin+data.qtSlSumAmt, 'n2')#
            </td>
        </tr>
        <tr>
            <td>1.其它销售收入</td>
            <td>
                <a  style="color: black" onclick="showDetail(5,'')">
                    #= uglcw.util.toString(data.qtSaleAmt, 'n2')#
                </a>
            </td>
            <td></td>
        </tr>
        <tr>
            <td>2.其它销售成本</td>
            <td>
                <a  style="color: black" onclick="showDetail(6,'')">
                    #= uglcw.util.toString(data.qtCostAmt, 'n2')#
                </a>
            </td>
            <td></td>
        </tr>
        <tr>
            <td>3.其它销售净收入</td>
            <td>
                #= uglcw.util.toString(data.qtSaleMargin, 'n2')#
            </td>
            <td>其它销售收入-其它销售成本</td>
        </tr>
        <tr>
            <td>4.其他收入项目</td>
            <td>
                <a  style="color: black" onclick="showDetail(7,'')">
                    #= uglcw.util.toString(data.qtSlSumAmt, 'n2')#
                </a>
            </td>
            <td></td>
        </tr>
        <tr>
            <td style="font-weight: bold;color: blue;">四.经营毛利</td>

            <td style="color:#= (data.saleMargin+data.qtSaleMargin+data.qtSlSumAmt-costAmtSum > 0) ? 'blue':'red'#}">
                #= uglcw.util.toString(data.saleMargin+data.qtSaleMargin+data.qtSlSumAmt-costAmtSum, 'n2')#
            </td>
            <td>销售收入+其它销售净收入+其他收入项目-费用报销</td>
        </tr>
    </table>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/getFinProfitstatistics',
                type: 'get',
                data: uglcw.ui.bind('.uglcw-query'),
                success: function (response) {
                    uglcw.ui.loaded()
                    if (response.code == 0) {
                        uglcw.ui.success('刷新成功')
                        var data = response.data;  //替换页面数据
                        $('#container').html(uglcw.util.template($('#t').html())({data: data}));
                    } else {
                        uglcw.ui.error("刷新失败！")
                    }
                }
            })
        })
        uglcw.ui.loaded()
    })


    function showDetail(type, costType) {
        var sdate = uglcw.ui.get('#sdate').value();
        var edate = uglcw.ui.get('#edate').value();
        var tabName = "";
        //typeId:1 产品销售收入
        //typeId:2 产品销售成本
        //typeId:3 产品折扣
        //typeId:4 费用合计
        //typeId:5 其它销售收入
        //typeId:6 其它销售成本
        //typeId:7 其他收入项目
        if (type == 1) {
            tabName = "产品销售收入";
        } else if (type == 2) {
            tabName = "产品销售成本";
        } else if (type == 3) {
            tabName = "产品折扣";
        } else if (type == 4) {
            tabName = "费用项目";
        } else if (type == 5) {
            tabName = "其它销售收入";
        } else if (type == 6) {
            tabName = "其它销售成本";
        } else if (type == 7) {
            tabName = "其他收入项目";
        }
        uglcw.ui.openTab('利润明细_' + tabName, 'manager/toFinProfitstatisticsItems?sdate=' + sdate + '&edate=' + edate + '&costType=' + costType + '&typeId=' + type);
    }
</script>
</body>
</html>
