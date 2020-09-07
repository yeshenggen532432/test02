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

<body onload="queryWare()">
<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center',border:false" title="">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'north',border:false" title="查询条件" style="height:60px">
                <div style="width: 970px;">
                    商品名称: <input name="wareNm" id="wareNm" class="easyui-textbox" onkeydown="toQuery(event);"/>
                    大单位条码: <input name="packBarCode" id="packBarCode" class="easyui-textbox"/>
                    小单位条码: <input name="beBarCode" id="beBarCode" class="easyui-textbox"/>
                    商品状态：<select name="status" id="status">
                    <option value="">全部</option>
                    <option value="1">启用</option>
                    <option value="2">不启用</option>
                </select>
                    <input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>
                    <input type="hidden" name="isType" id="isType" value="${isType}"/>
                    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
                </div>
            </div>
            <div data-options="region:'center',border:false" title="数据列表">
                <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
                       url="manager/wareSetPricePage?wtype=${wtype}&isType=${isType}" border="false"
                       rownumbers="true" fitColumns="false" pagination="true"
                       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#gridbar">
                    <thead frozen="true">
                    <th field="wareId" checkbox="true"></th>
                    <th field="wareCode" width="80" align="center">
                        商品编码
                    </th>
                    <th field="wareNm" width="100" align="left">
                        商品名称
                    </th>
                    </thead>
                    <thead>
                    <tr>
                        <th field="waretypeNm"   width="80" align="center" formatter="formatType">
                            所属分类
                        </th>
                        <th field="wareGg" width="80" align="left">
                            规格
                        </th>
                        <th field="wareDw" width="60" align="center">
                            大单位
                        </th>
                        <th field="minUnit" width="100" align="center">
                            小单位
                        </th>
                        <th field="inPrice" width="100" align="center" formatter="formatPrice">
                            <span onclick="operatePrice('inPrice')">大单位采购价✎</span>
                        </th>
                        <th field="wareDj" width="100" align="center"  formatter="formatPrice">
                            <span onclick="operatePrice('wareDj')">大单位批发价✎</span>
                        </th>
                        <th field="lsPrice" width="100" align="center"  formatter="formatPrice">
                            <span onclick="operatePrice('lsPrice')">大单位原价✎</span>
                        </th>
                        <th field="fxPrice" width="100" align="center" hidden="true"  formatter="formatPrice">
                            <span onclick="operatePrice('fxPrice')">大单位分销价✎</span>
                        </th>
                        <th field="cxPrice" width="100" align="center" hidden="true"  formatter="formatPrice">
                            <span onclick="operatePrice('cxPrice')">大单位促销价✎</span>
                        </th>
                        <th field="minInPrice" width="100" align="center"  formatter="formatPrice">
                            <span onclick="operatePrice('minInPrice')">小单位采购价✎</span>
                        </th>
                        <th field="sunitPrice" width="100" align="center"  formatter="formatPrice">
                            <span onclick="operatePrice('sunitPrice')">小单位批发价✎</span>
                        </th>
                        <th field="minLsPrice" width="100" align="center"  formatter="formatPrice">
                            <span onclick="operatePrice('minLsPrice')">小单位原价✎</span>
                        </th>
                        <th field="minFxPrice" width="100" align="center" hidden="true" formatter="formatPrice">
                            <span onclick="operatePrice('minFxPrice')">小单位分销价✎</span>
                        </th>
                        <th field="minCxPrice" width="100" align="center"  hidden="true" formatter="formatPrice">
                            <span onclick="operatePrice('minCxPrice')">小单位促销价✎</span>
                        </th>
                    </tr>
                    </thead>
                </table>
                <div id="gridbar">

                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $("#status").val("1");
    //查询
    function queryWare() {
        $("#datagrid").datagrid('load', {
            url: "manager/wareSetPricePage",
            wareNm: $("#wareNm").val(),
            status: $("#status").val(),
            packBarCode: $('#packBarCode').val(),
            beBarCode: $('#beBarCode').val()
        });
    }


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
            url: "manager/updateWarePrice",
            type: "post",
            data: "id=" + wareId + "&price=" + o.value+"&field="+field,
            success: function (data) {
                if (data == '1') {
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

</script>
</body>
</html>
