<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcs/lib/extend/formSelects-v4.css" media="all">
</head>
<body>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form layui-form-wd120" lay-filter="" style="width: 80%;">
            <div class="layui-form-item">
                <input type="hidden" name="id" value="${day.id}"/>
                <label class="layui-form-label">节假日名称</label>
                <div class="layui-input-inline">
                    <input type="text" name="dayName" lay-verify="required" autocomplete="off"
                           value="${day.dayName}"
                           class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">开始日期</label>
                <div class="layui-input-inline">
                    <input type="text" name="startDate" lay-verify="required"
                           autocomplete="off"
                           value="${day.startDate}" class="layui-input qweib-date">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">结束日期</label>
                <div class="layui-input-inline">
                    <input type="text" name="endDate" lay-verify="required"
                           autocomplete="off"
                           value="${day.endDate}" class="layui-input" id="edXb">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label"></label>
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-sm" lay-submit lay-filter="save">保存</button>
                    <button id="cancel" class="layui-btn layui-btn-sm layui-btn-primary">取消</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${base}/static/uglcs/layui/layui.js"></script>

<script>
    var $;
    var dataTp = '${dataTp}';
    layui.config({
        base: '/static/uglcs/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'form', 'formSelects', 'laydate'], function () {
        var form = layui.form
        var formSelects = layui.formSelects;
        $ = layui.$, layer = parent.layer === undefined ? layui.layer : top.layer;
        var laydate = layui.laydate;
        laydate.render({
            elem: '.qweib-date',
            format: 'yyyy-MM-dd'
        })
        laydate.render({
            elem: '#edXb',
            format: 'yyyy-MM-dd'
        })

        form.on('submit(save)', function (formData) {
            console.log(formData)
            $.ajax({
                url: '${base}/manager/kqholiday/saveHoliday',
                type: 'post',
                data: formData.field,
                success: function (response) {
                    if (response == '1') {
                        layer.msg('添加成功');
                        setTimeout(function () {
                            parent.layer.closeAll();
                            parent.location.reload();
                        }, 1500)
                    } else {
                        layer.msg('操作失败');

                    }
                }
            })
        })

        $('#cancel').on('click', function () {
            parent.layer.closeAll();
        })
    });
</script>
</body>
</html>

