<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
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
                        <li onclick="submitStk()" data-icon="save" class="k-info">保存</li>
                    </ul>
                    <div class="bill-info">
                        <c:if test="${model.status eq 0 }">
                            <span class="no" type="text" id="billstatus" style="color:red;width:80px">未审批</span>
                        </c:if>
                        <c:if test="${model.status eq 1 }">
                            <span class="status" type="text" id="billstatus" style="color:red;width:80px">已审批</span>
                        </c:if>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${model.id}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="operator" value="${model.operator}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="ioMark" value="${model.ioMark}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${model.status}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">单&nbsp;&nbsp;据&nbsp;&nbsp;号</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" readonly uglcw-model="billNo" id="billNo" value="${model.billNo}"/>
                            </div>
                            <label class="control-label col-xs-3">初始化日期</label>
                            <div class="col-xs-4">
                                <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                                       uglcw-model="billDate" value="${model.billDate}">
                            </div>
                            <label class="control-label col-xs-3">合计金额</label>
                            <div class="col-xs-4">
                                <input uglcw-role="numeric" id="totalAmt" disabled  uglcw-model="amt"  uglcw-options="format: 'n2',spinners: false"
                                       value="${model.amt}"/>
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom: 0px;">
                            <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-18">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${model.remarks}</textarea>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="layui-row layui-col-space15">
                <div class="layui-col-md12">
                    <div class="layui-card">
                        <div class="layui-card-body full">
                            <div id="grid" uglcw-role="grid"
                                 uglcw-options='
                          id: "id",
                          toolbar: uglcw.util.template($("#toolbar").html()),
                          editable: true,
                          height:400,
                          add: function(row){
                            row = row || {};
                            row.id = row.id || uglcw.util.uuid();
                            return row;
                          },
                          navigatable: true,
                          dataSource:${fns:toJson(model.list)}
                        '
                            >
                                <div data-field="itemName" uglcw-options="width: 150,
                                template:function(row){
                                    var account = {}
                                    $.map(accounts, function(a){
                                        if(a.id == row.accId){
                                            account = a;
                                            return false;
                                        }
                                    })
                                    return '<span>'+(account.acc_name || '')+'</span>'
                                },
                                 editor: function(container, options){
                                    var input = $('<input>');
                                    input.appendTo(container);
                                    var model = options.model;
                                    var selector = new uglcw.ui.ComboBox(input);
                                    selector.init({
                                        value: model.accId,
                                        dataSource: accounts,
                                        dataTextField: 'acc_name',
                                        dataValueField: 'id',
                                        select: function(e){
                                            var item = e.dataItem;
                                            model.accId = item.id,
                                            model.itemName = item.acc_name;
                                        }
                                    })
                                }">账号
                                </div>
                                <div data-field="amt"
                                     uglcw-options="width: 150, format: '{0:n2}', schema:{type: 'number', validation:{min:0}}">
                                    金额
                                </div>
                                <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<tag:compositive-selector-template/>
<tag:costitem-selector-template/>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:addRow();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var accounts = ${fns:toJson(fns:loadListByParam('fin_account','',''))};
    $(function () {

        uglcw.ui.init();
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange' && (e.field == 'amt')) {
                calTotalAmount();
            }

        })

        setTimeout(uglcw.ui.loaded, 210);
    })


    function addRow() {//添加
        uglcw.ui.get('#grid').addRow({
            amt: 0
        });
    }


    function add() {//新建
        uglcw.ui.openTab('货币资金初始化', '${base}manager/finInitMoney/add?r=' + new Date().getTime());
    }

    function calTotalAmount() {//合计金额
        var ds = uglcw.ui.get('#grid').k().dataSource;
        var data = ds.data().toJSON();
        var total = 0;
        $(data).each(function (idx, item) {
            total += (Number(item.amt));
        })
        uglcw.ui.get('#totalAmt').value(total);
    }

    function submitStk() {//保存
        var data = uglcw.ui.bind('.form-horizontal');
        if(data.status==1){
            return uglcw.ui.warning("该单据已审批，不能保存!");

        }
        if(data.status==2){
            return uglcw.ui.warning("该单据已作废，不能保存!");
        }
        var row=uglcw.ui.get('#grid').bind();//绑定表单数据
        if(row.length ==0){
            uglcw.ui.warning("请添加明细！")
            return false;
        }

        var valid = true;
        $(row).each(function (index, item) {
            if(!item.accId){
                valid = false;
                uglcw.ui.warning('第['+(index+1)+']行，请输入账号');
                return false;
            }
            if(!item.amt){
                valid = false;
                uglcw.ui.warning('第['+(index+1)+')]行,请输入金额');
                return false;
            }
            delete item['billTime'];
            delete item['newTime'];
            $.map(item, function(v, k){
                if(k != 'id'){
                    data['list['+index+'].'+k] = v;
                }
            })
        })

        if(!valid){
            return ;
        }
        uglcw.ui.confirm('保存后将不能修改,是否确定保存？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/finInitMoney/update',
                type: 'post',
                data: data,
                dataType: 'json',
                success: function (json) {
                    uglcw.ui.loaded()
                    if (json.state) {
                        uglcw.ui.success('暂存成功');
                        uglcw.ui.get("#billNo").value(json.billNo);
                        uglcw.ui.get("#billId").value(json.billId);
                        $('#billstatus').text('暂存成功');
                        <%--uglcw.ui.get('#grid').reload();//刷新页面数据--%>
                        <%--setTimeout(function(){--%>
                            <%--uglcw.ui.replaceCurrentTab('货币资金初始化'+json.id, '${base}/manager/finInitMoney/edit?id='+json.id);--%>
                        <%--}, 1000);--%>
                    } else {
                        uglcw.ui.warning(json.msg||'操作失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded()
                }
            })
        })
    }


</script>
</body>
</html>
