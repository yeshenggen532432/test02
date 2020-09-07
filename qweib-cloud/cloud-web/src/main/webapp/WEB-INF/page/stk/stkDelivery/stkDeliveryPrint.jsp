<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <link href="https://cdn.bootcss.com/quill/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.bootcss.com/quill/1.3.6/quill.min.js"></script>

    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>

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
    <input id="btnBillMes" value="配送信息" class="easyui-linkbutton" style=" width:70px; height:22px; "
           type="button" onclick="showBill()">
    <input id="btnPrintSet" value="设置" class="easyui-linkbutton" style=" width:50px; height:22px; "
           type="button" onclick="toPrintSet()">
    <input id="btnPrintColumn" class="easyui-linkbutton" value="设置打印列" style=" width:80px; height:22px; "
           type="button" onclick="printDlgConfig()">
    <input id="btnPrint" value="打印" class="easyui-linkbutton" style=" width:50px; height:22px; "
           type="button" onclick="printit()">
    <input id="btnPrintTemplate" class="easyui-linkbutton" value="设置模版"
           style=" width:80px; height:22px; " type="button" onclick="addTemplate()">
    <input id="btnWareGroup" class="easyui-linkbutton" value="设置分组" style=" width:80px; height:22px; "
           type="button" onclick="addWareGroup()">
    <tag:select name="templateId" id="templateId" value="${templateId}"
                onchange="changeTemplate(this)" tableName="stk_print_template"
                displayKey="id" displayValue="fd_name" whereBlock="fd_type='4'">
    </tag:select>
    合并商品
    <select style="width: 40px;" id="mergeId" onchange="changeMerge(this)">
        <option value="">否</option>
        <option value="1">是</option>
    </select>
