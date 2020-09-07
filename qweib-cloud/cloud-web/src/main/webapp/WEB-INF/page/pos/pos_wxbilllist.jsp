<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>

    <link rel="stylesheet" href="<%=basePath %>/resource/posstyle/css/xunjia_wuliao.css"/>
    <link rel="stylesheet" href="<%=basePath %>/resource/posstyle/css/weui.min.css"/>
    <title>消费列表</title>
    <style>
        .mui-table h4,.mui-table h5,.mui-table .mui-h5,.mui-table .mui-h6,.mui-table p{
            margin-top: 0;
        }
        .mui-table h4{
            line-height: 21px;
            font-weight: 500;
        }
        .add{
            color: #00a6fb;
        }

        .mui-scroll-wrapper {
            top: 25px;
        }
    </style>
</head>
<body>
<div>
    <header class="mui-bar mui-bar-nav">
        <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>

    </header>
    <input type="hidden" id="cardId" value="${cardId}">
    <%--	<div class="mui-content">
            <ul id="wareList" class="mui-table-view mui-table-view-striped mui-table-view-condensed"></ul>
        </div>--%>



            <!--数据列表-->
            <%--<ul id="wareList" class="mui-table-view mui-table-view-chevron"></ul>--%>
    <div id="pullrefresh" class="mui-scroll-wrapper">
        <div class="mui-scroll">
           <!-- <article style="bottom: 0;">-->
            <div class="weui_cells weui_cells_access" id="wareList">



            </div>
           <!-- </article>-->
        </div>
    </div>

    <%--
        <div id="pullrefresh" class="mui-content mui-scroll-wrapper">
            <div class="mui-scroll">
                <!--数据列表-->
                &lt;%&ndash;<ul id="wareList" class="mui-table-view mui-table-view-chevron"></ul>&ndash;%&gt;
                <ul id="wareList" class="mui-table-view"></ul>
            </div>
        </div>
    --%>
</div>

</body>
<script>
    /*$(document).ready(function() {
        $.wechatShare();//分享
    })*/
    mui.init({
        pullRefresh: {
            container: '#pullrefresh',
            up: {
                auto:true,
                contentrefresh: '正在加载...',
                callback: pullupRefresh
            }
        }
    });

    var pageNo = 1 ;
    var pageSize = 10 ;
    var wareType = "";
    //获取商品列表
    function pullupRefresh(){
        var cardId = $("#cardId").val();
        $.ajax({
            url:"<%=basePath%>/web/queryPosSaleSub",
            data : {"token":"${token}","cardId":cardId,"pageNo":pageNo,"pageSize":pageSize},
            type:"POST",
            success:function(json){
                if(json){
                    var str="";
                    var datas = json.rows;
                    if(datas!=null && datas!=undefined && datas.length>0){
                        pageNo++;
                        for(var i=0;i<datas.length;i++){


                        str += '<a class="weui_cell" href="javascript:;">';
                        str+= '        <div class="weui_cell_bd weui_cell_primary">';
                        str += '        <div class="wuliao-title">';
                        str += '        <label>单号:' + datas[i].docNo + '</label>';
                        str += '    <span></span>';
                        str += '    </div>';
                        str += '    <div class="detail clearfix">';
                        str += '        <span class="date">消费时间：' + datas[i].billDate + '</span>';
                        str += '    <span class="require">价格：<label>￥' + datas[i].disPrice + '</label></span>';
                        str += '    <span class="result">数量：<label>' + datas[i].qty + '</label></span>';
                        str += '    </div>';
                        str += '    <div class="org">';
                        str += '        <span>商品名称：'  + datas[i].wareNm + '</span>';
                        str += '    <label class="green">单据详情</label>';
                        str += '        </div>';
                        str += '        </div>';
                        str += '        </a>';

                        }
                        $("#wareList").append(str);
                    }
                    var isEnd = false;
                    if(datas.length<10){
                        isEnd = true;
                    }
                    mui('#pullrefresh').pullRefresh().endPullupToRefresh(isEnd);//参数为true代表没有更多数据了。
                }else{
                    mui('#pullrefresh').pullRefresh().endPullupToRefresh(false);
                    mui.toast(json.msg);
                }
            },
            error:function (data) {
                mui('#pullrefresh').pullRefresh().endPullupToRefresh(false);
            }
        });
    }
</script>
</html>
