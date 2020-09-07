<%@ page language="java" pageEncoding="UTF-8"%>
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
	
			<link rel="stylesheet" type="text/css" href="resource/css/dtree.css">
		<script type="text/javascript" src="resource/dtree.js"></script>
		<link rel="stylesheet" type="text/css" href="resource/login/css/nav.css" />
	</head>
	<body>
		<div class="easyui-accordion" id="easyui-accordion" height="100%" style="width:150px;border:0;" data-options="fit:false">
		<c:if test="${!empty pmenus}">
				<c:forEach items="${pmenus}" var="menuObj">
					<div title="${menuObj.menu_nm}" data-options="href:'manager/nextmenu?id=${menuObj.id_key}&optype=${optype }'" style="overflow:auto;"></div>
				</c:forEach>
		</c:if>
		<c:if test="${!empty cnmenus}">
					<div title="收款窗口" data-options="" style="overflow:auto;">
						<dl class="leftbar">
							<c:forEach items="${cnmenus}" var="menuObj">
								<c:if test="${fn:contains('收货款管理,其它收入收款,往来借入,往来回款收入',menuObj.menu_nm)==true}">
									<dd class="${menuObj.menu_cls}"><a href="javascript:parent.add('${menuObj.menu_nm}','manager/${menuObj.menu_url}?dataTp=${menuObj.data_tp }');">${menuObj.menu_nm}</a></dd>
								</c:if>
							</c:forEach>
					</dl>
					</div>
					<div title="付款窗口" data-options="" style="overflow:auto;">
						<dl class="leftbar">
						<c:forEach items="${cnmenus}" var="menuObj">
								<c:if test="${fn:contains('付货款管理,费用支付凭证,往来借出,往来还款支出',menuObj.menu_nm)==true}">
									<dd class="${menuObj.menu_cls}"><a href="javascript:parent.add('${menuObj.menu_nm}','manager/${menuObj.menu_url}?dataTp=${menuObj.data_tp }');">${menuObj.menu_nm}</a></dd>
								</c:if>
						</c:forEach>
						</dl>
					</div>
		</c:if>
		</div>
	</body>
</html>
