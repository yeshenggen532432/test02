<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
</head>

<body onload="queryShopRate();" class="easyui-layout">
<div data-options="region:'west',split:true,title:''"
     style="width:150px;padding-top: 5px;">

    <input type="hidden" id="cardType" />
    <table id="dg" class="easyui-datagrid" title="" fit="true" fitColumns="true" url="manager/pos/queryMemberTypeList"
           data-options="
				iconCls: 'icon-save',
				singleSelect: true,
				onClickRow: onClickRow, onLoadSuccess:onLoadSuccess
			">
        <!--  <table id="empdatagrid" class="easyui-datagrid" fit="true" singleSelect="true"
        url="manager/rolepages_company?page=1&rows=20" title="公司角色列表" iconCls="icon-save" border="false"
        rownumbers="true" fitColumns="true"
        toolbar="#tb" onClickRow=onClickRow>-->
        <thead>
        <tr>
            <th field="id" width="50" align="center" hidden="true">
                id
            </th>
            <th field="typeName" width="50" align="center">
                卡类型名称
            </th>



        </tr>
        </thead>
    </table>




</div>
<div id="wareTypeDiv" data-options="region:'center'" title="">
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       url="" title="会员促销列表" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="true" pagination="false" pagePosition=3
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
    <thead>
    <tr>
        <th field="id" width="50" align="center" hidden="true">
            id
        </th>
        <th field="cardTypeName" width="280" align="center" >
            卡类型
        </th>

        <th field="rateType" width="280" align="center" formatter="formatterRateType">
            打折类型
        </th>
        <th field="objName" width="280" align="center" >
            打折对象
        </th>
        <th field="rate" width="280" align="center">
            折扣%
        </th>
        <th field="startTimeStr" width="80" align="center">
            开始时间
        </th>
        <th field="endTimeStr" width="80" align="center">
            结束时间
        </th>
        <th field="status" width="100" align="center" formatter="formatterStatus">
            状态
        </th>
        <th field="_operater" width="200" align="center" formatter="formatterOper">
            操作
        </th>
    </tr>
    </thead>
</table>
<div id="tb" style="padding:5px;height:auto">

    连锁店:
    <tag:select id="shopName" name="shopName" displayKey="shop_no" onchange="queryShopRate()" displayValue="shop_name" tableName="pos_shopinfo"/>
    <a class="easyui-linkbutton" iconCls="icon-add"  href="javascript:toEditShopRate(0);">新增</a>


</div>
</div>

<div id="editdlg" closed="true" class="easyui-dialog" title="编辑" style="width:600px;height:600px;padding:10px"
     data-options="
    iconCls: 'icon-save',

    buttons: [{
    text:'确定',
    iconCls:'icon-ok',
    handler:function(){
    saveShopRate();
    }
    },{
    text:'取消',
    handler:function(){
    $('#editdlg').dialog('close');
    }
    }]
    ">
    <iframe  name="editfrm" id="editfrm" frameborder="0" marginheight="0" marginwidth="0" width="420px" height="300px"></iframe>
</div>

<script type="text/javascript">

    function onClickRow(rowNum,record)
    {
        //$("#groupId").val(record.id);
        $("#cardType").val(record.id);
        queryShopRate();
    }


    function queryShopRate(){
        $('#datagrid').datagrid({
            url:"manager/pos/queryPosCardDisSet",
            queryParams:{
                shopNo: $("#shopName").val(),
                cardType:$("#cardType").val()


            }

        });
    }

    function onLoadSuccess(data)
    {
        //var roleArr =  $('#dg').datagrid('getData');

    }

    function formatterRateType(val,row) {
        if(val == 0)return "全店打折";
        if(val == 1)return "按类型打折";
        if(val == 2)return "按单品打折";

    }

    function formatterStatus(val,row) {
        if(val == 0)return "无效";
        if(val == 1)return "有效";

    }

    function formatterOper(val,row){
        var html = "<a href='javascript:;;' onclick='toEditShopRate(\""+row.id+"\")'>修改<a/>";
        html+="&nbsp;|"+"<a href='javascript:;;' onclick='deleteShopRate(\""+row.id+"\")'>删除<a/>";

        return html;
    }



    function toEditShopRate(id){
        // document.getElementById("editfrm").src="${base}/manager/pos/toPosShopDisSetEdit?id="+id;
        //  $('#editdlg').dialog('open');
        location.href="${base}/manager/pos/toPosCardDisSetEdit?id="+id;
    }

    function deleteShopRate(id){
        $.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
            if (r) {
                $.ajax( {
                    url : "manager/pos/deletePosShopRate",
                    data : "id=" + id,
                    type : "post",
                    success : function(json) {
                        if (json == 1) {
                            showMsg("删除成功");
                            $("#datagrid").datagrid("reload");
                        }else{
                            showMsg("删除失败");
                        }
                    }
                });
            }
        });
    }

    function saveShopRate() {
        document.getElementById("editfrm").contentWindow.toSubmit();

    }


</script>
</body>
</html>
