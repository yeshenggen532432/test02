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
</head>
<body onload="initShow();">

<div class="box">
    <form action="manager/pos/saveMemberType" name="BonusSharfrm" id="BonusSharfrm" method="post">
        <input  type="hidden" name="id" id="id" value="${memberType.id}"/>
        <input type="hidden" name="status" id ="status" value="${memberType.id}">
        <dl id="dl">
            <div class="box" >

                <dd>
                    <span class="title">类型名称*：</span>
                    <input class="reg_input" name="typeName" id="typeName" value="${memberType.typeName}"  style="width: 120px"/>

                </dd>
                <dd>
                    <span class="title">有效期：</span>
                    <input class="reg_input" name="dayLong" id="dayLong"  style="width: 50px"/>
                    <select id="dateUnit" name="dateUnit" >
                        <option value="0">无限期</option>
                        <option value="1">天</option>
                        <option value="2">周</option>
                        <option value="3">月</option>
                        <option value="4">年</option>
                    </select>

                </dd>
                <dd>
                    <span class="title">前缀：</span>
                    <input class="reg_input" name="prefix" id="prefix" value="${memberType.prefix}"  style="width: 120px"/>

                </dd>
                <dd>
                    <span class="title">工本费：</span>
                    <input class="reg_input" name="cost" id="cost"  value="${memberType.cost}" style="width: 120px"/>

                </dd>

                <dd>
                    <span class="title">底金：</span>
                    <input class="reg_input" name="inputCash" id="inputCash" value="${memberType.inputCash}"  style="width: 120px"/>

                </dd>
                <dd>
                    <span class="title">赠送金额：</span>
                    <input class="reg_input" name="freeCost" id="freeCost"  value="${memberType.freeCost}" style="width: 120px"/>

                </dd>
                <dd>
                    <span class="title">有效期类型：</span>
                    <select id="dateType" name="dateType" >
                        <option value="0">超期无法消费</option>
                        <option value="1">超期无法打折</option>
                    </select>

                </dd>

                <dd>
                    <span class="title">卡介质：</span>
                    <select id="icType" name="icType" >
                        <option value="0">磁卡</option>
                        <option value="1">IC卡</option>
                        <option value="2">M1卡</option>
                    </select>

                </dd>
                <dd>
                    <span class="title">折扣：</span>
                    <input class="reg_input" name="discount" id="discount" value = "${memberType.discount}"  style="width: 110px"/>%

                </dd>
                <dd>
                    <span class="title">店员发行：</span>
                    <select id="newCard" name="newCard" >
                        <option value="0">店员可以发行</option>
                        <option value="1">店员不可发行</option>
                    </select>

                </dd>
                <dd>
                    <span class="title">修改金额：</span>
                    <select id="modifyAmt" name="modifyAmt" >
                        <option value="0">充值金额可修改</option>
                        <option value="1">充值金额不可修改</option>
                    </select>

                </dd>
                <dd>
                    <span class="title">挂失：</span>
                    <select id="hanged" name="hanged" >
                        <option value="0">可挂失</option>
                        <option value="1">不可挂失</option>
                    </select>

                </dd>

                <dd>
                    <span class="title">卡通用：</span>
                    <select id="shopShare" name="shopShare" >
                        <option value="0">通用</option>
                        <option value="1">连锁店</option>
                        <option value="2">加盟店</option>
                    </select>

                </dd>

            </div>

        </dl>

    </form>
</div>

<script type="text/javascript">
    function initShow()
    {
        $("#dateUnit").val(${memberType.dateUnit});
        $("#dateType").val(${memberType.dateType});
        $("#icType").val(${memberType.icType});
        $("#newCard").val(${memberType.newCard});
        $("#modifyAmt").val(${memberType.modifyAmt});
        $("#hanged").val(${memberType.hanged});
        $("#shopShare").val(${memberType.shopShare});
    }

    function toSubmit(){
        var typeName=$("#typeName").val();

        if(!typeName){
            alert("类型名称不能为空");
            return;
        }

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

    function toback(){

        window.parent.$('#editdlg').dialog('close');
        window.parent.queryMemberType();
    }

</script>

</body>
</html>
