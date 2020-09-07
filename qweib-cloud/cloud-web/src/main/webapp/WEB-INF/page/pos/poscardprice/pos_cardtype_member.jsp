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

    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
           border="false" url="manager/pos/queryMemberPage?cardType=${memberType}" pagination="true"
           pageSize=50 pageList="[10,20,50,100,200,500,1000]"
           rownumbers="true" fitColumns="false" pagination="false"
           toolbar="#tb" >
        <thead>
        <tr>
            <th field="ck" checkbox="true"></th>
            <th field="id" width="50" align="center" hidden="true">
                id
            </th>
            <th field="name" width="200" align="center">
                会员名称
            </th>
            <th field="cardNo" width="200" align="center">
                卡号
            </th>

            <th field="mobile" width="200" align="center">
                电话
            </th>

            <th field="typeName" width="200" align="center">
                会员类型
            </th>

            <th field="inputCash" width="200" align="center" formatter="amtformatter">
                剩余金额
            </th>

            <th field="freeCost" width="200" align="center">
                剩余赠送
            </th>

            <th field="status" width="200" align="center" formatter="formatterStatus">
                状态
            </th>




        </tr>
        </thead>
    </table>

    <div id="tb" style="padding:5px;height:auto">

        连锁店:
        <tag:select id="shopName" name="shopName" displayKey="shop_no" headerKey="" headerValue="全部" onchange="queryShopWare(0)" displayValue="shop_name" tableName="pos_shopinfo"/>
            姓名: <input name="cstName" id="cstName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
            卡号: <input name="cardNo" id="cardNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
            电话: <input name="mobile" id="mobile" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>

            状态: <select name="status" id="status">
            <option value="-2">全部</option>
            <option value="1">正常</option>
            <option value="0">挂失</option>
        </select>
            <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryMember();">查询</a>

        <input type="hidden" id="memberType" value="${memberType}"/>
        </div>


<script type="text/javascript">

    //查询物流公司
    function formatterStatus(val,row) {
        if(val == -1)return "退卡";
        if(val == 0) return "挂失";
        if(val == 1)return "正常";

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


    function queryMember()
    {
        $("#datagrid").datagrid('load',{
            url:"manager/pos/queryMemberPage",

            mobile:$("#mobile").val(),
            cardNo:$("#cardNo").val(),
            shopNo:$("#shopName").val(),
            name:$("#cstName").val(),
            status:$("#status").val(),
            cardType:$("#memberType").val()

        });
    }
    //回车查询
    function toQuery(e){
        var key = window.event?e.keyCode:e.which;
        if(key==13){
            queryMember();
        }
    }




</script>
</body>
</html>
