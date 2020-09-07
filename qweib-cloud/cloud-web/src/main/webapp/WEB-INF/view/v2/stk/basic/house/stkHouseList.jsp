<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>库位列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <%@include file="/WEB-INF/view/v2/include/edit-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="stkName" uglcw-role="textbox" placeholder="名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="状态">
                        <option value="1" selected>正常</option>
                        <option value="2">移除</option>
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
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    checkbox: true,
                    responsive: ['.header', 40],
                    id:'id',
                    url: '${base}manager/stkHouse/queryStorage',
                    criteria: '.query',
                    pageable: true,
                    ">

                <div data-field="stkName" uglcw-options="width:200">仓库名称</div>
                <div data-field="kw_oper"
                     uglcw-options="width:300, template: uglcw.util.template($('#kw_oper').html())">库位操作
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/x-uglcw-template" id="add-tpl">
    <div class="layui-fluid">
        <div class="layui-card header">
            <div class="layui-card-body">
                <ul class="uglcw-query criteria">
                    <li>
                        <input value="#= data.stkId||''#" uglcw-model="stkId" type="hidden" uglcw-role="textbox">
                        <input uglcw-model="houseName" uglcw-role="textbox" placeholder="名称">
                    </li>
                    <li>
                        <select uglcw-role="combobox" uglcw-model="status" placeholder="状态">
                            <option value="1" selected>正常</option>
                            <option value="2">移除</option>
                        </select>
                    </li>
                    <li>
                        <button class="k-info search" uglcw-role="button">搜索</button>
                    </li>
                </ul>
            </div>
        </div>
        <div class="layui-card">
            <div class="layui-card-body full">
                <div id="grid2" uglcw-role="grid"
                     uglcw-options="
                    checkbox: true,
                    criteria: '.criteria',
                    height: 350,
                    toolbar: kendo.template($('\\#toolbar').html()),
                    id:'id',
                    url: '${base}manager/stkHouse/Page',
                    pageable: true,
                    ">
                    <div data-field="houseName" uglcw-options="
                                            width:100,
                                            headerTemplate:  uglcw.util.template($('\\#header_edit_template').html())({title: '名称',field:'houseName'}),
                                            template:function(row){
                                                return uglcw.util.template($('\\#data_edit_template').html())({value:row.houseName, id:row.id, field:'houseName',callback:'changeBean'})
                                            }
                                            ">
                    </div>
                    <div data-field="kwArea" uglcw-options="width:120">库位面积</div>
                    <div data-field="oper" uglcw-options=" width:260,
                                 template: function(data){
                                    return kendo.template($('#product-list').html())({id: data.id, wareNames:$.map(data.wareList, function(item){return  item.wareNm;})});
                                 },

                                ">计划存放
                    </div>
                    <div data-field="kwVolume" uglcw-options="
                                            width:100,
                                            headerTemplate:  uglcw.util.template($('\\#header_edit_template').html())({title: '库位容量',field:'kwVolume'}),
                                            template:function(row){
                                                return uglcw.util.template($('\\#data_edit_template').html())({value:row.kwVolume, id:row.id, field:'kwVolume',callback:'changeBean'})
                                            }
                                            ">
                    </div>
                    <div data-field="createTime"
                         uglcw-options="width:140,template: '\\#= uglcw.util.toString(new Date(data.createTime+\'GMT+0800\'), \'yyyy-MM-dd HH:mm:ss\')#\\'">
                        创建时间
                    </div>
                    <div data-field="opt" uglcw-options="width:120,template: uglcw.util.template($('\\#opt-tpl').html())">
                        操作
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:toBack();" class="k-button k-button-icontext">
        <span class="k-iconk-i-close"></span>返回
    </a>
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:updateHouseStatus(1);" class="k-button k-button-icontext">
        <span class="k-icon k-i-checkmark"></span>恢复</a>
    <a role="button" href="javascript:updateHouseStatus(2);" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>移除</a>
</script>

<script type="text/x-uglcw-template" id="opt-tpl">
    <button class="k-button k-success" onclick="showQrCode(#= data.id#, '#=data.houseName#')">二维码</button>
</script>

<script id="product-list" type="text/x-kendo-template">
    <button style="padding: 0 5px 0px 2px;min-width: inherit;" onclick="addHouseWare(#= data.id#);"
            class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>
    </button>
    #if(data.wareNames.length>0){#
    <button style="padding: 0 8px 0px 2px;min-width: inherit;" onclick="javascript:delHouseWare(#=data.id#);"
            class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>
    </button>
    #}#

    <span class="product-list">#= data.wareNames.join(',')#</span>
