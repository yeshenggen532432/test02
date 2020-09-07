<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@tag pageEncoding="UTF-8" %>
<%@ attribute name="callback" type="java.lang.String" %>
qwb.ui.Modal.showGridSelector({
    closable: false,
    title: false,
    url: '${base}manager/memberPage?memberUse=1',
    checkbox: true,
    width: 650,
    height: 400,
    criteria: '<input placeholder="姓名" qwb-role="textbox" qwb-model="memberNm">',
    columns: [
        {field: 'memberNm', title: '姓名', width: 180},
        {field: 'memberMobile', title: '手机号', width: 180},
        {field: 'branchName', title: '部门', width: 180},
    ],
    yes: function (selection) {
        <c:if test="${not empty callback}">
        ${callback}(selection);
        </c:if>
    }
})
