<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
<div id="dg">
</div>
<script type="text/javascript">
    $(function () {
        $('#dg').datagrid({
            fit: true,
            border: false,
            pagination: false,
            fitcolumns: true,
            singleSelect: true,
            method: 'get',
            height: 250,
            autoRowWidth: true,
            url: '/manager/common/bill/snapshot?billType=${param.billType}&billId=${param.billId}',
            onDblClickRow: parent.loadSnapshot,
            loadFilter: loadFilter,
            columns: [[
                {
                    width: 150,
                    field: 'updateTime', title: '更新时间', formatter: function (v, r, i) {
                        return getLocalTime(v);
                    }
                },
                {width: 250, field: 'title', title: '客户名称'},
                {
                    width: 200, field: 'op', title: '操作', formatter: function (v, r, i) {
                        return '<button onclick="loadSnapshot(\'' + r.id + '\')">加载</button><button style="margin-left:5px" onclick="removeSnapshot(\'' + r.id + '\')">删除</button>';
                    }
                }
            ]]
        })
    });

    function loadFilter(response) {
        return {
            rows: response.data || []
        }
    }

    function getLocalTime(timestamp) {
        var date = new Date(timestamp);
        var month = date.getMonth() + 1;
        var day = date.getDate();
        var hour = date.getHours();
        var min = date.getMinutes();
        var sec = date.getSeconds();
        month = (month < 10 ? "0" : "") + month;
        day = (day < 10 ? "0" : "") + day;
        hour = (hour < 10 ? "0" : "") + hour;
        min = (min < 10 ? "0" : "") + min;
        sec = (sec < 10 ? "0" : "") + sec;
        var str = date.getFullYear() + "-" + month + "-" + day + " " + hour + ":" + min + ":" + sec;
        return str;
    }

    function removeSnapshot(id) {
        $.messager.confirm('提示', '确定删除吗？', function (r) {
            if (r) {
                $.ajax({
                    url: '/manager/common/bill/snapshot/' + id,
                    type: 'delete',
                    success: function (response) {
                        if (response.success) {
                            $('#dg').datagrid('reload');
                            parent.clearSnapshotId(id);
                        }
                    }
                })
            }
        })
    }

    function loadSnapshot(id){
        parent.loadSnapshot(id);
    }
</script>
</body>
</html>
