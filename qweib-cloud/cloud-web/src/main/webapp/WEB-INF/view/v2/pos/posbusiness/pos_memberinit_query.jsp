<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>会员余额初始化-初始化记录</title>
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
                        <input type="hidden" id="ioFlag" value="3" uglcw-role="textbox" uglcw-model="ioFlag"/>
                        <div class="form-group" style="margin-bottom: 10px;">
                            <div class="col-xs-3">
                                <select uglcw-role="combobox" uglcw-model="shopNo">
                                    <option value="">连锁店-全部</option>
                                </select>
                            </div>
                            <div class="col-xs-2">
                                <input uglcw-role="textbox" uglcw-model="cstName" placeholder="姓名">
                            </div>
                            <div class="col-xs-2">
                                <input uglcw-role="textbox" uglcw-model="cardNo" placeholder="卡号">
                            </div>
                            <div class="col-xs-2">
                                <input uglcw-role="textbox" uglcw-model="mobile" placeholder="电话">
                            </div>
                            <div class="col-xs-2">
                                <input uglcw-role="textbox" uglcw-model="operator" placeholder="收银员">
                            </div>
                            <div class="col-xs-2">
                                <input uglcw-role="textbox" uglcw-model="cardType" placeholder="卡类型">
                            </div>
                            <div class="col-xs-3">
                                <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                            </div>
                            <div class="col-xs-3">
                                <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                            </div>
                            <div class="col-xs-3">
                                <button id="search" uglcw-role="button" class="k-button k-primary">搜索</button>
                                <button id="reset" class="k-button" uglcw-role="button">重置</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                         <%--loadFilter: {--%>
                             <%--data: function (response) {--%>
                             <%--response.rows.splice( response.rows.length - 1, 1);--%>
                             <%--return response.rows || []--%>
                             <%--},--%>
                             <%--aggregates: function (response) {--%>
                             <%--var aggregate = {};--%>
                             <%--if (response.rows && response.rows.length > 0) {--%>
                                <%--aggregate = response.rows[response.rows.length - 1]--%>
                             <%--}--%>
                             <%--return aggregate;--%>
                            <%--}--%>
                         <%--},--%>
                         <%--toolbar: kendo.template($('#toolbar').html()),--%>
                         id:'id',
                         url: '${base}manager/pos/queryPosMemberIo',
                         criteria: '.form-horizontal',
                        <%--query: function(param){--%>
                            <%--param.edate+=' 23:59:00';--%>
                            <%--return param;--%>
                        <%--},--%>
                        <%--aggregate:[--%>
                         <%--{field: 'totalAmt', aggregate: 'SUM'},--%>
                         <%--{field: 'freeAmt', aggregate: 'SUM'},--%>
                         <%--{field: 'needPay', aggregate: 'SUM'},--%>
                         <%--{field: 'cashPay', aggregate: 'SUM'}--%>
                        <%--],--%>
                        }">
                        <%--<div data-field="inDate" uglcw-options="--%>
                        <%--width:50, selectable: true, type: 'checkbox', locked: true,--%>
                        <%--headerAttributes: {'class': 'uglcw-grid-checkbox'}--%>
                        <%--"></div>--%>

                        <div data-field="ioTimeStr" uglcw-options="width:150">时间</div>
                        <div data-field="cardNo" uglcw-options="width:120">卡号</div>
                        <div data-field="typeName" uglcw-options="width:100">卡类型</div>
                        <div data-field="inputCash"
                             uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.inputCash,\'n2\')#'">
                            充值金额
                        </div>
                        <div data-field="freeCost"
                             uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.freeCost,\'n2\')#'">
                            赠送金额
                        </div>
                        <div data-field="leftAmt"
                             uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.leftAmt,\'n2\')#'">
                            余额
                        </div>
                        <div data-field="operator" uglcw-options="width:100">收银员</div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:myexport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-zoom"></span>导出
    </a>

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
            var padding = 55;
            var height = $(window).height() - padding - $('.header').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }


</script>
</body>
</html>
