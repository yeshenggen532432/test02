<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>明细</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div></div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div class="query">
                <input type="hidden" uglcw-role="textbox" uglcw-model="sdate" id="sdate" value="${sdate}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="edate" id="edate" value="${edate}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="cstId" id="cstId" value="${cstId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="khNm" id="khNm" value="${khNm}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="xsTp" id="xsTp" value="${xsTp}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="wareId" id="wareId" value="${wareId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="isType" id="isType" value="${isType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="wtype" id="wtype" value="${wtype}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="timeType" id="timeType" value="${timeType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="staff" id="staff" value="${staff}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="wareNm" id="wareNm" value="${wareNm}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="saleType" id="saleType" value="${saleType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="showWareCheck" id="showWareCheck" value="${showWareCheck}"/>
            </div>
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    serverAggregates: false,
                    url: '${base}manager/querySumCstStatDetail',
                    dblclick: function(row){
                    	onDblClickRow(row);
                    },
                    dataBound: function(){
                        filterField();
                     },
                    loadFilter:{
                    	data: function(response){
                    		var rows = response.rows || []
                            return rows;
                    	}
                    },
                    criteria: '.query',
                    aggregate:[
                        {field: 'qty', aggregate: 'sum'},
                        {field: 'minQty', aggregate: 'sum'},
                    	{field: 'amt', aggregate:'sum'},
                    	{field: 'outQty', aggregate:'sum'},
                    	{field: 'minOutQty', aggregate:'sum'},
                    	{field: 'outAmt', aggregate:'sum'}
                    ]
                    ">
                <div data-field="billNo" uglcw-options="width:120, tooltip: true">单号</div>
                <div data-field="khNm" uglcw-options="width:120,tooltip: true, footerTemplate: '合计:'">客户名称</div>
                <div data-field="wareNm" uglcw-options="width:120, tooltip: true, editable: false">商品名称</div>
                <div data-field="xsTp" uglcw-options="width:100">销售类型</div>
                <div data-field="unitName" uglcw-options="width:100">计量单位</div>
                <div data-field="price" uglcw-options="width:120, format: '{0:n2}'">销售单价</div>
                <div data-field="qty"
                     uglcw-options="width:120, format: '{0:n2}', aggregates:['sum'], footerTemplate: '#= uglcw.util.toString(sum, \'n2\')#'">
                    销售数量
                </div>
                <div data-field="outQty"
                     uglcw-options="width:120, format: '{0:n2}', aggregates:['sum'], footerTemplate: '#= uglcw.util.toString(sum, \'n2\')#'">
                    发货数量
                </div>
                <div data-field="minUnitName" uglcw-options="width:100">计量单位(小)</div>
                <div data-field="minPrice" uglcw-options="width:120, format: '{0:n2}'">销售单价(小)</div>
                <div data-field="minQty"
                     uglcw-options="width:120,format: '{0:n2}', aggregates:['sum'], footerTemplate: '#= uglcw.util.toString(sum, \'n2\')#'">
                    销售数量(小)
                </div>
                <div data-field="minOutQty"
                     uglcw-options="width:120, format: '{0:n2}', aggregates:['sum'], footerTemplate: '#= uglcw.util.toString(sum, \'n2\')#'">
                    发货数量(小)
                </div>
                <div data-field="amt"
                     uglcw-options="width:120, format: '{0:n2}', aggregates:['sum'], footerTemplate: '#= uglcw.util.toString(sum, \'n2\')#'">
                    销售金额
                </div>
                <div data-field="outAmt"
                     uglcw-options="width:120, format: '{0:n2}', aggregates:['sum'], footerTemplate: '#= uglcw.util.toString(sum, \'n2\')#'">
                    发货金额
                </div>
                <div data-field=""
                >
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/javascript">
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    });

    function onDblClickRow(rowData) {
        if (rowData.xsTp == "销售退货") {
            uglcw.ui.openTab('销售退货开单', 'manager/pcstkthin?orderId=' + rowData.id)
        } else {
            uglcw.ui.openTab('销售信息' + rowData.id, 'manager/showstkout?dataTp=1&billId=' + rowData.id)
        }
    }
    function filterField(){
        var grid = uglcw.ui.get('#grid');
        if('${filterDataType}'==1){
            grid.showColumn('qty');
            grid.showColumn('price');
            grid.showColumn('unitName');
            grid.showColumn('outQty');
            grid.hideColumn('minQty');
            grid.hideColumn('minPrice');
            grid.hideColumn('minUnitName');
            grid.hideColumn('minOutQty');
        }else if('${filterDataType}'==2){
            grid.hideColumn('qty');
            grid.hideColumn('outQty');
            grid.hideColumn('price');
            grid.hideColumn('unitName');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
            grid.showColumn('minPrice');
            grid.showColumn('minUnitName');
        }else if('${filterDataType}'==3){
            grid.showColumn('qty');
            grid.showColumn('price');
            grid.showColumn('unitName');
            grid.showColumn('outQty');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
            grid.showColumn('minPrice');
            grid.showColumn('minUnitName');
        }
    }

</script>
</body>
</html>
