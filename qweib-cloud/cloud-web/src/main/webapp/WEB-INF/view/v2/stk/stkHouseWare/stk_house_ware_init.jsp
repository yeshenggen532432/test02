<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>库位商品操作</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .row-color-blue {
            color: blue;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul uglcw-role="buttongroup">
                <li>
                    <a  role="button" class="k-button k-button-icontext"
                       href="javascript:initData();">
                        <span class="k-icon k-i-search"></span>库存导入
                    </a>
                </li>
                <li>
                    <a role="button" class="k-button k-button-icontext"
                        href="javascript:clearData();">
                    <span class="k-icon "></span>清空库位
                </a>
                </li>
            </ul>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
</body>
</html>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    })
    function initData(){
        uglcw.ui.confirm('是否确定同步库存数据？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkHouseWare/initData',
                type: 'post',
                data: {},
                async: false,
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.info('同步库存成功！');
                    } else {
                        uglcw.ui.error(response.msg);
                    }
                }
            })
        });
    }

    function clearData(){
        uglcw.ui.confirm('是否确定清空库位数据？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkHouseWare/clearData',
                type: 'post',
                data: {},
                async: false,
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.info('库位数据清空成功！');
                    } else {
                        uglcw.ui.error('库位数据清空失败!');
                    }
                }
            })
        });
    }
</script>
