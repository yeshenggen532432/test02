<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>公司角色管理</title>
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
                    <input uglcw-model="roleNm" uglcw-role="textbox" placeholder="角色名称">
                </li>
                <li>
                    <select uglcw-model="status" uglcw-role="combobox" placeholder="客户状态">
                        <option value="1" selected>在用</option>
                        <option value="2">停用</option>
                    </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                            responsive:['.header',40],
                            align: 'center',
						    toolbar: uglcw.util.template($('#toolbar').html()),
							id:'id',
							pageable: true,
                    		url: '${base}manager/rolepages_company',
                    		criteria: '.query',
                    	">
                <div data-field="roleNm" uglcw-options="width:100,template:uglcw.util.template($('#role-name-tpl').html())">角色名称</div>
                <div data-field="oper" uglcw-options="width:100,template: uglcw.util.template($('#oper').html())">
                    分配权限
                </div>
                <div data-field="areaName"
                     uglcw-options="width:100, template: uglcw.util.template($('#areaName').html())">分配用户
                </div>
                <div data-field="status"
                     uglcw-options="width:120, template: uglcw.util.template($('#disable-template').html())">角色状态
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="role-name-tpl">
    # if(data.roleCd == "company_creator" || data.roleCd == "company_admin" || data.roleCd == "ptyg" || data.roleCd == "xzzy" || data.roleCd == "business_people"){ #
        #= data.roleNm#(系统角色)
    #} else {#
        #= data.roleNm#
    #}#
</script>
<script type="text/x-uglcw-template" id="disable-template">
    # if(data.status =='2'){ #
    <button class="k-button k-error" onclick="disable(#= data.idKey#, 1)"><i class="k-icon k-i-cancel"></i>停用</button>
    # }else { #
    <button class="k-button k-success" onclick="disable(#= data.idKey#, 2)"><i class="k-icon k-i-success"></i>在用</button>
    # } #
</script>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:update();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>修改
    </a>
    <a role="button" href="javascript:del();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>删除
    </a>
    &nbsp;&nbsp;&nbsp;&nbsp;<c:if test="${not empty allocPortCount}"><span style="color: red;">目前申请端口数：${allocPortCount}，已使用：${usedPortCount}。提示：普通员工不占用端口数</span></c:if>
</script>
<%--启用操作--%>
<script id="oper" type="text/x-uglcw-template">
    # if(data.roleCd == "company_creator" || data.roleCd == "company_admin" || data.roleCd == "ptyg" || data.roleCd == "xzzy" || data.roleCd == "business_people"){ #
    <button onclick="allocateMenu(#= data.idKey#,'#= data.roleNm#','#= data.roleCd#');" class="k-button k-info">
        <i class="k-icon  k-i-gear"></i> 分配菜单
    </button>
    <button onclick="allocateApp(#= data.idKey#,'#=data.roleNm#','#= data.roleCd#');" class="k-button k-info">分配应用
        <i class="k-icon ion-logo-buffer"></i>
    </button>
    # }else{ #
    <button onclick="allocateMenu(#= data.idKey#,'#= data.roleNm#');" class="k-button k-info">
        <i class="k-icon  k-i-gear"></i> 分配菜单
    </button>
    <button onclick="allocateApp(#= data.idKey#,'#=data.roleNm#');" class="k-button k-info">分配应用
        <i class="k-icon ion-logo-buffer"></i>
    </button>
    # } #
</script>
<script id="areaName" type="text/x-uglcw-template">
    # if(data.roleCd == "company_creator"){ #
    <span>创建者：${companyCreator.name}</span>
    # }else if (data.roleCd == "company_admin"){ #
    <button onclick="toRoleManager(#= data.idKey#);" class="k-button k-error">
        <i class="k-icon ion-md-remove-circle-outline"></i>移除管理员
    </button>
    <button onclick="toRoleTransferManager(#= data.idKey#);" class="k-button k-info">
        <i class="k-icon ion-md-swap"></i>转移管理员
    </button>
    # }else{ #
    <button onclick="toroleusr(#= data.idKey#);" class="k-button k-info"><i
            class="k-icon ion-md-contact"></i>分配用户
    </button>
    # } #
</script>

