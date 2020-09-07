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
                    <input uglcw-model="qddate" uglcw-role="datepicker" value="${qddate}">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
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
                    url: '${base}/manager/ywbfzxPage?dataTp=${dataTp}',
                    criteria: '.form-horizontal',
                    pageable: true,

                    }">

                <div data-field="timed" uglcw-options="width:160">时间段</div>
                <div data-field="khNm" uglcw-options="{width:140,tooltip: true}">客户名称</div>
                <div data-field="memberNm" uglcw-options="{width:120}">业务员名称</div>
                <div data-field="qdtpNum" uglcw-options="{width:120,
                             template: uglcw.util.template($('#formatterStPic1').html())}">签到图片
                </div>
                <div data-field="sdhtpNum" uglcw-options="{width:120
                            , template: uglcw.util.template($('#formatterStPic2').html())}">生动化陈列采集图片
                </div>
                <div data-field="kcjctpNum" uglcw-options="{width:120
                            , template: uglcw.util.template($('#formatterStPic3').html())}">库存检查图片
                </div>
                <div data-field="count1"
                     uglcw-options="width:200,template: function(data){
                            return kendo.template($('#formatterSt1').html())(data.list1);
                         }">订单信息
                </div>
                <div data-field="count2"
                     uglcw-options="width:200,template: function(data){
                            return kendo.template($('#formatterSt2').html())(data.list2);
                         }">库存信息
                </div>
                <div data-field="bfbz" uglcw-options="{width:120}">完成拜访步骤</div>
                <div data-field="khdjNm" uglcw-options="{width:120,
                                template: '#= data.khdjNm === \'null\' ? \'\' : data.khdjNm#'}">客户等级
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</div>
<script id="formatterSt1" type="text/x-kendo-template">
    #if(data && data.length >0){#
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">商品名称</td>
            <td style="width: 5px;">数量</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].wareNum #</td>
        </tr>
        # }#
        </tbody>
    </table>
    #}#
</script>
<script id="formatterSt2" type="text/x-kendo-template">
    #if(data && data.length >0){#
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">商品名称</td>
            <td style="width: 5px;">数量</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].kcNum #</td>
        </tr>
        # }#
        </tbody>
    </table>
    #}#
</script>
<script id="formatterStPic1" type="text/x-kendo-template">
    <a style="color:blue;" href="javascript:todetail('图片详情','#= data.mid#','#= data.cid#','#= data.qddate#',1)"> #=
        data.qdtpNum# </a>
</script>

<script id="formatterStPic2" type="text/x-kendo-template">
    <a style="color:blue;" href="javascript:todetail('图片详情','#= data.mid#','#= data.cid#','#= data.qddate#',2)"> #=
        data.sdhtpNum# </a>
</script>

<script id="formatterStPic3" type="text/x-kendo-template">
    <a style="color: blue;" href="javascript:todetail('图片详情','#= data.mid#','#= data.cid#','#= data.qddate#',3)"> #=
        data.kcjctpNum# </a>
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


    function todetail(title, mid, cid, qddate, tp) {
        uglcw.ui.openTab(title, "${base}manager/bfcPicXq?mid=" + mid + "&cid=" + cid + "&qddate=" + qddate + "&tp=" + tp)
    }

</script>
</body>
</html>
