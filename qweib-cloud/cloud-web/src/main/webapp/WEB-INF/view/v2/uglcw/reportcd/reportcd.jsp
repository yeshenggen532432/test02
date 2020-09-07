<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>

    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <div class="form-horizontal" uglcw-role="validator" novalidate id="bind">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${reportCd.id}"/>
                        <c:if test="${reportCd.id==1}">
                           <span style="text-align: right;font-size: 15px;color: blue">日报（最少字数限制）</span>
                            <div class="form-group" >
                                <label class="control-label col-xs-4">今日完成工作文字长度</label>
                                <div class="col-xs-4" style="text-align: left">
                                    <input uglcw-role="numeric"
                                           uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500"
                                           uglcw-model="gzNrcd" value="${reportCd.gzNrcd}">
                                </div>
                            </div>
                            <div class="form-group" style="text-align: left">
                                <label class="control-label col-xs-4">未完成工作文字长度</label>
                                <div class="col-xs-4">
                                    <input id="bcName" uglcw-role="numeric"
                                           uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500"
                                           uglcw-model="gzZjcd" value="${reportCd.gzZjcd}">
                                </div>
                            </div>
                            <input type="hidden" uglcw-model="gzJhcd" value="0" uglcw-role="textbox">
                        </c:if>
                        <c:if test="${reportCd.id==2}">
                            <span style="text-align: right;font-size: 15px;color: blue">周报（最少字数限制）</span>
                            <div class="form-group">
                                <label class="control-label col-xs-4">本周完成工作文字长度</label>
                                <div class="col-xs-4">
                                    <input id="gzNrcd" uglcw-role="numeric"
                                           uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500"
                                           uglcw-model="gzNrcd" value="${reportCd.gzNrcd}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-xs-4">本周工作总结文字长度</label>
                                <div class="col-xs-4">
                                    <input id="gzZjcd" uglcw-role="numeric"
                                           uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500"
                                           uglcw-model="gzZjcd" value="${reportCd.gzZjcd}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-xs-4">下周工作计划文字长度</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="numeric"
                                           uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500"
                                           uglcw-model="gzJhcd" value="${reportCd.gzJhcd}">
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${reportCd.id==3}">
                            <span style="text-align: right;font-size: 15px;color: blue">月报（最少字数限制）</span>
                            <div class="form-group">
                                <label class="control-label col-xs-4">本月工作内容文字长度</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="numeric"
                                           uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500"
                                           uglcw-model="gzNrcd" value="${reportCd.gzNrcd}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-xs-4">本月工作总结文字长度</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="numeric"
                                           uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500"
                                           uglcw-model="gzZjcd" value="${reportCd.gzZjcd}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-xs-4">下月工作计划文字长度</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="numeric"
                                           uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500"
                                           uglcw-model="gzJhcd" value="${reportCd.gzJhcd}">
                                </div>
                            </div>
                        </c:if>


                        <div class="form-group">
                            <label class="control-label col-xs-4">需帮助与支持文字长度</label>
                            <div class="col-xs-4">
                                <input id="earlyMinute" uglcw-role="numeric"
                                       uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500"
                                       uglcw-model="gzBzcd"
                                       value="${reportCd.gzBzcd}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-4">备注文字长度</label>
                            <div class="col-xs-4">
                                <input id="lateMinute" uglcw-role="numeric"
                                       uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500"
                                       uglcw-model="remocd"
                                       value="${reportCd.remocd}">

                            </div>
                        </div>
                        <div class="form-group">
                            <div class="control-label col-xs-8">
                                <button uglcw-role="button" class="k-success" onclick="save();">保存</button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })

    function save() {
        $.ajax({
            url: '${base}/manager/updatereportcd',
            data: uglcw.ui.bind($("#bind")),  //绑定值
            type: 'post',
            success: function (data) {
                if (data === "1") {
                    uglcw.ui.success('修改成功');
                    setTimeout(function () {
                        uglcw.ui.reload();
                    }, 1000)
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })
    }

</script>
</body>
</html>
