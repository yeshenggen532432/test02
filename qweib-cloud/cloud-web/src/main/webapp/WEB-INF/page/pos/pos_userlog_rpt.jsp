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
    <script type="text/javascript" src="resource/loadDiv.js"></script>
    <script type="text/javascript" src="resource/dtree.js"></script>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
    <style>
        .file-box{position:relative;width:70px;height: auto;}
        .uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
        .uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
    </style>
</head>

<body onload="initGrid()">
<table id="datagrid" class="easyui-datagrid"  fit="true"  singleSelect="false"
       iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="false"
       toolbar="#tb">

</table>
<div id="tb" style="padding:5px;height:auto">
    交班日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
    -
    <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
    收银员: <input name="memberNm" id="memberNm" style="width:156px;height: 20px;" onkeydown="queryWareStat();"/>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>





</div>

<script type="text/javascript">
    function initGrid()
    {
        var cols = new Array();
        var col = {
            field: 'shopName',
            title: '店铺名称',
            width: 140,
            align:'left'
        };
        cols.push(col);
        var col = {
            field: 'operator',
            title: '收银员',
            width: 140,
            align:'left'
        };
        cols.push(col);

        var col = {
            field: 'startTime',
            title: '开始时间',
            width: 140,
            align:'left'
        };
        cols.push(col);

        var col = {
            field: 'endTime',
            title: '交班时间',
            width: 140,
            align:'left'
        };
        cols.push(col);

        var col = {
            field: 'billQty',
            title: '结单数量',
            width: 100,
            align:'center'
        };
        cols.push(col);

        var col = {
            field: 'totalSale',
            title: '总营业额',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'saleCash',
            title: '营业现金',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'saleBank',
            title: '银行卡',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'saleTicket',
            title: '抵用券',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'saleCard',
            title: '会员卡',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'saleWx',
            title: '微信支付',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'saleZfb',
            title: '支付宝',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'cancelQty',
            title: '撤单单数',
            width: 100,
            align:'center'

        };
        cols.push(col);

        var col = {
            field: 'cancelAmt',
            title: '撤单金额',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'returnQty',
            title: '退货单数',
            width: 100,
            align:'center'

        };
        cols.push(col);


        var col = {
            field: 'returnAmt',
            title: '退货金额',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'newCards',
            title: '发卡数量',
            width: 100,
            align:'center'

        };
        cols.push(col);

        var col = {
            field: 'cardCost',
            title: '工本费',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'inputAmt',
            title: '充值金额',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'freeCost',
            title: '赠送金额',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'inputCash',
            title: '充值现金',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'inputBank',
            title: '银行卡',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'inputWx',
            title: '充值微信',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'inputZfb',
            title: '充值支付宝',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'rtnCardQty',
            title: '退卡次数',
            width: 100,
            align:'center'

        };
        cols.push(col);

        var col = {
            field: 'rtnCardAmt',
            title: '退卡金额',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'totalCash',
            title: '现金汇总',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'totalBank',
            title: '银行卡汇总',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'totalWx',
            title: '微信汇总',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        var col = {
            field: 'totalZfb',
            title: '支付宝汇总',
            width: 100,
            align:'center',
            formatter:amtformatter
        };
        cols.push(col);

        $('#datagrid').datagrid({
            url:"manager/pos/queryUserLogRpt",
            queryParams:{
                startTime:$("#sdate").val(),
                endTime:$("#edate").val()

            },
            columns:[
                cols
            ]}
        );
    }

    function initGrid1()
    {
        $.ajax( {
            url : "manager/pos/queryShopRight",
            data : "",
            type : "post",
            success : function(json) {
                if (json.state) {
                    var list = json.rows;
                    var cols = new Array();
                    var col = {
                        field: 'itemName',
                        title: '项目名称',
                        width: 140,
                        align:'left'
                    };
                    cols.push(col);
                    for(var i=0;i<list.length;i++){

                        var col = {
                            field: 'shop' + i,
                            title: list[i].shopName,
                            width: 140,
                            align:'center'
                        };
                        cols.push(col);
                    }
                    $('#datagrid').datagrid({
                        url:"manager/pos/queryUserLogRpt",
                        queryParams:{
                            startTime:$("#sdate").val(),
                            endTime:$("#edate").val()

                        },
                        columns:[
                            cols
                        ]}
                    );
                }else{
                    showMsg("查询失败");
                }
            }
        });
    }

    function amtformatter(v,row)
    {
        if(v == null)return "";
        if(v=="0E-7"){
            return "0.00";
        }
        if (row != null) {
            return numeral(v).format("0,0.00");
        }
    }

    function queryData(){
        initGrid();

        $("#datagrid").datagrid('load',{
            url:"manager/pos/queryUserLogRpt",
            startTime:$("#sdate").val(),
            endTime:$("#edate").val(),
            operator:$("#memberNm").val()

        });
    }



</script>
</body>
</html>
