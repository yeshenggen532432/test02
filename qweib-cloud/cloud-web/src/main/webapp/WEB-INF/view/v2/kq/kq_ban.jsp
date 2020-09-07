<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>特殊出勤设置-加班</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-header">部门-员工</div>
                <div class="layui-card-body" uglcw-options="responsive:[75]" uglcw-role="resizable">
                    <div uglcw-role="tree" id="tree"
                         uglcw-options="
							   lazy:false,
							   expandable: function (node) {
									return false
								},
							   url: '${base}manager/queryDepartMemberTree?dataTp=1',
							   select: function(e){
								  var node = this.dataItem(e.node);
								  var memberId = node.memberId;
								  if(memberId==null || memberId==undefined){
								  	uglcw.ui.get('#memberId').value('');
								  }else{
								  	uglcw.ui.get('#memberId').value(node.memberId);
								  }
								  var branchId = node.branchId;
								  if(branchId==null || branchId==undefined){
								  	uglcw.ui.get('#branchId').value('');
								  }else{
								  	uglcw.ui.get('#branchId').value(node.branchId);
								  }
								  uglcw.ui.get('#grid').reload();
								}
							">
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal query">
                        <li>
                            <input uglcw-model="branchId" id="branchId" uglcw-role="textbox" type="hidden">
                            <input uglcw-model="memberId" id="memberId" uglcw-role="textbox" type="hidden">
                            <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="姓名/手机号码">
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
                         uglcw-options="
						    responsive:['.header',40],
						 	toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable:{
								pageSize: 20
							},
                    		url: '${base}manager/kqban/queryKqBanPage',
                    		criteria: '.query',
                    	">
                        <div data-field="memberNm" uglcw-options="width:100">姓名</div>
                        <div data-field="banNm" uglcw-options="width:100">加班类型</div>
                        <div data-field="banDateStr" uglcw-options="width:100">加班申请日期</div>
                        <div data-field="startTime" uglcw-options="width:150">开始时间</div>
                        <div data-field="endTime" uglcw-options="width:150">结束时间</div>
                        <div data-field="hours" uglcw-options="width:100">加班小时数</div>
                        <div data-field="remarks" uglcw-options="width:100">备注</div>
                        <div data-field="operator" uglcw-options="width:100">操作员</div>
                        <div data-field="status"
                             uglcw-options="width:100,template: uglcw.util.template($('#status').html())">状态
                        </div>
                        <div data-field="ope" uglcw-options="width:100,template: uglcw.util.template($('#ope').html())">操作
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-add"></span>添加加班
    </a>
</script>

<%--启用状态--%>
<script id="status" type="text/x-uglcw-template">
    <span>#= data.status == '0' ? '正常' : '作废' #</span>
</script>
<%--启用操作--%>
<script id="ope" type="text/x-uglcw-template">
    # if(data.ope == 0){ #
    <button onclick="javascript:updateStatus(#= data.id#);" class="k-button k-info">作废</button>
    # } #
</script>

<%--添加请假--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                <div class="form-group">
                    <label class="control-label col-xs-6">加班类型</label>
                    <div class="col-xs-16">
                        <select id="banNm" uglcw-model="banNm" uglcw-role="combobox">
                            <%--<option value=""></option>--%>
                            <option value="平时加班">平时加班</option>
                            <option value="周末加班">周末加班</option>
                            <option value="假日加班">假日加班</option>
                            <option value="任务加班">任务加班</option>
                            <option value="其它1">其它1</option>
                            <option value="其它2">其它2</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">参考班次</label>
                    <div class="col-xs-16">
                        <tag:select2 name="bcId" id="bcId" tableName="kq_bc" headerKey="" whereBlock="status=1"
                                     headerValue="--选择班次--" displayKey="id" displayValue="bc_name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">开始时间</label>
                    <div class="col-xs-16">
                        <input uglcw-model="startTime" uglcw-role="datetimepicker" id="startTime">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">结束时间</label>
                    <div class="col-xs-16">
                        <input uglcw-model="endTime" uglcw-role="timepicker" id="endTime">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-16">
                        <input uglcw-model="remarks1" id="remarks1" uglcw-role="textbox" placeholder="">
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.layout.init();
        var i = 0;
        if (i == undefined) ;

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })

    //--------------------------------------------------------------------------------------------------------------
    //添加
    function add() {
        var memberId = uglcw.ui.get('#memberId').value();
        if (memberId == null || memberId == undefined || memberId == '') {
            uglcw.ui.toast("请选择员工")
            return;
        }
        uglcw.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                // if (row) {
                // 	uglcw.ui.bind($(container), row);
                // }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                // var data = uglcw.ui.bind($(container).find('form'));
                var banNm = uglcw.ui.get('#banNm').value();
                var bcId = uglcw.ui.get('#bcId').value();
                var startTime = uglcw.ui.get('#startTime').value();
                var endTime = uglcw.ui.get('#endTime').value();
                var remarks = uglcw.ui.get('#remarks1').value();
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/kqban/addKqBan',
                    type: 'post',
                    data: {
                        "memberId": memberId,
                        "banNm": banNm,
                        "startTime": startTime,
                        "endTimeStr": endTime,
                        "remarks": remarks,
                        "bcId": bcId
                    },
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp.state) {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else {
                            uglcw.ui.error('添加失败');
                        }
                        // if (resp === '1') {
                        // 	uglcw.ui.success('添加成功');
                        // 	uglcw.ui.get('#grid').reload();
                        // 	uglcw.ui.Modal.close();
                        // } else if (resp === '2') {
                        // 	uglcw.ui.success('修改成功');
                        // 	uglcw.ui.get('#grid').reload();
                        // 	uglcw.ui.Modal.close();
                        // } else if (resp === '3') {
                        // 	uglcw.ui.error('会员等级名称已存在');
                        // } else {
                        // 	uglcw.ui.error('操作失败');
                        // }
                    }
                })
                return false;
            }
        })
    }
</script>
</body>
</html>
