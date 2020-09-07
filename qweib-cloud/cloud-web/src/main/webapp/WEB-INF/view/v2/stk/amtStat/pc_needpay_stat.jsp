<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>付款统计</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" uglcw-role="textbox" value="0" id="all">

                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="inType" placeholder="入库类型">
                        <option value="">全部</option>
                        <option value="采购入库">采购入库</option>
                        <option value="其它入库">其它入库</option>
                        <option value="销售退货">销售退货</option>
                    </select>
                </li>
                <li style="width: 400px;">
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="searchAll" uglcw-role="button" class="k-button k-info">查询所有</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
				    align: 'center',
                    dblclick: function(row){
                    	 var q = uglcw.ui.bind('.query');
                    	 if(uglcw.ui.get('#all').value()>0){
                    	 delete q['edate'];
                    	 }
                    	 q.ioType = q.inType;
                         uglcw.ui.openTab('供应商应付款统计', '${base}manager/toNeedPayUnitStat?'+ $.map(q, function(v, k){
                         	return k+'='+ (v || '');
                         }).join('&'));
                    },
                    query:function(param){
                    	if(uglcw.ui.get('#all').value()> 0){
                    		param.edate = '';
                    		param.outType = '';
                    	}
                    	return param;
                    },
                    url: '${base}manager/queryNeedPayStat',
                    criteria: '.query'
                    ">
                <div data-field="amt1" uglcw-options="format: '{0:n2}'">总应付款</div>

            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#all').value(0);
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#searchAll').on('click', function () {
            uglcw.ui.get('#all').value(1);
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#all').value(0);
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.loaded()
    });
</script>
</body>
</html>
