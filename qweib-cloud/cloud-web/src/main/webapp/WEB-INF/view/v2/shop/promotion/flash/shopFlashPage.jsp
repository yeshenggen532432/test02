<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>秒杀活动列表</title>
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
            <ul class="uglcw-query query">
                <li>
                    <input uglcw-model="title" uglcw-role="textbox" placeholder="请输入关键字">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="state" placeholder="状态"
                            uglcw-options="value:'10'">
                        <option value="10">未结束</option>
                        <c:forEach items="${statusMap}" var="map">
                            <option value="${map.key}">${map.value}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <button uglcw-role="button" class="k-info" id="search">搜索</button>
                    <button uglcw-role="button" id="reset">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                            toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/promotion/shopFlash/page?sourceType=${sourceType}',
                    		criteria: '.query',
                    		loadFilter: {
                    		    data: function(response){
                    		        var rows= response ? (response.rows || []) : [];
                    		        rows.map(function(data){data.status=data.state});
                    		        return rows;
                    		    }
                    		},
                    	">
                <div data-field="title" uglcw-options="width:200">活动标题</div>
                <div data-field="startTimeStr" uglcw-options="width:150">开始时间</div>
                <div data-field="endTimeStr" uglcw-options="width:150">结束时间</div>

                <div data-field="state"
                     uglcw-options="width:100,template: uglcw.util.template($('#g_status_tpl').html())
                    ">开/关状态
                </div>
                <div data-field="runState"
                     uglcw-options="width:100, template: uglcw.util.template($('#g_runState_tpl').html())">运行状态
                </div>
                <div data-field="opt" uglcw-options="width:250,template: uglcw.util.template($('#opt_tpl').html())">
                    操作
                </div>
            </div>
        </div>
    </div>
</div>

<%--启用操作--%>
<script id="state_tpl" type="text/x-uglcw-template">
    # if(data.state == '1'){ #
    <button onclick="javascript:updateState(#= data.id#,0);" class="k-button k-info">开</button>
    # }else{ #
    <button onclick="javascript:updateState(#= data.id#,1);" class="k-button k-info">关</button>
    # } #
</script>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:toFlashTimePage();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>秒杀时间段模版列表
    </a>

    <a role="button" href="javascript:shopEditForm({});" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus"></span>发起活动（${sourceType==1?'零售':'批发'}）
    </a>
    <a role="button" href="javascript:updateStatusEnd();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>结束活动
    </a>
</script>
<script type="text/x-uglcw-template" id="opt_tpl">
    #var text=data.status==0?'设置':'查看'#
    #if (data.status ==0 ){#
    <button class="k-button k-success" type="button" onclick="edit(#=data.id#,'#=data.title#')">编辑</button>
    #}if (data.runStatus==1){#
    <button class="k-button k-success" type="button" onclick="updateEndTime(#=data.id#,'#=data.endTime#')">修改结束时间
    </button>
    #}#
    <button class="k-button k-success" type="button" onclick="toFlashWareCountPage('#=data.title#','#=data.id#')">#=text#商品</button>
    <%--<button class="k-button k-success" type="button" onclick="del(#=data.id#,#=data.state#)">删除</button>--%>
</script>
<%--添加或修改--%>
<script type="text/x-uglcw-template" id="editForm_tpl">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="editForm" uglcw-role="validator">
                <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                <div class="form-group">
                    <label class="control-label col-xs-6">活动标题</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="title" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">开始时间</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="startTimeStr" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-role="datetimepicker" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">结束时间</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="endTimeStr" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-role="datetimepicker" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group hide">
                    <label class="control-label col-xs-6">状态</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="state"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"关","value":"0"},{"text":"开","value":"1"}]'></ul>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/shop_promotion_status_include.jsp" %>
<script>
    //修改状态
    var editStatusUrl = "manager/promotion/shopFlash/updateState";

    function toFlashTimePage() {
        uglcw.ui.openTab('秒杀时间段列表', '${base}/manager/promotion/shopFlashTimes/toPage')
    }

    function toFlashWareCountPage(name, id) {
        uglcw.ui.openTab(name + '设置商品', '${base}/manager/promotion/shopFlashTimes/toPage?flashId=' + id);
    }

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        //resize();
        //$(window).resize(resize);
        uglcw.ui.loaded();
    })

    //修改启用状态
    function updateState(id, state) {
        var str = state ? '开' : '关';
        uglcw.ui.confirm("是否确定" + str + "操作?", function () {
            $.ajax({
                url: '${base}manager/promotion/shopFlash/updateState',
                data: {
                    id: id,
                    state: state
                },
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message);
                    }
                }
            })
        })
    }

    //删除
    function del(id, state) {
        if (state) {
            uglcw.ui.error("运行中活动不可删除");
            return false;
        }
        uglcw.ui.confirm("确定删除所选记录吗？将删除所有活动商品.", function () {
            $.ajax({
                url: "${base}manager/promotion/shopFlash/removeById",
                data: {
                    id: id,
                },
                type: 'post',
                dataType: 'json',
                success: function (resp) {
                    if (resp.state) {
                        uglcw.ui.get('#grid').reload();
                        uglcw.ui.success(resp.message);
                    } else {
                        uglcw.ui.error(resp.message)
                    }
                }
            });
        })
    }

    //添加
    function edit(id) {
        $.ajax({
            url: '${base}manager/promotion/shopFlash/findById',
            data: {id: id},
            type: 'post',
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp.state) {
                    shopEditForm(resp.obj);
                } else {
                    uglcw.ui.error('加载数据失败');
                }
            }
        })
    }

    function shopEditForm(data) {
        var text = data.id ? '修改' : '发起';
        var win = uglcw.ui.Modal.open({
            title: text + ' 秒杀活动',
            maxmin: false,
            area: ['600px', '450px'],
            content: $('#editForm_tpl').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), data);
            },
            yes: function () {
                var data = uglcw.ui.bind(".editForm");
                if (!data.title || !data.startTimeStr || !data.endTimeStr) {
                    uglcw.ui.error("请完善资料");
                    return false;
                }
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/promotion/shopFlash/saveOrUpdate?sourceType=${sourceType}',
                    data: data,
                    type: 'post',
                    async: true,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp.state) {
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.success(resp.message);
                            uglcw.ui.Modal.close(win);
                        } else {
                            uglcw.ui.error(resp.message)
                        }
                    }, error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error("出现错误")
                    }
                })
                return false;
            }
        })
    }
</script>

</body>
</html>
