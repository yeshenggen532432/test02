<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>产品销售毛利统计表</title>
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
        .uglcw-query>li.xs-tp #xsTp_taglist {
            position: fixed;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div  class="layui-card" uglcw-role="resizable" uglcw-options="responsive:[35]">
                <ul uglcw-role="accordion">
                    <li>
                        <span>库存商品类</span>
                        <div uglcw-role="tree"  id="tree1"
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
                    ">

                        </div>
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
                <%--<div class="layui-card-header">商品分类</div>--%>
                <%--<div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">--%>
                    <%--<div uglcw-role="tree"--%>
                         <%--uglcw-options="--%>
                       <%--url: '${base}manager/waretypes',--%>
                       <%--expandable: function(node){--%>
                        <%--return node.id === 0;--%>
                       <%--},--%>
                       <%--select: function(e){--%>
                        <%--var node = this.dataItem(e.node);--%>
                        <%--uglcw.ui.get('#wareType').value(node.id);--%>
                        <%--uglcw.ui.get('#grid').reload();--%>
                       <%--}--%>

                    <%--"--%>
                    <%--></div>--%>
                <%--</div>--%>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input uglcw-role="textbox" uglcw-model="wtype" id="wareType" type="hidden"/>
                            <input uglcw-role="textbox" uglcw-model="isType" id="isType" value="0" type="hidden"/>
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

                        <%--<li>--%>
                            <%--<select uglcw-role="combobox" uglcw-model="outType" uglcw-options="value: '',placeholder:'统计范围'">--%>
                                <%--<option value="正常销售">正常销售</option>--%>
                                <%--<option value="促销折让">促销折让</option>--%>
                                <%--<option value="消费折让">消费折让</option>--%>
                                <%--<option value="费用折让">费用折让</option>--%>
                                <%--<option value="其他销售">其他销售</option>--%>
                                <%--<option value="其它出库">其它出库</option>--%>
                                <%--<option value="销售退货">销售退货</option>--%>
                            <%--</select>--%>
                        <%--</li>--%>
                        <%--<li>
                            <select uglcw-model="type" uglcw-role="combobox" id="type" placeholder="资产类型" uglcw-options='value:""'>
                                <option value="0">库存商品类</option>
                                <option value="1">原辅材料类</option>
                                <option value="2">低值易耗品类</option>
                                <option value="3">固定资产类</option>
                            </select>
                        </li>--%>
                        <li>
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li>
                            <input uglcw-model="empNm" uglcw-role="textbox" placeholder="业务员">
                        </li>
                        <li>
                            <input type="hidden" uglcw-role="textbox" id="type" uglcw-model="type"/>
                            <input type="hidden" uglcw-role="textbox"id="click-flag" value="0"/>
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
						responsive:['.header',40],
						id:'id',
						 query: function(params){
                         <%--if(uglcw.ui.get('#click-flag').value()==1){
                            delete params['isType']
                            delete params['wtype']
                        }--%>
                        if(params.type != ''){
                            params.isType =params.type
                        }
                        return params;
                          },
						pageable:{
							pageSize: 20
						},
						autoBind: false,
						url: '${base}manager/queryWareStatPage',
						criteria: '.form-horizontal',
						aggregate:[
						 {field: 'sumQty', aggregate: 'sum'}
						],
						loadFilter: {
						  data: function (response) {
							if(!response || !response.rows){
								return [];
							}
							response.rows.splice(response.rows.length - 2, 2);
							$(response.rows).each(function(idx, row){
								row.avgRate = parseFloat(row.disAmt)/parseFloat(row.sumAmt);
							})
							return response.rows || []
						  },
						  total: function (response) {
							return response.total;
						  },
						  aggregates: function (response) {
							var aggregate = {
							sumQty:0,
							avgPrice: 0,
							sumAmt:0,
							sumCost: 0,
							avgCost: 0,
							disAmt: 0,
							avgAmt: 0,
							avgRate:0
							};
							if (response.rows && response.rows.length > 0) {
								//XXX整单折扣
								var discount = response.rows[response.rows.length - 2];
								aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
							}
							return aggregate;
						  }
						 }
                    ">
                        <div data-field="wareNm" uglcw-options="footerTemplate: '合计：'">商品名称</div>
                        <div data-field="sumQty"
                             uglcw-options="format: '{0:n2}',footerTemplate: '#= uglcw.util.toString((data.sumQty.sum !== undefined?data.sumQty.sum: data.sumQty), \'n2\')#'">
                            销售数量
                        </div>
                        <div data-field="avgPrice"
                             uglcw-options="format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.avgPrice,\'n2\')#'">
                            平均售价
                        </div>
                        <div data-field="sumAmt"
                             uglcw-options="format: '{0:n2}',footerTemplate: '#=  uglcw.util.toString(data.sumAmt,\'n2\')#'">
                            销售金额
                        </div>
                        <div data-field="sumCost"
                             uglcw-options="format: '{0:n2}',footerTemplate: '#=  uglcw.util.toString(data.sumCost,\'n2\')#'">
                            销售成本
                        </div>
                        <div data-field="avgCost"
                             uglcw-options="format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.avgCost, \'n2\')#'">
                            平均成本
                        </div>
                        <div data-field="disAmt"
                             uglcw-options="format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.disAmt,\'n2\')#'">
                            销售毛利
                        </div>
                        <div data-field="avgAmt"
                             uglcw-options="format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.avgAmt,\'n2\')#'">
                            平均单位毛利
                        </div>
                        <div data-field="avgRate"
                             uglcw-options="format: '{0:p2}',footerTemplate: '#= uglcw.util.toString(data.avgRate,\'n2\')#'">
                            毛利率
                        </div>
                    </div>
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
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.layout.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#click-flag').value(1); //查询标记1
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#gird').reload();
        })
        uglcw.ui.loaded()
    })

</script>
</body>
</html>
