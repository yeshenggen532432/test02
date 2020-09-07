<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card master">
                <%--按钮--%>
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <ul uglcw-role="buttongroup">
                            <c:if test="${cx}">
                                <li uglcw-state="2" onclick="cx()" class="k-info">
                                    撤销
                                </li>
                            </c:if>
                            <c:if test="${ty}">
                                <li uglcw-state="2" onclick="checkCommon(2,null)" class="k-info">
                                    同意
                                </li>
                            </c:if>
                            <c:if test="${jj}">
                                <li uglcw-state="2" onclick="checkCommon(3,null)" class="k-info">
                                    拒绝
                                </li>
                            </c:if>
                            <c:if test="${zj}">
                                <li uglcw-state="2" onclick="selectEmployee()" class="k-info">
                                    转交
                                </li>
                            </c:if>
                            <c:if test="${back}">
                                <li uglcw-state="2" onclick="checkCommon(6,null)" class="k-info">
                                    回退
                                </li>
                            </c:if>
                            <c:if test="${zx}">
                                <li uglcw-state="2" onclick="updateAuditExecStatus()" class="k-info">
                                    执行完成
                                </li>
                            </c:if>
                        </ul>
                    </ul>
                </div>
                <%--标题等等--%>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="auditNo" value="${audit.auditNo}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-2">标&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;题</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" uglcw-model="title" value="${audit.title}" disabled/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">类&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;型</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" uglcw-model="tp" value="${audit.tp}" disabled/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">金&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;额</label>
                            <div class="col-xs-4">
                                <input uglcw-role="numeric" uglcw-model="amount" uglcw-options="format: 'n2',spinners: false"
                                       value="${audit.amount}" disabled/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">开始时间</label>
                            <div class="col-xs-4">
                                <input uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd'" uglcw-model="stime"
                                       value="${audit.stime}" disabled>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">结束时间</label>
                            <div class="col-xs-4">
                                <input uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd'" uglcw-model="etime"
                                       value="${audit.etime}" disabled>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-4">
                        <textarea uglcw-role="textbox" uglcw-model="auditData" disabled
                                  style="width: 100%;">${audit.auditData}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">详&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;情</label>
                            <div class="col-xs-4">
                                <textarea uglcw-role="textbox" uglcw-model="dsc" disabled
                                          style="width: 100%;">${audit.dsc}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">付款对象</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" uglcw-model="tp" value="${audit.objectName}" disabled/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">付款账户</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" uglcw-model="tp" value="${audit.accName}" disabled/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">执&nbsp;&nbsp;&nbsp;行&nbsp;&nbsp;&nbsp;人</label>
                            <div class="col-xs-4">
                                <input uglcw-role="multiselect" class="dialog-width" uglcw-model="execIds" disabled
                                       uglcw-options='
                                        value:${fns:toJson(fn:split(audit.execIds, ","))},
                                        url: "${base}manager/queryMemberList?memberUse=1",
                                        dataTextField: "memberNm",
                                        dataValueField: "memberId"
                                '>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">图&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;片</label>
                            <div class="col-xs-16">
                                <div class="uglcw-album">
                                    <div id="album-list" class="album-list">
                                        <c:forEach items="${audit.picList}" var="item" varStatus="s">
                                            <div class="album-item">
                                                <img src="/upload/${item.picMini}">
                                                <div class="album-item-cover">
                                                    <i class="ion-ios-eye"
                                                       onclick="preview(${s.index})"></i>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-2">附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件</label>
                            <div class="col-xs-16">
                                <c:forEach items="${audit.fileList}" var="item" varStatus="s">
                                    <c:choose>
                                        <c:when test="${item.ext == 'png' || item.ext == 'jpg' || item.ext == 'jpeg'}">
                                            <div class="album-item">
                                                <img src="/upload/${item.path}">
                                                <div class="album-item-cover">
                                                    <i class="ion-ios-eye" onclick="previewFile(${item.path})"></i>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="k-button" href="/upload/${item.path}"  charset="UTF-8" target="_blank"> <i class="k-icon k-i-download"></i>${item.origin}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
    <%--流程--%>
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                            responsive:['.header',40],
                            id:'id',
                            dataSource: dataSource,
                        }">
                        <div data-field="memberNm" uglcw-options="width:160,tooltip:true">用户名</div>
                        <div data-field="checkTime" uglcw-options="width:160,tooltip:true">时间</div>
                        <div data-field="checkTp"
                             uglcw-options="width:70, template: uglcw.util.template($('#formatterCheckTp').html())">类型
                        </div>
                        <div data-field="dsc" uglcw-options="width:160,tooltip:true">理由</div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script type="text/x-uglcw-template" id="formatterCheckTp">
    # if('1' == data.isCheck){ #
    审批中
    # } else {  #
    # if('1' == data.checkTp){ #
    发起申请
    # } else if('2' == data.checkTp){ #
    同意
    # } else if('3' == data.checkTp){ #
    拒绝
    # } else if('4' == data.checkTp){ #
    转交
    # } else if('5' == data.checkTp){ #
    撤销
    # } else if('6' == data.checkTp){ #
    回退
    # } #
    # } #
