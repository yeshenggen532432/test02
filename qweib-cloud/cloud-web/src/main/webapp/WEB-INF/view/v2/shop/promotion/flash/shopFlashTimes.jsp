<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>秒杀时间段设置</title>
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

        <div class="layui-card">
            <div class="layui-card-body full">
                <div class="form-horizontal query" style="display: none">
                    <div class="form-group">
                        <div class="col-xs-4">
                            <input uglcw-model="mobile" uglcw-role="textbox" placeholder="手机号">
                        </div>
                        <div class="col-xs-4">
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </div>
                    </div>
                </div>
                <div id="grid" uglcw-role="grid"
                     uglcw-options="
                             toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: false,
                                url: '${base}/manager/promotion/shopFlashTimes/queryList?flashId=${flashId}',
                    		criteria: '.query',
                    	">
                    <div data-field="title" uglcw-options="width:200">秒杀时间段</div>
                    <div data-field="startTimeStr" uglcw-options="width:150">开始时间</div>
                    <div data-field="endTimeStr" uglcw-options="width:150">结束时间</div>
                    <div data-field="sort" uglcw-options="width:100">排序</div>
                    <c:if test="${flashId>0}">
                        <div data-field="wareCount" uglcw-options="width:100">商品数量</div>
                    </c:if>
                    <div data-field="state"
                         uglcw-options="width:100, template: uglcw.util.template($('#state_tpl').html())">
                        状态
                    </div>
                    <div data-field="opt" uglcw-options="width:200,template: uglcw.util.template($('#opt-tpl').html())">
                        操作
                    </div>
                </div>
            </div>
        </div>
        <%--表格：end--%>
    </div>
    <%--2右边：表格end--%>
</div>
</div>
<%--启用操作--%>
<script id="state_tpl" type="text/x-uglcw-template">
    <c:if test="${isRun}">
        # if(data.state == '1'){ #启用
        # }else{ #禁用
        # } #
    </c:if>
    <c:if test="${!isRun}">
        # if(data.state == '1'){ #
        <button onclick="javascript:updateState(#= data.id#,0);" class="k-button k-info">启用</button>
        # }else{ #
        <button onclick="javascript:updateState(#= data.id#,1);" class="k-button k-info">禁用</button>
        # } #
    </c:if>
</script>
<script type="text/x-uglcw-template" id="toolbar">
    <c:if test="${flashId ==0 || !isRun}">
        <a role="button" href="javascript:shopEditForm({flashId:${flashId},sort:1});"
           class="k-button k-button-icontext">
            <span class="k-icon k-i-plus-outline"></span>添加时间段
        </a>
    </c:if>
</script>
<script type="text/x-uglcw-template" id="opt-tpl">
    <c:if test="${flashId>0}">
        <button class="k-button k-success" type="button" onclick="toFlashWarePage('#=data.title#',#=data.id#)"
        ">商品编辑</button></c:if>
    <c:if test="${!isRun}">
        <button class="k-button k-success" type="button" onclick="edit(#=data.id#)">编辑</button>
        <button class="k-button k-success" type="button" onclick="del(#=data.id#)">删除</button>
    </c:if>
</script>
<%--添加或修改--%>
<script type="text/x-uglcw-template" id="editForm_tpl">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="editForm" uglcw-role="validator">
                <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                <input uglcw-role="textbox" uglcw-model="flashId" type="hidden">
                <div class="form-group">
                    <label class="control-label col-xs-6">秒杀时间段</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="title" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">开始时间</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="startTimeStr" uglcw-options="format:'HH:mm'"
                               uglcw-role="timepicker" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">结束时间</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="endTimeStr" uglcw-options="format:'HH:mm'"
                               uglcw-role="timepicker" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">排序</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="sort" uglcw-role="numeric" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">状态</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="state"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"禁用","value":"0"},{"text":"启用","value":"1"}]'></ul>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    //活动商品列表
    function toFlashWarePage(name, id) {
        uglcw.ui.openTab(name + '商品列表', '${base}/manager/promotion/shopFlashWare/toPage?flashId=${flashId}&timeId=' + id);
    }

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

        //resize();
        //$(window).resize(resize);
        uglcw.ui.loaded();
        uglcw.io.on('refreshFlash${flashId}',function () {
           // uglcw.ui.get('#grid').reload();
            location.href=location.href;
        });//发布事件
    })

    //修改启用状态
    function updateState(id, state) {
        var str = status ? '启用' : '禁用';
        uglcw.ui.confirm("是否确定" + str + "操作?", function () {
            $.ajax({
                url: '${base}manager/promotion/shopFlashTimes/updateState',
                data: {
                    id: id,
                    state: state
                },
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message);
                    }
                }
            })
        })
    }

    //删除
    function del(id) {
        uglcw.ui.confirm("确定删除所选记录吗？", function () {
            $.ajax({
                url: "${base}manager/promotion/shopFlashTimes/removeById?flashId=${flashId}",
                data: {
                    id: id,
                },
                type: 'post',
                dataType: 'json',
                success: function (resp) {
                    if (resp.state) {
                        uglcw.ui.get('#grid').reload();
                        uglcw.ui.success(resp.message);
                    } else {
                        uglcw.ui.error(resp.message)
                    }
                }
            });
        })
    }

    //添加
    function edit(id) {
        $.ajax({
            url: '${base}manager/promotion/shopFlashTimes/findById',
            data: {id: id},
            type: 'post',
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp.state) {
                    shopEditForm(resp.obj);
                } else {
                    uglcw.ui.error('加载数据失败');
                }
            }
        })
    }

    function shopEditForm(data) {
        var text = data.id ? '修改' : '新增';
        var win = uglcw.ui.Modal.open({
            title: text + ' 秒杀时间段',
            maxmin: false,
            area: ['600px', '450px'],
            content: $('#editForm_tpl').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), data);
            },
            yes: function () {
                var data = uglcw.ui.bind(".editForm");
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/promotion/shopFlashTimes/saveOrUpdate',
                    data: data,
                    type: 'post',
                    async: true,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp.state) {
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.success(resp.message);
                            uglcw.ui.Modal.close(win);
                        } else {
                            uglcw.ui.error(resp.message)
                        }
                    }, error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error("出现错误")
                    }
                })
                return false;
            }
        })
    }
</script>

</body>
</html>
