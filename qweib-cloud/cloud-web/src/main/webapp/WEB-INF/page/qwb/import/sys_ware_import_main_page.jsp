<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>商品信息导入</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>
<body>
    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
           url="manager/sysWareImportMain/page" border="false"
           rownumbers="true" fitColumns="false" pagination="true"
           pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#gridbar" data-options="onDblClickRow: onDblClickRow">
        <thead>
        <tr>
        <th field="id" checkbox="true">id</th>
        <th field="title" width="220" align="center">标题</th>
        <th field="operName" width="120" align="left">操作人</th>
        </tr>
        </thead>
    </table>
   <%-- <div id="gridbar">
        <div style="padding: 2px">
            <a   class="easyui-linkbutton" plain="true" iconCls="icon-redo" href="javascript:toWareModel();">下载模板</a>
            <a   class="easyui-linkbutton" plain="true" iconCls="icon-redo" href="javascript:toUpWare();">上传数据</a>
        </div>
    </div>--%>

<div id="upDiv" class="easyui-window" style="width:500px;height:100px;padding:10px;"
     minimizable="false" maximizable="false" collapsible="false" closed="true">
    <form action="manager/toUpWareTemplateData" id="upFrm" method="post" enctype="multipart/form-data">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr height="30px">
                <td>选择文件：</td>
                <td>
                    <input type="file" name="upFile" id="upFile" title="check"/>
                </td>
                <td><input type="button" onclick="toUpWareExcel();" style="width: 50px" value="上传"/></td>
            </tr>
        </table>
    </form>
</div>

<script type="text/javascript">
    //上传文件
    function toUpWareExcel() {
        $("#upFrm").form('submit', {
            success: function (data) {
                if (data == '1') {
                    alert("上传成功");
                    query();
                } else {
                    alert(data);
                }
                onclose();
            },
            onSubmit: function () {
                DIVAlert("<img src='resource/images/loading.gif' width='50px' height='50px'/>");
            }
        });
    }

    function query() {
        $("#datagrid").datagrid('load', {
            url: "manager/syswareImportMain/page"
        });
    }

    //下载模板
    function toWareModel() {
        if (confirm("是否下载商品模版?")) {
            window.location.href = "manager/toWareImportTemplate";
        }

    }
    //显示上传框
    function toUpWare() {
        $("#upDiv").window({title: '上传', modal: true});
        $("#upDiv").window('open');
    }

    function onDblClickRow(rowIndex, rowData) {
        parent.closeWin(rowData.title);
        parent.add(rowData.title, 'manager/sysWareImportMain/toWareType?mastId=' + rowData.id);
    }

</script>
</body>
</html>
