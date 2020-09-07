<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>限时促销价设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        #member-range-tabs .k-tabstrip-items {
            display: none;
        }

        .el-tag {
            margin-right: 3px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query query">
                <li>
                    <input uglcw-model="sourceType" uglcw-role="textbox" value="${sourceType}" style="display:none;">
                    <input uglcw-model="title" uglcw-role="textbox" placeholder="请输入活动名称">
                    <input uglcw-model="state" id="state" uglcw-role="textbox" style="display:none;">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="state" placeholder="状态"
                            uglcw-options="value:'10'">
                        <option value="10">未结束</option>
                        <c:forEach items="${statusMap}" var="map">
                            <option value="${map.key}">${map.value}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <button uglcw-role="button" class="k-info" id="btn-search">搜索</button>
                    <button uglcw-role="button" id="btn-reset">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
						    responsive:['.header',40],
                            <c:if test="${reward.state ==null}">toolbar: uglcw.util.template($('#toolbar').html()),</c:if>
							id:'id',
							rowNumber: true,
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/mall/promotion/activity/queryPage',
                    		loadFilter: {
                    		    data: function(response){
                    		        var rows= response.state ? (response.rows || []) : [];
                    		        rows.map(function(data){data.status=data.state});
                    		        return rows;
                    		    }
                    		},
                    		data: function(param){
                    		    param.page = param.page ;
                    		    param.size = param.pageSize;
                    		    uglcw.extend(param, uglcw.ui.bind('.query'))
                    		    return param;
                    		},
                    		dataBound: function(){
                    		    uglcw.ui.init('#grid')
                    		}
                    	">
                <div data-field="title" uglcw-options="width:250, template: uglcw.util.template($('#title-tpl').html())">
                    活动名称
                </div>
                <div data-field="startTime" uglcw-options="width:200, template: uglcw.util.template($('#time-tpl').html())">
                    活动时间
                </div>

                <!--<div data-field="member-setting"
                     uglcw-options="width:100, template: uglcw.util.template($('#member-op-tpl').html())">会员设置
                </div>-->
                <%--<div data-field="createTime"
                     uglcw-options="width:150, template: '#= uglcw.util.toString(new Date(data.createTime), \'yyyy-MM-dd HH:mm\')#'">
                    创建时间
                </div>--%>
                <%--<div data-field="status" uglcw-options="width:100, template: uglcw.util.template($('#status').html())">启用状态</div>--%>

                <%--<div data-field="description" uglcw-options="width:350,tooltip: true">备注</div>--%>
                <div data-field="state"
                     uglcw-options="width:150,template: uglcw.util.template($('#g_status_tpl').html())
                    ">开/关状态
                </div>
                <div data-field="runState"
                     uglcw-options="width:150, template: uglcw.util.template($('#g_runState_tpl').html())">运行状态
                </div>
                <div data-field="opt"
                     uglcw-options="width:200,template: uglcw.util.template($('#g_opt_tpl').html())"><%--(data:{status:data.state})--%>
                    操作
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="title-tpl">
    <button class="k-button" onclick="edit(#= data.id#,'#= data.title#');">#= data.title#</button>
</script>


<script type="text/x-uglcw-template" id="member-op-tpl">
    <button class="k-button" onclick="showMemberSetting(#= data.id#, '#= data.title#')">会员设置</button>
</script>


<script type="text/x-uglcw-template" id="time-tpl">
    <span>#= uglcw.util.toString(new Date(data.startTime), 'MM-dd HH:mm')#</span>
    <span> 到 </span>
    <span>#= uglcw.util.toString(new Date(data.endTime), 'MM-dd HH:mm')#</span>
</script>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:updateStatusEnd();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>结束活动
    </a>
    <%-- <a role="button" href="javascript:del();" class="k-button k-button-icontext">
         <span class="k-icon k-i-delete"></span>删除
     </a>--%>
</script>


<script id="member-settings-tpl" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body" style="padding: 0;">
            <ul uglcw-role="radio" uglcw-model="memberRangeType" uglcw-options="
            dataSource:[{text: '所有会员', value: 0}, <c:if test="${sourceType ==1}">{text: '指定会员类型', value: 1},</c:if>{text: '指定会员等级', value: 2},{text: '指定会员', value: 3}],
            change: function(v){
                uglcw.ui.get('#member-range-tabs').select(v);
            }
            "></ul>
            <div id="member-range-tabs" uglcw-role="tabs" uglcw-model="memberRangeType">
                <ul>
                    <li>所有会员</li>
                    <li>指定会员类型</li>
                    <li>指定会员等级</li>
                    <li>指定会员</li>
                    <li>请选择</li>
                </ul>
                <div>
                    <span style="color: #444;">全体会员可参与本次活动</span>
                </div>
                <div>
                    <select uglcw-model="memberTypeIds" uglcw-role="multiselect"
                            uglcw-options="autoClose: false, placeholder: '请选择会员类型', stringify: false"
                            placeholder="请选择会员类型">
                        <option value="1">常规会员</option>
                        <option value="2">员工会员</option>
                        <%--<option value="3">进销存会员</option>--%>
                        <option value="4">门店会员</option>
                    </select>
                </div>
                <div>
                    <select uglcw-model="memberLevelIds" uglcw-role="multiselect"
                            uglcw-options="
                            stringify: false,
                            dataTextField: 'gradeName',
                            dataValueField: 'id',
                            placeholder: '请选择会员等级',
                            url: '${base}manager/shopMemberGrade/page?isJxc=${sourceType==3?1:0}',
                            data: function(){
                                return {rows:50,page: 1, status: 1}
                            },
                            loadFilter: {
                                data: function(response){
                                    return response.rows || [];
                                }
                            }
                        "
                    >
                    </select>
                </div>
                <div>
                    <div id="grid-member" uglcw-role="grid" uglcw-model="members" uglcw-options="
                        pageable: false,
                        height: 350,
                        checkbox: true,
                        rowNumber: true,
                        id: 'id',
                        toolbar: uglcw.util.template($('#member-settings-toolbar').html())
                        ">
                        <div data-field="name" uglcw-options="width:'auto'">会员名称</div>
                        <div data-field="mobile" uglcw-options="width:'auto'">电话</div>
                        <div data-field="pic"
                             uglcw-options="width:'auto',  template: uglcw.util.template($('#avatar-tpl').html())">头像
                        </div>
                        <div data-field="nickname" uglcw-options="width:'auto'">昵称</div>
                        <div data-field="op" uglcw-options="command: 'destroy', width: 'auto'">操作</div>
                    </div>
                </div>
                <div>请选择</div>
            </div>
        </div>
    </div>
</script>
<script id="member-settings-toolbar" type="text/x-uglcw-template">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:selectMember();">
        <span class="k-icon k-i-search"></span>选择会员
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:removeMember();">
        <span class="k-icon k-i-trash"></span>批量删除
    </a>
</script>
<script id="member-selector-tpl" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="member-query">
                <input type="hidden" uglcw-role="textbox" uglcw-model="source" value="1">
            </div>
            <div uglcw-role="tabs" uglcw-lazy="true" uglcw-options="select: function(e){
                uglcw.ui.bind('.member-query',{ source: $(e.item).data('source')});
                var grid = $('#grid-member-selector').data('kendoGrid')
                if(grid){
                    uglcw.ui.get('#grid-member-selector').reload({page: 1});
                }
            }">
                <ul>
                    <c:if test="${sourceType==1}">
                        <li data-source="1">常规会员</li>
                        <li data-source="2">员工会员</li>
                        <li data-source="4">门店会员</li>
                    </c:if>
                    <c:if test="${sourceType==3}">
                        <li data-source="3">进销存客户</li>
                    </c:if>
                </ul>
            </div>
            <div id="grid-member-selector" uglcw-role="grid"
                 uglcw-options="
                    height: 350,
                    id:'id',
                    pageable: true,
                    url: '${base}manager/shopMember/shopMemberPage',
                    checkbox: true,
                    criteria: '.member-query'
                "
            >
                <div data-field="name" uglcw-options="width:'auto'">会员名称</div>
                <div data-field="mobile" uglcw-options="width:'auto'">电话</div>
                <div data-field="pic" uglcw-options="width:'auto', template: uglcw.util.template($('#avatar-tpl').html())">
                    头像
                </div>
                <div data-field="nickname" uglcw-options="width:'auto'">昵称</div>
            </div>
        </div>
    </div>
