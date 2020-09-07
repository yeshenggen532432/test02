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
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>

<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">

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
    卡类型: <select name="cardType" id="cardType">
    <option value="">全部</option>

</select>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>


    <input type="hidden" id="shopNo" value="${shopNo}"/>
    <input type="hidden" id="source" value="${source}"/>
    <input type="hidden" id="cardType1" value="${cardType}" />
      <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出会员</a>
    <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:toUpMember();">导入会员</a>

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
<div id="upDiv" class="easyui-window" style="width:500px;height:100px;padding:10px;"
     minimizable="false" maximizable="false" collapsible="false" closed="true">
    <form action="manager/pos/toUpMemberTemplateData" id="upFrm" method="post" enctype="multipart/form-data">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr height="30px">
                <td>选择文件：</td>
                <td>
                    <input type="file" name="upFile" id="upFile" title="check"/>
                </td>
                <td><input type="button" onclick="toUpMemberExcel();" style="width: 50px" value="上传"/></td>
            </tr>
        </table>
    </form>
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
            field: 'memId',
            title: 'memId',
            width: 50,
            align:'center',
            hidden:'true'

        };
        cols.push(col);
        var col = {
            field: 'openId',
            title: '会员编号',
            width: 135,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'name',
            title: '会员名称',
            width: 100,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'sex',
            title: '性别',
            width: 50,
            align:'center'


        };
        cols.push(col);
        var col = {
            field: 'birthday',
            title: '生日',
            width: 80,
            align:'center'


        };
        cols.push(col);
        var col = {
            field: 'mobile',
            title: '电话',
            width: 80,
            align:'center'


        };
        cols.push(col);
        var col = {
            field: 'regDateStr',
            title: '注册日期',
            width: 80,
            align:'center'


        };
        cols.push(col);
        var col = {
            field: 'cardNo',
            title: '卡号',
            width: 80,
            align:'center'


        };
        cols.push(col);
        var col = {
            field: 'typeName',
            title: '卡类型',
            width: 80,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'inputCash',
            title: '剩余金额',
            width: 80,
            align:'center',
            formatter:amtformatter

        };
        cols.push(col);
        var col = {
            field: 'freeCost',
            title: '剩余赠送',
            width: 80,
            align:'center',
            formatter:amtformatter

        };
        cols.push(col);
        var col = {
            field: 'sumValue',
            title: '积分',
            width: 100,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'cardDate',
            title: '有效期',
            width: 100,
            align:'center'

        };
        cols.push(col);

        var col = {
            field: 'status',
            title: '状态',
            width: 100,
            align:'center',
            formatter:formatterStatus

        };
        cols.push(col);

        var col = {
            field: 'address',
            title: '地址',
            width: 100,
            align:'center'

        };
        cols.push(col);

        var col = {
            field: 'lastTimeStr',
            title: '最后消费时间',
            width: 80,
            align:'center'

        };
        cols.push(col);
        var col = {
            field: 'shopName',
            title: '所属门店',
            width: 80,
            align:'center'


        };
        cols.push(col);

        $('#datagrid').datagrid({
            url:"manager/pos/queryMemberPage",
            queryParams:{

                mobile:$("#mobile").val(),
                cardNo:$("#cardNo").val(),
                shopNo:$("#shopName").val(),
                name:$("#cstName").val(),
                status:$("#status").val(),
                cardType:$("#cardType1").val(),
                source:$("#source").val()

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
            url:"manager/pos/queryMemberPage",

            mobile:$("#mobile").val(),
            cardNo:$("#cardNo").val(),
            shopNo:$("#shopName").val(),
            name:$("#cstName").val(),
            status:$("#status").val(),
            cardType:$("#cardType").val(),
            source:$("#source").val()

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

        exportData('posMemberService','queryMemberPage','com.qweib.cloud.biz.pos.model.PosMember',"{source:'"+$("#source").val()+"',cardType:'"+$("#cardType").val()+"',mobile:'"+$("#mobile").val()+"',cardNo:'"+$("#cardNo").val()+"',database:'"+database+"',shopNo:'"+$("#shopName").val()+"',name:'"+$("#cstName").val()+"'}","出库单记录");
    }

    function formatterStatus(val,row) {
        if(val == -1)return "退卡";
        if(val == 0) return "挂失";
        if(val == 1)return "正常";

    }

    function toUpMember() {
        //显示上传框

            $("#upDiv").window({title: '上传', modal: true});
            $("#upDiv").window('open');


    }
    function toUpMemberExcel()
    {
        //上传文件

            $("#upFrm").form('submit', {
                success: function (data) {
                    if (data == '1') {
                        alert("上传成功");
                        //document.getElementById("upDiv").window('close');
                        //parent.parent.closeWin('导入商品信息确认');
                        //parent.parent.add('导入商品信息确认','manager/towaresimport');
                        queryorder();
                    } else {
                        alert(data);
                    }
                    onclose();
                },
                onSubmit: function () {
                    DIVAlert("<img src='resource/images/loading.gif' width='50px' height='50px'/>");
                }
            });

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
                    $("#cardType").val($("#cardType1").val());

                }
            }
        });
    }
    loadCardType();

</script>
</body>
</html>
