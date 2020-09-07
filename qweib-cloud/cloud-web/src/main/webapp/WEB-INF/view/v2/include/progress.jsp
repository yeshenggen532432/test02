<%@ page language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    .progress{position: absolute;z-index: 1000;top: 30%;left: 30%;width:30%}
    .progress #parent{border:1px #EEE solid;height: 20px;margin: 0 auto;}
    .progress #child{width: 0%;height: 20px;background-color: lime;}
    .progress p{text-align: center;color: fuchsia;}
    .progress .close{position: inherit;right: 0px;color: blue}
</style>
<div class="progress hide">
    <div class="close" onclick="hideProgress()">隐藏</div>
    <p id="info" style="background-color: ghostwhite;">加载中....</p>
    <div id="parent">
        <div id="child"></div>
    </div>
</div>
<script>
    function showProgress(taskId,success) {
        if(!taskId)return false;
        $(".progress").removeClass("hide");
        //定时函数进行更新
        var interval=setInterval(function(){
            $.ajax({
                url:"${base}/sys/task/progress/"+taskId,
                async:false,
                success:function (data) {
                    if(data&&data.code==200){
                        data=data.data;
                        $("#child",".progress").width(data.progress+"%");
                        if(data.progress>=100) {
                            clearInterval(interval);
                            if(success)
                                success(data);
                        }else{
                            $("#info",".progress").html(data.remark);
                        }
                    }else{
                        clearInterval(interval);
                    }
                },error:function () {
                    clearInterval(interval);
                }
            });
        },1000);
    }
    function hideProgress() {
        $("#info",".progress").html("");
        $('.progress').addClass('hide');
        $("#child",".progress").width("0%");
    }

</script>
