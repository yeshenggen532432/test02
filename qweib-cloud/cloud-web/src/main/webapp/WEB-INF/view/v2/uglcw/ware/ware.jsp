<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品信息管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <script>
        var showInPrice = '${permission:checkUserButtonPdm("uglcw.sysWare.showInPrice")}';
        var showSalePrice = '${permission:checkUserButtonPdm("uglcw.sysWare.showSalePrice")}';
    </script>
    <style>
        .k-grid-toolbar {
            padding: 0px 10px 0px 10px !important;
            width: 100%;
            display: inline-flex;
            vertical-align: middle;
        }

        .k-grid-toolbar .k-checkbox-label {
            margin-top: 7px !important;

        }

        .k-grid-toolbar label {
            padding-left: 20px;
            margin-left: 10px;
            margin-top: 7px;
            margin-bottom: 0px !important;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 150px;">
            <div class="layui-card" uglcw-role="resizable" uglcw-options="responsive:[35]">
                <ul uglcw-role="accordion" uglcw-options="expandMode: 'single'" id="accordion">
                    <li>
                        <span>库存商品类</span>
                        <div id="tree0" uglcw-role="tree"
                             uglcw-options="
                                url:'${base}manager/syswaretypes?isType=0',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                if(item.text=='根节点'){
                                item.text='库存商品类'
                                }
                                })
                                return response;
                                },
                                select: function(e){
                                    onWareTypeSelect.call(this, e, 0);
                                },
                                dataBound: function(){
                                    var tree = this;
                                    clearTimeout($('#tree0').data('_timer'));
                                    $('#tree0').data('_timer', setTimeout(function(){
                                        tree.select($('#tree0 .k-item:eq(0)'));
                                        var nodes = tree.dataSource.data().toJSON();
                                        if(nodes && nodes.length > 0){
                                            uglcw.ui.bind('.uglcw-query', {
                                                isType: 0
                                            })
                                            uglcw.ui.get('#grid').reload();
                                        }
                                    }, 100))

                                 }
                            ">
                        </div>
                    </li>
                    <li>
                        <span>原辅材料类</span>
                        <div id="tree1" uglcw-role="tree"
                             uglcw-options="
                                expandable:function(node){
                                    if(node.id == '0')return true;
                                    return false;
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                if(item.text=='根节点'){
                                item.text='原辅材料类'
                                }
                                })
                                return response;
                                },
                                url:'${base}manager/syswaretypes?isType=1',
                                select: function(e){
                                  onWareTypeSelect.call(this, e, 1);
                                }
                            ">
                        </div>
                    </li>
                    <li>
                        <span>低值易耗品类</span>
                        <div id="tree2" uglcw-role="tree"
                             uglcw-options="
                                expandable:function(node){
                                    if(node.id == '0')return true;
                                    return false;
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                if(item.text=='根节点'){
                                item.text='低值易耗品类'
                                }
                                })
                                return response;
                                },
                                url:'${base}manager/syswaretypes?isType=2',
                                select: function(e){
                                  onWareTypeSelect.call(this, e, 2);
                                }
                            ">
                        </div>
                    </li>
                    <li>
                        <span>固定资产类</span>
                        <div id="tree3" uglcw-role="tree"
                             uglcw-options="
                                expandable:function(node){
                                    if(node.id == '0')return true;
                                    return false;
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                if(item.text=='根节点'){
                                item.text='固定资产类'
                                }
                                })
                                return response;
                                },
                                url:'${base}manager/syswaretypes?isType=3',
                                select: function(e){
                                    onWareTypeSelect.call(this, e, 3);
                                }
                            ">
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query differentiate">
                        <li>
                            <select uglcw-model="isType" uglcw-role="combobox" id="type" placeholder="资产类型"
                                    uglcw-options='value:"",change: function(){
                                     if(uglcw.ui.get("#type").value() == ""){
                                        uglcw.ui.get("#level2").k().text("");
                                        uglcw.ui.get("#level2").k().value("");
                                        uglcw.ui.get("#level2").k().dataSource.data([]);
                                        uglcw.ui.get("#level3").k().text("");
                                        uglcw.ui.get("#level3").k().value("");
                                        uglcw.ui.get("#level3").k().dataSource.data([]);
                                      }else{
                                        uglcw.ui.get("#level2").k().text("");
                                        uglcw.ui.get("#level2").k().value("");
                                        uglcw.ui.get("#level2").k().dataSource.read();
                                        uglcw.ui.get("#level3").k().text("");
                                        uglcw.ui.get("#level3").k().value("");
                                        uglcw.ui.get("#level3").k().dataSource.data([]);
                                        }
                                    }'
                            >
                                <option value="0">库存商品类</option>
                                <option value="1">原辅材料类</option>
                                <option value="2">低值易耗品类</option>
                                <option value="3">固定资产类</option>
                            </select>
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="level2" id="level2" placeholder="二级分类"
                                    uglcw-options="
                                    dataTextField: 'text',
                                    dataValueField: 'id',
                                    loadFilter: {
                                        data: function(response){
                                            return response[0].children||[];
                                        }
                                    },
                                    change: function(){
                                        uglcw.ui.get('#level3').k().dataSource.data([]);
                                        uglcw.ui.get('#level3').k().value('');
                                        uglcw.ui.get('#level3').k().dataSource.read();
                                    },
                                    data:function(){
                                        return {
                                            isType: uglcw.ui.get('#type').value(),
                                            id: 0
                                        }
                                    },
                                    url:'${base}manager/syswaretypes'
                            ">

                            </select>
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="level3" id="level3" placeholder="三级分类"
                                    uglcw-options="
                                    dataTextField: 'text',
                                    dataValueField: 'id',
                                     loadFilter: {
                                        data: function(response){
                                            return response||[]
                                        }
                                    },
                                    data:function(){
                                        return {
                                            isType: uglcw.ui.get('#type').value(),
                                            id: uglcw.ui.get('#level2').value(),
                                        }
                                    },
                                    url:'${base}manager/syswaretypes',
                            ">
                            </select>
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="packBarCode" placeholder="大单位条码">
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="beBarCode" placeholder="小单位条码">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="status">
                                <option value="">全部</option>
                                <option value="1" selected>启用</option>
                                <option value="2">不启用</option>
                            </select>
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
                    <div id="grid" class="uglcw-grid-compact" uglcw-role="grid"
                         uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    checkbox: true,
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    url: '${base}manager/wares',
                    criteria: '.uglcw-query',
                    dblclick: function(row){
                        toupdateware(row.wareId);
                    },
                    query: function(params){
                        params.wtype = params.level3 || params.level2
                        return params;
                    },
                    pageable: true,
                    ">
                        <div data-field="sort" uglcw-options="
                                width:80,
                                headerTemplate: uglcw.util.template($('#header_sort').html()),
                                template:function(row){
                                    return uglcw.util.template($('#num').html())({val:row.sort, data: row, field:'sort'})
                                }
                                ">
                        </div>
                        <div data-field="wareCode" uglcw-options="width:100,
                            headerTemplate: uglcw.util.template($('#header_field').html())({field:'wareCode',fieldName:'商品代码'}),
                           template:function(row){
									return uglcw.util.template($('#fieldTpl').html())({val:row.wareCode, data: row, field:'wareCode'})
								}
                        ">商品编码
                        </div>
                        <div data-field="wareNm" uglcw-options="width:200,locked: true,
                           headerTemplate: uglcw.util.template($('#header_field').html())({field:'wareNm',fieldName:'商品名称'}),
                           template:function(row){
									return uglcw.util.template($('#fieldTpl').html())({val:row.wareNm, data: row, field:'wareNm'})
								},
                         tooltip: true"></div>
                        <div data-field="py" uglcw-options="width:80, tooltip: true">助记码</div>
                        <div data-field="waretypeNm" uglcw-options="width:80">所属分类</div>
                        <div data-field="wareGg" uglcw-options="width:100,
                            hidden:true,
                           headerTemplate: uglcw.util.template($('#header_field').html())({field:'wareGg',fieldName:'规格(大)'}),
                           template:function(row){
									return uglcw.util.template($('#fieldTpl').html())({val:row.wareGg, data: row, field:'wareGg'})
								}
                        "></div>
                        <div data-field="minWareGg" uglcw-options="width:100,
                                  hidden:true,
                                  headerTemplate: uglcw.util.template($('#header_field').html())({field:'minWareGg',fieldName:'规格(小)'}),
                                  template:function(row){
									return uglcw.util.template($('#fieldTpl').html())({val:row.minWareGg, data: row, field:'minWareGg'})
								}
                                "></div>
                        <div data-field="wareDw" uglcw-options="width:80,
                                     hidden:true,
                                    headerTemplate: uglcw.util.template($('#header_field').html())({field:'wareDw',fieldName:'大单位'}),
                                   template:function(row){
									return uglcw.util.template($('#fieldTpl').html())({val:row.wareDw, data: row, field:'wareDw'})}
                        "></div>
                        <div data-field="packBarCode" uglcw-options="width:140,
                                     hidden:true,
                                    headerTemplate: uglcw.util.template($('#header_field').html())({field:'packBarCode',fieldName:'大单位条码'}),
                                   template:function(row){
									return uglcw.util.template($('#fieldTpl').html())({val:row.packBarCode, data: row, field:'packBarCode'})}
                        "></div>
                        <div data-field="minUnit" uglcw-options="width:80,
                                    hidden:true,
                                     headerTemplate: uglcw.util.template($('#header_field').html())({field:'minUnit',fieldName:'小单位'}),
                                   template:function(row){
									return uglcw.util.template($('#fieldTpl').html())({val:row.minUnit, data: row, field:'minUnit'})}
                        "></div>
                        <div data-field="beBarCode" uglcw-options="width:120,
                                     hidden:true,
                                    headerTemplate: uglcw.util.template($('#header_field').html())({field:'beBarCode',fieldName:'小单位条码'}),
                                   template:function(row){
									return uglcw.util.template($('#fieldTpl').html())({val:row.beBarCode, data: row, field:'beBarCode'})}
                        "></div>

                        <div data-field="sunitFront"
                             uglcw-options="width:80, template: uglcw.util.template($('#billing').html())">默认开单
                        </div>

                        <div data-field="inPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_inPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.inPrice, data: row, field:'inPrice'})
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
                        <div data-field="lowestSalePrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_lowestSalePrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.lowestSalePrice, data: row, field:'lowestSalePrice'})
								}
								">
                        </div>
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
                        <div data-field="shopWarePrice" uglcw-options="
								width:120,
								hidden:true,
								headerTemplate: uglcw.util.template($('#header_shopWarePrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWarePrice, data: row, field:'shopWarePrice'})
								}
								">
                        </div>
                        <div data-field="shopWareSmallPrice" uglcw-options="
								width:120,
								hidden:true,
								headerTemplate: uglcw.util.template($('#header_shopWareSmallPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallPrice, data: row, field:'shopWareSmallPrice'})
								}
								">
                        </div>
                        <div data-field="shopWareLsPrice" uglcw-options="
								width:120,
								hidden:true,
								headerTemplate: uglcw.util.template($('#header_shopWareLsPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareLsPrice, data: row, field:'shopWareLsPrice'})
								}
								">
                        </div>
                        <div data-field="shopWareSmallLsPrice" uglcw-options="
								width:120,
								hidden:true,
								headerTemplate: uglcw.util.template($('#header_shopWareSmallLsPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallLsPrice, data: row, field:'shopWareSmallLsPrice'})
								}
								">
                        </div>

                        <div data-field="posPrice1" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_posPrice1').html()),
								hidden:true,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.posPrice1, data: row, field:'posPrice1'})
								}
								">
                        </div>
                        <div data-field="posPrice2" uglcw-options="
								width:120,
								hidden:true,
								headerTemplate: uglcw.util.template($('#header_posPrice2').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.posPrice2, data: row, field:'posPrice2'})
								}
								">
                        </div>
                        <div
                                data-field="innerAccPrice"
                                uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_innerAccPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.innerAccPrice, data: row, field:'innerAccPrice'})
								}
								">
                        </div>
                        <div data-field="tranAmt" uglcw-options="
								width:110,
								headerTemplate: uglcw.util.template($('#head_tranAmt').html()),
								template:templateTranAmt
							">
                            运输费用
                        </div>
                        <div data-field="tcAmt" uglcw-options="
								width:110,
								template:templateTcAmt,
								hidden:true
							">
                            提成费用
                        </div>
                        <div data-field="brandNm" uglcw-options="width:80
                        ,
                             headerTemplate: uglcw.util.template($('#header_field').html())({field:'brandNm',fieldName:'所属品牌'})
                                   <%--template:function(row){--%>
									<%--return uglcw.util.template($('#fieldTpl').html())({val:row.brandNm, data: row, field:'brandNm'})}--%>
                        "></div>
                        <div data-field="qualityDays" uglcw-options="width:80,
                             headerTemplate: uglcw.util.template($('#header_field').html())({field:'qualityDays',fieldName:'保质期'}),
                                   template:function(row){
									return uglcw.util.template($('#fieldTpl').html())({val:row.qualityDays, data: row, field:'qualityDays'})}"></div>
                        <div data-field="groupName" uglcw-options="width:110,hidden:true">多规格商品组名</div>
                        <%--  <div data-field="multiSpecNm" uglcw-options="width:110">所属多规格商品</div>--%>
                        <div data-field="asnNo" uglcw-options="width:110,
                                    headerTemplate: uglcw.util.template($('#header_field').html())({field:'asnNo',fieldName:'标识码'}),
                                   template:function(row){
									return uglcw.util.template($('#fieldTpl').html())({val:row.asnNo, data: row, field:'asnNo'})}"></div>
                        <div data-field="fbtime" uglcw-options="width:160">创建时间</div>
                        <div data-field="status"
                             uglcw-options="width:80, template: uglcw.util.template($('#formatterStatus').html())">是否启用
                        </div>
                        <div data-field="isCy"
                             uglcw-options="width:80, template: uglcw.util.template($('#formatterSt').html())">是否常用
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script id="header_sort" type="text/x-uglcw-template">
    <span onclick="javascript:operateSort('sort');">排序✎</span>
