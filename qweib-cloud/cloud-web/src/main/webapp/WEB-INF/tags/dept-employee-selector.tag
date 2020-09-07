<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@tag pageEncoding="UTF-8" %>
<%@ attribute name="callback" type="java.lang.String" %>
<%@ attribute name="query" type="java.lang.String" required="false" %>
<%@ attribute name="checkbox" type="java.lang.Boolean" required="false" %>
<c:set var="ck" value="${checkbox == null ? true: checkbox}"/>
    qwb.ui.Modal.showTreeGridSelector({
        tree: {
            dataTextField: 'branchName',
            lazy: false,
            loadFilter: function (response) {
                return response.list || [];
            },
            url: '${base}manager/queryStkDepart',
            model: 'branchId',
            id: 'branchId',
            expandable: function () {
                return true;
            }
        },
        width: 900,
        id: 'memberId',
        pageable: true,
        url: '${base}manager/stkMemberPage',
        query: function (params) {
            <c:if test="${not empty query}">
            return ${query}(params);
            </c:if>
        },
        checkbox: ${ck},
        criteria: '<input qwb-role="textbox" placeholder="输入关键字" qwb-model="memberNm">',
        columns: [
            {field: 'memberNm', title: '姓名', width: 'auto'},
            {field: 'memberMobile', title: '电话', width: 'auto'}
        ],
        yes: function (data) {
            if (data) {
                <c:if test="${not empty callback}">
                ${callback}(data);
                </c:if>
            }
        }
    });
