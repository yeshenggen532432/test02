<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
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
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="billStatus" value="未付" uglcw-role="textbox">
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="报销单号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" value="${proName}" placeholder="报销对象">
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
                     dblclick: function(row){
                        uglcw.ui.openTab('费用报销'+row.id,'${base}manager/showFinCostEdit?billId='+row.id);
                     },
                      responsive:['.header',40],
                    id:'id',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.form-horizontal',
                    url: 'manager/queryFinCostToPayPage',
                    criteria: '.form-horizontal'
                    }">
                <div data-field="billNo" uglcw-options="width:160">单号</div>
                <div data-field="costTimeStr" uglcw-options="width:140">费用日期</div>
                <div data-field="proName" uglcw-options="width:140">报销对象</div>
                <div data-field="totalAmt" uglcw-options="width:100">报销金额</div>
                <div data-field="operator" uglcw-options="width:100">经办人</div>
                <div data-field="count"
                     uglcw-options="width:200,template: function(data){
                            return kendo.template($('#formatterSt').html())(data.list);
                         }">科目信息
                </div>
                <div data-field="remarks" uglcw-options="width:140">备注</div>
            </div>
        </div>
    </div>
</div>
<script id="formatterSt" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">明细科目名称</td>
            <td style="width: 5px;">报销金额</td>
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
