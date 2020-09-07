<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>拼团活动列表</title>
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
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="拼团名称">
                </li>
                <li>
                    <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="状态"
                            uglcw-options="value:'10'">
                        <option value="10">未结束</option>
                        <c:forEach items="${tourStatusMap}" var="map">
                            <option value="${map.key}">${map.value}</option>
                        </c:forEach>
                    </select>
                </li>
                <%--<li>
                    <select uglcw-role="combobox" uglcw-model="runStatus" placeholder="运行状态"
                            uglcw-options="value:''">
                        <option value="">全部</option>
                        <c:forEach items="${tourRunStatusMap}" var="map">
                            <option value="${map.key}">${map.value}</option>
                        </c:forEach>
                    </select>
                </li>--%>
                <li>
                    <button uglcw-role="button" class="k-info" id="search">搜索</button>
                    <button uglcw-role="button" id="reset">重置</button>
                </li>
                <li style="width: 500px!important;margin-top: 10px;">
                    活动商品不使用促销规则和无运费
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
                    		url: '${base}manager/shopTourWare/pages',
                    		criteria: '.query',
                    	">
                <div data-field="name" uglcw-options="width:150">拼团名称</div>
                <div data-field="wareNm" uglcw-options="width:150">商品名称</div>
                <div data-field="unitName" uglcw-options="width:60">单位</div>
                <div data-field="shopPrice"
                     uglcw-options="width:80, template: uglcw.util.template($('#shopPrice_tpl').html())">商城零售价
                </div>
                <div data-field="price" uglcw-options="width: 60">拼团价</div>
                <div data-field="count" uglcw-options="width: 70">参团人数</div>
                <div data-field="limitQty" uglcw-options="width: 70">限购数量</div>
                <div data-field="startTime" uglcw-options="width:120">开始时间</div>
                <div data-field="endTime" uglcw-options="width:120">结束时间</div>
                <div data-field="endTimeSuccess"
                     uglcw-options="width: 150,template: uglcw.util.template($('#endTimeSuccess_tpl').html())">结束时间到,人数未满订单
                </div>
                <div data-field="planName" uglcw-options="width: 100">拼团方案</div>
                <div data-field="orderCd" uglcw-options="width: 50">排序</div>
                <div data-field="hasCount"
                     uglcw-options="width: 70,template: uglcw.util.template($('#tpl_has_sale_qty').html())">已购数量
                </div>
                <div data-field="status" uglcw-options="width:100, template: uglcw.util.template($('#status_tpl').html())">
                    状态
                </div>
                <div data-field="runStatus"
                     uglcw-options="width:100, template: uglcw.util.template($('#runStatus_tpl').html())">
                    运行状态
                </div>
                <div data-field="opt" uglcw-options="width:200,template: uglcw.util.template($('#opt_tpl').html())">
                    操作
                </div>
            </div>
        </div>
    </div>
</div>
<script id="endTimeSuccess_tpl" type="text/x-kendo-template">
    # if(data.status == '2'){ #
    #=data.endTimeSuccess==1?'有效':'无效'#
    # } else{ #
    # if(data.endTimeSuccess == '1'){ #
    <button onclick="javascript:updateEndTimeSuccess(#= data.id#,0);"
            class="k-button k-info">有效
    </button>
    # }else{ #
    <button onclick="javascript:updateEndTimeSuccess(#= data.id#,1);"
            class="k-button k-info">无效
    </button>
    #}#
    #}#
</script>
<script id="tpl_has_sale_qty" type="text/x-kendo-template">
    <a href="javascript:showOrders(#= data.id#,#=data.hasCount#);"
       style="color:red;font-size: 12px; font-weight: bold;">#=data.hasCount#</a>
</script>

<script id="shopPrice_tpl" type="text/x-uglcw-template">
    #if(data.status==1){#
    #=(data.wareUnit == 'B')?data.shopBaseMaxLsPrice||'暂无':data.shopBaseMinLsPrice||'暂无'#
    #}else{#
    #=data.shopPrice||'暂无'#
    #}#
</script>

<%--启用操作--%>
<script id="status_tpl" type="text/x-uglcw-template">
    # if(data.status == '1'){ #
    <button onclick="javascript:updateStatus(#= data.id#,0,#= data.endTimeSuccess#,#=data.hasCount#);"
            class="k-button k-info">开
    </button>
    # }else if(data.status == '0'){ #
    <button onclick="javascript:updateStatus(#= data.id#,1,#= data.endTimeSuccess#,#=data.hasCount#);"
            class="k-button k-info">关
    </button>
    # } else{ #
    #=getStatus(data.status)#
    #}#
</script>

<script id="runStatus_tpl" type="text/x-uglcw-template">
    #=getRunStatus(data.runStatus)#
