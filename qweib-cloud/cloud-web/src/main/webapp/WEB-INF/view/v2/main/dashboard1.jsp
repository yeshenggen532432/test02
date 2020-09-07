<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>控制台</title>
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
        }
    </style>
</head>
<body>

<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md8">
            <div class="layui-row layui-col-space15">
                <div class="layui-col-md6">
                    <div class="layui-card quick-menu">
                        <div class="layui-card-header"><a class="uglcw-menu"
                                                          data-href="${base}/manager/sysQuickMenu/toPage?_sticky=v2"><h3
                                style="font-size: 13px">快捷菜单</h3></a></div>
                        <div class="layui-card-body">
                            <div class="layui-carousel layadmin-carousel layadmin-shortcut">
                                <div carousel-item class="quickMenuClass">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md6">
                    <div class="layui-card">
                        <div class="layui-card-header">待办事项
                            <div class="todo-list layui-btn-group layuiadmin-btn-group">
                                <a href="javascript:;" data-range="30" class="layui-btn layui-btn-normal layui-btn-xs">30天内</a>
                                <a href="javascript:;" data-range="60" class="layui-btn layui-btn-primary layui-btn-xs">60天内</a>
                                <a href="javascript:;" data-range="365"
                                   class="layui-btn layui-btn-primary layui-btn-xs">一年内</a>
                            </div>
                        </div>
                        <div class="layui-card-body">

                            <div class="layui-carousel layadmin-carousel layadmin-backlog">
                                <div carousel-item>
                                    <ul class="layui-row layui-col-space10">
                                        <li class="layui-col-xs6">
                                            <a data-href="${base}/manager/queryStkInMng?from=home"
                                               class="layadmin-backlog-body uglcw-menu sdate">
                                                <h3>待收货单据</h3>
                                                <p><cite id="comeNum">0</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs6">
                                            <a data-href="${base}/manager/queryStkOutPage?from=home"
                                               class="layadmin-backlog-body uglcw-menu sdate">
                                                <h3>待发货单据</h3>
                                                <p><cite id="sendNum">0</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs6">
                                            <a data-href="${base}/manager/queryBforderPage?from=home&orderZt=未审核&dataTp=1"
                                               class="layadmin-backlog-body uglcw-menu sdate">
                                                <h3>待审销售订单</h3>
                                                <p><cite id="saleOrderNum">0</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs6">
                                            <a data-href="${base}/manager/shopBforder/toUnPayOrder?_sticky=v2&payType=1&orderZtIndex=1&from=home"
                                               class="layadmin-backlog-body uglcw-menu sdate">
                                                <h3>待审商城订单</h3>
                                                <p><cite id="shopOrderNum">0</cite></p>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md12">
                    <div class="layui-card">
                        <div class="layui-card-header">数据概览</div>
                        <div class="layui-card-body">

                            <div class="layui-carousel layadmin-carousel layadmin-dataview" data-anim="fade"
                                 lay-filter="LAY-index-dataview">
                                <div carousel-item id="LAY-index-dataview">
                                    <div><i class="layui-icon layui-icon-loading1 layadmin-loading"></i></div>
                                    <div></div>
                                    <div></div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="layui-col-md4">
            <div class="layui-row layui-col-space15">
                <div class="layui-col-sm12">
                    <div class="layui-card">
                        <div class="layui-card-header">
                            访问量
                            <span class="layui-badge layui-bg-blue layuiadmin-badge">周</span>
                        </div>
                        <div class="layui-card-body layuiadmin-card-list">
                            <p class="layuiadmin-big-font">***</p>
                            <p>
                                总计访问量
                                <span class="layuiadmin-span-color">*** <i
                                        class="layui-inline layui-icon layui-icon-flag"></i></span>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="layui-col-sm12">
                    <div class="layui-card">
                        <div class="layui-card-header">
                            收入
                            <span class="layui-badge layui-bg-green layuiadmin-badge">年</span>
                        </div>
                        <div class="layui-card-body layuiadmin-card-list">

                            <p class="layuiadmin-big-font">***</p>
                            <p>
                                总收入
                                <span class="layuiadmin-span-color">*** <i
                                        class="layui-inline layui-icon layui-icon-dollar"></i></span>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="layui-col-sm12">
                    <div class="layui-card">
                        <div class="layui-card-header">
                            活跃用户
                            <span class="layui-badge layui-bg-orange layuiadmin-badge">月</span>
                        </div>
                        <div class="layui-card-body layuiadmin-card-list">

                            <p class="layuiadmin-big-font">***</p>
                            <p>
                                最近一个月
                                <span class="layuiadmin-span-color">*** <i
                                        class="layui-inline layui-icon layui-icon-user"></i></span>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="layui-col-sm12">
                    <div class="layui-card">
                        <div class="layui-card-header">效果报告</div>
                        <div class="layui-card-body layadmin-takerates">
                            <div class="layui-progress" lay-showPercent="yes">
                                <h3>转化率（日同比 28% <span class="layui-edge layui-edge-top" lay-tips="增长"
                                                      lay-offset="-15"></span>）
                                </h3>
                                <div class="layui-progress-bar" lay-percent="65%"></div>
                            </div>
                            <div class="layui-progress" lay-showPercent="yes">
                                <h3>签到率（日同比 11% <span class="layui-edge layui-edge-bottom" lay-tips="下降"
                                                      lay-offset="-15"></span>）</h3>
                                <div class="layui-progress-bar" lay-percent="32%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>
