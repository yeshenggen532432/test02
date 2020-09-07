<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
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
    <div class="layui-card">
        <div class="layui-card header">
            <div class="layui-card-body">
                <ul class="uglcw-query form-horizontal">
                    <li>
                        <input uglcw-model="ruleName" uglcw-role="textbox" placeholder="规律班名称">
                    </li>
                    <li>
                        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    checkbox: true,
                         responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}/manager/kqrule/queryKqRulePage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    dblclick: function(row){
                        uglcw.ui.openTab('规律班次设置', '${base}manager/kqrule/toBaseKqRuleEdit?ruleId='+row.id);
                    }
                    ">
                <div data-field="ruleName" uglcw-options="width:200">规律班名称</div>
                <div data-field="ruleUnit"
                     uglcw-options="{width:200,template: uglcw.util.template($('#formatterSt').html())}">周期单位
                </div>
                <div data-field="days" uglcw-options="{width:160}">天数</div>
                <div data-field="count" uglcw-options="{width:200,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.subList);
                         }
                        }">班次信息
                </div>
                <div data-field="remarks" uglcw-options="{width:200}">备注</div>
                <div data-field="status"
                     uglcw-options="{width:200,template: uglcw.util.template($('#formatterSt3').html())}">是否禁用
                </div>

            </div>
        </div>
    </div>
</div>
<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 5px;">序号</td>
            <td style="width: 5px;">班次名称</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].dayName #</td>
            <td>#= data[i].bcName #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>

<script type="text/x-kendo-template" id="formatterSt3">
    # if(data.status == 2){ #
    #if (data.dataTp=='2') {#
    <button class="k-button k-success" onclick="updateStatus(#= data.id#,1)">是</button>
    # }else{#
    <button class="k-button k-success" onclick="updateStatus(#= data.id#,1)">是</button>
    #}#
    # }else{#
    #if(data.dataTp=='1') {#
    <button class="k-button  k-error" onclick="updateStatus(#= data.id#,2)">否</button>

    #}else{#
    <button class="k-button k-error" onclick="updateStatus(#= data.id#,2)">否</button>

    #}#

    # } #

</script>
<script type="text/x-kendo-template" id="formatterSt">
    #if(data.ruleUnit=="0"){#
    天
    #}else if(data.ruleUnit == "1"){#
    周
    #}else if(data.ruleUnit == "2"){#
    月
    #}#

