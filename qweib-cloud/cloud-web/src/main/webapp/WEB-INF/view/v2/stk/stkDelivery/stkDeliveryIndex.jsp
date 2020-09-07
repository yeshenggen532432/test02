<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>物流配送中心</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-tabstrip > .k-content {
          padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div uglcw-role="tabs" uglcw-options="
            activate: function(e){
                var $iframe =  $(e.contentElement).find('iframe');
                if(!$iframe.attr('src')){
                    uglcw.ui.loading($(e.contentElement));
                    $iframe.on('load', function(e){
                        kendo.ui.progress($(e.target).closest('.k-content'), false);
                    })
                    $iframe.attr('src', $iframe.attr('data-src'))
                }
            }
    ">
                <ul>
                    <li>待发货销售单</li>
                    <li>待分配</li>
                    <li>待接收</li>
                    <li>已接收</li>
                    <li>配送中</li>
                    <li>已收货</li>
                    <li>已生成发货单</li>
                    <li>配送终止</li>
                    <li>配送单列表</li>
                    <li>司机路线图</li>
                </ul>
                <div>
                    <iframe data-src="${base}/manager/stkDelivery/toStkOutPageForDelivery" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
                <div>
                    <iframe data-src="${base}/manager/stkDelivery/toPage?psState=0&status=-2&show=0" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
                <div>
                    <iframe data-src="${base}/manager/stkDelivery/toPage?psState=1&status=-2&show=0" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
                <div>
                    <iframe data-src="${base}/manager/stkDelivery/toPage?psState=2&status=-2&show=0" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
                <div>
                    <iframe data-src="${base}/manager/stkDelivery/toPage?psState=3&status=-2&show=0" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
                <div>
                    <iframe data-src="${base}/manager/stkDelivery/toPage?psState=4&status=-2&show=0" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
                <div>
                    <iframe data-src="${base}/manager/stkDelivery/toPage?psState=6&status=1&show=0" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
                <div>
                    <iframe data-src="${base}/manager/stkDelivery/toPage?psState=5&status=-2&show=0" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
                <div>
                    <iframe data-src="${base}/manager/stkDelivery/toPage?show=1" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
                <div>
                    <iframe data-src="${base}/manager/stkDelivery/toDriverMap" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        resize();
        $(window).resize(resize);
        uglcw.ui.loaded();
    })

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var padding = 45;
            var height = $(window).height() - padding - $('.k-tabstrip-items').height();
            $('iframe').each(function (idx, iframe) {
                $(iframe).attr('height', height);
            })
        }, 200)
    }
</script>
</body>
</html>
