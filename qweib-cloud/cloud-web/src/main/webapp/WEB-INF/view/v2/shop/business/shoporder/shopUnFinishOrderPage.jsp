<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>已发货待确认收货订单</title>
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
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="订单号">
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="shopMemberName" placeholder="会员名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="orderZt" placeholder="订单状态" uglcw-options="value: ''">
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
                    <input uglcw-model="sdate" uglcw-role="datepicker">
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
                    editable: true,
                    url: '${base}manager/shopBforder/unFinishOrderPage',
                    criteria: '.form-horizontal',
                    pageable: true
                    ">
                <div data-field="orderNo" uglcw-options="
														  width:190,
														  locked: true,
														  align:'center',
														  template: function(dataItem){
														   return kendo.template($('#orderNo').html())(dataItem);
														  },
                        ">订单号
                </div>
              <%--  <div data-field="orderZt"
                     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#orderZt').html())">订单状态
                </div>--%>
                <%--<div data-field="isPay" uglcw-options="width:100,align:'center',template: uglcw.util.template($('#isPay').html())">付款状态</div>--%>
                <%--<div data-field="payType" uglcw-options="width:100,align:'center',template: uglcw.util.template($('#payType').html())">付款类型</div>--%>
                <%--<div data-field="payTime" uglcw-options="width:100,align:'center'">付款时间</div>--%>
                <%--<div data-field="pszd" uglcw-options="width:100,align:'center'">配送指定</div>--%>
                <%--<div data-field="odtime"
                     uglcw-options="width:160,align:'center',template: uglcw.util.template($('#odtime').html())">下单时间
                </div>--%>
                <div data-field="transportName"
                     uglcw-options="width:120,
                             editor: function(container, options){
                             var model = options.model;
                             var input = $('<input name=\'transportName\' data-bind=\'value:transportName\'/>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.MaskedTextBox(input);
                             widget.init({
                              value: model.transportName,
                              change: function(){
                                updateTransport(this.value(),model,'transportName');
                              }
                             })
                             }"
                >快递名称
                </div>
                <div data-field="transportCode"
                     uglcw-options="width:120,
                             editor: function(container, options){
                             var model = options.model;
                             var input = $('<input name=\'transportCode\' data-bind=\'value:transportCode\'/>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.MaskedTextBox(input);
                             widget.init({
                              value: model.transportCode,
                              change: function(){
                                updateTransport(this.value(),model,'transportCode');
                              }
                             })
                             }"
                >快递号
                </div>
                <jsp:include page="/WEB-INF/view/v2/include/order_detail_include.jsp">
                    <jsp:param name="hideOrder" value="true"/>
                </jsp:include>

            </div>
        </div>
    </div>
</div>
<%--toolbar--%>
<script type="text/x-kendo-template" id="toolbar">
    <%--<a role="button" href="javascript:toZf();" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>作废
    </a>
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-delete"></span>删除
    </a>--%>
    <a role="button" href="javascript:doFinish();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-edit"></span>确认收货
    </a>
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

    //确认收货
    function doFinish() {
        var id = "";
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            id = selection[0].id;
            uglcw.ui.confirm("您确认收货订单记录吗？", function () {
                $.ajax({
                    url: "${base}manager/shopBforder/doFinish",
                    data: {
                        id: id,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response == "1") {
                            uglcw.ui.success("确认收货成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error("确认收货失败");
                        }
                    }
                });
            })
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //修改快递
    function updateTransport(va, model, field) {
        if (va && va.length > 30) {
            uglcw.ui.error("输入内容过长，最多50个字符");
            return false;
        }
        $.ajax({
            url: "${base}manager/shopBforder/updateTransport",
            data: {
                id: model.id,
                value: va,
                field: field
            },
            type: 'post',
            dataType: 'json',
            success: function (response) {
                if (response.state) {
                    model.set(field, va);
                    model.set('dirty', false);
                } else {
                    uglcw.ui.error(response.msg);
                }
            }
        });
    }
</script>
</body>
</html>
