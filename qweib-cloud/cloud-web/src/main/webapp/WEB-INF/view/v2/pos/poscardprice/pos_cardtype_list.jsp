<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员类型价格设置-会员类型列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <%--2右边：表格start--%>
        <div class="layui-col-md12">
            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                            responsive:['.header',40],
						    <%--toolbar: kendo.template($('#toolbar').html()),--%>
							id:'id',
							pageable: true,
                    		url: '${base}manager/pos/queryMemberType',
                    		criteria: '.query',
                    	">
                        <div data-field="typeName" uglcw-options="width:100">会员类型名称</div>
                        <div data-field="oper" uglcw-options="width:500,template: uglcw.util.template($('#oper').html())">操作</div>
                    </div>
                </div>
            </div>
            <%--表格：end--%>
        </div>
        <%--2右边：表格end--%>
    </div>
</div>


<script id="oper" type="text/x-uglcw-template">
    <button onclick="javascript:setWarePrice(#= data.id#,'#=data.typeName#');" class="k-button k-info">设置商品价格</button>
    <button onclick="javascript:showMembers(#= data.id#,'#=data.typeName#');" class="k-button k-info">会员信息列表</button>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.ui.loaded();
    })



    //-----------------------------------------------------------------------------------------

    function showMembers(id,name){
        uglcw.ui.openTab(name+"_会员列表","${base}manager/pos/toPosMemberByType?memberType="+id)
    }

    function setWarePrice(id,name){
        uglcw.ui.openTab(name+"_设置商品价格","${base}manager/pos/toPosMemberTypePriceEdit?memberType="+id)
    }


</script>
</body>
</html>
