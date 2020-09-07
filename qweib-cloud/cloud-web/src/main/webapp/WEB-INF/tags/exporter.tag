<!--公共导出-->
<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ attribute name="service" type="java.lang.String" required="true" %>
<%@ attribute name="method" type="java.lang.String" required="true" %>
<%@ attribute name="bean" type="java.lang.String" required="true" %>
<%@ attribute name="condition" type="java.lang.String" required="false" %>
<%@ attribute name="description" type="java.lang.String" required="true" %>
<%@ attribute name="beforeExport" type="java.lang.String" required="false" %>
<%@ attribute name="removeField" type="java.lang.String" required="false" %>
<%@ attribute name="extraColumns" type="java.lang.String" required="false" %>
<%@ attribute name="extraColumnsInsertIndex" type="java.lang.String" required="false" %>
<%@ attribute name="excludeColumns" type="java.lang.String" required="false" %>

<script id="_exporter_grid_toolbar_tpl" type="text/x-qwb-template">
    <div class="_exporter_toolbar">
        <select qwb-role="combobox" qwb-model="exportstyle" style="width: 120px;">
            <option value="1">Excel</option>
            <option value="2">文本</option>
        </select>
        <select qwb-role="combobox" qwb-model="exportcontent" style="width: 120px;">
            <option value="2">导出全部</option>
            <option value="1">导出本页</option>
        </select>
        <a role="button" href="javascript:_doExport();"
           style="color: \\#fff;background-color:\\#2196f3;border-color: \\#2196f3; "
           class="k-info k-button k-button-icontext k-grid-add-purchase">
            <span class="k-icon ion-md-download"></span>开始导出
        </a>
    </div>
</script>
<script id="_exporter_template" type="text/x-qwb-template">
    <div class="exporter-container qwb-selector-container">
        <div qwb-role="grid" qwb-options="
        checkbox: true,
        height: 350,
        toolbar: qwb.util.template($('#_exporter_grid_toolbar_tpl').html()),
        dataBound: function(){
            qwb.ui.init($('._exporter_toolbar'));
            //工具栏移至底部
            $('.exporter-container .qwb-grid .k-grid-toolbar').insertAfter($('.exporter-container .qwb-grid .k-grid-content'));
        }
    ">
            <div data-field="title" qwb-options="width: 'auto'">列名称</div>
        </div>
    </div>
</script>
<script>
    //导出按钮事件
    function toExport() {
        qwb.ui.Modal.open({
            title: '导出向导',
            btns: [],
            area: ['365px', '400px'],
            content: $('#_exporter_template').html(),
            success: function (container) {
                qwb.ui.init($(container));
                var columns = qwb.ui.get('#grid').k().options.columns;
                var cols = $.map(columns, function (column) {
                    var removeField = '${removeField}';
                    var bool = true;
                    if(column.title=="#"){
                        bool = false;
                    }
                    if(removeField!=""&&removeField!=undefined){
                        if(removeField.indexOf(column.field)!=-1){
                            bool = false
                        }
                    }
                    if (column.title && bool  && !column.type<c:if test="${not empty excludeColumns}">
                        && '${excludeColumns}'.indexOf(column.field) === -1
                        </c:if>) {

                        return {
                            title: (column.title || "").trim(),
                            field: column.field
                        }
                    }
                });
                <c:if test="${not empty extraColumns}">
                 var pairs = '${extraColumns}'.split(',');
                  <c:choose>
                    <c:when test="${not empty extraColumnsInsertIndex}">
                var extraCols = []
                $(pairs).each(function(i, pair){
                    var items = pair.split(':');
                    extraCols.push({
                        title: items[1],
                        field: items[0]
                    })
                });
                  cols = cols.slice(0, ${extraColumnsInsertIndex}).concat(extraCols, cols.slice(${extraColumnsInsertIndex}));
                    </c:when>
                    <c:otherwise>
                $(pairs).each(function(i, pair){
                    var items = pair.split(':');
                    cols.push({
                        title: items[1],
                        field: items[0]
                    })
                });
                </c:otherwise>
                </c:choose>
                </c:if>
                qwb.ui.get($(container).find('.qwb-grid')).bind(cols);
                qwb.ui.get($(container).find('.qwb-grid')).k().select('tr');
            }
        })
    }

    function _doExport() {
        var grid = qwb.ui.get('.exporter-container .qwb-grid');
        var rows = grid.selectedRow();
        if (!rows || rows.length < 1) {
            return qwb.ui.warning('请选择要导出的列')
        }
        var ds = qwb.ui.get('#grid').k().dataSource;
        var condition = {};
        <c:if test="${not empty condition}">
            condition = qwb.ui.bind('${condition}');
        </c:if>
        <c:if test="${not empty beforeExport}">
            condition = ${beforeExport}(condition);
        </c:if>

        if(condition.edate){
            condition.edate += ' 23:59:59';
        }

        var query = qwb.extend(qwb.ui.bind('._exporter_toolbar'), {
            classname: '${service}',
            method: '${method}',
            condition: encodeURIComponent(JSON.stringify(condition)),
            bean: '${bean}',
            discribe: '${description}',
            pageNumber: ds.page(),
            pageSize: ds.pageSize(),
            total: ds.total(),
            data: encodeURIComponent(JSON.stringify($.map(rows, function (row) {
                return {
                    key: row.field,
                    name: row.title
                }
            })))
        });
        window.location.href = '${base}manager/export?' + $.map(query, function (v, k) {
            return k + '=' + v;
        }).join('&');
        qwb.ui.Modal.close();
        qwb.ui.info('操作完成');
    }
</script>
