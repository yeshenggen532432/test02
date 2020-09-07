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
        <li class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                        <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                        <input type="hidden" uglcw-model="proType" value="${proType}" uglcw-role="textbox">
                        <input uglcw-model="billNo" uglcw-role="textbox" placeholder="发票单号">
                </li>
                <li>
                        <input uglcw-model="proName" value="${proName}" uglcw-role="textbox" placeholder="供应商名称">
                </li>
                <li>
                        <input uglcw-model="sdate" id="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                        <input uglcw-model="edate" id="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                        <select uglcw-role="combobox" uglcw-model="inType" placeholder="入库类型">
                            <option value="">入库类型</option>
                            <option value="采购入库">采购入库</option>
                            <option value="其它入库">其它入库</option>
                            <option value="采购退货">采购退货</option>
                            <option value="销售退货">销售退货</option>
                            <option value="杂费单">杂费单</option>
                        </select>
                </li>

                <li>
                        <select uglcw-role="combobox" uglcw-model="isPay" placeholder="付款状况" uglcw-options="value:0" disabled>
                            <option value="0">未付款</option>
                            <option value="">全部</option>
                            <option value="1">已付款</option>
                            <option value="2">作废</option>
                        </select>
                </li>
                <li>
                        <input uglcw-role="numeric" style="width: 70px" data-min="0" uglcw-model="beginAmt" placeholder="发票金额">到<input uglcw-role="numeric"  style="width: 70px" uglcw-model="endAmt" placeholder="发票金额">
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
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    dblclick: function(row){
                         if(row.inType === '应付往来单位初始化'||row.inType === '杂费单'){
                            return;
                         }
                         uglcw.ui.openTab('待付款单据'+row.id, '${base}manager/showstkin?dataTp=1&billId='+row.id);
                    },
                    checkbox: true,
                    url: '${base}manager/stkInForPayPage',
                    aggregate:[
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'payAmt', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'},
                     {field: 'needPay', aggregate: 'SUM'}
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
                        	needPay:0
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
                <div data-field="billNo" uglcw-options="width:180,tooltip: true, footerTemplate: '合计'">单号</div>
                <div data-field="inDate" uglcw-options="width:150, format: '{0:n2}'">日期</div>

                <div data-field="proName" uglcw-options="width:120, format: '{0:n2}'">付款对象</div>
                <div data-field="options"
                     uglcw-options="width:300, template: uglcw.util.template($('#op-tpl').html()) ">操作
                </div>
                <div data-field="disAmt" uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#=uglcw.util.toString(data.disAmt,\'n2\') #'">
                    单据金额
                </div>
                <div data-field="payAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.payAmt,\'n2\')#'">已付款
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.freeAmt, \'n2\')#'">
                    核销金额
                </div>
                <div data-field="needPay"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#=uglcw.util.toString(data.needPay,\'n2\') #'">未付金额
                </div>
                <div data-field="inType" uglcw-options="width:120, format: '{0:n2}'">入库类型</div>
                <div data-field="billStatus" uglcw-options="width:120">收货状态</div>
                <div data-field="payStatus" uglcw-options="width:120">付款状态</div>

            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showInfo();">
        <span class="k-icon k-i-search"></span>查看发票
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showPayStat();">
        <span class="k-icon k-i-search"></span>付款统计
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showNeedPayStat();">
        <span class="k-icon k-i-search"></span>应付款统计
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showPayHisList();">
        <span class="k-icon k-i-search"></span>付款记录
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toBatchPay();">
        <span class="k-icon k-i-search"></span>批量付款
    </a>
</script>
<script type="text/x-uglcw-template" id="op-tpl">
    # if(data.id){ #
    <%--# if(data.inType === '应付往来单位初始化'){ #--%>
    <%--<button class="k-button k-info" onclick="showPayList(#= data.id#, '#= data.inType#', '#= data.billNo#')">付款记录--%>
    <%--</button>--%>
    <%--<button class="k-button k-info" onclick="toPay(this)">付款</button>--%>
    <%--<button class="k-button k-info" onclick="toFreePay(this)">核销</button>--%>
    <%--# }else{ #--%>
    <%--<button class="k-button k-info" onclick="showPayList(#= data.id#, '#= data.inType#', '#= data.billNo#')">付款记录--%>
    <%--</button>--%>
    <%--<button class="k-button k-info" onclick="toPay(this)">付款</button>--%>
    <%--<button class="k-button k-info" onclick="toFreePay(this)">核销</button>--%>
    <%--# } #--%>
    <button class="k-button k-info" onclick="showPayList(#= data.id#, '#= data.inType#', '#= data.billNo#')">付款记录</button>
    <button class="k-button k-info" onclick="toPay(this)">付款</button>
    <button class="k-button k-info" onclick="toFreePay(this)">核销</button>
    #}#
</script>
<script type="text/x-uglcw-template" id="batch-pay-dialog">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6">付款账号</label>
                    <div class="col-xs-18">
                        <%--<tag:select2 name="accId" id="accId" tableName="fin_account" headerKey="" whereBlock="status=0"--%>
                                     <%--headerValue="--请选择--" displayKey="id" displayValue="acc_name"/>--%>


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
                <div class="form-group">
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
                            selectPreOrders(this, uglcw.ui.get('#payDiv input[uglcw-model=proName]').value());
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
<script type="text/x-uglcw-template" id="freePay">
    <c:set var="datas" value="${fns:loadListByParam('fin_income_item','id,item_name','mark=1')}"/>
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="col-xs-6">核销金额</label>
                    <div class="col-xs-18">
                        <input uglcw-role="numeric" uglcw-model="freeAmt">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-xs-6">核销日期</label>
                    <div class="col-xs-18">
                        <input uglcw-options="format:'yyyy-MM-dd HH:mm'" uglcw-role="datetimepicker" uglcw-model="payTime" value="${payTime}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-xs-6">费用科目</label>
                    <div class="col-xs-14">
                        <select uglcw-role="combobox" id="costId" uglcw-model="costId"
                                uglcw-options="
                                  url: '${base}manager/queryUseIncomeItemList?typeName=营业外收入',
                                  loadFilter:{
                                    data: function(response){
                                    var itemId = '';
                                    $(response.rows).each(function (i, row) {
                                           if(row.itemName=='核销未付款项'){
                                                itemId = row.id;
                                           }
                                       });
                                       uglcw.ui.get('#costId').value(itemId);
                                    return response.rows ||[];
                                    }
                                  },
                                  dataTextField: 'itemName',
                                  dataValueField: 'id'
                                "
                        >
                        </select>
                    </div>

                    <%--<div class="col-xs-18">--%>
                        <%--<input uglcw-role="gridselector" uglcw-model="itemName,costId"--%>
                               <%--uglcw-options="click: function(){--%>
                            <%--selectCostItem(this);--%>
                        <%--}--%>
                        <%--<c:if test="${fn:length(datas) > 0}">--%>
                            <%--,value:'${datas.get(0)['item_name']}'--%>
                            <%--,text: '${datas.get(0)['id']}'--%>
                        <%--</c:if>--%>
                        <%--"--%>
                        <%-->--%>
                    <%--</div>--%>
                </div>
                <div class="form-group">
                    <label class="col-xs-6">备注</label>
                    <div class="col-xs-18">
                        <textarea uglcw-role="textbox" uglcw-model="hxRemark"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<tag:costitem-selector-template
        typeUrl="manager/queryIncomeTypeList"
        url="manager/queryUseIncomeItemList"
