<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>业务销售统计表</title>
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
            margin-top: 1px;
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
                    <input type="hidden" id="database" uglcw-model="database" uglcw-role="textbox" value="${database}" >
                    <select uglcw-model="timeType" id="timeType" uglcw-role="combobox"
                            uglcw-options="placeholder:'时间类型',value: '1',clearButton: false">
                        <option value="1">发货时间</option>
                        <option value="2">销售时间</option>
                        <option value="3">收款时间</option>
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
                    <input uglcw-role="textbox" uglcw-model="staff" placeholder="业务员"/>
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="商品名称" uglcw-model="wareNm">
                </li>
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="0" id="isType">
                    <input uglcw-role="gridselector" uglcw-model="wtypename,wtype" id="wtype" placeholder="资产类型"
                           uglcw-options="
                           value:'库存商品类',
                           click:function(){
                                    waretype()
                           }
                    ">
                </li>
                <li>

                    <select uglcw-model="isExpand" id="showProducts" uglcw-role="combobox"
                            uglcw-options="placeholder:'显示数据',value: '1'">
                        <option value="1">只显示业务员分组</option>
                        <option value="-1">显示商品分组</option>
                        <option value="0">显示商品分组(含销售类型)</option>
                    </select>
                    <%--<input type="checkbox" uglcw-model="isExpand" uglcw-options="type:'number'"--%>
                           <%--uglcw-role="checkbox"--%>
                           <%--id="showProducts">--%>
                    <%--<label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>--%>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    autoBind: false,
                    url: '${base}manager/queryEmptatMast',
                    criteria: '.uglcw-query',
                    query: function(params){
                        <%--params.isExpand = params.isExpand ? 0 : 1;--%>
                        return params;
                    },
                    pageable: true,
                    rowNumber: true,
                    aggregate:[
                     {field: 'qty', aggregate: 'sum'}
                    ],
                     dblclick: function(row){
                        var q = uglcw.ui.bind('.uglcw-query');

                        q.driverName = row.driverName;
                        var empId = row.empId;
                        var xsTp = row.xsTp;

				        var wareId = row.wareId;
				        if(xsTp == undefined)xsTp = '';
                        if(empId == undefined)empId = 0;
                        if(wareId == undefined)wareId = 0;
                        //if(xsTp == '')xsTp = q['xsTp'];

                        if(!uglcw.ui.get('#showProducts').value())
                        {
                            wareId = 0;
                            xsTp = uglcw.ui.get('#xsTp').value();
                            //xsTp = '';
                        }
                        delete q['xsTp'];
                        uglcw.ui.openTab('业务销售统计明细', '${base}manager/toStkEmpStatDetail?empId=' + empId +  '&wareId='+ wareId +'&filterDataType='+filterDataType+'&xsTp=' + xsTp + '&' + $.map(q, function(v, k){
                            return k+'='+(v||'');
                        }).join('&'));
                    },
                      dataBound: function(){
                        filterField();
                     },
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        var rows = response.rows || [];
                        if(uglcw.ui.get('#showProducts').value()){
                            var showProducts = uglcw.ui.get('#showProducts').value();
                            rows = [];
                            $(response.rows).each(function(idx, row){
                                var hit = rows.find(function(item){
                                   return item.empId == row.empId
                                })
                                if(!hit){
                                    row.products = [
                                        {
                                         wareNm: row.wareNm,
                                         wareId: row.wareId,
                                         xsTp: row.xsTp,
                                         unitName: row.unitName,
                                         price: row.price,
                                         amt: row.amt,
                                         qty: row.qty,
                                         outQty: row.outQty,
                                         outAmt: row.outAmt,
                                         minOutQty: row.minOutQty,
                                         minQty: row.minQty,
                                         minPrice:row.minPrice,
                                         minUnitName: row.minUnitName
                                         }
                                    ]
                                     row.showProducts = showProducts;
                                    rows.push(row);
                                }else{
                                    hit.products.push({
                                         wareNm: row.wareNm,
                                         wareId: row.wareId,
                                         xsTp: row.xsTp,
                                         unitName: row.unitName,
                                         price: row.price,
                                         amt: row.amt,
                                         qty: row.qty,
                                         outQty: row.outQty,
                                         outAmt: row.outAmt,
                                         minOutQty: row.minOutQty,
                                         minQty: row.minQty,
                                         minPrice:row.minPrice,
                                         minUnitName: row.minUnitName
                                    })

                                }
                            });
                        }
                          $(rows).each(function(idx, row){
                            row.index = idx;
                         })
                        return rows;
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
                <div data-field="staff" uglcw-options="width:150, tooltip: true, footerTemplate:'合计'">业务员</div>
                <div data-field="branchName" uglcw-options="width: 150, tooltip: true">部门</div>
                <div data-field="products"
                     uglcw-options="width:1050, hidden:true,
                      attributes:{class: 'product-grid'},
                      footerAttributes: {class: 'product-footer'},
                      footerTemplate: uglcw.util.template($('#product-footer-tpl').html()),
                      template: uglcw.util.template($('#product-tpl').html())">商品信息
                </div>
                <div data-field="qty"
                     uglcw-options="width:120,attributes:{ class: 'router-link', 'data-field': 'qty'}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.qty.sum != undefined ? data.qty.sum : data.qty, \'n2\')#'">
                    销售数量
                </div>
                <div data-field="minQty"
                     uglcw-options="width:120,attributes:{ class: 'router-link', 'data-field': 'qty'}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minQty || 0, \'n2\')#'">
                    销售数量(小)
                </div>
                <div data-field="outQty"
                     uglcw-options="width:120,attributes:{ class: 'router-link', 'data-field': 'outQty'}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty || 0, \'n2\')#'">
                    发货数量
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
                <div data-field="recAmt"
                     uglcw-options="width:120,attributes:{ class: 'router-link', 'data-field': 'recAmt'}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.recAmt || 0, \'n2\')#'">
                    回款金额
                </div>
                <div data-field="needRec"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.needRec || 0, \'n2\')#'">
                    未回款金额
                </div>
                <div data-field=""
                    >
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
    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>导出
    </a>
    <a role="button" href="javascript:createRptData();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>生成报表
    </a>
    <a role="button" href="javascript:queryRpt();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>查询生成的报表
    </a>


    <a role="button" href="javascript:print();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>打印
    </a>

    <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <input id="showDataRadio1"  type="radio" class="k-radio" onclick="javascript:filterData(1);" checked name="showDataRadio" value="1"/><label class="k-radio-label" for="showDataRadio1">显示大单位</label>
    <input id="showDataRadio2" type="radio"  class="k-radio" onclick="javascript:filterData(2);"  name="showDataRadio" value="2"/><label class="k-radio-label" for="showDataRadio2">显示小单位</label>
    <input id="showDataRadio3" type="radio"  class="k-radio" onclick="javascript:filterData(3);"  name="showDataRadio" value="3"/><label class="k-radio-label" for="showDataRadio3">显示大小单位</label>