</script>

<script id="num" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric"
           uglcw-validate="number"
           style="height:25px;display:none"
           onchange="changeSort(this,'#=field#',#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>

</script>
<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="bind">
                <div class="form-group">
                    <div class="control-label  col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="sunitFront"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"大单位","value":"0"},{"text":"小单位","value":"1"}]'></ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<script id="goods-category" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="classification">
                <div class="form-group">
                    <div class="control-label  col-xs-14">
                        <input uglcw-role="dropdowntree" uglcw-model="waretype"
                               uglcw-options="
                                        url: '${base}manager/syswaretypes',
                                        loadFilter:function(response){
                                        $(response).each(function(index,item){
                                            if(item.text=='根节点'){
                                             item.text='库存商品类';
                                            }
                                        })
                                        return response;
                                        }
                                       "
                        >
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>


<script id="product-type-selector-template" type="text/uglcw-template">
    <div class="uglcw-selector-container">
        <div style="line-height: 30px">
            已选:
            <button style="display: none;" id="__type_name" class="k-button k-info ghost"></button>
            <input type="hidden" uglcw-role="textbox" id="__type_id">
            <input type="hidden" uglcw-role="textbox" id="__upWaretypeNm">
        </div>
        <div style="padding: 2px;height: 344px;">

            <ul uglcw-role="accordion">
                <li>
                    <span>库存商品类</span>
                    <div>
                        <div uglcw-role="tree"
                             uglcw-options="
                                url:'${base}manager/syswaretypes?isType=0',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
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
                                    $('#__type_id').val(node.id);
                                      $('#__type_id').val(node.id);
                                       $('#__upWaretypeNm').val(node.text);
                                    $('#__type_name').text(node.text);
                                    $('#__type_name').show();
                                }
                            ">
                        </div>
                    </div>
                </li>
                <li>
                    <span>原辅材料类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=1',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                    if(item.text=='根节点'){
                                        item.text='原辅材料类'
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    $('#__type_id').val(node.id);
                                    $('#__type_name').text(node.text);
                                     $('#__upWaretypeNm').val(node.text);
                                    $('#__type_name').show();
                                }
                            ">
                    </div>
                </li>
                <li>
                    <span>低值易耗品类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=2',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                    if(item.text=='根节点'){
                                        item.text='低值易耗品类'
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    $('#__type_id').val(node.id);
                                    $('#__type_name').text(node.text);
                                      $('#__upWaretypeNm').val(node.text);
                                    $('#__type_name').show();
                                }
                            ">
                    </div>
                </li>
                <li>
                    <span>固定资产类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=3',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                    if(item.text=='根节点'){
                                      item.text='固定资产'
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                     $('#__type_id').val(node.id);
                                    $('#__type_name').text(node.text);
                                       $('#__upWaretypeNm').val(node.text);
                                    $('#__type_name').show();
                                }
                            ">
                    </div>
                </li>
            </ul>
        </div>
    </div>
