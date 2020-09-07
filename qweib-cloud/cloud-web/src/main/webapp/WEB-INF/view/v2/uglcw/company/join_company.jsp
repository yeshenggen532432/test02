<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
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
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query query">
                <%--<input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">--%>
                <li>
                    <input uglcw-model="memberName" uglcw-role="textbox" placeholder="申请人名称">
                </li>
                <li>
                    <input uglcw-model="memberMobile" uglcw-role="textbox" placeholder="申请人电话">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="申请状态"
                            uglcw-options="value:'', tooltip: '申请状态'">
                        <option value="">全部</option>
                        <option value="1">同意</option>
                        <option value="2">拒绝</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}" uglcw-options="tooltip:'开始时间'">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}" uglcw-options="tooltip:'结束时间'">
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
                    checkbox: true,
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    responsive:['.header',40],
                    id:'id',
                    url: '${base}manager/company/queryCompanyJoinPage',
                    criteria: '.uglcw-query',
                    pageable: true,
                    ">
                <div data-field="memberName" uglcw-options="width:160">申请人</div>
                <div data-field="memberMobile" uglcw-options="width:120">申请人电话</div>
                <div data-field="createTime" uglcw-options="width:160">申请时间</div>
                <div data-field="status"
                     uglcw-options="width:160, template: uglcw.util.template($('#status').html())">申请状态
                </div>
                <div data-field="userName" uglcw-options="width:120">操作人</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="status">
    # if(data.status=='1'){ #
    同意
    #}else if(data.status=='2'){#
    拒绝
    #}else{#
    <button class="k-button k-info" onclick="updateStatus(#=data.id#, #=data.memberId#, #= 1#)">同意</button>
    <button class="k-button k-info" onclick="updateStatus(#=data.id#, #=data.memberId#, #= 2#)">拒绝</button>
    #}#
</script>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-trash"></span>删除
    </a>
</script>

<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-8">角色选择:</label>
                    <div class="col-xs-16">
                        <select style="width: 200px;" uglcw-role="dropdowntree" uglcw-model="roleIds"
                                uglcw-options="
                                  checkboxes: true,
                                  checkAll: true,
                                  url: '${base}manager/queryRoleList',
                                  loadFilter:{
                                    data: function(response){return response.row ||[];}
                                  },
                                  dataTextField: 'roleNm',
                                  dataValueField: 'idKey'
                                ">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">部门:</label>
                    <div class="col-xs-16">
                        <select style="width: 200px;" uglcw-role="dropdowntree" uglcw-model="branchId"
                                uglcw-options="
                                initLevel: 1,
                                url: '${base}manager/departs?dataTp=1',
                                ">
                        </select>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<script>

    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
            ;
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query');
        })

        uglcw.ui.loaded()
    })

    function updateStatus(id, memberId, agree) {
        var content;
        if(1 == agree){
            var modal = uglcw.ui.Modal.open({
                title: '同意加入公司',
                content: uglcw.util.template($('#form').html())({}), //打开之前渲染获取密码值
                success: function (container) {
                    uglcw.ui.init($(container));
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('form')).validate();
                    if (!valid) {
                        return false;
                    }
                    var data = uglcw.ui.bind($(container).find('form'));

                    if (!data.branchId) {
                        uglcw.ui.warning('请选择部门');
                        return false;
                    }
                    $.ajax({
                        url: "${base}manager/company/updateStatusCompanyJoin",
                        type: "post",
                        data: "id=" + id + "&memId="+ memberId + "&agree="+agree+ "&roleIds="+data.roleIds+ "&branchId="+data.branchId,
                        success: function (data) {
                            doResult(data, modal)
                        }
                    })
                    return false;
                }
            })
        }else{
            content =  '您确认不同意加入吗？'
            uglcw.ui.confirm(content, function () {
                $.ajax({
                    url: "${base}manager/company/updateStatusCompanyJoin",
                    type: "post",
                    data: "id=" + id + "&memId="+ memberId + "&agree="+agree,
                    success: function (data) {
                        doResult(data, null)
                    }
                });
            });
        }
    }

    //处理返回结果
    function doResult(data, modal) {
        if (data == "1") {
            uglcw.ui.success('操作成功');
            uglcw.ui.get('#grid').reload();
            if (modal){
                uglcw.ui.Modal.close(modal);
            }
        } else if (data == "2") {
            uglcw.ui.error('已加入该公司');
        } else if (data == "5") {
            uglcw.ui.error('公司id不存在');
        } else if (data == "3") {
            uglcw.ui.error('该手机号已存在企业会员中');
        } else if (data == "4") {
            uglcw.ui.error('角色不能包含"创建者"或"管理员"');
        } else if (data == "6") {
            uglcw.ui.error('外勤人员不存在');
        } else if (data == "7") {
            uglcw.ui.error('端口数已超出');
        } else {
            uglcw.ui.error('操作失败');
            return;
        }
    }

    function toDel() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            //多选ids
            var ids = '';
            for(var i = 0; i < selection .length; i++){
                var item = selection[i];
                if (selection[0].status == '1' || selection[0].status == '2') {
                    uglcw.ui.warning('包含已审核的，不能删除！');
                    return;
                }else{
                    if(ids == ''){
                        ids += item.id;
                    }else{
                        ids += "," + item.id;
                    }
                }
            }
            uglcw.ui.confirm('您确认想要删除记录吗?', function () {
                $.ajax({
                    url: '${base}/manager/company/deleteCompanyJoin',
                    data: {
                        ids: ids
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        if (json) {
                            if (json == '1') {
                                uglcw.ui.success('删除成功');//错误提示
                                uglcw.ui.get('#grid').reload();
                            }
                        } else if (json == -1) {
                            uglcw.ui.error('删除失败');
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要删除的数据！');
        }
    }


</script>
</body>
</html>
