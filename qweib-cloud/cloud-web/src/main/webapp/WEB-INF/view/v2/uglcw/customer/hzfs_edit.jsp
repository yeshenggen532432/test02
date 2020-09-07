<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>

</head>
<body>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator" novalidate>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${hzfs.id}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">合作方式名称</label>
                            <div class="col-xs-4">
                                <input id="textbox" uglcw-role="textbox" uglcw-model="hzfsNm" value="${hzfs.hzfsNm}">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="control-label col-xs-6">
                                <button uglcw-role="button" class="k-success" onclick="toSubmit();">保存</button>
                                <button uglcw-role="button" class="k-default" onclick="toback();">取消</button>
                            </div>
                        </div>

                    </form>
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

    function toSubmit() {
        $.ajax({
            url: '${base}/manager/saveHzfs',
            type: 'post',
          /*  data: uglcw.ui.bind('.form-horizontal'),  //绑定值*/
            dataType: 'json',
            success: function (data) {
                if (data == '1') {
                    uglcw.ui.success('保存成功');
                    toback();
                } else {
                    uglcw.ui.error('删除失败');
                }
            }
        })
    }
    function toback() {
        top.layui.index.openTabsPage('${base}/manager/toCustomerHzfs');
    }
</script>
</body>
</html>
