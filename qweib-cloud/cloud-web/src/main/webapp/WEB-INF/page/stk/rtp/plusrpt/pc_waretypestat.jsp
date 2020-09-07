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

<body onload="initGrid()">
<table id="datagrid" fit="true" singleSelect="true"
       title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true"
       data-options="onDblClickRow: onDblClickRow">

</table>
<div id="tb" style="padding:5px;height:auto">
    发货日期
    : <input name="stime" id="sdate" onClick="WdatePicker();" style="width: 100px;" value="${sdate}"
             readonly="readonly"/>
    <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle"
         style="cursor: pointer;"/>
    -
    <input name="etime" id="edate" onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle"
         style="cursor: pointer;"/>
    发票类型:<select name="outType" id="outType">
    <option value="">全部</option>
    <option value="销售出库">销售发票</option>
    <option value="其它出库">其它出库发票</option>

</select>
    销售类型:<select name="xsTp" id="xsTp">
    <option value="">全部</option>
    <option value="正常销售">正常销售</option>
    <option value="促销折让">促销折让</option>
    <option value="消费折让">消费折让</option>
    <option value="费用折让">费用折让</option>
    <option value="其他销售">其他销售</option>
    <option value="其它出库">其它出库</option>
    <option value="销售退货">销售退货</option>
</select>


    业务员: <input name="staff" id="staff" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    只统计已结清订单：<input type="checkbox" id="chkIsRec" onchange="querydata()" checked="checked"/>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>
    <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>
    <input type="hidden" id="typeId"/>
    <input type="hidden" id="typeLevel"/>
</div>
<%@include file="/WEB-INF/page/export/export.jsp" %>
<script type="text/javascript">
    //查询
    //initGrid();
    function initGrid() {
        var cols = new Array();
        var col = {
            field: 'id',
            title: 'id',
            width: 100,
            align: 'center',
            hidden: true
        };
        cols.push(col);
        var col = {
            field: 'typeName',
            title: '类别/商品名称',
            width: 140,
            align: 'center'
        };
        cols.push(col);
        var col = {
            field: 'price',
            title: '销售均价',
            width: 100,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);
        var col = {
            field: 'sumQty',
            title: '数量',
            width: 100,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);
        var col = {
            field: 'sumAmt',
            title: '销售金额',
            width: 100,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);
        var col = {
            field: 'freeQty',
            title: '赠送数量',
            width: 100,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);

        var col = {
            field: 'unitName',
            title: '计量单位',
            width: 80,
            align: 'center'
        };
        cols.push(col);


        $('#datagrid').datagrid({
                columns: [
                    cols
                ]
            }
        );
    }

    function queryData() {
        $("#typeId").val(0);
        $("#typeLevel").val(0);
        var isRec = 0;
        if (document.getElementById("chkIsRec").checked) isRec = 1;
        $('#datagrid').datagrid({
                url: "manager/queryWareTypeStat",
                queryParams: {
                    typeLevel: 0,
                    sdate: $("#sdate").val(),
                    edate: $("#edate").val(),
                    outType: $("#outType").val(),
                    xsTp: $("#xsTp").val(),
                    staff: $("#staff").val(),
                    wareNm: $("#wareNm").val(),
                    khNm: $("#khNm").val(),
                    isRec:isRec
                }
            }
        );
    }

    function formatterMny(v) {
        if (v != null) {
            return numeral(v).format("0,0.00");
        } else {
            return v;
        }
    }

    function amtformatter(v, row) {
        if (v == null) return "";
        if (v == "0E-7") {
            return "0.00";
        }
        if (row != null) {
            return numeral(v).format("0,0.00");
        }
    }

    //回车查询
    function toQuery(e) {
        var key = window.event ? e.keyCode : e.which;
        if (key == 13) {
            queryData();
        }
    }


    function onLoadSuccess(data) {


    }


    function showMainDetail() {
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var outType = $("#xsTp").val();
        var stkUnit = $("#khNm").val();
        var epCustomerName = $("#epCustomerName").val();
        var customerType = $("#customerType").val();
        parent.closeWin('客户毛利明细统计表');
        parent.add('客户毛利明细统计表', 'manager/queryAutoCstStatDetail?sdate=' + sdate + '&edate=' + edate + '&epCustomerName=' + epCustomerName + '&outType=' + outType + '&customerType=' + customerType + '&stkUnit=' + stkUnit);
    }


    function createRptData() {
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var outType = $("#outType").val();
        var staff = $("#staff").val();
        var xsTp = $("#xsTp").val();
        var dateType = $("#timeType").val();
        var wareNm = $("#wareNm").val();
        parent.closeWin('生成业务销售统计汇总表');
        parent.add('生成业务销售统计汇总表', 'manager/toStkEmpStatSave?sdate=' + sdate + '&edate=' + edate + '&outType=' + outType + '&staff=' + staff + '&timeType=' + dateType + '&xsTp=' + xsTp + '&wareNm=' + wareNm);
    }


    function formatAutoAmt(val, row, index) {
        var price = "";
        var map = row.autoMap
        var html = "";
        for (var key in map) {
            if (key == this.value) {
                html = map[key];
            }
        }
        return formatterMny(html);
        ;
    }

    function onDblClickRow(rowIndex, rowData) {

        var isRec = 0;
        if (document.getElementById("chkIsRec").checked) isRec = 1;
        var typeLevel = rowData.typeLevel + 1;
        if (typeLevel > 2) return;
        var params = "typeId=" + rowData.id + "&typeLevel=" + typeLevel + "&sdate=" + $("#sdate").val()
            + "&edate=" + $("#edate").val() + "&outType=" + $("#outType").val()
            + "&xsTp=" + $("#xsTp").val() + "&staff=" + $("#staff").val() + "&wareNm=" + $("#wareNm").val()
            + "&khNm=" + $("#khNm").val() + "&isRec=" + isRec;
        parent.closeWin('类别统计-' + rowData.typeName);
        parent.add('类别统计-' + rowData.typeName, 'manager/toStkWareTypeStat1?' + params);
    }

    function myexport() {
        var typeId = $("#typeId").val();
        var typeLevel = $("#typeLevel").val();
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var outType = $("#outType").val();
        var xsTp = $("#xsTp").val();
        var staff = $("#staff").val();
        var wareNm = $("#wareNm").val();
        var database = "${datasource}";
        var isDb = $("#isDb").val();

        var c = {
            typeId: parseInt(typeId),
            typeLevel: parseInt(typeLevel),
            sdate: sdate,
            edate: edate,
            outType: outType,
            xsTp: xsTp,
            staff: staff,
            wareNm: wareNm,
            database: database
        }

        var t = ''
        if (typeLevel == 0) {
            t = 'sumWareTypeStat3'
        } else if (typeLevel == 1) {
            t = 'sumWareTypeStat2'
        } else if (typeLevel == 2) {
            t = 'sumWareTypeStat1'
        }
        if (t) {
            exportData('incomeStatService', t, 'com.qweib.cloud.biz.erp.model.StkWareTypeStatVo', JSON.stringify(c), "商品类型销售统计");
        }
    }
</script>
</body>
</html>
