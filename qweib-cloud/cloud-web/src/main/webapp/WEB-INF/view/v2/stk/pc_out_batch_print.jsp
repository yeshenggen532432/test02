<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售单据单据批量打印</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <style>
        table {
            width: 100%;
        }

        .content tr td:last-child {
            border-bottom: none !important;
        }

        .page-break {
            background: 0 0;
            border-bottom: 1px dashed gray;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }
        @media print {
            .page-break {
                visibility: hidden;
                border-bottom: none;
            }

            body * {
                visibility: hidden;
            }

            .layui-card-header {
                display: none;
            }

            .preview {
                margin: 0;
            }

            #preview-wrapper, #preview-wrapper * {
                visibility: visible;
            }
        }

        .print-settings label {
            text-align: right;
        }

        .print-settings .w-e-text-container {
            height: 150px !important;
        }

        .print-settings .k-checkbox-label {
            padding-left: 20px;
            margin-right: 10px;
        }

        .print-settings .form-group {
            margin-bottom: 10px;
        }

        .print-settings .form-group .control-label:after {
            content: ':'
        }

        .layui-card-body {
            line-height: inherit !important;
        }

        .aggregate-footer td {
            border-bottom: 1px solid #000;
        }

        .aggregate-footer td:first-child {
            border-left: 1px solid #000;
        }

        .aggregate-footer td:last-child {
            border-bottom: 1px solid #000 !important;
            border-right: 1px solid #000;
        }

        label{
            margin-bottom: 0px!important;
        }
    </style>
    <script>
        function formatQty(hsNum,minSumQty,maxUnitName,minUnitName) {
            hsNum = parseFloat(hsNum) || 1;
            minSumQty = parseFloat(minSumQty)||0;
            var result = "";
            if((hsNum+"").indexOf(".")!=-1){
                var sumQty = minSumQty/hsNum;
                var str = sumQty+"";
                if(str.indexOf(".")!=-1){
                    var nums = str.split(".");
                    var num1 = nums[0];
                    var num2 = nums[1];
                    if(parseFloat(num2)>0){
                        var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);
                        minQty = minQty.toFixed(2);
                        result = num1+""+maxUnitName+""+minQty+""+minUnitName;
                    }
                }else{
                    result = sumQty+maxUnitName;
                }
            }else{
                var remainder = (minSumQty) % (hsNum);
                if (remainder === 0) {
                    //整数件
                    result += '<span>' + minSumQty / hsNum + '</span>' +maxUnitName;
                } else if (remainder === minSumQty) {
                    //不足一件
                    var minQty =   Math.floor(minSumQty*100)/100;
                    result += '<span>' + minQty + '</span>' + minUnitName;
                } else {
                    //N件有余
                    var minQty = Math.floor(remainder*100)/100;
                    result += '<span>' + parseInt(minSumQty / hsNum) + '</span>' + maxUnitName + '<span>' + minQty + '</span>' + minUnitName;
                }
            }
            document.write(result);
            //return result;
        }
    </script>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-header" style="font-size: 12px;text-align: center">
            <button uglcw-role="button" onclick="printit()" uglcw-options="icon:'print'">打印
            </button>
            <label>模板名称：</label>
            <tag:select2 width="220px" name="templateId" id="templateId" value="${templateId}"
                         onchange="changeTemplate(this)" tableName="stk_print_template"
                         displayKey="id" displayValue="fd_name" whereBlock="fd_type='1'">
            </tag:select2>

            <input type="checkbox" class="k-checkbox"
                   uglcw-value="1"
                   uglcw-role="checkbox"
                   id="ishowBill">
            <label style="margin-left: 10px;" class="k-checkbox-label" for="ishowBill">显示单据</label>

            <input type="checkbox" class="k-checkbox"
                   uglcw-value="0"
                   uglcw-role="checkbox"
                   id="ishowGroupWare">
            <label style="margin-left: 10px;" class="k-checkbox-label" for="ishowGroupWare">显示按商品信息统计</label>


        </div>
        <div
                class="layui-card-body preview">
            <div style="width: 794px; margin: 0 auto;">
                <div style=" text-align: center; margin:10px auto;width:100%;" id="preview-wrapper">
                    <style>
                        blockquote, body, button, dd, div, dl, dt, form, h1, h2, h3, h4, h5, h6, input, li, ol, p, pre, td, textarea, th, ul {
                            margin: 0;
                            padding: 0;
                        }

                        .preview td {
                            height: 16px;
                            text-align: center;
                            font-family: "微软雅黑", "宋体";
                            font-size: 14px;
                            color: #000000;
                        }

                        .content tr td:last-child {
                            border-bottom: none !important;
                        }

                        .aggregate-footer td {
                            border-bottom: 1px solid #000;
                        }

                        .aggregate-footer td:first-child {
                            border-left: 1px solid #000;
                        }

                        .aggregate-footer td:last-child {
                            border-bottom: 1px solid #000 !important;
                            border-right: 1px solid #000;
                        }
                    </style>
                    <div id="showBill">
                    <c:forEach items="${mainDatas}" var="main">
                        <div style="page-break-before: always;"></div>
                        <div id="header">

                            <table style="width: 100%">
                                <tbody>
                                <tr>
                                    <td style="width: 180px;">
                            <span style="font-size: 10px">
                                <c:if test="${not empty printSettings.other2}">工商号:${printSettings.other2 }</c:if>
                            </span>
                                        <div style="margin-top: 5px;">
                                            页码:<span class="pagination">1/1</span>
                                            <c:if test="${printSettings.displayStk != null and printSettings.displayStk > 0}">&nbsp;&nbsp;&nbsp;&nbsp;仓库:<span> ${main.stkName}</span></c:if>
                                        </div>
                                    </td>
                                    <td align="center">
    				 <span style="font-size:22px;color:#000000;font-weight:bold;">
    				 	<c:choose>
                            <c:when test="${main.outType eq '销售出库' }">${printSettings.title}</c:when>
                            <c:when test="${main.outType eq '报损出库' }">报损出库单</c:when>
                            <c:when test="${main.outType eq '领用出库' }">领用出库单</c:when>
                            <c:otherwise>其它出库单</c:otherwise>
                        </c:choose>
	   		 		  </span>
                                    </td>
                                    <td style="width: 250px;">
                                        <div style="display: inline;">
                                            <c:if test="${printSettings.displayWxpay > 0 and not empty printSettings.wxpayQrcode}">
                                                <div class="qrcode-wrapper"
                                                     style="font-size: 10px; display: inline-block;">
                                        <span class="qrcode-text" style="float: left"><p
                                                style="margin:0;padding: 0;">微</p><pstyle="margin:0;padding: 0;">信</p>
                                            <p>收</p><p>款</p></span>
                                                    <img
                                                            style='
                                                                    margin-left: 5px;margin-bottom: 5px;
                                                            <c:if test="${printSettings.qrcodeWidth>0}">width:${printSettings.qrcodeWidth}px;</c:if>
                                                            <c:if test="${printSettings.qrcodeHeight>0}">height:${printSettings.qrcodeHeight}px;</c:if>'
                                                            src="${printSettings.wxpayQrcode}" class="qrcode">
                                                </div>
                                            </c:if>
                                            <c:if test="${printSettings.displayAlipay > 0 and not empty printSettings.alipayQrcode}">
                                                <div class="qrcode-wrapper"
                                                     style="font-size: 10px; display: inline-block;">
                                        <span class="qrcode-text"
                                              style="float: left"><p>支</p><p>付</p><p>宝</p><p>收</p><p>款</p></span>
                                                    <img
                                                            style='
                                                                    margin-left: 5px;margin-bottom: 5px;
                                                            <c:if test="${printSettings.qrcodeWidth>0}">width:${printSettings.qrcodeWidth}px;</c:if>
                                                            <c:if test="${printSettings.qrcodeHeight>0}">height:${printSettings.qrcodeHeight}px;</c:if>'
                                                            src="${printSettings.alipayQrcode}" class="qrcode last">
                                                </div>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>

                            <table class="tbody" border="${printSettings.displayBorder}" cellpadding="0" cellspacing="1"
                                   style="
                                   <c:if test="${printSettings.masterFontsize>0}">font-size:${printSettings.masterFontsize}px;</c:if> border-color: #000000;width:100%;">
                                <tr
                                        <c:if test="${printSettings.masterHeight > 0}">style="height: ${printSettings.masterHeight}px;"</c:if> >
                                    <td style="text-align: right;padding-right: 1px">
                                        客户名称:
                                    </td>
                                    <td style="<c:if
                                            test="${printSettings.masterFontsize>0}">font-size:${printSettings.masterFontsize}px;</c:if>font-weight: bold;text-align: left;padding-left: 1px">${main.khNm}</td>
                                    <td style="text-align: right;padding-right: 1px">电&nbsp;&nbsp;话:</td>
                                    <td style="text-align: left;padding-left: 1px">${main.tel}</td>
                                    <td style="text-align: right;padding-right: 1px">地&nbsp;&nbsp;址:</td>
                                    <td style="text-align: left;padding-left: 1px">${main.address }</td>
                                </tr>
                                <tr
                                        <c:if test="${printSettings.masterHeight > 0}">style="height: ${printSettings.masterHeight}px;"</c:if> >
                                    <td style="text-align: right;padding-right: 1px;width: 65px">配送指定:</td>
                                    <td style="text-align: left;padding-left: 1px;width: 180px">
                                        <c:choose>
                                            <c:when test="${main.pszd eq '公司直送'}">
                                                ${not empty printSettings.gszsName?printSettings.gszsName:main.pszd}
                                            </c:when>
                                            <c:otherwise>
                                                ${pszd}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: right;padding-right: 1px;width: 65px">日&nbsp;&nbsp;期:
                                    </td>
                                    <td style="text-align: left;padding-left: 1px;width: 110px">
                                            ${fn:substring(main.outDate, 0 , 10)}
                                    </td>
                                    <td style="text-align: right;padding-right: 1px;width: 65px">单&nbsp;&nbsp;号:
                                    </td>
                                    <td style="text-align: left;padding-left: 1px">${main.billNo}</td>
                                        <%--
                                        <td style="text-align: right;padding-right: 1px;width: 65px">单据日期：</td>
                                        <td style="text-align: left;padding-left: 1px">${outTime}</td>
                                        --%>
                                </tr>
                                <c:choose>
                                    <c:when test="${pszd eq '直供转单二批' and  printSettings.displayEp != null and printSettings.displayEp > 0}">
                                        <tr
                                                <c:if test="${printSettings.masterHeight > 0}">style="height: ${printSettings.masterHeight}px;"</c:if> >
                                            <td style="text-align: right;padding-right: 1px;">所属二批:</td>
                                            <td style="text-align: left;padding-left: 1px;">${main.epCustomerName}</td>
                                            <td style="text-align: right;padding-right: 1px;"></td>
                                            <td style="text-align: left;padding-left: 1px;"></td>
                                            <td style="text-align: right;padding-right: 1px;"></td>
                                            <td style="text-align: left;padding-left: 1px"></td>
                                        </tr>
                                    </c:when>
                                </c:choose>

                                <tr
                                        <c:if test="${printSettings.masterHeight > 0}">style="height: ${printSettings.masterHeight}px;"</c:if> >
                                    <td style="text-align: right;padding-right: 1px">备&nbsp;&nbsp;注:</td>
                                    <td style="text-align: left;" colspan="3">${main.remarks}</td>
                                    <c:if test="${printSettings.displayCustomerDept>0}">
                                        <%--<td style="text-align: right;width:70px;">累计应收:</td>--%>
                                        <%--<td style="text-align: left">${customerDept.sumamt}</td>--%>
                                    </c:if>
                                </tr>
                            </table>
                        </div>
                        <table id="content" style="border-collapse: collapse;">
                            <thead class="content">
                            <tr>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:6px">
                                    no.
                                </td>
                                <c:forEach items="${datas }" var="data">
                                    <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:${data.fdWidth}%;">${data.fdFieldName }</td>
                                </c:forEach>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                            </thead>
                            <tbody id="chooselist" class="content">
                            <c:forEach items="${main.maps}" var="item" varStatus="s">
                                <tr
                                        <c:if test="${printSettings.slaveHeight>0}">style="height: ${printSettings.slaveHeight}px;"</c:if>>
                                    <td style="border:1px solid #000000; text-align: center">
                                            ${s.index +1}
                                    </td>
                                    <c:forEach items="${datas }" var="data">
                                    <td style="border:1px solid #000000;
                                    <c:if
                                            test="${data.fdFontsize>0}">font-size:${data.fdFontsize}px;</c:if>
                                    <c:choose>
                                    <c:when test="${data.fdAlign == 1}">text-align: left;</c:when>
                                    <c:when test="${data.fdAlign == 2}">text-align: right;</c:when>
                                    <c:otherwise>text-align: center;</c:otherwise>
                                            </c:choose>">
                                        <c:choose>
                                        <c:when test="${data.fdFieldKey eq 'beBarCode'}">
                                        <c:if test="${item['beUnit'] eq 'B'}">
                                            ${item['packBarCode'] }
                                        </c:if>
                                        <c:if test="${item['beUnit'] eq 'S'}">
                                            ${item['beBarCode'] }
                                        </c:if>
                                        </c:when>
                                        <c:when test="${data.fdFieldKey eq 'wareNm'}">
                                            ${item[data.fdFieldKey] }
                                        </c:when>
                                        <c:when test="${data.fdFieldKey eq 'unitSummary'}">
                                            ${item[data.fdFieldKey] }
                                        </c:when>
                                        <c:when test="${data.fdFieldKey eq 'qty'}">
                                            ${fns:shapeField(item[data.fdFieldKey], data.fdDecimals)}
                                        </c:when>
                                        <c:when test="${data.fdFieldKey eq 'price'}">
                                            ${fns:shapeField(item[data.fdFieldKey], data.fdDecimals)}
                                        </c:when>
                                        <c:otherwise>
                                            ${fns:shapeField(item[data.fdFieldKey], data.fdDecimals)}
                                        </c:otherwise>
                                        </c:choose>
                                        </c:forEach>
                                    <td>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                            <tr class="aggregate-footer">
                                <td class="aggregate-rownum">
                                    <c:set var="coLen" value="0"/>
                                </td>
                                <c:forEach items="${datas }" var="data" varStatus="k">
                                    <c:choose>
                                        <c:when test="${data.fdFieldKey eq 'amt'}">
                                            <td class="aggregate">
                                                    ${main.totalAmt}
                                            </td>
                                        </c:when>
                                        <c:when test="${data.fdFieldKey eq 'qty'}">
                                            <td class="aggregate">
                                                <script>
                                                    var sumQty = ${main.sumQty };
                                                    sumQty = parseFloat(sumQty);
                                                    document.write(sumQty)
                                                </script>
                                            </td>
                                        </c:when>
                                        <c:when test="${data.fdFieldKey eq 'price'}">
                                            <td>

                                            </td>
                                        </c:when>
                                        <c:otherwise>
                                            <td style="text-align: left;"
                                                <c:if test="${k.index == 0}">class="aggregate-txt"</c:if>>
                                                <c:if test="${k.index == 0}">合计：${fns:convertNumberToChinese(main.totalAmt)}</c:if>
                                            </td>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </tr>
                        </table>
                        <div id="footer">
                            <table style="width:100%;">
                                <tr>
                                    <td colspan="6" style="text-align: left;padding-left: 10px">
                                        <c:if test="${printSettings.displayUnitCount>0}">大单位合计:${main.bigUnitCount}&nbsp;&nbsp;小单位合计:${main.smallUnitCount}&nbsp;&nbsp;</c:if>
                                        <c:if test="${printSettings.displayAmt>0}">
                                            整单折扣:${main.discount}&nbsp;&nbsp;应收金额:${main.disAmt}&nbsp;&nbsp;
                                        </c:if>
                                        <c:if
                                                test="${printSettings.displaySalesman > 0}">业务员:${main.staff }&nbsp;&nbsp;${main.staffTel}</c:if>&nbsp;&nbsp;制单人:${main.operator}&nbsp;&nbsp;咨询电话:${printSettings.tel}&nbsp;&nbsp;
                                    </td>
                                </tr>
                                <c:if test="${not empty printSettings.printMemo}">
                                    <tr>
                                        <td style="text-align: left;" colspan="6">
                                            <div style="white-space: pre-wrap;">${printSettings.printMemo}</div>
                                        </td>
                                    </tr>
                                </c:if>
                                <c:if test="${not empty printSettings.other1}">
                                    <tr>
                                        <td style="text-align: left;" colspan="6">
                                            <div style="white-space: pre-wrap;">${printSettings.other1}</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </table>
                        </div>
                    </c:forEach>
                    </div>
                    <div id="showGroupWare" style="display: none;">
