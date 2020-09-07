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
                    <li>待付报销单据</li>
                    <li>待审付款单据</li>
                    <li style="display: none">按付款对象统计</li>
                    <li style="display: none">按费用项目统计</li>
                    <li>付款单据列表</li>
                </ul>
                <div title="待付报销单据">
                    <iframe data-src="${base}/manager/toFinPayPage" name="costForm" id="costForm" frameborder="0"
                            marginheight="0"
                            marginwidth="0" width="100%" height="100%"></iframe>
                </div>
                <div title="待审付款单据">
                    <iframe data-src="${base}/manager/toFinPayUnAudit" name="payForm1" id="payForm1" frameborder="0"
                            marginheight="0"
                            marginwidth="0" width="100%" height="100%"></iframe>
                </div>
                <div title="按付款对象统计">
                    <iframe data-src="${base}/manager/toGroupProNamePayPage" name="payFormProName" id="payFormProName"
                            frameborder="0"
                            marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
                </div>

                <div title="按费用项目统计">
                    <iframe data-src="${base}/manager/toGroupItemNamePayPage" name="payFormItemName" id="payFormItemName"
                            frameborder="0"
                            marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
                </div>

                <div title="付款单据列表">
                    <iframe data-src="${base}/manager/toFinPayHis" name="payForm2" id="payForm2" frameborder="0"
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