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
           border="false"  pagination="true"
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

        连锁店:<tag:select id="shopName" name="shopName" displayKey="shop_no" headerKey="" headerValue="全部门店" onchange="queryShopWare(0)" displayValue="shop_name" tableName="pos_shopinfo"/>
        姓名: <input name="cstName" id="cstName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
        卡号: <input name="cardNo" id="cardNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
        电话: <input name="mobile" id="mobile" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>

        状态: <select name="status" id="status">
        <option value="-2">全部</option>
        <option value="1">正常</option>
        <option value="0">挂失</option>
    </select>
        <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryMember(0);">查询</a>
        <a class="easyui-linkbutton" iconCls="icon-edit"  href="javascript:initclick();">充值</a>





    </div>
</div>
</div>

<div id="dlg" closed="true" class="easyui-dialog" title="充值" style="width:400px;height:300px;padding:10px"
     data-options="
				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						initProc1();
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
            <span class="title">充值金额:：</span>
             <input name="inputCash" id="inputCash" style="width:120px;height: 20px;" />
        </dd>
        <dd>
            <span class="title">赠送金额:：</span>
             <input name="freeCost" id="freeCost" style="width:120px;height: 20px;" />
        </dd>
        <dd>
            <span class="title">新卡类型：</span>
            <tag:select id="cardTypeSel" name="cardType" displayKey="id" headerValue="请选择卡类型" headerKey="0" displayValue="type_name" tableName="shop_member_type"/>
        </dd>
        <span class="title">支付类型：</span>
        <select id="payType" name="payType" >
            <option value="现金支付">现金支付</option>
            <option value="微信支付">微信支付</option>
            <option value="支付宝">支付宝</option>
            <option value="银行卡">银行卡</option>
        </select>
    </div>





</div>



<script type="text/javascript">
    var database="${database}";

    function onClickRow(rowNum,record)
    {
        //$("#groupId").val(record.id);

        queryMember(record.id);
    }


    function initclick()
    {
        var rows = $("#datagrid").datagrid("getSelections");
        if(rows.length == 0)
        {
            alert("请选择会员， ");
            return;
        }
        if(rows.length > 1)
        {
            alert("只能选择一个会员");
            return;
        }
        $('#dlg').dialog('open');
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
        $('#datagrid').datagrid({
            url:"manager/pos/queryMemberPage",
            queryParams:{
                mobile:$("#mobile").val(),
                cardNo:$("#cardNo").val(),
                shopNo:$("#shopName").val(),
                name:$("#cstName").val(),
                status:$("#status").val(),
                cardType:memberType

            }

        });

    }
    //回车查询
    function toQuery(e){
        var key = window.event?e.keyCode:e.which;
        if(key==13){
            queryMember(0);
        }
    }


    function initProc1(){
        var id = 0;
        var rows = $("#datagrid").datagrid("getSelections");
        for ( var i = 0; i < rows.length; i++) {
           id = rows[i].id;

        }
        var inputCash = $("#inputCash").val();
        var freeCost = $("#freeCost").val();
        if(inputCash == "")inputCash = 0;
        if(freeCost == "")freeCost = 0;
        if(inputCash==0&&freeCost == 0)
        {
            alert("请输入金额");
            return;
        }
        var cardtype = $("#cardTypeSel").val();
        if(cardtype == "")cardtype = 0;
        var paytype = $("#payType").val();
        var cashPay = 0;
        var bankPay = 0;
        var wxPay = 0;
        var zfbPay  = 0;
        if(paytype == "微信支付")wxPay = inputCash;
        if(paytype == "现金支付")cashPay = inputCash;
        if(paytype == "银行卡")bankPay = inputCash;
        if(paytype == "支付宝")zfbPay = inputCash;
        $.ajax({
            url:"manager/pos/posMemberInput",
            type:"post",
            data:"id="+id+"&inputCash=" + inputCash + "&freeCost=" + freeCost + "&cardType=" + cardtype + "&cashPay=" + cashPay + "&bankPay=" + bankPay + "&wxPay=" + wxPay + "&zfbPay=" + zfbPay,
            success:function(data){
                if(data.state){
                    alert("操作成功");
                    $('#dlg').dialog('close');
                    $("#datagrid").datagrid("reload");
                }else{
                    alert("操作失败");
                    return;
                }
            }
        });

    }






</script>
</body>
</html>
