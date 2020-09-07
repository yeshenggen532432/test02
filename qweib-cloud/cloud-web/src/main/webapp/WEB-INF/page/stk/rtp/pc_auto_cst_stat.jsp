<%@ page language="java" pageEncoding="UTF-8" %>
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

<body onload="initGrid()">
<table id="datagrid" fit="true" singleSelect="true"
       title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true"
       data-options="onDblClickRow: onDblClickRow">

</table>
<div id="tb" style="padding:5px;height:auto">
    时间类型:<select name="timeType" id="timeType">
    <option value="2">发票时间</option>
    <option value="1">发货时间</option>
</select>
    时间: <input name="stime" id="sdate" onClick="WdatePicker();" style="width: 100px;" value="${sdate}"
               readonly="readonly"/>
    <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle"
         style="cursor: pointer;"/>
    -
    <input name="etime" id="edate" onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle"
         style="cursor: pointer;"/>
    出库类型:<tag:outtype id="outType" name="outType" style="width:100px" onchange="changeOutType()"></tag:outtype>
    销售类型:<tag:saleType id="xsTp" name="xsTp"></tag:saleType>
    客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
    客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    资产类型:<tag:zctype id="isType" name="isType"></tag:zctype>
    商品类别: <input name="wtype" type="hidden" id="wtype"/>
    <input name="wtypeName" ondblclick="setWareType('','')" readonly="true" style="width:80px" id="wtypeName"/>
    <a onclick="selectWareType()" href="javascript:;;">选择</a>
    客户所属区域:
    <select id="regioncomb" class="easyui-combotree" style="width:200px;"
            data-options="url:'manager/sysRegions',animate:true,dnd:true,onClick: function(node){
							setRegion(node.id);
							}"></select>
    <input type="hidden" name="regionId" id="regionId"/>
    所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;"
                 onkeydown="toQuery(event);"/>
    业务类型：
    <select id="saleType" name="saleType" onchange="queryData()">
        <option value="">全部</option>
        <option value="001">传统业务类</option>
        <option value="003">线上商城</option>
    </select>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>
    <a class="easyui-linkbutton" href="javascript:showMainDetail();">明细表</a>
    <a class="easyui-linkbutton" href="javascript:createRptData();">生成报表</a>
    <a class="easyui-linkbutton" href="javascript:queryRpt();">查询生成的报表</a>
    <a class="easyui-linkbutton" href="javascript:CustomerFee();">设置固定费用</a>
</div>
<div id="wareTypeDlg" closed="true" class="easyui-dialog" title="选择商品类别" style="width:250px;height:450px;padding:10px">
    <iframe name="wareTypefrm" id="wareTypefrm" frameborder="0" marginheight="0" marginwidth="0" width="100%"
            height="100%"></iframe>