</div>
<div style=" text-align: center; margin:10px auto;width:794px;height:540px;" id="printcontent">
    <div id="header">
        <table style="border-color: #000000;width:794px;">
            <tr>
                <td colspan="6" style="">
                    <table>
                        <td style="width: 180px;">
                        <span style="font-size: 10px"><c:if
                                test="${not empty printSettings.other2}">工商号:${printSettings.other2 }</c:if></span>
                        </td>
                        <td align="center" rowspan="2">
    				 <span style="font-size:22px;color:#000000;font-weight:bold;">
    				 	<c:choose>
                            <c:when test="${outType eq '销售出库' }">${printSettings.title}</c:when>
                            <c:when test="${outType eq '报损出库' }">报损配送单</c:when>
                            <c:when test="${outType eq '领用出库' }">领用配送单</c:when>
                            <c:otherwise>其它配送单</c:otherwise>
                        </c:choose>
	   		 		  </span>
                        </td>
                        <td rowspan="2" width="250px">
                            <div style="display: inline;">
                                <c:if test="${printSettings.displayWxpay > 0 and not empty printSettings.wxpayQrcode}">
                                    <div class="qrcode-wrapper">
                                        <span class="qrcode-text"><p>微</p><p>信</p><p>收</p><p>款</p></span>
                                        <img
                                                style='
                                                <c:if test="${printSettings.qrcodeWidth>0}">width:${printSettings.qrcodeWidth}px;</c:if>
                                                <c:if test="${printSettings.qrcodeHeight>0}">height:${printSettings.qrcodeHeight}px;</c:if>'
                                                src="${printSettings.wxpayQrcode}" class="qrcode">
                                    </div>
                                </c:if>
                                <c:if test="${printSettings.displayAlipay > 0 and not empty printSettings.alipayQrcode}">
                                    <div class="qrcode-wrapper">
                                        <span class="qrcode-text"><p>支</p><p>付</p><p>宝</p><p>收</p><p>款</p></span>
                                        <img
                                                style='
                                                <c:if test="${printSettings.qrcodeWidth>0}">width:${printSettings.qrcodeWidth}px;</c:if>
                                                <c:if test="${printSettings.qrcodeHeight>0}">height:${printSettings.qrcodeHeight}px;</c:if>'
                                                src="${printSettings.alipayQrcode}" class="qrcode last">
                                    </div>
                                </c:if>
                            </div>
                        </td>
                        <tr>
                            <td style="font-size: 10px">
                                <div>
                                页码：<span class="pagination">1/1</span>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table class="tbody" border="${printSettings.displayBorder}" cellpadding="0" cellspacing="1" style="
        <c:if test="${printSettings.masterFontsize>0}">font-size:${printSettings.masterFontsize}px;</c:if> border-color: #000000;width:794px;">
            <tr
                    <c:if test="${printSettings.masterHeight > 0}">style="height: ${printSettings.masterHeight}px;"</c:if> >
                <td style="text-align: right;padding-right: 1px">
                    客户名称:
                </td>
                <td style="<c:if
                        test="${printSettings.masterFontsize>0}">font-size:${printSettings.masterFontsize}px;</c:if>font-weight: bold;text-align: left;padding-left: 1px">${khNm}</td>
                <td style="text-align: right;padding-right: 1px">电&nbsp;&nbsp;话:</td>
                <td style="text-align: left;padding-left: 1px">${tel}</td>
                <td style="text-align: right;padding-right: 1px">地&nbsp;&nbsp;址:</td>
                <td style="text-align: left;padding-left: 1px">${address }</td>
            </tr>
            <tr
                    <c:if test="${printSettings.masterHeight > 0}">style="height: ${printSettings.masterHeight}px;"</c:if> >
                <td style="text-align: right;padding-right: 1px;width: 65px">配送指定:</td>
                <td style="text-align: left;padding-left: 1px;width: 180px">${pszd}</td>
                <td style="text-align: right;padding-right: 1px;width: 65px">日&nbsp;&nbsp;期:
                </td>
                <td style="text-align: left;padding-left: 1px;width: 110px">
                    ${fn:substring(outTime, 0 , 10)}
                </td>
                <td style="text-align: right;padding-right: 1px;width: 65px">单&nbsp;&nbsp;号:
                </td>
                <td style="text-align: left;padding-left: 1px">${billNo}</td>
                <%--
                <td style="text-align: right;padding-right: 1px;width: 65px">发票日期：</td>
                <td style="text-align: left;padding-left: 1px">${outTime}</td>
                --%>
            </tr>
            <c:if test="${pszd eq '直供转单二批' }">
                <tr
                        <c:if test="${printSettings.masterHeight > 0}">style="height: ${printSettings.masterHeight}px;"</c:if> >
                    <td style="text-align: right;padding-right: 1px;">所属二批:</td>
                    <td style="text-align: left;padding-left: 1px;">${epCustomerName}</td>
                    <td style="text-align: right;padding-right: 1px;"></td>
                    <td style="text-align: left;padding-left: 1px;"></td>
                    <td style="text-align: right;padding-right: 1px;"></td>
                    <td style="text-align: left;padding-left: 1px"></td>
                </tr>
            </c:if>
            <tr
                    <c:if test="${printSettings.masterHeight > 0}">style="height: ${printSettings.masterHeight}px;"</c:if> >
                <td style="text-align: right;padding-right: 1px">备&nbsp;&nbsp;注:</td>
                <td style="text-align: left;" colspan="3">${remarks}</td>
                <c:if test="${printSettings.displayCustomerDept>0}">
                <td  style="text-align: right;width:70px;">累计应收:</td>
                <td style="text-align: left">${customerDept.sumamt}</td>
                </c:if>
            </tr>
        </table>
    </div>
    <table id="content" style="border-collapse: collapse;">
        <thead>
        <tr>
            <td style="font-weight:bold;border:1px solid #000000;width:6px">
                no.
            </td>
            <c:forEach items="${datas }" var="data">
                <td style="font-weight:bold;border:1px solid #000000;width:${data.fdWidth}%;">${data.fdFieldName }</td>
            </c:forEach>
            <td style="border-bottom:1px solid #000000;">
                &nbsp;
            </td>
        </tr>
        </thead>
        <tbody id="chooselist">
        <c:forEach items="${mapList}" var="item" varStatus="s">
            <tr
                    <c:if test="${printSettings.slaveHeight>0}">style="height: ${printSettings.slaveHeight}px;"</c:if>>
                <td style="border:1px solid #000000;">
                        ${s.index +1}
                </td>
                <c:forEach items="${datas }" var="data">
                <td style="border:1px solid #000000;padding-left: 3px; padding-right: 3px;<c:if
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
                    <c:when test="${data.fdFieldKey eq 'qty'}">
                        ${fns:shapeField(item[data.fdFieldKey], data.fdDecimals)}
                    </c:when>
                    <c:when test="${data.fdFieldKey eq 'price'}">
                        ${fns:shapeField(item[data.fdFieldKey], data.fdDecimals)}
                    </c:when>
                    <c:when test="${data.fdFieldKey eq 'outQty'}">
                        ${fns:shapeField(item[data.fdFieldKey], data.fdDecimals)}
                    </c:when>
                    <c:otherwise>

                            ${item[data.fdFieldKey] }
                    </c:otherwise>
                    </c:choose>
                    </c:forEach>
                <td style="border-bottom:1px solid #000000;">
                    &nbsp;
                </td>
            </tr>
        </c:forEach>
        </tbody>

        <%--
        <tr>
                <td style="border:1px solid #999999;" colspan="2">合计：</td>
                <td style="border:1px solid #999999;" colspan="2">整单折扣:${discount}</td>
                <td style="border:1px solid #999999;" colspan="2">发票数量:${sumQty}</td>
                <td style="border:1px solid #999999;"colspan="2">发票金额:${disamt}</td>
                <td style="border:1px solid #999999;"colspan="2"></td>
        </tr>
         --%>
        <tr style="border: 1px solid #000000">
            <td>
                <c:set var="coLen" value="0"/>
            </td>
            <c:forEach items="${datas }" var="data" varStatus="loop">
                <c:choose>
                    <c:when test="${data.fdFieldKey eq 'outAmt'}">
                        <td style="border-left:1px solid #ffffff;border-right:1px solid #ffffff;">
                                ${disamt}
                        </td>
                    </c:when>
                    <c:when test="${data.fdFieldKey eq 'outQty'}">
                        <td style="border-left:1px solid #ffffff;border-right:1px solid #ffffff;">
                            <script>
                                var sumQty = ${sumQty };
                                sumQty = parseFloat(sumQty);
                                document.write(sumQty)
                            </script>
                        </td>
                    </c:when>
                    <c:when test="${data.fdFieldKey eq 'price'}">
                        <td style="border-left:1px solid #ffffff;border-right:1px solid #ffffff;">

                        </td>
                    </c:when>
                    <c:otherwise>

                        <td style="border:1px solid #ffffff;" >
                            <c:if test="${loop.index == 0}">合计：</c:if>
                        </td>
                    </c:otherwise>
                </c:choose>
                </td>
            </c:forEach>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
    <div id="footer">
        <table style="width:794px;">
            <tr>
                <td colspan="6" style="text-align: left;padding-left: 10px">
                    <c:if test="${printSettings.displayUnitCount>0}">大单位合计:${bigUnitCount}&nbsp;&nbsp;小单位合计:${smallUnitCount}&nbsp;&nbsp;</c:if>
                   &nbsp;&nbsp;配送金额:${disamt1}&nbsp;&nbsp;<c:if
                        test="${printSettings.displaySalesman > 0}">业务员:${staff }&nbsp;&nbsp;${staffTel}</c:if>&nbsp;&nbsp;制单人:${operator}&nbsp;&nbsp;电话:${printSettings.tel}&nbsp;&nbsp;
                </td>
            </tr>
            <c:if test="${not empty printSettings.printMemo or not empty printSettings.other1 }">
                <tr>
                    <td style="text-align: left;" colspan="6"><div style="white-space: pre-wrap;">${printSettings.printMemo}</div></td>
                </tr>
                <tr>
                    <td style="text-align: left;" colspan="6"><div style="white-space: pre-wrap;">${printSettings.other1}</div></td>
                </tr>
            </c:if>
        </table>
    </div>
