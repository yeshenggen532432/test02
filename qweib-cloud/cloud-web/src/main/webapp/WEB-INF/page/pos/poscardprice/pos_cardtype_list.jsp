<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
</head>

<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       url="manager/pos/queryMemberType" title="会员类型列表" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="true" pagination="false" pagePosition=3
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
    <thead>
    <tr>
        <th field="id" width="50" align="center" hidden="true">
            id
        </th>

        <th field="typeName" width="280" align="center">
            会员类型名称
        </th>
        <th field="_operater" width="280" align="center" formatter="formatterOper">
            操作
        </th>
    </tr>
    </thead>
</table>
<div id="tb" style="padding:5px;height:auto">

</div>

<script type="text/javascript">

    function queryMemberType(){
        $("#datagrid").datagrid('load',{
            url:"manager/pos/queryMemberType"


        });
    }


    function formatterOper(val,row){
        var html = "<a href='javascript:;;' onclick='setWarePrice(\""+row.id+"\",\""+row.typeName+"\")'>设置商品价格<a/>";
        html+="&nbsp;|"+"<a href='javascript:;;' onclick='showMembers(\""+row.id+"\",\""+row.typeName+"\")'>会员信息列表<a/>";
        return html;
    }

    function showMembers(id,name){
        window.parent.close(name+"_会员列表");
        window.parent.add(name+"_会员列表","manager/pos/toPosMemberByType?memberType="+id);
    }

    function setWarePrice(id,name){
        window.parent.close(name+"_设置商品价格");
        window.parent.add(name+"_设置商品价格","manager/pos/toPosMemberTypePriceEdit?memberType="+id);
    }


</script>
</body>
</html>
