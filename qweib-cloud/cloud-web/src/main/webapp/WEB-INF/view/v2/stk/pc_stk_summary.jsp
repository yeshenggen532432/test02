<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>收发存汇总表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-grid td.router-link {
            color: blue;
            cursor: pointer;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 150px;" uglcw-options="collapsed: true">
            <div class="layui-card" uglcw-role="resizable" uglcw-options="responsive:[35]">
                <ul uglcw-role="accordion">
                    <li>
                        <span>库存商品类</span>
                        <div uglcw-role="tree" id="tree1"
                             uglcw-options="
                               url: '${base}manager/companyWaretypes?isType=0',
                               expandable: function(node){
                                return node.id === 0;
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
                                uglcw.ui.get('#isType').value(0);
                                uglcw.ui.get('#wareType').value(node.id);
                                uglcw.ui.get('#type').value(0);
                                uglcw.ui.get('#click-flag').value(0);
                                uglcw.ui.get('#grid').reload();
                               },
                              dataBound: function(){
                                   var tree = this;
                                   clearTimeout($('#tree1').data('_timer'));
                                   $('#tree1').data('_timer', setTimeout(function(){
                                       tree.select($('#tree1 .k-item:eq(0)'));
                                       var nodes = tree.dataSource.data().toJSON();
                                       if(nodes && nodes.length > 0){
                                           uglcw.ui.bind('.uglcw-query', {
                                               isType: 0,
                                               type:0,
                                               waretype: nodes[0].id}
                                           );
                                           uglcw.ui.get('#grid').reload();
                                       }
                                  })
                                  )
                                }
                            "
                        ></div>
                    </li>
                    <li>
                        <span>原辅材料类</span>
                        <div uglcw-role="tree"
                             uglcw-options="
                           url: '${base}manager/companyWaretypes?isType=1',
                           expandable: function(node){
                            return node.id === 0;
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
                                uglcw.ui.get('#isType').value(1);
                                uglcw.ui.get('#type').value(1);
                                uglcw.ui.get('#wareType').value(node.id);
                                uglcw.ui.get('#click-flag').value(0);
                                uglcw.ui.get('#grid').reload();
                               }

                            "
                        ></div>
                    </li>
                    <li>
                        <span>低值易耗品类</span>
                        <div uglcw-role="tree"
                             uglcw-options="
                           url: '${base}manager/companyWaretypes?isType=2',
                           expandable: function(node){
                            return node.id === 0;
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
                                uglcw.ui.get('#wareType').value(node.id);
                                uglcw.ui.get('#isType').value(2);
                                uglcw.ui.get('#type').value(2);
                                uglcw.ui.get('#click-flag').value(0);
                                uglcw.ui.get('#grid').reload();
                               }

                            "
                        ></div>
                    </li>
                    <li>
                        <span>固定资产类</span>
                        <div uglcw-role="tree"
                             uglcw-options="
                           url: '${base}manager/companyWaretypes?isType=3',
                           expandable: function(node){
                            return node.id === 0;
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
                                uglcw.ui.get('#wareType').value(node.id);
                                uglcw.ui.get('#isType').value(3);
                                uglcw.ui.get('#type').value(3);
                                uglcw.ui.get('#click-flag').value(0);
                                uglcw.ui.get('#grid').reload();
                               }

                            "
                        ></div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal query">
                        <li>
                            <input type="hidden" uglcw-model="isType" id="isType" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="waretype" value="0" id="wareType" uglcw-role="textbox">
                            <input uglcw-model="startDate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="endDate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <select uglcw-model="type" uglcw-role="combobox" id="type" placeholder="资产类型" uglcw-options='value:""'>
                                <option value="0">库存商品类</option>
                                <option value="1">原辅材料类</option>
                                <option value="2">低值易耗品类</option>
                                <option value="3">固定资产类</option>
                            </select>
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="stkId"  uglcw-options="
                                       value:'',
                                       placeholder:'仓库',
                                       url: '${base}manager/queryBaseStorage',
                                       dataTextField:'stkName',
                                       dataValueField:'id'
                                   ">
                            </select>
                        </li>
                        <li style="width: 80px;">
                            <input type="checkbox" uglcw-value="1" uglcw-role="checkbox"
                                   uglcw-model="hideZero" id="ignoreZero">
                            <label style="margin-top: 10px;" class="k-checkbox-label" for="ignoreZero">过滤0值</label>
                        </li>
                        <li>
                            <input type="hidden" uglcw-role="textbox"id="click-flag" value="0"/>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                    autoBind:false,
                    responsive:['.header',40],
                    id:'id',
                    pageable:{
                        pageSize: 20
                    },
                    query: function(params){
                        if(uglcw.ui.get('#click-flag').value()==1){
                            delete params['isType']
                            delete params['waretype']
                        }
                        if(params.type != ''){
                            params.isType =params.type
                        }
                        return params;
                    },
                   <%-- autoBind: ${param.lazy ne null ? !param.lazy : 'false'},   --%>

                    rowNumber: true,
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    url: '${base}manager/stkSummaryPage',
                    criteria: '.query',
                    dblclick: function(row){
                     var query = uglcw.ui.bind('.query');
                         var q = {
                            wareId: row.wareId,
                            sdate: query.startDate,
                            edate: query.endDate,
                            billName: '全部',
                            stkId: query.stkId
                         };
                         uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?' + $.map(q, function (v, k) {
                            return k + '=' + (v || '');
                        }).join('&'));
                    },
                    aggregate:[
                     {field: 'initQty', aggregate: 'sum'},
                    ],
                    loadFilter: {
                      data: function (response) {
                        if(!response || !response.rows){
                            return [];
                        }
                        if(response.total == 0){
                        	return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        $(response.rows).each(function(idx, row){
                            var initInQty = row.initInQty =='' ? 0 : row.initInQty;
                            var inQty = row.inQty == '' ? 0 : row.inQty;
                            var inQty1 = row.inQty1 == '' ? 0 : row.inQty1;
                            var rtnQty = row.rtnQty == '' ? 0 : row.rtnQty;
                            var transInQty = row.transInQty == '' ? 0 : row.transInQty;
                            var zzInQty = row.zzInQty == '' ? 0 : row.zzInQty;
                            var cxInQty = row.cxInQty == ''? 0 : row.cxInQty;
                            var scQty = row.scQty == '' ? 0 : row.scQty;
                            var checkInQty = row.checkInQty == '' ? 0 : row.checkInQty;
                            row._bqQty = parseFloat(initInQty)
                            + parseFloat(inQty)
                            + parseFloat(inQty1)
                            + parseFloat(rtnQty)
                            + parseFloat(transInQty)
                            + parseFloat(zzInQty)
                            + parseFloat(cxInQty)
                            + parseFloat(scQty)
                            + parseFloat(checkInQty);
                            var outQty11 = row.outQty11 == '' ? 0 : row.outQty11;
                            var outQty12 = row.outQty12 == '' ? 0 : row.outQty12;
                            var outQty13 = row.outQty13 == '' ? 0 : row.outQty13;
                            var outQty14 = row.outQty14 == '' ? 0 : row.outQty14;
                            var outQty15 = row.outQty15 =='' ? 0 : row.outQty15;
                            var shopSaleQty = row.shopSaleQty == '' ? 0 : row.shopSaleQty;
                            var otherOutQty = row.otherOutQty == ''? 0 : row.otherOutQty;
                            var purRtnQty = row.purRtnQty == '' ? 0 : row.purRtnQty;
                            var transOutQty = row.transOutQty == '' ? 0 : row.transOutQty;
                            var zzOutQty = row.zzOutQty == '' ? 0 : row.zzOutQty;
                            var cxOutQty = row.cxOutQty == '' ? 0 : row.cxOutQty;
                            var useQty = row.useQty == '' ? 0 : row.useQty;
                            var lenOutQty = row.lenOutQty == '' ? 0 : row.lenOutQty;
                            var lossQty = row.lossQty == '' ? 0 : row.lossQty;
                            var lendQty = row.lendQty == '' ? 0 : row.lendQty;
                            var checkOutQty = row.checkOutQty == '' ? 0 : row.checkOutQty;
                            row._bqck = parseFloat(outQty11)
                            + parseFloat(outQty12)
                            + parseFloat(outQty13)
                            + parseFloat(outQty14)
                            + parseFloat(outQty15)
                            + parseFloat(shopSaleQty)
                            + parseFloat(otherOutQty)
                            + parseFloat(purRtnQty)
                            + parseFloat(transOutQty)
                            + parseFloat(zzOutQty)
                            + parseFloat(cxOutQty)
                            + parseFloat(useQty)
                            + parseFloat(lenOutQty)
                            + parseFloat(lossQty)
                            + parseFloat(lendQty)
                            + parseFloat(checkOutQty)
                            ;
                        })
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        sumQty:0,
                        sumQty1:0,
                        sumAmt:0,
                        sumAmt1:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
                            var outQty11 = aggregate.outQty11 == '' ? 0 : aggregate.outQty11;
                            var outQty12 = aggregate.outQty12 == '' ? 0 : aggregate.outQty12;
                            var outQty13 = aggregate.outQty13 == '' ? 0 : aggregate.outQty13;
                            var outQty14 = aggregate.outQty14 == '' ? 0 : aggregate.outQty14;
                            var outQty15 = aggregate.outQty15 =='' ? 0 : aggregate.outQty15;
                            var shopSaleQty = aggregate.shopSaleQty == '' ? 0 : aggregate.shopSaleQty;
                            var otherOutQty = aggregate.otherOutQty == ''? 0 : aggregate.otherOutQty;
                            var purRtnQty = aggregate.purRtnQty == '' ? 0 : aggregate.purRtnQty;
                            var transOutQty = aggregate.transOutQty == '' ? 0 : aggregate.transOutQty;
                            var zzOutQty = aggregate.zzOutQty == '' ? 0 : aggregate.zzOutQty;
                            var cxOutQty = aggregate.cxOutQty == '' ? 0 : aggregate.cxOutQty;
                            var useQty = aggregate.useQty == '' ? 0 : aggregate.useQty;
                            var lenOutQty = aggregate.lenOutQty == '' ? 0 : aggregate.lenOutQty;
                            var lossQty = aggregate.lossQty == '' ? 0 : aggregate.lossQty;
                            var lendQty = aggregate.lendQty == '' ? 0 : aggregate.lendQty;
                            var checkOutQty = aggregate.checkOutQty == '' ? 0 : aggregate.checkOutQty;
                            aggregate._bqck = parseFloat(outQty11)
                            + parseFloat(outQty12)
                            + parseFloat(outQty13)
                            + parseFloat(outQty14)
                            + parseFloat(outQty15)
                            + parseFloat(shopSaleQty)
                            + parseFloat(otherOutQty)
                            + parseFloat(purRtnQty)
                            + parseFloat(transOutQty)
                            + parseFloat(zzOutQty)
                            + parseFloat(cxOutQty)
                            + parseFloat(useQty)
                            + parseFloat(lenOutQty)
                            + parseFloat(lossQty)
                            + parseFloat(lendQty)
                            + parseFloat(checkOutQty)
                            ;
                        }
                        return aggregate;
                      }
                     }
                    ">
                        <div data-field="wareNm" uglcw-options="width: 200, tooltip: true, footerTemplate: '合计'">商品名称
                        </div>
                        <div data-field="unitName" uglcw-options="width: 80">单位</div>
                        <%--<div data-field="initQty"--%>
                             <%--uglcw-options="width: 100,  format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initQty.sum === undefined ? data.initQty: data.initQty.sum,\'n2\')#'">--%>
                            <%--期初数量--%>
                        <%--</div>--%>
                        <%--<div data-field="initAmt"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '期初金额')},  format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initAmt,\'n2\')#'">--%>
                            <%--期初金额--%>
                        <%--</div>--%>
                        <%--<div data-field="_bqQty"--%>
                             <%--uglcw-options="width: 100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data._bqQty,\'n2\')#'">--%>
                            <%--本期入库--%>
                        <%--</div>--%>

                        <%--<div data-field="avgPrice"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '期初平均价格')}, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.avgPrice,\'n2\')#'">--%>
                            <%--平均价格--%>
                        <%--</div>--%>
                        <%--<div data-field="initInQty"--%>
                             <%--uglcw-options="width: 100,attributes:{ class: 'router-link', 'data-field': 'initInQty'}, hidden: ${!fn:contains(fieldsStr, '初始化入库') or isExpand == 0}, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initInQty,\'n2\')#'">--%>
                            <%--初始化入库--%>
                        <%--</div>--%>
                        <%--<div data-field="initInAmt"--%>
                             <%--uglcw-options="width: 130, hidden: ${!fn:contains(fieldsStr, '初始化入库金额') or isExpand == 0}, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initInAmt,\'n2\')#'">--%>
                            <%--初始化入库金额--%>
                        <%--</div>--%>
                        <%--<div data-field="inQty"--%>
                             <%--uglcw-options="width: 100, attributes:{ class: 'router-link', 'data-field': 'inQty'}, hidden: ${!fn:contains(fieldsStr, '采购入库')}, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.inQty,\'n2\')#'">--%>
                            <%--采购入库--%>
                        <%--</div>--%>
                        <%--<div data-field="inAmt"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '采购金额')}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.inAmt,\'n2\')#'">--%>
                            <%--采购金额--%>
                        <%--</div>--%>
                        <%--<div data-field="otherTypeInQty"--%>
                             <%--uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'otherTypeInQty'}, hidden: ${!fn:contains(fieldsStr, '其它类型入库') or isExpand > 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeInQty,\'n2\')#'">--%>
                            <%--其它类型入库--%>
                        <%--</div>--%>
                        <%--<div data-field="otherTypeInAmt"--%>
                             <%--uglcw-options="width: 120, hidden: ${isExpand == 0 || showAmt == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeInQty,\'n2\')#'">--%>
                            <%--其它类型入库金额--%>
                        <%--</div>--%>
                        <%--<div data-field="inQty1"--%>
                             <%--uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'inQty1'}, hidden: ${!fn:contains(fieldsStr, '其它入库') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.其它入库,\'n2\')#'">--%>
                            <%--其它入库--%>
                        <%--</div>--%>
                        <%--<div data-field="inAmt1"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '其它入库金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.inAmt1,\'n2\')#'">--%>
                            <%--其它入库金额--%>
                        <%--</div>--%>
                        <%--<div data-field="rtnQty"--%>
                             <%--uglcw-options="width: 100, attributes:{ class: 'router-link', 'data-field': 'rtnQty'}, hidden: ${!fn:contains(fieldsStr, '销售退货') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.rtnQty,\'n2\')#'">--%>
                            <%--销售退货--%>
                        <%--</div>--%>
                        <%--<div data-field="rtnAmt"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '退货金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.rtnAmt,\'n2\')#'">--%>
                            <%--退货金额--%>
                        <%--</div>--%>
                        <%--<div data-field="transInQty"--%>
                             <%--uglcw-options="width: 100, attributes:{ class: 'router-link', 'data-field': 'transInQty'}, hidden: ${!fn:contains(fieldsStr, '移入数量') or isExpand == 0},format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transInQty,\'n2\')#'">--%>
                            <%--移入数量--%>
                        <%--</div>--%>
                        <%--<div data-field="transInAmt"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '移入金额') or isExpand == 0},format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transInAmt,\'n2\')#'">--%>
                            <%--移入金额--%>
                        <%--</div>--%>
                        <%--<div data-field="zzInQty"--%>
                             <%--uglcw-options="width: 100,attributes:{ class: 'router-link', 'data-field': 'zzInQty'}, hidden: ${!fn:contains(fieldsStr, '组装数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzInQty,\'n2\')#'">--%>
                            <%--组装数量--%>
                        <%--</div>--%>
                        <%--<div data-field="zzInAmt"--%>
                             <%--uglcw-options="width: 100,hidden: ${!fn:contains(fieldsStr, '组装金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzInAmt,\'n2\')#'">--%>
                            <%--组装金额--%>
                        <%--</div>--%>
                        <%--<div data-field="cxInQty"--%>
                             <%--uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'cxInQty'}, hidden: ${!fn:contains(fieldsStr, '拆卸入库数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxInQty,\'n2\')#'">--%>
                            <%--拆卸入库数量--%>
                        <%--</div>--%>
                        <%--<div data-field="cxInAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '拆卸入库金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxInAmt,\'n2\')#'">--%>
                            <%--拆卸入库金额--%>
                        <%--</div>--%>
                        <%--<div data-field="scQty"--%>
                             <%--uglcw-options="width: 100, attributes:{ class: 'router-link', 'data-field': 'scQty'}, hidden: ${!fn:contains(fieldsStr, '生产数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.scQty,\'n2\')#'">--%>
                            <%--生产数量--%>
                        <%--</div>--%>
                        <%--<div data-field="scAmt"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '生产金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.scAmt,\'n2\')#'">--%>
                            <%--生产金额--%>
                        <%--</div>--%>
                        <%--<div data-field="hkQty"--%>
                             <%--uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'hkQty'}, hidden: ${!fn:contains(fieldsStr, '领料回库数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.hkQty,\'n2\')#'">--%>
                            <%--领料回库数量--%>
                        <%--</div>--%>
                        <%--<div data-field="hkAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '领料回库金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.hkAmt,\'n2\')#'">--%>
                            <%--领料回库金额--%>
                        <%--</div>--%>
                        <%--<div data-field="checkInQty"--%>
                             <%--uglcw-options="width: 100, attributes:{ class: 'router-link', 'data-field': 'checkInQty'}, hidden: ${!fn:contains(fieldsStr, '盘盈数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkInQty,\'n2\')#'">--%>
                            <%--盘盈数量--%>
                        <%--</div>--%>
                        <%--<div data-field="checkInAmt"--%>
                             <%--uglcw-options="width: 100,hidden: ${!fn:contains(fieldsStr, '盘盈金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkInAmt,\'n2\')#'">--%>
                            <%--盘盈金额--%>
                        <%--</div>--%>
                        <%--<div data-field="outQty11"--%>
                             <%--uglcw-options="width: 100,attributes:{ class: 'router-link', 'data-field': 'outQty11'}, hidden: ${!fn:contains(fieldsStr, '正常销售')}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty11,\'n2\')#'">--%>
                            <%--正常销售--%>
                        <%--</div>--%>
                        <%--<div data-field="checkInQty"--%>
                             <%--uglcw-options="width: 100,hidden: ${!fn:contains(fieldsStr, '销售成本')}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkInQty,\'n2\')#'">--%>
                            <%--销售成本--%>
                        <%--</div>--%>
                        <%--<div data-field="otherTypeOutQty"--%>
                             <%--uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'otherTypeOutQty'}, hidden: ${!fn:contains(fieldsStr, '其它类型出库') or isExpand > 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeOutQty,\'n2\')#'">--%>
                            <%--其它类型出库--%>
                        <%--</div>--%>
                        <%--<div data-field="otherTypeOutAmt"--%>
                             <%--uglcw-options="width: 130, hidden: ${isExpand > 0 or showAmt == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeOutAmt,\'n2\')#'">--%>
                            <%--其它类型出库金额--%>
                        <%--</div>--%>
                        <%--<div data-field="outQty12"--%>
                             <%--uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'outQty12'}, hidden: ${!fn:contains(fieldsStr, '促销折让数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty12,\'n2\')#'">--%>
                            <%--促销折让数量--%>
                        <%--</div>--%>
                        <%--<div data-field="outAmt12"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '促销折让金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt12,\'n2\')#'">--%>
                            <%--促销折让金额--%>
                        <%--</div>--%>
                        <%--<div data-field="outQty13"--%>
                             <%--uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'outQty13'},hidden: ${!fn:contains(fieldsStr, '消费折让数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty13,\'n2\')#'">--%>
                            <%--消费折让数量--%>
                        <%--</div>--%>
                        <%--<div data-field="outAmt13"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '消费折让金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty13,\'n2\')#'">--%>
                            <%--消费折让金额--%>
                        <%--</div>--%>
                        <%--<div data-field="outQty14"--%>
                             <%--uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'outQty14'}, hidden: ${!fn:contains(fieldsStr, '费用折让数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty14,\'n2\')#'">--%>
                            <%--费用折让数量--%>
                        <%--</div>--%>
                        <%--<div data-field="outAmt14"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '费用折让金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt14,\'n2\')#'">--%>
                            <%--费用折让金额--%>
                        <%--</div>--%>
                        <%--<div data-field="outQty15"--%>
                             <%--uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'outQty15'}, hidden: ${!fn:contains(fieldsStr, '其它销售数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty15,\'n2\')#'">--%>
                            <%--其它销售数量--%>
                        <%--</div>--%>
                        <%--<div data-field="outAmt15"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '其它销售成本') or isExpand == 0},  format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt15,\'n2\')#'">--%>
                            <%--其它销售成本--%>
                        <%--</div>--%>
                        <%--<div data-field="shopSaleQty"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '终端零售数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.shopSaleQty,\'n2\')#'">--%>
                            <%--终端零售数量--%>
                        <%--</div>--%>
                        <%--<div data-field="shopSaleAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '终端零售成本') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.shopSaleAmt,\'n2\')#'">--%>
                            <%--终端零售成本--%>
                        <%--</div>--%>
                        <%--<div data-field="otherOutQty"--%>
                             <%--uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'otherOutQty'}, hidden: ${!fn:contains(fieldsStr, '其它出库数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherOutQty,\'n2\')#'">--%>
                            <%--其它出库数量--%>
                        <%--</div>--%>
                        <%--<div data-field="otherOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '其它出库金额') or isExpand == 0},  format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherOutAmt,\'n2\')#'">--%>
                            <%--其它出库金额--%>
                        <%--</div>--%>
                        <%--<div data-field="purRtnQty"--%>
                             <%--uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'purRtnQty'}, hidden: ${!fn:contains(fieldsStr, '采购退货数量') or isExpand == 0},  format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.purRtnQty,\'n2\')#'">--%>
                            <%--采购退货数量--%>
                        <%--</div>--%>
                        <%--<div data-field="purRtnAmt"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '采购退货金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.purRtnAmt,\'n2\')#'">--%>
                            <%--采购退货金额--%>
                        <%--</div>--%>
                        <%--<div data-field="transOutQty"--%>
                             <%--uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'initInQty'}, hidden: ${!fn:contains(fieldsStr, '移出数量') or isExpand == 0},format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transOutQty,\'n2\')#'">--%>
                            <%--移出数量--%>
                        <%--</div>--%>
                        <%--<div data-field="transOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '移出金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transOutAmt,\'n2\')#'">--%>
                            <%--移出金额--%>
                        <%--</div>--%>
                        <%--<div data-field="zzOutQty"--%>
                             <%--uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'zzOutQty'}, hidden: ${!fn:contains(fieldsStr, '组装出库数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzOutQty,\'n2\')#'">--%>
                            <%--组装出库数量--%>
                        <%--</div>--%>
                        <%--<div data-field="zzOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '组装出库金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzOutAmt,\'n2\')#'">--%>
                            <%--组装出库金额--%>
                        <%--</div>--%>
                        <%--<div data-field="cxOutQty"--%>
                             <%--uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'cxOutQty'},hidden: ${!fn:contains(fieldsStr, '拆卸出库数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxOutQty,\'n2\')#'">--%>
                            <%--拆卸出库数量--%>
                        <%--</div>--%>
                        <%--<div data-field="cxOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '拆卸出库金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxOutAmt,\'n2\')#'">--%>
                            <%--拆卸出库金额--%>
                        <%--</div>--%>
                        <%--<div data-field="useQty"--%>
                             <%--uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'useQty'}, hidden: ${!fn:contains(fieldsStr, '领料数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.useQty,\'n2\')#'">--%>
                            <%--领料数量--%>
                        <%--</div>--%>
                        <%--<div data-field="useAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '领料金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.useAmt,\'n2\')#'">--%>
                            <%--领料金额--%>
                        <%--</div>--%>
                        <%--<div data-field="lenOutQty"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '领用数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lenOutQty,\'n2\')#'">--%>
                            <%--领用数量--%>
                        <%--</div>--%>
                        <%--<div data-field="lenOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '领用金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lenOutAmt,\'n2\')#'">--%>
                            <%--领用金额--%>
                        <%--</div>--%>
                        <%--<div data-field="lossQty"--%>
                             <%--uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'lossQty'}, hidden: ${!fn:contains(fieldsStr, '报损数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lossQty,\'n2\')#'">--%>
                            <%--报损数量--%>
                        <%--</div>--%>
                        <%--<div data-field="lossAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '报损金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lossAmt,\'n2\')#'">--%>
                            <%--报损金额--%>
                        <%--</div>--%>
                        <%--<div data-field="lendQty"--%>
                             <%--uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'lendQty'}, hidden: ${!fn:contains(fieldsStr, '借出数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lendQty,\'n2\')#'">--%>
                            <%--借出数量--%>
                        <%--</div>--%>
                        <%--<div data-field="lendAmt"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '借出金额') or isExpand == 0},format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lendAmt,\'n2\')#'">--%>
                            <%--借出金额--%>
                        <%--</div>--%>
                        <%--<div data-field="checkOutQty"--%>
                             <%--uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'checkOutQty'}, hidden: ${!fn:contains(fieldsStr, '盘亏数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkOutQty,\'n2\')#'">--%>
                            <%--盘亏数量--%>
                        <%--</div>--%>
                        <%--<div data-field="checkOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '盘亏金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkOutAmt,\'n2\')#'">--%>
                            <%--盘亏金额--%>
                        <%--</div>--%>
                        <%--<div data-field="_bqck"--%>
                             <%--uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data._bqck,\'n2\')#'">--%>
                            <%--本期出库--%>
                        <%--</div>--%>
                        <%--<div data-field="endQty"--%>
                             <%--uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.endQty,\'n2\')#'">--%>
                            <%--期末数量--%>
                        <%--</div>--%>
                        <%--<div data-field="endAmt"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '期末成本')},format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.endAmt,\'n2\')#'">--%>
                            <%--期末成本--%>
                        <%--</div>--%>
                        <%--<div data-field="avgPrice1"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '期末平均单价')}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.avgPrice1,\'n2\')#'">--%>
                            <%--期末平均单价--%>
                        <%--</div>--%>

                        <div data-field="initQty"
                             uglcw-options="width: 100,  format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initQty.sum === undefined ? data.initQty: data.initQty.sum,\'n2\')#'">
                            期初数量
                        </div>
                        <div data-field="initAmt"
                             uglcw-options="width: 100, hidden:true,  format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initAmt,\'n2\')#'">
                            期初金额
                        </div>
                        <div data-field="_bqQty"
                             uglcw-options="width: 100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data._bqQty,\'n2\')#'">
                            本期入库
                        </div>

                        <%--<div data-field="avgPrice"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '期初平均价格')}, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.avgPrice,\'n2\')#'">--%>
                            <%--平均价格--%>
                        <%--</div>--%>
                        <div data-field="initInQty"
                             uglcw-options="width: 100,attributes:{ class: 'router-link', 'data-field': 'initInQty'}, hidden: ${!fn:contains(fieldsStr, '初始化入库') or isExpand == 0}, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initInQty,\'n2\')#'">
                            初始化入库
                        </div>
                        <%--<div data-field="initInAmt"--%>
                             <%--uglcw-options="width: 130, hidden: ${!fn:contains(fieldsStr, '初始化入库金额') or isExpand == 0}, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initInAmt,\'n2\')#'">--%>
                            <%--初始化入库金额--%>
                        <%--</div>--%>
                        <div data-field="inQty"
                             uglcw-options="width: 100, attributes:{ class: 'router-link', 'data-field': 'inQty'}, hidden: ${!fn:contains(fieldsStr, '采购入库')}, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.inQty,\'n2\')#'">
                            采购入库
                        </div>
                        <%--<div data-field="inAmt"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '采购金额')}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.inAmt,\'n2\')#'">--%>
                            <%--采购金额--%>
                        <%--</div>--%>
                        <div data-field="otherTypeInQty"
                             uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'otherTypeInQty'}, hidden: ${!fn:contains(fieldsStr, '其它类型入库') or isExpand > 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeInQty,\'n2\')#'">
                            其它类型入库
                        </div>
                        <%--<div data-field="otherTypeInAmt"--%>
                             <%--uglcw-options="width: 120, hidden: ${isExpand == 0 || showAmt == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeInQty,\'n2\')#'">--%>
                            <%--其它类型入库金额--%>
                        <%--</div>--%>
                        <div data-field="inQty1"
                             uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'inQty1'}, hidden: ${!fn:contains(fieldsStr, '其它入库') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.其它入库,\'n2\')#'">
                            其它入库
                        </div>
                        <%--<div data-field="inAmt1"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '其它入库金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.inAmt1,\'n2\')#'">--%>
                            <%--其它入库金额--%>
                        <%--</div>--%>
                        <div data-field="rtnQty"
                             uglcw-options="width: 100, attributes:{ class: 'router-link', 'data-field': 'rtnQty'}, hidden: ${!fn:contains(fieldsStr, '销售退货') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.rtnQty,\'n2\')#'">
                            销售退货
                        </div>
                        <%--<div data-field="rtnAmt"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '退货金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.rtnAmt,\'n2\')#'">--%>
                            <%--退货金额--%>
                        <%--</div>--%>
                        <div data-field="transInQty"
                             uglcw-options="width: 100, attributes:{ class: 'router-link', 'data-field': 'transInQty'}, hidden: ${!fn:contains(fieldsStr, '移入数量') or isExpand == 0},format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transInQty,\'n2\')#'">
                            移入数量
                        </div>
                        <%--<div data-field="transInAmt"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '移入金额') or isExpand == 0},format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transInAmt,\'n2\')#'">--%>
                            <%--移入金额--%>
                        <%--</div>--%>
                        <div data-field="zzInQty"
                             uglcw-options="width: 100,attributes:{ class: 'router-link', 'data-field': 'zzInQty'}, hidden: ${!fn:contains(fieldsStr, '组装数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzInQty,\'n2\')#'">
                            组装数量
                        </div>
                        <%--<div data-field="zzInAmt"--%>
                             <%--uglcw-options="width: 100,hidden: ${!fn:contains(fieldsStr, '组装金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzInAmt,\'n2\')#'">--%>
                            <%--组装金额--%>
                        <%--</div>--%>
                        <div data-field="cxInQty"
                             uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'cxInQty'}, hidden: ${!fn:contains(fieldsStr, '拆卸入库数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxInQty,\'n2\')#'">
                            拆卸入库数量
                        </div>
                        <%--<div data-field="cxInAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '拆卸入库金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxInAmt,\'n2\')#'">--%>
                            <%--拆卸入库金额--%>
                        <%--</div>--%>
                        <div data-field="scQty"
                             uglcw-options="width: 100, attributes:{ class: 'router-link', 'data-field': 'scQty'}, hidden: ${!fn:contains(fieldsStr, '生产数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.scQty,\'n2\')#'">
                            生产数量
                        </div>
                        <%--<div data-field="scAmt"--%>
                             <%--uglcw-options="width: 100, hidden: ${!fn:contains(fieldsStr, '生产金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.scAmt,\'n2\')#'">--%>
                            <%--生产金额--%>
                        <%--</div>--%>
                        <div data-field="hkQty"
                             uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'hkQty'}, hidden: ${!fn:contains(fieldsStr, '领料回库数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.hkQty,\'n2\')#'">
                            领料回库数量
                        </div>
                        <%--<div data-field="hkAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '领料回库金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.hkAmt,\'n2\')#'">--%>
                            <%--领料回库金额--%>
                        <%--</div>--%>
                        <div data-field="checkInQty"
                             uglcw-options="width: 100, attributes:{ class: 'router-link', 'data-field': 'checkInQty'}, hidden: ${!fn:contains(fieldsStr, '盘盈数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkInQty,\'n2\')#'">
                            盘盈数量
                        </div>
                        <%--<div data-field="checkInAmt"--%>
                             <%--uglcw-options="width: 100,hidden: ${!fn:contains(fieldsStr, '盘盈金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkInAmt,\'n2\')#'">--%>
                            <%--盘盈金额--%>
                        <%--</div>--%>
                        <div data-field="outQty11"
                             uglcw-options="width: 100,attributes:{ class: 'router-link', 'data-field': 'outQty11'}, hidden: ${!fn:contains(fieldsStr, '正常销售')}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty11,\'n2\')#'">
                            正常销售
                        </div>
                        <%--<div data-field="checkInQty"--%>
                             <%--uglcw-options="width: 100,hidden: ${!fn:contains(fieldsStr, '销售成本')}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkInQty,\'n2\')#'">--%>
                            <%--销售成本--%>
                        <%--</div>--%>
                        <div data-field="otherTypeOutQty"
                             uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'otherTypeOutQty'}, hidden: ${!fn:contains(fieldsStr, '其它类型出库') or isExpand > 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeOutQty,\'n2\')#'">
                            其它类型出库
                        </div>
                        <%--<div data-field="otherTypeOutAmt"--%>
                             <%--uglcw-options="width: 130, hidden: ${isExpand > 0 or showAmt == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeOutAmt,\'n2\')#'">--%>
                            <%--其它类型出库金额--%>
                        <%--</div>--%>
                        <div data-field="outQty12"
                             uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'outQty12'}, hidden: ${!fn:contains(fieldsStr, '促销折让数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty12,\'n2\')#'">
                            促销折让数量
                        </div>
                        <%--<div data-field="outAmt12"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '促销折让金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt12,\'n2\')#'">--%>
                            <%--促销折让金额--%>
                        <%--</div>--%>
                        <div data-field="outQty13"
                             uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'outQty13'},hidden: ${!fn:contains(fieldsStr, '消费折让数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty13,\'n2\')#'">
                            消费折让数量
                        </div>
                        <%--<div data-field="outAmt13"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '消费折让金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty13,\'n2\')#'">--%>
                            <%--消费折让金额--%>
                        <%--</div>--%>
                        <div data-field="outQty14"
                             uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'outQty14'}, hidden: ${!fn:contains(fieldsStr, '费用折让数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty14,\'n2\')#'">
                            费用折让数量
                        </div>
                        <%--<div data-field="outAmt14"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '费用折让金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt14,\'n2\')#'">--%>
                            <%--费用折让金额--%>
                        <%--</div>--%>
                        <div data-field="outQty15"
                             uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'outQty15'}, hidden: ${!fn:contains(fieldsStr, '其它销售数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty15,\'n2\')#'">
                            其它销售数量
                        </div>
                        <%--<div data-field="outAmt15"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '其它销售成本') or isExpand == 0},  format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt15,\'n2\')#'">--%>
                            <%--其它销售成本--%>
                        <%--</div>--%>
                        <div data-field="shopSaleQty"
                             uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '终端零售数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.shopSaleQty,\'n2\')#'">
                            终端零售数量
                        </div>
                        <%--<div data-field="shopSaleAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '终端零售成本') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.shopSaleAmt,\'n2\')#'">--%>
                            <%--终端零售成本--%>
                        <%--</div>--%>
                        <div data-field="otherOutQty"
                             uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'otherOutQty'}, hidden: ${!fn:contains(fieldsStr, '其它出库数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherOutQty,\'n2\')#'">
                            其它出库数量
                        </div>
                        <%--<div data-field="otherOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '其它出库金额') or isExpand == 0},  format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherOutAmt,\'n2\')#'">--%>
                            <%--其它出库金额--%>
                        <%--</div>--%>
                        <div data-field="purRtnQty"
                             uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'purRtnQty'}, hidden: ${!fn:contains(fieldsStr, '采购退货数量') or isExpand == 0},  format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.purRtnQty,\'n2\')#'">
                            采购退货数量
                        </div>
                        <%--<div data-field="purRtnAmt"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '采购退货金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.purRtnAmt,\'n2\')#'">--%>
                            <%--采购退货金额--%>
                        <%--</div>--%>
                        <div data-field="transOutQty"
                             uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'initInQty'}, hidden: ${!fn:contains(fieldsStr, '移出数量') or isExpand == 0},format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transOutQty,\'n2\')#'">
                            移出数量
                        </div>
                        <%--<div data-field="transOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '移出金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transOutAmt,\'n2\')#'">--%>
                            <%--移出金额--%>
                        <%--</div>--%>
                        <div data-field="zzOutQty"
                             uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'zzOutQty'}, hidden: ${!fn:contains(fieldsStr, '组装出库数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzOutQty,\'n2\')#'">
                            组装出库数量
                        </div>
                        <%--<div data-field="zzOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '组装出库金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzOutAmt,\'n2\')#'">--%>
                            <%--组装出库金额--%>
                        <%--</div>--%>
                        <div data-field="cxOutQty"
                             uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'cxOutQty'},hidden: ${!fn:contains(fieldsStr, '拆卸出库数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxOutQty,\'n2\')#'">
                            拆卸出库数量
                        </div>
                        <%--<div data-field="cxOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '拆卸出库金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxOutAmt,\'n2\')#'">--%>
                            <%--拆卸出库金额--%>
                        <%--</div>--%>
                        <div data-field="useQty"
                             uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'useQty'}, hidden: ${!fn:contains(fieldsStr, '领料数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.useQty,\'n2\')#'">
                            领料数量
                        </div>
                        <%--<div data-field="useAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '领料金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.useAmt,\'n2\')#'">--%>
                            <%--领料金额--%>
                        <%--</div>--%>
                        <div data-field="lenOutQty"
                             uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '领用数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lenOutQty,\'n2\')#'">
                            领用数量
                        </div>
                        <%--<div data-field="lenOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '领用金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lenOutAmt,\'n2\')#'">--%>
                            <%--领用金额--%>
                        <%--</div>--%>
                        <div data-field="lossQty"
                             uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'lossQty'}, hidden: ${!fn:contains(fieldsStr, '报损数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lossQty,\'n2\')#'">
                            报损数量
                        </div>
                        <%--<div data-field="lossAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '报损金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lossAmt,\'n2\')#'">--%>
                            <%--报损金额--%>
                        <%--</div>--%>
                        <div data-field="lendQty"
                             uglcw-options="width: 120,attributes:{ class: 'router-link', 'data-field': 'lendQty'}, hidden: ${!fn:contains(fieldsStr, '借出数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lendQty,\'n2\')#'">
                            借出数量
                        </div>
                        <%--<div data-field="lendAmt"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '借出金额') or isExpand == 0},format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lendAmt,\'n2\')#'">--%>
                            <%--借出金额--%>
                        <%--</div>--%>
                        <div data-field="checkOutQty"
                             uglcw-options="width: 120, attributes:{ class: 'router-link', 'data-field': 'checkOutQty'}, hidden: ${!fn:contains(fieldsStr, '盘亏数量') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkOutQty,\'n2\')#'">
                            盘亏数量
                        </div>
                        <%--<div data-field="checkOutAmt"--%>
                             <%--uglcw-options="width: 120,hidden: ${!fn:contains(fieldsStr, '盘亏金额') or isExpand == 0}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkOutAmt,\'n2\')#'">--%>
                            <%--盘亏金额--%>
                        <%--</div>--%>
                        <div data-field="_bqck"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data._bqck,\'n2\')#'">
                            本期出库
                        </div>
                        <div data-field="endQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.endQty,\'n2\')#'">
                            期末数量
                        </div>
                        <div data-field="endAmt"
                             uglcw-options="width: 120, hidden:true,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.endAmt,\'n2\')#'">
                            期末成本
                        </div>
                        <%--<div data-field="avgPrice1"--%>
                             <%--uglcw-options="width: 120, hidden: ${!fn:contains(fieldsStr, '期末平均单价')}, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.avgPrice1,\'n2\')#'">--%>
                            <%--期末平均单价--%>
                        <%--</div>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:settingFields();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>设置显示字段
    </a>
    <a role="button" href="javascript:calInventory();" class="k-button k-button-icontext">
        <span class="k-icon k-i-calculator"></span>重新计算库存
    </a>

    <a  role="button" href="javascript:newFun();" class="k-button k-button-icontext">
        <span></span>
    </a>
    <a  role="button" href="javascript:showFun();" class="k-button k-button-icontext">
        <span></span>
    </a>
</script>
<script type="text/x-uglcw-template" id="fields-setting-tpl">
    <div class="layui-card">
        <div class="layui-card-body">
            <div style="padding: 10px; color: \\#444;display: none">
                <input type="checkbox" uglcw-role="checkbox" uglcw-model="showAmt"
                       uglcw-options="type:'number'"
                       uglcw-value="${showAmt}"
                       class="k-checkbox" id="showAmt" style="display: none;">
                <label style="margin-bottom: 0px;" class="k-checkbox-label" for="showAmt" style="display: none;">显示金额</label>
                <input type="checkbox" uglcw-role="checkbox" uglcw-model="isExpand"
                       uglcw-value="${isExpand}"
                       uglcw-options="type:'number'"
                       class="k-checkbox" id="expand">
                <label style="margin-bottom: 0px;margin-left: 20px;" class="k-checkbox-label" for="expand">展开</label>
            </div>
            <div uglcw-role="grid"
                 uglcw-options="
                    rowNumber: true,
                    checkbox: true,
                    height: 350,
                    url: '${base}manager/stkSummaryField',
                    query: onQueryField,
                    dataBound: function(e){
                        var grid = e.sender;
                        $.map(grid.dataSource.data(), function(row){
                            if(row.chk){
                                grid.select(grid.element.find('tr[data-uid='+row.uid+']'));
                            }
                        });
                    }
            "
            >
                <div data-field="title" uglcw-options="width: 'auto'">字段名称</div>
            </div>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.layout.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#click-flag').value(1); //查询标记1
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#gird').reload();
        });

        $('#grid').on('click', '.router-link', function () {
            var $td = $(this);
            var $tr = $td.closest('tr');
            var row = uglcw.ui.get('#grid').k().dataItem($tr);
            onCellClick($td.data('field'), row);
        })
        $('.uglcw-layout-fixed').kendoTooltip({
            filter: 'li.k-item',
            position: 'right',
            content: function(e){
                return '<span class="k-in" style="width: 100px;display: inline-flex;">'+$(e.target).find('span.k-in').html()+'</span>';
            }
        });
        uglcw.ui.loaded()
    });

    function onQueryField(param) {
        param = param || {};
        param.colsStr = JSON.stringify($.map(uglcw.ui.get('#grid').k().options.columns, function (col) {
            if (col.field) {
                return {
                    title: col.title,
                    field: col.field
                }
            }
        }));
        return param;
    }

    function onCellClick(field, row) {
        var query = uglcw.ui.bind('.query');
        var sdate = query.startDate;
        var edate = query.endDate;
        var stkId = query.stkId;
        if (field == "inQty") {
            var billName = "采购入库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "initInQty") {
            var billName = "初始化入库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "checkInQty") {
            var billName = "盘盈";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "inQty1") {
            var billName = "其它入库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "rtnQty") {
            var billName = "销售退货";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "transInQty") {
            var billName = "移库入库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "zzInQty") {
            var billName = "组装入库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "cxInQty") {
            var billName = "拆卸入库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "scQty") {
            var billName = "生产入库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "hkQty") {
            var billName = "领料回库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }


        if (field == "outQty11") {
            var billName = "正常销售";

            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "outQty12") {
            var billName = "促销折让";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "outQty13") {
            var billName = "消费折让";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "outQty14") {
            var billName = "费用折让";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "outQty15") {
            var billName = "其它销售";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "otherOutQty") {
            var billName = "其它出库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "purRtnQty") {
            var billName = "采购退货";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "transOutQty") {
            var billName = "移库出库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "zzOutQty") {
            var billName = "组装出库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "cxOutQty") {
            var billName = "拆卸出库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "useQty") {
            var billName = "领用出库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "lossQty") {
            var billName = "报损出库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "lendQty") {
            var billName = "借出出库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "checkOutQty") {
            var billName = "盘亏";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "otherTypeInQty") {
            var billName = "其它类型入库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "otherTypeOutQty") {
            var billName = "其它类型出库";
            uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
    }

    function settingFields() {
        var i = uglcw.ui.Modal.open({
            content: $('#fields-setting-tpl').html(),
            title: '请选择显示字段',
            offset: '200px',
            area: '450px',
            success: function (c) {
                uglcw.ui.init(c);
                var grid = uglcw.ui.get($(c).find('.uglcw-grid')).k();
                uglcw.ui.get('#showAmt').on('change', function () {
                    var showAmt = uglcw.ui.get('#showAmt').value();
                    $(c).find('.uglcw-grid .k-grid-content td').each(function () {
                        var td = $(this), title = td.text();
                        if (title.indexOf('金额') !== -1 || title.indexOf('价') !== -1 || title.indexOf('成本') !== -1) {
                            if (showAmt) {
                                grid.select(td.closest('tr'));
                            } else {
                                var row;
                                if($(c).find('.uglcw-grid .k-grid-content-locked').length > 0){
                                    row = $(c).find('.uglcw-grid .k-grid-content-locked tr[data-uid=' + td.closest('tr').data('uid') + ']');
                                }else{
                                    row = $(c).find('.uglcw-grid .k-grid-content tr[data-uid=' + td.closest('tr').data('uid') + ']');
                                }
                                row.click();
                            }
                        }
                    })
                })
            },
            yes: function (c) {
                var grid = uglcw.ui.get($(c).find('.uglcw-grid'));
                var selection = grid.selectedRow();
                if (!selection || selection.length < 1) {
                    return uglcw.ui.error('请选择要显示的字段');
                }
                var data = uglcw.ui.bind(c);
                data.fieldsStr = $.map(selection, function (row) {
                    return row.title;
                }).join(',');
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/saveStkSummaryField',
                    type: 'post',
                    data: data,
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.state) {
                            uglcw.ui.success('操作成功')
                            uglcw.ui.Modal.close(i);
                            setTimeout(function () {
                                window.location.href = '${base}manager/querystksummary?lazy=false'
                            }, 1000)
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                    }
                });
                return false;
            }
        })
    }

    function calInventory() {
        uglcw.ui.confirm('确定重新计算库存吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/updateStorageQty',
                type: 'post',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('计算成功')
                    } else {
                        uglcw.ui.error('提交失败')
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function newFun(){
        uglcw.ui.openTab('存货收发存新', '${base}manager/stkSfcWare/toSfcPage');
    }


    function showFun(){
        var grid = uglcw.ui.get('#grid');
        grid.showColumn('initAmt');
        grid.showColumn('endAmt');
    }

</script>
</body>
</html>
