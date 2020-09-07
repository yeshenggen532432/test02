<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>${memberType==2?'站长设置':'联盟商家设置'}</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query" id="derive">
                <li>
                    <input type="hidden" uglcw-model="isDel" value="0" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="姓名">
                </li>
                <li>
                    <input uglcw-model="memberMobile" uglcw-role="textbox" placeholder="手机号码">
                </li>
                <li style="display: none">
                    <select uglcw-role="combobox" uglcw-model="memberUse" placeholder="在职状态">
                        <option value="1" selected>在职</option>
                        <option value="2">离职</option>
                        <option value="3">已删除</option>
                    </select>
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
					responsive: ['.header', 40],
                    rowNumber: true,
                    checkbox: true,
                    <c:if test="${empty editFlag}">
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    </c:if>
                    id:'id',
                    url: '${base}manager/memberPage?memberType=${memberType}',
                    criteria: '.query',
                    pageable: true,
                    ">
                <%--<div data-field="firstChar" uglcw-options="width:70">首字母</div>--%>
                <div data-field="memberNm" uglcw-options="width:180">姓名</div>
                <div data-field="memberMobile" uglcw-options="width:120">手机号码</div>
                <div data-field="memberUse" uglcw-options="width:100,hidden:true,
                                template: uglcw.util.template($('#formatterSt3').html())">状态
                </div>
                <div data-field="memberJob" uglcw-options="width:150">职位</div>
                <div data-field="memberTrade" uglcw-options="width:150">行业</div>
                <div data-field="memberHometown" uglcw-options="width:150">家乡</div>
            </div>
        </div>
    </div>
</div>
<script id="addressUploadDiv" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" id="addressUploadlFrm" uglcw-role="validator">
                <input type="hidden" uglcw-model="memId" uglcw-role="textbox">
                <div class="form-group">
                    <label class="control-label col-xs-8">上传方式</label>
                    <div class="col-xs-12">
                        <ul uglcw-role="radio" uglcw-model="upload"
                            uglcw-value="0"
                            uglcw-options='layout:"horizontal",
                                    dataSource:[{"text":"不上传","value":"0"},{"text":"上传","value":"1"}]
                                    '></ul>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">间隔分钟</label>
                    <div class="col-xs-12">
                        <select uglcw-model="min" uglcw-role="combobox">
                            <option value="1" selected="selected">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="form_edit">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input type="hidden" uglcw-model="memberId" uglcw-role="textbox"/>
                    <input type="hidden" uglcw-model="memberUse" uglcw-role="textbox"/>
                    <input type="hidden" uglcw-model="memberType" uglcw-role="textbox" value="${memberType}"/>
                    <label class="control-label col-xs-8">${memberType==2?'站长':'联盟商家'}姓名:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="memberNm" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">手机号码:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="memberMobile" uglcw-role="textbox"
                               uglcw-msg="请输入正确的电话号码格式" uglcw-validate="required|mobile" #=edit ? 'readonly' :''#>
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
                        <input style="width: 200px;" uglcw-model="memberJob" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">行业:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="memberTrade" uglcw-role="textbox">
                    </div>
                </div>

                <div class="hide form-group">
                    <label class="control-label col-xs-8">是否领导(VIP)：</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="isLead"
                            uglcw-value="2"
                            uglcw-options='layout:"horizontal",
                                    dataSource:[{"text":"是","value":"1"},{"text":"否","value":"2"}]
                                    '></ul>
                    </div>
                </div>
                <div class="hide form-group">
                    <label class="control-label col-xs-8">角色选择:</label>
                    <div class="col-xs-16">
                        <select style="width: 200px;" uglcw-role="dropdowntree" uglcw-model="roleIds"
                                uglcw-options="
                                  checkboxes: {
                                    template: uglcw.util.template($('\\#checkbox-tpl').html())
                                  },
                                  autoClose: false,
                                  checkAll: false,
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
                    <div class="hide form-group">
                        <input type="hidden" uglcw-model="cid" uglcw-role="textbox">
                        <label class="control-label col-xs-8">所属客户:</label>
                        <div class="col-xs-16">
                            <input style="width: 200px;" uglcw-model="khNm" uglcw-role="textbox">
                        </div>
                        <a href="javascript:choicecustomer()">查询</a>
                    </div>
                </c:if>
                <div class="hide form-group">
                    <label class="control-label col-xs-8">部门:</label>
                    <div class="col-xs-16">
                        <select style="width: 200px;" uglcw-role="dropdowntree" uglcw-model="branchId,branchName"
                                uglcw-options="
                                initLevel: 1,
                                id: 'id',
                                expandable: function(node){
                                    node.branchId = node.id;
                                    node.branchName = node.text;
                                },
                                value: #= data.branchId#,
                                dataTextField: 'branchName',
                                dataValueField: 'branchId',
                                url: '${base}manager/departs?dataTp=1',
                                ">
                        </select>
                    </div>
                </div>
                <div class="hide form-group" style="display:none;">
                    <label class="control-label col-xs-8">在职状态:</label>
                    <div class="col-xs-16">
                        <select style="width:200px" uglcw-role="combobox" uglcw-model="memberUse">
                            <option value="1" selected>在职</option>
                            <option value="2">离职</option>
                            <option value="3">已删除</option>
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

