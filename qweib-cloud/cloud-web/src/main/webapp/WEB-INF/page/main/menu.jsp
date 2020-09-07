<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>T3</title>
	</head>
	<body>
		<dl class="leftbar">
			<c:if test="${!empty menus}">
				<c:forEach items="${menus}" var="menuObj">
					<c:if test="${fn:contains(menuObj.menu_url,'?')==false}">
						<dd class="${menuObj.menu_cls}"><a href="javascript:parent.add('${menuObj.menu_nm}','manager/${menuObj.menu_url}?dataTp=${menuObj.data_tp }');">${menuObj.menu_nm}</a></dd>
					</c:if>
					<c:if test="${fn:contains(menuObj.menu_url,'?')==true}">
						<dd class="${menuObj.menu_cls}"><a href="javascript:parent.add('${menuObj.menu_nm}','manager/${menuObj.menu_url}&dataTp=${menuObj.data_tp }');">${menuObj.menu_nm}</a></dd>
					</c:if>
				</c:forEach>
			</c:if>
		</dl>
	</body>
</html>
