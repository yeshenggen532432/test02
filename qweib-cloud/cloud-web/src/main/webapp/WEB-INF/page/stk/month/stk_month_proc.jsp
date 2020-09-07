<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
</head>
<body>

<div class="box">
    <form action="manager/pos/savePosShopInfo" name="BonusSharfrm" id="BonusSharfrm" method="post">
        <input  type="hidden" name="id" id="id" value="${shop.id}"/>
        <input  type="hidden" name="canInput" id="canInput" value="${shop.canInput}"/>
        <input  type="hidden" name="canCost" id="canCost" value="${shop.canCost}"/>
        <dl id="dl">
            <dt class="f14 b">月结信息</dt>
            <dd>
                <span class="title" >年月：</span>
                <input type="text" id="yymm" value="${curYm}"  readonly="readonly">
            </dd>


            <dd>
                <span class="title" >开始日期：</span> <input name="sdate" id="sdate"  style="width: 100px;" value="${sdate}"
                           readonly="readonly"/>

            </dd>
            <dd>
                <span class="title" >结束日期：</span> <input name="edate" id="edate"  style="width: 100px;" value="${edate}"
                       readonly="readonly"/>


            </dd>





        </dl>
        <div class="f_reg_but">
            <a class="easyui-linkbutton" iconCls="icon-add" plain="false" href="javascript:checkMonth();">开始月结</a>

        </div>
    </form>
</div>

<script type="text/javascript">

    function checkMonth() {

        if($("#yyyymm").val() == "")
        {
            alert("请选择月份");
            return;
        }
        if($("#sdate").val() == "")
        {
            alert("请选择开始日期");
            return;
        }
        if($("#edate").val() == "")
        {
            alert("请选择截至日期");
            return;
        }

        $.ajaxSettings.async = false;
       /* var size =  checkJxcBill();
        if(size>0){
            if(window.confirm("当前月结区间有未处理完的单据，去处理!")){
                var sdate=$("#sdate").val();
                var edate=$("#edate").val();
                parent.add("待处理业务单据","${base}/manager/toJxcBillForMonthBalanceRpt?sdate="+sdate+"&edate="+edate);
            }
            return;
        }*/

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
                        $.messager.confirm('确认', '系统发现之前有未结算的月份，是否自动月结?',function(r) {
                            if (r) {
                                toSubmit();
                            }
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

    function toSubmit(){

        if($("#yyyymm").val() == "")
        {
            alert("请选择月份");
            return;
        }
        if($("#sdate").val() == "")
        {
            alert("请选择开始日期");
            return;
        }
        if($("#edate").val() == "")
        {
            alert("请选择截至日期");
            return;
        }

        $.ajaxSettings.async = false;
        /*var size =  checkJxcBill();
        if(size>0){
            if(window.confirm("当前月结区间有未处理完的单据，去处理!")){
                var sdate=$("#sdate").val();
                var edate=$("#edate").val();
                parent.add("待处理业务单据","${base}/manager/toJxcBillForMonthBalanceRpt?sdate="+sdate+"&edate="+edate);
            }
            return;
        }*/

        var path = "manager/stkmonth/monthProc";
        $.ajax({
            url: path,
            type: "POST",
            data : {"startDate":$("#sdate").val(),"endDate":$("#edate").val() ,"yymm":$("#yymm").val()},
            dataType: 'json',
            async : false,
            success: function (json) {
                if(json.state){

                    alert("月结成功");
                    window.location.reload();
                }
                else
                {

                    alert(json.msg);
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

    /**
     * 校验进销存单据是否都处理完成
     * @author guojr
     */
    function checkJxcBill(){
        var sdate = $("#sdate").val();
        var edate =$("#edate").val();
        var k = 0;
        $.ajax({
            url: "${base}/manager/jxcBillForMonthBalanceRpt",
            type: "POST",
            data : {"sdate":sdate,"edate":edate,"page":1,"rows":2},
            dataType: 'json',
            async : false,
            success: function (json) {
                if(json.state){
                    var size = json.rows.length;
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

