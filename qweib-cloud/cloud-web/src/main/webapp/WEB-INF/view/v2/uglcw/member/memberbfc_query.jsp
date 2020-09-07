<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>T3</title>
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
            <ul class="uglcw-query form-horizontal">

                <li><input type="hidden" uglcw-model="rptType" uglcw-role="textbox" value="${rptType}">
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input uglcw-model="rptTitle" uglcw-role="textbox" placeholder="标题">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索1</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
						responsive:['.header',40],
						  dblclick:function(row){
						   var q = uglcw.ui.bind('.form-horizonal');
						   q.id = row.id;
						   q.title=row.rptTitle;
						   delete q['sdate'];
						   delete q['edate'];
						   uglcw.ui.openTab(q.title,'${base}manager/toMemberbfcView?'+$.map(q, function(v, k){
								 return k+'='+(v||'');
							 }).join('&'));
					  },
						id:'id',
                    url: '${base}/manager/querySaveRptDataStatPage',
                    criteria: '.form-horizontal',
                    pageable: true,

                    }">

                <div data-field="rptTitle" uglcw-options="width:320">标题</div>
                <div data-field="sdate" uglcw-options="{width:220}">日期</div>
                <div data-field="operName" uglcw-options="{width:220}">操作人</div>
                <div data-field="remark" uglcw-options="{width:220}">备注</div>
            </div>
        </div>
    </div>
</div>
</div>
</div>

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
