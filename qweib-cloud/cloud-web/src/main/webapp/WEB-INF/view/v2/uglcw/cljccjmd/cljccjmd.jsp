<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <div class="form-horizontal" uglcw-role="validator" novalidate id="inventory_settings">
                        <span style="font-size: 14px;color: blue; text-decoration: underline;">库存模板设置</span>
                        <c:forEach items="${list}" var="list" varStatus="s">
                            <input type="hidden" uglcw-model="cljccjMdLs[${s.count-1}].id" uglcw-role="textbox" value="${list.id}"/>
                            <div class="form-group">
                                <label style="color: red" class="control-label col-xs-3">名称${s.count-1}</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="textbox" class="reg_input"
                                           uglcw-model="cljccjMdLs[${s.count-1}].mdNm" value="${list.mdNm}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-xs-3">货架排面数</label>
                                <div class="col-xs-4">
                                    <ul uglcw-role="radio"
                                         uglcw-options='"layout":"horizontal","dataSource":[{"text":"显示","value":"1"},{"text":"不显示","value":"2"}] '
                                         uglcw-model="cljccjMdLs[${s.count-1}].isHjpms" uglcw-value="${list.isHjpms}">
                                    </ul>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-xs-3">端架排面数</label>
                                <div class="col-xs-4">
                                    <ul uglcw-role="radio"
                                         uglcw-options='"layout":"horizontal","dataSource":[{"text":"显示","value":"1"},{"text":"不显示","value":"2"}]'
                                         uglcw-model="cljccjMdLs[${s.count-1}].isDjpms" uglcw-value="${list.isDjpms}" >
                                    </ul>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-xs-3">收银台围栏</label>
                                <div class="col-xs-4">
                                    <ul uglcw-role="radio"
                                         uglcw-options='"layout":"horizontal","dataSource":[{"text":"显示","value":"1"},{"text":"不显示","value":"2"}]'
                                         uglcw-model="cljccjMdLs[${s.count-1}].isSytwl" uglcw-value="${list.isSytwl}">
                                    </ul>
                                </div>
                            </div>


                            <div class="form-group">
                                <label class="control-label col-xs-3">冰点数</label>
                                <div class="col-xs-4">
                                    <ul uglcw-role="radio"
                                         uglcw-options='"layout":"horizontal","dataSource":[{"text":"显示","value":"1"},{"text":"不显示","value":"2"}]'
                                         uglcw-model="cljccjMdLs[${s.count-1}].isBds" uglcw-value="${list.isBds}">
                                    </ul>
                                </div>
                            </div>

                        </c:forEach>
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
            url: '${base}/manager/updateCljccjMdLs',
            data: uglcw.ui.bind($("#inventory_settings")),  //绑定值
            type: 'post',
            success: function (data) {
                if (data === "1") {
                    uglcw.ui.success('修改成功');
                    toback();
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })
    }
    function toback() {
        location.href = '${base}/manager/queryCljccjMdls';
    }

</script>
</body>
</html>
