<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户等级商品价格设置-客户等级列表</title>
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
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="khdjNm" uglcw-role="textbox" placeholder="客户等级名称">
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
							pageable: true,
                    		url: '${base}manager/toKhlevelPage',
                    		criteria: '.query',
                    	">
                <div data-field="qdtpNm" uglcw-options="width:100">客户类型名称</div>
                <div data-field="khdjNm" uglcw-options="width:100">客户等级名称</div>
                <div data-field="oper" uglcw-options="width:300, template: uglcw.util.template($('#oper').html())">操作</div>
            </div>
        </div>
    </div>
</div>

<%--操作--%>
<script id="oper" type="text/x-uglcw-template">
    <a href="javascript:setWareTypeRate(#= data.id#,'#=data.khdjNm#');" style="color: \\#3343a4;font-size: 12px;">设置商品类别价格折扣率<a/>&nbsp;|
        <a href="javascript:setWarePrice(#= data.id#,'#=data.khdjNm#');" style="color: \\#3343a4;font-size: 12px;">设置商品价格<a/>&nbsp;|
            <a href="javascript:showCustomers(#= data.id#,'#=data.khdjNm#');" style="color: \\#3343a4;font-size: 12px;">客户信息列表<a/>
</script>

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

        uglcw.ui.loaded();
    })

    //===============================================================================================
    function setWareTypeRate(id, name) {
        uglcw.ui.openTab(name + "_设置商品类别折扣率", "${base}manager/customerlevelratewaretype?_sticky=v2&relaId=" + id);
    }

    function setWarePrice(id, name) {
        uglcw.ui.openTab(name + "_设置商品价格", "${base}manager/toCustomerLevelSetWareTree?_sticky=v2&levelId=" + id);
    }

    function showCustomers(id, name) {
        uglcw.ui.openTab(name + "_客户信息列表", "${base}manager/toCustomerLevelPage?khdjNm=" + name);

    }


</script>
</body>
</html>