</script>


<script id="head_tranAmt" type="text/x-uglcw-template">
    <span onclick="javascript:editPrice();">运输费用✎</span>
</script>

<script type="text/x-kendo-template" id="billing">
    #if(data.sunitFront){#
    <span style="color:red;">小单位</span>
    #}else{#
    <span>大单位</span>
    #}#

</script>
<script type="text/x-kendo-template" id="formatterStatus">
    #if (data.status == 1) {#
    是
    #} else {#
    否
    #}#
</script>

<script type="text/x-kendo-template" id="formatterSt">
    # if(data.isCy =='1'){ #
    <button class="k-button k-success" onclick="disable(#= data.wareId#, 2)">是</button>
    # }else { #
    <button class="k-button k-error" onclick="disable(#= data.wareId#, 1)">否</button>
    # } #

</script>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toaddware();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:toupdateware();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-pencil"></span>修改
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toDel();">
        <span class="k-icon k-i-trash"></span>移除
    </a>
    <%-- <a role="button" href="javascript:editPrice();"
        class="k-button k-button-icontext">
         <span class="k-icon k-i-edit"></span><span id="editPrice">编辑价格</span>
     </a>--%>
    <%--  <a role="button" href="javascript:toWareModel();"
         class="k-button k-button-icontext">
          <span class="k-icon k-i-download"></span>下载模板
      </a>--%>
    <%--  <a role="button" href="javascript:showUpload();"
         class="k-button k-button-icontext k-grid-add-other">
          <span class="k-icon k-i-upload"></span>上传商品
      </a>--%>

    <a role="button" class="k-button k-button-icontext"
       href="javascript:selectType();">
        <span class="k-icon k-i-settings"></span>批量调整商品类别
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:updateSunitFront();">
        <span class="k-icon k-i-settings"></span>批量调整开单单位
    </a>


    <input type="checkbox" class="k-checkbox" onclick="showWareAttr();" uglcw-role="checkbox" uglcw-model="showWareAttr"
           id="showWareAttr" >
    <label style="margin-left: 10px;" class="k-checkbox-label" for="showWareAttr">显示规格单位条码</label>

    <div id="showShopPriceDiv" style="display: ${permission:checkUserButtonPdm("uglcw.sysWare.showShopPrice")?'':'none'}">
        <input type="checkbox" class="k-checkbox" onclick="showPrice();" uglcw-role="checkbox" uglcw-model="showShopPrice"
               id="showShopPrice">
        <label style="margin-left: 10px;" class="k-checkbox-label" for="showShopPrice">显示商城价格</label>
    </div>
    <div id="showPosPriceDiv" style="display: ${permission:checkUserButtonPdm("uglcw.sysWare.showPosPrice")?'':'none'}">
        <input type="checkbox" class="k-checkbox" onclick="showPrice();" uglcw-role="checkbox" uglcw-model="showPosPrice"
               id="showPosPrice">
        <label style="margin-left: 10px;" class="k-checkbox-label" for="showPosPrice">显示门店价格</label>
    </div>