</script>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加拼团产品
    </a>
    <a role="button" href="javascript:end();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>结束方案
    </a>
</script>
<script type="text/x-uglcw-template" id="opt_tpl">
    #if (data.status==0){#
    <button class="k-button k-success" type="button" onclick="edit(#=data.id#)">编辑</button>
    #}if (data.status==1){#
    <button class="k-button k-success" type="button" onclick="updateEndTime(#=data.id#,'#=data.endTime#')">修改结束时间
    </button>
    #}#
</script>
<script id="endtime-setting-tpl" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div style="display: inline-flex; vertical-align: middle;">
                <label style="line-height: 30px;">结束时间：</label>
                <div style="width: 250px;">
                    <input uglcw-role="datetimepicker" uglcw-model="endTime"
                           uglcw-options="value:'#=data.endTime#', disableDates: function(date){
                             var now = new Date().setHours(0, 0, 0, 0);
                             return date && date.valueOf() < now.valueOf();
                           }"/>
                </div>
            </div>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var tourStatusArray = [];
    <c:forEach items="${tourStatusMap}" var="map">
    tourStatusArray.push({
    ${map.key}:
    '${map.value}'
    })
    </c:forEach>

    function getStatus(status) {
        for (var i in tourStatusArray) {
            var item = tourStatusArray[i];
            if (item[status]) {
                return item[status];
            }
        }
    }

    var tourRunStatusArray = [];
    <c:forEach items="${tourRunStatusMap}" var="map">
    tourRunStatusArray.push({
    ${map.key}:
    '${map.value}'
    })
    </c:forEach>

    function getRunStatus(status) {
        for (var i in tourRunStatusArray) {
            var item = tourRunStatusArray[i];
            if (item[status]) {
                return item[status];
            }
        }
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

        uglcw.io.on('shop_tour_plan_state_chage', function (data) {
            location.href = location.href;
        });

        uglcw.io.on('shop_tour_ware_chage', function (data) {
            location.href = location.href;
        });

    })

    function updateEndTime(id, endTime) {
        uglcw.ui.Modal.open({
            title: '拼团活动结束时间',
            area: '400px',
            content: uglcw.util.template($('#endtime-setting-tpl').html())({data: {endTime: endTime}}),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var date = uglcw.ui.bind(c);
                if (!date) {
                    uglcw.ui.error('请选择时间');
                    return false;
                }
                $.ajax({
                    url: '${base}manager/shopTourWare/updateEndTime',
                    data: {
                        id: id,
                        endTime: date.endTime
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
                return true;
            }
        });
    }

    //修改启用状态
    function updateStatus(id, status, endTimeSuccess, hasCount) {
        var endTimeSuccessText = ''
        if (hasCount) {
            var endTimeSuccessText = endTimeSuccess ? '关闭后拼团结束,已购买订单自动成交.' : '关闭后拼团失败，将取消订单并退款已支付订单.';
        }
        var str = status ? '开启后有人购买将不能停止,确定开启?' : '是否确定手动关闭拼团?' + endTimeSuccessText;
        uglcw.ui.confirm(str, function () {
            $.ajax({
                url: '${base}manager/shopTourWare/updateStatus',
                data: {
                    id: id,
                    status: status
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

    //修改结束时间到,人数未满订单
    function updateEndTimeSuccess(id, endTimeSuccess) {
        uglcw.ui.confirm('是否修改结束时间到,人数未满订单"'+(endTimeSuccess?'有效':'无效')+'"?', function () {
            $.ajax({
                url: '${base}manager/shopTourWare/updateEndTimeSuccess',
                data: {
                    id: id,
                    endTimeSuccess: endTimeSuccess
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

    function edit(id) {
        uglcw.ui.openTab('拼团产品', '${base}manager/shopTourWare/edit?id=' + id);
    }

    function add() {
        uglcw.ui.openTab('新增拼团产品', '${base}manager/shopTourWare/add');
    }

    function end() {
        var datas = uglcw.ui.get('#grid').selectedRow();
        if (!datas || datas.length == 0) {
            uglcw.ui.error('请选择');
            return;
        }
        uglcw.ui.confirm('确定结束选中拼团？', function () {
            var data = [];
            datas.forEach(function (row) {
                data.push(row.id);
            })
            $.ajax({
                url: '${base}manager/shopTourWare/endStatusBatch',
                data: {
                    ids: data.join(',')
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
        });
    }

    function showOrders(id, hasCount) {
        if (hasCount)
            uglcw.ui.openTab('拼团订单列表', '${base}manager/shopBforder/toPage?orderType=2&promotionId=' + id);
    }

</script>

</body>
</html>