<%--                        <div style="page-break-after: always;"></div>--%>
                        <span style="font-size:22px;color:#000000;font-weight:bold;width: 740px">商品信息统计</span>
                        <table id="content1" style="width: 800px">
                            <thead>
                            <tr>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:30px">
                                    no.
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:140px">
                                    商品名称
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:100px">规格
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:80px">数量
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:70px">单位
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:100px">大小数量
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:100px">生产日期
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:120px">条码
                                </td>
                            </tr>
                            </thead>
                            <c:set var="totalQty" value="0"/>
                            <c:forEach items="${wareGroupDatas}" var="item" varStatus="s">
                                <tr>
                                    <td style="border:1px solid #000000; text-align: center">
                                            ${s.index +1}
                                    </td>
                                    <td style="border:1px solid #000000;">
                                            ${item['ware_nm'] }
                                    </td>
                                    <td style="border:1px solid #000000;">
                                            ${item['ware_gg'] }
                                    </td>
                                    <td style="border:1px solid #000000;">
                                            ${item['qty'] }
                                       <c:set var="totalQty" value="${item['qty']+totalQty}"/>
                                    </td>
                                    <td style="border:1px solid #000000;">
                                            ${item['unit_name'] }
                                    </td>
                                    <td style="border:1px solid #000000;">
                                        <script>
                                            formatQty('${item['hs_num'] }', '${item['min_qty'] }', '${item['unit_name'] }', '${item['min_unit'] }');
                                        </script>
