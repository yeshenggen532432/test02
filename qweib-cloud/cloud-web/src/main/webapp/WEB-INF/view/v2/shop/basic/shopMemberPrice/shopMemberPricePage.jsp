<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员价格设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .xxzf-more {
            font-size: 8px;
            color: red;
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
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="会员名称">
                </li>
                <li>
                    <input uglcw-model="mobile" uglcw-role="textbox" placeholder="手机号">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li style="width:300px;margin-top: 10px;">仅设置关闭进销存价格关联的客户会员</li>
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
                    		url: '${base}manager/shopMemberPrice/shopMemberPricePage?source=3',
                    		criteria: '.query',
                    	">
                <div data-field="name" uglcw-options="width:100">会员名称</div>
                <div data-field="oper" uglcw-options="width:130, template: uglcw.util.template($('#oper').html())">操作</div>
                <div data-field="mobile" uglcw-options="width:100">电话</div>
                <div data-field="customerName" uglcw-options="width:100">关联客户</div>
                <div data-field="status" uglcw-options="width:100, template: uglcw.util.template($('#status').html())">状态
                </div>
                <div data-field="defaultAddress" uglcw-options="width:100">收货地址</div>
                <div data-field="pic" uglcw-options="width:100, template: uglcw.util.template($('#pic').html())">微信头像</div>
                <div data-field="nickname" uglcw-options="width:100">微信昵称</div>
                <div data-field="sex" uglcw-options="width:100">性别</div>
                <div data-field="country" uglcw-options="width:100">国家</div>
                <div data-field="province" uglcw-options="width:100">省份</div>
                <div data-field="city" uglcw-options="width:100">城市</div>
            </div>
        </div>
    </div>
</div>

<%--启用状态--%>
<script id="status" type="text/x-uglcw-template">
    <span>#= data.status == '1' ? '已启用' : '未启用' #</span>
</script>
<%--操作--%>
<script id="oper" type="text/x-uglcw-template">
    <button onclick="javascript:setPrice(#= data.id#,'#=data.name#');" class="k-button k-info">设置商品价格</button>
</script>

<%--微信头像--%>
<script id="pic" type="text/x-uglcw-template">
    # if(data.pic != ""){ #
    <img src="#=data.pic#" style="width:30px;height: 30px;align: middle;"/>
    # } #
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


    //-----------------------------------------------------------------------------------------
    //设置商品价格
    function setPrice(id, name) {
        uglcw.ui.openTab(name+"_会员价格设置", "${base}manager/shopMemberPrice/shopMemberPriceWareType?_sticky=v2&shopMemberId=" + id);
    }

</script>
</body>
</html>
