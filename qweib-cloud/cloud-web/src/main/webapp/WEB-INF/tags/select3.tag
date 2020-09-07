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
<c:set var="datas" value="${fns:loadListByParam(tableName,selectBlock,whereBlock)}"/>
<select id="${id}" qwb-model="${name }" <c:if test="${attrStr !=null}"> ${attrStr} </c:if> qwb-role="combobox" placeholder="${placeholder}"
	 qwb-options='value: "${value}",
	 <c:if test="${onchange !=null}">change: ${onchange},</c:if>
	 <c:if test="${onselect !=null}">select: ${onselect},</c:if>
<c:if test="${tooltip !=null}">tooltip: "${tooltip}",</c:if>
<c:if test="${allowInput !=null and allowInput}">allowInput: true, filter:"contains",</c:if>
<c:if test="${index !=null}">index: ${index},</c:if>
	dataTextField:"${displayValue}", dataValueField: "${displayKey}",
	dataSource: ${fns:toJson(datas)}
'
		<c:if test="${not empty validate}">qwb-validate="${validate}"</c:if> style="width:${width};">
</select>
