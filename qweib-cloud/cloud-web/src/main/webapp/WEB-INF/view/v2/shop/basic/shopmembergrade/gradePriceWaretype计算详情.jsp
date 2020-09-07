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
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input uglcw-model="gradeRate" id="gradeRate" uglcw-role="numeric"
                                   placeholder="${isJxc == 1?"批发":""}系数%" value="${gradeRate}"
                                   title="原价(进)*${isJxc == 1?"批发":"零售"}系数/100=商城${isJxc == 1?"批发":"零售"}价(大),注:${isJxc == 1?"批发":"零售"}价(小)必须为空">
                        </li>
                        <li>
                            <button id="shopGradeWareRateSubmit" uglcw-role="button" class="k-button k-info">确定修改系数
                            </button>
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
                                                row.shopWareLsPrice=(row.shopWareLsPrice/row.lsPrice*100).toFixed(2);
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
                        <div data-field="wareNm" uglcw-options="width:100">商品名称</div>
                        <div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
                        <%--<div data-field="wareGg" uglcw-options="width:80">规格</div>--%>
                        <%--<div data-field="wareDw" uglcw-options="width:60">单位</div>--%>
                        <%--<div data-field="wareDj" uglcw-options="width:60">批发价</div>--%>
                        <%--<div data-field="lsPrice" uglcw-options="width:60">原价</div>--%>
                        <div data-field="hsNum" uglcw-options="width:60">大小单位换算比例</div>
                        <div data-field="lsPrice" uglcw-options="width:60">原价(进)</div>

                        <c:choose>
                            <c:when test="${isJxc == 1}">
                                <%-- <div data-field="shopWareRate" uglcw-options="
                                 width:130,
                                 headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '批发系数%',field:'shopWareRate'}),
                                 template:function(row){
                                     var dataSource={lsPrice:row.lsPrice,hsNum:row.hsNum};
                                     return uglcw.util.template($('#data_edit_template').html())({value:row.shopWareRate, id:row.wareId, field:'shopWareRate',type:'number',dataSource:dataSource,callback:'changePrice'})
                                 }
                                 ">--%>

                                <div data-field="shopWareRate"
                                     uglcw-options="width:100,
                             editor: function(container, options){
                             var model = options.model;
                             var dataStyle='';
                            <%-- if(model.shopWarePriceTemp){
                                var binput=$('<input disabled style=\'width:35%\' data-bind=\'value:shopWarePriceTemp\'>');
                                binput.appendTo(container);
                                new uglcw.ui.TextBox(binput).init();
                                dataStyle='style=\'width:55%\'';
                             }--%>
                             var input = $('<input '+dataStyle+'  name=\'shopWareRate\' data-bind=\'value:shopWareRate\'/>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.Numeric(input);
                             widget.init({
                              min: 0,
                              change: function(){
                                changePfPrice(this.value(),'shopWareRate',model);
                              }
                             })
                             }"
                                >批发系数%
                                </div>

                                <div data-field="shopWarePrice"
                                     uglcw-options="width:100,
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
                                changePfPrice(this.value(),'shopWarePrice',model);
                              }
                             })
                             }"
                                >商城批发价(大)
                                </div>
                                <div data-field="shopWareSmallPrice"
                                     uglcw-options="width:100,
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
                                changePfPrice(this.value(),'shopWareSmallPrice',model);
                              }
                             })
                             }"
                                >商城批发价(小)
                                </div>


                                <%--</div>
                                <div data-field="shopWarePrice" uglcw-options="
								width:130,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '商城批发价(大)',field:'shopWarePrice'}),
								template:function(row){
								    var dataSource={lsPrice:row.lsPrice,hsNum:row.hsNum};
									return uglcw.util.template($('#data_edit_template').html())({value:row.shopWarePrice, id:row.wareId, field:'shopWarePrice',type:'number',dataSource:dataSource,tipText:row.shopWarePriceTemp,callback:'changePrice'})
								}
								">
                                </div>
                                <div data-field="shopWareSmallPrice" uglcw-options="
								width:130,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '商城批发价(小)',field:'shopWareSmallPrice'}),
								template:function(row){
								     var dataSource={lsPrice:row.lsPrice,hsNum:row.hsNum};
									return uglcw.util.template($('#data_edit_template').html())({value:row.shopWareSmallPrice, id:row.wareId, field:'shopWareSmallPrice',type:'number',dataSource:dataSource,tipText:row.shopWareSmallPriceTemp,callback:'changePrice'})
								}
								">
                                </div>--%>
                            </c:when>
                            <c:otherwise>
                                <div data-field="shopWareLsRate" uglcw-options="
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
<script>
    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#click-flag').value(1);
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#shopGradeWareRateSubmit').on('click', function () {
            var gradeRate = uglcw.ui.get("#gradeRate").value();
            uglcw.ui.confirm('商品大单位价格和小单位价格未单独设置时,将统一按此系数进行调整!', function () {
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
            })
        })
        uglcw.ui.loaded();
    })


    function changePfPrice(value, field, model) {
        switch (field) {
            case 'shopWareRate'://大单位系统可以为空不可以为0
                if (value == 0) {
                    uglcw.ui.error('批发系统不能为0');
                    return false;
                }
                var shopWarePrice = null;
                if (!value)
                    shopWarePrice = null;
                else if (model.lsPrice)
                    shopWarePrice = (model.lsPrice * (value / 100)).toFixed(2);//批发价大=原价*当前系数/100

                var gradeRate = uglcw.ui.get('#gradeRate').value();
                if (value) {
                    if (model.lsPrice) {
                        if (!model.shopWareSmallPrice) {//如果小单位未设置时
                            var shopWareSmallPriceTemp = shopWarePrice / model.hsNum;//小单位零时价格=大单位价格/大小单位换算比例
                            model.set('shopWareSmallPriceTemp', shopWareSmallPriceTemp.toFixed(2));
                            model.set('shopWareSmallPrice', 1);//需改变绑定字段,临时数据才会更新
                            model.set('shopWareSmallPrice', null);
                        }
                    } else {
                        uglcw.ui.error('原价(进)不能为空');
                        return false;
                    }
                } else {
                    if (model.lsPrice && gradeRate) {
                        var shopWarePriceTemp = (model.lsPrice * gradeRate / 100).toFixed(2);
                        model.set('shopWarePriceTemp', shopWarePriceTemp);
                        if (!model.shopWareSmallPrice) {
                            var shopWareSmallPriceTemp = shopWarePriceTemp / model.hsNum;//小单位价格=大单位价格/批发系数
                            model.set('shopWareSmallPriceTemp', shopWareSmallPriceTemp.toFixed(2));
                            model.set('shopWareSmallPrice', 1);//需改变绑定字段,临时数据才会更新
                            model.set('shopWareSmallPrice', null);
                        }
                    } else {
                        model.set('shopWareSmallPriceTemp', null);
                        model.set('shopWareSmallPrice', 1);//需改变绑定字段,临时数据才会更新
                        model.set('shopWareSmallPrice', null);
                    }
                }
                model.set('shopWarePrice', shopWarePrice);//修改大单位价格
                changePrice2(value, field, model.wareId, function () {
                    changePrice2(model.shopWarePrice, 'shopWarePrice', model.wareId);
                });
                break;
            case 'shopWarePrice':
                if (value == 0) {
                    uglcw.ui.error('大单位金额不能为');
                    return false;
                }
                if (!value) {
                    model.set('shopWareRate', null);
                    model.set('shopWareSmallPriceTemp', null);
                    model.set('shopWareSmallPrice', 1);
                    model.set('shopWareSmallPrice', null);
                }

                if (value && model.lsPrice) {
                    var shopWareRate = (value / model.lsPrice * 100).toFixed(2);//当前系数=大单位价格/原价/100
                    if (!model.shopWareSmallPrice) {//如果小单位未设置时
                        var shopWareSmallPriceTemp = value / model.hsNum;//小单位零时价格=大单位价格/大小单位换算比例
                        model.set('shopWareSmallPriceTemp', shopWareSmallPriceTemp.toFixed(2));
                        model.set('shopWareSmallPrice', 1);
                        model.set('shopWareSmallPrice', null);
                    }
                    model.set('shopWareRate', shopWareRate);
                    model.set('shopWarePriceTemp', null);
                } else if (model.lsPrice && uglcw.ui.get('#gradeRate').value()) {
                    var shopWarePriceTemp = (model.lsPrice * (uglcw.ui.get('#gradeRate').value() / 100)).toFixed(2);
                    model.set('shopWarePriceTemp', shopWarePriceTemp);
                    if (!model.shopWareSmallPrice) {
                        var shopWareSmallPriceTemp = model.shopWarePriceTemp / model.hsNum;//小单位价格=大单位价格/批发系数
                        model.set('shopWareSmallPriceTemp', shopWareSmallPriceTemp.toFixed(2));
                        model.set('shopWareSmallPrice', 1);
                        model.set('shopWareSmallPrice', null);
                    }
                }
                changePrice2(value, field, model.wareId, function () {
                    changePrice2(model.shopWareRate, 'shopWareRate', model.wareId);
                });
                break;
            case 'shopWareSmallPrice':
                model.set('shopWareSmallPriceTemp', null);
                if (!value) {
                    model.set('shopWarePriceTemp', null);
                    model.set('shopWarePrice', 1);
                    model.set('shopWarePrice', null);
                }
                if (value) {
                    if (!model.shopWarePrice) {
                        var shopWarePriceTemp = (value * model.hsNum).toFixed(2);
                        model.set('shopWarePriceTemp', shopWarePriceTemp);
                        model.set('shopWarePrice', 1);
                        model.set('shopWarePrice', null);
                    }
                } else if (model.lsPrice && model.lsPrice && uglcw.ui.get('#gradeRate').value()) {
                    if (!model.shopWarePrice) {
                        var shopWarePriceTemp = (model.lsPrice * (uglcw.ui.get('#gradeRate').value() / 100)).toFixed(2);
                        model.set('shopWarePriceTemp', shopWarePriceTemp);
                        var shopWareSmallPriceTemp = model.shopWarePriceTemp / model.hsNum;
                        model.set('shopWareSmallPriceTemp', shopWareSmallPriceTemp.toFixed(2));
                        model.set('shopWarePrice', 1);
                        model.set('shopWarePrice', null);
                    } else {
                        var shopWareSmallPriceTemp = model.shopWarePrice / model.hsNum;
                        model.set('shopWareSmallPriceTemp', shopWareSmallPriceTemp.toFixed(2));
                        model.set('shopWareSmallPrice', 1);
                        model.set('shopWareSmallPrice', null);
                    }
                }
                changePrice2(value, field, model.wareId);
                break;
        }
        //model.set('dirty', false);
    }

    /*
        function changePf(shopWareRate, shopWarePrice, shopWareSmallPrice, model) {//系数,大单价价,小单位价格
            var lsPrice = model.lsPrice;
            var hsNum = model.hsNum;
            var gradeRate = uglcw.ui.get('#gradeRate').value();
            if (shopWareRate) {
                if (lsPrice) {
                    model.set('shopWarePriceTemp', null);
                    var shopWarePrice = (lsPrice * shopWareRate / 100).toFixed(2);
                    model.set('shopWarePrice', shopWarePrice);
                    if (!shopWareSmallPrice) {
                        model.set('shopWareSmallPriceTemp', (shopWarePrice / hsNum).toFixed(2));
                    } else {
                        model.set('shopWareSmallPriceTemp', null);
                    }
                }
            } else {
                model.set('shopWarePrice', '');
            }

        }*/

    function changePrice(value, field, wareId, dataSource, callFun) {
        var model = null;
        if (dataSource)
            model = JSON.parse(decodeURI(dataSource));
        $.ajax({
            url: "manager/shopMemberPrice/updateShopMemeberGradePrice2",
            type: "post",
            data: {
                wareId: wareId,
                field: field,
                price: value,
                gradeId:${gradeId},
            },
            success: function (data) {
                if (data == '1') {
                    callFun();
                    if (model.lsPrice) {
                        if (field == 'shopWareRate') {
                            var shopWarePrice = value;
                            if (value) shopWarePrice = model.lsPrice * (value / 100);
                            changePrice2(shopWarePrice, "shopWarePrice", wareId);
                        } else if (field == 'shopWarePrice') {
                            var shopWareRate = value;
                            if (value) shopWareRate = value / model.lsPrice * 100;
                            changePrice2(shopWareRate, "shopWareRate", wareId);
                            //$("#shopWarePrice_spanTip_" + wareId).text('');
                        } else if (field == 'shopWareLsRate') {
                            var shopWareLsPrice = value;
                            if (value) shopWareLsPrice = model.lsPrice * (value / 100);
                            changePrice2(shopWareLsPrice, "shopWareLsPrice", wareId);
                            //$("#shopWareLsPrice_spanTip_" + wareId).text('');
                        } else if (field == 'shopWareLsPrice') {
                            var shopWareLsRate = value;
                            if (value) shopWareLsRate = value / model.lsPrice * 100;
                            changePrice2(shopWareLsRate, "shopWareLsRate", wareId);
                            //$("#shopWareLsPrice_spanTip_" + wareId).text('');
                        }
                    }
                    uglcw.ui.success('操作成功')
                    return true;
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }

    function changePrice2(value, field, wareId, fun) {
        $.ajax({
            url: "manager/shopMemberPrice/updateShopMemeberGradePrice2",
            type: "post",
            data: {
                wareId: wareId,
                field: field,
                price: value,
                gradeId:${gradeId},
            },
            success: function (data) {
                if (data == '1') {
                    if (fun) fun();
                    else
                        uglcw.ui.success('修改成功');
                    return true;
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }

</script>
</body>
</html>
