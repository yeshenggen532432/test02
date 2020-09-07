<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019-04-10
  Time: 11:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
</head>
<body onload="initShow();">

<div class="box">
    <form action="manager/pos/savePosZfbSet" name="BonusSharfrm" id="BonusSharfrm" method="post">
        <input  type="hidden" name="id" id="id" value="${zfbset.id}"/>

        <dl id="dl">

            <dt class="f14 b">支付宝设置</dt>
            <div class="box" >
                <dd>
                    <span class="title">连锁店*：</span>
                    <tag:select id="shopNo" name="shopNo" displayKey="shop_no" onchange="queryZfbset()" displayValue="shop_name" tableName="pos_shopinfo"/>
                </dd>
                <dd>
                    <span class="title">pid：</span>
                    <input class="reg_input" name="pid" id="pid" value="${zfbset.pid}"  style="width:300px"/>

                </dd>
                <dd>
                    <span class="title">appid：</span>
                    <input class="reg_input" name="appid" id="appid" value="${zfbset.appid}"  style="width:300px"/>

                </dd>
                <dd>
                    <span class="title">商户私钥：</span>
                    <input class="reg_input" name="privateKey" id="privateKey" value="${zfbset.privateKey}"  style="width:300px"/>

                </dd>

                <dd>
                    <span class="title">商户公钥：</span>
                    <input class="reg_input" name="publicKey" id="publicKey" value="${zfbset.publicKey}"  style="width:300px"/>

                </dd>

                <dd>
                    <span class="title">支付宝公钥：</span>
                    <input class="reg_input" name="alipayPublicKey" id="alipayPublicKey" value="${zfbset.alipayPublicKey}"  style="width:300px"/>

                </dd>
                <input type="hidden" id="status" name = "status" value="${zfbset.status}">




                <dd>
                    <span class="title">启用支付宝否：</span>
                    <input type="checkbox" name="statuscheck" id="statuscheck" />
                </dd>


            </div>

        </dl>
        <div class="f_reg_but">
            <input type="button" value="保存" class="l_button" onclick="toSubmit();"/>

        </div>
    </form>
</div>


<script type="text/javascript">
    function initShow()
    {

        if($("#id").val() > 0)
        {
            $("#shopNo").val(${shopRate.shopNo});


        }

        if($("#status").val() == "1")
        {
            $("#statuscheck").prop('checked','true');

        }
        else {

            $("#statuscheck").removeAttr('checked');

        }

    }



    function toSubmit(){

        if($("#statuscheck").is(":checked"))$("#status").val(1);
        else $("#status").val(0);
        $("#BonusSharfrm").form('submit',{
            success:function(data){

                if(data== 1){
                    alert("保存成功");
                    toback();
                }else {
                    alert("保存失败");
                    toback();
                }
            }
        });
    }

    function queryZfbset(){
        var shopNo = $("#shopNo").val();
        var index = 0;
        $.ajax({
            url:"manager/pos/queryZfbSet",
            data:"shopNo=" + shopNo,
            type:"post",
            success:function(data){
                if(data){
                    var list = data.rows;
                    if(list.length> 0)
                    {
                        $("#pid").val(list[0].pid);
                        $("#appid").val(list[0].appid);
                        $("#privateKey").val(list[0].privateKey);
                        $("#publicKey").val(list[0].publicKey);
                        $("#alipayPublicKey").val(list[0].alipayPublicKey);
                        if(list[0].status == 1)$("#statuscheck").prop('checked','true');
                    }
                    else
                    {
                        $("#pid").val('');
                        $("#appid").val('');
                        $("#privateKey").val('');
                        $("#publicKey").val('');
                        $("#alipayPublicKey").val('');
                        $("#statuscheck").prop('checked','true');
                    }



                }
            }
        });



    }



</script>

</body>
</html>
