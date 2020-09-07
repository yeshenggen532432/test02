<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
<head>
    <meta charset="UTF-8">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <meta name="format-detection" content="telephone=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0,minimum-scale=1.0">
    <style>
        /*			.mui-card .mui-control-content {
                        padding: 10px;
                    }

                    .mui-control-content {
                        //height: 150px;
                    }*/

        .mui-table-view-cell{
            margin: 5px 10px;
            padding: 10px;
            background-color: #FFFFFF;
            border-radius: 5px;
        }
        .mui-table-view-cell:after {
            background-color: transparent;
        }

        .mui-media-body{
            margin-left: 105px;
            font-size: 14px;
            color: #666666;
        }


        .my-left {
            width: 90px;
            height: 60px;
            float: left;
            text-align: center;
            color: #3388FF;
        }
        .my-left h4{
            font-size: 23px;
            font-weight: 600;
            margin-top: 10px;
        }
        .my-left p{
            font-size: 10px;
            line-height: 20px;
            color: #3388FF;
        }

        .my-right-middel{
            position: absolute;
            left: 115px;
            right: 10px;
            top: 35px;
            color: #8f8f94;
        }
        .my-right-middel span{
            display: inline-block;
            font-size: 10px;
            color: #999999;
            background-color: #F0F0F0;
            border-radius: 2px;
            padding: 0 5px;
            height: 18px;
            line-height: 18px;
        }

        .my-right-bottom {
            position: absolute;
            left: 115px;
            right: 15px;
            bottom: 0px;
        }
        .my-right-bottom p{
            font-size: 10px;
            color: #999999;
        }

        .mui-table-view{
            background-color: #F0F0F0;
        }

        .mui-table-view:before,
        .mui-table-view:after {
            height: 0;
        }

        /*.mui-content>.mui-table-view:first-child {
            margin-top: 1px;
        }*/

        .my-zs-sy{
            height: 30px;
            display: flex;
            border-top: dotted 1px #EEEEEE;
            margin-top: 10px;
        }
        .my-zs{
            flex: 1;
            text-align: center;
            line-height: 35px;
            font-size: 14px;
            color: #333333;
            padding-top: 5px;
        }
        .my-line{
            border-left:solid 1px #EEEEEE ;
            height: 20px;
            margin-top: 8px;
        }
        .my-sy{
            flex: 1;
            text-align: center;
            line-height: 35px;
            font-size: 14px;
            color: red;
            padding-top: 5px;
        }

        .new{
            display: inline-block;
            width: 40px;
            height: 16px;
            line-height: 16px;
            position: absolute;
            left: 0px;
            top: 5px;
            background-color: coral;
            border-radius: 10px;
            font-size: 8px;
            color: #FFFFFF;
            text-align: center;
        }

    </style>

</head>

<!-- --------body开始----------- -->
<body>
<header class="mui-bar mui-bar-nav">
    <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
    <h1 class="mui-title">优惠券</h1>
</header>
<div class="mui-content">
    <div style="padding: 0 10px;background-color: white;">
        <div id="segmentedControl" class="mui-segmented-control mui-segmented-control-inverted">
            <a class="mui-control-item mui-active" href="javaScript:dbsy();">待办使用</a>
            <a class="mui-control-item" href="#item2">赠送转让</a>
            <a class="mui-control-item" href="#item3">已使用</a>
            <a class="mui-control-item" href="#item3">已使用</a>
        </div>
    </div>

    <!--列表信息流 开始-->
    <div class="mui-scroll">
        <ul class="mui-table-view">
            <li class="mui-table-view-cell mui-media" >
                <a href="javascript:;" >
                    <div class="my-left">
                        <h4>￥100</h4>
                        <p>满149元可用</p>
                    </div>
                    <div class="mui-media-body">
                        <div class="mui-ellipsis-2">标题</div>
                    </div>
                    <div class="my-right-middel">
                        <span>全平台</span>
                    </div>
                    <div class="my-right-bottom">
                        <p>2019-01-22</p>
                    </div>
                    <div class="new">
                        新到
                    </div>
                </a>
                <div class="my-zs-sy mui-hidden">
                    <div class="my-zs">赠送</div>
                    <div class="my-line"></div>
                    <div class="my-sy">使用</div>
                </div>
            </li>
            <li class="mui-table-view-cell mui-media" >
                <a href="javascript:;" >
                    <div class="my-left">
                        <h4>￥100</h4>
                        <p>满149元可用</p>
                    </div>
                    <div class="mui-media-body">
                        <div class="mui-ellipsis">标题</div>
                    </div>
                    <div class="my-right-middel">
                        <span>全平台</span>
                    </div>
                    <div class="my-right-bottom">
                        <p>2019-01-22</p>
                    </div>
                </a>
                <div class="my-zs-sy">
                    <div class="my-zs ">赠送</div>
                    <div class="my-line"></div>
                    <div class="my-sy">使用</div>
                </div>
            </li>
            <li class="mui-table-view-cell mui-media" >
                <a href="javascript:;" >
                    <div class="my-left">
                        <h4>￥100</h4>
                        <p>满149元可用</p>
                    </div>
                    <div class="mui-media-body">
                        <div class="mui-ellipsis">标题</div>
                    </div>
                    <div class="my-right-middel">
                        <span>全平台</span>
                    </div>
                    <div class="my-right-bottom">
                        <p>2019-01-22</p>
                    </div>
                </a>
                <div class="my-zs-sy">
                    <div class="my-zs mui-hidden">赠送</div>
                    <div class="my-line mui-hidden"></div>
                    <div class="my-sy">使用</div>
                </div>
            </li>

        </ul>
    </div>

</div>
<script src="../js/mui.min.js"></script>
<script>
    mui.init();

    function dbsy(){
        mui.alert("11")
    }


</script>

</body>

</html>

