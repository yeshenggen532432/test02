<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
	<meta name="referrer" content="never">
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.product-grid td {
			padding: 0;
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
		<%--2右边：表格start--%>
		<div class="layui-col-md12">
			<%--表格：头部start--%>
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal">
						<div class="form-group" style="margin-bottom: 10px;">
							<div class="col-xs-12">
								<button id="freshButton" class="k-button" uglcw-role="button"><i class="k-icon k-i-refresh"></i>刷新</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%--表格：头部end--%>

			<%--表格：start--%>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '/manager/getMaterialList?type=news&total=${news_count}',
                    		criteria: '.form-horizontal',
                    	">
						<div data-field="media_id" uglcw-options="width:300,hidden: true">素材id</div>
						<div data-field="thumb" uglcw-options="width:300,template: uglcw.util.template($('#thumb').html())">封面</div>
						<div data-field="title" uglcw-options="width:200,tooltip: true, template: uglcw.util.template($('#title').html())">标题</div>
						<div data-field="author" uglcw-options="width:70,template: uglcw.util.template($('#author').html())">作者</div>
						<div data-field="update_time" uglcw-options="width:180,template: uglcw.util.template($('#update_time').html())">更新日期</div>
						<div data-field="news_url" uglcw-options="width:80,template: uglcw.util.template($('#news_url').html())">浏览</div>
						<div data-field="del" uglcw-options="width:100,template: uglcw.util.template($('#del').html())">删除</div>
						<%--<div data-field="shopWarePrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_pfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWarePrice, data: row, field:'pfPrice'})
								}
								">
						</div>
						<div data-field="shopWarePrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_pfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWarePrice, data: row, field:'pfPrice'})
								}
								">
						</div>--%>
					</div>
				</div>
			</div>
			<%--表格：end--%>
		</div>
		<%--2右边：表格end--%>
	</div>
</div>

<%--添加关键词--%>
<script type="text/x-uglcw-template" id="keywordAddDiv">
	<div class="layui-card">
		<div class="layui-card-body">
			<form class="form-horizontal" uglcw-role="validator">
				<div class="form-group">
					<label class="control-label col-xs-6">关键词</label>
					<div class="col-xs-16">
						<textarea uglcw-role="textbox" uglcw-model="keyword"  uglcw-validate="required" maxlength="30" uglcw-options="min: 1, max: 30"></textarea>
					</div>
				</div>
			</form>
		</div>
	</div>
</script>

<%--上架状态--%>
<script id="header_pfPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('pfPrice');">商城批发价(大)✎</span>
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('lsPrice');">商城零售价(大)✎</span>
</script>
<script id="header_cxPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('cxPrice');">商城大单位促销价✎</span>
</script>
<script id="header_minPfPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minPfPrice');">商城批发价(小)✎</span>
</script>
<script id="header_minLsPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minLsPrice');">商城零售价(小)✎</span>
</script>
<script id="header_minCxPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minCxPrice');">商城小单位促销价✎</span>
</script>
<script id="price" type="text/x-uglcw-template">
	# var wareId = data.wareId #
	# if(val == null || val == undefined || val === '' || val== "undefined"){ #
	# 	val = "" #
	# } #

	<input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric" uglcw-validate="number" style="height:25px;display:none" onchange="changePrice(this,'#= field #','#= wareId #')"  value='#= val #'>
	<span class="#=field#_span" id="#=field#_span_#=wareId#" >#= val #</span>

</script>
<script id="edit" type="text/x-uglcw-template">
	<button onclick="javascript:editKeyword('#= data.keyword#');" class="k-button k-info">编辑</button>
</script>
<script id="del" type="text/x-uglcw-template">
	<button onclick="javascript:deleteNewsMaterial('#= data.media_id#');" class="k-button k-error">删除</button>
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
<script id="upload" type="text/x-uglcw-template">
	#if(data.mediaId == ""){#
	<button onclick="javascript:uploadImageMaterial('#= data.keyword#');" class="k-button k-info">上传</button>
	#}else{#
	<button onclick="javascript:uploadImageMaterial('#= data.keyword#');" class="k-button k-info">重新上传</button>
	#}#
</script>
<script id="url" type="text/x-uglcw-template">
	<input  type="image" src="#= data.url#" height="180" width="280" align="middle" style="margin-top:10px;margin-bottom:10px;"/>
</script>
<script id="update_time" type="text/x-uglcw-template">
	#var timestamp =new Date(data.update_time*1000);#
	#var update_time = timestamp.toLocaleString();#
	#=update_time#
</script>
<script id="thumb" type="text/x-uglcw-template">
	#var thumb_photo= data.content.news_item[0].thumb_url;#
	<input  type="image" src="#=thumb_photo#" height="180" width="280" align="middle" style="margin-top:10px;margin-bottom:10px;"/>
