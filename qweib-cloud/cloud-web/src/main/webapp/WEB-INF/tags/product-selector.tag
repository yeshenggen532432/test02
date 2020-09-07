<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@tag pageEncoding="UTF-8" %>
<%@ attribute name="callback" type="java.lang.String" required="false" %>
<%@ attribute name="query" type="java.lang.String" required="false" %>
<%@ attribute name="checkbox" type="java.lang.Boolean" required="false" %>
<%@ attribute name="onCheckbox" type="java.lang.String" required="false" %>
<c:set var="ck" value="${checkbox == null ? true: checkbox}"/>
var _checkbox = ${ck};
<c:if test="${onCheckbox != null and onCheckbox != ''}">
    _checkbox =${onCheckbox}();
</c:if>
qwb.ui.Modal.showTreeGridSelector({
    tree: {
        url: '${base}manager/waretypes',
        model: 'waretype',
        id: 'id',
        expandable: function(node){
            return node.id == 0;
        }
    },
    width: 900,
    id: 'wareId',
    pageable: true,
    url: '${base}manager/dialogWarePage',
    query: function (params) {
        <c:if test="${not empty query}">
            return ${query}(params);
        </c:if>
    },
    checkbox: _checkbox,
    criteria: '<input qwb-role="textbox" placeholder="输入关键字" qwb-model="wareNm">',
    columns: [
        {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
        {
        field: 'wareNm', title: '商品名称', width: 120, tooltip: true
        },
        {field: 'wareGg', title: '规格', width: 120},
        {field: 'inPrice', title: '采购价格', width: 120},
        {field: 'stkQty', title: '库存数量', width: 120},
        {field: 'wareDw', title: '大单位', width: 120},
        {field: 'minUnit', title: '小单位', width: 120},
        {field: 'maxUnitCode', title: '大单位代码', width: 120, hidden: true},
        {field: 'minUnitCode', title: '小单位代码', width: 120, hidden: true},
        {field: 'hsNum', title: '换算比例', width: 120, hidden: true},
        {field: 'sunitFront', title: '开单默认选中小单位', width: 240, hidden: true}
    ],
    yes: function (data) {
        if (data) {
            <c:if test="${not empty callback}">
            ${callback}(data);
            </c:if>
        }
    }
});