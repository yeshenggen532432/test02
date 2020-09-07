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
    <input type="hidden" id="sdate" value="${sdate}"/>
    <input type="hidden" id="edate" value="${edate}"/>
    <input type="hidden" id="outType" value="${outType}"/>
    <input type="hidden" id="xsTp" value="${xsTp}"/>
    <input type="hidden" id="staff" value="${staff}"/>
    <input type="hidden" id="khNm" value="${khNm}"/>
    <input type="hidden" id="wareNm" value="${wareNm}"/>
    <input type="hidden" id="typeName" value="${typeName}"/>
    <input type="hidden" id="typeId" value="${typeId}"/>
    <input type="hidden" id="typeLevel" value="${typeLevel}"/>
    <input type="hidden" id="isRec" value="${isRec}" />
    <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>

</div>
<%@include file="/WEB-INF/page/export/export.jsp" %>
<script type="text/javascript">
    var autoTitleDatas = eval('${autoTitleJson}');
    var autoPriceDatas = eval('${autoPriceJson}');
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

        $('#datagrid').datagrid({
                url: "manager/queryWareTypeStat",
                queryParams: {
                    typeId: $("#typeId").val(),
                    typeLevel: $("#typeLevel").val(),
                    sdate: $("#sdate").val(),
                    edate: $("#edate").val(),
                    outType: $("#outType").val(),
                    xsTp: $("#xsTp").val(),
                    staff: $("#staff").val(),
                    wareNm: $("#wareNm").val(),
                    khNm: $("#khNm").val(),
                    isRec:$("#isRec").val()
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

    }

    function onDblClickRow(rowIndex, rowData) {

        var isRec = 0;
        if (document.getElementById("chkIsRec").checked) isRec = 1;
        var typeLevel = rowData.typeLevel + 1;
        if (typeLevel > 2) {
            var params = "typeId=" + rowData.id + "&typeLevel=" + typeLevel + "&sdate=" + $("#sdate").val() + "&edate=" + $("#edate").val()
                + "&staff=" + $("#staff").val() + "&xsTp=" + $("#xsTp").val() + "&isRec=" + isRec;
            parent.closeWin('类别统计-' + rowData.typeName);
            parent.add('类别统计明细-' + rowData.typeName, 'manager/toStkWareTypeStat2?' + params);
            return;
        }
        var params = "typeId=" + $("#typeId").val() + "&typeLevel=" + typeLevel + "&sdate=" + $("#sdate").val()
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

    queryData();
</script>
</body>
</html>
