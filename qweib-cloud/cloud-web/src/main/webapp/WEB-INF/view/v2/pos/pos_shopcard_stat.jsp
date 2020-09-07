<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>各分店报表-异店卡统计</title>
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
                            url: 'manager/pos/queryShopCardStat',
                            criteria: '.form-horizontal',

                            }">
                <div data-field="shopNo" uglcw-options="width:120">卡所属门店店号</div>
                <div data-field="shopName" uglcw-options="width:120">卡所属门店店名</div>
                <div data-field="inputCash"
                     uglcw-options="width:100,template: '#= data.inputCash ? uglcw.util.toString(data.inputCash,\'n2\'): \' \'#'">
                    充值金额
                </div>
                <div data-field="oper" uglcw-options="width:100, template: uglcw.util.template($('#oper').html())">操作</div>
            </div>
        </div>
    </div>
</div>
</div>
</div>

<script id="oper" type="text/x-uglcw-template">
    <button onclick="javascript:todetail(#= data.shopNo#,#=data.shopName#);" class="k-button k-info">查看明细</button>
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


    //-----------------------------------------------------------------------
    function todetail(shopNo, shopName) {
        uglcw.ui.openTab(shopName, "${base}manager/toPosShopCardDetail?shopNo=" + shopNo + "&sdate=" + $("#sdate").val() + "&edate=" + $("#edate").val());
    }

</script>
</body>
</html>
