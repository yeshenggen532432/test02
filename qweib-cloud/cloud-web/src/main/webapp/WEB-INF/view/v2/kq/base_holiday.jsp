<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
    <div class="layui-card">
        <div class="layui-card header">
            <div class="layui-card-body">
                <ul class="uglcw-query form-horizontal query">
                    <li>
                        <input uglcw-model="dayName" uglcw-role="textbox" placeholder="节假日名称">
                    </li>
                    <li>
                        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                         responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}/manager/kqholiday/queryHolidayPage',
                    criteria: '.query',
                    pageable: true,
                    checkbox: true
                    }">
                <div data-field="dayName" uglcw-options="width:'auto'">节假日名称</div>
                <div data-field="startDate" uglcw-options="width:'auto'">开始日期</div>
                <div data-field="endDate" uglcw-options="width:'auto'">结束日期</div>


            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toaddJxsjb();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:getSelected();">
        <span class="k-icon k-i-pencil"></span>修改
    </a>
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-delete"></span>删除</a>
</script>

<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="layui-card-body">
                <div class="form-horizontal" uglcw-role="validator" id="bind">
                    <div class="form-group">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="id" id="id">
                        <label class="control-label col-xs-8">节假日名称</label>
                        <div class="col-xs-14">
                            <input class="form-control" uglcw-role="textbox" uglcw-model="dayName"
                                   uglcw-validate="required">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-8">开始日期</label>
                        <div class="col-xs-14">
                            <input uglcw-model="startDate" uglcw-role="datepicker">
                        </div>

                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-8">结束日期</label>
                        <div class="col-xs-14">
                            <input uglcw-model="endDate" uglcw-role="datepicker">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置（清除搜索输入框数据）
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })


    function toaddJxsjb() {//添加客户等级
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#t').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    $.ajax({
                        url: '${base}/manager/kqholiday/saveHoliday',
                        data: uglcw.ui.bind(container),  //绑定值
                        type: 'post',
                        success: function (data) {
                            if (data == "1") {
                                uglcw.ui.success('保存成功')
                                uglcw.ui.get('#grid').reload();//刷新页面数据
                            } else {
                                uglcw.ui.error('失败');//错误提示
                                return;
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });
    }

    function getSelected() {//修改
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#t').html(),
                success: function (container) {
                    uglcw.ui.init($(container));//初始化
                    uglcw.ui.bind($(container).find('#bind'), selection[0]);//邦定数据
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        $.ajax({
                            url: '${base}/manager/kqholiday/saveHoliday',
                            data: uglcw.ui.bind(container),  //绑定值
                            type: 'post',
                            success: function (data) {
                                if (data == "1") {
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                } else {
                                    uglcw.ui.error('失败');//错误提示
                                    return;
                                }
                            }
                        })
                    } else {
                        uglcw.ui.error('失败');
                        return false;
                    }
                }
            });
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function toDel() {   //删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('您确认想要删除记录吗?', function () {
                $.ajax({
                    url: '${base}/manager/kqholiday/deleteHoliday',
                    data: {
                        ids: selection[0].id
                    },
                    type: 'post',
                    success: function (json) {
                        if (json.state) {
                            uglcw.ui.success('删除成功');
                            uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                        } else {
                            uglcw.ui.error('删除失败');
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要删除的数据！');
        }
    }
</script>
</body>
</html>
