<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>科目余额表-二级细表</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	<style>
		tr{background-color:#FFF;height:30px;vertical-align:middle; padding:3px;}
		td{padding-left:10px;}
	</style>
</head>
<body >
<div id="tb" >
	<form action="manager/calAccountBlanceList?_sticky=v2" name="toFinCalAccountBlancefrm" id="toFinCalAccountBlancefrm" method="post">
		日期:
		<input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
		<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
		<input name="rptType" id="rptType"  type="hidden" value="${rptType}" />
		<input name="typeId" id="typeId"  type="hidden" value="${typeId}"/>
		<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
		<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
	</form>
	<c:if test="${not empty datas}">
		<table width="100%" border="1"
			   cellpadding="0" cellspacing="1" >
			<tr>
				<td >项目</td>
				<td >
					本期增加
				</td>
			</tr>
			<c:forEach items="${datas}" var="data">
				<c:if test='${!(data["qc_amt"] eq 0 && data["bq_in_amt"] eq 0 && data["bq_out_amt"] eq 0 && data["qm_amt"] eq 0)}'>
					<tr>
						<td style="padding-left: 20px;">&nbsp;&nbsp;${data["name"]}</td>
						<td >
							<fmt:formatNumber value='${data["bq_in_amt"]}' pattern="#,#00.0#"/>
						</td>
					</tr>
				</c:if>
			</c:forEach>

		</table>
	</c:if>
</div>
</body>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	function query(){
		uglcw.ui.loading();
		document.getElementById("toFinCalAccountBlancefrm").submit();
	}
</script>
</html>
