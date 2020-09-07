<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员类型价格设置-会员列表</title>
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
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <tag:select2 name="shopNo" id="shopNo" tableName="pos_shopinfo" headerKey=""
                                         headerValue="全部" displayKey="shop_no" displayValue="shop_name"/>
                        </li>
                        <li>
                            <input uglcw-model="cstName" uglcw-role="textbox" placeholder="姓名">

                        </li>
                        <li>
                            <input uglcw-model="cardNo" uglcw-role="textbox" placeholder="卡号">

                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="mobile" placeholder="电话">

                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="status" placeholder="状态">
                                <option value="-2">全部</option>
                                <option value="1">正常</option>
                                <option value="0">挂失</option>
                            </select>

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
                    <%--toolbar: kendo.template($('#toolbar').html()),--%>
                        id:'id',
                        checkbox: true,
                        url: 'manager/pos/queryMemberPage?cardType=${memberType}',
                        criteria: '.form-horizontal',
                        pageable: true
                    ">
                        <div data-field="name" uglcw-options="width:100">会员名称</div>
                        <div data-field="cardNo" uglcw-options="width:100">卡号</div>
                        <div data-field="mobile" uglcw-options="width:130">电话</div>
                        <div data-field="typeName" uglcw-options="width:100">会员类型</div>
                        <div data-field="inputCash"
                             uglcw-options="width:100,template: uglcw.util.template($('#inputCash').html())">剩余金额
                        </div>
                        <div data-field="freeCost" uglcw-options="width:100">剩余赠送</div>
                        <div data-field="status"
                             uglcw-options="width:100,template: uglcw.util.template($('#status').html())">状态
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%--toolbar--%>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toZf();" class="k-button k-button-icontext">
        <span class="k-icon k-i-minus"></span>作废
    </a>
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-delete"></span>删除
    </a>
</script>
<script id="status" type="text/x-uglcw-template">
    # if(data.status == -1){ #
    退卡
    # }else if(data.status == 0){ #
    挂失
    # }else {#
    正常
    # } #
</script>
<script id="inputCash" type="text/x-uglcw-template">
    # if(data.inputCash == "0E-7"){ #
    <span>0.00</span>
    # }else if(data.inputCash != null){#
    <span>#= data.inputCash #</span>
    # } #
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();

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
