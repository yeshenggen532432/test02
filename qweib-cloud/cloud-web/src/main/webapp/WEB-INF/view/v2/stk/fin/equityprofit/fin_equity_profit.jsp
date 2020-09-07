<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>股东利润分配开单</title>
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
                        <span class="no" style="color: green;">${billNo}</span>
                        <span id="billStatus" class="status" style="color:red;">${billStatus}</span>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">标&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;题</label>
                            <div class="col-xs-4">
                                <input uglcw-model="title" id="title"
                                       uglcw-role="textbox" uglcw-validate="required" maxlength="25"
                                       value="${title}">
                            </div>
                            <label class="control-label col-xs-3">付款时间</label>
                            <div class="col-xs-4">
                                <input id="inDate" uglcw-role="datetimepicker" uglcw-validate="required" uglcw-options="format:'yyyy-MM-dd HH:mm:ss'"
                                       uglcw-model="inDate" value="${billTimeStr}">
                            </div>
                            <label class="control-label col-xs-3">合计利润</label>
                            <div class="col-xs-4">
                                <input uglcw-role="numeric" id="totalAmt" disabled  uglcw-model="totalAmt"  uglcw-options="format: 'n2',spinners: false"
                                       value="${totalAmt}"/>
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom: 0px;">
                            <label class="control-label col-xs-3">付款账户</label>
                            <div class="col-xs-4">
                                <select uglcw-role="combobox" uglcw-model="accId" uglcw-validate="required"
                                        uglcw-options=" value: '${accId}',
                                  url: '${base}manager/queryAccountList',
                                  loadFilter:{
                                    data: function(response){return response.rows ||[];}
                                  },
                                  dataTextField: 'accName',
                                  dataValueField: 'id'
                                "
                                >
                                </select>
                            </div>
                            <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-11">
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
                          editable: true,
                            toolbar: uglcw.util.template($("#toolbar").html()),
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "amt", aggregate: "sum"}
                          ],
                          change: calTotalAmount,
                          dataSource:${fns:toJson(sublist)}
                        '
                            >
                                <%--<div data-field="shareHoldName"--%>
                                     <%--uglcw-options="width: 150, editable: true">股东名称--%>
                                <%--</div>--%>

                                <div data-field="shareHoldName" uglcw-options="width: 150,
									 editor: function(container, options){
										var input = $('<input>');
										input.appendTo(container);
										console.log(options);
										var model = options.model;
										var selector = new uglcw.ui.ComboBox(input);
										selector.init({
											value: model.id,
											dataSource:itemsJson,
											dataTextField: 'itemName',
											dataValueField: 'id',
											select: function(e){
												var item = e.dataItem;
												model.shareHoldId = item.id,
												model.shareHoldName = item.itemName;
											}
										})
									}">股东名称
                                </div>

                                <div data-field="amt"
                                     uglcw-options="width: 160, footerTemplate: '#= uglcw.util.toString(sum,\'n2\')#', format: '{0:n2}', schema:{type: 'number', validation:{min:0}}">
                                    金额
                                </div>
                                <div data-field="remarks" uglcw-options="width:200, editable: true">备注</div>
                                <div data-field="options" uglcw-options="width: 100, command:'destroy'">操作</div>
                                <div data-field="_" ></div>
                            </div>
                        </div>
                    </div>

        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:addRow();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-add"></span>增行
    </a>
</script>
<tag:compositive-selector-template index="2"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange' && (e.field == 'amt')) {
                calTotalAmount();
                uglcw.ui.get("#grid").commit();
            }
        });
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        loadData();
        setTimeout(uglcw.ui.loaded, 210);
    })


    var c, m, s;

    function chooseItem(container, model, selector) {
        c = container;//
        m = model;
        s = selector;
        <tag:costitem-selector-script callback="onCostItemChosen"/>
    }

    function onCostItemChosen(row) {//回调的值
        s.value(row.itemName);
        m.set('itemId', row.id);
        m.set('itemName', row.itemName);
        m.set('typeName', row.typeName);
        saveChanges();
    }

    function addRow() {
        uglcw.ui.get('#grid').addRow({
            amt: 0
        });
    }


    function selectConsignee() {
        <tag:compositive-selector-script callback="onItemChoose"/>
    }

    function onItemChoose(id, name, type) {
        uglcw.ui.bind('.master', {proName: name, proId: id, proType: type});
    }

    function add() {
        uglcw.ui.openTab('股东利润分配开单', '${base}manager/finEquityProfit/toAdd?r=' + new Date().getTime());
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
        if (data.accId == 0) {
           return uglcw.ui.warning('请选择付款账户！')
        }

        var items = uglcw.ui.get('#grid').bind();
        if (items.length < 1) {
            uglcw.ui.error('请输入明细');
            return;
        }
        var valid = true
        $(items).each(function(idx, item){
            if(!item.amt){
                uglcw.ui.warning('第['+(idx+1)+']请输入金额');
                valid =false;
                return false;
            }
        })
        if(!valid){
            return;
        }
        data.id = data.billId;
        data.billTimeStr = data.inDate;
        data.status = 0;
        data.wareStr = JSON.stringify(items);

        uglcw.ui.confirm('是否确定保存？', function () {

            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/finEquityProfit/save',
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
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
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
        form.billTimeStr = form.inDate;
        form.wareStr = JSON.stringify(uglcw.ui.get('#grid').bind());

        if (form.accId == 0) {
            return uglcw.ui.warning('请选择付款账户');

        }
        var items = uglcw.ui.get('#grid').bind();
        if (items.length < 1) {
            uglcw.ui.error('请选择明细');
            return;
        }
        var valid = true;
        $(items).each(function (index, item) {
            if (!item.amt) {
                valid = false;
                uglcw.ui.warning('第[' + (index + 1) + ')]行,请选择金额');
                return false;
            }
            $.map(item, function (v, k) {
                form['list[' + index + '].' + k] = v;
            })
        })
        if (!valid) {
            return;
        }

        uglcw.ui.confirm('是否确定保存并提交', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/finEquityProfit/save',
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
                url: '${base}manager/finEquityProfit/audit',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value(), costTerm: 1},
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

    function loadData()
    {
        var path = "${base}manager/queryUseEquityItemList";
        $.ajax({
            url: path,
            type: "POST",
            data : {"typeName":'实收资本'},
            dataType: 'json',
            async : false,
            success: function (json) {
                if(json.state){
                    var size = json.rows.length;
                    itemsJson = json.rows;
                }
            }
        });
    }

</script>
</body>
</html>
