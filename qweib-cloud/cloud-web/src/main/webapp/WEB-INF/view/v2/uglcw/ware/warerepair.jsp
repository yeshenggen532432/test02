<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>设置采购价格</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>
<body style="text-align: center;padding: 15px;">
<div style="margin: 5px; text-align: center">
    <table style="width: 600px" border="1"
           cellpadding="0" cellspacing="1">
        <thead>
        <tr>
            <th style="width: 40px">序号</th>
            <th style="width: 140px">商品名称</th>
            <th style="width: 80px">采购价</th>
            <th style="width: 80px">大单位名称</th>
            <th style="width: 80px">小单位名称</th>
            <th style="width: 140px">大单位:小单位</th>
            <th>&nbsp;</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${datas }" var="data" varStatus="s">
            <tr>
                <td>${s.index+1 }
                </td>
                <td>
                    ${data.wareNm}
                </td>
                <td align="center">
                    <input name="inPrice" id="inPrice" type="text" style="border: 1px solid #ddd;width: 80px"
                           onkeyup="CheckInFloat(this)" value="${data.inPrice}"
                           onchange="changeInPrice(this,${data.wareId})"/>
                </td>
                <td align="center">

                            <input name="wareDw" id="wareDw" type="text" style="border: 1px solid #ddd;width: 50px;text-align: center"
                                   value="${data.wareDw}"
                                   onchange="updateWareUnit(this,${data.wareId})"/>
                </td>
                <td align="center">
                            <input name="minUnit" id="minUnit" type="text" style="border: 1px solid #ddd;width: 50px;text-align: center"
                                   value="${data.minUnit}"
                                   onchange="updateWareUnit(this,${data.wareId})"/>
                </td>
                <td align="center">
                    <input name="bUnit"  type="text" readonly="readonly" style="border: 1px solid #ddd;width: 30px"
                                     onkeyup="CheckInFloat(this)" onchange="changeWareScale(this,${data.wareId})" value="<fmt:formatNumber value="${data.bUnit}" pattern=""/>"/>:
                    <input name="sUnit"  type="text" onclick="selectCell(this)" style="border: 1px solid #ddd;width: 50px"
                           onkeyup="CheckInFloat(this)" onchange="changeWareScale(this,${data.wareId})" value="<fmt:formatNumber value="${data.sUnit}" pattern=""/>"/>
                </td>
                <td>&nbsp;</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
<script type="text/javascript">
    function changeInPrice(obj, wareId) {
        $.ajax({
            url: "manager/updateWareInPrice",
            type: "post",
            data: "id=" + wareId + "&inPrice=" + obj.value,
            success: function (data) {
                if (data == '1') {
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }


    function updateWareUnit(obj, wareId) {
        var row =  $(obj).closest('tr');
        var wareDw = $(row).find("input[name='wareDw']").val();
        var minUnit = $(row).find("input[name='minUnit']").val();
        $.ajax({
            url: "manager/updateWareUnit",
            type: "post",
            data: "id=" + wareId + "&wareDw="+wareDw+"&minUnit="+minUnit+"",
            success: function (data) {
                if (data == '1') {

                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function changeWareScale(obj, wareId) {
        var row =  $(obj).closest('tr');
        var bUnit = $(row).find("input[name='bUnit']").val();
        var sUnit = $(row).find("input[name='sUnit']").val();
        $.ajax({
            url: "manager/updateWareScale",
            type: "post",
            data: "id=" + wareId + "&bUnit="+bUnit+"&sUnit="+sUnit+"",
            success: function (data) {
                if (data == '1') {

                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function selectCell(o){
        o.select();
    }

</script>
</body>
</html>
