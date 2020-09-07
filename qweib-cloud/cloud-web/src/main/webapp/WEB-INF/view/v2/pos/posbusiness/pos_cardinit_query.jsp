<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
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
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <div class="form-horizontal" id="export">
                        <div class="form-group" style="margin-bottom: 10px;">
                            <div class="col-xs-4">
                                <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                                <input uglcw-role="textbox" uglcw-model="billNo" placeholder="单号">
                            </div>

                            <div class="col-xs-4">
                                <select uglcw-role="combobox" uglcw-model="status">
                                    <option value="-1">全部</option>
                                    <option value="1">已审核</option>
                                    <option value="0">未审核</option>
                                    <option value="2">作废</option>
                                    <option value="3">被冲红单</option>
                                    <option value="4">冲红单</option>
                                </select>
                            </div>
                            <div class="col-xs-8">
                                <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                                <button id="reset" class="k-button" uglcw-role="button">重置</button>
                                <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>
                                &nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>
                                &nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom: 0px;">
                            <div class="col-xs-4">
                                <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                            </div>
                            <div class="col-xs-4">
                                <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                    toolbar: kendo.template($('#toolbar').html()),
                     dblclick:function(row){
                       uglcw.ui.openTab('会员余额初始化信息'+row.id, '${base}manager/pos/toPosCardInit?billId='+ row.id+$.map( function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    responsive:['.header',40],
                    id:'id',
                    url: 'manager/pos/queryPosCardInitPage',
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
                    }">

                        <div data-field="billNo" uglcw-options="width:170">单号</div>
                        <div data-field="billTimeStr" uglcw-options="width:160">单据日期</div>
                        <div data-field="sumCash" uglcw-options="width:120">累计充值金额</div>
                        <div data-field="sumFree" uglcw-options="width:120">累计赠送金额</div>

                        <div data-field="operator" uglcw-options="width:120">操作员</div>
                        <div data-field="remarks" uglcw-options="width:180">备注</div>
                        <div data-field="status"
                             uglcw-options="width:80, template: uglcw.util.template($('#formatterStatus').html())">状态
                        </div>

                        <div data-field="_operator"
                             uglcw-options="width:200, template: uglcw.util.template($('#formatterSt3').html())">操作
                        </div>
                        <div data-field="remarks" uglcw-options="width:120">备注</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:newBill();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>初始化开单
    </a>



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
    # if(data.status =='1' || data.status ==0){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#, 1)"><i class="k-icon"></i>作废</button>
    # } #

    # if(data.status =='0'){ #
    <button class="k-button k-success" onclick="auditBill1(#= data.id#, 1)"><i class="k-icon "></i>审核</button>
    # } #

</script>
<script id="formatterSt" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">项目名称</td>
            <td style="width: 5px;">项目金额</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].itemName #</td>
            <td>#= data[i].amt #</td>
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
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


    function auditBill1(id) {
        uglcw.ui.confirm('您确认要审核吗？', function () {
            $.ajax({
                url: "manager/pos/updateCardInitAudit",
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

    function cancelBill(id) {
        uglcw.ui.confirm('您确认要作废吗？', function () {
            $.ajax({
                url: "manager/pos/cancelCardInit",
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

    function showPayStat() {
        uglcw.ui.openTab('预收款统计', '${base}manager/toFinPreInStat?dataTp=1')

    }

    function newBill() {
        uglcw.ui.openTab('余额实初始化开单', '${base}manager/pos/toPosCardInit?billId=0')

    }
</script>
</body>
</html>