</script>

<script id="header_field" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('#= field #');">
        #= fieldName #✎
       </span>
</script>

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
<script id="header_lowestSalePrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('lowestSalePrice');">最低销售价(大)✎</span>
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


<script id="header_posPrice1" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('posPrice1');">门店零售价(大)✎</span>
</script>
<script id="header_posPrice2" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('posPrice2');">门店零售价(小)✎</span>
</script>
<script id="header_shopWarePrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('shopWarePrice');">商城批发价(大)✎</span>
</script>
<script id="header_shopWareSmallPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('shopWareSmallPrice');">商城批发价(小)✎</span>
</script>
<script id="header_shopWareLsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('shopWareLsPrice');">商城零售价(大)✎</span>
</script>
<script id="header_shopWareSmallLsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('shopWareSmallLsPrice');">商城零售价(小)✎</span>
</script>
<script id="header_innerAccPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('innerAccPrice');">内部核算价✎</span>
</script>


<script id="price" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <input class="#=field#_input k-textbox" name="#=field#_input" id="#=field#_input_#=wareId#" uglcw-role="numeric"
           uglcw-validate="number"
           style="height:25px;display:none" onchange="changePrice(this,'#= field #',#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>
</script>

<script id="fieldTpl" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <input class="#=field#_input k-textbox" name="#=field#_input" id="#=field#_input_#=wareId#" uglcw-role="textbox"
           style="height:25px;display:none" onchange="changeFieldValue(this,'#= field #',#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.layout.init();
        $('.uglcw-layout-fixed').kendoTooltip({
            filter: 'li.k-item',
            position: 'right',
            content: function (e) {
                return '<span class="k-in" style="width: 100px;display: inline-flex;">' + $(e.target).find('span.k-in').html() + '</span>';
            }
        });
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').k().dataSource.read();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query', {});
        });
        uglcw.ui.loaded()
    });

    function onWareTypeSelect(e, isType) {
        var node = this.dataItem(e.node);
        uglcw.ui.get('#type').value(isType);
        if (node.id == 0) {
            uglcw.ui.get('#level2').k().dataSource.read();
            uglcw.ui.get('#level2').value('');
            uglcw.ui.get('#level3').k().dataSource.data([]);
            uglcw.ui.get('#level3').value('');
        } else if (node.pid == 0) {
            uglcw.ui.get('#level2').k().dataSource.read();
            uglcw.ui.get('#level2').value(node.id);
            uglcw.ui.get('#level3').k().dataSource.data([]);
            uglcw.ui.get('#level3').value('');
        } else if (node.pid > 0) {
            uglcw.ui.get('#level2').k().dataSource.read();
            uglcw.ui.get('#level2').value(node.pid);
            uglcw.ui.get('#level3').k().dataSource.read();
            uglcw.ui.get('#level3').value(node.id);
        }
        uglcw.ui.get('#grid').reload();
    }

    function operateSort(field) {
        var display = $("." + field + "_input").css('display');
        if (display == 'none') {
            $("." + field + "_input").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").hide();
            $("." + field + "_span").show();
        }
    }

    function changeSort(element, field, id) {
        if (isNaN(element.value)) {
            alert("请输入数字");
            return;
        }
        $.ajax({
            url: "${base}manager/updateSort",
            type: "post",
            data: "&id=" + id + "&sort=" + element.value,
            success: function (response) {
                if (response.code == 200) {
                    uglcw.ui.success("操作成功");
                    //uglcw.ui.get("#"+field+"_span_"+id).value(element.value);
                    $("#" + field + "_span_" + id).text(element.value);
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }


    function disable(id, status) {
        var type = status == 1 ? '是' : '不是';
        uglcw.ui.confirm('确定' + type + '常用商品吗？', function () {
            $.ajax({
                url: '${base}manager/updateWareIsCy',
                type: 'post',
                data: {id: id, isCy: status},
                success: function (response) {
                    if (response == '1') {
                        uglcw.ui.success(type + '成功');
                        uglcw.ui.get('#grid').reload();

                    } else {
                        uglcw.ui.error(type + '失败');
                    }
                }
            })
        })
    }

    function toDel() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('是否要移除选中的商品?', function () {
                $.ajax({
                    url: '${base}/manager/deleteware',
                    data: {
                        ids: $.map(selection, function (row) {
                            return row.wareId
                        }).join(",")
                    },
                    type: 'post',
                    success: function (json) {
                        if (json == '1') {
                            uglcw.ui.success('删除成功');
                            uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                        } else if (json == 2) {
                            uglcw.ui.error('删除失败，该商品已使用！');

                        } else {
                            uglcw.ui.error('删除失败！');//

                        }


                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要删除的行！');
        }
    }


    function updateSunitFront() {//批量调整开单单位
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#t').html(),
                success: function (container) {
                    uglcw.ui.init($(container));//初始化
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        var chkObjs = uglcw.ui.bind($("#bind"));
                        var type = chkObjs.sunitFront;
                        var ids = $.map(selection, function (row) {
                            return row.wareId
                        });
                        $.ajax({
                            url: '${base}/manager/batchUpdateWareSunitFront',
                            data: JSON.stringify({
                                ids: ids,
                                type: type
                            }),
                            contentType: 'application/json',
                            dataType: 'json',
                            type: 'post',
                            success: function (response) {
                                if (response.code == 200) {
                                    uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                                }
                            }
                        })
                    } else {
                        uglcw.ui.error('失败');
                        return false;
                    }
                }
            });
        } else {
            uglcw.ui.warning('请选择商品！');
        }

    }

    function getWareType() {
        return uglcw.ui.get('#level3').value() || uglcw.ui.get('#level2').value();
    }

    function toaddware() {//添加商品
        var id = getWareType();
        uglcw.ui.openTab('编辑', '${base}manager/tooperware?wtype=' + id + '&click_flag=' + 1);
    }

    function toupdateware(id) {//修改
        var wtype = getWareType();
        if (!id) {
            var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
            if (!selection) {
                return uglcw.ui.warning('请选择行！');
            }
            id = selection[0].wareId;
        }
        uglcw.ui.openTab('商品编辑', '${base}manager/tooperware?Id=' + id + '&click_flag=' + 1);
    }

    function selectType() {

        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            var win = uglcw.ui.Modal.open({
                checkbox: true,
                selection: 'single',
                title: false,
                maxmin: false,
                resizable: false,
                move: true,
                btns: ['确定', '取消'],
                area: ['400', '415px'],
                content: $('#product-type-selector-template').html(),
                success: function (c) {
                    uglcw.ui.init(c);
                },
                yes: function (c) {
                    var typeId = uglcw.ui.get($(c).find('#__type_id')).value();
                    var typeName = uglcw.ui.get($(c).find('#__upWaretypeNm')).value();
                    var bool = checkWareTypeLeaf(typeId);
                    if (!bool) {
                        uglcw.ui.warning('商品类别未选择最末节点，未更改将会自动归到未分类商品类别！');
                        return false;
                    }
                    $.ajax({
                        url: '${base}/manager/batchUpdateWareType',
                        data: {
                            ids: $.map(selection, function (row) {  //选中多行数据审批
                                return row.wareId
                            }).join(','),
                            wareType: typeId
                        },
                        type: 'post',
                        success: function (json) {
                            if (json != "-1") {
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                                uglcw.ui.Modal.close(win);
                            } else {
                                uglcw.ui.error('商品类别更新失败');

                            }
                        }
                    })
                }
            })
        } else {
            uglcw.ui.warning('请选择商品！');
        }
    }

    /**
     校验商品类别是否末级节点
     */
    function checkWareTypeLeaf(typeId) {
        var bool = true;
        $.ajax({
            async: false,
            url: "${base}manager/checkWareTypeLeaf",
            data: "id=" + typeId,
            type: "post",
            dataType: 'json',
            success: function (json) {
                if (!json.state) {
                    bool = false;
                }
            }
        });
        return bool;
    }

    function updateWareType() { //批量调整商品类别
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                title: '商品类别'
                , content: $('#goods-category').html(),
                success: function (container) {
                    uglcw.ui.init($(container));//初始化
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        var textbox = uglcw.ui.bind($("#classification"));
                        var wareType = textbox.waretype;
                        $.ajax({
                            url: '${base}/manager/batchUpdateWareType',
                            data: {
                                ids: $.map(selection, function (row) {  //选中多行数据审批
                                    return row.wareId
                                }).join(','),
                                wareType: wareType
                            },
                            type: 'post',
                            success: function (json) {
                                if (json != "-1") {
                                    uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                                } else {
                                    uglcw.ui.error('商品类别更新失败');

                                }
                            }
                        })
                    } else {
                        uglcw.ui.error('失败');
                        return false;
                    }
                }
            });
        } else {
            uglcw.ui.warning('请选择商品！');

        }
    }


    //------------------------------------------------------运输费用:start------------------------------------------------------------
    //模板：运输费用
    function templateTranAmt(row) {
        var tranAmt = row.tranAmt;
        if (tranAmt == undefined || tranAmt == "undefined") {
            tranAmt = 0.0;
        }
        return "<input type='text' style='display:none' size='12' onchange='changeTranPrice(this," + row.wareId + ")' name='inputTranAmt' value='" + tranAmt + "' class='k-textbox inputTranAmt' uglcw-role='numeric' uglcw-validate='number'/><span class='inputTranAmtSpan' name='spanTranAmt' id='spanTranAmt_" + row.wareId + "'>" + tranAmt + "</span>";
    }


    function editPrice() {
        var display = $(".inputTranAmt").css('display');
        if (display == 'none') {
            $(".inputTranAmt").show();
            $(".inputTranAmtSpan").hide();
        } else {
            $(".inputTranAmt").hide();
            $(".inputTranAmtSpan").show();
        }
    }

    function changeTranPrice(obj, wareId) {
        if (isNaN(obj.value)) {
            uglcw.ui.toast("请输入数字");
            return;
        }
        var spanTranAmt = $('#spanTranAmt_' + wareId);
        $.ajax({
            url: "${base}manager/updateWareTranAmt",
            type: "post",
            data: "id=" + wareId + "&tranAmt=" + obj.value,
            success: function (data) {
                if (data == '1') {
                    spanTranAmt.text(obj.value);

                } else {
                    uglcw.ui.toast("操作失败");
                }
            }
        });
    }

    //------------------------------------------------------运输费用:end------------------------------------------------------------

    //------------------------------------------------------提成费用:start------------------------------------------------------------
    //模板：提成费用
    function templateTcAmt(row) {
        var tcAmt = row.tcAmt;
        if (tcAmt == undefined || tcAmt == "undefined") {
            tcAmt = 0.0;
        }
        return "<input type='text' style='display:none' size='12' onchange='changeTcPrice(this," + row.wareId + ")' name='inputTcAmt' value='" + tcAmt + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span name='spanTcAmt' id='spanTcAmt_" + row.wareId + "'>" + tcAmt + "</span>";

    }

    function changeTcPrice(obj, wareId) {
        if (isNaN(obj.value)) {
            uglcw.ui.toast("请输入数字");
            return;
        }
        var spanTcAmt = $('#spanTcAmt_' + wareId);
        $.ajax({
            url: "${base}manager/updateWareTcAmt",
            type: "post",
            data: "id=" + wareId + "&tcAmt=" + obj.value,
            success: function (data) {
                if (data == '1') {
                    spanTcAmt.text(obj.value);

                } else {
                    uglcw.ui.toast("操作失败");
                }
            }
        });
    }

    //------------------------------------------------------提成费用:end------------------------------------------------------------
    //------------------------------------------------------采购价:start------------------------------------------------------------
    //模板：采购价
    function templateInPrice(row) {
        var inPrice = row.inPrice;
        if (inPrice == undefined || inPrice == "undefined") {
            inPrice = 0.0;
        }
        return "<input type='text' style='display:none' size='12' onchange='changeInPrice(this," + row.wareId + ")' name='inputInPrice' value='" + inPrice + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span name='spanInPrice' id='spanInPrice_" + row.wareId + "'>" + inPrice + "</span>";
    }

    function changeInPrice(obj, wareId) {
        if (isNaN(obj.value)) {
            uglcw.ui.toast("请输入数字");
            return;
        }
        var spanInPrice = $('#spanInPrice_' + wareId);
        $.ajax({
            url: "${base}manager/updateWareInPrice",
            type: "post",
            data: "id=" + wareId + "&inPrice=" + obj.value,
            success: function (data) {
                if (data == '1') {
                    spanInPrice.text(obj.value)

                } else {
                    uglcw.ui.toast("操作失败");
                }
            }
        });
    }


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
                    if (field == "addRate" || field == "inPrice" || field == "minInPrice") {
                        $("#lsPrice_span_" + wareId).text(data.lsPrice);
                        $("#lsPrice_input_" + wareId).val(data.lsPrice);
                        $("#minLsPrice_input_" + wareId).val(data.minLsPrice);
                        $("#minLsPrice_span_" + wareId).text(data.minLsPrice);
                    }
                    if (field == "lsPrice" || field == "minLsPrice") {//addRate_span_9
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


    function changeFieldValue(o, field, wareId) {
        if (o.value == "") {
            uglcw.ui.toast("请输入")
            return;
        }
        $.ajax({
            url: "${base}manager/updateWareFieldValue",
            type: "post",
            dataType: 'json',
            data: "wareId=" + wareId + "&value=" + o.value + "&field=" + field,
            success: function (data) {
                if (data.state) {
                    $("#" + field + "_span_" + wareId).text(o.value);
                } else {
                    uglcw.ui.toast(data.msg);
                }
            }
        });
    }


    function showPrice() {
        var showShopPrice = $("#showShopPrice").is(':checked');
        var grid = uglcw.ui.get('#grid');
        if (!showShopPrice) {
            grid.hideColumn('shopWarePrice');
            grid.hideColumn('shopWareSmallPrice');
            grid.hideColumn('shopWareLsPrice');
            grid.hideColumn('shopWareSmallLsPrice');
        } else {
            grid.showColumn('shopWarePrice');
            grid.showColumn('shopWareSmallPrice');
            grid.showColumn('shopWareLsPrice');
            grid.showColumn('shopWareSmallLsPrice');
        }


        var showPosPrice = $("#showPosPrice").is(':checked');
        var grid = uglcw.ui.get('#grid');
        if (!showPosPrice) {
            grid.hideColumn('posPrice1');
            grid.hideColumn('posPrice2');
        } else {
            grid.showColumn('posPrice1');
            grid.showColumn('posPrice2');
        }
    }

    function showWareAttr() {
        var showWareAttr = $("#showWareAttr").is(':checked');
        var grid = uglcw.ui.get('#grid');
        if (!showWareAttr) {
            grid.hideColumn('wareGg');
            grid.hideColumn('minWareGg');
            grid.hideColumn('wareDw');
            grid.hideColumn('packBarCode');
            grid.hideColumn('minUnit');
            grid.hideColumn('beBarCode');
        } else {
            grid.showColumn('wareGg');
            grid.showColumn('minWareGg');
            grid.showColumn('wareDw');
            grid.showColumn('packBarCode');
            grid.showColumn('minUnit');
            grid.showColumn('beBarCode');
        }
    }

    $(function () {
        var grid = uglcw.ui.get('#grid');
        if (showInPrice == 'false') {
            grid.hideColumn('inPrice');
            grid.hideColumn('minInPrice');
        }
        if (showSalePrice == 'false') {
            grid.hideColumn('lsPrice');
            grid.hideColumn('wareDj');
            grid.hideColumn('minLsPrice');
            grid.hideColumn('sunitPrice');
        }
    })
</script>
</body>
</html>
