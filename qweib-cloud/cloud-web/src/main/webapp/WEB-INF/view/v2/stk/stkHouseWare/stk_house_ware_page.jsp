<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>库位商品类别</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
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
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <select uglcw-model="type" uglcw-role="combobox" id="type" placeholder="资产类型" uglcw-options='value:""'>
                                <option value="0">库存商品类</option>
                                <option value="1">原辅材料类</option>
                                <option value="2">低值易耗品类</option>
                                <option value="3">固定资产类</option>
                            </select>
                        </li>
                        <li>
                            <input type="hidden" id="isType" uglcw-model="isType" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="waretype" id="wareType" uglcw-role="textbox">
                            <input uglcw-model="wareNm" id="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li style="width: 290px !important;">
                           <%--<uglcw:storage-select base="${base}" id="stkId" name="stkId"></uglcw:storage-select>--%>
                            <uglcw:storage-house-select
                                    base="${base}"
                                    id="stkId"
                                    name="stkId"
                                    houseId="houseId"
                                    houseName="houseId"
                                    status="1"
                            />
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
                    url: '${base}manager/stkHouseWare/page',
                    criteria: '.form-horizontal',
                    aggregate:[
                     {field: 'qty', aggregate: 'SUM'}
                    ],
                      dblclick: function(row){
                        showItems(row);
                    },
                    loadFilter: {
                      data: function (response) {
                        response.rows = response.rows || []
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
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
                        <div data-field="houseName" uglcw-options="width:150, tooltip:true, footerTemplate: '合计:' ">库位名称
                        </div>
                        <div data-field="wareNm" uglcw-options="width:150, tooltip:true">商品名称</div>
                        <div data-field="qty"
                             uglcw-options="width:140, format: '{0:n2}',titleAlign:'center',align:'right',template: uglcw.util.template($('#formatterNum').html()),footerTemplate: '#=uglcw.util.toString((data.qty||0),\'n2\')#'">库存数量(大)
                        </div>
                        <div data-field="unitName" uglcw-options="width: 100">大单位</div>
                        <div data-field="_sum_Qty" uglcw-options="width:120,tooltip: true,titleAlign:'center',align:'right',
                                template: function(data){
                                    return formatQty(data);
                                }">大小数量
                        </div>
                        <div data-field="minQty"
                             uglcw-options="width:140, format: '{0:n2}',titleAlign:'center',align:'right',template: uglcw.util.template($('#formatterMinNum').html()),footerTemplate: '#=uglcw.util.toString((data.minQty||0),\'n2\')#'">库存数量(小)
                        </div>
                        <div data-field="minUnit" uglcw-options="width: 100">小单位</div>
                        <div data-field="kwArea" uglcw-options="width:150, tooltip:true">库位面积</div>
                        <div data-field="kwVolume" uglcw-options="width:150, tooltip:true">库位容量</div>
                        <div data-field="kwBar" uglcw-options="width:150, tooltip:true">库位条码</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="formatterNum">
    #var qty =  Math.floor(data.qty * 100)/100;#
    #qty = qty;#
    #var rtn = qty; #
    #= (rtn)#
</script>

<script type="text/x-kendo-template" id="formatterMinNum">
    #var minQty =  Math.floor(data.minQty * 100)/100;#
    #minQty = minQty;#
    #var rtn = minQty; #
    #= (rtn)#
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
        $('.uglcw-layout-fixed').kendoTooltip({
            filter: 'li.k-item',
            position: 'right',
            content: function(e){
                return '<span class="k-in" style="width: 100px;display: inline-flex;">'+$(e.target).find('span.k-in').html()+'</span>';
            }
        });
        uglcw.ui.loaded()
    })


    function formatQty(data) {
        var hsNum = data.hsNum || 1;
        var minSumQty = data.minQty ||0;
        var result = "";
        var remainder = minSumQty % hsNum;
        if (remainder === 0) {
            //整数件
            result += '<span>' + minSumQty / hsNum + '</span>' + data.unitName;
        } else if (remainder === minSumQty) {
            //不足一件
            var minQty =   Math.floor(minSumQty*100)/100;
            result += '<span>' + minQty + '</span>' + data.minUnit;
        } else {
            //N件有余
            var minQty = Math.floor(remainder*100)/100;
            result += '<span>' + parseInt(minSumQty / hsNum) + '</span>' + data.unitName + '<span>' + minQty + '</span>' + data.minUnit;
        }
        return result;
    }

</script>
</body>
</html>