<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="idKey" type="hidden">
                    <label class="control-label col-xs-6">角色名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="roleNm" uglcw-role="textbox" uglcw-validate="required"
                               placeholder="请输入角色名称">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">角色描述</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="remo" uglcw-role="textbox">
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="app-tree-tpl">

    <div id="node-#= item.id#">
        <label class="app-menu-label">#= item.applyName#</label>
        <%--如果应用类型为原生且菜单为按钮类型 则才显示数据权限 即全部\部门及子部门\个人\自定义--%>
        #if(item.PId!=0 && item.menuTp == 1 && item.tp == 2&&item.applyIfwap==0){#
        <ul class="app-menu uglcw-radio horizontal">
            <li><input #=item.menuLeaf == '1'? 'checked': '' # type="radio" value="1" id="radio_app_all_#= item.id#"
                #if(item.admin || (item.specificTag && item.specificTag.length > 0)){#
                disabled
                #}#
                class="k-radio" name="radio_app_#= item.id#"><label
                        for="radio_app_all_#= item.id#" class="k-radio-label">全部</label></li>
            <li><input #=item.menuLeaf == '2'? 'checked': '' # type="radio" value="2" id="radio_app_dept_#= item.id#"
                #if(item.admin || (item.specificTag && item.specificTag.length > 0)){#
                disabled
                #}#
                class="k-radio" name="radio_app_#= item.id#"><label
                        for="radio_app_dept_#= item.id#" class="k-radio-label">部门及子部门</label></li>
            <li><input #=item.menuLeaf == '3'? 'checked': '' # type="radio" value="3" id="radio_app_personal_#=
                item.id#" class="k-radio"
                #if(item.admin || (item.specificTag && item.specificTag.length > 0)){#
                disabled
                #}#
                name="radio_app_#= item.id#"><label for="radio_app_personal_#= item.id#"
                                                    class="k-radio-label">个人</label></li>
            <li><input #=item.menuLeaf == '4'? 'checked': '' # type="radio" value="4" id="radio_app_custom_#= item.id#"
                class="k-radio"
                #if(item.admin || (item.specificTag && item.specificTag.length > 0)){#
                disabled
                #}#
                name="radio_app_#= item.id#"><label for="radio_app_custom_#= item.id#"
                                                    class="k-radio-label uglcw-app-custom">自定义</label></li>
        </ul>
        #if(item.applyName =='报表统计'){#
        <br>
        <div class="app-menu uglcw-checkbox">
            <input type="checkbox"
                   name="sgtjz"
                   class="k-checkbox"
                   id="checkbox_app_1_#= item.id#"
                   #if(item.admin || (item.specificTag && item.specificTag.length > 0)){#
                   disabled
                   #}#
                   #if(item.sgtjz.indexOf('1')!=-1){#
            checked
            #}#
            value="1"><label for="checkbox_app_1_#= item.id#" class="k-checkbox-label">业务执行</label>
            <input type="checkbox" name="sgtjz" class="k-checkbox" id="checkbox_app_2_#= item.id#"
                   #if(item.admin || (item.specificTag && item.specificTag.length > 0)){#
                   disabled
                   #}#
                   #if(item.sgtjz.indexOf('1')!=-1){#
            checked
            #}#
            value="2"><label for="checkbox_app_2_#= item.id#" class="k-checkbox-label">客户拜访</label>
            <input
                    #if(item.admin || (item.specificTag && item.specificTag.length > 0)){#
                    disabled
                    #}#
                    #if(item.sgtjz.indexOf('1')!=-1){#
            checked
            #}#
            type="checkbox" class="k-checkbox" id="checkbox_app_3_#= item.id#" value="3"><label
                for="checkbox_app_3_#= item.id#" class="k-checkbox-label">产品订单</label>
            <input name="sgtjz"
                   #if(item.admin || (item.specificTag && item.specificTag.length > 0)){#
                   disabled
                   #}#
                   #if(item.sgtjz.indexOf('1')!=-1){#
            checked
            #}#
            type="checkbox" class="k-checkbox" id="checkbox_app_4_#= item.id#" value="4"><label
                for="checkbox_app_4_#= item.id#" class="k-checkbox-label">销售订单</label>
        </div>
        # } #
        #}#
    </div>

