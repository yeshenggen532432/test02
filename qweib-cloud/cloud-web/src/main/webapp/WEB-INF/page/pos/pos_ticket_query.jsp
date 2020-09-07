]<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>会员管理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
</head>

<body class="easyui-layout" fit="true">
<div data-options="region:'west',split:true,title:'券类型'"
     style="width:400px;padding-top: 5px;">

    <table id="datagrid1" class="easyui-datagrid" fit="true" singleSelect="false"
           url="manager/pos/queryTicketType" iconCls="icon-save" border="false"
           rownumbers="true" fitColumns="true" pagination="false"
           pageSize=20 pageList="[10,20,50,100,200,500,1000]" data-options="
				onClickRow: onClickRow">
        <thead>
        <tr>
            <th field="ck" checkbox="true"></th>
            <th field="id" width="50" align="center" hidden="true">
                id
            </th>
            <th field="ticketNo" width="80" align="center">
                编号
            </th>
            <th field="ticketName" width="120" align="center">
                类型名称
            </th>

            <th field="amt" width="120" align="center">
                面值
            </th>
            <th field="waretypeNm" width="120" align="center">
                限制消费
            </th>


        </tr>
        </thead>
    </table>

</div>
<div id="departDiv" data-options="region:'center'" title="已发行的券">
    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
           border="false"
           rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
           pageSize=20 pageList="[10,20,50,100,200,500,1000]"
           toolbar="#tb" data-options="">


    </table>
    <div id="tb" style="padding:5px;height:auto">
        状态: <select name="statusSel" id="statusSel">
        <option value="-9">全部</option>
        <option value="0">未使用</option>
        <option value="1">已使用</option>
    </select>
        会员名称: <input name="memberNm" id="memberNm" style="width:156px;height: 20px;" onkeydown="queryTicket(0);"/>
        <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryTicket(0);">查询</a>
    </div>

</div>
<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
</div>
<script type="text/javascript">
    $(function(){
        initGrid();
    });

    var unitInfo = [{ "value": "0", "text": "小单位" }, { "value": "1", "text": "大单位" }];


    function statusformatter(value, rowData, rowIndex) {

        if(value == 0)return "未使用";
        return "已使用";
    }

    function initGrid() {
        // {field: 'pipingName', title: '管道名称(登记单元)', width: 170, editor: "text"},

        $("#datagrid").datagrid({
            singleSelect: false,
            fitColumns: false,
            border: false,
            columns: [[
                {field: 'ck', checkbox: 'true', width: 66},
                {field: 'id', title: '编号', width: 66, hidden: "true"},
                {field: 'ticketBarcode', title: '券编号', width: 120},
                {field: 'memberName', title: '会员名称', width: 120},
                {field: 'endDate', title: '有效期', width: 120},
                {field: 'status', title: '状态', width: 90, formatter: statusformatter}

            ]],


        });
    }

    function onClickRow(rowNum,record)
    {
        queryTicket(record.id);
    }

    function queryTicket(ticketType){

        $('#datagrid').datagrid({
            url:"manager/pos/queryTicketPage",
            queryParams:{
                id:ticketType,
                status:$("#statusSel").val(),
                memberNm:$("#memberNm").val()

            }

        });



    }















</script>
</body>
</html>
