<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
    <style>
        table {
            width: 100%;
        }

        .preview td {
            height: 16px;
            text-align: center;
            font-family: '微软雅黑';
            font-size: 14px;
            color: #000000;
        }

        .preview td.waretd {
            border: 1px solid #000000;
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

        .preview  td:last-child {
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
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-header" style="font-size: 12px;text-align: center">
            <button uglcw-role="button" onclick="showBill()" uglcw-options="icon:'txt'">单据信息</button>
            <button uglcw-role="button" onclick="toPrintSet()" uglcw-options="icon:'gear'">设置</button>
            <button uglcw-role="button" onclick="printDlgConfig()" uglcw-options="icon:'table'">设置打印列
            </button>
            <button uglcw-role="button" onclick="printit()" uglcw-options="icon:'print'">打印(<span
                    id="print-count">0</span>)</button>
            <button uglcw-role="button" onclick="addTemplate()" uglcw-options="icon:'border-no'">设置模板
            </button>
            <label>模板名称：</label>
            <tag:select2 width="150px" name="templateId" id="templateId" value="${templateId}"
                         onchange="changeTemplate(this)" tableName="stk_print_template"
                         displayKey="id" displayValue="fd_name" whereBlock="fd_type='${fdType}'">
            </tag:select2>
        </div>
        <div class="layui-card-body preview">
            <input uglcw-role="textbox" type="hidden" id="billId" value="${billId}"/>
            <div style=" text-align: center; margin:10px auto;width:794px;height:540px;" id="printcontent">
                <div id="header">
                    <table style="border-color: #000000;width:794px;">
                        <tr>
                            <td colspan="6" style="">
                                <table>
                                    <td style="width: 180px;">
                                        <%--<span style="font-size: 10px">
                                        <c:if test="${not empty printSettings.other2}">工商号:${printSettings.other2 }</c:if>
                                        </span>--%>
                                    </td>
                                    <td align="center" rowspan="2">
    				 <span style="font-size:22px;color:#000000;font-weight:bold;">
    				 		${printSettings.title}
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
                                                            src="${base}${printSettings.wxpayQrcode}" class="qrcode">
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
                            <td style="text-align: right;padding-right: 1px">供应商:</td>
                            <td style="text-align: left;padding-left: 1px;">${proName}</td>
                            <td style="text-align: right;padding-right: 1px">入库日期:
                            </td>
                            <td style="text-align: left;padding-left: 1px;">
                               ${inTime}
                            </td>
                            <td style="text-align: right;padding-right: 1px;">单&nbsp;&nbsp;号:
                            </td>
                            <td style="text-align: left;padding-left: 1px">${billNo}</td>
                            <%--
                            <td style="text-align: right;padding-right: 1px;width: 65px">日期：</td>
                            <td style="text-align: left;padding-left: 1px">${outTime}</td>
                            --%>
                        </tr>
                        <tr>
                            <td style="text-align: right;padding-right: 1px">备注:</td>
                            <td colspan="5" style="text-align: left;padding-left: 1px;">${remarks}</td>
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
                                <c:when test="${data.fdFieldKey eq 'qty'}">
                                    ${fns:shapeField(item[data.fdFieldKey], data.fdDecimals)}
                                </c:when>
                                <c:when test="${data.fdFieldKey eq 'price'}">
                                    ${fns:shapeField(item[data.fdFieldKey], data.fdDecimals)}
                                </c:when>
                                <c:when test="${data.fdFieldKey eq 'amt'}">
                                    ${fns:shapeField(item[data.fdFieldKey], data.fdDecimals)}
                                </c:when>
                                <%--<c:when test="${data.fdFieldKey eq 'productDate'}">--%>
                                        <%--${item[data.fdFieldKey]}--%>
                                <%--</c:when>--%>
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
                    <tr class="aggregate-footer">
                        <td class="aggregate-rownum">
                            <c:set var="coLen" value="0"/>
                        </td>
                        <c:forEach items="${datas }" var="data" varStatus="loop">
                            <c:choose>
                                <c:when test="${data.fdFieldKey eq 'amt'}">
                                    <td class="aggregate">
                                            ${disamt}
                                    </td>
                                </c:when>
                                <c:when test="${data.fdFieldKey eq 'qty'}">
                                    <td class="aggregate">
                                        <script>
                                            var sumQty = ${sumQty };
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
                                        <c:if test="${loop.index == 0}">class="aggregate-txt"</c:if>>
                                        <c:if test="${loop.index == 0 && totalamt >= 0}">合计：${fns:convertNumberToChinese(totalamt)}</c:if>
                                    </td>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </tr>
                </table>
                <div id="footer">
                    <table style="width:794px;">
                        <tr>
                            <td colspan="6" style="text-align: left;padding-left: 10px">
                                <c:if test="${printSettings.displayUnitCount>0}">大单位合计:${bigUnitCount}&nbsp;&nbsp;小单位合计:${smallUnitCount}&nbsp;&nbsp;</c:if>
                                整单折扣:${discount}&nbsp;&nbsp;&nbsp;&nbsp;制单人:${operator}&nbsp;&nbsp;咨询电话:${printSettings.tel}&nbsp;&nbsp;
                            </td>
                        </tr>
                        <c:if test="${not empty printSettings.printMemo or not empty printSettings.other1 }">
                            <tr>
                                <td style="text-align: left;" colspan="6">
                                    <div style="white-space: pre-wrap;">${printSettings.printMemo}</div>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;" colspan="6">
                                    <div style="white-space: pre-wrap;">${printSettings.other1}</div>
                                </td>
                            </tr>
                        </c:if>
                    </table>
                </div>
            </div>
            <div>
                <div class="preview" id="preview" style="width: 794px; text-align: center; margin: 10px auto;"></div>
            </div>
        </div>
    </div>

</div>
<script id="settings-tpl" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal print-settings" uglcw-role="validator">
                <%--<div class="form-group">
                    <label class="control-label col-xs-6">工商号</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" value="${printSettings.other2}" uglcw-model="other2"/>
                    </div>
                </div>--%>
                <div class="form-group">
                    <label class="control-label col-xs-6">单据标题</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" uglcw-validate="required" value="${printSettings.title}"
                               uglcw-model="printTitle"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">咨询电话</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" value="${printSettings.tel}" uglcw-model="tel"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注1</label>
                    <div class="col-xs-18">
                        <div uglcw-role="wangeditor"
                             uglcw-options="menus:editorMenus"
                             uglcw-model="printMemo">${printSettings.printMemo}</div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注2</label>
                    <div class="col-xs-18">
                        <div uglcw-role="wangeditor"
                             uglcw-options="menus:editorMenus"
                             uglcw-model="other1">${printSettings.other1}</div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">高度设置</label>
                    <div class="col-xs-18">
                        <label>表头高度</label>
                        <input style="width: 120px;" uglcw-options="spinners: false, format: 'n0'"
                               value="${printSettings.masterHeight}" uglcw-role="numeric"
                               uglcw-model="masterHeight"/>
                        <label>表身行高</label>
                        <input style="width: 120px;" uglcw-options="spinners: false, format: 'n0'"
                               value="${printSettings.slaveHeight}" uglcw-role="numeric"
                               uglcw-model="slaveHeight"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6" style="margin: 10px 0;">表头字体</label>
                    <div class="col-xs-18" style="margin: 10px 0;">
                        <input uglcw-role="slider" value="${printSettings.masterFontsize}" uglcw-options="min: 10, max:40, smallStep: 1, largeStep: 5,
                            change:function(){
                            uglcw.ui.get('#slider-input').value(this.value());
                            $('#fontsize-preview').css('font-size', this.value()+'px');
                        }
                        " uglcw-model="masterFontsize"/>
                        <input id="slider-input" uglcw-role="numeric" uglcw-options="spinners: false, format: 'n0'"
                               value="${printSettings.masterFontsize}"
                               uglcw-options="min: 10, max: 40,
                         change:function(){
                            uglcw.ui.get('[uglcw-role=slider]').value(this.value());
                            $('#fontsize-preview').css('font-size', this.value()+'px');
                        }" style="width: 100px;">
                        <span id="fontsize-preview"
                              style="color: #444;font-size: ${printSettings.masterFontsize}">字体大小</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">显示控制</label>
                    <div class="col-xs-18">
                        <input id="displayBorder" uglcw-value="${printSettings.displayBorder}" type="checkbox"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="displayBorder"/>
                        <label class="k-checkbox-label" for="displayBorder">显示边框</label>
                        <input id="displayUnitCount" type="checkbox" uglcw-value="${printSettings.displayUnitCount}"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="displayUnitCount"/>
                        <label class="k-checkbox-label" for="displayUnitCount"> 显示大/小单位统计</label>

                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">页眉页脚</label>
                    <div class="col-xs-18">
                        <input id="repeatTitle" uglcw-value="${printSettings.repeatTitle}" type="checkbox"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="repeatTitle"/>
                        <label class="k-checkbox-label" for="repeatTitle">重复页眉</label>
                        <input id="repeatFooter" uglcw-value="${printSettings.repeatFooter}" type="checkbox"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="repeatFooter"/>
                        <label class="k-checkbox-label" for="repeatFooter">重复页脚</label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">纸张高度</label>
                    <div class="col-xs-18">
                        <input style="width: 120px;" uglcw-role="numeric" uglcw-options="spinners: false, format: 'n0'"
                               value="${printSettings.pageHeight}"
                               uglcw-model="pageHeight"/>
                        <span style="color:#444">单页纸张高度，请根据纸张高度酌情调整数值</span>
                    </div>

                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">收款码大小</label>
                    <div class="col-xs-18">
                        <input style="width: 120px;" uglcw-options="spinners: false, format: 'n0'"
                               value="${printSettings.qrcodeWidth}" uglcw-role="numeric"
                               uglcw-model="qrcodeWidth"/>
                        <span>*</span>
                        <input style="width: 120px;" uglcw-options="spinners: false, format: 'n0'"
                               value="${printSettings.qrcodeHeight}" uglcw-role="numeric"
                               uglcw-model="qrcodeHeight"/>
                        px
                        <span style="color:darkgray">建议70*70</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">微信收款码</label>
                    <div class="col-xs-18">
                        <div uglcw-role="album" uglcw-model="wxpayQrcode"
                             uglcw-options="
                            cropper: 2,
                             limit: 1,
                             async:{
                                saveUrl: '${base}manager/uploadQrcode',
                                saveField: 'file'
                             },
                             <c:if test="${not empty printSettings.wxpayQrcode}">
                             dataSource:[
                               {
                                 fid: 1,
                                 url: '${printSettings.wxpayQrcode}',
                                 title: '微信收款码.png'
                               }
                             ],
                             </c:if>
                             success: function(response){
                                if(response.code == 200){
                                    var url = '/upload/' + response.data.fileNames[0];
                                    return {
                                        thumb: url,
                                        url: url
                                    }
                                }
                             }"
                        ></div>
                        <input id="displayWxpay" type="checkbox" uglcw-value="${printSettings.displayWxpay}"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="displayWxpay"/>
                        <label class="k-checkbox-label" for="displayWxpay">显示微信收款码</label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">支付宝收款码</label>
                    <div class="col-xs-18">
                        <div uglcw-role="album" uglcw-model="alipayQrcode"
                             uglcw-options="
                            cropper: 2,
                             limit: 1,
                             async:{
                                saveUrl: '${base}manager/uploadQrcode',
                                saveField: 'file'
                             },
                             <c:if test="${not empty printSettings.alipayQrcode}">
                             dataSource:[
                               {
                                 fid: 1,
                                 url: '${printSettings.alipayQrcode}',
                                 title: '支付宝收款码.png'
                               }
                             ],
                             </c:if>
                             success: function(response){
                                if(response.code == 200){
                                    var url = '/upload/' + response.data.fileNames[0];
                                    return {
                                        thumb: url,
                                        url: url
                                    }
                                }
                             }"
                        ></div>
                        <input id="displayAlipay" type="checkbox" uglcw-value="${printSettings.displayAlipay}"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="displayAlipay"/>
                        <label class="k-checkbox-label" for="displayAlipay">显示支付宝收款码</label>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script id="columns-settings-tpl" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body" style="padding: 0;">
            <div class="column-setting" uglcw-role="grid" uglcw-options="
                    url: '${base}manager/queryPrintConfigListDatas?fdModel=${fdModel}',
                    pageable: false,
                    rowNumber: true,
                    autoAppendRow:false,
                    editable: true,
                    height: 350,
                    loadFilter: {
                        data: function(response){
                            if(response && response.rows){
                                $(response.rows).each(function(i, row){
                                    row.fdAlign = row.fdAlign || 0;
                                })
                            }
                            return response.rows || [];
                        }
                    }
                ">
                <div data-field="fdFieldName" uglcw-options="width:140, tooltip: true, schema:{type:'string'}">列名</div>
                <div data-field="fdWidth" uglcw-options="width:120, schema:{type:'number'}">长度(总长度100)</div>
                <div data-field="fdAlign"
                     uglcw-options="width:100, editable: true, values:[{text:'居中', value: 0},{text:'左对齐', value: 1},{text:'右对齐', value: 2}]">
                    对齐方式
                </div>
                <div data-field="fdHeight" uglcw-options="width:70, schema:{type:'number'}">高度</div>
                <div data-field="fdDecimals" uglcw-options="width:70, schema:{type:'number'}">小数位</div>
                <div data-field="fdFontsize"
                     uglcw-options="width:80, schema:{type:'number', validation:{min: 10, max: 15}}">字体大小
                </div>
                <div data-field="orderCd" uglcw-options="width:70, schema:{type:'number'}">排序</div>
                <div data-field="fdStatus"
                     uglcw-options="width:'auto', template: uglcw.util.template($('#display-btn-tpl').html())">显示
                </div>
            </div>
        </div>
    </div>
</script>
<script id="display-btn-tpl" type="text/x-uglcw-template">
    #if(data.fdStatus){#
    <button class="k-button k-info" onclick="toggleColumnDisplay(this, 0)">显示</button>
    #} else {#
    <button class="k-button k-info" onclick="toggleColumnDisplay(this, 1)">隐藏</button>
    #}#
</script>
<scirpt type="text/javascript" src="<%=basePath %>/resource/printadapter.js?v=1"></scirpt>
<script type="text/javascript">
    var editorMenus = [
        'head', 'bold', 'fontSize', 'fontName', 'italic', 'underline', 'strikeThrough', 'foreColor', 'backColor',
        'image'
    ];

    function getScreenDPI() {
        var arrDPI = [];
        if (window.screen.deviceXDPI != undefined) {
            arrDPI[0] = window.screen.deviceXDPI;
            arrDPI[1] = window.screen.deviceYDPI;
        } else {
            var tmpNode = document.createElement("DIV");
            tmpNode.style.cssText = "width:1in;height:1in;position:absolute;left:0px;top:0px;z-index:99;visibility:hidden";
            document.body.appendChild(tmpNode);
            arrDPI[0] = parseInt(tmpNode.offsetWidth);
            arrDPI[1] = parseInt(tmpNode.offsetHeight);
            tmpNode.parentNode.removeChild(tmpNode);
        }
        return arrDPI;
    }

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
                var clazz = $(tmpRows[i]).attr('class');
                var trMtmp = '<tr style="height:' + trHtmp + 'px;" ' + (clazz ? 'class="' + clazz + '"' : '') + '>' + tmpRows[i].innerHTML + '</tr>';//第i行内容
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
                    console.log('------------------', height_tmp);
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

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();

        loadPrintCount();

        var repeatTitle = Number('${printSettings.repeatTitle}' || 1),
            repeatFooter = Number('${printSettings.repeatFooter}' || 1);

        adjustAggregate();
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

    function toggleColumnDisplay(btn, expected) {
        uglcw.ui.get('.column-setting').k().dataItem($(btn).closest('tr')).set('fdStatus', expected);
    }

    function adjustAggregate() {
        var $stop = $('.aggregate-footer td.aggregate:visible:first');
        var $emptyCells = $stop.prevAll('td:not(.aggregate-txt,.aggregate-rownum)');
        $('.aggregate-footer .aggregate-txt').attr('colspan', $emptyCells.length + 1);
        $emptyCells.remove();
    }

    function loadPrintCount() {
        $.ajax({
            url: "${base}manager/sysPrintRecord/queryPrintCount",
            data: {fdSourceId: '${billId}', fdModel: '${fdModel}'},
            type: "post",
            async: true,
            success: function (json) {
                $('#print-count').html(json.count);
            }
        });
    }

    function doPrint() {
        window.print();
    }

    function printit() {
        $.ajax({
            url: "manager/sysPrintRecord/addPrintRecord",
            data: {fdSourceId: '${billId}', fdSourceNo: '${billNo}', fdModel: '${fdModel}'},
            type: "post",
            success: function (json) {

            }
        });
        var newstr = document.getElementById('preview').innerHTML;
        var oldstr = document.body.innerHTML;//
        document.body.innerHTML = '<div class="preview">'+newstr + '</div>';
        window.print();
        document.body.innerHTML = oldstr;
    }

    function toPrintSet() {
        uglcw.ui.Modal.open({
            title: '打印设置',
            area: ['650px', '500px'],
            content: $('#settings-tpl').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var validator = uglcw.ui.get($(c).find('.print-settings'));
                if (validator.validate()) {
                    uglcw.ui.confirm('确定保存设置吗？', function () {
                        var data = uglcw.ui.bind(c);
                        data.billName = '${billName}';
                        if (data.alipayQrcode && data.alipayQrcode.length > 0) {
                            data.alipayQrcode = data.alipayQrcode[0].url
                        }
                        if (data.wxpayQrcode && data.wxpayQrcode.length > 0) {
                            data.wxpayQrcode = data.wxpayQrcode[0].url
                        }
                        $.ajax({
                            url: '${base}manager/savePrintSet',
                            type: 'post',
                            data: data,
                            success: function (response) {
                                if (response.state) {
                                    uglcw.ui.success('保存成功！');
                                    uglcw.ui.Modal.close();
                                    setTimeout(function () {
                                        uglcw.ui.reload();
                                    }, 1000)
                                } else {
                                    uglcw.ui.error(response.msg || '保存失败');
                                }
                            }
                        })
                    });
                }
                //不直接关闭弹框
                return false;
            }
        })
    }

    function printDlgConfig() {
        uglcw.ui.Modal.open({
            title: '设置打印列',
            area: ['800px', '450px'],
            maxmin: false,
            content: $('#columns-settings-tpl').html(),
            success: function (c) {
                uglcw.ui.init(c);
                var grid = uglcw.ui.get($(c).find('.uglcw-grid'));
                grid.k().dataSource.bind('change', function (e) {
                    if (e.action === 'itemchange') {
                        var fieldName = e.field;
                        var item = e.items[0];
                        var value = item[fieldName];
                        var data = {
                            id: item.id,
                            fdModel: '${fdModel}'
                        }
                        data[fieldName] = value;
                        $.ajax({
                            url: '${base}manager/updatePrintConfig',
                            data: data,
                            type: 'post',
                            success: function (response) {
                                if (response.state) {
                                    uglcw.ui.toast('保存成功');
                                } else {
                                    uglcw.ui.toast(response.msg || '保存失败');
                                }
                            }
                        })
                    }

                })
            },
            yes: function (c) {
                uglcw.ui.reload();
            }
        });
    }

    function showBill() {
        uglcw.ui.openTab('采购订单', '${base}manager/showstkin?dataTp=1&billId=${billId}');
    }

    function addTemplate() {
        uglcw.ui.openTab('设置模版', '${base}manager/stkPrintTemplate/page?fdType=201');
    }


    function changeTemplate(o) {
        var mergeId = $("#mergeId").val();
        window.location.href = '${base}manager/showstkinprint?dataTp=1&billId=${billId}&fromFlag=${param.fromFlag}&templateId=' + o.value
    }

</script>
</body>
</html>



