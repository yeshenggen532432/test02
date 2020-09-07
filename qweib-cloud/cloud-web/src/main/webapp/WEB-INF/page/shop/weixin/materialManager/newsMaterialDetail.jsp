<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>图文消息编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script src="<%=basePath%>/resource/clipboard.min.js"></script>
	<script type="text/javascript" src="<%=basePath%>/resource/wangEditor/wangEditor.min.js" ></script>
	<style type="text/css">
		#tb{
			background-color:#F4F4F4;
		}
		.imageTable{
			border:2px solid #F4F4F4;
			background:#ffffff;
			width:380px;
			height:180px;
			margin-top:10px;
			cellspacing:0;
			cellpadding:0;
		}
		.imageTable td{
			border:2px solid #F4F4F4;
			align:center;
		}
		.imageTable button{
			width:60px;
		}
		.imageTable img{
			width:280px;
			height:180px;
		}
		#replyContentImage p{
			margin-top:20px;
			font-size:13px;
			margin-bottom:10px;
		}
		#editor{
			width:660px ;
		}
	</style>
</head>
<body>
<div id="tb" style="padding:5px;height:auto">
	&nbsp&nbsp&nbsp图文消息编辑&nbsp&nbsp&nbsp
	<a class="easyui-linkbutton" iconCls="icon-save" plain="true" href="javascript:saveNewsMaterialDetail();">保存图文素材</a>
	<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:parent.toNewsManager();">返回</a>
