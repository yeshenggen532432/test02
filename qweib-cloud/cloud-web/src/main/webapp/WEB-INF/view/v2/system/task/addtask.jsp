<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-in {
            width: 100%;
            margin-right: 10px;
        }

        .control-label {
            text-align: right;
            width: 220px;
        }

        .sub-task .control-label {
            width: 120px;
        }

        .control-label:after {
            content: ":";
        }

        .control-item {
            vertical-align: bottom;
            margin-left: 10px;
            text-align: left;
            display: inline-flex;
        }

        .control-item .k-textbox {
            width: 200px;
        }

        .k-widget.k-upload {
            width: 400px;
        }

        .sub-task .k-upload {
            width: 250px;
        }

        .k-widget.k-upload .k-upload-files {
            height: 150px;
            overflow-y: auto;
        }

        .sub-task-item {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card master">
        <div class="layui-card-header  btn-group">
            <ul uglcw-role="buttongroup">
                <li onclick="save(3)" data-icon="save" class="k-info">存为草稿</li>
                <li onclick="save(1)" data-icon=" ion-md-paper-plane" class="k-info">发布</li>
            </ul>
        </div>
        <div class="layui-card-body">
            <div id="master-form" class="form-horizontal" style="padding-left: 20px;" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label required">标题</label>
                    <div class="control-item">
                        <input style="width: 200px;" uglcw-role="textbox" uglcw-model="taskTitle" value="${task.taskTitle}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label required">开始时间</label>
                    <div class="control-item">
                        <input style="width: 200px;" uglcw-options="format: 'yyyy-MM-dd HH:mm'" uglcw-model="startTime"
                               uglcw-role="datetimepicker"
                               id="dialog-startTimeStr"
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label required">结束时间</label>
                    <div class="control-item">
                        <input style="width: 200px;" uglcw-options="format: 'yyyy-MM-dd HH:mm'" uglcw-model="endTime"
                               uglcw-role="datetimepicker"
                               id="dialog-endTimeStr"
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label">任务提醒1</label>
                    <div class="control-item">
                        <input uglcw-role="slider" uglcw-options="min: 0, max:100, tooltip: { template: '#= value #%'}"
                               uglcw-model="remind1">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label ">提醒2</label>
                    <div class="control-item">
                        <input uglcw-role="slider" uglcw-options="min: 0, max:100, tooltip: { template: '#= value #%'}"
                               uglcw-model="remind2">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label">提醒3</label>
                    <div class="control-item">
                        <input uglcw-role="slider" uglcw-options="min: 0, max:100, tooltip: { template: '#= value #%'}"
                               uglcw-model="remind3">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label">提醒4</label>
                    <div class="control-item">
                        <input uglcw-role="slider" uglcw-options="min: 0, max:100, tooltip: { template: '#= value #%'}"
                               uglcw-model="remind4">
                    </div>
                </div>
                <div class="form-group">
                    <c:if test="${!empty parentId}">
                        <label class="control-label">所属父任务</label>
                        <div class="control-item">
                            <input uglcw-model="parentId" id="parentId" type="hidden" value="${parentId}">
                            <input uglcw-model="parentName" id="parentName" type="text" value="${parentName }"
                                   class="read">
                        </div>
                    </c:if>
                </div>
                <div class="form-group" style="margin-bottom: 10px;">
                    <label class="control-label required">执行人</label>
                    <div class="control-item">
                        <input uglcw-validate="required" uglcw-role="gridselector" uglcw-model="zreName,zreIds"
                               value="${usrNm}" uglcw-options="click:function(){
                            showUserSelector(this, 'zreIds', '执行人');
                        }">
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 10px;">
                    <label class="control-label">关注人</label>
                    <div class="control-item">
                        <input uglcw-role="gridselector" uglcw-model="gzrName,gzrIds" uglcw-options="
                        click: function(){
                            showUserSelector(this, 'gzrIds', '关注人');
                        }">
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 10px;">
                    <label class="control-label">内容描述</label>
                    <div class="control-item">
                        <div style="width: 400px">
                            <textarea uglcw-role="textbox" uglcw-model="taskMemo"></textarea>
                        </div>
                    </div>

                </div>
                <div class="form-group" style="margin-bottom: 10px;">
                    <label class="control-label">附件</label>
                    <div class="control-item">
                        <input id="files" style="width: 400px;" type="file" uglcw-role="upload"
                               uglcw-options="
                                    async:{
                                        saveUrl: '${base}manager/uploadFile',
                                        saveField: 'file',
                                        removeUrl: '${base}manager/doUnloadFile',
                                    },
                                    upload: function(e){
                                        e.data = {
                                            attTempId: '${attTempId}'
                                        }
                                    },
                                    success: function(e){
                                        var response = e.response;
                                        var file = e.files[0];
                                        if(response.status){
                                            var f = response.info[0];
                                            uglcw.extend(file, f);
                                        }
                                    },
                                    remove: function(e){
                                        var file = e.files[0];
                                        e.data = {
                                            attachmentId: file.id,
                                            attTempId: '${attTempId}'
                                        }
                                    }
                            "

                        >
                        <span style="color: gray;margin-left: 20px;">温馨提示：附件不能为(.exe .rar .zip)文件</span>
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 10px;">
                    <label class="control-label">添加子任务</label>
                    <div class="control-item">
                        <div class="sub-task-container">
                            <div class="sub-task-list" data-bind="source: subTasks"
                                 data-template="sub-task-item-tpl"></div>
                            <button onclick="addTask();" class="k-button k-info"><i class="k-icon k-i-add"></i></button>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="sub-task-item-tpl">
    <div class="sub-task-item">
        <input data-bind="attr: {id: uuid}" uglcw-role="gridselector" uglcw-options="icon:'k-i-add', click: function(){
                            addSubTask(this);
                        }">
        <button class="k-button k-error" data-bind="click: remove"><i class="k-icon k-i-trash"></i></button>
    </div>
