<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<c:set var="base" value="<%=basePath%>"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>营业状态</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <script src="${base}/static/uglcs/jquery/jquery.min.js"></script>
    <script src="${base}/static/uglcu/uglcw.core.min.js"></script>
    <script src="${base}/static/uglcs/layui/layui.js"></script>
    <link rel="stylesheet" href="${base}/static/uglcs/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="${base}/static/uglcs/style/admin.css" media="all">
    <style>
        .uglcw-menu {
            cursor: pointer;
        }

        .quick-menu .uglcw-menu cite {
            border-radius: 4px;
            background-color: #f8f8f8;
            line-height: 45px;
        }

        .quick-menu .uglcw-menu cite:hover {
            color: #38F;
            background-color: #f2f2f2;
        }

        .quick-menu .uglcw-menu .layui-icon-add-1:hover {
            background-color: #f2f2f2;
            color: #38f;
        }

        .quick-menu .uglcw-menu .layui-icon-add-1 {
            height: 45px;
            line-height: 45px;
            color: rgba(102, 102, 102, 0.46);
            background-color: #f8f8f8;
            border-radius: 4px;
            margin-top: 2px;
        }

        .layadmin-backlog-body p cite {
            font-weight: 400;
            font-size: 25px;
        }
    </style>
</head>
<body>

