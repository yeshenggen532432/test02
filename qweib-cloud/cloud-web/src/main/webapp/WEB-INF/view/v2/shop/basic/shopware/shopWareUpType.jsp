<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品展区</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .pic-container {
            display: inline-flex;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">

    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px;">
            <div class="layui-card">
                <div class="layui-card-header">商品分组</div>
                <div class="layui-card-body">
                    <div uglcw-role="tree" id="wareGroupTree"
                         uglcw-options="
							url: 'manager/shopWareGroup/queryGroupTree',
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#groupIds').value(node.id);
								uglcw.ui.get('#wareType').value('');
								uglcw.ui.get('#wareTypeTree').clearSelection();
								uglcw.ui.get('#grid').reload();
                       		}
                    	">
                    </div>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-header">商品分类</div>
                <div class="layui-card-body">
                    <div uglcw-role="tree" id="wareTypeTree"
                         uglcw-options="
							url: '${base}manager/shopWareType/queryShopWaretypesByShopQy',
							expandable:function(node){return node.id == '0'},
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#groupIds').value('');
								uglcw.ui.get('#wareType').value(node.id);
								uglcw.ui.get('#wareGroupTree').clearSelection();
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
                            <input type="hidden" uglcw-model="groupIds" id="groupIds" uglcw-role="textbox">
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
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
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
						    responsive:['.header',40],
							id:'id',
							pageable:{
								pageSize: 20
							},
                    		url: '${base}manager/shopWare/uppage',
                    		criteria: '.form-horizontal',
                    	">
                        <div data-field="wareNm">商品名称</div>
                        <div data-field="wareGg">规格</div>
                        <div data-field="wareDw">单位</div>
                        <div data-field="wareDj">批发价</div>
                        <div data-field="lsPrice">原价</div>
                        <div data-field="shopWarePrice">商城批发价(大)</div>
                        <div data-field="shopWareLsPrice">商城零售价(大)</div>
                        <div data-field="picList" uglcw-options="{template:uglcw.util.template($('#picList').html())}">图片
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script id="picList" type="text/x-kendo-template">
    <div class="uglcw-album">
        <div id="album-list" class="album-list">
            #if(data.warePicList) for(var i = 0;i
            <data.warePicList.length
            ; i++){#
            # var item = data.warePicList[i];#
            <div class="album-item">
                # if(item.type == "1"){ #
                <img src="/upload/#= item.picMini#" style="border: 1px solid red;">
                # }else{ #
                <img src="/upload/#= item.picMini#">
                # } #
                <div class="album-item-cover">
                    <i class="ion-ios-eye" onclick="preview(this, #= i#)"></i>
                </div>
            </div>
            #}#
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })


    //----------------------------------------------------------------------------------------------------------------
    //放大图片
    function preview(i, index) {
        var grid = uglcw.ui.get('#grid');
        var row = grid.k().dataItem($(i).closest('tr'));
        layer.photos({
            photos: {
                start: index, data: $.map(row.warePicList, function (item) {
                    return {
                        src: '/upload/' + item.pic,
                        pid: item.id,
                        alt: item.pic,
                        thumb: '/upload/' + item.picMini
                    }
                })
            }, anim: 5
        });
    }
</script>
</body>
</html>
