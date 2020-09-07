<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品价格设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-header">库存商品类</div>
                <div class="layui-card-body">
                    <div uglcw-role="tree" id="tree"
                         uglcw-options="
							url: '${base}manager/companyStockWaretypes',
							expandable:function(node){return node.id == '0'},
							loadFilter:function(response){
							$(response).each(function(index,item){
							if(item.text=='根节点'){
							item.text='库存商品类'
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
                            <input type="hidden" uglcw-model="wtype" id="wareType" uglcw-role="textbox">

                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li>

                            <input uglcw-model="packBarCode" uglcw-role="textbox" placeholder="大单位条码">
                        </li>
                        <li>
                            <input uglcw-model="beBarCode" uglcw-role="textbox" placeholder="小单位条码">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="status" placeholder="商品状态" uglcw-options="value: ''">
                                <option value="1" selected>启用</option>
                                <option value="2">不启用</option>
                            </select>
                        </li>
                        <li>
                            <input type="hidden" uglcw-role="textbox"id="click-flag" value="0"/>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>

                        </li>
                        <li >
                            <div  style="width:380px">
                            <span style="color: red">注: 【销售原价】=【采购价】*(1+【加价比例%】)</span>
                            </div>
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
                                delete params['wtype']
                            }
                            return params;
                            },
							pageable: true,
                    		url: '${base}manager/wareSetPricePage',
                    		criteria: '.form-horizontal',
                    	">
                        <div data-field="wareCode" uglcw-options="width:100">商品编码</div>
                        <div data-field="wareNm" uglcw-options="width:150,tooltip:true,fixed:true">商品名称</div>
                        <div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
                        <div data-field="wareGg" uglcw-options="width:110,tooltip:true">规格</div>
                        <div data-field="wareDw" uglcw-options="width:60">大单位</div>
                        <div data-field="minUnit" uglcw-options="width:60">小单位</div>
                        <div data-field="inPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_inPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.inPrice, data: row, field:'inPrice'})
								}
								">
                        </div>
                        <div data-field="addRate" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_addRate').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.addRate, data: row, field:'addRate'})
								}
								">
                        </div>
                        <div data-field="lsPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_lsPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.lsPrice, data: row, field:'lsPrice'})
								}
								">
                        </div>
                        <div data-field="wareDj" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_pfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.wareDj, data: row, field:'wareDj'})
								}
								">
                        </div>
                        <%--<div data-field="fxPrice" uglcw-options="--%>
                        <%--width:120,--%>
                        <%--headerTemplate: uglcw.util.template($('#header_fxPrice').html()),--%>
                        <%--template:function(row){--%>
                        <%--return uglcw.util.template($('#price').html())({val:row.fxPrice, data: row, field:'fxPrice'})--%>
                        <%--}--%>
                        <%--">--%>
                        <%--</div>--%>
                        <%--<div data-field="cxPrice" uglcw-options="--%>
                        <%--width:120,--%>
                        <%--headerTemplate: uglcw.util.template($('#header_cxPrice').html()),--%>
                        <%--template:function(row){--%>
                        <%--return uglcw.util.template($('#price').html())({val:row.cxPrice, data: row, field:'cxPrice'})--%>
                        <%--}--%>
                        <%--">--%>
                        <%--</div>--%>
                        <div data-field="minInPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_minInPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.minInPrice, data: row, field:'minInPrice'})
								}
								">
                        </div>
                        <div data-field="minLsPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_minLsPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.minLsPrice, data: row, field:'minLsPrice'})
								}
								">
                        </div>
                        <div data-field="sunitPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_minPfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.sunitPrice, data: row, field:'sunitPrice'})
								}
								">
                        </div>

                        <div data-field="tcAmt" uglcw-options="
								width:120,
								hidden:true,
								headerTemplate: uglcw.util.template($('#header_tcAmt').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.tcAmt, data: row, field:'tcAmt'})
								}
								">
                        </div>
                        <div data-field="saleProTc" uglcw-options="
								width:180,
								hidden:true,
								headerTemplate: uglcw.util.template($('#header_saleProTc').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.saleProTc, data: row, field:'saleProTc'})
								}
								">
                        </div>
                        <div data-field="saleGroTc" uglcw-options="
								width:180,
								hidden:true,
								headerTemplate: uglcw.util.template($('#header_saleGroTc').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.saleGroTc, data: row, field:'saleGroTc'})
								}
								">
                        </div>
                        <%--<div data-field="minFxPrice" uglcw-options="--%>
                        <%--width:120,--%>
                        <%--headerTemplate: uglcw.util.template($('#header_minFxPrice').html()),--%>
                        <%--template:function(row){--%>
                        <%--return uglcw.util.template($('#price').html())({val:row.minFxPrice, data: row, field:'minFxPrice'})--%>
                        <%--}--%>
                        <%--">--%>
                        <%--</div>--%>
                        <%--<div data-field="minCxPrice" uglcw-options="--%>
                        <%--width:120,--%>
                        <%--headerTemplate: uglcw.util.template($('#header_minCxPrice').html()),--%>
                        <%--template:function(row){--%>
                        <%--return uglcw.util.template($('#price').html())({val:row.minCxPrice, data: row, field:'minCxPrice'})--%>
                        <%--}--%>
                        <%--">--%>
                        <%--</div>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script id="header_inPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('inPrice');">采购价(大)✎</span>
