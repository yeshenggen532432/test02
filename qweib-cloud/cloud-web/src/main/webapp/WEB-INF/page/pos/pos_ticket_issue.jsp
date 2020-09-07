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

<body class="easyui-layout">
<div data-options="region:'west',split:true,title:''"
     style="width:150px;padding-top: 5px;">


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
<div id="wareTypeDiv" data-options="region:'center'" title="会员列表">

    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
           border="false" url="manager/pos/queryMemberPage" pagination="true"
           pageSize=50 pageList="[10,20,50,100,200,500,1000]"
           rownumbers="true" fitColumns="false" pagination="false"
           toolbar="#tb" >
        <thead>
        <tr>
            <th field="ck" checkbox="true"></th>
            <th field="id" width="50" align="center" hidden="true">
                id
            </th>
            <th field="name" width="200" align="center">
                会员名称
            </th>
            <th field="cardNo" width="200" align="center">
                卡号
            </th>

            <th field="mobile" width="200" align="center">
                电话
            </th>

            <th field="typeName" width="200" align="center">
                会员类型
            </th>

            <th field="inputCash" width="200" align="center" formatter="amtformatter">
                剩余金额
            </th>

            <th field="freeCost" width="200" align="center">
                剩余赠送
            </th>

            <th field="status" width="200" align="center" formatter="formatterStatus">
                状态
            </th>




        </tr>
        </thead>
    </table>

    <div id="tb" style="padding:5px;height:auto">

            连锁店: <select name="shopName" id="shopName">
            <option value="">全部</option>

        </select>
        姓名: <input name="cstName" id="cstName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
        卡号: <input name="cardNo" id="cardNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
        电话: <input name="mobile" id="mobile" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>

        状态: <select name="status" id="status">
        <option value="-2">全部</option>
        <option value="1">正常</option>
        <option value="0">挂失</option>
    </select>
            <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryMember(0);">查询</a>
        <a class="easyui-linkbutton" iconCls="icon-edit"  href="javascript:issueclick();">优惠券赠送会员</a>
        <a class="easyui-linkbutton" iconCls="icon-edit"   href="javascript:issueclick2();">发行优惠券</a>





</div>
</div>

<div id="dlg" closed="true" class="easyui-dialog" title="发行优惠券" style="width:400px;height:200px;padding:10px"
     data-options="
				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						IssueProc1();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
    <div class="box">
        <dd>
            选择券类型: <select id="ticketTypeSelect" name="ticketTypeSelect">

        </select>
        </dd>
        <dd>
            有效期: <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
            <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
        </dd>
    </div>




</div>

<div id="dlg2" closed="true" class="easyui-dialog" title="发行优惠券" style="width:400px;height:200px;padding:10px"
     data-options="
				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						IssueProc2();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg2').dialog('close');
					}
				}]
			">
    <div class="box">
        <dd>
            选择券类型: <select id="ticketTypeSelect2" name="ticketTypeSelect2">

        </select>
        </dd>
        <dd>
            发行数量: <input name="qty" id="qty" style="width:120px;height: 20px;" />
        </dd>
        <dd>
            有效期: <input name="edate2" id="edate2"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
            <img onclick="WdatePicker({el:'edate2'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
        </dd>
    </div>




</div>

<script type="text/javascript">
    var database="${database}";

    //查询物流公司


    function loadShop(){
        var shopNo = $("#shopNo").val();
        var index = 0;
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
                        //if(list[i].shopNo == shopNo)index = i + 1;
                    }
                    document.getElementById("shopName").value=shopNo;



                }
            }
        });



    }
    loadShop();

    function loadTicketType(){

        var index = 0;
        $.ajax({
            url:"manager/pos/queryTicketType",
            type:"post",
            success:function(data){
                if(data){
                    var list = data.rows;
                    var objSelect = document.getElementById("ticketTypeSelect");
                    var objSelect2 = document.getElementById("ticketTypeSelect2");
                    //objSelect.options.add(new Option(''),'');
                    for(var i = 0;i < list.length; i++)
                    {
                        objSelect.options.add( new Option(list[i].ticketName,list[i].id));
                        objSelect2.options.add( new Option(list[i].ticketName,list[i].id));
                        //if(list[i].shopNo == shopNo)index = i + 1;
                    }

                }
            }
        });



    }

    loadTicketType();

    function issueclick()
    {
        var rows = $("#datagrid").datagrid("getSelections");
        if(rows.length == 0)
        {
            alert("请选择要赠送的会国， ");
            return;
        }
        $('#dlg').dialog('open');
    }

    function issueclick2()
    {

        $('#dlg2').dialog('open');
    }
    function formatterStatus(val,row) {
        if(val == -1)return "退卡";
        if(val == 0) return "挂失";
        if(val == 1)return "正常";

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

    function onLoadSuccess(data)
    {
        //var roleArr =  $('#dg').datagrid('getData');

    }
    function onLoadSuccess1(data)
    {


    }
    function onLoadSuccess2(data)
    {


    }

    function queryMember(memberType)
    {
        $("#datagrid").datagrid('load',{
            url:"manager/pos/queryMemberPage",

            mobile:$("#mobile").val(),
            cardNo:$("#cardNo").val(),
            shopNo:$("#shopName").val(),
            name:$("#cstName").val(),
            status:$("#status").val(),
            cardType:memberType

        });
    }
    //回车查询
    function toQuery(e){
        var key = window.event?e.keyCode:e.which;
        if(key==13){
            queryMember(0);
        }
    }


    function IssueProc1(){
        var ids = [];
        var rows = $("#datagrid").datagrid("getSelections");
        for ( var i = 0; i < rows.length; i++) {
            ids.push(rows[i].memId);

        }

        $.ajax({
            url:"manager/pos/PosTicketIssue",
            type:"post",
            data:"memberIds="+ids+"&ticketType=" + $("#ticketTypeSelect").val() + "&endDate=" + $("#edate").val(),
            success:function(data){
                if(data.state){
                    alert("操作成功");
                    $('#dlg').dialog('close');

                }else{
                    alert("操作失败");
                    return;
                }
            }
        });

    }

    function IssueProc2(){
        var qty = $("#qty").val();


        $.ajax({
            url:"manager/pos/PosTicketIssue",
            type:"post",
            data:"qty="+qty+"&ticketType=" + $("#ticketTypeSelect2").val() + "&endDate=" + $("#edate2").val(),
            success:function(data){
                if(data.state){
                    alert("操作成功");
                    $('#dlg2').dialog('close');

                }else{
                    alert("操作失败");
                    return;
                }
            }
        });

    }





    function onClickRow(rowNum,record)
    {
        //$("#groupId").val(record.id);

        queryMember(record.id);
    }

    function onClickRow2(rowNum,record)
    {
        $("#moduleId").val(record.id);


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

            submitOneRight(0);
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




</script>
</body>
</html>
