<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企微宝</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	
	<style>
	body, div, dl, dt, dd, ul, ol, li, h1, h2, h3, h4, h5, h6, pre, code, form, input, textarea,select, fieldset, legend, p, span, label, blockquote,table, th, td, object,html{margin:0;padding:0;}
	.tableList{margin:0 auto; font-size:12px;text-align: center;}
	.tableList thead tr{background-color:#f0faff;height:30px; font-size:12px;}
	.tableList tr.thead {background-color:#f0faff;height:30px; font-size:13px;}
	
	.TableLine{height:28px;font: bold;font-size:12px;text-align: left}
	.TableLine1{background-color: #ffffff; height:28px;font: bold;font-size:12px;}
	.tableList1{margin:0 auto; font-size:12px;text-align: center;border-color:dark;}
	table{margin:0 auto;}
	</style>
	
	</head>
	<body >
			<br/>
			<form action="manager/saveAutoCstDetailStat" name="saveAutoCstDetailStatfrm" id="saveAutoCstDetailStatfrm" method="post">
			<input type="hidden" name="rptType" value="4"/>
			&nbsp;&nbsp;报表标题：<input name="rptTitle" value="${sdate}-${edate}客户费用统计表" size="80"/>
			<br/>
			&nbsp;&nbsp;备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：
			<textarea name="remark" rows="5" cols="90">报表参数--时间:${sdate}-${edate},销售类型:${outType},客户类型:${customerType },所属二批:${epCustomerName }
			</textarea><input style='width:60px;height:27px' id="saveRptButton" type='button' value='保存' onclick='javascript:updateSubmit();'/>
			<textarea  name="saveHtml" id="saveHtml" style="display:none "></textarea>
			</form>
			<div id="saveHtmlDiv">
			<table  align="center" border="1"
					cellpadding="0" cellspacing="0"  width="1800px" class="tableList">
			<tr class="thead">
			<td>&nbsp;&nbsp;&nbsp;</td>
			<td >&nbsp;&nbsp;客户名称</td> 
			<td >&nbsp;&nbsp;所属二批</td> 
			<td >&nbsp;&nbsp;销售数量</td> 
			<td >销售收入</td> 
			<td >平均单位售价</td> 
			<td >整单折扣 </td>
			<td >销售费用投入</td>
			<td >销售成本</td>
			<td >自定义费用</td> 
			<c:if test="${not empty autoList }">
			<c:forEach items="${autoList }" var="auto">
				<td>
					${auto.name }
				</td>
			</c:forEach>
			</c:if>
			<td >固定成本</td>
			<td >销售毛利</td> 
			<td >平均单位毛利</td> 
			</tr>
			<c:forEach items="${mainDatas }" var="d" varStatus="s">
			<tr height="26" class="TableLine" style="text-align:left">
			<td>${s.index+1 }</td> 
			<td style="text-algin:left">${d.stkUnit }</td> 
			<td style="text-algin:left">${d.epCustomerName }</td> 
			<td ><fmt:formatNumber type="number"  maxFractionDigits="3" value="${d.sumQty}"/></td> 
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${d.sumAmt}"/></td> 
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${d.avgPrice}"/></td> 
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${d.discount}"/></td>
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${d.inputAmt}"/></td> 
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${d.sumCost}"/></td>
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${d.autoCost}"/></td> 
			<c:if test="${not empty autoList }">
			<c:forEach items="${autoList }" var="auto">
				<td>
					<c:forEach items="${d.autoMap}" var="map">
						<c:if test="${map.key eq auto.id }">
							${map.value }
						</c:if>
					</c:forEach>
				</td>
			</c:forEach>
			</c:if>
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${d.fee}"/></td> 
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${d.disAmt}"/></td> 
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${d.avgAmt}"/></td> 
			</tr>
			</c:forEach>
			</table>
			</div>
	</body>
	<script>
	function updateSubmit(){
		 document.getElementById("saveHtml").value="";
		 document.getElementById("saveHtml").value=$("#saveHtmlDiv").formhtml();
		 $("#saveAutoCstDetailStatfrm").form('submit',{
				success:function(data){
					data = eval(data)
					if(parseInt(data)>0){
						alert("保存成功！");
						$("#saveRptButton").attr("disabled","true"); 
						parent.closeWin('生成的统计表');
				    	parent.add('生成的统计表','manager/querySaveRptDataStat?rptType=4');
					}else{
						alert("保存失败！");
					}
				}
		});
	   }
	 (function ($) {
		    var oldHTML = $.fn.html;
		    $.fn.formhtml = function () {
		        if (arguments.length) return oldHTML.apply(this, arguments);
		        $("input,textarea,button", this).each(function () {
		            this.setAttribute('value', this.value);
		        });
		        $(":radio,:checkbox", this).each(function () {
		            // im not really even sure you need to do this for "checked"
		            // but what the heck, better safe than sorry
		            if (this.checked) this.setAttribute('checked', 'checked');
		            else this.removeAttribute('checked');
		        });
		        $("option", this).each(function () {
		            // also not sure, but, better safe...
		            if (this.selected) this.setAttribute('selected', 'selected');
		            else this.removeAttribute('selected');
		        });
		        return oldHTML.apply(this);
		    };

		    //optional to override real .html() if you want
		    // $.fn.html = $.fn.formhtml;
		})(jQuery);
	</script>
</html>
