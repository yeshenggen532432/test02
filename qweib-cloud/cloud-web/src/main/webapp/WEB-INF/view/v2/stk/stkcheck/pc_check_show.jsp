<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>库存盘点</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-grid-toolbar .info{
            display: inline-flex;
            margin-top: 5px;
        }
        .k-grid-toolbar .info .item{
            color: #000;
            margin-left: 10px;
            line-height: 24px;
        }

        .k-grid-toolbar .info .item label:after{
            content: ':';
        }

        .color_class .k-dirty2 {
            margin: 0;
            top: 0;
            left: 0;
        }

        .color_class .k-dirty2 {
            position: absolute;
            width: 0;
            height: 0;
            border-style: solid;
            border-width: 3px;
            border-color: red transparent transparent red;

            padding: 0;
            overflow: hidden;
            vertical-align: top;
        }

        .row-color-blue {
            color: blue !important;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body full">
            <div class="query">
                <input type="hidden" uglcw-role="textbox" uglcw-model="billId" value="${billId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="stkId" value="${stkId}"/>
            </div>
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    loadFilter:{
                        data: function(response){
                            return response.list || [];
                        }
                    },
                     dataBound: function(){
                       			resetData();
                       		},
                    toolbar: kendo.template($('#toolbar').html()),
                    url: '${base}manager/queryCheckSub',
                    criteria: '.query',
                    ">
                <div data-field="wareCode" uglcw-options="width:120,tooltip: true, editable: false">商品编码</div>
                <div data-field="wareNm" uglcw-options="width:120, tooltip: true, editable: false">商品名称</div>
                <div data-field="wareGg" uglcw-options="width:90, editable: false">规格</div>
                <div data-field="stkQty" uglcw-options="width:90, format:'{0:n2}', editable: false">账面数量</div>
                <div data-field="maxQtyFlag" uglcw-options="width:90,hidden:true">大单位修改标示</div>
                <div data-field="minQtyFlag" uglcw-options="width:90,hidden:true">小单位修改标示</div>
                <div data-field="unitName" uglcw-options="width:100, editable: false">大单位</div>
                <div data-field="qty" uglcw-options="width:120,decimals:10,attributes:{class: 'k-dirty-cell maxQtyFlag'}, schema:{type: 'number'}">盘点数(大)
                </div>
                <div data-field="minUnit" uglcw-options="width:100, editable: false">小单位</div>
                <div data-field="minQty" uglcw-options="width:120,decimals:10, attributes:{class: 'k-dirty-cell minQtyFlag'}, schema:{type: 'number'}">
                    盘点数(小)
                </div>
                <div data-field="disQty" uglcw-options="width:90,decimals:10, editable: false">差量</div>
                <div data-field="produceDate" uglcw-options="width: 150">生产日期
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <div class="info">
        <div class="item">
            <label>盘点时间</label>
            <span>${checkTime}</span>
        </div>
        <div class="item">
            <label>盘点仓库</label>
            <span>${stkName}</span>
        </div>
        <div class="item">
            <label>盘点人</label>
            <span>${staff}</span>
        </div>
        <div class="item">
            <label>单据状态</label>
            <span><c:if test="${status eq -2}">
                暂存
            </c:if>
		<c:if test="${status eq 0}">
            已审批
        </c:if>
		<c:if test="${status eq -2}">
            已作废
        </c:if></span>
        </div>

        <div class="item">
            剩余清零：<c:if test="${checkScope eq 1}">是</c:if><c:if test="${checkScope ne 1}">否</c:if>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    });

    function resetData(){
        var data = uglcw.ui.get('#grid').k().dataSource.data();
        var clazz = 'row-color-blue';
        $(data).each(function (i, row) {
            if(row.priceFlag==1){
                $('#grid .k-grid-content tr[data-uid=' + row.uid + '] td.priceFlag').addClass('color_class').prepend("<span class='k-dirty2'></span>");
            }
            if(row.maxQtyFlag==1){
                $('#grid .k-grid-content tr[data-uid=' + row.uid + '] td.maxQtyFlag').addClass('color_class').prepend("<span class='k-dirty2'></span>");
            }
            if(row.minQtyFlag==1){
                $('#grid .k-grid-content tr[data-uid=' + row.uid + '] td.minQtyFlag').addClass('color_class').prepend("<span class='k-dirty2'></span>");
            }

            if(row.appendData == 1){
                $('#grid .k-grid-content tr[data-uid='+row.uid+']').addClass(clazz);
            }

        })
    }
</script>
</body>
</html>
