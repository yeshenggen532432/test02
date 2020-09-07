<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-search input, select {
            height: 30px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card master">
        <form class="form-horizontal" uglcw-role="validator">
            <div class="layui-card-header btn-group">
                <ul uglcw-role="buttongroup">
                    <c:if test="${rebateIn.status eq -2 }">
                        <li onclick="submitStk()" class="k-info" data-icon="save" id="btnsave">保存</li>

                        <li onclick="audit()" class="k-info" data-icon="check" id="btnsave">审批</li>
                    </c:if>
                    <c:if test="${rebateIn.status ne 2 }">
                        <li onclick="cancel()" id="btncancel" class="k-error" data-icon="delete">作废
                        </li>
                    </c:if>
                </ul>

            </div>
            <div class="layui-card-body">
                <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${rebateIn.id }"/>
                <input uglcw-role="textbox" type="hidden" id="billId" uglcw-model="billId" value="${rebateIn.id }"/>
                <input uglcw-role="textbox" type="hidden" id="status" uglcw-model="status" value="${rebateIn.status }"/>
                <input uglcw-role="textbox" type="hidden" id="inDate" uglcw-model="inDate" value="${rebateIn.inDate }"/>
                <input uglcw-role="textbox" type="hidden" id="proName" uglcw-model="proName" value="${rebateIn.proName }"/>
                <input uglcw-role="textbox" type="hidden" id="proId" uglcw-model="proId" value="${rebateIn.proId }"/>
                <input uglcw-role="textbox" type="hidden" id="inType" uglcw-model="inType" value="${rebateIn.inType }"/>
                <div class="form-group">
                    <label class="control-label col-xs-3">单&nbsp;&nbsp;据&nbsp;&nbsp;号</label>
                    <div class="col-xs-4">
                        <input uglcw-role="gridselector"
                               uglcw-options="
                                   icon: 'k-i-search',
                                   tooltip: '点击图标查看采购单',
                                   click: function(){
                                       showRelateBill(${rebateIn.relateId});
                                   }
                                "
                               value="${rebateIn.billNo}" readonly>

                    </div>

                    <label class="control-label col-xs-3">单据时间</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" value="${rebateIn.inDate}" readonly>
                    </div>
                    <label class="control-label col-xs-3">收款状态</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" value="${rebateIn.payStatus}" readonly>
                    </div>
                </div>
                <div class="form-group" style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}">
                    <label class="control-label col-xs-3">往来单位</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" value="${rebateIn.proName}" readonly>
                    </div>
                    <label class="control-label col-xs-3">返利金额</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" value="${rebateIn.totalAmt}" readonly>
                    </div>
                    <label class="control-label col-xs-3">单据状态</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" id="auditStatus"
                        <c:if test="${rebateIn.status eq -2 }">
                               value="暂存"
                        </c:if>
                        <c:if test="${rebateIn.status eq 1 }">
                               value="已审批"
                        </c:if>
                        <c:if test="${rebateIn.status eq 2 }">
                               value="已作废"
                        </c:if> readonly>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options='
                          responsive:[".master",40],
                          id: "id",
                          rowNumber: true,
                          checkbox: false,
                          editable: true,
                          dragable: true,
                          height:400,
                          navigatable: true,
                           dataSource:${fns:toJson(rebateIn.list)}
                        '
            >
                <div data-field="wareId" uglcw-options="width: 120">序号</div>
                <div data-field="wareCode" uglcw-options="width: 160">产品编号</div>
                <div data-field="wareNm" uglcw-options="width: 200">产品名称</div>
                <div data-field="wareGg" uglcw-options="width: 180">产品规格</div>
                <div data-field="unitName" uglcw-options="width: 120">单位</div>
                <div data-field="qty" uglcw-options="width: 100">采购数量</div>
                <div data-field="rebatePrice" uglcw-options="width: 120">单件返利</div>
                <div data-field="amt" uglcw-options="width: 120">返利金额</div>
            </div>
        </div>
    </div>
</div>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    })

    function submitStk() { //保存
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            return uglcw.ui.warning('该单据已审批，不能保存!');
        }
        if (status == 2) {
            return uglcw.ui.warning('该单据已作废，不能保存!');
        }
        var data = uglcw.ui.bind('.master');
        var list = uglcw.ui.get('#grid').value();

        $(list).each(function (i, row) {
            $.map(row, function (v, k) {
                data['list[' + i + '].' + k] = v;
            })
        })

        uglcw.ui.confirm('保存后将不能修改，是否确定保存？', function () {

            $.ajax({
                url: '${base}manager/stkRebateIn/save',
                type: 'post',
                data: data,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.get('#auditStatus').value('提交成功')
                    } else {
                        uglcw.ui.error(json.msg);
                    }
                    uglcw.ui.loaded();
                }
            })


        })
    }

    function audit() {  //审批
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            uglcw.ui.warning('单据已审批，不能在审批!');
            return;
        }
        if (status == 2) {
            uglcw.ui.warning('单据已作废，不能在审批!！');
            return;
        }

        uglcw.ui.confirm('是否确定审批？', function () {
            $.ajax({
                url: '${base}manager/stkRebateIn/audit',
                type: 'post',
                data: {billId: billId},
                dataType: 'json',
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.get("#status").value(1);
                        uglcw.ui.get('#auditStatus').value('审批成功');
                    } else {
                        uglcw.ui.error(json.msg);
                    }
                    uglcw.ui.loaded();
                }
            })

        })
    }



    function cancel() { //作废
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (status == 2) {
            uglcw.ui.warning("单据已作废!");
            return;
        }
        uglcw.ui.confirm('是否确定作废?', function () {
            $.ajax({
                url: "${base}/manager/stkRebateIn/cancel",
                type: "post",
                data: {"billId": billId},
                dataType: 'json',
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.get("#status").value(2);
                        uglcw.ui.get("#auditStatus").value("作废成功");
                    } else {
                        uglcw.ui.error(json.msg);
                    }
                }
            });
        });
    }

    function showRelateBill(realteId){
        uglcw.ui.openTab('采购单' + realteId,'${base}manager/showstkin?billId=' + realteId);
    }


</script>
</body>
</html>
