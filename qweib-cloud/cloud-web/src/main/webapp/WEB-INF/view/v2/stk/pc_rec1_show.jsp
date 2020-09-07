<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>收款记录</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-xs-8">
                    收款单号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.billNo}" readonly>
                </div>
            </div>
            <c:if test="${not empty model.sourceBillNo }">
            <div class="form-group">
                <label class="control-label col-xs-8">
                    单号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="gridselector" value="${model.sourceBillNo}"
                           uglcw-options="icon:'k-i-info', click: function(){
                            uglcw.ui.openTab('单据信息', '${base}manager/showstkout?dataTp=1&billId=${model.billId}')
                           }">
                </div>
            </div>
            </c:if>
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
                    <input uglcw-role="textbox" readonly value="${model.khNm}">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-xs-8">
                    <c:if test="${model.billType eq 1}">
                        核销金额
                    </c:if>
                    <c:if test="${model.billType eq 0}">
                        已收款
                    </c:if>
                    <c:if test="${model.billType eq 2}">
                        已收款
                    </c:if>
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.sumAmt}" readonly>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-xs-8">
                    收款账号
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.accNo}" readonly>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-xs-8">
                    <c:if test="${model.billType eq 1}">
                        核销时间
                    </c:if>
                    <c:if test="${model.billType eq 0}">
                        收款时间
                    </c:if>
                    <c:if test="${model.billType eq 2}">
                        收款时间
                    </c:if>
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="datetimepicker" uglcw-options="format: 'yyyy-MM-dd HH:mm'" value="${model.recTime}">
                </div>
            </div>
            <c:if test="${ not empty model.xsthAmt && model.xsthAmt ne 0}">
            <div class="form-group">
                <label class="control-label col-xs-8">
                    抵扣应付款
                </label>
                <div class="col-xs-16">
                    <input uglcw-role="textbox" value="${model.xsthAmt}">
                </div>
            </div>
            </c:if>
            <c:if test="${not empty model.preNo|| model.preAmt ne 0}">
                <div class="form-group">
                    <label class="control-label col-xs-8">
                        往来预收款单
                    </label>
                    <div class="col-xs-16">
                        <input uglcw-role="gridselector" value="${model.preNo}"
                               uglcw-options="icon:'k-i-info',
                                readonly: true
                                click:function(){
                               uglcw.ui.openTab('往来预收信息', '${base}manager/showFinPreInEdit?billId=${model.preId}');
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
                <c:if test="${  model.xsthAmt ne 0 or model.preAmt ne 0}">
                <div class="form-group">
                <label class="control-label col-xs-8">
                实际收款金额
                </label>
                <div class="col-xs-16">
                <input uglcw-role="textbox" value="${model.sumAmt-model.preAmt-model.xsthAmt}">
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
                    <div data-field="preAmt"
                         uglcw-options="width: 100,editable:false, format: '{0:n2}'">
                        抵扣预收款
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
        uglcw.ui.openTab('单据信息' + sourceBillId, '${base}manager/showstkout?dataTp=1&billId=' + sourceBillId);
    }
</script>
</body>
</html>