<script type="text/x-uglcw-template" id="quick-menu-tpl">
    {{# layui.each(d, function(index, page) { }}
    <ul class="layui-row layui-col-space10 {{#if(index === 0){ layui-this } }}">
        {{# layui.each(page, function(j, item){ }}
        <li class="layui-col-xs3">
            <a class="uglcw-menu" data-href="${base}/manager/{{item.applyUrl}}">
                <cite>{{item.menuName}}</cite>
            </a>
        </li>
        {{# }); }}
        <li class="layui-col-xs3">
            <a class="uglcw-menu" data-href="${base}/manager/sysQuickMenu/toPage?_sticky=v2">
                <i class="layui-icon layui-icon-add-1"></i>
                <cite style="display: none;">快捷菜单</cite>
            </a>
        </li>
    </ul>
    {{# }); }}
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

    var carousel, element, device, util;
    layui.config({
        base: '/static/uglcs/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'console', 'carousel'], function () {
        carousel = layui.carousel;
        element = layui.element;
        device = layui.device();
        loadQuickData();
        loadTodo();
        var delay;
        $('.todo-list').on('click', 'a.layui-btn', function () {
            $(this).siblings().removeClass('layui-btn-normal').addClass('layui-btn-primary');
            $(this).removeClass('layui-btn-primary').addClass('layui-btn-normal');
            clearTimeout(delay);
            setTimeout(loadTodo, 300);
        })
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

    function getDateRange() {
        var now = new Date();
        var el = $('.todo-list .layui-btn-normal');
        var range = el.data('range');
        now.setDate(now.getDate() - parseInt(range));
        return layui.util.toDateString(now, 'yyyy-MM-dd');
    }

    function loadHomeSh() {
        var path = "${base}/manager/stkInForHomeShPage";
        $.ajax({
            url: path,
            type: "POST",
            data: {"billStatus": '未收货', "dataTp": 1, "page": 1, "rows": 1, sdate: getDateRange()},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    var size = json.total;
                    $("#comeNum").html(size);
                }
            }
        });
    }

    /**
     * 发货
     */
    function loadHomeFh() {
        var path = "${base}/manager/stkOutForHomeFhPage";
        $.ajax({
            url: path,
            type: "POST",
            data: {"isPay": -1, "billStatus": '未发货', "dataTp": 1, "page": 1, "rows": 1, sdate: getDateRange()},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    var size = json.total;
                    $("#sendNum").html(size);
                }
            }
        });
    }

    /**
     * 销售订单待审
     */
    function loadHomeOrder() {
        var path = "${base}/manager/bforderHomePage";
        $.ajax({
            url: path,
            type: "POST",
            data: {"orderZt": '未审核', "dataTp": 1, "page": 1, "rows": 1, sdate: getDateRange()},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    var size = json.total;
                    $("#saleOrderNum").html(size);
                }
            }
        });
    }


    /**
     * 商城订单待审
     */
    function loadHomeShopOrder() {
        var path = "${base}/manager/shopBforder/unPayOrderHomePage";
        $.ajax({
            url: path,
            type: "POST",
            data: {"dataTp": 1, "page": 1, "rows": 1, sdate: getDateRange()},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    var size = json.total;
                    $("#shopOrderNum").html(size);
                }
            }
        });
    }


    function loadQuickData() {
        var path = "${base}/manager/sysQuickMenu/quick";
        $.ajax({
            url: path,
            type: "POST",
            data: {"page": 1, "rows": 50},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    var size = json.rows.length;
                    if (size > 0) {
                        var pageable = chunk(json.rows, 11);
                        layui.laytpl($('#quick-menu-tpl').html()).render(pageable, function (html) {
                            $(".quickMenuClass").html(html);
                        });
                        render('.layadmin-shortcut');
                    }
                }
            }
        });
    }

    function loadTodo() {
        loadHomeFh();
        loadHomeSh();
        loadHomeOrder();
        loadHomeShopOrder();
    }

    function getQueryParams(url) {
        var vars = {}, hash;
        var hashes = url.slice(url.indexOf('?') + 1).split('&');
        for (var i = 0; i < hashes.length; i++) {
            hash = hashes[i].split('=');
            vars[hash[0]] = hash[1];
        }
        return vars;
    };

    $(function () {
        $('body').on('click', '.uglcw-menu', function () {
            var url = $(this).data('href');
            var title = $(this).find('h3').text() || $(this).find('cite').text();
            if ($(this).hasClass('sdate')) {
                if (url.indexOf('?') === -1) {
                    url += '?sdate=' + getDateRange();
                } else {
                    url += '&sdate=' + getDateRange();
                }
            }
            window.top.openTab(title, url);
        })

        uglcw.io.on('quick_menu_updated', function () {
            loadQuickData();
        })

        $('.quick-menu').on('mouseenter', '.layui-icon-add-1', function () {
            layer.tips('添加快捷菜单', this, {})
        }).on('mouseleave', '.layui-icon-add-1', function () {
            layer.close(layer.index)
        });

    })
</script>
</body>
</html>