</script>
<script id="checkbox-tpl" type="text/x-uglcw-template">
    #if(!item.specificTag || item.specificTag.length == 0){#
    <input #= !!item.admin ? 'disabled': ''# id="_#= item.uid#" tabindex="-1" type="checkbox" class="k-checkbox"
    #=item.checked ? 'checked':''# >
    <label for="_#= item.uid#" class="k-checkbox-label checkbox-span"></label>
    # } #
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })

    //-----------------------------------------------------------------------------------------
    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var roleCd = selection[0].roleCd;
            if (roleCd == 'company_creator' || roleCd == 'company_admin' || roleCd == 'ptyg' || roleCd == 'xzzy' || roleCd == 'business_people') {
                uglcw.ui.toast('系统角色不可删除');
                return;
            }
            uglcw.ui.confirm("确定删除所选记录吗？", function () {
                $.ajax({
                    url: "${base}manager/delrole_company",
                    data: {
                        id: selection[0].idKey,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.code == 200) {
                            uglcw.ui.success("删除成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error(response.message);
                        }
                    }
                });
            })
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //添加
    function add() {
        edit()
    }

    //修改
    function update() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            if (selection[0].name == '热销商品' || selection[0].name == '常售商品') {
                uglcw.ui.toast("热销商品、常售商品为系统默认，不允许操作!")
                return;
            }
            edit(selection[0]);
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //添加或修改
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
                    url: '${base}manager/operCompanyrole_company',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '2') {
                            uglcw.ui.success('修改成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        }else if (resp ==='3'){
                            uglcw.ui.error("系统角色不可修改！");
                            uglcw.ui.Modal.close();
                        } else {
                            uglcw.ui.error('操作失败');
                            uglcw.ui.Modal.close();
                        }
                    }
                })
                return false;
            }
        })
    }


    //------------------------------------------------------------------------------------------------------------
    //移除管理员
    function toRoleManager(idKey) {
        $.ajax({
            url: "${base}manager/member/has_admin",
            type: 'get',
            dataType: 'json',
            success: function (response) {
                if (response.code == 200) {

                    uglcw.ui.Modal.showTreeSelector({
                        area: ['350px', '400px'],
                        checkbox: true,
                        title: '请选择要移除的管理员',
                        url: '${base}/manager/usrtree_company',
                        okText: '移除',
                        data: {
                            id: idKey
                        },
                        dataTextField: 'usrnm',
                        loadFilter: function (response) {
                            return $.map(response || [], function (user) {
                                if (user.isuse) {
                                    return user;
                                }
                            })
                        },
                        yes: function (checked) {
                            if (!checked || checked.length < 1) {
                                uglcw.ui.warning('请选择要移除的管理员');
                                return false;
                            }
                            uglcw.ui.confirm("确定移除管理员吗？", function () {
                                $.ajax({
                                    url: '${base}manager/company/role/admin/delete',
                                    type: 'POST',
                                    data: {
                                        roleid_manager: idKey,
                                        opertype_manager: 'usr',
                                        usrid: $.map(checked, function (usr) {
                                            return usr.usrid;
                                        }).join(',')
                                    },
                                    success: function (response) {
                                        if (response.state) {
                                            uglcw.ui.success(response.message)
                                        } else {
                                            uglcw.ui.error(response.message);
                                        }
                                    }
                                })
                            });
                        }
                    })
                } else {
                    uglcw.ui.warning(response.message);
                }
            }
        });
    }

    //转移管理员
    function toRoleTransferManager(idKey) {
        $.ajax({
            url: "${base}manager/member/has_admin",
            type: 'get',
            dataType: 'json',
            success: function (response) {
                if (response.code == 200) {
                    uglcw.ui.confirm("确定转移管理员吗？", function () {
                        uglcw.ui.Modal.showTreeSelector({
                            area: ['350px', '400px'],
                            title: '请选择要转移的管理员',
                            url: '${base}/manager/usrtree_company',
                            okText: '转移',
                            selection: 'single',
                            data: {
                                id: idKey
                            },
                            dataTextField: 'usrnm',
                            loadFilter: function (response) {
                                return $.map(response || [], function (user) {
                                    if (!!!user.isuse) {
                                        return user;
                                    }
                                })
                            },
                            yes: function (checked) {
                                if (!checked || checked.length < 1) {
                                    uglcw.ui.warning('请选择要转移的管理员');
                                    return false;
                                }
                                $.ajax({
                                    url: '${base}manager/company/role/admin/assign',
                                    type: 'POST',
                                    data: {
                                        roleid_transfer_manager: 2,
                                        opertype_transfer_manager: 'usr',
                                        usrid: $.map(checked, function (usr) {
                                            return usr.usrid;
                                        }).join(',')
                                    },
                                    success: function (response) {
                                        if (response.state) {
                                            uglcw.ui.success(response.message)
                                        } else {
                                            uglcw.ui.error(response.message);
                                        }

                                    }
                                })
                            }
                        })
                    })
                } else {
                    uglcw.ui.warning(response.message);
                }
            }
        });
    }

    var limitSelected = -1;

    //分配用户
    function toroleusr(idKey) {
        uglcw.ui.Modal.showTreeSelector({
            area: ['300px', '400px'],
            url: '${base}manager/usrtree_company_new?id=' + idKey,
            loadFilter: function(response) {
                limitSelected = response.limitSelected;
                return response.nodes || [];
            },
            check: function(e) {
                if (limitSelected >= 0) {
                    if (uglcw.ui.get(this.element).selectedNodes().length > limitSelected) {
                        uglcw.ui.warning('该角色可选人数不能超过 ' + limitSelected + ' 个');
                        this.dataItem(e.node).set('checked', false);
                    }
                }
            },
            yes: function (nodes) {
                var ids = $.map(nodes, function (item) {
                    return item.id;
                })
                saverolepri(idKey, ids);
            }
        })
    }

    //保存角色分配功能
    function saverolepri(roleid, ids) {
        $.ajax({
            url: "${base}manager/saveCompanyroleusr",
            data: {
                roleid: roleid,
                usrid: ids.join(',')
            },
            type: 'post',
            dataType: 'json',
            success: function (response) {
                uglcw.ui.toast(response.message)
                if (response.code == 200) {
                    setTimeout(uglcw.ui.reload, 1000);
                }
            }
        });
    }

    function allocateApp(roleId, roleName, admin) {
        uglcw.ui.loading();
        uglcw.ui.Modal.showTreeSelector({
            lazy: false,
            title: '分配应用:' + roleName || '',
            flat: {
                parent: 'PId',
                children: 'children'
            },
            data: {
                roleId: roleId,
                tp: 2
            },
            checkboxes: {
                checkChildren: true,
                template: uglcw.util.template($('#checkbox-tpl').html())
            },
            checkable: function (node) {
                return node.applyNo > 0;
            },
            expandable: function () {
                return false;
            },
            area: ['500px', '500px'],
            dataTextField: 'applyName',
            okText: '保存并通知移动端用户',
            btns: admin ? [] : undefined,
            url: '${base}manager/companyRoletree',
            template: function (node) {
                var item = node.item;
                item.admin = admin;
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
                //自定义事件
                $(container).on('click', '.uglcw-radio .uglcw-app-custom', function () {
                    var node = tree.k().dataItem($(this).closest('.k-item'));
                    showCustomPermissionDialog(roleId, node.id, node.applyName, node.mids, node);
                })
                //统计报表checkbox事件
                $(container).on('change', '.uglcw-checkbox [type=checkbox]', function () {
                    var node = tree.k().dataItem($(this).closest('.k-item'));
                    var sgtjz = [];
                    $(this).closest('.uglcw-checkbox').find('[type=checkbox]').each(function () {
                        if ($(this).is(':checked')) {
                            sgtjz.push($(this).val());
                        }
                    })
                    node.sgtjz = sgtjz.join(',');
                })
                uglcw.ui.loaded();
            },
            yes: function (checked, nodes, flat) {
                var data = {
                    menuapplytype: 2,
                    companyroleId: roleId
                };
                //菜单选项
                $(checked).each(function (idx, item) {
                    data['roleMenu[' + idx + '].ifChecked'] = true;
                    data['roleMenu[' + idx + '].menuId'] = item.id;
                    data['roleMenu[' + idx + '].tp'] = item.tp;
                    data['roleMenu[' + idx + '].bindId'] = item.menuId;
                    data['roleMenu[' + idx + '].mids'] = item.mids;
                    data['roleMenu[' + idx + '].dataTp'] = item.menuLeaf;
                    data['roleMenu[' + idx + '].sgtjz'] = item.sgtjz;
                });
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/saveRoleMenuApply',
                    type: 'post',
                    data: data,
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response == '2') {
                            uglcw.ui.success('操作成功');
                        }else{
                            uglcw.ui.error('操作失败');
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

    function showCustomPermissionDialog(roleId, menuId, appName, mids, node) {
        uglcw.ui.Modal.showTreeSelector({
            lazy: false,
            title: '分配[' + appName + ']用户名单',
            area: ['350px', '400px'],
            url: '${base}/manager/usrtree_company2',
            data: {
                roleid: roleId,
                cdid: menuId,
                mids: mids
            },
            flat: {
                pid: 'pid',
                id: 'usrid'
            },
            dataTextField: 'usrnm',
            expandable: function () {
                return true;
            },
            checkboxes: {
                checkChildren: true
            },
            checkable: function (node) {
                return node.isuse > 0;
            },
            success: function (container) {
            },
            yes: function (checked, nodes, flat) {
                var data = {
                    roleid2: roleId,
                    cdid: menuId,
                    usrid2: $.map(checked, function (n) {
                        if (n.pid != 0)
                            return n.usrid
                    }).join(',')
                };
                $.ajax({
                    url: '${base}/manager/updateUsrByjc',
                    type: 'post',
                    data: data,
                    success: function (response) {
                        console.log(response);
                        node.mids = data.usrid2;
                    }
                })

            }
        })
    }

    function allocateMenu(roleId, roleName, admin) {
        uglcw.ui.loading();
        uglcw.ui.Modal.showTreeSelector({
            lazy: false,
            title: '[' + roleName + ']分配菜单',
            area: ['500px', '500px'],
            dataTextField: 'applyName',
            checkboxes: {
                checkChildren: true,
                template: function(e){
                    var item = e.item;
                    item.admin = admin;
                    return uglcw.util.template($('#checkbox-tpl').html())({item: item})
                }
            },
            btns: admin ? [] : undefined,
            data: {
                roleId: roleId,
                tp: 1
            },
            url: '${base}manager/companyRoletree',
            flat: {
                parent: 'PId',
                children: 'children'
            },
            expandable: function () {
                return true
            },
            checkable: function (node) {
                return node.applyNo > 0;
            },
            template: function (node) {
                var item = node.item;
                item.admin = admin;
                return uglcw.util.template($('#app-tree-tpl').html())({item: item})
            },
            success: function (container) {
                var tree = uglcw.ui.get($(container).find('.uglcw-tree'));
                tree.collapse();
                $(container).on('change', '.uglcw-radio [type=radio]', function () {
                    var node = tree.k().dataItem($(this).closest('.k-item'));
                    var checkedValue = $(this).val();
                    console.log(node, $(this).val());
                    node.menuLeaf = checkedValue;
                })
                //自定义事件
                $(container).on('click', '.uglcw-radio .uglcw-app-custom', function () {
                    var node = tree.k().dataItem($(this).closest('.k-item'));
                    showCustomPermissionDialog(roleId, node.id, node.applyName, node.mids, node);
                })
                //统计报表checkbox事件
                $(container).on('change', '.uglcw-checkbox [type=checkbox]', function () {
                    var node = tree.k().dataItem($(this).closest('.k-item'));
                    var sgtjz = [];
                    $(this).closest('.uglcw-checkbox').find('[type=checkbox]').each(function () {
                        if ($(this).is(':checked')) {
                            sgtjz.push($(this).val());
                        }
                    })
                    node.sgtjz = sgtjz.join(',');
                })
                uglcw.ui.loaded();
            },
            yes: function (checked, nodes, flat) {
                var data = {
                    companyroleId: roleId,
                    menuapplytype: 1
                };
                $(flat).each(function (idx, item) {
                    data['roleMenu[' + idx + '].ifChecked'] = item.halfChecked || item.checked;
                    data['roleMenu[' + idx + '].menuId'] = item.id;
                    data['roleMenu[' + idx + '].tp'] = item.tp;
                    data['roleMenu[' + idx + '].bindId'] = item.menuId;
                    data['roleMenu[' + idx + '].mids'] = item.mids;
                    data['roleMenu[' + idx + '].dataTp'] = item.menuLeaf;
                    data['roleMenu[' + idx + '].sgtjz'] = item.sgtjz;
                });
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/saveRoleMenuApply',
                    type: 'post',
                    data: data,
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response == '2') {
                            uglcw.ui.success('操作成功');
                        } else {
                            uglcw.ui.success(response);
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

    //保存菜单应用分配功能
    function savecorpri_role(idkey, ids) {
        // bindClick();//绑定点击事件
        // var url = "manager/saveRoleMenuApply";

        /*$("#menufrm_role").form('submit', {
            url: url,
            success: function (data) {
                showMsg(data);
                closetreewin_role();
            }
        });
*/
        var data = {
            // companyroleId: idkey,
            // menuapplytype: 1
        };
        $(ids).each(function (index, menu) {
            $.map(menu, function (v, k) {
                data['roleMenu[' + index + '].' + k] = v;

            })
        })

        $.ajax({
            url: "${base}manager/saveRoleMenuApply?companyroleId=" + idkey + "&menuapplytype=1",
            data: data,
            type: 'post',
            dataType: 'json',
            success: function (response) {
                uglcw.ui.toast(response)
            }
        });
    }

    function disable(idKey, state) {
        var type = state == 1 ? '在用' : '停用';
        uglcw.ui.confirm('确定' + type + '该角色吗？',function () {
            $.ajax({
                url: '${base}manager/updateRoleStatus',
                type: 'post',
                data: {idKey: idKey, status: state},
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.success(type + '成功');
                        uglcw.ui.get('#grid').reload();
                    } else if(response.code != 200){
                        uglcw.ui.error(response.message);
                    }else{
                        uglcw.ui.error(type + '失败');
                    }

                }
            })
        })
    }

</script>
</body>
</html>
