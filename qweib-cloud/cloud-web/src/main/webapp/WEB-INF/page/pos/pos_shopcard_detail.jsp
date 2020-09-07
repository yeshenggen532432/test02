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

<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" >

</table>


    <input type="hidden" id="sdate" value="${sdate}" />
    <input type="hidden" id="edate" value="${edate}" />
    <input type="hidden" id="shopNo" value="${shopNo}" />

    <!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->

</div>


<%@include file="/WEB-INF/page/export/export.jsp"%>
<script type="text/javascript">
    var database="${database}";
    initGrid();
    //queryorder();
    function initGrid()
    {


        var cols = new Array();


        var cols = new Array();

        var col = {
            field: 'ioTimeStr',
            title: '交易时间',
            width: 100,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'cardNo',
            title: '卡号',
            width: 135,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'typeName',
            title: '卡类型',
            width: 135,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'docNo',
            title: '单号',
            width: 135,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'cardPay',
            title: '卡消费金额',
            width: 100,
            align:'center',
            formatter:amtformatter

        };
        cols.push(col);
        var col = {
            field: 'left',
            title: '余额',
            width: 80,
            align:'center',
            formatter:amtformatter

        };
        cols.push(col);


        var col = {
            field: 'operator',
            title: '收银员',
            width: 80,
            align:'center'

        };
        cols.push(col);





        $('#datagrid').datagrid({
            url:"manager/pos/queryPosMemberIo",
            queryParams:{
                startTime:$("#sdate").val(),
                endTime:$("#edate").val() + ' 23:59:00',
                shopNo:$("#shopNo").val(),
                shopCard:1

            },
            columns:[
                cols
            ]}
        );
        //$('#datagrid').datagrid('reload');
    }
    //查询物流公司
    function  queryorder() {
        $("#datagrid").datagrid('load',{
            url:"manager/pos/queryPosMemberIo",
            startTime:$("#sdate").val(),
            endTime:$("#edate").val() + ' 23:59:00',
            shopNo:$("#shopNo").val(),
            shopCard:1

        });

    }
    function amtformatter(v,row)
    {
        if(v==""){
            return "";
        }
        if(v=="0E-7"){
            return "0.00";
        }
        if (row != null) {
            return numeral(v).format("0,0.00");
        }
    }


</script>
</body>
</html>
