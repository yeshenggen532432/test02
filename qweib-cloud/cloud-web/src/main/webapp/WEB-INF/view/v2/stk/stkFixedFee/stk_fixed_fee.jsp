<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>固定费用单</title>
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
                    <ul uglcw-role="buttongroup">·
                        ·
                        <li onclick="add()" data-icon="add" class="k-info">新建</li>
                        <c:if test="${status eq -2}">
                            <li onclick="draftSave()" class="k-info" id="btndraft" data-icon="save">暂存</li>
                            <li onclick="audit()" class="k-info" style="display: ${billId eq 0?'none':''}" id="btnaudit"
                                data-icon="track-changes-accept">审批
                            </li>
                        </c:if>
                        <li onclick="saveAudit()" class="k-info" id="btnsave"
                            style="display: ${(status eq 0 and billId eq 0)?'':'none'}" data-icon="save">保存并审批
                        </li>
                    </ul>
                    <div class="bill-info">
                        <span class="no" style="color: green;">固定费用单据 ${billNo}</span>
                        <span id="billStatus" class="status" style="color:red;">${billStatus}</span>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
                        <input uglcw-role="textbox" type="hidden" id="proId" uglcw-model="proId" value="${proId}"/>
                        <input uglcw-role="textbox" type="hidden" id="proType" uglcw-model="proType" value="${proType}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">收款单位</label>
                            <div class="col-xs-4">
                                <input uglcw-role="gridselector" uglcw-validate="required" uglcw-options="click: function(){
                                    selectConsignee();
                                }" uglcw-model="proName,proId" value="${proName}"/>
                            </div>
                            <label class="control-label col-xs-3">费用归属日期</label>
                            <div class="col-xs-4">
                                <input id="billDateStr" uglcw-role="datetimepicker"
                                       uglcw-options="format:'yyyy-MM-dd HH:mm'"
                                       uglcw-model="billDateStr" value="${billDateStr}">
                            </div>
                            <label class="control-label col-xs-3">费用金额</label>
                            <div class="col-xs-4">
                                <input uglcw-role="numeric" id="totalAmt" readonly uglcw-model="totalAmt"
                                       uglcw-options="format: 'n2',spinners: false"
                                       value="${totalAmt}"/>
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom: 0px;">
                            <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-18">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${remarks}</textarea>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="layui-row layui-col-space15">
                <div class="layui-col-md10">
                    <div class="layui-card">
                        <div class="layui-card-body full">
                            <div id="grid" uglcw-role="grid"
                                 uglcw-options='
                                  responsive:[".master",40],
                                  id: "id",
                                  editable: true,
                                  height:400,
                                  navigatable: true,
                                  aggregate: [
                                    {field: "amt", aggregate: "sum"}
                                  ],
                                  dataSource:${fns:toJson(sublist)}
                                '
                            >
                                <div data-field="fixedName" uglcw-options="width: 150,
									 editor: function(container, options){
										var input = $('<input>');
										input.appendTo(container);
										console.log(options);
										var model = options.model;
										var selector = new uglcw.ui.ComboBox(input);
										selector.init({
											value: model.id,
											dataSource:itemsJson,
											dataTextField: 'name',
											dataValueField: 'id',
											select: function(e){
												var item = e.dataItem;
												model.fixedId = item.id,
												model.fixedName = item.name;

												loadCusotmerFixedFeePrice(model);
											}
										})
									}">固定费用类型
                                </div>

                                <div data-field="amt"
                                     uglcw-options="width: 120,editable: false, footerTemplate: '#= uglcw.util.toString(sum,\'n2\')#', format: '{0:n2}', schema:{type: 'number', validation:{min:0}}">
                                    费用金额
                                </div>
                                <div data-field="remarks" uglcw-options="width: 120,editable: true">备注</div>
                                <div data-field="options" uglcw-options="width: 100, command:'destroy'">操作</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md2">
                        <div class="layui-card">
                            <div class="layui-card-header">
                                <span>固定费用类型</span>
                            </div>
                            <div class="layui-card-body full">
                                <div id="tree" uglcw-role="tree" uglcw-options="
                                responsive:['.master',40],
                                url:'${base}manager/fixedField/fixedFieldList?status=1',
                                dataTextField:'name',
                                dataValueField: 'id',
                                loadFilter:function(response){
                                    itemsJson=response.datas;
                                    return response.datas;
                                }
                            "></div>
                            </div>
                        </div>
                </div>
            </div>
        </div>
    </div>
</div>
<tag:compositive-selector-template index="2"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var itemsJson;
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange' && (e.field == 'amt')) {
                calTotalAmount();
                uglcw.ui.get('#grid').commit();
            }
        })

        $('#tree').on('dblclick', '.k-in', function(e){
            var customerId = uglcw.ui.get('#proId').value();
            if(customerId==""||customerId==null){
                return uglcw.ui.info("请选择收款单位");
            }
            var row = $(e.target).closest('.k-item');
            var rowData = uglcw.ui.get('#tree').k().dataItem(row);
            var newRow = {
                fixedId: rowData.id,
                fixedName: rowData.name
            };
            loadCusotmerFixedFeePrice(newRow);
            uglcw.ui.get('#grid').addRow(newRow)
        })
        setTimeout(uglcw.ui.loaded, 210);
    })


    function selectConsignee() {
        <tag:compositive-selector-script callback="onItemChoose" />
    }

    function onItemChoose(id, name, type) {
        uglcw.ui.bind('.master', {proName: name, proId: id, proType: type});
    }

    function add() {
        uglcw.ui.openTab('固定费用开单', '${base}manager/stkFixedFee/add');
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
        uglcw.ui.get('#totalAmt').value(total);
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
            uglcw.ui.error('请选择费用');
            return;
        }
        var valid = true;
        $(items).each(function (index, item) {
            if (!item.amt) {
                valid = false;
                uglcw.ui.warning('第[' + (index + 1) + ')]行,请选择收款金额');
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
        data.status = -2;
        data.itemsStr = JSON.stringify(items);
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/stkFixedFee/save',
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
        var valid = true;
        $(items).each(function (index, item) {
            if (!item.amt) {
                valid = false;
                uglcw.ui.warning('第[' + (index + 1) + ')]行,请选择收款金额');
                return false;
            }
            $.map(item, function (v, k) {
                form['list[' + index + '].' + k] = v;
            })
        })
        if (!valid) {
            return;
        }
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/stkFixedFee/save',
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
            uglcw.ui.error('发票已作废，不能审批！');
            return;
        }
        uglcw.ui.confirm('是否确定审核？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkFixedFee/audit',
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


    function loadCusotmerFixedFeePrice(row) {
        var action = "stkCustomerFixedCalculate/loadCusotmerFixedFee";
        var customerId = uglcw.ui.get('#proId').value();
        var proType = uglcw.ui.get('#proType').value();
        var date = uglcw.ui.get("#billDateStr").value();
        if(customerId==""){
            return;
        }
        if(date==""){
            return uglcw.ui.info("费用归属日期不能为空!");
        }
        if (proType != 2) {
            return;
        }
        $.ajax({
            url: CTX + 'manager/' + action,
            type: 'post',
            async: false,
            data: {
                customerId: customerId,
                fixedId:row.fixedId,
                date:date
            },
            success: function (response) {
                if (response.state) {
                    row.amt = response.fee;
                    calTotalAmount();
                    uglcw.ui.get('#grid').commit();
                }
            }
        })
    }

</script>
</body>
</html>
