<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员余额列表</title>
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
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="会员名称">
                </li>
                <li>
                    <input uglcw-model="mobile" uglcw-role="textbox" placeholder="手机号">
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
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/shopMember/page?opeCount=1',
                    		criteria: '.query',
                    		dblclick:dblclick,

                    	">
                <div data-field="name" uglcw-options="width:100,align:'center'">会员名称</div>
                <div data-field="mobile" uglcw-options="width:120,align:'center'">电话</div>
                <div data-field="inputCash" uglcw-options="width:100,align:'center'">充值金额</div>
                <div data-field="freeCost" uglcw-options="width:100,align:'center'">赠送金额</div>
                <div data-field="sumAmount"
                     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#sumAmount').html())">总余额
                </div>
                <div data-field="sumInput" uglcw-options="width:100,align:'center'">总充值</div>
                <div data-field="sumCost" uglcw-options="width:100,align:'center'">总消费</div>
            </div>
        </div>
    </div>
</div>

<%--总余额--%>
<script id="sumAmount" type="text/x-uglcw-template">
    # var inputCash = data.inputCash; #
    # var freeCost = data.freeCost; #
    # var sumAmount = 0; #
    # if(inputCash != null && inputCash != undefined && inputCash != 'undefined' && inputCash != ''){ #
    #    sumAmount += parseFloat(inputCash); #
    # } #
    # if(freeCost != null && freeCost != undefined && freeCost != 'undefined' && freeCost != ''){ #
    #    sumAmount += parseFloat(freeCost); #
    # } #
    <span>#= sumAmount #</span>
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
    //双击事件
    function dblclick(data) {
        var mId = data.memId;
        var name = data.name;
        var url = "${base}manager/shopMemberIo/toShopMemberBalanceDetailPage?mId=" + mId;
        uglcw.ui.openTab(name + '_会员余额明细', url)
    }


</script>
</body>
</html>
