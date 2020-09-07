<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>月结处理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <script src="<%=basePath %>/resource/stkstyle/js/Map.js" type="text/javascript" charset="utf-8"></script>
    <style>
        tr {
            background-color: #FFF;
            height: 35px;
            vertical-align: middle;
            padding: 3px;
        }
        td {
            padding-left: 10px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body full" uglcw-role="resizable" uglcw-options="responsive:['.header', 75]" id="container">
                <input  type="hidden" name="id" id="id" value="${shop.id}"/>
                <input  type="hidden" name="canInput" id="canInput" value="${shop.canInput}"/>
                <input  type="hidden" name="canCost" id="canCost" value="${shop.canCost}"/>
                <table width="600px" border="0"  cellpadding="0" cellspacing="1" style="margin-top: 30px;margin-left: 10px">
                    <tr>
                        <td style="width: 100px;text-align: center">月结月份：</td>
                        <td colspan="2">
                            <input type="text" id="yymm" value="${curYm}"  style="width: 100px;"  readonly="readonly">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 100px;text-align: center">开始日期：</td>
                        <td colspan="2">
                            <input name="sdate" id="sdate"  style="width: 100px;" value="${sdate}"
                                   readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 100px;text-align: center">结束日期：</td>
                        <td colspan="2">
                            <input name="edate" id="edate"  style="width: 100px;" value="${edate}"
                                   readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <button id="monthBlance" style="margin-left:100px;margin-top: 10px" uglcw-role="button" class="k-button k-info">开始月结</button>
                        </td>
                    </tr>
            </table>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>


<%--var msg = "当前月结区间有"+"<br/>-------------------";--%>
<%--msg=msg+"<br/>待收货:"+comeSize+"&nbsp;<a href='javascript:;;' onclick='toDealBills(\"0\",\"CGFP\")'>处理</a>";--%>
<%--msg=msg+"<br/>待发货:"+sendSize+"&nbsp;<a href='javascript:;;' onclick='toDealBills(\"0\",\"XSFP\")'>处理</a>";--%>
<%--msg=msg+"&nbsp;<br/>暂存单据："+drageSize+"<a href='javascript:;;' onclick='toDealBills(\"-2\",\"\")'>处理</a>";--%>
<%--msg=msg+"<br/><a href='javascript:;;' onclick='toDealBills(\"\",\"\")'>全部处理</a>";--%>

<script type="text/x-uglcw-template" id="bill-dialog">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                    <table width="100%" border="0"  cellpadding="0" cellspacing="1" style="margin-left:5px">
                        <tr>
                            <td style="width: 80px;text-align: right">待收货:</td>
                            <td> <span id="comeSize">0</span></td>
                            <td colspan="2">
pc
                                <a role="button" href="javascript:toDealBills('0','CGFP');"
                                   class="k-button k-button-icontext" style="color:deepskyblue">
                                    <span ></span>去处理
                                </a>
                                <a role="button" href="javascript:oneKeyCancel('0','CGFP','1');"
                                   class="k-button k-button-icontext" style="color: deepskyblue">
                                    <span ></span>一键作废
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px;text-align: right">待发货:</td>
                            <td> <span id="sendSize">0</span></td>
                            <td colspan="2">
                                <a role="button" href="javascript:toDealBills('0','XSFP');"
                                   class="k-button k-button-icontext" style="color: deepskyblue">
                                    <span ></span>去处理
                                </a>
                                <a role="button" href="javascript:oneKeyCancel('0','XSFP','2');"
                                   class="k-button k-button-icontext" style="color: deepskyblue">
                                    <span ></span>一键作废
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px;text-align: right">暂存单据:</td>
                            <td><span id="drageSize">0</span></td>
                            <td colspan="2">
                                <a role="button" href="javascript:toDealBills(-2,'');"
                                   class="k-button k-button-icontext" style="color: deepskyblue">
                                    <span ></span>去处理
                                </a>
                                <a role="button" href="javascript:oneKeyCancel(-2,'','3');"
                                   class="k-button k-button-icontext" style="color: deepskyblue">
                                    <span ></span>一键作废
                                </a>
                            </td>
                        </tr>
                    </table>
            </div>
        </div>
    </div>
</script>




<script type="text/javascript">
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get("#monthBlance").on("click",function () {
            checkMonth();
        });
        uglcw.ui.loaded()
    })

    var win ;
    function checkMonth() {

        if($("#yyyymm").val() == "")
        {
            uglcw.ui.info("请选择月份");
            return false;
        }
        if($("#sdate").val() == "")
        {
            uglcw.ui.info("请选择开始日期");
            return false;
        }
        if($("#edate").val() == "")
        {
            uglcw.ui.info("请选择截至日期");
            return false;
        }
        $.ajaxSettings.async = false;
        var size =  checkJxcBill();
        if(size>0){
            var drageSize =  map.get("drageSize");
            var comeSize =  map.get("comeSize");
            var sendSize = map.get("sendSize");
            if(drageSize==0){
                if(window.confirm("有待收货/待发货单据未处理完，是否去处理")){
                    win = uglcw.ui.Modal.open({
                        title: '月年结概况',
                        content: $('#bill-dialog').html(),
                        width: 450,
                        btns: ['继续月结','关闭'],
                        success: function (container) {
                            $("#drageSize").text(drageSize);
                            $("#comeSize").text(comeSize);
                            $("#sendSize").text(sendSize);
                            uglcw.ui.init($(container));
                        },
                        yes: function (container) {
                            if($("#drageSize").text()!=0){
                                uglcw.ui.info("暂存单据未处理完，不能月结!");
                                return false;
                            }
                            uglcw.ui.Modal.close(win);
                            checkAgain();

                        }
                    })
                    //uglcw.ui.info(msg);
                }else{
                    checkAgain();
                }
            }else{
                win = uglcw.ui.Modal.open({
                    title: '月年结概况',
                    content: $('#bill-dialog').html(),
                    width: 450,
                    btns: ['继续月结','关闭'],
                    success: function (container) {
                        $("#drageSize").text(drageSize);
                        $("#comeSize").text(comeSize);
                        $("#sendSize").text(sendSize);
                        uglcw.ui.init($(container));
                    },
                    yes: function (container) {
                        if($("#drageSize").text()!=0){
                            uglcw.ui.info("暂存单据未处理完，不能月结!");
                            return false;
                        }
                        uglcw.ui.Modal.close(win);
                        checkAgain();
                    }
                })
                //uglcw.ui.info(msg);
            }
            return false;
        }
        checkAgain();
    }

    function checkAgain() {
        var path = "manager/stkmonth/checkNeedProc";
        $.ajax({
            url: path,
            type: "POST",
            data : {"startDate":$("#sdate").val(),"endDate":$("#edate").val() ,"yymm":$("#yymm").val()},
            dataType: 'json',
            async : false,
            success: function (json) {
                if(json.state){
                    if(json.ret == 1)
                    {
                        uglcw.ui.confirm('系统发现之前有未结算的月份，是否自动月结？', function () {
                            toSubmit();
                        });
                    }
                    else
                    {
                        toSubmit();
                    }
                }
            }
        });
    }
    
    function toDealBills(status,billType) {
        var sdate=$("#sdate").val();
        var edate=$("#edate").val();
        var url = '${base}manager/toJxcBillForMonthBalanceRpt?dataTp=1&sdate=' + sdate + "&edate=" + edate;
        if(billType!=""){
            url+="&billType="+billType;
        }
        if(status!=""){
            url+="&status="+status;
        }

        uglcw.ui.openTab('待处理业务单据',url);
    }
    
    function toSubmit(){

        if($("#yyyymm").val() == "")
        {
            uglcw.ui.info("请选择月份");
            return false;
        }
        if($("#sdate").val() == "")
        {
            uglcw.ui.info("请选择开始日期");
            return false;
        }
        if($("#edate").val() == "")
        {
            uglcw.ui.info("请选择截至日期");
            return false;
        }
        $.ajaxSettings.async = false;
        var path = "manager/stkmonth/monthProc";
        $.ajax({
            url: path,
            type: "POST",
            data : {"startDate":$("#sdate").val(),"endDate":$("#edate").val() ,"yymm":$("#yymm").val()},
            dataType: 'json',
            async : false,
            success: function (json) {
                if(json.state){
                    uglcw.ui.info("月结成功");
                    setTimeout(function () {
                        uglcw.ui.closeCurrentTab();
                    }, 1000);
                }
                else
                {
                    uglcw.ui.info(json.msg);
                }
            }
        });
    }
    function getMonthDate() {
        var yyyymm = $("#yyyymm").val();
        if(yyyymm== "")return;
        var path = "manager/stkmonth/getMonthDate";
        $.ajax({
            url: path,
            type: "POST",
            data : {"yymm":yyyymm},
            dataType: 'json',
            async : false,
            success: function (json) {
                if(json.state){
                    $("#sdate").val(json.sdate);
                    $("#edate").val(json.edate);
                }
                else
                {
                }
            }
        });
    }


    function oneKeyCancel(status,billType,index){
        var sdate=$("#sdate").val();
        var edate=$("#edate").val();
        var data={
            sdate:sdate,
            edate:edate,
            billType:billType,
            status:status
        }
        if(window.confirm("是否确定作废!")) {
            $.ajax({
                url: "<%=basePath%>/manager/stkMonthBillCancel/cancelBills",
                type: "POST",
                data: data,
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.info("一键作废成功!");
                        if(index=='1'){
                            $("#comeSize").val(0);
                        }else if(index=='2'){
                            $("#sendSize").val(0);
                        }else if(index=='3'){
                            $("#drageSize").val(0);
                        }
                    }
                }
            });
        }
    }

    var map = new Map();
    /**
     * 校验进销存单据是否都处理完成
     * @author guojr
     */
    function checkJxcBill(){
        var sdate = $("#sdate").val();
        var edate =$("#edate").val();
        map = new Map();
        var k = 0;
        $.ajax({
            url: "${base}/manager/jxcBillForMonthBalanceDatas",
            type: "POST",
            data : {"sdate":sdate,"edate":edate},
            dataType: 'json',
            async : false,
            success: function (json) {
                if(json.state){
                    var drageSize =json.drageSize;
                    var comeSize =json.comeSize;
                    var sendSize =json.sendSize;
                    map.put("drageSize",drageSize);
                    map.put("comeSize",comeSize);
                    map.put("sendSize",sendSize);
                    var size = drageSize+comeSize+sendSize;
                    k = size;
                }
            }
        });
        return k;
    }
    if($("#canInput").val() == 1)$("#chkInput").attr("checked","checked");
    else $("#chkInput").attr("checked",false);
    if($("#canCost").val() == 1)$("#chkCost").attr("checked","checked");
    else $("#chkCost").attr("checked",false);

</script>
</body>
</html>
