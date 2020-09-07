<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品销售日报表--按单据明细</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        ::-webkit-input-placeholder {
            color:black;
        }
        .biz-type.k-combobox{
            font-weight: bold;

        }
        .biz-type .k-input{
            color: black;
            background-color: rgba(0, 123, 255, .35);
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
        .k-grid-toolbar{
            padding: 5px 10px 5px 10px!important;
            width: 100%;
            display: inline-flex;
            vertical-align: middle;
        }
        .k-grid-toolbar .k-checkbox-label{
            margin-top: 0px!important;

        }
        .k-grid-toolbar label{
            padding-left: 20px;
            margin-left: 10px;
            margin-bottom: 0px!important;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header" style="display: none">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <select uglcw-model="timeType" id="timeType" uglcw-role="combobox"  data-value="${timeType}">
                        <option value="1">发货时间</option>
                        <option value="2">销售时间</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                    <input uglcw-role="textbox" type="hidden" uglcw-model="wareId" value="${wareId}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-model="outType" id="outType" uglcw-role="combobox" uglcw-options="value:'销售出库',
                     placeholder:'出库类型',
                     change: function(){
                        uglcw.ui.get('#xsTp').k().dataSource.read();
                     }">
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>

                    </select>
                </li>
                <li style="width: 180px!important;" class="xs-tp">
                    <input id="xsTp" uglcw-role="multiselect" uglcw-model="xsTp" uglcw-options="
                    placeholder:'销售类型',
                    tagMode: 'single',
                    tagTemplate: uglcw.util.template($('#xp-type-tag-template').html()),
                    autoClose: false,
                    url: '${base}manager/loadXsTp',
                    data: function(){
                        return {
                            outType: uglcw.ui.get('#outType').value()
                        }
                    },
                    loadFilter:{
                        data: function(response){
                            return response.list || []
                        }
                    },
                    dataTextField: 'xsTp',
                    dataValueField: 'xsTp'
                ">


                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="stkId" uglcw-options="
                                    dataTextField: 'stkName',
                                    dataValueField: 'id',
                                    url: '${base}manager/queryBaseStorage',
                                    placeholder: '仓库'
                                "></select>
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="业务员" uglcw-model="staff">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="customerTypeId" uglcw-options="
                                                url: '${base}manager/queryarealist1',
                                                placeholder: '客户类型',
                                                dataTextField: 'qdtpNm',
                                                dataValueField: 'id',
                                                loadFilter:{
                                                    data: function(response){
                                                        return response.list1 || [];
                                                    }
                                                }
                                             ">
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="客户名称" uglcw-model="khNm">
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="商品名称" uglcw-model="wareNm" value="${wareNm}">
                </li>
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="0" id="isType">
                    <input uglcw-role="gridselector" uglcw-model="wtypename,waretype" id="wtype" placeholder="资产类型"
                           uglcw-options="
                           value:'库存商品类',
                           click: function(){
                                    waretype()
                           }
                    ">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li>
                    <select class="biz-type" id="saleType" uglcw-model="saleType" uglcw-role="combobox"
                            uglcw-options="placeholder:'业务类型', value: ''">
                        <option value="001" selected>传统业务类</option>
                        <option value="003">线上商城</option>
                        <option value="004">线下门店</option>
                    </select>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    autoBind: true,
                    responsive:['.header',40],
                    <%--toolbar: kendo.template($('#toolbar').html()),--%>
                    id:'id',
                    url: '${base}manager/sumWareDayBillStat',
                    criteria: '.form-horizontal',
                    pageable: true,
                    rowNumber:true,
                    <%--aggregate:[--%>
                     <%--{field: 'qty', aggregate: 'SUM'},--%>
                     <%--{field: 'minQty', aggregate: 'SUM'},--%>
                     <%--{field: 'amt', aggregate: 'SUM'},--%>
                     <%--{field: 'outQty', aggregate: 'SUM'},--%>
                     <%--{field: 'minOutQty', aggregate: 'SUM'},--%>
                     <%--{field: 'outAmt', aggregate: 'SUM'}--%>

                    <%--],--%>
                    dataBound: function(){
                        filterField();
                     },
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        var rows = response.rows || [];
                       return rows;
                      }
                      ,
                      total: function (response) {
                        return response.total;
                      }
                      <%--,--%>
                      <%--aggregates: function (response) {--%>
                        <%--var aggregate = {--%>
                            <%--qty: 0,amt:0, outQty: 0, outAmt:0--%>
                        <%--};--%>
                        <%--if (response.rows && response.rows.length > 0) {--%>

                            <%--aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1])--%>
                        <%--}--%>
                        <%--return aggregate;--%>
                      <%--}--%>
                     }

                    ">
                <div data-field="billNo" uglcw-options="width: 140, tooltip: true">单据号</div>
                <div data-field="billTime" uglcw-options="width: 120,template: '#= uglcw.util.toString(new Date(data.billTime), \'yyyy-MM-dd HH:mm\')#'">单据日期</div>
                <div data-field="khNm" uglcw-options="width: 120, tooltip: true">客户名称</div>
                <div data-field="wareNm" uglcw-options="width: 200, tooltip: true">商品名称</div>
                <div data-field="unitName" uglcw-options="width: 80, tooltip: true">计量单位</div>
                <div data-field="qty"
                     uglcw-options="width:120,attributes:{ class: 'router-link', 'data-field': 'qty'}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.qty.sum != undefined ? data.qty.sum : data.qty, \'n2\')#'">
                    销售数量
                </div>
                <div data-field="outQty"
                     uglcw-options="width:120,attributes:{ class: 'router-link', 'data-field': 'outQty'}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty || 0, \'n2\')#'">
                    发货数量
                </div>
                <div data-field="minUnitName" uglcw-options="width: 100, tooltip: true">计量单位(小)</div>
                <div data-field="minQty"
                     uglcw-options="width:120,attributes:{ class: 'router-link', 'data-field': 'minQty'}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minQty || 0, \'n2\')#'">
                    销售数量(小)
                </div>
                <div data-field="minOutQty"
                     uglcw-options="width:120,attributes:{ class: 'router-link', 'data-field': 'minOutQty'}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minOutQty || 0, \'n2\')#'">
                    发货数量(小)
                </div>
                <div data-field="amt"
                     uglcw-options="width:120,attributes:{ class: 'router-link', 'data-field': 'amt'}, format: '{0:n2}', footerTemplate:'#= uglcw.util.toString(data.amt || 0, \'n2\')#'">
                    销售金额
                </div>
                <div data-field="outAmt"
                     uglcw-options="width:120,attributes:{ class: 'router-link', 'data-field': 'outAmt'}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt || 0, \'n2\')#'">
                    发货金额
                </div>
