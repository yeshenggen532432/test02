<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>仅限同城销售商品设置</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>

<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
       url="${base}/manager/shopCityWare/pageList" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
    <thead>
    <tr>
        <th field="wareId" checkbox="true"></th>
        <th field="wareNm" width="200" align="center">
            商品名称
        </th>
        <th field="wareGg" width="150" align="center">
            规格
        </th>
        <th field="wareDj" width="100" align="center">
            批发价
        </th>
        <th field="putOn" width="120" align="center" formatter="formatPutOn">
            上架状态
        </th>
    </tr>
    </thead>
</table>
<div id="tb" style="padding:5px;height:auto">
    商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;"  onkeydown="if(event.keyCode==13)query();"/>
    <a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:query();">查询</a>
    <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toadd();">添加</a>
    <%--<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toedit();">修改</a>--%>
    <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:todel();">移除</a>
</div>

<%--弹出框--%>
<div id="wareWindow" class="easyui-window" title="商品选择" style="width:800px;height:800px;"
     minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
    <iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%"
            height="100%"></iframe>
</div>
<!-- ===================================以下是js========================================= -->
<script type="text/javascript">
    //上架状态
    function formatPutOn(val, row) {
        if (!row.wareId) return "";
        var html = "未上架";
        if (val == "1") {
            html = "已上架";
        }
        return html;
    }

    //====================增删改查：start==========================
    //查询
    function query() {
        $("#datagrid").datagrid('load', {
            url: "${base}manager/shopCityWare/pageList",
            wareNm: $("#wareNm").val(),
        });
    }

    //添加
    function toadd() {
        if(!document.getElementById("windowifrm").src)
            document.getElementById("windowifrm").src="${base}/manager/shopCityWare/wareType";
        $("#wareWindow").window('open');
    }

    //删除
    function todel() {
        var rows = $('#datagrid').datagrid('getSelections');
        var ids = "";
        for (var i = 0; i < rows.length; i++) {
            if (ids != '') {
                ids = ids + ",";
            }
            ids = ids + rows[i].wareId;
        }
        if (ids == "") {
            $.messager.alert('Warning', '请选择商品！');
            return;
        }
        if (confirm("是否要移出选中同城商品吗?")) {
            $.ajax({
                url: "manager/shopCityWare/del",
                data: "wareIds=" + ids,
                type: "post",
                success: function (json) {
                    if (json.state) {
                        alert("移除成功");
                        query();
                    } else {
                        alert("移除失败");
                        return;
                    }
                }
            });
        }
    }
</script>
</body>
</html>
