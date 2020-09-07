<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body onload="initGrid()"  class="easyui-layout">
<div data-options="region:'west',split:true,title:'商品分类树'"
     style="width:150px;padding-top: 5px;">
    <ul id="waretypetree" class="easyui-tree"
        data-options="url:'manager/waretypes',animate:true,dnd:true,onClick: function(node){
					queryData(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
    </ul>
</div>
<div id="wareTypeDiv" data-options="region:'center'" title="商品信息">
<table id="datagrid"  fit="true" singleSelect="true"
       title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onLoadSuccess: onLoadSuccess">

</table>
<div id="tb" style="padding:5px;height:auto">

    时间类型:<select name="timeType" id="timeType">
    <option value="1">发货时间</option>
    <option value="2">发票时间</option>
</select>
    : <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
    -
    <input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
    出库类型:<tag:outtype id="outType" name="outType" onchange="changeOutType()"/>
    销售类型:<tag:saleType id="xsTp" name="xsTp"/>

    仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage" headerKey="-1" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>
    业务员: <input name="staff" id="staff" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
    客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    显示日期:<input type="checkbox" checked="checked"  id="showDate" name="showWareCheck" onclick="queryData(0)" value="1"/>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData(0);">查询</a>

    业务类型：
    <select id="saleType" name="saleType" onchange="queryData()">
        <option value="">全部</option>
        <option value="001">传统业务类</option>
        <option value="003">线上商城</option>
        <option value="004">线下门店</option>
    </select>

</div>
</div>
<input type="hidden" id="database" value="${database}"/>
<%@include file="/WEB-INF/page/export/export.jsp"%>
<script type="text/javascript">
    //查询
    //initGrid();
    function initGrid()
    {
        var cols = new Array();
        var col = {
            field: 'dateStr',
            title: '日期',
            width: 140,
            align:'center'
        };
        cols.push(col);

        var col = {
            field: 'wareNm',
            title: '商品名称',
            width: 120,
            align:'center'
        };
        cols.push(col);

        var col = {
            field: 'unitName',
            title: '计量单位',
            width: 80,
            align:'center'
        };
        cols.push(col);

        var col = {
            field: 'khNm',
            title: '客户名称',
            width: 140,
            align:'center'
        };
        cols.push(col);



        var col = {
            field: 'xsTp',
            title: '销售类型',
            width: 100,
            align:'center'
        };
        cols.push(col);


        var col = {
            field: 'qty',
            title: '发票数量',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);
        var col = {
            field: 'amt',
            title: '发票金额',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'price',
            title: '价格',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'outQty',
            title: '发货数量',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);
        var col = {
            field: 'outAmt',
            title: '发货金额',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);




        $('#datagrid').datagrid({
                columns:[
                    cols
                ]
            }
        );
    }
    function queryData(waretype){
        var showDateCheck="0";

        if($('#showDate').is(':checked')){
            showDateCheck="1";
        }
        var xsTp = $('#xsTp').combobox('getValues')+"";
        $('#datagrid').datagrid({
                url:"manager/queryWareDayStat",
                queryParams:{
                    stkId:$("#stkId").val(),
                    sdate:$("#sdate").val(),
                    edate:$("#edate").val(),
                    outType:$("#outType").val(),
                    xsTp:xsTp,
                    staff:$("#staff").val(),
                    saleType:$("#saleType").val(),
                    khNm:$("#khNm").val(),
                    customerType:$("#customerType").val(),
                    wareNm:$("#wareNm").val(),
                    waretype:waretype,
                    isShowDate:showDateCheck,
                    timeType:$("#timeType").val()
                }
            }
        );

        if($('#showDate').is(':checked')) {
            $('#datagrid').datagrid('showColumn','dateStr');

        }else{
            $('#datagrid').datagrid('hideColumn','dateStr');

        }
    }
    function formatterMny(v)
    {
        if (v != null) {
            return numeral(v).format("0,0.00");
        }else{
            return v;
        }
    }
    function amtformatter(v,row)
    {
        if (row != null) {
            return numeral(v).format("0,0.00");
        }
    }
    //回车查询
    function toQuery(e){
        var key = window.event?e.keyCode:e.which;
        if(key==13){
            queryData();
        }
    }

    function onDblClickRow(rowIndex, rowData)
    {
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var outType = $("#outType").val();
        var xsTp = $('#xsTp').combobox('getValues')+"";
        var epCustomerName=rowData.epCustomerName;
        var saleType=$("#saleType").val()
        parent.closeWin('客户毛利明细统计');
        parent.add('客户毛利明细统计','manager/queryAutoCstStatDetail?sdate=' + sdate + '&edate=' + edate +'&epCustomerName='+epCustomerName+'&saleType='+saleType+'&outType=' + outType + '&stkUnit=' + rowData.stkUnit + '&xsTp=' +xsTp );
        //parent.add('发货' + rowData.id,'manager/showstkoutcheck?dataTp=1&billId=' + rowData.id);
    }

    function onLoadSuccess(data) {

        var start = 0;
        var end = 0;
        if (data.total > 0) {
            var temp = data.rows[0].dateStr;
            var wareNm = data.rows[0].wareNm;
            for (var i = 1; i < data.rows.length; i++) {
                if (temp == data.rows[i].dateStr&&wareNm==data.rows[i].wareNm) {
                    end++;
                } else {
                    if (end > start) {
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'dateStr'
                        });
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'wareNm'
                        });


                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'unitName'
                        });


                    }
                    temp = data.rows[i].dateStr;
                    wareNm=data.rows[i].wareNm;
                    start = i;
                    end = i;
                }
            }

            if (end > start) {
                $("#datagrid").datagrid('mergeCells', {
                    index: start,
                    rowspan: end - start + 1,
                    field: 'dateStr'
                });
                $("#datagrid").datagrid('mergeCells', {
                    index: start,
                    rowspan: end - start + 1,
                    field: 'wareNm'
                });


                $("#datagrid").datagrid('mergeCells', {
                    index: start,
                    rowspan: end - start + 1,
                    field: 'unitName'
                });
            }
        }
    }

    function mergeCol(data,colName){
        var start = 0;
        var end = 0;
        if (data.total > 0) {
            var temp = data.rows[0][colName];
            for (var i = 1; i < data.rows.length; i++) {
                if (temp == data.rows[i][colName]) {
                    end++;
                } else {
                    if (end > start) {
                        $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: colName
                        });
                    }
                    temp = data.rows[i][colName];
                    start = i;
                    end = i;
                }
            }
            /*这里是为了判断重复内容出现在最后的情况，如ABCC*/
            if (end > start) {
                $("#datagrid").datagrid('mergeCells', {
                    index: start,
                    rowspan: end - start + 1,
                    field: colName
                });
            }
        }

    }


    function createRptData()
    {
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var outType = $("#outType").val();
        var staff = $("#staff").val();
        var khNm = $("#khNm").val();
        var customerType = $("#customerType").val();
        var epCustomerName = $("#epCustomerName").val();
        var xsTp = $("#xsTp").val();
        var wareNm = $("#wareNm").val();
        var saleType=$("#saleType").val();
        //alert(outType);
        var paramStr = 'sdate=' + sdate + '&edate=' + edate +'&outType=' + outType+'&staff=' + staff + '&khNm=' + khNm + '&customerType=' + customerType+'&saleType='+saleType+'&epCustomerName=' + epCustomerName + '&xsTp=' + xsTp + '&wareNm=' + wareNm;
        parent.closeWin('生成销售票据明细表');
        //parent.add('生成销售票据明细表','manager/toStkOutDetailSave?sdate=' + sdate + '&edate=' + edate +'&outType=销售出库'+'&staff=' + staff + '&khNm=' + khNm + '&customerType=' + customerType+'&epCustomerName=' + epCustomerName);
        parent.add('生成销售票据明细表','manager/toStkOutDetailSave?' + paramStr);
    }

    function queryRpt()
    {
        parent.closeWin('生成的统计表');
        parent.add('生成的统计表','manager/toStkCstStatQuery?rptType=8');
    }

    function formatAutoAmt(val,row,index){
        var price = "";
        var map = row.autoMap
        var html ="";
        for(var key in map){
            if(key==this.value){
                html = map[key];
            }
        }
        return formatterMny(html);
        ;
    }
    function loadCustomerType(){
        $.ajax({
            url:"manager/queryarealist1",
            type:"post",
            success:function(data){
                if(data){
                    var list = data.list1;
                    var img="";
                    img +='<option value="">--请选择--</option>';
                    for(var i=0;i<list.length;i++){
                        if(list[i].qdtpNm!=''){
                            img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
                        }
                    }
                    $("#customerType").html(img);
                }
            }
        });
    }
    loadCustomerType();

    function myexport(){
        var database = $("#database").val();

        var stkId = $("#stkId").val();
        var  sdate =$("#sdate").val();
        var edate=$("#edate").val();
        var outType=$("#outType").val();
        var xsTp =$("#xsTp").val();
        var staff =$("#staff").val();
        var saleType =$("#saleType").val();
        var khNm=$("#khNm").val();
        var customerType =$("#customerType").val();
        var epCustomerName=$("#epCustomerName").val();
        var wareNm =$("#wareNm").val();

        var c = {
            database: database,
            stkId: stkId,
            sdate: sdate,
            edate: edate,
            outType: outType,
            xsTp:xsTp,
            staff: staff,
            xsTp: xsTp,
            saleType:saleType,
            khNm:khNm,
            customerType:customerType,
            epCustomerName:epCustomerName,
            wareNm: wareNm

        }

        exportData('incomeStatService','sumStkOutMast','com.qweib.cloud.biz.erp.model.StkOut',JSON.stringify(c),"销售票据明细表");


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
</script>
</body>
</html>
