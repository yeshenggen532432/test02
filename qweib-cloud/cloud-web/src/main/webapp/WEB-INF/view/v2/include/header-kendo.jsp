<%@ page language="java" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<base href="<%=basePath%>"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="uglcw" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="base" value="<%=basePath%>"/>
<c:set var="mapUrl" value="//api.map.baidu.com/"/>
<link rel="icon" href="${base }/resource/ico/favicon.ico" type="image/x-icon"/>
<link rel="shortcut icon" href="${base }/resource/ico/logo.ico" type="image/x-icon"/>
<link rel="stylesheet" href="${base}/static/uglcu/uglcw.vendor.css?v=20190723" media="all">
<link rel="stylesheet" href="${base}/static/uglcu/uglcw.ui.css?v=20200520" media="all">
<script>
    var CTX = '${base}',_STICKY='${_sticky}';
</script>
<style>
    ul.uglcw-query *{
        box-sizing: border-box;
    }
    ul.uglcw-query>li {
        margin-top: 2px;
        width: 160px!important;
    }
    .col-xs-4, .col-xs-3, .col-xs-11, .col-xs-18 {
        padding-right: 0;
    }
    @media (max-width: 1368px) {
        .form-horizontal .control-label{
            padding-top: 3px;
        }
        .col-xs-3 {
            width: 10%;
            padding-left: 5px;
        }

       .col-xs-4 {
            width: 20%;
        }

        .col-xs-13 {
            width: 50%;
        }
         .col-xs-11 {
            width: 50%;
        }
        .col-xs-6 {
            width: 20%;
        }
        .col-xs-18 {
            width: 80%;
        }
    }
    ::placeholder {
        color: #838383;/*919191*/
    }
</style>
