<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>充值列表</title>
	<%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
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
		<h1 class="mui-title">充值记录</h1>
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
		$.ajax({
			url:"<%=basePath%>/web/shopMemberIo/queryShopMemberIoPage",
			data : {"token":"${token}","ioFlags":1,"pageNo":pageNo,"pageSize":pageSize},
			type:"POST",
			success:function(json){
				 if(json && json.state){
					var str="";
					var datas = json.obj.rows;
					if(datas!=null && datas!=undefined && datas.length>0){
						pageNo++;
						for(var i=0;i<datas.length;i++){
							var inputCash = datas[i].inputCash;
							var freeCost = datas[i].freeCost;
							var ioTimeStr = datas[i].ioTimeStr;
							str += "<li class=\"mui-table-view-cell\">"
							str += "<div class=\"mui-table\">"
							str += "<div class=\"mui-table-cell mui-col-xs-8\">"
							str += "<h4 class=\"mui-ellipsis\">充值金额："+inputCash+"元</h4>"
							str += "<h5>"+ioTimeStr+"</h5>"
							str += "</div>"
							str += "<div class=\"mui-table-cell mui-col-xs-4 mui-text-right\">"

							var isAdd = "";
							str += "<h5 class=\"mui-ellipsis "+ isAdd+"\">赠送："+freeCost+"元</h5>"
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
