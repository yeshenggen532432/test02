<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员收藏</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .xxzf-more {
            font-size: 8px;
            color: red;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <input uglcw-role="textbox" uglcw-model="putOn" type="hidden" value="1">
                <li>
                    <input uglcw-model="memNm" uglcw-role="textbox" placeholder="会员名称">
                </li>
                <li>
                    <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
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
                           <c:if test="${! empty shopMemberId}"> toolbar: kendo.template($('#toolbar').html()),</c:if>
						    responsive:['.header',40],
							id:'id',
							pageable: true,
							checkbox:true,
                    		url: '${base}manager/shopWareFavorite/page?hyId=${shopMemberId}',
                    		criteria: '.query',
                    	">
                <div data-field="memNm" uglcw-options="width:100">会员名称</div>
                <div data-field="createTimeStr" uglcw-options="width:100">收藏日期</div>
                <div data-field="wareNm" uglcw-options="width:100">商品名称</div>
                <div data-field="wareGg" uglcw-options="width:100">规格</div>
                <%--<div data-field="wareDj" uglcw-options="width:100">价格</div>--%>
                <%--<div data-field="_picture" uglcw-options="width:100,template: uglcw.util.template($('#status').html())">图片</div>--%>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:openWindow();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:todel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>移除
    </a>
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

    //选择商品加入模版或所有商品对应的运费模版
    function openWindow() {
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                url: '${base}manager/shopWareNewType/shopWaretypesExists',
                lazy: false,
                model: 'waretype',
                id: 'id',
                expandable: function (node) {
                    return node.id == 0;
                },
                loadFilter: function (response) {
                    $(response).each(function (index, item) {
                        if (item.text == '根节点') {
                            item.text = '商品分类'
                        }
                    })
                    return response;
                },
            },
            title: "选择商品",
            width: 900,
            id: 'wareId',
            pageable: true,
            url: 'manager/shopWareFavorite/shopSelectWareData?shopMemberId=${shopMemberId}',
            query: function (params) {
                //params.stkId = uglcw.ui.get('#stkId').value()
            },
            persistSelection: false,
            checkbox: true,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
            columns: [
                {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
                {field: 'wareNm', title: '商品名称', width: 250},
                {field: 'wareDw', title: '大单位', width: 120},
                {field: 'minUnit', title: '小单位', width: 120}
            ],
            yes: addWare
        })
    }


    //更新运费模版
    function addWare(data) {
        if (!data || data.length == 0) {
            uglcw.ui.toast("请勾选您要操作的行！")
            return;
        }
        var ids = "";
        $(data).each(function (i, item) {
            if (ids != "") {
                ids += "," + item.wareId;
            } else {
                ids = item.wareId;
            }
        })
        uglcw.ui.loading();
        //uglcw.ui.confirm("是否确认加入",function(){
        $.ajax({
            url: "${base}/manager/shopWareFavorite/add?shopMemberId=${shopMemberId}",
            data: {"wareIds": ids},
            type: "post",
            success: function (data) {
                uglcw.ui.loaded();
                if (data.state) {
                    uglcw.ui.success('加入成功');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error('加入失败！');
                }
                return false;
            }
        });
        //});
    }

    //删除
    function todel() {
        var ids = "";
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            $(selection).each(function (idx, item) {
                if (ids != "") {
                    ids += "," + item.wareId;
                } else {
                    ids = item.wareId;
                }
            })
        } else {
            uglcw.ui.toast("请勾选你要操作的行！");
            return false;
        }
        uglcw.ui.confirm("是否要移出选中商品吗?", function () {
            $.ajax({
                url: "manager/shopWareFavorite/del?shopMemberId=${shopMemberId}",
                data: "wareIds=" + ids,
                type: "post",
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.toast("移除成功");
                        //uglcw.ui.get('#grid').k().dataSource.read();
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error("移除失败");
                    }
                }
            });
        });
    }

</script>
</body>
</html>
