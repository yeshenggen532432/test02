<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 220px;">
            <div class="layui-card">
                <div class="layui-card-header">
                    商品分类
                </div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:[70]">
                    <div id="tree" uglcw-role="tree"
                         uglcw-options="
                        url:'manager/syswaretypes',
                        expandable:function(node){
                            return node.id == '0'
                        },
                        select: function(e){
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#wtype').value(node.id);
                            uglcw.ui.get('#grid').reload();
                        }
                    "
                    >
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query">
                        <li>
                            <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                            <input id="wtype" type="hidden" uglcw-model="wtype" uglcw-role="textbox">
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
                                <option value="1">启用</option>
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
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                            checkbox: true,
                            responsive:['.header', 30],
                            id:'id',
                            toolbar: uglcw.util.template($('#toolbar').html()),
                            url: '${base}manager/wares?wtype=${wtype}',
                            criteria: '.uglcw-query',
                            pageable: true
                    ">
                        <div data-field="wareCode" uglcw-options="width:120">商品编码</div>
                        <div data-field="wareNm" uglcw-options="width:140">商品名称</div>
                        <div data-field="py" uglcw-options="width:140">助记码</div>
                        <div data-field="waretypeNm" uglcw-options="width:80">所属分类</div>
                        <div data-field="brandNm" uglcw-options="width:120">所属品牌</div>
                        <div data-field="qualityDays" uglcw-options="width:80">保质期</div>
                        <div data-field="wareGg" uglcw-options="width:80">规格</div>
                        <div data-field="wareDw" uglcw-options="width:80">大单位</div>
                        <div data-field="packBarCode" uglcw-options="width:80">大单位条码</div>
                        <div data-field="beBarCode" uglcw-options="width:80">小单位</div>
                        <div data-field="sunitFront" uglcw-options="width:80">默认开单</div>
                        <div data-field="inPrice" uglcw-options="width:80">采购价</div>
                        <div data-field="wareDj" uglcw-options="width:80">批发价</div>
                        <div data-field="lsPrice" uglcw-options="width:80">大单位原价</div>
                        <div data-field="tranAmt" uglcw-options="width:80">运输费用</div>
                        <div data-field="tcAmt" uglcw-options="width:80,hidden:true">提成费用</div>
                        <div data-field="aliasName" uglcw-options="width:80">别名</div>
                        <div data-field="asnNo" uglcw-options="width:80">标识码</div>
                        <div data-field="fbtime" uglcw-options="width:80">发布时间</div>
                        <div data-field="status" uglcw-options="width:80">是否启用</div>
                        <div data-field="isCy" uglcw-options="width:80">是否常用</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toaddcustomer();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:getSelected();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-pencil"></span>修改
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toDel();">
        <span class="k-icon k-i-trash"></span>删除
    </a>
    <a role="button" href="javascript:updatekhTp();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-redo"></span>编辑
    </a>
    <a role="button" href="javascript:zryd();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-redo"></span>下载模板
    </a>
    <a role="button" href="javascript:showUpload();"
       class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-checkmark"></span>上传商品
    </a>

    <a role="button" class="k-button k-button-icontext"
       href="javascript:myexport();">
        <span class="k-icon k-i-image-export"></span>批量调整商品类别
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:setPrice();">
        <span class="k-icon k-i-settings"></span>批量调整开单单位
    </a>

</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload()
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {});
        })
        uglcw.ui.loaded()
    })

    function showUpload() {  //上传商品
        uglcw.ui.Modal.showUpload({
            url: '${base}manager/toUpProviderExcel',
            field: 'upFile',
            error: function () {
                console.log('error', arguments)
            },
            complete: function () {
                console.log('complete', arguments);
            },
            success: function (e) {
                if (e.response != '1') {
                    uglcw.ui.error(e.response);
                } else {
                    uglcw.ui.success('导入成功');
                    uglcw.ui.get('#grid').reload();
                }
            }
        })
    }
</script>
</body>
</html>
