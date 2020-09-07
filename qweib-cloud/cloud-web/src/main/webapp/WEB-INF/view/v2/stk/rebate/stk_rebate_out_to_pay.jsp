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
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单号">
                </li>
                <li>

                    <select uglcw-role="combobox" uglcw-model="customerType"
                            placeholder="客户类型"
                            uglcw-options="
										url: '${base}manager/queryarealist1',
										index: -1,
										loadFilter:{
											data: function(response){
												return response.list1 || []
											}
										},
										dataTextField: 'qdtpNm',
										dataValueField: 'qdtpNm'
									"></select>
                </li>
                <%--                <li>--%>
                <%--                        <select id="saleType" uglcw-model="saleType" uglcw-role="combobox" placeholder="业务类型">--%>
                <%--                            <option value="">全部</option>--%>
                <%--                            <option value="001">传统业务类</option>--%>
                <%--                            <option value="003">线上商城</option>--%>
                <%--                        </select>--%>
                <%--                </li>--%>
                <li>
                    <input uglcw-model="khNm" value="${khNm}" uglcw-role="textbox" placeholder="往来单位"/>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>


                <li>
                    <select placeholder="单据状态" uglcw-model="status" uglcw-role="combobox" id="status"
                            uglcw-options="value: '${status}'">
                        <option value="">全部</option>
                        <option value="-2">暂存</option>
                        <option value="1">已审批</option>
                        <option value="2">作废</option>
                    </select>
                </li>

                <li>
                    <select uglcw-role="combobox" uglcw-model="autoId"
                            placeholder="变动费用类型"
                            uglcw-options="
										url: '${base}manager/autoFieldList?status=1',
										index: -1,
										loadFilter:{
											data: function(response){
												return response.datas || []
											}
										},
										dataTextField: 'name',
										dataValueField: 'id'
									"></select>
                </li>
                <li>
                    <select uglcw-model="isPay" uglcw-role="combobox" placeholder="付款状况" id="payStatus"
                            uglcw-options="value: '${payStatus}'">
                        <option value="0">未付款</option>
                        <option value="-1">全部</option>
                        <option value="1">已付款</option>
                    </select>
                </li>


                <li>
                    <input uglcw-model="epCustomerName" uglcw-role="textbox" placeholder="所属二批"/>
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
                    checkbox: true,
                    query: function(param){
                      param.recStatus = -2; //排除暂存的单据
                      return param;
                    },
                    url: '${base}manager/stkRebateOut/stkRebateOutForPayPage',
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
                        	disAmt1: 0,
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
                <div data-field="billNo"
                     uglcw-options="width:180,template: uglcw.util.template($('#bill-no').html()), footerTemplate: '合计'">
                    费用单号
                </div>
                <div data-field="outDate" uglcw-options="width:160">单据日期</div>
                <div data-field="khNm" uglcw-options="width:120, tooltip: true">往来单位</div>
                <div data-field="autoName" uglcw-options="width:120, tooltip: true">变动费用类型</div>
                <div data-field="disAmt1"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.disAmt1 || 0, \'n2\')#'">
                    费用金额
                </div>
                <div data-field="recAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.recAmt || 0, \'n2\')#'">
                    已付款
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.freeAmt||0, \'n2\')#'">
                    核销金额
                </div>
                <div data-field="needRec"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.needRec||0, \'n2\')#'">
                    未付金额
                </div>
                <div data-field="status" uglcw-options="width:120, template: uglcw.util.template($('#status-tpl').html())">
                    单据状态
                </div>
                <div data-field="recStatus" uglcw-options="width:120">付款状态</div>
                <div data-field="remarks" uglcw-options="width:160">备注</div>
                <div data-field="epCustomerName" uglcw-options="width:120">所属二批</div>
                <div data-field="options" uglcw-options="width:220, template: uglcw.util.template($('#op-tpl').html())">操作
                </div>
            </div>
        </div>
    </div>
</div>
<script id="op-tpl" type="text/x-uglcw-template">
    <div class="op-button">
        #if(data.id && data.status!=-2){#
        # if(data.status == -2){ #
        <button class="k-button k-success" onclick="copy(#= data.id#)"><i class="k-icon k-i-copy"></i>复制</button>
        # }else{ #
        <button class="k-button k-info" onclick="showPayList(#= data.id#)"><i class="k-icon k-i-info"></i>付款记录</button>
        # if(data.billStatus!='作废'){ #
        <button class="k-button k-info" onclick="toPay(this)"><i class="k-icon ion-md-card"></i>付款</button>
        #}#
        # } #
        #}#
    </div>
