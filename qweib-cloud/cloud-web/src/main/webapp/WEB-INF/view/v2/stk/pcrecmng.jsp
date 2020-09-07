<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>收货款管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <select uglcw-model="timeType" id="timeType" uglcw-options="allowInput: false, clearButton: false" uglcw-role="combobox">
                        <option value="2">按单据时间</option>
                        <option value="1">按发货时间</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="customerType"
                            uglcw-options="
                                    placeholder:'客户类型',
									url: '${base}manager/queryarealist1',
									dataTextField: 'qdtpNm',
									dataValueField: 'qdtpNm',
									loadFilter: {
										data: function(response){
											return response.list1 || [];
										}
									}
								"
                    ></select>
                </li>
                <li>
                    <input type="hidden" uglcw-model="proType" value="${proType}" uglcw-role="textbox">
                    <input uglcw-model="khNm" uglcw-role="textbox" value="${khNm}" placeholder="往来单位" id="khNm">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="memberNm" placeholder="业务员">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="单据单号">
                </li>
                <li>
                    <select uglcw-model="outType" uglcw-role="combobox" placeholder="单据类型">
                        <option value="">单据类型</option>
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>
                    </select>
                </li>
                <li>
                    <select uglcw-model="sendStatus" uglcw-role="combobox" uglcw-options="allowInput: false, clearButton: false">
                        <option value="0">包含未发货</option>
                        <option value="1" selected="selected">已发货</option>
                    </select>
                </li>
                <li>
                    <select uglcw-model="isPay" uglcw-role="combobox" uglcw-options="
                        allowInput: false,
                        clearButton: false" placeholder="收款状态">
                        <option value="0" selected="selected">未收款</option>
                        <option value="1">已收款</option>
