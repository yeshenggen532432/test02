<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品日报表销售按客户统计</title>
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
                    mergeBy:'proName',
                    id:'id',
                    autoBind: true,
                    url: '${base}manager/customerSaleStat/statPages',
                    criteria: '.uglcw-query',
                    query: function(params){
                        return params;
                    },
                    pageable: true,
                    rowNumber: true,
                    aggregate:[
                     {field: 'qty', aggregate: 'sum'}
                    ],
                   dblclick: function(row){
                        var q = uglcw.ui.bind('.uglcw-query');
                        var proId = row.proId;
                        var proName = row.proName;
                        var xsTp = row.xsTp;
				        var wareId = row.wareId;
				        if(xsTp == undefined)xsTp = '';
                        if(proId == undefined)proId = '';
                        if(wareId == undefined)wareId = '';
                        q.wareId = wareId;
                        q.proId = proId;
                        if(xsTp!=''){
                         q.xsTp = xsTp;
                        }
                        q.proName=proName;
                        q.filterDataType = ${query.filterDataType};
                        uglcw.ui.openTab('客户销售统计明细', '${base}manager/customerSaleStat/toStatItemPages?1=1&' + $.map(q, function(v, k){
                            return k+'='+(v||'');
                        }).join('&'));
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
                <div data-field="proName" uglcw-options="merge:true,width:150, tooltip: true, footerTemplate:'合计'">客户名称</div>
                <div data-field="wareNm" uglcw-options="width:120,hidden:true">商品名称</div>
                <div data-field="xsTp" uglcw-options="width:120,hidden:true">销售类型</div>
                <div data-field="unitName" uglcw-options="width:80,hidden:true">计量单位</div>
                <div data-field="price" uglcw-options="width:80,format: '{0:n2}',hidden:true">销售单价</div>
                <div data-field="qty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.qty || 0, \'n2\')#'">
                    销售数量
                </div>
                <div data-field="outQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty || 0, \'n2\')#'">
                    发货数量
                </div>
                <div data-field="unitName" uglcw-options="width:100,hidden:true">计量单位(小)</div>
                <div data-field="minPrice" uglcw-options="width:100,format: '{0:n2}', hidden:true">销售单价(小)</div>
                <div data-field="minQty"
                     uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minQty || 0, \'n2\')#'">
                    销售数量(小)
                </div>
                <div data-field="minOutQty"
                     uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minOutQty || 0, \'n2\')#'">
                    发货数量(小)
                </div>
                <div data-field="amt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.amt || 0, \'n2\')#'">
                    销售金额
                </div>
                <div data-field="outAmt"
                     uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt || 0, \'n2\')#'">
                    发货金额
                </div>

                <div data-field="">
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<script>
    $(function () {
        uglcw.ui.init();
        filterField();
        uglcw.ui.loaded()
    })
    function filterField(){
        var grid = uglcw.ui.get('#grid');
        var filterDataType = ${query.filterDataType};
        if(filterDataType=='1'){
            grid.showColumn('qty');
            grid.showColumn('outQty');
            grid.hideColumn('minQty');
            grid.hideColumn('minOutQty');
        }else if(filterDataType=='2'){
            grid.hideColumn('qty');
            grid.hideColumn('outQty');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
        }else if(filterDataType=='3'){
            grid.showColumn('qty');
            grid.showColumn('outQty');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
        }
        // var showGroupType = uglcw.ui.get("#showGroupType").value();
        // if(showGroupType==1){
        //     grid.hideColumn('wareNm');
        //     grid.hideColumn('unitName');
        //     grid.hideColumn('minUnitName');
        //     grid.hideColumn('price');
        //     grid.hideColumn('minPrice');
        //     grid.hideColumn('xsTp');
        // }else{
        //     grid.hideColumn('xsTp');
        //     grid.showColumn('wareNm');
        //     grid.showColumn('unitName');
        //     grid.showColumn('minUnitName');
        //     grid.showColumn('price');
        //     grid.showColumn('minPrice');
        //     if(showGroupType==3){
        //         grid.showColumn('xsTp');
        //     }
        // }
        var timeType = ${query.timeType};
        if(timeType=='1'){
            grid.hideColumn('qty');
            grid.hideColumn('minQty');
            grid.hideColumn('amt');
        }else{
            grid.showColumn('amt');
            if(filterDataType=='1'){
                grid.showColumn('qty');
            }
            if(filterDataType=='2'||filterDataType=='3'){
                grid.showColumn('minQty');
            }
        }
    }

</script>
</body>
</html>
