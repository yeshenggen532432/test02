<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
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
                    id="print-count">0</span>)
            </button>
            <button uglcw-role="button" onclick="addTemplate()" uglcw-options="icon:'border-no'">设置模板
            </button>
            <button uglcw-role="button" onclick="addWareGroup()" uglcw-options="icon:'list-bulleted'">设置分组
            </button>
            <label>模板名称：</label>
            <tag:select2 width="120px" name="templateId" id="templateId" value="${templateId}"
                         onchange="changeTemplate(this)" tableName="stk_print_template"
                         displayKey="id" displayValue="fd_name" whereBlock="fd_type='1'">
            </tag:select2>
            <label>
                合并商品:
            </label>
            <select style="width: 100px;" uglcw-role="combobox" id="mergeId" onchange="changeMerge(this)">
                <option value="">否</option>
                <option value="1">是</option>
            </select>
        </div>
        <c:if test="${not empty printSettings.printType and printSettings.printType == 1}">
            <div class="layui-card-body" style="height: 100%;" uglcw-role="resizable" uglcw-options="responsive:[55]">
                <iframe id="previewWindow"
                        src="${base}manager/stk/out/print/${billNo}.pdf?billId=${billId}&templateId=${templateId}&merge=${merge}"
                        style="height: 100%;width: 100%; overflow: hidden; position: absolute;"
                        frameborder="0"></iframe>
            </div>
        </c:if>
        <div <c:if
                test="${not empty printSettings.printType and printSettings.printType == 1}"> style="display: none;"</c:if>
                class="layui-card-body preview">
            <input uglcw-role="textbox" type="hidden" id="billId" value="${billId}"/>
            <div style="width: 794px; margin: 0 auto;">
                <div style=" text-align: center; margin:10px auto;width:100%;height:540px;" id="printcontent">
                    <div id="header">
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
                        <table style="width: 100%">
                            <tbody>
                            <tr>
                                <td style="width: 180px;">
                            <span style="font-size: 10px">
                                <c:if test="${not empty printSettings.other2}">工商号:${printSettings.other2 }</c:if>
                            </span>
                                    <div style="margin-top: 5px;">
                                        页码:<span class="pagination">1/1</span>
                                        <c:if test="${printSettings.displayStk != null and printSettings.displayStk > 0}">&nbsp;&nbsp;&nbsp;&nbsp;仓库:<span> ${stkName}</span></c:if>
                                    </div>
                                </td>
                                <td align="center">
    				 <span style="font-size:22px;color:#000000;font-weight:bold;">
    				 	<c:choose>
                            <c:when test="${outType eq '销售出库' }">${printSettings.title}</c:when>
                            <c:when test="${outType eq '报损出库' }">报损出库单</c:when>
                            <c:when test="${outType eq '领用出库' }">领用出库单</c:when>
                            <c:otherwise>其它出库单</c:otherwise>
                        </c:choose>
	   		 		  </span>
                                </td>
                                <td style="width: 250px;">
                                    <div style="display: inline;">
                                        <c:if test="${printSettings.displayWxpay > 0 and not empty printSettings.wxpayQrcode}">
                                            <div class="qrcode-wrapper" style="font-size: 10px; display: inline-block;">
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
                                            <div class="qrcode-wrapper" style="font-size: 10px; display: inline-block;">
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
                                        test="${printSettings.masterFontsize>0}">font-size:${printSettings.masterFontsize}px;</c:if>font-weight: bold;text-align: left;padding-left: 1px">${khNm}</td>
                                <td style="text-align: right;padding-right: 1px">电&nbsp;&nbsp;话:</td>
                                <td style="text-align: left;padding-left: 1px">${tel}</td>
                                <td style="text-align: right;padding-right: 1px">地&nbsp;&nbsp;址:</td>
                                <td style="text-align: left;padding-left: 1px">${address }</td>
                            </tr>
                            <tr
                                    <c:if test="${printSettings.masterHeight > 0}">style="height: ${printSettings.masterHeight}px;"</c:if> >
                                <td style="text-align: right;padding-right: 1px;width: 65px">配送指定:</td>
                                <td style="text-align: left;padding-left: 1px;width: 180px">
                                    <c:choose>
                                        <c:when test="${pszd eq '公司直送'}">
                                            ${not empty printSettings.gszsName?printSettings.gszsName:pszd}
                                        </c:when>
                                        <c:otherwise>
                                            ${pszd}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: right;padding-right: 1px;width: 65px">日&nbsp;&nbsp;期:
                                </td>
                                <td style="text-align: left;padding-left: 1px;width: 110px">
                                    ${fn:substring(outTime, 0 , 10)}
                                </td>
                                <td style="text-align: right;padding-right: 1px;width: 65px">单&nbsp;&nbsp;号:
                                </td>
                                <td style="text-align: left;padding-left: 1px">${billNo}</td>
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
                                        <td style="text-align: left;padding-left: 1px;">${epCustomerName}</td>
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
                                <td style="text-align: left;" colspan="3">${remarks}</td>
                                <c:if test="${printSettings.displayCustomerDept>0}">
                                    <td style="text-align: right;width:70px;">累计应收:</td>
                                    <td style="text-align: left">${customerDept.sumamt}</td>
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
                            <%-- <td>
                                 &nbsp;
                             </td>--%>
                        </tr>
                        </thead>
                        <tbody id="chooselist" class="content">
                        <c:forEach items="${mapList}" var="item" varStatus="s">
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
                                    <c:when test="${data.fdFieldKey eq 'wareCode'}">
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
                                        <%--       <td>

                                               </td>--%>
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
                                                ${totalamt}
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
                                            <c:if test="${loop.index == 0}">合计：${fns:convertNumberToChinese(totalamt)}</c:if>
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
                                    <c:if test="${printSettings.displayUnitCount>0}">大单位合计:${bigUnitCount}&nbsp;&nbsp;小单位合计:${smallUnitCount}&nbsp;&nbsp;</c:if>
                                    <c:if test="${printSettings.displayAmt>0}">
                                        整单折扣:${discount}&nbsp;&nbsp;应收金额:${disamt}&nbsp;&nbsp;
                                    </c:if>
                                    <c:if
                                            test="${printSettings.displaySalesman > 0}">业务员:${staff }&nbsp;&nbsp;${staffTel}</c:if>&nbsp;&nbsp;制单人:${operator}&nbsp;&nbsp;咨询电话:${printSettings.tel}&nbsp;&nbsp;
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
                </div>
            </div>
            <div id="preview-wrapper" style="width: 794px;margin: 0 auto;">
                <div id="preview" style="width: 100%; text-align: center; margin: 0 auto;"></div>
            </div>
        </div>
    </div>

