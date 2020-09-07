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
                    区域
                </div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:[75]">
                    <div id="tree1" uglcw-role="tree"
                         uglcw-options="
                                loadOnDemand: false,
                                url:'${base}manager/sysRegions',
                                expandable:function(node){
                                    return true;
                                },
                                select: function(e){
                                    var target = e.node || e.sender.select();
                                    var node = this.dataItem(target);
                                    var ids = [];
                                     var collect = function(node){
                                        if(node.id == 0){
                                            return;
                                        }
                                        ids.push(node.id);
                                        if(node.hasChildren){
                                            $(node.children.view()).each(function(idx, child){
                                                collect(child)
                                            })
                                        }
                                     }
                                     collect(node);
                                     console.log('children:', ids);
                                     $('#tree1').data('collected', ids);
                                     $('.actions button').hide();
                                    if(!node.hasChildren){
                                           $('.actions button').show();
                                    }else{
                                            $('#query').show();
                                    };
                                    loadRegion(node.id);
                                    var parent = node.parentNode();
                                    uglcw.ui.get('#upRegionSpan').value(parent ? parent.text:'无');
                                    loadRegion(node.id);
                                    //TODO 再次请求数据
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
                        <li type="button" uglcw-role="button" class="k-info ghost" data-col="add" onclick="addRegion();">
                            新增一级区域
                        </li>
                        <li type="button" uglcw-role="button" id="nextTypea" data-col="add" class="k-info ghost"
                            onclick="addNextType();">
                            新增下级区域
                        </li>
                        <li type="button" uglcw-role="button" class="k-info" onclick="saveRegion();">保存
                        </li>
                        <li type="button" uglcw-role="button" class="k-error ghost" onclick="deleteRegion();">删除
                        </li>
                    </ul>
                </div>

                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: ['.btn-group', 35]">
                    <form class="form-horizontal" id="form">
                        <div class="form-group">
                            <label class="control-label col-xs-5">上级区域：</label>
                            <div class="col-xs-8">
                                <input uglcw-model="upRegionSpan" id="upRegionSpan" disabled value="无"
                                       uglcw-role="textbox">
                            </div>
                        </div>
                        <input type="hidden" uglcw-model="regionId" id="regionId" uglcw-role="textbox">
                        <input type="hidden" uglcw-model="regionPid" id="regionPid" uglcw-role="textbox">

                        <div class="form-group">
                            <label class="control-label col-xs-5">名称</label>
                            <div class="col-xs-8">
                                <input uglcw-model="regionNm" id="regionNm"
                                       uglcw-role="textbox">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-5">区域客户操作</label>
                            <div class="col-xs-12 actions" id="actions">
                                <button style="display: none" type="button" id="add" onclick="addCustomerRegion();"
                                        class="k-button k-info ghost">添加
                                </button>
                                <button style="display: none" type="button" id="del" onclick="delCustomerRegion();"
                                        class="k-button k-info ghost">移除
                                </button>
                                <button style="display: none" type="button" id="query" onclick="queryCustomerRegion();"
                                        class="k-button k-info ghost">查看
                                </button>
                            </div>
                        </div>
                    </form>
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
    });

    function loadRegion(id) {
        $.ajax({
            url: '${base}/manager/getRegion',
            data: {id: id},
            dataType: 'json',
            success: function (data) {
                data.regionNm = data.regionNm;
                data.regionId = data.regionId;
                data.regionPid = data.regionPid;
                uglcw.ui.bind('#form', data);
            }
        })
    }

    function addRegion() {//新增一级分类
        $("#upRegionSpan").html("无");
        $("#nextTypea").hide();
        uglcw.ui.clear('.form-horizontal', {upRegionSpan: '无'}, {
            excludeHidden: false
        }) //清除值,{要保留的字段}
    }

    function addNextType() {//新增下级分类
        var node = uglcw.ui.get('#tree1').k().select();
        if (!node) {
            return add();
        }
        node = uglcw.ui.get('#tree1').k().dataItem(node);
        uglcw.ui.clear('#form', {
            regionPid: node.id,
            upRegionSpan: node.text
        }, {
            excludeHidden: false
        })
    }

    function deleteRegion() {//删除
        var data = uglcw.ui.bind('#form');
        if (data.regionId) {
            uglcw.ui.confirm('确定删除区域吗?', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/deleteRegion',
                    type: 'post',
                    data: {id: data.regionId},
                    success: function (response) {
                        uglcw.ui.loaded();
                        uglcw.ui.get('#tree1').reload();
                        if (response) {
                            if (response === '1') {
                                uglcw.ui.info('删除成功');
                                uglcw.ui.clear('#form', {}, {
                                    excludeHidden: false
                                });
                            } else if (response == '2') {
                                uglcw.ui.error('该区域下有客户不能删除');
                            } else if (response == '3') {
                                uglcw.ui.error('该区域下有区域不能删除');
                            } else {
                                uglcw.ui.error('删除失败');

                            }
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('请求失败');
                    }
                })
            })
        }
    }

    function saveRegion() {//保存
        var data = uglcw.ui.bind('#form');
        uglcw.ui.confirm('确定保存吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/operRegion',
                type: 'post',
                data: data,
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response === '2') {
                        uglcw.ui.success('修改成功');
                        uglcw.ui.get('#tree1').reload();
                        $('#nextTypea').show();
                    } else if (response === '-1') {
                        return uglcw.ui.error('操作失败');
                    } else if (response === '-2') {
                        return uglcw.ui.error('区域不能超过2级');
                    } else if (response === '-3') {
                        return uglcw.ui.error('该区域名称已经存在');
                    } else {
                        uglcw.ui.success('添加成功')
                        uglcw.ui.get('#tree1').reload();
                        $('#nextTypea').show();
                    }

                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    //添加客户
    function addCustomerRegion() {
        var regionId = uglcw.ui.get('#regionId').value();
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/dialogShopCustomerPage?regionId=0&type=1',
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
                    callBackFunSelectCustomer(ids, regionId, 1);
                }
                ;

            }
        })
    }

    //移除客户
    function delCustomerRegion() {
        var ids = $('#tree1').data('collected')||[]; //获取选中节点和其所有节点
        var url = '${base}manager/dialogShopCustomerPage?type=2';
        var regionIds = [];
        $(ids).each(function(i, id){
            regionIds.push('regionId='+id);
        });
        if(regionIds.length > 0) {
            url += ('&'+ regionIds.join('&'));
        }
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: url,
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
                    callBackFunSelectCustomer(ids, 0, 2);
                }

            }
        })
    }

    //查询客户
    function queryCustomerRegion() {
        var ids = $('#tree1').data('collected')||[]; //获取选中节点和其所有节点
        var url = '${base}manager/dialogShopCustomerPage?type=2';
        var regionIds = [];
        $(ids).each(function(i, id){
            regionIds.push('regionId='+id);
        });
        if(regionIds.length > 0) {
            url += ('&'+ regionIds.join('&'));
        }
        uglcw.ui.Modal.showGridSelector({
            btns: [],
            closable: true,
            title: false,
            url: url,
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

    //选择客户-回调
    function callBackFunSelectCustomer(ids, regionId, type) {
        $.ajax({
            url: "${base}manager/batchUpdateShopCustomerType",
            data: {
                ids: ids.join(','),
                regionId: regionId
            },
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
