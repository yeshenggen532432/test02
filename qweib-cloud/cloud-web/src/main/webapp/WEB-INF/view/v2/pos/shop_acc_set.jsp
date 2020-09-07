<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
</head>
<body>

<div class="box">
    <form action="manager/pos/savePosAccSet" name="BonusSharfrm" id="BonusSharfrm" method="post">
        <input  type="hidden" name="id" id="id" value="${acc.id}"/>
        <input type="hidden" name="shopNo" id="shopNo" value="9999">
        <dl id="dl">
            <dt class="f14 b">商城收款账户设置</dt>

            <dd>
                <span class="title">现金支付账号：</span>
                <tag:select name="cashAccId" id="cashAccId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--选择账号--" displayKey="id" displayValue="acc_no" value="${acc.cashAccId}"/>

            </dd>
            <dd>
                <span class="title">银行卡支付账号：</span>
                <tag:select name="bankAccId" id="bankAccId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--选择账号--" displayKey="id" displayValue="acc_no" value="${acc.bankAccId}"/>

            </dd>


            <dd>
                <span class="title">余额支付账号：</span>
                <tag:select name="memberAccId" id="memberAccId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--选择账号--" displayKey="id" displayValue="acc_no" value="${acc.memberAccId}"/>

            </dd>

            <dd>
                <span class="title">微信支付账号：</span>
                <tag:select name="wxAccId" id="wxAccId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--选择账号--" displayKey="id" displayValue="acc_no" value="${acc.wxAccId}"/>

            </dd>

            <dd>
                <span class="title">支付宝支付账号：</span>
                <tag:select name="zfbAccId" id="zfbAccId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--选择账号--" displayKey="id" displayValue="acc_no" value="${acc.zfbAccId}"/>

            </dd>





        </dl>
        <div class="f_reg_but">
            <input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
            <input type="button" value="返回" class="b_button" onclick="toback();"/>
        </div>
    </form>
</div>

<script type="text/javascript">

    function toSubmit(){




        $("#BonusSharfrm").form('submit',{
            success:function(data){
                if(data=="1"){
                    alert("保存成功");

                }else{
                    alert("操作失败");
                }
            }
        });

    }





</script>
</body>
</html>

