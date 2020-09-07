<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品销售日报表(新)</title>
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
                <li>
                    <select uglcw-model="timeType" id="timeType" uglcw-role="combobox"
                            uglcw-options="placeholder:'时间类型',value: '1',clearButton: false">
                        <option value="1">发货单</option>
                        <option value="2">销售单</option>
                    </select>
                </li>
                <li>
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
                    <tag:select2 name="carId" id="carId" tableName="stk_vehicle" headerKey=""
                                 headerValue="--车辆--" displayKey="id" displayValue="veh_no"/>
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
                    url: '${base}manager/saleDayStat/statPages',
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
				        var wareId = row.wareId;
                        if(wareId == undefined)wareId = '';
                        q.wareId = wareId;
                        q.filterDataType = filterDataType;
                        uglcw.ui.openTab('商品销售统计明细', '${base}manager/saleDayStat/toStatItemPages?1=1&' + $.map(q, function(v, k){
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
                <div data-field="wareNm" uglcw-options="width: 200, tooltip: true">商品名称</div>
                <div data-field="unitName" uglcw-options="width: 80, tooltip: true">计量单位</div>
                <div data-field="qty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.qty.sum != undefined ? data.qty.sum : data.qty, \'n2\')#'">
                    销售数量
                </div>
                <div data-field="outQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty || 0, \'n2\')#'">
                    发货数量
                </div>
                <div data-field="minUnitName" uglcw-options="width: 100, tooltip: true">计量单位(小)</div>
                <div data-field="minQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minQty || 0, \'n2\')#'">
                    销售数量(小)
                </div>
                <div data-field="minOutQty"
                     uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minOutQty || 0, \'n2\')#'">
                    发货数量(小)
                </div>
                <div data-field="amt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate:'#= uglcw.util.toString(data.amt || 0, \'n2\')#'">
                    销售金额
                </div>
                <div data-field="outAmt"
                     uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt || 0, \'n2\')#'">
                    发货金额
                </div>
                <div data-field="op" uglcw-options="width:180,
                 template: uglcw.util.template($('#opt-tpl').html())">操作
                </div>
            </div>
        </div>
    </div>
</div>
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
    <a role="button" href="javascript:print();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>打印
    </a>
    <span style="color:red">
        注：按销售单查询时，发货数量与时间区间无关，只表示该商品对应销售的累计发货数
    </span>
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

<script id="opt-tpl" type="text-x-uglcw-template">
    <a style="width: 120px" href="javascript:;;" onclick="showItems(2,#=data.wareId#, '#=data.wareNm#')"><i
            class="k-icon"></i>按客户统计
    </a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<tag:exporter-complex service="saleDayStatService" method="statPages"
                      bean="com.qweib.cloud.biz.erp.report.query.SaleDayStatQuery"
                      removeField="op"
                      condition=".query" description="商品销售日报表"
/>

<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<script>
    $(function () {
        uglcw.ui.init();
        //显示商品
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
        if(filterDataType==1){
            grid.showColumn('qty');
            grid.showColumn('outQty');
            grid.showColumn('unitName');
            grid.hideColumn('minQty');
            grid.hideColumn('minOutQty');
            grid.hideColumn('minUnitName');
        }else if(filterDataType==2){
            grid.hideColumn('qty');
            grid.hideColumn('outQty');
            grid.hideColumn('unitName');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
            grid.showColumn('minUnitName');
        }else if(filterDataType==3){
            grid.showColumn('qty');
            grid.showColumn('outQty');
            grid.showColumn('unitName');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
            grid.showColumn('minUnitName');
        }

        var timeType = uglcw.ui.get("#timeType").value();
        if(timeType==1){
            grid.hideColumn('qty');
            grid.hideColumn('minQty');
            grid.hideColumn('amt');
        }else{
            grid.showColumn('amt');
            if(filterDataType==1){
                grid.showColumn('qty');
            }
            if(filterDataType==2||filterDataType==3){
                grid.showColumn('minQty');
            }
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
        uglcw.ui.openTab('打印商品销售统计表', "${base}manager/saleDayStat/toStatPrint?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }


    function showItems(type,wareId,wareNm){
        var url = "${base}manager/toWareDateBillStat?";
        if(type==2){
            url = "${base}manager/saleDayStat/toStatCustomerPages?";
        }
        var q = uglcw.ui.bind('.uglcw-query');
        var wareId = wareId;
        var wareNm = wareNm;
        q.filterDataType=filterDataType;
        q.wareId = wareId;
        q.wareNm = wareNm;
        uglcw.ui.openTab('商品销售日报表-按客户统计', url + $.map(q, function(v, k){
            return k+'='+(v||'');
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
