<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
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
    <div class="layui-card header">
        <div class="layui-card-body">
            <div class="form-horizontal">
                <div class="form-group" style="margin-bottom:0px;">
                    <div class="col-xs-4">
                        <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                    </div>
                    <div class="col-xs-4">
                        <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                    </div>
                    <div class="col-xs-6">
                        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
						showHeader:false,

                     dblclick:function(row){
                       var q = uglcw.ui.bind('.form-horizontal');
                       var amtType='';
                      if(row.itemName1=='总付款')amtType=-1;
                      if(row.itemName1=='现金')amtType=6;
                      if(row.itemName1=='银行卡')amtType=3;
                      if(row.itemName1=='微信')amtType=1;
                      if(row.itemName1=='支付宝')amtType=2;
                      if(amtType !=''){
                        if(amtType ==6) amtType =0;
                        q.amtType = amtType;
                         uglcw.ui.openTab('往来预收款统计', '${base}manager/toFinPreInUnitStat?'+ $.map(q, function(v, k){
                         return k+'='+(v == undefined ? '' : v);
                        }).join('&'));
                       }
                     },
                      responsive:['.header',40],
                    id:'id',
                    url: 'manager/queryFinPreInStat',
                    criteria: '.form-horizontal',
                    ">

                <div data-field="itemName1"
                     uglcw-options="width:200"></div>
                <div data-field="amt1"
                     uglcw-options="width:200,template: uglcw.util.template($('#colour').html())">
                </div>

                <%--FIXME--%>
            </div>
        </div>
    </div>
</div>
<script id="colour" type="text/x-kendo-template">
    <a style="color:blue;font-size: 13px; font-weight: bold;">#=uglcw.util.toString(data.amt1,'n2')#</a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })

</script>
</body>
</html>
