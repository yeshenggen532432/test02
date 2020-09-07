<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="permisstion" uri="/WEB-INF/tlds/permission.tld" %>
<%@ attribute name="buttonCode" type="java.lang.String" 
	description="button code" required="true"%>
<%@ attribute name="id" type="java.lang.String" 
	description="按钮对应的id属性"%>	
<%@ attribute name="name" type="java.lang.String" 
	description="按钮对应的name属性"%>
<%@ attribute name="image" type="java.lang.String" 
	description="按钮图片对应的image属性"%>	
<%@ attribute name="onclick" type="java.lang.String" 
	description="按钮对应的onclick属性"%>
<%@ attribute name="btnType" type="java.lang.String" 
	description="按钮类型"%>
<%--popedom为1时显示，为0时不显示 --%>	
<c:set var="popedom" value="${permisstion:checkUserBtnPdm(buttonCode)}"/>
<c:if test="${not empty popedom}">
	<c:choose>
		<c:when test="${btnType eq 'button'}">
			${name}
		</c:when>
		<c:when test="${btnType eq 'column' }">
		   ${name}
		</c:when>
		<c:otherwise>
			<a  id="${id}" class="easyui-linkbutton" plain="true" iconCls="${image }" href="${onclick}">${name}</a>
		</c:otherwise>
	</c:choose>
</c:if>
