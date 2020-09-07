<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>配货单打印</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <link href="https://cdn.bootcss.com/quill/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.bootcss.com/quill/1.3.6/quill.min.js"></script>

    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        function formatQty(v,hsNum,unitName,minUnit) {
            if (hsNum > 1) {
                var str = v + "";
                if (str.indexOf(".") != -1) {
                    var nums = str.split(".");
                    var num1 = nums[0];
                    var num2 = nums[1];
                    if (parseFloat(num2) > 0) {
                        var minQty = parseFloat(0 + "." + num2) * parseFloat(hsNum);
                        minQty = (Math.floor(minQty * 100) / 100)
                        document.write(num1 + "" + unitName + "" + minQty + "" + minUnit);
                        return;
                    }
                }
            }
            v = (Math.floor(v * 100) / 100)
            document.write(v + unitName);
        }
    </script>
    <style>
        table {
            width: 100%;
        }

        td {
            height: 16px;
            text-align: center;
            font-family: '微软雅黑';
            font-size: 14px;
            color: #000000;
        }

        td.waretd {
            border: 1px solid #000000;
        }

        .form .form-item {
            margin-bottom: 5px;
            vertical-align: top;
            line-height: 24px;
        }

        .form .form-item .form-label {
            text-align: right;
            width: 120px;
            vertical-align: middle;
            float: left;
        }

        .form .form-item .form-label.required:before {
            content: "*";
            display: inline-block;
            line-height: 1;
            font-size: 12px;
            color: #ed4014;
        }

        .form .form-item .form-content {
            margin-left: 120px;
            position: relative;
            vertical-align: middle;
        }

        .qrcode-wrapper {
            font-size: 10px;
            display: inline-block;
        }

        .qrcode-wrapper .qrcode-text {
            float: left;
        }

        .qrcode {
            margin-left: 5px;
            width: 80px;
            height: 80px;
            margin-bottom: 5px;
        }

        td:last-child {
            border-bottom: none !important;
        }

        .page-break {
            background: 0 0;
            border-top: 1px dashed gray;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        @media print {
            .page-break {
                border-top: none;
            }
        }
    </style>
</head>
<body>
<input type="hidden" id="billId" value="${billId}"/>
<div id="printbtn" style=" width:100%;text-align: center; margin:5px auto;">
    <%--<input id="btnBillMes" value="配送信息" class="easyui-linkbutton" style=" width:70px; height:22px; "--%>
           <%--type="button" onclick="showBill()">--%>

    <input id="btnPrint" value="打印" class="easyui-linkbutton" style=" width:50px; height:22px; "
           type="button" onclick="printit()">
</div>
<div style=" text-align: center; margin:10px auto;width:794px;height:540px;" id="printcontent">
    <div id="header">
        <table style="border-color: #000000;width:794px;">
            <tr>
                <td colspan="6" style="">
                    <table>
                        <td style="width: 180px;">
                        <span style="font-size: 10px"></span>
                        </td>
                        <td align="center" rowspan="2">
    				 <span style="font-size:22px;color:#000000;font-weight:bold;">
    				 	配货单
	   		 		  </span>
                        </td>
                        <td rowspan="2" width="250px">

                        </td>
                        <tr>
                            <td style="font-size: 10px">

                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table class="tbody" cellpadding="0" cellspacing="1" style="border-color: #000000;width:794px;">
            <tr>
                <td style="text-align: right;padding-right: 1px;width: 65px">配货仓库:</td>
                <td style="text-align: left;padding-left: 1px;width: 180px">${invoice.stkName}</td>
                <td style="text-align: right;padding-right: 1px;width: 65px">配货日期:</td>
                <td style="text-align: left;padding-left: 1px;width: 110px">
                    ${fn:substring(invoice.billTimeStr, 0 , 10)}
                </td>
                <td style="text-align: right;padding-right: 1px;width: 65px">单&nbsp;&nbsp;号:
                </td>
                <td style="text-align: left;padding-left: 1px">${invoice.billNo}</td>
            </tr>
        </table>
    </div>
    <table style="border-collapse: collapse;">
        <tr>
            <td style="font-weight:bold;border:1px solid #000000;width:6px">
                no.
            </td>
            <td style="font-weight:bold;border:1px solid #999999;">产品编号</td>
            <td style="font-weight:bold;border:1px solid #999999;">产品名称</td>
            <td style="font-weight:bold;border:1px solid #999999;">规格</td>
            <td style="font-weight:bold;border:1px solid #999999;display: none">单位</td>
            <td style="font-weight:bold;border:1px solid #999999;">配货数量</td>
            <td   rowspan="${len+1}" style="border:1px solid #999999;">
                <table>
                    <tr>
                        <td>关联单据</td>
                    </tr>
                    <c:forEach items="${billMap}" var="item">
                        <tr>
                            <td>${item.value}</td>
                        </tr>
                    </c:forEach>

                    </tbody>
                </table>
            </td>
        </tr>
        <c:set var="sumQty" value="0"/>
        <c:set var="sumAmt" value="0"/>
        <c:forEach items="${invoice.mergeList}" var="item"  varStatus="s">
            <tr>
                <td style="border:1px solid #000000;">
                        ${s.index +1}
                </td>
                <td style="border:1px solid #999999;">${item.ware_code}</td>
                <td style="border:1px solid #999999;text-align: left">${item.ware_nm}</td>
                <td style="border:1px solid #999999;text-align: left">${item.ware_gg}</td>
                <td style="border:1px solid #999999;text-align: left;display: none">${item.unit_name}</td>
                <td style="border:1px solid #999999;">

                    <script type="text/javascript">
                        formatQty('${item.qty}','${item.hs_num}','${item.unit_name}','${item.min_unit}');
                    </script>
                </td>
            </tr>
            <c:set var="sumQty" value="${sumQty+item.qty}"/>
        </c:forEach>
        <tr style="border:1px solid #999999;">
            <td style="border:1px solid #999999;" colspan="2">合计</td>
            <td style="border:1px solid #999999;"></td>
            <td style="border:1px solid #999999;"></td>
            <td style="border:1px solid #999999;display: none"></td>
            <td style="border:1px solid #999999;border-bottom:1px solid #999999; ">
                <fmt:formatNumber value="${sumQty}" pattern="#0.00" />
            </td>
            <td style="border:1px solid #999999;"></td>
        </tr>
    </table>

</div>

<scirpt type="text/javascript" src="<%=basePath %>/resource/printadapter.js?v=1"></scirpt>
<script type="text/javascript">
    function doPrint() {
        window.print();
    }
    function printit()
    {
        //if (confirm('确定打印吗？')){
        var newstr = document.getElementById('printcontent').innerHTML;
        var oldstr = document.body.innerHTML;//
        document.body.innerHTML = newstr;
        window.print();
        document.body.innerHTML = oldstr;
        return false;
        //	}
    }


</script>
</body>
</html>  



