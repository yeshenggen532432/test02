<%@ page language="java" pageEncoding="UTF-8"%>
<div class="container_ware_details"><%--<iframe id="details_iframe" frameborder="0" width="100%" height="100%" style="display:none;position: fixed; z-index: 200000;"></iframe>--%></div>
<script type="text/javascript">
    var parentTitle=window.document.title;
    /*  history.pushState(null, null, document.URL);//去除历史记录
      window.addEventListener("popstate",function(e) {
          console.log("toWareDetails--popstate")
      }, false);*/
    //商品详情
    function toWareDetails(wareId){
        var url="<%=basePath%>/web/shopWareMobile/toWareDetails?token="+getToken()+"&wareId="+wareId+"&companyId="+getWid();
        if($(".container_ware_details").length==0||browser.versions.ios) {
            //window.location.href = url;
            toPage(url);
            return
        }else {
            if($("#details_iframe").length==0) {
                $(".container_ware_details").html('<iframe id="details_iframe" frameborder="0" width="100%" height="100%" style="position: fixed; z-index: 200000;" src="'+url+'"></iframe>');
            }else{
                $("#details_iframe").attr("src", url);
                //$("#details_iframe").css("display", "block");
            }
        }
    }
    //iframe 中点击返回时特殊处理
    function backClick() {console.log("backClick")
        $("#details_iframe").remove();
        /* $("#details_iframe").css("display","none");
         $("#details_iframe").attr("src", "about:blank");
         var cssHtml='<style type="text/css">.Loading{ background:url("<%=basePath%>/resource/shop/mobile/images/loading.gif") 50% no-repeat #fff; width:100%; height:100%; overflow:hidden; position:fixed; left:0; top:0; z-index:100;background-size: 80px 80px;}</style>';
        var html='<section class="Loading"></section>';
        document.getElementById("details_iframe").contentWindow.document.body.innerHTML = cssHtml+html;*/
        if(window.parent && !browser.versions.ios) {
            window.parent.document.title = parentTitle;
            changeParentShare(null);
        }else{
            history.back();
        }
    }

    //iframe商品详情修改父页面分享问题
    function changeParentShare(shareData) {
        wechatShare(shareData);//分享
    }
</script>