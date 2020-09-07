<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card header">
            <div class="layui-card-body">
                <ul class="uglcw-query form-horizontal query">
                    <li>
                        <input uglcw-model="khdjNm" uglcw-role="textbox" placeholder="客户等级名称">
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
                    url: '${base}/manager/toKhlevelPage',
                    criteria: '.query',
                    pageable: true,

                    }">

                <div data-field="qdtpNm" uglcw-options="width:200">客户类型名称</div>
                <div data-field="khdjNm" uglcw-options="{width:200}">客户等级名称</div>
                <div data-field="hy_oper"
                     uglcw-options="width:300, template: uglcw.util.template($('#khdj_oper').html())">客户等级相关操作
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toaddKhlevel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:getSelected();">
        <span class="k-icon k-i-pencil"></span>修改
    </a>
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-delete"></span>删除</a>
    <a role="button" href="javascript:setLevelPrice();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-settings"></span>按客户等级设置商品销售价格</a>
</script>

<script id="khdj_oper" type="text/x-uglcw-template">
    <button onclick="javascript:addCustomer('#= data.id#','#=data.qdId#');" class="k-button k-info">添加</button>
    <button onclick="javascript:delCustomer('#=data.id#','#=data.qdId#');" class="k-button k-info">移除</button>
    <button onclick="javascript:queryCustomer('#=data.id#','#=data.qdId#');" class="k-button k-info">
        查看
    </button>
</script>
<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="bind">
                <div class="form-group">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="id" id="id">
                    <label class="control-label col-xs-8">客户类型名称</label>
                    <div class="col-xs-14">
                        <c:if test="${!empty list}">
                            <select uglcw-role="combobox" uglcw-model="qdId">
                                <c:forEach items="${list}" var="list">
                                    <option value="${list.id}">${list.qdtpNm}</option>
                                </c:forEach>
                            </select>
                        </c:if>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">客户等级名称</label>
                    <div class="col-xs-14">
                        <input class="form-control" uglcw-role="textbox" uglcw-model="khdjNm" uglcw-validate="required">
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


    function toDel() {   //删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('是否要删除选中的客户等级?', function () {
                $.ajax({
                    url: '${base}/manager/deletekhlevelById',
                    data: {
                        id: selection[0].id
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        if (json) {
                            if (json == '1') {
                                uglcw.ui.success('删除成功');//错误提示
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            }else if(json == '2'){
                                uglcw.ui.error('客户等级内有归属客户不能删除');
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
    }

    function setLevelPrice() {
        uglcw.ui.openTab('按客户等级设置商品销售价格', '${base}/manager/levelpricewaretype');
    }

    function toaddKhlevel() {//添加客户等级
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
                        url: '${base}/manager/operKhlevel',
                        data: uglcw.ui.bind(container),  //绑定值
                        type: 'post',
                        success: function (data) {
                            if (data == "1" || data == "2") {
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            } else {
                                uglcw.ui.error('操作失败');
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

    //获取选中行的值
    function getSelected() {
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            uglcw.ui.Modal.open({  //弹框当前页面div
                area: '500px',
                content: $('#t').html(),
                success: function (container) {
                    uglcw.ui.init($(container)); //初始化页面
                    uglcw.ui.bind($(container).find('#bind'), selection[0]);//绑定数据
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        $.ajax({
                            url: '${base}/manager/operKhlevel',
                            type: 'post',
                            data: uglcw.ui.bind(container),
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

    //添加客户
    function addCustomer(id, qdId) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/queryNoneGradeCustomer?qdId=' + qdId,
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
                    callBackFunSelectCustomer(ids, id);
                }
                ;

            }
        })
    }

    //移除客户等级
    function delCustomer(id, qdId) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/queryCustomerByKhlevelId?id=' + id + '&qdId=' + qdId,
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
                    callBackFunSelectCustomerGrade(ids);
                }

            }
        })
    }

    //查询客户
    function queryCustomer(id, qdId) {
        uglcw.ui.Modal.showGridSelector({
            btns: [],
            closable: true,
            title: false,
            url: '${base}manager/queryCustomerByKhlevelId?id=' + id + '&qdId=' + qdId,
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

    //添加客户等级回调
    function callBackFunSelectCustomer(ids, id) {
        $.ajax({
            url: "${base}manager/batchAddCustomerGrade",
            data: {
                ids: ids.join(','),
                id: id
            },
            type: "post",
            success: function (json) {
                if (json != "-1") {
                    uglcw.ui.success('添加成功');
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }

    //移除客户等级回调
    function callBackFunSelectCustomerGrade(ids) {
        $.ajax({
            url: "${base}manager/batchRemoveCustomerGrade",
            data: {
                ids: ids.join(',')
            },
            type: "post",
            success: function (json) {
                if (json != "-1") {
                    uglcw.ui.success('移除成功！');
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }
</script>
</body>
</html>
