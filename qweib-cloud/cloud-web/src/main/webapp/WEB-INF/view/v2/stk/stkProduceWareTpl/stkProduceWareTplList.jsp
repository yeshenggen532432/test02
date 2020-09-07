<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>生产材料标准配置表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                    responsive:[40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    url: '${base}manager/stkProduceWareTpl/list'
                    ">
                        <div data-field="relaWareNm" uglcw-options="width: 200">生产产品</div>
                        <div data-field="option" uglcw-options="template: uglcw.util.template($('#op-tpl').html())">操作</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-add"></span>新增配置
    </a>
    <a role="button" href="javascript:edit(0);" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>调整所有原料配置
    </a>
    <a role="button" href="javascript:showAll();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>配置总列表信息
    </a>
    <a role="button" href="javascript:quick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-cart"></span>快速领料
    </a>
    <a role="button" href="javascript:refresh();" class="k-button k-button-icontext">
        <span class="k-icon k-i-refresh"></span>刷新
    </a>
</script>
<script type="text/x-uglcw-template" id="op-tpl">
    <button class="k-button k-success" onclick="showWareItems(#=data.relaWareId#,'#= data.relaWareNm#')"><i
            class="k-icon k-i-eye"></i>查看配置信息
    </button>
    <button class="k-button k-info" onclick="edit(#=data.relaWareId#,'#= data.relaWareNm#')"><i
            class="k-icon k-i-edit"></i>修改配置信息
    </button>
    <button class="k-button k-info" onclick="selectMember(#=data.relaWareId#)"><i class="k-icon k-i-add"></i>添加阅读人员
    </button>
    #if(data.readersIds){#
    <button class="k-button k-success"
            onclick="showMember(#=data.relaWareId#,'#= data.readersIds#', '#= data.readersNms#')"><i
            class="k-icon k-i-eye"></i>查看可阅读人员
    </button>
    #}#
</script>
<script type="text/x-uglcw-template" id="member-tpl">
    <div id="member-grid" uglcw-role="grid" uglcw-options="height: 350, showHeader: false, align:'center'">
        <div data-field="name" uglcw-options="tooltip: false">姓名</div>
        <div data-field="options"
             uglcw-options="template: '<button onclick=\'removeMember(this, \#=data.id\#,\#=data.memberId\#)\' class=\'k-button k-error\'><i class=\'k-icon k-i-remove\'></i>移除</button>'">
            操作
        </div>
    </div>
</script>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    })



    function refresh() {
        uglcw.ui.get('#grid').reload();
    }

    function add() {
        uglcw.ui.openTab("新增配置信息", "${base}manager/stkProduceWareTpl/add")
    }

    function edit(id, name) {
        if (id == 0) {
            uglcw.ui.openTab('调整所有原料配置', '${base}manager/stkProduceWareTpl/edit');
        } else {
            uglcw.ui.openTab(name + '_编辑配置信息', '${base}manager/stkProduceWareTpl/edit?relaWareId=' + id);
        }
    }
    function showAll() {
        uglcw.ui.openTab('总配置列表信息','${base}manager/stkProduceWareTpl/toListItems');

    }
    function quick() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        var ids = '';
        if (selection) {
            ids = $.map(selection, function (row) {
                return row.relaWareId;
            }).join(',');
        }
        uglcw.ui.openTab('快速领料', '${base}manager/stkProduceWareTpl/mainWareList?relaWareIds=' + ids);
    }

    function showWareItems(id, name) {
        uglcw.ui.openTab(name + "_配置信息", "${base}manager/stkProduceWareTpl/toListItems?relaWareId=" + id);
    }

    function showMember(id, ids, names) {
        ids = ids.split(',');
        names = names.split(',');
        var rows = []
        for (var i = 0; i < ids.length; i++) {
            rows.push({id: id, memberId: ids[i], name: names[i]})
        }

        uglcw.ui.Modal.open({
            title: '可阅读人员',
            content: $('#member-tpl').html(),
            success: function (c) {
                uglcw.ui.init($(c));
                uglcw.ui.get($(c).find('.k-grid')).bind(rows);
            },
            yes: function () {
            }
        })
    }

    function removeMember(e, id, memberId, name) {
        var btn = e;
        uglcw.ui.confirm('确定移除吗？', function () {
            $.ajax({
                url: '${base}manager/stkProduceWareTpl/deleteReaders',
                type: 'post',
                data: {relaWareId: id, readersIds: memberId, readersNms: name},
                dataType: 'json',
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.toast('移除成功');
                        uglcw.ui.get('#member-grid').k().removeRow($(btn).closest('tr'));
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.toast(response.msg || '移除失败');
                    }
                },
            })
        })
    }

    var tempId = null;

    function selectMember(id) {
        tempId = id;
        <tag:employee-selector callback="onMemberSelect"/>
    }

    function onMemberSelect(selection) {
        if (selection && selection.length > 0) {
            $.ajax({
                url: '${base}manager/stkProduceWareTpl/updateReader',
                type: 'post',
                data: {
                    relaWareId: tempId,
                    readersIds: $.map(selection, function (item) {
                        return item.memberId
                    }).join(','),
                    readersNms: $.map(selection, function (item) {
                        return item.memberNm
                    }).join(',')
                },
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.success('添加成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.msg || '添加失败');
                    }
                }
            })
        }
    }

</script>
</body>
</html>
