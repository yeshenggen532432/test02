<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>员工导入记录</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
</head>
<body>
<table id="datagrid"  class="easyui-datagrid"  fit="true" singleSelect="false"
       url="manager/sysMemberImportMain/subPage?mastId=${mastId}"
       iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" >
    <thead>
    <tr>
        <th field="ck" checkbox="true"></th>
        <th field="memberId" width="50" align="center" hidden="true">
            memberId
        </th>
        <th field="memberNm" width="80" align="center">
            姓名
        </th>
        <th field="firstChar" width="50" align="center">
            首字母
        </th>
        <th field="memberMobile" width="80" align="center" >
            手机号码
        </th>
        <th field="branchName" width="80" align="center" >
            部门
        </th>
        <th field="memberJob" width="50" align="center" >
            职位
        </th>
        <th field="memberTrade" width="50" align="center" >
            行业
        </th>
        <th field="memberHometown" width="120" align="center" >
            家乡
        </th>
    </tr>
    </thead>
</table>
<div id="tb" style="padding:5px;height:auto">
    姓名: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
    手机号码: <input name="memberMobile" id="memberMobile" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
</div>

<script type="text/javascript">
    function query() {
        $("#datagrid").datagrid('load', {
            url: "manager/sysMemberImportMain/toSubPage",
            memberNm:$("#memberNm").val(),
            memberMobile:$("#memberMobile").val()
        });
    }

    //回车查询
    function toQuery(e){
        var key = window.event?e.keyCode:e.which;
        if(key==13){
            query();
        }
    }

</script>
</body>
</html>
