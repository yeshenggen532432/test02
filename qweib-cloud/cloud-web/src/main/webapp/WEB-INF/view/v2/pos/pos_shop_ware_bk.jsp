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
</head>

<body class="easyui-layout" fit="true">
<div data-options="region:'west',split:true,title:'门店信息'"
     style="width:250px;padding-top: 5px;">

    <table id="datagrid1" class="easyui-datagrid" fit="true" singleSelect="false"
           url="manager/pos/queryPosShopInfoPage" iconCls="icon-save" border="false"
           rownumbers="true" fitColumns="true" pagination="false"
           pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="
				onClickRow: onClickRow">
        <thead>
        <tr>
            <th field="ck" checkbox="true"></th>
            <th field="id" width="50" align="center" hidden="true">
                id
            </th>
            <th field="shopNo" width="80" align="center">
                店号
            </th>
            <th field="shopName" width="120" align="center">
                店名
            </th>


        </tr>
        </thead>
    </table>

</div>
<div id="departDiv" data-options="region:'center'" title="门店销售商品">
    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
           border="false"
           rownumbers="true" fitColumns="true" pagination="false" pagePosition=3
           toolbar="#tb" data-options="onClickRow: onClickRow1">


    </table>
    <div id="tb" style="padding:5px;height:auto">
        <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare();">选择商品</a>
        <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:deleteWare();">删除商品</a>
    </div>

