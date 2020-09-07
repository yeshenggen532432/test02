<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-selector-container .uglcw-tree .k-in {
            padding: 2px 5px 2px 5px;
        }

        ul.app-menu.uglcw-radio.horizontal li {
            margin-top: 2px;
            margin-left: 2px;
        }

    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid" class="uglcw-grid-compact"
                 uglcw-options="
                    rowNumber: true,
                    lockable: false,
                    responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    loadFilter:{
                        data: function(resp){
                            return resp.data || []
                        }
                    },
                    id:'id',
                    url: '${base}manager/im/service',
                    pageable: false,
                    ">
                <div data-field="name">姓名</div>
                <div data-field="alias">昵称</div>
                <div data-field="avatar" uglcw-options="
                    template: function(row){
                        return row.avatar ? '<img style=\'width:40px;height:40px;\' src=\''+row.avatar+'\' />' : ''
                    }
                ">客服头像</div>
                <div data-field="no">客服编号</div>
                <div data-field="mobile">手机号</div>
                <div data-field="platform" uglcw-options="
                        template: uglcw.util.template($('#platform-tpl').html())
                ">推送平台</div>
                <div data-field="op" uglcw-options="
                                template: uglcw.util.template($('#operation').html())">操作
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card form">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input type="hidden" uglcw-model="userId" uglcw-role="textbox"/>
                    <label class="control-label col-xs-8">关联员工:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;"
                               uglcw-options="click: toSelectUser"
                               uglcw-model="name" uglcw-role="gridselector" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">客服工号:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="no" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">客服头像:</label>
                    <div class="col-xs-16">
                        <div uglcw-role="album"
                            uglcw-options="
                                cropper: 1,
                                aspectRatio: 1,
                                limit: 1,
                                multiple: false,
                                editable: true,
                                async:{
                                    saveUrl: '${base}manager/im/upload'
                                },
                                success: function(response){
                                    var data = response.data || {};
                                    return {
                                        thumb: '/upload' + data.name,
                                        url: '/upload' + data.name
                                    }
                                }
                            "
                        ></div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">客服昵称:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="alias" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">推送手机号:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="mobile" uglcw-role="textbox" uglcw-validate="required|mobile">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">推送平台:</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="platform" uglcw-options="layout:'horizontal', dataSource:[{text:'iOS', value:1},{text:'Android', value: 0}]">
                        </ul>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="platform-tpl">
   #if(data.platform==1){#
        <i class="k-icon ion-logo-apple"></i>
    #}else{#
   <i class="k-icon ion-logo-android"></i>
    #}#
</script>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:addService();">
        <span class="k-icon k-i-plus"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:refresh();">
        <span class="k-icon k-i-refresh"></span>刷新
    </a>
</script>
<script type="text/x-uglcw-template" id="operation">
    <button role="button" class="k-button k-button-icontext"
       onclick="editService(this);">
        <span class="k-icon k-i-edit"></span>编辑
    </button>
    <button role="button" class="k-button k-button-icontext"
       onclick="removeService(this);">
        <span class="k-icon k-i-trash"></span>删除
    </button>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })

    function toSelectUser() {
        uglcw.ui.Modal.showGridSelector({
            url: '${base}manager/memberPage?memberUse=1',
            columns: [
                {
                    field: 'memberNm',
                    title: '名称'
                },
                {
                    field: 'memberMobile',
                    title: '手机号码'
                }
            ],
            checkbox: false,
            yes: function (data) {
                if (data && data.length > 0) {
                    var member = data[0]
                    uglcw.ui.bind('.form', {
                        userId: member.memberId,
                        name: member.memberNm
                    })
                }
            }
        })
    }

    function addService() {
        uglcw.ui.Modal.open({
            title: '添加客服',
            content: $('#form').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var data = uglcw.ui.bind(c);
                var photos = uglcw.ui.get($(c).find('[uglcw-role=album]')).value();
                if(photos && photos.length > 0){
                    data.avatar = photos[0].url;
                }
                save(data);
            }
        })
    }

    function refresh(){
        uglcw.ui.get('#grid').reload();
    }

    function editService(el) {
        var grid = uglcw.ui.get('#grid');
        var row = grid.k().dataItem($(el).closest('tr'))
        uglcw.ui.Modal.open({
            title: '编辑客服【' + row.name + '】',
            content: $('#form').html(),
            success: function (c) {
                uglcw.ui.init(c);
                uglcw.ui.bind(c, row)
                if(row.avatar){
                    uglcw.ui.get($(c).find('[uglcw-role=album]')).value([{
                        url: row.avatar,
                        thumb: row.avatar
                    }]);
                }

            },
            yes: function (c) {
                var data = uglcw.ui.bind(c);
                var photos = uglcw.ui.get($(c).find('[uglcw-role=album]')).value();
                if(photos && photos.length > 0){
                    data.avatar = photos[0].url;
                }
                save(data);
            }
        })
    }

    function removeService(el) {
        var grid = uglcw.ui.get('#grid');
        var row = grid.k().dataItem($(el).closest('tr'))
        uglcw.ui.confirm('确定移除该客服吗?', function(){
            $.ajax({
                url: '${base}manager/im/service/remove/' + row.userId,
                type: 'post',
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.get('#grid').reload();
                    }
                }
            })
        })
    }

    function save(service) {
        $.ajax({
            url: '${base}manager/im/service',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify(service),
            success: function (response) {
                if (response.code == 200) {
                    uglcw.ui.get('#grid').reload();
                }
            }
        })
    }


</script>
</body>
</html>
