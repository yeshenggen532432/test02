<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@tag pageEncoding="UTF-8" %>
<%@ attribute name="callback" type="java.lang.String" required="false" %>
<%@ attribute name="query" type="java.lang.String" required="false" %>
<%@ attribute name="selection" type="java.lang.String" required="false" %>
<%@ attribute name="checkbox" type="java.lang.Boolean" required="false" %>
<c:set var="ck" value="${checkbox == null ? true: checkbox}"/>
qwb.ui.Modal.showTreeGridSelector({
    tree: {
        url: '${base}manager/waretypes',
        model: 'waretype',
        id: 'id',
        expandable: function(node){
            return node.id == 0;
        }
    },
    height: 350,
    width: 800,
    id: 'wareId',
    pageable: true,
    persistSelection: true,
    url: '${base}manager/queryWarePage',
    query: function (params) {
        <c:if test="${not empty query}">
            return ${query}(params);
        </c:if>
    },
    <c:if test="${not empty selection}">
        selection: qwb.ui.get('${selection}').value(),
    </c:if>
    checkbox: ${ck},
    criteria: '<input qwb-role="textbox" placeholder="输入关键字" qwb-model="wareNm">',
    columns: [
        {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
        {
        field: 'wareNm', title: '商品名称', width: 120, tooltip: true
        },
        {field: 'wareGg', title: '规格', width: 120},
        {field: 'stkQty', title: '库存数量', width: 120},
        {field: 'wareDw', title: '大单位', width: 120},
        {field: 'minUnit', title: '小单位', width: 120},
        {field: 'productDate', title: '生产日期', width: 120}
    ],
    yes: function (data) {
        if (data) {
            <c:if test="${not empty callback}">
            ${callback}(data);
            </c:if>
        }
    }
});
