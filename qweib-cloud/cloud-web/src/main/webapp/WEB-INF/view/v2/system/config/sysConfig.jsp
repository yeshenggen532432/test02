<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>系统参数配置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .control-label{
            margin-bottom: 0;
        }
    </style>
</head>
<body>
<tag:mask/>

<div class="layui-card">
    <div class="layui-card-body">
        <input type="hidden" name="systemGroupCode" value="${param.systemGroupCode}" id="systemGroupCode">
        <input type="text" name="name" value="${param.name}" id="name" placeholder="参数名称">
        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
        <table style="margin-top: 10px;border:1px solid teal;">
            <c:forEach items="${datas }" var="data" varStatus="s">
                <tr style="height: 25px;border:1px solid teal;">
                    <td style="width:50px;text-align: center">${s.index+1}</td>
                    <td style="text-align: right;border:1px solid teal;"><label class="control-label" for="${data.code}">${data.name}：</label></td>
                    <td width="240px" style="padding: 2px 5px 0px 10px;">
                        <input type="checkbox" id="${data.code}" uglcw-value="${data.status}"
                               onchange="updateConfig(this,'${data.code}','${data.id}','${data.name}')"
                               uglcw-model="${data.code}" uglcw-role="checkbox">
                        <label for="${data.code}"></label>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            var name = $("#name").val();
            var systemGroupCode = $("#systemGroupCode").val();
            document.location.href="${base}manager/sysConfig/queryConfig?systemGroupCode="+systemGroupCode+"&name="+name;
        });
        uglcw.ui.loaded()
    })

    function updateConfig(o, code, id, name) {
        var status = "0";
        if (uglcw.ui.get(o).value()) {
            status = "1";
        }
        $.ajax({
            url: '${base}manager/sysConfig/updateConfig',
            type: 'post',
            data: {id: id, code: code, status: status, name: name},
            dataType: 'json',
            success: function (json) {
                uglcw.ui.loaded();
                if (json.state) {
                    uglcw.ui.success('操作成功', 'info');
                } else {
                    uglcw.ui.error('操作失败！', 'info')
                }
            }
        })
    }
</script>
</body>