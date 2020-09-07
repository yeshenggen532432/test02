<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <%@include file="/WEB-INF/view/v2/include/edit-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .uglcw-grid .k-grid-content .k-combobox .k-icon.k-i-close {
            right: 16px !important;
        }

        .uglcw-grid .k-grid-content .k-combobox .k-select {
            width: 16px !important;
        }

        .uglcw-grid .k-grid-content .k-combobox .k-input {
            padding-right: 5px;
        }

        .uglcw-grid .k-grid-content .k-combobox .k-dropdown-wrap {
            padding-right: 20px;
        }
        .layui-layer.layui-layer-page.layui-layer-photos{
            background: transparent;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 220px">
            <div uglcw-role="resizable" uglcw-options="responsive:[50]">
                <%--上架分类开始--%>
                <div class="layui-card">
                    <%--<div class="layui-card-header" style="font-size: 15px;font-weight: bold;">商品上架管理</div>--%>
                    <div class="layui-card-body">
                        <button onclick="javascript:getWareTypeTree(-1);" class="k-info k-button k-primary"
                                style="width:80px">按分类上架
                        </button>
                        <button onclick="javascript:getWareTypeTree(1);" class="k-info k-button k-primary"
                                style="width:80px">按分类下架
                        </button>
                    </div>
                    <div class="layui-card-body">
                        <div uglcw-role="tree" id="wareTypeTree"
                             uglcw-options="
                            lazy: false,
							url: '${base}manager/shopWareNewType/shopWaretypesExists',
							expandable:function(node){
								return node.id == '0';
							},
							loadFilter:function(response){
							$(response).each(function(index,item){
							if(item.text=='根节点'){
							item.text='所有上架商品'
							}
							})
							return response;
							},
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#groupIds').value('');
								uglcw.ui.get('#waretype').value(node.id);
								uglcw.ui.get('#wareGroupTree').clearSelection();
								uglcw.ui.get('#grid').reload();
								uglcw.ui.get('#grid').hideColumn('groupSort');
								uglcw.ui.get('#grid').showColumn('shopSort');
								g_groupIds='';
								$('#addWareToGroup').addClass('hide');
								$('#batchAddWareToGroup').removeClass('hide');
                       		}
                    	">
                        </div>
                    </div>
                </div>
                <%--上架分类结束--%>
                <%--分组开始--%>
                <div class="layui-card">
                    <div class="layui-card-header" style="font-size: 15px;">首页分组
                        <button onclick="toShopWareGroup();" class="k-info k-button k-primary">增加</button>
                    </div>
                    <%--<div class="layui-card-body">
                        <button onclick="toShopWareGroup();" class="k-info k-button k-primary">增加</button>
                        <button onclick="reloadShopWareGroup();" class="k-info k-button k-primary">刷新</button>
                    </div>--%>
                    <div class="layui-card-body">
                        <div uglcw-role="tree" id="wareGroupTree"
                             uglcw-options="
							url: 'manager/shopWareGroup/queryGroupTree',
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#groupIds').value(node.id);
								uglcw.ui.get('#waretype').value('');
								uglcw.ui.get('#wareTypeTree').clearSelection();
								uglcw.ui.get('#grid').reload();
								uglcw.ui.get('#grid').hideColumn('shopSort');
								uglcw.ui.get('#grid').showColumn('groupSort');
								g_groupIds=node.id;
								$('#addWareToGroup').removeClass('hide');
								$('#batchAddWareToGroup').addClass('hide');
                       		}
                    	">
                        </div>
                    </div>
                </div>
                <%--分组线束--%>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="waretype" id="waretype" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="groupIds" id="groupIds" uglcw-role="textbox">
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox" id="searchPutOn" uglcw-model="putOn" placeholder="上架状态"
                                    uglcw-options="value:1">
                                <option value="10">全部</option>
                                <option value="0">未上架</option>
                                <option value="1">已上架</option>
                            </select>
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                        <li>
                            <input type="checkbox" uglcw-role="checkbox" id="showAllProducts" uglcw-model="showAllProducts">
                            <label style="margin-top: 7px" class="k-checkbox-label"
                                   for="showAllProducts">加载所有进销存商品</label>
                        </li>
                    </ul>
                </div>
            </div>
            <%--表格：头部end--%>

            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid" class="uglcw-grid-compact"
                         uglcw-options="
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							responsive: ['.header', 40],
							checkbox:true,
							pageable: true,
							autoMove: false,
							editable: true,
							autoAppendRow: false,
                    		url: '${base}manager/shopWare/page?loadStock=1&showGroup=1&showPic=1',
                    		criteria: '.form-horizontal',
                    		dataBound: function(){
                    		    uglcw.ui.init('#grid .k-grid-content');
                    		},
                    		loadFilter:{
                    		    data: function(response){
                    		        var rows = [];
                                    if(response.rows && response.rows.length > 0){
                                        rows = $.map(response.rows, function(row){
                                            row.shopWareStock = row.shopWareStock || {
                                                maxOpen: 0,
                                                maxStorage: '',
                                                minStorage:'',
                                                storageType:1
                                            }
                                            row.maxStorage = row.shopWareStock.maxStorage ==null?'':row.shopWareStock.maxStorage;
                                            row.minStorage = row.shopWareStock.minStorage;
                                            row.maxOpen = row.shopWareStock.maxOpen;
                                            row.storageType=row.shopWareStock.storageType;//库存类型0进销存控制,1商城独自控制

                                            if(row.maxStorage+'' !=''){console.log(row.maxStorage)
                                                var minStorage=row.maxStorage*row.hsNum;
                                                if(minStorage && minStorage%1!=0){
                                                    minStorage=minStorage.toFixed(2);
                                                 }
                                                row.minStorage =minStorage;
                                            }

                                            //row.minStorage = row.shopWareStock.minStorage;
                                            //row.minOpen = row.shopWareStock.minOpen;
                                            <%--大小单位格式化--%>
                                            row.defWareGg=row.wareGg;
                                            row.defWareDw=row.wareDw;
                                            if(row.shopWarePriceDefault&&row.shopWarePriceDefault==1){
                                                row.defWareGg=row.minWareGg;
                                                row.defWareDw=row.minUnit;
                                            }
                                            return row;
                                        })
                                    }

                    		        return rows;
                    		    }
                    		}

                    	">
                        <div data-field="groupSort" uglcw-options="
								width:80,hidden:true,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '分组排序',field:'groupSort'}),
								template:function(row){
									return uglcw.util.template($('#data_edit_template').html())({value:row.groupSort, id:row.wareId, field:'groupSort',callback:'changeSort'})
								}
								">
                        </div>
                        <div data-field="shopSort" uglcw-options="
								width:60,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '排序',field:'shopSort'}),
								template:function(row){
									return uglcw.util.template($('#data_edit_template').html())({value:row.shopSort, id:row.wareId, field:'shopSort',callback:'changeSort'})
								}
								">
                        </div>
                        <!--<div data-field="op-poster" uglcw-options="width: 70,
                                template:uglcw.util.template($('#poster_template').html())
                        "

                        >海报预览
                        </div>-->
                        <div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
                        <div data-field="wareNm"
                             uglcw-options="width:130,locked: true, tooltip: true,template:uglcw.util.template($('#wareNmTempl').html())">
                            商品名称
                        </div>
                        <div data-field="shopWareAlias" uglcw-options="
								width:130,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '商城别称',field:'shopWareAlias'}),
								template:function(row){
									return uglcw.util.template($('#data_edit_template').html())({value:row.shopWareAlias, id:row.wareId, field:'shopWareAlias',callback:'changeWare'})
								}
								">
                        </div>
                        <div data-field="defWareGg"
                             uglcw-options="width:80,template:function(row){return '<span id=\'defWareGg_span_'+row.wareId+'\'>'+row.defWareGg+'</span>'}">
                            规格
                        </div>
                        <div data-field="defWareDw"
                             uglcw-options="width:60,template:function(row){return '<span id=\'defWareDw_span_'+row.wareId+'\'>'+row.defWareDw+'</span>'}">
                            单位
                        </div>
                        <div data-field="shopWarePriceDefault" uglcw-options="
                            width:80,
                            headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '默认单位',field:'shopWarePriceDefault'}),
                            template:function(row){
                                 if(!row.minUnit && !row.minWareGg){
                                    return '大单位';
                                 }
                                var options=[{ text: '小单位', value: 1 },{ text: '大单位', value: 0}];
                                 var dataSource={wareGg:row.wareGg,wareDw:row.wareDw,minUnit:row.minUnit,minWareGg:row.minWareGg};
                                return uglcw.util.template($('#data_select_template').html())({value:row.shopWarePriceDefault||0, id:row.wareId, field:'shopWarePriceDefault',dataSource:dataSource,options:options,callback:'chageShopWarePriceDefault'})
                            }
                        ">
                        </div>
                        <div data-field="putOn" uglcw-options="
                            width:80,
                            headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '上架状态',field:'putOn'}),
                            template:function(row){
                                 var options=[{ text: '上架', value: 1 },{ text: '下架', value: 0}];
                                return uglcw.util.template($('#data_select_template').html())({value:row.putOn||0, id:row.wareId, field:'putOn',
                                options:options,callback:'chageWarePutOn'})
                            }
                            ">
                        </div>
                        <div data-field="wareResume" uglcw-options="
								width:130,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '商品简述',field:'wareResume'}),
								template:function(row){
									return uglcw.util.template($('#data_edit_template').html())({value:row.wareResume, id:row.wareId, field:'wareResume',callback:'changeWare'})
								}
								">
                        </div>
                        <div data-field="wareDesc"
                             uglcw-options="width:80, template: uglcw.util.template($('#wareDescTempl').html())">商品描述
                        </div>
                        <div data-field="maxOpen" uglcw-options="
								width:80,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '库存开关',field:'maxOpen'}),
								template:function(row){
								    var options=[{ text: '开启', value: 1 },{ text: '关闭', value: 0}];
								    var dataSource={bUnit:row.bUnit};
									return uglcw.util.template($('#data_select_template').html())({value:row.maxOpen, id:row.wareId, field:'maxOpen',
                                    dataSource:dataSource,options:options,callback:'chageWareStockOpen'})
								}
								">
                        </div>

                        <div data-field="storageType" uglcw-options="
								width:100,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '库存类型',field:'storageType'}),
								template:function(row){
								    var options=[{ text: '商城独自库存', value: 1 },{ text: '进销存库存', value: 0}];
									return uglcw.util.template($('#data_select_template').html())({value:row.storageType , id:row.wareId, field:'storageType',
                                    options:options,callback:'chageStorageType'})
								}
								">
                        </div>
                        <div data-field="maxStorage" uglcw-options="
								width:90,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '库存量(大)',field:'maxStorage'}),
								template:function(row){
								    var dataSource={bUnit:row.bUnit,hsNum:row.hsNum};
									return uglcw.util.template($('#data_edit_template').html())({value:row.maxStorage, id:row.wareId, field:'maxStorage',dataSource:dataSource,callback:'chageWareStockStorage'})
								}
								">
                        </div>
                        <div data-field="minStorage" uglcw-options="
								width:90,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '库存量(小)',field:'minStorage'}),
								template:function(row){
								    var dataSource={bUnit:row.bUnit,hsNum:row.hsNum};
									return uglcw.util.template($('#data_edit_template').html())({value:row.minStorage, id:row.wareId, field:'minStorage',dataSource:dataSource,callback:'chageWareStockStorage'})
								}
								">
                        </div>
                        <div data-field="groupNms" uglcw-options="align:'left',width:130">商品分组</div>
                        <div data-field="picList"
                             uglcw-options="align:'left', width:300,template:uglcw.util.template($('#picList').html())">图片
                        </div>
                        <div data-field="wareDj" uglcw-options="width:80">批发价(进)</div>
                        <div data-field="lsPrice" uglcw-options="width:80">原价(进)</div>
                        <div data-field="shopWarePrice" uglcw-options="width:100">商城批发价(大)</div>
                        <div data-field="shopWareLsPrice" uglcw-options="width:100">商城零售价(大)</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="poster_template">
    <a style="cursor: pointer;color: \\#38f;" href="javascript:showPoster(#= data.wareId#);">预览</a>
