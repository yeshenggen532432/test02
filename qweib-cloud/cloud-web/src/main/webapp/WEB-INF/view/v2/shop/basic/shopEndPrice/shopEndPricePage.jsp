<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员最终执行表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-panelbar .k-tabstrip > .k-content, .k-tabstrip > .k-content {
            position: static;
            border-style: solid;
            border-width: 1px;
            margin: 0;
            padding: 0;
            zoom: 1;
        }

        .uglcw-tabstrip .uglcw-query > li {

        }

        .uglcw-tabstrip .k-state-disabled {
            opacity: 1;
        }

    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query query">
                <li style="width: 150px;">
                    <input placeholder="请选择商品" id="wareId" uglcw-role="gridselector" uglcw-model="wareNm,wareId"
                           uglcw-options="click: showWareSelector">
                </li>
                <li class="level">
                    <input uglcw-model="gradeName" uglcw-role="textbox" placeholder="等级名称">
                </li>
                <li class="non-level" style="display: none;">
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="会员名称">
                </li>
                <li class="non-level" style="display: none;">
                    <input uglcw-model="mobile" uglcw-role="textbox" placeholder="手机号">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>

            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div uglcw-role="tabs" uglcw-options="select: function(e){
                var index = $(e.item).index();
                if(index > 0){
                    $('.level').hide();
                    $('.non-level').show();
                }else{
                    $('.level').show();
                    $('.non-level').hide();
                }
                var grid = $('#grid'+index).data('kendoGrid');
                if(grid){
                    uglcw.ui.get('#grid'+index).reload();
                }
            }">
                <ul>
                    <li>常规会员</li>
                    <li>员工会员</li>
                    <li>进销存客户会员</li>
                    <li disabled>
                        <ul class="uglcw-query">
                            <li style="width: 200px!important;margin-left: 20px;">说明：<span style="background-color:orange">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>进销存商品基础价
                            </li>
                            <li><span style="background-color:#333333">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>商城商品基础价
                            </li>
                            <li><span style="background-color:blue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>商城会员等级价格
                            </li>
                            <li><span style="background-color:green">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>商城会员自定义价格
                            </li>
                        </ul>
                    </li>
                </ul>
                <div>
                    <div id="grid0" uglcw-role="grid"
                         uglcw-options="
						    responsive:['.header',80],
							id:'id',
							pageable: true,
                    		url: '${base}manager/shopEndPrice/ptEndPriceByWare?isJxc=0',
                    		criteria: '.query',
                    	">
                        <div data-field="gradeName" uglcw-options="width:100">会员等级</div>
                        <div data-field="oper" uglcw-options="width:150,
                                template:function(row){
									return uglcw.util.template($('#oper').html())({data: row, type:'1',name:row.gradeName,isJxc:0})
								}">
                            操作
                        </div>
                        <div data-field="isJxc" uglcw-options="width:150,template: uglcw.util.template($('#isJxc').html())">
                            进销存客户使用
                        </div>
                        <div data-field="shopWareLsPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareLsPrice, data: row, wareSource:row.shopWareLsPriceSource, min:'false'})
								}
								">
                            商城零售价(大)
                        </div>
                        <div data-field="shopWareSmallLsPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallLsPrice, data: row, wareSource:row.shopWareSmallLsPriceSource, min:'true'})
								}
								">
                            商城零售价(小)
                        </div>
                    </div>
                </div>
                <div>
                    <div id="grid1" uglcw-role="grid"
                         uglcw-options="
						    responsive:['.header',80],
							id:'id',
							autoBind: false,
							pageable: true,
                    		url: '${base}manager/shopEndPrice/ygEndPriceByWare',
                    		criteria: '.query',
                    	">
                        <div data-field="name" uglcw-options="width:100">员工名称</div>
                        <div data-field="oper" uglcw-options="width:130,template:function(row){
									return uglcw.util.template($('#oper').html())({data: row, type:'2',name:row.name,isJxc:0})
								}">
                            操作
                        </div>
                        <div data-field="mobile" uglcw-options="width:110">电话</div>
                        <div data-field="gradeName" uglcw-options="width:100">会员等级</div>
                        <div data-field="shopWareLsPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareLsPrice, data: row, wareSource:row.shopWareLsPriceSource, min:'false'})
								}
								">
                            商城零售价(大)
                        </div>
                        <div data-field="shopWareSmallLsPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallLsPrice, data: row, wareSource:row.shopWareSmallLsPriceSource, min:'true'})
								}
								">
                            商城零售价(小)
                        </div>
                    </div>
                </div>
                <div>
                    <div id="grid2" uglcw-role="grid"
                         uglcw-options="
						    responsive:['.header',80],
							id:'id',
							autoBind: false,
							pageable: true,
                    		url: '${base}manager/shopEndPrice/khEndPriceByWare',
                    		criteria: '.query',
                    	">
                        <div data-field="name" uglcw-options="width:150,tooltip:true">客户会员名称</div>
                        <div data-field="oper" uglcw-options="width:130,template:function(row){
									return uglcw.util.template($('#oper').html())({data: row, type:'3',name:row.name,isJxc:1})
								}">
                            操作
                        </div>
                        <div data-field="mobile" uglcw-options="width:110">电话</div>
                        <div data-field="gradeName" uglcw-options="width:100">会员等级</div>
                        <div data-field="customerName" uglcw-options="width:150,tooltip:true">关联客户</div>
                        <div data-field="khClose"
                             uglcw-options="width:130,template: uglcw.util.template($('#khClose').html())">进销存价格关联
                        </div>
                        <div data-field="shopWarePrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWarePrice, data: row, wareSource:row.shopWarePriceSource, min:'false'})
								}
								">
                            商城批发价(大)
                        </div>
                        <div data-field="shopWareLsPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareLsPrice, data: row, wareSource:row.shopWareLsPriceSource, min:'false'})
								}
								">
                            商城零售价(大)
                        </div>
                        <div data-field="shopWareSmallPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallPrice, data: row, wareSource:row.shopWareSmallPriceSource, min:'true'})
								}
								">
                            商城批发价(小)
                        </div>
                        <div data-field="shopWareSmallLsPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallLsPrice, data: row, wareSource:row.shopWareSmallLsPriceSource, min:'true'})
								}
								">
                            商城零售价(小)
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%--线下支付--%>
<script id="isXxzf" type="text/x-uglcw-template">
    # if(data.isXxzf === 0){ #
    不显示
    # }else if(1 === data.isXxzf){ #
    显示
    # } #
