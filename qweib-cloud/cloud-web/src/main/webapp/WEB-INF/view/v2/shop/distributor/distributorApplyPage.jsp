<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员申请记录</title>
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
            <ul class="uglcw-query">
                <li>
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="会员名称">
                </li>
                <li>
                    <input uglcw-model="startApplyDate" uglcw-role="datepicker" value="${startApplyDate}">
                </li>
                <li>
                    <input uglcw-model="endApplyDate" uglcw-role="datepicker" value="${endApplyDate}">
                </li>
                <%-- <li>
                     <input uglcw-model="auditDateStart" uglcw-role="datepicker" value="${auditDateStart}">
                 </li>
                 <li>
                     <input uglcw-model="auditDateEnd" uglcw-role="datepicker" value="${auditDateEnd}">
                 </li>--%>
                <li>
                    <select uglcw-role="combobox" uglcw-model="state" placeholder="状态">
                        <c:forEach items="${stateMap}" var="map">
                            <option value="${map.key}">${map.value}</option>
                        </c:forEach>
                        <option value="">全部</option>
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
                 uglcw-options="
 					 responsive:['.header',40],
                    <%--toolbar: kendo.template($('#toolbar').html()),--%>
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/shopMemberDistributor/page',
                    criteria: '.uglcw-query',
                    pageable: true,
                    loadFilter: {
                        data: function(response){
                            var data= response.rows ? (response.rows || []) : [];
                            return data;
                        }
                    }
                    ">
                <div data-field="nickname" uglcw-options="width:100,align:'center'">会员名称</div>
                <div data-field="applyTime" uglcw-options="width:150,align:'center'">申请时间</div>
                <div data-field="auditTime" uglcw-options="width:150,align:'center'">审核时间</div>
                <div data-field="state"
                     uglcw-options="width:100, template:uglcw.util.template($('#state_tpl').html())">状态
                </div>
                <div data-field="memo" uglcw-options="width:300,align:'center'">审核说明</div>
                <div data-field="opt" uglcw-options="width:100,template: uglcw.util.template($('#opt_tpl').html())">
                    操作
                </div>
            </div>
        </div>
    </div>
</div>

<script id="state_tpl" type="text/x-kendo-template">
    #=getState(data.state)#
</script>

<script id="opt_tpl" type="text/x-kendo-template">
    #if (data.state ==0 ){#
    <button class="k-button k-success" type="button" onclick="audit(#=data.id#,'#=data.nickname#')">审核</button>
    #}#
</script>
<%--设置商品库存修改--%>
<script type="text/x-uglcw-template" id="audit_form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-xs-4">审核状态</label>
                    <div class="col-xs-16">
                        <input uglcw-role="combobox" id="state" uglcw-model="state"
                               uglcw-options="value:1,dataSource:[{ text: '成功', value: 1 },{ text: '失败', value: 2}]"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-4">说明</label>
                    <div class="col-xs-16">
                         <textarea style="height: 100px;" uglcw-role="textbox" id="memo" uglcw-model="memo"
                                   placeholder="请输入备注"></textarea>
                    </div>
                </div>

            </form>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<script>
    var statusArray = [];
    <c:forEach items="${stateMap}" var="map">
    statusArray.push({'${map.key}': '${map.value}'});
    </c:forEach>

    function getState(state) {
        for (var i in statusArray) {
            var item = statusArray[i];
            if (item[state]) {
                return item[state];
            }
        }
    }

    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query');
        })
        uglcw.ui.loaded()
    })

    function audit(id, nickname) {
        uglcw.ui.Modal.open({
            content: $('#audit_form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var data = uglcw.ui.bind(container);
                data.id = id;
                toAudit(data);
                return true;
            }
        })
    }

    function toAudit(data) {
        uglcw.ui.loading();
        var url = "${base}/manager/shopMemberDistributor/updateAudit";
        $.ajax({
            url: url,
            data: data,
            type: 'post',
            success: function (json) {
                uglcw.ui.loaded();
                if (json.state) {
                    uglcw.ui.success('操作成功！');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error(json.message);
                }
            },
            error: function () {
                uglcw.ui.info('结算错误！');
            }
        })
    }
</script>
</body>
</html>
