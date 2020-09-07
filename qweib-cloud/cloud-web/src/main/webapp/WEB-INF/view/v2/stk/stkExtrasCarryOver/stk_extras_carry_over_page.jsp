<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>杂费结转单列表</title>
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
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="单据号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="采购厂家">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" uglcw-options="value: ''" placeholder="单据状态">
                        <option value="1">已审核</option>
                        <option value="-2" >暂存</option>
                        <option value="2">作废</option>
                        <%--<option value="3">已支付</option>--%>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>
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
                    id:'id',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.form-horizontal',
                    dblclick: function(row){
                        uglcw.ui.openTab('杂费单'+row.id,'${base}manager/stkExtrasCarryOver/show?billId='+row.id);
                    },
                    url: '${base}manager/stkExtrasCarryOver/pages',
                    criteria: '.form-horizontal',
                    }">
                <div data-field="billNo" uglcw-options="width:160,tooltip: true">单号</div>
                <div data-field="sourceBillNo" uglcw-options="width:160,tooltip: true">单号</div>
                <div data-field="proName" uglcw-options="width:120,tooltip: true">采购厂家</div>
                <div data-field="billDateStr" uglcw-options="width:160">结算日期</div>
                <div data-field="createName" uglcw-options="width:100">创建人</div>
                <div data-field="feeAmt" uglcw-options="width:100">杂费金额</div>
                <div data-field="billStatus"
                     uglcw-options="width:80">状态
                </div>
                <div data-field="_operator"
                     uglcw-options="width:200, template: uglcw.util.template($('#formatterOper').html())">操作
                </div>
                <div data-field="count"
                     uglcw-options="width:250, hidden: true,template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }">商品信息
                </div>
                <div data-field="remarks" uglcw-options="width:130,tooltip: true">备注</div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status==-2){#
    暂存
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
<script type="text/x-kendo-template" id="formatterOper">

    #if(data.status==1){#
    <%--<a role="button" href="javascript:showCheck(#=data.sourceBillId#,'#= data.inType#',#=data.id#);" class="k-button k-button-icontext">--%>
        <%--<span class="k-icon k-i-plus-outline"></span>收货--%>
    <%--</a>--%>
    #}#

    # if(data.status != 2){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#)">作废</button>
    # } #

    # if(data.status =='-2'){ #
    <button class="k-button k-success" onclick="auditBill(#= data.id#)">审核</button>
    # } #

</script>
<script id="product-list" type="text/x-uglcw-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;text-align: center">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 60px;">数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
            <td style="width: 60px;">已收数量</td>
            <td style="width: 60px;">未收数量</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].qty #</td>
            <td>#= data[i].price #</td>
            <td>#= data[i].amt #</td>
            <td>#= data[i].inQty #</td>
            <td>#= data[i].inQty1 #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('count')
            } else {
                grid.hideColumn('count');
            }
        })
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
                url: "manager/stkExtrasCarryOver/cancel",
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
            uglcw.ui.confirm('您确认要审核吗？', function () {
                $.ajax({
                    url: "manager/stkExtrasCarryOver/audit",
                    type: "post",
                    data: {
                        billId: id

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
    }

    function showCheck(sourceBillId, title,id) {
        uglcw.ui.openTab('采购发票收货确认' + id, '${base}manager/showstkincheck?dataTp=1&billId=' + sourceBillId+"&secoId="+id);
    }

</script>
</body>
</html>
