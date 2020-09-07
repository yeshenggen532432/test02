<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>杂费结转</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-in {
            width: 100%;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card master">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <c:if test="${entity.status eq -2}">
                            <li onclick="draftSave()" class="k-info" id="btndraft" data-icon="save">暂存</li>
                            <li onclick="audit()" class="k-info" style="display: ${entity.id eq 0?'none':''}" id="btnaudit" data-icon="track-changes-accept">审批</li>
                        </c:if>
                        <li onclick="saveAudit()" class="k-info"  id="btnsave"  style="display: ${(entity.status eq -2 and entity.id eq 0)?'':'none'}" data-icon="save">保存并审批</li>
                    </ul>
                    <div class="bill-info">
                        <span class="no" style="color: green;">杂费结转单 ${entity.billNo}</span>
                        <span id="billStatus" class="status" style="color:red;">${entity.billStatus}</span>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${entity.id}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="sourceBillId" id="sourceBillId" value="${entity.sourceBillId}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="sourceBillNo" id="sourceBillNo" value="${entity.sourceBillNo}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="disAmt" id="disAmt" value="${entity.disAmt}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="proId" value="${entity.proId}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="proType" value="${entity.proType}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="inType" value="${entity.inType}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${entity.status}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">采购厂家</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" uglcw-validate="required" readonly uglcw-model="proName" value="${entity.proName}"/>
                            </div>
                            <label class="control-label col-xs-3">结算日期</label>
                            <div class="col-xs-4">
                                <input id="billDateStr" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                                       uglcw-model="billDateStr" value="${entity.billDateStr}">
                            </div>
                            <label class="control-label col-xs-3">杂费分摊</label>
                            <div class="col-xs-4">
                                <input uglcw-role="numeric" id="feeAmt"  uglcw-model="feeAmt"uglcw-options="format: 'n2',spinners: false"
                                       value="${entity.feeAmt}" />
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom: 0px;">
                            <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-18">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${entity.remarks}</textarea>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options='
                          id: "id",
                          responsive:[".header",200],
                          editable: true,
                          dragable: true,
                          rowNumber: true,
                          checkbox: false,
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"},
                            {field: "feeAmt", aggregate: "sum"},
                            {field: "totalAmt", aggregate: "sum"}
                          ],
                          dataSource: gridDataSource'
                    >
                        <%--<div data-field="wareCode" uglcw-options="--%>
                            <%--width: 100--%>
                        <%--">产品编号--%>
                        <%--</div>--%>
                        <div data-field="wareNm" uglcw-options="width: 150">产品名称</div>
                        <div data-field="subId" uglcw-options="width: 150,hidden:true">采购明细ID</div>
                        <div data-field="beUnit" uglcw-options="width: 150,hidden:true">单位代码</div>
                        <div data-field="sourceBillId" uglcw-options="width: 150,hidden:true">采购id</div>
                        <div data-field="sourceBillNo" uglcw-options="width: 150,hidden:true">采购单号</div>
                        <div data-field="wareGg" uglcw-options="width: 100">产品规格</div>
                        <div data-field="unitName" uglcw-options="width: 100">单位
                        </div>
                        <div data-field="price"
                             uglcw-options="width: 100,editable:false">
                            采购单价
                        </div>
                        <div data-field="qty" uglcw-options="
                           editable:false,
                            aggregates: ['sum'],
                            width: 100,
                             footerTemplate: '#= (sum||0) #'
                            ">采购数量
                        </div>
                        <div data-field="amt" uglcw-options="editable:false,
                            aggregates: ['sum'],
                            footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#',
                            width: 100
                            ">采购金额
                        </div>
                        <div data-field="feeAmt" uglcw-options="
                            editable:false,
                            aggregates: ['sum'],
                             footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#',
                            width: 100
                            ">杂费
                        </div>
                        <div data-field="totalAmt" uglcw-options="
                            editable:false,
                            aggregates: ['sum'],
                             footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#',
                            width: 100
                        ">采购总成本
                        </div>
                        <div data-field="costPrice" uglcw-options="
                            editable:false,
                            width: 100
                            ">采购总单价
                        </div>
                </div>
            </div>

        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var gridDataSource = ${fns:toJson(warelist)};
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange' && (e.field == 'amt')) {

            }
        })
        uglcw.ui.get('#feeAmt').on('change', function () {
            changeFeeAmt();
        });
        setTimeout(uglcw.ui.loaded, 210);
    })

    function add() {
        uglcw.ui.openTab('杂费开单', '${base}manager/stkExtrasCarryOver/add');
    }

    function scrollToGridBottom() {
        uglcw.ui.get('#grid').scrollBottom()
    }

    function scrollToGridTop() {
        uglcw.ui.get('#grid').scrollTop()
    }

    function saveChanges() {
        uglcw.ui.get('#grid').commit();
    }

    function calTotalAmount() {
        var ds = uglcw.ui.get('#grid').k().dataSource;
        var data = ds.data().toJSON();
        var total = 0;
        $(data).each(function (idx, item) {
            total += (Number(item.amt));
        })
    }

    function changeFeeAmt(){
        var items = uglcw.ui.get('#grid').k().dataSource.data(); //uglcw.ui.get('#grid').k().dataSouce.data();
        var disAmt = $("#disAmt").val();
        var feeAmtSum =$("#feeAmt").val();
        if(feeAmtSum==""){
            feeAmtSum = 0;
        }
        $(items).each(function (index, item) {
               var amt = item.amt;
                item.costPrice = item.price;
                item.feeAmt = 0;
                item.totalAmt = item.amt;
               if(feeAmtSum!=0){
                   var feeAmt = (parseFloat(amt)*parseFloat(feeAmtSum))/parseFloat(disAmt);
                   //feeAmt = Math.floor(feeAmt * 100)/100;
                   feeAmt = feeAmt.toFixed(2)
                   var totalAmt = parseFloat(amt)+parseFloat(feeAmt);
                   //totalAmt = Math.floor(totalAmt * 100)/100;
                   totalAmt = totalAmt.toFixed(2);
                   var qty = item.qty;
                   if(qty!=0){
                       var costPrice = parseFloat(totalAmt)/parseFloat(qty);
                       item.costPrice = Math.floor(costPrice * 1000000000)/1000000000;
                   }
                   item.feeAmt = feeAmt;
                   item.totalAmt = totalAmt;
               }
        })
        uglcw.ui.get('#grid').commit();

    }

    function draftSave() {
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');
        uglcw.ui.get('#grid').commit();
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            return uglcw.ui.warning('该单据已审批，不能操作!')
        }
        if (status == 2) {
            return uglcw.ui.warning('该单据已作废，不能操作!')
        }
        if (!uglcw.ui.get('form').validate()) {
            return;
        }
        var data = uglcw.ui.bind('form');

        var items = uglcw.ui.get('#grid').bind();
        if (items.length < 1) {
            uglcw.ui.error('请选择明细');
            return;
        }
        if(form.feeAmt==""||form.feeAmt==0){
            uglcw.ui.error('请输入杂费金额');
            return;
        }

        var valid = true;
        $(items).each(function (index, item) {
            if (!item.amt) {
               // valid = false;
             //   uglcw.ui.warning('第[' + (index + 1) + ')]行,请选择杂费金额');
             //   return false;
            }
            $.map(item, function (v, k) {
                form['list[' + index + '].' + k] = v;
            })
        })
        if (!valid) {
            return;
        }
        data.id = data.billId;
        data.status = -2;
        data.wareStr = JSON.stringify(items);
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/stkExtrasCarryOver/save',
            type: 'post',
            data: data,
            dataType: 'json',
            success: function (response) {
                uglcw.ui.loaded();
                if (response.state) {
                    $('#billStatus').text('暂存成功');
                    uglcw.ui.get("#status").value(-2);
                    uglcw.ui.get("#billId").value(response.id);
                    $("#btnaudit").show();
                    $("#btnsave").hide();
                    uglcw.ui.success('暂存成功');
                }
            },
            error: function () {
                uglcw.ui.loaded();
            }
        })
    }

    function saveAudit() {//保存并审批
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');
        if (form.status == 1) {
            return uglcw.ui.warning('该单据已审批，不能操作！');
        }
        if (form.status == 2) {
            return uglcw.ui.warning('该单据已作废，不能操作!');
        }
        form.id = form.billId;
        form.status = 1;
        var list = uglcw.ui.get('#grid').bind();
        form.itemsStr = JSON.stringify(list);
        var items = uglcw.ui.get('#grid').bind();//绑定表格数据
        if (items.length == 0) {
            uglcw.ui.error('请选择费用');
            return false;
        }
        if(form.feeAmt==""||form.feeAmt==0){
            uglcw.ui.error('请输入杂费金额');
            return;
        }

        var valid = true;
        $(items).each(function (index, item) {
            if (!item.amt) {
                //valid = false;
               // uglcw.ui.warning('第[' + (index + 1) + ')]行,请选择杂费金额');
               // return false;
            }
            $.map(item, function (v, k) {
                form['list[' + index + '].' + k] = v;
            })
        })
        if (!valid) {
            return;
        }
        form.wareStr = JSON.stringify(items);
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/stkExtrasCarryOver/save',
            type: 'post',
            dataType: 'json',
            data: form,
            success: function (response) {
                uglcw.ui.loaded()
                if (response.state) {
                    uglcw.ui.success('提交成功');
                    uglcw.ui.get("#status").value(1);
                    uglcw.ui.get("#billId").value(response.id);
                    $("#btnaudit").hide();
                    $("#btnsave").hide();
                    $("#btndraft").hide();
                    $('#billStatus').text('提交成功');
                    uglcw.ui.bind('form', response);
                } else {
                    uglcw.ui.error('提交失败');
                }
            },
            error: function () {
                uglcw.ui.loaded()
            }
        })

    }

    function audit() {
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            uglcw.ui.error('该单据已审核');
            return;
        }
        if (status == 2) {
            uglcw.ui.error('单据已作废，不能审批！');
            return;
        }
        uglcw.ui.confirm('是否确定审核？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkExtrasCarryOver/audit',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value()},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('审批成功');
                        $('#billStatus').text('审批成功');
                        uglcw.ui.get("#status").value(1);
                        $("#btnaudit").hide();
                        $("#btnsave").hide();
                        $("#btndraft").hide();
                    }
                }
            })

        })
    }
</script>
</body>
</html>
