<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body onload="initGrid()">
<table id="datagrid"  fit="true" singleSelect="true"
       title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onDblClickRow: onDblClickRow">

</table>
<div id="tb" style="padding:5px;height:auto">
    <input type="hidden" id="sdate" value="${sdate}" />
    <input type="hidden" id="edate" value="${edate}" />
    <input type="hidden" id="cstId" value="${cstId}" />
    <input type="hidden" id="xsTp" value="${xsTp}" />
    <input type="hidden" id="wareId" value="${wareId}" />
    <input type="hidden" id="isType" value="${isType}"/>
    <input type="hidden" id="wtype" value="${wtype}"/>
    <input type="hidden" id="timeType" value="${timeType}"/>

</div>

<script type="text/javascript">

    //查询
    //initGrid();
    function initGrid()
    {
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
            field: 'billNo',
            title: '单号',
            width: 140,
            align:'center'
        };
        cols.push(col);

        var col = {
            field: 'khNm',
            title: '客户名称',
            width: 140,
            align:'center'
        };
        cols.push(col);
        var col = {
            field: 'wareNm',
            title: '商品名称',
            width: 140,
            align:'center'
        };
        cols.push(col);


        var col = {
            field: 'xsTp',
            title: '销售类型',
            width: 120,
            align:'center'
        };
        cols.push(col);


        var col = {
            field: 'unitName',
            title: '计量单位',
            width: 80,
            align:'center'
        };
        cols.push(col);
        var col = {
            field: 'price',
            title: '销售单价',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);
        var col = {
            field: 'qty',
            title: '发票数量',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);
        var col = {
            field: 'amt',
            title: '发票金额',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'outQty',
            title: '发货数量',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);
        var col = {
            field: 'outAmt',
            title: '发货金额',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);






        $('#datagrid').datagrid({
            url:"manager/querySumCstStatDetail",
            queryParams:{
                sdate:$("#sdate").val(),
                edate:$("#edate").val(),
                xsTp:$("#xsTp").val(),
                cstId:$("#cstId").val(),
                wareId:$("#wareId").val(),
                isType:$("#isType").val(),
                wtype:$("#wtype").val(),
                timeType:$("#timeType").val()

            },
                columns:[
                    cols
                ]
            }
        );

    }

    function formatterMny(v)
    {
        if (v != null) {
            return numeral(v).format("0,0.00");
        }else{
            return v;
        }
    }
    function amtformatter(v,row)
    {
        if(v == null)return "";
        if(v=="0E-7"){
            return "0.00";
        }
        if (row != null) {
            return numeral(v).format("0,0.00");
        }
    }


    function onDblClickRow(rowIndex, rowData) {
        if(rowData.xsTp == "销售退货")
        {
            parent.add('销售退货开单','manager/pcstkthin?orderId='+rowData.id);
        }
        else {
            parent.closeWin('发票信息' + rowData.id);
            parent.add('发票信息' + rowData.id, 'manager/showstkout?dataTp=1&billId=' + rowData.id);
        }
    }

</script>
</body>
</html>