<script id="checkbox-tpl" type="text/x-uglcw-template">
    #if(item.roleCd !== 'company_creator' && item.roleCd !== 'company_admin'){#
    <input id="_#= item.uid#" tabindex="-1" type="checkbox" class="k-checkbox"
           #=item.checked ? 'checked':''# >
    <label for="_#= item.uid#" class="k-checkbox-label checkbox-span"></label>
    # } #
</script>

<script type="text/x-uglcw-template" id="recover">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="bind">
                <div class="form-group">
                    <div class="control-label  col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="memberUse"
                            uglcw-value="1"
                            uglcw-options='layout:"horizontal",
                                    dataSource:[{"text":"在职","value":"1"},{"text":"离职","value":"2"}]
                                    '></ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

</script>
<script type="text/x-uglcw-template" id="formatAuthority">
    <button class="k-button k-info" onclick="queryAuthority(#=data.memberId#,1)">查看菜单</button>
    <button class="k-button k-info" onclick="queryAuthority(#=data.memberId#,2)">查看应用</button>
</script>
<script type="text/x-uglcw-template" id="formatterSt">
    # if(data.isLead =='1'){#
    是
    #}else{#
    #}#

</script>
<script type="text/x-uglcw-template" id="formatterSt1">
    # if(data.isAdmin == '1'){#
    是
    #}else{#
    #}#
</script>
<script type="text/x-uglcw-template" id="formatterSt3">
    # if(data.memberUse==3){#
    <button class="k-button k-error" onclick="recoverIsTy(#= data.memberId#)">已删除</button>
    #}else if(data.memberUse==2){#
    #if(dataTp =='3'){#
    <button class="k-button k-error" onclick="updateIsTy(#= data.memberId#,1)">已离职</button>
    #}else{#
    <button class="k-button k-error" onclick="updateIsTy(#= data.memberId#,1)">已离职</button>
    #}#
    #}else{#
    #if(dataTp =='3'){#
    <button class="k-button k-info" onclick="updateIsTy(#= data.memberId#,2)">在职</button>
    #}else{#
    <button class="k-button k-info" onclick="updateIsTy(#= data.memberId#,2)">在职</button>
    #}#
    #}#
</script>
<script type="text/x-uglcw-template" id="formatterSt5">
    # if(data.memberUse == 2){#
    #if(dataTp == '3'){#
    <button class="k-button k-info" onclick="choicemember(#= data.memberId#)">转让客户</button>
    #}else{#
    <button class="k-button k-info" onclick="choicemember(#= data.memberId#)">转让客户</button>
    #}#
    #}#

</script>
<script type="text/x-uglcw-template" id="formatterSt4">

    #if (data.unId) {#

    #if (data.unId == '1') {#
    #if (dataTp == '3') {#
    <button class="k-button k-warning" onclick="updateUnId(#= data.memberId#,1)">待绑定</button>
    # } else {#
    <button class="k-button k-warning" onclick="updateUnId(#= data.memberId#,1)">待绑定</button>
    # }#
    #} else {#
    #if (dataTp == '3') {#
    <button class="k-button k-info" onclick="updateUnId(#= data.memberId#,2)">绑定</button>
    #} else {#
    <button class="k-button k-info" onclick="updateUnId(#= data.memberId#,2)">绑定</button>
    #}#
    #}#
    #} else {#
    #if (dataTp == '3') {#
    <button class="k-button k-default" onclick="updateUnId(#= data.memberId#,3)">没绑定</button>
    #} else {#
    <button class="k-button k-default" onclick="updateUnId(#= data.memberId#,3)">没绑定</button>
    #}#
    #}#

