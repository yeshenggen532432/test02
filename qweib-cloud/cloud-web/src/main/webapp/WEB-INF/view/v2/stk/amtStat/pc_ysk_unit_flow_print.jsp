<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="Generator" content="EditPlus®">
    <meta name="Author" content="">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>

    <style>
        table{width:794px;}
        td{height:26px;text-align: center;font-size:12px;<br/>color:#000000;}
        td.waretd{border:1px solid #999999;}
    </style>
</head>
<body>
<div id="printbtn" style=" width:100%;text-align: center; margin:10px auto;">
    <input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()">
</div>
<div id="printcontent" style="width: 794px; text-align: center; margin: 10px auto;">
    <table style="border-collapse: collapse;">
        <thead>
        <tr>
            <td style="font-weight:bold;border:1px solid #000000;">类型</td>
            <td style="font-weight:bold;border:1px solid #000000;">日期</td>
            <td style="font-weight:bold;border:1px solid #000000;">单号</td>
            <td style="font-weight:bold;border:1px solid #000000;">往来单位</td>
            <td style="font-weight:bold;border:1px solid #000000;">增加</td>
            <td style="font-weight:bold;border:1px solid #000000;">减少</td>
            <td style="font-weight:bold;border:1px solid #000000;">结余</td>
        </tr>
        </thead>
        <tbody id="chooselist">
        </tbody>
        <c:forEach items="${datas}" var="item" >
            <tr>
                <td style="border:1px solid #999999;">${item["bill_name"]}</td>
                <td style="border:1px solid #999999;">${item["bill_time"]}</td>
                <td style="border:1px solid #999999;">${item["bill_no"]}</td>
                <td style="border:1px solid #999999;">${item["unit_name"]}</td>
                <td style="border:1px solid #999999;">${item["in_amt"]}</td>
                <td style="border:1px solid #999999;">${item["out_amt"]}</td>
                <td style="border:1px solid #999999;">${item["left_amt"]}</td>
            </tr>
        </c:forEach>
    </table>
</div>

<script type="text/javascript">
    function doPrint() {
        window.print();
    }
    function printit()
    {
        var newstr = document.getElementById('printcontent').innerHTML;
        var oldstr = document.body.innerHTML;//
        document.body.innerHTML = newstr;
        window.print();
        document.body.innerHTML = oldstr;
        return false;
    }
</script>
</body>
</html>