</div>
<div class="box" style="width:100%;">
	<dl id="dl">
		<dd >
			<table  style="margin-top:5px;margin-left:20px;border-collapse:   separate;   border-spacing:   0px;" >
				<!-- 表格行间距 --><tr><td style="height:25px;"></td></tr>
				<tr>
					<td  style="text-align:right;">标题：</td>
					<td>
						<input type='hidden' id="id" value="${newsMaterialDetail.id }"  name='id'/>
						<!-- 设置回复文字 -->
						<textarea class="reg_input" name="titleTextarea" id="titleTextarea"
								  style="width:350px;height:80px;resize:none;"></textarea>
						<span id="titleTextareaTip" class="onshow"></span>
					</td>
				</tr>
				<!-- 表格行间距 --><tr><td style="height:30px;"></td></tr>
				<tr>
					<td  style="text-align:right;">作者：</td>
					<td>
						<input type='text' id="authorText" value="${shopWxset.authorText}"  name='authorText' style="width:120px;"/>
						<span id="authorTextTip" class="onshow"></span>
					</td>
				</tr>
				<!-- 表格行间距 --><tr><td style="height:30px;"></td></tr>
				<tr>
					<td style="text-align:right;">摘要：</td>
					<td>
						<textarea class="reg_input" name="digestTextarea" id="digestTextarea"
								  style="width:350px;height:130px;resize:none;"></textarea>
						<span id="digestTextareaTip" class="onshow"></span>
					</td>
				</tr>
				<!-- 表格行间距 --><tr><td style="height:30px;"></td></tr>
				<tr   >
					<td style="text-align:right;">原文地址：</td>
					<td >
                        <textarea class="reg_input" name="digestTextarea" id="realUrlTextarea"
								  style="width:350px;height:130px;resize:none;"></textarea>
						<span id="realUrlTextareaTip" class="onshow"></span>
					</td>
				</tr>
				<!-- 表格行间距 --><tr><td style="height:30px;"></td></tr>
				<tr>
					<td style="text-align:right;">显示封面：</td>
					<td>
						<c:if test="${shopWxset.status==null || shopWxset.status==0}">
							<input type='text' id="status" value="0"  name='status' style="width:500px;" hidden="true"/>
							<input type='checkbox' id="status" name="status" style="height:20px;width:20px;" onclick="checkStatus()"/>
						</c:if>
						<c:if test="${shopWxset.status==1}">
							<input type='text' id="status" value="1"  name='status' style="width:500px;" hidden="true"/>
							<input type='checkbox' id="status" name="status" checked="checked" style="height:20px;width:20px"  onclick="checkStatus()"/>
						</c:if>
					</td>
				</tr>
				<!-- 表格行间距 --><tr><td style="height:30px;"></td></tr>
				<tr>
					<td style="text-align:right;">打开评论：</td>
					<td>
						<c:if test="${shopWxset.status==null || shopWxset.status==0}">
							<input type='text' id="status" value="0"  name='status' style="width:500px;" hidden="true"/>
							<input type='checkbox' id="status" name="status" style="height:20px;width:20px;" onclick="checkStatus()"/>
						</c:if>
						<c:if test="${shopWxset.status==1}">
							<input type='text' id="status" value="1"  name='status' style="width:500px;" hidden="true"/>
							<input type='checkbox' id="status" name="status" checked="checked" style="height:20px;width:20px"  onclick="checkStatus()"/>
						</c:if>
					</td>
				</tr>
				<!-- 表格行间距 --><tr><td style="height:30px;"></td></tr>
				<tr>
					<td style="text-align:right;">只允许粉丝评论：</td>
					<td>
						<c:if test="${shopWxset.status==null || shopWxset.status==0}">
							<input type='text' id="status" value="0"  name='status' style="width:500px;" hidden="true"/>
							<input type='checkbox' id="status" name="status" style="height:20px;width:20px;" onclick="checkStatus()"/>
						</c:if>
						<c:if test="${shopWxset.status==1}">
							<input type='text' id="status" value="1"  name='status' style="width:500px;" hidden="true"/>
							<input type='checkbox' id="status" name="status" checked="checked" style="height:20px;width:20px"  onclick="checkStatus()"/>
						</c:if>
					</td>
				</tr>
				<!-- 表格行间距 --><tr><td style="height:30px;"></td></tr>
				<tr>
					<td style="text-align:right;">封面：</td>
					<td>
						<div id="replyContentImage">
							<table  id="imageTable" class="imageTable">
								<tr>
									<td width="280">
										<img id="buttonImage" alt="" src="">
									</td>
									<td  width="100">
										<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:showImageWin();">设置图片</a>
									</td>
								</tr>
							</table>
							<p style="display: none">image_id:&nbsp;&nbsp;<label id="buttonImagID" stype="width:200px"/></p>
						</div>
						<!-- 设置新闻封面素材 -->
						<div id="imageDiv" class="easyui-window" style="width:800px;height:400px;padding:10px;"
							 minimizable="false" maximizable="false" collapsible="false" closed="true">
							<table id="imageDatagrid" class="easyui-datagrid" fit="true" singleSelect="false"  border="false"
								   rownumbers="true" fitColumns="false" pagination="true"
								   pageSize=10 pageList="[10,20,30,40,50]"  nowrap="false" toolbar="#imageTb">
								<thead>
								<tr>
									<th field="id" width="50" align="center">
										图片id
									</th>
									<th field="picMini" width="200" align="center" formatter="imageFormatter">
										图片
									</th>
									<th field="uploadTime" width="150" align="center">
										上传日期
									</th>
									<th field="mediaId" width="120" align="center" formatter="media_idFormatter">
										微信公众平台图片
									</th>
									<th field="setImage" width="80" align="center" formatter="imageSetFormatter">
										设置
									</th>
								</tr>
								</thead>
							</table>
							<div id="imageTb" style="padding:5px;height:auto">
							</div>
						</div>
						<!-- 设置新闻正文图片 -->
						<div id="newsImageDiv" class="easyui-window" style="width:800px;height:400px;padding:10px;"
							 minimizable="false" maximizable="false" collapsible="false" closed="true">
							<table id="newsImageDatagrid" class="easyui-datagrid" fit="true" singleSelect="false"  border="false"
								   rownumbers="true" fitColumns="false" pagination="true"
								   pageSize=10 pageList="[10,20,30,40,50]"  nowrap="false" toolbar="#imageTb">
								<thead>
								<tr>
									<th field="id" width="50" align="center">
										图片id
									</th>
									<th field="picMini" width="200" align="center" formatter="newsImageFormatter">
										图片
									</th>
									<th field="uploadTime" width="150" align="center">
										上传日期
									</th>
									<th field="mediaId" width="120" align="center" formatter="newsMedia_idFormatter">
										微信公众平台图片
									</th>
									<th field="setImage" width="80" align="center" formatter="newsImageSetFormatter">
										设置
									</th>
								</tr>
								</thead>
							</table>
							<div id="newsImageTb" style="padding:5px;height:auto">
							</div>
						</div>
					</td>
				</tr>
				<!-- 表格行间距 --><tr><td style="height:30px;"></td></tr>
					<tr style="height: 150px;">
						<td style="text-align:right;"  rowspan="2">正文：</td>
						<td rowspan="2">
							<div id="editor">${ware.wareDesc}</div>
						</td>
						<td style="text-align:left;vertical-align: middle;border:2px solid #F4F4F4;">
							<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:showNewsImageWin();">设置图片</a>
						</td>
					</tr>
					<tr style="height: 150px;">
						<td style="border:2px solid #F4F4F4;"><label id="wangEditorWordCount"></label>字符<br/>小于20000字符(带格式)</td>
					</tr>
			</table>
		</dd>
	</dl>