</script>
<script type="text/x-uglcw-template" id="toolbar">

    <a role="button" href="javascript:add();" class="primary k-button k-button-icontext" style="color: \\#FFF;background: \\#38F;">
        <span class="k-icon k-i-plus-outline"></span>费用开单
    </a>

    <c:if test="${tabType eq '0'}">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showPayHisList();">
        <span class="k-icon ion-md-time"></span>付款记录
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toBatchPay();">
        <span class="k-icon ion-md-card"></span>批量付款
    </a>
    </c:if>
    <c:if test="${tabType eq '1'}">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toBatchAudit();">
        <span class="k-icon ion-md-card"></span>批量审批
    </a>
    </c:if>

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
<script id="bill-no" type="text/x-uglcw-template">
    <a href="javascript:showDetail(#= data.id#);" style="color: \\#3343a4;font-size: 12px; font-weight: bold;">#=
        data.billNo#</a>
</script>
<script id="pay-tpl" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-8">付款对象</label>
                    <div class="col-xs-16">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="proId"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="billId"/>
                        <input uglcw-role="textbox" uglcw-model="proName" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">已付款</label>
                    <div class="col-xs-16">
                        <input uglcw-role="textbox" uglcw-model="payAmt" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">还应支付</label>
                    <div class="col-xs-16">
                        <input uglcw-role="textbox" uglcw-model="needPay" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">付款时间</label>
                    <div class="col-xs-16">
                        <input uglcw-role="datetimepicker" uglcw-options="format: 'yyyy-MM-dd HH:mm'"
                               uglcw-model="payTimeStr"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">本次付款</label>
                    <div class="col-xs-16">
                        <input uglcw-role="numeric" uglcw-validate="required" uglcw-options="spinners: false"
                               uglcw-model="cash"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">付款账户</label>
                    <div class="col-xs-16">
                        <input uglcw-role="combobox"
                               uglcw-validate="required"
                               uglcw-options="
                        url: '${base}manager/queryAccountList',
                        loadFilter:{
                          data:function(resp){
                            return resp.rows || [];
                          }
                        },
                        dataTextField: 'accName',
                        dataValueField: 'id'" uglcw-model="accId"/>
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

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        });
        uglcw.ui.loaded()
    });

    function add() {
        uglcw.ui.openTab('变动费用开单', '${base}manager/stkRebateOut/add?r=' + new Date().getTime());
    }

    function showDetail(id) {
        uglcw.ui.openTab('变动费用单据信息' + id, '${base}/manager/stkRebateOut/show?dataTp=1&billId=' + id);
    }

    function showPayList(id) {
        uglcw.ui.openTab('付款记录' + id, '${base}manager/queryPayPageByBillId?inType=2&dataTp=1&billId=' + id);
    }

    function toPay(btn) {
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr'));
        row.payAmt = row.recAmt;
        row.billId = row.id;
        row.needPay = row.disAmt - row.recAmt;
        row.cash = row.needPay;
        row.proId = row.cstId;
        row.proName = row.khNm;
        row.payTimeStr = uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm');
        var rtn = uglcw.ui.Modal.open({
            title: '付款',
            content: $('#pay-tpl').html(),
            success: function (c) {
                uglcw.ui.init(c);
                uglcw.ui.bind(c, row);
            },
            yes: function (c) {
                var validator = uglcw.ui.get($(c).find('.form-horizontal'));
                if (!validator.validate()) {
                    return false;
                }
                var data = uglcw.ui.bind(c);
                uglcw.ui.confirm('是否确定付款？', function () {
                    uglcw.ui.loading();
                    $.ajax({
                        url: '${base}manager/stkRebateOut/payRebetaOut',
                        type: 'post',
                        data: data,
                        success: function (resp) {
                            uglcw.ui.loaded();
                            if (resp.state) {
                                uglcw.ui.success('付款成功');
                                uglcw.ui.get('#grid').reload();
                                uglcw.ui.Modal.close(rtn);
                            }
                        },
                        error: function () {
                            uglcw.ui.loaded();
                        }
                    })
                });

                return false;
            }
        })
    }

    function copy(id) {
        uglcw.ui.confirm('是否确定复制？', function () {
            uglcw.ui.openTab('复制销售返利单', '${base}manager/stkRebateOut/copy?billId=' + id);
        })
    }

    function showPayHisList() {
        uglcw.ui.openTab('付款记录', '${base}manager/queryPayPageByBillId?inType=2&dataTp=1');
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
            title: '批量付款',
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
                uglcw.ui.confirm('确定批量付款吗', function () {
                    uglcw.ui.loading();
                    $.ajax({
                        url: '${base}manager/stkRebateOut/batchRebateOutPay',
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


    function toBatchAudit() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection || selection.length < 1) {
            return uglcw.ui.notice({
                type: 'error',
                title: '提示',
                desc: '请勾选要审批的单据'
            })
        }
       var  ids = $.map(selection, function (row) {
            return row.id;
        }).join(',');
        uglcw.ui.confirm('确定批量审批吗', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkRebateOut/batchRebateOutAudit?ids='+ids,
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
        });

    }

</script>
</body>
</html>
