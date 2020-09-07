<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
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
		<div class="layui-col-md9">
			<%--表格：头部start--%>
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal">
						<div class="form-group" style="margin-bottom: 10px;">
							<div class="col-xs-24">
								<button id="uploadImageTouglcwButton" onclick="uploadImageTouglcw();"
										class="k-button " uglcw-role="button" style="display: inline;">
									<i class="k-icon k-i-upload"></i>上传单张图片</button>
								<form action="/manager/WeixinConfig/uploadWeixinImages" id="uploadImagesForm" name="uploadImagesForm" method="post" enctype="multipart/form-data" style="display: inline;">
									<button id="uploadImagesButton" onclick="return uploadImages();"
											class="k-button " uglcw-role="button">
										<i class="k-icon k-i-upload"></i>批量上传图片</button>
									<input type="file" style="display: none;" multiple="multiple" name="fileUpload" id="fileUpload" value="上传多张图片" onchange="uploadImagesTouglcw();"/>
									<button hidden="true" id="uploadButton" onclick="return uploadImagesTouglcw()" style="width:80px">上传</button>
								</form>
								<button id="uploadImagesMaterialButton" onclick="uploadImagesMaterial();"
										class="k-button " uglcw-role="button" style="display: inline;">
									<i class="k-icon k-i-upload"></i>批量上传选中行的图片到微信公众平台</button>
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
                    		url: '${base}/manager/WeixinConfig/imagePage',
                    		criteria: '.form-horizontal',
                    	">
						<div data-field="picMini" uglcw-options="width:200,template: uglcw.util.template($('#picMini').html())">图片</div>
						<div data-field="uploadTime" uglcw-options="width:150">上传日期</div>
						<div data-field="mediaId" uglcw-options="width:130,template: uglcw.util.template($('#mediaId').html())">微信公众平台图片</div>
						<div data-field="upload" uglcw-options="width:140,template: uglcw.util.template($('#upload').html())">上传到微信公众平台</div>
						<div data-field="remark" uglcw-options="width:100">备注</div>
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
<script id="upload" type="text/x-uglcw-template">
	#if(data.mediaId == ""){#
	<button onclick="javascript:uploadImageMaterial('#= data.id#','#= data.pic#');" class="k-button k-info">上传</button>
	#}else{#
	<button onclick="javascript:uploadImageMaterial('#= data.id#','#= data.pic#');" class="k-button k-info">重新上传</button>
	#}#
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/javascript" src="resource/jquery.upload.js"></script>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

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
	/*//图片管理
	 function toImageManager(){
	 var url="/manager/WeixinConfig/toImageMaterialPage";
	 mainiframe.location.href=url;
	 }*/
    //微信公众平台图片管理
    function toImageManager(){
        var url="/manager/WeixinConfig/toImageMaterialPage";
        uglcw.ui.openTab('图片管理', url);
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

    //上传图片到微信公众平台
    function uploadImageMaterial(id,pic){
        var imagePath="${uploadPath}"+"/"+pic;
        $.ajax({
            url:"/manager/postuglcwImage",
            data:"id="+id+"&imagePath="+imagePath,
            type:"post",
            dataType:"JSON",
            success:function(data){
                if(data.media_id != null){
                    uglcw.ui.get('#grid').reload();
                    uglcw.ui.success("上传成功！");
                }else{
                    uglcw.ui.error("上传失败！"+data.errmsg);
                }
            }
        });
    }

    //批量上传选中的图片到微信公众平台
    function uploadImagesMaterial(){
        var rows = uglcw.ui.get('#grid').selectedRow();
        if(rows == null){
            uglcw.ui.error("没有选中行！");
            return;
        }

        for(var i=0;i<rows.length;i++){
            var id=rows[i].id;
            var imagePath="${uploadPath}"+"/"+rows[i].pic;
            $.ajax({
                url:"/manager/postuglcwImage",
                async:false,
                data:"id="+id+"&imagePath="+imagePath,
                type:"post",
                dataType:"JSON",
                success:function(data){
                    if(data.media_id != null){//上传成功！
                    }else{//上传失败！
                        uglcw.ui.error("第"+i+"行图片上传失败！"+data.errmsg);
                    }
                }
            });
        }
        uglcw.ui.get('#grid').reload();
        uglcw.ui.success("图片已上传！");
    }


</script>
</body>
</html>
