<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>仓库列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        td .set-default{
            display: none;
        }
        td.uglcw-grid-readonly:hover .set-default{
            display: block;
            margin: 0 auto;
        }
        .uglcw-grid.uglcw-grid-compact td {
            padding-top: .5em !important;
            padding-bottom: .5em !important;
        }
        .uglcw-grid.uglcw-grid-compact td .k-button{
            padding-top: 0;
            padding-bottom: 0;
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
                    <c:set var="title" value="${fns:getStorageTitleName()}"/>
                    <c:set var="bool" value="${fns:isUseKuwei()}"/>
                    <input uglcw-model="stkName" uglcw-role="textbox" placeholder="仓库名称">
                </li>
                <li>
                    <select uglcw-model="status" uglcw-role="combobox" placeholder="状态">
                        <option value="1" selected>启用</option>
                        <option value="2">禁用</option>
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
            <div id="grid" uglcw-role="grid"class="uglcw-grid-compact"
                 uglcw-options="
                    checkbox: true,
                    responsive: ['.header', 40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/basestkPage',
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="stkNo" uglcw-options="width:100,hidden:true">仓库编码</div>
                <div data-field="stkName" uglcw-options="width:180">仓库名称</div>
                <div data-field="kwArea" uglcw-options="width:80,hidden:true">库位面积</div>
                <div data-field="kwVolume" uglcw-options="width:80,hidden:true">库位容量</div>
                <div data-field="kwBar" uglcw-options="width:80,hidden:true">库位条码</div>
                <div data-field="kwSort" uglcw-options="width:80,hidden:true">库位排序</div>
                <div data-field="isSelect"
                     uglcw-options="width:140, template: uglcw.util.template($('#isSelect-template').html())">是否默认
                </div>
                <div data-field="isFixed"
                     uglcw-options="width:140, template: uglcw.util.template($('#isFixed-template').html())">手机端锁定仓库
                </div>
                <div data-field="stkManager" uglcw-options="width:160">管理员</div>
                <div data-field="tel" uglcw-options="width:160">联系电话</div>

                <div data-field="saleCar" uglcw-options="width:160,
                        template: uglcw.util.template($('#salecar-template').html())">${title}类型
                </div>
                <div data-field="address" uglcw-options="width:200, tooltip: true">地址</div>
                <div data-field="remarks" uglcw-options="width:120, tooltip: true">备注</div>
               <%-- <div data-field="kw_oper"
                     uglcw-options="width:300, template: uglcw.util.template($('#kw_oper').html())">仓库库位相关操作
                </div>--%>
            </div>
        </div>
    </div>
</div>
<script id="salecar-template" type="text/x-uglcw-template">
    <span>
    # if(data.saleCar == 1){ #
         车销仓库
    # } else if (data.saleCar == 2) {#
        门店仓库
    # }else { #
        正常仓库
    # } #
    </span>
</script>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:toEdit();">
        <span class="k-icon k-i-edit"></span>修改</a>
    <a role="button" href="javascript:updateStorageStatus(1);" class="k-button k-button-icontext">
        <span class="k-icon k-i-checkmark"></span>启用</a>
    <a role="button" href="javascript:updateStorageStatus(2);" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>禁用</a>
    <%--<c:if test="${bool}">--%>
        <%--<a role="button" class="k-button k-button-icontext" href="javascript:createTemp();">--%>
            <%--<span class="k-icon k-i-edit"></span>生成临时库位</a>--%>
    <%--</c:if>--%>
</script>
<%--<script id="kw_oper" type="text/x-uglcw-template">
    <button onclick="javascript:addHouse(#= data.id#);" class="k-button k-info">添加</button>
    <button onclick="javascript:delHouse(#= data.id#);" class="k-button k-info">移除</button>
    <button onclick="javascript:queryHouse(#= data.id#);" class="k-button k-info">查看</button>
</script>--%>
<script type="text/x-uglcw-template" id="isSelect-template">
    # if(data.isSelect =='1'){ #
    <button class="k-button k-error">默认</button>
    <button class="k-button k-success" onclick="isSelect(#= data.id#,#=data.isSelect#)">取消默认</button>
    # }else { #
    <button class="k-button k-success set-default"  onclick="isSelect(#= data.id#,#=data.isSelect#)">设为默认</button>
    # } #
</script>
<script type="text/x-uglcw-template" id="isFixed-template">
    # if(data.isFixed =='1'){ #
    <button class="k-button k-error">默认</button>
    <button class="k-button k-success" onclick="isFixed(#= data.id#, #=data.isFixed#)">取消默认</button>
    # }else { #
    <button class="k-button k-success  set-default" onclick="isFixed(#= data.id#, #= data.isFixed#)">设为默认</button>
    # } #
</script>
<script type="text/x-uglcw-template" id="isTemp-template">
    # if(data.houseId){ #
        # if(data.isTemp =='1'){ #
        <%--<button class="k-button k-error"><i class="k-icon k-i-success"></i>是</button>--%>
    是
        # }else { #
        <%--<button class="k-button k-success"><i class="k-icon k-i-cancel"></i>否</button>--%>
        # } #
    # } #
</script>

<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group" style="display: none">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <input uglcw-role="textbox" uglcw-model="status" type="hidden">
                    <label class="control-label col-xs-6">
                        仓库编码</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="stkNo" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">仓库名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="stkName" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
              <%--  <div class="form-group">
                    <label class="control-label col-xs-6">管理员</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="stkManager" uglcw-role="textbox">
                    </div>
                </div>--%>
                <div class="form-group" style="display:none">
                    <label class="control-label col-xs-6">仓库面积</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="kwArea" uglcw-role="numeric" uglcw-role="textbox">平方米
                    </div>
                </div>
                <div class="form-group" style="display:none">
                    <label class="control-label col-xs-6">仓库容量</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="kwVolume" uglcw-role="numeric" uglcw-role="textbox">件数
                    </div>
                </div>
                <div class="form-group" style="display:none">
                    <label class="control-label col-xs-6">仓库条码</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="kwBar" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group" style="display:none">
                    <label class="control-label col-xs-6">仓库排序</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="kwSort" uglcw-role="numeric"
                               uglcw-validate="number"
                               uglcw-options="decimals: 0,format: 'n0'"
                               uglcw-role="textbox" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">管理员</label>
                    <div class="col-xs-16">
                        <tag:select3 width="200px;" name="managerId" id="managerId" tableName="sys_mem" headerKey="-1"
                                     headerValue="--请选择--"
                                     selectBlock="member_id,member_nm,member_mobile" whereBlock="member_use=1"
                                     displayKey="member_id" displayValue="member_nm" onselect="employeePhone"/>
                    </div>
                </div>
               <div class="form-group">
                    <label class="control-label col-xs-6">联系电话</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="tel" id="tel" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">仓库类型</label>
                    <div class="col-xs-16">
                        <select style="width: 200px;" uglcw-role="combobox" uglcw-model="saleCar">
                            <option value="0" selected>正常仓库</option>
                            <option value="1">车销仓库</option>
                            <option value="2">门店仓库</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">地址</label>
                    <div class="col-xs-16">
                        <input uglcw-model="address" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-16">
                        <textarea uglcw-model="remarks" uglcw-role="textbox"></textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>

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
    })

    function employeePhone(e) {
        var item = e.dataItem;
        uglcw.ui.get('#tel').value(item.member_mobile)

    }
    function add() {
        edit();
    }

    function toEdit() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的仓库');
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
                $.ajax({
                    url: '${base}manager/savestk',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (response) {
                        if (response.code == 200) {
                            uglcw.ui.success('操作成功');
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error(response.message||'操作失败');
                            return false;
                        }
                    }
                })
            }
        })
    }

    function updateStorageStatus(status) {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if(selection){
            $.ajax({
                url: '${base}manager/updateStorageStatus',
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

    function isSelect(id,isSelect) {
        var s = '是否确定默认？'
        if('1' == isSelect){
            s = '取消默认仓库？'
        }
        uglcw.ui.confirm(s,function () {
            $.ajax({
                url: '${base}manager/updateSelect',
                type: 'post',
                data: {id: id},
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.success( '操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败');
                    }

                }
            })
        })
    }

    function isFixed(id, isFixed) {
        var s = '该仓库是否确认为手机端锁定仓库？'
        if('1' == isFixed){
            s = '取消手机端锁定仓库？'
        }
        uglcw.ui.confirm(s, function () {
            $.ajax({
                url: '${base}manager/updateFixedStorage',
                type: 'post',
                data: {id: id},
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.success( '操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败');
                    }

                }
            })
        })
    }

    function createTemp(){
        uglcw.ui.confirm('是否确定生成临时库位?',function () {
            $.ajax({
                url: '${base}manager/oneKeyCreateTemp',
                type: 'post',
                success: function (response) {
                    if (response == '1') {
                        uglcw.ui.success( '操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败');
                    }

                }
            })
        })
    }
  /*  //添加库位
    function addHouse(id) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/stkHouse/queryNoneStorageHouse',
            query: function (params) {
                params.status = 1;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="houseName">',
            columns: [
                {field: 'houseName', title: '库位名称',width: 'auto', attributes: {style: 'text-align:center'},
                    headerAttributes: {style: 'text-align:center'}
                    }
            ],
            yes: function (nodes) {
                if(nodes && nodes.length>0){
                    var ids = $.map(nodes, function (node) {
                        return node.id;
                    });
                    callBackFunQueryNoneStorageHouse(ids, id);
                };

            }
        })
    }
    //移除库位
    function delHouse(id) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/stkHouse/queryHouseByStkId?id=' + id,
            query: function (params) {
                params.status = 1;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="houseName">',
            columns: [
                {field: 'houseName', title: '库位名称',width: 'auto', attributes: {style: 'text-align:center'},
                    headerAttributes: {style: 'text-align:center'}
                }
            ],
            yes: function (nodes) {
                if(nodes && nodes.length>0){
                    var ids = $.map(nodes, function (node) {
                        return node.id;
                    });
                    callBackFunQueryHouseByStkId(ids);
                }

            }
        })
    }
        //查看库位
        function queryHouse(id) {
            uglcw.ui.Modal.showGridSelector({
                btns:[],
                closable: true,
                title: false,
                url: '${base}manager/stkHouse/queryHouseByStkId?id=' + id,
                query: function (params) {
                    params.status = 1;
                },
                checkbox: true,
                width: 650,
                height: 400,
                criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="houseName">',
                columns: [
                    {field: 'houseName', title: '库位名称',width: 'auto', attributes: {style: 'text-align:center'},
                        headerAttributes: {style: 'text-align:center'}
                    }
                ],
            })
        }
    //添加库位的回调
    function callBackFunQueryNoneStorageHouse(ids,id) {
        $.ajax({
            url: "${base}manager/stkHouse/batchAddHouse",
            data: { ids:ids.join(','),
                id:id},
            type: "post",
            success: function (response) {
                if (response.code == 200) {
                    uglcw.ui.success( '操作成功');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }
    //移除库位的回调
    function callBackFunQueryHouseByStkId(ids) {
        $.ajax({
            url: "${base}manager/stkHouse/batchRemoveHouse",
            data: { ids:ids.join(',')},
            type: "post",
            success: function (response) {
                if (response.code == 200) {
                    uglcw.ui.success( '操作成功');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }*/
</script>
</body>
</html>
