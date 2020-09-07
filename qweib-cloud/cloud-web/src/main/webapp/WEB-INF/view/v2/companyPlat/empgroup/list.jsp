<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
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
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input uglcw-model="groupNm" uglcw-role="textbox" placeholder="圈名称">
                        </li>
                        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </ul>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                        checkbox:'true' ,
                    responsive:['.header',40],
                    id:'id',
                     toolbar: kendo.template($('#toolbar').html()),
                    url: 'manager/empgroupPage',
                    criteria: '.form-horizontal',
                    pageable: true,

                    }">
                        <div data-field="groupNm" uglcw-options="width:240">圈名称</div>
                        <div data-field="groupDesc"
                             uglcw-options="width:275, tooltip: true,
                             template: '#= data.groupDesc ? data.groupDesc: \'-\'#'">圈介绍
                        </div>
                        <div data-field="memberNm" uglcw-options="{width:240}">创建人</div>
                        <div data-field="creatime" uglcw-options="{width:240}">创建时间</div>
                        <div data-field="groupNum" uglcw-options="{width:240}">总人数</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-trash"></span>删除
    </a>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


    function toDel() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('是否删除?', function () {
                $.ajax({
                    url: '${base}/manager/delempgroup',
                    data: {
                        ids: $.map(selection, function (row) {  //选中多行数据删除
                            return row.groupId
                        }).join(',')
                    },
                    type: 'post',
                    success: function (json) {
                        if (json) {
                            if (json == 1) {
                                uglcw.ui.success("删除成功");
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            }
                        } else {
                            uglcw.ui.error("删除失败");//错误提示
                            return;
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择行！');
        }

    }
</script>
</body>
</html>
