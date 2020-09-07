<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="id" type="java.lang.String" 
	description="id" required="true"%>
<%@ attribute name="name" type="java.lang.String" 
	description="name" required="true"%>
<%@ attribute name="value" type="java.lang.String" 
	description="value" %>	
<%@ attribute name="onchange" type="java.lang.String" 
	description="onchange"%>
<%@ attribute name="onclick" type="java.lang.String" 
	description="onclick"%>
<%@ attribute name="headerKey" type="java.lang.String" 
	description="headerKey属性"%>
<%@ attribute name="headerValue" type="java.lang.String" 
	description="headerValue属性"%>	
<%@ attribute name="style" type="java.lang.String" 
	description="样式"%>	
<%@ attribute name="tclass" type="java.lang.String" 
	description="class"%>	
<select id="${id}" name="${name }" style="${style}" class="${tclass }">
<c:if test="${ not empty headerKey || headerKey eq ''}">
	<option value="${headerKey}" >
	<c:if test="${ not empty headerValue }">${headerValue }</c:if>
	</option>
</c:if>
	<option value="10001" ${(value eq  '10001')?'selected':''}>正常采购</option>
	<option value="10005" ${(value eq  '10005')?'selected':''}>其他</option>
</select>