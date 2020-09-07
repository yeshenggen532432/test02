<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .pic-container {
            display: inline-flex;
        }

    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="bind">
                <li>
                    <select uglcw-role="combobox" uglcw-model="branchId" placeholder="部门">
                        <option value="">全部</option>
                        <c:forEach items="${deptList}" var="list">
                            <option value="${list.branchId}">${list.branchName}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="qdtpNm"
                            placeholder="客户类型"
                            uglcw-options="
                                            url: '${base}manager/queryarealist1',
                                            dataTextField: 'qdtpNm',
                                            dataValueField: 'qdtpNm',
                                            index:-1,
                                             loadFilter:{
                                             data: function(response){    //过滤数据
                                               return response.list1 || []
                                             }
                                            }
                                        "
                    >
                    </select>
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
                    <input uglcw-model="stime" uglcw-role="datepicker" value="${stime}">
                </li>
                <li>
                    <input uglcw-model="etime" uglcw-role="datepicker" value="${etime}">
                </li>
                <li style="width: 400px !important;">
                    <input type="checkbox" uglcw-role="checkbox" uglcw-value="true" id="picIndex1" uglcw-model="picIndex1"
                           uglcw-options="type:'number'">
                    <label style="margin-top: 10px;" for="picIndex1">步骤1</label>
                    <input type="checkbox" uglcw-role="checkbox" uglcw-value="true" id="picIndex2" uglcw-model="picIndex2"
                           uglcw-options="type:'number'">
                    <label style="margin-top: 10px;"  for="picIndex2">步骤2</label>
                    <input type="checkbox" uglcw-role="checkbox" uglcw-value="true" id="picIndex3" uglcw-model="picIndex3"
                           uglcw-options="type:'number'">
                    <label style="margin-top: 10px;" for="picIndex3">步骤3</label>
                    <input type="checkbox" uglcw-role="checkbox" uglcw-value="true" id="picIndex4" uglcw-model="picIndex4"
                           uglcw-options="type:'number'">
                    <label style="margin-top: 10px;" for="picIndex4">步骤4</label>
                    <input type="checkbox" uglcw-role="checkbox" uglcw-value="true" id="isShow" uglcw-model="isShow"
                           uglcw-options="type:'number'">
                    <label style="margin-top: 10px;" for="isShow">显示无图片记录</label>
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
            <div id="grid" uglcw-role="grid" class="uglcw-grid-compact"
                 uglcw-options="{
                 responsive:['.header',40],
                     toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/memberbfcPage?dataTp=${dataTp}',
                    criteria: '.form-horizontal',
                    pageable: true,

                    }">

                <div data-field="qddate" uglcw-options="width:100">拜访日期</div>
                <div data-field="memberNm" uglcw-options="{width:100}">业务员</div>

                <div data-field="khNm" uglcw-options="{width:180}">客户</div>
                <div data-field="qdtime" uglcw-options="{width:160}">签到时间</div>
                <div data-field="listpic" uglcw-options="width:360,
                            align:'left'
                         ,template: uglcw.util.template($('#formatterSt').html())">拜访拍照
                </div>
                <div data-field="count1"
                     uglcw-options="width:200,template: function(data){
                            return kendo.template($('#formatterSt11').html())(data.list1);
                         }">订单信息
                </div>
                <div data-field="count2"
                     uglcw-options="width:200,template: function(data){
                            return kendo.template($('#formatterSt22').html())(data.list2);
                         }">库存信息
                </div>
                <div data-field="memberMobile" uglcw-options="{width:120}">手机号</div>
                <div data-field="branchName" uglcw-options="{width:100}">部门</div>
                <div data-field="qdtpNm" uglcw-options="{width:100,
                            template: '#= data.qdtpNm === \'null\' ? \'\' : data.qdtpNm#' }">客户类型
                </div>
                <div data-field="khdjNm" uglcw-options="{width:100,
                            template: '#= data.khdjNm === \'null\' ? \'\' : data.khdjNm#' }">客户等级
                </div>
                <div data-field="remo" uglcw-options="{width:100,
                            template: '#= data.remo === \'null\' ? \'\' : data.remo#' }">客户备注
                </div>

                <div data-field="ldtime" uglcw-options="{width:160}">离店时间</div>
                <div data-field="bfsc" uglcw-options="{width:120}">拜访时长</div>

                <div data-field="oper1" uglcw-options="{width:100
                                ,template: uglcw.util.template($('#formatterSt2').html())}">销售小结明细
                </div>
                <div data-field="bcbfzj" uglcw-options="{width:100}">拜访总结</div>
                <div data-field="dbsx" uglcw-options="{width:100}">代办事项</div>
                <div data-field="qdaddress" uglcw-options="{width:275}">签到地址</div>
                <div data-field="khaddress" uglcw-options="{width:275}">客户地址</div>
                <div data-field="linkman" uglcw-options="{width:100}">负责人</div>
                <div data-field="tel" uglcw-options="{width:120,
                             template: '#= data.tel === \'null\' ? \'\' : data.tel#' }">负责人电话
                </div>
                <div data-field="mobile" uglcw-options="{width:120}">负责人手机</div>

            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:createRptData();" class="k-button k-button-icontext">
        <span class="k-icon k-i-printer"></span>生成报表
    </a>
    <a role="button" href="javascript:queryRpt();" class="k-button k-button-icontext">
        <span class="k-icon k-i-hyperlink-open"></span>查询生成的报表
    </a>