</script>
<script id="title" type="text/x-uglcw-template">
	#var title=data.content.news_item[0].title;#
	#=title#
</script>
<script id="author" type="text/x-uglcw-template">
	#var author=data.content.news_item[0].author;#
	#=author#
</script>
<script id="news_url" type="text/x-uglcw-template">
	#var url= data.content.news_item[0].url;#
	<input style="width:60px;height:27px" type="button" value="浏览" onclick="showNews('#=url#')" />
</script>



<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/javascript" src="resource/jquery.upload.js"></script>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

		/* //增加关键词
		 uglcw.ui.get('#addKeyWordButton').on('click', function () {
		 uglcw.ui.Modal.open({
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

		 })*/


        //刷新
        uglcw.ui.get('#freshButton').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })

        resize();
        $(window).resize(resize);
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
        var display =$("."+field+"_input").css('display');
        if(display == 'none'){
            $("."+field+"_input").show();
            $("."+field+"_span").hide();
        }else{
            $("."+field+"_input").hide();
            $("."+field+"_span").show();
        }
    }

    function changePrice(o,field,wareId){
        $.ajax({
            url: "manager/shopWare/updateShopWarePrice2",
            type: "post",
            data: "id=" + wareId + "&price=" + o.value +"&field="+field,
            success: function (data) {
                if (data == '1') {
                    $("#"+field+"_span_"+wareId).text(o.value);
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }

    function toSubscribeReply(){
        //打开自定义被关注回复页面
        var url="/manager/weiXinReply/toSubscribeReply";
        mainiframe.location.href=url;
    }
    function toReceiveReply(){
        //打开自定义收到消息回复页面
        var url="/manager/weiXinReply/toReceiveReply";
        mainiframe.location.href=url;
    }
    function toKeywordReply(){
        //打开自定义关键词分页页面
        var url="/manager/weiXinReply/toKeywordReply";
        mainiframe.location.href=url;
    }
    //打开编辑页面
    function editKeyword(keyword){
        var url="/manager/weiXinReply/toKeywordReplyDetail?keyword="+keyword;
        window.location.href=url;
    }

    //删除关键词
    function deleteKeyword(keyword){
        uglcw.ui.confirm('你确定要删除关键词 '+keyword+' 吗?',function(){
            var deleteKeyword_url="/manager/weiXinReply/deleteKeyword?keyword="+keyword;
            var msg=$.ajax({url:deleteKeyword_url,async:false});
            var json=$.parseJSON(msg.responseText);
            if(json.state){
                uglcw.ui.success("删除成功!");
                uglcw.ui.get('#grid').reload();
            }else{
                uglcw.ui.error("删除失败!");
            }
        })
    }

    //添加关键词
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
    }

    //自定义被关注回复
    function toSubscribeReply(){
        //打开自定义被关注回复页面
        var url="/manager/weiXinReply/toSubscribeReply";
        uglcw.ui.openTab('自定义被关注回复', url);
    }

    //打开自定义收到消息回复页面
    function toReceiveReply(){
        var url="/manager/weiXinReply/toReceiveReply";
        uglcw.ui.openTab('自定义收到消息回复', url);
    }

    // 上传单张图片到驰用T3
    function uploadImageTouglcw(){
        var postImage_Url="/manager/WeixinConfig/uploadWeixinImage";
        $.upload({
            // 上传地址
            url:postImage_Url,
            // 文件域名字
            fileName: 'fileUpload',
            // 上传完成后, 返回json, text
            dataType: 'json',
            // 上传之前回调,return true表示可继续上传
            onSend: function() {
                return true;
            },
            // 上传之后回调
            onComplate:function(data){
                if(data.state){
                    queryImage();
                }else{
                    uglcw.ui.success(data.msg);
                }
            },
        });
    }

    //刷新
    function queryImage() {
        uglcw.ui.clear('.form-horizontal');
        uglcw.ui.get('#grid').reload();
    }

    // 上传单张图片到驰用T3
    function uploadImageTouglcw(){
        var postImage_Url="/manager/WeixinConfig/uploadWeixinImage";
        $.upload({
            // 上传地址
            url:postImage_Url,
            // 文件域名字
            fileName: 'fileUpload',
            // 上传完成后, 返回json, text
            dataType: 'json',
            // 上传之前回调,return true表示可继续上传
            onSend: function() {
                return true;
            },
            // 上传之后回调
            onComplate:function(data){
                if(data.state){
                    queryImage();
                }else{
                    uglcw.ui.success(data.msg);
                }
            },
        });
    }

    // 批量上传多张图片到驰用T3
    function uploadImages(){
        $("#fileUpload").click();
        return false;
    }

    //批量上传图片到驰用T3
    function uploadImagesTouglcw(){
        //检查批量上传的图片的数量
        var files = $("#fileUpload")[0].files;
        if(files.length==0){
            uglcw.ui.error("没有图片");
            return;
        }

        if(files.length>50){
            uglcw.ui.error("1次上传不能超过50张图片");
            $("#fileUpload").val("");
            return;
        }
        //检查批量上传的图片的类型
        var fileExt = "";
        for(var i=0;i<files.length;i++){
            fileExt=(files[i].name).substring(files[i].name.lastIndexOf(".")).toLowerCase();
            if(!fileExt.match(/.jpg|.jpeg|.gif|.png|.bmp/)){
                uglcw.ui.error(files[i].name+"不是jpg、jpeg、gif、png、bmp类型的图片文件");
                $("#fileUpload").val("");
                return;
            }
        }
        //检查批量上传的图片的大小
        for(var i=0;i<files.length;i++){
            var fileSize=files[i].size;
            if(fileSize>2*1024*1024){
                uglcw.ui.error(files[i].name+"的大小超过了2MB");
                $("#fileUpload").val("");
                return;
            }
        }
		/* //上传图片到驰用T3
		 $("#uploadImagesForm").form('submit',{
		 success:function(data){
		 var dataJson = JSON.parse(data);
		 if(dataJson.state){
		 $.messager.alert('消息','上传成功!','info');
		 queryImage();
		 $("#fileUpload").val("");
		 }else{
		 $.messager.alert('消息','上传失败!','info');
		 $("#fileUpload").val("");
		 }
		 }
		 });*/

        //上传图片到驰用T3
        var formData = new FormData();
        console.log($("#fileUpload"));
        for(var i=0;i<files.length;i++){
            formData.append('fileUpload',files[i]);
        };
        //  formData.append('fileUpload',document.getElementById("fileUpload").files[0]);
        $.ajax({
            url:"${base}/manager/WeixinConfig/uploadWeixinImages",
            type:"post",
            data:formData,
            processData:false,
            contentType:false,
        }).done(function(data) { //回调函数
            if(data.state){
                uglcw.ui.success("上传成功!");
                queryImage();
                $("#fileUpload").val("");
            }else{
                uglcw.ui.error("上传失败!");
                $("#fileUpload").val("");
            }
        });
        return false;
    }


    //微信公众平台图片管理
    function toWeixinImageManager(){
        var url="/manager/WeixinConfig/toWeixinImageMaterialPage";
        uglcw.ui.openTab('微信公众平台图片管理', url);
    }
    //微信公众平台图文管理
    function toWeixinNewsManager(){
        var url="/manager/WeixinConfig/toWeixinNewsMaterialPage";
        uglcw.ui.openTab('微信公众平台图文管理', url);
    }

    //删除
    function deleteImageMaterial(media_id){
        uglcw.ui.confirm( '你确定要删除吗?',function(){
            var deleteImageMaterial_url="/manager/deleteMaterial?media_id="+media_id;
            var msg=$.ajax({url:deleteImageMaterial_url,async:false});
            var json=$.parseJSON(msg.responseText);
            if(json.errcode==0){
                uglcw.ui.success("删除成功!");
                queryImageMaterial();
            }else{
                uglcw.ui.error("删除失败!"+" json.errcode:"+json.errcode+" ,json.errmsg:"+json.errmsg);
            }
        })
    }


    //查询
    function queryImageMaterial(){
        var msg=$.ajax({url:"/manager/getMaterialCount",async:false});
        var json=$.parseJSON(msg.responseText);
        var image_count=json.image_count;
        $("#num").html(image_count);
        uglcw.ui.get('#grid').reload();
    }


    //查询
    function queryNewsMaterial(){
        var msg=$.ajax({url:"/manager/getMaterialCount",async:false});
        var json=$.parseJSON(msg.responseText);
        var news_count=json.news_count;
        $("#num").html(news_count);
        uglcw.ui.get('#grid').reload();
    }

    function showNews(url){
        window.open(url,'浏览图文消息');
    }

    //删除
    function deleteNewsMaterial(media_id){
        uglcw.ui.confirm( '你确定要删除吗?',function(){
                var deletePhotoMaterial_url="/manager/deleteMaterial?media_id="+media_id;
                var msg=$.ajax({url:deletePhotoMaterial_url,async:false});
                var json=$.parseJSON(msg.responseText);
                if(json.errcode==0){
                    uglcw.ui.success("删除成功!");
                    queryNewsMaterial();
                }else{
                    uglcw.ui.error("删除失败!"+" json.errcode:"+json.errcode+" ,json.errmsg:"+json.errmsg);
                }
        })
    }

</script>
</body>
</html>
