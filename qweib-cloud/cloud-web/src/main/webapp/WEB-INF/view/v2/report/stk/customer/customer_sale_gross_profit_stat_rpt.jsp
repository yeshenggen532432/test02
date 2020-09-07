<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户销售毛利统计表(新)</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-grid td.router-link {
            color: blue;
            cursor: pointer;
        }

        .uglcw-grid .product-grid {
            padding: 0;
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
        .uglcw-query>li.xs-tp #xsTp_taglist {
            position: fixed;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        #grid .k-grid-toolbar{
            padding: 0px 10px 0px 10px!important;
            width: 100%;
            display: inline-flex;
            vertical-align: middle;
        }
        #grid .k-grid-toolbar .k-checkbox-label{
            margin-top: 5px!important;

        }
        #grid .k-grid-toolbar label{
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
                <li><input uglcw-model="sort" id="sort" uglcw-role="textbox" type="hidden" value="${sort}" />
                    <input uglcw-model="timeType" id="timeType" uglcw-role="textbox" type="hidden" value="1" />
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>

                <li>
                    <select uglcw-model="outType" id="outType" uglcw-role="combobox" uglcw-options="
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
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="客户名称"/>
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="业务员" uglcw-model="empName">
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="商品名称" uglcw-model="wareNm">
                </li>
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="0" id="isType">
                    <input uglcw-role="gridselector" uglcw-model="wtypename,waretype" id="waretype" placeholder="资产类型"
                           uglcw-options="
                           value:'库存商品类',
                           click:function(){
                                    waretype()
                           }
                    ">
                </li>
                <li>
                    <select uglcw-model="showGroupType" id="showGroupType" uglcw-role="combobox"
                            uglcw-options="placeholder:'显示数据',value: '1'">
                        <option value="1">只显示客户分组</option>
                        <option value="2">显示商品分组</option>
                        <option value="3">显示商品分组(含销售类型)</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="dropdowntree" uglcw-options="
											placeholder:'客户所属区域',
											url: '${base}manager/sysRegions',
											dataTextField: 'text',
											dataValueField: 'id'
										" uglcw-model="regionId"></select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="epCustomerName" placeholder="所属二批"/>
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
                    responsive:['.header',40],
                    mergeBy:'proName',
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    autoBind: false,
                    url: '${base}manager/customerSaleGrossProfitStat/statPages',
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
                        q.filterDataType = filterDataType;
                        uglcw.ui.openTab('客户销售统计明细', '${base}manager/customerSaleGrossProfitStat/toStatItemPages?1=1&' + $.map(q, function(v, k){
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
                <div data-field="price" uglcw-options="width:120,format: '{0:n2}'">平均销售单价</div>
                <div data-field="qty"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.qty || 0, \'n2\')#',
                        headerTemplate: uglcw.util.template($('#sort_js').html())({data:{title:'qty'}})">
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
                     footerTemplate: '#= uglcw.util.toString(data.saleAmt || 0, \'n2\')#',
                        headerTemplate: uglcw.util.template($('#sort_js').html())({data:{title:'saleAmt'}})">
                    销售收入
                </div>
                <div data-field="costAmt"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.costAmt || 0, \'n2\')#',
                        headerTemplate: uglcw.util.template($('#sort_js').html())({data:{title:'costAmt'}})">
                    销售成本
                </div>
                <div data-field="grossAmt"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.grossAmt || 0, \'n2\')#',
                        headerTemplate: uglcw.util.template($('#sort_js').html())({data:{title:'grossAmt'}})">
                    销售毛利
                </div>
                <div data-field="grossPrice"
                     uglcw-options="width:120,
                     format: '{0:n2}',
                     footerTemplate: '#= uglcw.util.toString(data.grossPrice || 0, \'n2\')#',
                        headerTemplate: uglcw.util.template($('#sort_js').html())({data:{title:'grossPrice'}})">
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
                     footerTemplate: '#= uglcw.util.toString(data.grossRate || 0, \'n2\')#',
                        headerTemplate: uglcw.util.template($('#sort_js').html())({data:{title:'grossRate'}})">
                    毛利率
                </div>
                <div data-field="">
                </div>
            </div>
        </div>
    </div>
</div>

<script id="sort_js" type="text/x-uglcw-template">
    #if(data.title==='qty'){#
    <span id="qty_span" onclick="javascript:reportSort('qty','qty');">销售数量</span>
    #}else if(data.title==='saleAmt'){#
    <span id="saleAmt_span" onclick="javascript:reportSort('sale_amt','saleAmt');">销售收入</span>
    #}else if(data.title==='costAmt'){#
    <span id="costAmt_span" onclick="javascript:reportSort('cost_amt','costAmt');">销售成本</span>
    #}else if(data.title==='grossAmt'){#
    <span id="grossAmt_span" onclick="javascript:reportSort('gross_amt','grossAmt');">销售毛利</span>
    #}else if(data.title==='grossPrice'){#
    <span id="grossPrice_span" onclick="javascript:reportSort('gross_price','grossPrice');">平均单位毛利</span>
    #}else if(data.title==='grossRate'){#
    <span id="grossRate_span" onclick="javascript:reportSort('gross_rate','grossRate');">毛利率</span>
    #}#
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
<script type="text/x-kendo-template" id="toolbar">
    <span>&nbsp;&nbsp;&nbsp;</span>
    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>导出
    </a>
    <input id="showDataRadio1"  type="radio" class="k-radio" onclick="javascript:filterData(1);" checked name="showDataRadio" value="1"/><label class="k-radio-label" for="showDataRadio1">显示大单位</label>
    <input id="showDataRadio2" type="radio"  class="k-radio" onclick="javascript:filterData(2);"  name="showDataRadio" value="2"/><label class="k-radio-label" for="showDataRadio2">显示小单位</label>
    <input id="showDataRadio3" type="radio"  class="k-radio" onclick="javascript:filterData(3);"  name="showDataRadio" value="3"/><label class="k-radio-label" for="showDataRadio3">显示大小单位</label>
    &nbsp;&nbsp;&nbsp;
<%--    <a role="button" href="javascript:print();" class="k-button k-button-icontext">--%>
<%--        <span class="k-icon k-i-info"></span>打印--%>
<%--    </a>--%>

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
                                url:'${base}manager/syswaretypes?isType=0',
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
                                url:'${base}manager/syswaretypes?isType=1',
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
                                url:'${base}manager/syswaretypes?isType=2',
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
                                url:'${base}manager/syswaretypes?isType=3',
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
<tag:exporter-complex service="customerSaleGrossProfitStatService" method="statPages"
                      bean="com.qweib.cloud.biz.erp.report.query.CustomerSaleGrossProfitStatQuery"
                      condition=".query" description="客户销售毛利统计表"
/>
<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<script>
    function reportSort(field,title){
        //目前仅客户分组可进行排序，商品分组不支持排序
        var showGroupType = uglcw.ui.get('#showGroupType').value();
        if(showGroupType!=1){
            return;
        }
        var sort;
        var obj = $("#"+title+"_span");
        var str = obj.html();
        if(str.indexOf(' ')==-1){
            obj.html(str+" ↓");
            sort = field + " desc ";
        }else if(str.indexOf('↓')!== -1){
            obj.html(str.substring(0,str.indexOf(" "))+" ↑");
            sort = field + " asc ";
        }else{
            obj.html(str.substring(0,str.indexOf(" ")));
            sort = "";
        }
        clearOtherSort(title);
        uglcw.ui.get('#sort').value(sort);
        //reload进行排序
        uglcw.ui.get('#grid').reload();
    }
    function clearOtherSort(title){
        if("qty"===title){
            $("#saleAmt_span").html("销售收入");
            $("#costAmt_span").html("销售成本");
            $("#grossAmt_span").html("销售毛利");
            $("#grossPrice_span").html("平均单位毛利");
            $("#grossRate_span").html("毛利率");
        }else if("saleAmt"===title){
            $("#qty_span").html("销售数量");
            $("#costAmt_span").html("销售成本");
            $("#grossAmt_span").html("销售毛利");
            $("#grossPrice_span").html("平均单位毛利");
            $("#grossRate_span").html("毛利率");
        }else if("costAmt"===title){
            $("#qty_span").html("销售数量");
            $("#saleAmt_span").html("销售收入");
            $("#grossAmt_span").html("销售毛利");
            $("#grossPrice_span").html("平均单位毛利");
            $("#grossRate_span").html("毛利率");
        }else if("grossAmt"===title){
            $("#qty_span").html("销售数量");
            $("#costAmt_span").html("销售成本");
            $("#saleAmt_span").html("销售收入");
            $("#grossPrice_span").html("平均单位毛利");
            $("#grossRate_span").html("毛利率");
        }else if("grossPrice"===title){
            $("#qty_span").html("销售数量");
            $("#costAmt_span").html("销售成本");
            $("#saleAmt_span").html("销售收入");
            $("#grossAmt_span").html("销售毛利");
            $("#grossRate_span").html("毛利率");
        }else if("grossRate"===title){
            $("#qty_span").html("销售数量");
            $("#costAmt_span").html("销售成本");
            $("#saleAmt_span").html("销售收入");
            $("#grossAmt_span").html("销售毛利");
            $("#grossPrice_span").html("平均单位毛利");
        }else{
            $("#qty_span").html("销售数量");
            $("#costAmt_span").html("销售成本");
            $("#saleAmt_span").html("销售收入");
            $("#grossAmt_span").html("销售毛利");
            $("#grossPrice_span").html("平均单位毛利");
            $("#grossRate_span").html("毛利率");
            uglcw.ui.get('#sort').value("");
        }
    }
    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#showGroupType').on('change', function () {
            clearOtherSort();
            uglcw.ui.get('#grid').reload();
            filterField();
        });

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
            filterField();
        })

        $('#waretype').on('change',function () {
            if(!uglcw.ui.get('#waretype').value()){
                uglcw.ui.bind('.uglcw-query',{isType:''});
            }
        })
        uglcw.ui.get('#xsTp').k().dataSource.read();
        filterField();
        uglcw.ui.loaded()
    })

    var filterDataType = 1;
    function filterData(v){
        filterDataType = v;
        filterField();
    }

    function filterField(){
        var grid = uglcw.ui.get('#grid');
        var showGroupType = uglcw.ui.get("#showGroupType").value();
        if(showGroupType!=1){
            grid.hideColumn('xsTp');
            grid.showColumn('wareNm');
            grid.showColumn('unitName');
            grid.showColumn('minUnitName');
            grid.showColumn('price');
            grid.showColumn('minPrice');
            if(showGroupType==3){
                grid.showColumn('xsTp');
            }
        }
        filteCommon();
    }

    function filteCommon(){
        var grid = uglcw.ui.get('#grid');
        if(filterDataType==1){
            grid.showColumn('qty');
            grid.showColumn('unitName');
            grid.showColumn('price');
            grid.showColumn('grossPrice');
            grid.hideColumn('minQty');
            grid.hideColumn('minUnitName');
            grid.hideColumn('minPrice');
            grid.hideColumn('minGrossPrice');
        }else if(filterDataType==2){
            grid.hideColumn('qty');
            grid.hideColumn('unitName');
            grid.hideColumn('price');
            grid.hideColumn('grossPrice');
            grid.showColumn('minQty');
            grid.showColumn('minUnitName');
            grid.showColumn('minPrice');
            grid.showColumn('minGrossPrice');
        }else if(filterDataType==3){
            grid.showColumn('qty');
            grid.showColumn('unitName');
            grid.showColumn('price');
            grid.showColumn('grossPrice');
            grid.showColumn('minQty');
            grid.showColumn('minUnitName');
            grid.showColumn('minPrice');
            grid.showColumn('minGrossPrice');
        }
        var showGroupType = uglcw.ui.get("#showGroupType").value();
        if(showGroupType==1){
            grid.hideColumn('wareNm');
            grid.hideColumn('unitName');
            grid.hideColumn('minUnitName');
            grid.hideColumn('price');
            grid.hideColumn('minPrice');
            grid.hideColumn('xsTp');
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
        uglcw.ui.openTab('打印客户销售统计表', "${base}manager/customerSaleStat/toStatPrint?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function waretype() {
        var i = uglcw.ui.Modal.open({
            checkbox:true,
            selection:'single',
            title:false,
            maxmin:false,
            resizable:false,
            move:true,
            btns:['确定','取消'],
            area:['400','415px'],
            content:$('#product-type-selector-template').html(),
            success:function (c) {
                uglcw.ui.init(c);

            },
            yes:function (c) {
                uglcw.ui.get("#isType").value(uglcw.ui.get($(c).find('#_isType')).value())
                uglcw.ui.get("#waretype").value(uglcw.ui.get($(c).find('#wtypename')).value());
                uglcw.ui.get("#waretype").text(uglcw.ui.get($(c).find('#_type_id')).value());
                uglcw.ui.Modal.close(i);
                return false;

            }
        })
    }

</script>
</body>
</html>