</script>
<script id="product-tpl" type="text/x-uglcw-template">
    # if(data.products){ #
    <table class="product-table">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;text-align: center">商品名称</td>
            # if(data.showProducts==0){ #
            <td style="width: 80px;text-align: center">销售类型</td>
            #}#
            <td class="_max_class" style="width: 60px;text-align: center">计量单位</td>
            <td class="_max_class" style="width: 60px;text-align: center">销售单价</td>
            <td class="_max_class" style="width: 60px;text-align: center">销售数量</td>
            <td class="_max_class" style="width: 60px;text-align: center">发货数量</td>
            <td  class="_min_class" style="width: 80px;text-align: center">计量单位(小)</td>
            <td  class="_min_class" style="width: 60px;text-align: center">销售单价(小)</td>
            <td  class="_min_class" style="width: 80px;text-align: center">销售数量(小)</td>
            <td  class="_min_class" style="width: 80px;text-align: center">发货数量(小)</td>
            <td style="width: 60px;text-align: center">销售金额</td>
            <td style="width: 60px;text-align: center">发货金额</td>
        </tr>
        #for (var i=0; i< data.products.length; i++) { #
        <tr>
            <td style="width: 120px;padding-left: 5px">#= data.products[i].wareNm #</td>
            # if(data.showProducts==0){ #
            <td style="width: 80px;text-align: center">#= data.products[i].xsTp #</td>
            #}#
            <td class="_max_class" style="width: 60px;text-align: center;">#= data.products[i].unitName #</td>
            <td class="_max_class"
                    data-field="price"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].price){#
                    style="width: 60px;text-align: right;padding-right: 5px;"
                    #}#
            >#= uglcw.util.toString(data.products[i].price,'n2')#</td>
            <td class="_max_class"
                    data-field="qty"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].qty){#
                    style="width: 60px;text-align: right;padding-right: 5px;"
                    #}#
            >#= uglcw.util.toString(data.products[i].qty,'n2')#
            </td>

            <td class="_max_class"
                    data-field="outQty"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].outQty){#
                    style="width: 60px;text-align: right;padding-right: 5px;"
                    #}#
            >#= uglcw.util.toString(data.products[i].outQty,'n2')#
            </td>

            <td  class="_min_class" style="width: 80px;text-align: center;color: blue">#= data.products[i].minUnitName #</td>
            <td
                    class="_min_class"
                    data-field="minPrice"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].price){#
                    style="width: 60px;text-align: right;padding-right: 5px;"
                    #}#
            >#= uglcw.util.toString(data.products[i].minPrice,'n2')#</td>
            <td
                    class="_min_class"
                    data-field="minQty"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].minQty){#
                    style="width: 80px;text-align:right;color: blue"
                    #}#
            >#= uglcw.util.toString(data.products[i].minQty,'n2')#
            </td>
            <td
                    class="_min_class"
                    data-field="minOutQty"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].minOutQty){#
                    style="width: 80px;text-align: right;padding-right: 5px;color: blue"
                    #}#
            >#= uglcw.util.toString(data.products[i].minOutQty,'n2')#
            </td>
            <td
                    data-field="amt"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].amt){#
                    style="width: 60px;text-align: right;padding-right: 5px;"
                    #}#
            >#= uglcw.util.toString(data.products[i].amt,'n2')#
            </td>
            <td
                    data-field="outAmt"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].outAmt){#
                    style="width: 60px;text-align: right;padding-right: 5px;"
                    #}#
            >#= uglcw.util.toString(data.products[i].outAmt,'n2')#
            </td>
        </tr>
        # }#
        </tbody>
    </table>
    # } #
</script>
<script id="product-footer-tpl" type="text/x-uglcw-template">
    <div class="product-table">
        <span class="router-link" data-field="qty" style="width: 60px;">#= uglcw.util.toString(data.qty, 'n2')#</span>
        <span class="router-link" data-field="outQty"
              style="width: 60px;">#= uglcw.util.toString(data.outQty, 'n2')#</span>
        <span class="router-link" data-field="minQty" style="width: 60px;">#= uglcw.util.toString(data.minQty, 'n2')#</span>
        <span class="router-link" data-field="outQty"
              style="width: 60px;">#= uglcw.util.toString(data.outQty, 'n2')#</span>
        <span class="router-link" data-field="amt" style="width: 60px;">#= uglcw.util.toString(data.amt, 'n2')#</span>
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
<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<tag:exporter service="incomeStatService" method="sumEmpStatMast"
              bean="com.qweib.cloud.biz.erp.model.StkOut"
              beforeExport="onBeforeExport"
              condition=".query" description="业务销售统计表"

/>
<script>


    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid');
            grid.reload();
            if (checked==1) {
                grid.hideColumn('products');
                grid.showColumn('wareNm');
                grid.hideColumn('qty');
                grid.hideColumn('amt');
                grid.hideColumn('outQty');
                grid.hideColumn('outAmt');
                grid.hideColumn('minQty');
                grid.hideColumn('minOutQty');
            } else {
                grid.showColumn('products');
                grid.hideColumn('wareNm');
                grid.showColumn('qty');
                grid.showColumn('amt');
                grid.showColumn('outQty');
                grid.showColumn('outAmt');
                grid.showColumn('minQty');
                grid.showColumn('minOutQty');
            }
        });

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        $('#wtype').on('change',function () {
            if(!uglcw.ui.get('#wtype').value()){
                uglcw.ui.bind('.uglcw-query',{isType:''});
            }
        })

        $('#grid').on('click', '.router-link', function () {
            var $td = $(this);
            var $tr, field = $td.data('field'),wareId =$td.data('ware-id'), row;
            if (wareId) {
                //点击商品明细中的单元格
                $tr = $td.closest('.product-table').closest('tr');
            } else {
                $tr = $td.closest('tr');
            }
            row = uglcw.ui.get('#grid').k().dataItem($tr);
            if(wareId){
                var ware = {};
                //从当前行数据查找完整的商品信息
                $(row.products).each(function(){
                    if(this.wareId === wareId){
                        ware = this;
                        return false;
                    }
                });
                //合并属性
                row = uglcw.extend({}, row, ware);
            }
            onCellClick(field, row);
        });
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
            grid.hideColumn('minQty');
            grid.hideColumn('minOutQty');
            $("._max_class").show();
            $("._min_class").hide();
        }else if(filterDataType==2){
            grid.hideColumn('qty');
            grid.hideColumn('outQty');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
            $("._max_class").hide();
            $("._min_class").show();
        }else if(filterDataType==3){
            grid.showColumn('qty');
            grid.showColumn('outQty');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
            $("._max_class").show();
            $("._min_class").show();
        }
    }

    function onBeforeExport(query){
        delete query['wtypename']
        return query;
    }
    function createRptData() {
        var query = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('生成业务销售统计汇总表', "${base}manager/toStkEmpStatSave?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function queryRpt() {
        uglcw.ui.openTab('生成的统计表', '${base}manager/toStkCstStatQuery?rptType=7');
    }

    function onCellClick(field, row) {

        if (field == "qty"||field == "minQty" || field == "amt") {
            var q = uglcw.ui.bind('.uglcw-query');

            //q.driverName = row.driverName;
            var empId = row.empId;
            var xsTp = row.xsTp;

            var wareId = row.wareId;
            if (xsTp == undefined) xsTp = '';
            if (empId == undefined) empId = 0;
            if (wareId == undefined) wareId = 0;
            if(xsTp == '')
            xsTp = uglcw.ui.get('#xsTp').value();
            if (!uglcw.ui.get('#showProducts').value()) {
                wareId = 0;
                xsTp = uglcw.ui.get('#xsTp').value();
                //alert(xsTp);
            }

            delete q['xsTp'];
            uglcw.ui.openTab('业务销售统计明细', '${base}manager/toStkEmpStatDetail?empId=' + empId + '&filterDataType='+filterDataType+'&xsTp=' + xsTp + '&wareId=' + wareId + '&' + $.map(q, function (v, k) {
                return k + '=' + (v || '');
            }).join('&'));
        }

        if (field == "outQty"||field == "minOutQty" || field == "outAmt") {
            var q = uglcw.ui.bind('.form-horizontal');
            delete q['xsTp'];
            //q.driverName = row.driverName;
            var empId = row.empId;
            var xsTp = row.xsTp;

            var wareId = row.wareId;
            if (xsTp == undefined) xsTp = '';
            if (empId == undefined) empId = 0;
            if (wareId == undefined) wareId = 0;
            if (!uglcw.ui.get('#showProducts').value()) {
                wareId = 0;
                xsTp = '';
            }
            uglcw.ui.openTab('业务销售统计发货明细', '${base}manager/toStkEmpSendDetail?empId=' + empId + '&filterDataType='+filterDataType+'&xsTp=' + xsTp + '&wareId=' + wareId + '&' + $.map(q, function (v, k) {
                return k + '=' + (v || '');
            }).join('&'));
        }


        if (field == "recAmt") {
            var q = uglcw.ui.bind('.form-horizontal');
            delete q['xsTp'];
            //q.driverName = row.driverName;
            var empId = row.empId;
            var xsTp = row.xsTp;

            var wareId = row.wareId;
            if (xsTp == undefined) xsTp = '';
            if (empId == undefined) empId = 0;
            if (wareId == undefined) wareId = 0;
            if (!uglcw.ui.get('#showProducts').value()) {
                wareId = 0;
                xsTp = '';
            }
            uglcw.ui.openTab('业务销售统计发货明细', '${base}manager/toStkEmpRecDetail?empId=' + empId + '&xsTp=' + xsTp + '&wareId=' + wareId + '&' + $.map(q, function (v, k) {
                return k + '=' + (v || '');
            }).join('&'));
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
        query.showWareCheck = query.isExpand;
        uglcw.ui.openTab('打印业务销售统计表', "${base}manager/toStkEmpStatPrint?" + $.map(query, function (v, k) {
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
