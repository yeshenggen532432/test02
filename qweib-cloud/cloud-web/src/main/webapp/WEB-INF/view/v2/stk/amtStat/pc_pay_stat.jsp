<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>付货款管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" uglcw-role="textbox" id="all" value="0">
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="inType" placeholder="入库类型">
                        <option value="">全部</option>
                        <option value="销售出库">采购入库</option>
                        <option value="其它出库">其它入库</option>
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
                    responsive:['.header',40],
                    id:'id',
                    showHeader: false,
                   <%-- dblclick: function(row){
                         var query = uglcw.ui.bind('.query');
                         query.proName=row.proName
                         uglcw.ui.openTab('供应商付款统计', '${base}manager/toPayUnitStat?' + $.map(query, function (v, k) {
                            return k + '=' + (v || '');
                        }).join('&'));
                    },--%>
                    url: '${base}manager/queryPayStat',
                    criteria: '.query',
                    query: function(param){
						if(uglcw.ui.get('#all').value() == 1){
							param.sdate = '';
							param.edate = '';
							param.inType = '';
						}
						return param;
                    }

                    ">
                <div data-field="itemName1"></div>
                <div data-field="amt1"
                     uglcw-options="template: '<a style=\'color:blue;\' onclick=\'showStat(this, 1);\'>#= uglcw.util.toString(data.amt1, \'n2\')#</a>'"></div>
                <div data-field="itemName2"></div>
                <div data-field="amt2"
                     uglcw-options="template: '<a style=\'color:blue;\' onclick=\'showStat(this, 2);\'>#= uglcw.util.toString(data.amt2, \'n2\')#</a>'"></div>
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
            uglcw.ui.clear('.form-horizontal');
        });
        uglcw.ui.loaded()
    });

    function showStat(a, type) {
        var row = uglcw.ui.get('#grid').k().dataItem($(a).closest('tr'));
        var amtType;
        var title = row['itemName' + type];//动态获取数据，根据类型来判断
        if (title === '总付款') {
            amtType = 5;
        } else if (title === '核销') {
            amtType = 4;
        } else if (title == '现金') {
            amtType = 6;
        } else if (title == '银行卡') {
            amtType = 1;
        } else if (title == '微信') {
            amtType = 2;
        } else if (title == '支付宝') {
            amtType = 3;
        }
        if (amtType != "") {
            if (amtType == 6) amtType = 0;
        }
        var query = uglcw.ui.bind('.query');
        query.sdate = "",
            query.edate = "",
            query.ioType = query.inType;
        query.amtType = amtType;
        uglcw.ui.openTab('供应商付款统计', '${base}manager/toPayUnitStat?' + $.map(query, function (v, k) {
            return k + '=' + v;
        }).join('&'));
    }

</script>
</body>
</html>
