<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客服人员分配</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-selector-container .uglcw-tree .k-in {
            padding: 2px 5px 2px 5px;
        }

        ul.app-menu.uglcw-radio.horizontal li {
            margin-top: 2px;
            margin-left: 2px;
        }

        .app-menu-label {
            margin-top: 2px;
        }

        .app-menu.uglcw-radio {
            margin-left: 20px;
            margin-top: 0px;
            font-size: 10px;
            float: right;
        }

        .app-menu.uglcw-checkbox {
            float: right;
            font-size: 10px;
        }

        .app-menu .k-radio-label::before {
            width: 12px;
            height: 12px;
        }

        .app-menu .k-radio-label:before {
            width: 12px;
            height: 12px;
        }

        .app-menu .k-checkbox-label:before {
            font-size: 12px;
            line-height: 12px;
        }

        .app-menu .k-checkbox-label::before {
            width: 13px;
            height: 13px;
        }

        .app-menu .k-checbox-label:before {
            width: 12px;
            height: 12px;
        }

        .app-menu .k-radio-label {
            padding-left: 18px;
            line-height: 15px !important;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <div class="form-horizontal query" id="derive">
                <div class="form-group" style="margin-bottom: 10px;">
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                        <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="姓名">
                    </div>
                    <div class="col-xs-4">
                        <input uglcw-model="memberMobile" uglcw-role="textbox" placeholder="手机号码">
                    </div>
                    <c:if test="${!empty info.datasource}">
                        <div class="col-xs-4">
                            <select uglcw-role="combobox" uglcw-model="memberUse" placeholder="在职状态">
                                <option value="">全部</option>
                                <option value="1" selected>在职</option>
                                <option value="2">离职</option>
                            </select>
                        </div>
                    </c:if>
                    <c:if test="${empty info.datasource}">
                        <div class="col-xs-4">
                            <input uglcw-model="memberCompany" uglcw-role="textbox" placeholder="公司">
                        </div>
                    </c:if>

                    <div class="col-xs-4">
                        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    rowNumber: true,
                    checkbox: true,
                    responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/memberPage?dataTp=${dataTp}',
                    criteria: '.query',
                    pageable: true,
                    ">
                <%-- <div data-field="inDate" uglcw-options="
                         width:50, selectable: true, type: 'checkbox',
                         headerAttributes: {'class': 'uglcw-grid-checkbox'}
                         "></div>--%>
                <div data-field="isCustomerService" uglcw-options="width:70,
                            template: uglcw.util.template($('#formatterSt4').html())">是否客服</div>
                <div data-field="firstChar" uglcw-options="width:70">首字母</div>
                <div data-field="memberNm" uglcw-options="width:80">姓名</div>
                <div data-field="memberMobile" uglcw-options="width:120">手机号码</div>
                <div data-field="roleNames" uglcw-options="width:140,tooltip: true">角色列表</div>
                <div data-field="branchName" uglcw-options="width:80">部门</div>
                <div data-field="isLead" uglcw-options="width:80,
                             template: uglcw.util.template($('#formatterSt').html())">是否领导
                </div>
                <div data-field="isAdmin" uglcw-options="width:80,
                                template: uglcw.util.template($('#formatterSt1').html())">是否管理员
                </div>
                <div data-field="memberUse" uglcw-options="width:80,
                                template: uglcw.util.template($('#formatterSt3').html())">在职状态
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input  type="hidden" uglcw-model="memberId" uglcw-role="textbox"/>
                    <input type="hidden" uglcw-model="memberType" uglcw-role="textbox"/>
                    <label class="control-label col-xs-8">成员姓名:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="memberNm" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">手机号码:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="memberMobile" uglcw-role="textbox"
                               uglcw-msg="请输入正确的电话号码格式" uglcw-validate="required|mobile">
                    </div>
                </div>
                #if(edit){#
                <div class="form-group">
                    <label class="control-label col-xs-8">密码:</label>
                    <div class="col-xs-16">
                        <input type="password" style="width: 200px;" uglcw-model="memberPwd" uglcw-role="textbox">
                    </div>
                </div>
                #}#
                <div class="form-group">
                    <label class="control-label col-xs-8">职位:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="memberJob" uglcw-role="textbox" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">行业:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="memberTrade" uglcw-role="textbox" >
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-xs-8">是否领导(VIP)：</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="isLead"
                            uglcw-value="2"
                            uglcw-options='layout:"horizontal",
                                    dataSource:[{"text":"是","value":"1"},{"text":"否","value":"2"}]
                                    '></ul>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">角色选择:</label>
                    <div class="col-xs-16">
                        <select style="width: 200px;" uglcw-role="dropdowntree" uglcw-model="roleIds"
                                uglcw-options="
                                  checkboxes: true,
                                  checkAll: true,
                                  value: 4,
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
                <c:if test="${tpNm=='卖场'}">
                    <div class="form-group">
                        <input type="hidden" uglcw-model="cid" uglcw-role="textbox">
                        <label class="control-label col-xs-8">所属客户:</label>
                        <div class="col-xs-16">
                            <input style="width: 200px;" uglcw-model="khNm" uglcw-role="textbox" >
                        </div>
                        <a href="javascript:choicecustomer()">查询</a>
                    </div>
                </c:if>
                <div class="form-group">
                    <label class="control-label col-xs-8">部门:</label>
                    <div class="col-xs-16">
                        <select style="width: 200px;" uglcw-role="dropdowntree"  uglcw-model="branchId"
                                uglcw-options="
                                initLevel: 1,
                                url: '${base}manager/departs?dataTp=1',
                                ">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">家乡:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="memberHometown" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">简介:</label>
                    <div class="col-xs-14">
                        <textarea style="width: 200px;" uglcw-model="memberDesc" uglcw-role="textbox"></textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="formatterSt">
    # if(data.isLead =='1'){#
    是
    #}else{#
    否
    #}#

</script>
<script type="text/x-uglcw-template" id="formatterSt1">
    # if(data.isAdmin == '1'){#
    是
    #}else{#
    否
    #}#
</script>
<script type="text/x-uglcw-template" id="formatterSt3">
    # if(data.memberUse==2){#
    #if(dataTp =='3'){#
    已离职
    #}else{#
    已离职
    #}#
    #}else{#
    #if(dataTp =='3'){#
    在职
    #}else{#
    在职
    #}#
    #}#
</script>
<script type="text/x-uglcw-template" id="formatterSt4">
    # if(data.isCustomerService =='1'){#
    是
    #}else{#
    否
    #}#

</script>
<script type="text/x-uglcw-template" id="toolbar">
    <c:if test="${dataTp!=3}">
        <c:if test="${!empty info.datasource}">
            <a role="button" href="javascript:setSelectedCustomerService();" class="k-button k-button-icontext">
                <span class="k-icon k-i-edit"></span>设置为客服</a>
            <a role="button" href="javascript:setSelectedNotCustomerService();" class="k-button k-button-icontext">
                <span class="k-icon k-i-edit"></span>取消为客服</a>
        </c:if>
    </c:if>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var dataTp = '${dataTp}';
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })



    function toedit() {//修改
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }
    function edit(item) {
        uglcw.ui.Modal.open({
            title: '编辑员工',
            content: uglcw.util.template($('#form').html())({edit: item && item.memberId}), //打开之前渲染获取密码值
            success: function (container) {
                uglcw.ui.init($(container));
                if (item) {
                    var row = item.toJSON();
                    if(row.roleIds){
                        row.roleIds= $.map(row.roleIds.split(','), function(id){
                            return parseInt(id);
                        });
                    }
                    uglcw.ui.bind($(container), row);
                }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));

                if(!data.branchId){
                    return  uglcw.ui.warning('请选择部门');
                }
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/member',
                    type: 'post',
                    data: JSON.stringify(data),
                    contentType: 'application/json',
                    async: false,
                    success: function (data) {
                        uglcw.ui.loaded();
                        if (data.data== '1') {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                        } else if (data.data == '2') {
                            uglcw.ui.success('修改成功');
                            uglcw.ui.get('#grid').reload();
                        } else if (data.data== '3') {
                            uglcw.ui.error('该手机号已存在');
                            return;
                        }else if(data.data =='4') {
                            uglcw.ui.error('不能直接添加管理员与创建者角色');
                            return;
                        }else if(data.data=='5'){
                            uglcw.ui.error('当前企业有错误');
                        } else {
                            uglcw.ui.error('操作失败');
                            return false;
                        }
                    }
                })
            }
        })

    }

    //设置选中的员工为客服
    function setSelectedCustomerService() {
        var rows = uglcw.ui.get('#grid').selectedRow();
        if (rows) {
            var ids = [];
            for ( var i = 0; i < rows.length; i++) {
                ids.push(rows[i].memberId);
            }
            uglcw.ui.confirm('您确认要设置选中的员工为客服吗？', function() {
                $.ajax( {
                    url : "/manager/weiXinChat/setSelectedCustomerService",
                    data : "ids=" + ids,
                    type : "post",
                    success : function(json) {
                        if (json == 1) {
                            uglcw.ui.success("设置客服成功！");
                            uglcw.ui.get('#grid').reload();
                        }else if (json == -1) {
                            uglcw.ui.error("设置客服失败！");
                        }
                    }
                });
            });
        } else {
            uglcw.ui.warning('请选择要设置客服的员工！');
        }
    }

    //取消设置选中的员工为客服
    function setSelectedNotCustomerService() {
        var rows = uglcw.ui.get('#grid').selectedRow();
        if (rows) {
            var ids = [];
            for ( var i = 0; i < rows.length; i++) {
                ids.push(rows[i].memberId);
            }
            uglcw.ui.confirm('您确认选中的员工取消客服吗？', function() {
                $.ajax( {
                    url : "/manager/weiXinChat/setSelectedNotCustomerService",
                    data : "ids=" + ids,
                    type : "post",
                    success : function(json) {
                        if (json == 1) {
                            uglcw.ui.success("取消客服成功！");
                            uglcw.ui.get('#grid').reload();
                        }else if (json == -1) {
                            uglcw.ui.error("取消客服失败！");
                        }
                    }
                });
            });
        } else {
            uglcw.ui.warning('请选择要取消客服的员工！');
        }
    }
</script>
</body>
</html>
