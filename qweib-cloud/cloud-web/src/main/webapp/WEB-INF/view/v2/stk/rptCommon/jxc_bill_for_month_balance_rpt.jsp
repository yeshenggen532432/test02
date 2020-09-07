<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>月结未处理完单据</title>
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
            <ul class="uglcw-query">
                <li>
                    <input  type="hidden" uglcw-model="billType" uglcw-role="textbox" readonly value="${billType}">
                    <input  type="hidden" uglcw-model="status" uglcw-role="textbox" readonly value="${status}">
                    <input uglcw-model="sdate" uglcw-role="textbox" readonly value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="textbox" readonly value="${edate}">
                </li>
                <li>
                    <select  uglcw-model="billName" id="billName" uglcw-role="combobox"  placeholder="业务类型" onchange="query()">
                        <option value=""></option>
                        <option value="采购入库">采购入库</option>
                        <option value="采购退货">采购退货</option>
                        <option value="其它入库">其它入库</option>
                        <option value="销售退货">销售退货</option>
                        <option value="销售出库">销售出库</option>
                        <option value="配货单">配货单</option>
                        <option value="其它出库">其它出库</option>
                        <option value="报损出库">报损出库</option>
                        <%--<option value="领用出库">领用出库</option>--%>
                        <option value="借出出库">借出出库</option>
                        <option value="移库管理">移库管理</option>
                        <option value="组装入库">组装入库</option>
                        <option value="拆卸出库">拆卸出库</option>
                        <option value="生产入库">生产入库</option>
                        <option value="领料出库">领料出库</option>
                        <option value="领料回库">领料回库</option>
                        <option value="盘点单">盘点单</option>
                    </select>
                </li>
                <li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="cancel" class="k-button" uglcw-role="button"  href="javascript:batchCancel();">批量作废</button>
                </li>
                <li>
                    <button id="onekeycancel" class="k-button" uglcw-role="button"  href="javascript:oneKeyCancel();">一键全部作废</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    pageable: true,
                    rowNumber: true,
                    checkbox: true,
                    url: '${base}manager/jxcBillForMonthBalanceRpt',
                    criteria: '.uglcw-query',
                    dblclick: function(rowData){
                         var billName='';
                         var path='';
                            if(rowData.bill_name == '销售出库')
                            {
                            billName = '销售出库';

                            path ='showstkout?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '配货单')
                            {
                            billName = '配货单';
                            path ='stkDelivery/show?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '其它出库')
                            {
                            billName = '其它出库';

                            path ='showstkout?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '报损出库')
                            {
                            billName = '报损出库';
                            path ='showstkout?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '领用出库')
                            {
                            billName = '领用出库';
                            path ='showstkout?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '借出出库')
                            {
                            billName = '借出出库';
                            path ='showstkout?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '生产入库')
                            {
                            billName = '生产入库';
                            path ='stkProduce/show?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '其他入库')
                            {
                            billName = '其他入库';
                            path ='showstkin?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '采购入库')
                            {
                            billName = '采购入库';
                            path ='showstkin?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '销售退货')
                            {
                            billName = '销售退货';
                            path ='showstkin?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '采购退货')
                            {
                            billName = '采购退货';
                            path ='showstkin?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '移库管理')
                            {
                            billName = '移库管理';
                            path ='stkMove/show?billId='+rowData.bill_id;
                            }

                            if(rowData.bill_name == '组装入库')
                            {
                            billName = '组装入库';
                            path ='stkZzcx/show?billId='+rowData.bill_id;
                            }

                            if(rowData.bill_name == '拆卸出库')
                            {
                            billName = '拆卸出库';
                            path ='stkZzcx/show?billId='+rowData.bill_id;
                            }

                            if(rowData.bill_name == '领料回库')
                            {
                            billName = '领料回库';
                            path ='showStkLlhkIn?billId='+rowData.bill_id;
                            }

                            if(rowData.bill_name == '领料出库')
                            {
                            billName = '领料出库';
                            path ='stkPickup/show?billId='+rowData.bill_id;
                            }

                            if(rowData.bill_name == '销售返利')
                            {
                            billName = '销售返利';
                            path ='stkRebateOut/show?billId='+rowData.bill_id;
                            }

                            if(rowData.bill_name == '采购返利')
                            {
                            billName = '采购返利';
                            path ='stkRebateIn/show?billId='+rowData.bill_id;
                            }
                            if(rowData.bill_name == '盘点单')
                            {
                            billName = '盘点单';
                            path ='stkCheck/showcheck?billId='+rowData.bill_id;
                            }
                            if(path != '')
                            {
                               uglcw.ui.openTab(billName + rowData.bill_id, '${base}manager/'+path);
                            }
                    },
                    loadFilter: {
                      data: function (response) {
                        if(response.total == 0){
                        	return [];
                        }
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                     }
                    ">
                <div data-field="bill_id" uglcw-options="hidden:true">id</div>
                <div data-field="bill_no" uglcw-options="width:'auto'">单据号</div>
                <div data-field="bill_time" uglcw-options="width:'auto'">单据日期</div>
                <div data-field="bill_name" uglcw-options="width:'auto'">业务名称</div>
                <div data-field="status" uglcw-options="width:80,template: uglcw.util.template($('#formatterStatus').html())">状态</div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/x-kendo-template" id="formatterStatus">
    #= getStatus(data)#
</script>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });
        uglcw.ui.get('#cancel').on('click', function () {
            batchCancel();
        });

        uglcw.ui.get('#onekeycancel').on('click', function () {
            oneKeyCancel();
        });

        uglcw.ui.loaded();
    });

    function query(){
        uglcw.ui.get('#grid').reload();
    }

    function getStatus(rowData)
    {
        var html ="";
        var val = rowData.status;
        if(rowData.bill_name == "销售出库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未发货";
            }
        }
        if(rowData.bill_name == "配货单")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未发货";
            }
        }
        if(rowData.bill_name == "其它出库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未发货";
            }
        }
        if(rowData.bill_name == "其它入库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未收货";
            }
        }
        if(rowData.bill_name == "报损出库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未发货";
            }
        }
        if(rowData.bill_name == "领用出库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未发货";
            }
        }
        if(rowData.bill_name == "借出出库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未发货";
            }
        }
        if(rowData.bill_name == "生产入库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未入库";
            }
        }
        if(rowData.bill_name == "其他入库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未收货";
            }
        }
        if(rowData.bill_name == "采购入库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未收货";
            }
        }
        if(rowData.bill_name == "销售退货")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未收货";
            }
        }
        if(rowData.bill_name == "采购退货")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未收货";
            }
        }
        if(rowData.bill_name == "移库管理")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="暂存";
            }
        }

        if(rowData.bill_name == "组装入库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未收货";
            }
        }

        if(rowData.bill_name == "拆卸出库")
        {

            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未发货";
            }
        }

        if(rowData.bill_name == "领料回库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未收货";
            }
        }

        if(rowData.bill_name == "领料出库")
        {
            if(val==-2){
                html="暂存";
            }else if(val==0){
                html="未发货";
            }
        }

        if(rowData.bill_name == "销售返利")
        {
            if(val==-2){
                html="暂存";
            }
        }

        if(rowData.bill_name == "采购返利")
        {
            if(val==-2){
                html="暂存";
            }
        }
        if(rowData.bill_name == "盘点单")
        {
            if(val==-2){
                html="暂存";
            }
        }
        return html+rowData.status;
    }


    /**
     * 一键作废
     */
    function oneKeyCancel(){
        var data={
            sdate:'${sdate}',
            edate:'${edate}',
            billType:'${billType}',
            status:'${status}'
        }
        if(window.confirm("是否全部作废!")) {
            $.ajax({
                url: "<%=basePath%>/manager/stkMonthBillCancel/cancelBills",
                type: "POST",
                data: data,
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.info("一键作废成功!");
                        query();
                    }
                }
            });
        }
    }


    function batchCancel() {
        var ids = [];
        var rows = uglcw.ui.get('#grid').selectedRow();
        var bizType="";
        // for (var i = 0; i < rows.length; i++) {
        //     ids.push(rows[i].bill_id);
        //     if(bizType!=""&&bizType!=rows[i].bill_name){
        //         //alert(bizType+""+rows[i].bill_name);
        //         uglcw.ui.warning('请选择相同的业务类型作废!')
        //         return;
        //     }
        //     if(i==0){
        //         bizType = rows[i].bill_name;
        //     }
        // }

        var len = rows.length;
        if(len==0){
            uglcw.ui.warning('请选择单据！');
            return;
        }
        if(window.confirm("是否确定作废!")){
            $.ajaxSettings.async = false;
            for (var i = 0; i < rows.length; i++) {
                var billId = rows[i].bill_id;
                var billName="";
                var path = "";
                var  bizType = rows[i].bill_name;
                if(bizType == "销售出库")
                {
                    billName = "销售出库";
                    path ="cancelStkOut";
                }
                if(bizType == "配货单")
                {
                    billName = "配货单";
                    path ="stkDelivery/cancel";
                }
                if(bizType == "其它出库")
                {
                    billName = "其它出库";
                    path ="cancelStkOut";
                }
                if(bizType == "报损出库")
                {
                    billName = "报损出库";
                    path ="cancelStkOut";
                }
                if(bizType == "领用出库")
                {
                    billName = "领用出库";
                    path ="cancelStkOut";
                }
                if(bizType == "借出出库")
                {
                    billName = "借出出库";
                    path ="cancelStkOut";
                }
                if(bizType == "生产入库")
                {
                    billName = "生产入库";
                    path ="stkProduce/cancel";
                }
                if(bizType == "其它入库")
                {
                    billName = "其它入库";
                    path ="cancelProc";
                }
                if(bizType == "采购入库")
                {
                    billName = "采购入库";
                    path ="cancelProc";
                }
                if(bizType == "销售退货")
                {
                    billName = "销售退货";
                    path ="cancelProc";
                }
                if(bizType == "采购退货")
                {
                    billName = "采购退货";
                    path ="cancelProc";
                }
                if(bizType == "移库管理")
                {
                    billName = "移库管理";
                    path ="stkMove/cancel";
                }

                if(bizType == "组装入库")
                {
                    billName = "组装入库";
                    path ="stkZzcx/cancel";
                }

                if(bizType == "拆卸出库")
                {
                    billName = "拆卸出库";
                    path ="stkZzcx/cancel";
                }

                if(bizType == "领料回库")
                {
                    billName = "领料回库";
                    path ="cancelStkLlhkInByBillId";
                }
                if(bizType == "领料出库")
                {
                    billName = "领料出库";
                    path ="stkPickup/cancel?token=''";
                }

                if(bizType == "销售返利")
                {
                    billName = "销售返利";
                    path ="stkRebateOut/cancel";
                }

                if(bizType == "采购返利")
                {
                    billName = "采购返利";
                    path ="stkRebateIn/cancel";
                }
                if(bizType == "盘点单")
                {
                    billName = "盘点单";
                    path ="cancelCheck";
                }
                $.ajax({
                    url: "<%=basePath%>/manager/"+path,
                    type: "POST",
                    data : {"billId":billId},
                    dataType: 'json',
                    async : false,
                    success: function (json) {
                        if(json.state){

                        }
                    }
                });
            }
            query();
        }

    }
</script>
</body>
</html>