</div>
<script type="text/javascript">
    var autoTitleDatas = eval('${autoTitleJson}');
    var autoPriceDatas = eval('${autoPriceJson}');
    //查询
    //initGrid();
    function initGrid() {
        var cols = new Array();
        var col = {
            field: 'stkUnit',
            title: '客户名称',
            width: 140,
            align: 'center'
        };
        cols.push(col);
        var col = {
            field: 'sumQty',
            title: '销售数量',
            width: 100,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);

        var col = {
            field: 'sumAmt',
            title: '销售收入',
            width: 100,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);

        var col = {
            field: 'avgPrice',
            title: '平均单位售价',
            width: 80,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);

        var col = {
            field: 'discount',
            title: '整单折扣',
            width: 80,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);

        var col = {
            field: 'inputAmt',
            title: '销售投入费用',
            width: 80,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);

        var col = {
            field: 'sumCost',
            title: '销售成本',
            width: 80,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);

        var col = {
            field: 'autoCost',
            title: '自定义费用',
            width: 80,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);
        if (autoTitleDatas.length > 0) {
            for (var i = 0; i < autoTitleDatas.length; i++) {
                var json = autoTitleDatas[i];
                var col = {
                    field: json.name,
                    title: '' + json.name,
                    width: 100,
                    align: 'center',
                    formatter: formatAutoAmt,
                    value: json.id
                };
                cols.push(col);
            }
        }

        var col = {
            field: 'fee',
            title: '固定费用',
            width: 80,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);


        var col = {
            field: 'disAmt',
            title: '销售毛利',
            width: 100,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);

        var col = {
            field: 'avgAmt',
            title: '平均单位毛利',
            width: 100,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);

        var col = {
            field: 'epCustomerName',
            title: '所属二批',
            width: 120,
            align: 'center'
        };
        cols.push(col);

        $('#datagrid').datagrid({
                columns: [
                    cols
                ]
            }
        );
    }

    function queryData() {
        var xsTp = $('#xsTp').combobox('getValues')+"";
        $('#datagrid').datagrid({
                url: "manager/queryAutoCstStatPage",
                queryParams: {
                    sdate: $("#sdate").val(),
                    edate: $("#edate").val(),
                    xsTp: xsTp,
                    outType:$("#outType").val(),
                    stkUnit: $("#khNm").val(),
                    epCustomerName: $("#epCustomerName").val(),
                    customerType: $("#customerType").val(),
                    timeType: $("#timeType").val(),
                    wtype: $("#wtype").val(),
                    isType:$("#isType").val(),
                    regionId: $("#regionId").val(),
                    saleType: $("#saleType").val()
                }
            }
        );
    }

    function formatterMny(v) {
        if (v != null) {
            return numeral(v).format("0,0.00");
        } else {
            return v;
        }
    }

    function amtformatter(v, row) {
        if (v == null) return "";
        if (v == "0E-7") {
            return "0.00";
        }
        if (row != null) {
            return numeral(v).format("0,0.00");
        }
    }

    //回车查询
    function toQuery(e) {
        var key = window.event ? e.keyCode : e.which;
        if (key == 13) {
            queryData();
        }
    }

    function onDblClickRow(rowIndex, rowData) {
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var xsTp = rowData.xsTp;
        var timeType = $("#timeType").val();
        var epCustomerName = rowData.epCustomerName;
        var wtype = $("#wtype").val();
        var customerType = $("#customerType").val();
        parent.closeWin('客户毛利明细统计');
        parent.add('客户毛利明细统计', 'manager/queryAutoCstStatDetail?sdate=' + sdate + '&wtype=' + wtype + '&customerType=' + customerType + '&edate=' + edate + '&timeType=' + timeType + '&epCustomerName=' + epCustomerName + '&xsTp=' + xsTp + '&stkUnit=' + rowData.stkUnit);
    }

    function CustomerFee() {
        parent.closeWin('客户固定费用');
        parent.add('客户固定费用', 'manager/toCustomerFee');
    }

    function showMainDetail() {
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        //var xsTp = $("#xsTp").val();
        var xsTp = $('#xsTp').combobox('getValues')+"";
        var stkUnit = $("#khNm").val();
        var timeType = $("#timeType").val();
        var epCustomerName = $("#epCustomerName").val();
        var customerType = $("#customerType").val();
        var wtype = $("#wtype").val();
        parent.closeWin('客户毛利明细统计表');
        parent.add('客户毛利明细统计表', 'manager/queryAutoCstStatDetail?sdate=' + sdate + '&wtype=' + wtype + '&edate=' + edate + '&timeType=' + timeType + '&epCustomerName=' + epCustomerName + '&xsTp=' + xsTp + '&customerType=' + customerType + '&stkUnit=' + stkUnit);
    }


    function createRptData() {
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var xsTp = $('#xsTp').combobox('getValues')+"";
        var outType = $("#outType").val();
        var stkUnit = $("#khNm").val();
        var epCustomerName = $("#epCustomerName").val();
        var customerType = $("#customerType").val();
        var timeType = $("#timeType").val();
        var wtype = $("#wtype").val();
        var regionId = $("#regionId").val();
        parent.closeWin('生成客户费用统计表');
        parent.add('生成客户费用统计表', 'manager/queryAutoCstStatDetailList?sdate=' + sdate + '&timeType=' + timeType + '&regionId=' + regionId + '&wtype=' + wtype + '&edate=' + edate + '&outType=' + outType + '&stkUnit=' + stkUnit + '&customerType=' + customerType + '&epCustomerName=' + epCustomerName);
    }

    function queryRpt() {
        parent.closeWin('生成的统计表');
        parent.add('生成的统计表', 'manager/querySaveRptDataStat?rptType=4');
    }

    function formatAutoAmt(val, row, index) {
        var price = "";
        var map = row.autoMap
        var html = "";
        for (var key in map) {
            if (key == this.value) {
                html = map[key];
            }
        }
        return formatterMny(html);
    }

    function setRegion(regionId) {
        $("#regionId").val(regionId);
    }

    function selectWareType() {
        var isType=$("#isType").val();
        document.getElementById("wareTypefrm").src='${base}/manager/selectDialogWareType?isType='+isType;
        $('#wareTypeDlg').dialog('open');
    }
    function setWareType(id,name) {
        if(id==0){
            id="";
        }
        $("#wtype").val(id);
        $("#wtypeName").val(name);
    }

    function changeOutType(){
        var v = $("#outType").val();
        $('#xsTp').combobox('loadData',{});
        $('#xsTp').combobox('setValue', '');
        // if(v==""){
        //    $('#xsTp').combobox('loadData',allData);
        // }else
        //
        if(v=="销售出库"){
            $('#xsTp').combobox('loadData',outData);
        }else if(v=="其它出库"){
            $('#xsTp').combobox('loadData',otherData);
        }
    }
    $(function(){
        $("#xsTp").combobox('loadData', outData);
    })





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
