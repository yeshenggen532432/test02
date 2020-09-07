<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户销售统计表</title>
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
            <ul class="uglcw-query form-horizontal">
                <li>
                    <select uglcw-model="timeType" id="timeType" uglcw-role="combobox"  uglcw-options="clearButton: false">
                        <option value="1">发货时间</option>
                        <option value="2">发票时间</option>
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
                    <input uglcw-role="textbox" placeholder="客户名称" uglcw-model="khNm">
                </li>
                <li>
                <input uglcw-role="textbox" placeholder="业务员" uglcw-model="staff">
                 </li>
                <li>
                    <input uglcw-role="textbox" placeholder="商品名称" uglcw-model="wareNm">
                </li>
                <li>
                    <tag:select2 name="carId" id="carId" tableName="stk_vehicle" headerKey=""
                                 headerValue="--车辆--" displayKey="id" displayValue="veh_no"/>
                </li>
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="0" id="isType">
                    <input uglcw-role="gridselector" uglcw-model="wtypename,wtype" id="wtype" placeholder="资产类型"
                           uglcw-options="
                           value:'库存商品类',
                           click: function(){
                                    waretype()
                           }
                    ">
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

                    <select uglcw-model="showWareCheck" id="showProducts" uglcw-role="combobox"
                            uglcw-options="placeholder:'显示数据',value: '0'">
                        <option value="0">只显示客户分组</option>
                        <option value="2">显示商品分组</option>
                        <option value="1">显示商品分组(含销售类型)</option>
                    </select>
                    <%--<input type="checkbox" uglcw-model="showWareCheck" uglcw-role="checkbox"--%>
                           <%--id="showProducts">--%>
                    <%--<label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>--%>
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
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/queryCstStatMast',
                    criteria: '.form-horizontal',
                    autoBind: false,
                    pageable: true,
                     rowNumber: true,
                    aggregate:[
                     {field: 'qty', aggregate: 'sum'}

                    ],
                    dblclick: function(row){
                        var q = uglcw.ui.bind('.uglcw-query');
                        //delete q['xsTp'];
                        //q.driverName = row.driverName;
                        var cstId = row.cstId;
                        var xsTp = row.xsTp;
                        var khNm = row.khNm;
                        q.khNm = khNm;
				        var wareId = row.wareId;
				        if(xsTp == undefined)xsTp = '';
                        //if(empId == undefined)empId = 0;
                        if(wareId == undefined)wareId = 0;
                        if(!uglcw.ui.get('#showProducts').value())
                        {
                            wareId = 0;
                            //xsTp = '';
                        }

                        q.filterDataType=filterDataType;
                        uglcw.ui.openTab('客户销售统计明细', '${base}manager/toStkCstStatDetail?cstId=' + cstId + '&wareId='+ wareId  + '&' + $.map(q, function(v, k){
                            return k+'='+(v||'');
                        }).join('&'));
                    },
                     dataBound: function(){
                        filterField();
                     },
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        var rows = [];
                        $(response.rows).each(function(idx, row){
                            var hit = rows.find(function(item){
                               return item.cstId == row.cstId
                            })
                           var showProducts = uglcw.ui.get('#showProducts').value();
                            if(!hit){
                                row.products = [
                                    {wareNm: row.wareNm, wareId: row.wareId, xsTp: row.xsTp, unitName: row.unitName, minUnitName: row.minUnitName, price: row.price,minPrice:row.minPrice,qty:row.qty,minQty:row.minQty,amt:row.amt,outQty:row.outQty,minOutQty:row.minOutQty,outAmt:row.outAmt}
                                ]
                                row.showProducts = showProducts;
                                rows.push(row);
                            }else{
                                hit.qty+=row.qty;
                                hit.amt+=row.amt;
                                hit.outQty+=row.outQty;
                                hit.outAmt+=row.outAmt;

                                hit.minQty+=row.minQty;
                                hit.minOutQty+=row.minOutQty;

                                hit.products.push({wareNm: row.wareNm, wareId: row.wareId, xsTp: row.xsTp, unitName: row.unitName,minUnitName: row.minUnitName, price: row.price,minPrice:row.minPrice,qty:row.qty,minQty:row.minQty,amt:row.amt,outQty:row.outQty,minOutQty:row.minOutQty,outAmt:row.outAmt})
                            }
                        })
                         $(rows).each(function(idx, row){
                            row.index = idx;
                         })

                        return rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            qty: 0,amt:0, outQty: 0, outAmt:0, recAmt:0, needRec:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="khNm" uglcw-options="width:150, tooltip: true, footerTemplate:'合计'">客户名称</div>

                <div data-field="products"
                     uglcw-options="width:1050, hidden:true,
                      attributes:{class: 'product-grid'},
                      footerAttributes: {class: 'product-footer'},
                      footerTemplate: uglcw.util.template($('#product-footer-tpl').html()),
                      template: uglcw.util.template($('#product-tpl').html())">商品信息
                </div>
                <div data-field="qty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.qty.sum != undefined ? data.qty.sum : data.qty || 0, \'n2\')#'">
                    销售数量
                </div>
                <div data-field="minQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate:'#= uglcw.util.toString(data.minQty || 0, \'n2\')#'">
                    销售数量(小)
                </div>

                <div data-field="outQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty || 0, \'n2\')#'">
                    发货数量
                </div>
                <div data-field="minOutQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minOutQty || 0, \'n2\')#'">
                    发货数量(小)
                </div>
                <div data-field="amt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate:'#= uglcw.util.toString(data.amt || 0, \'n2\')#'">
                    销售金额
                </div>
                <div data-field="outAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt || 0, \'n2\')#'">
                    发货金额
                </div>
                <div data-field="recAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.recAmt || 0, \'n2\')#'">
                    回款金额
                </div>
                <div data-field="needRec"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.needRec || 0, \'n2\')#'">
                    未回款金额
                </div>
                <div data-field="epCustomerName" uglcw-options="width:120">所属二批</div>
                <div data-field="address" uglcw-options="width: 200, tooltip: true">客户地址</div>
                <div data-field="">
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">

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
<script id="product-footer-tpl" type="text/x-uglcw-template">
    <div class="product-table">
        <span class="router-link" data-field="qty" style="width: 50px;">#= uglcw.util.toString(data.qty, 'n2')#</span>
        <span class="router-link" data-field="minQty" style="width: 50px;">#= uglcw.util.toString(data.minQty, 'n2')#</span>
        <span class="router-link" data-field="amt" style="width: 60px;">#= uglcw.util.toString(data.amt, 'n2')#</span>
        <span class="router-link" data-field="outQty"
              style="width: 50px;">#= uglcw.util.toString(data.outQty, 'n2')#</span>
        <span class="router-link" data-field="minOutQty"
              style="width: 50px;">#= uglcw.util.toString(data.minOutQty, 'n2')#</span>
        <span class="router-link" data-field="outAmt"
              style="width: 60px;">#= uglcw.util.toString(data.outAmt, 'n2')#</span>
    </div>
