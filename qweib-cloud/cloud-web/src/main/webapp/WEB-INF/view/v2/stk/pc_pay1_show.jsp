<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>付款记录</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-xs-8">
                    付款单号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.billNo}" readonly>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    单号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="gridselector" value="${model.sourceBillNo}"
                           uglcw-options="icon:'k-i-info', click: function(){
                            uglcw.ui.openTab('单据信息', '${base}manager/showstkin?dataTp=1&billId=${model.billId}')
                           }">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    单据状态
                </label>
                <div class="col-xs-16">
                    <c:if test="${model.status eq 0 }">正常单</c:if>
                    <c:if test="${model.status eq 2 }"><span
                            style="color:blue;text-decoration:line-through;font-weight:bold;">作废单</span></c:if>
                    <c:if test="${model.status eq 3 }"><span style="color:#FF00FF;font-weight:bold;">被冲红单</span></c:if>
                    <c:if test="${model.status eq 4 }"><span style="color:red;font-weight:bold;">冲红单</span></c:if>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    往来单位
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" readonly value="${model.proName}">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    <c:if test="${model.billType eq 1}">
                        核销金额
                    </c:if>
                    <c:if test="${model.billType eq 0}">
                        已付款
                    </c:if>
                    <c:if test="${model.billType eq 2}">
                        已付款
                    </c:if>
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.sumAmt}" readonly>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    <c:if test="${model.billType eq 1}">
                        核销时间
                    </c:if>
                    <c:if test="${model.billType eq 0}">
                        付款时间
                    </c:if>
                    <c:if test="${model.billType eq 2}">
                        付款时间
                    </c:if>
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="datetimepicker" uglcw-options="format: 'yyyy-MM-dd HH:mm'" value="${model.payTime}">
                </div>
            </div>
            <c:if test="${not empty model.preNo || (model.preAmt ne 0 && not empty model.preAmt)}">
                <div class="form-group">
                    <label class="control-label col-xs-8">
                        往来预付款单
                    </label>
                    <div class="col-xs-16">
                        <input uglcw-role="gridselector" value="${model.preNo}"
                               uglcw-options="icon:'k-i-info',
                                readonly: true
                                click:function(){
                               uglcw.ui.openTab('往来预付信息', '${base}manager/showFinPreOutEdit?billId=${model.preId}');
                           }">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">
                        抵扣款金额
                    </label>
                    <div class="col-xs-16">
                        <input uglcw-role="textbox" value="${model.preAmt}">
                    </div>
                </div>
            </c:if>
            <c:if test="${ model.preAmt ne 0}">
                <div class="form-group">
                    <label class="control-label col-xs-8">
                        实际付款金额
                    </label>
                    <div class="col-xs-16">
                        <input uglcw-role="textbox" value="${model.sumAmt-model.preAmt}">
                    </div>
                </div>
            </c:if>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    备注
                </label>
                <div class="col-xs-16">
                    <textarea uglcw-role="textbox">${model.remarks}</textarea>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-xs-6">
            </label>
            <div class="col-xs-16">
                <div id="grid" uglcw-role="grid"
                     uglcw-options='
                  responsive:[".master",40],
                  id: "id",
                  editable: false,
                  height:250,
                  autoAppendRow:false,
                  navigatable: true,
                  aggregate: [
                    {field: "sumAmt", aggregate: "sum"}
                  ],
                  dataSource:${fns:toJson(model.subList)}
                '
                >
                    <div data-field="proName"
                         uglcw-options="width: 120,editable: false, footerTemplate: '合计:'">往来客户
                    </div>
                    <div data-field="sourceBillNo" uglcw-options="width: 150,template: uglcw.util.template($('#formatterEvent').html())">关联单号
                    </div>
                    <div data-field="sumAmt"
                         uglcw-options="width: 100,editable:false, footerTemplate: '#= uglcw.util.toString(sum,\'n2\')#', format: '{0:n2}'">
                        金额
                    </div>
                </div>
            </div>
        </div>


    </div>
</div>
<script id="formatterEvent" type="text/x-uglcw-template">
    #if(data.sourceBillNo.indexOf("CSH")!=-1){#
    #= data.sourceBillNo#
    #}else{#
    <a style="color:blue;" href="javascript:showSourceBill(#=data.billId#)">#=data.sourceBillNo#</a>
    #}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })


    function showSourceBill(sourceBillId) {
        uglcw.ui.openTab('单据信息' + sourceBillId, '${base}manager/showstkin?dataTp=1&billId=' + sourceBillId);
    }
</script>
</body>
</html>
