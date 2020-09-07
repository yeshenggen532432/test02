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
<div data-options="region:'west',split:true,title:'商品分类树'"
     style="width:150px;padding-top: 5px;">
    <ul id="waretypetree" class="easyui-tree"
        data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
					queryShopWare(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
    </ul>
</div>

<div id="departDiv" data-options="region:'center'" title="门店销售商品">
    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
           border="false"
           rownumbers="true" fitColumns="true" pagination="true" pagePosition=3  pageSize=50 pageList="[10,20,50,100,200,500,1000]"
           toolbar="#tb" >


    </table>
    <div id="tb" style="padding:5px;height:auto">
        连锁店:
        <tag:select id="shopName" name="shopName" displayKey="shop_no" onchange="queryShopWare(0)" displayValue="shop_name" tableName="pos_shopinfo"/>

        销售全部商品 <input type="checkbox" id="allWareCheck" onchange="updateData()"/>
        <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare();">选择商品</a>
        <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:deleteWare();">删除商品</a>
    </div>
    <input type="hidden" id="isAllWare" value="${isAllWare}">

</div>
<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
</div>
<script type="text/javascript">
    $(function(){
        initGrid();
        var nn = $("#isAllWare").val();
        if(nn == 0)$('#allWareCheck').attr('checked',true);
        queryShopWare();

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
    //data-options="onClickRow: onClickRow1"
    function initGrid() {
        // {field: 'pipingName', title: '管道名称(登记单元)', width: 170, editor: "text"},


        $("#datagrid").datagrid({
            singleSelect: false,
            fitColumns: false,
            border: false,
            columns: [[
                {field: 'ck', checkbox: 'true', width: 66},
                {field: 'id', title: '编号', width: 66, hidden: "true"},
                {field: 'wareId', title: '编号', width: 66, hidden: "true"},
                {field: 'wareNm', title: '商品名称', width: 90},
                {field: 'wareDw', title: '大单位', width: 90},
                {field: 'minUnit', title: '小单位', width: 90},
                { field: 'defaultUnit', title: '<span onclick="javascript:editPrice(0);">默认单位✎</span>', width: 150, formatter: formatDefaultUnit},
                {field: 'posPrice1', title: '<span onclick="javascript:editPrice(1);">门店大单位零售价✎</span>', width: 120,formatter:formatPosPrice1},
                {field: 'posPrice2', title: '<span onclick="javascript:editPrice(2);">门店小单位零售价✎</span>', width: 120,formatter:formatPosPrice2},
                {field: 'disPrice1', title: '大单位促销价', width: 90},
                {field: 'disPrice2', title: '小单位促销价', width: 90}
            ]],


        });
    }

    function onClickRow(rowNum,record)
    {
        queryShopWare(record.shopNo);
    }

    function queryShopWare(wareType){

        var shopNo1 = $("#shopName").val();
        $('#datagrid').datagrid({
            url:"manager/pos/queryPosShopWare",
            queryParams:{
                shopNo:shopNo1,
                wareType:wareType

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
    }
    function getChanges(){
        var rows = $('#datagrid').datagrid('getChanges');
        alert(rows.length+' rows are changed!');

    }

    function submitOneWare(ope)
    {
        var shopNos = $("#shopName").val();
        // var shoprows = $("#datagrid1").datagrid("getSelections");

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

        var shopNos = $("#shopName").val();

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
        var shopNos = $("#shopName").val();
        // var shoprows = $("#datagrid").datagrid("getSelections");

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
                    defaultUnit:0,
                    posPrice1:json.list[i].posPrice1,
                    posPrice2:json.list[i].posPrice2

                });
            }
        }
    }



    function deleteWare()
    {
        var shopNos = $("#shopName").val();
        //var shoprows = $("#datagrid1").datagrid("getSelections");

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

    //大小单位设置
    function formatDefaultUnit(val,row){
        var defaultUnit = "小单位";
        if(val == 1)defaultUnit = "大单位";
        var html ='<select name="defaultUnitSel" id="defaultUnitSel' + row.wareId + '" style="display:none" onchange="changePrice(this,' + row.wareId + ')"> ';
        if(val == 0) {
            html = html +'<option value="0" selected = "selected">小单位</option>'
                + '<option value="1">大单位</option>';
        }
        else
        {
            html = html +'<option value="0" >小单位</option>'
                + '<option value="1" selected = "selected">大单位</option>';
        }
        html = html  +'</select>'
            +'<span name="unitSpan1" id="unitSpan1_'+row.wareId+'">' + defaultUnit + '</span>';
        return html;
    }

    //门商品大单位零售价格
    function formatPosPrice1(val,row){
        var posPrice1 = row.posPrice1;
        if(posPrice1 == null || posPrice1 == undefined || posPrice1 == ''){
            posPrice1 = "";
        }
        return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.wareId + ")' name='priceInput1' id='priceInput1_"+row.wareId+"' value='" + posPrice1 + "'/><span name='priceSpan1' id='priceSpan1_"+row.wareId+"' >" + posPrice1 + "</span>";
    }
    //门商品小单位零售价格
    function formatPosPrice2(val,row){
        var posPrice2 = row.posPrice2;
        if(posPrice2 == null || posPrice2 == undefined || posPrice2 == ''){
            posPrice2 = "";
        }
        return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.wareId + ")' name='priceInput2' id='priceInput2_"+row.wareId+"' value='" + posPrice2 + "'/><span name='priceSpan2' id='priceSpan2_"+row.wareId+"' >" + posPrice2 + "</span>";
    }
    var k1 = true;
    var k2 = true;
    var k0 = true;
    function editPrice(kStr) {
        var priceInput = document.getElementsByName("priceInput1");
        var priceInput2 = document.getElementsByName("priceInput2");
        var priceSpan = document.getElementsByName("priceSpan1");
        var priceSpan2 = document.getElementsByName("priceSpan2");
        var defaultUnitSel = document.getElementsByName("defaultUnitSel");
        var unitSpan1 = document.getElementsByName("unitSpan1");

        for (var i = 0; i < priceInput.length; i++) {
            switch (kStr) {
                case 0:
                    if(k0){
                        defaultUnitSel[i].style.display = '';
                        unitSpan1[i].style.display = 'none';
                    }else{
                        defaultUnitSel[i].style.display = 'none';
                        unitSpan1[i].style.display = '';
                    }
                    break;
                case 1:
                    if (k1) {
                        priceInput[i].style.display = '';
                        priceSpan[i].style.display = 'none';
                    } else {
                        priceInput[i].style.display = 'none';
                        priceSpan[i].style.display = '';
                    }
                    break;
                case 2:
                    if (k2) {
                        priceInput2[i].style.display = '';
                        priceSpan2[i].style.display = 'none';
                    } else {
                        priceInput2[i].style.display = 'none';
                        priceSpan2[i].style.display = '';
                    }
                    break;

            }
        }
        switch (kStr) {
            case 0:
                k0= !k0;
                break;
            case 1:
                k1 = !k1;
                break;
            case 2:
                k2 = !k2;
                break;

        }
    }


    //-----------------------批量修改价格：开始----------------------------------
    //修改：更新门店零售价
    function changePrice(obj, wareId) {
        var posPrice1 = $("#priceInput1_"+wareId).val();
        var posPrice2 = $("#priceInput2_"+wareId).val();
        var defaultUnit = $("#defaultUnitSel" + wareId).val();
        var unitName = "小单位";
        if(defaultUnit == 1)unitName = "大单位";
        var shopNo = $("#shopName").val();
        $("#priceSpan1_"+wareId).text(posPrice1);
        $("#priceSpan2_"+wareId).text(posPrice2);
        $("#unitSpan1_"+wareId).text(unitName);
        $.ajax({
            url: "manager/pos/updateShopWare",
            type: "post",
            data:{
                "wareId":wareId,
                "posPrice1":posPrice1,
                "posPrice2":posPrice2,
                "shopNos":shopNo,
                "defaultUnit":defaultUnit
            },
            success: function (data) {
                if (data.state) {
                    //alert("操作成功");
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }


    function updateData() {

        var flag = 0;
        if(document.getElementById("allWareCheck").checked)flag = 0;
        else flag = 1;
        $.ajax({
            url: "manager/pos/updateParams",
            type: "post",
            data:{
                "paramName":"门店销售商品",
                "paramValue":flag,
                "shopNo":'9999'
            },
            success: function (data) {
                if (data.state) {
                    //alert("操作成功");
                    queryShopWare(0);
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

</script>
</body>
</html>
