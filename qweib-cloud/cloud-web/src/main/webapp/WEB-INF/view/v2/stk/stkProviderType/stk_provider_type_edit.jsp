<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>

</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <div class="form-horizontal" uglcw-role="validator" novalidate>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${vo.id}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">名称</label>
                            <div class="col-xs-6">
                                <input id="textbox" uglcw-role="textbox" uglcw-model="name" value="${vo.name}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">备注</label>
                            <div class="col-xs-6">
                                <textarea id="remark" uglcw-role="textbox" uglcw-model="remark">${vo.remark}</textarea>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="control-label col-xs-5">
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
        uglcw.ui.loaded();

    })

    function save() {
        $.ajax({
            url: '${base}manager/stkProviderType/save',
            data: uglcw.ui.bind('.form-horizontal'),  //绑定值
            success: function (state) {
                if (state) {
                    uglcw.ui.success("保存成功")
                    setTimeout(function(){
                        toback();
                        uglcw.ui.closeCurrentTab();
                    },1000)

                } else {
                    uglcw.ui.error('失败');//错误提示
                    return;
                }
            }
        })
    }

    function toback() {
        location.href = "${base}/manager/stkProviderType/toPage";
    }

</script>
</body>
</html>
