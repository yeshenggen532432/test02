<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员等级-商品价格</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <%@include file="/WEB-INF/view/v2/include/edit-kendo.jsp" %>
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
        <div class="uglcw-layout-fixed" style="width: 200px;">
            <div class="layui-card">
                <div class="layui-card-header">商品分类</div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">
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
								uglcw.ui.get('#wareType').value(node.id);
								uglcw.ui.get('#click-flag').value(0)
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
                            <input type="hidden" uglcw-model="wareType" id="wareType" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="gradeId" id="gradeId" uglcw-role="textbox" value="${gradeId}">
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li>
                            <input type="hidden" uglcw-role="textbox" id="click-flag" value="0"/>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <%-- <button id="reset" class="k-button" uglcw-role="button">重置</button>--%>
                        </li>
                    </ul>
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <span>
                                ${isJxc == 1?"批发":"零售"}系数
                            </span>
                            <input style="width:80px;!important;" uglcw-model="gradeRate" id="gradeRate"
                                   uglcw-role="numeric"
                                   value="${gradeRate}"
                                   title="原价(进)*${isJxc == 1?"批发":"零售"}系数/100=商城${isJxc == 1?"批发":"零售"}价(大),注:${isJxc == 1?"批发":"零售"}价(小)为空时">%
                        </li>
                        <%--<li>
                            <button id="shopGradeWareRateSubmit" uglcw-role="button" class="k-button k-info">修改${isJxc == 1?"批发":"零售"}系数</button>
                        </li>--%>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
						    responsive:['.header',40],
							id:'id',
							pageable: true,
							editable: true,
                    		url: '${base}manager/shopMemberPrice/shopWareGradePricePage',
                    		criteria: '.form-horizontal',
							query: function(params){
                            if(uglcw.ui.get('#click-flag').value()==1){
                                delete params['wareType']
                            }
                            return params;
                            },
                            loadFilter:{
                            data: function(response){
                                 var rows = [];
                                 var gradeRate='${gradeRate}';

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
                                            if(!row.shopWarePrice && !row.shopWareSmallPrice && gradeRate){
                                                row.shopWarePriceTemp=(row.lsPrice*parseFloat(gradeRate)/100).toFixed(2);
                                                row.shopWareSmallPriceTemp=(row.shopWarePriceTemp/hsNum).toFixed(2);
                                            }

                                            if(row.shopWareLsPrice){
                                                row.shopWareLsRate=(row.shopWareLsPrice/row.lsPrice*100).toFixed(2);
                                            }
                                            //全局零售价系数有设置,零售价(大和小)都为空时
                                            if(!row.shopWareLsPrice && !row.shopWareSmallLsPrice && gradeRate){
                                                 row.shopWareLsPriceTemp=(row.lsPrice*parseFloat(gradeRate)/100).toFixed(2);;
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
                        <div data-field="wareNm" uglcw-options="width:120">商品名称</div>
                        <div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
                        <%--<div data-field="wareGg" uglcw-options="width:80">规格</div>--%>
                        <%--<div data-field="wareDw" uglcw-options="width:60">单位</div>--%>
                        <%--<div data-field="wareDj" uglcw-options="width:60">批发价</div>--%>
                        <%--<div data-field="lsPrice" uglcw-options="width:60">原价</div>--%>
                        <div data-field="hsNum" uglcw-options="width:60">大小单位换算比例</div>
                        <div data-field="lsPrice" uglcw-options="width:60">原价(进)</div>

                        <c:choose>
                            <c:when test="${isJxc == 1}">
                                <div data-field="shopWareRate"
                                     uglcw-options="width:60,
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
                                     uglcw-options="width:80,
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
                                     uglcw-options="width:80,
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
                            </c:when>
                            <c:otherwise>
                                <%-- <div data-field="shopWareLsRate" uglcw-options="
                                 width:130,
                                 headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '零售系数%',field:'shopWareLsRate'}),
                                 template:function(row){
                                     var dataSource={lsPrice:row.lsPrice,hsNum:row.hsNum};
                                     return uglcw.util.template($('#data_edit_template').html())({value:row.shopWareLsRate, id:row.wareId, field:'shopWareLsRate',type:'number',dataSource:dataSource,callback:'changePrice'})
                                 }
                                 ">
                                 </div>
                                 <div data-field="shopWareLsPrice" uglcw-options="
                                 width:130,
                                 headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '商城零售价(大)',field:'shopWareLsPrice'}),
                                 template:function(row){
                                      var dataSource={lsPrice:row.lsPrice,hsNum:row.hsNum};
                                     return uglcw.util.template($('#data_edit_template').html())({value:row.shopWareLsPrice, id:row.wareId, field:'shopWareLsPrice',type:'number',dataSource:dataSource,tipText:row.shopWareLsPriceTemp,callback:'changePrice'})
                                 }
                                 ">
                                 </div>
                                 <div data-field="shopWareSmallLsPrice" uglcw-options="
                                 width:130,
                                 headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '商城零售价(小)',field:'shopWareSmallLsPrice'}),
                                 template:function(row){
                                     var dataSource={lsPrice:row.lsPrice,hsNum:row.hsNum};
                                     return uglcw.util.template($('#data_edit_template').html())({value:row.shopWareSmallLsPrice, id:row.wareId, field:'shopWareSmallLsPrice',type:'number',dataSource:dataSource,tipText:row.shopWareSmallLsPriceTemp,callback:'changePrice'})
                                 }
                                 ">
                                 </div>--%>


                                <div data-field="shopWareLsRate"
                                     uglcw-options="width:100,
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
                                     uglcw-options="width:100,
                              template: function(data){
                                return uglcw.util.template($('#priceTempl').html())({orign:data.shopWareLsPrice,temp:data.shopWareLsPriceTemp});
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
                                     uglcw-options="width:100,
                              template: function(data){
                                return uglcw.util.template($('#priceTempl').html())({orign:data.shopWareSmallLsPrice,temp:data.shopWareSmallLsPriceTemp});
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


                            </c:otherwise>
                        </c:choose>
                        <%--<div data-field="shopWareCxPrice" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_cxPrice').html()),
                                template:function(row){
                                    return uglcw.util.template($('#price').html())({val:row.shopWareCxPrice, data: row, field:'shopWareCxPrice'})
                                }
                                ">
                        </div>--%>
                        <%--<div data-field="shopWareSmallCxPrice" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_minCxPrice').html()),
                                template:function(row){
                                    return uglcw.util.template($('#price').html())({val:row.shopWareSmallCxPrice, data: row, field:'shopWareSmallCxPrice'})
                                }
                                ">
                        </div>--%>
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

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}/static/uglcu/shop/wareUpdatePrice.js" type="text/javascript"></script>
<script>
    //修改价格提交链接
    var chagePriceUrl = "manager/shopMemberPrice/updateShopMemeberGradePrice2?gradeId=${gradeId}";
    var getRate = {
        pf() {
            return uglcw.ui.get('#gradeRate').value();
        },
        ls() {
            return uglcw.ui.get('#gradeRate').value();
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
        /*     uglcw.ui.get('#reset').on('click', function () {
                 uglcw.ui.clear('.form-horizontal');
                 uglcw.ui.get('#grid').reload();
             })*/

        uglcw.ui.get('#gradeRate').on('change', function () {
            var gradeRate = uglcw.ui.get("#gradeRate").value();
            //uglcw.ui.confirm('商品大单位价格和小单位价格未单独设置时,将统一按此系数进行计算!', function () {
            $.ajax({
                url: "manager/shopSetting/edit",
                type: "post",
                data: {
                    name: "shopGradeWareGlobalRate" + '${gradeId}',
                    gradeRate: gradeRate,
                    gradeId:${gradeId},
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
</script>
</body>
</html>
