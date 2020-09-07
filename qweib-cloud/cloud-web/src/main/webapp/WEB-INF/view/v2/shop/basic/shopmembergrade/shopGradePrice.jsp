<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员等级价格设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="gradeName" uglcw-role="textbox" placeholder="等级名称">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
					   	   responsive:['.header',40],
							id:'id',
							pageable: true,
                    		url: '${base}manager/shopMemberGrade/page',
                    		criteria: '.query',
                    	">
                <div data-field="gradeName" uglcw-options="width:100">等级名称</div>
                <div data-field="oper" uglcw-options="width:130, template: uglcw.util.template($('#oper').html())">操作</div>
                <div data-field="status" uglcw-options="width:100,template: uglcw.util.template($('#status').html())">状态
                </div>
                <div data-field="isJxc" uglcw-options="width:100,template: uglcw.util.template($('#isJxc').html())">
                    进销存客户会员使用
                </div>
                <%--<div data-field="isXxzf" uglcw-options="width:100, template: uglcw.util.template($('#isXxzf').html())">线下支付</div>--%>
            </div>
        </div>
    </div>
</div>

<%--启用状态--%>
<script id="status" type="text/x-uglcw-template">
    <span>#= data.status == '1' ? '已启用' : '未启用' #</span>
</script>
<%--进销存客户会员使用--%>
<script id="isJxc" type="text/x-uglcw-template">
    # if(data.isJxc == 1){ #
    是
    # } #
</script>

<script id="oper" type="text/x-uglcw-template">
    <button onclick="javascript:setPrice(#= data.id#,'#=data.gradeName#');" class="k-button k-info">设置商品价格</button>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })


    //-----------------------------------------------------------------------------------------

    //设置商品价格
    function setPrice(id, gradeName) {
        uglcw.ui.openTab("等级价格设置_" + gradeName,"${base}manager/shopMemberGrade/gradePriceWaretype?gradeId=" + id);
    }


</script>
</body>
</html>
