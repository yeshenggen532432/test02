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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="packBarCode" placeholder="单位条码">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status">
                        <option value="">全部</option>
                        <option value="1" selected>启用</option>
                        <option value="2">不启用</option>
                    </select>
                </li>
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="0" id="isType">
                    <input uglcw-role="gridselector" uglcw-model="wtypename,wtype" id="wtype" placeholder="资产类型"
                           uglcw-options="
                           value:'库存商品类',
                           click: function(){
                                    waretype()
                           }
                    ">
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
                    responsive: ['.header', 40],
                    id:'id',
                    url: '${base}manager/waresSpecPage',
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="wareNm" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_wareNm').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.wareNm, data: row, field:'wareNm'})
                                }
                                ">
                </div>
                <div data-field="wareGg" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_wareGg').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.wareGg, data: row, field:'wareGg'})
                                }
                                ">
                </div>
                <div data-field="minWareGg" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_minWareGg').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.minWareGg, data: row, field:'minWareGg'})
                                }
                                ">
                </div>
                <div data-field="wareDw" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_wareDw').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.wareDw, data: row, field:'wareDw'})
                                }
                                ">
                </div>
                <div data-field="minUnit" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_minUnit').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.minUnit, data: row, field:'minUnit'})
                                }
                                ">
                </div>
                <div data-field="sunitFront"
                     uglcw-options="width:120, template: uglcw.util.template($('#billing').html())">默认开单
                </div>
                <div data-field="sUnit" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_hsNum').html()),
                                template:function(row){
                                    return uglcw.util.template($('#price').html())({val:row.sUnit, data: row, field:'sUnit'})
                                }
                                ">
                </div>
                <div data-field="packBarCode" uglcw-options="width:160">大单位条码</div>
                <div data-field="beBarCode" uglcw-options="width:160">小单位条码</div>

            </div>
        </div>
    </div>
</div>
<script id="header_wareNm" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('wareNm');">商品名称✎</span>
</script>
<script id="header_wareGg" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('wareGg');">规格(大)✎</span>
</script>
<script id="header_minWareGg" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minWareGg');">规格(小)✎</span>
</script>
<script id="header_wareDw" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('wareDw');">大单位✎</span>
</script>
<script id="header_minUnit" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minUnit');">小单位✎</span>
</script>
<script id="header_hsNum" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('sUnit');">大小单位比例换算✎</span>
</script>

<script id="price" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #

    <span>#= data.bUnit #</span>:<input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric"
                                        uglcw-validate="number"
                                        style="height:25px;width:55%;display:none"
                                        onchange="changePrice(this, 0,'#= field #',#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= data.sUnit #</span>

</script>

<%--<script id="hsNum" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #

    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric" uglcw-validate="number"
           style="height:25px;display:none" onchange="changePrice(this, 0,'#= field #',#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">"1:#= data.hsNum #"</span>

</script>--%>
<script id="val" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #

    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="textbox"
           style="height:25px;display:none" onchange="changePrice(this, 1,'#= field #',#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>

</script>
<script type="text/x-kendo-template" id="billing">
    <%-- #if(data.){#
     <span style="color:red;">小单位</span>
     #}else{#
     <span>大单位</span>
     #}#--%>
    # if(data.sunitFront =='1'){ #
    <button class="k-button k-success" onclick="updateSunitFront (#= data.wareId#, 2)">小单位</button>
    # }else { #
    <button class="k-button k-error" onclick="updateSunitFront(#= data.wareId#, 1)">大单位</button>
    # } #
</script>

<script id="product-type-selector-template" type="text/uglcw-template">
    <div class="uglcw-selector-container">
        <div style="line-height: 30px">
            已选:
            <button style="display: none;" id="_type_name" class="k-button k-info ghost"></button>
        </div>
        <div style="padding: 2px;height: 344px;">
            <input type="hidden" uglcw-role="textbox" id="_type_id">
            <input type="hidden" uglcw-role="textbox" id="_isType">
            <input type="hidden" uglcw-role="textbox" id="wtypename">
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
                                         item.text='库存商品类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(0);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
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
                                         item.text='原辅材料类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(1);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
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
                                         item.text='低值易耗品类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(2);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
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
                                         item.text='固定资产类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(3);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();

                                }
                            ">
                    </div>
                </li>
            </ul>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {isType: '', wtypename: '', wtype: ''});
        });
        $('#wtype').on('change', function () {
            if(!uglcw.ui.get('#wtype').value()){
                uglcw.ui.bind('.form-horizontal', {isType: ''})  //清空当前id为wtype搜索框内容
            }
        })

        uglcw.ui.loaded();
    });


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

    function changePrice(el, type, field, wareId) {
        var data = {field: field, id: wareId};
        var value = $(el).val();
        if (type == 0) {
            data.price = value
        } else {
            data.val = value
        }
        $.ajax({
            url: "${base}manager/updateWareSpec",
            type: "post",
            data: data,
            success: function (data) {
                if (data == '1') {
                    $("#" + field + "_span_" + wareId).text(value);
                } else {
                    uglcw.ui.toast("保存失败");
                }
            }
        });
    }

    function updateSunitFront(id, sunitFront) {
        $.ajax({
            url: '${base}manager/updateWareSpecsunitFront',
            type: 'post',
            data: {id: id, sunitFront: sunitFront},
            success: function (response) {
                if (response == '1') {
                    uglcw.ui.success("操作成功");
                    uglcw.ui.get('#grid').reload();//刷新页面

                } else {
                    uglcw.ui.error('失败');
                    return;
                }
            }
        })
    }

    //资产类型
    function waretype() {
        var i = uglcw.ui.Modal.open({
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
                uglcw.ui.get("#isType").value(uglcw.ui.get($(c).find('#_isType')).value());
                uglcw.ui.get("#wtype").value(uglcw.ui.get($(c).find('#wtypename')).value());
                uglcw.ui.get("#wtype").text(uglcw.ui.get($(c).find('#_type_id')).value());
                uglcw.ui.Modal.close(i);
                return false;

            }

        })


    }

</script>
</body>
</html>
