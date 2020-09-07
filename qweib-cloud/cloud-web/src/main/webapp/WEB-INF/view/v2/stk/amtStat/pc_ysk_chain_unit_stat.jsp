<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>收货款管理--连锁店客户</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
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
                        <option value="借出出库">借出出库</option>
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
                    <input type="hidden" uglcw-model="proType" value="" uglcw-role="textbox">
                    <input uglcw-model="unitName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间">
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
                    <tag:select2 name="shopId" id="shopId" value="${shopId}" tableName="sys_chain_store"
                                 displayKey="id" displayValue="store_name" placeholder="所属连锁店"/>
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
                    dblclick: function(row){
                       <%--var q = uglcw.ui.bind('.query');--%>
                       <%--q.epcustomername=row.epcustomername--%>
                       <%--q.unitName=row.unitname;--%>
                       <%--q.proType=row.protype;--%>
                       <%--q.unitId=row.unitid;--%>
                       <%--uglcw.ui.openTab('待收款单据', '${base}manager/toUnitRecPage?'+ $.map(q, function(v, k){--%>
                      <%--return k + '=' + (v);--%>
                       <%--}).join('&'));--%>

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
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.sumamt || 0#'">欠款金额
                </div>
                <div data-field="options"
                     uglcw-options="width:200, template: uglcw.util.template($('#op-tpl').html()) ">操作
                </div>
                <div data-field="epcustomername" uglcw-options="width:150">所属二批</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="op-tpl">
    <%--# if(data.protype!=6){ #--%>
    <button class="k-button k-info" onclick="toRecBill(#= data.unitid#, '#= data.unitname#', '#=data.epcustomername#',#= data.protype#)">按单据收款</button>
    <button class="k-button k-info" onclick="toAutoRec(#= data.unitid#, '#= data.unitname#', #=data.sumamt#,#= data.protype#)">收款</button>
    <%--# } #--%>
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
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">欠款金额</label>
                    <div class="col-xs-18">
                        <input uglcw-role="numeric" uglcw-model="amt" readonly>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">本次收款</label>
                    <div class="col-xs-18">
                        <input uglcw-validate="required" data-min="0" uglcw-role="numeric" uglcw-model="cash">
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
                        说明：自动匹配收款功能，在收款时不需要选择待收款单，系统会自己根据收款的金额匹配相应的待收款单且会根据单据最早的时间逐单匹配；</p>
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
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })
        uglcw.ui.loaded()
    })

    function search() {
        uglcw.ui.get('#grid').reload();
    }

    function toAutoRec(cstId, cstName, amt,proType) {
        var rtn = uglcw.ui.Modal.open({
            content: $('#rec-dialog').html(),
            title: '收款',
            success: function (container) {
                uglcw.ui.init(container);
                uglcw.ui.bind($(container).find('form'), {cstId: cstId, khNm: cstName, amt: amt, cash: amt,proType:proType});
            },
            yes: function (container) {
                var form = $(container).find('form');
                var validate = uglcw.ui.get(form).validate();
                if (validate) {
                    var data = uglcw.ui.bind(form);

                    if (parseFloat(data.amt)<=0) {
                        uglcw.ui.info('本次收款必须大于0');
                        return false;
                    }

                    if (parseFloat(data.cash) > parseFloat(data.amt)) {
                        uglcw.ui.info('本次收款不能大于' + data.amt);
                        return false;
                    }
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

    function toRecBill(cstId, cstName, epcustomername,proType){
        var q = uglcw.ui.bind('.query');
        q.epcustomername=cstId;
        q.unitName=cstName;
        q.proType=proType;
        q.unitId=cstId;
        uglcw.ui.openTab('待收款单据', '${base}manager/toUnitRecPage?'+ $.map(q, function(v, k){
            return k + '=' + (v);
        }).join('&'));
    }
</script>
</body>
</html>
