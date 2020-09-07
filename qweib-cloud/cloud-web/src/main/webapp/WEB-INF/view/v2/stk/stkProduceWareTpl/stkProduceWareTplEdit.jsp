<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>生产材料标准配置表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">

    <div class="layui-card">
        <div class="layui-card-body full">
            <input type="hidden" uglcw-role="textbox" uglcw-model="bizType" value="${bizType}"/>
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                  		  toolbar: uglcw.util.template($('#toolbar').html()),
                    	">
                <div data-field="relaWareNm" uglcw-options="width: 150">主产品</div>
                <div data-field="wareCode" uglcw-options="width: 150">原料编号</div>
                <div data-field="wareNm" uglcw-options="width: 150">原料名称</div>
                <div data-field="wareGg" uglcw-options="width: 150">原料规格</div>
                <div data-field="qty" uglcw-options="width: 150">配比数量</div>
                <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加原料
    </a>
    <a role="button" href="javascript:save();" class="k-button k-button-icontext">
        <span class="k-icon k-i-save"></span>保存
    </a>
</script>
<script>

    $(function () {
        uglcw.ui.init();
        var data = ${fns:toJson(itemList)};
        uglcw.ui.get('#grid').bind(data);
        resize();
        $(window).resize(resize);
        uglcw.ui.loaded()
    })

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 40;
            var height = $(window).height() - padding;
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

    function refresh() {
        uglcw.ui.get('#grid').reload();
    }

    function add() {
        <tag:product-selector query="onQuery" callback="onProductSelect"/>
    }

    function onQuery(params) {
        params.stkId = 0;
        return params
    }

    function onProductSelect(selection) {
        $.map(selection, function (item) {

        })
        uglcw.ui.get('#grid').addRow(selection);
    }

    function save() {
        var data = uglcw.ui.get('#grid').bind();
        if (!data || data.length < 1) {
            return uglcw.ui.error('请添加明细！');
        }
        var param = uglcw.ui.bind();
        $(data).each(function (idx, item) {
            $.map(item, function (v, k) {
                param['itemList[' + idx + '].k'] = v;
            })
        })

        uglcw.ui.confirm('保存后将不能修改，是否确定保存？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkProduceWareTpl/save',
                type: 'post',
                dataType: 'json',
                data: param,
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success(response.msg);
                        setTimeout(function () {
                            uglcw.ui.reload();
                        }, 1000);
                    } else {
                        uglcw.ui.error('保存失败');
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