/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })

    function showInfo() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection || selection.length < 1) {
            return uglcw.ui.warning('请选择要查看的记录');
        }
        var valid = true;
        $(selection).each(function (i, row) {
            if (row.inType === '应付往来单位初始化') {
                valid = false;
                return false;
            }
        })
        if (!valid) {
            return;
        }
        uglcw.ui.openTab('采购入库' + selection[0].id, '${base}manager/showstkin?dataTp=1&billId=' + selection[0].id);
    }

    function showPayStat() {
        uglcw.ui.openTab('付款统计', '${base}manager/toPayStat?dataTp=1');
    }

    function showNeedPayStat() {
        uglcw.ui.openTab('付款统计', '${base}manager/toNeedPayStat?dataTp=1');
    }

    function showPayHisList() {
        uglcw.ui.openTab('付款记录', '${base}manager/queryPayPageByBillId?dataTp=1');
    }

    function toBatchPay() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection || selection.length < 1) {
            return uglcw.ui.warning('请选择要查看的记录');
        }
        var valid = true;
        $(selection).each(function (i, row) {
            if (row.inType === '应付往来单位初始化') {
                valid = false;
                uglcw.ui.warning('有应付往来单位初始化，不允许批量收款');
                return false;
            }
        })
        if (!valid) {
            return;
        }

      var rtn =  uglcw.ui.Modal.open({
            title: '批量付款',
            content: $('#batch-pay-dialog').html(),
            width: 350,
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var form = uglcw.ui.get($(container).find('.form-horizontal'));
                if (!form.validate()) {
                    return false;
                }
                var data = uglcw.ui.bind($(container));
                uglcw.ui.confirm('您确认批量付款吗', function () {
                    uglcw.ui.loading();
                    $.ajax({
                        url: '${base}manager/batchInPay',
                        data: {
                            ids: $.map(selection, function (row) {
                                return row.id
                            }).join(','),
                            accId: data.accId,
                            remarks: data.remarks
                        },
                        type: 'post',
                        success: function (response) {
                            uglcw.ui.loaded();
                            if (response.state) {
                                uglcw.ui.Modal.close(rtn);
                                uglcw.ui.success(response.msg || '操作成功');
                                uglcw.ui.get('#grid').reload();
                            } else {
                                uglcw.ui.error(response.msg || '操作失败');
                            }
                        },
                        error: function () {
                            uglcw.ui.loaded();
                        }
                    })
                })
                return false;
            }
        })


    }

    function showPayList(billId, inType, billNo) {
        var query = {
            dataTp: 1,
            //sdate: uglcw.ui.get('#sdate').value(),
            //edate: uglcw.ui.get('#edate').value(),
            sourceBillNo: billNo,
            billId: billId
        };
        uglcw.ui.openTab('付款记录' + billId, '${base}manager/queryPayPageByBillId?' + $.map(query, function (v, k) {
            return k + '=' + v;
        }).join('&'));
    }

    function toPay(btn) {
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr'));
        row.payTimeStr = uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm');
        row.cash = row.needPay;
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

                        var url = '${base}manager/payProc';
                        if (row.inType === '应付往来单位初始化') {
                            url = '${base}manager/finInitWlYwMain/payInit';
                        } else if (row.inType === '杂费单') {
                            url = '${base}manager/stkExtrasFee/payFee';
                        }
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
                                        uglcw.ui.get('#grid').reload();
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

    function toFreePay(btn) {
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr'));

        var amt = Math.abs(row.disAmt) - Math.abs(row.payAmt + row.freeAmt);

        if (amt <= 0) {
            return uglcw.ui.warning('该单已支付完成，不需要核销')
        }
        var form = {
            freeAmt: row.needPay
        }
        var rtn= uglcw.ui.Modal.open({
            title: '核销:' + row.proName,
            content: $('#freePay').html(),
            success: function (container) {
                uglcw.ui.init(container);
                uglcw.ui.bind(container, form);
            },
            yes: function (container) {
                var validator = uglcw.ui.get($(container).find('.form-horizontal'));
                if (validator.validate()) {
                    var data = uglcw.ui.bind(container);
                    var url = '${base}manager/updateFreeAmt';
                    if(row.inType=='应付往来单位初始化'){
                        url = '${base}manager/finInitWlYwMain/updateInitYfFreeAmt';
                    }else if (row.inType === '杂费单') {
                        url = '${base}manager/stkExtrasFee/updateFeeYfFreeAmt';
                    }
                    alert(url);
                    uglcw.ui.confirm('确定核销吗?', function () {
                        uglcw.ui.loading();
                        $.ajax({
                            url: url,
                            data: {
                                billId: row.id,
                                freeAmt: data.freeAmt,
                                remarks: data.hxRemarks,
                                costId: data.costId,
                                payTime: data.payTime
                            },
                            type: 'post',
                            success: function (response) {
                                uglcw.ui.loaded();
                                if (response.state) {
                                    uglcw.ui.success('核销成功');
                                    uglcw.ui.get('#grid').reload();
                                    uglcw.ui.Modal.close(rtn);
                                } else {
                                    uglcw.ui.error(response.msg || '核销失败');
                                }
                            },
                            error: function () {
                                uglcw.ui.error('核销失败');
                                uglcw.ui.loaded();
                            }
                        })
                    })
                }
                return false;
            }
        })
    }

    var sender;

    function selectCostItem(e) {
        sender = e
        <tag:costitem-selector-script callback="onCostItemSelect"/>
    }

    function onCostItemSelect(data) {
        sender.bind('itemName, costId', {
            itemName: data.itemName,
            costId: data.id
        });
    }

    function selectPreOrders(sender, proName) {
        console.log(sender);
        uglcw.ui.Modal.showGridSelector({
            url: '${base}manager/selectFinPreOutPage',
            type: 'get',
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
                '<input uglcw-role="textbox" uglcw-model="proName" type="hidden" value="'+(proName||'')+'">' +
                '<input placeholder="开始日期" uglcw-role="datepicker" value="${sdate}" uglcw-model="sdate">' +
                '<input placeholder="结束日期" uglcw-role="datepicker" value="${edate}" uglcw-model="edate">',
            yes: function (data) {
                var row = data[0];
                uglcw.ui.bind("#payDiv",{
                    preNo: row.billNo,
                    preId: row.id
                });
                var preAmt = row.totalAmt - row.payAmt-row.freeAmt-row.backAmt;
                uglcw.ui.get('#preAmt').value(preAmt);
                uglcw.ui.get('#oldPreAmt').value(preAmt);
                uglcw.ui.get('#retAmt').value(
                    Number(uglcw.ui.get('#cash').value() - uglcw.ui.get('#preAmt').value()).toFixed(2)
                )
            }
        })
    }

</script>
</body>
</html>
