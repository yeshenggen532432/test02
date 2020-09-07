<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%@tag pageEncoding="UTF-8" %>
<%@ attribute name="callback" type="java.lang.String" required="false" %>
<%@ attribute name="checkbox" type="java.lang.Boolean" required="false" %>
<%@ attribute name="onCheckbox" type="java.lang.String" required="false" %>
<%@ attribute name="selection" type="java.lang.String" required="false" %>
<%@ attribute name="fullscreen" type="java.lang.Boolean" required="false" %>
<c:set var="_fullscreen" value="${fullscreen == null ? false:fullscreen}"/>
<c:set var="ck" value="${checkbox == null ? true: checkbox}"/>
var _checkbox = ${ck};
<c:if test="${onCheckbox != null and onCheckbox != ''}">
    _checkbox =${onCheckbox}();
</c:if>
var _productResize = function(c, type){
    $(c).find('.qwb-layout-fixed .accordion-wrapper').height($(c).find('.layui-layer-content').height() - 10);
    var $accordion = $(c).find('.qwb-accordion');
    if($accordion.length > 0){
        qwb.ui.get($accordion).resize();
    }
    var $grid = $(c).find('.qwb-grid');
    if($grid.length > 0){
        qwb.ui.get($grid).resize($(c).find('.layui-layer-content'), [50]);
    }
}
var _i = qwb.ui.Modal.open({
    id: 'product-out-selector',
    title: '请选择商品',
    maxmin: true,
    resizable: true,
    move: true,
   <!--<c:if test="${_fullscreen}">
    full: true,
    </c:if>-->
    full: true,
    btns: ['选中并继续', '确定', '取消'],
    area:['860px', '430px'],
    content: qwb.util.template($('#product-out-selector-template').html())({data: {checkbox: _checkbox}}),
    fullscreen: function(c){
        _productResize(c, 1);
        var ti,tj;
        setTimeout(function(){
            layer.close(ti);
            layer.close(tj);
        }, 1500)
        $(c).find('.layui-layer-btn.layui-layer-btn-r').css('text-align', 'center');
    },
    restore: function(c){
        setTimeout(function(){
            _productResize(c, 0);
        }, 200)
        $(c).find('.layui-layer-btn.layui-layer-btn-r').css('text-align', 'right');
    },
    success: function(c){
        $(c).find('.layui-layer-content').css('overflow-y', 'hidden');
        $(c).data('layer_index', _i);
        qwb.ui.init(c);
        var $grid = $(c).find('.qwb-grid');
        var grid = qwb.ui.get($grid);
        <c:if test="${not empty selection}">
            var selection = qwb.ui.get('${selection}').value();
            grid.on('dataBound', function(e){
            if (selection && selection.length > 0) {
                setTimeout(function () {
                    var data = grid.k().dataSource.data();
                    var idField = 'wareId';
                    $(data).each(function (i, row) {
                        $(selection).each(function (j, item) {
                            if (item[idField] == row[idField]) {
                                var ck = $grid.find('tr[data-uid=' + row.uid + '] input.k-checkbox');
                                if (!ck.is(':checked')) {
                                    grid.k().select($grid.find('tr[data-uid=' + row.uid + ']'));
                                }
                                return false
                            }
                        })
                    })
                }, 50);
            }
        });
        </c:if>

        $(c).find('.criteria .search-btn').on('click', function(){
            grid.reload();
        })
        $(c).find('.criteria .search-input').on('keydown', function(e){
            if(e.keyCode === 13){
                grid.reload();
            }
        })
        $(c).find('.criteria .search-input').on('click', function(e){
            $(this).select();
        })
        grid.options.dblclick = function(data){
            if(data){
                <c:if test="${not empty callback}">
                ${callback}([data]);
                qwb.ui.Modal.close(_i);
                </c:if>
            }
        }
        grid.on('dataBound', function(){
            _productResize(c);
        })
        _productResize(c);
    },
    yes: function (c) {
        var grid = qwb.ui.get($(c).find('.qwb-grid'));
        var data = grid.selectedRow();
        if (data) {
            data.sort(function(a, b){
                if(a._sort > b._sort){
                    return 1;
                }else if(a._sort == b._sort){
                    return 0;
                }else{
                    return -1;
                }
            });
            <c:if test="${not empty callback}">
            ${callback}(data);
            grid.clearSelection();
            </c:if>
        }
        return false;
    },
    btn2: function(c){
        var grid = qwb.ui.get($(c).find('.qwb-grid'));
        var data = grid.selectedRow();
        if (data) {
            data.sort(function(a, b){
                if(a._sort > b._sort){
                    return 1;
                }else if(a._sort == b._sort){
                    return 0;
                }else{
                    return -1;
                }
            })
            <c:if test="${not empty callback}">
            ${callback}(data);
            </c:if>
        }
        return true;
    }
});
