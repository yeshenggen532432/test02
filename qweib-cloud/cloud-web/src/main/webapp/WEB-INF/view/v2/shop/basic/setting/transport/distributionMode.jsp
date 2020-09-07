<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>配送方式设置</title>

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
                        <form id="distribution_modeForm">
                            <input uglcw-role="textbox" type="hidden" uglcw-model="name" value="distribution_mode"/>
                            <span style="text-align: right;font-size: 15px;color: blue" onclick="openTab()">点击管理自提点</span>
                            <%--<div class="form-group">
                                <label class="control-label col-xs-4">配送方式选择</label>
                                <div class="col-xs-4">
                                    <input type="radio" name="type" value="1"
                                           <c:if test="${model==null ||  model.type==null || model.type=='1'}">checked</c:if> >快递到家&nbsp;&nbsp;
                                    <input type="radio" name="type" value="2"
                                           <c:if test="${model!=null && model.type=='2'}">checked</c:if>>自提点取货&nbsp;&nbsp;
                                    <input type="radio" name="type" value="3"
                                           <c:if test="${model!=null && model.type=='3'}">checked</c:if>>快递或自提&nbsp;&nbsp;
                                </div>
                            </div>--%>
                            <div class="form-group">
                                <label class="control-label col-xs-4">一、配送方式选择：</label>
                                <div class="col-xs-16">
                                    <ul uglcw-role="radio" uglcw-model="type" id="type"
                                        uglcw-value="${model.type==null?1:model.type}"
                                        uglcw-options='"layout":"horizontal","dataSource":[{"text":"快递到家","value":"1"},{"text":"自提点取货","value":"2"},{"text":"快递或自提","value":"3"}]'></ul>

                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-xs-4">二、自提是否需要运费：</label>
                                <div class="col-xs-16">
                                    <ul uglcw-role="radio" uglcw-model="is_freight" id="is_freight"
                                        uglcw-value="${model.is_freight==null?1:model.is_freight}"
                                        uglcw-options='"layout":"horizontal","dataSource":[{"text":"是","value":"1"},{"text":"否","value":"0"}]'></ul>

                                </div>
                            </div>

                            <div class="form-group">
                                <div class="control-label col-xs-8">
                                    <button type="button" uglcw-role="button" class="k-success" onclick="save();">保存
                                    </button>
                                </div>
                            </div>
                        </form>
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
    function openTab() {
        uglcw.ui.openTab("自提点管理","${base}manager/shopMemberAddress/toPage?hyId=0");
    }
    function save() {
        $.ajax({
            url: '${base}/manager/shopSetting/edit',
            data:$("#distribution_modeForm").serialize(),  //绑定值
            type: 'post',
            success: function (data) {
                if (data.success) {
                    uglcw.ui.success('修改成功');
                    /*setTimeout(function () {
                        uglcw.ui.reload();
                    }, 1000)*/
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })
    }
</script>
</body>
</html>
