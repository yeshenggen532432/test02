<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body>
<table id="datagrid" fit="true" singleSelect="false"
       title="" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
</table>
<div id="tb" style="padding:5px;height:auto">
    <div style="margin-bottom:5px">

        <c:if test="${psState eq 0}">
        <a class="easyui-linkbutton" plain="true"
           iconCls="icon-edit" href="javascript:sendToDriver(1);">发送到司机</a>
        </c:if>
        <c:if test="${psState ne 4 && psState ne 5 && psState ne 6}">
        <a class="easyui-linkbutton" plain="true"
           iconCls="icon-edit" href="javascript:sendFinish(4);">已收货</a>
        </c:if>
        <c:if test="${psState ne 4 && psState ne 5 && psState ne 6}">
        <a class="easyui-linkbutton" plain="true"
           iconCls="icon-edit" href="javascript:sendUnFinish(5);">配送终止</a>
        </c:if>

        <%--
        <a class="easyui-linkbutton" plain="true"
           iconCls="icon-redo" href="javascript:driverMap();">司机路线图</a>
          --%>

        <a class="easyui-linkbutton" plain="true"
           iconCls="icon-redo" onclick="queryorder()">刷新</a>
    </div>
    <div>

        司机名称:
        <tag:select name="driverId" id="driverId" tclass="pcl_sel"  headerKey=""
                    headerValue="" tableName="stk_driver" displayKey="id" displayValue="driver_name"/>
        配送车辆:
        <tag:select name="vehId" id="vehId" tclass="pcl_sel" headerKey=""
                    headerValue="" tableName="stk_vehicle" displayKey="id" displayValue="veh_no"/>

        配送单号: <input name="billNo" id="billNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
        发票单号: <input name="outNo" id="outNo" value="${outNo}" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
        <select name="outType" style="display: none" id="outType" >
        <option value="销售出库">销售出库</option>
         </select>
        客户名称: <input name="khNm" id="khNm" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
         <select name="customerType" id="customerType" style="width: 80px;display: none"></select>
         <input name="memberNm" id="memberNm" style="width:80px;height: 20px;display: none" onkeydown="toQuery(event);"/>

        <c:if test="${psState eq null}">
            单据状态: <select name="status" id="status">
            <option value="">全部</option>
            <option value="-2">暂存</option>
            <option value="1">配送完成</option>
            <option value="2">作废</option>
        </select>
        </c:if>

        配送状态: <select name="psState" id="psState" >
                    <option value="">全部</option>
                    <option value="0">待分配</option>
                    <option value="1">待接收</option>
                    <option value="2">已接收</option>
                    <option value="3">配送中</option>
                    <option value="4">已收货</option>
                    <option value="6">已生成发货单</option>
                    <option value="5">配送终止</option>
                 </select>
                <script type="text/javascript">
                    $("#psState").val(${psState});
                </script>
        <br/>
        配送日期: <input name="sdate" id="sdate" onClick="WdatePicker();" style="width: 80px;" value="${sdate}"
                     readonly="readonly"/>
        <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22"
             align="absmiddle" style="cursor: pointer;"/>
        -
        <input name="edate" id="edate" onClick="WdatePicker();" style="width: 80px;" value="${edate}"
               readonly="readonly"/>
        <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22"
             align="absmiddle" style="cursor: pointer;"/>

        <c:set var="datas" value="${fns:loadListByParam('stk_storage','id,stk_name,sale_car','')}"/>
        仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage" headerKey="-1" headerValue="--请选择--"
                       displayKey="id" displayValue="stk_name"/>
        <select id="saleCar" name="saleCar" onchange="queryorder()" style="display: none">
            <option value="">全部</option>
            <option value="0" selected>正常仓库</option>
            <option value="1">车销仓库</option>
            <option value="2">门店仓库</option>
        </select>
        商品名称: <input name="wareNm" id="wareNm" style="width:80px;height: 20px;" onkeydown="toQuery(event);"/>
        备注: <input name="remarks" id="remarks" style="width:80px;height: 20px;"/>
        所属二批: <input name="epCustomerName" id="epCustomerName" style="width:80px;height: 20px;"
                     onkeydown="toQuery(event);"/>
        显示商品信息:<input type="checkbox" id="showWareCheck" name="showWareCheck" onclick="queryorder()" value="1"/>
        <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
        <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:showOutList('');">发货明细查询</a>
    </div>
</div>

