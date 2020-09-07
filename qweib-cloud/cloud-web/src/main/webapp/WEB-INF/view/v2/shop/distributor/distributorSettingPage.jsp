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
                            <label class="control-label col-xs-4">一、分销申请是否开启：</label>
                            <div class="col-xs-4">
                                <ul uglcw-role="radio" uglcw-model="is_open" id="is_open"
                                    uglcw-value="${model.is_open==null?1:model.is_open}"
                                    uglcw-options='"layout":"horizontal","dataSource":[{"text":"是","value":"1"},{"text":"否","value":"0"}]'></ul>

                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-4">二、指定分销商品佣金：</label>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-4">1级佣金比例：</label>
                            <div class="col-xs-4">
                                <input id="first_scale" uglcw-role="numeric"
                                       maxlength="5" uglcw-options="min: 0, max: 99"
                                       uglcw-model="first_scale"
                                       value="${model.first_scale}">
                            </div>
                            <label class="col-xs-4">%</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">2级佣金比例：</label>
                            <div class="col-xs-4">
                                <input id="second_scale" uglcw-role="numeric"
                                       maxlength="5" uglcw-options="min: 0, max: 99"
                                       uglcw-model="second_scale"
                                       value="${model.second_scale}">
                            </div>
                            <label class="col-xs-4">%</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">3级佣金比例：</label>
                            <div class="col-xs-4">
                                <input id="third_scale" uglcw-role="numeric"
                                       maxlength="5" uglcw-options="min: 0, max: 99"
                                       uglcw-model="third_scale"
                                       value="${model.third_scale}">
                            </div>
                            <label class="col-xs-4">%</label>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-4">三、申请认证分销员是否审核：</label>
                            <div class="col-xs-4">
                                <ul uglcw-role="radio" uglcw-model="is_apply_audit" id="is_apply_audit"
                                    uglcw-value="${model.is_apply_audit}"
                                    uglcw-options='"layout":"horizontal","dataSource":[{"text":"是","value":"1"},{"text":"否","value":"0"}]'></ul>

                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">说明：</label>
                            <div class="col-xs-12">
                                <textarea id="content" uglcw-role="textbox" uglcw-model="content" rows="10"
                                          cols="50">${model.content}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">四、全店佣金（指定分销商品以外商品）：</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">1级佣金比例：</label>
                            <div class="col-xs-4">
                                <input id="first_store_scale" uglcw-role="numeric"
                                       maxlength="5" uglcw-options="min: 0, max: 99"
                                       uglcw-model="first_store_scale"
                                       value="${model.first_store_scale}">
                            </div>
                            <label class="col-xs-4">%</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">2级佣金比例：</label>
                            <div class="col-xs-4">
                                <input id="second_store_scale" uglcw-role="numeric"
                                       maxlength="5" uglcw-options="min: 0, max: 99"
                                       uglcw-model="second_store_scale"
                                       value="${model.second_store_scale}">
                            </div>
                            <label class="col-xs-4">%</label>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">3级佣金比例：</label>
                            <div class="col-xs-4">
                                <input id="third_store_scale" uglcw-role="numeric"
                                       maxlength="5" uglcw-options="min: 0, max: 99"
                                       uglcw-model="third_store_scale"
                                       value="${model.third_store_scale}">
                            </div>
                            <label class="col-xs-4">%</label>
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
