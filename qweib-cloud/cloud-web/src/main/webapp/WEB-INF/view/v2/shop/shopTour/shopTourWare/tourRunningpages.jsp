<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>执行中的拼团商品列表</title>
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
            <ul class="uglcw-query query">
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker">
                </li>
                <li>
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="拼团名称">
                </li>
                <li>
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="商品名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="拼团状态"
                            uglcw-options="value:''">
                        <option value="">全部</option>
                        <option value="1">拼团中</option>
                        <option value="2">已完成</option>
                    </select>
                </li>
                <li>
                    <button uglcw-role="button" class="k-info" id="search">搜索</button>
                    <button uglcw-role="button" id="reset">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                            <%--toolbar: kendo.template($('#toolbar').html()),--%>
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/shopTourWare/runningpages',
                    		criteria: '.query',
                    	">
                <div data-field="name" uglcw-options="width:150">拼团名称</div>
                <div data-field="wareNm" uglcw-options="width:150">商品名称</div>
                <div data-field="unitName" uglcw-options="width:60">单位</div>
                <div data-field="shopPrice" uglcw-options="width:80">商城原价</div>
                <div data-field="price"
                     uglcw-options="width: 80">
                    拼团价
                </div>
                <div data-field="count"
                     uglcw-options="width: 70, template: uglcw.util.template($('#tpl_count').html())">拼团人数
                </div>
                <%--<div data-field="hasCount"--%>
                     <%--uglcw-options="width: 70">已拼人数--%>
                <%--</div>--%>
                <div data-field="hasCount"
                     uglcw-options="width: 70,template: uglcw.util.template($('#tpl_has_sale_qty').html())">已购数量
                </div>
                <div data-field="limitQty"
                     uglcw-options="width: 80">限购数量
                </div>
                <div data-field="startTime" uglcw-options="width:120">开始时间</div>
                <div data-field="endTime" uglcw-options="width:120">结束时间</div>
                <div data-field="planName"
                     uglcw-options="width: 100">拼团方案
                </div>
                <div data-field="status" uglcw-options="width:100, template: uglcw.util.template($('#status_tpl').html())">
                    拼团状态
                </div>
                <div data-field="orderCd"
                     uglcw-options="width: 50">排序
                </div>
            </div>
        </div>
    </div>
</div>

<script id="status_tpl" type="text/x-uglcw-template">
    # if(data.status == '1'){ #
   拼团中
    # }else if(data.status == '0'){ #
   未开始
    # }else if(data.status == '2'){ #
    已完成
    # } #
</script>
<script id="tpl_count" type="text/x-uglcw-template">
    <span>#=data.hasCount+"/"+data.count  #</span>
</script>

<script id="tpl_has_sale_qty" type="text/x-kendo-template">
    <a href="javascript:showOrders(#= data.id#);" style="color:red;font-size: 12px; font-weight: bold;">#=
        data.hasCount#</a>
</script>
<%--启用操作--%>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>


    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        //resize();
        //$(window).resize(resize);
        uglcw.ui.loaded();
    })
    function showOrders(id) {
        uglcw.ui.openTab('拼团订单列表', '${base}manager/shopBforder/toPage?orderType=2&promotionId='+ id);
    }
</script>

</body>
</html>
