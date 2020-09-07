<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
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
        <ul class="mui-table-view" id = "ticketList">
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

<script>
    mui.init();

    function dbsy(){
        mui.alert("11")
    }

    function loadTicket(){

        var index = 0;
        $.ajax({
            url:"<%=basePath %>/web/queryPosMemberTicket",//
            data: "token=${token}",
            type:"post",
            success:function(data){
                if(data){
                    var list = data.rows;
                    var text = "";
                    for(var i = 0;i < list.length; i++)
                    {
                    text += '<li class="mui-table-view-cell mui-media" >';
                        text += '<a href="javascript:;" >';
                        text += '<div class="my-left">';
                        text += '<h4>￥' + list[i].amt + '</h4>';
                        //<p>满149元可用</p>
                        text += '</div>';
                        text += '<div class="mui-media-body">';
                        text += '<div class="mui-ellipsis-2">' + list[i].ticketName + '</div>';
                        text += '</div>';
                        text += '<div class="my-right-middel">';
                        text += '<span>全平台</span>';
                        text += '</div>';
                        text += '<div class="my-right-bottom">';
                        text += '<p>有效期' + list[i].endDate + '</p>';
                        text += '</div>';
                        text += '<div class="new">';
                        text += ' 新到';
                        text += '</div>';
                        text += '</a>';
                        text += '<div class="my-zs-sy">';
                        text += '<div class="my-zs">赠送好友</div>';
                        text += '<div class="my-line"></div>';

                        text += '<div class="my-sy" onclick="useClick(' + list[i].id + ')">使用</div>';

                        text += '</div>';
                        text += '</li>';
                    }
                    $("#ticketList").html(text);

                }
            }
        });



    }
    loadTicket();
    function useClick(ticketId)
    {
        window.location.href = '<%=basePath %>/web/toPosTicketUse?token=${token}&ticketId=' + ticketId;
    }

</script>

</body>

</html>