</div>
</div>
</div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <input id="showDataRadio1"  type="radio" class="k-radio" onclick="javascript:filterData(1);" checked name="showDataRadio" value="1"/><label class="k-radio-label" for="showDataRadio1">显示大单位</label>
    <input id="showDataRadio2" type="radio"  class="k-radio" onclick="javascript:filterData(2);"  name="showDataRadio" value="2"/><label class="k-radio-label" for="showDataRadio2">显示小单位</label>
    <input id="showDataRadio3" type="radio"  class="k-radio" onclick="javascript:filterData(3);"  name="showDataRadio" value="3"/><label class="k-radio-label" for="showDataRadio3">显示大小单位</label>
</script>

<script type="text/x-uglcw-template" id="xp-type-tag-template">
    <div style="width: 130px;
            text-overflow: ellipsis;
            white-space: nowrap">
        # for(var idx = 0; idx < values.length; idx++){ #
        #: values[idx]#
        # if(idx < values.length - 1) {# , # } #
        # } #
    </div>
</script>

<script id="product-footer-tpl" type="text/x-uglcw-template">
    <div class="product-table">
        <span class="router-link" data-field="qty" style="width: 60px;">#= uglcw.util.toString(data.qty, 'n2')#</span>
        <span class="router-link" data-field="amt" style="width: 60px;">#= uglcw.util.toString(data.amt, 'n2')#</span>

        <span class="router-link" data-field="outQty"
              style="width: 60px;">#= uglcw.util.toString(data.outQty, 'n2')#</span>
        <span class="router-link" data-field="outAmt"
              style="width: 60px;">#= uglcw.util.toString(data.outAmt, 'n2')#</span>
    </div>
