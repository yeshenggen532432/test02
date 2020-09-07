<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>驰用T3</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body>

<div id="easyTabs" class="easyui-tabs" style="width:auto;height: 360px">
    <div title="配送单据列表" >
        <table id="datagrid" fit="true" singleSelect="true"
               title="" border="false"
               rownumbers="true" fitColumns="false" pagination="true"
               pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
        </table>
    </div>
    <div title="配送商品列表">
        <c:set var="totalQty" value="0"/>
        <table style="font-size: 12px;">
            <tr><td>序号</td><td>商品名称</td><td>单位</td><td>数量</td></tr>
            <c:forEach items="${subList}" var="ware" varStatus="s">
                <tr><td>${s.index+1}</td><td> ${ware.wareNm}</td><td>${ware.unitName}</td><td>${ware.outQty}</td></tr>
                <c:set var="totalQty" value="${totalQty+ware.outQty}"/>
            </c:forEach>
            <tr><td></td><td></td><td></td><td>${totalQty}</td></tr>
        </table>
    </div>
</div>
<div id="tb" style="padding:5px;height:auto">
    <div>

        <input name="driverId" id="driverId"  type="hidden" value="${driverId}"/>
        <select name="outType" style="display: none" id="outType" >
            <option value=""></option>
        </select>
        <input name="status" id="status" type="hidden" value="${status}"/>
        <input name="psState" id="psState" type="hidden" value="${psState}" />
        <input name="sdate" id="sdate" type="hidden" onClick="WdatePicker();" style="width: 80px;" value="${sdate}"
               readonly="readonly"/>
        <input name="edate" id="edate" type="hidden" onClick="WdatePicker();" style="width: 80px;" value="${edate}"
               readonly="readonly"/>
        <c:if test="${psState eq 0 and status eq -2}">
            <a class="easyui-linkbutton" plain="true"
               iconCls="icon-edit" href="javascript:sendToDriver(1);">发送到司机</a>
        </c:if>
        显示商品信息:<input type="checkbox" id="showWareCheck" name="showWareCheck" onclick="queryorder()" value="1"/>
    </div>
</div>
<script type="text/javascript">
    initGrid();
    function initGrid() {

        var cols = new Array();
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
            field: 'khNm',
            title: '客户名称',
            width: 100,
            align: 'center'

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


        $('#datagrid').datagrid({
                url: "${base}/manager/stkDelivery/dialogPage",
                queryParams: {
                    jz: "1",
                    status:'${status}',
                    sdate:$("#sdate").val(),
                    edate:$("#edate").val(),
                    psState:$("#psState").val(),
                    outType: $("#outType").val(),
                    driverId: $("#driverId").val()
                },
                columns: [
                    cols
                ],
                onLoadSuccess: function (data) {
                    var rows = $('#datagrid').datagrid("getRows");
                    if (rows.length > 0) {

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
            status:$("#status").val(),
            sdate:$("#sdate").val(),
            edate:$("#edate").val(),
            psState:$("#psState").val(),
            outType: $("#outType").val(),
            driverId: $("#driverId").val()
        });
        if ($('#showWareCheck').is(':checked')) {
            $('#datagrid').datagrid('showColumn', 'count');
        } else {
            $('#datagrid').datagrid('hideColumn', 'count');
        }
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
            return "已送达";
        }else if(val==5){
            return "配送终止";
        }
    }

    function formatterStatus(val,row){
        if(val==-2){
            return "暂存";
        }else if(val==1){
            return "配送完成";
        }else if(val==0){
            return "未发货";
        }
        else if(val==2){
            return "已作废";
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
        return v;
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


    function onDblClickRow(rowIndex, rowData) {
        parent.parent.parent.closeWin('销售配送信息' + rowData.id);
        parent.parent.parent.add('销售配送信息' + rowData.id, 'manager/stkDelivery/show?billId=' + rowData.id);
    }
</script>
</body>
</html>