</div>
<script id="settings-tpl" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal print-settings" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6">工商号</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" value="${printSettings.other2}" uglcw-model="other2"/>
                    </div>
                </div>
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
                    <label class="control-label col-xs-6">公司直送名称</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" value="${printSettings.gszsName}" uglcw-model="gszsName"/>
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
                    <label class="control-label col-xs-6">打印方式</label>
                    <div class="col-xs-18">
                        <ul uglcw-model="printType" uglcw-role="radio" uglcw-value="${printSettings.printType}"
                            uglcw-options="dataSource:[{text:'网页打印', value: '0'},{text:'PDF打印', value: '1'},{text:'LODOP', value: '2'}]"></ul>

                        <a style="color: #38f" target="_blank"
                           href="http://www.lodop.net/download/Lodop6.226_Clodop3.093.zip">下载LODOP</a>
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
                        <input id="displaySalesman" uglcw-value="${printSettings.displaySalesman}" type="checkbox"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="displaySalesman"/>
                        <label class="k-checkbox-label" for="displaySalesman">显示业务员</label>
                        <input id="displayCustomerDept" uglcw-value="${printSettings.displayCustomerDept}" type="checkbox"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="displayCustomerDept"/>
                        <label class="k-checkbox-label" for="displayCustomerDept">显示客户欠款</label>
                        <input id="displayUnitCount" type="checkbox" uglcw-value="${printSettings.displayUnitCount}"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="displayUnitCount"/>
                        <label class="k-checkbox-label" for="displayUnitCount"> 显示大/小单位统计</label>
                        <input id="displayStk" type="checkbox" uglcw-value="${printSettings.displayStk}"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="displayStk"/>
                        <label class="k-checkbox-label" for="displayStk"> 显示仓库</label>
                        <input id="displayEp" type="checkbox" uglcw-value="${printSettings.displayEp}"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="displayEp"/>
                        <label class="k-checkbox-label" for="displayEp"> 显示二批</label>
                        <input id="displayAmt" type="checkbox" uglcw-value="${printSettings.displayAmt}"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="displayAmt"/>
                        <label class="k-checkbox-label" for="displayAmt"> 显示金额</label>
                    </div>
                </div>
                <div class="form-group"
                     style="display: ${fns:checkFieldDisplay('sys_config',''*'','code=\"CONFIG_AUTO_PRINT_STK_OUT\"  and status=1')}">
                    <label class="control-label col-xs-6">自动打印选项</label>
                    <div class="col-xs-18">
                        <label>打印时间点</label>
                        <select uglcw-role="combobox" id="autoPrintType" uglcw-model="autoPrintType" style="width: 130px;">
                            <option value="0">未选择</option>
                            <option value="1" <c:if test="${printSettings.autoPrintType == 1}"> selected</c:if>>暂存
                            </option>
                            <option value="2" <c:if test="${printSettings.autoPrintType == 2}"> selected</c:if>>审批
                            </option>
                        </select>
                        <input id="autoPrintRepeat" uglcw-value="${printSettings.autoPrintRepeat}" type="checkbox"
                               uglcw-options="type:'number'" uglcw-role="checkbox" uglcw-model="autoPrintRepeat"/>
                        <label class="k-checkbox-label" for="autoPrintRepeat">允许重复打印</label>
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
                    <label class="control-label col-xs-6">纸张大小</label>
                    <div class="col-xs-18">
                        <input style="width: 60px;" uglcw-role="numeric" uglcw-options="spinners: false, format: 'n0'"
                               value="${printSettings.pageWidth}"
                               uglcw-model="pageWidth"/>
                        <span>*</span>
                        <input style="width: 60px;" uglcw-role="numeric" uglcw-options="spinners: false, format: 'n0'"
                               value="${printSettings.pageHeight}"
                               uglcw-model="pageHeight"/>
                        <span style="color:#444">纸张大小(px),默认652x396</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">左右边距</label>
                    <div class="col-xs-18">
                        <span>左边距:</span>
                        <input style="width: 60px;" uglcw-role="numeric" uglcw-options="spinners: false, format: 'n0'"
                               value="${printSettings.leftMargin == null ? 14 : printSettings.leftMargin}"
                               uglcw-model="leftMargin"/>
                        <span>右边距:</span>
                        <input style="width: 60px;" uglcw-role="numeric" uglcw-options="spinners: false, format: 'n0'"
                               value="${printSettings.rightMargin == null ? 14 : printSettings.rightMargin}"
                               uglcw-model="rightMargin"/>
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
                        <span style="color:darkgray">建议60*60</span>
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
            <div class="column-setting uglcw-grid-compact" uglcw-role="grid" uglcw-options="
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
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<c:if test="${not empty printSettings.printType and printSettings.printType == 2}">
    <script type="text/javascript" src="${base}static/uglcu/plugins/lodop/LodopFuncs.js"></script>
