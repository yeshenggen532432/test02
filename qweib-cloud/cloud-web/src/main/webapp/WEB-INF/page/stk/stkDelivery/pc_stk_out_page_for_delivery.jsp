<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
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
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">

</table>
<div id="tb" style="padding:5px;height:auto">
    发票单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
    客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>

    <input name="memberNm" id="memberNm" style="width:120px;height: 20px;display: none" onkeydown="toQuery(event);"/>
    发票日期: <input name="sdate" id="sdate" onClick="WdatePicker();" style="width: 100px;" value="${sdate}"
                 readonly="readonly"/>
    <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle"
         style="cursor: pointer;"/>
    -
    <input name="edate" id="edate" onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle"
         style="cursor: pointer;"/>
    所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;"
                 onkeydown="toQuery(event);"/>
    <select name="orderZt" id="billStatus" style="display: none">
        <option value="未发货">未发货</option>
        <option value="终止未发完">终止未发完</option>
    </select>
    出库类型
    <select name="outType" id="outType">
        <option value="销售出库">销售出库</option>
        <option value="其它出库">其它出库</option>
        <option value="报损出库">报损出库</option>
        <option value="领用出库">领用出库</option>
        <option value="借出出库">借出出库</option>
    </select>
    <select name="orderZt" id="payStatus" style="display: none">
        <option value="">全部</option>
        <option value="未收款">未收款</option>
        <option value="已收款">已收款</option>
    </select>
    <br/>
    仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage" headerKey="-1" headerValue="--请选择--" displayKey="id"
                   displayValue="stk_name"/>
    商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    备注: <input name="remarks" id="remarks" style="width:120px;height: 20px;"/>
    显示商品信息:<input type="checkbox" id="showWareCheck" name="showWareCheck" onclick="queryorder()" value="1"/>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
    <%--<tag:permission name="配送单历史查询" image="icon-search" onclick="javascript:showDeliveryQuery();"   buttonCode="stk.stkSend.senditems"></tag:permission>--%>
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
            field: 'billNo',
            title: '单号',
            width: 135,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'operator',
            title: '创建人',
            width: 80,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'outType',
            title: '发票类型',
            width: 100,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'outDate',
            title: '发票日期',
            width: 80,
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
            field: 'staff',
            title: '业务员',
            width: 80,
            align: 'center'

        };
        cols.push(col);
        var col = {
            field: '_operator',
            title: '操作',
            width: 80,
            align: 'center',
            formatter: formatterSt3


        };
        cols.push(col);
        var col = {
            field: 'count',
            title: '商品信息',
            width: 400,
            align: 'center',
            formatter: formatterSt


        };
        cols.push(col);

        var col = {
            field: 'totalAmt',
            title: '合计金额',
            width: 60,
            align: 'center',
            formatter: amtformatter,
            hidden:${!permission:checkUserFieldPdm("stk.stkSend.lookamt")}

        };
        cols.push(col);
        var col = {
            field: 'discount',
            title: '整单折扣',
            width: 60,
            align: 'center',
            formatter: amtformatter,
            hidden:${!permission:checkUserFieldPdm("stk.stkSend.lookamt")}

        };
        cols.push(col);
        var col = {
            field: 'disAmt',
            title: '发票金额',
            width: 60,
            align: 'center',
            formatter: amtformatter,
            hidden:${!permission:checkUserFieldPdm("stk.stkSend.lookamt")}

        };
        cols.push(col);

        var col = {
            field: 'recAmt',
            title: '已收金额',
            width: 60,
            align: 'center',
            formatter: amtformatter,
            hidden:${!permission:checkUserFieldPdm("stk.stkSend.lookamt")}

        };
        cols.push(col);
        var col = {
            field: 'freeAmt',
            title: '核销金额',
            width: 60,
            align: 'center',
            formatter: amtformatter,
            hidden:${!permission:checkUserFieldPdm("stk.stkSend.lookamt")}

        };
        cols.push(col);

        var col = {
            field: 'billStatus',
            title: '发票状态',
            width: 60,
            align: 'center'

        };
        cols.push(col);


        var col = {
            field: 'remarks',
            title: '备注',
            width: 200,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'shr',
            title: '收货人',
            width: 80,
            align: 'center'

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
            field: 'pszd',
            title: '配送指定',
            width: 100,
            align: 'center'

        };
        cols.push(col);
        var col = {
            field: 'epCustomerName',
            title: '所属二批',
            width: 100,
            align: 'center'

        };
        cols.push(col);
        var isPay = -1;
        var sts = $("#payStatus").val();
        if (sts == "已收款") isPay = 1;
        if (sts == "未收款") isPay = 0;
        $('#datagrid').datagrid({
                url: "manager/stkDelivery/stkOutPageForDelivery",
                queryParams: {
                    jz: "1",
                    isPay: isPay,
                    billNo: $("#orderNo").val(),
                    khNm: $("#khNm").val(),
                    staff: $("#memberNm").val(),
                    billStatus: $("#billStatus").val(),
                    sdate: $("#sdate").val(),
                    edate: $("#edate").val(),
                    wareNm: $("#wareNm").val(),
                    outType: $("#outType").val(),
                    customerType: $("#customerType").val(),
                    epCustomerName: $("#epCustomerName").val(),
                    stkId: $("#stkId").val(),
                    remarks: $("#remarks").val()
                },
                columns: [
                    cols
                ]
            }
        );
        //$('#datagrid').datagrid('reload');
        if ($('#showWareCheck').is(':checked')) {
            $('#datagrid').datagrid('showColumn', 'count');
        } else {
            $('#datagrid').datagrid('hideColumn', 'count');
        }
    }

    //查询物流公司
    function queryorder() {
        var isPay = -1;
        var sts = $("#payStatus").val();
        if (sts == "已收款") isPay = 1;
        if (sts == "未收款") isPay = 0;
        $("#datagrid").datagrid('load', {
            url: "manager/stkDelivery/stkOutPageForDelivery",
            jz: "1",
            isPay: isPay,
            billNo: $("#orderNo").val(),
            khNm: $("#khNm").val(),
            staff: $("#memberNm").val(),
            billStatus: $("#billStatus").val(),
            sdate: $("#sdate").val(),
            edate: $("#edate").val(),
            wareNm: $("#wareNm").val(),
            outType: $("#outType").val(),
            customerType: $("#customerType").val(),
            epCustomerName: $("#epCustomerName").val(),
            stkId: $("#stkId").val(),
            remarks: $("#remarks").val()
        });
        if ($('#showWareCheck').is(':checked')) {
            $('#datagrid').datagrid('showColumn', 'count');
        } else {
            $('#datagrid').datagrid('hideColumn', 'count');
        }
    }

    //回车查询
    function toQuery(e) {
        var key = window.event ? e.keyCode : e.which;
        if (key == 13) {
            queryorder();
        }
    }

    function formatterSt3(val, row) {
        if (row.id == "" || row.id == null || row.id == undefined) {
            return "";
        }
        <%--var ret = "<input style='width:60px;height:27px;display:${permission:checkUserFieldDisplay('stk.stkSend.senditems')}' type='button' value='配送明细' onclick='showOutList(\""+row.id+"\",\""+row.billNo+"\")'/>";--%>

        var ret = "";

        if (row.billStatus != '作废') {
            ret = ret + "<input style='width:60px;height:27px;margin-top:2px;;display:${permission:checkUserFieldDisplay('stk.stkSend.send')}' type='button' value='配送' onclick='showCheck(\"" + row.id + "\",\"" + row.outType + "\",\"" + row.billStatus + "\")'/>";
        }
        <%--var index= $("#datagrid").datagrid("getRowIndex",row);--%>
        <%--if(row.status == 0)--%>
        <%--ret = ret + "<br/><input style='width:60px;height:27px;margin-top:2px;;display:${permission:checkUserFieldDisplay('stk.stkSend.wanjie')}' type='button' value='完结' onclick='wanjieBill(\""+row.id+"\",\""+index+"\")'/>";--%>
        return ret;

    }

    function formatterSt(v, row) {
        if (row.id == "" || row.id == null || row.id == undefined) {
            return "";
        }
        var hl = '<table>';
        if (row.list.length > 0) {
            hl += '<tr>';
            hl += '<td width="120px;"><b>商品名称</b></td>';
            hl += '<td width="80px;"><b>销售类型</b></td>';
            hl += '<td width="60px;"><b>单位</font></b></td>';
            hl += '<td width="80px;"><b>规格</font></b></td>';
            hl += '<td width="60px;" style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookqty")}"><b>数量</font></b></td>';
            hl += '<td width="60px;" style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookprice")}"><b>单价</font></b></td>';
            hl += '<td width="60px;" style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookamt")}"><b>总价</font></b></td>';
            hl += '<td width="60px;" style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookqty")}"><b>已发数量</font></b></td>';
            hl += '<td width="60px;" style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookqty")}"><b>未发数量</font></b></td>';
            hl += '</tr>';
        }
        for (var i = 0; i < row.list.length; i++) {
            hl += '<tr>';
            hl += '<td>' + row.list[i].wareNm + '</td>';
            hl += '<td>' + row.list[i].xsTp + '</td>';
            hl += '<td>' + row.list[i].unitName + '</td>';
            hl += '<td>' + row.list[i].wareGg + '</td>';
            hl += '<td style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookqty")}">' + row.list[i].qty + '</td>';
            hl += '<td style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookprice")}">' + row.list[i].price + '</td>';
            hl += '<td style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookamt")}">' + numeral(row.list[i].qty * row.list[i].price).format("0,0.00") + '</td>';
            hl += '<td style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookqty")}">' + row.list[i].outQty + '</td>';
            hl += '<td style="display:${permission:checkUserFieldDisplay("stk.stkSend.lookqty")}">' + row.list[i].outQty1 + '</td>';
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

    var billId = 0;

    function wanjieBill(id, rowIndex) {
        var remarks = "";
        $("#datagrid").datagrid("selectRow", rowIndex);
        var row = $('#datagrid').datagrid('getSelected');
        if (row) {
            billId = id;
            remarks = row.remarks;
            if (row.remarks == undefined) {
                remarks = "";
            }
            document.getElementById("wjRemark").value = remarks;
            $('#dlg').dialog('open');
        }
    }

    function closeBill() {
        if (billId == 0) {
            return;
        }
        $('#dlg').dialog('close');
        var remarks = document.getElementById("wjRemark").value;
        //$('#dlg').dialog('open');
        $.messager.confirm('确认', '您确认想要完结该记录吗？', function (r) {
            if (r) {
                $.ajax({
                    url: "manager/closeStkOut",
                    data: "billId=" + billId + "&remarks='" + remarks + "'",
                    type: "post",
                    success: function (json) {
                        if (json.state) {
                            showMsg("完结成功");
                            $("#datagrid").datagrid("reload");
                        } else if (json == -1) {
                            showMsg("完结失败" + json.msg);
                        }
                        billId = 0;
                        document.getElementById("wjRemark").value = "";
                    }
                });
            }
        });
    }

    function showCheck(billId, outType, status) {
        // if(outType == "销售出库")
        // {
        parent.parent.closeWin('物流配送开单');
        parent.parent.add('物流配送开单', 'manager/stkDelivery/add?outId=' + billId);
        // }
    }

    function onDblClickRow(rowIndex, rowData) {
        // if(rowData.outType == "销售出库")
        // 	{
        parent.parent.closeWin('物流配送开单');
        parent.parent.add('物流配送开单', 'manager/stkDelivery/add?outId=' + rowData.id);
        // }
    }

    function showOutList(billId, billNo) {
        parent.parent.closeWin('物流配送单列表');
        parent.parent.add('物流配送单列表', 'manager/stkDelivery/toPage?outNo=' + billNo);
    }

    function showDeliveryQuery() {
        parent.parent.closeWin('物流配送单查询');
        parent.parent.add('物流配送单查询', 'manager/stkDelivery/toPage');
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
