<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .row-color-blue{
            color:blue;text-decoration:line-through;font-weight:bold;
        }
        .row-color-pink{
            color:#FF00FF;font-weight:bold;
        }
        .row-color-red{
            color:red;font-weight:bold;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <div class="form-horizontal" >
                        <div class="form-group" style="margin-bottom: 0px;">
                            <div class="col-xs-6">
                                <input type="hidden" uglcw-model="billId" value="${billId}" uglcw-role="textbox">
                                <input type="hidden" uglcw-model="remarks" value="${remarks}" uglcw-role="textbox">
                                &nbsp;&nbsp;<span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>&nbsp;<span
                                    style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>&nbsp;<span
                                    style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                         loadFilter: {
                         data: function (response) {
                         response.rows.splice( response.rows.length - 1, 1);
                         return response.rows || []
                       },
                       aggregates: function (response) {
                         var aggregate = {};
                       if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                       }
                        return aggregate;
                       }
                     },
                    responsive:['.header',40],
                    id:'id',
                    url: 'manager/queryAccIoPage',
                    criteria: '.form-horizontal',
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
                    },
                     aggregate:[
                     {field: 'inAmt', aggregate: 'SUM'},
                     {field: 'outAmt', aggregate: 'SUM'}
                    ],

                    }">

                        <div data-field="remarks" uglcw-options="width:100">类型</div>
                        <div data-field="billNo" uglcw-options="width:160">单号</div>
                        <div data-field="accTimeStr"
                             uglcw-options="width:140 ,footerTemplate: '合计'">日期</div>
                        <div data-field="inAmt"
                             uglcw-options="width:100,footerTemplate: '#= uglcw.util.toString(data.inAmt,\'n2\')#'">收入金额</div>
                        <div data-field="outAmt"
                             uglcw-options="width:100,footerTemplate: '#= uglcw.util.toString(data.outAmt,\'n2\')#'">支出金额</div>
                        <div data-field="operator" uglcw-options="width:120">操作员</div>
                        <div data-field="status"
                             uglcw-options="width:100, template: uglcw.util.template($('#formatterStr').html())">状态</div>
                        <%--<div data-field="_operator"--%>
                             <%--uglcw-options="width:100, template: uglcw.util.template($('#formatterSt3').html())">操作</div>--%>
                        <div data-field="remarks1" uglcw-options="width:120,tooltip: true">备注</div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="formatterSt3">
    # if(data.status ==0){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#,'#=data.remarks#')"><i class="k-icon "></i>作废</button>
    # } #

</script>
<script type="text/x-kendo-template" id="formatterStr">
    #if(data.status==0){#
    正常
    #}else if(data.status==1){#
    作废
    #}else if(data.status==3){#
    被冲红单
    #}else if(data.status==4){#
    冲红单
    #}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.loaded()
    })

    function cancelBill(id,type) {

        var url = "manager/deleteFinBackIn";
        if(type=="还款支出"){
            url = "manager/deleteFinBackOut";
        }else if(type=="初始还款支出"){
            url = "manager/finInitQtJrMain/deleteFinInitBackOut";
        }else if(type=="初始借款收回"){
            url = "manager/finInitQtWlMain/deleteFinInitBackIn";
        }

        uglcw.ui.confirm('您确认要作废吗？', function () {
            $.ajax({
                url:url,
                type: "post",
                data: "ioId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败'+ json.msg);
                        return;
                    }
                }
            });
        });
    }

</script>
</body>
</html>
