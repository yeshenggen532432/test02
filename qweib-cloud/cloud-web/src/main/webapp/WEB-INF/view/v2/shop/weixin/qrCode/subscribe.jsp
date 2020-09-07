<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>生成关注二维码</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        #member-range-tabs .k-tabstrip-items {
            display: none;
        }

        .el-tag {
            margin-right: 3px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid" style="padding:100px"><br/><br/>
    <a role="button" href="javascript:showQrCode();" target="" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>生成关注二维码
    </a>
    <div id="qrcodeDiv" style="display:none;">
        <br/><br/>
        右键图片另存为
        <br/><br/>
        <img id="qrcode" src="">
    </div>
</div>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.loaded()
    })

    //显示二维码
    function showQrCode() {
        $("#qrcode").attr("src", "");
        $.ajax({
            url: '${base}manager/WeixinConfig/subscribe',
            type: 'post',
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp.state && resp.ticketUrl) {
                    $("#qrcodeDiv").css("display", "");
                    var url = resp.ticketUrl;
                    $("#qrcode").attr("src", url);
                } else {
                    uglcw.ui.error(resp.msg);
                }
            }
        })
    }

    //下载二维码
    function downloadImg() {
        var url = $("#qrcode").attr("src");                            // 获取图片地址
        var a = document.createElement('a');          // 创建一个a节点插入的document
        var event = new MouseEvent('click')           // 模拟鼠标click点击事件
        a.download = "关注公众号二维码"                  // 设置a节点的download属性值
        a.href = url;                                 // 将图片的src赋值给a节点的href
        a.dispatchEvent(event)                        // 触发鼠标点击事件
    }
</script>

</body>
</html>
