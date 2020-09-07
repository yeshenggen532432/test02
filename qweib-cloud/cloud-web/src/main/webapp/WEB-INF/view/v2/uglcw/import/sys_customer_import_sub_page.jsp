<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户信息导入-客户明细</title>
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
                    <div class="form-horizontal">
                        <div class="form-group" style="margin-bottom: 10px;">
                            <input type="hidden" uglcw-model="khTp" value="2" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="isDb" value="2" uglcw-role="textbox">
                            <div class="col-xs-4">
                                <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                            </div>
                            <div class="col-xs-4">
                                <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员">
                            </div>
                            <div class="col-xs-4">
                                <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                                <button id="reset" class="k-button" uglcw-role="button">重置</button>
                            </div>
                            <%--<div class="col-xs-4">--%>
                                <%--<select uglcw-role="combobox" uglcw-model="客户类型" placeholder="客户类型">--%>
                                    <%--<option value="">--订单状态--</option>--%>
                                    <%--<option value="审核">审核</option>--%>
                                    <%--<option value="未审核">未审核</option>--%>
                                    <%--<option value="已作废">已作废</option>--%>
                                <%--</select>--%>
                            <%--</div>--%>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                    <%--toolbar: kendo.template($('#toolbar').html()),--%>
                    id:'id',
                    <%--checkbox: true,--%>
                    url: '${base}manager/sysCustomerImportMain/subPage?mastId=${mastId}',
                    criteria: '.form-horizontal',
                    pageable: true
                    ">
                        <div data-field="khCode" uglcw-options="width:80">客户编码</div>
                        <div data-field="khNm" uglcw-options="width:150">客户名称</div>
                        <div data-field="linkman" uglcw-options="width:100">负责人</div>
                        <div data-field="tel" uglcw-options="width:130">负责人电话</div>
                        <div data-field="mobile" uglcw-options="width:130">负责人手机</div>
                        <div data-field="address" uglcw-options="width:200">地址</div>
                        <div data-field="qdtpNm" uglcw-options="width:80">客户类型</div>
                        <div data-field="memberNm" uglcw-options="width:100">业务员</div>
                        <div data-field="memberMobile" uglcw-options="width:130">业务员手机号</div>
                        <div data-field="longitude" uglcw-options="width:100">经度</div>
                        <div data-field="latitude" uglcw-options="width:100">纬度</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();;
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })

        resize();
        $(window).resize(resize)
        uglcw.ui.loaded()
    })

    var delay;
    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - $('.k-grid-toolbar').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }


</script>
</body>
</html>