</script>
<script id="header_addRate" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('addRate');">加价比例%✎</span>
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('lsPrice');">销售原价(大)✎</span>
</script>
<script id="header_pfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('wareDj');">批发价(大)✎</span>
</script>
<script id="header_fxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('fxPrice');">大单位分销价✎</span>
</script>
<script id="header_cxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('cxPrice');">大单位促销价✎</span>
</script>
<script id="header_minInPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minInPrice');">采购价(小)✎</span>
</script>
<script id="header_minLsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minLsPrice');">销售原价(小)✎</span>
</script>
<script id="header_minPfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('sunitPrice');">批发价(小)✎</span>
</script>
<script id="header_minFxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minFxPrice');">小单位分销价✎</span>
</script>
<script id="header_minCxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minCxPrice');">小单位促销价✎</span>
</script>
<script id="header_tcAmt" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('tcAmt');">按数量业务提成✎</span>
</script>
<script id="header_saleProTc" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('saleProTc');">按收入业务提成比列%✎</span>
</script>
<script id="header_saleGroTc" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('saleGroTc');">按毛利业务提成比列%✎</span>
</script>
<script id="price" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #

    <input class="#=field#_input k-textbox" name="#=field#_input"  id="#=field#_input_#=wareId#" uglcw-role="numeric" uglcw-validate="number"
           style="height:25px;display:none" onchange="changePrice(this,'#= field #',#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>

</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#click-flag').value(1); //搜索标记
            uglcw.ui.get('#grid').reload();
        })

        //重置
        // uglcw.ui.get('#reset').on('click', function () {
        //     uglcw.ui.clear('.form-horizontal');
        //     uglcw.ui.get('#grid').reload();
        // })
        //设置tree高度
        var treeHeight = $(window).height() - $("div.layui-card-header").height() - 60;
        $("#tree").height(treeHeight + "px");
        uglcw.ui.loaded();
    })


    //---------------------------------------------------------------------------------------------------------------

    function operatePrice(field) {
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
            url: "${base}manager/updateWarePrice",
            type: "post",
            dataType: 'json',
            data: "id=" + wareId + "&price=" + o.value + "&field=" + field,
            success: function (data) {
                if (data.state) {
                    $("#" + field + "_span_" + wareId).text(o.value);
                    if(field=="addRate"||field=="inPrice"||field=="minInPrice"){
                        $("#lsPrice_span_" + wareId).text(data.lsPrice);
                        $("#lsPrice_input_" + wareId).val(data.lsPrice);
                        $("#minLsPrice_input_" + wareId).val(data.minLsPrice);
                        $("#minLsPrice_span_" + wareId).text(data.minLsPrice);
                    }
                    if(field=="lsPrice"||field=="minLsPrice"){//addRate_span_9
                        data.addRate = "";
                        $("#addRate_input_" + wareId).val(data.addRate);
                        $("#addRate_span_" + wareId).text(data.addRate);
                    }
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }


</script>
</body>
</html>
