<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>快捷菜单设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <%--2右边：表格start--%>
        <div class="layui-col-md12">
            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                            editable:true,
						    responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							pageable: true,
                    		url: '${base}manager/sysQuickMenu/pages',
                    		criteria: '.query',
                    	">
                        <div data-field="sort"
                             uglcw-options="
                             editor: function(container, options){
                             var model = options.model;
                             var input = $('<input name=\'sort\' data-bind=\'value:sort\'>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.Numeric(input);
                             widget.init({
                              value: model.sort,
                              change: function(){
                                changeSort(this.value(),model.id,'sort',model);
                              }
                             })
                             }"
                        >排序
                        </div>
                        <div data-field="menuName">菜单名称</div>
                        <div data-field="op" uglcw-options="template: uglcw.util.template($('#opt-tpl').html())">操作</div>
                    </div>
                </div>
            </div>
            <%--表格：end--%>
        </div>
        <%--2右边：表格end--%>
    </div>
</div>
<script type="text/x-uglcw-template" id="opt-tpl">
    <button class="k-button" onclick="del(#= data.id#)">移除</button>
</script>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:queryAuthority();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:del();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>移除
    </a>
</script>


<script type="text/x-uglcw-template" id="app-tree-tpl">
    <div id="node-#= item.id#">
        <label class="app-menu-label">#= item.applyName#</label>
        #if(item.PId!=0 && item.menuTp == 0){#
        #if(item.applyUrl!=''){#
        |<a href="javascript:;;" style="color: deepskyblue" onclick="javascript:saveQuickMenu(#=item.id#);">选择</a>
        #}#
        #}#
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.ui.loaded();
    })

    function emit() {
        uglcw.io.emit('quick_menu_updated');
    }

    //-----------------------------------------------------------------------------------------
    //删除
    function del(id) {

        if (!id) {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (!selection) {
                returnuglcw.ui.toast("请勾选你要操作的行！")
            }
            id = selection[0].id
        }

        uglcw.ui.confirm("是否要移除选中行?", function () {
            $.ajax({
                url: "${base}manager/sysQuickMenu/delete",
                data: {
                    id: id
                },
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response == "1") {
                        uglcw.ui.success("移除成功");
                        uglcw.ui.get('#grid').reload();
                        emit();
                    } else {
                        uglcw.ui.error("移除失败");
                    }
                }
            });
        })
    }

    function queryAuthority() {
        var memberId = '${usr.idKey}';
        var type = 1;
        var title = '菜单';
        uglcw.ui.Modal.showTreeSelector({
            lazy: false,
            title: '查看' + title,
            flat: {
                parent: 'PId',
                children: 'children'
            },
            data: {
                member_id: memberId,
                menu_type: type
            },
            checkbox: false,
            checkboxes: false,
            expandable: function () {
                return false;
            },
            area: ['520px', '500px'],
            dataTextField: 'applyName',
            btns: [],
            url: '${base}manager/member/quickauthority',
            template: function (node) {
                var item = node.item;
                item.admin = true;
                return uglcw.util.template($('#app-tree-tpl').html())({item: item})
            }
        })
    }

    function saveQuickMenu(menuId) {
        $.ajax({
            url: '${base}manager/sysQuickMenu/save',
            type: 'post',
            dataType: 'json',
            data: {"menuId": menuId},
            success: function (json) {
                if (json.state) {
                    uglcw.ui.success(json.msg);
                    uglcw.ui.get('#grid').reload();
                    emit();
                } else {
                    uglcw.ui.error('操作失败！');
                }
            }
        })
    }

    function changeSort(value, id, field, model) {
        if (value && isNaN(value)) {
            alert("请输入正整数");
            return false;
        }
        $.ajax({
            url: "${base}/manager/sysQuickMenu/updateSort",
            type: "post",
            data: "&id=" + id + "&sort=" + value,
            success: function (data) {
                if (data == 0) {
                    uglcw.ui.success("操作成功");
                    model.set(field, value);
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }


</script>
</body>
</html>
