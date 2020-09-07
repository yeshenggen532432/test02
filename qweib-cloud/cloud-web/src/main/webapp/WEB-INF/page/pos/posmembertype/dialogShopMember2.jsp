<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>

<body scrolling="no">
<table id="datagrid_memeber" class="easyui-datagrid" fit="true" singleSelect="false"
       url="manager/pos/queryMemberPage?exceptCardType=${cardType}&queryType=${type}" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb3">
    <thead>
    <tr>
        <th field="id" checkbox="true"></th>
        <th field="name" width="80" align="center" >
            会员名称
        </th>
        <th field="mobile" width="100" align="center">
            电话
        </th>
        <th field="typeName" width="100" align="center">
            会员类型
        </th>
        <th field="cardNo" width="100" align="center">
            卡号
        </th>
    </tr>
    </thead>
</table>
<div id="tb3" style="padding:5px;height:auto">
    会员名称/手机/卡号: <input name="name" id="name" style="width:156px;height: 20px;" onkeydown="query();"/>
   <input type="hidden" id="cardType" value="${cardType}">
    <input type="hidden" id="queryType" value="${type}">
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:confirmSelectMember();">确定选择</a>
</div>

<script type="text/javascript">
    function confirmSelectMember(){
        var rows = $('#datagrid_memeber').datagrid('getSelections');
        var ids = "";
        for(var i=0;i<rows.length;i++){
            if(ids!=''){
                ids=ids+",";
            }
            ids=ids+rows[i].id;
        }
        if(ids==""){
            alert('请选择会员！');
            return;
        }
        window.callBackFunSelectMemeber(ids);
        window.$('#memberDlg').dialog('close');
    }

    //查询会员
    function query(){
        $("#datagrid_memeber").datagrid('load',{
            url:"manager/pos/queryMemberPage",
            keyWord:$("#name").val(),
            exceptCardType:$("#cardType").val(),
            queryType:$("#queryType").val()
        });
    }
</script>
</body>
</html>