</div>
<script type="text/javascript">

    $(function(){
        $.formValidator.initConfig({validatorGroup:"title"});//标题字数验证
        $.formValidator.initConfig({validatorGroup:"author"});//作者字数验证
        $.formValidator.initConfig({validatorGroup:"digest"});//摘要字数验证
        $.formValidator.initConfig({validatorGroup:"realUrl"});//原文地址字数验证
        toValidateKeyword();//关键词字数验证
        wangEditorConfig();//富文本配置
    });
    //图文消息编辑表单验证
    function toValidateKeyword(){
        $("#titleTextarea").formValidator({validatorGroup:"title",onShow:"1~64个字",onFocus:"1~64个字",onCorrect:"通过"}).inputValidator({min:1,max:128,onError:"1~64个字"});
        $("#authorText").formValidator({validatorGroup:"author",onShow:"0~8个字",onFocus:"0~8个字",onCorrect:"通过"}).inputValidator({min:0,max:16,onError:"0~8个字"});
        $("#digestTextarea").formValidator({validatorGroup:"author",onShow:"0~120个字",onFocus:"0~120个字",onCorrect:"通过"}).inputValidator({min:0,max:240,onError:"0~120个字"});
        $("#realUrlTextarea").formValidator({validatorGroup:"realUrl",onShow:"0~1000个字符",onFocus:"0~1000个字符",onCorrect:"通过"}).inputValidator({min:0,max:1000,onError:"0~1000个字符"});

    }
    function savePayConfig(){
        $("#weixinPayConfigForm").form('submit',{
            success:function(data){
                var dataJson = JSON.parse(data);
                if(dataJson.state){
                    $.messager.alert('消息','保存成功!','info');
                    $("#id").val(dataJson.id);
                }else{
                    $.messager.alert('消息','保存失败!','info');
                }
            }
        });
        return false;
    }
    //查询图片
    function queryImageMaterial(){
        $('#imageDatagrid').datagrid({
            url:"/manager/WeixinConfig/imagePage"
        });
    }
    //设置图片
    function showImageWin(){
        $("#imageDiv").window({title:"设置图片",modal:true});
        queryImageMaterial();
        $("#imageDiv").window('open');
        $("#imageDiv").window('center');
    }
    function hideImageWin(){
        $("#imageDiv").window('close');
        $('#imageDatagrid').datagrid('reload');
    }
    function imageFormatter(val,row){
        if(val!=""){
            return "<input  type=\"image\" src=\""+"upload/"+val+"\" height=\"180\" width=\"180\" align=\"middle\" style=\"margin-top:10px;margin-bottom:10px;\"/>";
        }
    }
    function media_idFormatter(val,row){
        if(row.mediaId==""){
            return "未上传";
        }else{
            return "已上传";
        }
    }
    function imageSetFormatter(val,row,index){
        var ImageUrl=row.picMini;
        var image_id=row.id;
        ImageUrl=JSON.stringify(ImageUrl);
        image_id=JSON.stringify(image_id);
        return "<input style='width:60px;height:27px' type='button' value='设置' onclick='setImageMaterial("+ImageUrl+","+image_id+")' />";
    }
    function setImageMaterial(ImageUrl,image_id){
        ImageUrl="upload/"+ImageUrl;
        $("#buttonImage").attr("src",ImageUrl);
        $("#buttonImagID").html(image_id);
        hideImageWin();
    }
    //富文本配置
    var editor;
    function wangEditorConfig(){
        var E = window.wangEditor;
        editor = new E('#editor');

        editor.customConfig.uploadImgServer = "/manager/WeixinConfig/wangEditorUpload";
        editor.customConfig.uploadFileName = "file";
        editor.customConfig.uploadImgMaxSize = 3 * 1024 * 1024;
        editor.customConfig.uploadImgMaxLength = 5;
        editor.customConfig.uploadImgHooks = {
            before: function (xhr, editor, files) {
                showNewsImageWin();
            },
            success: function (xhr, editor, result) {
            },
            fail: function (xhr, editor, result) {
            },
            error: function (xhr, editor) {
            },
            timeout: function (xhr, editor) {
            },
        }
      /*  editor.customConfig.customUploadImg = function (files, insert) {
            // files 是 input 中选中的文件列表
            // insert 是获取图片 url 后，插入到编辑器的方法
         //   showImageWin();
            // 上传代码返回结果之后，将图片插入到编辑器中
          //  insert(imgUrl)
        }*/
        editor.customConfig.customAlert = function (info) {
            alert("自定义提示：" + info);
        }
        editor.customConfig.onchange = function (html) {
            console.log(html);
            $("#wangEditorWordCount").html(html.length);
        }
        editor.customConfig.zIndex = 0;
		// 隐藏“网络图片”tab
        editor.customConfig.showLinkImg = false;
        editor.create();
    }
	<!--设置新闻封面图片-->
    //查询封面图片
    function queryImageMaterial(){
        $('#imageDatagrid').datagrid({
            url:"/manager/WeixinConfig/imagePage"
        });
    }
    //显示封面图片
    function imageFormatter(val,row){
        if(val!=""){
            return "<input  type=\"image\" src=\""+"upload/"+val+"\" height=\"180\" width=\"180\" align=\"middle\" style=\"margin-top:10px;margin-bottom:10px;\"/>";
        }
    }
    //查询封面图片是否上传
    function media_idFormatter(val,row){
        if(row.mediaId==""){
            return "未上传";
        }else{
            return "已上传";
        }
    }
    //设置封面图片窗口按钮
    function imageSetFormatter(val,row,index){
        var ImageUrl=row.picMini;
        var image_id=row.id;
        ImageUrl=JSON.stringify(ImageUrl);
        image_id=JSON.stringify(image_id);
        return "<input style='width:60px;height:27px' type='button' value='设置' onclick='setImageMaterial("+ImageUrl+","+image_id+")' />";
    }
    //设置封面图片，打开设置图片窗口
    function showImageWin(){
        $("#imageDiv").window({title:"设置图片",modal:true});
        queryImageMaterial();
        $("#imageDiv").window('open');
        $("#imageDiv").window('center');
    }
    //设置封面图片，关闭设置图片窗口
    function hideImageWin(){
        $("#imageDiv").window('close');
        $('#imageDatagrid').datagrid('reload');
    }
    //设置封面图片
    function setImageMaterial(ImageUrl,image_id){
        ImageUrl="upload/"+ImageUrl;
        $("#buttonImage").attr("src",ImageUrl);
        $("#buttonImagID").html(image_id);
        hideImageWin();
    }
    <!--设置新闻正文图片-->
    //查询正文图片
    function queryNewsImageMaterial(){
        $('#newsImageDatagrid').datagrid({
            url:"/manager/WeixinConfig/imagePage"
        });
    }
    //显示正文图片
    function newsImageFormatter(val,row){
        if(val!=""){
            return "<input  type=\"image\" src=\""+"upload/"+val+"\" height=\"180\" width=\"180\" align=\"middle\" style=\"margin-top:10px;margin-bottom:10px;\"/>";
        }
    }
    //查询正文图片是否上传
    function newsMedia_idFormatter(val,row){
        if(row.mediaId==""){
            return "未上传";
        }else{
            return "已上传";
        }
    }
    //设置正文图片窗口按钮
    function newsImageSetFormatter(val,row,index){
        var ImageUrl=row.picMini;
        var image_id=row.id;
        ImageUrl=JSON.stringify(ImageUrl);
        image_id=JSON.stringify(image_id);
        return "<input style='width:60px;height:27px' type='button' value='设置' onclick='setNewsImageMaterial("+ImageUrl+","+image_id+")' />";
    }
    //设置正文图片，打开设置图片窗口
    function showNewsImageWin(){
        $("#newsImageDiv").window({title:"设置图片",modal:true});
        queryNewsImageMaterial();
        $("#newsImageDiv").window('open');
        $("#newsImageDiv").window('center');
    }
    //设置正文图片，关闭设置图片窗口
    function hideNewsImageWin(){
        $("#newsImageDiv").window('close');
        $('#newsImageDatagrid').datagrid('reload');
    }
    //设置正文图片
    function setNewsImageMaterial(ImageUrl,image_id){
        var getWeixinNewsImage_Url="/manager/getWeixinNewsImageUrl";
        $.ajax({
            url:getWeixinNewsImage_Url,
            dataType: "json",
            data:{"ImageUrl":ImageUrl,"image_id":image_id},
            type:"post",
            success:function(data){
                if(data.state=="true"){
                    var newsImageUrl=data.url;
                    //设置富文本图片公众号图片地址
                    editor.insertImg(newsImageUrl);
                }else{
					alert("上传图文图片到公众号失败!");
                }
            }
        });
        hideNewsImageWin();
    }

    //保存图文素材
    function saveNewsMaterialDetail(){
        if($.formValidator.pageIsValid("title")==true && $.formValidator.pageIsValid("author")==true
            && $.formValidator.pageIsValid("digest")==true && $.formValidator.pageIsValid("realUrl")==true){
            var title=$("#titleTextarea").val();
            var author=$("#authorText").val();
            var digest=$("#digestTextarea").val();
            var realUrl=$("#realUrlTextarea").val();
            //取得富文本HTML内容
            var contentHtml = editor.txt.html();
            var contentText= editor.txt.text();
            console.log("html:"+contentHtml);
            console.log("text:"+contentText);
            var saveNewsMaterialDetail_url="/manager/postWeixinNews";
            $.ajax({
                url:saveNewsMaterialDetail_url,
                dataType: "json",
                data:{"title":title,"author":author,"digest":digest,"realUrl":realUrl,"content":contentHtml},
                type:"post",
                success:function(data){
                    if(data=="1"){
                        alert("保存成功!");
                        hideKeywordAddDiv();
                        queryKeyword();
                    }else{
                        if(data=="0"){
                            alert("保存失败!关键词已存在!");
                        }else{
                            if(data=="1"){
                                alert("保存成功!");
                            }
                        }
                    }
                }
            });
        }
    }

</script>
</body>
</html>