<div class="layui-fluid">
    <div class="layui-row">
        <div>
            <div class="layui-row ">
                <div>
                    <div class="layui-card">
                        <div class="layui-card-header">营业状态
                            筛选：<select onchange="loadQuickData(this.value)">
                                <option value="">请选择</option>
                                <c:forEach items="${diningStatusMap}" var="item">
                                    <option value="${item.key}">${item.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="layui-card-body">
                            <div class="layadmin-backlog">
                                <div carousel-item>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>


    </div>
</div>
<script type="text/x-uglcw-template" id="quick-menu-tpl">
    <ul class="layui-row layui-col-space10">
        {{# layui.each(d, function(j, item){ }}
        <li class="layui-col-xs2">
            <span class="layadmin-backlog-body uglcw-menu">
                    <h3>{{item.name}}
                         {{#  if(item.peopleNumber){ }}
                            {{item.peopleNumber}}人
                         {{# }  }}
                       <div style="float: right;">
                            切换<select onchange="changeStatus({{item.id}},this.value)">
                                <c:forEach items="${diningStatusMap}" var="item">
                                    <option value="${item.key}"
                                            {{# if(item.status==${item.key}){ }}
                                            selected
                                            {{# } }}
                                    >${item.value}</option>
                                </c:forEach>
                            </select>
                         </div>
                    </h3>
                <p><cite style="{{item.color}}">{{ item.statusText }}</cite>
                    <%--入座时间--%>
                    {{#  if(item.startTimeStr){ }}
                       {{ item.startTimeStr }} 时长:{{item.startLongTimeStr}}
                        <span style="float: right;color: #00a2eb"
                              onclick="queryOrder({{item.id}},'{{item.name}}',{{item.startTime}})">订单</span>
                    {{# }  }}
                    <%--预定时间--%>
                     {{#  if(item.startTimeStr ==null && item.reserveTimeStr){ }}
                       {{ item.reserveTimeStr }}
                    {{# }  }}

                     <%--如果入座时间为空时--%>
                    {{#  if(! item.startTimeStr){ }}
                        <span style="float: right;color: #00a2eb"
                              onclick="queryOrder({{item.id}},'{{item.name}}')">历史订单</span>
                    {{# }  }}

                    <%--下单时间,如果下单时间大于最后一次查看时间说明有新订单,需要增加提醒--%>
                     {{#  if((item.addOrderTime && item.lastLookTime==null) || (item.lastLookTime<item.addOrderTime)){ }}
                         <img width="15px" src="${base}/static/uglcu/images/face/47.gif">
                    {{# }  }}
                </p>

            </span>
        </li>
        {{# }); }}
    </ul>
</script>

<script src="${base}/static/uglcs/layui/layui.js?t=1"></script>
<script>
    function chunk(array, size) {
        if (!array) return [];
        var firstChunk = array.slice(0, size); // create the first chunk of the given array
        if (!firstChunk.length) {
            return array; // this is the base case to terminal the recursive
        }
        return [firstChunk].concat(chunk(array.slice(size, array.length), size));
    }

    var carousel, element, device;
    layui.config({
        base: '/static/uglcs/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'console', 'carousel'], function () {
        carousel = layui.carousel;
        element = layui.element;
        device = layui.device();
        loadQuickData();
    });

    function render(el) {
        var othis = $(el);
        carousel.render({
            elem: el
            , width: '100%'
            , arrow: 'none'
            , interval: othis.data('interval')
            , autoplay: othis.data('autoplay') === true
            , trigger: (device.ios || device.android) ? 'click' : 'hover'
            , anim: othis.data('anim')
        });
    }

    var diningStatusMap = [];
    <c:forEach items="${diningStatusMap}" var="item">
    diningStatusMap.push({key:${item.key}, text: '${item.value}'});
    </c:forEach>

    function getStatusStr(status) {
        var statusText = "";
        diningStatusMap.forEach(function (item) {
            if (item.key == status) {
                statusText = item.text;
                return;
            }
        });
        return statusText;
    }

    function loadQuickData(status) {
        var path = "${base}/manager/shopDiningTable/findList";
        $.ajax({
            url: path,
            type: "POST",
            data: {"page": 1, "rows": 50, "status": status},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    var size = json.obj.length;
                    if (size > 0) {
                        var pageable = json.obj;// chunk(json.obj, 110);
                        pageable.filter(function (item) {
                            item.statusText = getStatusStr(item.status);
                            var color = 'color:#009688';
                            if (item.status == 20)
                                color = 'color:#13ce66';
                            else if (item.status == 40)
                                color = 'color:#ff4949';
                            item.color = color;
                        })
                        layui.laytpl($('#quick-menu-tpl').html()).render(pageable, function (html) {
                            $(".layadmin-backlog").html(html);
                        });
                        //render('.layadmin-backlog');
                    } else {
                        $(".layadmin-backlog").html("暂无数据");
                    }
                }
            }
        });
    }

    $(function () {
        uglcw.io.on('quick_menu_updated', function () {
            loadQuickData();
        })
        window.setInterval(function () {
            loadQuickData();
        },5000)
    })

    /**
     * 修改状态
     */
    function changeStatus(id, status) {
        if (status == 20) {
            layer.prompt({value: '', title: '请输入人数'}, function (peopleNumber, index) {
                layer.close(index);
                updateStatus(id, status,peopleNumber)
            });
        } else {
            layer.confirm("是否确定修改状态", {icon: 3, title: '提示'}, function () {
                updateStatus(id, status)
            });
        }
    }

    function updateStatus(id, status,peopleNumber) {
        var index = layer.load(1); //换了种风格
        $.ajax({
            url: '${base}manager/shopDiningTable/updateStatus',
            data: {id: id, status: status,peopleNumber:peopleNumber},
            type: 'post',
            async: false,
            success: function (resp) {
                layer.close(index);
                if (resp.state) {
                    layer.msg('操作成功', {icon: 1, time: 2000}, function () {
                        loadQuickData();
                    });
                } else {
                    layer.msg('操作失败', {icon: 2, time: 2000});
                }
            }
        })
    }

    //查看桌号对应的订单
    function queryOrder(id, name, startTime) {
        if (startTime) {
            $.ajax({
                url: '${base}manager/shopDiningTable/queryOrder',
                data: {id: id},
                type: 'post',
                async: false,
                success: function (resp) {
                    if (resp.state) {
                        var startTimeStr = new Date(startTime);
                        var date = startTimeStr.format('yyyy-MM-dd')
                        var time = startTimeStr.format('HH:mm:ss')
                        var url = "${base}/manager/shopBforder/toPage?_sticky=v2&orderType=9&shopDiningId=" + id + "&sdate=" + date + "&stime=" + time;
                        window.top.openTab(name + "订单", url);
                    } else
                        layer.msg('操作失败', {icon: 2, time: 2000});
                }
            });
        } else {
            var url = "${base}/manager/shopBforder/toPage?_sticky=v2&orderType=9&shopDiningId=" + id;
            window.top.openTab(name + "历史订单", url);
        }
    }

</script>
</body>
</html>

