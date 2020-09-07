<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>报销单-核销单</title>
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
                        <li onclick="add()" data-icon="add" class="k-info">新建</li>
                        <c:if test="${status eq 0}">
                            <li onclick="draftSave()" class="k-info" id="btndraft" data-icon="save">暂存</li>
                                <li onclick="audit()" class="k-info" style="display: ${billId eq 0?'none':''}" id="btnaudit" data-icon="track-changes-accept">审批</li>
                        </c:if>
                        <li onclick="saveAudit()" class="k-info"  id="btnsave"  style="display: ${(status eq 0 and billId eq 0)?'':'none'}" data-icon="save">保存并审批</li>
                    </ul>
                    <div class="bill-info">
                        <span class="no" style="color: green;">报销单-核销单-${billNo}</span>
                        <span id="billStatus" class="status" style="color:red;">${billstatus}</span>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="proId" value="${proId}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="proType" value="${proType}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="depId" id="depId" value="${depId}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="costBillId" id="costBillId"
                               value="${costBillId}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="billType" id="billType" value="${billType}"/>
                        <div class="form-group">

                            <label class="control-label col-xs-3">核销对象</label>
                            <div class="col-xs-4">
                                <input uglcw-role="gridselector" id="proName"  uglcw-validate="required" uglcw-options="click: function(){
                                    selectConsignee();
                                }" uglcw-model="proName,proId" value="${proName}"/>
                            </div>
                            <label class="control-label col-xs-3">核销时间</label>
                            <div class="col-xs-4">
                                <input id="inDate" uglcw-role="datetimepicker"  uglcw-validate="required" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                                       uglcw-model="inDate" value="${payTimeStr}">
                            </div>
                            <label class="control-label col-xs-3">报销单号</label>
                            <div class="col-xs-4">
                                <input uglcw-role="gridselector"  uglcw-options="click: function(){
                                    selectFinCost();
                                }" uglcw-model="costNo" value="${costNo}"/>
                            </div>
                        </div>

                        <div class="form-group" >
                            <label class="control-label col-xs-3">核销金额</label>
                            <div class="col-xs-4">
                                <input uglcw-role="numeric" id="payAmt" disabled uglcw-model="payAmt" uglcw-options="format: 'n2',spinners: false"
                                       value="${payAmt}"/>
                            </div>
                            <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-12">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${remarks}</textarea>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options='
                 responsive:[".master",40],
                  id: "id",
                  <%--url:"${base}manager/queryFinCostSubToPay?billId=${costBillId}",--%>
                  editable: true,
                  height:400,
                  navigatable: true,
                  aggregate: [
                    {field: "amt", aggregate: "sum"}
                  ],
                  change: calTotalAmount,
                  dataSource: ${fns:toJson(sublist)}
                '
                    >
                        <div data-field="typeName"
                             uglcw-options="width: 120,editable:false, footerTemplate: '合计:'">费用科目
                        </div>
                        <div data-field="itemName" uglcw-options="width: 120">费用明细科目
                        </div>
                        <div data-field="amt"
                             uglcw-options="width: 100,
                                footerTemplate: '#= (sum||0) #',
                                  format: '{0:n2}',
                                  schema:{
                                    type: 'number',
                                    validation:{min:0}}">
                            核销金额
                        </div>
                        <div data-field="remarks" uglcw-options="width: 120,editable: true">备注</div>
                        <div data-field="options" uglcw-options="width: 100, command:'destroy'">操作</div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<tag:compositive-selector-template index="1"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            //debugger;
            var action = e.action;
            if (action == 'itemchange' && (e.field == 'amt')) {
                var item = e.items[0];
                var amt = item.amt;
                var id = item.id;
                //判断值是否在范围内
                for(var i = 0;i<datas.length;i++){
                    var data = datas[i];
                    if(data.id==id){
                        if(amt>=0||amt<data.amt){
                            uglcw.ui.error('核销金额有误，请重新输入');
                            item.set('amt',data.amt);
                            return ;
                        }
                    }
                }
                calTotalAmount();
                uglcw.ui.get('#grid').commit();
            }

        })
        uglcw.ui.get('.form-horizontal').on('change', function (e) {
            $('.form-horizontal').data('_change', true);
        });
        if(${billId}==0&&${costBillId}!=''){
            loadDetail();
        }
        setTimeout(uglcw.ui.loaded, 210);
    })
    var datas ;
    function loadDetail() {//查看显示的绑定值
        $.ajax({
            url: '${base}manager/queryFinCostSubToPay',
            type: "POST",
            data: {billId: '${costBillId}'},
            dataType: 'json',
            success: function (json) {
                if(json.state){
                    //手动处理金额
                    for(var i = 0;i<json.rows.length;i++){
                        var data = json.rows[i];
                        data.amt = (data.amt * -1);
                    }
                    uglcw.ui.get('#grid').bind(json.rows || []);
                    datas = json.rows;
                    calTotalAmount();
                }
            }
        });

    }

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 45;
            var height = $(window).height() - padding - $('.master').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
    })
    }


    function add() {
        uglcw.ui.openTab('报销单-核销单开单', '${base}manager/toFinHxEdit?costBillId=0&billType=1&r='+ new Date().getTime());
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
        uglcw.ui.get('#payAmt').value(total);
        $('.form-horizontal').data('_change', true);
    }

    function addRow() {
        uglcw.ui.get('#grid').addRow({
            id: kendo.guid(),
            inTypeCode: 10001,
            qty: 1,
            amt: 0,
        });
    }


    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }

    function selectFinCost() {//原单号
        uglcw.ui.Modal.showGridSelector({
            closable: true,
            title: '选择原单号',
            url: '${base}/manager/queryFinCostList',
            query: function (params) {
                params.billStatus = '未付'
            },
            checkbox: false,
            width: 650,
            height: 400,
            criteria: '<input uglcw-role="datepicker" uglcw-model="sdate">' +
                '<input uglcw-role="datepicker" uglcw-model="edate">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
                '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="proName">',
            columns: [
                {field: 'billNo', title: '单号'},
                {field: 'proName', title: '名称'},
                {field: 'totalAmt', title: '金额'}
            ],
            yes: function (data) {//点击回调值
                if (data && data.length > 0) {
                    uglcw.ui.bind('form', {costNo: data[0].billNo, costBillId: data[0].id});
                }
            }
        })
    }


    function draftSave() {//暂存
        calTotalAmount();
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
            uglcw.ui.error('请选择费用');
            return;
        }
        var valid = true;
        $(items).each(function (index, item) {
            if (!item.amt) {
                valid = false;
                uglcw.ui.warning('第[' + (index + 1) + ')]行,请选择付款金额');
                return false;
            }
            $.map(item, function (v, k) {
                form['list[' + index + '].' + k] = v;
            })
        })
        if (!valid) {
            return;
        }
        data.id = data.billId;
        data.payTimeStr = data.inDate;
        data.status = 0;
        data.empId = data.proId;
        data.wareStr = JSON.stringify(items);
        uglcw.ui.confirm('是否确定保存', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/addFinPay',
                type: 'post',
                data: data,
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        $('#billStatus').text('暂存成功');
                        uglcw.ui.get("#status").value(0);
                        uglcw.ui.get("#billId").value(response.id);
                        $("#btnaudit").show();
                        $("#btnsave").hide();
                        uglcw.ui.success('暂存成功');
                        $('.form-horizontal').data('_change', false);
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function saveAudit() {//保存并审批
        calTotalAmount();
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
        form.payTimeStr = form.inDate;
        form.empId = form.proId;
        form.wareStr = JSON.stringify(uglcw.ui.get('#grid').bind());

        var items = uglcw.ui.get('#grid').bind();//
        if (items.length < 1) {
            uglcw.ui.error('请选择费用');
            return;
        }
        var valid = true;
        $(items).each(function (index, item) {
            if (!item.amt) {
                valid = false;
                uglcw.ui.warning('第[' + (index + 1) + ')]行,请选择付款金额');
                return false;
            }
            $.map(item, function (v, k) {
                form['list[' + index + '].' + k] = v;
            })
        })
        if (!valid) {
            return;
        }
        uglcw.ui.confirm('是否确定保存并审批', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/addFinPay',
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
                        response.billId = response.id
                        $('#billStatus').text('提交成功');
                        uglcw.ui.bind('form', response);
                        setTimeout(function () {
                            uglcw.ui.replaceCurrentTab('报销单-核销单' + response.id, '${base}/manager/showFinHxEdit?billId=' + response.id);
                        }, 1000);
                    } else {
                        uglcw.ui.error('提交失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded()
                }
            })
        })
    }

    function audit() {
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            uglcw.ui.error('该单据已审批');
            return;
        }
        if (status == 2) {
            uglcw.ui.error('该单据已作废，不能审批！');
            return;
        }
        //需要增加判断，如果有修改则必须先保存
        if ($('.form-horizontal').data('_change')) {
            return uglcw.ui.warning('单据已修改，请先暂存');
        }
        uglcw.ui.confirm('是否确定审核？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/updatePayAudit',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value(), costTerm: 1},
                dataType: 'json',
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.success('审批成功');
                        uglcw.ui.get("#status").value(1);
                        $("#btnaudit").hide();
                        $("#btnsave").hide();
                        $("#btndraft").hide();
                        $('#billStatus').text('审批成功');
                    } else {
                        uglcw.ui.error('操作失败' + json.msg);
                    }
                }
            })

        })
    }

</script>
</body>
</html>
