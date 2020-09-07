<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
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
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="单号">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="单据状态">
                        <option value="-1"></option>
                        <option value="1">已审核</option>
                        <option value="0">未审核</option>
                    </select>
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
                    toolbar: kendo.template($('#toolbar').html()),
                    dblclick:function(row){
                       uglcw.ui.openTab('货币资金初始化信息'+row.id, '${base}manager/finInitMoney/edit?id='+row.id+ $.map( function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                     responsive:['.header',40],
                    id:'id',
                    url: 'manager/finInitMoney/page',
                    criteria: '.form-horizontal',
                    pageable: true

                    }">

                <div data-field="billNo" uglcw-options="{width:200}">单号</div>
                <div data-field="billDate"
                     uglcw-options="width:160">单据日期
                </div>
                <div data-field="amt" uglcw-options="{width:120}">初始化金额</div>
                <div data-field="operator" uglcw-options="{width:120}">经办人</div>
                <div data-field="status"
                     uglcw-options="width:120, template: uglcw.util.template($('#formatterStatus').html())">状态
                </div>
                <div data-field="remarks" uglcw-options="{width:160,tooltip: true }">备注</div>
                <div data-field="_operator"
                     uglcw-options="width:140,template: uglcw.util.template($('#formatterSt3').html())">操作
                </div>

            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="formatterSt3">
    # if(data.status =='0'){ #
    <button class="k-button k-success" onclick="auditBill(#= data.id#)"><i class="k-icon"></i>审核</button>
    # } #

</script>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:newBill();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>资金初始化
    </a>
</script>

<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status==0){#
    未审批
    #} else if(data.status==1){#
    已审批
    #} else if(data.status==2){#
    作废
    #} else if(data.status==3){#
    被冲红单
    #} else if(data.status==4){#
    冲红单
    #}#
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


    function auditBill(id) {
        uglcw.ui.confirm('您确认要审核吗？', function () {
            $.ajax({
                url: "manager/finInitMoney/audit",
                type: "post",
                data: "billId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error("操作失败" + json.msg);
                        return;
                    }
                }
            });
        });
    }

    function newBill() {
        uglcw.ui.openTab('货币资金初始化', '${base}/manager/finInitMoney/add');
    }
</script>
</body>
</html>
