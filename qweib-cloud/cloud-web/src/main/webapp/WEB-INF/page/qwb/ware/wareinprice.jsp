<%@ page language="java" pageEncoding="UTF-8" %>
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
    <table style="width: 250px" border="1"
           cellpadding="0" cellspacing="1">
        <thead>
        <tr>
            <th style="width: 40px">序号</th>
            <th style="width: 60px">商品名称</th>
            <th style="width: 80px">采购价</th>
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
                <td>
                    <input name="inPrice" id="inPrice" type="text" style="border: 0px solid #ddd;width: 100px"
                           onkeyup="CheckInFloat(this)" value="${data.inPrice}"
                           onchange="changeInPrice(this,${data.wareId})"/>
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
                    //alert("操作成功");
                    //queryWare();
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

</script>
</body>
</html>