</script>
<script type="text/x-uglcw-template" id="formaterrusr">
    <button class="k-button k-info" onclick="toroleusr(#=data.memberId#, '#= data.memberNm#')">
        <a class="k-icon k-i-plus-circle"></a>设置
    </button>

</script>
<script type="text/x-uglcw-template" id="formatterSt6">
    #if(data.useDog == 1){#
    <button class="k-button k-info" onclick="writeDogProc(#= data.memberId#,#=data.memberMobile#)">写加密锁</button>
    <button class="k-button k-warning" onclick="updateDog(#= data.memberId#,0)">取消验证</button>
    #}else{#
    <button class="k-button k-info" onclick="writeDogProc(#= data.memberId#,#=data.memberMobile#)">写加密锁</button>
    #}#

</script>
<script type="text/x-uglcw-template" id="formatterSt7">
    #if(data.upload == 1){#
    上传
    #}else{#
    不上传
    #}#

</script>
<script type="text/x-uglcw-template" id="formatterSt8">
    #if(data.upload == 1){#
    #=data.min#
    #}else{#
    #}#

</script>
<script type="text/x-uglcw-template" id="formatterSt9">
    <botton class="k-button k-info"
            onclick="toUpdateAddressUpload(#= data.memberId#, #= data.upload||0#, #= data.min||1#)">设置
    </botton>
</script>
<script type="text/x-uglcw-template" id="formatterSt10">
    #if(data.memUpload == '0'){#
    永不上报
    #}else{#
    始终上报
    #}#

</script>
<script type="text/x-uglcw-template" id="toolbar">
    <c:if test="${dataTp!=3}">
        <c:if test="${!empty info.datasource}">
            <a role="button" class="k-button k-button-icontext"
               href="javascript:toaddmember();">
                <span class="k-icon k-i-plus"></span>添加
            </a>
            <a role="button" href="javascript:toedit();" class="k-button k-button-icontext">
                <span class="k-icon k-i-edit"></span>修改</a>
            <%-- <a role="button" href="javascript:updateUseStatus(2);" class="k-button k-button-icontext">
                 <span class="k-icon k-i-minus-outline"></span>离职</a>
             <a role="button" href="javascript:updateUseStatus(1);" class="k-button k-button-icontext">
                 <span class="k-icon k-i-plus-outline"></span>入职</a>--%>
            <a role="button" href="javascript:toDel();" class="k-button k-button-icontext">
                <span class="k-icon k-i-trash"></span>删除
            </a>
            <%--<a role="button" href="javascript:toLoadModel();"
               class="k-button k-button-icontext k-grid-add-other">
                <span class="k-icon k-i-download"></span>下载模板
            </a>
            <a role="button" href="javascript:toUpCustomer();"
               class="k-button k-button-icontext k-grid-add-other">
                <span class="k-icon k-i-upload"></span>上传成员
            </a>--%>
        </c:if>
    </c:if>