</script>
<script type="text/x-kendo-template" id="toolbar">
    <a id="addWareToGroup" role="button" href="javascript:addWareToGroupWindow();"
       class="k-button k-button-icontext hide">
        <span class="k-icon k-i-track-changes-accept"></span>添加商品到当前分组
    </a>
    <a role="button" href="javascript:add()" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus"></span>新增商品
    </a>
    <a role="button" href="javascript:update();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>修改商品
    </a>
    <a role="button" href="javascript:setPutOn(1);" class="k-button k-button-icontext">
        <span class="k-icon k-i-sort-asc-sm"></span>上架
    </a>
    <a role="button" href="javascript:setPutOn(0);" class="k-button k-button-icontext">
        <span class="k-icon k-i-sort-desc-sm"></span>下架
    </a>
    <a id="batchAddWareToGroup" role="button" href="javascript:setGroup();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>设置分组
    </a>
    <a role="button" href="javascript:setShopWarePriceDefault();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>批量大小单位更改
    </a>
    <a role="button" href="javascript:setShopWareStock();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>批量操作库存状态
    </a>
</script>

<%--商品名称--%>
<script id="wareNmTempl" type="text/x-uglcw-template">
    <button onclick="javascript:toupdateware(#= data.wareId#,'#= data.wareNm#');"
            class="k-button k-info">#=wareNm#
    </button>
