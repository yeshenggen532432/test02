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
    <div class="layui-card">
        <div class="layui-card header">
            <div class="layui-card-body">
                <ul class="uglcw-query /manager/toFinCostform-horizontal query">
                    <li>
                        <input uglcw-model="proName" uglcw-role="textbox" placeholder="名称">
                    </li>
                    <li>
                        <select uglcw-role="combobox" uglcw-model="status" placeholder="状态">
                            <option value="1" selected>正常</option>
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
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                    responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/finUnitPage',
                    criteria: '.query',
                    pageable: true,
                    checkbox: true
                    }">
                <div data-field="proNo" uglcw-options="width:80">单位编码</div>
                <div data-field="proName" uglcw-options="width:100">单位名称</div>
                <div data-field="contact" uglcw-options="width:100">联系人</div>
                <div data-field="tel" uglcw-options="width:120">联系电话</div>
                <div data-field="mobile" uglcw-options="width:120">手机</div>
                <div data-field="address" uglcw-options="width:160">地址</div>
                <div data-field="remarks" uglcw-options="width:120">备注</div>
               <%-- <div data-field="status"
                     uglcw-options="width:100, template: uglcw.util.template($('#formatterSt3').html())">是否禁用
                </div>--%>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toaddprovider();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:getSelected();">
        <span class="k-icon k-i-pencil"></span>修改
    </a>
    <a role="button" href="javascript:updateState(1);" class="k-button k-button-icontext">
        <span class="k-icon k-i-checkmark"></span>启用</a>
    <a role="button" href="javascript:updateState(2);" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>禁用</a>
</script>

<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="bind">
                <div class="form-group">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="id" id="id" value="${pro.id}">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${pro.status}">
                    <label class="control-label col-xs-8">单位编码</label>
                    <div class="col-xs-14">
                        <input class="form-control" uglcw-role="textbox" uglcw-model="proNo" value="${pro.proNo}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">单位名称</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="proName" id="proName"  uglcw-validate="required" value="${pro.proName}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">联系人</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="contact" id="contact" value="${pro.contact}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">联系电话</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="tel" id="tel" value="${pro.tel}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">手机</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="mobile" id="mobile" value="${pro.mobile}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">地址</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="address" id="address" value="${pro.address}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-14">
                        <textarea uglcw-role="textbox" uglcw-model="remarks" id="remarks" value="${pro.remarks}"></textarea>
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

    function updateState(status) {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if(selection){
                $.ajax({
                    url: '${base}manager/updateFinUnitIsUse',
                    type: 'post',
                    data: {id:selection[0].id , status: status},
                    async: false,
                    success: function (data) {
                        if (data == '1') {
                            uglcw.ui.success('操作成功');
                            uglcw.ui.get('#grid').reload();
                        } else if(data == '2'){
                            uglcw.ui.error('已是当前状态不能重复操作');
                        }  else{
                            uglcw.ui.error('操作失败');
                            return;
                        }
                    }
                })
        }else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }
    function toaddprovider() {//添加
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
                        url: '${base}manager/savefinunit',
                        data: uglcw.ui.bind(container),  //绑定值
                        type: 'post',
                        success: function (response) {
                            if (response.code == 200) {
                                uglcw.ui.success('添加成功');
                                setTimeout(function () {
                                    uglcw.ui.reload();
                                }, 1000)
                            } else {
                                uglcw.ui.error(response.message || '操作失败');
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
                    uglcw.ui.bind($(container).find('#bind'), selection[0]);//邦定数据
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        $.ajax({
                            url: '${base}manager/savefinunit',
                            data: uglcw.ui.bind(container),  //绑定值
                            type: 'post',
                            success: function (response) {
                                if (response.code == 200) {
                                    uglcw.ui.success('修改成功');
                                    setTimeout(function () {
                                        uglcw.ui.reload();
                                    }, 1000)
                                } else {
                                    uglcw.ui.error(response.message ||'操作失败');
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

    function toDel() {   //删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('您确认想要删除记录吗?', function () {
                $.ajax({
                    url: '${base}/manager/deletefinunit',
                    data: {
                        ids: selection[0].id
                    },
                    type: 'post',
                    success: function (json) {
                        if (json == 2) {
                            uglcw.ui.warning('删除失败，该往来单位已使用！');
                        }
                        if (json == 1) {
                            uglcw.ui.success('删除成功');
                            uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                        } else if (json == -2) {
                            uglcw.ui.warning('包含有当前登陆用户，不能删除！');

                        } else if (json == -1) {
                            uglcw.ui.error('删除失败！')
                        }

                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要删除的行！');
        }
    }
</script>
</body>
</html>
