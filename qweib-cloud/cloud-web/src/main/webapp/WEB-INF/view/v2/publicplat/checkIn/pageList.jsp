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
            <ul class="uglcw-query form-horizontal" id="derive">
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="姓名">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="branchId">
                        <option value="">全部</option>
                        <c:forEach items="${listb}" var="list">
                            <option value="${list.branchId}">${list.branchName}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <input uglcw-model="atime" uglcw-role="datepicker" value="${atime}">
                </li>
                <li>
                    <input uglcw-model="btime" uglcw-role="datepicker" value="${btime}">
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
                     toolbar: kendo.template($('#toolbar').html()),
                    url: '${base}manager/checkInPage?dataTp=${dataTp}',
                    criteria: '.form-horizontal',
                    pageable: true,

                    }">

                <div data-field="branchNm" uglcw-options="width:100">部门</div>
                <div data-field="memberNm" uglcw-options="{width:100}">姓名</div>
                <div data-field="cdate" uglcw-options=" width:120,
                            template: '#= uglcw.util.toString(new Date(data.cdate), \'yyyy-MM-dd dddd\')#'">工作日期
                </div>
                <div data-field="location" uglcw-options="{width:260}">地址</div>
                <div data-field="stime" uglcw-options="{width:120}">上班时间</div>
                <div data-field="etime" uglcw-options="{width:120}">下班时间</div>
                <div data-field="picList" uglcw-options="width:90,template:uglcw.util.template($('#picList').html())">图片</div>
                <div data-field="cdzt" uglcw-options="{width:120}">迟到/早退情况</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toLoadExcel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-download"></span>导出
    </a>
</script>

<script id="picList" type="text/x-uglcw-template">
    <div class="uglcw-album">
        <div id="album-list" class="album-list">
            #if(data.picList){#
                #for(var i = 0;i < data.picList.length ; i++){#
                    # var item=data.picList[i];#
                    <div class="album-item">
                        <img src="/upload/#= item.picMini#">
                        <div class="album-item-cover">
                            <i class="ion-ios-eye" onclick="preview(this, #=i#)"></i>
                        </div>
                    </div>
                #}#
           #}#
        </div>
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


    function toLoadExcel() {
        var textbox = uglcw.ui.bind($("#derive")) //绑定值
        var memNm = textbox.memberNm;
        var branchId2 = textbox.branchId;
        var time1 = textbox.atime;
        var time2 = textbox.btime;
        window.location.href = '${base}/manager/loadForExcel?memNm=' + memNm + '&branchId2=' + branchId2 + '&time1=' + time1 + '&time2=' + time2;
    }

    //放大图片
    function preview(i, index) {
        var grid = uglcw.ui.get('#grid');
        var row = grid.k().dataItem($(i).closest('tr'));
        layer.photos({
            photos: {
                start: index, data: $.map(row.picList, function (item) {
                    return {
                        src: '/upload/' + item.pic,
                        pid: item.id,
                        alt: item.pic,
                        thumb: '/upload/' + item.picMini
                    }
                })
            }, anim: 5
        });
    }

</script>
</body>
</html>