<%--                        <option value="2">作废</option>--%>
<%--                        <option value="1">需退款</option>--%>
                    </select>
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage"
                                 whereBlock="status=1 or status is null"
                                 headerKey="" headerValue="仓库"
                                 displayKey="id" displayValue="stk_name" placeholder="仓库"/>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="saleCar"  uglcw-options="value:'', tooltip: '仓库类型'"  placeholder="仓库类型">
                        <option value="0">正常仓库</option>
                        <option value="1">车销仓库</option>
                        <option value="2">门店仓库</option>
                    </select>
                </li>
                <li>
                    <tag:select2 name="carId" id="carId" tableName="stk_vehicle" headerKey="" headerValue="车辆"
                                 displayKey="id" displayValue="veh_no" placeholder="车辆"/>
                </li>
                <li>
                    <tag:select2 name="shopId" id="shopId" value="${shopId}" tableName="sys_chain_store" headerKey="" headerValue="所属连锁店"
                                 displayKey="id" displayValue="store_name" placeholder="所属连锁店"/>
                </li>

                <li >
                    <input uglcw-role="numeric" style="width: 70px" uglcw-options="spinners: false" data-min="0"
                           uglcw-model="beginAmt" placeholder="单据金额">到
                    <input uglcw-role="numeric" style="width: 70px;" uglcw-options="spinners: false" uglcw-model="endAmt"
                                                                           placeholder="单据金额">
                </li>
                <li>
                    <input uglcw-model="epCustomerName" value="${epCustomerName}" uglcw-role="textbox"
                           placeholder="所属二批">
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
                         if(row.outType === '应收往来单位初始化'){
                            return;
                         }
                         uglcw.ui.openTab('单据信息'+row.id, '${base}manager/showstkout?dataTp=1&billId='+row.id);
                    },
                    checkbox: true,
                    url: '${base}manager/stkOutPageForRec',
                    aggregate:[
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'disAmt1', aggregate: 'SUM'},
                     {field: 'needRec', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        var rows = response.rows || [];
                        rows.splice(rows.length - 1, 1);
                        return rows
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	disAmt: 0,
                        	disAmt1: 0,
                        	needRec:0
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
                <div data-field="billNo" uglcw-options="width:160,tooltip: true,
				 		template: uglcw.util.template($('#formatterEvent').html()),footerTemplate: '合计'">单据单号
                </div>
                <div data-field="khNm" uglcw-options="width:150, tooltip: true">往来单位</div>
                <div data-field="outDate" uglcw-options="width:130">单据日期</div>

                <div data-field="options"
                     uglcw-options="width:250, template: uglcw.util.template($('#op-tpl').html()) ">操作
                </div>

                <div data-field="disAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.disAmt,\'n2\')#'">
                    单据金额
                </div>
                <div data-field="disAmt1"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.disAmt1, \'n2\')#'">
                    发货金额
                </div>
                <div data-field="recAmt"
                     uglcw-options="width:120, format: '{0:n2}'">已收金额
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120, format: '{0:n2}'">核销金额
                </div>
                <div data-field="needRec"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.needRec,\'n2\')#'">
                    未收金额
                </div>
                <div data-field="outType" uglcw-options="width:80">单据类型</div>
                <div data-field="stkName" uglcw-options="width:80">仓库</div>
                <div data-field="staff" uglcw-options="width:80">业务员</div>
                <div data-field="billStatus" uglcw-options="width:120">发货状态</div>
                <div data-field="recStatus" uglcw-options="width:120">收款状态</div>
                <div data-field="epCustomerName" uglcw-options="width:120">所属二批</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">

    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>导出
    </a>

    <a role="button" class="k-button k-button-icontext"
       href="javascript:toBatchRec();">
        <span class="k-icon k-i-search"></span>批量收款
    </a>
</script>
<script id="formatterEvent" type="text/x-uglcw-template">
    #if(data.outType=='应收往来单位初始化'){#
    #= data.billNo#
    #}else{#
    <a style="color:blue;" href="javascript:showSourceBill(#=data.id#)">#=data.billNo#</a>
    #}#
</script>
<script type="text/x-uglcw-template" id="op-tpl">
    # if(data.id){ #
    # if(data.outType === '应收往来单位初始化'){ #
    <a class="k-button k-info" onclick="showPayList(#= data.id#, '#= data.outType#', '#= data.billNo#')">收款明细
    </a>
    <a class="k-button k-info" onclick="toRec(this)">收款</a>
    <a class="k-button k-info" onclick="toFreePay(this)">核销</a>
    # }else{ #
    <a class="k-button k-info" onclick="showPayList(#= data.id#, '#= data.outType#', '#= data.billNo#')">收款明细
    </a>
    <a class="k-button k-info" onclick="toRec(this)">收款</a>
    <a class="k-button k-info" onclick="toFreePay(this)">核销</a>
    <%--# if(data.needRtn == 1){ #--%>
    <%--<a class="k-button k-info" onclick="toRecRtn(this)">退款</a>--%>
    <%--# } #--%>
    # } #
    #}#
</script>
<script type="text/x-uglcw-template" id="batch-pay-dialog">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                    <div class="form-group">
                        <label class="control-label col-xs-6">收款总金额</label>
                        <div class="col-xs-14">
                            <input disabled uglcw-role="textbox" uglcw-model="cash">
                        </div>
                    </div>
                    <div class="form-group">
                         <label class="control-label col-xs-6">收款账号</label>
                        <div class="col-xs-14">
                            <input uglcw-validate="required" uglcw-role="combobox" id="accId" uglcw-model="accId" uglcw-options="
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
                        <label class="control-label col-xs-6">收款时间</label>
                        <div class="col-xs-14">
                            <input uglcw-options="format:'yyyy-MM-dd HH:mm:ss'"
                                   uglcw-role="datetimepicker" uglcw-model="recTimeStr">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-6">批量方式</label>
                        <div class="col-xs-14">
                            <ul uglcw-role="radio" uglcw-model="recWay"
                                uglcw-value="1"
                                uglcw-options='layout:"horizontal",
                                                                 dataSource:[{"text":"合并收款","value":"1"},{"text":"分批收款","value":"2"}]
                                                     '></ul>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-6">备注</label>
                        <div class="col-xs-14">
                            <textarea uglcw-role="textbox" uglcw-model="remarks"></textarea>
                        </div>
                    </div>
            </div>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="pc_pay1">
    <div class="layui-card">
        <div id="recDiv" class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <input type="hidden" uglcw-model="billId" uglcw-role="textbox"/>
                <div class="form-group">
                    <label class="control-label col-xs-6">往来单位</label>
                    <div class="col-xs-18">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="cstId">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="proId">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="proType" id="payProType">
                        <input disabled uglcw-role="textbox" uglcw-model="cstName" id="cstName">
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
                        <input disabled uglcw-role="textbox" uglcw-model="recAmt1">
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
                    <span style="font-weight: bold" class="control-label col-xs-6" for="link-checkbox">关联抵扣款单</span>
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
                            selectPreOrders(this);
                        } ">
                        </div>
                        <div class="col-xs-6" style="padding-left: 0px;">
                            <input id="oldPreAmt" uglcw-role="textbox" type="hidden" uglcw-model="oldPreAmt"/>
                            <input id="preAmt" placeholder="本次抵扣金额" uglcw-role="numeric" uglcw-model="preAmt"/>
                        </div>
                        <div class="col-xs-12">
                            <ul uglcw-role="radio" uglcw-model="ysChk" id="ysChk"
                                uglcw-value="0"
                                uglcw-options='layout:"horizontal",
                                    dataSource:[{"text":"预收款单","value":"0"},{"text":"应付款单","value":"1"}]
                                    '></ul>
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
                        <input uglcw-options="format:'yyyy-MM-dd HH:mm'" uglcw-role="datetimepicker" uglcw-model="recTime"
                               value="${recTime}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-xs-6">费用科目</label>
                    <div class="col-xs-18">
                            <select uglcw-role="combobox" id="costId" uglcw-model="costId"
                                    uglcw-options="
                                  url: '${base}manager/queryUseCostItemList?typeName=经营费用',
                                  loadFilter:{
                                    data: function(response){
                                    var defaultItem = '${defaultItem}';
                                    var itemId = '';
                                    if(defaultItem != null && defaultItem != ''){
                                        $(response.rows).each(function (i, row) {
                                           if(row.id==defaultItem){
                                                itemId = row.id;
                                                return false;
                                           }
                                        });
                                    }
                                    if(itemId == ''){
                                    $(response.rows).each(function (i, row) {
                                           if(row.itemName=='核销未收款'){
                                                itemId = row.id;
                                                return false;
                                           }
                                       });
                                    }
                                    uglcw.ui.get('#costId').value(itemId);
                                    return response.rows ||[];
                                    }
                                  },
                                  dataTextField: 'fullName',
                                  dataValueField: 'id'
                                "
                            >
                            </select>
                    </div>
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
        typeUrl="manager/toDialogCostType"
        url="manager/queryUseCostItemList"
