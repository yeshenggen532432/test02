<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>审批流</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .xxzf-more {
            background-color: aliceblue;
            overflow: hidden;
            padding-bottom: 2px;
            padding-top: 2px;
            font-size: 8px;
        }

        .dialog-width {
            width: 280px;
        }
        .tip-red{
            color: red;
            font-size: 8px;
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
                    <ul class="uglcw-query form-horizontal" id="export">
                        <li>
                            <input uglcw-model="zdyNm" uglcw-role="textbox" placeholder="审批名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="status">
                                <option value="0">启用</option>
                                <option value="1">禁用</option>
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
                         uglcw-options="{
                            checkbox:'true',
                            responsive:['.header',40],
                            id:'id',
                            toolbar: kendo.template($('#toolbar').html()),
                            url: 'manager/queryAuditZdyList',
                            criteria: '.uglcw-query',
                            pageable: true,
                        }">
                        <div data-field="zdyNm" uglcw-options="width:160,tooltip:true">审批名称</div>
                        <%--<div data-field="sort" uglcw-options="--%>
                                <%--width:80,--%>
                                <%--headerTemplate: uglcw.util.template($('#header_sort').html()),--%>
                                <%--template:function(row){--%>
                                    <%--return uglcw.util.template($('#num').html())({val:row.sort, data: row, field:'sort'})--%>
                                <%--}--%>
                                <%--">--%>
                        <%--</div>--%>
                        <div data-field="status"
                             uglcw-options="width:70, template: uglcw.util.template($('#formatterStatus').html())">状态
                        </div>
                        <div data-field="modelName" uglcw-options="width:130, tooltip:true">审批模板 </div>
                        <div data-field="isSy" uglcw-options="width:70, template: uglcw.util.template($('#formatterIsSy').html())">使用类型 </div>
                        <div data-field="detailName" uglcw-options="width:100,template: uglcw.util.template($('#formatterDetail').html())">详情</div>
                        <div data-field="amountName" uglcw-options="width:80,template: uglcw.util.template($('#formatterAmount').html())">金额</div>
                        <div data-field="timeName" uglcw-options="width:140,template: uglcw.util.template($('#formatterTime').html())">时间</div>
                        <div data-field="typeName" uglcw-options="width:80,template: uglcw.util.template($('#formatterType').html())">类型</div>
                        <div data-field="objectName" uglcw-options="width:80,template: uglcw.util.template($('#formatterObject').html())">对象</div>
                        <div data-field="accountName" uglcw-options="width:80,template: uglcw.util.template($('#formatterAccount').html())">账户</div>
                        <div data-field="remarkName" uglcw-options="width:80,template: uglcw.util.template($('#formatterRemark').html())">备注</div>
                        <div data-field="sendList"
                             uglcw-options="width:300,template: uglcw.util.template($('#formatterSendList').html())">发起人
                        </div>
                        <div data-field="mlist"
                             uglcw-options="width:300,template: uglcw.util.template($('#formatterMembers').html())">审核人
                        </div>
                        <div data-field="approver"
                             uglcw-options="width:80,template: uglcw.util.template($('#formatterApprover').html())">最终审批人
                        </div>
                        <div data-field="execList"
                             uglcw-options="width:300,template: uglcw.util.template($('#formatterExecList').html())">执行人
                        </div>
                        <div data-field="isMobile"
                             uglcw-options="width:70, template: uglcw.util.template($('#formatterIsMobile').html())">同步手机
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="formatterTp">
    <%--{text:'类型', value: 1},{text:'时间', value: 2},{text:'详情', value: 3},{text:'金额', value: 4},{text:'备注', value: 5}--%>
    # var tp = data.tp; #
    # if(tp){ #
    # var pin = ''; #
    # var str = tp.split(','); #
    # for(var i = 0; i < str.length; i++){ #
    # var s = str[i]; #
    # if('1' == s){ #
    # pin += "类型," #
    # }else if('2' == s){ #
    #  pin += "时间," #
    #  }else if('3' == s){ #
    #  pin += "详情," #
    # }else if('4' == s){ #
    #  pin += "金额," #
    # }else if('5' == s){ #
    #  pin += "备注," #
    # } else if('6' == s){ #
    #  pin += "对象," #
    # }else if('7' == s){ #
    #  pin += "账户," #
    # }else if('8' == s){ #
    #  pin += "关联单," #
    # }#
    # } #
    # if('' != pin){ #
    # pin = pin.substring(0, pin.length -1); #
    # } #
    #: pin #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterStatus">
    # if('1' == data.status ){ #
    <button class="k-button k-success" onclick="updateState(#= data.id#, #= data.status #, #= data.systemId #)">禁用</button>
    # }else{ #
    <button class="k-button k-success" onclick="updateState(#= data.id#, #= data.status #, #= data.systemId #)">启用</button>
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterIsMobile">
    # if('1' == data.isMobile ){ #
    <button class="k-button k-success" onclick="updateIsMobile(#= data.id#, #= data.isMobile #)">同步手机</button>
    # }else{ #
    <button class="k-button k-success" onclick="updateIsMobile(#= data.id#, #= data.isMobile #)">已同步</button>
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterIsSy">
    # if('1' == data.isSy ){ #
    私用
    # }else{ #
    公用
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterSendList">
    # var memberList = data.sendList; #
    # if(memberList){ #
    # var pin = ''; #
    # for(var i = 0; i < memberList.length; i++){ #
    # var member = memberList[i]; #
    # if(member){ #
    # pin += member.memberNm + ","; #
    # } #
    # } #
    # pin = pin.substring(0, pin.length -1); #
    #: pin #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterExecList">
    # var memberList = data.execList; #
    # if(memberList){ #
    # var pin = ''; #
    # for(var i = 0; i < memberList.length; i++){ #
    # var member = memberList[i]; #
    # if(member){ #
    # pin += member.memberNm + ","; #
    # } #
    # } #
    # pin = pin.substring(0, pin.length -1); #
    #: pin #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterMembers">
    # var memberList = data.mlist; #
    # if(memberList){ #
    # var pin = ''; #
    # for(var i = 0; i < memberList.length; i++){ #
    # var member = memberList[i]; #
    # if(member){ #
    # pin += member.memberNm + ","; #
    # } #
    # } #
    # pin = pin.substring(0, pin.length -1); #
    #: pin #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterApprover">
    # var member = data.approver; #
    # if(member){ #
    #: member.memberNm #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterDetail">
    # if(data.tp.search("3") != -1){ #
    # if(data.detailName){ #
    #: data.detailName #
    # }else{ #
    详情
    # } #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterAmount">
    # if(data.tp.search("5") != -1){ #
    # if(data.amountName){ #
    #: data.amountName #
    # }else{ #
    金额
    # } #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterTime">
    # if(data.tp.search("2") != -1){ #
    # if(data.timeName){ #
    #: data.timeName #
    # }else{ #
    开始时间，结束时间
    # } #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterType">
    # if(data.tp.search("1") != -1){ #
    # if(data.typeName){ #
    #: data.typeName #
    # }else{ #
    类型
    # } #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterObject">
    # if(data.tp.search("6") != -1){ #
    # if(data.objectName){ #
    #: data.objectName #
    # }else{ #
    对象
    # } #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterAccount">
    # if(data.tp.search("7") != -1){ #
    # if(data.accountName){ #
    #: data.accountName #
    # }else{ #
    账户
    # } #
    # } #
