<%@ page language="java" pageEncoding="UTF-8" %>
<script src="${base}/static/uglcu/uglcw.vendor.js?v=20191228"></script>
<script src="${base}/static/uglcu/uglcw.ui.js?v=20200619"></script>
<script type="text/x-uglcw-template" id="_login-dialog">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6">用户名</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" uglcw-model="username" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">密码</label>
                    <div class="col-xs-18">
                        <input type="password" uglcw-role="textbox" uglcw-model="password" uglcw-validate="required">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script>
    $(window.document).ajaxSuccess(function (event, xhr, settings, data) {
        if (data) {
            if (data.code == 413) {
                uglcw.ui.notice({
                    error: 'warning',
                    title: '登录超时，请重新登录'
                });
                window.top.openLoginDialog();
            } else if (data.code === 410) {
                uglcw.ui.warning(data.message || '请勿重复提交');
            }
        }
    })
</script>
