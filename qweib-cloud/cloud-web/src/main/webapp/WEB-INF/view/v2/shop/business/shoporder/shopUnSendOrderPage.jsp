<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>待发货订单</title>
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
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="status" uglcw-role="textbox" type="hidden" value="2"/>
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="订单号">
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="shopMemberName" placeholder="会员名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="orderZt" placeholder="审核状态">
                        <option value="">--订单状态--</option>
                        <c:forEach items="${orderZtMap}" var="ztMap">
                            <option value="${ztMap.key}">${ztMap.value}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage"
                                 whereBlock="status=1 or status is null"
                                 headerKey="" headerValue="--选择仓库--"
                                 displayKey="id" displayValue="stk_name"/>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="distributionMode" placeholder="配送方式">
                        <option value="0">--配送方式--</option>
                        <option value="1">快递</option>
                        <option value="2">自提</option>


                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
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
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/shopBforder/unSendOrderPage',
                    criteria: '.form-horizontal',
                    pageable: true
                    ">
                <jsp:include page="/WEB-INF/view/v2/include/order_detail_include.jsp"/>

            </div>
        </div>
    </div>
</div>
<%--toolbar--%>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:showProductGroupList();" class="k-button k-button-icontext k-grid-add-other"
       title="按搜索框条件统计商品数量">
        <span class="k-icon k-i-hyperlink"></span>商品统计表
    </a>
    <%--<a role="button" href="javascript:toZf();" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>作废
    </a>
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-delete"></span>删除
    </a>--%>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/shop-bforder.jsp" %>
<%--公用方法转移--%>
<script>
    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid').k();
            var index = grid.options.columns.findIndex(function (column) {
                return column.field == 'count';
            })
            if (checked) {
                grid.showColumn(index)
            } else {
                grid.hideColumn(index);
            }
        })
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
            ;
        })
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })
</script>
</body>
</html>