</script>
<script id="kw_oper" type="text/x-uglcw-template">
    <button onclick="javascript:addHouse(#= data.id#);" class="k-button k-info">添加</button>
</script>
<script type="text/x-uglcw-template" id="addHouse_tpl">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6">添加库位数</label>
                    <div class="col-xs-16">
                        <input uglcw-role="numeric" uglcw-model="autoNumber" id="autoNumber" data-bind="value:autoNumber">
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<%--二维码--%>
<script type="text/x-uglcw-template" id="qrCode_tpl">
    <div class="layui-card">
        <div class="layui-card-body">
            <button class="downloadBtn" type="button" onclick="downloadImg('#=name#')">下载</button>
            <div id="qrcode"/>
        </div>
    </div>
    </div>
</script>
<%--二维码--%>
<script src="<%=basePath%>/resource/shop/mobile/js/qrcode.js" type="text/javascript"></script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        });
        uglcw.ui.loaded();
    })

    function add() {
        uglcw.ui.Modal.open({  //弹框当前页面div
            area: '500px',
            content: $('#addHouse_tpl').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var autoNumber = uglcw.ui.get("#autoNumber").value();
                if (!autoNumber || isNaN(autoNumber)) {
                    uglcw.ui.error('请输入正确数字');
                    return false;
                }
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/stkHouse/autoCreate',
                    type: 'post',
                    data: {number: autoNumber, stkId: stkId},
                    type: 'post',
                    async: false,
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.code == 200) {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid2').reload();
                            uglcw.ui.Modal.close();
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
            }
        });
    }


    function updateHouseStatus(status) {
        var selection = uglcw.ui.get('#grid2').selectedRow();
        if (selection) {
            if(status==2){
                var houseName = selection[0].houseName;
                if(houseName=='临时库位'){
                    uglcw.ui.info(houseName+",不能移除");
                    return;
                }
            }
            $.ajax({
                url: '${base}manager/stkHouse/updateHouseStatus',
                type: 'post',
                data: {id: selection[0].id, status: status},
                async: false,
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid2').reload();
                    } else {
                        uglcw.ui.error(response.message || '操作失败');
                        return;
                    }
                }
            })
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function remove() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm('确定删除所选仓库吗？', function () {
                $.ajax({
                    url: '${base}manager/stkHouse/delete',
                    type: 'post',
                    data: {
                        id: $.map(selection, function (row) {
                            return row.id
                        }).join(',')
                    },
                    success: function (response) {
                        if (response === '1') {
                            uglcw.ui.success('删除成功');
                            uglcw.ui.get('#grid').reload();
                        } else if (response === '-1') {
                            uglcw.ui.error('删除失败');
                        }
                    }
                })
            })

        }
    }

    //添加库位商品
    function addHouseWare(id) {
        var index = uglcw.ui.Modal.showGridSelector({
            btns: ['确定', '取消'],
            title: false,
            url: '${base}manager/stkHouseWare/queryNoneHouseWare',
            query: function (params) {
                params.status = 1;
            },
            checkbox: true,
            width: 700,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="wareNm">',
            columns: [
                {field: 'wareNm', title: '商品名称', width: 200, tooltip: true},
                {field: 'wareGg', title: '规格', width: 220, tooltip: true},
                {field: 'wareCode', title: '商品编码', width: 160},
            ],
            yes: function (nodes) {
                if (nodes && nodes.length > 0) {
                    var ids = $.map(nodes, function (node) {
                        return node.wareId;
                    });
                    callBackFunAddHouseWare(ids, id, index);
                }
                ;

            }
        })
    }

    //移除库位商品
    function delHouseWare(id) {
        var off = uglcw.ui.Modal.showGridSelector({
            btns: ['确定', '取消'],
            closable: false,
            title: false,
            url: '${base}manager/stkHouseWare/queryHouseWareByHouseId?id=' + id,
            query: function (params) {
                params.status = 1;
            },
            checkbox: true,
            width: 700,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="wareNm">',
            columns: [
                {field: 'wareNm', title: '商品名称', width: 200, tooltip: true},
                {field: 'wareGg', title: '规格', width: 220, tooltip: true},
                {field: 'wareCode', title: '商品编码', width: 160},
            ],
            yes: function (nodes) {
                if (nodes && nodes.length > 0) {
                    var ids = $.map(nodes, function (node) {
                        return node.wareId;
                    });
                    callBackFunQueryHouseWareByHouseId(ids, off);
                }
                ;

            }
        })
    }

    //添加库位商品的回调
    function callBackFunAddHouseWare(ids, id, index) {
        $.ajax({
            url: "${base}manager/stkHouseWare/batchAddHouseWare",
            data: {
                ids: ids.join(','),
                id: id
            },
            type: "post",
            success: function (response) {
                if (response.code == 200) {
                    uglcw.ui.success('操作成功');
                    uglcw.ui.Modal.close(index);
                    uglcw.ui.get('#grid2').reload();
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }

    //移除库位商品的回调
    function callBackFunQueryHouseWareByHouseId(ids, off) {
        $.ajax({
            url: "${base}/manager/stkHouseWare/batchRemoveHouseWare",
            data: {ids: ids.join(',')},
            type: "post",
            success: function (json) {
                if (json != "-1") {
                    uglcw.ui.success('移除成功');
                    uglcw.ui.Modal.close(off);
                    uglcw.ui.get('#grid2').reload();
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }

    function changeBean(value, field, id, fun) {
        var data = {};
        data.id = id;
        data.field = field;
        data.value = value;
        if (data.value == '') {
            uglcw.ui.toast("不能输入空值")
            return;
        }
        $.ajax({
            url: '${base}manager/stkHouse/update',
            data: data,
            type: 'post',
            async: false,
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp.state) {
                    uglcw.ui.success('操作成功');
                    callSuccessFun(value, field, id);
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })
    }

    //显示二维码
    function showQrCode(id, name) {
        uglcw.ui.Modal.open({
            content: uglcw.util.template($('#qrCode_tpl').html())({name: name}),
            btns: [],
            title: '二维码',
            area: '250px',
            shadeClose: true,
            success: function (container) {
                uglcw.ui.init($(container));
                var qrcode = new QRCode(document.getElementById("qrcode"), {
                    width: 200,
                    height: 200,
                    correctLevel: 3
                });
                qrcode.clear(); // 清除代码
                qrcode.makeCode(name);
            },
            yes: function (container) {
            }
        })
    }

    function downloadImg(name) {
        var url = $("#qrcode").find("img").attr("src"); // 获取图片地址
        var a = document.createElement('a');          // 创建一个a节点插入的document
        var event = new MouseEvent('click')           // 模拟鼠标click点击事件
        a.download = name + "二维码"                  // 设置a节点的download属性值
        a.href = url;                                 // 将图片的src赋值给a节点的href
        a.dispatchEvent(event)                        // 触发鼠标点击事件
    }


    //添加库位
    var stkId;
    var win;
    function addHouse(id) {
        stkId = id;
        var _productResize = function (c, type) {
            $(c).find('.layui-layer-content').height() - 10;
            var $grid = $(c).find('.uglcw-grid');
            if ($grid.length > 0) {
                uglcw.ui.get($grid).resize($(c).find('.layui-layer-content'), [70]);
            }
        }
         var win =  uglcw.ui.Modal.open({
            title:'库位列表',
            full: true,
            btns: [],
            area:['760px', '430px'],
            content: $('#add-tpl').html(),
            fullscreen: function (c) {
                _productResize(c, 1);
                var ti, tj;
                setTimeout(function () {
                    layer.close(ti);
                    layer.close(tj);
                }, 1500)
                $(c).find('.layui-layer-btn.layui-layer-btn-r').css('text-align', 'center');
            },
            restore: function (c) {
                setTimeout(function () {
                    _productResize(c, 0);
                }, 200)
                $(c).find('.layui-layer-btn.layui-layer-btn-r').css('text-align', 'right');
            },
            success: function (c) {

                $(c).find('[uglcw-model=stkId]').val(id);
                uglcw.ui.init($(c));
                $(c).find('.search').on('click', function () {    //弹框搜索
                    uglcw.ui.get($(c).find('.uglcw-grid')).reload();
                })
                $(c).kendoTooltip({   //提示表格数据
                    filter: '.product-list',
                    position: 'right',
                    content: function (e) {
                        return $(e.target).html();
                    }
                });
                var $grid = $(c).find('.uglcw-grid');
                var grid = uglcw.ui.get($grid);
                grid.on('dataBound', function () {
                    _productResize(c);
                })
                _productResize(c);
            }
        });

    }
    
    function  toBack() {
        uglcw.ui.Modal.close(win);
    }
</script>
</body>
</html>
