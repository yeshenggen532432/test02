<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-scheduler-dayview .k-event-template {
            padding: .1em 1.4em .1em .6em;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px;">
            <div class="layui-card">
                <div class="layui-card-header">
                    部门
                </div>
                <div class="layui-card-body">
                    <div uglcw-role="tree" style="height: 590px;"
                         uglcw-options="
                    url: '${base}manager/departs?depart=${depart}&dataTp=1',
                    initLevel: 1,
                    select: function(e){
                        var department = this.dataItem(e.node);
                        uglcw.ui.get('#branchId').value(department.id);
                        uglcw.ui.get('#grid').reload();
                    }">
                    </div>
                </div>
            </div>

        </div>
        <div class="" style="width: 200px;">
            <div class="layui-card">
                <div class="layui-card-header">员工</div>
                <div class="layui-card-body full">
                    <div class="query">
                        <input uglcw-role="textbox" uglcw-model="branchId" type="hidden" id="branchId"/>
                        <input uglcw-role="textbox" uglcw-model="memberUse" type="hidden" value="1"/>
                    </div>
                    <div id="grid" uglcw-role="grid" uglcw-options="
                        url: '${base}manager/kqrule/queryKqEmpRulePage',
                        pageable: false,
                        criteria: '.query',
                        height: 610,
                        checkbox: true,
                        click: function(row){
                            uglcw.ui.get('#memberId').value(row.memberId);
                            var scheduler = $('#scheduler').data('kendoScheduler');
                            scheduler.dataSource.read();
                        },
                        dblclick: function(row){
                            uglcw.ui.get('#memberId').value(row.memberId);
                            var scheduler = $('#scheduler').data('kendoScheduler');
                            scheduler.dataSource.read();
                        }">
                        <div data-field="memberNm" uglcw-options="width:'auto'">姓名</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body" style="font-size: 12px">
                    <ul class="uglcw-query">
                        <li>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberId" id="memberId"/>
                            <input id="sdate" uglcw-role="datepicker" uglcw-model="sdate" value="${sdate}"/>
                        </li>
                        <li>
                            <input id="edate" uglcw-role="datepicker" uglcw-model="edate" value="${edate}"/>
                        </li>
                        <li style="width: 300px !important;">
                            <button class="k-button k-info" onclick="search()"><i class="k-icon k-i-search"></i>查询
                            </button>
                            <button class="k-button k-info" onclick="clear()"><i class="k-icon k-i-reset"></i>清空选择
                            </button>
                            <button class="k-button k-info" onclick="remove()"><i class="k-icon k-i-delete"></i>删除排班
                            </button>
                        </li>
                        <li style="margin-left: 20px; width: 250px;">
                            <span style="color: red;">注：如果有分配规则班和排班，则以排班为准</span>
                        </li>
                    </ul>
                </div>
                <div class="layui-card-body full">
                    <ul id="contextMenu"></ul>
                    <div id="scheduler" uglcw-role="scheduler"
                         uglcw-options="
                             selectable: true,
                             views:[
                              {type:'day', editable: false, allDaySlot: false},
                              {type:'month', selected: true, editable: false},
                              {type:'agenda', editable: false}
                              ],
                             criteria: '.btn-group',
                             url: '${base}/manager/kqpb/queryKqPbPage',
                             loadFilter:{
                                data:function(response){
                                    var data = response.rows || [];
                                    return $.map(data, function(row){
                                        row.start = new Date(row.bcDate);
                                        row.end = new Date(row.bcDate);
                                        row.title = row.memberNm+': '+row.bcName;
                                        return row;
                                    });
                                }
                             }
                        "
                    ></div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var scheduleList = [];
    var contextMenus = [{
        attr: {
            'data-bc-id': -1,
        }, text: '不排班', cssClass: 'schedule-skip'
    }, {
        attr: {
            'data-bc-id': 0,
        },
        text: '休',
        cssClass: 'schedule-none'
    }];
    $(function () {
        uglcw.ui.init();
        loadScheduleList();
        $('#contextMenu').kendoContextMenu({
            filter: ".k-scheduler-monthview .k-event, .k-scheduler-monthview .k-scheduler-table td",
            target: "#scheduler",
            dataSource: contextMenus,
            showOn: 'click',
            select: function (e) {
                var target = $(e.target);
                var scheduler = uglcw.ui.get('#scheduler').k();
                var grid = uglcw.ui.get('#grid');
                var selection = grid.selectedRow();
                if (!selection || selection.length < 1) {
                    return uglcw.ui.warning('请选择员工');
                }
                var slot = scheduler.slotByElement(target);
                var bcDate = uglcw.util.toString(slot.startDate, 'yyyy-MM-dd');
                var bcId = $(e.item).data('bc-id');
                $.ajax({
                    url: '${base}manager/kqpb/saveBatKqPb',
                    type: 'post',
                    data: {
                        dateStr: bcDate,
                        empStr: $.map(selection, function (member) {
                            return member.memberId
                        }).join(','),
                        bcId: bcId
                    },
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success('排班成功');
                            uglcw.ui.get('#scheduler').reload();
                        }
                    }
                });
            },
            open: function (e) {
                var menu = e.sender;
            }
        });
        uglcw.ui.loaded();
    });

    function loadScheduleList() {
        $.ajax({
            url: '${base}manager/bc/queryKqBcPage',
            type: 'get',
            async: false,
            data: {status: 1},
            dataType: 'json',
            success: function (response) {
                if (response.state) {
                    scheduleList = response.rows || [];
                    $.map(scheduleList, function (schedule) {
                        contextMenus.push({
                            attr: {
                                'data-bc-id': schedule.id
                            },
                            bcId: schedule.id,
                            text: schedule.bcName
                        });
                    })
                }
            }
        })
    }

    /**
     * 查询月份内所有员工的信息
     */
    function search() {
        uglcw.ui.get('#memberId').value('');
        uglcw.ui.get('#grid').clearSelection();
        uglcw.ui.get('#scheduler').reload();
    }

    function remove() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection || selection.length < 1) {
            return uglcw.ui.warning('请选择员工');
        }
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/kqpb/deleteKqPb',
            type: 'post',
            data: {
                ids: $.map(selection, function (member) {
                    return member.memberId
                }).join(','),
                sdate: uglcw.ui.get('#sdate').value(),
                edate: uglcw.ui.get('#edate').value()
            },
            success: function (response) {
                uglcw.ui.loaded();
                if (response.state) {
                    uglcw.ui.success('删除成功');
                    uglcw.ui.get('#scheduler').reload();
                } else {
                    uglcw.ui.error('删除失败');
                }
            },
            error: function () {
                uglcw.ui.loaded();
            }
        })
    }
</script>
</body>
</html>