</div>
<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
</div>
<script type="text/javascript">
    $(function(){
        initGrid();
    });

    var unitInfo = [{ "value": "0", "text": "小单位" }, { "value": "1", "text": "大单位" }];


    function unitformatter(value, rowData, rowIndex) {

        for (var i = 0; i < unitInfo.length; i++) {
            if (unitInfo[i].value == value) {
                return unitInfo[i].text;
            }
        }
        return "";
    }

    function initGrid() {
        // {field: 'pipingName', title: '管道名称(登记单元)', width: 170, editor: "text"},

        $("#datagrid").datagrid({
            singleSelect: false,
            fitColumns: false,
            border: false,
            columns: [[
                {field: 'ck', checkbox: 'true', width: 66},
                {field: 'id', title: '编号', width: 66, hidden: "true"},
                {field: 'wareId', title: '编号1', width: 66, hidden: "true"},
                {field: 'wareNm', title: '商品名称', width: 90},
                {field: 'wareDw', title: '大单位', width: 90},
                {field: 'minUnit', title: '小单位', width: 90},
                { field: 'defaultUnit', title: '默认单位', width: 150, formatter: unitformatter, align: 'center', editor: { type: 'combobox', options: { data: unitInfo, valueField: "value", textField: "text" } } }
            ]],


        });
    }

    function onClickRow(rowNum,record)
    {
        queryShopWare(record.shopNo);
    }

    function queryShopWare(shopNo1){

        $('#datagrid').datagrid({
            url:"manager/pos/queryPosShopWare",
            queryParams:{
                shopNo:shopNo1

            }

        });



    }

    var editIndex = undefined;
    function endEditing(){
        if (editIndex == undefined){return true}
        if ($('#datagrid').datagrid('validateRow', editIndex)){
            //var ed = $('#datagrid').datagrid('getEditor', {index:editIndex,field:'menuId'});
            //var productname = $(ed.target).combobox('getText');
            //$('#datagrid').datagrid('getRows')[editIndex]['productname'] = productname;
            $('#datagrid').datagrid('endEdit', editIndex);

            editIndex = undefined;

            submitOneWare(0);
            return true;
        } else {
            return false;
        }
    }
    function onClickRow1(index){
        if (editIndex != index){
            if (endEditing()){
                $('#datagrid').datagrid('selectRow', index)
                    .datagrid('beginEdit', index);
                editIndex = index;

            } else {
                $('#datagrid').datagrid('selectRow', editIndex);
            }
        }

    }

    function accept(){
        if (endEditing()){
            $('#datagrid').datagrid('acceptChanges');

        }
    }
    function reject(){
        $('#datagrid').datagrid('rejectChanges');
        editIndex = undefined;
        alert(22);
    }
    function getChanges(){
        var rows = $('#datagrid').datagrid('getChanges');
        alert(rows.length+' rows are changed!');

    }

    function submitOneWare(ope)
    {
        var shopNos = "";
        var shoprows = $("#datagrid1").datagrid("getSelections");
        for(var i = 0;i<shoprows.length;i++)
        {
            if(shopNos == "")shopNos = shoprows[i].shopNo;
            else shopNos = shopNos + "," + shoprows[i].shopNo;
        }
        if(shopNos == "")
        {
            alert("请选择门店");
            return;
        }
        var roleArr =  $('#datagrid').datagrid('getData');

        var rows = $('#datagrid').datagrid('getChanges');
        if(rows.length == 0)return;
        var id = rows[0].wareId;
        var defaultUnit = rows[0].defaultUnit;

        $.ajax( {
            url : "manager/pos/updateShopWare",
            data : "shopNos=" + shopNos+"&wareId=" + id + "&defaultUnit=" + defaultUnit,
            type : "post",
            success : function(json) {
                if (json.state) {
                    if(ope == 1)
                        showMsg("保存成功");
                    //$("#datagrid").datagrid("reload");
                } else{
                    showMsg("提交失败");
                }
            }
        });
        accept();

    }

    function dialogSelectWare(){
        var shopNos = "";
        var shoprows = $("#datagrid1").datagrid("getSelections");
        for(var i = 0;i<shoprows.length;i++)
        {
            if(shopNos == "")shopNos = shoprows[i].shopNo;
            else shopNos = shopNos + "," + shoprows[i].shopNo;
        }
        if(shopNos == "")
        {
            alert("请选择门店");
            return;
        }

        $('#wareDlg').dialog({
            title: '商品选择',
            iconCls:"icon-edit",
            width: 800,
            height: 400,
            modal: true,
            href: "<%=basePath %>/manager/dialogWareType?stkId="+0,
            onClose: function(){
            }
        });
        $('#wareDlg').dialog('open');
    }

    function callBackFun(json){
        var shopNos = "";
        var shoprows = $("#datagrid1").datagrid("getSelections");
        for(var i = 0;i<shoprows.length;i++)
        {
            if(shopNos == "")shopNos = shoprows[i].shopNo;
            else shopNos = shopNos + "," + shoprows[i].shopNo;
        }
        $.ajax( {
            url : "manager/pos/addBatShopWare",
            data : "shopNos=" + shopNos+"&wareStr=" + JSON.stringify(json.list) ,
            type : "post",
            success : function(json) {
                if (json.state) {
                    //if(ope == 1)
                    showMsg("保存成功");
                    //$("#datagrid").datagrid("reload");
                } else{
                    showMsg("提交失败");
                }
            }
        });
        var size = json.list.length;
        if(size>0){
            for(var i=0;i<size;i++){
                $('#datagrid').datagrid("appendRow", {
                    id:0,
                    wareId:json.list[i].wareId,
                    wareNm:json.list[i].wareNm,
                    wareDw:json.list[i].wareDw,
                    minUnit:json.list[i].minUnit,
                    defaultUnit:0

                });
            }
        }
    }



    function deleteWare()
    {
        var shopNos = "";
        var shoprows = $("#datagrid1").datagrid("getSelections");
        for(var i = 0;i<shoprows.length;i++)
        {
            if(shopNos == "")shopNos = shoprows[i].shopNo;
            else shopNos = shopNos + "," + shoprows[i].shopNo;
        }
        if(shopNos == "")
        {
            alert("请选择门店");
            return;
        }
        var roleArr =  $('#datagrid').datagrid('getSelections');
        if(roleArr.length == 0)
        {
            alert("请选择要删除的记录");
            return;
        }
        var wareIds = "";
        for(var i = 0;i<roleArr.length;i++)
        {
            if(wareIds == "")wareIds = roleArr[i].wareId;
            else wareIds = wareIds + "," + roleArr[i].wareId;
        }

        $.ajax( {
            url : "manager/pos/deleteShopWare",
            data : "shopNos=" + shopNos+"&wareIds=" + wareIds,
            type : "post",
            success : function(json) {
                if (json.state) {

                    showMsg("删除成功");
                    $("#datagrid").datagrid("reload");
                } else{
                    showMsg("提交失败");
                }
            }
        });


    }



</script>
</body>
</html>