</script>
<script id="product-tpl" type="text/x-uglcw-template">
    <table class="product-grid" style="padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;text-align: center">商品名称</td>
            # if(data.showProducts==1){ #
            <td style="width: 80px;text-align: center">销售类型</td>
            #}#
            <td class="_max_class" style="width: 60px;text-align: center">计量单位</td>
            <td class="_max_class" style="width: 60px;text-align: center">价格</td>
            <td class="_max_class" style="width: 60px;text-align: center">发票数量</td>
            <td class="_max_class" style="width: 60px;text-align: center">发货数量</td>
            <td class="_min_class" style="width: 60px;text-align: center;color:blue">计量单位(小)</td>
            <td class="_min_class" style="width: 60px;text-align: center;color:blue">价格(小)</td>
            <td class="_min_class" style="width: 60px;text-align: center;color:blue">发票数量(小)</td>
            <td class="_min_class" style="width: 60px;text-align: center;color:blue">发货数量(小)</td>
            <td style="width: 60px;text-align: center">发票金额</td>
            <td style="width: 60px;text-align: center">发货金额</td>
        </tr>
        #for (var i=0; i< data.products.length; i++) { #
        <tr>
            <td style="width: 120px;padding-left: 5px">#= data.products[i].wareNm #</td>
            # if(data.showProducts==1){ #
            <td  style="width: 80px;text-align: center">#= data.products[i].xsTp #</td>
            #}#
            <td class="_max_class" style="width: 60px;text-align: center;">#= data.products[i].unitName #</td>
            <td
                    class="_max_class"
                    style="width: 60px;text-align: right;padding-right: 5px"
                    data-field="price"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].price){#
                    #}#
            >#= uglcw.util.toString(data.products[i].price,'n2')#</td>

            <td
                    class="_max_class"
                    style="width: 60px;text-align: right;padding-right: 5px"
                    data-field="qty"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].qty){#
                    #}#
            >#= uglcw.util.toString(data.products[i].qty,'n2')#
            </td>

            <td
                    class="_max_class"
                    style="width: 60px;text-align: right;padding-right: 5px"
                    data-field="outQty"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].outQty){#
                    #}#
            >#= uglcw.util.toString(data.products[i].outQty,'n2')#
            </td>

            <td class="_min_class" style="width: 60px;text-align: center;color: blue">#= data.products[i].minUnitName #</td>
            <td
                    class="_min_class"
                    style="width: 60px;text-align: right;padding-right: 5px;color: blue"
                    data-field="price"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].minPrice){#
                    #}#
            >#= uglcw.util.toString(data.products[i].minPrice,'n2')#</td>
            <td
                    class="_min_class"
                    style="width: 60px;text-align: right;padding-right: 5px;color: blue"
                    data-field="minQty"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].qty){#
                    #}#
            >#= uglcw.util.toString(data.products[i].minQty,'n2')#
            </td>
            <td
                    class="_min_class"
                    style="width: 60px;text-align: right;padding-right: 5px;color: blue"
                    data-field="minOutQty"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].minQutQty){#
                    #}#
            >#= uglcw.util.toString(data.products[i].minOutQty,'n2')#
            </td>

            <td
                    style="width: 60px;text-align: right;padding-right: 5px"
                    data-field="amt"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].amt){#
                    #}#
            >#= uglcw.util.toString(data.products[i].amt,'n2')#
            </td>
            <td
                    style="width: 60px;text-align: right;padding-right: 5px"
                    data-field="outAmt"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].outAmt){#
                    #}#
            >#= uglcw.util.toString(data.products[i].outAmt,'n2')#
            </td>
        </tr>
        # }#
        </tbody>
    </table>
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
<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<script>

    var filterDataType = 1;
    $(function () {
        uglcw.ui.init();
        $('.q-box-arrow').on('click', function () {
            $(this).find('i').toggleClass('k-i-arrow-chevron-left k-i-arrow-chevron-down');
            $('.q-box-more').toggle();
            $('.q-box-wrapper').closest('.layui-card').toggleClass('box-shadow')
        })

        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid');
            grid.reload();
            if(checked==0){
                grid.hideColumn('products');
                grid.showColumn('qty');
                grid.showColumn('minQty');
                grid.showColumn('amt');
                grid.showColumn('minOutQty');
                grid.showColumn('outQty');
                grid.showColumn('outAmt');
            }else{
                grid.showColumn('products');
                grid.hideColumn('qty');
                grid.hideColumn('minQty');
                grid.hideColumn('amt');
                grid.hideColumn('minOutQty');
                grid.hideColumn('outQty');
                grid.hideColumn('outAmt');
            }
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#xsTp').k().dataSource.read();

        $('#wtype').on('change', function () {
            if(!uglcw.ui.get('#wtype').value()){
                uglcw.ui.bind('.form-horizontal', {isType: ''})  //清空当前id为wtype搜索框内容
            }
        })
        filterField();
        uglcw.ui.loaded()
    })

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

        uglcw.ui.openTab('打印客户销售统计表', "${base}manager/toStkCstStatPrint?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function createRptData() {
        var query = uglcw.ui.bind('.form-horizontal');
        if(query.showWareCheck==0){
            query.showWareCheck =1;
        }
        uglcw.ui.openTab('生成客户销售统计表', "${base}manager/toStkCstStatSave?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    //销货商品信息
    function queryRpt() {
        uglcw.ui.openTab('生成的统计表', '${base}manager/toStkCstStatQuery?rptType=6');
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
