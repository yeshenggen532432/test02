<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户商品价格设置-客户列表</title>
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
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员">
                </li>
                <li>

                    <select uglcw-role="combobox" uglcw-model="priceSet" placeholder="价格设置">
                        <option value="">全部</option>
                        <option value="1" selected>已设置价格</option>
                        <option value="2">未设置价格</option>
                    </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li>
                    <div  style="width:380px">
                    <button id="clear" onclick="clearPrice();" uglcw-role="button" class="k-button  k-info">清空选中客户自定义设置的商品价格</button>
                    <input type="checkbox" uglcw-role="checkbox"
                           uglcw-options="type:'number'"
                           class="k-checkbox" id="clearAllChk"/>
                    <label  style="margin-top: 10px;" class="k-checkbox-label" for="clearAllChk">全部</label>
                    </div>
                </li>
                <li> </li>
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
							checkbox: true,
                    		url: '${base}manager/customerPage',
                    		criteria: '.query',
                    	">
                <div data-field="khCode" uglcw-options="width:80">客户编码</div>
                <div data-field="khNm" uglcw-options="width:100">客户名称</div>
                <div data-field="oper" uglcw-options="width:120, template: uglcw.util.template($('#oper').html())">操作</div>
                <div data-field="linkman" uglcw-options="width:100">负责人</div>
                <div data-field="tel" uglcw-options="width:120">负责人电话</div>
                <div data-field="mobile" uglcw-options="width:120">负责人手机</div>
                <div data-field="address" uglcw-options="width:200">地址</div>
                <div data-field="qdtpNm" uglcw-options="width:100">客户类型</div>
                <div data-field="memberNm" uglcw-options="width:100">业务员</div>
                <div data-field="memberMobile" uglcw-options="width:120">业务员手机号</div>
                <div data-field="longitude" uglcw-options="width:100">经度</div>
                <div data-field="latitude" uglcw-options="width:100">纬度</div>
            </div>
        </div>
    </div>
</div>

<%--操作--%>
<script id="oper" type="text/x-uglcw-template">
    <a href="javascript:setWarePrice(#= data.id#,'#=data.khNm#');" style="color: \\#3343a4;font-size: 12px;">设置商品价格<a/>
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
    function setWarePrice(id, name) {
        uglcw.ui.openTab(name + "_设置商品价格", "${base}manager/toCustomerPriceSetWareTree?_sticky=v2&customerId=" + id);
    }

    function clearPrice() {
        var checked = uglcw.ui.get('#clearAllChk').value();
        if (checked) {
                uglcw.ui.confirm('是否确定清空所有客户自定义设置的商品价格？', function () {
                    loadData("");
                })
        }else{
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (selection && selection.length > 0) {
                var ids =  $.map(selection, function (row) {
                    return row.id
                }).join(',');
                uglcw.ui.confirm('是否确定清空选中客户自定义设置的商品价格？', function () {
                    loadData(ids);
                })
            }else{
                uglcw.ui.info("请选择客户!");
            }
        }


        // var selection = uglcw.ui.get('#grid').selectedRow();
        // if (selection && selection.length > 0) {
        //     var ids =  $.map(selection, function (row) {
        //         return row.id
        //     }).join(',');
        //     uglcw.ui.confirm('是否确定清空选中客户价格？', function () {
        //         loadData(ids);
        //     })
        // } else {
        //     uglcw.ui.confirm('您未选中客户，是否确定清空所有客户价格？', function () {
        //     loadData("");
        //     })
        // }
    }

    function loadData(customerIds){
        var params={
            customerIds:customerIds
        };
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/deleteCustomerPriceByIds',
            type: 'post',
            data: params,
            async: false,
            success: function (response) {
                uglcw.ui.loaded();
                if (response.state) {
                    uglcw.ui.info('操作成功');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error('更新失败');
                }
            }
        })
    }

</script>
</body>
</html>
