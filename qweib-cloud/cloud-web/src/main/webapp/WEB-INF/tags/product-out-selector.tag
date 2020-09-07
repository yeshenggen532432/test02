<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%@tag pageEncoding="UTF-8" %>
<%@ attribute name="callback" type="java.lang.String" required="false" %>
<%@ attribute name="query" type="java.lang.String" required="false" %>
<%@ attribute name="selection" type="java.lang.String" required="false" %>
<%@ attribute name="checkbox" type="java.lang.Boolean" required="false" %>
<c:set var="ck" value="${checkbox == null ? true: checkbox}"/>
qwb.ui.Modal.showTreeGridSelector({
    title: false,
    tree: {
        url: '${base}manager/waretypes',
        model: 'waretype',
        id: 'id',
        expandable: function(node){
            return node.id == 0;
        }
    },
    area:['860px', '350px'],
    id: 'wareId',
    pageable: true,
    persistSelection: true,
    url: '${base}manager/dialogOutWarePage',
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
        {field: 'wareNm', title: '商品名称', width: 120, tooltip: true},
        {field: 'wareGg', title: '规格', width: 120},
        {field: 'stkQty', title: '实际数量', width: 80},
        {field: 'occQty', title: '占用数量', hidden: true, width: 80},
        {field: '_xnQty', title: '虚拟库存', hidden: true, width: 80},
        {field: 'wareDj', title: '销售价', width: 80},
        {field: 'wareDw', title: '大单位', width: 80},
        {field: 'minUnit', title: '小单位', width: 80},
        <c:if test="${fns:checkFieldDisplay('sys_config',''*'','code=\"CONFIG_SALE_SHOW_INPRICE\"  and status=1') ne 'none'}">
        {field: 'inPrice', title: '成本价', width: 80},
        </c:if>
    ],
    yes: function (data) {
        if (data) {
            <c:if test="${not empty callback}">
            ${callback}(data);
            </c:if>
        }
    }
});