<%--                                            ${item['qty'] }--%>
                                    </td>
                                    <td style="border:1px solid #000000;">
                                            ${item['product_date'] }
                                    </td>
                                    <td style="border:1px solid #000000;">
                                            ${item['pack_bar_code'] }
                                    </td>
                                </tr>
                            </c:forEach>
                            <tr>
                                <td style="border:1px solid #000000; text-align: center">
                                </td>
                                <td style="border:1px solid #000000;">
                                    合计
                                </td>
                                <td style="border:1px solid #000000;">
                                </td>
                                <td style="border:1px solid #000000;">
                                    <fmt:formatNumber value="${totalQty}" pattern="#,###.##"/>
                                </td>
                                <td style="border:1px solid #000000;">
                                </td>
                                <td style="border:1px solid #000000;">
                                </td>
                                <td style="border:1px solid #000000;">
                                </td>
                                <td style="border:1px solid #000000;">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="8">
                                    <div style="width:740px;text-align: left; word-break:break-all;">
                                    注：单据分数共(${len}份)
                                    单据号:${voucherNos}
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div style="width: 794px;margin: 0 auto;">
                <div id="preview" style="width: 100%; text-align: center; margin: 0 auto;"></div>
            </div>
        </div>
    </div>

</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/javascript">
    var editorMenus = [
        'head', 'bold', 'fontSize', 'fontName', 'italic', 'underline', 'strikeThrough', 'foreColor', 'backColor',
        'image'
    ];
    AutoPage = {
        header: null,//页面顶部显示的信息
        content: null,//页面正文TableID
        footer: null,//页面底部
        totalHeight: null,//总的高度
        tableCss: null,//正文table样式
        divID: null,//全文divID
        repeatTitle: true,
        repeatFooter: true,

        init: function (header, content, footer, totalHeight, divID, type, repeatTitle, repeatFooter) {
            AutoPage.header = header;
            AutoPage.content = content;
            AutoPage.footer = footer;
            AutoPage.totalHeight = totalHeight;
            AutoPage.divID = divID;
            AutoPage.repeatTitle = repeatTitle;
            AutoPage.repeatFooter = repeatFooter;
            //初始化分页信息
            if (type == 1)
                AutoPage.initPageSingle();
            else if (type == 2)
                AutoPage.initPageDouble();
            //隐藏原来的数据
            AutoPage.hidenContent();
            //开始分页
            //AutoPage.beginPage();

        },
        //分页 重新设定HTML内容(单行)
        initPageSingle: function () {
            var tmpRows = $("#" + AutoPage.content)[0].rows; //表格正文
            var height_tmp = 0; //一页总高度
            var html_tmp = "";  //临时存储正文
            var html_header = AutoPage.addPageBreak() + "<table style='border-collapse: collapse;'>";
            var html_foot = "</table>";
            var page = 0; //页码

            var tr0Height = tmpRows[0].clientHeight; //table标题高度
            var tr0Html = '<tr>' + tmpRows[0].innerHTML + '</tr>';//table标题内容
            height_tmp = tr0Height;
            if (AutoPage.totalHeight == 0) {
                AutoPage.totalHeight = 470;
            }
            for (var i = 1; i < tmpRows.length; i++) {
                AutoPage.removeScript(tmpRows[i]);
                var tableHeight = AutoPage.totalHeight - (page <= 1 || AutoPage.repeatTitle ? AutoPage.header.height() : 0)
                    - (AutoPage.repeatFooter ? AutoPage.footer.height() : 0);

                var trHtmp = tmpRows[i].clientHeight;//第i行高度
                if (tableHeight < trHtmp) {
                    return uglcw.ui.error('页面高度过小');
                }
                var clazz = $(tmpRows[i]).attr('class');
                var trMtmp = '<tr style="height:' + trHtmp + 'px;" ' + (clazz ? 'class="' + clazz + '"' : '') + '>' + tmpRows[i].innerHTML + '</tr>';//第i行内容
                //height_tmp += trHtmp;
                if (height_tmp + trHtmp > tableHeight) {
                    //下一页
                    console.log('------------------', height_tmp);
                    html_tmp += (html_foot + (AutoPage.repeatFooter ? AutoPage.footer.html() : '') + '</div>');
                    i--;
                    height_tmp = tr0Height;

                } else {
                    height_tmp += trHtmp;
                    if (height_tmp == tr0Height + trHtmp) {
                        html_tmp += (page <= 0 || AutoPage.repeatTitle ? AutoPage.header.html() : '') + html_header + tr0Html;
                        page++;//页码
                    }
                    html_tmp += trMtmp;
                    if (i == tmpRows.length - 1) {
                        //最后一页
                        console.log('last page------')
                        if (height_tmp + AutoPage.footer.height() > tableHeight) {
                            html_tmp += html_foot + '</div>';
                            html_tmp += AutoPage.addPageBreak() + AutoPage.footer.html() + '</div>';
                        } else {
                            html_tmp += html_foot + AutoPage.footer.html() + '</div>';
                        }
                    }
                }

            }

            $("#" + AutoPage.divID).html(html_tmp);
            var tdpagecount = $("#" + AutoPage.divID).find(".pagination");//document.getElementsByName("tdPageCount");
            for (var i = 0; i < tdpagecount.length; i++) {
                $(tdpagecount[i]).text((i + 1) + "/" + page);
            }

        },


        removeScript: function (e) {
            var scripts = e.getElementsByTagName('script')
            var i = scripts.length;
            while (i--) {
                scripts[i].parentNode.removeChild(scripts[i]);
            }
        },

        //分页 重新设定HTML内容(双行)
        initPageDouble: function () {

            var tmpRows = $("#" + AutoPage.content)[0].rows; //表格正文
            var height_tmp = 0; //一页总高度
            var html_tmp = "";  //临时存储正文
            var html_header = "<table>";
            var html_foot = "</table>";
            var page = 0; //页码

            var tr0Height = tmpRows[0].clientHeight + tmpRows[1].clientHeight; //table标题高度
            var tr0Html = "<tr>" + tmpRows[0].innerHTML + "</tr>" + "<tr>" + tmpRows[1].innerHTML + "</tr>";//table标题内容
            height_tmp = tr0Height;
            for (var i = 1; i < tmpRows.length; i++) {
                var trHtmp = tmpRows[(i - 1) * 2].clientHeight + tmpRows[(i - 1) * 2 + 1].clientHeight;//第i行高度
                var trMtmp = "<tr>" + tmpRows[(i - 1) * 2].innerHTML + "</tr>" + "<tr>" + tmpRows[(i - 1) * 2 + 1].innerHTML + "</tr>";//第i行内容

                height_tmp += trHtmp;
                if (height_tmp < AutoPage.totalHeight) {
                    if (height_tmp == tr0Height + trHtmp) {
                        html_tmp += AutoPage.header + html_header + tr0Html;
                        page++;//页码
                    }
                    html_tmp += trMtmp;
                    if (i == tmpRows.length - 1) {
                        html_tmp += html_foot + AutoPage.footer;
                    }
                } else {
                    html_tmp += html_foot + AutoPage.footer + AutoPage.addPageBreak();
                    i--;
                    height_tmp = tr0Height;
                }
            }


            $("#" + AutoPage.divID).html(html_tmp);

            var tdpagecount = $(".pagination");//document.getElementsByName("tdPageCount");

            for (var i = 0; i < tdpagecount.length; i++) {
                $(tdpagecount[i]).text((i + 1) + "/" + page);
            }

        },

        //隐藏原来的数据
        hidenContent: function () {
            $('#printcontent').hide()
        },

        ////添加分页符
        addPageBreak: function () {
            return "<div class='page-break' style='page-break-after:always;'>";
        },

    };

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
        var repeatTitle = Number('${printSettings.repeatTitle}' || 1),
            repeatFooter = Number('${printSettings.repeatFooter}' || 1);

        //adjustAggregate();
        <%--AutoPage.init(--%>
        <%--$('#header'),--%>
        <%--'content',--%>
        <%--$('#footer'),--%>
        <%--Number('${printSettings.pageHeight}' || 470),--%>
        <%--'preview',--%>
        <%--1,--%>
        <%--repeatTitle,--%>
        <%--repeatFooter--%>
        <%--)--%>


    })

    function toggleColumnDisplay(btn, expected) {
        uglcw.ui.get('.column-setting').k().dataItem($(btn).closest('tr')).set('fdStatus', expected);
    }

    function adjustAggregate() {
        var $stop = $('.aggregate-footer td.aggregate:visible:first');
        var $emptyCells = $stop.prevAll('td:not(.aggregate-txt,.aggregate-rownum)');
        $('.aggregate-footer .aggregate-txt').attr('colspan', $emptyCells.length + 1);
        $emptyCells.remove();
    }


    function doPrint() {
        window.print();
    }

    function printit() {
        if(!$("#showBill").is(":hidden")&&!$("#showGroupWare").is(":hidden")){
            $("#showBill").after(AutoPage.addPageBreak());
        }
        window.print();
        addPrintRecord(function () {
            uglcw.ui.closeCurrentTab();
        })
    }

    function addPrintRecord(callback) {
        $.ajax({
            url: "${base}manager/sysPrintRecord/addPrintRecordBatch",
            data: {fdSourceId: '${ids}', fdSourceNo: '${voucherNos}', fdModel: '${fdModel}'},
            type: "post",
            success: function (json) {
                if (callback && $.isFunction(callback)) {
                    callback()
                }
            }
        });
    }


    function changeTemplate(o) {
        var mergeId = $("#mergeId").val();
        window.location.href = '${base}manager/showstkoutbatchprint?dataTp=1&billIds=${billIds}&fromFlag=${param.fromFlag}&templateId=' + o.value + "&merge=" + mergeId;
    }

    function showWareStat(){
        document.location.href='${base}manager/showSaleOutWareStat?fromFlag=1&billIds=${billIds}';
    }

