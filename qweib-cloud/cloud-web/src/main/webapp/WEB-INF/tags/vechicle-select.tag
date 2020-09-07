<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="base" type="java.lang.String"
			  description="base" required="true"%>
<%@ attribute name="required" type="java.lang.String"
			  description="required"%>
<%@ attribute name="id" type="java.lang.String"
	description="id" required="true"%>
<%@ attribute name="name" type="java.lang.String"
	description="name" %>
<%@ attribute name="value" type="java.lang.String"
	description="value" %>
<%@ attribute name="showHead" type="java.lang.String"
			  description="showHead" %>
<%@ attribute name="style" type="java.lang.String"
			  description="样式" %>
<%@ attribute name="dataBound" type="java.lang.String"
			  description="dataBound" %>
<%@ attribute name="change" type="java.lang.String"
			  description="change" %>
<%@ attribute name="status" type="java.lang.String"
			  description="空显示全部,1只显示启用数据" %>
<%@ attribute name="type" type="java.lang.String"
			  description="0或者空为正常仓库  1:车销仓库 2:门店仓库" %>
<%--<select <c:if test="${not empty required}">--%>
				<%--qwb-validate="required"--%>
			<%--</c:if>--%>

		<%--qwb-model="${id}" qwb-role="combobox" id="${id}"   placeholder="仓库"--%>
		<%--qwb-options="value: '', tooltip: '仓库',url: '${base}manager/getStorageList?status=${status}&saleCar=${type}',--%>
						<%--dataTextField: 'stkName',--%>
						<%--index: 0,--%>
						<%--dataValueField: 'id',--%>
						<%--<c:if test="${not empty dataBound}">--%>
						<%--dataBound:${dataBound}--%>
						<%--</c:if> "--%>
		<%--tyle="${style}--%>
<%-->--%>

<%--</select>--%>
<input
	<c:if test="${not empty required}">
		qwb-validate="required"
	</c:if>
	   qwb-role="combobox"
	   id="${id}" value="${value}"
	   onchange="${change}"
	   placeholder="仓库"
	   qwb-options="url: '${base}manager/getStorageList?status=${status}&saleCar=${type}',
						dataTextField: 'stkName',
						dataValueField: 'id',
						loadFilter:{
                                    data: function(response){
                                    var list = [];
									<c:if test="${showHead}">
									var head={id:-1,stkName:''};
				                    list.push(head);
				                    </c:if>
                                    list = list.concat((response.list || []));
                                    return list;
                                    }
                                  },
						<c:if test="${not empty dataBound}">
						dataBound:${dataBound},
						</c:if>
						index: 0,
						"
	   					qwb-model="${id}"
	   					style="${style}"></input>