<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style type="text/css">
        .product-grid td {
            padding: 0;
        }
        .textarea{
            width:380px;
            height:180px;
            resize:none;
            align:center;
            margin-left:15px;
            margin-top: 20px;
        }
        #replyContentImage input{
            width:300px;
        }
        #replyContentImage p{
            margin-left:30px;
        }
        #imageTable{
            border:2px solid #F4F4F4;
            background:#ffffff;
            width:380px;
            height:180px;
            margin-top:20px;
            margin-left:30px;
            cellspacing:0;
            cellpadding:0;
        }
        #imageTable td{
            border:2px solid #F4F4F4;
            align:center;
        }
        #imageTable button{
            width:60px;
        }
        #imageTable img{
            width:280px;
            height:180px;
        }
        #replyContent button{
            width:80px;
            height:30px;
            position:relative;
            left:15%;
            font-size:13px;
        }
        #replyContent p{
            margin-top:20px;
            margin-left:20px;
            font-size:13px;
            margin-bottom:10px;
        }
        #replyContent label{
            margin-top:20px;
            padding-left:20px;
        }
        .layui-fluid {
            padding-top: 0px;
            padding-left: 0px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <%--1左边：商品分类start--%>
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <div class="form-horizontal">
                        <div class="form-group" style="margin-bottom: 10px;">
                            <label class="control-label col-xs-3">回复内容</label>
                            <div class="col-xs-5">
                                <ul uglcw-role="radio" uglcw-model="radio" id="contentRadio"
                                    uglcw-value="1"
                                    uglcw-options='layout:"horizontal",
                                    change:function(v){ replyContentType(v); },
                                    dataSource:[{"text":"文字","value":"text"},{"text":"图片","value":"image"}]
                                    '></ul>
                            </div>
                            <div class="col-xs-3">
                                <button uglcw-role="button" class="k-success" id="saveButton">保存</button>
                            </div>
                        </div>

                        <div class="form-group" style="margin-bottom: 10px;">
                           <%-- <label class="control-label col-xs-3">textarea</label>--%>
                            <div id="replyContentTextareaDiv">
                               <form class="form-horizontal" uglcw-role="validator" id="textareaForm">
                                    <div class="col-xs-11" style="width:410px;">
                                        <textarea uglcw-role="textbox" uglcw-model="textarea" id="replyContentTextarea"
                                                  uglcw-validate="required" maxlength="600" uglcw-options="min: 1, max: 600"
                                                  class="textarea" style="width:380px;
                                                                            height:184px;
                                                                            resize:none;
                                                                            align:center;
                                                                            margin-left:15px;
                                                                            margin-top: 20px;"></textarea>
                                    </div>
                               </form>
                            </div>

                           <div id="replyContentImage">
                               <table  id="imageTable">
                                   <tr>
                                       <td width="280">
                                           <img id="buttonImage" alt="" src="">
                                       </td>
                                       <td  width="100">
                                           <a  class="k-button k-info" href="javascript:showImageWin();">
                                               <i class="k-icon k-i-plus-circle"></i>设置图片</a>
                                       </td>
                                   </tr>
                               </table>
                               <p style="display: none;">image_id:&nbsp;&nbsp;&nbsp;<label  id="buttonImagID" stype="width:200px"/></p>
                           </div>
                            <%--<div class="col-xs-6">
                                <button id="addKeyWordButton" class="k-button k-info" uglcw-role="button">增加关键词</button>
                                <button id="freshButton" class="k-button" uglcw-role="button">刷新</button>
                            </div>--%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>





<%--设置图片--%>
<script type="text/x-uglcw-template" id="keywordAddDiv">
    <div class="layui-col-md12">
        <div class="layui-card">
            <div class="layui-card-body">
                <div id="grid" uglcw-role="grid"
                     uglcw-options="
                                id:'id',
                                checkbox:true,
                                pageable: true,
                                url: '${base}/manager/WeixinConfig/imagePage',
                                criteria: '.form-horizontal',
                            ">
                    <div data-field="id" uglcw-options="width:60">图片id</div>
                    <div data-field="picMini" uglcw-options="width:200,template: uglcw.util.template($('#picMini').html())">图片</div>
                    <div data-field="uploadTime" uglcw-options="width:150"> 上传日期</div>
                    <div data-field="mediaId" uglcw-options="width:130,template: uglcw.util.template($('#mediaId').html())">微信公众平台图片</div>
                    <div data-field="setImage" uglcw-options="width:80,template: uglcw.util.template($('#setImage').html())">设置</div>
                </div>
            </div>
        </div>
    </div>
</script>


<script id="edit" type="text/x-uglcw-template">
    <button onclick="javascript:editKeyword('#= data.keyword#');" class="k-button k-info">编辑</button>
</script>
<script id="delete" type="text/x-uglcw-template">
    <button onclick="javascript:deleteKeyword('#= data.keyword#');" class="k-button k-info">删除</button>
</script>
<script id="picMini" type="text/x-uglcw-template">
    <input  type="image" src="upload/#= data.picMini#" height="180" width="180" align="middle"
                    style="margin-top:10px;margin-bottom:10px;"/>
</script>
<script id="mediaId" type="text/x-uglcw-template">
    #if(data.mediaId == ""){#
    未上传
    #}else{#
    已上传
   #}#
</script>
<script id="setImage" type="text/x-uglcw-template">
    <input style='width:60px;height:27px' type='button' value='设置' onclick='setImageMaterial("#= data.pic#","#= data.id#")' />
</script>



<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //选择单选框
        var subscribeStatus="${config.subscribeStatus}";
        if("${config.id}"==""){
            var weixinConfigId=0;
        }else{
            var weixinConfigId="${config.id}";
        }
        var getWeixinConfig_url="/manager/weiXinReply/getSubscribeReplyText?weixinConfigId="+weixinConfigId;
        var subscribeTex="";
        var msg=$.ajax({url:getWeixinConfig_url,async:false});
        if(msg.responseText==""){//文本为空
            /*var radioText=$("#radioText");
            radioText.prop("checked","checked");*/
            uglcw.ui.bind('body',{radio:'text'})
            replyContentType("text");
        }else{
            var json=$.parseJSON( msg.responseText ) ;
            var subscribeReplyTextMap=json.subscribeReplyTextMap;
            if(json.state){
                var subscribeImageId="${config.subscribeImageId}";
                var radioText=$("#radioText");
                var radioImage=$("#radioImage");
                if(subscribeStatus == "0"){
                   /* radioText.prop("checked","checked");
                    replyContentType();*/
                    uglcw.ui.bind('body',{radio:'text'})
                    replyContentType("text");
                    $("#replyContentTextarea").val( subscribeReplyTextMap.subscribe_text);
                }else{
                    if(subscribeImageId == "" || subscribeImageId == null){
                       /* radioText.prop("checked","checked");
                        replyContentType();*/
                        uglcw.ui.bind('body',{radio:'text'})
                        replyContentType("text");
                        $("#replyContentTextarea").val( subscribeReplyTextMap.subscribe_text);
                    }else{
                        /*radioImage.prop("checked","checked");
                        replyContentType();*/
                        uglcw.ui.bind('body',{radio:'image'})
                        replyContentType("image");
                        var getImage_url="/manager/weiXinReply/getSubscribeImageUrl?subscribeImageId="+subscribeImageId;
                        var msg=$.ajax({url:getImage_url,async:false});
                        if(msg.responseText==""){
                            uglcw.ui.error("查询图片失败！");
                        }else{
                            var json=$.parseJSON( msg.responseText ) ;
                            var ImageMap=json.ImageMap;
                            var ImageUrl=ImageMap.pic;
                            ImageUrl="upload/"+ImageUrl;
                            $("#buttonImage").attr("src",ImageUrl);
                        }
                        $("#buttonImagID").html(subscribeImageId);
                    }
                }
            }else{
                uglcw.ui.error("查询回复内容失败！");
            }
        }

        /*resize();
        $(window).resize(resize);*/
        uglcw.ui.loaded();
    })

    var delay;
    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - 40;
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

    //---------------------------------------------------------------------------------------------------------------

    function operatePrice(field) {
        var display = $("." + field + "_input").css('display');
        if (display == 'none') {
            $("." + field + "_input").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").hide();
            $("." + field + "_span").show();
        }
    }

    function changePrice(o, field, wareId) {
        $.ajax({
            url: "manager/shopWare/updateShopWarePrice2",
            type: "post",
            data: "id=" + wareId + "&price=" + o.value + "&field=" + field,
            success: function (data) {
                if (data == '1') {
                    $("#" + field + "_span_" + wareId).text(o.value);
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }

    function toSubscribeReply() {
        //打开自定义被关注回复页面
        var url = "/manager/weiXinReply/toSubscribeReply";
        mainiframe.location.href = url;
    }
    function toReceiveReply() {
        //打开自定义收到消息回复页面
        var url = "/manager/weiXinReply/toReceiveReply";
        mainiframe.location.href = url;
    }
    function toKeywordReply() {
        //打开自定义关键词分页页面
        var url = "/manager/weiXinReply/toKeywordReply";
        mainiframe.location.href = url;
    }
    //打开编辑页面
    function editKeyword(keyword) {
        var url = "/manager/weiXinReply/toKeywordReplyDetail?keyword=" + keyword;
        window.location.href = url;
    }

    //删除关键词
    function deleteKeyword(keyword) {
        uglcw.ui.confirm('你确定要删除关键词 ' + keyword + ' 吗?', function () {
            var deleteKeyword_url = "/manager/weiXinReply/deleteKeyword?keyword=" + keyword;
            var msg = $.ajax({url: deleteKeyword_url, async: false});
            var json = $.parseJSON(msg.responseText);
            if (json.state) {
                uglcw.ui.success("删除成功!");
                uglcw.ui.get('#grid').reload();
            } else {
                uglcw.ui.error("删除失败!");
            }
        })
    }

   /* //添加关键词
    function addKeyword() {
        uglcw.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                if (row) {
                    uglcw.ui.bind($(container), row);
                }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/shopWareGroup/editGroup',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '2') {
                            uglcw.ui.success('修改成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '3') {
                            uglcw.ui.error('该分组名称已存在');
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })
    }*/

    //自定义被关注回复
    function toSubscribeReply() {
        //打开自定义被关注回复页面
        var url = "/manager/weiXinReply/toSubscribeReply";
        uglcw.ui.openTab('自定义被关注回复', url);
    }

    //打开自定义收到消息回复页面
    function toReceiveReply() {
        var url = "/manager/weiXinReply/toReceiveReply";
        uglcw.ui.openTab('自定义收到消息回复', url);
    }

    //保存
    uglcw.ui.get('#saveButton').on('click', function () {

        saveReply();

    })

    //单选框选择文字或者图片
    //单选框
    function replyContentType(v){
        switch(v){
            case "text":
                $("#replyContentTextareaDiv").show();
                $("#replyContentImage").hide();
                break;
            case "image":
                $("#replyContentTextareaDiv").hide();
                $("#replyContentImage").show();
                break;
            default:break;
        }
    }

    //保存自定义回复
    //保存
    function saveReply(){
        if("${config.id}"==""){
            uglcw.ui.error("请先保存公众号配置！");
        }else{
           // var ContentType=$("input[name=replyContentType]:checked").val();
            var ContentType=uglcw.ui.bind('body').radio;
            var subscribeImageId="${config.subscribeImageId}";
            switch(ContentType){
                case "text":
                    $("#buttonImagID").html("")
                    $("#buttonImage").attr('src',"");
                    var saveReply_url="/manager/weiXinReply/updateSubscribeReply";
                    var valid = uglcw.ui.get('#textareaForm').validate();
                    if (valid){
                        $.ajax({
                            url:saveReply_url,
                            data:{"type":ContentType,"value":$("#replyContentTextarea").val()},
                            //data:"type="+ContentType+"&value="+$("#replyContentTextarea").val(),
                            type:"post",
                            success:function(data){
                                if(data=="1"){
                                    uglcw.ui.success("保存成功!");
                                }else{
                                    uglcw.ui.error("保存失败");
                                }
                            }
                        });
                    }
                    break;
                case "image":
                    $("#replyContentTextarea").val("");
                    var saveReply_url="/manager/weiXinReply/updateSubscribeReply";
                    if($("#buttonImagID").html()=="")  {
                        uglcw.ui.error("请选择图片");
                    }else{
                        $.ajax({
                            url:saveReply_url,
                            data:{"type":ContentType,"value":$("#buttonImagID").html()},
                            type:"post",
                            success:function(data){
                                if(data=="1"){
                                    uglcw.ui.success("保存成功!");
                                }else{
                                    uglcw.ui.error("保存失败");
                                }
                            }
                        });
                    }
                    break;
                default:break;
            }
        }
    }


    //设置图片
    function showImageWin(){
        /*$("#imageDiv").window({title:"设置图片",modal:true});
        queryImageMaterial();
        $("#imageDiv").window('open');
        $("#imageDiv").window('center');*/

        uglcw.ui.Modal.open({
            area: ['800px','400px'],
            content: $('#keywordAddDiv').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container).find('form'));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}/manager/weiXinReply/addKeyword',
                    type: 'post',
                    data: data,
                    async: false,
                    success:function(data){
                        uglcw.ui.loaded();
                        if(data=="1"){
                            uglcw.ui.success("保存成功!");
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        }else{
                            if(data=="0"){
                                uglcw.ui.error("保存失败!关键词已存在!");
                            }else{
                                uglcw.ui.error("保存失败");
                            }
                        }
                    }
                })
                return false;
            }
        })



    }

    //查询图片
    function queryImageMaterial(){
        $('#imageDatagrid').datagrid({
            url:"/manager/WeixinConfig/imagePage"
        });
    }

    //设置图片
    function setImageMaterial(ImageUrl,image_id){
        ImageUrl="upload/"+ImageUrl;
        $("#buttonImage").attr("src",ImageUrl);
        $("#buttonImagID").html(image_id);
        uglcw.ui.Modal.close();
    }

</script>
</body>
</html>
