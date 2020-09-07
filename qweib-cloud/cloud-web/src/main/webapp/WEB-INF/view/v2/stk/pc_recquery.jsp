<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>收款记录</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .row-color-blue {
            color: blue;
            text-decoration: line-through;
            font-weight: bold;
        }

        .row-color-pink {
            color: #FF00FF;
            font-weight: bold;
        }

        .row-color-red {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query" id="export">
                <li style="display: none">
                    <input type="hidden" uglcw-model="billId" value="${billId}" uglcw-role="textbox">
                    <select uglcw-role="combobox" uglcw-model="outType" id="outType" uglcw-options="value: '${outType}'">
                        <option value="1">非返利收款</option>
                        <option value="2">返利收款</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="memberNm" placeholder="收款人">
                </li>

                <li>

                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="收款单号">
                </li>
                <li>
                    <input uglcw-model="sourceBillNo" value="${sourceBillNo}" uglcw-role="textbox" placeholder="单号">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="billType">
                        <option value="">全部</option>
                        <option value="0">收款</option>
                        <option value="1">核销</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status">
                        <option value="">全部</option>
                        <option value="0">正常单</option>
                        <option value="2">作废单</option>
                        <option value="3">被冲红单</option>
                        <option value="4">冲红单</option>
                    </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li style="width: 300px !important; padding-top: 5px">
                    <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>
                    &nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>
                    &nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    align: 'center',
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    dblclick:function(row){
                      var outType = uglcw.ui.get('#outType').value();
                      showDetail(row, outType);
                    },
                    loadFilter:{
                        data: function(resp){
                            var rows = resp.rows || [];
                            rows.splice(rows.length - 1, 1);
                            return rows;
                        },
                        aggregates: function(resp){
                            var agg = {sumAmt: 0, cash:0, bank:0, wx: 0, zfb: 0};
                            if(resp.rows && resp.rows.length>0){
                                agg = uglcw.extend(agg, resp.rows[resp.rows.length - 1]);
                            }
                            return agg;
                        }
                    },
                    aggregate:[
                        {field: 'sumAmt', aggregate: 'SUM'},
                        {field: 'cash', aggregate: 'SUM'},
                        {field: 'bank', aggregate: 'SUM'},
                        {field: 'wx', aggregate: 'SUM'},
                        {field: 'zfb', aggregate: 'SUM'},
                    ],
                    pageable: true,
                    url: 'manager/stkRecPage',
                    criteria: '.query',
                    dataBound: function(){
                        var data = this.dataSource.view();
                        $(data).each(function(idx, row){
                            var clazz = ''
                            if(row.status == 2){
                                clazz = 'row-color-blue';
                            }else if(row.status == 3){
                                clazz = 'row-color-pink';
                            }else if(row.status == 4){
                                clazz = 'row-color-red';
                            }
                            $('#grid tr[data-uid='+row.uid+']').addClass(clazz);
                        })
                    }">
                <div data-field="billNo" uglcw-options="width:170">收款单号</div>
                <div data-field="sourceBillNo" uglcw-options="width:170,
                        template: uglcw.util.template($('#formatterEvent').html())">单号
                </div>
                <div data-field="proName" uglcw-options="width:160">往来对象</div>
                <div data-field="recTimeStr" uglcw-options="width:160">收款时间</div>
                <div data-field="memberNm" uglcw-options="width:100">收款人</div>
                <div data-field="sumAmt"
                     uglcw-options="width:140, footerTemplate: '#= uglcw.util.toString(data.sumAmt,\'n2\')#'">总收款/核销金额
                </div>
                <div data-field="cash"
                     uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.cash,\'n2\')#'">现金
                </div>
                <div data-field="bank"
                     uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.bank,\'n2\')#'">银行转账
                </div>
                <div data-field="wx"
                     uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.wx,\'n2\')#'">微信
                </div>
                <div data-field="zfb"
                     uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.zfb,\'n2\')#'">支付宝
                </div>
                <div data-field="wk"
                     uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.wk,\'n2\')#'">无卡账户
                </div>
                <div data-field="preAmt" uglcw-options="width:100">抵扣预收款</div>
                <div data-field="xsthAmt" uglcw-options="width:100">退货金额</div>
                <div data-field="billTypeStr" uglcw-options="width:120">类型</div>
                <div data-field="status"
                     uglcw-options="width:80, template: uglcw.util.template($('#formatterStatus').html())">状态
                </div>
                <div data-field="itemName" uglcw-options="width:120, tooltip: true">费用项目</div>
                <div data-field="mergeBillNo"
                     uglcw-options="width:140,
                        template: uglcw.util.template($('#formatterMergeBillNo').html())">收款总单号</div>
                <div data-field="remarks" uglcw-options="width:140, tooltip: true">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:cancelPay();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>作废
    </a>
</script>
<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status==0){#
    正常
    #}else if(data.status==2){#
    作废
    #}else if(data.status==3){#
    被冲红单
    #}else if(data.status==4){#
    冲红单
    #}#
</script>
<script type="text/x-kendo-template" id="formatterEvent">
    #if(data.billNo=='合计:'){#
    #}else{#
    <a style="color: blue" href="javascript:showSourceBill('#=data.billId#','#=data.sourceBillNo#')">#=data.sourceBillNo#</a>
    #}#
</script>

<script type="text/x-kendo-template" id="formatterMergeBillNo">
    <a style="color: blue" href="javascript:shouRecMerge('#=data.mergeBillId#')">#=data.mergeBillNo#</a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        });
        uglcw.ui.loaded()
    })


    function cancelPay(id) {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection || selection.length < 1) {
            return uglcw.ui.warning('请选择作废单据');
        }
        var valid = true;
        $(selection).each(function (i, item) {
            if (item.status != 0) {
                uglcw.ui.warning('非正常单，无法作废！');
                valid = false;
                return false; //break;
            }
        })
        if (!valid) {
            return;
        }
        uglcw.ui.confirm('是否确认作废收款单？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: "${base}manager/cancelRec",
                type: "post",
                data: {
                    id: selection[0].id
                },
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败：' + json.msg);
                    }
                },
                error: function () {
                    uglcw.ui.error('操作失败');
                    uglcw.ui.loaded();
                }
            });
        });
    }

    function showDetail(row, outType) {
        uglcw.ui.openTab('收货款单信息', '${base}manager/showStkpay?dataTp=1&outType=' + outType + '&billId=' + row.id);
    }

    function shouRecMerge(mergeBillId) {
        uglcw.ui.openTab('合并收款总单', '${base}manager/showStkRecMerge?dataTp=1&billId=' + mergeBillId);
    }

    function showSourceBill(sourceBillId, sourceBillNo) {
        if (sourceBillNo.indexOf("CSH") != -1) {
        } else {
            uglcw.ui.openTab('单据信息' + sourceBillId, 'manager/showstkout?dataTp=1&billId=' + sourceBillId);
        }
    }
</script>
</body>
</html>
