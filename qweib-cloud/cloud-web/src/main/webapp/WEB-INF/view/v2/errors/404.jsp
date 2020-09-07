<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>404</title>
    <style>
        body{
            background-color: #FFF;
        }
    </style>
</head>
<body style="padding: 0; margin: 0;">
<div style="margin-top: 150px;">
    <div style="height: 300px; width: 500px;margin: 0 auto; ">
        <div>
            <h1>AH~ 您访问的页面找不到了 :)</h1>
            <p>
                <span style="color: #ccc;"><a href="javascript:window.history.go(-1);">返回</a> <a style="margin-left: 20px"
                                                                                         id="countdown">5</a></span>
            </p>
        </div>
    </div>
</div>
<script>
    var countdown = 5;
    var timer = setInterval(function () {
        countdown--;
        document.getElementById('countdown').innerText = countdown;
        if (countdown <= 0) {
            window.clearInterval(timer);
            //window.history.go(-1);
        }
    }, 1000)
</script>
</body>
</html>
