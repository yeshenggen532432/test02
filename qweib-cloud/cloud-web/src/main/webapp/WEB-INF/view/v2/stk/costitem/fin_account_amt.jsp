<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>货币资金</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
        <div class="layui-card header">
            <div class="layui-card-body">
                <ul class="uglcw-query form-horizontal" >
                    <li style="width:500px!important;">
                        <ul id="search" uglcw-role="radio" uglcw-model="accType"
                            uglcw-options='"layout":"horizontal",
                                        "dataSource":[{"text":"全部","value":""},
                                                     {"text":"现金","value":"0"},
                                                     {"text":"微信","value":"1"},
                                                     {"text":"支付宝","value":"2"},
                                                     {"text":"银行卡","value":"3"},
                                                     {"text":"无卡账号","value":"4"}]'>
                        </ul>
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
                    url: 'manager/queryAccountList',
                    serverAggregates: false,
                    criteria: '.form-horizontal',
                    aggregate: [
                      {field: 'accAmt', aggregate: 'sum'}
                    ]
                    }">

                        <div data-field="accTypeName" uglcw-options="width:160">账号类型</div>
                        <div data-field="accNo" uglcw-options="width:160">账号</div>
                        <div data-field="bankName" uglcw-options="width:140">其它</div>

                        <div data-field="remarks" uglcw-options="width:140">备注</div>
                        <div data-field="accAmt" uglcw-options="width:120,
                                 format:'{0:n2}',
                                 aggregates: ['sum'],
                                 footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#'
                        ">账户余额</div>
                        <div data-field="_operator"
                             uglcw-options="width:120, template: uglcw.util.template($('#formatterSt3').html())">操作
                        </div>
                    </div>
                </div>
            </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toFresh();" class="k-button k-button-icontext">
        <span class="k-icon "></span>刷新
    </a>
    <c:if test="${permission:checkUserButtonPdm('fin.finAccount.updateResetAcc') }">
        <a role="button" href="javascript:toResetAccAmt();" class="k-button k-button-icontext">
            <span class="k-icon k-i-redo"></span>更新账户资金
        </a>
    </c:if>
</script>
<script type="text/x-kendo-template" id="formatterSt3">
    <button class="k-button k-info" onclick="showDetail(#= data.id#, 1)">查看明细</button>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded()
    })


    function showDetail(accId) {
        top.layui.index.openTabsPage('${base}manager/toFinAccIo?accId=' + accId, '账户明细');

    }
    function toFresh() {//刷新
        uglcw.ui.get('#grid').reload();
    }

    function toResetAccAmt() {
        uglcw.ui.confirm('您确认更新资金吗？', function () {
            $.ajax({
                url:"manager/updateResetBatchAccAmt",
                type: "post",
                data: "",
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(json.msg);
                        return;
                    }
                }
            });
        });
    }
</script>
</body>
</html>