<script type="text/javascript">
    $("#status").val("${status}");
    $("#saleCar").val("0");
    initGrid();
    function initGrid() {

        var cols = new Array();
        var col = {
            field: 'ck',
            checkbox: true
        };
        cols.push(col);
        var col = {
            field: 'id',
            title: 'id',
            width: 50,
            align: 'center',
            hidden: 'true'

        };
        cols.push(col);
        var col = {
            field: 'driverName',
            title: '司机',
            width: 80,
            align:'center'

        };
        cols.push(col);

        var col = {
            field: 'vehNo',
            title: '车辆',
            width: 80,
            align:'center'

        };
        cols.push(col);

        var col = {
            field: 'billNo',
            title: '配送单号',
            width: 135,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'outNo',
            title: '发票单号',
            width: 135,
            align: 'center'

        };
        cols.push(col);
        var col = {
            field: 'khNm',
            title: '客户名称',
            width: 100,
            align: 'center'

        };
        cols.push(col);


        var col = {
            field: 'outType',
            title: '销售类型',
            width: 100,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'status',
            title: '单据状态',
            width: 80,
            align: 'center',
            formatter:formatterStatus

        };
        cols.push(col);

        var col = {
            field: 'psState',
            title: '配送状态',
            width: 80,
            align: 'center',
            formatter:formatterPsState

        };
        cols.push(col);

        var col = {
            field: 'outDate',
            title: '配送日期',
            width: 80,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'count',
            title: '商品信息',
            width: 500,
            align: 'center',
            formatter: formatterSt


        };
        cols.push(col);

        var col = {
            field: 'ddNum',
            title: '配送数量',
            width: 60,
            align: 'center',
            formatter: amtformatter

        };
        cols.push(col);

        var col = {
            field: 'disAmt1',
            title: '配送金额',
            width: 60,
            align: 'center',
            formatter: amtformatter

        };
        cols.push(col);
        var col = {
            field: 'tel',
            title: '电话',
            width: 100,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'address',
            title: '地址',
            width: 150,
            align: 'center'

        };
        cols.push(col);
        var col = {
            field: 'operator',
            title: '创建人',
            width: 80,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'remarks',
            title: '备注',
            width: 200,
            align: 'center'

        };
        cols.push(col);
        //
        // var col = {
        //     field: 'shr',
        //     title: '收货人',
        //     width: 80,
        //     align: 'center'
        //
        // };
        // cols.push(col);



        var col = {
            field: 'epCustomerName',
            title: '所属二批',
            width: 100,
            align: 'center'

        };
        cols.push(col);

        $('#datagrid').datagrid({
                url: "manager/stkDelivery/page",
                queryParams: {
                    jz: "1",
                    outNo: $("#outNo").val(),
                    billNo: $("#billNo").val(),
                    khNm: $("#khNm").val(),
                    memberNm: $("#memberNm").val(),
                    status: $("#status").val(),
                    sdate: $("#sdate").val(),
                    edate: $("#edate").val(),
                    psState:$("#psState").val(),
                    outType: $("#outType").val(),
                    customerType: $("#customerType").val(),
                    epCustomerName: $("#epCustomerName").val(),
                    wareNm: $("#wareNm").val(),
                    stkId: $("#stkId").val(),
                    remarks: $("#remarks").val(),
                    saleCar: $("#saleCar").val(),
                    driverId: $("#driverId").val(),
                    vehId: $("#vehId").val()
                },
                columns: [
                    cols
                ],
                onLoadSuccess: function (data) {
                    var rows = $('#datagrid').datagrid("getRows");
                    if (rows.length > 0) {
                        // for (var i = 0; i < rows.length; i++) {
                        //     var id = rows[i].id;
                        //     if (id) {
                        //         $.ajax({
                        //             url: "manager/sysPrintRecord/queryPrintCount",
                        //             data: {fdSourceId: id, fdModel: 'com.cnlife.stk.model.StkOutsub'},
                        //             type: "post",
                        //             async: true,
                        //             success: function (json) {
                        //                 document.getElementById("print" + json.id).value = "打印(" + json.count + ")";
                        //             }
                        //         });
                        //     }
                        // }
                    }
                }
            }
        );

        if ($('#showWareCheck').is(':checked')) {
            $('#datagrid').datagrid('showColumn', 'count');
        } else {
            $('#datagrid').datagrid('hideColumn', 'count');
        }
    }

    function queryorder() {
        $("#datagrid").datagrid('load', {
            url: "manager/stkDelivery/page",
            jz: "1",
            outNo: $("#outNo").val(),
            billNo: $("#billNo").val(),
            khNm: $("#khNm").val(),
            memberNm: $("#memberNm").val(),
            status: $("#status").val(),
            sdate: $("#sdate").val(),
            edate: $("#edate").val(),
            wareNm: $("#wareNm").val(),
            psState:$("#psState").val(),
            outType: $("#outType").val(),
            stkId: $("#stkId").val(),
            customerType: $("#customerType").val(),
            epCustomerName: $("#epCustomerName").val(),
            remarks: $("#remarks").val(),
            saleCar: $("#saleCar").val(),
            driverId: $("#driverId").val(),
            vehId: $("#vehId").val()
        });
        if ($('#showWareCheck').is(':checked')) {
            $('#datagrid').datagrid('showColumn', 'count');
        } else {
            $('#datagrid').datagrid('hideColumn', 'count');
        }
    }

    function formatterSt3(val, row) {
        if (row.outType == "" || row.outType == null || row.outType == undefined) {
            return "";
        }
        //var ret = "<input style='width:60px;height:27px' id='print" + row.id + "' type='button' value='打印' onclick='printBill(" + row.id + ")'/>";
        var ret = "";
        if (row.billStatus == '暂存') {
            ret += "<br/><input style='width:60px;height:27px' type='button' value='审批' onclick='audit(\"" + row.id + "\",\"" + row.billStatus + "\",\"" + row.billNo + "\")'/>";
        }
        if (row.billStatus == '已发货') {
            ret += "<br/><input style='width:60px;height:27px' type='button' value='发货明细' onclick='audit(\"" + row.id + "\",\"" + row.billStatus + "\",\"" + row.billNo + "\")'/>";
        }
        return ret;
    }

    function formatterPsState(val,row){
        ///配送状态 0:待分配 1:待接收 2:配送中 3:配送完成 4:配送终止
        if(val==0||val==null){
            if(row.driverName=="合计："){
                return "";
            }
            return "待分配";
        }else if(val==1){
            return "待接收";
        }else if(val==2){
            return "已接收";
        }else if(val==3){
            return "配送中";
        }else if(val==4){
            return "已收货";
        }else if(val==5){
            return "配送终止";
        }else if(val==6){
            return "已生成发货单";
        }
    }

    function formatterStatus(val,row){
        if(val==-2){
            return "暂存";
        }else if(val==1){
            return "配送完成";
        }else if(val==0){
            return "未发货";
        }else if(val==2){
            return "已作废";
        }
    }



    function printBill(billId) {
        if (billId == "" || billId == 0) {
            return "";
        }
        parent.parent.closeWin('配送信息' + billId);
        parent.parent.add('配送信息' + billId, 'manager/showstkoutprint?fromFlag=1&billId=' + billId);
    }



    //回车查询
    function toQuery(e) {
        var key = window.event ? e.keyCode : e.which;
        if (key == 13) {
            queryorder();
        }
    }

    function formatterSt(v, row) {
        if (row.list == null || row.list == undefined) {
            return "";
        }
        var hl = '<table>';
        if (row.list.length > 0) {
            hl += '<tr>';
            hl += '<td width="120px;"><b>商品名称</b></td>';
            hl += '<td width="80px;"><b>销售类型</b></td>';
            hl += '<td width="60px;"><b>单位</font></b></td>';
            hl += '<td width="80px;"><b>规格</font></b></td>';
            hl += '<td width="60px;"><b>数量</font></b></td>';
            hl += '<td width="60px;"><b>单价</font></b></td>';
            hl += '<td width="60px;"><b>金额</font></b></td>';
            hl += '<td width="60px;"><b>已送数量</font></b></td>';
            hl += '<td width="60px;"><b>未配送数量</font></b></td>';
            hl += '</tr>';
        }
        for (var i = 0; i < row.list.length; i++) {
            hl += '<tr>';
            hl += '<td>' + row.list[i].wareNm + '</td>';
            hl += '<td>' + row.list[i].xsTp + '</td>';
            hl += '<td>' + row.list[i].unitName + '</td>';
            hl += '<td>' + row.list[i].wareGg + '</td>';
            hl += '<td>' + row.list[i].qty + '</td>';
            hl += '<td>' + row.list[i].price + '</td>';
            hl += '<td>' + numeral(row.list[i].amt).format("0,0.00") + '</td>';
            hl += '<td>' + row.list[i].outQty + '</td>';
            hl += '<td>' + row.list[i].outQty1 + '</td>';
            hl += '</tr>';
        }
        hl += '</table>';
        return hl;
    }

    function amtformatter(v, row) {
        if (v == "") {
            return "";
        }
        if (v == "0E-7") {
            return "0.00";
        }
        if (row != null) {
            return numeral(v).format("0,0.00");
        }
    }

    function formatterSt2(val, row) {
        if (row.list.length > 0) {
            if (val == '未审核') {
                return "<input style='width:60px;height:27px' type='button' value='未审核' onclick='updateOrderSh(this, " + row.id + ")'/>";
            } else {
                return val;
            }
        }
    }


    function onDblClickRow(rowIndex, rowData) {
        parent.parent.closeWin('销售配送信息' + rowData.id);
        parent.parent.add('销售配送信息' + rowData.id, 'manager/stkDelivery/show?billId=' + rowData.id);
    }



    function sendToDriver(){
        var ids = "";
        var rows = $("#datagrid").datagrid("getSelections");
        for (var i = 0; i < rows.length; i++) {
           if(ids!=""){
               ids = ids +",";
           }
            if(rows[i].psState!=0){
                 alert("请选择配送状态[待分配]的进行发送！");
                 return ;
            }
            ids = ids + rows[i].id;
        }
        if (ids.length == 0) {
            alert("请选择要发送的记录");
            return;
        }
        $.messager.confirm('确认', '是否确定发送到司机?', function (r) {
            if (r) {
                var path = "manager/stkDelivery/sendToDriver";
                $.ajax({
                    url: path,
                    type: "POST",
                    data: {"ids": ids,"psState":1},
                    dataType: 'json',
                    async: false,
                    success: function (json) {
                        if (json.state) {
                            queryorder();
                        } else {
                            $.messager.alert('消息', '发送失败', 'info');
                        }
                    }
                });
            }
        });
    }

    function sendUnFinish(){
        var ids = "";
        var rows = $("#datagrid").datagrid("getSelections");
        for (var i = 0; i < rows.length; i++) {
            if(ids!=""){
                ids = ids +",";
            }
            if(rows[i].status==2){
                alert(rows[i].billNo+"该单据已作废，不能操作！");
                return ;
            }
            if(rows[i].psState==5){
                alert("请选择配送状态为非[配送中止]的进行操作！");
                return ;
            }
            ids = ids + rows[i].id;
        }
        if (ids.length == 0) {
            alert("请选择要操作的记录");
            return;
        }

        $.messager.confirm('确认', '是否确定该操作?', function (r) {
            if (r) {
                var path = "manager/stkDelivery/sendFinish";
                $.ajax({
                    url: path,
                    type: "POST",
                    data: {"ids": ids,"psState":5},
                    dataType: 'json',
                    async: false,
                    success: function (json) {
                        if (json.state) {
                            queryorder();
                        } else {
                            $.messager.alert('消息', '操作失败', 'info');
                        }
                    }
                });
            }
        });
    }

    function sendFinish(){
        var ids = "";
        var rows = $("#datagrid").datagrid("getSelections");
        for (var i = 0; i < rows.length; i++) {
            if(ids!=""){
                ids = ids +",";
            }
            if(rows[i].status==2){
                alert(rows[i].billNo+"该单据作废，不能操作！");
                return ;
            }
            if(rows[i].psState==4){
                alert("请选择配送状态为非[配送完成]的进行操作！");
                return ;
            }
            ids = ids + rows[i].id;
        }
        if (ids.length == 0) {
            alert("请选择要操作的记录");
            return;
        }
        $.messager.confirm('确认', '是否确定该操作?', function (r) {
            if (r) {
                var path = "manager/stkDelivery/sendFinish";
                $.ajax({
                    url: path,
                    type: "POST",
                    data: {"ids": ids,"psState":4},
                    dataType: 'json',
                    async: false,
                    success: function (json) {
                        if (json.state) {
                            queryorder();
                        } else {
                            $.messager.alert('消息', '操作失败', 'info');
                        }
                    }
                });
            }
        });
    }

    function showOutList(deliveryNo)
    {
        parent.parent.closeWin('发货明细查询');
        parent.parent.add('发货明细查询','manager/outdetailquery?deliveryNo='+deliveryNo);
    }


    function driverMap(){
        // var driverId = $("#driverId").val();
        // var driverName = $("#driverId").find("option:selected").text();
        // if(driverId==""){
        //     $.messager.alert('消息', '请选择司机', 'info');
        //     return;
        // }
        parent.parent.closeWin('司机路线图');
        parent.parent.add('司机路线图','manager/stkDelivery/toDriverMap?psState=${psState}');
    }


    function audit(billId, status, billNo) {
        if (status != '暂存') {
            $.messager.alert('消息', '只有暂存的单据才需要审批!', 'info');
            return;
        }
        $.messager.confirm('确认', '是否确定审核' + billNo + '?', function (r) {
            if (r) {
                var path = "manager/stkDelivery/audit";
                $.ajax({
                    url: path,
                    type: "POST",
                    data: {"token": "", "billId": billId},
                    dataType: 'json',
                    async: false,
                    success: function (json) {
                        if (json.state) {
                            queryorder();
                        } else {
                            $.messager.alert('消息', '审核失败', 'info');
                        }
                    }
                });
            }
        });
    }
    function loadCustomerType() {
        $.ajax({
            url: "manager/queryarealist1",
            type: "post",
            success: function (data) {
                if (data) {
                    var list = data.list1;
                    var img = "";
                    img += '<option value="">--请选择--</option>';
                    for (var i = 0; i < list.length; i++) {
                        if (list[i].qdtpNm != '') {
                            img += '<option value="' + list[i].qdtpNm + '">' + list[i].qdtpNm + '</option>';
                        }
                    }
                    $("#customerType").html(img);
                }
            }
        });
    }
    loadCustomerType();
</script>
</body>
</html>
