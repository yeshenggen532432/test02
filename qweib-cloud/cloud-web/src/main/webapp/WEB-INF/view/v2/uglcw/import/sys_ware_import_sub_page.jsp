<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>驰用T3</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>

<body onload="queryWare()">
<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
<input type="hidden" name="mastId" id="mastId" value="${mastId}"/>
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center',border:false" title="">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'north',border:false" title="查询条件" style="height:60px">
                <div style="width: 970px;">
                    商品名称: <input name="wareNm" id="wareNm" class="easyui-textbox" onkeydown="toQuery(event);"/>
                    大单位条码: <input name="packBarCode" id="packBarCode" class="easyui-textbox"/>
                    小单位条码: <input name="beBarCode" id="beBarCode" class="easyui-textbox"/>

                    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
                </div>
            </div>
            <div data-options="region:'center',border:false" title="数据列表">
                <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
                       url="manager/sysWareImportMain/subPage?mastId=${mastId}&wtype=${wtype}" border="false"
                       rownumbers="true" fitColumns="false" pagination="true"
                       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#gridbar">
                    <thead frozen="true">
                    <th field="wareCode" width="80" align="center">
                        商品编码
                    </th>
                    <th field="wareNm" width="100" align="left">
                        商品名称
                    </th>
                    </thead>
                    <thead>
                    <tr>
                        <th field="py" width="100" align="left">
                            助记码
                        </th>
                        <th field="waretypeNm" width="80" align="center" formatter="formatType">
                            所属分类
                        </th>
                        <th field="brandNm" width="80" align="center">
                            所属品牌
                        </th>
                        <th field="qualityDays" width="80" align="center">
                            保质期
                        </th>
                        <th field="wareGg" width="80" align="left">
                            规格
                        </th>
                        <th field="wareDw" width="60" align="center">
                            大单位
                        </th>
                        <th field="packBarCode" width="100" align="center">
                            大单位条码
                        </th>
                        <th field="minUnit" width="100" align="center">
                            小单位
                        </th>
                        <th field="beBarCode" width="100" align="center">
                            小单位条码
                        </th>

                        <th field="inPrice" width="60" align="center" >
                            采购价
                        </th>
                        <th field="wareDj" width="60" align="center">
                            批发价
                        </th>
                        <th field="lsPrice" width="60" align="center">
                            零售价
                        </th>
                        <th field="tranAmt" width="60" align="center">
                            运输费用
                        </th>
                        <th field="tcAmt" width="60" align="center">
                            提成费用
                        </th>
                        <th field="aliasName" width="60" align="center">
                            别名
                        </th>
                        <th field="asnNo" width="60" align="center" >
                            标识码
                        </th>
                        <th field="fbtime" width="100" align="center">
                            发布时间
                        </th>
                        <th field="status" width="60" align="center" formatter="formatterStatus">
                            是否启用
                        </th>
                        <th field="isCy" width="60" align="center" formatter="formatterSt">
                            是否常用
                        </th>
                    </tr>
                    </thead>
                </table>
                <div id="gridbar">
                    <div style="padding: 2px">

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    function queryWare() {
        $("#datagrid").datagrid('load', {
            url: "manager/sysWareImportMain/subPage",
            wareNm: $("#wareNm").val(),
            status: 1,
            packBarCode: $('#packBarCode').val()

        });
    }
    function reloadware() {
        $("#datagrid").datagrid("reload");
    }

    function formatType(val, row, index) {
        return row.waretypeNm;
    }

    function formatterSt(val, row) {
        if (val == 1) {
            return "是";
        } else {
            return "否";
        }
    }
    function formatterStatus(val, row) {
        if (val == 1) {
            return "是";
        } else {
            return "否";
        }
    }

</script>
</body>
</html>