</script>

<script id="product-type-selector-template" type="text/uglcw-template">
    <div class="uglcw-selector-container">
        <div style="line-height: 30px">
            已选:
            <button style="display: none;" id="_type_name" class="k-button k-info ghost"></button>
        </div>
        <div style="padding: 2px;height: 344px;">
            <input type="hidden" uglcw-role="textbox" id="_type_id">
            <input type="hidden" uglcw-role="textbox" id="_isType">
            <input type="hidden" uglcw-role="textbox" id="wtypename">
            <ul uglcw-role="accordion">
                <li>
                    <span>库存商品类</span>
                    <div>
                        <div uglcw-role="tree"
                             uglcw-options="
                                url:'${base}manager/syswaretypes?isType=0&noCompany=0',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                 loadFilter:function(response){
                                  $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                         item.text='库存商品类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(0);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
                                }
                            ">
                        </div>
                    </div>
                </li>
                <li>
                    <span>原辅材料类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=1&noCompany=0',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                 loadFilter:function(response){
                                  $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                         item.text='原辅材料类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(1);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
                                }
                            ">
                    </div>
                </li>
                <li>
                    <span>低值易耗品类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=2&noCompany=0',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                 loadFilter:function(response){
                                  $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                         item.text='低值易耗品类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(2);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
                                }
                            ">
                    </div>
                </li>
                <li>
                    <span>固定资产类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=3&noCompany=0',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                 loadFilter:function(response){
                                  $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                         item.text='固定资产类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(3);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();

                                }
                            ">
                    </div>
                </li>
            </ul>
        </div>
    </div>
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

uglcw.ui.get('#search').on('click', function () {
uglcw.ui.get('#grid').reload();
})

uglcw.ui.get('#reset').on('click', function () {
uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
})
    filterField();
uglcw.ui.loaded();
})

var filterDataType = 1;
function filterData(v){
    filterDataType = v;
    filterField();
}
function filterField(){
    var grid = uglcw.ui.get('#grid');
    if('${filterDataType}'==1){
        grid.showColumn('unitName');
        grid.showColumn('qty');
        grid.showColumn('outQty');
        grid.hideColumn('minUnitName');
        grid.hideColumn('minQty');
        grid.hideColumn('minOutQty');
    }else if('${filterDataType}'==2){
        grid.hideColumn('unitName');
        grid.hideColumn('qty');
        grid.hideColumn('outQty');
        grid.showColumn('minUnitName');
        grid.showColumn('minQty');
        grid.showColumn('minOutQty');
    }else if('${filterDataType}'==3){
        grid.showColumn('unitName');
        grid.showColumn('qty');
        grid.showColumn('outQty');
        grid.showColumn('minUnitName');
        grid.showColumn('minQty');
        grid.showColumn('minOutQty');
    }
}


//资产类型
function waretype() {
    var i = uglcw.ui.Modal.open({
        checkbox: true,
        selection: 'single',
        title: false,
        maxmin: false,
        resizable: false,
        move: true,
        btns: ['确定', '取消'],
        area: ['400', '415px'],
        content: $('#product-type-selector-template').html(),
        success: function (c) {
            uglcw.ui.init(c);
        },
        yes: function (c) {
            uglcw.ui.get("#isType").value(uglcw.ui.get($(c).find('#_isType')).value());
            uglcw.ui.get("#wtype").value(uglcw.ui.get($(c).find('#wtypename')).value());
            uglcw.ui.get("#wtype").text(uglcw.ui.get($(c).find('#_type_id')).value());
            uglcw.ui.Modal.close(i);
            return false;

        }

    })


}

</script>
</body>
</html>
