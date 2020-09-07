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

                <div class="layui-col-md12">
                    <div class="layui-card">
                        <div class="layui-card-header">营业情况
                            <div class="todo-list layui-btn-group layuiadmin-btn-group">
                                <a href="javascript:;" data-range="0" class="layui-btn layui-btn-normal layui-btn-xs">今天</a>
                                <a href="javascript:;" data-range="7" class="layui-btn layui-btn-primary layui-btn-xs">7天内</a>
                                <a href="javascript:;" data-range="30"
                                   class="layui-btn layui-btn-primary layui-btn-xs">本月</a>
                            </div>
                        </div>
                        <div class="layui-card-body">

                            <div class="layui-carousel layadmin-carousel layadmin-backlog">
                                <div carousel-item>
                                    <ul class="layui-row layui-col-space12">
                                        <li class="layui-col-xs3 layui-col-md2" >
                                            <a data-href="${base}/manager/pos/toPosShopBill?from=home"
                                               class="layadmin-backlog-body uglcw-menu sdate" >
                                                <h3 style="color: #000;">零售金额</h3>
                                                <p><cite id="posAmt" style="color: #000;">0</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs3 layui-col-md2">
                                            <a data-href="${base}/manager/shopBforder/toPage?_sticky=v2&from=home"
                                               class="layadmin-backlog-body uglcw-menu sdate" >
                                                <h3 style="color: #000;">商城销售</h3>
                                                <p><cite id="mallAmt" style="color: #000;">0</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs3 layui-col-md2">
                                            <a data-href="${base}/manager/queryOrderPage?from=home"
                                               class="layadmin-backlog-body uglcw-menu sdate" >
                                                <h3 style="color: #000;">批发金额</h3>
                                                <p ><cite id="stkOutAmt" style="color: #000;">0</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs3 layui-col-md2">
                                            <a data-href="${base}/manager/pos/toCardInputQuery?from=home"
                                               class="layadmin-backlog-body uglcw-menu sdate" >
                                                <h3 style="color: #000;">会员充值</h3>
                                                <p><cite id="inputAmt" style="color: #000;">0</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs3 layui-col-md2">
                                            <a data-href="${base}/manager/bill_center/storage?inType=%e9%87%87%e8%b4%ad%e5%85%a5%e5%ba%93?from=home"
                                               class="layadmin-backlog-body uglcw-menu sdate" >
                                                <h3 style="color: #000;">采购金额</h3>
                                                <p><cite id="stkInAmt" style="color: #000;">0</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs3 layui-col-md2">
                                            <a data-href="${base}/manager/bill_center/payment/receipt"
                                               class="layadmin-backlog-body uglcw-menu sdate" >
                                                <h3 style="color: #000;">回款金额</h3>
                                                <p><cite id="recAmt" style="color: #000;">0</cite></p>
                                            </a>
                                        </li>

                                        <li class="layui-col-xs3 layui-col-md2">
                                            <a data-href="${base}/manager/bill_center/payment/payment"
                                               class="layadmin-backlog-body uglcw-menu sdate" ">
                                                <h3 style="color: #000;">付款金额</h3>
                                                <p><cite id="payAmt" style="color: #000;">0</cite></p>
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
                        <div class="layui-card-header">待办事项
                            <div class="todo-list layui-btn-group layuiadmin-btn-group">

                            </div>
                        </div>
                        <div class="layui-card-body">
                            <div class="layadmin-backlog">
                            <div carousel-item>
                            <ul class="layui-row layui-col-space12">
                                <li class="layui-col-xs3">
                                    <a data-href="${base}/manager/queryStkInMng?from=home"
                                       class="layadmin-backlog-body uglcw-menu sdate">
                                        <h3>待收货</h3>
                                        <p><cite id="comeNum">0</cite></p>
                                    </a>
                                </li>
                                <li class="layui-col-xs3">
                                    <a data-href="${base}/manager/queryStkOutPage?from=home"
                                       class="layadmin-backlog-body uglcw-menu sdate">
                                        <h3>待发货</h3>
                                        <p><cite id="sendNum">0</cite></p>
                                    </a>
                                </li>
                                <li class="layui-col-xs3">
                                    <a data-href="${base}/manager/queryBforderPage?from=home&orderZt=未审核&dataTp=1"
                                       class="layadmin-backlog-body uglcw-menu sdate">
                                        <h3>待审销售订单</h3>
                                        <p><cite id="saleOrderNum">0</cite></p>
                                    </a>
                                </li>
                                <li class="layui-col-xs3">
                                    <a data-href="${base}/manager/shopBforder/toUnPayOrder?_sticky=v2&payType=1&orderZtIndex=1&from=home"
                                       class="layadmin-backlog-body uglcw-menu sdate">
                                        <h3>待审商城订单</h3>
                                        <p><cite id="shopOrderNum2">0</cite></p>
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
                        <div class="layui-card-header">...

                        </div>
                        <div class="layui-card-body">
                            <div class="layui-carousel layadmin-carousel layadmin-backlog">
                            <div layui-row layui-col-space12>
                                <div class="layui-col-md3 layui-col-xs3">
                                    <img src="/static/img/客户类型.png" height="60" width="60"/>
                                    <label class="control-label">发卡客户:</label>
                                    <label class="control-label" style="color:#00cc99" id="newCstQty">0</label>
                                </div>

                                <div class="layui-col-md3 layui-col-xs3">
                                    <img src="/static/img/我的客户.png" height="60" width="60"/>
                                    <label class="control-label">新增会员:</label>
                                    <label class="control-label" style="color:#00cc99" id="newCardQty">0</label>
                                </div>
                                <div class="layui-col-md3 layui-col-xs3">
                                    <img src="/static/img/商品统计.png" height="60" width="60"/>
                                    <label class="control-label">明星商品:</label>
                                    <label class="control-label" style="color:#00cc99" id="wareQty">-</label>
                                </div>

                                <div class="layui-col-md3">

                                </div>



                            </div>
                                <div layui-row layui-col-space12>
                                    <div class="layui-col-md3 layui-col-xs3">
                                        <img src="/static/img/考勤.png" height="60" width="60"/>
                                        <label class="control-label">今日考勤:</label>
                                        <label class="control-label" style="color:#00cc99" id="kqQty">-</label>
                                    </div>

                                    <div class="layui-col-md3 layui-col-xs3">
                                        <img src="/static/img/我的拜访.png" height="60" width="60"/>
                                        <label class="control-label">今日拜访:</label>
                                        <label class="control-label" style="color:#00cc99" id="bfQty">-</label>
                                    </div>
                                    <div class="layui-col-md3 layui-col-xs3">

                                    </div>

                                    <div class="layui-col-md3">

                                    </div>



                                </div>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="layui-col-md4">


            <div class="layui-row layui-col-space12">

                <div class="layui-col-md6">
                    <div class="layui-card quick-menu">
                        <div class="layui-card-header">
                            <a class="uglcw-menu"
                                                          data-href="${base}/manager/sysQuickMenu/toPage?_sticky=v2"><h3
                                style="font-size: 13px">快捷菜单</h3></a></div>
                        <div class="layui-card-body" style="height: 610px;">
                            <div class="layadmin-shortcut" style="height: 840px;">
                                <div carousel-item class="quickMenuClass">
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
    {{# layui.each(d, function(index, page) { }}
    <ul class="layui-row layui-col-space10 {{#if(index === 0){ layui-this } }}">
        {{# layui.each(page, function(j, item){ }}
        <li class="layui-col-xs3 layui-col-md10">
            <a class="uglcw-menu" data-href="${base}/manager/{{item.applyUrl}}">
                <cite>{{item.menuName}}</cite>
            </a>
        </li>
        {{# }); }}
        <li class="layui-col-xs3 layui-col-md10">
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
        if(range<10) {
            now.setDate(now.getDate() - parseInt(range));
            return layui.util.toDateString(now, 'yyyy-MM-dd');
        }
        else
        {
            var str = layui.util.toDateString(now, 'yyyy-MM') + "-01";
            return str;
        }
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

    function sumPageStat() {
        var path = "${base}/manager/pos/sumPageStat";
        $.ajax({
            url: path,
            type: "POST",
            data: {sdate: getDateRange()},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    $("#posAmt").html(json.posAmt);
                    $("#mallAmt").html(json.mallAmt);
                    $("#inputAmt").html(json.inputAmt);
                    $("#stkOutAmt").html(json.stkOutAmt);
                    $("#stkInAmt").html(json.stkInAmt);
                    $("#recAmt").html(json.recAmt);
                    $("#payAmt").html(json.payAmt);
                    $("#newCstQty").html(json.newCstQty);
                    $("#newCardQty").html(json.newCardQty);
                    $("#wareQty").html(json.wareQty);
                    $("#kqQty").html(json.kqQty);
                    $("#bfQty").html(json.bfQty);

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
        sumPageStat();
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

