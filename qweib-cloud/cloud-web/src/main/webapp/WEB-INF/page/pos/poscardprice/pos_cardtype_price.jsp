<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>

<body class="easyui-layout" fit="true" >
<div data-options="region:'west',split:true,title:'商品分类树'"
     style="width:150px;padding-top: 5px;">
    <ul id="waretypetree" class="easyui-tree"
        data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
					queryShopWare(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
    </ul>
</div>

<div data-options="region:'center',border:false" title="数据列表">
                <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
                       url="" border="false"
                       rownumbers="true" fitColumns="false" pagination="true"
                       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
                    <thead>
                    <th field="wareId" checkbox="true"></th>
                    <th field="wareCode" width="80" align="center">
                        商品编码
                    </th>
                    <th field="wareNm" width="200" align="left">
                        商品名称
                    </th>

                        <th field="wareDw" width="60" align="center">
                            大单位
                        </th>
                        <th field="minUnit" width="100" align="center">
                            小单位
                        </th>
                        <th field="posPrice1" width="100" align="center" formatter="formatPrice">
                            <span onclick="operatePrice('posPrice1')">大单位零售价✎</span>
                        </th>
                        <th field="posPrice2" width="100" align="center"  formatter="formatPrice">
                            <span onclick="operatePrice('posPrice2')">小单位零售价✎</span>
                        </th>


                    </thead>
                </table>
    <div id="tb" style="padding:5px;height:auto">

        会员类型:<input name="typeName" id="typeName" style="width:120px;height: 20px;" value="${typeName}" readonly="readonly"/>
        连锁店:
        <tag:select id="shopName" name="shopName" displayKey="shop_no" onchange="queryShopWare(0)" displayValue="shop_name" tableName="pos_shopinfo"/>
        商品名称：<input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
        <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryShopWare(0);">查询</a>
        <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:importPrice();">导入批发价</a>
        <input type="hidden" id="memberType" value="${memberType}">
    </div>
</div>


<script type="text/javascript">
    $("#status").val("1");

    //查询
    function  queryShopWare(waretype) {
        ///alert($("#memberType").val());
        $('#datagrid').datagrid({
            url:"manager/pos/queryMemberTypePrice",
            queryParams:{
                wareNm: $("#wareNm").val(),
                shopNo: $("#shopName").val(),
                memberType: $('#memberType').val(),
                wareType:waretype

            }

        });

    }
    queryShopWare(0);


    function reloadware() {
        $("#datagrid").datagrid("reload");
    }


    function formatType(val, row, index) {
        return row.waretypeNm;
    }

    function formatPrice(val,row,index) {
        if (val == undefined || val== "undefined") {
            val = 0.0;
        }
        return "<input class="+this.field+"_imput"+" type='text' style='display:none' size='7' onclick='gjr_CellClick(this)' onchange='changePrice(this,\""+this.field+"\",\"" + row.wareId + "\")' name="+this.field+"_input"+" value='" + val + "'/><span class="+this.field+"_span"+" id="+this.field+"_span_"+row.wareId+">" + val + "</span>";
    }

    function changePrice(o,field,wareId){
        $.ajax({
            url: "manager/pos/saveMembertypePrice",
            type: "post",
            data: "wareId=" + wareId + "&" + field + "=" + o.value+"&shopNo="+$("#shopName").val() + "&memberType=" + $("#memberType").val(),
            success: function (data) {
                if (data.state) {
                    $("#"+field+"_span_"+wareId).text(o.value);
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function operatePrice(field) {
        var display =$("."+field+"_imput").css('display');
        if(display == 'none'){
            $("."+field+"_imput").show();
            $("."+field+"_span").hide();
        }else{
            $("."+field+"_imput").hide();
            $("."+field+"_span").show();
        }
    }

    function gjr_CellClick(o) {
        o.select();
    }

    function importPrice() {
        var flag = 0;
        var shopNo= $("#shopName").val();
        var memberType= $('#memberType').val();
        $.ajax({
            url: "manager/pos/importBatPrice",
            type: "post",
            data:{
                "shopNo":shopNo,
                "memberType":memberType

            },
            success: function (data) {
                if (data.state) {
                    alert("导入成功");
                    queryShopWare(0);
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });

    }

</script>
</body>
</html>
