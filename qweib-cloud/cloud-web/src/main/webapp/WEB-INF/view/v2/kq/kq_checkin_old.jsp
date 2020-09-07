<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>

	<title>驰用T3</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<link rel="stylesheet" href="${base}/static/uglcs/style/ext/dtree/dtree.css" media="all">
	<link rel="stylesheet" href="${base}/static/uglcs/style/ext/dtree/font/dtreefont.css">
</head>
<body>
<div class="layui-fluid">
	<div class="layui-card">
		<div class="layui-card-header">
			<div class="layui-form" lay-filter="search-form">
				<div class="layui-inline uglcw-search">
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label">开始时间</label>
							<div class="layui-input-inline">

								<input id="qweib-date" name="sdate" style="width:200px;"
									   class="layui-input layui-input-inline"
									   value="${sdate}">
							</div>
						</div>
						<div class="layui-inline">
							<label class="layui-form-label">结束时间</label>
							<div class="layui-input-inline">

								<input id="edXb" name="edate" style="width: 200px;"
									   class="layui-input layui-input-inline"
									   value="${edate}">
							</div>
						</div>
						<button class="layui-btn layui-btn-sm layui-btn-normal"
								id="search-submit"
								lay-submit
								lay-filter="member-search">
							查询
						</button>
						<button id="reset" type="reset" class="layui-btn layui-btn-sm layui-btn-primary"
								style="margin-left: 0px;">
							重置
						</button>
					</div>

				</div>
			</div>
		</div>
		<div class="layui-card-body">
			<div class="layui-row layui-col-space12">
				<div class="layui-col-xs2">
					<div class="layui-card">
						<div class="layui-card-header">
							<div style="font-weight: bold">部门结构树</div>
						</div>
						<div class="layui-card-body">
							<div style="overflow: auto;" id="context-container">
								<div id="tree"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="layui-col-xs2">
					<div class="layui-card">
						<div class="layui-card-header">
							<div style="font-weight: bold">员工</div>
						</div>
						<div class="layui-card-body">
							<table id="class-list" lay-filter="class-list"></table>
						</div>
					</div>
				</div>
				<div class="layui-col-xs8">
					<div class="layui-card">
						<div class="layui-card-header">
							<div style="font-weight: bold">考勤信息</div>
						</div>
						<div class="layui-card-body">
						<table id="class-list-checkin" lay-filter="class-list"></table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script src="${base}/static/uglcs/layui/layui.js"></script>
<script src="${base}/static/uglcs/jquery/jquery.min.js"></script>
<script src="${base}/static/uglcs/kendo/kendo.all.min.js"></script>
<script src="${base}/static/uglcs/kendo/kendo.culture.zh-CN.min.js"></script>
<script src="${base}/static/uglcs/kendo/kendo.messages.zh-CN.min.js"></script>
<script>
    $(function () {

    })
</script>

<script>
    var layer, $, table, form;
    layui.config({
        base: '/static/uglcs/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'table', 'dtree', 'laydate'],
        function () {
            form = layui.form, dtree = layui.dtree, laydate = layui.laydate;
            table = layui.table;
            $ = layui.$, layer = layui.layer;

            laydate.render({
                elem: '#qweib-date',
                format: 'yyyy-MM-dd'
            })
            laydate.render({
                elem: '#edXb',
                format: 'yyyy-MM-dd'
            })

            table.render({
                elem: '#class-list',
                loading: true,
                url: '${base}manager/kqrule/queryKqEmpRulePage',
                method: 'get',
                height: 'full-100',
                cellMinWidth: 80,
                id: 'class-list',
                skin: 'row',
                even: true,
                size: 'sm',
                cols: [[
                    {type: 'checkbox', fixed: 'left'},
                    {type: 'numbers', fixed: 'left'},
                    {field: 'memberNm', title: '姓名', align: 'center', fixed: 'left'},
                    {field: 'memberMobile', title: '电话', align: 'center', fixed: 'left'},
                ]],
                parseData: function (response) {
                    return {
                        code: 0,
                        count: response.total,
                        data: response.rows
                    }
                }
            })

            table.render({
                elem: '#class-list-checkin',
                loading: true,
                url: '${base}manager/checkInPage?dataTp=${dataTp }',
                method: 'get',
                height: 'full-100',
                cellMinWidth: 80,
                id: 'class-list',
                page: true,
                limit: 20,
                skin: 'row',
                even: true,
                size: 'sm',
                request: {
                    pageName: 'page',
                    limitName: 'rows'
                },
                cols: [[
					{type: 'checkbox', fixed: 'left'},
                    {type: 'numbers', fixed: 'left'},
                    {field: 'id', title: 'id', align: 'center', fixed: 'left',hide:"true"},
					 {field: 'memberId', title: 'psnId', align: 'center', fixed: 'left',hide:"true"},
                    {field: 'memberNm', title: '姓名', align: 'center', fixed: 'left'},
                    {field: 'branchNm', title: '部门', align: 'center'},
                   {field: 'cdate', title: '工作日期', align: 'center'},
                    {field: 'location', title: '地址', align: 'center'},
                    {field: 'stime', title: '上班时间', align: 'center'},
                    {field: 'etime', title: '下班时间', align: 'center'},
                    {field: 'cdzt', title: '考勤状态', align: 'center'},
                    {field: 'picList', title: '签到拍照', align: 'center'},
                ]],
                parseData: function (response) {
                    console.log(response);
                    return {
                        code: 0,
                        count: response.total,
                        data: response.rows
                    }
                }
            })

            var loadTree = function () {
                dtree.render({
                    elem: '#tree',
                    method: 'get',
                    skin: 'layui',
                    toolbarScroll: '#context-container',
                    toolbarFun: {},
                    dataStyle: 'layuiStyle',
                    url: '${base}manager/department/tree',
                    success: function (response) {
                        var visit = function (data) {
                            $(data).each(function (idx, item) {
                                item.title = item.branchName;
                                if (item.children && item.children.length > 0) {
                                    visit(item.children);
                                }
                            })
                        }
                        visit(response.data)
                        return {
                            status: {code: 200},
                            data: response.data
                        }
                    },
                    response: {
                        rootName: 'data',
                        treeId: 'branchId'
                    },
                })
            }

            loadTree();

            dtree.on('node', function (obj) {
                console.log(obj);
                var node = obj.param;
                table.reload('class-list', {
                    url: '${base}/manager/kqrule/queryKqEmpRulePage',
                    where: {
                        branchId: node.nodeId,
                        memberUse: 1
                    }
                })
            })
        }
    );
</script>
</body>
</html>