</script>
<script id="avatar-tpl" type="text/x-uglcw-template">
    #if(data.pic){#
    <img src="#= data.pic#" style="width: 50px;height:50px;"/>
    #}#
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/shop_promotion_status_include.jsp" %>
<script>
    //修改状态
    var editStatusUrl = "manager/mall/promotion/activity/updateState";
    $(function () {
        //ui:初始化
        uglcw.ui.init();
        $('#btn-search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });
        $('#btn-reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        });
        uglcw.ui.loaded();

        $('#tabs li').on('click', function (item) {
            var value = $(this).attr("value");
            uglcw.ui.get('#state').value(value);
            uglcw.ui.get('#grid').reload();
        })

        uglcw.io.on('shop_activity_chage', function (data) {
            location.href = location.href;
        });
    })

    function showMemberSetting(id, title) {
        uglcw.ui.Modal.open({
            title: '[' + title + '] - 会员设置',
            content: $('#member-settings-tpl').html(),
            area: '650px',
            success: function (c) {
                uglcw.ui.init(c);
                uglcw.ui.loading(c);
                $.ajax({
                    url: '${base}manager/mall/promotion/activityMembership/detail/' + id + '/members',
                    type: 'get',
                    success: function (response) {
                        uglcw.ui.loaded(c);
                        if (response.state) {
                            var members = response.obj;
                            uglcw.ui.bind(c, members);
                        } else {
                            uglcw.ui.error(response.message);
                            uglcw.ui.Modal.close();

                        }
                    },
                    error: function () {
                        uglcw.ui.loaded(c);
                    }
                })
            },
            yes: function (c) {
                var data = uglcw.ui.bind(c);
                if(data.memberRangeType==4){
                    uglcw.ui.error('请选择');
                    return false;
                }
                data.rewardId = id;
                data.memberIds = $.map((data.members || []), function (m) {
                    return m.id;
                });
                $.ajax({
                    url: '${base}/manager/mall/promotion/activityMembership/saveMembers',
                    type: 'post',
                    data: JSON.stringify(data),
                    contentType: 'application/json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success(response.message);
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error(response.message);
                        }
                    }
                })

            }

        })
    }

    function selectMember() {
        uglcw.ui.Modal.open({
            title: '请选择会员',
            area: '650px',
            content: $('#member-selector-tpl').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var rows = uglcw.ui.get($(c).find('.uglcw-grid')).selectedRow();
                if (rows && rows.length > 0) {
                    var check = function (source, target, idName) {
                        var hit = false;
                        $(source).each(function (i, item) {
                            if (item[idName] === target[idName]) {
                                hit = true;
                                return false;
                            }
                        });
                        return hit;
                    };
                    var source = uglcw.ui.get('#grid-member').value();
                    $(rows).each(function (j, row) {
                        if (!check(source, row, 'id')) {
                            uglcw.ui.get('#grid-member').addRow(row);
                        }
                    })
                }
            }
        })
    }

    function removeMember() {
        uglcw.ui.confirm('确定删除所选会员吗', function () {
            uglcw.ui.get('#grid-member').removeSelectedRow(true);
        });
    }

    function onMemberSelect() {

    }

    function loadMemberLevels(callback) {
        $.ajax({
            url: '${base}manager/shopMemberGrade/page',
            type: 'get',
            dataType: 'json',
            data: {rows: 50, page: 1, status: 1},
            success: function (response) {
                callback(response.rows || []);
            }
        })
    }

    //添加
    function add() {
        uglcw.ui.openTab('添加${sourceType==1?"零售":"批发"}活动', '${base}manager/mall/promotion/activity/detail?sourceType=${sourceType}');
    }

    //修改
    function edit(id, title) {
        if (!id) {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (!selection || selection.length < 1) {
                return uglcw.ui.toast("请勾选你要操作的行！");
            }
            id = selection[0].id;
            title = selection[0].title;
        }
        uglcw.ui.openTab(title, '${base}manager/mall/promotion/activity/detail?_sticky=v2&id=' + id);
    }

    //删除(单个)
    function del(id, status) {
        if (!id) {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (!selection || selection.length < 1) {
                return uglcw.ui.warning('请选择要删除的活动！');
            }
            id = selection[0].id;
            status = selection[0].status;
        }
        if (status !== 2) {
            return uglcw.ui.error('请先终止活动')
        }
        uglcw.ui.confirm("确定删除所选活动吗？", function () {
            $.ajax({
                url: "${base}manager/mall/promotion/activity/" + id,
                type: 'delete',
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message || "操作失败");
                    }
                }
            });
        })
    }


</script>
</body>
</html>
