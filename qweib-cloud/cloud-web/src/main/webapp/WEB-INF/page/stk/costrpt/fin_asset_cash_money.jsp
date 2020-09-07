<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>资产汇算表_货币资金</title>
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
<div>

    <input type="hidden" id="isType" name="isType" value="${isType}"/>

    日期: <input name="sdate" id="sdate" onClick="WdatePicker();" style="width: 100px;" value="${sdate}" type="hidden"/>
    <input name="edate" id="edate" onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle"
         style="cursor: pointer;"/>
    <input type="radio" name="typeId" onclick="javascript:query();" checked value=""/>全部
    <input type="radio" name="typeId" onclick="javascript:query();" value="0"/>现金
    <input type="radio" name="typeId" onclick="javascript:query();" value="1"/>微信
    <input type="radio" name="typeId" onclick="javascript:query();" value="2"/>支付宝
    <input type="radio" name="typeId" onclick="javascript:query();" value="3"/>银行卡
    <input type="radio" name="typeId" onclick="javascript:query();" value="4"/>无卡账号

    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
</div>
<table id="datagrid" class="easyui-datagrid" style="width:800px;"
       data-options="fitColumns:true,singleSelect:true,onDblClickRow: onDblClickRow">
    <thead>

    </thead>
</table>
<%@include file="/WEB-INF/page/export/export.jsp" %>
<script type="text/javascript">

    function initGrid() {
        var cols = new Array();

        var col = {
            field: 'acc_id',
            title: 'acc_id',
            width: 50,
            align: 'center',
            hidden: 'true'

        };
        cols.push(col);

        var col = {
            field: 'acc_type',
            title: '账号类型',
            width: 100,
            align: 'center',
            formatter: formatterType

        };
        cols.push(col);

        var col = {
            field: 'acc_no',
            title: '账号',
            width: 120,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'qcamt',
            title: '期初金额',
            width: 100,
            align: 'center',
            formatter: amtformatter

        };
        cols.push(col);


        var col = {
            field: 'inamt',
            title: '本期增加',
            width: 100,
            align: 'center',
            formatter: amtformatter

        };
        cols.push(col);
        var col = {
            field: 'outamt',
            title: '本期减少',
            width: 100,
            align: 'center',
            formatter: amtformatter

        };
        cols.push(col);
        var col = {
            field: 'qmamt',
            title: '期末余额',
            width: 100,
            align: 'center',
            formatter: amtformatter

        };
        cols.push(col);
        var typeId = $("input[name='typeId']:checked").val();
        $('#datagrid').datagrid({
                url: "manager/finRptCashDay",
                queryParams: {
                    isNeedPay: 0,
                    sdate: $("#sdate").val(),
                    edate: $("#edate").val(),
                    typeId:typeId,
                    isType:$("#isType").val()
                },
                columns: [
                    cols
                ]
            }
        );
    }

    function query() {
        var typeId = $("input[name='typeId']:checked").val();
        $("#datagrid").datagrid('load', {
            url: "manager/finRptCashDay",
            jz: "1",
            sdate: $("#sdate").val(),
            edate: $("#edate").val(),
            typeId: typeId,
            isType:$("#isType").val()
        });
    }

    //回车查询
    function toQuery(e) {
        var key = window.event ? e.keyCode : e.which;
        if (key == 13) {
            query();
        }
    }

    function onDblClickRow(rowIndex, rowData) {
        var accId = rowData.acc_id;
        var sdate = $('#sdate').val();
        var edate = $('#edate').val();
        if (accId == undefined) {
            return;
        }

        parent.closeWin('账户明细');
        parent.add('账户明细', 'manager/toFinAccIo?sdate=' + sdate + '&edate=' + edate + '&accId=' + accId);
    }


    function amtformatter(v, row) {
        if (row != null) {
            return numeral(v).format("0,0.00");
        }
    }

    function formatterType(v, row) {
        if (row.acc_type == 0) return "现金";
        if (row.acc_type == 1) return "微信";
        if (row.acc_type == 2) return "支付宝";
        if (row.acc_type == 3) return "银行卡";
        if (row.acc_type == 4) return "无卡账号";
    }

    initGrid();

</script>
</body>
</html>