</script>
<script type="text/x-uglcw-template" id="app-tree-tpl">
    <div id="node-#= item.id#">
        <label class="app-menu-label">#= item.applyName#</label>
        #if(item.PId!=0 && item.menuTp == 1){#
        <ul class="app-menu uglcw-radio horizontal">
            <li><input #=item.menuLeaf == '1'? 'checked': '' # type="radio" value="1" id="radio_app_all_#= item.id#"
                #if(item.admin){#
                disabled
                #}#
                class="k-radio" name="radio_app_#= item.id#"><label
                        for="radio_app_all_#= item.id#" class="k-radio-label">全部</label></li>
            <li><input #=item.menuLeaf == '2'? 'checked': '' # type="radio" value="2" id="radio_app_dept_#= item.id#"
                #if(item.admin){#
                disabled
                #}#
                class="k-radio" name="radio_app_#= item.id#"><label
                        for="radio_app_dept_#= item.id#" class="k-radio-label">部门及子部门</label></li>
            <li><input #=item.menuLeaf == '3'? 'checked': '' # type="radio" value="3" id="radio_app_personal_#=
                item.id#" class="k-radio"
                #if(item.admin){#
                disabled
                #}#
                name="radio_app_#= item.id#"><label for="radio_app_personal_#= item.id#"
                                                    class="k-radio-label">个人</label></li>
            <li><input #=item.menuLeaf == '4'? 'checked': '' # type="radio" value="4" id="radio_app_custom_#= item.id#"
                class="k-radio"
                #if(item.admin){#
                disabled
                #}#
                name="radio_app_#= item.id#"><label for="radio_app_custom_#= item.id#"
                                                    class="k-radio-label uglcw-app-custom">自定义</label></li>
        </ul>
        #if(item.applyName =='报表统计'){#
        <br>
        <div class="app-menu uglcw-checkbox">
            <input type="checkbox"
                   name="sgtjz"
                   class="k-checkbox"
                   id="checkbox_app_1_#= item.id#"
                   #if(item.admin){#
                   disabled
                   #}#
                   #if(item.sgtjz.indexOf('1')!=-1){#
            checked
            #}#
            value="1"><label for="checkbox_app_1_#= item.id#" class="k-checkbox-label">业务执行</label>
            <input type="checkbox" name="sgtjz" class="k-checkbox" id="checkbox_app_2_#= item.id#"
                   #if(item.admin){#
                   disabled
                   #}#
                   #if(item.sgtjz.indexOf('1')!=-1){#
            checked
            #}#
            value="2"><label for="checkbox_app_2_#= item.id#" class="k-checkbox-label">客户拜访</label>
            <input
                    #if(item.admin){#
                    disabled
                    #}#
                    #if(item.sgtjz.indexOf('1')!=-1){#
            checked
            #}#
            type="checkbox" class="k-checkbox" id="checkbox_app_3_#= item.id#" value="3"><label
                for="checkbox_app_3_#= item.id#" class="k-checkbox-label">产品订单</label>
            <input name="sgtjz"
                   #if(item.admin){#
                   disabled
                   #}#
                   #if(item.sgtjz.indexOf('1')!=-1){#
            checked
            #}#
            type="checkbox" class="k-checkbox" id="checkbox_app_4_#= item.id#" value="4"><label
                for="checkbox_app_4_#= item.id#" class="k-checkbox-label">销售订单</label>
        </div>
        # } #
        #}#
    </div>

