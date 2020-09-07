<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

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
                    <li>往来借出单</li>
                    <li>往来还款单</li>
                </ul>
                <div title="往来借出单">
                    <iframe data-src="${base}/manager/bill_center/finance/loan" name="doneForm" id="doneForm" frameborder="0"
                            marginheight="0"
                            marginwidth="0" width="100%" height="100%"></iframe>
                </div>
                <div title="往来还款单">
                    <iframe data-src="${base}/manager/toFinInReturnPage" name="notForm" id="notForm" frameborder="0"
                            marginheight="0"
                            marginwidth="0" width="100%" height="100%"></iframe>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init()
        var height = $(document).height() - $('ul.k-tabstrip-items').height() - 40;
        $('iframe').each(function (i, iframe) {
            $(iframe).attr('height', height + 'px');
        })
        uglcw.ui.loaded();
    })
</script>
</body>
</html>
