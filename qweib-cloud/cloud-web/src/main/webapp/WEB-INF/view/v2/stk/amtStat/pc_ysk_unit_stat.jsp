<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>收货款管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        #grid .k-grid-toolbar {
            display: inline-flex;
            width: 100%;
        }

        #grid .k-grid-toolbar .inTypesClass .k-button {
            padding: 0em 1.6em 0em .4em !important;
        }

        #grid .k-grid-toolbar .inTypesClass .k-multiselect-wrap {
            padding-right: 0;
        }

        #grid .k-grid-toolbar .inTypesClass .k-multiselect-wrap li {
            margin: 0;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <select uglcw-role="combobox" uglcw-options="value: ''" uglcw-model="outType" placeholder="出库类型">
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>
                        <option value="报损出库">报损出库</option>
                        <%--<option value="领用出库">领用出库</option>--%>
                        <option value="借出出库">借出出库</option>
                        <%--<option value="销售出库">销售发票</option>--%>
                        <%--<option value="其它出库">其它出库发票</option>--%>
                    </select>
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
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="showXsth" id="showXsth" value="0" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="inTypes" id="inTypes" value="销售退货" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="showPre" id="showPre" value="0" uglcw-role="textbox"/>
                    <input type="hidden" uglcw-model="proType" value="" uglcw-role="textbox">
                    <input uglcw-model="unitName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="" placeholder="开始时间">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>

                <li style="width: 70px;">
                    <input uglcw-role="numeric" data-min="0" uglcw-model="beginAmt" placeholder="金额">
                </li>
                <li style="width: 20px!important; text-align: center">
                    <span style="line-height: 30px;">到</span>
                </li>
                <li style="width: 70px;">
                    <input uglcw-role="numeric" uglcw-model="endAmt" placeholder="金额">
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" value="1" uglcw-model="showShop"
                           id="showShop" onclick="search()">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showShop">显示连锁店</label>
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox"  uglcw-model="showNoZero"
                           id="showNoZero" onclick="search()"  uglcw-value="1">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showNoZero">过滤应收金额为0的数据</label>
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
            <div id="grid" uglcw-role="grid" class="uglcw-grid-compact"
                 uglcw-options="
                 responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    dblclick: function(row){
                       var q = uglcw.ui.bind('.query');
                       q.epcustomername=row.epcustomername
                       q.unitName=row.unitname;
                       q.proType=row.protype;
                       q.unitId=row.unitid;
                       q.beginAmt = 0;
                       q.endAmt = 0;
                       uglcw.ui.openTab(q.unitName+'_应收流水', '${base}manager/toYsUnitFlowPage?'+ $.map(q, function(v, k){
                          return k + '=' + (v);
                       }).join('&'));
                    },
                    url: '${base}manager/queryYskUnitStat',
                    aggregate:[
                     {field: 'disamt', aggregate: 'SUM'},
                     {field: 'disamt1', aggregate: 'SUM'},
                     {field: 'recamt', aggregate: 'SUM'},
                     {field: 'freeamt', aggregate: 'SUM'},
                     {field: 'sumamt', aggregate: 'SUM'}
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
                        	disamt: 0,
                        	disamt1: 0,
                        	recamt: 0,
                        	freeamt: 0,
                        	sumamt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     },
                    criteria: '.query',
                    pageable: true,
                    dataBound:function(){
                        uglcw.ui.init('.inTypesClass');
                    }
                    ">
                <div data-field="unitname" uglcw-options="width:180,tooltip: true, footerTemplate: '合计'">往来单位</div>
                <div data-field="disamt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.disamt || 0#'">销售金额
                </div>
                <div data-field="disamt1"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.disamt1 || 0#'">发货金额
                </div>

                <div data-field="recamt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.recamt || 0#'">已收金额
                </div>
                <div data-field="freeamt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.freeamt || 0#'">核销金额
                </div>
                <div data-field="sumamt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.sumamt || 0#'">应收金额
                </div>
                <div data-field="xsthamt"
                     uglcw-options="width:120,hidden:true, format: '{0:n2}'">剩余应付款
                </div>
                <div data-field="preamt"
                     uglcw-options="width:120, hidden:true,format: '{0:n2}'">剩余预收款
                </div>
                <div data-field="qkamt"
                     uglcw-options="width:120,hidden:true, format: '{0:n2}',template: uglcw.util.template($('#op-qkamt').html())">
                    欠款金额
                </div>
                <div data-field="options"
                     uglcw-options="width:330, template: uglcw.util.template($('#op-tpl').html()) ">操作
                </div>
                <div data-field="epcustomername" uglcw-options="width:150">所属二批</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showPayList();">
        <span class="k-icon k-i-search"></span>收款纪录
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toUnitRecPage();">
        <span class="k-icon k-i-search"></span>待收款单据
    </a>
    <!--<a role="button" class="k-button k-button-icontext"
       href="javascript:showRecStat();">
        <span class="k-icon k-i-search"></span>收货款统计
    </a>-->
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showYshkStat();">
        <span class="k-icon k-i-search"></span>预收货款信息
    </a>

    <div class="k-button">
        <input type="checkbox" uglcw-role="checkbox" uglcw-model="showPreChk"
               uglcw-options="type:'number'"
               class="k-checkbox" id="showPreChk"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="showPreChk">加载预收款</label>
    </div>

    <div class="k-button">
        <input type="checkbox" uglcw-role="checkbox" uglcw-model="showXsthChk"
               uglcw-options="type:'number'"
               class="k-checkbox" id="showXsthChk"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="showXsthChk">加载应付款</label>
    </div>

    <a class="inTypesClass" style="display: none;">
        <select uglcw-model="inTypesChk" id="inTypesChk" style="width: 300px;" onchange="search()" uglcw-role="multiselect"
                uglcw-options="value: '',clearButton:false,
         placeholder: '应付款类型'">
            <option value="销售退货">退货款</option>
            <option value="采购入库">采购款</option>
            <option value="其它入库">其它入库款</option>
        </select>
    </a>


