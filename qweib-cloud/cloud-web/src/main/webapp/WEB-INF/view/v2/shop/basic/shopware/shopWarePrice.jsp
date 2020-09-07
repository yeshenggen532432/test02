<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品价格设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px;">
            <div class="layui-card">
                <div class="layui-card-header">商品分类</div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:[75]">
                    <div uglcw-role="tree" id="tree"
                         uglcw-options="
                            lazy: false,
							url: '${base}manager/shopWareNewType/shopWaretypesExists',
							expandable:function(node){return node.id == '0'},
							loadFilter: function (response) {
                            $(response).each(function (index, item) {
                                if (item.text == '根节点') {
                                    item.text = '商品分类'
                                }
                            })
                            return response;
                            },
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#waretype').value(node.id);
								uglcw.ui.get('#click-flag').value(0);
								uglcw.ui.get('#grid').reload();
                       		}
                    	">
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="waretype" id="waretype" uglcw-role="textbox">
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li>
                            <input type="hidden" uglcw-role="textbox" id="click-flag" value="0"/>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <%--<button id="reset" class="k-button" uglcw-role="button">重置</button>--%>
                        </li>
                    </ul>
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <span>
                                批发系数
                            </span>
                            <input style="width:80px;!important;" uglcw-model="basePfRate" id="basePfRate"
                                   uglcw-role="numeric" value="${basePfRate}" title="原价(进)*批发系数/100=商城批发价(大),注:批发价(小)为空时">
                            %
                        </li>
                        <%--<li>
                            <button id="shopBaseWareGlobalPfRateSubmit" uglcw-role="button" class="k-button k-info">
                                修改批发系数
                            </button>
                        </li>--%>
                    </ul>

                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <span>
                                零售系数
                            </span>
                            <input style="width:80px;!important;" uglcw-model="baseLsRate" id="baseLsRate"
                                   uglcw-role="numeric" value="${baseLsRate}" title="原价(进)*零售系数/100=商城零售价(大),注:零售价(小)为空时">
                            %
                        </li>
                        <%-- <li>
                             <button id="shopBaseWareGlobalLsRateSubmit" uglcw-role="button" class="k-button k-info">
                                 修改零售系数
                             </button>
                         </li>--%>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
						 	responsive: ['.header', 40],
							id:'id',
							query: function(params){
                            if(uglcw.ui.get('#click-flag').value()==1){
                                delete params['wareType']
                            }
                            return params;
                            },
							pageable: true,
                            editable: true,
                    		url: '${base}manager/shopWare/page',
                    		criteria: '.form-horizontal',
                    		 loadFilter:{
                            data: function(response){
                                 var rows = [];
                                 var basePfRate='${basePfRate}';
                                 var baseLsRate='${baseLsRate}';

                                 //if(!gradeRate)return response.rows;
                                 if(response.rows && response.rows.length > 0){
                                    rows = $.map(response.rows, function(row){
                                        //零售价不为空并对应的批发价大和零售价大为空时才使用全局系数
                                        var hsNum=row.hsNum;
                                        if(row.lsPrice){//原价不为空时

                                            if(row.shopWarePrice){
                                                row.shopWareRate=(row.shopWarePrice/row.lsPrice*100).toFixed(2);
                                            }
                                            //全局批发系数有设置,批发价(大和小)都为空时
                                            if(!row.shopWarePrice && !row.shopWareSmallPrice && basePfRate){
                                                row.shopWarePriceTemp=(row.lsPrice*parseFloat(basePfRate)/100).toFixed(2);
                                                row.shopWareSmallPriceTemp=(row.shopWarePriceTemp/hsNum).toFixed(2);
                                            }

                                            if(row.shopWareLsPrice){
                                                row.shopWareLsRate=(row.shopWareLsPrice/row.lsPrice*100).toFixed(2);
                                            }
                                            //全局零售价系数有设置,零售价(大和小)都为空时
                                            if(!row.shopWareLsPrice && !row.shopWareSmallLsPrice && baseLsRate){
                                                 row.shopWareLsPriceTemp=(row.lsPrice*parseFloat(baseLsRate)/100).toFixed(2);;
                                                 row.shopWareSmallLsPriceTemp=(row.shopWareLsPriceTemp/hsNum).toFixed(2);
                                            }
                                        }

                                         //批发价(大)不为空零售价(小)为空时按换算比率自动计算小单位价
                                          if(row.shopWarePrice && !row.shopWareSmallPrice){
                                             row.shopWareSmallPriceTemp=(row.shopWarePrice/hsNum).toFixed(2);
                                          }
                                          if(!row.shopWarePrice && row.shopWareSmallPrice){
                                            row.shopWarePriceTemp=(row.shopWareSmallPrice*hsNum).toFixed(2);
                                          }

                                          if(row.shopWareLsPrice && !row.shopWareSmallLsPrice){
                                            row.shopWareSmallLsPriceTemp=(row.shopWareLsPrice/hsNum).toFixed(2);
                                          }
                                          if(!row.shopWareLsPrice && row.shopWareSmallLsPrice){
                                            row.shopWareLsPriceTemp=(row.shopWareSmallLsPrice*hsNum).toFixed(2);
                                          }

                                        return row;
                                    });
                                }
                               return rows;
                             }
                            }
                    	">
                        <div data-field="wareNm" uglcw-options="width:100">商品名称</div>
                        <%-- <div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
                        <div data-field="wareGg" uglcw-options="width:80">规格</div>
                        <div data-field="wareDw" uglcw-options="width:60">单位</div>--%>
                        <div data-field="hsNum" uglcw-options="width:60">大小单位换算比例</div>
                        <%--<div data-field="wareDj" uglcw-options="width:50">批发价(进)</div>--%>
                        <div data-field="lsPrice" uglcw-options="width:50">原价(进)</div>


                        <div data-field="shopWareRate"
                             uglcw-options="width:50,
                             editor: function(container, options){
                             var model = options.model;
                             var input = $('<input name=\'shopWareRate\' data-bind=\'value:shopWareRate\'/>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.Numeric(input);
                             widget.init({
                              min: 0,
                              change: function(){
                                chageRate(this.value(),'shopWareRate',model);
                              }
                             })
                             }"
                        >批发系数%
                        </div>


                        <div data-field="shopWarePrice"
                             uglcw-options="width:60,
                              template: function(data){
                                return uglcw.util.template($('#priceTempl').html())({orign:data.shopWarePrice,temp:data.shopWarePriceTemp});
                              },
                             editor: function(container, options){
                             var model = options.model;
                             var dataStyle='';
                             if(model.shopWarePriceTemp){
                                var binput=$('<input disabled style=\'width:35%\' data-bind=\'value:shopWarePriceTemp\'>');
                                binput.appendTo(container);
                                new uglcw.ui.TextBox(binput).init();
                                dataStyle='style=\'width:55%\'';
                             }
                             var input = $('<input '+dataStyle+'  name=\'shopWarePrice\' data-bind=\'value:shopWarePrice\'/>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.Numeric(input);
                             widget.init({
                              min: 0,
                              change: function(){
                                changeMaxPrice(this.value(),'shopWarePrice',model);
                              }
                             })
                             }"
                        >商城批发价(大)
                        </div>
                        <div data-field="shopWareSmallPrice"
                             uglcw-options="width:60,
                              template: function(data){
                                return uglcw.util.template($('#priceTempl').html())({orign:data.shopWareSmallPrice,temp:data.shopWareSmallPriceTemp});
                              },
                             editor: function(container, options){
                             var model = options.model;
                             var dataStyle='';
                             if(model.shopWareSmallPriceTemp){
                                var binput=$('<input disabled style=\'width:35%\' data-bind=\'value:shopWareSmallPriceTemp\'>');
                                binput.appendTo(container);
                                new uglcw.ui.TextBox(binput).init();
                                dataStyle='style=\'width:55%\'';
                             }
                             var input = $('<input '+dataStyle+'  name=\'shopWareSmallPrice\' data-bind=\'value:shopWareSmallPrice\'/>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.Numeric(input);
                             widget.init({
                              min: 0,
                              change: function(){
                                chageSmallPrice(this.value(),'shopWareSmallPrice',model);
                              }
                             })
                             }"
                        >商城批发价(小)
                        </div>

                        <div data-field="shopWareLsRate"
                             uglcw-options="width:50,
                             editor: function(container, options){
                             var model = options.model;
                             var input = $('<input name=\'shopWareLsRate\' data-bind=\'value:shopWareLsRate\'/>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.Numeric(input);
                             widget.init({
                              min: 0,
                              change: function(){
                                chageRate(this.value(),'shopWareLsRate',model);
                              }
                             })
                             }"
                        >零售系数%
                        </div>

                        <div data-field="shopWareLsPrice"
                             uglcw-options="width:60,
                              template: function(data){
                                return uglcw.util.template($('#baseLsPriceTempl').html())({orign:data.shopWareLsPrice,temp:data.shopWareLsPriceTemp,data:data,isSmall:false});
                              },
                             editor: function(container, options){
                             var model = options.model;
                             var dataStyle='';
                             if(model.shopWareLsPriceTemp){
                                var binput=$('<input disabled style=\'width:35%\' data-bind=\'value:shopWareLsPriceTemp\'>');
                                binput.appendTo(container);
                                new uglcw.ui.TextBox(binput).init();
                                dataStyle='style=\'width:55%\'';
                             }
                             var input = $('<input '+dataStyle+'  name=\'shopWareLsPrice\' data-bind=\'value:shopWareLsPrice\'/>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.Numeric(input);
                             widget.init({
                              min: 0,
                              change: function(){
                                changeMaxPrice(this.value(),'shopWareLsPrice',model);
                              }
                             })
                             }"
                        >商城零售价(大)
                        </div>
                        <div data-field="shopWareSmallLsPrice"
                             uglcw-options="width:60,
                              template: function(data){
                                return uglcw.util.template($('#baseLsPriceTempl').html())({orign:data.shopWareSmallLsPrice,temp:data.shopWareSmallLsPriceTemp,data:data,isSmall:true});
                              },
                             editor: function(container, options){
                             var model = options.model;
                             var dataStyle='';
                             if(model.shopWareSmallLsPriceTemp){
                                var binput=$('<input disabled style=\'width:35%\' data-bind=\'value:shopWareSmallLsPriceTemp\'>');
                                binput.appendTo(container);
                                new uglcw.ui.TextBox(binput).init();
                                dataStyle='style=\'width:55%\'';
                             }
                             var input = $('<input '+dataStyle+'  name=\'shopWareSmallLsPrice\' data-bind=\'value:shopWareSmallLsPrice\'/>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.Numeric(input);
                             widget.init({
                              min: 0,
                              change: function(){
                                chageSmallPrice(this.value(),'shopWareSmallLsPrice',model);
                              }
                             })
                             }"
                        >商城零售价(小)
                        </div>


                        <%-- <div data-field="shopWarePrice" uglcw-options="
                                 width:120,
                                 headerTemplate: uglcw.util.template($('#header_pfPrice').html()),
                                 template:function(row){
                                     return uglcw.util.template($('#price').html())({val:row.shopWarePrice, data: row, field:'pfPrice'})
                                 }
                                 ">
                         </div>
                         <div data-field="shopWareSmallPrice" uglcw-options="
                                 width:120,
                                 headerTemplate: uglcw.util.template($('#header_minPfPrice').html()),
                                 template:function(row){
                                     return uglcw.util.template($('#price').html())({val:row.shopWareSmallPrice, data: row, field:'minPfPrice'})
                                 }
                                 ">
                         </div>
                         <div data-field="shopWareLsPrice" uglcw-options="
                                 width:120,
                                 headerTemplate: uglcw.util.template($('#header_lsPrice').html()),
                                 template:function(row){
                                     return uglcw.util.template($('#price').html())({val:row.shopWareLsPrice, data: row, field:'lsPrice'})
                                 }
                                 ">
                         </div>
                         <div data-field="shopWareSmallLsPrice" uglcw-options="
                                 width:120,
                                 headerTemplate: uglcw.util.template($('#header_minLsPrice').html()),
                                 template:function(row){
                                     return uglcw.util.template($('#price').html())({val:row.shopWareSmallLsPrice, data: row, field:'minLsPrice'})
                                 }
                                 ">
                         </div>
                         --%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script id="priceTempl" type="text/x-uglcw-template">
    #if(orign){#
    #=orign#
    #}else if(temp){#
    <span style="color:green">(#=temp#)</span>
    #}#
</script>


<script id="baseLsPriceTempl" type="text/x-uglcw-template">
    #if(orign){#
    #=orign#
    #}else if(temp){#
        <span style="color:green">(#=temp#)</span>
    #}else if((data.lsPrice || data.minLsPrice) && data.hsNum){#
        #if(!isSmall){#
            <span style="color: orange">(#=data.lsPrice?data.lsPrice:(data.minLsPrice*data.hsNum).toFixed(2)#)</span>
        #}else{#
            <span style="color: orange">(#=data.minLsPrice?data.minLsPrice:(data.lsPrice/data.hsNum).toFixed(2)#)</span>
        #}#
    #}#
</script>

<%--上架状态--%>
<%--<script id="header_pfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('pfPrice');">商城批发价(大)✎</span>
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('lsPrice');">商城零售价（大）✎</span>
</script>
<script id="header_cxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('cxPrice');">商城大单位促销价✎</span>
</script>
<script id="header_minPfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minPfPrice');">商城批发价(小)✎</span>
</script>
<script id="header_minLsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minLsPrice');">商城零售价(小)✎</span>
</script>
<script id="header_minCxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minCxPrice');">商城小单位促销价✎</span>
</script>
<script id="price" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #

    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric" uglcw-validate="number"
           style="height:25px;display:none" onchange="changePrice(this,'#= field #',#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>
    #if(!val && field ){#
    #if(field=='pfPrice' && data.wareDj)val=data.wareDj#
    #if(field=='lsPrice' && data.lsPrice)val=data.lsPrice#
    #if(field=='minPfPrice' && data.sunitPrice)val=data.sunitPrice#
    #if(field=='minLsPrice' && data.minLsPrice)val=data.minLsPrice#
    &lt;%&ndash; <span style="color: orange;" class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>&ndash;%&gt;
    #}#

</script>--%>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}/static/uglcu/shop/wareUpdatePrice.js?v=20200106" type="text/javascript"></script>
<script>
    //修改价格提交链接
    var chagePriceUrl = "manager/shopWare/updateShopWarePrice3";
    var getRate = {
        pf() {
            return uglcw.ui.get('#basePfRate').value();
        },
        ls() {
            return uglcw.ui.get('#baseLsRate').value();
        }
    }
    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#click-flag').value(1);
            uglcw.ui.get('#grid').reload();
        })

        //重置
        /*  uglcw.ui.get('#reset').on('click', function () {
              uglcw.ui.clear('.form-horizontal');
              uglcw.ui.get('#grid').reload();
          })*/
        //全局批发系数设置
        uglcw.ui.get('#basePfRate').on('change', function () {
            var basePfRate = uglcw.ui.get("#basePfRate").value();
            //uglcw.ui.confirm('商品批发价(大)和小单位价格未单独设置时,将统一按此系数进行计算!', function () {
            $.ajax({
                url: "manager/shopSetting/edit",
                type: "post",
                data: {
                    name: "shopBaseWareGlobalPfRate" + '${gradeId}',
                    basePfRate: basePfRate
                },
                success: function (data) {
                    if (data.success) {
                        uglcw.ui.success(data.msg);
                        //uglcw.ui.get('#grid').reload();
                        location.reload();
                    } else {
                        uglcw.ui.toast("设置错误");
                    }
                }
            });
            //})
        })
        //全局零售系数设置
        uglcw.ui.get('#baseLsRate').on('change', function () {
            var baseLsRate = uglcw.ui.get("#baseLsRate").value();
            //uglcw.ui.confirm('零售价(大)和小单位价格未单独设置时,将统一按此系数进行计算!', function () {
            $.ajax({
                url: "manager/shopSetting/edit",
                type: "post",
                data: {
                    name: "shopBaseWareGlobalLsRate" + '${gradeId}',
                    baseLsRate: baseLsRate
                },
                success: function (data) {
                    if (data.success) {
                        uglcw.ui.success(data.msg);
                        //uglcw.ui.get('#grid').reload();
                        location.reload();
                    } else {
                        uglcw.ui.toast("设置错误");
                    }
                }
            });
            //})
        })
        uglcw.ui.loaded();
    })

    //---------------------------------------------------------------------------------------------------------------

    /* function operatePrice(field) {
         var display = $("." + field + "_input").css('display');
         if (display == 'none') {
             $("." + field + "_input").show();
             $("." + field + "_span").hide();
         } else {
             $("." + field + "_input").hide();
             $("." + field + "_span").show();
         }
     }

     function changePrice(o, field, wareId) {
         if (isNaN(o.value)) {
             uglcw.ui.toast("请输入数字")
             return;
         }
         $.ajax({
             url: "manager/shopWare/updateShopWarePrice2",
             type: "post",
             data: "id=" + wareId + "&price=" + o.value + "&field=" + field,
             success: function (data) {
                 if (data == '1') {
                     $("#" + field + "_span_" + wareId).text(o.value);
                     uglcw.ui.success("操作成功");
                 } else {
                     uglcw.ui.toast("价格保存失败");
                 }
             }
         });
     }*/


</script>
</body>
</html>
