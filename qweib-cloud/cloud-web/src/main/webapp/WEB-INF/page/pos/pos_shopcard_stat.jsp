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

<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" >

</table>
<div id="tb" style="padding:5px;height:auto">
    消费门店: <select name="shopName" id="shopName">
    <option value="">全部</option>

</select>

    消费日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
    -
    <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>



    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>

    <input type="hidden" id="shopNo" value="${shopNo}"/>

    <!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->

</div>

<script type="text/javascript">
    var database="${database}";
    initGrid();
    //queryorder();
    function initGrid()
    {


        var cols = new Array();


        var col = {
            field: 'shopNo',
            title: '卡所属门店店号',
            width: 135,
            align:'center'

        };
        cols.push(col);

        var col = {
            field: 'shopName',
            title: '卡所属门店店名',
            width: 135,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'inputCash',
            title: '充值金额',
            width: 80,
            align:'center',
            formatter:amtformatter

        };
        cols.push(col);




        var col = {
            field: '_operator',
            title: '操作',
            width: 100,
            align:'center',
            formatter:formatterSt3


        };
        cols.push(col);




        $('#datagrid').datagrid({
            url:"manager/pos/queryShopCardStat",
            queryParams:{
                startTime:$("#sdate").val(),
                endTime:$("#edate").val() + ' 23:59:00',
                shopNo:$("#shopName").val()

            },
            columns:[
                cols
            ]}
        );
        //$('#datagrid').datagrid('reload');
    }
    //查询物流公司
    function  queryorder() {
        $("#datagrid").datagrid('load',{
            url:"manager/pos/queryShopCardStat",
            startTime:$("#sdate").val(),
            endTime:$("#edate").val() + ' 23:59:00',
            shopNo:$("#shopName").val()

        });

    }
    //回车查询
    function toQuery(e){
        var key = window.event?e.keyCode:e.which;
        if(key==13){
            queryorder();
        }
    }



    function amtformatter(v,row)
    {
        if(v==""){
            return "";
        }
        if(v=="0E-7"){
            return "0.00";
        }
        if (row != null) {
            return numeral(v).format("0,0.00");
        }
    }
    function todetail(shopNo){
        window.parent.add(title,"manager/toPosShopCardDetail?shopNo="+shopNo+"&sdate=" + $("#sdate").val() + "&edate=" + $("#edate").val());
    }


    function formatterSt3(val,row){

        if(row.id == 0)return "";
        var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='todetail("+row.shopNo+")'/>";

        return ret;

    }




    function loadShop(){
        var shopNo = $("#shopNo").val();
        $.ajax({
            url:"manager/pos/queryShopRight",
            type:"post",
            success:function(data){
                if(data){
                    var list = data.rows;
                    var objSelect = document.getElementById("shopName");
                    objSelect.options.add(new Option(''),'');
                    for(var i = 0;i < list.length; i++)
                    {
                        objSelect.options.add( new Option(list[i].shopName,list[i].shopNo));

                    }
                    document.getElementById("shopName").value=shopNo;

                }
            }
        });
    }
    loadShop();


</script>
</body>
</html>
