<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户类型--对应客户信息列表</title>
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
                    <input type="hidden" uglcw-model="qdtpNm" value="${qdtpNm}" uglcw-role="textbox">
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <%--表格：头部end--%>

    <%--表格：start--%>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
						    responsive:['.header',40],
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/customerPage',
                    		criteria: '.query',
                    	">
                <div data-field="khCode" uglcw-options="width:80">客户编码</div>
                <div data-field="khNm" uglcw-options="width:150">客户名称</div>
                <div data-field="linkman" uglcw-options="width:100">负责人</div>
                <div data-field="tel" uglcw-options="width:120">负责人电话</div>
                <div data-field="mobile" uglcw-options="width:120">负责人手机</div>
                <div data-field="address" uglcw-options="width:200">地址</div>
                <div data-field="qdtpNm" uglcw-options="width:100">客户类型</div>
                <div data-field="memberNm" uglcw-options="width:100">业务员</div>
                <div data-field="memberMobile" uglcw-options="width:120">业务员手机号</div>
                <div data-field="longitude" uglcw-options="width:100">经度</div>
                <div data-field="latitude" uglcw-options="width:100">纬度</div>
                <%--<div data-field="oper" uglcw-options="width:200, template: uglcw.util.template($('#oper').html())">操作</div>--%>
            </div>
        </div>
    </div>
    <%--表格：end--%>
</div>
<%--2右边：表格end--%>
</div>
</div>

<%--操作--%>
<script id="oper" type="text/x-uglcw-template">
    <a href="javascript:setWarePrice(#= data.id#,'#=data.khdjNm#');"
       style="color: \\#3343a4;font-size: 12px;">设置商品价格<a/>&nbsp;|
        <a href="javascript:showCustomers(#= data.id#,'#=data.khdjNm#');" style="color: \\#3343a4;font-size: 12px;">客户信息列表<a/>
            <%--<button onclick="javascript:setWarePrice(#= data.id#,'#=data.khdjNm#');" class="k-button k-info">设置商品价格</button>--%>
            <%--<button onclick="javascript:showCustomers(#= data.id#,'#=data.khdjNm#');" class="k-button k-info">客户信息列表</button>--%>
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
    function setWarePrice(id, name) {
        uglcw.ui.openTab(name + "_设置商品价格", "${base}manager/toCustomerLevelSetWareTree?levelId=" + id);
    }

    function showCustomers(id, name) {
        uglcw.ui.openTab(name + "_客户信息列表", "${base}manager/toCustomerLevelPage?khdjNm=" + name);
    }


</script>
</body>
</html>
