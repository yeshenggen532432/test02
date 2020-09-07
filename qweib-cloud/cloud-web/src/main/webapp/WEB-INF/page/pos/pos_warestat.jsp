]<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>会员管理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body class="easyui-layout" fit="true">
<div data-options="region:'west',split:true,title:'商品分类树'"
     style="width:150px;padding-top: 5px;">
    <div id="divHYGL" style="overflow: auto;">
        <ul id="waretypetree" class="easyui-tree"
            data-options="url:'manager/waretypes',animate:true,dnd:true,onClick: function(node){
					queryWareByType(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
        </ul>
    </div>
</div>
<div id="departDiv" data-options="region:'center'" >
    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
            border="false"
           rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
           pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
        <thead>
        <tr>
            <th field="ck" checkbox="true"></th>
            <th field="wareId" width="10" align="center" hidden="true">
                wareId
            </th>


            <th field="wareNm" width="100" align="center" >
                商品名称
            </th>

            <th field="sumQty" width="100" align="center" formatter="amtformatter"  sortable="true">
                销售数量
            </th>

            <th field="sumAmt" width="100" align="center" formatter="amtformatter"  sortable="true">
                销售金额
            </th>

        </tr>
        </thead>
    </table>
    <div id="tb" style="padding:5px;height:auto">
        营业日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
        <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
        -
        <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
        <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
        连锁店: <select name="shopName" id="shopName">
        <option value="">全部</option>

    </select>

        商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" />

        <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWareStat();">查询</a>
        <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>
        过滤数量为0的记录否：<input type="checkbox" id="hideZero" onchange="querydata()"/>
        <input type="hidden" id="shopNo" value="${shopNo}">

    </div>

</div>
<%@include file="/WEB-INF/page/export/export.jsp"%>
<script type="text/javascript">
    var database="${database}";
    $(function(){

    });

    function ruleclick()
    {
        var rows = $("#datagrid").datagrid("getSelections");
        if(rows.length == 0)
        {
            alert("请选择要分配的员工");
            return;
        }
        $('#dlg').dialog('open');
    }

    function queryWareByType(typeId){


        var hideZero = 0;
        if(document.getElementById("hideZero").checked)hideZero = 1;

        $('#datagrid').datagrid({
            url:"manager/pos/queryPosWareStatPage",
            queryParams:{
                waretype:typeId,
                sdate:$("#sdate").val(),
                edate:$("#edate").val() + " 23:59:00",
                hideZero:hideZero,
                wareNm:$("#wareNm").val(),
                shopNo:$("#shopName").val()
            }

        });


    }

    function queryWareStat()
    {
        var hideZero = 0;
        if(document.getElementById("hideZero").checked)hideZero = 1;
        $('#datagrid').datagrid({
            url:"manager/pos/queryPosWareStatPage",
            queryParams:{
                sdate:$("#sdate").val(),
                edate:$("#edate").val() + " 23:59:00",
                hideZero:hideZero,
                wareNm:$("#wareNm").val(),
                shopNo:$("#shopName").val()
            }

        });

    }

    //导出
    function myexport(){
        var hideZero = 0;
        if(document.getElementById("hideZero").checked)hideZero = 1;
        var edate = $("#edate").val() + " 23:59:00";
        exportData('posSaleStatService','queryWareStatPage','com.qweib.cloud.biz.pos.model.PosWareStatVo',"{wareNm:'"+$("#wareNm").val()+"',hideZero:"+hideZero+",shopNo:'"+$("#shopName").val()+"',database:'"+database+"',sdate:'"+$("#sdate").val()+"',edate:'"+edate+"'}","商品销售排行");
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