/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<tag:exporter service="stkOutService" method="queryOutPageForRec"
                      bean="com.qweib.cloud.biz.erp.model.StkOut"
                      removeField="options"
                      condition=".query" description="待收款单据列表"
/>
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

    function toBatchRec() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection || selection.length < 1) {
            return uglcw.ui.warning('请选择要收款的记录');
        }
        var valid = true;
        var totalAmt = 0;
        $(selection).each(function (i, row) {
            var needAmt = parseFloat(row.disAmt*100) - parseFloat(row.recAmt*100) - parseFloat(row.freeAmt*100);
            totalAmt+=needAmt;
        })
        if (!valid) {
            return;
        }
       var row = {};
       var recTimeStr = uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm:ss');
        row.recTimeStr = recTimeStr;
        row.cash = totalAmt/100;
       var rtn = uglcw.ui.Modal.open({
            title: '批量收款',
            content: $('#batch-pay-dialog').html(),
            width: 400,
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind(container, row);
            },
            yes: function (container) {
                var form = uglcw.ui.get($(container).find('.form-horizontal'));
                if (!form.validate()) {
                    return false;
                }
                var data = uglcw.ui.bind($(container));
                uglcw.ui.confirm('您确认批量收款吗', function () {
                    uglcw.ui.loading();
                    $.ajax({
                        url: '${base}manager/batchRec',
                        data: {
                            billNos: $.map(selection, function (row) {
                                return row.billNo
                            }).join(','),
                            accId: data.accId,
                            cash:data.cash,
                            recTimeStr:data.recTimeStr,
                            recWay:data.recWay,
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

    function showPayList(billId, outType, billNo) {
        if (outType === '应收往来单位初始化') {
            uglcw.ui.openTab('收款记录' + billId, '${base}manager/queryRecPageByBillId?dataTp=1&billId=&sourceBillNo=' + billNo);
        } else {
            uglcw.ui.openTab('收款记录' + billId, '${base}manager/queryRecPageByBillId?dataTp=1&billId=' + billId);
        }
    }

    function toRec(btn) {
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr'));
        row.recTimeStr = uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm');
        var needAmt = parseFloat(row.disAmt*100) - parseFloat(row.recAmt*100) - parseFloat(row.freeAmt*100);
        row.cash = needAmt/100;
        row.cstName = row.khNm;
        row.cstId = row.cstId;
        row.needRec =needAmt/100;
        row.recAmt1 = parseFloat(row.recAmt) +  parseFloat(row.freeAmt);
        row.needRec1 =row.needRec;
        row.billId = row.id;
        row.proType = row.proType;
        var redMark = row.redMark;
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
                    var ioMark = 1;
                    if(redMark==1){
                        ioMark =-1;
                    }
                    if (data.cash*ioMark < data.preAmt*ioMark) {
                        uglcw.ui.warning('抵扣金额不能大于本次收款金额');
                        return false;
                    }
                    if (data.needRec*ioMark < data.cash*ioMark) {
                        uglcw.ui.warning('收款金额不能大于单据金额:' + data.needRec);
                        return false;
                    }
                    if (data.accId == 0) {
                        if (data.cash*ioMark > data.preAmt*ioMark) {
                            return uglcw.ui.error('请选择收款账户');
                        }
                    }
                    if(data.preAmt!=0&&data.preAmt!=""&&data.preAmt!=null){
                        if(data.preNo==""||data.preNo==null){
                            return uglcw.ui.error('请选择抵扣单号!');
                        }
                    }

                    var url = '${base}manager/recProc';
                    if (row.outType === '应收往来单位初始化') {
                        url = '${base}manager/finInitWlYwMain/recInit';
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
                                    uglcw.ui.get('#grid').reload();
                                    uglcw.ui.Modal.close(rtn);
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
        if (row.disAmt - row.recAmt - row.freeAmt <= 0) {
            //return uglcw.ui.warning('该单已支付完成，不需要核销')
        }
        var needAmt = parseFloat(row.disAmt*100) - parseFloat(row.recAmt*100) - parseFloat(row.freeAmt*100);
        var needRec = needAmt/100;
        var form = {
            freeAmt: needRec
        }
        var rtn = uglcw.ui.Modal.open({
            title: '核销:' + row.khNm,
            content: $('#freePay').html(),
            success: function (container) {
                uglcw.ui.init(container);
                uglcw.ui.bind(container, form);
            },
            yes: function (container) {
                var validator = uglcw.ui.get($(container).find('.form-horizontal'));
                if (validator.validate()) {
                    //如果费用科目为空，默认为核销未收款
                    if(uglcw.ui.get('#costId').value()==''){
                        var itemId;
                        $("select[name$='costId'] option").each(function(){
                            if($(this).text() == "核销未收款"){
                                itemId = $(this).val();
                                return false;
                            }
                        });
                        uglcw.ui.get('#costId').value(itemId);
                    }
                    var data = uglcw.ui.bind(container);
                    var url = '${base}manager/updateOutFreeAmt';
                    if(row.outType=='应收往来单位初始化'){
                        url = '${base}manager/updateInitYsFreeAmt';
                    }
                    uglcw.ui.confirm('确定核销吗?', function () {
                        uglcw.ui.loading();
                        $.ajax({
                            url:url,
                            data: {
                                billId: row.id,
                                freeAmt: data.freeAmt,
                                remarks: data.hxRemark,
                                costId: data.costId,
                                recTime: data.recTime
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

    function selectPreOrders(sender) {
        console.log(sender);
        var v = uglcw.ui.get('#ysChk').value();
        if (v == 0) {
            uglcw.ui.Modal.showGridSelector({
                url: '${base}manager/selectFinPreInPage',
                type: 'get',
                title: "选择预收款单",
                query: function (params) {
                    params.jz = 1;
                    params.proName = uglcw.ui.get('#cstName').value();
                    params.proType = uglcw.ui.get('#payProType').value();
                },
                columns: [
                    {title: '单号', field: 'billNo', width: 160},
                    {title: '单据日期', field: 'billTime', width: 120},
                    {title: '往来单位', field: 'proName', width: 120},
                    {title: '账户名称', field: 'accName', width: 120},
                    {title: '预收金额', field: 'totalAmt', width: 120},
                    {title: '剩余抵扣金额', field: 'rectAmt', width: 120, template: '#= data.totalAmt - data.payAmt#'},
                    {title: '备注', field: 'remarks', width: 120}
                ],
                btns: [],
                criteria: '<input placeholder="单号" uglcw-role="textbox" uglcw-model="billNo">' +
                    '<input placeholder="开始日期" uglcw-role="datepicker" uglcw-model="sdate">' +
                    '<input placeholder="结束日期" uglcw-role="datepicker" value="${edate}" uglcw-model="edate">',
                yes: function (data) {
                    var row = data[0];
                    // sender.bind('preNo,preId', {
                    //     preNo: row.billNo,
                    //     preId: row.id
                    // });

                    uglcw.ui.bind("#recDiv",{
                        preNo: row.billNo,
                        preId: row.id
                    });

                    var preAmt = (row.totalAmt - row.payAmt-row.backAmt-row.freeAmt);
                    uglcw.ui.get('#preAmt').value(preAmt);
                    uglcw.ui.get('#oldPreAmt').value(preAmt);
                    uglcw.ui.get('#retAmt').value(
                        Number(uglcw.ui.get('#cash').value() - uglcw.ui.get('#preAmt').value()).toFixed(2)
                    )
                }
            })
        } else if (v == 1) {
            uglcw.ui.Modal.showGridSelector({
                url: '${base}manager/selectPayPage',
                type: 'get',
                title: "选择应付款单",
                query: function (params) {
                    params.jz = 1;
                    params.isPay = 0;
                    params.proName = uglcw.ui.get('#cstName').value();
                    params.proType = uglcw.ui.get('#payProType').value();
                },
                columns: [
                    {title: '单据单号', field: 'billNo', width: 160},
                    {title: '单据日期', field: 'inDate', width: 120},
                    {title: '入库类型', field: 'inType', width: 120},
                    {title: '付款对象', field: 'proName', width: 120},
                    {title: '单据金额', field: 'disAmt', width: 120},
                    {title: '已付款', field: 'payAmt', width: 120},
                    {title: '核销金额', field: 'freeAmt', width: 120},
                    {title: '未付金额', field: 'needPay', width: 120},
                    {title: '收货状态', field: 'billStatus', width: 120},
                    {title: '付款状态', field: 'payStatus', width: 120}
                ],
                btns: [],
                criteria: '<input placeholder="单据单号" uglcw-role="textbox" uglcw-model="billNo">' +
                    '<input placeholder="单据日期" uglcw-role="datepicker"  uglcw-model="sdate">' +
                    '<input uglcw-role="datepicker" value="${edate}" uglcw-model="edate">',
                yes: function (data) {
                    var row = data[0];

                    uglcw.ui.bind("#recDiv",{
                        preNo: row.billNo,
                        preId: row.id
                    });
                    //
                    // sender.bind('preNo,preId', {
                    //     preNo: row.billNo,
                    //     preId: row.id
                    // });
                    var preAmt = row.totalAmt - row.payAmt;
                    uglcw.ui.get('#preAmt').value(preAmt);
                    uglcw.ui.get('#oldPreAmt').value(preAmt);
                    uglcw.ui.get('#retAmt').value(
                        Number(uglcw.ui.get('#cash').value() - uglcw.ui.get('#preAmt').value()).toFixed(2)
                    )
                }
            })
        }

    }

    function showSourceBill(sourceBillId) {
        uglcw.ui.openTab('单据信息' + sourceBillId, '${base}manager/showstkout?dataTp=1&billId=' + sourceBillId);
    }
</script>
</body>
</html>
