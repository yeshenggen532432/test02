<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>出库明细表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body full">
            <div class="query">
                <input type="hidden" uglcw-role="textbox" uglcw-model="sdate" value="${sdate}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="edate" value="${edate}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="stkId" value="${stkId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="wareId" value="${wareId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="khNm" value="${khNm}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="timeType" value="${timeType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="xsTp" value="${xsTp}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="outType" value="${outType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="ioType" value="1"/>
            </div>
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    url: '${base}manager/stkOutSubDetailPage',
                    responsive:['.header',40],
                    pageable: {
                        pageSizes: [20,40,50,100,200,500]
                    },
                    dblclick: function(row){
                    	showBill(row);
                    },
                       dataBound: function(){
                        filterField();
                     },
                    loadFilter:{
                    	data: function(response){
                    		var rows = response.rows || []
                    		rows.splice(rows.length - 1, 1);
                    		$.map(rows, function(row){
                    			row.price  = row.outQty == 0 ? 0 : row.outAmt / row.outQty;
                    			row.minPrice = row.minOutQty==0?0:row.outAmt/row.minOutQty;
                    		})
                            return rows;
                    	},
                    	aggregates: function(response){
                    		var aggregate = {
                    			amt: 0,
                    			outQty: 0
                    		};
                    		if (response.rows && response.rows.length > 0) {
                           		 aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1]);
                       		}
                        	return aggregate;
                    	}
                    },
                    criteria: '.query',
                    aggregate:[
                    	{field: 'amt', aggregate:'SUM'},
                    	{field: 'outQty', aggregate:'SUM'}
                    ]
                    ">
                <div data-field="billNo" uglcw-options="width:120,tooltip: true, footerTemplate: '合计:'">单号</div>
                <div data-field="wareNm" uglcw-options="width:120, tooltip: true, editable: false">商品名称</div>
                <div data-field="billName" uglcw-options="width:90, editable: false">销售类型</div>
                <div data-field="unitName" uglcw-options="width:100, editable: false">单位</div>
                <div data-field="outQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty, \'n2\')#'">
                    发货数量
                </div>
                <c:if test="${permission:checkUserFieldPdm('stk.wareOutStat.showprice')}">
                    <div data-field="price" uglcw-options="width:120, format: '{0:n2}'">单价</div>
                </c:if>
                <div data-field="minUnitName" uglcw-options="width:100, editable: false">单位(小)</div>
                <div data-field="minOutQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minOutQty, \'n2\')#'">
                    发货数量(小)
                </div>
                <c:if test="${permission:checkUserFieldPdm('stk.wareOutStat.showprice')}">
                    <div data-field="minPrice" uglcw-options="width:120, format: '{0:n2}'">单价(小)</div>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.wareOutStat.showamt')}">
                    <div data-field="outAmt"
                         uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt, \'n2\')#'">
                        发货金额
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    });

    function showBill(row) {
        var billName = row.billName;
        if ('销售出库' === billName) {
            uglcw.ui.openTab('销售出库详细' + row.billId, '${base}manager/showstkout?dataTp=1&billId=' + row.billId);
        }else if('其它出库' === billName){
            uglcw.ui.openTab('其它出库详细' + row.billId, '${base}manager/showstkout?dataTp=1&billId=' + row.billId);
        }else if('报损出库' === billName){
            uglcw.ui.openTab('报损出库详细' + row.billId, '${base}manager/showstkout?dataTp=1&billId=' + row.billId);
        }else if('借出出库' === billName){
            uglcw.ui.openTab('借出出库详细' + row.billId, '${base}manager/showstkout?dataTp=1&billId=' + row.billId);
        }else if('领用出库' === billName){
            uglcw.ui.openTab('领用出库详细' + row.billId, '${base}manager/showstkout?dataTp=1&billId=' + row.billId);
        }else if('移库出库' === billName){
            uglcw.ui.openTab('移库出库详细' + row.billId, '${base}manager/stkMove/show?billId=' + row.billId);
        }else if('拆卸出库' === billName){
            uglcw.ui.openTab('拆卸出库详细' + row.billId, '${base}manager/stkZzcx/show?billId=' + row.billId);
        }else if('组装出库' === billName){
            uglcw.ui.openTab('组装出库详细' + row.billId, '${base}manager/stkZzcx/show?billId=' + row.billId);
        }else if('领料出库' === billName){
            uglcw.ui.openTab('领用出库详细' + row.billId, '${base}manager/stkPickup/show?billId=' + row.billId);
        }else if('盘亏' === billName){
            uglcw.ui.openTab('盘亏出库详细' + row.billId, '${base}manager/showStkcheck?billId=' + row.billId);
        }
    }

    function filterField(){
        var grid = uglcw.ui.get('#grid');
        if('${filterDataType}'==1){
            grid.showColumn('unitName');
            grid.showColumn('outQty');
            grid.showColumn('price');
            grid.hideColumn('minUnitName');
            grid.hideColumn('minOutQty');
            grid.hideColumn('minPrice');
        }else if('${filterDataType}'==2){
            grid.hideColumn('unitName');
            grid.hideColumn('outQty');
            grid.hideColumn('price');
            grid.showColumn('minUnitName');
            grid.showColumn('minOutQty');
            grid.showColumn('minPrice');
        }else if('${filterDataType}'==3){
            grid.showColumn('unitName');
            grid.showColumn('outQty');
            grid.showColumn('price');
            grid.showColumn('minUnitName');
            grid.showColumn('minOutQty');
            grid.showColumn('minPrice');
        }
    }

</script>
</body>
</html>
