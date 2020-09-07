<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>批量打印销售发票</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<%@include file="/WEB-INF/page/include/source.jsp" %>
	<link href="${base}resource/quill/quill.snow.css" rel="stylesheet">
	<script src="${base}resource/quill/quill.min.js"></script>

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
<input type="hidden" id="billId" value="${billId}"/>
<div id="printbtn" style=" width:100%;text-align: center; margin:5px auto;">
	<input id="btnPrint" value="打印" class="easyui-linkbutton" style=" width:50px; height:22px; "
		   type="button" onclick="printit()">
	<tag:select name="templateId" id="templateId" value="${templateId}"
				onchange="changeTemplate(this)" tableName="stk_print_template"
				displayKey="id" displayValue="fd_name" whereBlock="fd_type='1'">
	</tag:select>
</div>
<div style=" text-align: center; margin:10px auto;width:794px;height:540px;" id="printcontent">
<c:forEach items="${mainDatas}" var="main">
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
							<c:when test="${outType eq '报损出库' }">报损出库单</c:when>
							<c:when test="${outType eq '领用出库' }">领用出库单</c:when>
							<c:otherwise>其它出库单</c:otherwise>
						</c:choose>
                         <c:if test="${saleType eq '003'}">
							 <span style="font-size: 12px">(商城订单)</span>
						 </c:if>
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
					<td style="text-align: right;width:70px;">累计应收:</td>
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
		<c:forEach items="${main.maps}" var="item" varStatus="s">
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
					<c:otherwise>
						${fns:shapeField(item[data.fdFieldKey], data.fdDecimals)}
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
								${fns:shapeField(disamt, data.fdDecimals)}
						</td>
					</c:when>
					<c:when test="${data.fdFieldKey eq 'qty'}">
						<td class="aggregate">
								${fns:shapeField(sumQty, data.fdDecimals)}
						</td>
					</c:when>
					<c:when test="${data.fdFieldKey eq 'price'}">
						<td style="border-left:1px solid #ffffff;border-right:1px solid #ffffff;">

						</td>
					</c:when>
					<c:otherwise>
						<td <c:if test="${loop.index == 0}">class="aggregate-txt"</c:if>>
							<c:if test="${loop.index == 0}">合计：${fns:convertNumberToChinese(totalamt)}</c:if>
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
					<%--<c:if test="${printSettings.displayUnitCount>0}">大单位合计:${bigUnitCount}&nbsp;&nbsp;小单位合计:${smallUnitCount}&nbsp;&nbsp;</c:if>--%>
					整单折扣:${discount}&nbsp;&nbsp;应收金额:${disamt}&nbsp;&nbsp;<c:if
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
</c:forEach>
</div>

<div style="width: 794px; text-align: center; margin: 10px auto;">
	<div id="preview" style="width: 100%"></div>
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
			if (AutoPage.totalHeight == 0) {
				AutoPage.totalHeight = 470;
			}

			for (var i = 1; i < tmpRows.length; i++) {
				AutoPage.removeScript(tmpRows[i]);
				var tableHeight = AutoPage.totalHeight - (page <= 1 || AutoPage.repeatTitle ? AutoPage.header.height() : 0)
						- (AutoPage.repeatFooter ? AutoPage.footer.height() : 0);
				var trHtmp = tmpRows[i].clientHeight;//第i行高度
				if (tableHeight < trHtmp) {
					alert('页面高度过小，请调整设置');
					return;
				}

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

		var html = $('#printMemo').html()
		if (html) {
			//' '替换为&nbsp;
			$('#printMemo').html(html.replace(/\s/g, '&nbsp;'));
		}

		var other1Html = $('#other1').html()
		if (other1Html) {
			//' '替换为&nbsp;
			$('#other1').html(other1Html.replace(/\s/g, '&nbsp;'));
		}

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

		adjustAggregate();

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
		$.ajax({
			url: "manager/sysPrintRecord/addPrintRecordBatch",
			data: {fdSourceId: '${ids}', fdSourceNo: '${voucherNos}', fdModel: '${fdModel}'},
			type: "post",
			success: function (json) {
					parent.closeWin('批量打印发票');
			}
		});
		var newstr = document.getElementById('preview').innerHTML;
		var oldstr = document.body.innerHTML;//
		document.body.innerHTML = newstr;
		window.print();
		document.body.innerHTML = oldstr;
	}

	function showPictrue(input) {
		var r = new FileReader();
		f = input.files[0];
		r.readAsDataURL(f);
		r.onload = function (e) {
			//$(input).closest('.form-item').find('img').attr('src', this.result);
		}
	}


	function changeTemplate(o) {
		var mergeId = $("#mergeId").val();
		location = 'manager/showstkoutbatchprint?dataTp=1&billIds=${billIds}&fromFlag=${param.fromFlag}&templateId=' + o.value + "&merge=" + mergeId;
	}

</script>
</body>
</html>



