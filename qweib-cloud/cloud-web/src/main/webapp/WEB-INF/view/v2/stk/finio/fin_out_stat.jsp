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
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input type="hidden" id="all" value="" uglcw-role="textbox"/>

                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="inType">
                        <option value="">全部</option>
                        <option value="销售出库">采购入库</option>
                        <option value="其它出库">其它入库</option>
                    </select>
                </li>
                <li style="width: 300px">
                    <button id="search" uglcw-role="button" class="k-button k-info">查询</button>
                    <button id="search-all" uglcw-role="button" class="k-button k-info">查询所有</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                      dblclick:function(row){
                       var q = uglcw.ui.bind('.form-horizontal');
                       delete q['inType'];
                       if(uglcw.ui.get('#all').value()){
                        q.sdate='',
                        q.edate=''
                       }

                       var amtType='';
                      if(row.itemName1=='总付款')amtType=-1;
                      if(row.itemName1=='现金')amtType=6;
                      if(row.itemName1=='银行卡')amtType=3;
                      if(row.itemName1=='微信')amtType=1;
                      if(row.itemName1=='支付宝')amtType=2;
                      if(amtType !=''){
                        if(amtType ==6) amtType =0;
                        q.amtType = amtType;
                         uglcw.ui.openTab('往来单位借款统计', '${base}manager/toFinOutUnitStat?'+ $.map(q, function(v, k){
                         return k+'='+(v);
                        }).join('&'));
                       }
                     },
                     responsive:['.header',40],
                    id:'id',
                    url: 'manager/queryFinOutStat',
                    criteria: '.form-horizontal',
                    query: function(params){
                        if(uglcw.ui.get('#all').value()){
                            params.sdate = '';
                            params.edate = '';
                        }
                        return params;
                    },

                    showHeader:false
                    ">
                <div data-field="itemName1"
                     uglcw-options="width:200"></div>
                <div data-field="amt1" uglcw-options="width:200,template: uglcw.util.template($('#colour').html())">
                </div>

                <%--FIXME--%>
            </div>
        </div>
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
        uglcw.ui.get('#search').on('click', function () {   //（查询）
            uglcw.ui.get('#all').value('');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#search-all').on('click', function () {   //（查询所有）
            uglcw.ui.get('#all').value(1);
            uglcw.ui.get('#grid').reload({all: true});
        })


        uglcw.ui.loaded()
    })


</script>
</body>
</html>