</script>

<script type="text/x-uglcw-template" id="in-type-tag-template">
    <div style="width: 130px;
            text-overflow: ellipsis;
            white-space: nowrap">
        # for(var idx = 0; idx < values.length; idx++){ #
        #: values[idx]#
        # if(idx < values.length - 1) {# , # } #
        # } #
    </div>
</script>
<script type="text/x-uglcw-template" id="op-qkamt">
    <span>#=uglcw.util.toString(data.sumamt-data.xsthamt-data.preamt, 'n2')#</span>
</script>
<script type="text/x-uglcw-template" id="op-tpl">
    <%--# if(data.protype!=6){ #--%>
    <button class="k-button k-info"
            onclick="toRecBill(#= data.unitid#, '#= data.unitname#', '#=data.epcustomername#',#= data.protype#)">按单据收款
    </button>
    <button class="k-button k-info"
            onclick="toAutoRec(#= data.unitid#, '#= data.unitname#', #=data.sumamt#,#= data.protype#,#= data.xsthamt#,#=data.preamt#)">
        收款
    </button>
    <button class="k-button k-info"
            onclick="toAutoFree(#= data.unitid#, '#= data.unitname#', #=data.sumamt#,#= data.protype#)">核销
    </button>
    <%--# } #--%>
    # if(data.protype==6){ #
    <button class="k-button k-info"
            onclick="toChain(#= data.unitid#, '#= data.unitname#', '#=data.epcustomername#',#= data.protype#)">连锁客户
    </button>
    # } #
