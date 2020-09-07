<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>促销规则列表</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source.jsp" %>
    <style type="text/css">
        .van-cell {
            position: relative;
            display: -webkit-box;
            display: -webkit-flex;
            display: flex;
            box-sizing: border-box;
            width: 100%;
            padding: 10px 15px;
            overflow: hidden;
            color: #323233;
            font-size: 14px;
            line-height: 24px;
            background-color: #fff;
            border-bottom: 1px solid #ebedf0;
        }
    </style>
</head>
<!-- --------head结束----------- -->
<!-- --------body开始----------- -->
<body>
<%--商品记忆功能引入--%>
<%@include file="/WEB-INF/page/shop/mobile/include/wareDetailComponent.jsp" %>
<div id="wrapper" class="inner_style">
    <div class="int_title">
	            <span class="int_pic" onclick="history.back();">
	            	<img src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png"/>
	            </span>
        <span id="titleNm">促销规则列表</span>
    </div>

    <div>
        <div role="feed" class="van-list" id="listData">
            <%--<div class="van-cell">
                <a><span>满1000.00元,立减100.00元-送赠品</span></a>
            </div>
            <div class="van-cell">
                <div class="van-cell__title"><span>满2000.00元,立减20.00元</span></div>
            </div>
            <div class="van-cell">
                <div class="van-cell__title"><span>满200.00元,立减20.00元</span></div>
            </div>
            <div class="van-cell">
                <div class="van-cell__title"><span>满500.00元,立减50.00元</span></div>
            </div>--%>
        </div>
    </div>

    <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js"></script>
    <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/swiper.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/index.js"></script>
    <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/inner.js"></script>
    <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/pay_success.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //$.wechatShare();//分享
            getRuningList();
        })


        //获取商品列表
        function getRuningList(pageNum, pageSize) {
            $.ajax({
                url: '<%=basePath%>/web/shopRewardMobile/getRuningList?token=${token}',
                type: 'get',
                success: function (response) {
                    var html = '';
                    if (response.state) {
                        var data = response.obj;
                        if (data && data.length > 0) {
                            $(data).each(function (i, item) {
                                html += ' <div class="van-cell"><a href="javascript:toPage(\'<%=basePath%>/web/shopRewardMobile/toWareListIndex?token=${token}&rewardId=' + item.rewardId + '\');"><span>结束时间:'+item.endTimeStr+ item.memo + '</span></a></div>';
                            })
                        } else {
                            html = '<div class="van-cell">暂无数据</div>';
                        }
                    } else {
                        html = response.message || response.msg;
                    }
                    $("#listData").html(html);
                },
                error: function (error) {

                }
            });
        }
    </script>

</body>
</html>
