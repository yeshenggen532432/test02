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
        td{height:26px;text-align: center;font-size:12px;color:#000000;}
        td.waretd{border:1px solid #999999;}
    </style>
</head>
<body style="text-align: center">
<div id="printbtn" style=" width:100%;text-align: center; margin:10px auto;">
    <input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()">
</div>
<div id="printcontent" style="width:100%;text-align: center">
    <table style="padding-left:30px;width: 95%">
        <tr>
            <td width="30%"></td>
            <td style="font-size: 18px;font-weight: bold;text-align: center">商品类别销售统计表</td>
            <td width="30%" style="text-align: right;vertical-align:bottom;padding-right: 10px;font-size: 11px;">
                日期:${sdate}--${edate}
            </td>
        </tr>
        </tr>
    </table>
    <table style="padding-left: 30px;width: 95%;border-collapse: collapse;">
        <thead>
        <tr>
            <td style="width:40px;font-weight:bold;border:1px solid #000000;">序号</td>
            <td class="products" style="width:120px;text-align: center;border:1px solid #000000;">类别名称</td>
            <td class="price" style="width:120px;text-align: center;border:1px solid #000000;">销售均价</td>
            <td class="sumQty"  style="width:100px;text-align: center;border:1px solid #000000;">数量</td>
            <td class="minPrice" style="width:120px;text-align: center;border:1px solid #000000;">销售均价(小)</td>
            <td class="minSumQty" style="width:100px;text-align: center;border:1px solid #000000;">数量(小)</td>
            <td class="sumAmt" style="width:100px;text-align: center;border:1px solid #000000;">销售金额</td>
            <td class="freeQty" style="width:100px;text-align: center;border:1px solid #000000;">赠送数量</td>
            <td class="minFreeQty" style="width:100px;text-align: center;border:1px solid #000000;">赠送数量(小)</td>
        </tr>
        </thead>
        <tbody id="chooselist">
        </tbody>
        <c:forEach items="${datas}" var="item" varStatus="s">
            <tr>
                <td style="border:1px solid #999999;">${s.index+1}</td>

                <td class="products" style="border:1px solid #999999;">${item.typeName}</td>
                <td class="price" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.price}" pattern="#,###.##"/>
                </td>
                <td class="sumQty" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.sumQty}" pattern="#,###.##"/>
                </td>
                <td class="minPrice" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.minPrice}" pattern="#,###.##"/>
                </td>
                <td class="minSumQty" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.minSumQty}" pattern="#,###.##"/>
                </td>
                <td style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.sumAmt}" pattern="#,###.##"/>
                </td>
                <td class="freeQty" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.freeQty}" pattern="#,###.##"/>
                </td>
                <td class="minFreeQty" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.minFreeQty}" pattern="#,###.##"/>
                </td>

            </tr>
        </c:forEach>
    </table>
</div>
<script>
    $(function () {filterField();})
    function filterField(){
        if('${filterDataType}'==1){
            $(".price").show();
            $(".sumQty").show();
            $(".freeQty").show();
            $(".minPrice").hide();
            $(".minSumQty").hide();
            $(".minFreeQty").hide();
        }else if('${filterDataType}'==2){
            $(".price").hide();
            $(".sumQty").hide();
            $(".freeQty").hide();
            $(".minPrice").show();
            $(".minSumQty").show();
            $(".minFreeQty").show();
        }else if('${filterDataType}'==3){
            $(".price").show();
            $(".sumQty").show();
            $(".freeQty").show();
            $(".minPrice").show();
            $(".minSumQty").show();
            $(".minFreeQty").show();
        }
    }
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
