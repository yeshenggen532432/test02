<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>关注公众号二维码</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <style>
        #qrcode {
            width: 200px;
            height: 200px;
            margin: 15px auto;
        }

        .box {
            margin: auto 10px;
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            border-radius: 5px;
        }

        .title h3 {
            height: 40px;
            line-height: 40px;
            font-size: 16px;
            color: #00a6fb;
        }

        .content a {
            display: block;
            margin-top: 10px;
            height: 25px;
            line-height: 25px;
            font-size: 14px;
            color: #333333;
        }

    </style>
</head>
<!-- --------head结束----------- -->

<!-- --------body开始----------- -->
<body>
<div>
    <header class="mui-bar mui-bar-nav">
        <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
        <h1 class="mui-title">关注公众号</h1>
    </header>

    <div class="mui-content mui-text-center">
        <div class="box">
            <div class="content">
                <a href="javaScript:;">长按识别二维码，关注公众号</a>
                <div id="qrcode"/>
            </div>
        </div>
    </div>

</div>
</div>
</body>

<script>
    mui.init();

    $(document).ready(function () {
        var shareData = {
            title: document.title, // 分享标题
            desc: document.title, // 分享描述
            link: location.href, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
            imgUrl: $("img").attr("src"), // 分享图标
            success: function () {
            }
        }
        //$.wechatShare(shareData);//分享
        getTicketUrl();
    })

    /**
     * 设置条形码和二维码
     */
    function setCode(code) {
        var qrcode = new QRCode(document.getElementById("qrcode"), {
            width: 200,
            height: 200,
            correctLevel: 3
        });
        qrcode.makeCode(code);
    }

    /**
     * 获取ticketUrl
     */
    function getTicketUrl() {
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "<%=basePath %>/web/wx/subscribe",
            data: "token=${token}",
            success: function (json) {
                if (json.state) {
                    setCode(json.ticketUrl);
                }
            }
        });
    }

</script>


</html>