</script>

<%--商品别名--%>
<script id="shopWareAliasTempl" type="text/x-uglcw-template">
    #if(data.shopWareAlias){#
    <div style="overflow:hidden;text-overflow: ellipsis" class="k-textbox">#=data.shopWareAlias#</div>
    #}#
</script>

<%--大小单位颜色区分--%>
<script id="shopWarePriceDefaultTempl" type="text/x-uglcw-template">
    #if(data.shopWarePriceDefault && data.shopWarePriceDefault==1){#
    <span class="k-button">小单位</span>
    #}else{#
    #if(data.minUnit || data.minWareGg){#
    <span class="k-button">大单位</span>
    #}else{#
    大单位
    #}#
    #}#
    <%--#if(data.shopWarePriceDefault && data.shopWarePriceDefault==1){#
        <span style="color:red;">小单位</span>
    #}else if(data.minUnit || data.minWareGg){#
        <span class="k-button">大单位</span>
    #}else{#
        大单位
    #}#--%>
</script>

<%--上下架模版--%>
<script id="putOnTempl" type="text/x-uglcw-template">
    #var text=data.putOn == 1?'已上架':'未上架'#
    <span class="k-button">#=text#</span>
</script>
<%--上下架模版--%>
<script id="storageTypeTempl" type="text/x-uglcw-template">
    #= data.storageType==1?'商城独自库存':'<span class="k-button" style="color: red">进销存库存</span>'#
