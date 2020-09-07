<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>特殊出勤设置-考勤补签</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>

        .pic-container {
            display: inline-flex;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card full">
                <div class="layui-card-header">部门-员工</div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:[75]">
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
                            <input uglcw-model="psnId" id="memberId" uglcw-role="textbox" type="hidden">
                            <input uglcw-model="memberUse" id="memberUse" uglcw-role="textbox" type="hidden" value="1">
                            <input uglcw-model="dataTp" id="dataTp" uglcw-role="textbox" type="hidden" value="1">

                            <input uglcw-model="atime" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="btime" uglcw-role="datepicker" value="${edate}">
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
                    		url: '${base}manager/checkInPage',
                    		criteria: '.query',
                    		<%--dataTp=${dataTp}--%>
                    	">
                        <div data-field="branchNm" uglcw-options="width:100">部门</div>
                        <div data-field="memberNm" uglcw-options="width:100">姓名</div>
                        <div data-field="cdate" uglcw-options="width:150,template: uglcw.util.template($('#cdate').html())">
                            工作日期
                        </div>
                        <div data-field="location" uglcw-options="width:300">地址</div>
                        <div data-field="stime" uglcw-options="width:100">上班时间</div>
                        <div data-field="etime" uglcw-options="width:100">下班时间</div>
                        <div data-field="cdzt" uglcw-options="width:100">考勤状态</div>
                        <div data-field="picList" uglcw-options="width:100,template: uglcw.util.template($('#formatterSt').html())">签到拍照</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-add"></span>添加补签
    </a>
    <a role="button" href="javascript:del();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>删除补签
    </a>
    <a role="button" href="javascript:edit();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>校正考勤位置
    </a>
    <span>&nbsp;&nbsp;注：补签或较正后需要重新计算考勤</span>
</script>
<script id="formatterSt" type="text/x-kendo-template">
    <div class="pic-container">
        #for (var i=0; i
        <data.picList.length
                ;i++){#
                # var pic=data.picList[i];#
        <div class="pic-item">
            <a href="javascript:void(0);" onclick="preview(this, #= i#)">
                <img src="/upload/#= pic.picMin#" style="height: 80px;">
            </a>
        </div>
        #}#
    </div>
</script>
<%--启用状态--%>
<script id="cdate" type="text/x-uglcw-template">
    # var dtime=data.cdate; #
    # var dateweek = data.dateweek; #
    # if(dateweek==1){ #
    # dtime+=' 星期日'; #
    # }else if(dateweek==2){ #
    # dtime+=' 星期一'; #
    # }else if(dateweek==3){ #
    # dtime+=' 星期二'; #
    # }else if(dateweek==4){ #
    # dtime+=' 星期三'; #
    # }else if(dateweek==5){ #
    # dtime+=' 星期四'; #
    # }else if(dateweek==6){ #
    # dtime+=' 星期五'; #
    # }else if(dateweek==7){ #
    # dtime+=' 星期六'; #
    # } #
    <span>#= dtime #</span>


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
                    <label class="control-label col-xs-6">类型</label>
                    <div class="col-xs-16">
                        <select id="tp" uglcw-model="tp" uglcw-role="combobox">
                            <option value="1-1">上班</option>
                            <option value="1-2">下班</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">时间</label>
                    <div class="col-xs-16">
                        <input uglcw-model="startTime" uglcw-role="datetimepicker" id="startTime">
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

    function preview(a, index) {
        var row = uglcw.ui.get('#grid').k().dataItem($(a).closest('tr'));
        layer.photos({
            photos: {
                start: index, data: $.map(row.picList, function (item) {
                    return {
                        src: '/upload/' + item.pic,
                        pid: uglcw.util.uuid(),
                        thumb: '/upload/' + item.picMin
                    }
                })
            }, anim: 5
        });
    }

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
                var tp = uglcw.ui.get('#tp').value();
                var checkTime = uglcw.ui.get('#startTime').value();
                var remarks = uglcw.ui.get('#remarks1').value();
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/manuAddCheckIn',
                    type: 'post',
                    data: {"psnId": memberId, "tp": tp, "checkTime": checkTime, "remark": remarks},
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
                    }
                })
                return false;
            }
        })
    }

    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var ids;
            for (var i = 0; i < selection.length; i++) {
                if (selection[i].cdzt != "补签") {
                    uglcw.ui.toast("只能删除补签记录");
                    return;
                }
                if (i == 0) ids = selection[i].id;
                else ids = ids + "," + selection[i].id;
            }
            uglcw.ui.confirm("确定删除所选记录吗？", function () {
                $.ajax({
                    url: "${base}manager/deleteCheckIn",
                    data: {
                        ids: ids
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success("删除成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error("删除失败");
                        }
                    }
                });
            })
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //较正
    function edit() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
                $.ajax({
                    url: "${base}manager/chgCheckInPos",
                    data: {
                        checkId: selection[0].id
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success("校正成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error("校正失败");
                        }
                    }
                });
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }
</script>
</body>
</html>
