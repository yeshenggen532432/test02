<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>业务销售统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">

    <ul class="uglcw-query">
        <input type="hidden" uglcw-role="textbox" uglcw-model="sdate" id="sdate" value="${sdate}"/>
        <input type="hidden" uglcw-role="textbox" uglcw-model="edate" id="edate" value="${edate}"/>
        <input type="hidden" uglcw-role="textbox" uglcw-model="empId" id="empId" value="${empId}"/>
        <input type="hidden" uglcw-role="textbox" uglcw-model="xsTp" id="xsTp" value="${xsTp}"/>
        <input type="hidden" uglcw-role="textbox" uglcw-model="wareId" id="wareId" value="${wareId}"/>
        <input type="hidden" uglcw-role="textbox" uglcw-model="timeType" id="timeType" value="${timeType}"/>
        <input type="hidden" uglcw-role="textbox" uglcw-model="wtype" id="wtype" value="${wtype}"/>
        <input type="hidden" uglcw-role="textbox" uglcw-model="wareNm" id="wareNm" value="${wareNm}"/>
    </ul>

    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:[40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    autoBind: false,
                    url: '${base}manager/querySumEmptatDetail',
                    criteria: '.uglcw-query',
                    pageable: false,
                    aggregate:[
                     {field: 'qty', aggregate: 'sum'},
                     {field: 'amt', aggregate: 'sum'},
                     {field: 'outQty', aggregate: 'sum'},
                     {field: 'outAmt', aggregate: 'sum'},
                     {field: 'minQty', aggregate: 'sum'},
                     {field: 'minOutQty', aggregate: 'sum'}
                    ],
                     dblclick: function(row){
                     if(row.xsTp == '销售退货')
                     {
                        uglcw.ui.openTab('销售退货信息', '${base}manager/showstkin?billId=' + row.id);
                     }
                     else
                     {
                        uglcw.ui.openTab('销售销售信息', '${base}manager/showstkout?billId=' + row.id);
                     }
                    },
                     dataBound: function(){
                        filterField();
                     },
                    loadFilter: {
                      data: function (response) {
                         if(!response.rows || response.rows.length<2){
                            return [];
                        }
                        //response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="billNo" uglcw-options="width:120, tooltip: true, footerTemplate:'合计'">单号</div>
                <div data-field="memberNm" uglcw-options="width: 120, tooltip: true">业务员名称</div>
                <div data-field="wareNm" uglcw-options="width:120, tooltip: true">商品名称</div>
                <div data-field="xsTp" uglcw-options="width:80">销售类型</div>
                <div data-field="unitName" uglcw-options="width:80">计量单位</div>
                <div data-field="price" uglcw-options="width:80, format: '{0:n2}'">销售单价</div>
                <div data-field="qty"
                     uglcw-options="width:80, format: '{0:n2}',  footerTemplate: '#= uglcw.util.toString(data.qty || 0, \'n2\')#'">
                    销售数量
                </div>
                <div data-field="outQty"
                     uglcw-options="width:80, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty || 0, \'n2\')#'">
                    发货数量
                </div>
                <div data-field="minUnitName" uglcw-options="width:100">计量单位(小)</div>
                <div data-field="minPrice" uglcw-options="width:120, format: '{0:n2}'">销售单价(小)</div>
                <div data-field="minQty"
                     uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minQty, \'n2\')#'">
                    销售数量(小)
                </div>
                <div data-field="minOutQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minOutQty, \'n2\')#'">
                    发货数量(小)
                </div>
                <div data-field="amt"
                     uglcw-options="width:80, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.amt || 0, \'n2\')#'">
                    销售金额
                </div>
                <div data-field="outAmt"
                     uglcw-options="width:80, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt, \'n2\')#'">
                    发货金额
                </div>
                <div data-field=""></div>

            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">

</script>
<script id="product-tpl" type="text/x-uglcw-template">

</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>


<script>

    $(function () {
        uglcw.ui.init();
        $('.q-box-arrow').on('click', function () {
            $(this).find('i').toggleClass('k-i-arrow-chevron-left k-i-arrow-chevron-down');
            $('.q-box-more').toggle();
            $('.q-box-wrapper').closest('.layui-card').toggleClass('box-shadow')
        })
        filterField();

        uglcw.ui.loaded();

        uglcw.ui.get('#grid').reload();

    })

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
