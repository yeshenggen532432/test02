<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>按商品类别销售统计</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
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
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input type="hidden" id="database" uglcw-model="database" uglcw-role="textbox" value="${datasource}">
                    <input uglcw-role="textbox" type="hidden" uglcw-model="typeLevel" value="0"/>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-model="outType" id="outType" uglcw-role="combobox" uglcw-options="value:'销售出库',
                     placeholder:'出库类型',
                     change: function(){
                        uglcw.ui.get('#xsTp').k().dataSource.read();
                     }
">
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
                    <input uglcw-role="textbox" uglcw-model="staff" placeholder="业务员"/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="khNm" placeholder="客户名称"/>
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="商品名称" uglcw-model="wareNm">
                </li>
                <li>
                    <input type="checkbox" uglcw-model="isRec" uglcw-role="checkbox"
                           id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">只统计已结清订单</label>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
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
                    autoBind: false,
                    responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/queryWareTypeStat',
                    criteria: '.form-horizontal',
                    pageable: true,
                    dblclick: function(row){
                        var q = uglcw.ui.bind('.form-horizontal');
                        q.typeId = row.id;
                        q.typeLevel= row.typeLevel+1;
                        q.filterDataType=filterDataType;
                        uglcw.ui.openTab('类别统计-'+row.typeName, '${base}manager/toStkWareTypeStat1?'+ $.map(q, function(v, k){
                            return k+'='+ (v||'');
                        }).join('&'));
                    },
                    aggregate:[
                     {field: 'sumQty', aggregate: 'sum'},
                     {field: 'minSumQty', aggregate: 'sum'}

                    ],
                     dataBound: function(){
                        filterField();
                     },
                    loadFilter: {
                      data: function (response) {
                        if(!response.rows || response.rows.length<2){
                            return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {

                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     }
                    ">
                <div data-field="typeName" uglcw-options="width:160,
                        footerTemplate:'合计'">类别/商品名称
                </div>
                <div data-field="price" uglcw-options="width:120, format: '{0:n2}'">销售均价</div>
                <div data-field="sumQty"
                     uglcw-options="width:100, format: '{0:n2}',
                             footerTemplate: '#= uglcw.util.toString(data.sumQty.sum != undefined ? data.sumQty.sum : data.sumQty,\'n2\')#'
                             ">
                    数量
                </div>

                <div data-field="minPrice" uglcw-options="width:120, format: '{0:n2}'">销售均价(小)</div>
                <div data-field="minSumQty"
                     uglcw-options="width:100, format: '{0:n2}',
                             footerTemplate: '#= uglcw.util.toString(data.minSumQty.sum != undefined ? data.minSumQty.sum : data.minSumQty,\'n2\')#'
                             ">
                    数量(小)
                </div>
                <div data-field="sumAmt"
                     uglcw-options="width:100, format: '{0:n2}',
                             footerTemplate: '#= uglcw.util.toString(data.sumAmt||0, \'n2\')#'
                             ">
                    销售金额
                </div>
                <div data-field="freeQty"
                     uglcw-options="width:100, format: '{0:n2}',
                             footerTemplate: '#= uglcw.util.toString(data.freeQty||0, \'n2\')#'
                             ">
                    赠送数量
                </div>
                <div data-field="minFreeQty"
                     uglcw-options="width:100, format: '{0:n2}',
                             footerTemplate: '#= uglcw.util.toString(data.minFreeQty||0, \'n2\')#'
                             ">
                    赠送数量(小)
                </div>
                <div data-field="unitName"
                     uglcw-options="width:100, format: '{0:n2}'">
                    计量单位
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>导出
    </a>
    <a role="button" href="javascript:print();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>打印
    </a>
    <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <input id="showDataRadio1"  type="radio" class="k-radio" onclick="javascript:filterData(1);" checked name="showDataRadio" value="1"/><label class="k-radio-label" for="showDataRadio1">显示大单位</label>
    <input id="showDataRadio2" type="radio"  class="k-radio" onclick="javascript:filterData(2);"  name="showDataRadio" value="2"/><label class="k-radio-label" for="showDataRadio2">显示小单位</label>
    <input id="showDataRadio3" type="radio"  class="k-radio" onclick="javascript:filterData(3);"  name="showDataRadio" value="3"/><label class="k-radio-label" for="showDataRadio3">显示大小单位</label>

</script>
<tag:exporter service="incomeStatService" method="sumWareTypeStat3"
              bean="com.qweib.cloud.biz.erp.model.StkWareTypeStatVo"
              condition=".uglcw-query" description="商品类型销售统计"

/>
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
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
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

        uglcw.ui.loaded()
    })


    function exportExcel() {

    }

    var filterDataType = 1;
    function filterData(v){
        filterDataType = v;
        filterField();
    }
    function filterField(){
        var grid = uglcw.ui.get('#grid');
        if(filterDataType==1){
            grid.showColumn('price');
            grid.showColumn('sumQty');
            grid.showColumn('freeQty');
            grid.hideColumn('minPrice');
            grid.hideColumn('minSumQty');
            grid.hideColumn('minFreeQty');
        }else if(filterDataType==2){
            grid.hideColumn('price');
            grid.hideColumn('sumQty');
            grid.hideColumn('freeQty');
            grid.showColumn('minPrice');
            grid.showColumn('minSumQty');
            grid.showColumn('minFreeQty');
        }else if(filterDataType==3){
            grid.showColumn('price');
            grid.showColumn('sumQty');
            grid.showColumn('freeQty');
            grid.showColumn('minPrice');
            grid.showColumn('minSumQty');
            grid.showColumn('minFreeQty');
        }
    }

    function print() {
        var query = uglcw.ui.bind('.form-horizontal');
        query.filterDataType=filterDataType;
        var sdate = query.sdate;
        var edate = query.edate;
        if(sdate==""){
            uglcw.ui.info("开始日期不能为空!");
            return;
        }
        if(edate==""){
            uglcw.ui.info("结束日期不能为空!");
            return;
        }
        var dis =$.date.diff(sdate, 'm', edate);
        if((dis+1)>3){
            uglcw.ui.info("最多只能打印3个月之间的数据");
            return;
        }

        uglcw.ui.openTab('打印按商品类别销售统计表', "${base}manager/toStkWareTypeStatPrint?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }


</script>
</body>
</html>
