<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
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
			  description="value" %>
<input qwb-validate="required" qwb-role="combobox" id="${id}" value="${value}" onchange="${change}"
	   qwb-options="url: '${base}manager/stkHouse/dataList',
						dataTextField: 'houseName',
						index: 0,
						dataValueField: 'id',
						dataBound:${dataBound}
                                        " qwb-model="${id}" style="${style}"></input>