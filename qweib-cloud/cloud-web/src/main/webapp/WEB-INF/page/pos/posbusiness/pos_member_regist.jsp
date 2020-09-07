<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>
    <%@include file="/WEB-INF/page/include/source.jsp"%>
</head>
<body>

<div class="box">
    <form action="manager/pos/posMemberRegist" name="BonusSharfrm" id="BonusSharfrm" method="post">
        <input  type="hidden" name="id" id="id" value="${bc.id}"/>
        <dl id="dl">
            <dt class="f14 b">会员信息</dt>
            <div class="box" >
            <dd>
                <span class="title">卡类型*：</span>
                <tag:select id="cardTypeSel" name="cardType" displayKey="id" onchange="chooseCardType();" headerValue="请选择卡类型" headerKey="0" displayValue="type_name" tableName="shop_member_type"/>
            </dd>
            <dd>
                <span class="title">卡号*：</span>
                <input class="reg_input" name="cardNo" id="cardNo"  style="width: 120px"/>

            </dd>
            <dd>
                <span class="title">工本费：</span>
                <input class="reg_input" name="cardCost" id="cardCost"  style="width: 120px"/>

            </dd>

            <dd>
                <span class="title">有效期：</span>
                <input class="reg_input" name="activeDate" id="activeDate"  style="width: 120px"/>

            </dd>
            <dd>
                <span class="title">底金：</span>
                <input class="reg_input" name="inputCash" id="inputCash"  style="width: 120px"/>

            </dd>
            <dd>
                <span class="title">赠送金额：</span>
                <input class="reg_input" name="freeCost" id="freeCost"  style="width: 120px"/>

            </dd>
            </div>
            <div class="box" >
                <dd>
                    <span class="title">姓名*：</span>
                    <input class="reg_input" name="name" id="name"  style="width: 120px"/>

                </dd>
                <dd>
                    <span class="title">性别：</span>
                    <select id="sex" name="sex" >
                        <option value="男">男</option>
                        <option value="女">女</option>

                    </select>

                </dd>
                <dd>
                    <span class="title">电话*：</span>
                    <input class="reg_input" name="mobile" id="mobile"  style="width: 120px"/>

                </dd>
                <dd>
                    <span class="title">生日：</span>
                    <input type="text" id="month" name="month" style="width:50px;">月 &nbsp;&nbsp;
                    <input type="text" id="day" name="day" style="width:50px;"/>	日
                </dd>
                <dd>
                    <span class="title">地址：</span>
                    <input class="reg_input" name="address" id="address"  style="width: 300px"/>

                </dd>
            </div>

            <input type="hidden" id = "cashPay" name = "cashPay" />
            <input type="hidden" id = "bankpay" name = "bankpay" />
            <input type="hidden" id = "wxPay" name = "wxPay" />
            <input type="hidden" id = "zfbPay" name = "zfbPay" />



        </dl>
        <div class="f_reg_but">
            <input type="button" value="发卡" class="l_button" onclick="registClick();"/>

        </div>
    </form>
</div>

<div id="dlg" closed="true" class="easyui-dialog" title="支付方式" style="width:400px;height:200px;padding:10px"
     data-options="
				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						toSubmit();
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
            支付方式: <select name="payTypeSel" id="payTypeSel">
            <option value="">请选择支付方式</option>
            <option value="现金">现金</option>
            <option value="银行卡">银行卡</option>
            <option value="微信支付">微信支付</option>
            <option value="支付宝">支付宝</option>

        </select>
        </dd>

    </div>




</div>

<script type="text/javascript">

    function initShow()
    {
    $("#dateUnit").val(${memberType.dateUnit});

    function registClick()
    {
        if($("#cardNo").val()== "")
        {
            alert("请输入卡号");
            return;
        }
        if($("#cardTypeSel").val() == ""||$("#cardTypeSel").val() == "0")
        {
            alert("请选择卡类型");
            return;
        }
        if($("#name").val() == "")
        {
            alert("请输入姓名");
            return;
        }
        if($("#mobie").val() == "")
        {
            alert("请输入电话");
            return;
        }
        var inputCash = $("#inputCash").val();
        var cardCost = $("#cardCost").val();
        if(inputCash > 0||cardCost> 0)
        {
            $('#dlg').dialog('open');
        }
        else
        {
            toSubmit();
        }
    }

    function chooseCardType() {
        var cardType = $("#cardTypeSel").val();
        $.ajax({
            url:"manager/pos/getMemberTypeById",
            data:"id=" + cardType,
            type:"post",
            success:function(data){
                if(data){
                    var list = data.rows;
                    if(list.length> 0)
                    {
                        $("#cardCost").val(list[0].cost);
                        $("#inputCash").val(list[0].inputCash);
                        $("#freeCost").val(list[0].freeCost);
                        $("#activeDate").val(list[0].cardDate);
                    }

                }
            }
        });
    }

    function choosePayType()
    {
        var needPay = $("#inputCash").val() + 0;
        var cardCost = $("#cardCost").val() + 0;
        needPay = needPay + cardCost;
        $("#cashPay").val(0);
        $("#bankPay").val(0);
        $("#wxPay").val(0);
        $("#zfbPay").val(0);
        if($("#payTypeSel").val() == "现金")
        $("#cashPay").val(needPay);
        if($("#payTypeSel").val() == "银行卡")
            $("#bankPay").val(needPay);
        if($("#payTypeSel").val() == "微信支付")
            $("#wxPay").val(needPay);
        if($("#payTypeSel").val() == "支付宝")
            $("#zfbPay").val(needPay);
        toSubmit();

    }

    function toSubmit(){
        if($("#cardNo").val()== "")
        {
            alert("请输入卡号");
            return;
        }
        if($("#cardTypeSel").val() == ""||$("#cardTypeSel").val() == "0")
        {
            alert("请选择卡类型");
            return;
        }
        if($("#name").val() == "")
        {
            alert("请输入姓名");
            return;
        }
        if($("#mobie").val() == "")
        {
            alert("请输入电话");
            return;
        }

        if ($.formValidator.pageIsValid()==true){
            $("#BonusSharfrm").form('submit',{
                success:function(data){
                    if(data.state){
                        alert("注册成功");

                    }else{
                        alert("操作失败");
                    }
                }
            });
        }
    }
    function toback(){
        location.href="${base}/manager/bc/toBaseBc";
    }
    $(function(){
        $.formValidator.initConfig();

        $("#cardNo").formValidator({onShow:"请输入(20个字以内)",onFocus:"请输入(2个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(20个字以内)"});
        $("#name").formValidator({onShow:"请输入(20个字以内)",onFocus:"请输入(2个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(20个字以内)"});
        $("#mobile").formValidator({onShow:"请输入(20个字以内)",onFocus:"请输入(2个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(20个字以内)"});



    });




</script>
</body>
</html>

