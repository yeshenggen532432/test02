<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
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
        td{height:26px;text-align: center;font-size:11px;color:#000000;}
        td.waretd{border:1px solid #999999;}
    </style>
</head>
<body style="text-align: center">
<div id="printbtn" style=" width:100%;text-align: center; margin:10px auto;">
    <input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()">
</div>
<div id="printcontent" style="width:100%;text-align: center">
    <table style="padding-left:30px;width: 95%">
        <td width="30%"></td>
        <td style="font-size: 18px;font-weight: bold;text-align: center">销售票据明细表</td>
        <td width="30%" style="text-align: right;vertical-align:bottom;padding-right: 10px;font-size: 11px;">
            日期:${sdate}--${edate}
        </td>
    </table>
    <table style="padding-left: 30px;width: 95%;border-collapse: collapse;">
        <thead>
        <tr>
            <td style="width:40px;font-weight:bold;border:1px solid #000000;">序号</td>
            <td style="width:140px;font-weight:bold;border:1px solid #000000;">单号</td>
            <td style="width:140px;font-weight:bold;border:1px solid #000000;">客户名称</td>
            <td class="products" style="width:120px;text-align: center;border:1px solid #000000;">商品名称</td>
            <td class="products xsTp" style="width:100px;text-align: center;border:1px solid #000000;">销售类型</td>
            <td class="products" style="width:120px;text-align: center;border:1px solid #000000;">计量单位</td>
            <td class="products" style="width:100px;text-align: center;border:1px solid #000000;">价格</td>
            <td class="qty"  style="width:100px;text-align: center;border:1px solid #000000;">销售数量</td>
            <td class="outQty" style="width:100px;text-align: center;border:1px solid #000000;">发货数量</td>
            <td style="width:100px;text-align: center;border:1px solid #000000;">销售金额</td>
            <td style="width:100px;text-align: center;border:1px solid #000000;">发货金额</td>

        </tr>
        </thead>
        <tbody id="chooselist">
        </tbody>
        <c:forEach items="${datas}" var="item" varStatus="s">
            <tr>
                <td style="border:1px solid #999999;">${s.index+1}</td>
                <td style="border:1px solid #999999;">${item.docNo}</td>
                <td style="border:1px solid #999999;">${item.khNm}</td>
                <td class="products" style="border:1px solid #999999;">
                        ${item.wareNm}
                </td>
                <td class="products xsTp" style="border:1px solid #999999;">${item.xsTp}</td>
                <td class="products" style="border:1px solid #999999;">${item.unitName}</td>
                <td class="products" style="border:1px solid #999999;">${item.price}</td>
                <td class="qty" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.qty}" pattern="#,###.0#"/>
                </td>
                <td class="outQty" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.outQty}" pattern="#,###.##"/>
                </td>
                <td style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.amt}" pattern="#,###.##"/>
                </td>
                <td style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.outAmt}" pattern="#,###.##"/>
                </td>

            </tr>
        </c:forEach>
    </table>
</div>
<script>

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
