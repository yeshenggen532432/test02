<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="报销单号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="报销人员">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="itemName" placeholder="科目">
                </li>
                <li>
                    <input uglcw-role="dropdowntree" uglcw-model="itemName"
                           uglcw-options="
                                        placeholder: '部门',
                                        url:'manager/departs?dataTp=1'
                                       "
                    >
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="单据状态">
                        <option value="1">未付完</option>
                        <option value="0" selected>未审核</option>
                        <option value="2">作废</option>
                        <option value="3">已支付</option>
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
                         responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.form-horizontal',
                    dblclick: function(row){
                        uglcw.ui.openTab('费用报销'+row.id,'${base}manager/showFinCostEdit?billId='+row.id);
                    },
                    url: '${base}manager/queryFinCostPage',
                    criteria: '.form-horizontal',
                    }">
                <div data-field="billNo" uglcw-options="width:160,tooltip: true">单号</div>
                <div data-field="costTimeStr" uglcw-options="width:160">报销日期</div>
                <div data-field="proName" uglcw-options="width:120,tooltip: true">报销对象</div>
                <div data-field="operator" uglcw-options="width:100">经办人</div>
                <div data-field="totalAmt" uglcw-options="width:100">报销单金额</div>
                <div data-field="payAmt" uglcw-options="width:100">已报销金额</div>
                <div data-field="hxAmt" uglcw-options="width:100">已核销金额</div>
                <div data-field="restAmt" uglcw-options="width:100">未报销金额</div>
                <div data-field="billStatus"
                     uglcw-options="width:80">状态
                </div>
                <div data-field="count"
                     uglcw-options="width:200,template: function(data){
                            return kendo.template($('#formatterSt').html())(data.list);
                         }">科目信息
                </div>
                <div data-field="_operator"
                     uglcw-options="width:280, template: uglcw.util.template($('#formatterSt3').html())">操作
                </div>
                <div data-field="remarks" uglcw-options="width:130,tooltip: true">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:newBill();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>填写报销单
    </a>
</script>

<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" id="dlg" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-8">费用摊销期数</label>
                    <div class="col-xs-14">
                        <input class="form-control" uglcw-role="textbox" uglcw-model="termQty" value="1"
                               uglcw-validate="required">
                        <input type="hidden" id="checkId">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status==0){#
    未审批
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
<script type="text/x-kendo-template" id="formatterSt3">
    # if(data.status != 2){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#)">作废</button>
    # } #

    # if(data.status =='0'){ #
    <button class="k-button k-success" onclick="auditBill(#= data.id#)">审核</button>
    # } #
    # if(data.status =='1'){ #
    <button class="k-button k-success" onclick="showPayList('#= data.billNo#')">付款明细</button>
    <button class="k-button k-success" onclick="payBill(#= data.id#)">付款</button>
    <button class="k-button k-success" onclick="toFreePay(#= data.id#)">核销</button>
    # } #

</script>
<script id="formatterSt" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">明细科目名称</td>
            <td style="width: 5px;">费用金额</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].itemName #</td>
            <td>#= data[i].amt || 0#</td>
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
                url: "manager/cancelFinCost",
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
                    var textbox = uglcw.ui.bind($("#dlg"));
                    var costTerm = textbox.termQty;
                    if (costTerm < 1) {
                        uglcw.ui.warning('期数输入错误！');
                        return;
                    }
                    uglcw.ui.confirm('您确认要审核吗？', function () {
                        $.ajax({
                            url: "manager/updateCostAudit",
                            type: "post",
                            data: {
                                billId: id,
                                costTerm: costTerm,

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

    //付款明细
    function showPayList(costNo){
        uglcw.ui.openTab('付款明细', '${base}manager/toFinPayHis?costNo=' + costNo);
    }

    //核销
    function toFreePay(id){
        uglcw.ui.openTab('报销单-核销单', '${base}manager/toFinHxEdit?costBillId=' + id);
    }

    function payBill(id) {
        uglcw.ui.openTab('付款凭证', '${base}manager/toFinPayEdit?costBillId=' + id);

    }

    function newBill() {
        uglcw.ui.openTab('费用开单', '${base}manager/toFinCostEdit');

    }
</script>
</body>
</html>
