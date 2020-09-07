<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@tag pageEncoding="UTF-8" %>
<%@attribute name="title" required="false" %>
<%@attribute name="template" required="false" %>
<%@attribute name="callback" %>
    var i = qwb.ui.Modal.open({
        closable: true,
        title: '${empty title ? '请选择收货单位': title}',
        area: '850px',
        scrollbar: false,
        maxmin: false,
        resizable: false,
        content:$('#${empty template ? 'consignee-mutiselector': template}').html(),
        success: function (container) {
            qwb.ui.init(container);
            //搜索事件
            $(container).find('.query').on('keydown', function(e){
                var that = this
                if(e.keyCode == 13){
                    $(that).closest('.criteria').find('.search').click();
                }
            })
            $(container).find('.criteria .search').on('click', function () {
                qwb.ui.get($(this).closest('.k-content').find('.k-grid')).reload();
            });
            //双击选中事件
            $(container).find('.qwb-grid').on('dblclick', 'tbody tr', function () {
                var grid = qwb.ui.get($(this).closest('.qwb-grid')).k();
                var dataItem = grid.dataItem(this);
                var field = $(container).find('[qwb-role=tabs] li.k-state-active').attr('qwb-field');
                var id = $(container).find('[qwb-role=tabs] li.k-state-active').attr('qwb-id');
                var type = $(container).find('[qwb-role=tabs] li.k-state-active').attr('qwb-type');
                //赋值并关闭
                ${callback}(dataItem[id], dataItem[field], type, dataItem);
                qwb.ui.Modal.close(i);
            });
            $(container).find('.layui-layer-content').css("height","");
        },
        yes: function (container) {
            //var grid = qwb.ui.get($(container).find('.k-content.k-state-active .qwb-grid'));
            //var data = grid.k().dataSource.data();
            var row = qwb.ui.get($(container).find('.k-content.k-state-active .qwb-grid')).selectedRow();

            if (row && row.length > 0) {
                var field = $(container).find('[qwb-role=tabs] li.k-state-active').attr('qwb-field');
                var id = $(container).find('[qwb-role=tabs] li.k-state-active').attr('qwb-id');
                var type = $(container).find('[qwb-role=tabs] li.k-state-active').attr('qwb-type');
                //${callback}(row[0][id], row[0][field], type, row[0]);
                row = $.map(row, function(item){
                    return item.toJSON();
                })
                ${callback}(row, type);
            }
        }
    })