</script>
<script id="formatterSt2" type="text/x-kendo-template">
    <a style="color:blue;"
       href="javascript:todetail2('#= data.qddate##= data.memberNm##= data.khNm#','#= data.mid#','#= data.cid#','#= data.qddate#')">查看</a>
</script>
<script id="formatterSt11" type="text/x-kendo-template">
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
<script id="formatterSt22" type="text/x-kendo-template">
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
<script id="formatterSt" type="text/x-kendo-template">

    <div class="pic-container">
        #for (var i=0; i
        <data.listpic.length
                ;i++){#
                # var pic=data.listpic[i];#
        <div class="pic-item">
            <a href="javascript:void(0);" onclick="preview(this, #= i#)">
                <img src="/upload/#= pic.picMin#" style="height: 80px; margin-right: 2px;">
            </a>
            <br>
            <span class="pic-desc">#= pic.nm#</span>
        </div>
        #}#
    </div>

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

    function preview(a, index) {
        var row = uglcw.ui.get('#grid').k().dataItem($(a).closest('tr'));
        layer.photos({
            photos: {
                start: index, data: $.map(row.listpic, function (item) {
                    return {
                        src: '/upload/' + item.pic,
                        pid: uglcw.util.uuid(),
                        alt: item.nm,
                        thumb: '/upload/' + item.picMin
                    }
                })
            }, anim: 5
        });
    }


    function todetail2(title, mid, cid, xjdate) {//查看
        uglcw.ui.openTab(title, '${base}manager/toqueryBfxsxj?mid=' + mid + '&cid=' + cid + '&xjdate=' + xjdate);
    }

    function createRptData() {
        var textbox = uglcw.ui.bind($("#bind"));
        var stime = textbox.stime;
        var etime = textbox.etime;
        var memberNm = textbox.memberNm;
        var khNm = textbox.khNm;
        var qdtpNm = textbox.qdtpNm;
        var qdtpNm = textbox.qdtpNm;
        var branchId = textbox.branchId;
        var picIndex1 = textbox.picIndex1;
        var picIndex2 = textbox.picIndex2;
        var picIndex3 = textbox.picIndex3;
        var picIndex4 = textbox.picIndex4;
        var isShow = textbox.isShow;
        uglcw.ui.openTab('业务员拜访明细报表', '${base}/manager/toMemberbfcSave?stime=' + stime + '&etime=' + etime + '&memberNm=' + memberNm + '&khNm=' + khNm
            + '&qdtpNm=' + qdtpNm + '&khdjNm=' + qdtpNm + '&branchId=' + branchId + '&picIndex1=' + picIndex1 + '&picIndex2=' + picIndex2
            + '&picIndex3=' + picIndex3 + '&picIndex4=' + picIndex4 + '&isShow=' + isShow);
    }

    function queryRpt() {
        uglcw.ui.openTab('生成的统计表', '${base}/manager/toMemberbfcQuery?rptType=11');
    }
</script>
</body>
</html>
