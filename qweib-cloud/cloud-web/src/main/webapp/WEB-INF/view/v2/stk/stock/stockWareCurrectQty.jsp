<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>初始化库存</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称"/>
                </li>
                <li>
                    <tag:select2 placeholder="仓库" name="stkId" id="stkId" index='0' tableName="stk_storage"
                                 whereBlock="status=1 or status is null"
                                 onchange="reCorrectQty()" displayKey="id" displayValue="stk_name"/>
                </li>
                  <li style="width:80px; margin-top: 10px">小单位大于</li>
                <li>
                    <input uglcw-role="numeric" value="${config.maxEnd}" uglcw-options="spinners: false"
                           uglcw-mopdel="maxEnd">
                </li>

                    <li style="width: 90px; margin-top: 10px">归(<span style="color:red;">1</span>)处理</li>
                    <li style="width: 40px; margin-top: 10px">小于</li>

                <li>
                    <input uglcw-role="numeric" value="${config.minEnd}" uglcw-options="spinners: false"
                           uglcw-mopdel="maxEnd">
                </li>

                    <li style="width: 80px; margin-top: 10px">归(<span style="color:red;">0</span>)处理</li>

                <li style="width: 200px;">
                    <button class="k-button k-info" onclick="reCorrectQty()"><i class="k-icon k-i-calculator"></i>重新计算
                    </button>
                    <button class="k-button k-info" onclick="confirmCorrectQty()"><i class="k-icon k-i-check"></i>确定计算
                    </button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    url: '${base}manager/stockWareCurrectQty',
                    criteria: '.query',
                    ">
                <div data-field="stkName" uglcw-options="width:120,tooltip: true">仓库名称</div>
                <div data-field="wareNm" uglcw-options="width:120, tooltip: true, editable: false">商品名称</div>
                <div data-field="minUnitName" uglcw-options="width:90, editable: false">小单位'</div>
                <div data-field="qty" uglcw-options="width:100, editable: false">纠偏前数量</div>
                <div data-field="qtyEnd" uglcw-options="width:120, format: '{0:n2}'">纠偏后数量</div>
                <div data-field="disQty" uglcw-options="width:120, format: '{0:n2}'">纠偏差量</div>
                <div data-field="amt" uglcw-options="width:120, format: '{0:n2}'">发货金额</div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    });

    function reCorrectQty() {
        var data = uglcw.ui.bind('.form-horizontal');
        if (data.maxEnd >= 1 || data.minEnd >= 1) {
            return uglcw.ui.warning('纠偏参数值必须小于1');
        }
        uglcw.ui.get('#grid').reload();
    }

    function confirmCorrectQty() {
        var data = uglcw.ui.bind('.form-horizontal');
        if (data.maxEnd >= 1 || data.minEnd >= 1) {
            return uglcw.ui.warning('纠偏参数值必须小于1');
        }
        uglcw.ui.confirm('确定库存纠偏？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stockWareCurrectConfirmQty',
                type: 'post',
                data: data,
                success: function (resp) {
                    uglcw.ui.loaded();
                    if (resp.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

</script>
</body>
</html>
