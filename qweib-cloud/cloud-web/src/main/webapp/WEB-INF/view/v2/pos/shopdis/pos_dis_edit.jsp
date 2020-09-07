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
    <form action="manager/pos/savePosDisSet" name="BonusSharfrm" id="BonusSharfrm" method="post">
        <input  type="hidden" name="id" id="id" value="${shopRate.id}"/>

        <dl id="dl">

            <dt class="f14 b">促销信息</dt>
            <div class="box" >
                <input type="hidden" id="status" name = "status" value="${shopRate.status}">
                <dd>
                    <span class="title">连锁店*：</span>
                    <tag:select id="shopNo" name="shopNo" displayKey="shop_no" onchange="queryShopRate()" displayValue="shop_name" tableName="pos_shopinfo"/>
                </dd>

                <dd>
                    <span class="title">打折类型*：</span>
                    <select id="rateType" name="rateType" onchange="changeDisType();"  style="width:120px;">
                        <option value="0">全店打折</option>
                        <option value="1">按类型打折</option>
                        <option value="2">按单品打折</option>
                    </select>

                </dd>
                <dd>

                    <div id="chooseTypeDiv" style="display:none;">
                        <span class="title">打折对象：</span>
                    <select id="waretypecomb" class="easyui-combotree" style="width:200px;"
                            data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
						setTypeWare(node.id);
						}"></select>
                    </div>
                    <div id="wareDiv"><span class="title">打折对象：</span>
                    <input class="reg_input" name="objName" id="objName" value="${shopRate.objName}" readonly="readonly"  style="width: 120px"/>
                    <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare();">选择</a>
                    </div>
                    <input type = "hidden" id="objId" name="objId" value="${shopRate.objId}"/>
                </dd>
                <dd>
                    <span class="title">折扣：</span>
                    <input class="reg_input" name="rate" id="rate" value="${shopRate.rate}"  style="width: 120px"/>%

                </dd>
                <dd>
                    <span class="title">特价：</span>
                    <input class="reg_input" name="disPrice" id="disPrice"  value="${shopRate.disPrice}" style="width: 120px"/>

                </dd>

                <dd>
                    <span class="title">开始时间*：</span>
                     <input name="startTimeStr" id="startTimeStr"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});" style="width: 100px;" value="${shopRate.startTimeStr}" readonly="readonly"/>
                    <img onclick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>

                </dd>
                <dd>
                    <span class="title">结束时间*：</span>
                    <input name="endTimeStr" id="endTimeStr"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});" style="width: 100px;" value="${shopRate.endTimeStr}" readonly="readonly"/>
                    <img onclick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>


                </dd>

                <dd>
                    <span class="title">有效否：</span>
                    <input type="checkbox" name="statuscheck" id="statuscheck" />
                </dd>


            </div>

        </dl>
        <div class="f_reg_but">
            <input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
            <input type="button" value="返回" class="b_button" onclick="toback();"/>
        </div>
    </form>
</div>

<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
</div>

<script type="text/javascript">
    function initShow()
    {

        if($("#id").val() > 0)
        {
        $("#shopNo").val(${shopRate.shopNo});
        $("#rateType").val(${shopRate.rateType});

        }
        if($("#rateType").val() == 0)$("#objName").val("全店打折");
        if($("#status").val() == "1")
        {
            $("#statuscheck").prop('checked','true');

        }
        else {

            $("#statuscheck").removeAttr('checked');

        }

    }

    function changeDisType() {
        var distype = $("#rateType").val();
        if(distype == 0)
        {
            $("#chooseTypeDiv").css('display','none');
            $("#wareDiv").css('display','block');
            $("#objName").val("全店打折");
        }
        if(distype == 1)
        {
            $("#chooseTypeDiv").css('display','block');
            $("#wareDiv").css('display','none');
            $("#objName").val("");
        }
        if(distype == 2)
        {
            $("#chooseTypeDiv").css('display','none');
            $("#wareDiv").css('display','block');
            $("#objName").val("");
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

    function toback(){

        //window.parent.$('#editdlg').dialog('close');
        //window.parent.queryMemberType();
        location.href="${base}/manager/pos/toPosShopDisSet";
    }

    function setTypeWare(typeId){
        $("#objId").val(typeId);
    }


    function dialogSelectWare(){

        var shopNos = $("#shopName").val();

        if(shopNos == "")
        {
            alert("请选择门店");
            return;
        }
        if($("#rateType").val() == 0)return ;

        $('#wareDlg').dialog({
            title: '商品选择',
            iconCls:"icon-edit",
            width: 800,
            height: 400,
            modal: true,
            href: "<%=basePath %>/manager/dialogWareType?stkId="+0,
            onClose: function(){
            }
        });
        $('#wareDlg').dialog('open');
    }

    function callBackFun(json){
        var shopNos = $("#shopName").val();
        // var shoprows = $("#datagrid").datagrid("getSelections");
        if(json.list.length> 1)
        {
            alert("只能选择一个商品");
            return;
        }

        $("#objName").val(json.list[0].wareNm);
        $("#objId").val(json.list[0].wareId);
    }

</script>

</body>
</html>
