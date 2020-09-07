<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>新商品确认导入</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-header btn-group" style="height: 40px;">
                    <a role="button" class="k-button k-button-icontext"
                       href="javascript:confirmData();" id="savedrage">
                        <span class="k-icon k-i-save"></span>确定
                    </a>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid-advanced"
                         uglcw-options="
                            responsive: ['.header', 40],
                            editable: true,
                            autoAppendRow: false,
                            rowNumber: true,
                            lockable: false,
                            id:'id',
                            serverFiltering: false,

                    ">
                        <div data-field="wareNm" uglcw-options="width:120, tooltip: true">商品名称</div>
                        <div data-field="wareGg" uglcw-options="width:90">规格</div>
                        <div data-field="minStkQty" uglcw-options="width:90,hidden:true">账面数量(小)</div>
                        <div data-field="stkQty" uglcw-options="width:90,hidden:true">账面数量(大)</div>
                        <div data-field="qty"
                             uglcw-options="width:120,hidden:true">盘点数(大)
                        </div>
                        <div data-field="unitName" uglcw-options="width:50">大单位</div>
                        <div data-field="minQty"
                             uglcw-options="width:120,hidden:true">
                            盘点数(小)
                        </div>
                        <div data-field="minUnit" uglcw-options="width:50">小单位</div>
                        <div data-field="price" uglcw-options="width:100,  editable: true, schema:{type: 'number',decimals:10}">采购价</div>
                        <div data-field="hsNum" uglcw-options="width:50,editable: true, schema:{type: 'number',decimals:10}">大小换算数量</div>
                        <div data-field="productDate" uglcw-options="width: 100,hidden:true">生产日期
                        </div>
                        <div data-field="options" uglcw-options="width: 100, command:'destroy'">
                            操作
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
        loadData();
    });

    function confirmData() {
        var data = {};
        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 1) {
            return uglcw.ui.error('请选择商品');
        }
        data.wareStr = JSON.stringify(list);
        uglcw.ui.confirm("是否确定保存当前商品列表", function () {
            $.ajax({
                url: '${base}manager/saveWareNewData',
                type: 'post',
                data: data,
                success: function (response) {
                    if (response.state) {
                        var datas = response.list;
                        window.localStorage.removeItem("new_ware_key_datas");
                        window.localStorage.setItem("new_ware_key_datas", JSON.stringify(datas));
                        window.parent.appendNewWareData();
                    } else {
                        uglcw.ui.error(response.msg);
                    }
                }
            })


        })
    }

    function loadData(){
        var data=window.localStorage.getItem("new_ware_key_list");
        var json = JSON.parse(data);
        var list = json.wareStr;
        var datas = JSON.parse(list);
        uglcw.ui.get('#grid').bind(datas || []);
    }
</script>
</body>
</html>
