<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>入库明细</title>
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
                <input type="hidden" uglcw-role="textbox" uglcw-model="proId" value="${proId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="inType" value="${inType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="wareId" value="${wareId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="timeType" value="${timeType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="memberNm" value="${memberNm}"/>
            </div>
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    url: '${base}manager/stkInSubPage',
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
                    			row.price  = row.inQty == 0 ? 0 : row.inAmt / row.inQty;
                    			row.minPrice  = row.minInQty == 0 ? 0 : row.inAmt / row.minInQty

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
                <div data-field="proName" uglcw-options="width:120, tooltip: true">往来单位</div>
                <div data-field="billNo" uglcw-options="width:140,tooltip: true, footerTemplate: '合计:'">单号</div>
                <div data-field="wareNm" uglcw-options="width:120, tooltip: true, editable: false">商品名称</div>
                <div data-field="unitName" uglcw-options="width:100">单位</div>
                <div data-field="qty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.qty, \'n2\')#'">
                    单据数量
                </div>
                <div data-field="inQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.inQty, \'n2\')#'">
                    收货数量
                </div>
                <c:if test="${permission:checkUserFieldPdm('stk.wareInStat.showprice')}">
                    <div data-field="price" uglcw-options="width:120, format: '{0:n2}'">单价</div>
                </c:if>
                <div data-field="minQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minQty, \'n2\')#'">
                    单据数量(小)
                </div>
                <div data-field="minInQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minInQty, \'n2\')#'">
                    收货数量(小)
                </div>
                <c:if test="${permission:checkUserFieldPdm('stk.wareInStat.showprice')}">
                    <div data-field="minPrice" uglcw-options="width:120, format: '{0:n2}'">单价(小)</div>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.wareInStat.showamt')}">
                    <div data-field="inAmt"
                         uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.inAmt, \'n2\')#'">
                        收货金额
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
        if ('销售退货'.indexOf(billName) !== -1) {
            uglcw.ui.openTab('销售出库详细' + row.billId, '${base}manager/showstkin?dataTp=1&billId=' + row.billId);
        } else if ('采购退货'.indexOf(billName) !== -1) {
            uglcw.ui.openTab('采购退货详细' + row.billId, '${base}manager/showstkin?dataTp=1&billId=' + row.billId);
        } else if ('其它入库' === billName) {
            uglcw.ui.openTab('其它入库详细' + row.billId, '${base}manager/showstkin?dataTp=1&billId=' + row.billId);
        } else if ('采购入库' === billName) {
            uglcw.ui.openTab('采购入库详细' + row.billId, '${base}manager/showstkin?dataTp=1&billId=' + row.billId);
        }else if ('移库入库' === billName) {
            uglcw.ui.openTab('移库入库详细' + row.billId, '${base}manager/stkMove/show?billId=' + row.billId);
        } else if ('拆卸入库' === billName) {
            uglcw.ui.openTab('拆卸入库详细' + row.billId, '${base}manager/stkZzcx/show?billId=' + row.billId);
        } else if ('组装入库' === billName) {
            uglcw.ui.openTab('组装入库详细' + row.billId, '${base}manager/stkZzcx/show?billId=' + row.billId);
        } else if ('初始化入库' === billName) {
            uglcw.ui.openTab('初始化入库详细' + row.billId, '${base}manager/showStkcheckInit?billId=' + row.billId);
        } else if ('盘盈' === billName) {
            uglcw.ui.openTab('盘盈入库详细' + row.billId, '${base}manager/showStkcheck?billId=' + row.billId);
        }else if('生产入库' === billName){
            uglcw.ui.openTab('生产入库详细' + row.billId, '${base}manager/stkProduce/show?billId=' + row.billId);
        }else if('领料回库' === billName){
            uglcw.ui.openTab('领料回库详细' + row.billId, '${base}manager/showStkLlhkIn?billId=' + row.billId);
        }
    }


    function filterField(){
        var grid = uglcw.ui.get('#grid');
        if('${filterDataType}'==1){
            grid.showColumn('unitName');
            grid.showColumn('qty');
            grid.showColumn('inQty');
            grid.showColumn('price');
            grid.hideColumn('minUnitName');
            grid.hideColumn('minQty');
            grid.hideColumn('minInQty');
            grid.hideColumn('minPrice');
        }else if('${filterDataType}'==2){
            grid.hideColumn('unitName');
            grid.hideColumn('qty');
            grid.hideColumn('inQty');
            grid.hideColumn('price');
            grid.showColumn('minUnitName');
            grid.showColumn('minInQty');
            grid.showColumn('minQty');
            grid.showColumn('minPrice');
        }else if('${filterDataType}'==3){
            grid.showColumn('unitName');
            grid.showColumn('qty');
            grid.showColumn('inQty');
            grid.showColumn('price');
            grid.showColumn('minUnitName');
            grid.showColumn('minQty');
            grid.showColumn('minInQty');
            grid.showColumn('minPrice');
        }
    }

</script>
</body>
</html>