</script>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:update();">
        <span class="k-icon k-i-pencil"></span>修改
    </a>
    <a role="button" href="javascript:del();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-delete"></span>删除</a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().reload();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.io.on('refreshBcRuleList', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.loaded()
    })


    //修改停用
    function updateStatus(id, status) {
        $.ajax({
            url: "manager/kqrule/updateRuleStatus",
            type: "post",
            data: "id=" + id + "&status=" + status,
            success: function (data) {
                if (data.state) {
                    alert("操作成功");
                    uglcw.ui.get('#grid').reload();//刷新页面数据
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function add() {  //添加
        uglcw.ui.openTab('规律班信息', '${base}/manager/kqrule/toBaseKqRuleNew');
    }

    function update(id) { //修改
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            var id = selection[0].id;
            top.layui.index.openTabsPage('${base}/manager/kqrule/toBaseKqRuleEdit?ruleId=' + id, '规律班信息' + id);
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function del() {   //删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            /*   var id = selection[0].id;//获取当前行id*/
            uglcw.ui.confirm('确定删除所选记录吗', function () {
                $.ajax({
                    url: '${base}manager/kqrule/deleteKqRule',
                    data: {
                        ids: $.map(selection, function (row) {  //选中多行数据删除
                            return row.id
                        }).join(',')
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success(response.msg);
                            uglcw.ui.get('#grid').reload();//刷新页面数据
                        } else {
                            uglcw.ui.error(response.msg);//错误提示
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

</script>


<%--
<script>
    var dataTp = '${dataTp}';
    layui.config({
        base: '/static/uglcs/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'table', 'upload'], function () {
        var $ = layui.jquery;
        var table = layui.table, form = layui.form, upload = layui.upload;

        table.render({
            elem: '#member-list',
            loading: true,
            url: '${base}/manager/bc/queryKqBcPage',
            method: 'get',
            height: 'full-100',
            cellMinWidth: 80,
            id: 'member-list',
            toolbar: '#toolbar',
            defaultToolbar: ['filter'],
            page: true,
            limit: 20,
            skin: 'row',
            even: true,
            size: 'sm',
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {type: 'numbers', fixed: 'left'},
                {field: 'bcCode', title: '班次编码', align: 'center', fixed: 'left'},
                {field: 'bcName', title: '班次名称', align: 'center', fixed: 'left'},
                {field: 'count', title: '时间信息', align: 'center', fixed: 'left'},
                {field: 'earlyMinute', title: '上班弹性时间', align: 'center'},
                {field: 'lateMinute', title: '下班弹性时间', align: 'center'},
                {field: 'beforeMinute', title: '最早上班签到时间', align: 'center'},
                {field: 'afterMinute', title: '最晚下班签到时间', align: 'center'},
                {field: 'address', title: '考勤位置', align: 'center'},
                {
                    field: 'outOf',
                    title: '可超出否',
                    width: 90,
                    align: 'center',
                    templet: '<span>{{d.outOf ? "是":"否"}}</span>'
                },

                {field: 'remarks', title: '备注', width: 100, align: 'center'},
                {
                    field: 'status',
                    title: '是否禁用',
                    width: 100,
                    align: 'center',
                    fixed: 'right',
                    templet: '#job-template'
                },

            ]],
            request: {
                pageName: 'page',
                limitName: 'rows'
            },
            parseData: function (response) {
                return {
                    code: 0,
                    count: response.total,
                    data: response.rows
                }
            }

        })

        table.on('toolbar', function (o) {
            var checkStatus = table.checkStatus(o.config.id);
            var event = o.event
            switch (event) {
                case 'add':
                    edit()
                    break;
                case 'update':
                    if (!checkStatus.data || checkStatus.data.length < 1) {
                        layer.msg('请选择要修改的数据');
                        return
                    }
                    edit(checkStatus.data[0].id);
                    break;
                case 'delete':
                    if (!checkStatus.data || checkStatus.data.length < 1) {
                        layer.msg('请选择要修改的数据');
                        return
                    }
                    var i = top.layer.confirm('确定删除所选记录吗？', function () {
                        $.ajax({
                            type: 'post',
                            url: '${base}/manager/bc/deleteKqBc',
                            data: {
                                ids: $.map(checkStatus.data, function (item) {
                                    return item.id
                                }).join(',')
                            },
                            success: function (res) {
                                if (state = true) {
                                    layer.msg('删除成功');
                                    top.layer.close(i);
                                    table.reload('member-list');
                                }
                            }
                        })
                    })
                    break;
                default:
                    break;
            }
            console.log(o);
        });

        table.on('rowDouble', function (e) {
            edit(e.data.id)
        })

        form.on('submit(member-search)', function (data) {
            table.reload('member-list', {
                url: '${base}/manager/bc/queryKqBcPage',
                where: {
                    bcName: data.field.bcName
                }

            });
        });
    });

    function edit(id) {
        var url = '${base}/manager/bc/toBaseBcNew';
        if (id) {
            url = '${base}/manager/bc/toBaseBcEdit?id=' + id;
        }
        var i = layui.layer.open({
            type: 2,
            title: id ? '编辑员工' : '新增员工',
            content: url,
            yes: function (index, layero) {

            },
            success: function (layero, index) {
                setTimeout(function () {
                    layui.layer.tips('点击此处返回用户列表', '.layui-layer-setwin .layui-layer-close', {
                        tips: 3
                    });
                }, 500)
            }
        })
        layui.layer.full(i)
    }
</script>--%>
</body>
</html>
