<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>多规格商品属性</title>
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
    <div class="layui-card master">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                            responsive:['.header',40],
							id:'id',
							pageable: true,
                    		url: '${base}manager/wareAttribute',
                    		criteria: '.query',
                    	">
                <div data-field="groupName" uglcw-options="width:100">商品组名</div>
                <div data-field="wareNm" uglcw-options="width:100">所属商品</div>
                <div data-field="attribute" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_attribute').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.attribute, data: row, field:'attribute'})
                                }
                                ">
                </div>
            </div>
        </div>
    </div>
</div>
<script id="header_attribute" type="text/x-uglcw-template">
    <span onclick="javascript:operateAttribute('attribute');">商品属性✎</span>
</script>
<script id="val" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #

    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="textbox"
           style="height:25px;display:none" onchange="changeAttribute(this,#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>

</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        //ui:初始化
        uglcw.ui.init();

        uglcw.ui.loaded();
    });

    function operateAttribute(field) {
        var display = $("." + field + "_input").css('display');
        if (display == 'none') {
            $("." + field + "_input").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").hide();
            $("." + field + "_span").show();
        }
    }

    function changeAttribute(o, wareId) {
        $.ajax({
            url: "${base}manager/updateWareAttribute",
            type: "post",
            data: {
                wareId: wareId,
                val: o.value,
            },
            success: function (data) {
                if (data == '1') {
                    uglcw.ui.success("修改成功！")
                    uglcw.ui.get('#grid').reload();//刷新页面数据
                } else {
                    uglcw.ui.error("商品参数修改失败！");
                }
            }
        });
    }
</script>
</body>
</html>