</script>
<script type="text/x-uglcw-template" id="formatterRemark">
    # if(data.tp.search("4") != -1){ #
    # if(data.remarkName){ #
    #: data.remarkName #
    # }else{ #
    备注
    # } #
    # } #
</script>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toAdd();">
        <span class="k-icon k-i-plus"></span>添加审批
    </a>
    <a role="button" href="javascript:toUpdate();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>修改审批
    </a>
</script>

<script id="header_sort" type="text/x-uglcw-template">
    <span onclick="javascript:operateSort('sort');">排序✎</span>
</script>

<script id="num" type="text/x-uglcw-template">
    # var id = data.id #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric"
           uglcw-validate="number"
           style="height:25px;display:none"
           onchange="changeSort(this,'#=field#',#= id #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=id#">#= val #</span>
</script>

<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator" id="fromAudit">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <input uglcw-role="textbox" uglcw-model="sort" type="hidden">
                    <input uglcw-role="textbox" uglcw-model="isMobile" type="hidden">
                    <input uglcw-role="textbox" uglcw-model="status" type="hidden">
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">审批名称</label>
                    <div class="col-xs-16">
                        <input style="width: 280px;" uglcw-model="zdyNm" id="zdyNm" uglcw-role="textbox" uglcw-validate="required"
                               placeholder="请输入名称">
                    </div>
                </div>
                <div class="form-group" id="divModel">
                    <label class="control-label col-xs-6">审批模板</label>
                    <div class="col-xs-16">
                        <input uglcw-role="combobox" class="dialog-width" uglcw-model="modelId" id="modelId" uglcw-validate="required"
                               uglcw-options="
                               <%--index: 0,//默认选中--%>
                                    url: '${base}manager/queryAuditModelList',
                                    change:function(){ changeAuditModel(this.dataItem()) },
                                    dataTextField: 'name',
                                    dataValueField: 'id'"
                        />
                    </div>
                </div>
                <div class="form-group">
                    <span class="tip-red col-xs-offset-6">备注：如果修改“审批模板”，对应的“审批科目设置”的科目会清空</span>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">表单要素</label>
                    <div class="col-xs-16">
                        <input uglcw-role="multiselect" class="dialog-width" uglcw-model="tp" id="formTp"
                               uglcw-options="
                                       dataSource:[
                                        {text:'类型', value: 1},{text:'时间', value: 2},{text:'详情', value: 3},{text:'备注', value: 4},{text:'金额', value: 5},
                                        {text:'对象', value: 6},{text:'账户', value: 7},{text:'关联单', value: 8}
                                       ]"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">使用类型</label>
                    <div class="col-xs-16">
                        <div>
                            <ul uglcw-role="radio" uglcw-model="isSy" id="isSy"
                                uglcw-options='layout:"horizontal",
                                    change:function(){ changeIsSy() },
                                    dataSource:[{"text":"公用","value":"2"},{"text":"私用","value":"1"}]
                                    '>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="sendDiv">
                    <label class="control-label col-xs-6">发 起 人</label>
                    <div class="col-xs-16">
                        <input uglcw-role="multiselect" class="dialog-width" uglcw-model="sendIds"
                               uglcw-options="
                                    url: '${base}manager/queryMemberList?memberUse=1',
                                    dataTextField: 'memberNm',
                                    dataValueField: 'memberId'
                                ">
                        <div class="xxzf-more dialog-width">
                            1.选择‘私用’，发起人默认自己<br/>
                            2.选择‘公用’，为空时默认全部
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">审 核 人</label>
                    <div class="col-xs-16">
                        <input uglcw-role="multiselect" class="dialog-width" uglcw-model="memIds"
                               uglcw-options="
                                    url: '${base}manager/queryMemberList?memberUse=1',
                                    dataTextField: 'memberNm',
                                    dataValueField: 'memberId'
                                ">
                        <input type="checkbox" id="isUpdateAudit" uglcw-model="isUpdateAudit" uglcw-role="checkbox" uglcw-value="1">
                        <label for="isUpdateAudit">可修改</label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">最终审批人</label>
                    <div class="col-xs-16">
                        <select class="dialog-width" uglcw-role="combobox" uglcw-model="approverId"
                                uglcw-options="
                                    url: '${base}manager/queryMemberList?memberUse=1',
                                    loadFilter:{
                                        data: function(response){return response ||[];}
                                    },
                                    dataTextField: 'memberNm',
                                    dataValueField: 'memberId'
                                ">
                        </select>
                        <input type="checkbox" id="isUpdateApprover" uglcw-model="isUpdateApprover" uglcw-role="checkbox" uglcw-options="type:'number'" uglcw-value="1">
                        <label for="isUpdateApprover">可修改</label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">执 行 人</label>
                    <div class="col-xs-16">
                        <input uglcw-role="multiselect" class="dialog-width" uglcw-model="execIds"
                               uglcw-options="
                                    url: '${base}manager/queryMemberList?memberUse=1',
                                    dataTextField: 'memberNm',
                                    dataValueField: 'memberId'
                                ">
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
        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })
        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()

    })

    //1.私用 2.公用
    function changeIsSy() {
        var value = uglcw.ui.get('#isSy').value();
        if (value == 1) {
            $('#sendDiv').addClass('hide');//隐藏发起人
        } else {
            $('#sendDiv').removeClass('hide');//显示发起人
        }
    }


    function toUpdate() {//修改
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function toAdd() {
        edit(null);
    }

    //添加或修改
    var modalId;
    function edit(row) {
        modalId = uglcw.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                if (row) {
                    uglcw.ui.bind($(container), row);
                    //行政办公审批模板:可编辑
                    var modelId = row.modelId;
                    if (modelId && modelId != '2') {
                        uglcw.ui.get('#formTp').enable(false);
                    } else {
                        uglcw.ui.get('#formTp').enable(true);
                    }
                    //审批人，最终审批人：是否可以修改 0：不可以  1或空：可以
                    if(row.isUpdateAudit == '0'){
                        uglcw.ui.get('#isUpdateAudit').value('0')
                    }
                    if(row.isUpdateApprover == '0'){
                        uglcw.ui.get('#isUpdateApprover').value('0')
                    }
                    if(row.systemId){
                        uglcw.ui.get('#zdyNm').enable(false);
                        uglcw.ui.get('#isSy').enable(false);
                        uglcw.ui.get('#modelId').enable(false);
                    }
                }else{
                    uglcw.ui.get('#formTp').enable(true);
                }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                if(row && row.modelId && row.modelId != data.modelId){
                    showTip(data)
                }else {
                    saveAuditZdy(data)
                }
                return false;
            }
        })
    }

    var modalIndexTip;
    function showTip(data) {
        modalIndexTip = uglcw.ui.confirm('“审批模板”跟原来不一致，对应的“审批科目设置”的科目会清空;你确定要修改吗？', function () {
            saveAuditZdy(data)
        }, function () {
        })
    }

    function saveAuditZdy(data) {
        $.ajax({
            url: '${base}manager/saveAuditZdy',
            type: 'post',
            data: JSON.stringify(data),
            contentType: 'application/json',
            async: false,
            success: function (resp) {
                if (resp === '1') {
                    uglcw.ui.Modal.close(modalId);
                    uglcw.ui.Modal.close(modalIndexTip);
                    uglcw.ui.success('添加成功');
                    uglcw.ui.get('#grid').reload();
                } else if (resp === '2') {
                    uglcw.ui.error('该审批流名称已存在');
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })
    }


    //切换审批模板
    function changeAuditModel(data) {
        if(data){
            //批量赋值
            uglcw.ui.bind('form', {
                tp: data.tp,
                isSy:2
            })
            //行政办公审批模板:可编辑(id == '2')
            if ( "2" == data.id) {
                uglcw.ui.get('#formTp').enable(true);
            } else {
                uglcw.ui.get('#formTp').enable(false);
            }
        }else {
            uglcw.ui.bind('form', {
                tp: "",
            })
            uglcw.ui.get('#formTp').enable(true);
        }
    }

    //修改状态
    function updateState(id, status, systemId) {
        if(systemId){
            uglcw.ui.toast("系统默认的审批流不能操作！！！")
            return
        }
        var tip = '是否禁用该审批？'
        if('1' == status){
            tip = '是否启用该审批？'
        }
        uglcw.ui.confirm(tip,function () {
            $.ajax({
                url: '${base}manager/updateAuditZdyStatus',
                type: 'post',
                data: {id: id},
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.success( '操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败');
                    }

                }
            })
        })
    }

    //修改状态
    function updateIsMobile(id, isMobile) {
        var tip = '是否取消同步手机？'
        if('1' == isMobile){
            tip = '是否确定同步手机？'
        }
        uglcw.ui.confirm(tip,function () {
            $.ajax({
                url: '${base}manager/updateAuditZdyIsMobile',
                type: 'post',
                data: {id: id},
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.success( '操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败');
                    }

                }
            })
        })
    }

    function operateSort(field) {
        var display = $("." + field + "_input").css('display');
        if (display == 'none') {
            $("." + field + "_input").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").hide();
            $("." + field + "_span").show();
        }
    }

    function changeSort(element,field,id) {
        if (isNaN(element.value)) {
            alert("请输入数字");
            return;
        }
        $.ajax({
            url: "${base}manager/updateAuditZdySort",
            type: "post",
            data: "&id=" + id + "&sort=" + element.value,
            success: function (response) {
                if (response.code == 200) {
                    uglcw.ui.success("操作成功");
                    $("#"+field+"_span_"+id).text(element.value);
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }




</script>
</body>
</html>