</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var dataTp = '${dataTp}';
    $(function () {
        //ui:初始化
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })

    function onDepartTreeInit() {
        console.log('dataBound');
    }

    function updateUseStatus(status) {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            updateIsTy(selection[0].memberId, status);
        } else {
            uglcw.ui.warning('请选择要编辑的行！');
        }
    }

    function updateIsTy(id, isTy) {//是否在职
        var type = isTy == 1 ? '恢复' : '离职';
        uglcw.ui.confirm('确定' + type + '该员工吗？', function () {
            $.ajax({
                url: '${base}manager/updateIsTy',
                type: "post",
                data: {id: id, isTy: isTy},
                dataType: "json",
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.success(response.message);
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message);
                    }
                }
            });
        })
    }

    //删除状态
    function recoverIsTy(memberId) {
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#recover').html(),
            success: function (container) {
                uglcw.ui.init($(container));//初始化
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var chkObjs = uglcw.ui.bind($("#bind"));
                    var type = chkObjs.memberUse;
                    $.ajax({
                        url: '${base}manager/member/recoverIsTy',
                        data: ({
                            memberId: memberId,
                            type: type
                        }),
                        dataType: 'json',
                        type: 'post',
                        success: function (response) {
                            if (response.code == 200) {
                                uglcw.ui.success(response.message);
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });
    }

    function choicemember(mid1) {//转让客户
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/memberPage?memberUse=1',
            checkbox: false,
            width: 650,
            btns: [],
            height: 400,
            criteria: '<input placeholder="姓名" uglcw-role="textbox" uglcw-model="memberNm">',
            columns: [
                {field: 'memberNm', title: '姓名', width: 100},
                {field: 'memberMobile', title: '手机号码', width: 150},
                {field: 'branchName', title: '部门', width: 150},
            ],
            yes: function (nodes) {
                var mid2 = nodes[0].memberId;
                $.ajax({
                    url: "${base}manager/updateZrKh",
                    type: "post",
                    data: "mid1=" + mid1 + "&mid2=" + mid2,
                    success: function (data) {
                        if (data == '1') {
                            uglcw.ui.success("转让客户成功");
                            uglcw.ui.warning(response.message);
                        } else {
                            uglcw.ui.error("转让客户失败");
                            return;
                        }
                    }
                });
            }
        })

    }

    function updateUnId(id, isTy) {//是否绑定
        $.ajax({
            url: "${base}manager/updateUnId",
            type: "post",
            data: "id=" + id + "&isTy=" + isTy,
            success: function (data) {
                if (data == '1') {
                    uglcw.ui.success("操作成功");
                    uglcw.ui.get('#grid').reload();
                } else if (data == '2') {
                    uglcw.ui.success("操作成功");
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error("解绑失败");
                    return;
                }
            }
        });
    }

    function updateDog(memberId, useDog) {//取消验证
        $.ajax({
            url: "${base}manager/updateUseDog",
            type: "post",
            data: "memberId=" + memberId + "&useDog=" + useDog
                + "&idKey=" + keyid,
            success: function (data) {
                if (data == '1') {
                    uglcw.ui.success("设置成功");
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error("设置失败");
                    return;
                }
            }
        });
    }

    function toUpdateAddressUpload(memberId, upload, min) {//设置
        uglcw.ui.Modal.open({
            title: '修改位置上传方式',
            area: '400px',
            content: $('#addressUploadDiv').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), {
                    memId: memberId,
                    upload: upload,
                    min: min
                })
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var data = uglcw.ui.bind('#addressUploadlFrm');
                    data.memId = memberId;
                    $.ajax({
                        url: '${base}/manager/updateAddressUpload',
                        data: data,
                        type: 'post',
                        success: function (data) {
                            if (data == "1") {
                                uglcw.ui.success('操作成功');
                                uglcw.ui.get('#grid').reload();//刷新页面
                            } else {
                                uglcw.ui.error("操作失败");
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });

    }

    function toDel() {//删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm("您确认想要删除${memberType==2?'站长':'联盟商家'}记录吗？", function () {
                $.ajax({
                    url: "${base}manager/delMemberMemberType",
                    type: "post",
                    data: {
                        memberType: '${memberType}',
                        ids: $.map(selection, function (row) {  //选中多行数据删除
                            return row.memberId
                        }).join(',')
                    },
                    success: function (json) {
                        if (json.state) {
                            uglcw.ui.success('删除成功');
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error('操作失败');
                            return;
                        }
                    }
                });
            });

        } else {
            uglcw.ui.warning('请选择要删除的数据')
        }

    }

    function toLoadModel() {//下载模板
        uglcw.ui.confirm('您确认想要下载模板吗？', function () {
            window.location.href = "${base}/manager/toLoadModel";

        });

    }

    function toUpCustomer() {//上传数据
        uglcw.ui.Modal.showUpload({
            btns: [],
            url: '${base}manager/toUpExcel',
            field: 'upFile',
            error: function () {
                console.log('error', arguments)
            },
            complete: function () {
                console.log('complete', arguments);
            },
            success: function (e) {
                if (e.response != '1') {
                    uglcw.ui.error(e.response);
                } else {
                    uglcw.ui.success('导入成功');
                    uglcw.ui.get('#grid').reload();
                }
            }
        })
    }

    function queryAuthority(memberId, type) {
        var title = type == 1 ? '菜单' : '应用';
        uglcw.ui.Modal.showTreeSelector({
            lazy: false,
            title: '查看' + title,
            flat: {
                parent: 'PId',
                children: 'children'
            },
            data: {
                member_id: memberId,
                menu_type: type
            },
            checkboxes: {checkChildren: true},
            checkable: function (node) {
                return node.applyNo > 0;
            },
            expandable: function () {
                return true;
            },
            area: ['520px', '500px'],
            dataTextField: 'applyName',
            btns: [],
            url: '${base}manager/member/authority',
            template: function (node) {
                var item = node.item;
                item.admin = true;
                return uglcw.util.template($('#app-tree-tpl').html())({item: item})
            },
            success: function (container) {
                var tree = uglcw.ui.get($(container).find('.uglcw-tree'));
                $(container).on('change', '.uglcw-radio [type=radio]', function () {
                    var node = tree.k().dataItem($(this).closest('.k-item'));
                    var checkedValue = $(this).val();
                    console.log(node, $(this).val());
                    node.menuLeaf = checkedValue;
                })
                //自定义事件
                $(container).on('click', '.uglcw-radio .uglcw-app-custom', function () {
                    var node = tree.k().dataItem($(this).closest('.k-item'));
                    showCustomPermissionDialog(roleId, node.id, node.applyName, node.mids, node);
                })
                //统计报表checkbox事件
                $(container).on('change', '.uglcw-checkbox [type=checkbox]', function () {
                    var node = tree.k().dataItem($(this).closest('.k-item'));
                    var sgtjz = [];
                    $(this).closest('.uglcw-checkbox').find('[type=checkbox]').each(function () {
                        if ($(this).is(':checked')) {
                            sgtjz.push($(this).val());
                        }
                    })
                    node.sgtjz = sgtjz.join(',');
                })
                uglcw.ui.loaded();
            },
            yes: function (checked, nodes, flat) {
                var data = {
                    menuapplytype: 2,
                    companyroleId: roleId
                };
                //菜单选项
                $(checked).each(function (idx, item) {
                    data['roleMenu[' + idx + '].ifChecked'] = true;
                    data['roleMenu[' + idx + '].menuId'] = item.id;
                    data['roleMenu[' + idx + '].tp'] = item.tp;
                    data['roleMenu[' + idx + '].bindId'] = item.menuId;
                    data['roleMenu[' + idx + '].mids'] = item.mids;
                    data['roleMenu[' + idx + '].dataTp'] = item.menuLeaf;
                    data['roleMenu[' + idx + '].sgtjz'] = item.sgtjz;
                });
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/saveRoleMenuApply',
                    type: 'post',
                    data: data,
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response) {
                            uglcw.ui.success('操作成功');
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('操作失败');
                    }
                })
            }
        })
    }

    function toroleusr(memberId, memberNm) {
        uglcw.ui.Modal.showTreeSelector({
            title: '分配用户:' + memberNm,
            lazy: false,
            url: '${base}manager/queryUsrForRole',
            data: {
                id: memberId
            },
            flat: {
                root: '0',
                parent: 'pid',
                id: 'usrid',
                children: 'children'
            },
            checkable: function (node) {
                return node.isuse > 0
            },
            expandable: function () {
                return true;
            },
            loadFilter: function (response) {
                $.map(response, function (node) {
                    node.pid = 1
                })
                //构造一个根节点 用于全选
                response.push({
                    usrid: 1,
                    pid: 0,
                    usrnm: '根节点',
                    isuse: 0
                })
                return response;
            },
            dataTextField: 'usrnm',
            area: ['250px', '400px'],
            yes: function (nodes, tree, flat) {
                $.ajax({
                    url: '${base}manager/addZcUsr',
                    type: 'post',
                    data: {
                        zusrId: memberId,
                        cusrIds: $.map(nodes, function (node) {
                            if (node.pid !== 0) {
                                return node.usrid;
                            }
                        }).join(',')
                    },
                    success: function (response) {
                        if (response === '2') {
                            uglcw.ui.success('保存成功！');
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error('操作失败！');
                        }
                    }
                })
                console.log(nodes, tree, flat);
            }
        })
    }

    function toaddmember() {//添加
        edit();
    }

    function toedit() {//修改
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function edit(item) {
        var i = uglcw.ui.Modal.open({
            title: "编辑${memberType==2?'站长':'联盟商家'}",
            content: uglcw.util.template($('#form_edit').html())({
                branchId: item ? item.branchId : undefined,
                edit: item && item.memberId
            }), //打开之前渲染获取密码值
            success: function (container) {
                uglcw.ui.init($(container));
                if (item) {
                    var row = item.toJSON();
                    if (row.roleIds) {
                        row.roleIds = $.map(row.roleIds.split(','), function (id) {
                            return parseInt(id);
                        });
                    }
                    uglcw.ui.bind($(container), row);
                }
            },
            yes: function (container) {
                var form = uglcw.ui.get($(container).find('.form-horizontal'));
                if (!form.validate()) {
                    return false;
                }
                var data = uglcw.ui.bind($(container));
                /*if (!data.branchId) {
                    uglcw.ui.warning('请选择部门');
                    return false;
                }*/
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/member',
                    type: 'post',
                    data: JSON.stringify(data),
                    contentType: 'application/json',
                    async: false,
                    success: function (data) {
                        uglcw.ui.loaded();
                        if (data.data == '1') {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close(i);
                        } else if (data.data == '2') {
                            uglcw.ui.success('修改成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close(i);
                        } else if (data.data == '3') {
                            uglcw.ui.error('该手机号已存在');
                        } else if (data.data == '4') {
                            uglcw.ui.error('不能直接添加管理员与创建者角色');
                        } else if (data.data == '5') {
                            uglcw.ui.error('当前企业有错误');
                        } else if (data.data == '6') {
                            uglcw.ui.error('添加员工失败，外勤人员数量已满');
                        } else if (data.data == '7') {
                            uglcw.ui.error('对不起，您已超出端口上限，请先增加端口数。具体联系平台客服');
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })

    }
</script>
</body>
</html>