</script>
<script type="text/javascript">
    var LODOP;

    function createPage() {
        LODOP = getLodop();
        LODOP.PRINT_INIT("${billNo}");
        //top left width height
        //LODOP.SET_PRINT_PAGESIZE(1, 2300, 1400, "");
        //LODOP.SET_PRINT_STYLEA(0,"Horient",2);
        LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
        LODOP.ADD_PRINT_HTM(0, 0, '100%', '100%', document.getElementById("preview-wrapper").innerHTML);
    };

    $(function () {
        uglcw.ui.init();

        if('${showGroupWare}'=='1'){
            $("#showGroupWare").show();
            $("#showBill").hide();
            uglcw.ui.get('#ishowGroupWare').value(1);
            uglcw.ui.get('#ishowBill').value(0);
        }

        //显示商品
        uglcw.ui.get('#ishowGroupWare').on('change', function () {
            var checked = uglcw.ui.get('#ishowGroupWare').value();
            if (checked) {
               $("#showGroupWare").show();
            } else {
                $("#showGroupWare").hide();
            }
        });

        uglcw.ui.get('#ishowBill').on('change', function () {
            var checked = uglcw.ui.get('#ishowBill').value();
            if (checked) {
                $("#showBill").show();
            } else {
                $("#showBill").hide();
            }
        });

    });

    function lodopPrint() {
        createPage();
        LODOP.PREVIEW();
    };


</script>
</body>
</html>



