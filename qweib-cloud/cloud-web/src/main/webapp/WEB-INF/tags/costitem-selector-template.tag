<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@tag pageEncoding="UTF-8" %>
<%@attribute name="id" required="false" %>
<%--表格地址--%>
<%@attribute name="url" required="false" %>
<%--树地址--%>
<%@attribute name="typeUrl" required="false" %>
<%--左侧查询拦截器--%>
<%@ attribute name="typeQuery" type="java.lang.String" required="false" %>
<%--右侧查询拦截器--%>
<%@ attribute name="query" type="java.lang.String" required="false" %>
<c:set var="defaulTypeUrl" value="${base}manager/queryUseCostTypeList"/>
<c:set var="dataTypeUrl" value="${(empty typeUrl) ? defaulTypeUrl : typeUrl }"></c:set>
<c:set var="defaultUrl" value="${base}manager/queryUseCostItemList"/>
<c:set var="dataUrl" value="${(empty url) ? defaultUrl : url }"></c:set>
<style>
    .qwb-search input, select {
        height: 30px;
    }

    .layui-card-header.btn-group {
        padding-left: 0px;
        line-height: inherit;
        height: inherit;
    }

    .dropdown-header {
        border-width: 0 0 1px 0;
        text-transform: uppercase;
    }

    .dropdown-header > span {
        display: inline-block;
        padding: 10px;
    }

    .dropdown-header > span:first-child {
        width: 50px;
    }

    .k-list-container > .k-footer {
        padding: 10px;
    }

    .k-grid .k-command-cell .k-button {
        padding-top: 2px;
        padding-bottom: 2px;
    }

    .k-grid tbody tr {
        cursor: move;
    }

    .k-tabstrip .criteria .k-textbox {
        width: 200px;
    }

    .k-tabstrip .criteria {
        margin-bottom: 5px;
    }
</style>
<script id="${empty id ?'costitem-selector': id}" type="text/x-qwb-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="layui-row layui-col-space5">
                <div class="layui-col-md4">
                    <div class="costitem-type-grid" qwb-role="grid" qwb-options="
                    id: 'id',
                    url: '${dataTypeUrl}',
                    <c:if test="${typeQuery != null}">
                    query: ${typeQuery},
                    </c:if>
                    dataBound:function(){
                        var that = this
                        var data = this.dataSource.data().toJSON();
                        if(data.length > 0){
                            qwb.ui.bind('.costitem-grid-query', { typeId: data[0].id });
                            qwb.ui.get('.costitem-grid').k().setOptions({autoBind: true});
                        }
                        $('.costitem-type-grid').on('click', 'tbody tr', function(){
                           var row = that.dataItem($(this));
                           qwb.ui.bind('.costitem-grid-query', { typeId: row.id });
                            qwb.ui.get('.costitem-grid').reload();
                        });
                    },
                    height: 350
                ">
                        <div data-field="typeName">科目名称</div>
                    </div>
                </div>
                <div class="layui-col-md8">
                    <div class="costitem-grid-query">
                        <input type="hidden" id="costitem-type" qwb-role="textbox" qwb-model="typeId"/>
                    </div>
                    <div class="costitem-grid" qwb-role="grid" qwb-options="
                        url: '${dataUrl}',
                        autoBind: false,
                        <c:if test="${query != null}">
                        query: ${query},
                        </c:if>
                        criteria: '.costitem-grid-query',
                        height: 350
                ">
                        <div data-field="itemName">明细科目名称</div>
                        <div data-field="typeName" style="display: none">类别</div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

