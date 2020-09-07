<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>往来还款单据列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input type="hidden" uglcw-model="isNeedPay" value="0" uglcw-role="textbox">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="itemName" value="${itemName}" placeholder="明细科目名称">
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
                     dblclick:function(row){
                       uglcw.ui.openTab('往来借入'+row.id, '${base}manager/showFinInEdit?_sticky=v2&billId='+ row.id+$.map( function(v, k){  //只带id
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    responsive:['.header',40],
                    id:'id',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.form-horizontal',
                     loadFilter: {
                         data: function (response) {
                         response.rows.splice( response.rows.length - 1, 1);
                         return response.rows || []
                       },
                       aggregates: function (response) {
                         var aggregate = {};
                       if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                       }
                        return aggregate;
                       }
                     },
                    url: 'manager/queryFinInForReturnPage',
                    criteria: '.form-horizontal',
                    aggregate:[
                     {field: 'needPay', aggregate: 'SUM'}
                    ]
                    }">
                <div data-field="billNo" uglcw-options="width:160,footerTemplate: '合计'">借入单号</div>
                <div data-field="billTimeStr" uglcw-options="width:140">单据日期</div>
                <div data-field="proName" uglcw-options="width:120,tooltip: true ">往来单位</div>
                <div data-field="accName" uglcw-options="width:140">账户名称</div>
                <div data-field="totalAmt" uglcw-options="width:100">借款金额</div>
                <div data-field="needPay"
                     uglcw-options="width:100,footerTemplate:'#= uglcw.util.toString(data.needPay,\'n2\')#'">
                    未还款金额
                </div>
                <div data-field="payAmt" uglcw-options="width:100">已还金额</div>
                <div data-field="freeAmt" uglcw-options="width:100">核销金额</div>
                <div data-field="itemId" uglcw-options="hidden:true,width:100">科目ID</div>
                <div data-field="itemName" uglcw-options="hidden:true,width:100">科目名称</div>
                <div data-field="count"
                     uglcw-options="width:200,template: function(data){
                            return kendo.template($('#formatterSt').html())(data.list);
                         }">科目信息
                </div>

                <div data-field="remarks" uglcw-options="width:120">备注</div>
            </div>
        </div>
    </div>
</div>
<script id="formatterSt" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">明细科目名称</td>
            <td style="width: 5px;">借入金额</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].itemName #</td>
            <td>#= data[i].amt #</td>
        </tr>
        # }#
        </tbody>
    </table>
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
</script>
</body>
</html>
