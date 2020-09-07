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
       url="manager/pos/queryPosSaleSub?mastId=${mastId}" title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="false"
       >
    <thead>
    <tr>

        <th field="id" width="50" align="center" hidden="true">
            id
        </th>

        <th field="wareNm" width="120" align="center">
            商品名称
        </th>
        <th field="unitName" width="80" align="center">
            单位
        </th>
        <th field="qty" width="80" align="center" formatter="amtformatter">
            数量
        </th>

        <th field="disPrice" width="80" align="center" formatter="amtformatter">
            单价
        </th>
        <th field="disAmt" width="80" align="center" formatter="amtformatter">
            金额
        </th>



    </tr>
    </thead>

</table>
<div id="tb" style="padding:5px;height:auto">

</div>



<script type="text/javascript">

    //查询物流公司
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
