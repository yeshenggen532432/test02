<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
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
        <div class="uglcw-layout-fixed" style="width: 220px">
            <div class="layui-card" id="putOnWareTypeEdit">
                <div class="layui-card-body">
                    <button onclick="javascript:getChecked();" class="k-button k-primary">上架商品类别编辑</button>
                </div>
            </div>

            <div class="layui-card">
                <div class="layui-card-header">商品分类</div>
                <div class="layui-card-body">
                    <div uglcw-role="tree" id="wareTypeTree"
                         uglcw-options="
							url: '${base}manager/pos/syswaretypes',
							data: function(){
							    return {
							        shopNo: uglcw.ui.get('#shopNo').value()
							    }
							},
							loadFilter:function(response){
                                    $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                         item.text='商品分类';
                                        }
                                    })
                                    return response;
                                },
							expandable:function(node){
								return node.id == '0';
							},
							select: function(e){
								var node = this.dataItem(e.node)
                                uglcw.ui.get('#wareType').value(node.id);
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
                            <tag:select2 name="shopNo" id="shopNo" tableName="pos_shopinfo" displayKey="shop_no"
                                         displayValue="shop_name" index="0"/>
                        </li>
                        <li>
                            <input type="hidden" uglcw-model="wareType" id="wareType" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="groupIds" id="groupIds" uglcw-role="textbox">
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="isSale" placeholder="上架状态">
                                <option value="-1">全部</option>
                                <option value="0">未上架</option>
                                <option value="1" selected>已上架</option>
                            </select>
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <%--表格：头部end--%>

            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/pos/queryPosShopWare1',
                    		query:function(param){
                                if(param.isSale ===''){
                                    param.isSale = '-1'
                                }
                    		},
                    		criteria: '.form-horizontal'
                    	">


                        <div data-field="wareNm" uglcw-options="width:100">商品名称</div>
                        <div data-field="putOn"
                             uglcw-options="width:100, template: uglcw.util.template($('#putOn').html())">上架状态
                        </div>
                        <div data-field="wareDw" uglcw-options="width:100">大单位</div>
                        <div data-field="minUnit" uglcw-options="width:100">小单位</div>
                        <div data-field="defaultUnit" uglcw-options="
								width:150,
								headerTemplate: uglcw.util.template($('#header_defaultUnit').html()),
								template:templateUnit

								">
                        </div>
                        <div data-field="posPrice1" uglcw-options="
								width:150,
								headerTemplate: uglcw.util.template($('#header_lsPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.posPrice1, data: row, field:'posPrice1'})
								}
								">
                        </div>
                        <div data-field="posPrice2" uglcw-options="
								width:150,
								headerTemplate: uglcw.util.template($('#header_minLsPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.posPrice2, data: row, field:'posPrice2'})
								}
								">
                        </div>
                        <div data-field="disPrice1" uglcw-options="width:100">大单位促销价</div>
                        <div data-field="disPrice2" uglcw-options="width:100">小单位促销价</div>


                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">

    <a role="button" href="javascript:addWares();" class="k-button k-button-icontext">
        <span class="k-icon k-i-sort-asc-sm"></span>上架
    </a>
    <a role="button" href="javascript:deleteWare();" class="k-button k-button-icontext">
        <span class="k-icon k-i-sort-desc-sm"></span>下架
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:updateWareUnit();">
        <span class="k-icon k-i-settings"></span>批量调整开单单位
    </a>
</script>

<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="bind">
                <div class="form-group">
                    <div class="control-label  col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="defaultUnit"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"大单位","value":"1"},{"text":"小单位","value":"0"}]'></ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<%--上架状态--%>
<script id="putOn" type="text/x-uglcw-template">
    <span>#= data.isSale == '1' ? '已上架' : '未上架' #</span>
</script>
<%--商品描述--%>
<script id="wareDesc" type="text/x-uglcw-template">
    # if(data.wareDesc==null || data.wareDesc==undefined || data.wareDesc==''){ #
    <button onclick="javascript:toupdateware(#= data.wareId#,'#= data.wareNm#');" class="k-button k-info">请设置</button>
    # }else{ #
    <button onclick="javascript:toupdateware(#= data.wareId#,'#= data.wareNm#');" class="k-button">已描述</button>
    # } #
</script>
<script id="header_defaultUnit" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('defaultUnit');">默认单位✎</span>
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
<%--设置商品分组--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-xs-6">商品分组</label>
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

<script id="picList" type="text/x-uglcw-template">
    <div class="uglcw-album">
        <div id="album-list" class="album-list">
            #if(data.warePicList)for(var i = 0;i
            <data.warePicList.length
                    ; i++){#
                    # var item=data.warePicList[i];#
            <div class="album-item">
                # if(item.type == "1"){ #
                <img src="/upload/#= item.picMini#" style="border: 1px solid red;">
                # }else{ #
                <img src="/upload/#= item.picMini#">
                # } #
                <div class="album-item-cover">
                    <i class="ion-ios-eye" onclick="preview(this, #= i#)"></i>
                    <i class="ion-ios-photos" onclick="setAsPrimary(this, #= i#)"></i>
                </div>
            </div>
            #}#
        </div>
    </div>
</script>

<script id="tpl" type="text/x-uglcw-template">

</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/edit-kendo.jsp" %><!--列表编辑模版-->
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

        uglcw.ui.get('#grid').on('dataBound', function () {
            this.autoFitColumn('picList');
        })

        resize();
        $(window).resize(resize);
        uglcw.ui.loaded();
    })

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - 40;
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

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
                $.ajax({
                    url: '${base}manager/shopWare/updateBatchPutOnWare',
                    data: {
                        ids: ids,
                        putOn: putOn
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response != "-1") {
                            uglcw.ui.success("操作成功");
                            uglcw.ui.get('#grid').k().dataSource.read();
                        } else {
                            uglcw.ui.error("操作失败");
                        }
                    }
                })
            })
        }
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
        top.layui.index.openTabsPage("${base}manager/shopWare/toUpdateWare?Id=" + wareId, wareNm + "_修改");
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

    var g_groupIds = "";

    function callChangeFun(value, field, wareId) {
        if (value && isNaN(value)) {
            alert("请输入正整数");
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
                    callSuccessFun(value, field, wareId);
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }


    //-------------------------------------------------------------------------------------------
    function getChecked() {
        uglcw.ui.Modal.showTreeSelector({
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
            area: ['300px', '600px'],
            url: '${base}manager/pos/shopWaretypes?shopNo=' + uglcw.ui.get('#shopNo').value(),
            yes: function (checkNodes, nodes, smooth) {
                var cIds = [];
                var bIds = [];
                $.map(checkNodes, function (item) {
                    if (item.checked) {
                        cIds.push(item.id)
                    } else if (item.halfChecked) {
                        bIds.push(item.id)
                    }
                })
                savepower(cIds, bIds);
            }
        })
    }

    //保存
    function savepower(cIds, iIds) {
        var shopNo = uglcw.ui.get('#shopNo').value();
        //选中
        //alert(iIds);
        var cStr;//全选id
        var bStr;//部分选中
        if (cIds != null && cIds != undefined && cIds != '') {
            cStr = cIds.join(',');
        }
        if (iIds != null && iIds != undefined && iIds != '') {
            bStr = iIds.join(',');
        }

        $.ajax({
            url: "${base}manager/pos/updateShopWaretype",
            type: "post",
            data: {shopNo: shopNo, "ids": cStr, "ids1": bStr},
            success: function (json) {
                if (json.state) {
                    uglcw.ui.success('修改成功');

                    //window.location.reload()//刷新当前页面.
                    uglcw.ui.get('#wareTypeTree').reload();
                } else {
                    uglcw.ui.error('修改失败');
                }
            }
        });
    }


    uglcw.ui.get('#shopNo').on('change', function () {

        uglcw.ui.get('#wareTypeTree').reload();

    })


    //=======================================================================================
    function operatePrice(field) {
        if (field == 'defaultUnit') {
            //默认单位
            var display = $("." + field + "_select").css('display');
            if (display == 'none') {
                $("." + field + "_select").show();
                $("." + field + "_span").hide();
            } else {
                $("." + field + "_select").hide();
                $("." + field + "_span").show();
            }
        } else {
            var display = $("." + field + "_input").css('display');
            if (display == 'none') {
                $("." + field + "_input").show();
                $("." + field + "_span").hide();
            } else {
                $("." + field + "_input").hide();
                $("." + field + "_span").show();
            }
        }
    }

    function changePrice(o, field, wareId) {
        if (isNaN(o.value)) {
            uglcw.ui.toast("请输入数字")
            return;
        }
        $.ajax({
            url: "${base}manager/pos/updateShopWare2",
            type: "post",
            data: {
                shopNo: uglcw.ui.get('#shopNo').value(),
                wareId: wareId,
                field: field,
                val: o.value,
            },
            success: function (data) {
                if (data == '1') {
                    $("#" + field + "_span_" + wareId).text(o.value);
                    // uglcw.ui.toast("价格保存成功");
                } else {
                    uglcw.ui.error("价格保存失败");
                }
            }
        });
    }


    function templateUnit(row) {
        var defaultUnit = "小单位";
        var val = row.defaultUnit;
        var wareId = row.wareId;
        if (val == 1) defaultUnit = "大单位";
        var html = '';
        html += '<select class="defaultUnit_select" id="defaultUnit_select_' + wareId + '" style="display:none" onchange="changePrice2(this,' + row.wareId + ')" >';
        if (val == 1) {
            html += '<option value="0">小单位</option>';
            html += '<option value="1" selected>大单位</option>';
        } else {
            html += '<option value="0" selected>小单位</option>';
            html += '<option value="1">大单位</option>';
        }
        html += '</select>';
        html += '<span id="defaultUnit_span_' + wareId + '" class="defaultUnit_span">' + defaultUnit + '</span>';
        return html;
    }

    function changePrice2(o, wareId) {
        $.ajax({
            url: "${base}manager/pos/updateShopWare2",
            type: "post",
            data: {
                shopNo: uglcw.ui.get('#shopNo').value(),
                wareId: wareId,
                field: 'defaultUnit',
                val: o.value,
            },
            success: function (data) {
                if (data == '1') {
                    if (o.value == '1') {
                        $("#defaultUnit_span_" + wareId).text('大单位');
                    } else {
                        $("#defaultUnit_span_" + wareId).text('小单位');
                    }

                    uglcw.ui.toast("价格保存成功");
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }


    function addWares() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var wareIds = '';
            for (var i = 0; i < selection.length; i++) {
                if (wareIds == '') {
                    wareIds = selection[i].wareId;
                } else {
                    wareIds += ',' + selection[i].wareId;
                }
            }
        }

        if (selection.length == 0) {
            uglcw.ui.error("请选择要上架的商品");
            return;
        }


        var shopNo = uglcw.ui.get('#shopNo').value();
        if (shopNo == "") {
            uglcw.ui.error("请选择门店");
            return;
        }
        $.ajax({
            url: "${base}manager/pos/addBatShopWare1",
            data: "shopNo=" + shopNo + "&wareStr=" + wareIds,
            type: "post",
            success: function (json) {
                if (json.state) {
                    //if(ope == 1)
                    uglcw.ui.success("上加成功");
                    uglcw.ui.get('#grid').reload();

                } else {
                    uglcw.ui.error("提交失败");
                }
            }
        });
    }


    function deleteWare() {
        var shopNos = uglcw.ui.get('#shopNo').value();
        //var shoprows = $("#datagrid1").datagrid("getSelections");

        if (shopNos == "") {
            uglcw.ui.error("请选择门店");
            return;
        }
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var wareIds = '';
            for (var i = 0; i < selection.length; i++) {
                if (wareIds == '') {
                    wareIds = selection[i].wareId;
                } else {
                    wareIds += ',' + selection[i].wareId;
                }
            }
        }

        if (selection.length == 0) {
            uglcw.ui.error("请选择要下架的记录");
            return;
        }


        $.ajax({
            url: "${base}manager/pos/deleteShopWare",
            data: "shopNos=" + shopNos + "&wareIds=" + wareIds,
            type: "post",
            success: function (json) {
                if (json.state) {

                    uglcw.ui.success("下架成功");
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error("提交失败");
                }
            }
        });


    }

    function updateWareUnit() {
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
                        var type = chkObjs.defaultUnit;
                        var ids = $.map(selection, function (row) {
                            return row.wareId
                        });
                        $.ajax({
                            url: '${base}manager/pos/batchUpdateWareDefaultUnit',
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

</script>
</body>
</html>
