<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>杂费单列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid page-list">
    <div class="layui-card header">
        <div class="lyaui-card-header actionbar btn-group">
            <a role="button" href="javascript:newBill();" class="primary k-button k-button-icontext">
                <span class="k-icon k-i-plus-outline"></span>杂费开单
            </a>
            <a role="button" href="javascript:addItem();" class="k-button k-button-icontext">
                <span class="k-icon k-i-gear"></span>杂费明细设置
            </a>
        </div>
        <div class="layui-card-body full" style="padding-left: 5px;">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="杂费单号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="收款对象">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="itemName" placeholder="费用科目明细">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="单据状态" uglcw-options="value:''">
                        <option value="1">已审核</option>
                        <option value="-2">暂存</option>
                        <option value="2">作废</option>
                        <%--<option value="3">已支付</option>--%>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                    responsive:['.header',20],
                    id:'id',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.form-horizontal',
                    dblclick: function(row){
                        uglcw.ui.openTab('杂费单'+row.id,'${base}manager/stkExtrasFee/show?billId='+row.id);
                    },
                    url: '${base}manager/stkExtrasFee/pages',
                    criteria: '.form-horizontal',
                    }">
                <div data-field="billNo" uglcw-options="width:160,tooltip: true">单号</div>
                <div data-field="proName" uglcw-options="width:120,tooltip: true">收款对象</div>
                <div data-field="billDateStr" uglcw-options="width:160">收款日期</div>
                <div data-field="createName" uglcw-options="width:100">创建人</div>
                <div data-field="totalAmt" uglcw-options="width:100">付款金额</div>
                <div data-field="payAmt" uglcw-options="width:100">已付金额</div>
                <div data-field="freeAmt" uglcw-options="width:100">核销金额</div>
                <div data-field="billStatus"
                     uglcw-options="width:80">状态
                </div>

                <div data-field="_operator"
                     uglcw-options="width:200, template: uglcw.util.template($('#formatterOper').html())">操作
                </div>
                <div data-field="remarks" uglcw-options="width:130,tooltip: true">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="pc_pay1">
    <div class="layui-card">
        <div class="layui-card-body" id="payDiv">
            <div class="form-horizontal" uglcw-role="validator">
                <input type="hidden" uglcw-model="billId" uglcw-role="textbox"/>
                <div class="form-group">
                    <label class="control-label col-xs-6">付款对象</label>
                    <div class="col-xs-18">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="proId">
                        <input disabled uglcw-role="textbox" uglcw-model="proName">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">已付款</label>
                    <div class="col-xs-18">
                        <input disabled uglcw-role="textbox" uglcw-model="payAmt">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">还应支付</label>
                    <div class="col-xs-18">
                        <input disabled uglcw-role="textbox" uglcw-model="needPay">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">付款时间</label>
                    <div class="col-xs-18">
                        <input uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-role="datetimepicker" uglcw-model="payTimeStr">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">本次付款</label>
                    <div class="col-xs-18">
                        <input uglcw-validate="required" id="cash" uglcw-role="numeric" uglcw-model="cash">
                    </div>
                </div>
                <div class="form-group" style="display: none;">
                    <label class="control-label col-xs-6" for="link-checkbox">关联预付款单</label>
                    <div class="col-xs-18">
                        <input id="link-checkbox" type="checkbox" uglcw-role="checkbox" uglcw-model="preAmtChk">
                        <label style="margin-top: 10px;" for="link-checkbox" class="k-checkbox-label"></label>
                    </div>
                </div>
                <div id="pre-group" style="display: none;">
                    <div class="form-group">
                        <label class="control-label col-xs-6">预付款单</label>
                        <div class="col-xs-12">
                            <input  uglcw-role="gridselector" uglcw-model="preNo,preId" uglcw-options="click: function(){
                            selectPreOrders(this);
                        } ">
                        </div>
                        <div class="col-xs-6" style="padding-left: 0px;">
                            <input id="oldPreAmt" uglcw-role="textbox" type="hidden" uglcw-model="oldPreAmt"/>
                            <input id="preAmt" uglcw-role="numeric" uglcw-model="preAmt"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-6">实际付款金额</label>
                        <div class="col-xs-12">
                            <input id="retAmt" readonly uglcw-role="numeric" uglcw-model="retAmt"/>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">付款账户</label>
                    <div class="col-xs-18">
                        <input uglcw-validate="required" uglcw-role="combobox" uglcw-model="accId" uglcw-options="
                            url: '${base}manager/queryAccountList',
                            loadFilter: {
                                data: function(response){
                                    return response.rows || []
                                }
                            },
                            dataTextField: 'accName',
                            dataValueField: 'id'
                        "></input>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-18">
                        <textarea uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status==-2){#
    暂存
    #}else if(data.status==1){#
    已审批
    #}else if(data.status==2){#
    作废
    #}else if(data.status==3){#
    被冲红单
    #}else if(data.status==4){#
    冲红单
    #}#
</script>
<script type="text/x-kendo-template" id="formatterOper">
    # if(data.status != 2){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#)">作废</button>
    # } #

    # if(data.status ==0){ #
    <button class="k-button k-success" onclick="auditBill(#= data.id#)">审核</button>
    # } #

    # if(data.status ==1 &&(data.totalAmt-data.payAmt-data.freeAmt)>0){ #
    <button class="k-button k-info" onclick="toPay(this)">付款</button>
    # } #

</script>
<script id="formatterSt" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">明细科目名称</td>
            <td style="width: 5px;">付款金额</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].itemName #</td>
            <td>#= data[i].amt #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })

        uglcw.ui.loaded()
    })


    function cancelBill(id) {
        uglcw.ui.confirm('您确认要作废吗？', function () {
            $.ajax({
                url: "manager/stkExtrasFee/cancel",
                type: "post",
                data: "billId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败' + json.msg);
                        return;
                    }
                }
            });
        });
    }

    function auditBill(id) {
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#t').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {

                    uglcw.ui.confirm('您确认要审核吗？', function () {
                        $.ajax({
                            url: "manager/stkExtrasFee/audit",
                            type: "post",
                            data: {
                                billId: id

                            },
                            success: function (json) {
                                if (json.state) {
                                    uglcw.ui.success('操作成功');
                                    uglcw.ui.get('#grid').reload();
                                } else {
                                    uglcw.ui.error('操作失败' + json.msg);
                                    return;
                                }
                            }
                        });
                    });
                } else {
                    uglcw.ui.error('校验失败');
                    return false;
                }

            }
        });

    }

    function toPay(btn) {
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr'));
        row.payTimeStr = uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm');

        var needPay = row.totalAmt-row.payAmt-row.freeAmt;
        row.cash = needPay;
        row.needPay = needPay;
        row.billId = row.id;

        var rtn = uglcw.ui.Modal.open({
            title: '付款',
            content: $('#pc_pay1').html(),
            success: function (container) {
                uglcw.ui.init(container);
                uglcw.ui.get('#link-checkbox').on('change', function () {
                    $('#pre-group').toggle();
                });
                var cal = function () {
                    uglcw.ui.get('#retAmt').value(
                        Number(uglcw.ui.get('#cash').value() - uglcw.ui.get('#preAmt').value()).toFixed(2)
                    )
                }
                uglcw.ui.get('#cash').on('change', cal);
                uglcw.ui.get('#preAmt').on('change', cal);
                uglcw.ui.bind(container, row);
            },
            yes: function (container) {
                var validator = uglcw.ui.get($(container).find('.form-horizontal'));
                if (validator.validate()) {
                    var data = uglcw.ui.bind(container);
                    if (Math.abs(data.cash) < Math.abs(data.preAmt)) {
                        uglcw.ui.warning('抵扣金额不能大于本次收款金额');
                        return false;
                    }
                    if (Math.abs(data.needPay) < Math.abs(data.cash)) {
                        uglcw.ui.warning('付款金额不能大于应付金额');
                        return false;
                    }
                    url = '${base}manager/stkExtrasFee/payFee';
                    uglcw.ui.confirm('是否确定保存', function () {
                        uglcw.ui.loading();
                        $.ajax({
                            url: url,
                            type: 'post',
                            data: data,
                            success: function (response) {
                                uglcw.ui.loaded();
                                if (response.state) {
                                    uglcw.ui.success('保存成功');
                                    uglcw.ui.Modal.close(rtn);
                                    uglcw.ui.get('#grid').k().dataSource.read();
                                } else {
                                    uglcw.ui.error('保存失败');
                                }
                            },
                            error: function () {
                                uglcw.ui.error('保存失败');
                                uglcw.ui.loaded();
                            }
                        })
                    })

                }
                return false;
            }
        })
    }

    function newBill() {
        uglcw.ui.openTab('杂费单', '${base}manager/stkExtrasFee/add');

    }

    function addItem() {
        uglcw.ui.openTab('杂费明细设置', '${base}manager/toFinInCostItem');

    }
</script>
</body>
</html>