</script>


<%--商品描述--%>
<script id="wareDescTempl" type="text/x-uglcw-template">
    # if(data.wareDesc==null || data.wareDesc==undefined || data.wareDesc==''){ #
    <button onclick="javascript:toupdateware(#= data.wareId#,'#= data.wareNm#');" style="color: red"
            class="k-button k-info">请设置
    </button>
    # }else{ #
    已描述
    # } #
</script>

<%--设置商品分组--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-xs-6">首页分组</label>
                    <div class="col-xs-16">
                        <input uglcw-role="multiselect" uglcw-model="multiselect" id="multiselect"
                               uglcw-options="
										url: '${base}manager/shopWareGroup/list',
										dataTextField: 'name',
										dataValueField: 'id'
										"
                        />
                    </div>
                </div>

            </form>
        </div>
    </div>
</script>

<%--设置商品大小单位修改--%>
<script type="text/x-uglcw-template" id="priceDefault_form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-xs-6">单位切换</label>
                    <div class="col-xs-16">
                        <input uglcw-role="combobox" id="priceDefault"
                               uglcw-options="dataSource:[
                              { text: '小单位', value: 1 },
                              { text: '大单位', value: 0}
                              ]"
                        />
                    </div>
                </div>

            </form>
        </div>
    </div>
</script>

<%--设置商品库存修改--%>
<script type="text/x-uglcw-template" id="stockDefault_form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-xs-4">库存开关</label>
                    <div class="col-xs-6">
                        <input uglcw-role="combobox" id="maxOpenDefault" title="大单位换算比例不为1商品,将无法开启库存功能"
                               uglcw-options="dataSource:[{ text: '开启', value: 1 },{ text: '关闭', value: 0}]"
                        />
                    </div>
                    <label class="control-label col-xs-4">库存类型</label>
                    <div class="col-xs-8">
                        <input uglcw-role="combobox" id="storageTypeDefault"
                               uglcw-options="dataSource:[{ text: '商城独自库存', value: 1 },{ text: '进销存库存', value: 0}]"
                        />
                    </div>
                </div>

            </form>
        </div>
    </div>
</script>

