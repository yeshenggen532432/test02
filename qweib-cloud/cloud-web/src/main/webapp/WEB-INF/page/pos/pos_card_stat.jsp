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
    连锁店: <select name="shopName" id="shopName">
    <option value="">全部</option>

</select>
    姓名: <input name="cstName" id="cstName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    卡号: <input name="cardNo" id="cardNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    电话: <input name="mobile" id="mobile" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    收银员: <input name="operator" id="operator" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    消费日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
    -
    <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
    <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>


    卡类型: <input name="cardType" id="cardType" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>



    <!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->

</div>
<div>
    <form action="manager/orderExcel" name="loadfrm" id="loadfrm" method="post">
        <input type="text" name="orderNo2" id="orderNo2"/>
        <input type="text" name="khNm2" id="khNm2"/>
        <input type="text" name="memberNm2" id="memberNm2"/>
        <input type="text" name="sdate2" id="sdate2"/>
        <input type="text" name="edate2" id="edate2"/>
        <input type="text" name="orderZt2" id="orderZt2"/>
        <input type="text" name="pszd2" id="pszd2"/>
        <input type="hidden" id = "shopNo" value="${shopNo}" />
    </form>
</div>
<div id="dlg" closed="true" class="easyui-dialog" title="完结" style="width:400px;height:200px;padding:10px"
     data-options="
				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						closeBill();
					}
				},{
					text:'取消',
					handler:function(){
						document.getElementById('wjRemark').value='';
						$('#dlg').dialog('close');
					}
				}]
			">

</div>
<%@include file="/WEB-INF/page/export/export.jsp"%>
<script type="text/javascript">
    var database="${database}";
    initGrid();
    //queryorder();
    function initGrid()
    {


        var cols = new Array();
        var col = {
            field: 'id',
            title: 'id',
            width: 50,
            align:'center',
            hidden:'true'

        };
        cols.push(col);

        var col = {
            field: 'statDate',
            title: '日期',
            width: 135,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'newQty',
            title: '发卡数量',
            width: 100,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'inputQty',
            title: '充值次数',
            width: 50,
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
            field: 'inputFree',
            title: '赠送金额',
            width: 80,
            align:'center',
            formatter:amtformatter

        };
        cols.push(col);

        var col = {
            field: 'costQty',
            title: '消费次数',
            width: 50,
            align:'center'


        };
        cols.push(col);

        var col = {
            field: 'cardPay',
            title: '消费金额',
            width: 80,
            align:'center',
            formatter:amtformatter

        };
        cols.push(col);

        var col = {
        field: 'disAmt',
        title: '差额',
        width: 80,
        align:'center',
        formatter:amtformatter

    };
        cols.push(col);

        var col = {
            field: 'totalAmt',
            title: '总可消费金额',
            width: 80,
            align:'center',
            formatter:amtformatter

        };
        cols.push(col);







        $('#datagrid').datagrid({
            url:"manager/pos/getCardStatList",
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
            url:"manager/pos/getCardStatList",
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
    //导出
    function myexport(){
        exportData('StkOutService','queryOutPage','com.cnlife.stk.model.StkOut',"{khNm:'"+$("#khNm").val()+"',memberNm:'"+$("#memberNm").val()+"',database:'"+database+"',sdate:'"+$("#sdate").val()+"',edate:'"+$("#edate").val()+"'}","出库单记录");
    }

    function formatterStatus(val,row) {
        if(val == -1)return "退卡";
        if(val == 0) return "挂失";
        if(val == 1)return "正常";

    }

    function formatterDocType(val,row)
    {
        if(val == 0)return "销售单";
        if(val == 1)return "退货单";
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
    function todetail(title,id){
        window.parent.add(title,"manager/queryBforderDetailPage?orderId="+id);
    }





    //导出成excel
    function toLoadExcel(){
        $('#orderNo2').val($('#orderNo').val());
        $('#khNm2').val($('#khNm').val());
        $('#memberNm2').val($('#memberNm').val());
        $('#sdate2').val($('#sdate').val());
        $('#edate2').val($('#edate').val());
        $('#orderZt2').val($('#orderZt').val());
        $('#pszd2').val($('#pszd').val());
        $('#loadfrm').form('submit',{
            success:function(data){
                alert(data);
            }
        });
    }

    function onDblClickRow(rowIndex, rowData)
    {
        if(rowData.outType == "销售出库")
        {
            parent.closeWin('发货开单');
            parent.add('发货开单','manager/showstkoutcheck?dataTp=1&billId=' + rowData.id);
        }
        else
        {
            parent.closeWin('其它发货开单');
            parent.add('其它发货开单','manager/showstkoutcheck?dataTp=1&billId=' + rowData.id);
        }
    }

    function showOutList(billId)
    {

        parent.closeWin('发货明细' + billId);
        parent.add('发货明细' + billId,'manager/toOutList?billId=' + billId);
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

    function loadCardType(){
        $.ajax({
            url:"manager/pos/queryMemberTypeList",
            type:"post",
            success:function(data){
                if(data){
                    var list = data.rows;
                    var objSelect = document.getElementById("cardType");
                    objSelect.options.add(new Option(''),'');
                    for(var i = 0;i < list.length; i++)
                    {
                        objSelect.options.add( new Option(list[i].typeName,list[i].id));

                    }

                }
            }
        });
    }
    loadCardType();

</script>
</body>
</html>