</script>
<%--关闭进销存客户--%>
<script id="isJxc" type="text/x-uglcw-template">
    # if(1 == data.isJxc){ #
    是
    # } #
</script>
<%--操作--%>
<script id="oper" type="text/x-uglcw-template">
   <%-- # var gradeId = data.id #
    # if(gradeId == null || gradeId == undefined || gradeId == '' || gradeId == 'undefined'){ #
    # gradeId = '-1'; #
    # } #--%>

   #if(type==3 && !data.name){#
        #type=1;#
        #name=data.gradeName;#
   #}#
    <button onclick="javascript:queryEndPrice(#=type #,#=data.id#,'#=name#',#=isJxc#);" class="k-button k-info">商品最终执行价
    </button>
</script>
<script id="khClose" type="text/x-uglcw-template">
    #if(data.name){#
        # if(1 == data.khClose){ #
            <span title="只走商城价格体系">关闭</span>
        # }else if(0 == data.khClose){ #
            <span title="只走进销存价格体系">开启</span>
        # }else{ #
            <span style="color: red;" title="请进入商城会员信息中进行设置">未设置</span>
        #}#
    #}#
</script>
<script id="price" type="text/x-uglcw-template">
    # if(val!=null && val!=undefined && val!="" && val!="undefined"){ #
    #if('true' == min){ #
    # val = val.toFixed(2) #
    # } #
    # }else{ #
    # val = "" #
    # } #

    # if(wareSource == 1){ #
    <span style="color: orange;">#= val #</span>
    # }else if(wareSource == 2){ #
    <span style="color: \\#333;">#= val #</span>
    # }else if(wareSource == 3){ #
    <span style="color: blue;">#= val #</span>
    # }else if(wareSource == 4){ #
    <span style="color: green;">#= val #</span>
    # }else{ #
    #= val #
    #}#
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {

        uglcw.ui.init();
        uglcw.ui.loaded();
        $('#search').on('click', function(){
            uglcw.ui.get('.uglcw-grid:visible').reload();
        })
        $('#reset').on('click', function(){
            uglcw.ui.clear('.query',{wareId: '', wareNm:''});
            uglcw.ui.get('.uglcw-grid:visible').reload();
        })

    })


    //-----------------------------------------------------------------------------------------

    function showWareSelector() {
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                lazy:false,
                url: '${base}manager/shopWareNewType/shopWaretypesExists',
                model: 'waretype',
                id: 'id',
                expandable: function (node) {
                    return node.id == 0;
                }
            },
            width: 900,
            id: 'wareId',
            pageable: true,
            url: '${base}manager/shopWare/page',
            checkbox: false,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
            columns: [
                {field: 'wareCode', title: '商品编码', width: 120},
                {field: 'wareNm', title: '商品名称', width: 240},
                {field: 'wareDw', title: '大单位', width: 120},
                {field: 'minUnit', title: '小单位', width: 120},

            ],
            yes: function (data) {
                if (data) {
                    var product = data[0];
                    uglcw.ui.bind('.query', {wareId: product.wareId, wareNm: product.wareNm});
                    uglcw.ui.get('.uglcw-grid:visible').reload();
                }
            }
        })
    }

    function queryEndPrice(type,id, name,isJxc) {
        if (type == 1) {
            uglcw.ui.openTab(name + "_商品最终执行价", "manager/shopEndPrice/toShopEndPriceByGrade?_sticky=v2&isJxc="+isJxc+"&gradeId="+id)
        } else {
            uglcw.ui.openTab(name + "_商品最终执行价", "manager/shopEndPrice/toShopEndPriceByShopMember?_sticky=v2&shopMemberId=" + id);
        }
    }


</script>
</body>
</html>
