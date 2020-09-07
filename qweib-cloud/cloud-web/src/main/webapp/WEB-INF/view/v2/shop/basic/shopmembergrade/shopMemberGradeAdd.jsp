<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcs/lib/extend/formSelects-v4.css" media="all">
</head>
<body>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form" lay-filter="" style="width: 80%;">
            <div class="layui-form-item">
                <input type="hidden" name="id" id="id" value="${model.id}"/>
                <label class="layui-form-label">等级名称:</label>
                <div class="layui-input-inline">
                    <input type="text" name="gradeName" lay-verify="required" placeholder="请输入等级名称" autocomplete="off"
                           value="${model.gradeName}" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">等级级别:</label>
                <div class="layui-input-inline">
                    <input type="text" name="gradeNo" lay-verify="required" placeholder="请输入(1~100之内的整数)" autocomplete="off"
                           value="${model.gradeNo}" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">线下支付:</label>
                <div >
                    <input type="radio" name="isXxzf" value="" title="无">
                    <input type="radio" name="isXxzf" value="0" title="不显示" <c:if test="${model.isXxzf eq 0}">checked </c:if> >
                    <input type="radio" name="isXxzf" value="1" title="显示"  <c:if test="${model.isXxzf eq 1}">checked </c:if> >
                </div>
                <span style="color:#FF5722;font-size: 12px">(备注:会员下单选择支付方式是否显示“线下支付”)</span>
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
    var dataTp = '${dataTp}';
    layui.config({
        base: '/static/uglcs/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'form', 'formSelects'], function () {
        var form = layui.form
        var $ = layui.$, layer = parent.layer === undefined ? layui.layer : top.layer;

        form.on('submit(save)', function (data) {
            var index = top.layer.msg('数据提交中，请稍候', {icon: 16, time: false, shade: 0.8});
            $.ajax({
                type: 'post',
                url: 'manager/shopMemberGrade/update',
                data: data.field,
                success: function (res) {
                    top.layer.close(index)
                    if (res == '1') {
                        top.layer.msg('添加成功')
                        setTimeout(function () {
                            parent.layer.closeAll();
                            parent.location.reload();
                        }, 1500)

                    } else if (res == '2') {
                        top.layer.msg('修改成功')
                        setTimeout(function () {
                            parent.layer.closeAll();
                            parent.location.reload();
                        }, 1500)
                    } else if (res == '3') {
                        top.layer.msg('会员等级名称已存在')
                    } else {
                        top.layer.msg('操作失败')
                    }
                },
                error: function () {
                    top.layer.close(index)
                }
            })
        })

        $('#cancel').on('click', function () {
            parent.layer.closeAll();
        })
    })
    ;


</script>
</body>
</html>
