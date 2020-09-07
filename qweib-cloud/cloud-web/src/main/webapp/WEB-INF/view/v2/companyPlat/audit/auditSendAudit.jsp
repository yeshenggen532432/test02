<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>发起审批--具体的审批模板</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-header">
            <button id="save" uglcw-role="button" class="k-info" data-icon="save" onclick="javascript:save();">
                保存
            </button>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="layui-card">
                    <div class="layui-card-body">
                        <%--隐藏的--%>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="modelId" value="${auditModel.id}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="zdyId"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="auditTp" value="6"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="objectType"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">审批类型</label>
                            <div class="col-xs-4">
                                <input id="gridselector" uglcw-role="gridselector" uglcw-model="zdyNm" placeholder="非必填"
                                       uglcw-options="allowInput: false, click: showDialogAuditZdy">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">标&emsp;&emsp;题</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" uglcw-model="title" uglcw-validate="required" placeholder="必填"/>
                            </div>
                        </div>
                        <c:if test="${fn:contains(auditModel.tp, '1')}">
                            <div class="form-group">
                                <label class="control-label col-xs-3">类&emsp;&emsp;型</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="textbox" uglcw-model="tp"/>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${fn:contains(auditModel.tp, '5')}">
                            <div class="form-group">
                                <label class="control-label col-xs-3">金&emsp;&emsp;额</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="numeric" uglcw-model="amount" uglcw-validate="required" placeholder="必填"
                                           uglcw-options="format: 'n2',spinners: false"/>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${fn:contains(auditModel.tp, '2')}">
                            <div class="form-group">
                                <label class="control-label col-xs-3">开始时间</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd'"
                                           uglcw-model="stime">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-xs-3">结束时间</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd'"
                                           uglcw-model="etime">
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${fn:contains(auditModel.tp, '4')}">
                            <div class="form-group">
                                <label class="control-label col-xs-3">备&emsp;&emsp;注</label>
                                <div class="col-xs-4">
                                        <textarea uglcw-role="textbox" uglcw-model="auditData"
                                                  style="width: 100%;"></textarea>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${fn:contains(auditModel.tp, '3')}">
                            <div class="form-group">
                                <label class="control-label col-xs-3">详&emsp;&emsp;情</label>
                                <div class="col-xs-4">
                                            <textarea uglcw-role="textbox" uglcw-model="dsc"
                                                      style="width: 100%;"></textarea>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${fn:contains(auditModel.tp, '6')}">
                            <div class="form-group">
                                <label class="control-label col-xs-3">付款对象</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="gridselector" uglcw-options="click: function(){ selectConsignee(); }" uglcw-model="objectName,objectId" uglcw-validate="required" placeholder="必填"/>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${fn:contains(auditModel.tp, '7')}">
                            <div class="form-group">
                                <label class="control-label col-xs-3">付款账户</label>
                                <div class="col-xs-4">
                                    <select uglcw-role="combobox" uglcw-model="accountId" uglcw-validate="required" placeholder="必填"
                                            uglcw-options="
                                              url: '${base}manager/queryAccountList',
                                              loadFilter:{
                                                data: function(response){return response.rows ||[];}
                                              },
                                              dataTextField: 'accName',
                                              dataValueField: 'id'
                                            ">
                                    </select>
                                </div>
                            </div>
                        </c:if>
                        <div class="form-group">
                            <label class="control-label col-xs-3">审&ensp;核&ensp;人</label>
                            <div class="col-xs-4">
                                <input uglcw-role="multiselect" class="dialog-width" uglcw-model="memIds" id="memIds"
                                       uglcw-options='
                                               url: "${base}manager/queryMemberList?memberUse=1",
                                               dataTextField: "memberNm",
                                               dataValueField: "memberId"
                                            '>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">最终审批人</label>
                            <div class="col-xs-4">
                                <input uglcw-role="multiselect" class="dialog-width" uglcw-model="approverId" id="approverId"
                                       uglcw-options="
                                                url: '${base}manager/queryMemberList?memberUse=1',
                                                dataTextField: 'memberNm',
                                                dataValueField: 'memberId'
                                            ">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">执&ensp;行&ensp;人</label>
                            <div class="col-xs-4">
                                <input uglcw-role="multiselect" class="dialog-width" uglcw-model="execIds"
                                       uglcw-options='
                                                url: "${base}manager/queryMemberList?memberUse=1",
                                                dataTextField: "memberNm",
                                                dataValueField: "memberId"
                                        '>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">图&emsp;&emsp;片</label>
                            <div class="col-xs-16">
                                <div id="album" uglcw-role="album"
                                     uglcw-options="accept:'image/*',aspectRatio:70/35,limit:3,sortable:false"
                                     uglcw-role="album"></div>

                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">附&emsp;&emsp;件</label>
                            <div class="col-xs-6">
                                <input id="files" type="file">
                                <span style="color: red;margin-left: 20px;">温馨提示：附件为(.xls .xlsx .doc .docx .ppt .pptx)文件</span>
                            </div>
                        </div>

                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<tag:compositive-selector-template index="1"/>
