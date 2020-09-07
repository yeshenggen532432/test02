<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>  
<html>
<head>
	<meta charset="UTF-8">
	<title>下载页</title>
	<meta content="target-densitydpi=device-dpi,width=640" name="viewport">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<link rel="stylesheet" href="resource/wj/css/reset.css">
	<link rel="stylesheet" href="resource/wj/css/survey_results.css">
</head>
<%--<script type="text/javascript">
	$(function(){border-radius：35px
		var ratio = '${ratio.ratio }';
		if(ratio==100){
			
		}
	});
</script>
--%>
<body>
<c:if test="${state==true}">
	<div class="wrap">
<!-- 		<header cleafix>
			<a href="" title=""><img src="../image/return.png" alt="" title=""></a>
			<h2>问卷调查 </h2>
		</header> -->
		<div class="con clearfix">
			<h3>您的选择是：</h3>
				<c:forEach items="${strArray}" var="nos" varStatus="status">
					<span>${nos }</span>&nbsp;&nbsp;
				</c:forEach>
			<div class="select clearfix">
				<ul cleafix>
					<c:forEach items="${ratios}" var="ratio" varStatus="i">
						<li>
							<span>${ratio.no }</span>
							<p>${ratio.content }</p>
							<div>
								<strong style="width:${ratio.ratio }%"></strong>
							</div>
							<em><fmt:formatNumber type="number" value="${ratio.ratio } " maxFractionDigits="1"/>%</em>
						</li>
					</c:forEach>
				</ul>
			</div>
			<a href="web/listQuestionnaire">返回</a>
			<%--<a onclick="javascript:history.go(-1)">返回</a>--%>
			</div>
			<%--<div class="wj_tijiao" style="width:100%"><a href="javascript:history.go(-1)" >返回</a></div>--%>
	</div>
</c:if>	
	<!-- 错误消息提示 -->
	<c:if test="${state==false}">
		<div align="center" style="margin-top: 0px;width: auto;">
		  	<font color="red" size="30px">${msg}</font>
		</div>	
	</c:if>
	<script>
		  // 调用自适应屏幕的功能函数，640是根据psd图来设置，有多宽设置多宽
  			// opt.fixViewportWidth(640);
	</script>
	<script type="text/javascript" src="resource/loadpage/js/MetaHandler.js"></script>
</body>
</html>