</script>
<script type="text/x-uglcw-template" id="sub-task-tpl">
    <div class="layui-card-body">
        <div class="form-horizontal sub-task" style="padding-left: 20px;" uglcw-role="validator">
            <div class="form-group">
                <label class="control-label required">标题</label>
                <div class="control-item">
                    <input style="width: 200px;" uglcw-validate="required" uglcw-role="textbox" uglcw-model="taskTitle"
                           value="${task.taskTitle}">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label required">开始时间</label>
                <div class="control-item">
                    <input style="width: 200px;" uglcw-options="format: 'yyyy-MM-dd HH:mm'" uglcw-model="startTime"
                           uglcw-role="datetimepicker"
                           uglcw-validate="required">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label required">结束时间</label>
                <div class="control-item">
                    <input style="width: 200px;" uglcw-options="format: 'yyyy-MM-dd HH:mm'" uglcw-model="endTime"
                           uglcw-role="datetimepicker"
                           uglcw-validate="required">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label">任务提醒1</label>
                <div class="control-item">
                    <input uglcw-role="slider" uglcw-options="min: 0, max:100, tooltip: { template: '#= value #%'}"
                           uglcw-model="remind1">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label ">提醒2</label>
                <div class="control-item">
                    <input uglcw-role="slider" uglcw-options="min: 0, max:100, tooltip: { template: '#= value #%'}"
                           uglcw-model="remind2">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label">提醒3</label>
                <div class="control-item">
                    <input uglcw-role="slider" uglcw-options="min: 0, max:100, tooltip: { template: '#= value #%'}"
                           uglcw-model="remind3">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label">提醒4</label>
                <div class="control-item">
                    <input uglcw-role="slider" uglcw-options="min: 0, max:100, tooltip: { template: '#= value #%'}"
                           uglcw-model="remind4">
                </div>
            </div>
            <div class="form-group" style="margin-bottom: 10px;">
                <label class="control-label required">执行人</label>
                <div class="control-item">
                    <input uglcw-validate="required" uglcw-role="gridselector" uglcw-model="memberIds" value="${usrNm}"
                           uglcw-options="click:function(){
                             showUserSelector(this, 'zreIds', '执行人');
                        }">
                </div>
            </div>
            <div class="form-group" style="margin-bottom: 10px;">
                <label class="control-label">关注人</label>
                <div class="control-item">
                    <input uglcw-role="gridselector" uglcw-model="supervisorIds" uglcw-options="click: function(){
                            showUserSelector(this, 'gzrIds', '关注人');
                        }">
                </div>
            </div>
            <div class="form-group" style="margin-bottom: 10px;">
                <label class="control-label">内容描述</label>
                <div class="control-item">
                    <div style="width: 250px">
                        <textarea uglcw-role="textbox" uglcw-model="taskMemo"></textarea>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label style="width: 100px;"></label>
                <div class="control-item">
                    <span style="color: gray;margin-left: 20px;">温馨提示：附件不能为(.exe .rar .zip)文件</span>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label">附件</label>
                <div class="control-item">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="attTempId"/>
                    <input class="form-file" style="width: 250px;" type="file" uglcw-role="upload"
                           uglcw-options="
                                    async:{
                                        saveUrl: '${base}manager/uploadFile',
                                        saveField: 'file',
                                        removeUrl: '${base}manager/doUnloadFile',
                                    },
                                    upload: function(e){
                                        e.data = {
                                            attTempId: '${attTempId}'
                                        }
                                    },
                                    success: function(e){
                                        var response = e.response;
                                        var file = e.files[0];
                                        if(response.status){
                                            var f = response.info[0];
                                            uglcw.extend(file, f);
                                        }
                                    },
                                    remove: function(e){
                                        var file = e.files[0];
                                        e.data = {
                                            attachmentId: file.id,
                                            attTempId: '${attTempId}'
                                        }
                                    }
                            "

                    >
                </div>
            </div>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var vm;
    $(function () {
        uglcw.ui.init();

        vm = kendo.observable({
            subTasks: [],
            remove: function (e) {
                var index = this.subTasks.indexOf(e.data);
                uglcw.ui.confirm('确定删除吗?', function () {
                    vm.subTasks.splice(index, 1);
                })
            },
            add: function () {
                this.subTasks.push({uuid: uglcw.util.uuid()});
                var i = this.subTasks.length - 1;
                uglcw.ui.init('.sub-task-list .sub-task-item:eq(' + i + ')');
            }
        });
        kendo.bind($('.sub-task-list'), vm);
        uglcw.ui.loaded()
    });

    function addTask() {
        var data = uglcw.ui.bind('#master-form');
        if (!data.startTime || !data.endTime) {
            return uglcw.ui.warning('请输日期');
        }
        vm.add();
    }

    function addSubTask(sender) {
        var data = uglcw.ui.bind('#master-form');
        if (!data.startTime || !data.endTime) {
            return uglcw.ui.warning('请输日期');
        }
        uglcw.ui.Modal.open({
            title: '添加子任务',
            content: $('#sub-task-tpl').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var data = uglcw.ui.bind(c);
                var files = uglcw.ui.get($(c).find('.form-file')).k().getFiles();
                if (files && files.length > 0) {
                    data.attTempId = files[0].tempid; //disgusting!!!
                }
                sender.value(data.taskTitle);
                sender.text(JSON.stringify(data));
            }
        })
    }

    function showUserSelector(sender, model, title) {
        uglcw.ui.Modal.showGridSelector({
            title: '请选择' + title || '',
            url: '${base}manager/taskmempage',
            checkbox: false,
            btns: [],
            criteria: '<input placeholder="姓名" uglcw-role="textbox" uglcw-model="memberNm">' +
                '<input placeholder="手机号" uglcw-role="textbox" uglcw-model="memberMobile">' +
                '<input placeholder="公司" uglcw-role="textbox" uglcw-model="memberCompany">',
            columns: [
                {field: 'memberNm', title: '姓名', width: 100},
                {field: 'memberMobile', title: '手机', width: 120},
                {field: 'memberCompany', title: '公司', width: 150, tooltip: true},
                {field: 'memberJob', title: '职业', width: 100, tooltip: true},
                {field: 'memberTrade', title: '行业', width: 100, tooltip: true},
                {field: 'memberGraduated', title: '毕业院校', width: 100, tooltip: true},
                {field: 'memberHometown', title: '家乡', width: 100, tooltip: true}
            ],
            yes: function (e) {
                if (e && e.length > 0) {
                    sender.value(e[0].memberNm);
                    sender.text(e[0].memberId);
                }
            }
        })
    }

    function save(type) {
        var valid = uglcw.ui.get('#master-form').validate()
        if (!valid) {
            return;
        }
        var data = uglcw.ui.bindFormData('#master-form');
        $('.sub-task-list .sub-task-item').each(function () {
            var subtask = uglcw.ui.get($(this).find('[uglcw-role=gridselector]'));
            if (subtask.value()) {
                data.append('taskchild', subtask.text());
            }
        })
        var files = uglcw.ui.get('#files').k().getFiles();
        if (files && files.length > 0) {
            data.append('attTempId', files[0].tempid);
        }
        data.append('type', type);
        $.ajax({
            url: '${base}manager/addTaskAndChild',
            type: 'post',
            data: data,
            processData: false,
            contentType: false,
            success: function (code) {
                if (code === '1') {
                    uglcw.ui.success('保存成功');
                }
            }
        })
    }
</script>
</body>
</html>
