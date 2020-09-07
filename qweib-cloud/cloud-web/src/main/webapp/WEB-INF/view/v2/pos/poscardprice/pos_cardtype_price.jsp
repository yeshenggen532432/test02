<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员类型价格设置-设置商品价格</title>
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
        <div class="uglcw-layout-fixed" style="width: 220px;">
            <div class="layui-card">
                <div class="layui-card-header">库存商品类</div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">
                    <div uglcw-role="tree" id="tree"
                         uglcw-options="
							url: '${base}manager/syswaretypes',
							expandable:function(node){return node.id == '0'},
							loadFilter: function (response) {
                               $(response).each(function (index, item) {
                                    if (item.text == '根节点') {
                                        item.text = '库存商品类'
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
                            <input type="hidden" uglcw-model="wareType" id="wareType" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="memberType" id="memberType" uglcw-role="textbox"
                                   value="${memberType}">
                            <input uglcw-model="typeName" uglcw-role="textbox" placeholder="会员类型" value="${typeName}"
                                   readonly="readonly">
                        </li>
                        <li>
                            <tag:select2 name="shopNo" id="shopNo" tableName="pos_shopinfo" displayKey="shop_no"
                                         displayValue="shop_name" index="0"/>
                        </li>
                        <li>
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li style="width: 300px;">
                            <input type="hidden" uglcw-role="textbox"id="click-flag" value="0"/>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
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
							 query: function(params){
                             if(uglcw.ui.get('#click-flag').value()==1){
                                delete params['wareType']
                            }
                            return params;
                            },
							toolbar: uglcw.util.template($('#toolbar').html()),
							pageable: true,
                    		url: '${base}manager/pos/queryMemberTypePrice',
                    		criteria: '.form-horizontal',
                    	">
                        <div data-field="wareNm" uglcw-options="width:100">商品名称</div>
                        <div data-field="wareDw" uglcw-options="width:60">大单位</div>
                        <div data-field="minUnit" uglcw-options="width:60">小单位</div>
                        <div data-field="posPrice1" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_lsPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.posPrice1, data: row, field:'posPrice1'})
								}
								">
                        </div>
                        <div data-field="posPrice2" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_minLsPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.posPrice2, data: row, field:'posPrice2'})
								}
								">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <button id="importPrice" class="k-button" uglcw-role="button"><i class="k-icon k-i-excel"></i>导入批发价
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('posPrice1');">大单位零售价✎</span>
</script>
<script id="header_minLsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('posPrice2');">小单位零售价✎</span>
</script>
<script id="price" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #

    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric" uglcw-validate="number"
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
            uglcw.ui.get('#click-flag').value(1);
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#importPrice').on('click', function () {
            var flag = 0;
            var shopNo = $("#shopNo").val();
            var memberType = $('#memberType').val();
            $.ajax({
                url: "manager/pos/importBatPrice",
                type: "post",
                data: {
                    "shopNo": shopNo,
                    "memberType": memberType

                },
                success: function (data) {
                    if (data.state) {
                        alert("导入成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        alert("操作失败");
                        return;
                    }
                }
            });
        })

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
            url: "${base}manager/pos/saveMembertypePrice",
            type: "post",
            data: "wareId=" + wareId + "&" + field + "=" + o.value + "&shopNo=" + $("#shopNo").val() + "&memberType=" + $("#memberType").val(),
            success: function (data) {
                if (data.state) {
                    $("#" + field + "_span_" + wareId).text(o.value);
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }


</script>
</body>
</html>