</script>
<script id="tip" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-4">理由</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" uglcw-model="dsc" placeholder="非必填">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/biz/salesorder/templates.jsp" %>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}/resource/stkstyle/js/Map.js"></script>
<script src="${base}/static/uglcu/plugins/intro/intro.min.js"></script>
<script src="${base}static/uglcs/jquery/jquery.hotkeys.js"></script>
<script src="${base}static/uglcu/biz/erp/salesorder.js?v=20200106"></script>
<script src="${base}/static/uglcu/plugins/jquery.scannerdetection.js"></script>
<script src="${base}/static/uglcu/biz/common.js"></script>
<script>
    var dataSource = ${fns:toJson(audit.checkList)};
    var picList = ${fns:toJson(audit.picList)};
</script>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })

    /**
     * 撤销
     */
    function cx() {
        var data = uglcw.ui.bind('form');
        uglcw.ui.confirm('是否确定撤销吗？', function () {
            $.ajax({
                url: '${base}manager/cancelAudit?auditNo=' + data.auditNo,
                type: 'post',
                dataType: 'json',
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('撤销成功');
                        setTimeout(function () {
                            uglcw.ui.reload();
                        }, 500);
                    } else {
                        uglcw.ui.error(json.msg);
                    }
                },
                error: function () {
                    uglcw.ui.error('撤销失败');
                }
            })
        })
    }

    /**
     * 审核（同意/拒绝/转交/退回）
     * checkTp 审核类型 2 同意 3 拒绝 4 转交 6退回到上个
     */
    function checkCommon(checkTp, memId) {
        var data = uglcw.ui.bind('form');
        var tip = '';
        if ('2' == checkTp) {
            tip = '同意';
        } else if ('3' == checkTp) {
            tip = '拒绝';
        } else if ('4' == checkTp) {
            tip = '转交';
        } else if ('5' == checkTp) {
            tip = '撤销';
        } else if ('6' == checkTp) {
            tip = '回退';
        }
        uglcw.ui.Modal.open({
            title: tip,
            area: '300px',
            content: $('#tip').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var bind = uglcw.ui.bind(container);
                $.ajax({
                    url: '${base}manager/toCheck',
                    type: 'post',
                    data: {"auditNo": data.auditNo, "checkTp": checkTp, "dsc": bind.dsc, "memId": memId},
                    dataType: 'json',
                    success: function (json) {
                        if (json.state) {
                            uglcw.ui.success(tip + '成功');
                            setTimeout(function () {
                                uglcw.ui.reload();
                            }, 500);
                        } else {
                            uglcw.ui.error(json.msg);
                        }
                    },
                    error: function () {
                        uglcw.ui.error(tip + '失败');
                    }
                })
            }
        });
    }

    /**
     * 撤销
     */
    function updateAuditExecStatus() {
        var data = uglcw.ui.bind('form');
        uglcw.ui.confirm('是否确定执行完成吗？', function () {
            $.ajax({
                url: '${base}manager/updateAuditExecStatus?auditNo=' + data.auditNo,
                type: 'post',
                dataType: 'json',
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('执行成功');
                        setTimeout(function () {
                            uglcw.ui.reload();
                        }, 500);
                    } else {
                        uglcw.ui.error(json.msg);
                    }
                },
                error: function () {
                    uglcw.ui.error('执行失败');
                }
            })
        })
    }

    /**
     * 业务员挑选弹框
     */
    function selectEmployee() {
        <tag:dept-employee-selector checkbox="false" callback="onEmployeeSelect"/>
    }

    /**
     * 业务员挑选回调
     */
    function onEmployeeSelect(data) {
        if (data && data.length > 0) {
            var employee = data[0];
            checkCommon(4, employee.memberId);
        }
    }


    function preview(index) {
        var audit = ${fns:toJson(audit)};
        layer.photos({
            photos: {
                start: index, data: $.map(audit.picList, function (item) {
                    return {
                        src: '/upload/' + item.pic,
                        pid: item.id,
                        alt: item.pic,
                        thumb: '/upload/' + item.picMini
                    }
                })
            }, anim: 5
        });
    }

    // 放大图片
    function previewFile(pic) {
        var picList = [];
        picList.push(pic)
        layer.photos({
            photos: {
                start: 0, data: $.map(picList, function (item) {
                    return {
                        src: '/upload/' + item,
                        pid: item.id,
                        alt: item.pic,
                        thumb: '/upload/' + item.pic
                    }
                })
            }, anim: 5
        });
    }


</script>
</body>
</html>
