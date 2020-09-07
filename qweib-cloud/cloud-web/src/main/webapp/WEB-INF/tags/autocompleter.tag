<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@tag pageEncoding="UTF-8" %>
<%@ attribute name="name" type="java.lang.String" required="true"
	description="name"%>
<%@ attribute name="value" type="java.lang.String" 
	description="value"%>	
<%@ attribute name="id" type="java.lang.String" 
	description="id"%>
<%@ attribute name="placeholder" type="java.lang.String" 
	description="placeholder"%>
<%@ attribute name="onclick" type="java.lang.String" 
	description="onclick"%>
<%@ attribute name="onchange" type="java.lang.String" 
	description="onchange"%>
<%@ attribute name="onblur" type="java.lang.String" 
	description="onblur"%>
<%@ attribute name="onkeydown" type="java.lang.String" 
	description="onkeydown"%>
<%@ attribute name="headerKey" type="java.lang.String" 
	description="headerKey属性"%>
<%@ attribute name="width" type="java.lang.String" 
	description="width长度"%>
<%@ attribute name="headerValue" type="java.lang.String" 
	description="headerValue属性"%>
<%@ attribute name="tclass" type="java.lang.String" 
	description="tclass属性"%>
<main>
    <div class="field" >
        <input type="text" name="${name}" id="${id}" value="${value}"  placeholder="${placeholder }" class="${tclass }" style="width: ${width};font-size:11px" onclick="${onclick}" onblur="${onblur}" onchange="${onchange}" onkeydown="${onkeydown}"/>
    </div>
</main>