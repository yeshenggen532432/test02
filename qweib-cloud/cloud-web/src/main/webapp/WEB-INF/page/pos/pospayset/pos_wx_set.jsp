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
    <form action="manager/pos/savePosWxSet" name="BonusSharfrm" id="BonusSharfrm" method="post">
        <input  type="hidden" name="id" id="id" value="${wxset.id}"/>

        <dl id="dl">

            <dt class="f14 b">微信支付设置</dt>
            <div class="box" >
                <dd>
                    <span class="title">连锁店*：</span>
                    <tag:select id="shopNo" name="shopNo" displayKey="shop_no" onchange="queryWxset()" displayValue="shop_name" tableName="pos_shopinfo"/>
                </dd>
                <dd>
                    <span class="title">appid：</span>
                    <input class="reg_input" name="appid" id="appid" value="${wxset.appid}"  style="width:300px"/>

                </dd>
                <dd>
                    <span class="title">商户号：</span>
                    <input class="reg_input" name="mchId" id="mchId" value="${wxset.mchId}"  style="width:300px"/>

                </dd>

                <dd>
                    <span class="title">Key：</span>
                    <input class="reg_input" name="wxkey" id="wxkey" value="${wxset.wxkey}"  style="width:300px"/>

                </dd>

                <dd>
                    <span class="title">分商户号：</span>
                    <input class="reg_input" name="subMchId" id="subMchId" value="${wxset.subMchId}"  style="width:300px"/>

                </dd>
                <input type="hidden" id="status" name = "status" value="${wxset.status}">




                <dd>
                    <span class="title">启用微信支付否：</span>
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

    function queryWxset(){
        var shopNo = $("#shopNo").val();
        var index = 0;
        $.ajax({
            url:"manager/pos/queryWxSet",
            data:"shopNo=" + shopNo,
            type:"post",
            success:function(data){
                if(data){
                    var list = data.rows;
                    if(list.length> 0)
                    {
                        $("#id").val(list[0].id);
                        $("#appid").val(list[0].appid);
                        $("#mchId").val(list[0].mchId);
                        $("#wxkey").val(list[0].wxkey);
                        $("#subMchId").val(list[0].subMchId);
                        if(list[0].status == 1)$("#statuscheck").prop('checked','true');
                    }
                    else
                    {
                        $("#id").val(0);
                        $("#appid").val('');
                        $("#mchId").val('');
                        $("#wxkey").val('');
                        $("#subMchId").val('');
                        $("#statuscheck").prop('checked','true');
                    }



                }
            }
        });



    }



</script>

</body>
</html>
