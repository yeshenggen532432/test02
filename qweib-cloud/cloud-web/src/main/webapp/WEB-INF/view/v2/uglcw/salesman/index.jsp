<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-selector-container .uglcw-tree .k-in {
            padding: 2px 5px 2px 5px;
        }

        ul.app-menu.uglcw-radio.horizontal li {
            margin-top: 2px;
            margin-left: 2px;
        }

        .app-menu-label {
            margin-top: 2px;
        }

        .app-menu.uglcw-radio {
            margin-left: 20px;
            margin-top: 0px;
            font-size: 10px;
            float: right;
        }

        .app-menu.uglcw-checkbox {
            float: right;
            font-size: 10px;
        }

        .app-menu .k-radio-label::before {
            width: 12px;
            height: 12px;
        }

        .app-menu .k-radio-label:before {
            width: 12px;
            height: 12px;
        }

        .app-menu .k-checkbox-label:before {
            font-size: 12px;
            line-height: 12px;
        }

        .app-menu .k-checkbox-label::before {
            width: 13px;
            height: 13px;
        }

        .app-menu .k-checbox-label:before {
            width: 12px;
            height: 12px;
        }

        .app-menu .k-radio-label {
            padding-left: 18px;
            line-height: 15px !important;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="salesmanName" uglcw-role="textbox" placeholder="业务员姓名">
                </li>
                <li style="width: 500px!important;">
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button k-info" uglcw-role="button">重置</button>
                    <button id="modify" class="k-button" uglcw-role="button" onclick="toEdit()">修改</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive: ['.header', 40],
                    id:'id',
                    dblclick: function(row){
                        edit(row);
					},
                    url: '${base}manager/querySalesmanPage',
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="salesmanName" uglcw-options="width: 'auto'">业务员姓名</div>
                <div data-field="tel" uglcw-options="width: 'auto'">联系电话</div>
                <div data-field="memberName" uglcw-options="width: 'auto'">关联员工</div>
                <div data-field="allocAuthority"
                     uglcw-options="width: 'auto',template: uglcw.util.template($('#allocAuthority').html())">
                    分配权限
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="disable-template">
    # if(data.status =='2'){ #
    <button class="k-button k-error" onclick="disable(#= data.id#, 1)"><i class="k-icon k-i-cancel"></i>已禁用</button>
    # }else { #
    <button class="k-button k-success" onclick="disable(#= data.id#, 2)"><i class="k-icon k-i-success"></i>正常</button>
    # } #
</script>

<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <label class="control-label col-xs-8">业务员姓名</label>
                    <div class="col-xs-16">
                        <input readonly uglcw-model="salesmanName" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">关联员工</label>
                    <div class="col-xs-16">
                        <tag:select2 allowInput="true" name="memberId" id="memberId" tableName="sys_mem" headerKey="-1"
                                     headerValue="--请选择--" whereBlock="member_use=1"
                                     displayKey="member_id" displayValue="member_nm"/>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<script id="allocAuthority" type="text/x-uglcw-template">
    # if(data.memberId > 0){ #
    <button onclick="allocateApp(#= data.memberId#,'#= data.memberName#', 1, '分配菜单');" class="k-button k-info">
        <i class="k-icon  k-i-gear"></i> 分配菜单
    </button>
    <button onclick="allocateApp(#= data.memberId#,'#=data.memberName#', 2, '分配应用');" class="k-button k-info">分配应用
        <i class="k-icon ion-logo-buffer"></i>
    </button>
    <button onclick="removeSalesman(#= data.id#);" class="k-button k-info">移除
    </button>
    #}#
</script>
<script type="text/x-uglcw-template" id="app-tree-tpl">
    <div id="node-#= item.id#">
        <%--周边客户--%>
        #if(item.applyCode == 'khgl_show_around_customer'){#
        <%--&lt;%&ndash;<input id="_#= item.uid#" tabindex="-1" type="checkbox" uglcw-role="checkbox" uglcw-options="type:'number'" class="k-checkbox" #=item.selected ? 'checked':''# >&ndash;%&gt;--%>
        <input id="_#= item.uid#" tabindex="-1" type="checkbox" uglcw-role="checkbox" uglcw-options="type:'number'" class="k-checkbox" #=item.ifChecked == '0'? '': 'checked'#>
        <label for="_#= item.uid#" class="k-checkbox-label checkbox-span">#= item.applyName#</label>
        #}else{#
        <label class="app-menu-label">#= item.applyName#</label>
        #}#
        <%--<label class="app-menu-label">#= item.applyName#</label>--%>
        #if(item.pid!=0 && item.menuTp == 1 && item.specific_tag && item.specific_tag.length > 0){#
        <ul class="app-menu uglcw-radio horizontal">
            <li><input #=item.menuLeaf == '1'? 'checked': '' # type="radio" value="1" id="radio_app_all_#= item.id#"
                class="k-radio" name="radio_app_#= item.id#"><label
                        for="radio_app_all_#= item.id#" class="k-radio-label">全部</label></li>
            <li><input #=item.menuLeaf == '2'? 'checked': '' # type="radio" value="2" id="radio_app_dept_#= item.id#"
                class="k-radio" name="radio_app_#= item.id#"><label
                        for="radio_app_dept_#= item.id#" class="k-radio-label">部门及子部门</label></li>
            <li><input #=item.menuLeaf == '3'? 'checked': '' # type="radio" value="3" id="radio_app_personal_#=
                item.id#"
                class="k-radio" name="radio_app_#= item.id#"><label
                        for="radio_app_personal_#= item.id#" class="k-radio-label">个人</label></li>
        </ul>

        #}#
    </div>
</script>

<%--<script id="checkbox-tpl" type="text/x-uglcw-template">--%>
    <%--<input id="_#= item.uid#" tabindex="-1" type="checkbox" uglcw-role="checkbox" uglcw-options="type:'number'" class="k-checkbox" #=item.checked ? 'checked':''# >--%>
    <%--<label for="_#= item.uid#" class="k-checkbox-label checkbox-span"></label>--%>
<%--</script>--%>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        });
        uglcw.ui.loaded();
    });

    function toEdit() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的数据');
        }
    }

    function edit(row) {
        uglcw.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                if (row) {
                    uglcw.ui.bind($(container), row);
                }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/saveSalesman',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.code == 200) {
                            uglcw.ui.success(response.message);
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error(response.message);
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                    }
                })
            }
        })
    }

    function allocateApp(memberId, memberName, type, title) {
        if (!memberId || memberId <= 0) {
            uglcw.ui.error('请先关联员工');
            return;
        }
        uglcw.ui.loading();
        uglcw.ui.Modal.showTreeSelector({
            lazy: false,
            title: title + ':' + memberName || '',
            flat: {
                parent: 'pid',
                children: 'children'
            },
            data: {
                memberId: memberId,
                type: type
            },
            expandable: function () {
                return true;
            },
            checkboxes: false,
            // checkboxes: {
            //     checkChildren: true,
            //     template: uglcw.util.template($('#checkbox-tpl').html())
            // },
            area: ['500px', '500px'],
            dataTextField: 'applyName',
            loadFilter: function (response) {
                return response.data || [];
            },
            okText: '保存',
            url: '${base}manager/salesman/menus',
            template: function (node) {
                var item = node.item;
                return uglcw.util.template($('#app-tree-tpl').html())({item: item})
            },
            success: function (container) {
                var tree = uglcw.ui.get($(container).find('.uglcw-tree'));
                $(container).on('change', '.uglcw-radio [type=radio]', function () {
                    var node = tree.k().dataItem($(this).closest('.k-item'));
                    var checkedValue = $(this).val();
                    console.log(node, $(this).val());
                    node.menuLeaf = checkedValue;
                })
                $(container).on('change', 'input[uglcw-role=checkbox]', function(){
                    var node = tree.k().dataItem($(this).closest('.k-item'));
                    var checkedValue = $(this).is(':checked');
                    node.ifChecked = checkedValue;
                })
                uglcw.ui.loaded();
            },
            yes: function (checked, nodes, flat) {
                var data = {
                    type: type,
                    memberId: memberId,
                    menus: []
                };

                var visit = function (nodes, result) {
                    $(nodes).each(function (i, node) {
                        if (node.menuLeaf) {
                            result.push(node)
                        }
                        if (node.items && node.items.length > 0) {
                            visit(node.items, result)
                        }
                    })
                }

                var result = [];
                visit(nodes, result);

                //菜单选项
                $(result).each(function (idx, item) {
                    var menuData = {ifChecked:item.ifChecked, menuId: item.id, authorityType: item.menuLeaf, authorityId: item.authorityId};
                    data.menus.push(menuData);
                });
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/salesman/menus',
                    type: 'post',
                    contentType: 'application/json',
                    data: JSON.stringify(data),
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.code == 200) {
                            uglcw.ui.success(response.message);
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('操作失败');
                    }
                })
            }
        })
    }

    function removeSalesman(id) {
        uglcw.ui.confirm('是否要移除该员工吗?', function () {
            $.ajax({
                url: '${base}manager/saveSalesman',
                type: 'post',
                data: {id: id},
                async: false,
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.code == 200) {
                        uglcw.ui.success(response.message);
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message);
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        });
    }
</script>
</body>
</html>
