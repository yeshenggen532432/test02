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
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input uglcw-model="taskTitle" uglcw-role="textbox" placeholder="任务名称">
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
                         uglcw-options="{
                    responsive:['.header',40],
                    id:'id',
                     toolbar: kendo.template($('#toolbar').html()),
                    url: 'manager/taskpages?parentId=${parentId }',
                    criteria: '.form-horizontal',
                    pageable: true,

                    }">

                        <div data-field="taskTitle" uglcw-options="width:140">任务标题</div>
                        <div data-field="createTime" uglcw-options="{width:160}">创建时间</div>
                        <div data-field="startTime" uglcw-options="{width:160}">开始时间</div>
                        <div data-field="endTime" uglcw-options="{width:160}">结束时间</div>
                        <div data-field="status"
                             uglcw-options="width:120, template: uglcw.util.template($('#state-classification').html())">状态
                        </div>
                        <div data-field="createName"
                             uglcw-options="width:100, template: '#= data.createName ? data.createName: \'-\'#'">发布人
                        </div>
                        <div data-field="memberNm"
                             uglcw-options="width:100, template: '#= data.memberNm ? data.memberNm: \'-\'#'">执行人
                        </div>
                        <div data-field="supervisor"
                             uglcw-options="width:100, template: '#= data.supervisor ? data.supervisor: \'-\'#'">关注人
                        </div>
                        <div data-field="actTime"
                             uglcw-options="width:160, template: '#= data.actTime ? data.actTime: \'-\'#'">实际完成时间
                        </div>
                        <div data-field="percent"
                             uglcw-options="width:100, template: '#= data.percent ? (data.percent+\'%\'): \'-\'#'">完成进度
                        </div>
                        <div data-field="child"
                             uglcw-options="width:100, template: uglcw.util.template($('#ischild').html())">任务节点
                        </div>
                        <div data-field="cz"
                             uglcw-options="width:220, template: uglcw.util.template($('#vcz').html())">操作
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toadd();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-trash"></span>删除
    </a>
</script>
<script id="state-classification" type="text/x-kendo-template">
    #if(data.status=="1"){#
    <span style='color:blue'>进行中</span>
    #}else if(data.status=="2"){ #
    <span style='color:green'>完成</span>
    #}else if(data.status=="3"){#
    <span style='color:red'>草稿</span>
    #}#
</script>

<script id="ischild" type="text/x-kendo-template">
    #if(data.parentId>0){#
    <a href="javascript:showtask(1,'#=data.id#');" style='text-decoration:none;color: blue'>子</a>
    #}else{#
    #if(data.child==1){#
    <a href="javascript:showtask(2,'#=data.id#');" style='text-decoration:none;color: red;'>主</a>
    #}else{#
    <a style='text-decoration:none;color: black;'>主</a>
    #}#
    #}#
</script>
<script id="vcz" type="text/x-kendo-template">
    #if(data.status == 3){#
    <span style="color:grey;">进度历史</span>
    &nbsp;|&nbsp;<a href="javascript:toupdate('#=data.taskTitle#','#=data.id#','#=data.parentId #');"
                    style='text-decoration:none;color: blue;'>任务修改</a>
    #}else{#
    #var percent =data.percent;#
    #if(typeof(percent)=="undefined"){#
    #percent=0;#
    #}#
    <a href="javascript:detail('#=data.taskTitle#','#=data.id#','#=percent#');"
       style='text-decoration:none;color: blue;'>进度历史</a>
    &nbsp;|&nbsp;<a href="javascript:mod('#=data.taskTitle#','#=data.id#');" style='text-decoration:none;color: blue;'>任务详情</a>
    #if(data.status == 1){#
    &nbsp;|&nbsp; <a href="javascript:cuiban('#=data.id#');" style='text-decoration:none;color: blue;'>催办</a>
    #}#
    #}#
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


    // 查询主子任务 type=1查看主任务 2 查看子任务
    function showtask(type, taskId) {
        if (type == '1') {
            uglcw.ui.openTab('查看主任务', "${base}manager/topctaskdetail?type=" + type + "&taskId=" + taskId);
        } else if (type == '2') {
            uglcw.ui.openTab('查看子任务', "${base}manager/topctaskdetail?type=" + type + "&taskId=" + taskId);
        }

    }

    function toupdate(title, id, parentId) {//任务修改
        if (parentId > 0) {//子任务弹窗修改
            uglcw.ui.openTab(title + '：修改子任务', "${base}manager/toUpdateChild?taskId=" + id);
        } else {//主任务
            location.href = "${base}/manager/toupdatetask?id=" + id;
        }
    }

    function detail(title, id, percent) {//进度历史
        uglcw.ui.openTab(title + ':进度详情', '${base}manager/detailtaskfedd?id=' + id + '&percent=' + percent + '&title=' + title);

    }

    function mod(title, id) {//任务详情
        uglcw.ui.openTab(title + ':任务详情', '${base}manager/totaskbyid?id=' + id)

    }

    function cuiban(tid) {//催办
        $.ajax({
            url: '${base}manager/taskcbMsg',
            data: "tid=" + tid,
            type: "post",
            success: function (data) {
                alert(data.info);
            }
        });

    }

    function toDel() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('是否删除该任务以及子任务?', function () {
                $.ajax({
                    url: '${base}/manager/deltasks',
                    data: {
                        ids: selection[0].id
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        if (json) {
                            if (json == 1) {
                                uglcw.ui.success('删除成功');//错误提示
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            }
                        } else {
                            uglcw.ui.error('删除失败');
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择行！');
        }

    }

    function toadd() {//添加
        location.href = "${base}/manager/totaskadd";


    }
</script>
</body>
</html>
