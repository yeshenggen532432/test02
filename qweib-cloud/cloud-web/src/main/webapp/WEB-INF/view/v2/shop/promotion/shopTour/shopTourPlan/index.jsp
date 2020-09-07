<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>拼团设置首页</title>
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
                    <li>拼团产品列表</li>
                    <li>拼团方案列表</li>
                </ul>
                <div>
                    <iframe data-src="${base}/manager/shopTourWare/topage" width="100%" frameborder="0"
                            allowtransparency="true"></iframe>
                </div>
                <div>
                    <iframe data-src="${base}/manager/shopTourPlan/topage" width="100%" frameborder="0"
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
