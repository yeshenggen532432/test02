<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>产品入库统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
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
<tag:mask/>
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
                                    uglcw.ui.get('#wareType').value(node.id);
                                    uglcw.ui.get('#isType').value(0);
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
                                    uglcw.ui.get('#wareType').value(node.id);
                                    uglcw.ui.get('#isType').value(1);
                                    uglcw.ui.get('#type').value(1);
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
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="isType" id="isType" value="0" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="waretype" id="wareType" uglcw-role="textbox">
                            <select uglcw-role="combobox" uglcw-model="timeType" uglcw-options="placeholder:'时间类型'">
                                <option value="1" selected>收货时间</option>
                                <option value="2">单据时间</option>
                            </select>
                        </li>
                        <li>
                            <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="0" placeholder="仓库"
                                         headerValue="" displayKey="id" displayValue="stk_name"
                                         whereBlock="status=1 or status is null"
                            />

                        </li>
                        <li>
                            <select uglcw-model="inType" uglcw-options="value: ''" placeholder="入库类型" uglcw-role="combobox"
                                    id="inType">
                                <option value="采购入库">采购入库</option>
                                <option value="采购退货">采购退货</option>
                                <option value="其它入库">其它入库</option>
                                <option value="销售退货">销售退货</option>
                                <option value="移库入库">移库入库</option>
                                <option value="组装入库">组装入库</option>
                                <option value="拆卸入库">拆卸入库</option>
                                <option value="生产入库">生产入库</option>
                                <option value="领料回库">领料回库</option>
                                <option value="盘盈">盘盈</option>
                            </select>
                        </li>
                        <li>
                            <input placeholder="供应商名称" uglcw-role="textbox" uglcw-model="proName"/>
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
                            <input placeholder="商品名称" uglcw-role="textbox" uglcw-model="wareNm"/>
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
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
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
                    pageable:{
                        pageSize: 20
                    },
                    url: '${base}manager/stkInSubStatPage',
                    criteria: '.form-horizontal',
                    dblclick: function(row){
                     var query = uglcw.ui.bind('.uglcw-query');
                         query.wareId=row.wareId;
                          query.filterDataType = filterDataType;
                         uglcw.ui.openTab('明细_'+ row.wareNm, '${base}manager/queryIndetailList?dataTp=1&' + $.map(query, function (v, k) {
                            return k + '=' + (v || '');
                        }).join('&'));
                    },
                    aggregate:[
                     {field: 'sumAmt', aggregate: 'sum'},
                    ],
                     dataBound: function(){
                        filterField();
                     },
                    loadFilter: {
                      data: function (response) {
                        if(response.total == 0){
                        	return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        sumQty:0,
                        sumQty1:0,
                        minSumQty:0,
                        minSumQty1:0,
                        sumAmt:0,
                        sumAmt1:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     }
                    ">
                        <div data-field="wareNm" uglcw-options="footerTemplate: '合计'">商品名称</div>
                        <div data-field="unitName">单位</div>
                        <div data-field="sumQty" uglcw-options="format: '{0:n2}',
                             footerTemplate: '#= uglcw.util.toString(data.sumQty,\'n2\')#'">
                            单据数量
                        </div>

                        <div data-field="sumQty1" uglcw-options="format: '{0:n2}',
                             footerTemplate: '#= uglcw.util.toString(data.sumQty1,\'n2\')#'">
                            收货数量
                        </div>
                        <div data-field="minUnitName">单位(小)</div>
                        <div data-field="minSumQty" uglcw-options="format: '{0:n2}',
                             footerTemplate: '#= uglcw.util.toString(data.minSumQty,\'n2\')#'">
                            单据数量(小)
                        </div>
                        <div data-field="minSumQty1" uglcw-options="format: '{0:n2}',
                             footerTemplate: '#= uglcw.util.toString(data.minSumQty1,\'n2\')#'">
                            收货数量(小)
                        </div>
                        <c:if test="${permission:checkUserFieldPdm('stk.wareInStat.showamt')}">
                            <div data-field="sumAmt"
                                 uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.sumAmt,\'n2\')#'">
                                采购金额
                            </div>
                        </c:if>
                        <c:if test="${permission:checkUserFieldPdm('stk.wareInStat.showamt')}">
                            <div data-field="sumAmt"
                                 uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.sumAmt1,\'n2\')#'">
                                收货金额
                            </div>
                        </c:if>
                        <c:if test="${permission:checkUserFieldPdm('stk.wareInStat.showprice')}">
                            <div data-field="avgPrice"
                                 uglcw-options="format: '{0:n2}',template:'#= uglcw.util.toString((data.sumQty==0?0:data.sumAmt/data.sumQty), \'n2\')#',
                                  footerTemplate: '#= uglcw.util.toString((data.sumQty==0?0:data.sumAmt/data.sumQty), \'n2\')#'">
                                平均单价
                            </div>
                        </c:if>
                        <c:if test="${permission:checkUserFieldPdm('stk.wareInStat.showprice')}">
                            <div data-field="minAvgPrice"
                                 uglcw-options="format: '{0:n2}',template:'#= uglcw.util.toString((data.minSumQty==0?0:data.sumAmt/data.minSumQty), \'n2\')#',
                                  footerTemplate: '#= uglcw.util.toString((data.minSumQty==0?0:data.sumAmt/data.minSumQty), \'n2\')#'">
                                平均单价(小)
                            </div>
                        </c:if>
                    </div>
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
<%--<script id="color" type="text/x-kendo-template">--%>
    <%--<a style="color:blue;font-size: 13px; font-weight: bold;">#=uglcw.util.toString(data.sumQty,'n2')#</a>--%>
<%--</script>--%>
<%--<script id="hues" type="text/x-kendo-template">--%>
    <%--<a style="color:blue;font-size: 13px; font-weight: bold;">#=uglcw.util.toString(data.sumQty1,'n2')#</a>--%>
<%--</script>--%>
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

        $('.uglcw-layout-fixed').kendoTooltip({
            filter: 'li.k-item',
            position: 'right',
            content: function(e){
                return '<span class="k-in" style="width: 100px;display: inline-flex;">'+$(e.target).find('span.k-in').html()+'</span>';
            }
        });
        filterField();
        uglcw.ui.loaded()
    });

    var filterDataType = 1;
    function filterData(v){
        filterDataType = v;
        filterField();
    }
    function filterField(){
        var grid = uglcw.ui.get('#grid');
        if(filterDataType==1){
            grid.showColumn('unitName');
            grid.showColumn('sumQty');
            grid.showColumn('sumQty1');
            grid.showColumn('avgPrice');
            grid.hideColumn('minUnitName');
            grid.hideColumn('minSumQty');
            grid.hideColumn('minSumQty1');
            grid.hideColumn('minAvgPrice');
        }else if(filterDataType==2){
            grid.hideColumn('unitName');
            grid.hideColumn('sumQty');
            grid.hideColumn('sumQty1');
            grid.hideColumn('avgPrice');
            grid.showColumn('minUnitName');
            grid.showColumn('minSumQty');
            grid.showColumn('minSumQty1');
            grid.showColumn('minAvgPrice');
        }else if(filterDataType==3){
            grid.showColumn('unitName');
            grid.showColumn('sumQty');
            grid.showColumn('sumQty1');
            grid.showColumn('avgPrice');
            grid.showColumn('minUnitName');
            grid.showColumn('minSumQty');
            grid.showColumn('minSumQty1');
            grid.showColumn('minAvgPrice');
        }
    }

</script>
</body>
</html>
