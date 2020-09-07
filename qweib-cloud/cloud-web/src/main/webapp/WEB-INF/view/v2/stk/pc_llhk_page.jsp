<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>生产领料</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="textbox" uglcw-role="textbox" uglcw-model="orderNo" placeholder="单号"/>
                </li>
                <li>
                    <input type="textbox" uglcw-role="textbox" uglcw-model="proName" placeholder="车间"/>
                    <span style="display: none;">
                        <select uglcw-model="inType" uglcw-role="combobox" id="inType">
                            <option value="领料回库">全部</option>
                        </select>
                    </span>
                </li>
                <li>
                    <select uglcw-model="billStatus" uglcw-options="value: ''" placeholder="单据状态" uglcw-role="combobox"
                            id="status">
                        <option value="暂存" selected>暂存</option>
                        <option value="已收货">已收货</option>
                        <option value="作废">作废</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input uglcw-model="epCustomerName" uglcw-role="textbox" placeholder="商品名称">
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>
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
                 uglcw-options="
                        responsive:['.header',40],
                        id:'id',
                        dblclick: function(row){
                          showDetail(row.id);
                        },
                        url: '${base}manager/stkLlhkPage',
                        criteria: '.query',
                        pageable: true
                    ">
                <div data-field="billNo" uglcw-options="width:200, template: uglcw.util.template($('#bill-no').html())">单号
                </div>
                <div data-field="inDate" uglcw-options="width:140">单据日期</div>
                <div data-field="inType" uglcw-options="width:100">入库类型</div>
                <div data-field="proName" uglcw-options="width:120">车间</div>
                <div data-field="count"
                     uglcw-options="width:450, hidden: true, template: uglcw.util.template($('#product-tpl').html()) ">商品信息
                </div>
                <div data-field="billStatus" uglcw-options="width:120">状态</div>
                <div data-field="remarks" uglcw-options="width:150, tooltip:true">备注</div>
            </div>
        </div>
    </div>
</div>
<script id="bill-no" type="text/x-uglcw-template">
    <a href="javascript:showDetail(#= data.id#);" <%--style="color: \\#3343a4;font-size: 12px; font-weight: bold;"--%>>#=
        data.billNo#</a>
</script>
<script id="product-tpl" type="text/x-uglcw-template">
    <table class="product-grid" style="border-bottom:1px \\#3343a4 solid;padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 60px;">数量</td>
        </tr>
        #var list = data.list#
        #for (var i=0; i< list.length; i++) { #
        <tr>
            <td>#= list[i].wareNm #</td>
            <td>#= list[i].unitName #</td>
            <td>#= list[i].wareGg #</td>
            <td>#= list[i].qty #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('count');
            } else {
                grid.hideColumn('count');
            }
        });

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })


        uglcw.ui.loaded()
    })


    function showDetail(id) {
        uglcw.ui.openTab('领料回库单信息' + id, '${base}manager/showStkLlhkIn?dataTp=1&billId=' + id)
    }
</script>
</body>
</html>