</div>
<div style="width: 794px; text-align: center; margin: 10px auto;">
    <div id="preview" style="width: 100%"></div>
</div>
<div id="printDlg" closed="true" class="easyui-dialog" style="width:540px; height:200px;" title="设置打印列"
     iconCls="icon-edit">

</div>


<div id="dlg" closed="true" class="easyui-dialog" title="设置" style="width:520px;height:480px;padding:10px"
     data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						submitSet();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
    <form:form commandName="printSettings" class="form">
        <div class="form-item">
            <label class="form-label required">
                工商号：
            </label>
            <div class="form-content">
                <form:input path="other2" id="other2" style="width:240px;height: 20px;"/>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                单据标题：
            </label>
            <div class="form-content">
                <form:input path="title" id="printTitle" style="width:240px;height: 20px;"/>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label">
                咨询电话：
            </label>
            <div class="form-content">
                <form:input path="tel" id="comTel" style="width:120px;height: 20px;"/><br/>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label">
                备注1：
            </label>
            <div class="form-content">
                <div style="width: 250px">
                    <div id="printMemo" style="height: 100px; max-height: 150px;">${printSettings.printMemo}</div>
                </div>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label ">
                备注2：
            </label>
            <div class="form-content">
                <div style="width: 250px;">
                    <div id="other1" style="height: 100px; max-height: 150px;">${printSettings.other1}</div>
                </div>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                表头行高：
            </label>
            <div class="form-content">
                <form:input path="masterHeight" id="masterHeight" style="width:240px;height: 20px;"/>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                表身行高：
            </label>
            <div class="form-content">
                <form:input path="slaveHeight" id="slaveHeight" style="width:240px;height: 20px;"/>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                表头字体：
            </label>
            <div class="form-content">
                <div style="height: 20px;">
                    <select id="masterFontsize">
                        <c:forEach begin="10" end="32" var="i">
                            <option
                                    <c:if test="${i == printSettings.masterFontsize}">selected</c:if> >${i}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                显示边框：
            </label>
            <div class="form-content">
                <div style="height: 20px;">
                    <input type="checkbox" id="displayBorder"
                           <c:if test="${printSettings.displayBorder>0}">checked</c:if> />
                </div>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                显示业务员：
            </label>
            <div class="form-content">
                <div style="height: 20px;">
                    <input type="checkbox" id="displaySalesman"
                           <c:if test="${printSettings.displaySalesman>0}">checked</c:if> />
                </div>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                显示客户欠款：
            </label>
            <div class="form-content">
                <div style="height: 20px;">
                    <input type="checkbox" id="displayCustomerDept"
                           <c:if test="${printSettings.displayCustomerDept>0}">checked</c:if> />
                </div>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                显示大/小单位统计：
            </label>
            <div class="form-content">
                <div style="height: 20px;">
                    <input type="checkbox" id="displayUnitCount"
                           <c:if test="${printSettings.displayUnitCount>0}">checked</c:if> />
                </div>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                页眉页脚：
            </label>
            <div class="form-content">
                <div style="height: 20px;">
                    重复页眉：<input id="repeatTitle" type="checkbox"
                                <c:if test="${printSettings.repeatTitle > 0}">checked</c:if> style="width: 40px;">
                    重复页脚：<input id="repeatFooter" type="checkbox"
                                <c:if test="${printSettings.repeatFooter > 0}">checked</c:if> style="width: 40px;">
                </div>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                纸张高度：
            </label>
            <div class="form-content">
                <div style="height: 20px;">
                    <input style="width: 100px;" id="pageHeight" type="number" placehoder="纸张高度如470" value="${printSettings.pageHeight}">
                    <span style="color:darkgray">请根据纸张高度酌情调整数值</span>
                </div>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label required">
                收款码大小：
            </label>
            <div class="form-content">
                <div style="height: 20px;">
                    <input id="qrcodeWidth" style="width: 40px;" type="number" value="${printSettings.qrcodeWidth}"
                           placehoder="宽度"> x
                    <input id="qrcodeHeight" style="width: 40px;" type="number" value="${printSettings.qrcodeHeight}"
                           placehoder="高度"> px
                    <span style="color:darkgray">建议70*70</span>
                </div>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label ">
                微信收款码：
            </label>
            <div class="form-content">
                <form:input type="hidden" path="wxpayQrcode"/>
                <img style="width: 40px;height: 40px" src="${printSettings.wxpayQrcode}">
                <input type="checkbox" id="displayWxpay"
                       <c:if test="${printSettings.displayWxpay>0}">checked</c:if>></input>
                <input type="file" accept="image/*" name="newWxpayQrcode" onchange="showPictrue(this)"/>
                <input type="button" onclick="uploadImg($('input[name=newWxpayQrcode]'),'#wxpayQrcode')" value="上传"/>
            </div>
        </div>
        <div class="form-item">
            <label class="form-label">
                支付宝收款码：
            </label>
            <div class="form-content">
                <form:input type="hidden" path="alipayQrcode"/>
                <img style="width: 40px;height: 40px" src="${printSettings.alipayQrcode}">
                <input type="checkbox" id="displayAlipay"
                       <c:if test="${printSettings.displayAlipay>0}">checked</c:if>></input>
                <input type="file" accept="image/*" name="newAlipayQrcode" onchange="showPictrue(this)"/>
                <input type="button" onclick="uploadImg($('input[name=newAlipayQrcode]'), '#alipayQrcode')" value="上传"/>
            </div>
        </div>
    </form:form>
