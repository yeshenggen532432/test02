<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%@ attribute name="id" type="java.lang.String"
	description="id" required="true"%>
<%@ attribute name="name" type="java.lang.String"
	description="name" required="true"%>
<%@ attribute name="placeholder" type="java.lang.String"
			  description="name" required="false"%>
<%@ attribute name="value" type="java.lang.String"
	description="value" %>
<%@ attribute name="onchange" type="java.lang.String"
	description="onchange"%>
<%@ attribute name="onselect" type="java.lang.String"
			  description="onselect"%>
<%@ attribute name="onclick" type="java.lang.String"
	description="onclick"%>
<%@ attribute name="displayKey" type="java.lang.String"
	description="option显示的key字段名" required="true"%>
<%@ attribute name="displayValue" type="java.lang.String"
	description="option显示的value字段名" required="true"%>
<%@ attribute name="headerKey" type="java.lang.String"
	description="headerKey属性"%>
<%@ attribute name="headerValue" type="java.lang.String"
	description="headerValue属性"%>
<%@ attribute name="width" type="java.lang.String"
	description="width长度"%>
<%@ attribute name="tableName" type="java.lang.String"
	description="tableName" required="true"%>
<%@ attribute name="selectBlock" type="java.lang.String"
	description="id,name"%>
<%@ attribute name="whereBlock" type="java.lang.String"
	description="id=1 and name='2' "%>
<%@ attribute name="tclass" type="java.lang.String"
	description="tclass属性"%>
<%@ attribute name="style" type="java.lang.String"
			  description="style"%>
<%@ attribute name="options" type="java.lang.String" %>
<%@ attribute name="validate" type="java.lang.String" %>
<%@ attribute name="tooltip" type="java.lang.String" %>
<%@ attribute name="allowInput" type="java.lang.Boolean"%>
<%@ attribute name="attrStr" type="java.lang.String" %>
<%@ attribute name="index" type="java.lang.Integer" %>
<%@ attribute name="attrJson" type="java.lang.String"
			  description="需要增加的属性JSON,key为属性名，value为对象值"%>

<c:set var="datas" value="${fns:loadListByParam(tableName,selectBlock,whereBlock)}"/>
<c:if test="${attrJson !=null && attrJson !=''}">
	<c:set var="attrsMap" value="${fns:toJsonArray(attrJson)}"/>
</c:if>

<select id="${id}" qwb-model="${name }" <c:if test="${attrStr !=null}"> ${attrStr} </c:if> qwb-role="combobox" onchange="${onchange }" placeholder="${placeholder}"  qwb-options="value: '${value}',
<c:if test="${tooltip !=null}">tooltip: '${tooltip}',</c:if>
<c:if test="${allowInput !=null and allowInput}">allowInput: true, filter:'contains',</c:if>
<c:if test="${onselect != null and not empty onselect}">select: ${onselect},</c:if>
<c:if test="${index !=null}">index: ${index},</c:if>
	dataTextField:'${displayValue}', dataValueField:'${displayKey}'" <c:if test="${not empty validate}">qwb-validate="${validate}"</c:if> style="width:${width};">
<c:if test="${ not empty headerKey || headerKey eq ''}">
	<option value="${headerKey}" >
	<c:if test="${ not empty headerValue }">${headerValue}</c:if>
	</option>
</c:if>
<c:forEach items="${datas}" var="map">
	<option value="${map[displayKey]}" ${(value eq  map[displayKey])?'selected':''}>${map[displayValue]}</option>
</c:forEach>
</select>
<%--因下拉option无法增加元素所有做个隐藏域,方便页面使用--%>
<ul id="assist_${id}" style="display: none">
	<c:forEach items="${datas}" var="map">
		<li
		<c:if test="${attrsMap !=null}">
			<c:forEach items="${attrsMap}" var="attrMap">
				<c:forEach items="${attrMap}" var="attr">
					${attr.key}="${map[attr.value]}"
				</c:forEach>
			</c:forEach>
		</c:if>
		>${map[displayValue]}</li>
	</c:forEach>
</ul>
