<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>付货款管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="返利单号">
                </li>
                <li>
                    <input uglcw-model="proName" value="${proName}" uglcw-role="textbox" placeholder="往来单位"/>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select placeholder="单据状态" uglcw-model="status" uglcw-role="combobox"  id="status"  uglcw-options="value: '${status}'">
                        <option value="">全部</option>
                        <option value="-2">暂存</option>
                        <option value="1">已审批</option>
                        <option value="2">作废</option>
                    </select>
                </li>
                <li>
                    <select uglcw-model="isPay" uglcw-role="combobox" placeholder="收款状况" id="payStatus" uglcw-options="value: '${payStatus}'">
                        <option value="0">未收款</option>
                        <option value="-1">全部</option>
                        <option value="1">已收款</option>
                    </select>
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
                 uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    query: function(param){
                       if(param.isPay == '需退款'){
                          delete param['isPay'];
                          param.needRtn = 1;
                       }
                       return param;
                    },
                    checkbox: true,
                    url: '${base}manager/stkRebateIn/stkRebateInForRecPage',
                    aggregate:[
                     {field: 'totalAmt', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'disAmt1', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'},
                     {field: 'payAmt', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	disAmt: 0,
                        	payAmt: 0,
                        	freeAmt: 0,
                        	totalAmt: 0,
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     },
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="billNo" uglcw-options="width:180,tooltip: true,template: uglcw.util.template($('#formatterSt1').html()),
                 footerTemplate: '合计'">返利单号</div>
                <div data-field="inDate" uglcw-options="width:160">单据日期</div>
                <div data-field="proName" uglcw-options="width:120">往来单位</div>
                <div data-field="disAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.disAmt || 0, \'n2\')#'">
                    返利金额
                </div>
                <div data-field="payAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.payAmt || 0, \'n2\')#'">
                    已收金额
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.freeAmt||0, \'n2\')#'">
                    核销金额
                </div>
                <div data-field="needPay"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.needPay||0, \'n2\')#'">
                    未收金额
                </div>
                <div data-field="status" uglcw-options="width:120, template: uglcw.util.template($('#status-tpl').html())">
                    单据状态
                </div>
                <div data-field="payStatus" uglcw-options="width:120">收款状态</div>
                <div data-field="options" uglcw-options="width:220, template: uglcw.util.template($('#op-tpl').html())">操作
                </div>
            </div>
        </div>
    </div>
</div>
<script id="formatterSt1" type="text/x-kendo-template">
    <a href="javascript:showSourceBill('#= data.id#')" style="color: blue" ;>#=data.billNo#</a>
</script>
<script id="op-tpl" type="text/x-uglcw-template">
    <div class="op-button">
        #if(data.id && data.status!=-2){#
        # if(data.status == -2){ #
        <button class="k-button k-success" onclick="copy(#= data.id#)"><i class="k-icon k-i-copy"></i>复制</button>
        # }else{ #
        <button class="k-button k-info" onclick="showRecList(#= data.id#)"><i class="k-icon k-i-info"></i>收款记录</button>
        # if(data.billStatus!='作废'){ #
        <button class="k-button k-info" onclick="toRec(this)"><i class="k-icon ion-md-card"></i>收款</button>
        #}#
        # } #
        #}#
    </div>
</script>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showRecHisList();">
        <span class="k-icon ion-md-time"></span>收款记录
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toBatchPay();">
        <span class="k-icon ion-md-card"></span>批量收款
    </a>
</script>
<script type="text/x-uglcw-template" id="batch-rec-tpl">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-8">
                        收款账号
                    </label>
                    <div class="col-xs-16">
                        <tag:select2 validate="required" name="accId" id="accId" tableName="fin_account"
                                     whereBlock="status=0" headerKey="" headerValue="--请选择--" displayKey="id"
                                     displayValue="acc_name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-16">
                        <textarea uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="status-tpl">
    # if(data.status == -2){ #
    暂存
    # }else if(data.status == 1){ #
    已审批
    #} else if(data.status == 2){ #
    已作废
    #}#
</script>
<script type="text/x-uglcw-template" id="pc_pay1">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <input type="hidden" uglcw-model="billId" uglcw-role="textbox"/>
                <div class="form-group">
                    <label class="control-label col-xs-6">往来单位</label>
                    <div class="col-xs-18">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="cstId">
                        <input disabled id="proName" uglcw-role="textbox" uglcw-model="cstName">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">剩余单据金额</label>
                    <div class="col-xs-18">
                        <input disabled uglcw-role="textbox" uglcw-model="needRec1">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">已收款</label>
                    <div class="col-xs-18">
                        <input disabled uglcw-role="textbox" uglcw-model="recAmt">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">应收款</label>
                    <div class="col-xs-18">
                        <input disabled uglcw-role="textbox" uglcw-model="needRec">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">收款时间</label>
                    <div class="col-xs-18">
                        <input uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-role="datetimepicker" uglcw-model="recTimeStr">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">本次收款</label>
                    <div class="col-xs-18">
                        <input uglcw-validate="required" id="cash" uglcw-role="numeric" uglcw-model="cash">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6" for="link-checkbox">关联抵扣款单</label>
                    <div class="col-xs-18">
                        <input id="link-checkbox" type="checkbox" uglcw-role="checkbox" uglcw-model="preAmtChk">
                        <label style="margin-top: 10px;" for="link-checkbox" class="k-checkbox-label"></label>
                    </div>
                </div>
                <div id="pre-group" style="display: none;">
                    <div class="form-group">
                        <label class="control-label col-xs-6">抵扣款单</label>
                        <div class="col-xs-12">
                            <input id="pre-no" uglcw-role="gridselector" uglcw-model="preNo,preId" uglcw-options="click: function(){

                            selectPreOrders(this, uglcw.ui.get('#proName').value());
                        } ">
                        </div>
                        <div class="col-xs-6" style="padding-left: 0px;">
                            <input id="oldPreAmt" uglcw-role="textbox" type="hidden" uglcw-model="oldPreAmt"/>
                            <input id="preAmt" placeholder="本次抵扣金额" uglcw-role="numeric" uglcw-model="preAmt"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-6">实际收款金额</label>
                        <div class="col-xs-12">
                            <input id="retAmt" readonly uglcw-role="numeric" uglcw-model="retAmt"/>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">收款账户</label>
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

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })

    function showRecList(id) {
        uglcw.ui.openTab('收款记录' + id, '${base}manager/queryRecPageByBillId?outType=2&dataTp=1&billId=' + id);
    }
    function showSourceBill(sourceBillId) {
        uglcw.ui.openTab('采购返利信息' + sourceBillId, '${base}manager/stkRebateIn/show?dataTp=1&billId=' + sourceBillId);
    }

    function toRec(btn) {
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr'));
        row.recTimeStr = uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm');

        row.recAmt = row.payAmt;
        row.cash =  row.disAmt - row.payAmt - row.freeAmt;
        row.needRec = row.disAmt - row.payAmt - row.freeAmt;
        row.recAmt1 = parseFloat(row.recAmt) +  parseFloat(row.freeAmt);
        row.needRec1 =row.needRec;


       // row.cash = row.needRec;
        row.cstId = row.proId;
        row.cstName = row.proName;
        // row.recAmt = row.payAmt;
        // row.needRec = row.disAmt1 - row.payAmt - row.freeAmt;
        // row.needRec1 = row.disAmt - row.payAmt - row.freeAmt;
        // row.cash = row.needRec;
        row.billId = row.id;
        var rtn = uglcw.ui.Modal.open({
            title: '收款',
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
                    if (data.cash < data.preAmt) {
                        uglcw.ui.notice({
                            type: 'error',
                            title: '提示',
                            desc: '抵扣金额不能大于本次收款金额'
                        })
                        return false;
                    }
                    if (data.needRec < data.cash) {
                        uglcw.ui.notice({
                            type: 'error',
                            title: '提示',
                            desc: '收款金额不能大于单据金额' + data.needRec
                        });
                        return false;
                    }
                    uglcw.ui.confirm('是否确定保存', function () {
                        uglcw.ui.loading();
                        $.ajax({
                            url: '${base}manager/stkRebateIn/recRebetaIn',
                            type: 'post',
                            data: data,
                            success: function (response) {
                                uglcw.ui.loaded();
                                if (response.state) {
                                    uglcw.ui.success('保存成功');
                                    uglcw.ui.get('#grid').reload();
                                    uglcw.ui.Modal.close(rtn);
                                } else {
                                    uglcw.ui.error(response.msg);
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


    function selectPreOrders(sender, proName) {
        console.log(sender);
        uglcw.ui.Modal.showGridSelector({
            url: '${base}manager/selectFinPreInPage',
            type: 'get',
            query: function (params) {
                params.proName = proName;
                params.jz = 1;
                return params;
            },
            columns: [
                {title: '单号', field: 'billNo', width: 160},
                {title: '单据日期', field: 'billTime', width: 120},
                {title: '往来单位', field: 'proName', width: 120},
                {title: '账户名称', field: 'accName', width: 120},
                {title: '预付金额', field: 'totalAmt', width: 120},
                {title: '剩余抵扣金额', field: 'rectAmt', width: 120, template: '#= data.totalAmt - data.payAmt#'},
                {title: '备注', field: 'remarks', width: 120}
            ],
            btns: [],
            criteria: '<input placeholder="单号" uglcw-role="textbox" uglcw-model="billNo">' +
                '<input placeholder="开始日期" uglcw-role="datepicker" value="${sdate}" uglcw-model="sdate">' +
                '<input placeholder="结束日期" uglcw-role="datepicker" value="${edate}" uglcw-model="edate">',
            yes: function (data) {
                var row = data[0];
                sender.bind('preNo,preId', {
                    preNo: row.billNo,
                    preId: row.id
                });
                var preAmt = row.totalAmt - row.payAmt;
                uglcw.ui.get('#preAmt').value(preAmt);
                uglcw.ui.get('#oldPreAmt').value(preAmt);
                uglcw.ui.get('#retAmt').value(
                    Number(uglcw.ui.get('#cash').value() - uglcw.ui.get('#preAmt').value()).toFixed(2)
                )
            }
        })
    }

    function copy(id) {
        uglcw.ui.confirm('是否确定复制？', function () {
            uglcw.ui.openTab('复制采购返利单', '${base}manager/stkRebateIn/copy?billId=' + id);
        })
    }

    function showRecHisList() {
        uglcw.ui.openTab('收款记录', '${base}manager/queryRecPageByBillId?outType=2&dataTp=1');
    }

    function toBatchPay() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection || selection.length < 1) {
            return uglcw.ui.notice({
                type: 'error',
                title: '提示',
                desc: '请勾选要付款的单据'
            })
        }
        uglcw.ui.Modal.open({
            title: '批量收款',
            content: $('#batch-rec-tpl').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var validator = uglcw.ui.get($(c).find('.form-horizontal'));
                if (!validator.validate()) {
                    return false;
                }
                var data = uglcw.ui.bind(c);
                data.ids = $.map(selection, function (row) {
                    return row.id;
                }).join(',');
                uglcw.ui.confirm('确定批量收款吗', function () {
                    uglcw.ui.loading();
                    $.ajax({
                        url: '${base}manager/stkRebateIn/batchRebateInRec',
                        data: data,
                        type: 'post',
                        success: function (resp) {
                            uglcw.ui.loaded();
                            if (resp.state) {
                                uglcw.ui.notice({
                                    type: 'success',
                                    title: '提示',
                                    desc: resp.msg || '操作成功'
                                });
                                uglcw.ui.get('#grid').reload();
                            } else {
                                uglcw.ui.notice({
                                    type: 'error',
                                    title: '提示',
                                    desc: resp.msg || '操作失败'
                                });
                            }
                        },
                        error: function () {
                            uglcw.ui.loaded();
                        }
                    })
                })
            }
        })

    }

</script>
</body>
</html>