</script>
<script type="text/x-uglcw-template" id="rec-dialog">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6">往来单位</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" uglcw-model="cstId" type="hidden">
                        <input uglcw-role="textbox" uglcw-model="proType" type="hidden">
                        <input uglcw-role="textbox" readonly uglcw-model="khNm">
                        <input uglcw-role="textbox" uglcw-model="inTypes" type="hidden">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">应收金额</label>
                    <div class="col-xs-18">
                        <input uglcw-role="numeric" uglcw-model="amt" id="uglcwAmt" readonly>
                    </div>
                </div>
                <div id="xsthAmtDiv">
                    <div class="form-group">
                        <label class="control-label col-xs-6">抵扣应付款</label>
                        <div class="col-xs-18">
                            <input uglcw-role="numeric" uglcw-model="xsthAmt" id="uglcwXsthAmt" onchange="calAmt(this)"><span
                                style="color: red">（会自动抵扣相应应付单据）</span>
                        </div>
                    </div>
                </div>
                <div id="preAmtDiv">
                    <div class="form-group">
                        <label class="control-label col-xs-6">抵扣预收款</label>
                        <div class="col-xs-18">
                            <input uglcw-role="numeric" uglcw-model="preAmt" id="uglcwPreAmt" onchange="calAmt(this)"><span
                                style="color: red">（会自动抵扣预收单据）</span>
                        </div>
                    </div>
                </div>
                <div id="uglcwQkAmtDiv">
                    <div class="form-group">
                        <label class="control-label col-xs-6">欠款金额</label>
                        <div class="col-xs-18">
                            <input uglcw-role="numeric" uglcw-model="qkAmt" id="uglcwQkAmt" readonly>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">本次实收</label>
                    <div class="col-xs-18">
                        <input uglcw-validate="required" data-min="0" uglcw-role="numeric" id="uglcwCash" uglcw-model="cash">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">收款账号</label>
                    <div class="col-xs-18">
                        <tag:select2 validate="required" name="accId" id="accId" tableName="fin_account" headerKey=""
                                     whereBlock="status=0" headerValue="--请选择--" displayKey="id"
                                     displayValue="acc_name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-18">
                        <textarea uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
                <div class="form-group">
                    <p class="col-xs-24" style="color:red;">
                        说明：自动匹配收款功能，在收款时不需要选择待收款单，系统会自己根据收款的金额匹配相应的待收款销售单且会根据单据最早的时间逐单匹配；</p>
                </div>
            </form>
        </div>
    </div>
</script>


