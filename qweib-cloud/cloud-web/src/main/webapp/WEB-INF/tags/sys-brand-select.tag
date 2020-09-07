<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="base" type="java.lang.String"
			  description="base" required="true"%>
<%@ attribute name="id" type="java.lang.String" 
	description="id" required="true"%>
<%@ attribute name="name" type="java.lang.String" 
	description="name" required="true"%>
<%@ attribute name="value" type="java.lang.String" 
	description="value" %>
<%@ attribute name="style" type="java.lang.String"
			  description="value" %>
<%@ attribute name="change" type="java.lang.String"
			  description="value" %>
<%@ attribute name="dataBound" type="java.lang.String"
			  description="dataBound" %>
<%@ attribute name="status" type="java.lang.String"
			  description="空显示全部,1只显示启用数据" %>
<input qwb-validate="required" qwb-role="combobox" id="${id}" value="${value}" placeholder="商品品牌" onchange="${change}"
	   qwb-options="url: '${base}manager/brandList?status=${status}',
	  				 	dataTextField: 'name',
						dataValueField: 'id'"
	   qwb-model="${id}" style="${style}"></input>