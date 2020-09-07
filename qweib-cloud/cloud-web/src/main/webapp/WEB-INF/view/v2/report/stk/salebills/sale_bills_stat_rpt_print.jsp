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
    <input id="btnShowAll" value="取消隐藏" style=" width:80px; height:22px; font-size:16px;" type="button" onclick="javascript:showAll()"/>
    <input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()">

    <span style="font-size: 12px">注:对应列不需要打印可<span style="color: red">双击隐藏</span></span>
</div>
<div id="printcontent" style="width:100%;text-align: center">
    <table style="padding-left:30px;width: 95%">
        <td width="30%"></td>
        <td style="font-size: 18px;font-weight: bold;text-align: center">销售票据明细表</td>
        <td width="30%" style="text-align: right;vertical-align:bottom;padding-right: 10px;font-size: 11px;">
            日期:${query.sdate}--${query.edate}
        </td>
    </table>
    <table style="padding-left: 30px;width: 95%;border-collapse: collapse;">
        <thead>
        <tr>
            <td class="number"  ondblclick="showColumn('number')" style="width:40px;font-weight:bold;border:1px solid #000000;">序号</td>
            <td class="billNo" style="width:140px;font-weight:bold;border:1px solid #000000;" ondblclick="showColumn('billNo')">
                <c:if test="${query.timeType eq 1}">
                    发货日期
                </c:if>
                <c:if test="${query.timeType eq 2}">
                    销售日期
                </c:if>
            </td>
            <td class="proName"  ondblclick="showColumn('proName')" style="width:140px;font-weight:bold;border:1px solid #000000;">客户名称</td>
            <td class="wareNm"  ondblclick="showColumn('wareNm')" style="width:120px;text-align: center;border:1px solid #000000;">商品名称</td>
            <td class="xsTp"  ondblclick="showColumn('xsTp')" style="width:100px;text-align: center;border:1px solid #000000;">销售类型</td>
            <td class="unitName"  ondblclick="showColumn('unitName')" style="width:120px;text-align: center;border:1px solid #000000;">计量单位</td>
            <td class="price"  ondblclick="showColumn('price')" style="width:100px;text-align: center;border:1px solid #000000;">价格</td>
            <td class="qty"  ondblclick="showColumn('qty')"  style="width:100px;text-align: center;border:1px solid #000000;">销售数量</td>
            <td class="outQty"  ondblclick="showColumn('outQty')" style="width:100px;text-align: center;border:1px solid #000000;">发货数量</td>
            <td class="minUnitName"  ondblclick="showColumn('minUnitName')" style="width:120px;text-align: center;border:1px solid #000000;">计量单位(小)</td>
            <td class="minPrice"  ondblclick="showColumn('minPrice')" style="width:100px;text-align: center;border:1px solid #000000;">价格(小)</td>
            <td class="minQty"  ondblclick="showColumn('minQty')"  style="width:100px;text-align: center;border:1px solid #000000;">销售数量(小)</td>
            <td class="minOutQty"  ondblclick="showColumn('minOutQty')" style="width:100px;text-align: center;border:1px solid #000000;">发货数量(小)</td>
            <td class="amt"  ondblclick="showColumn('amt')" style="width:100px;text-align: center;border:1px solid #000000;">销售金额</td>
            <td class="outAmt"  ondblclick="showColumn('outAmt')" style="width:100px;text-align: center;border:1px solid #000000;">发货金额</td>
            <td class="proTel"  ondblclick="showColumn('proTel')" style="width:100px;text-align: center;border:1px solid #000000;">客户电话</td>
            <td class="address"  ondblclick="showColumn('address')" style="width:100px;text-align: center;border:1px solid #000000;">客户地址</td>
        </tr>
        </thead>
        <tbody id="chooselist">
        </tbody>
        <c:forEach items="${datas}" var="item" varStatus="s">
            <tr>
                <td class="number" ondblclick="showColumn('number')" style="border:1px solid #999999;">${s.index+1}</td>
                <td class="billNo" ondblclick="showColumn('billNo')" style="border:1px solid #999999;">${item.billNo}</td>
                <td class="proName" ondblclick="showColumn('proName')" style="border:1px solid #999999;">${item.proName}</td>
                <td class="wareNm" ondblclick="showColumn('wareNm')" style="border:1px solid #999999;">
                        ${item.wareNm}
                </td>
                <td class="xsTp" ondblclick="showColumn('xsTp')" style="border:1px solid #999999;">${item.xsTp}</td>
                <td class="unitName" ondblclick="showColumn('unitName')" style="border:1px solid #999999;">${item.unitName}</td>
                <td class="price" ondblclick="showColumn('price')" style="border:1px solid #999999;">
                    <fmt:formatNumber value="${item.price}" pattern="#,###.##"/>
                </td>
                <td class="qty" ondblclick="showColumn('qty')" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.qty}" pattern="#,###.0#"/>
                </td>
                <td class="outQty" ondblclick="showColumn('outQty')" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.outQty}" pattern="#,###.##"/>
                </td>
                <td class="minUnitName" ondblclick="showColumn('minUnitName')" style="border:1px solid #999999;">${item.minUnitName}</td>
                <td class="minPrice" ondblclick="showColumn('minPrice')" style="border:1px solid #999999;">
                    <fmt:formatNumber value="${item.minPrice}" pattern="#,###.##"/>
                </td>
                <td class="minQty" ondblclick="showColumn('minQty')" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.minQty}" pattern="#,###.0#"/>
                </td>
                <td class="minOutQty" ondblclick="showColumn('minOutQty')" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.minOutQty}" pattern="#,###.##"/>
                </td>
                <td class="amt" ondblclick="showColumn('amt')" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.amt}" pattern="#,###.##"/>
                </td>
                <td class="outAmt" ondblclick="showColumn('outAmt')" style="border:1px solid #999999;text-align: right;padding-right: 10px">
                    <fmt:formatNumber value="${item.outAmt}" pattern="#,###.##"/>
                </td>
                <td class="proTel" ondblclick="showColumn('proTel')" style="border:1px solid #999999;">${item.proTel}</td>
                <td class="address" ondblclick="showColumn('address')" style="border:1px solid #999999;">${item.address}</td>
            </tr>
        </c:forEach>
    </table>
</div>
<script>
    $(function () {filterField();})
    function filterField(){
        if('${query.filterDataType}'==1){
            $(".qty").show();
            $(".outQty").show();
            $(".minQty").hide();
            $(".minOutQty").hide();
            $(".minUnitName").hide();
            $(".minPrice").hide();
        }else if('${query.filterDataType}'==2){
            $(".minQty").show();
            $(".minOutQty").show();
            $(".qty").hide();
            $(".outQty").hide();
            $(".unitName").hide();
            $(".price").hide();
        }else if('${query.filterDataType}'==3){
            $(".minQty").show();
            $(".minOutQty").show();
            $(".minOutQty").show();
            $(".minUnitName").show();
            $(".qty").show();
            $(".outQty").show();
            $(".unitName").show();
            $(".price").show();
        }
        var timeType = ${query.timeType};
        if(timeType==1){
            $(".qty").hide();
            $(".minQty").hide();
            $(".amt").hide();
        }else{
            $(".amt").show();
            if(filterDataType==1){
                $(".qty").show();
            }
            if(filterDataType==2||filterDataType==3){
                $(".minQty").show();
            }
        }
    }

    function  showColumn(field) {
        $("."+field).hide();
    }

    function  showAll() {
        document.location.reload();
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
