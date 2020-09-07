<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
</head>

<body class="easyui-layout" onload="querySumPage()">
<div data-options="region:'west',split:true,title:'商品分类树'"
     style="width:150px;padding-top: 5px;">
    <ul id="waretypetree" class="easyui-tree"
        data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
					queryByWaretypeId(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
    </ul>
</div>
<div id="wareTypeDiv" data-options="region:'center'" title="">
    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
           iconCls="icon-save" border="false"
           rownumbers="true" fitColumns="true" pagination="true"
           pageSize=20 pageList="[10,20,50,100,200,500,1000]"
           toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
        <thead>
        <tr>


            <th field="wid" width="50" align="center" hidden="true">
                wid
            </th>

            <th field="wareNm" width="100" align="center" >
                商品名称
            </th>
            <th field="kcNum" width="100" align="center" sortable="true">
                最后库存数
            </th>
            <th field="wareRate" width="100" align="center" sortable="true">
                市场占比%
            </th>
            <th field="saleRate" width="100" align="center" sortable="true">
                铺货率%
            </th>
            <th field="cstQty" width="100" align="center" sortable="true">
                在售商家数
            </th>


        </tr>
        </thead>
    </table>
    <div id="tb" style="padding:5px;height:auto">
        起止日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
        <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
        -
        <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
        <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>

        商品名称: <input name="wareNm" id="wareNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
        公司类别:<select name="noCompany" id="noCompany">
        <option value="0">全部</option>
        <option value="2">公司类别</option>
        <option value="1">非公司类别</option>
    </select>

        客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
        合作方式: <select name="hzfsNm" id="hzfsNm" style="width: 125px;">
        <option value="">合部</option>
        <c:forEach items="${hzfsls}" var="hzfsls">
            <option value="${hzfsls.hzfsNm}" <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
        </c:forEach>
    </select>
        所属片区: <input name="regionNm" id="regionNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
        业务员: <input name="staff" id="staff" style="width:100px;height: 20px;"/>

        <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryAllData();">查询</a>

        <input type="hidden" id="waretypeId" value="0"/>
        <input type="hidden" id="database" value="${database}"/>
        <%@include file="/WEB-INF/page/export/export.jsp"%>
        <input type="hidden" id="cid" value="${cid}">
        <input type="hidden" id="noCompany1" value="${noCompany}">
    </div>
</div>
<script type="text/javascript">
    //点击商品分类树查询
    $("#noCompany").val($("#noCompany1").val());
    function queryByWaretypeId(id)
    {
        $("#waretypeId").val(id);
        querySumPage();
    }
    //查询商品
    function queryAllData()
    {
        $("#waretypeId").val(0);
        querySumPage();
    }
    function querySumPage(){



        $('#datagrid').datagrid({
            url:"manager/queryMemBfXsxjStatPage",
            queryParams:{
                wareNm:$("#wareNm").val(),
                sdate:$("#sdate").val(),
                edate:$("#edate").val() + " 23:59:00",
                waretype:$("#waretypeId").val(),
                cid:$("#cid").val(),
                noCompany:$("#noCompany").val(),
                customerType:$("#customerType").val(),
                regionNm:$("#regionNm").val()

            }

        });


    }
    function loadCustomerType(){
        $.ajax({
            url:"manager/queryarealist1",
            type:"post",
            success:function(data){
                if(data){
                    var list = data.list1;
                    var img="";
                    img +='<option value="">--请选择--</option>';
                    for(var i=0;i<list.length;i++){
                        if(list[i].qdtpNm!=''){
                            img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
                        }
                    }
                    $("#customerType").html(img);
                }
            }
        });
    }
    loadCustomerType();
    function addDate(date, days) {
        if (days == undefined || days == '') {
            days = 1;
        }
        var date = new Date(date);
        date.setDate(date.getDate() + days);
        var month = date.getMonth() + 1;
        var day = date.getDate();
        return date.getFullYear() + '-' + getFormatDate(month) + '-' + getFormatDate(day);
    }
    function getFormatDate(arg) {
        if (arg == undefined || arg == '') {
            return '';
        }

        var re = arg + '';
        if (re.length < 2) {
            re = '0' + re;
        }

        return re;
    }
    function myexport(){
        var database = $("#database").val();
        var sdate=$("#sdate").val();
        var edate=$("#edate").val();
        edate = addDate(edate,1);
        var wareNm=$("#wareNm").val();
        var waretype=$("#waretypeId").val();
        var customerType =$("#customerType").val();
        var noCompany=$("#noCompany").val();



        exportData('sysBfxsxjService','sumBfxsxjPage','com.cnlife.qwb.model.SysBfxsxj',"{sdate:"+sdate+",edate:"+edate+",database:'"+database+"',wareNm:'" +wareNm+"',waretype:"+waretype+",cid:'" + cid + "',noCompany:" + noCompany + "}","拜访销售总结汇总表");


    }

    function onDblClickRow(rowIndex, rowData)
    {
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var wid = rowData.wid;
        var cid = rowData.cid
        parent.closeWin('拜访销售小结明细');
        parent.add('拜访销售小结明细','manager/toBfxsxjDetail?sdate=' + sdate + '&edate=' + edate +'&wid='+wid+'&cid=' + cid);
    }
</script>
</body>
</html>
