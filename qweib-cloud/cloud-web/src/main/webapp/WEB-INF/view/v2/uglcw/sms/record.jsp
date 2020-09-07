<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>短信模板管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .query .k-widget.k-numerictextbox {
            display: none;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <select uglcw-role="combobox" uglcw-model="sendStatus" placeholder="状态">
                        <option value="">全部</option>
                        <option value="0">未发送</option>
                        <option value="1">发送成功</option>
                        <option value="2">发送失败</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="memberType" placeholder="会员类型">
                        <option value="">全部</option>
                        <option value="1">员工</option>
                        <option value="2">供应商</option>
                        <option value="3">客户</option>
                        <option value="4">往来单位</option>
                        <option value="5">商城会员</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="mobile" uglcw-role="textbox" placeholder="手机号码">
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
            <div id="grid" class="uglcw-grid-compact" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    url: '${base}manager/sms/send_record?smsTemplateId=${templateId}',
                    criteria: '.query',
                    pageable: true,
                    loadFilter: {
                      data: function (response) {
                        if(response.code != 200) {
                            uglcw.ui.error(response.message);
                            return [];
                        } else {
                            return response.data.rows;
                        }
                      },
                      total: function(response) {
                        if(response.code != 200) {
                            return 0;
                        } else {
                            return response.data.total;
                        }
                      }
                     }
                    ">
                <div data-field="memberType" uglcw-options="width:60, template: uglcw.util.template($('#formatterMemberType').html())">会员类型</div>
                <div data-field="memberName" uglcw-options="width:160">会员姓名</div>
                <div data-field="mobile" uglcw-options="width:160">手机号</div>
                <div data-field="sendStatus" uglcw-options="width: 100, template: uglcw.util.template($('#formatterSendStatus').html())">状态</div>
                <div data-field="sendTime"
                     uglcw-options="width:160, schema: {type: 'timestamp', format: 'yyyy-MM-dd HH:mm:ss'}">发送时间
                </div>
                <div data-field="failureCause" uglcw-options="width:100">失败原因</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="formatterMemberType">
    #if(data.memberType == 1){#
    员工
    #}else if(data.memberType == 2){#
    供应商
    #}else if(data.memberType == 3){#
    客户
    #}else if(data.memberType == 4){#
    往来单位
    #}else if(data.memberType == 5){#
    商城会员
    #}else{#
    未识别类型
    #}#
</script>
<script type="text/x-uglcw-template" id="formatterSendStatus">
    #if(data.sendStatus == 0){#
    未发送
    #}else if(data.sendStatus == 1){#
    发送成功
    #}else{#
    发送失败
    #}#
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
    });
</script>
</body>
</html>