<tag:costitem-selector-template/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        //ui:初始化
        uglcw.ui.init();
        new uglcw.ui.Upload('#files').init(attachmentConfig);
        uglcw.ui.loaded();
    })

    var attachmentConfig = {
        validation: {
            // 图片常用格式,'.png','.jpg','.jpeg'
            allowedExtensions: ['.xls', '.xlsx', '.doc', '.docx', '.ppt', '.pptx']
        },
        async: {
            autoUpload: true,
            saveUrl: '${base}manager/upload/single?path=audit',
            saveField: 'file',
            removeField: 'name',
            removeVerb: 'post',
            removeUrl: '${base}manager/upload/remove',
        },
        upload: function (e) {
            e.data = {}
        },
        success: function (e) {
            var response = e.response;
            // console.log('success:' + JSON.stringify(response));
            if (e.operation == 'remove') {

            } else {
                var file = e.files[0];
                if (response.success) {
                    var f = response.data;
                    uglcw.extend(file, f);
                    file.object = f.name.replace('/' + f.bucket + '/', '');
                }
            }

        },
        remove: function (e) {
            var file = e.files[0];
            e.data = {
                bucket: file.bucket,
                object: file.object
            }
        }
    }

    /**
     * 选择对象
     */
    function selectConsignee() {
        <tag:compositive-selector-script callback="onItemChoose"/>
    }

    function onItemChoose(id, name, type) {
        uglcw.ui.bind('.form-horizontal', {objectName: name, objectId: id, objectType: type});
    }

    //保存
    function save() {
        if (!uglcw.ui.get('form').validate()) {
            return;
        }
        var memIds = uglcw.ui.get('#memIds').value();
        var approverId = uglcw.ui.get('#approverId').value();
        if((memIds == null || memIds == '') && (approverId == null || approverId == '')){
            uglcw.ui.toast("审核人和最终审批人至少有一个")
           return;
        }
        var data = uglcw.ui.bindFormData('form');
        //图片
        var album = uglcw.ui.get('#album');
        $(album.value()).each(function (idx, item) {
            if (item.file) {
                data.append('file' + item.fid, item.file, item.title);
            }
        });
        var files = $('#files').data('kendoUpload').getFiles();
        if (files && files.length) {
            data.append("fileJson", JSON.stringify($.map(files, function (file) {
                //过滤不支持的格式
                if (file.origin) {
                    return {
                        size: file.size,
                        name: file.name,
                        origin: file.origin,
                        ext: file.ext
                    }
                }
            })))
        }
        uglcw.ui.confirm('确定保存吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/addAudit',
                type: 'post',
                data: data,
                processData: false,
                contentType: false,
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response === '1') {
                        uglcw.ui.success('保存成功');
                    } else {
                        return uglcw.ui.error('保存失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function showDialogAuditZdy() {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}/manager/queryAuditZdyPageByModelId',
            query: function (params) {
                params.modelId = '${auditModel.id}'
            },
            checkbox: false,
            width: 650,
            height: 400,
            btns: ['确定', '取消'],
            // criteria: '<input uglcw-role="datepicker" uglcw-model="sdate">' +
            //     '<input uglcw-role="datepicker" uglcw-model="edate">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
            //     '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="proName">',
            columns: [
                {field: 'zdyNm', title: '名称', width: 160},
                {field: 'accountName', title: '付款账号', width: 160},
            ],
            yes: function (data) {
                if (data && data.length > 0) {
                    var item = data[0];
                    uglcw.ui.bind('form', {zdyId: item.id, zdyNm: item.zdyNm, accountId:item.accountId, memIds:item.memIds, approverId:item.approverId, execIds:item.execIds});
                    var isUpdateAudit = item.isUpdateAudit;
                    var isUpdateApprover = item.isUpdateApprover;
                    if(isUpdateAudit == '0'){
                        uglcw.ui.get("#memIds").enable(false)
                    }else {
                        uglcw.ui.get("#memIds").enable(true)
                    }
                    if(isUpdateApprover == '0'){
                        uglcw.ui.get("#approverId").enable(false)
                    }else {
                        uglcw.ui.get("#approverId").enable(true)
                    }
                    uglcw.ui.Modal.close();
                }
            }
        })
    }

</script>
</body>
</html>