</c:if>
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

        <c:choose>
        <c:when test="${not empty printSettings.printType and printSettings.printType == 1}">
        var w = window;
        $('#previewWindow')[0].contentWindow.onafterprint = function () {
            w.showBill();
        }
        $('#previewWindow')[0].contentWindow.print();
        addPrintRecord();
        </c:when>
        <c:when test="${not empty printSettings.printType and printSettings.printType == 2}">
        lodopPrint();
        addPrintRecord();
        </c:when>
        <c:otherwise>
        /* var newstr = document.getElementById('preview').innerHTML;
         var oldstr = document.body.innerHTML;//
         document.body.innerHTML = '<div class="preview">' + newstr + '</div>';*/
        window.print();
        addPrintRecord(function () {
            uglcw.ui.closeCurrentTab();
        });

        </c:otherwise>
        </c:choose>

    }

    function addPrintRecord(callback) {
        $.ajax({
            url: "${base}manager/sysPrintRecord/addPrintRecord",
            data: {fdSourceId: '${billId}', fdSourceNo: '${billNo}', fdModel: '${fdModel}'},
            type: "post",
            success: function (json) {
                if (callback && $.isFunction(callback)) {
                    callback()
                }
            }
        });
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
        //uglcw.ui.openTab('销售单据', '${base}manager/showstkout?dataTp=1&billId=${billId}');
        window.location.href = '${base}manager/showstkout?dataTp=1&billId=${billId}';
    }

    function addTemplate() {
        uglcw.ui.openTab('设置模版', '${base}manager/stkPrintTemplate/page?fdType=1');
    }

    function addWareGroup() {
        var cstId = '${cstId}';
        uglcw.ui.openTab(cstId + '_设置客户商品分组', '${base}manager/stkCustomerWareGroup/queryStkWareGroup?cstId=' + cstId);
    }

    function changeTemplate(o) {
        var mergeId = $("#mergeId").val();
        window.location.href = '${base}manager/showstkoutprint?dataTp=1&billId=${billId}&fromFlag=${param.fromFlag}&templateId=' + o.value + "&merge=" + mergeId;
    }


    function changeMerge(o) {
        var templateId = $("#templateId").val();
        window.location.href = '${base}manager/showstkoutprint?dataTp=1&billId=${billId}&fromFlag=${param.fromFlag}&templateId=' + templateId + "&merge=" + o.value;
    }

    $("#mergeId").val('${merge}');
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

    function lodopPrint() {
        createPage();
        LODOP.PREVIEW();
    };
</script>
</body>
</html>