</div>
<scirpt type="text/javascript" src="<%=basePath %>/resource/printadapter.js?v=1"></scirpt>
<script type="text/javascript">
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
            var html_header = "<table style='border-collapse: collapse;'>";
            var html_foot = "</table>";
            var page = 0; //页码

            var tr0Height = tmpRows[0].clientHeight; //table标题高度
            var tr0Html = "<tr>" + tmpRows[0].innerHTML + "</tr>";//table标题内容
            height_tmp = tr0Height;
            if(AutoPage.totalHeight==0){
                AutoPage.totalHeight = 470;
            }

            for (var i = 1; i < tmpRows.length; i++) {
                AutoPage.removeScript(tmpRows[i]);
                var tableHeight = AutoPage.totalHeight - (page <= 1 || AutoPage.repeatTitle ? AutoPage.header.height() : 0)
                    - (AutoPage.repeatFooter ? AutoPage.footer.height() : 0);
                var trHtmp = tmpRows[i].clientHeight;//第i行高度
                var trMtmp = "<tr>" + tmpRows[i].innerHTML + "</tr>";//第i行内容
                height_tmp += trHtmp;
                if (height_tmp < tableHeight) {
                    if (height_tmp == tr0Height + trHtmp) {
                        html_tmp += (page <= 0 || AutoPage.repeatTitle ? AutoPage.header.html() : '') + html_header + tr0Html;
                        page++;//页码
                    }
                    html_tmp += trMtmp;
                    if (i == tmpRows.length - 1) {
                        html_tmp += html_foot + AutoPage.footer.html();
                    }
                } else {
                    html_tmp += html_foot + (AutoPage.repeatFooter ? AutoPage.footer.html() : '') + AutoPage.addPageBreak();
                    i--;
                    height_tmp = tr0Height;
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
            return "<p class='page-break' style='page-break-before:always;'></p>";
        },

    };

    var memoEditor, otherEditor;
    $(function () {
        memoEditor = new Quill('#printMemo', {
            modules: {
                toolbar: [
                    [{'header': [1, 2, 3, 4, 5, 6, false]}],
                    [{'list': 'ordered'}, {'list': 'bullet'}],
                    ['bold', 'italic', 'underline', 'strike'],
                ]
            },
            theme: 'snow'
        })
        otherEditor = new Quill('#other1', {
            modules: {
                toolbar: [
                    [{'header': [1, 2, 3, 4, 5, 6, false]}],
                    [{'list': 'ordered'}, {'list': 'bullet'}],
                    ['bold', 'italic', 'underline', 'strike'],
                ]
            },
            theme: 'snow'
        })
        var repeatTitle = Number('${printSettings.repeatTitle}' || 1),
            repeatFooter = Number('${printSettings.repeatFooter}' || 1);

        AutoPage.init(
            $('#header'),
            'content',
            $('#footer'),
            Number('${printSettings.pageHeight}' || 470),
            'preview',
            1,
            repeatTitle,
            repeatFooter
        )
    })

    function doPrint() {
        window.print();
    }

    function printit() {
        //if (confirm('确定打印吗？')){

        $.ajax({
            url: "manager/sysPrintRecord/addPrintRecord",
            data: {fdSourceId: '${billId}', fdSourceNo: '${billNo}', fdModel: '${fdModel}'},
            type: "post",
            success: function (json) {
                if ('${param.fromFlag}' == 0) {
                    parent.closeWin('销售开单');
                } else {
                    parent.closeWin('发票信息${billId}');
                }
            }
        });
        var newstr = document.getElementById('preview').innerHTML;
        var oldstr = document.body.innerHTML;//
        document.body.innerHTML = newstr;
        window.print();
        document.body.innerHTML = oldstr;
        //	}
    }

    function showPictrue(input) {
        var r = new FileReader();
        f = input.files[0];
        r.readAsDataURL(f);
        r.onload = function (e) {
            //$(input).closest('.form-item').find('img').attr('src', this.result);
        }
    }

    function submitSet() {

        var title1 = $("#printTitle").val();
        var tel = $("#comTel").val();
        var printMemo = $("#printMemo").val();
        var other1 = $("#other1").val();
        var other2 = $("#other2").val();
        if (title1 == "") {
            alert("请输入标题");
            return;
        }
        var billId = $("#billId").val();
        $.messager.confirm('确认', "是否确认保存", function (r) {
            if (r) {
                $.ajax({
                    url: "manager/savePrintSet",
                    data: {
                        "billName": "${billName}",
                        "printTitle": title1,
                        "tel": tel,
                        "printMemo": memoEditor.container.firstChild.innerHTML,
                        "other1": otherEditor.container.firstChild.innerHTML,
                        "other2": other2,
                        'masterHeight': $('#masterHeight').val() || 0,
                        'slaveHeight': $('#slaveHeight').val() || 0,
                        'displayWxpay': $('#displayWxpay').is(":checked") ? 1 : 0,
                        'displayAlipay': $('#displayAlipay').is(":checked") ? 1 : 0,
                        'displaySalesman': $('#displaySalesman').is(":checked") ? 1 : 0,
                        'displayUnitCount': $('#displayUnitCount').is(":checked") ? 1 : 0,
                         displayCustomerDept: $('#displayCustomerDept').is(":checked") ? 1 : 0,
                        'wxpayQrcode': $('#wxpayQrcode').val(),
                        'alipayQrcode': $('#alipayQrcode').val(),
                        qrcodeWidth: $('#qrcodeWidth').val() || 0,
                        qrcodeHeight: $('#qrcodeHeight').val() || 0,
                        'displayBorder': $('#displayBorder').is(":checked") ? 1 : 0,
                        'masterFontsize': $('#masterFontsize').val() || 0,
                        repeatTitle: $('#repeatTitle').is(":checked") ? 1 : 0,
                        repeatFooter: $('#repeatFooter').is(":checked") ? 1 : 0,
                        pageHeight: $('#pageHeight').val() || 0
                    },
                    type: "post",
                    success: function (json) {
                        if (json.state) {
                            //showMsg("保存成功");
                            $('#dlg').dialog('close');
                            var templateId = $("#templateId").val();
                            window.location.href = 'manager/stkDelivery/print?billId=' + billId + '&templateId=' + templateId;

                        } else {
                            showMsg("保存失败" + json.msg);
                        }
                    }
                });
            }
        });
    }

    function uploadImg(input, target) {
        var formData = new FormData();
        var files = $(input)[0].files;
        if (files.length < 1) {
            alert('请选择文件')
            return;
        }

        formData.append("file", files[0]);
        $.ajax({
            url: '${base}manager/uploadQrcode',
            type: 'post',
            dataType: 'json',
            data: formData,
            cache: false,
            processData: false,
            contentType: false,
            success: function (response) {
                if (response.code == 200) {
                    var url = '/upload/' + response.data.fileNames[0];
                    $(target).val(url)
                    $(input).closest('.form-item').find('img').attr('src', url);
                }
            }
        })
    }

    function toPrintSet() {
        $('#dlg').dialog('open');
    }

    function printDlgConfig() {
        //$('#printDlg').dialog('open');
        /**/
        $('#printDlg').dialog({
            title: '设置打印列',
            iconCls: "icon-edit",
            width: 610,
            height: 400,
            modal: true,
            href: "manager/queryPrintConfigList?fdModel=${fdModel}",
            onClose: function () {
                var templateId = $("#templateId").val();
                window.location.href = 'manager/stkDelivery/print?billId=' + '${billId}' + '&templateId=' + templateId;
            }
        });
        $('#printDlg').dialog('open');
    }

    function updateFdStatus(index, id) {
        var fdStatus = 0;
        var txtStatus = document.getElementById("fdStatus" + index).value;
        if (txtStatus == 0) {
            fdStatus = 1;
        }
        $.ajax({
            url: "manager/updatePrintConfig",
            data: {id: id, fdStatus: fdStatus, fdModel: '${fdModel}'},
            type: "post",
            success: function (json) {
                if (json.state) {

                    if (fdStatus == 0) {
                        document.getElementById("fdStatus" + index).value = 0;
                        document.getElementById("fdStatusTxt" + index).innerHTML = "否";
                        document.getElementById("btnfield" + index).value = "显示";
                    } else {
                        document.getElementById("fdStatus" + index).value = 1;
                        document.getElementById("fdStatusTxt" + index).innerHTML = "是";
                        document.getElementById("btnfield" + index).value = "不显示";
                    }

                } else {
                    showMsg("保存失败" + json.msg);
                }
            }
        });
    }

    function changeFieldName(obj, id) {
        if (obj.value == "") {
            alert("列名不能为空！");
            return;
        }
        $.ajax({
            url: "manager/updatePrintConfig",
            data: {id: id, fdFieldName: obj.value, fdModel: '${fdModel}'},
            type: "post",
            success: function (json) {
                if (json.state) {
                } else {
                    showMsg("保存失败" + json.msg);
                }
            }
        });
    }

    function changeFdWidth(obj, id) {
        if (obj.value == "") {
            alert("宽度不能为空！");
            return;
        }
        $.ajax({
            url: "manager/updatePrintConfig",
            data: {id: id, fdWidth: obj.value, fdModel: '${fdModel}'},
            type: "post",
            success: function (json) {
                if (json.state) {
                } else {
                    showMsg("保存失败" + json.msg);
                }
            }
        });
    }

    function changeFdHeight(obj, id) {
        $.ajax({
            url: "manager/updatePrintConfig",
            data: {id: id, fdHeight: obj.value, fdModel: '${fdModel}'},
            type: "post",
            success: function (json) {
                if (json.state) {
                } else {
                    showMsg("保存失败" + json.msg);
                }
            }
        });
    }

    var timer;

    function onFieldChange(obj, id, name) {
        if (timer) {
            clearTimeout(timer)
        }
        var data = {
            id: id,
            fdModel: '${fdModel}',
        }
        data[name] = obj.value
        timer = setTimeout(function () {
            $.ajax({
                url: "manager/updatePrintConfig",
                data: data,
                type: "post",
                success: function (json) {
                    if (json.state) {
                    } else {
                        showMsg("保存失败" + json.msg);
                    }
                }
            });
        }, 100)
    }

    function changeFdFontsize(obj, id) {
        $.ajax({
            url: "manager/updatePrintConfig",
            data: {id: id, fdFontsize: obj.value, fdModel: '${fdModel}'},
            type: "post",
            success: function (json) {
                if (json.state) {
                } else {
                    showMsg("保存失败" + json.msg);
                }
            }
        });
    }


    function changeOrderCd(obj, id) {
        if (obj.value == "") {
            alert("排序不能为空！");
            return;
        }
        $.ajax({
            url: "manager/updatePrintConfig",
            data: {id: id, orderCd: obj.value, fdModel: '${fdModel}'},
            type: "post",
            success: function (json) {
                if (json.state) {
                } else {
                    showMsg("保存失败" + json.msg);
                }
            }
        });
    }

    function showBill() {
        location = 'manager/stkDelivery/show?billId=${billId}';
    }

    function addTemplate() {
        parent.closeWin('设置模版');
        parent.add('设置模版', 'manager/stkPrintTemplate/page?fdType=4');
    }

    function addWareGroup() {

        var cstId = '${cstId}';
        parent.closeWin(cstId + '_设置客户商品分组');
        parent.add(cstId + '_设置客户商品分组', 'manager/stkCustomerWareGroup/queryStkWareGroup?cstId=' + cstId);
    }

    function changeTemplate(o) {
        var mergeId = $("#mergeId").val();
        location = 'manager/stkDelivery/print?dataTp=1&billId=${billId}&fromFlag=${param.fromFlag}&templateId=' + o.value + "&merge=" + mergeId;
    }

    $.ajax({
        url: "manager/sysPrintRecord/queryPrintCount",
        data: {fdSourceId: '${billId}', fdModel: '${fdModel}'},
        type: "post",
        async: true,
        success: function (json) {
            document.getElementById("btnPrint").value = "打印(" + json.count + ")";
        }
    });

    function changeMerge(o) {
        var templateId = $("#templateId").val();
        location = 'manager/stkDelivery/print?dataTp=1&billId=${billId}&fromFlag=${param.fromFlag}&templateId=' + templateId + "&merge=" + o.value;
    }

    $("#mergeId").val('${merge}');
</script>
</body>
</html>  



