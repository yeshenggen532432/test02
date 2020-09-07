<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>分销基础设置</title>

    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <div class="form-horizontal" uglcw-role="validator" novalidate id="bind">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="name" id="name" value="${name}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-4">分销功能是否开启：</label>
                            <div class="col-xs-4">
                                <ul uglcw-role="radio" uglcw-model="is_open" id="is_open"
                                    uglcw-value="${model.is_open}"
                                    uglcw-options='"layout":"horizontal","dataSource":[{"text":"是","value":"1"},{"text":"否","value":"0"}]'></ul>

                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">申请认证分销员是否审核：</label>
                            <div class="col-xs-4">
                                <ul uglcw-role="radio" uglcw-model="is_apply_audit" id="is_apply_audit"
                                    uglcw-value="0"
                                    uglcw-options='"layout":"horizontal","dataSource":[{"text":"否","value":"0"}]'></ul>

                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">说明：</label>
                            <div class="col-xs-4">
                                 <textarea uglcw-role="textbox" uglcw-model="content" id="content"
                                           uglcw-validate="required" maxlength="600" uglcw-options="min: 1, max: 600"
                                           class="textarea" style="width:380px;
                                                                            height:184px;
                                                                            resize:none;
                                                                            align:center;
                                                                            margin-left:15px;
                                                                            margin-top: 20px;">${model.content}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="control-label col-xs-8">
                                <button uglcw-role="button" class="k-success" onclick="save();">保存</button>
                            </div>
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
        uglcw.ui.loaded()
    })

    function save() {
        $.ajax({
            url: '${base}/manager/shopSetting/edit',
            data: uglcw.ui.bind($("#bind")),  //绑定值
            type: 'post',
            success: function (data) {
                if (data.success) {
                    uglcw.ui.success('修改成功');
                    setTimeout(function () {
                        uglcw.ui.reload();
                    }, 1000)
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })
    }

</script>
</body>
</html>
