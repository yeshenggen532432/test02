<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户类型商品价格设置-客户类型列表</title>
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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="qdtpNm" uglcw-role="textbox" placeholder="客户类型名称">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li style="width:275px !important; padding-top: 5px;">
                    注:商品原价(零售价)*销售折扣率=对应客户销售价
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
							pageable: true,
                    		url: '${base}manager/toQdtypePage',
                    		criteria: '.query',
                    	">
                <div data-field="coding" uglcw-options="width:100">编码</div>
                <div data-field="qdtpNm" uglcw-options="width:100">客户类型名称</div>
                <div data-field="rate" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_rate').html()),
								template:function(row){
									return uglcw.util.template($('#rate_tmplate').html())({val:row.rate, data: row, field:'rate'})
								}
								">销售折扣率(%)</div>
                <div data-field="oper" uglcw-options="width:200, template: uglcw.util.template($('#oper').html())">操作</div>
            </div>
        </div>
    </div>
</div>

<%--操作--%>
<script id="oper" type="text/x-uglcw-template">
    <a href="javascript:setWareTypeRate(#= data.id#,'#=data.qdtpNm#');" style="color: \\#3343a4;font-size: 12px;">设置商品类别价格折扣率<a/>&nbsp;|
        <a href="javascript:setWarePrice(#= data.id#,'#=data.qdtpNm#');" style="color: \\#3343a4;font-size: 12px;">设置商品价格<a/>&nbsp;|
            <a href="javascript:showCustomers(#= data.id#,'#=data.qdtpNm#');" style="color: \\#3343a4;font-size: 12px;">客户信息列表<a/>
                <%--<button onclick="javascript:setWarePrice(#= data.id#,'#=data.khdjNm#');" class="k-button k-info">设置商品价格</button>--%>
                <%--<button onclick="javascript:showCustomers(#= data.id#,'#=data.khdjNm#');" class="k-button k-info">客户信息列表</button>--%>
</script>
<script id="header_rate" type="text/x-uglcw-template">
    <span onclick="javascript:operate('rate');">销售折扣率%✎</span>
</script>
<script id="rate_tmplate" type="text/x-uglcw-template">
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <div style="display: inline-flex">
        <div style="display: none">
            <input class="#=field#_input" id="#=field#_input_#= data.id #" name="#=field#_input" uglcw-role="numeric"
                   uglcw-options="min:0, max: 1000" style="height:25px;width: 60px"
                   onchange="changeRate(this,'#= field #',#= data.id #)" value='#= val #'>
        </div>
        <span class="#=field#_span" id="#=field#_span_#= data.id #">#= val #</span>
        <span class="#=field#_org_rate" id="#=field#_org" style='color:green'></span>
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
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })


    //===============================================================================================

    function setWareTypeRate(id, name) {
        uglcw.ui.openTab(name + "_设置商品类别折扣率", "${base}manager/customertyperatewaretype?_sticky=v2&relaId=" + id);
    }


    function setWarePrice(id, name) {
        uglcw.ui.openTab(name + "_设置商品价格", "${base}manager/toCustomerTypeSetWareTree?_sticky=v2&relaId=" + id);
    }

    function showCustomers(id, name) {
        uglcw.ui.openTab(name + "_客户信息列表", "${base}manager/toCustomerTypePage?_sticky=v2&qdtpNm=" + name);
    }

    function changeRate(o, field,id) {
        if (isNaN(o.value)) {
            uglcw.ui.toast("请输入数字")
            return;
        }
        $.ajax({
            url: "${base}manager/updateQdTypeRate",
            type: "post",
            data: "id="+id+"&rate=" + o.value + "&field=" + field,
            success: function (data) {
                if (data == '1') {
                    uglcw.ui.info('更新成功!');
                    $("#" + field + "_span_"+id).text(o.value);
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }

    function operate(field) {
        var display = $("." + field + "_input").closest("div").css('display');
        if (display == 'none') {
            $("." + field + "_input").closest("div").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").closest("div").hide();
            $("." + field + "_span").show();
        }
    }
</script>
</body>
</html>
