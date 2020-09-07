<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户销售毛利统计表明细(新)</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-grid td.router-link {
            color: blue;
            cursor: pointer;
        }

        .uglcw-grid .product-grid {
            padding: 0;
        }

        .uglcw-grid .product-footer {
            padding: 0;
            text-align: right !important;
        }

        .uglcw-grid .product-footer span {
            text-align: left;
            display: inline-block;
            text-overflow: ellipsis;
            white-space: nowrap;
            position: relative;
            padding: 0 .75rem;
        }
        .uglcw-query>li.xs-tp #xsTp_taglist {
            position: fixed;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .k-grid-toolbar{
            padding: 0px 10px 0px 10px!important;
            width: 100%;
            display: inline-flex;
            vertical-align: middle;
        }
        .k-grid-toolbar .k-checkbox-label{
            margin-top: 5px!important;

        }
        .k-grid-toolbar label{
            padding-left: 20px;
            margin-left: 10px;
            margin-top: 7px;
            margin-bottom: 0px!important;
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
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="${query.isType}" id="isType">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="timeType" value="${query.timeType}" id="timeType">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="sdate" value="${query.sdate}" id="sdate">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="edate" value="${query.edate}" id="edate">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="outType" value="${query.outType}" id="outType">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="saleType" value="${query.saleType}" id="saleType">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="xsTp" value="${query.xsTp}" id="xsTp">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="proId" value="${query.proId}" id="proId">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="empName" value="${query.empName}" id="empName">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="regionId" value="${query.regionId}" id="regionId">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="customerTypeId" value="${query.customerTypeId}" id="customerTypeId">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="carId" value="${query.carId}" id="carId">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="wareId" value="${query.wareId}" id="wareId">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="proName" value="${query.proName}" id="proName">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="wareNm" value="${query.wareNm}" id="wareNm">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="showGroupType" value="${query.showGroupType}" id="showGroupType">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="waretype" value="${query.waretype}" id="waretype">
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
                    autoBind: true,
                    url: '${base}manager/customerSaleGrossProfitStat/statItemPages',
                    criteria: '.uglcw-query',
                    query: function(params){
                        return params;
                    },
                    pageable: true,
                    rowNumber: true,
                    aggregate:[
                     {field: 'qty', aggregate: 'sum'}
                    ],
                     dataBound: function(){
                        filterField();
                     },
                      dblclick: function(row){
                         var url = '';
                         var title ='';
                         if(row.xsTp=='销售退货'){
                            url='${base}manager/showstkin?billId=' + row.billId;
                            title='销售退货信息';
                         }else{
                            url='${base}manager/showstkout?billId=' + row.billId;
                            title='销售发票信息';
                         }
                        uglcw.ui.openTab(title,url);
                    },
                     loadFilter: {
                      data: function (response) {
                        if(response && response.code == 200){
                            response.data.rows.splice(response.data.rows.length - 1, 1);
                            return response.data.rows || [];
                        }
                        return []
                      },
                       total: function(response){
                        return response.data ? response.data.total : 0;
                      },
                       aggregates: function (response) {
                        var aggregate = {};
                        if (response.data.rows && response.data.rows.length > 0) {
                            aggregate = response.data.rows[response.data.rows.length - 1]
                        }
                        return aggregate;
                      }
                     }
                    ">
                <div data-field="billNo" uglcw-options="width:150, tooltip: true, footerTemplate:'合计'">
                   单据号
                </div>
                <div data-field="billDate" uglcw-options="
                            width:140,
                            template: function(dataItem){
                                return kendo.template($('#formateData-template').html())(dataItem);
                          }">
                        发货日期
                </div>
                <div data-field="proName" uglcw-options="width:150,">客户名称</div>
                <div data-field="wareNm" uglcw-options="width:120">商品名称</div>
                <div data-field="xsTp" uglcw-options="width:120">销售类型</div>
                <div data-field="unitName" uglcw-options="width:80,hidden:true">计量单位</div>
                <div data-field="price" uglcw-options="width:120,format: '{0:n2}'">平均销售单价</div>
                <div data-field="qty"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.qty || 0, \'n2\')#'">
                    销售数量
                </div>
                <div data-field="minUnitName" uglcw-options="width:100,hidden:true">计量单位(小)</div>
                <div data-field="minPrice" uglcw-options="width:100,format: '{0:n2}'">平均销售单价(小)</div>
                <div data-field="minQty"
                     uglcw-options="width:120,format: '{0:n2}',
                      footerTemplate: '#= uglcw.util.toString(data.minQty || 0, \'n2\')#'">
                    销售数量(小)
                </div>
                <div data-field="saleAmt"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.saleAmt || 0, \'n2\')#'">
                    销售收入
                </div>
                <div data-field="costAmt"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.costAmt || 0, \'n2\')#'">
                    销售成本
                </div>
                <div data-field="grossAmt"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.grossAmt || 0, \'n2\')#'">
                    销售毛利
                </div>
                <div data-field="grossPrice"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.grossPrice || 0, \'n2\')#'">
                    平均单位毛利
                </div>
                <div data-field="minGrossPrice"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.grossPrice || 0, \'n2\')#'">
                    平均单位毛利(小)
                </div>
                <div data-field="grossRate"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.grossRate || 0, \'n2\')#'">
                    毛利率
                </div>
                <div data-field="remarks" uglcw-options="width:100">备注</div>
                <div data-field="">
                </div>
            </div>
        </div>
    </div>
</div>

<script id="formateData-template" type="text/x-kendo-template">
    #if(data.billDate){#
    #= uglcw.util.toString(new Date(data.billDate + 'GMT+0800'), 'yyyy-MM-dd HH:mm:ss')#
    #}#
</script>

<script id="source-bill-no" type="text/x-kendo-template">
    <a href="javascript:showSourceNoDetail(#=data.sourceBillId#);" style="color:blue;font-size: 12px; font-weight: bold;"> #= data.sourceBillNo#</a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })
    function filterField(){
        var grid = uglcw.ui.get('#grid');
        var filterDataType = ${query.filterDataType};
        if(filterDataType==1){
            grid.showColumn('unitName');
            grid.showColumn('price');
            grid.showColumn('qty');
            grid.showColumn('outQty');
            grid.hideColumn('minQty');
            grid.hideColumn('minOutQty');
            grid.hideColumn('minUnitName');
            grid.hideColumn('minPrice');
        }else if(filterDataType==2){
            grid.hideColumn('qty');
            grid.hideColumn('outQty');
            grid.hideColumn('unitName');
            grid.hideColumn('price');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
            grid.showColumn('minUnitName');
            grid.showColumn('minPrice');
        }else if(filterDataType==3){
            grid.showColumn('qty');
            grid.showColumn('outQty');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
            grid.showColumn('unitName');
            grid.showColumn('price');
            grid.showColumn('minUnitName');
            grid.showColumn('minPrice');
        }
        var timeType = ${query.timeType};
        if(timeType==1){
            grid.hideColumn('qty');
            grid.hideColumn('minQty');
            grid.hideColumn('amt');
            grid.showColumn('sourceBillNo');
        }else{
            grid.showColumn('amt');
            if(filterDataType==1){
                grid.showColumn('qty');
            }
            if(filterDataType==2||filterDataType==3){
                grid.showColumn('minQty');
            }
            grid.hideColumn('sourceBillNo');
        }
    }


    <%--function filterField(){--%>
    <%--    var grid = uglcw.ui.get('#grid');--%>
    <%--    var showGroupType = uglcw.ui.get("#showGroupType").value();--%>
    <%--    if(showGroupType!=1){--%>
    <%--        grid.hideColumn('xsTp');--%>
    <%--        grid.showColumn('wareNm');--%>
    <%--        grid.showColumn('unitName');--%>
    <%--        grid.showColumn('minUnitName');--%>
    <%--        grid.showColumn('price');--%>
    <%--        grid.showColumn('minPrice');--%>
    <%--        if(showGroupType==3){--%>
    <%--            grid.showColumn('xsTp');--%>
    <%--        }--%>
    <%--    }--%>
    <%--    filteCommon();--%>
    <%--}--%>

    <%--function filteCommon(){--%>
    <%--    var filterDataType = ${query.filterDataType};--%>
    <%--    var grid = uglcw.ui.get('#grid');--%>
    <%--    if(filterDataType==1){--%>
    <%--        grid.showColumn('qty');--%>
    <%--        grid.showColumn('unitName');--%>
    <%--        grid.showColumn('price');--%>
    <%--        grid.showColumn('grossPrice');--%>
    <%--        grid.hideColumn('minQty');--%>
    <%--        grid.hideColumn('minUnitName');--%>
    <%--        grid.hideColumn('minPrice');--%>
    <%--        grid.hideColumn('minGrossPrice');--%>
    <%--    }else if(filterDataType==2){--%>
    <%--        grid.hideColumn('qty');--%>
    <%--        grid.hideColumn('unitName');--%>
    <%--        grid.hideColumn('price');--%>
    <%--        grid.hideColumn('grossPrice');--%>
    <%--        grid.showColumn('minQty');--%>
    <%--        grid.showColumn('minUnitName');--%>
    <%--        grid.showColumn('minPrice');--%>
    <%--        grid.showColumn('minGrossPrice');--%>
    <%--    }else if(filterDataType==3){--%>
    <%--        grid.showColumn('qty');--%>
    <%--        grid.showColumn('unitName');--%>
    <%--        grid.showColumn('price');--%>
    <%--        grid.showColumn('grossPrice');--%>
    <%--        grid.showColumn('minQty');--%>
    <%--        grid.showColumn('minUnitName');--%>
    <%--        grid.showColumn('minPrice');--%>
    <%--        grid.showColumn('minGrossPrice');--%>
    <%--    }--%>
    <%--    var showGroupType = uglcw.ui.get("#showGroupType").value();--%>
    <%--    if(showGroupType==1){--%>
    <%--        grid.hideColumn('wareNm');--%>
    <%--        grid.hideColumn('unitName');--%>
    <%--        grid.hideColumn('minUnitName');--%>
    <%--        grid.hideColumn('price');--%>
    <%--        grid.hideColumn('minPrice');--%>
    <%--        grid.hideColumn('xsTp');--%>
    <%--    }--%>
    <%--}--%>

</script>
</body>
</html>
