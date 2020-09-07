<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>商城商品</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="resource/loadDiv.js"></script>
</head>
<body>
<div id="tb12">
	<div style="color:red;margin: 5px 0">
		(备注:以下表格颜色区分:
		<span style="color:orange;margin-right: 10px">1.进销存商品基础价;</span>
		<span style="color:#333;margin-right: 10px">2.商城商品基础价;</span>
		<span style="color:blue;margin-right: 10px">3.商城会员等级价格;</span>
		<span style="color:green;">4.商城会员自定义价格</span>
		)
	</div>
	<div>
		商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;"/>
		<a class="easyui-linkbutton" iconCls="icon-search" plain="true"  href="javascript:queryWare();">查询</a>
		<input name="shopMemberId" id="shopMemberId" value="${shopMemberId}" hidden="true"/>
		<input name="wareType" id="wareType" value="${wareType}" hidden="true"/>
	</div>
</div>

<table id="dataGridWare" class="easyui-datagrid" fit="true" singleSelect="false"
       url="manager/shopEndPrice/shopWareEndPricePageByShopMemberId?shopMemberId=${shopMemberId}&wareType=${wareType}" border="false"
       rownumbers="true" fitColumns="false" pagination="true" pagePosition="bottom"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb12">
    <thead>
    <tr>
        <th field="wareNm" width="80" align="center">
            商品名称
        </th>
        <th field="wareGg" width="100" align="center">
            规格
        </th>
        <c:if test="${'0'==source || '3'==source}">
            <th field="shopWarePrice" width="100" align="center" styler=cellStyler1>
                商城批发价(大)
            </th>
        </c:if>
        <th field="shopWareLsPrice" width="100" align="center" styler=cellStyler2>
            商城零售价(大)
        </th>
       <%-- <th field="shopWareCxPrice" width="100" align="center" styler=cellStyler3>
            商城大单位促销价
        </th>--%>
        <c:if test="${'0'==source || '3'==source}">
            <th field="shopWareSmallPrice" width="100" align="center" styler=cellStyler4 formatter="formatterMinPrice">
                商城批发价(小)
            </th>
        </c:if>
        <th field="shopWareSmallLsPrice" width="100" align="center" styler=cellStyler5 formatter="formatterMinPrice">
            商城零售价(小)
        </th>
      <%--  <th field="shopWareSmallCxPrice" width="100" align="center" styler=cellStyler6 formatter="formatterMinPrice">
            商城小单位促销价
        </th>--%>
    </tr>
    </thead>
</table>

<script type="text/javascript">
    //查询
    function queryWare(){
        var shopMemberId = $("#shopMemberId").val();
        $("#dataGridWare").datagrid('load',{
            url:"manager/shopEndPrice/shopWareEndPricePageByShopMemberId?shopMemberId=${shopMemberId}&wareType=${wareType}",
            wareNm:$("#wareNm").val(),
        });
    }

    //-----------------设置风格------------------------
    function cellStyler1(value,row){
        var source1 = row.shopWarePriceSource;
        switch (source1) {
            case 1:
                return 'color:orange;';
                break;
            case 2:
                return 'color:#333;';
                break;
            case 3:
                return 'color:blue;';
                break;
            case 4:
                return 'color:green;';
                break;
        }
    }
    function cellStyler2(value,row){
        var source2 = row.shopWareLsPriceSource;
        switch (source2) {
            case 1:
                return 'color:orange;';
                break;
            case 2:
                return 'color:#333;';
                break;
            case 3:
                return 'color:blue;';
                break;
            case 4:
                return 'color:green;';
                break;
        }
    }
    function cellStyler3(value,row){
        var source3 = row.shopWareCxPriceSource;
        switch (source3) {
            case 1:
                return 'color:orange;';
                break;
            case 2:
                return 'color:#333;';
                break;
            case 3:
                return 'color:blue;';
                break;
            case 4:
                return 'color:green;';
                break;
        }
    }
    function cellStyler4(value,row){
        var source4 = row.shopWareSmallPriceSource;
        switch (source4) {
            case 1:
                return 'color:orange;';
                break;
            case 2:
                return 'color:#333;';
                break;
            case 3:
                return 'color:blue;';
                break;
            case 4:
                return 'color:green;';
                break;
        }
    }
    function cellStyler5(value,row){
        var source5 = row.shopWareSmallLsPriceSource;
        switch (source5) {
            case 1:
                return 'color:orange;';
                break;
            case 2:
                return 'color:#333;';
                break;
            case 3:
                return 'color:blue;';
                break;
            case 4:
                return 'color:green;';
                break;
        }
    }
    function cellStyler6(value,row){
        var source6 = row.shopWareSmallCxPriceSource;
        switch (source6) {
            case 1:
                return 'color:orange;';
                break;
            case 2:
                return 'color:#333;';
                break;
            case 3:
                return 'color:blue;';
                break;
            case 4:
                return 'color:green;';
                break;
        }

    }
    //-----------------设置风格------------------------

    function formatterMinPrice(val) {
        if(val!=null && val!=undefined && val!=""){
            val = val.toFixed(2)
        }
        return val;
    }
</script>
</body>
</html>
