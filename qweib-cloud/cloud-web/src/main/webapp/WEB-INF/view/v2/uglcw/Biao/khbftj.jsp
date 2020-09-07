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
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input uglcw-model="stime" uglcw-role="datepicker" value="${stime}">
                </li>
                <li>
                    <input uglcw-model="etime" uglcw-role="datepicker" value="${etime}">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="khdjNm" placeholder="客户等级">
                        <option value="">全部</option>
                        <c:forEach items="${list}" var="list">
                            <option value="${list.khdjNm}">${list.khdjNm}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <input uglcw-model="bfpl" uglcw-role="textbox" placeholder="拜访频率">
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
                 uglcw-options="{
                    responsive:['.header',40],
                    id:'id',
                    url: '${base}/manager/khbftjPage?dataTp=1',
                    criteria: '.form-horizontal',
                    pageable: true,

                    }">

                <div data-field="khNm" uglcw-options="width:180,template: uglcw.util.template($('#formatterSt1').html())">
                    客户名称
                </div>
                <div data-field="memberNm" uglcw-options="{width:100}">业务员名称</div>
                <div data-field="khdjNm"
                     uglcw-options="{width:100,  template: '#= data.khdjNm === \'null\' ? \'\' : data.khdjNm#'   }">客户等级
                </div>
                <div data-field="createTime" uglcw-options="{width:160}">建立时间</div>
                <div data-field="scbfDate" uglcw-options="{width:160}">拜访日期</div>
                <div data-field="bfsc" uglcw-options="{width:100}">时长</div>
                <div data-field="bfpl" uglcw-options="{width:100}">拜访频率</div>
            </div>
        </div>
    </div>
</div>
</div>
</div>
<script id="formatterSt1" type="text/x-kendo-template">
    <a href="javascript:todetail('#= data.id#','#=data.khTp#')" style="color: blue" ;>#=data.khNm#</a>
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


    function todetail(id, khTp) {
        uglcw.ui.openTab('客户名称', '${base}manager/tocustomerxq?khTp=' + khTp + '&Id=' + id);
    }
</script>
</body>
</html>