<script type="text/x-uglcw-template" id="free-dialog">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6">往来单位</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" uglcw-model="cstId" type="hidden">
                        <input uglcw-role="textbox" uglcw-model="proType" type="hidden">
                        <input uglcw-role="textbox" readonly uglcw-model="khNm">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">应收金额</label>
                    <div class="col-xs-18">
                        <input uglcw-role="numeric" uglcw-model="amt" readonly>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">本次核销</label>
                    <div class="col-xs-18">
                        <input uglcw-validate="required" data-min="0" uglcw-role="numeric" uglcw-model="cash">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">费用科目</label>
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
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-18">
                        <textarea uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            search();
        })
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })
        uglcw.ui.get('#showXsthChk').on('change', function () {
            var checked = $("#showXsthChk").is(":checked");
            var showPreChk = $("#showPreChk").is(":checked");
            var bool = checked;
            if (!bool) {
                bool = showPreChk;
            }
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('xsthamt');
                uglcw.ui.get("#showXsth").value(1);
                $(".inTypesClass").show();
            } else {
                grid.hideColumn('xsthamt');
                uglcw.ui.get("#showXsth").value(0);
                $(".inTypesClass").hide();
            }
            if (bool) {
                grid.showColumn("qkamt");
            } else {
                grid.hideColumn("qkamt");
                uglcw.ui.get('#inTypesChk').value('');
            }
            search();
        });

        uglcw.ui.get('#showPreChk').on('change', function () {
            var checked = $("#showPreChk").is(":checked");
            var xsthChk = $("#showXsthChk").is(":checked");
            var bool = checked;
            if (!bool) {
                bool = xsthChk;
            }
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('preamt');
                uglcw.ui.get("#showPre").value(1);
                // grid.showColumn("qkamt");
            } else {
                grid.hideColumn('preamt');
                // grid.hideColumn("qkamt");
                uglcw.ui.get("#showPre").value(0);
            }
            if (bool) {
                grid.showColumn("qkamt");
            } else {
                grid.hideColumn("qkamt");
            }
            search();
        });
        uglcw.ui.loaded()
    })

    function search() {
        var inTypes = uglcw.ui.get("#inTypesChk").value();
        if (inTypes == "销售退货") {
            inTypes = "销售退货";
        }
        uglcw.ui.get("#inTypes").value(inTypes);
        uglcw.ui.get('#grid').reload();
    }

    function toAutoFree(cstId, cstName, amt, proType) {
        var cash = parseFloat(amt);
        var rtn = uglcw.ui.Modal.open({
            content: $('#free-dialog').html(),
            title: '核销',
            success: function (container) {
                uglcw.ui.init(container);
                uglcw.ui.bind($(container).find('form'), {
                    cstId: cstId,
                    khNm: cstName,
                    amt: amt,
                    cash: amt,
                    proType: proType
                });
            },
            yes: function (container) {
                var form = $(container).find('form');
                var validate = uglcw.ui.get(form).validate();
                if (validate) {

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

                    var data = uglcw.ui.bind(form);

                    if (parseFloat(data.amt) < 0) {
                        uglcw.ui.info('核销金额为负数时，请按具体单据核销');
                        return false;
                    }

                    if (parseFloat(data.amt) <= 0) {
                        uglcw.ui.info('本次核销必须大于0');
                        return false;
                    }

                    if (parseFloat(data.cash) > parseFloat(data.amt)) {
                        uglcw.ui.info('本次核销不能大于' + data.amt);
                        return false;
                    }

                    if (parseFloat(data.cash) > parseFloat(data.amt)) {
                        uglcw.ui.info('本次核销不能大于' + data.amt);
                        return false;
                    }

                    uglcw.ui.confirm('确认核销吗？', function () {
                        $.ajax({
                            url: '${base}manager/autoFreeBill',
                            data: data,
                            success: function (response) {
                                if (response.state) {
                                    uglcw.ui.success(response.msg);
                                    uglcw.ui.get('#grid').reload();
                                    uglcw.ui.Modal.close(rtn);
                                } else {
                                    uglcw.ui.error(response.msg);
                                }
                            }
                        })
                    })
                }
                return false;
            }
        })
    }


    function calAmt(o) {
        var uglcwAmt = $("#uglcwAmt").val();
        var uglcwXsthAmt = $("#uglcwXsthAmt").val();
        var uglcwPreAmt = $("#uglcwPreAmt").val();
        var uglcwQkAmt = parseFloat(uglcwAmt) - parseFloat(uglcwXsthAmt) - parseFloat(uglcwPreAmt);
        uglcw.ui.get('#uglcwQkAmt').value(uglcwQkAmt);
        uglcw.ui.get('#uglcwCash').value(uglcwQkAmt);
    }

    function toAutoRec(cstId, cstName, amt, proType, xsthAmt, preAmt) {
        var cash = parseFloat(amt) - parseFloat(xsthAmt);
        var qkAmt = parseFloat(amt) - parseFloat(xsthAmt) - parseFloat(preAmt);
        var inTypes = uglcw.ui.get("#inTypes").value();
        var rtn = uglcw.ui.Modal.open({
            content: $('#rec-dialog').html(),
            title: '收款',
            success: function (container) {
                var checked = $("#showXsthChk").is(":checked");
                var bool = checked;
                if (checked) {
                    $("#xsthAmtDiv").show();
                } else {
                    $("#xsthAmtDiv").hide();
                }
                checked = $("#showPreChk").is(":checked");
                if (!bool) {
                    bool = checked;
                }
                if (checked) {
                    $("#preAmtDiv").show();
                } else {
                    $("#preAmtDiv").hide();
                }

                if (bool) {
                    $("#uglcwQkAmtDiv").show();
                } else {
                    $("#uglcwQkAmtDiv").hide();
                }
                uglcw.ui.init(container);
                uglcw.ui.bind($(container).find('form'), {
                    cstId: cstId,
                    khNm: cstName,
                    amt: amt,
                    inTypes: inTypes,
                    qkAmt: qkAmt,
                    preAmt: preAmt,
                    cash: qkAmt,
                    proType: proType,
                    xsthAmt: xsthAmt
                });
            },
            yes: function (container) {
                var form = $(container).find('form');
                var validate = uglcw.ui.get(form).validate();
                if (validate) {
                    var data = uglcw.ui.bind(form);

                    if(parseFloat(data.amt)>0){
                        if(parseFloat(data.cash)<0){
                            uglcw.ui.info('本次实收必须大于0');
                            return false;
                        }
                        if (parseFloat(data.cash) > parseFloat(data.amt)) {
                            uglcw.ui.info('本次实收不能大于' + data.amt);
                            return false;
                        }
                    }else{
                        if(parseFloat(data.cash)>0){
                            uglcw.ui.info('本次实收必须小于0');
                            return false;
                        }
                        if (parseFloat(Math.abs(data.cash)) > parseFloat(Math.abs(data.amt))) {
                            uglcw.ui.info('本次实收不能大于' + data.amt);
                            return false;
                        }
                    }

                    if(parseFloat(data.qkAmt)>0){
                        if(parseFloat(data.cash)<0){
                            uglcw.ui.info('本次实收必须大于0');
                            return false;
                        }
                        if (parseFloat(data.cash) > parseFloat(data.qkAmt)) {
                            uglcw.ui.info('本次实收不能大于' + data.qkAmt);
                            return false;
                        }
                    }else{
                        if(parseFloat(data.cash)>0){
                            uglcw.ui.info('本次实收必须小于0');
                            return false;
                        }
                        if (parseFloat(Math.abs(data.cash)) > parseFloat(Math.abs(data.qkAmt))) {
                            uglcw.ui.info('本次实收不能大于' + data.qkAmt);
                            return false;
                        }
                    }

                    // if (parseFloat(Math.abs(data.cash)) > parseFloat(Math.abs(data.qkAmt))) {
                    //     uglcw.ui.info('本次实收不能大于' + data.qkAmt);
                    //     return false;
                    // }

                    if (parseFloat(data.xsthAmt) < 0) {
                        uglcw.ui.info('抵扣应付款必须大于0');
                        return false;
                    }

                    if (parseFloat(data.preAmt) < 0) {
                        uglcw.ui.info('预收抵扣必须大于0');
                        return false;
                    }

                    if (parseFloat(data.xsthAmt) > parseFloat(xsthAmt)) {
                        uglcw.ui.info('抵扣应付款不能大于' + xsthAmt);
                        return false;
                    }

                    if (parseFloat(data.preAmt) > parseFloat(preAmt)) {
                        uglcw.ui.info('预收抵扣不能大于' + preAmt);
                        return false;
                    }

                    // if (parseFloat(data.cash) <= 0) {
                    //     if (data.xsthAmt == 0 && data.preAmt == 0) {
                    //         uglcw.ui.info('本次实收必须大于0');
                    //         return false;
                    //     }
                    // }

                    uglcw.ui.confirm('确认收款吗？', function () {
                        $.ajax({
                            url: '${base}manager/autoRecBill',
                            data: data,
                            success: function (response) {
                                if (response.state) {
                                    uglcw.ui.success(response.msg);
                                    uglcw.ui.get('#grid').reload();
                                    uglcw.ui.Modal.close(rtn);
                                } else {
                                    uglcw.ui.error(response.msg);
                                }
                            }
                        })
                    })
                }
                return false;
            }
        })
    }

    function toRecBill(cstId, cstName, epcustomername, proType) {
        var q = uglcw.ui.bind('.query');
        q.epcustomername = epcustomername;
        q.unitName = cstName;
        q.proType = proType;
        q.unitId = cstId;
        uglcw.ui.openTab('待收款单据', '${base}manager/toUnitRecPage?' + $.map(q, function (v, k) {
            return k + '=' + encodeURIComponent(v);
        }).join('&'));
    }


    function toChain(cstId, cstName, epcustomername, proType) {
        var q = uglcw.ui.bind('.query');
        q.shopId = cstId;
        uglcw.ui.openTab('连锁店客户应收款', '${base}manager/toYskChainUnitStat?' + $.map(q, function (v, k) {
            return k + '=' + encodeURIComponent(v || '');
        }).join('&'));

    }

    function showPayList() {
        uglcw.ui.openTab('收款记录', '${base}manager/queryRecPageByBillId?dataTp=1')
    }

    function toUnitRecPage() {
        var query = uglcw.ui.bind('.query');
        uglcw.ui.openTab('待收款单据', '${base}manager/toUnitRecPage?' + $.map(query, function (v, k) {
            return k + '=' + encodeURIComponent(v || '');
        }).join('&'));
    }

    function showRecStat() {
        uglcw.ui.openTab('收货款统计', '${base}manager/toAccTypeAmtStat')
    }

    function showYshkStat() {
        uglcw.ui.openTab('预收货款信息', '${base}manager/toYshkPage?dataTp=1');
    }

</script>
</body>
</html>
