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
    <form action="manager/pos/saveTicketType" name="BonusSharfrm" id="BonusSharfrm" method="post">
        <input  type="hidden" name="id" id="id" value="${ticketType.id}"/>
        <input  type="hidden" name="status" id="status" value="${ticketType.status}"/>

        <input  type="hidden" name="wareType" id="wareType" value="${ticketType.status}"/>
        <dl id="dl">
            <dt class="f14 b">类型信息</dt>

            <dd>
                <span class="title">类型名称：</span>
                <input class="reg_input" name="ticketName" id="ticketName" value="${ticketType.ticketName}" style="width: 120px"/>

            </dd>
            <dd>
                <span class="title">前缀编号：</span>
                <input class="reg_input" name="ticketNo" id="ticketNo" value="${ticketType.ticketNo}" style="width: 120px"/>

            </dd>
            <dd>
                <span class="title">流水号长度：</span>
                <input class="reg_input" name="seqLen" id="seqLen" value="${ticketType.seqLen}" style="width: 120px"/>

            </dd>

            <dd>
                <span class="title">面值：</span>
                <input class="reg_input" name="amt" id="amt" value="${ticketType.amt}" style="width: 120px"/>

            </dd>
            <dd>
                <span class="left_title">限制消费商品类别：</span>
                <select id="waretypecomb" class="easyui-combotree" style="width:200px;"
                        data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
						setTypeWare(node.id);
						}"></select>
            </dd>
            <dd>
                <span class="title">备注：</span>
                <input class="reg_input" name="remarks" id="remarks" value="${ticketType.remarks}" style="width: 120px"/>


            </dd>





        </dl>
        <div class="f_reg_but">
            <input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
            <input type="button" value="返回" class="b_button" onclick="toback();"/>
        </div>
    </form>
</div>

<script type="text/javascript">

    function setTypeWare(typeId){
        $("#wareType").val(typeId);
    }
    function toSubmit(){

        if($("#ticketName").val() == "")
        {
            alert("请输入名称");
            return;
        }



        $("#BonusSharfrm").form('submit',{
            success:function(data){
                if(data=="1"){
                    alert("保存成功");
                    toback();
                }else{
                    alert("操作失败");
                }
            }
        });

    }
    function toback(){
        location.href="${base}/manager/pos/toPosTicketType";
    }










</script>
</body>
</html>

