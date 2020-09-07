<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>订货管理-商品分类管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-header">
                    部门分类树
                </div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:[75]">
                    <div id="tree1" uglcw-role="tree"
                         uglcw-options="
                                lazy: false,
                                dataTextField: 'branchName',
                                url:'manager/department/tree?dataTp=1',
                                loadFilter:function(response){
                                    return response.data || []
                                },
                                expandable:function(node){
                                    if(node.id == '0')return true;
                                    return false;
                                },
                                select: function(e){
                                    var target = e.node || e.sender.select();
                                    var node = this.dataItem(target);
                                    var parent = node.parentNode();
                                    uglcw.ui.get('#parentName').value(parent ? parent.branchName:'无');
                                    loadDepartment(node.branchId);
                                },
                                dataBound: function(){
                                    this.select('.k-item:first');
                                    this.trigger('select');
                                }
                            ">
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <li id="add" onclick="add()" class="k-info" data-icon="add">新增一级分类</li>
                        <li onclick="addChild()" id="nextTypea" class="k-info"
                            data-icon="add">新增下级分类
                        </li>
                        <li onclick="save()" id="save" class="k-info" data-icon="save">保存
                        </li>
                        <li onclick="remove()" id="remove" class="k-error"
                            data-icon="trash">删除
                        </li>
                    </ul>
                </div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: ['.btn-group', 35]">
                    <div class="form-horizontal" id="form" uglcw-role="validator">
                        <input type="hidden" uglcw-model="branchId" id="branchId" uglcw-role="textbox">
                        <input type="hidden" uglcw-model="parentId" id="parentId" uglcw-role="textbox">
                        <input type="hidden" uglcw-model="branchLeaf" id="branchLeaf" uglcw-role="textbox">
                        <input type="hidden" uglcw-model="branchPath" id="branchPath" uglcw-role="textbox">
                        <input type="hidden" uglcw-model="branchName1" id="branchName1" uglcw-role="textbox">
                        <div class="form-group">
                            <label class="control-label col-xs-3">上级部门</label>
                            <div class="col-xs-6">
                                <input uglcw-model="parentName" id="parentName" disabled value="无"
                                       uglcw-role="textbox">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">部门名称</label>
                            <div class="col-xs-6">
                                <input uglcw-model="branchName" id="branchName" uglcw-validate="required"
                                       uglcw-role="textbox">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">上午上班时间</label>
                            <div class="col-xs-6">
                                <input uglcw-model="swSb" id="swSb" uglcw-options="format: 'HH:mm'"
                                       uglcw-role="timepicker">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">上午下班时间</label>
                            <div class="col-xs-6">
                                <input uglcw-model="swXb" id="swXb" uglcw-options="format: 'HH:mm'"
                                       uglcw-role="timepicker">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">下午上班时间</label>
                            <div class="col-xs-6">
                                <input uglcw-model="xwSb" id="xwSb" uglcw-options="format: 'HH:mm'"
                                       uglcw-role="timepicker">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">下午下班时间</label>
                            <div class="col-xs-6">
                                <input uglcw-model="xwXb" id="xwXb" uglcw-options="format: 'HH:mm'"
                                       uglcw-role="timepicker">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">备注</label>
                            <div class="col-xs-6">
                                <textarea id="branchMemo" uglcw-role="textbox" uglcw-model="branchMemo"></textarea>
                            </div>
                        </div>
                        <%--<div class="form-group">
                            <label class="control-label col-xs-3">分配部门权限</label>
                            <div class="col-xs-12">
                                <button type="button" class="k-info" uglcw-role="button" onclick="showMember(1);">
                                    <i class="k-icon k-i-check-circle"></i>可见人员
                                </button>
                                <button type="button" class="k-error" uglcw-role="button" onclick="showMember(2);">
                                    <i class="k-icon k-i-close-circle"></i>不可见人员
                                </button>
                            </div>
                        </div>--%>
                        <div class="form-group">
                            <label class="control-label col-xs-3">部门人员操作</label>
                            <div class="col-xs-12">
                                <button onclick="addMember();" class="k-button k-info ghost">添加</button>
                                <button onclick="delMember();" class="k-button k-info ghost">移除</button>
                                <button onclick="queryMember();" class="k-button k-info ghost">查看</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })

    function loadDepartment(id) {
        $.ajax({
            url: '${base}/manager/getdepart',
            data: {id: id},
            dataType: 'json',
            success: function (data) {
                data.branchName1 = data.branchName;
                uglcw.ui.bind('#form', data);
            }
        })
    }

    function add() {
        uglcw.ui.clear('#form', {parentName: '无'}, {
            excludeHidden: false
        });
    }

    function addChild() {
        var node = uglcw.ui.get('#tree1').k().select();
        if (!node) {
            return add();
        }
        node = uglcw.ui.get('#tree1').k().dataItem(node);
        uglcw.ui.clear('#form', {
            parentId: node.branchId,
            parentName: node.branchName
        }, {
            excludeHidden: false
        })
    }

    function save() {
        var validator = uglcw.ui.get('#form');
        if (!validator.validate()) {
            return;
        }
        uglcw.ui.loading();
        $.ajax({
            url: '${base}/manager/operdepart',
            type: 'post',
            data: uglcw.ui.bind('#form'),
            success: function (response) {
                uglcw.ui.loaded();
                if (response == '0') {
                    uglcw.ui.success('修改成功');
                    uglcw.ui.get('#tree1').reload();
                } else if (response == '-1') {
                    uglcw.ui.error('操作失败');
                } else if (response == '-3') {
                    uglcw.ui.error('该部门名称已存在');
                } else {
                    uglcw.ui.success('添加成功');
                    uglcw.ui.bind('#form', {
                        branchId: response
                    });
                    uglcw.ui.get('#tree1').reload();
                }
            },
            error: function () {
                uglcw.ui.loaded();
            }
        })
    }

    function remove() {
        uglcw.ui.confirm('是否删除该部门？', function () {
            $.ajax({
                url: '${base}/manager/deletedepart',
                type: 'post',
                data: {id: uglcw.ui.get('#branchId').value()},
                success: function (response) {
                    if (response) {
                        uglcw.ui.get('#tree1').reload();
                        if (response === '1') {
                            uglcw.ui.success('删除成功');
                        } else if (response ==='2'){
                            return uglcw.ui.error("该区域下有人员不能删除")
                        }else {
                            uglcw.ui.error('请先删除子部门')
                        }
                    }
                }
            })
        })
    }


    /*function showMember(type) {
        var branchId = uglcw.ui.get('#branchId').value();
        uglcw.ui.Modal.showTreeSelector({
            title: (type === 1 ? '可' : '不可') + '见人员设置',
            area: ['350px', '70%'],
            offset: '50px',
            url: '${base}/manager/deptpowertree',
            data: {
                deptId: branchId,
                tp: type
            },
            dataTextField: 'usrnm',
            checkable: function (node) {
                return node.isuse > 0;
            },
            yes: function (checked, tree, flat) {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}/manager/saveDeptPower',
                    type: 'post',
                    data: {
                        powertp: type,
                        deptId: branchId,
                        usrid: $.map(checked, function (item) {
                            return item.usrid
                        }).join(',')
                    },
                    success: function (response) {
                        uglcw.ui.loaded();
                        uglcw.ui.success('操作成功');
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('操作失败');
                    }
                })
            }
        })
    }*/
    //添加员工

    function addMember() {
        var branchId = uglcw.ui.get('#branchId').value();
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/dialogShopMemberPage?branchId=' + branchId+'&type=1',
            query: function (params) {
                params.memberUse = 1;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="memberNm">',
            columns: [
                {field: 'memberNm', title: '姓名', width: 200, tooltip: true},
                {field: 'memberMobile', title: '手机号码', width: 220, tooltip: true},
            ],
            yes: function (nodes) {
                if(nodes && nodes.length>0){
                    var ids = $.map(nodes, function (node) {
                        return node.memberId;
                    });
                    callBackFunSelectMember(ids, branchId,1);
                };

            }
        })
    }
    //移除
    function delMember() {
        var branchId = uglcw.ui.get('#branchId').value();
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/dialogShopMemberPage?branchId=' + branchId+'&type=2',
            query: function (params) {
                params.memberUse = 1;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="memberNm">',
            columns: [
                {field: 'memberNm', title: '姓名', width: 200, tooltip: true},
                {field: 'memberMobile', title: '手机号码', width: 220, tooltip: true},
            ],
            yes: function (nodes) {
                if(nodes && nodes.length>0){
                    var ids = $.map(nodes, function (node) {
                        return node.memberId;
                    });
                    callBackFunSelectMember(ids, '',2);
                }

            }
        })
    }

    //查询员工
    function queryMember() {
        var branchId = uglcw.ui.get('#branchId').value();
        uglcw.ui.Modal.showGridSelector({
            btns:[],
            closable: true,
            title: false,
            url: '${base}manager/dialogShopMemberPage?branchId=' + branchId+'&type=2',
            query: function (params) {
                params.memberUse = 1;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="memberNm">',
            columns: [
                {field: 'memberNm', title: '姓名', width: 200, tooltip: true},
                {field: 'memberMobile', title: '手机号码', width: 220, tooltip: true},
            ],
        })
    }
    //回调
    function callBackFunSelectMember(ids, branchId, type) {
        $.ajax({
            url: "${base}manager/batchUpdateMemberDepartment",
            data: { ids:ids.join(','),
                branchId:branchId},
            type: "post",
            success: function (json) {
                if (json != "-1") {
                    if (type == '1') {
                        uglcw.ui.success('添加成功');
                    } else {
                        uglcw.ui.success('移除成功');
                    }
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }
</script>
</body>
</html>
