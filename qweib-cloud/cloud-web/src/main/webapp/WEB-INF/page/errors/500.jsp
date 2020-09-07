<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>出错了~</title>
</head>
<body style="padding: 0; margin: 0; height: 100%; width: 100%;">
<!--
<% Exception ex = (Exception) request.getAttribute("exception"); %>
<H2>Exception: <%= ex.getMessage()%>
</H2>
<P/>
<% ex.printStackTrace(new java.io.PrintWriter(out)); %>
-->
<div style="margin-top: 150px;">
    <div style="height: 300px; width: 500px;margin: 0 auto; ">
        <div>
            <img src="http://qweib.com/templets/qiweibao/images/logo.jpg">
            <h1>:( 抱歉出错了，请稍后再试~</h1>
            <p>
                <span style="color: #ccc;">错误信息:</span> <span style="color: red"><%= ex.getMessage()%></span>
            </p>
        </div>
    </div>
</div>
</body>
</html>
