<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@tag pageEncoding="UTF-8" %>
<%@attribute name="title" required="false" %>
<%@attribute name="template" required="false" %>
<%@attribute name="callback" %>
    qwb.ui.Modal.open({
        closable: true,
        title: '${empty title ? '请选择费用科目': title}',
        area: '850px',
        moveOut: true,
        btns: [],
        scrollbar: false,
        content: $('#${empty template ? 'costitem-selector': template}').html(),
        success: function (container) {
            qwb.ui.init(container);
            //双击选中事件
            $(container).find('.costitem-grid').on('dblclick', 'tbody tr', function () {
                var grid = qwb.ui.get($(this).closest('.qwb-grid')).k();
                var dataItem = grid.dataItem(this);
                //赋值并关闭
                ${callback}(dataItem);
                qwb.ui.Modal.close();
            });

        },
        yes: function (container) {
            var row = qwb.ui.get($(container).find('.costitem-grid')).selectedRow();
            if (row && row.length > 0) {
                ${callback}(row);
            }
        }
    })

