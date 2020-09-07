<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员价格</title>
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
        <div class="uglcw-layout-fixed" style="width: 200px">
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
								uglcw.ui.get('#wareType').value(node.id);
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
                            <input type="hidden" uglcw-role="textbox" uglcw-model="wareType" id="wareType">
                            <input type="hidden" uglcw-role="textbox" uglcw-model="shopMemberId" id="shopMemberId"
                                   value="${shopMemberId}">
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox" id="settingPrice" uglcw-model="settingPrice" placeholder="价格是否设置"
                                    uglcw-options="value:''">
                                <option value="">自定义价格是否设置</option>
                                <option value="0">未设置</option>
                                <option value="1">已设置</option>
                            </select>
                        </li>
                        <li>
                            <input type="hidden" uglcw-role="textbox" id="click-flag" value="0"/>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <%----<button id="reset" class="k-button" uglcw-role="button">重置</button>----%>
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
                            if(uglcw.ui.get('#click-flag').value()==1){
                                delete params['wareType']
                            }
                            return params;
                            },
							pageable: true,
							editable: true,
                    		url: '${base}manager/shopMemberPrice/queryShopMemberPriceByShopMemberId',
                    		criteria: '.form-horizontal',
                    		loadFilter:{
                            data: function(response){
                                 var rows = [];
                                 if(response.rows && response.rows.length > 0){
                                    rows = $.map(response.rows, function(row){
                                        var hsNum=row.hsNum;
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
                        <div data-field="hsNum" uglcw-options="width:60">大小单位换算比例</div>
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

                        <%-- <div data-field="shopWarePrice" uglcw-options="
                                 width:120,
                                 headerTemplate: uglcw.util.template($('#header_pfPrice').html()),
                                 template:function(row){
                                     return uglcw.util.template($('#price').html())({val:row.shopWarePrice, data: row, field:'pfPrice'})
                                 }
                                 ">
                         </div>--%>
                        <%--<div data-field="shopWareLsPrice" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_lsPrice').html()),
                                template:function(row){
                                    return uglcw.util.template($('#price').html())({val:row.shopWareLsPrice, data: row, field:'lsPrice'})
                                }
                                ">
                        </div>
                        <div data-field="shopWareCxPrice" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_cxPrice').html()),
                                template:function(row){
                                    return uglcw.util.template($('#price').html())({val:row.shopWareCxPrice, data: row, field:'cxPrice'})
                                }
                                ">
                        </div>--%>
                        <%-- <div data-field="shopWareSmallPrice" uglcw-options="
                                 width:120,
                                 headerTemplate: uglcw.util.template($('#header_minPfPrice').html()),
                                 template:function(row){
                                     return uglcw.util.template($('#price').html())({val:row.shopWareSmallPrice, data: row, field:'minPfPrice'})
                                 }
                                 ">
                         </div>--%>
                        <%--<div data-field="shopWareSmallLsPrice" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_minLsPrice').html()),
                                template:function(row){
                                    return uglcw.util.template($('#price').html())({val:row.shopWareSmallLsPrice, data: row, field:'minLsPrice'})
                                }
                                ">
                        </div>
                        <div data-field="shopWareSmallCxPrice" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_minCxPrice').html()),
                                template:function(row){
                                    return uglcw.util.template($('#price').html())({val:row.shopWareSmallCxPrice, data: row, field:'minCxPrice'})
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
<%--上架状态--%>
<%--<script id="header_pfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('pfPrice');">商城批发价(大)✎</span>
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('lsPrice');">商城零售价(大)✎</span>
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

</script>--%>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}/static/uglcu/shop/wareUpdatePrice.js" type="text/javascript"></script>
<script>
    //修改价格提交链接
    var chagePriceUrl = "${base}manager/shopMemberPrice/updateShopMemeberPrice2?shopMemberId=${shopMemberId}";
    var getRate = {
        pf() {
            return null;
        },
        ls() {
            return null;
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
        /* uglcw.ui.get('#reset').on('click', function () {
             uglcw.ui.clear('.form-horizontal');
             uglcw.ui.get('#grid').reload();
         })
 */
        uglcw.ui.loaded();
    })


    //---------------------------------------------------------------------------------------------------------------

    /*    function operatePrice(field) {
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
                url: "${base}manager/shopMemberPrice/updateShopMemeberPrice2",
            type: "post",
            data: {
                wareId: wareId,
                field: field,
                price: o.value,
                shopMemberId:${shopMemberId},
            },
            success: function (data) {
                if (data == '1') {
                    $("#" + field + "_span_" + wareId).text(o.value);
                    uglcw.ui.success("修改成功");
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }*/


</script>
</body>
</html>