<script id="picList" type="text/x-uglcw-template">
    <div class="uglcw-album">
        <div id="album-list" class="album-list">
            #if(data.warePicList)for(var i = 0;i
            <data.warePicList.length
                    ; i++){#
                    # var item=data.warePicList[i];#
            <div class="album-item">
                # if(item.type != "1"){ #
                <img src="/upload/#= item.picMini#" style="border: 1px solid red;">
                # }else{ #
                <img src="/upload/#= item.picMini#">
                # } #
                <%-- <div class="album-item-cover">
                     <i class="ion-ios-eye" onclick="preview(this, #= i#)"></i>
                     <i class="ion-ios-photos" onclick="setAsPrimary(this, #= i#)"></i>
                 </div>--%>
                <div class="album-item-cover" ondblclick="preview(this, #= i#)">
                    <a href="javascript:;" style="color:white" onclick="setAsPrimary(this, #= i#)">设为主图</a>
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
        uglcw.layout.init();
        //查询
        uglcw.ui.get('#search').on('click', function () {
            var searchPutOn = uglcw.ui.get('#searchPutOn').value();
            if (searchPutOn == '')
                uglcw.ui.get('#searchPutOn').value(10);
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.get('#showAllProducts').on('click', function () {
            uglcw.ui.get("#searchPutOn").value('')
            uglcw.ui.get('#grid').reload();
        });

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#grid').on('dataBound', function () {
            this.autoFitColumn('picList');
        })
        uglcw.ui.loaded();
        uglcw.io.on('listen_wareGroupChange', function (data) {
            reloadShopWareGroup()
        })
        uglcw.io.on('listen_wareChange', function (data) {debugger
            uglcw.ui.get('#grid').reload();
        })
    })

    //---------------------------------------------------------------------------------------------------------------

    //商品上架，下架
    function setPutOn(putOn) {
        var ids = "";
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            $(selection).each(function (idx, item) {
                if (ids != "") {
                    ids += "," + item.wareId;
                } else {
                    ids = item.wareId;
                }
            })
            var tipMsg;
            if ('0' == putOn) {
                tipMsg = '确认要下架选中的商品吗？'
            } else if ('1' == putOn) {
                tipMsg = '确认要上架选中的商品吗？'
            }
            uglcw.ui.confirm(tipMsg, function () {
                chageWarePutOn(putOn + '', null, ids, null);
            })
        }
    }

    //商品上架，下架
    function chageWarePutOn(value, field, id, dataSource) {
        if (!value) {
            uglcw.ui.error("请选择！")
            return false;
        }
        $.ajax({
            url: '${base}manager/shopWare/updateBatchPutOnWare',
            data: {
                ids: id,
                putOn: value
            },
            type: 'post',
            dataType: 'json',
            success: function (response) {
                if (response != "-1") {
                    uglcw.ui.success("操作成功");
                    //如果搜索的是进销存商品时,上架商品同时刷新分类列表
                    var showAllProducts = uglcw.ui.get("#showAllProducts").value();
                    if (value && value == '1' && showAllProducts)
                        uglcw.ui.get("#wareTypeTree").reload();
                    if (dataSource) {
                        var model = JSON.parse(decodeURI(dataSource));
                        callSuccessFun(model.optionText, 'putOn', id);
                    } else {
                        uglcw.ui.get('#grid').k().dataSource.read();
                    }
                } else {
                    uglcw.ui.error("操作失败");
                }
            }
        })
    }


    //设置商品分组
    function setGroup() {
        var ids = "";
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            $(selection).each(function (idx, item) {
                if (ids != "") {
                    ids += "," + item.wareId;
                } else {
                    ids = item.wareId;
                }
            })
        } else {
            uglcw.ui.toast("请勾选您要操作的行！")
            return;
        }
        uglcw.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var groupNms = "";
                var groupIds = uglcw.ui.get("#multiselect").value();
                var dataItems = uglcw.ui.get('#multiselect').dataItems();
                for (var i = 0; i < dataItems.length; i++) {
                    var id = dataItems[i].id;
                    var groupNm = dataItems[i].name;
                    for (var j = 0; j < groupIds.length; j++) {
                        var groupId = groupIds[j];
                        if (id == groupId) {
                            if (groupNms == "") {
                                groupNms = groupNm;
                            } else {
                                groupNms += "," + groupNm;
                            }
                            break;
                        }
                    }
                }
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/shopGroupWare/batchUpdateWareGroup',
                    data: {
                        ids: ids,
                        groupIds: groupIds,
                        groupNms: groupNms,
                    },
                    type: 'post',
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '2') {
                            uglcw.ui.success('修改成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })
    }

    function add() {
        uglcw.ui.openTab('新增商品', '${base}manager/tooperware?click_flag=3&sourceShop=1&wtype='+(uglcw.ui.get('#waretype').value()||''));
    }
    //修改
    function update() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var row = selection[0];
            toupdateware(row.wareId, row.wareNm);
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }

    }

    //修改商品
    function toupdateware(wareId, wareNm) {
        uglcw.ui.openTab(wareNm + "_修改", "${base}manager/shopWare/toUpdateWare?_sticky=v2&Id=" + wareId);
    }

    //-------------------------------订阅：start--------------------------------------------
    uglcw.io.on('refershShopWare', function (data) {
        if (data == 'success') {
            uglcw.ui.get('#grid').reload();
        }
    })

    //-------------------------------订阅：end---------------------------------------------
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

    //设置主图
    function setAsPrimary(i, index) {
        var grid = uglcw.ui.get('#grid');
        var row = grid.k().dataItem($(i).closest('tr'));
        uglcw.ui.confirm('确定设置主图吗？', function () {
            $.ajax({
                url: "${base}manager/shopWare/updateWareMainPic",
                data: "wareId=" + row.wareId + "&picId=" + row.warePicList[index].id,
                type: "post",
                success: function (json) {
                    if (json != "-1") {
                        uglcw.ui.success('设置主图成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('设置主图失败');
                        return;
                    }
                }
            });
        })
    }

    //分组ID
    var g_groupIds = "";

    //分组改变事件
    function changeSort(value, field, wareId) {
        if (value && isNaN(value)) {
            uglcw.ui.error("请输入正整数");
            return false;
        }
        var url = "/manager/shopWare/updateSort";
        if (field == 'groupSort')
            url = "/manager/shopGroupWare/updateSort";
        $.ajax({
            url: url,
            type: "post",
            data: "groupIds=" + g_groupIds + "&wareId=" + wareId + "&sort=" + value,
            success: function (data) {
                if (data == 1) {
                    uglcw.ui.success("操作成功");
                    //model.set(field, value);
                    //model.set('dirty', false)
                    callSuccessFun(value, field, wareId);
                } else {
                    uglcw.ui.error("操作失败");
                    return;
                }
            }
        });
    }


    //打开分组管理
    function toShopWareGroup() {
        uglcw.ui.openTab("商城商品分组", "${base}manager/shopWareGroup/toPage?_sticky=v2");
    }

    /**
     * 重新载入分组
     */
    function reloadShopWareGroup() {
        uglcw.ui.get("#wareGroupTree").reload();
    }


    //商品分类操作
    //-------------------------------------------------------------------------------------------
    function getWareTypeTree(shopQy) {
        var btns = ['上架', '取消'];
        if (shopQy == 1)
            btns = ['下架', '取消'];
        uglcw.ui.Modal.showTreeSelector({
            btns: btns,
            lazy: false,
            expandable: function (node) {
                if (node.id == 0) {
                    return true;
                }
                if (node.checked || node.halfChecked) {
                    return true;
                }
                // return false
                return false;
            },
            area: ['300px', '500px'],
            url: '${base}manager/shopWareNewType/shopWaretypesAll?shopQy=' + shopQy,
            loadFilter: function (wareTypes) {
                allCheckWareTypeIds = [];
                var rootText = '';
                if (shopQy == -1) {
                    rootText = '未上架商品分类';
                } else {
                    rootText = '已上架商品分类';
                    removeCheckFlag(wareTypes);//已上架分类时记录所有
                }
                if (wareTypes && wareTypes.length > 0) {
                    if (wareTypes[0].id == 0) {
                        wareTypes[0].text = rootText;
                    }
                }
                return wareTypes;
            }, yes: function (checkNodes, nodes, smooth) {
                var cIds = [];
                var bIds = [];
                $.map(checkNodes, function (item) {
                    if (item.checked && item.id) {//全选
                        cIds.push(item.id);
                    } else if (item.halfChecked && item.id) {//半选
                        bIds.push(item.id);
                    }
                })
                return saveMenu(cIds, bIds, shopQy);
            }
        })
    }

    function removeCheckFlag(wareTypes) {
        $(wareTypes).each(function (i, item) {
            item.checked = false;
            item.halfChecked = false;
            if (item.children && item.children.length > 0)
                removeCheckFlag(item.children);
        })
    }

    //保存
    function saveMenu(cIds, Iids, shopQy) {
        var cStr;//全选id
        var bStr;//部分选中
        if (cIds != null && cIds != undefined && cIds != '') {
            cStr = cIds.join(',');
        }
        if (Iids != null && Iids != undefined && Iids != '') {
            bStr = Iids.join(',');
        }
        if (shopQy == 1) {
            uglcw.ui.confirm("下架分类将同时下架商品!", function () {
                updateWaretypeShopQY(cStr, bStr, shopQy);
            });
        } else {
            if (!cStr && !bStr) {
                uglcw.ui.error('未改变');
                return true;
            }
            updateWaretypeShopQY(cStr, bStr, shopQy);
        }
    }

    function updateWaretypeShopQY(cStr, bStr, shopQy) {
        var url = "${base}manager/shopWareNewType/updateWaretypeShopQYOn";
        if (shopQy == 1)
            url = "${base}manager/shopWareNewType/updateWaretypeShopQYOff";
        $.ajax({
            url: url,
            type: "post",
            data: {
                cIds: cStr,
                iIds: bStr
            },
            success: function (response) {
                if (response == '1') {
                    uglcw.ui.success('修改成功');
                    window.location.reload()//刷新当前页面.
                    //uglcw.ui.get("#wareTypeTree").reload();
                    //uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error('修改失败');
                }
            }
        });
    }

    //设置商品大小单位
    function setShopWarePriceDefault() {
        var ids = "";
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            $(selection).each(function (idx, item) {
                if (ids != "") {
                    ids += "," + item.wareId;
                } else {
                    ids = item.wareId;
                }
            })
        } else {
            uglcw.ui.toast("请勾选您要操作的行！")
            return;
        }
        uglcw.ui.Modal.open({
            content: $('#priceDefault_form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var priceDefault = uglcw.ui.get('#priceDefault').value();

                chageShopWarePriceDefault(priceDefault, null, ids, null);
                return false;
            }
        })
    }

    //库存操作
    function setShopWareStock() {
        var ids = "";
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection) {
            uglcw.ui.toast("请勾选您要操作的行！")
            return;
        }
        uglcw.ui.Modal.open({
            content: $('#stockDefault_form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var maxOpenDefault = uglcw.ui.get('#maxOpenDefault').value();
                var storageTypeDefault = uglcw.ui.get('#storageTypeDefault').value();
                var data = {};
                if (maxOpenDefault != '')
                    data.maxOpen = maxOpenDefault;
                if (storageTypeDefault != '')
                    data.storageType = storageTypeDefault;
                if (!maxOpenDefault && !storageTypeDefault) {
                    uglcw.ui.toast("请选择！")
                    return false;
                }
                uglcw.ui.success('操作已提交后台处理');
                $(selection).each(function (idx, item) {
                    if (maxOpenDefault && maxOpenDefault == 1 && item.bUnit != 1) return;
                    data.wareId = item.wareId;
                    updateWareStock(data);
                })
                //location.href=location.href;
                uglcw.ui.get('#grid').k().dataSource.read();
                return true;
            }
        })
    }

    //修改大小单位默认
    function chageShopWarePriceDefault(value, field, id, dataSource) {
        if (!value) {
            uglcw.ui.error("请选择");
            return false;
        }
        var model = null;
        if (dataSource)
            model = JSON.parse(decodeURI(dataSource));
        if (model && value == 1 && !model.minUnit && !model.minWareGg) {
            uglcw.ui.error("小单位名称规格未设置");
            return false;
        }
        $.ajax({
            url: '${base}manager/shopWare/updateShopWarePriceDefault',
            data: {
                wareIds: id,
                shopWarePriceDefault: value
            },
            type: 'post',
            dataType: 'json',
            success: function (data) {
                if (data.state) {
                    uglcw.ui.success(data.message);
                    if (model) {
                        //model.set('shopWarePriceDefault', value);
                        // model.set('dirty', false);
                        var defWareGg = model.minWareGg;
                        var defWareDw = model.minUnit;
                        if (value == 0) {
                            defWareGg = model.wareGg;
                            defWareDw = model.wareDw;
                        }
                        /*model.set('defWareGg', defWareGg);
                        model.set('defWareDw', defWareDw);
                        model.set('dirty', false);*/
                        $('#defWareGg_span_' + id).text(defWareGg);
                        $('#defWareDw_span_' + id).text(defWareDw);
                        callSuccessFun(model.optionText, 'shopWarePriceDefault', id);
                    } else {
                        uglcw.ui.get('#grid').k().dataSource.read();
                    }
                    /*setTimeout(function () {
                        model.set('dirty', false);
                    }, 200)*/
                } else {
                    uglcw.ui.error(data.message);
                }
                uglcw.ui.Modal.close();
            }
        })
    }

    //修改库存库存量
    function chageWareStockStorage(value, field, wareId, dataSource) {

        /*console.log(model.bUnit)
        console.log(model.sUnit)
        console.log(model.hsNum)//换算数量(包装单位到单品单位的转换系数),大单位*换算系统=小单位*/
        var model = JSON.parse(decodeURI(dataSource));
        if (model.bUnit && model.bUnit != 1) {
            uglcw.ui.error("换算比例大单位必须为1，请重新编辑商品换算比例");
            return false;
        }
        if (value == '') {
            uglcw.ui.error("不能为空");
            return false;
        }
        var minStorage = 0, maxStorage = 0;
        if (field == 'maxStorage') {
            minStorage = value * model.hsNum;
            maxStorage = value;
            if (minStorage % 1 != 0)
                minStorage = minStorage.toFixed(2)
        } else {
            maxStorage = value / model.hsNum;
            minStorage = value;
            if (maxStorage % 1 != 0)
                maxStorage = maxStorage.toFixed(2);
        }
        var data = {
            "wareId": wareId,
            "maxStorage": maxStorage
        };
        updateWareStock(data, function (state) {
            if (state) {
                //model.set("maxStorage", maxStorage);
                //model.set("minStorage", minStorage);
                //model.set('dirty', false);
                //callSuccessFun(value,field,id);
                $("#maxStorage_span_" + wareId).text(maxStorage);
                $("#minStorage_span_" + wareId).text(minStorage);
                $("#maxStorage_input_" + wareId).val(maxStorage);
                $("#minStorage_input_" + wareId).val(minStorage);
            }
        });
    }

    //修改库存状态
    function chageWareStockOpen(value, field, wareId, dataSource) {
        var model = JSON.parse(decodeURI(dataSource));
        if (!value) {
            uglcw.ui.error("请选择");
            return false;
        }
        var data = {
            "wareId": wareId,
            "maxOpen": value
        };
        model.maxOpen = value;
        if (model.maxOpen == 1 && model.bUnit && model.bUnit != 1) {
            uglcw.ui.error("换算比例大单位必须为1，请重新编辑商品换算比例");
            return false;
        }
        updateWareStock(data, function (state) {
            if (state) {
                callSuccessFun(model.optionText, field, wareId);
                //model.set(field, value);
                //model.set('dirty', false);
            }
        });
    }

    //修改库存类型
    function chageStorageType(value, field, wareId, dataSource) {
        if (!value) {
            uglcw.ui.error("请选择");
            return false;
        }
        var model = JSON.parse(decodeURI(dataSource));
        var data = {
            "wareId": wareId,
            "storageType": value
        };
        updateWareStock(data, function (state) {
            if (state) {
                callSuccessFun(model.optionText, field, wareId);
                //model.set(field, value);
                //model.set('dirty', false);
            }
        });
    }

    function updateWareStock(data, fun) {
        if (!data.wareId) {
            uglcw.ui.error("商品ID不能为空");
            return false;
        }
        $.ajax({
            url: '${base}manager/shopWareStock/update',
            data: data,
            type: 'post',
            dataType: 'json',
            success: function (data) {
                if (fun)
                    fun(data.state);
                if (data.state) {
                    if (fun)
                        uglcw.ui.success(data.message);
                } else {
                    uglcw.ui.error(data.message);
                }
            }
        })
    }

    //原已存在分组商品数据
    var g_groupWareIdArray = [];

    //选择商品加入到分组
    function addWareToGroupWindow() {
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                url: '${base}manager/shopWareNewType/shopWaretypesExists',
                lazy: false,
                model: 'waretype',
                id: 'id',
                expandable: function (node) {
                    return node.id == 0;
                }
            },
            title: "选择商品",
            width: 900,
            id: 'wareId',
            pageable: true,
            url: '${base}manager/shopWare/page?showGroup=1',
            query: function (params) {
                //params.stkId = uglcw.ui.get('#stkId').value()
            },
            checkbox: true,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
            columns: [
                {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
                {field: 'wareNm', title: '商品名称', width: 250},
                {field: 'groupNms', title: '已加入分组', width: 220}
            ],
            success: function (c, tree, grid) {
                grid.on('dataBound', function () {//默认选中已存在
                    g_groupWareIdArray = [];
                    $(grid.k().dataSource.data()).each(function (i, row) {
                        if (row.groupIds) {
                            if (row.groupIds.indexOf("," + g_groupIds + ",") != -1) {
                                g_groupWareIdArray.push(row.wareId);
                                var rowObj = $(c).find('.uglcw-grid tr[data-uid=' + row.uid + ']');
                                grid.k().select(rowObj);
                            }
                        }

                    })
                });
                grid.on('change', function (e) {
                    console.log(e.sender.select());
                })
            },
            yes: addWareToGroup
        })
    }

    //选择商品加入到分组
    function addWareToGroup(data) {
        //当前所有勾选
        var idsArray = [];
        $(data).each(function (i, item) {
            idsArray.push(item.wareId);
        })

        //查找新加入的商品
        var g_newGroupWareIdArray = [];
        $(idsArray).each(function (j, item) {
            var exists = false;
            $(g_groupWareIdArray).each(function (i, g_item) {
                if (g_item == item) {
                    exists = true;
                    return;
                }
            });
            if (!exists) {
                g_newGroupWareIdArray.push(item);
            }
        })

        //查找被移出分组的商品
        var g_unGroupWareIdArray = [];
        g_unGroupWareIdArray.push(0)
        $(g_groupWareIdArray).each(function (i, g_item) {
            var exists = false;
            $(idsArray).each(function (j, item) {
                if (g_item == item) {
                    exists = true;
                    return;
                }
            })
            if (!exists) {
                g_unGroupWareIdArray.push(g_item);
            }
        })

        if (g_newGroupWareIdArray && g_newGroupWareIdArray.length == 0 && g_unGroupWareIdArray && g_unGroupWareIdArray.length == 0) {
            uglcw.ui.error('未发生改变，无须提交！');
            return false;
        }

        //uglcw.ui.confirm("是否确认加入",function(){
        $.ajax({
            url: '${base}manager/shopGroupWare/batchUpdateWareGroup',
            data: {
                ids: g_newGroupWareIdArray.join(","),
                groupIds: g_groupIds,
                unWareIds: g_unGroupWareIdArray.join(","),
            },
            type: "post",
            success: function (resp) {
                if (resp === '2') {
                    uglcw.ui.success('操作成功');
                    //uglcw.ui.get($('.uglcw-selector-container .uglcw-grid')).reload()
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error('操作失败！');
                }
                return false;
            }
        });
        //});
    }

    function changeWare(value, field, id) {
        $.ajax({
            url: "manager/shopWare/updateShopWare",
            type: "post",
            data: "id=" + id + "&text=" + value + "&field=" + field,
            success: function (data) {
                if (data == '1') {
                    uglcw.ui.success('操作成功');
                    //$("#" + field + "_span_" + wareId).text(o.value);
                    //model.set(field, value);
                    //model.set('dirty', false);
                    callSuccessFun(value, field, id);
                } else {
                    uglcw.ui.toast("保存失败");
                }
            }
        });
    }

    function showPoster(id) {
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/poster/product',
            contentType: 'application/json',
            type: 'post',
            data: JSON.stringify({
                productId: id,
                context: {}
            }),
            success: function (response) {
                uglcw.ui.loaded()
                if (response.success) {
                    layer.photos({
                        photos: {
                            start: 0, data: [
                                {
                                    src: '/upload/' + response.data,
                                    thumb: '/upload/' + response.data
                                }
                            ]
                        }, anim: 5
                    });
                } else {
                    uglcw.ui.error(response.message)
                }
            },
            error: function () {
                uglcw.ui.error('操作失败，请稍后再试');
                uglcw.ui.loaded()
            }
        })

    }
</script>
</body>
</html>
