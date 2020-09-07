<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
    <div class="layui-card">
        <div class="layui-card header">
            <div class="layui-card-body">
                <ul class="uglcw-query form-horizontal">
                    <li>
                        <input uglcw-model="bcName" uglcw-role="textbox" placeholder="班次名称">
                    </li>
                    <li>
                        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                    checkbox: true,
                    toolbar: kendo.template($('#toolbar').html()),
                     dblclick:function(row){
                       uglcw.ui.openTab('每天上下班设置', '${base}manager/bc/toBaseBcEdit?id='+ row.id+$.map( function(v, k){  //只带id
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                     responsive:['.header',40],
                    id:'id',
                    url: '${base}/manager/bc/queryKqBcPage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    }">
                <div data-field="bcCode" uglcw-options="width:120">班次编码</div>
                <div data-field="bcName" uglcw-options="{width:160}">班次名称</div>
                <div data-field="count" uglcw-options="{width:200,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.subList);
                         }
                        }">时间信息
                </div>
                <div data-field="earlyMinute" uglcw-options="{width:120}">上班弹性时间</div>
                <div data-field="lateMinute" uglcw-options="{width:120}">下班弹性时间</div>
                <div data-field="beforeMinute" uglcw-options="{width:140}">最早上班签到时间</div>
                <div data-field="afterMinute" uglcw-options="{width:140}">最晚下班签到时间</div>
                <div data-field="address" uglcw-options="{width:260}">考勤位置</div>
                <div data-field="outOf"
                     uglcw-options="{width:100,template: uglcw.util.template($('#formatterSt4').html())}">可超出否
                </div>
                <div data-field="remarks" uglcw-options="{width:120}">备注</div>
                <div data-field="status"
                     uglcw-options="{width:100,template: uglcw.util.template($('#formatterSt3').html())}">是否禁用
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="formatterSt3">
    # if(data.status == 2){ #
    #if (data.dataTp=='2') {#
    <button class="k-button" onclick="updateStatus(#= data.id#,1)"><i class="k-icon "></i>是</button>
    # }else{#
    <button class="k-button" onclick="updateStatus(#= data.id#,1)"><i class="k-icon "></i>是</button>
    #}#
    # }else{#
    #if(data.dataTp=='1') {#
    <button class="k-button" onclick="updateStatus(#= data.id#,2)"><i class="k-icon "></i>否</button>

    #}else{#
    <button class="k-button" onclick="updateStatus(#= data.id#,2)"><i class="k-icon "></i>否</button>

    #}#

    # } #
</script>

<script type="text/x-kendo-template" id="formatterSt4">
    #if(data.outOf ==0){#
    否
    #} else {#
    是
    #}#

</script>
<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 5px;">上班时间</td>
            <td style="width: 5px;">下班时间</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].startTime #</td>
            <td>#= data[i].endTime #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>


<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toaddbc();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:getSelected();">
        <span class="k-icon k-i-pencil"></span>修改
    </a>
    <a role="button" href="javascript:del();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-delete"></span>删除</a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置（清除搜索输入框数据）
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })


    //修改停用
    function updateStatus(id, status) {
        $.ajax({
            url: "manager/bc/updateBcStatus",
            type: "post",
            data: "id=" + id + "&status=" + status,
            success: function (data) {
                if (data.state) {
                    alert("操作成功");
                    uglcw.ui.get('#grid').reload();//刷新页面数据
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function toaddbc() {  //添加
        location.href = ('${base}manager/bc/toBaseBcNew');

    }

    function getSelected(id) { //修改
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            var id = selection[0].id;
            location.href = ('${base}/manager/bc/toBaseBcEdit?id=' + id);
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function del() {   //删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            /*   var id = selection[0].id;//获取当前行id*/
            uglcw.ui.confirm('确定删除所选记录吗', function () {
                $.ajax({
                    url: '${base}/manager/bc/deleteKqBc',
                    data: {
                        ids: $.map(selection, function (row) {  //选中多行数据删除
                            return row.id
                        }).join(',')
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success(response.msg);
                            uglcw.ui.get('#grid').reload();//刷新页面数据
                        } else {
                            uglcw.ui.error(response.msg);//错误提示
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

</script>
</body>
</html>
