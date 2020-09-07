<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- --------head开始----------- -->
<head>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
    <title>账单列表</title>
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
            top: 44px;
        }
    </style>
</head>
<!-- --------head结束----------- -->

<!-- --------body开始----------- -->
<body>
<div>
    <header class="mui-bar mui-bar-nav">
        <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>

    </header>

    <%--	<div class="mui-content">
            <ul id="wareList" class="mui-table-view mui-table-view-striped mui-table-view-condensed"></ul>
        </div>--%>

    <div id="pullrefresh" class="mui-scroll-wrapper">
        <div class="mui-scroll">
            <!--数据列表-->
            <%--<ul id="wareList" class="mui-table-view mui-table-view-chevron"></ul>--%>
            <ul id="wareList" class="mui-table-view"></ul>
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
            url:"<%=basePath%>/web/queryPosMemberIo",
            data : {"token":"${token}","cardId":cardId,"pageNo":pageNo,"pageSize":pageSize},
            type:"POST",
            success:function(json){
                if(json){
                    var str="";
                    var datas = json.rows;
                    if(datas!=null && datas!=undefined && datas.length>0){
                        pageNo++;
                        for(var i=0;i<datas.length;i++){
                            var title = "";
                            var inputCash = datas[i].inputCash;
                            var freeCost = datas[i].freeCost;
                            if(datas[i].ioFlag == 0)title = "办卡" + inputCash + "元 赠送" + freeCost + "元";
                            if(datas[i].ioFlag == 1)title = "充值" + inputCash + "元 赠送" + freeCost + "元" ;
                            if(datas[i].ioFlag == 2)title = "消费" + datas[i].cardPay + "元 ";
                            if(datas[i].ioFlag == 9)title = "退卡";
                            if(datas[i].ioFlag == 10)title = "挂失";
                            if(datas[i].ioFlag == 11)title = "解挂";
                            if(datas[i].ioFlag == 99)title = "导入";
                            if(datas[i].ioFlag == 7)title = "补卡";
                            var ioTimeStr = datas[i].ioTimeStr;
                            str += "<li class=\"mui-table-view-cell\">"
                            str += "<div class=\"mui-table\">"
                            str += "<div class=\"mui-table-cell mui-col-xs-8\">"
                            str += "<h4 class=\"mui-ellipsis\">"+title+"</h4>"
                            str += "<h5>"+ioTimeStr+"</h5>"
                            str += "</div>"
                            str += "<div class=\"mui-table-cell mui-col-xs-4 mui-text-right\">"

                            var isAdd = "";
                            if(1==1){
                                //isAdd = "add"
                            }
                            str += "<h5 class=\"mui-ellipsis "+ isAdd+"\">余额："+datas[i].leftAmt+"元</h5>"
                            //str += "<h6>余额：120元</h6>"
                            str += "</div>"
                            str += "</div>"
                            str += "</li>"
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
