<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card header">
                    <div class="layui-card-body">
                        <ul class="uglcw-query form-horizontal query">
                            <li>
                                <input uglcw-model="storeName" uglcw-role="textbox" placeholder="加盟连锁店">
                            </li>
                            <li>
                                <select uglcw-role="combobox" uglcw-model="status" placeholder="状态">
                                    <option value="1" selected>正常</option>
                                    <option value="2">已禁用</option>
                                </select>
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
                         uglcw-options="{
                    responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/queryChainStore',
                    criteria: '.query',
                    pageable: true,

                    }">

                        <div data-field="storeName">加盟连锁店</div>
                        <div data-field="sp_oper"
                             uglcw-options="template: uglcw.util.template($('#sp_oper').html())">连锁店相关操作
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toadd();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:getSelected();">
        <span class="k-icon k-i-pencil"></span>修改
    </a>
 <%--   <a role="button" href="javascript:toDel();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-delete"></span>删除</a>--%>
    <a role="button" href="javascript:updateChainStoreState(1);" class="k-button k-button-icontext">
        <span class="k-icon k-i-checkmark"></span>启用</a>
    <a role="button" href="javascript:updateChainStoreState(2);" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>禁用</a>
</script>
<%--商品品牌相关操作--%>
<script id="sp_oper" type="text/x-uglcw-template">
    <button onclick="javascript:add(#= data.id#);" class="k-button k-info">添加</button>
    <button onclick="javascript:del(#= data.id #);" class="k-button k-info">移除</button>
    <button onclick="javascript:view(#=data.id#);" class="k-button k-info">
        查看
    </button>
</script>
<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="brand_name">
                <div class="form-group">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="id" id="id">
                    <label class="control-label col-xs-8">加盟连锁店</label>
                    <div class="col-xs-14">
                        <input class="form-control" uglcw-role="textbox" uglcw-model="storeName" uglcw-validate="required">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置（清除搜索输入框数据）
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })


    function toadd() {//添加
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#t').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    $.ajax({
                        url: '${base}/manager/operChainStore',
                        data: uglcw.ui.bind(container),  //绑定值
                        type: 'post',
                        success: function (data) {
                            if (data == "1" || data == "2") {
                                uglcw.ui.get('#grid').reload();//刷新页面数据
                            } else {
                                uglcw.ui.error('失败');//错误提示
                                return;
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });
    }

    function getSelected() {//修改
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#t').html(),
                success: function (container) {
                    uglcw.ui.init($(container));//初始化
                    uglcw.ui.bind($(container).find('#brand_name'), selection[0]);//邦定数据
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        $.ajax({
                            url: '${base}/manager/operChainStore',
                            data: uglcw.ui.bind(container),  //绑定值
                            type: 'post',
                            success: function (data) {
                                if (data == "1" || data == "2") {
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                } else {
                                    uglcw.ui.error('失败');//错误提示
                                    return;
                                }
                            }
                        })
                    } else {
                        uglcw.ui.error('失败');
                        return false;
                    }
                }
            });
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }
/*
    function toDel() {   //删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('是否要删除选中的品牌名称?', function () {
                $.ajax({
                    url: '${base}/manager/deleteById',
                    data: {
                        id: selection[0].id
                    },
                    type: 'post',
                    success: function (json) {
                        if (json) {
                            if (json == '1') {
                                uglcw.ui.success('删除成功');//错误提示
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            }else if(json == '2'){
                                uglcw.ui.error('连锁店内有归属客户不能删除');
                            }
                        } else {
                            uglcw.ui.error('删除失败');
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要删除的行！');
        }
    }*/
    function updateChainStoreState(status) {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if(selection){
            $.ajax({
                url: '${base}manager/updateChainStoreState',
                type: 'post',
                data: {id:selection[0].id , status: status},
                async: false,
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    }  else{
                        uglcw.ui.error(response.message || '操作失败');
                        return;
                    }
                }
            })
        }else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }
    //添加
    function add(id) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/queryNoneChainStoreCustomer',
            query: function (params) {
                params.isDb = 2;
            },
            checkbox: true,
            width: 700,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="khNm">',
            columns: [
                {field: 'khNm', title: '客户名称', width: 160, tooltip: true},
                {field: 'mobile', title: '客户手机', width: 120},
                {field: 'address', title: '客户地址', width: 220, tooltip: true},
                {field: 'khCode', title: '客户编码', width: 160},
            ],
            yes: function (nodes) {
                if (nodes && nodes.length > 0) {
                    var ids = $.map(nodes, function (node) {
                        return node.id;
                    });
                    addChainStoreCustomer(ids, id);
                }
                ;

            }
        })
    }

    //移除
    function del(id) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/queryChainStoreCustomer?shopId=' + id,
            query: function (params) {
                params.isDb = 2;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="khNm">',
            columns: [
                {field: 'khNm', title: '客户名称', width: 160, tooltip: true},
                {field: 'mobile', title: '客户手机', width: 120},
                {field: 'address', title: '客户地址', width: 220, tooltip: true},
                {field: 'khCode', title: '客户编码', width: 160},
            ],
            yes: function (nodes) {
                if (nodes && nodes.length > 0) {
                    var ids = $.map(nodes, function (node) {
                        return node.id;
                    });
                    removeChainStoreCustomer(ids);
                }

            }
        })
    }

    //查询
    function view(id) {
        uglcw.ui.Modal.showGridSelector({
            btns: [],
            closable: true,
            title: false,
            url: '${base}manager/queryChainStoreCustomer?shopId=' + id,
            query: function (params) {
                params.isDb = 2;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="khNm">',
            columns: [
                {field: 'khNm', title: '客户名称', width: 160, tooltip: true},
                {field: 'mobile', title: '客户手机', width: 120},
                {field: 'address', title: '客户地址', width: 220, tooltip: true},
                {field: 'khCode', title: '客户编码', width: 160},
            ],
        })
    }

    //添加商品回调
    function addChainStoreCustomer(ids, id) {
        $.ajax({
            url: '${base}/manager/batchUAddChainStoreCustomer',
            data: {
                ids: ids.join(','),
                id: id
            },
            type: 'post',
            success: function (json) {
                if (json != "-1") {
                    uglcw.ui.success('添加成功');
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })

    }

    //移除商品
    function removeChainStoreCustomer(ids) {
        $.ajax({
            url: '${base}/manager/batchRemoveChainStoreCustomer',
            data: {ids: ids.join(',')},
            type: 'post',
            success: function (json) {
                if (json != "-1") {
                    uglcw.ui.success('移除成功');
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })
    }
</script>
</body>
</html>
