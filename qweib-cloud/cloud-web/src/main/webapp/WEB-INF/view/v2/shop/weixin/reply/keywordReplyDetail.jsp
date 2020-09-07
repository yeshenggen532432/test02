<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.bc-item {
			text-align: center;
			margin-bottom: 10px;
			-webkit-box-shadow: 0 3px 6px 0 rgba(0, 0, 0, .1), 0 1px 3px 0 rgba(0, 0, 0, .08);
			box-shadow: 0 3px 6px 0 rgba(0, 0, 0, .1), 0 1px 3px 0 rgba(0, 0, 0, .08)
		}

		.bc-item .bc-title {
			font-weight: bold;
			font-size: 14px;
		}
		.form-horizontal label:not(.k-radio-label):after {
			content: "";
		}

		.imageTable{
			border:2px solid #F4F4F4;
			background:#ffffff;
			width:380px;
			height:180px;
			margin-top:20px;
			margin-left:30px;
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
		hr{
			height:3px;
			width:100%;
			border:none;
			background-color:#FF0000;
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
		<div class="layui-col-md12">
			<div class="layui-card">
				<div class="layui-card-header btn-group">
					<label class="control-label" style="margin-left: 30px;">关键词:</label><label class="control-label"  id="keywordLabel">${keyword}</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<ul uglcw-role="buttongroup">
						<li onclick="showKeywordEditDiv();" data-icon="edit" class="k-info">修改关键词</li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<li onclick="goBack();"  data-icon="undo" class="k-info">返回</li>
					</ul>
				</div>
				<div class="layui-card-body">
					<div id="keywordReply">
						<dl id="keywordReplyDl">
							<c:if test="${keywordReplyDetailListSize>0}">
								<c:forEach items="${keywordReplyDetailList}" var="keywordReplyDetail" varStatus="s">
									<%--<dd id="dd${s.index}">
										<div style="border-left-width:2px;margin-top:0px;padding-left:20px;float:left;height:360px;" >
											<div id="replyContent${s.index}" class="replyContent">
												<!-- 关键词回复内容id -->
												<p>关键词回复内容id:<label id="id${s.index}" name='id${s.index}'>${keywordReplyDetail.id}</label></p>
												<p><label>回复内容</label>
													<label class="contentRadio"><input id="radioText${s.index}"  type="radio" name="replyContentType${s.index}" onclick="replyContentType(${s.index})" value="text"  class="content"/>文字</label>
													<label class="contentRadio"><input id="radioImage${s.index}" type="radio" name="replyContentType${s.index}" onclick="replyContentType(${s.index})" value="image" class="content"/>图片</label>
													<label class="contentRadio"><input type="button" id="saveButton${s.index}" name="saveButton${s.index}" onclick="saveReply(${s.index})" value="保存" style="width:80px"/></label>
													<label class="contentRadio"><input type="button" id="saveButton${s.index}" name="saveButton${s.index}" onclick="deleteReply(${s.index})" value="删除" style="width:80px"/></label>
												</p>
												<!-- 设置回复文字 -->
												<div id="replyContentTextareaDiv${s.index}">
													<p><textarea class="reg_input" name="replyContentTextarea${s.index}" id="replyContentTextarea${s.index}"
																 style="width:350px;height:180px;resize:none;margin-left:30px;"></textarea>
														<span id="replyContentTextarea${s.index}Tip" class="onshow"></span></p>
												</div>
												<!-- 设置回复图片 -->
												<div id="replyContentImage${s.index}" class="hidden">
													<table  id="imageTable${s.index}" class="imageTable">
														<tr>
															<td width="280">
																<img id="buttonImage${s.index}" alt="" src="">
															</td>
															<td  width="100">
																<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:showImageWin(${s.index});">设置图片</a>
															</td>
														</tr>
													</table>
													<p>image_id:&nbsp;&nbsp;<label id="buttonImagID${s.index}" stype="width:200px"/></p>
												</div>
											</div>
										</div>
										<hr/>
									</dd>--%>

									<dd id="dd${s.index}" >
										<div class="form-horizontal" id="replyContent${s.index}">
											<p><label class="control-label">关键词回复内容id:</label><label id="id${s.index}" name="id${s.index}">${keywordReplyDetail.id}</label></p>

											<div class="form-group" style="margin-bottom: 10px;">
												<label class="control-label col-xs-3">回复内容</label>
												<div class="col-xs-5">
													<ul uglcw-role="radio" uglcw-model="radio${s.index}" id="contentRadio${s.index}"
														uglcw-value="1"
														uglcw-options='layout:"horizontal",
                                    change:function(v){ replyContentType(${s.index},v); },
                                    dataSource:[{"text":"文字","value":"text"},{"text":"图片","value":"image"}]
                                    '></ul>
												</div>
												<div class="col-xs-6">
													<button uglcw-role="button" class="k-success" id="saveButton${s.index}" onclick="saveReply(${s.index});">保存</button>
													<button uglcw-role="button" class="k-error" id="deleteButton${s.index}" onclick="deleteReply(${s.index});">删除</button>
												</div>
											</div>

											<div class="form-group" style="margin-bottom: 10px;">
												<div id="replyContentTextareaDiv${s.index}">
													<form class="form-horizontal" uglcw-role="validator" id="textareaForm${s.index}">
														<div class="col-xs-11" style="width:410px;">
                                        <textarea uglcw-role="textbox" uglcw-model="textarea" id="replyContentTextarea${s.index}"
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

												<div id="replyContentImage${s.index}">
													<table  id="imageTable${s.index}" class="imageTable">
														<tr>
															<td width="280">
																<img id="buttonImage${s.index}" alt="" src="" >
															</td>
															<td  width="100">
																<a class="k-button k-info" href="javascript:showImageWin(${s.index});">
																	<i class="k-icon k-i-plus-circle"></i>设置图片</a>
															</td>
														</tr>
													</table>
													<p style="display: none;">image_id:&nbsp;&nbsp;&nbsp;<label  id="buttonImagID${s.index}" stype="width:200px"/></p>
												</div>
											</div>
										</div>
										<hr/>
									</dd>

								</c:forEach>
							</c:if>



						</dl>
						<!-- 设置关键字 -->
						<div style="margin:20px 0px;margin-left: 15px;">
							<button uglcw-role="button" onclick="addKeywordReply();" data-icon="add" class="k-info">增加关键词回复</button>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
</div>

<%--关键词回复素材窗口模板--%>
<script id="keywordReply-template" type="text/x-uglcw-template">

	<dd id="dd#=data.keywordCount#" >
		<div class="form-horizontal" id="replyContent#=data.keywordCount#">
			<p><label class="control-label">关键词回复内容id:</label><label id="id#=data.keywordCount#" name="id#=data.keywordCount#">0</label></p>

			<div class="form-group" style="margin-bottom: 10px;">
				<label class="control-label col-xs-3">回复内容</label>
				<div class="col-xs-5">
					<ul uglcw-role="radio" uglcw-model="radio#=data.keywordCount#" id="contentRadio#=data.keywordCount#"
						uglcw-value="1"
						uglcw-options='layout:"horizontal",
                                    change:function(v){ replyContentType(#=data.keywordCount#,v); },
                                    dataSource:[{"text":"文字","value":"text"},{"text":"图片","value":"image"}]
                                    '></ul>
				</div>
				<div class="col-xs-6">
					<button uglcw-role="button" class="k-success" id="saveButton#=data.keywordCount#" onclick="saveReply('#=data.keywordCount#');">保存</button>
					<button uglcw-role="button" class="k-error" id="deleteButton#=data.keywordCount#" onclick="deleteReply('#=data.keywordCount#');">删除</button>
				</div>
			</div>

			<div class="form-group" style="margin-bottom: 10px;">
				<div id="replyContentTextareaDiv#=data.keywordCount#">
					<form class="form-horizontal" uglcw-role="validator" id="textareaForm#=data.keywordCount#">
						<div class="col-xs-11" style="width:410px;">
                                        <textarea uglcw-role="textbox" uglcw-model="textarea" id="replyContentTextarea#=data.keywordCount#"
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

				<div id="replyContentImage#=data.keywordCount#">
					<table  id="imageTable#=data.keywordCount#" class="imageTable">
						<tr>
							<td width="280">
								<img id="buttonImage#=data.keywordCount#" alt="" src="" >
							</td>
							<td  width="100">
								<a class="k-button k-info" href="javascript:showImageWin('#=data.keywordCount#');">
									<i class="k-icon k-i-plus-circle"></i>设置图片</a>
							</td>
						</tr>
					</table>
					<p style="display: none;">image_id:&nbsp;&nbsp;&nbsp;<label  id="buttonImagID#=data.keywordCount#" stype="width:200px"/></p>
				</div>
			</div>
		</div>
		<hr/>
	</dd>

</script>

<%--排班模板--%>
<script id="bc-template" type="text/x-uglcw-template">
	# for(var i= 0; i< data.count; i++){ #
	<div class="col-xs-6">
		<div class="bc-item  k-info">
            <span class="bc-title">
                #if(data.count == 7){#
                #= data.title[i]#
                #}else{#
                #= (i+1)#
                #}#
            </span>
			<input class="bc-options" uglcw-role="combobox" uglcw-model="subList[#= i#].bcId" uglcw-options="
                placeholder: '请设置班次',
                dataSource: bcList,
                dataTextField: 'bcName',
                dataValueField: 'id',
                change: function(e){
                    if(this.value()){
                       $(e.sender.element).closest('.bc-item').addClass('k-success').removeClass('k-info')
                    }else{
                        $(e.sender.element).closest('.bc-item').removeClass('k-success').addClass('k-info')
                    }
                }
            "/>
		</div>
	</div>
	# } #
</script>



<%--设置图片--%>
<script type="text/x-uglcw-template" id="imageAddDiv">
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




<%--修改关键词--%>
<script type="text/x-uglcw-template" id="keywordEditDiv">
	<div class="layui-card">
		<div class="layui-card-body">
			<form class="form-horizontal" uglcw-role="validator">
				<div class="form-group">
					<label class="control-label col-xs-6">关键词</label>
					<div class="col-xs-16">
						<textarea uglcw-role="textbox" uglcw-model="keyword" id="keywordTextarea"  uglcw-validate="required" maxlength="30" uglcw-options="min: 1, max: 30"></textarea>
					</div>
				</div>
			</form>
		</div>
	</div>
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

    var bcList = [];
    $(function () {
        uglcw.ui.init();
        <%--<c:if test="${not empty kqRule}">
        var rule = eval('(' + '${kqRule}' + ')');
        </c:if>
        <c:if test="${empty kqRule}">
        var rule = {};
        </c:if>
        var settings = {};
        if (rule.subList) {
            $(rule.subList).each(function (idx, bc) {
                settings['subList[' + idx + '].bcId'] = bc.bcId
            })
        }
        uglcw.ui.bind('body', rule);
        loadWorkTypes();
        initBcTemplate(uglcw.ui.get('#ruleUnit').value());
        $('#op-container').on('click', '.bc-item', function () {
            uglcw.ui.get($(this).find('[uglcw-role=combobox]')).k().open();
        });
        uglcw.ui.bind('body', settings);
        checkSelect();--%>
        uglcw.ui.loaded()
    });

    function checkSelect() {
        $('#op-container').find('.bc-item').each(function () {
            if (uglcw.ui.get($(this).find('[uglcw-role=combobox]')).value()) {
                $(this).addClass('k-success').removeClass('k-info')
            }
        })
    }

    function initBcTemplate(i) {
        var count = 1;
        if (i == 1) {
            count = 7;
        } else if (i == 2) {
            count = 31;
        }
        uglcw.ui.get('#days').value(count);
        var html = uglcw.util.template($('#bc-template').html())({
            count: count,
            title: ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日']
        });
        $('#op-container').html(html);
        uglcw.ui.init('#op-container');
    }

    function loadWorkTypes() {
        $.ajax({
            url: '${base}manager/bc/queryKqBcPage',
            type: 'post',
            dataType: 'json',
            data: {status: 1},
            async: false,
            success: function (response) {
                if (response.state) {
                    bcList = response.rows;
                    bcList.push({id: 0, bcName: '休息'});
                }
            }
        })
    }

    function save() {
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/kqrule/saveKqRule',
            type: 'post',
            data: uglcw.ui.bind('form'),
            success: function (response) {
                uglcw.ui.loaded();
                if (response == '1') {
                    uglcw.ui.success('保存成功');
                    setTimeout(function () {
                        uglcw.io.emit('refreshBcRuleList');
                        uglcw.ui.closeCurrentTab();
                        uglcw.ui.openTab('规律班次设置', '${base}manager/kqrule/toBaseKqRule')
                    }, 1500);
                } else {
                    uglcw.ui.error("操作失败");
                }
            },
            error: function () {
                uglcw.ui.loaded();
            }
        })
    }


    //---------------------------------关键词回复编辑-----------------------------------------------------


    var keywordIndex=0;//编辑的关键词回复
    var keywordCount=0;//关键词回复总数
    $(function(){
        keywordCount=${keywordReplyDetailListSize};
        var keywordReplyDetailList="${keywordReplyDetailList}";
        /*$.formValidator.initConfig({validatorGroup:"keyword"});//关键词回复字数验证*/
        toValidateKeyword();//关键词字数验证
        <c:forEach items="${keywordReplyDetailList}" var="keywordReplyDetail" varStatus="s">
        var keyword_text="${keywordReplyDetail.keywordText}";
        var keyword_image_id="${keywordReplyDetail.keywordImageId}";
        var index=${s.index};
       /* $.formValidator.initConfig({validatorGroup:"${s.index}"});//关键字回复字数验证*/
        toValidate("${s.index}");//关键词回复字数验证
        var radioText=$("#radioText"+index);
        var radioImage=$("#radioImage"+index);
        if(keyword_image_id==0 || keyword_image_id==""){
          //  radioText.prop("checked","checked");
            uglcw.ui.bind('body',{radio${s.index}:'text'});
            replyContentType(index,"text");
            $("#replyContentTextarea"+index).val(keyword_text);
        }else{
         //   radioImage.prop("checked","checked");
            uglcw.ui.bind('body',{radio${s.index}:'image'});
            replyContentType(index,"image");
            var getImage_url="/manager/weiXinReply/getKeywordImageUrl?keywordImageId="+keyword_image_id;
            var msg=$.ajax({url:getImage_url,async:false});
            if(msg.responseText==""){
                uglcw.ui.error("查询图片失败！");
            }else{
                var json=$.parseJSON( msg.responseText ) ;
                var ImageMap=json.ImageMap;
                var ImageUrl=ImageMap.pic;
                ImageUrl="upload/"+ImageUrl;
                $("#buttonImage"+index).attr("src",ImageUrl);

            }
            $("#buttonImagID"+index).html(keyword_image_id);
        }
        </c:forEach>
    });
    //关键词回复表单验证
    function toValidate(index){
      /*  $("#replyContentTextarea"+index).formValidator({validatorGroup:index,onShow:"1~600个字",onFocus:"1~600个字",onCorrect:"通过"}).inputValidator({min:1,max:1200,onError:"1~600个字"});*/
    }
    //关键词表单验证
    function toValidateKeyword(){
       /* $("#keywordTextarea").formValidator({validatorGroup:"keyword",onShow:"1~30个字",onFocus:"1~30个字",onCorrect:"通过"}).inputValidator({min:1,max:60,onError:"1~30个字"});*/
    }
    //单选框
    function replyContentType(index){
        var ContentType=$("input[name=replyContentType"+index+"]:checked").val();
        switch(ContentType){
            case "text":
                $("#replyContentTextareaDiv"+index).show();
                $("#replyContentImage"+index).hide();
                break;
            case "image":
                $("#replyContentTextareaDiv"+index).hide();
                $("#replyContentImage"+index).show();
                break;
            default:break;
        }
    }
    //查询图片
    function queryImageMaterial(){
        $('#imageDatagrid').datagrid({
            url:"/manager/WeixinConfig/imagePage"
        });
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
        $("#buttonImage"+keywordIndex).attr("src",ImageUrl);
        $("#buttonImagID"+keywordIndex).html(image_id);
        hideImageWin();
    }
    //设置图片
    function showImageWin(index){
       /* keywordIndex=index;
        $("#imageDiv").window({title:"设置图片",modal:true});
        queryImageMaterial();
        $("#imageDiv").window('open');
        $("#imageDiv").window('center');*/
        keywordIndex=index;
        uglcw.ui.Modal.open({
            area: ['800px','400px'],
            content: $('#imageAddDiv').html(),
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
    function hideImageWin(){
       /* $("#imageDiv").window('close');
        $('#imageDatagrid').datagrid('reload');*/
       uglcw.ui.Modal.close();
    }

    //保存关键词回复
    function saveReply(index){
        var radio="radio"+index;
       // var ContentType=uglcw.ui.bind('body')[radio];
       // var ContentType=$("input[name=replyContentType"+index+"]:checked").val();
        var ContentType=uglcw.ui.get('[uglcw-model='+radio+']').value();
        var id=$("#id"+index).html();
        switch(ContentType){
            case "text":
                $("#buttonImagID"+index).html("");
                $("#buttonImage"+index).attr('src',"");
                var saveReply_url="/manager/weiXinReply/updateKeywordReply";
                if ($("#replyContentTextarea"+index).val() != ""){
                    $.ajax({
                        url:saveReply_url,
                        data:{"id":id,"type":ContentType,"keyword":$("#keywordLabel").html(),"value":$("#replyContentTextarea"+index).val()},
                        type:"post",
                        success:function(data){
                            if(data.state){
                                uglcw.ui.success("保存成功!");
                                if(id=="0"){
                                    $("#id"+index).html(data.keywordReplyId);
                                }
                            }else{
                                uglcw.ui.error("保存失败");
                            }
                        }
                    });
                }
                break;
            case "image":
                $("#replyContentTextarea"+index).val("");
                var saveReply_url="/manager/weiXinReply/updateKeywordReply";
                if($("#buttonImagID"+index).html()=="")  {
                    uglcw.ui.error("请选择图片");
                }else{
                    $.ajax({
                        url:saveReply_url,
                        data:{"id":id,"type":ContentType,"keyword":$("#keywordLabel").html(),"value":$("#buttonImagID"+index).html()},
                        type:"post",
                        success:function(data){
                            if(data.state){
                                uglcw.ui.success("保存成功!");
                                if(id=="0"){
                                    $("#id"+index).html(data.keywordReplyId);
                                }
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
    //删除关键词回复
    function deleteReply(index){
        var id=$("#id"+index).html();
        var deleteReply_url="/manager/weiXinReply/deleteKeywordReply";
        $.ajax({
            url:deleteReply_url,
            data:{"id":id},
            type:"post",
            success:function(data){
                if(data){
                    uglcw.ui.success("删除成功!");
                    $("#dd"+index).remove();
                    keywordCount=keywordCount-1;
                }else{
                    uglcw.ui.error("删除失败!");
                }
            }
        });
    }
    //打开修改关键词窗口
    function showKeywordEditDiv(){
       /* $("#keywordEditDiv").window({title:"修改关键词",modal:true});
		 $("#keywordEditDiv").window({top:100,left:$(window).width()/2-240});
		 var keyword=$("#keywordLabel").html();
		 $("#keywordTextarea").val(keyword);
		 $("#keywordEditDiv").window('open');*/


        uglcw.ui.Modal.open({
            content: $('#keywordEditDiv').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container).find('form'));
                var keyword=$("#keywordLabel").html();
                $("#keywordTextarea").val(keyword);
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}/manager/weiXinReply/updateKeyword',
                    type: 'post',
                    data: {"keyword":$.trim($("#keywordTextarea").val()),"oldKeyword":$("#keywordLabel").html()},
                    async: false,
                    success:function(data){
                        uglcw.ui.loaded();
                        if(data=="1"){
                            uglcw.ui.success("保存成功!");
                            $("#keywordLabel").html($.trim($("#keywordTextarea").val()));
                            uglcw.ui.Modal.close();
                        }else{
                            if(data=="0"){
                                uglcw.ui.error("保存失败!关键词已存在!");
                                uglcw.ui.Modal.close();
                            }else{
                                uglcw.ui.error("保存失败");
                                uglcw.ui.Modal.close();
                            }
                        }
                    }
                })
                return false;
            }
        })


    }
    //关闭修改关键词窗口
    function hideKeywordEditDiv(){
        $("#keywordEditDiv").window('close');
    }
    //更新关键词
    function updateKeyword(){
        if($.formValidator.pageIsValid("keyword")){
            var updateKeyword_url="/manager/weiXinReply/updateKeyword";
            $.ajax({
                url:updateKeyword_url,
                data:{"keyword":$.trim($("#keywordTextarea").val()),"oldKeyword":$("#keywordLabel").html()},
                type:"post",
                success:function(data){
                    if(data=="1"){
                        uglcw.ui.success("保存成功!");
                        $("#keywordLabel").html($.trim($("#keywordTextarea").val()));
                        hideKeywordEditDiv();
                    }else{
                        uglcw.ui.error("保存失败");
                    }
                }
            });
        }
    }

    //增加关键词回复
    function addKeywordReply(){
        /*var strs = "<dd id=\"dd"+keywordCount+"\">";
        strs+="<div style=\"border-left-width:2px;margin-top:0px;padding-left:20px;float:left;height:360px;\" >";
        strs+="<div id=\"replyContent"+keywordCount+"\" class=\"replyContent\">";
        strs+="<p>关键词回复内容id:<label id=\"id"+keywordCount+"\" name='id"+keywordCount+"'>0</label></p>";
        strs+="<p><label>回复内容</label>";
        strs+="<label class=\"contentRadio\"><input id=\"radioText"+keywordCount+"\"  type=\"radio\" name=\"replyContentType"+keywordCount+"\" onclick=\"replyContentType("+keywordCount+")\" value=\"text\"  class=\"content\"/>文字</label>";
        strs+="<label class=\"contentRadio\"><input id=\"radioImage"+keywordCount+"\" type=\"radio\" name=\"replyContentType"+keywordCount+"\" onclick=\"replyContentType("+keywordCount+")\" value=\"image\" class=\"content\"/>图片</label>";
        strs+="<label class=\"contentRadio\"><input type=\"button\" id=\"saveButton"+keywordCount+"\" name=\"saveButton"+keywordCount+"\" onclick=\"saveReply("+keywordCount+")\" value=\"保存\" style=\"width:80px\"/></label>";
        strs+="<label class=\"contentRadio\"><input type=\"button\" id=\"saveButton"+keywordCount+"\" name=\"saveButton"+keywordCount+"\" onclick=\"deleteReply("+keywordCount+")\" value=\"删除\" style=\"width:80px\"/></label>";
        strs+="</p>";
        strs+="<div id=\"replyContentTextareaDiv"+keywordCount+"\">";
        strs+="<p><textarea class=\"reg_input\" name=\"replyContentTextarea"+keywordCount+"\" id=\"replyContentTextarea"+keywordCount+"\"";
        strs+="style=\"width:350px;height:180px;resize:none;margin-left:30px;\"></textarea>";
        strs+="<span id=\"replyContentTextarea"+keywordCount+"Tip\" class=\"onshow\"></span></p>";
        strs+="</div>";
        strs+="<div id=\"replyContentImage"+keywordCount+"\" class=\"hidden\">";
        strs+="<table  id=\"imageTable"+keywordCount+"\" class=\"imageTable\">";
        strs+="<tr>";
        strs+="<td width=\"280\">";
        strs+="<img id=\"buttonImage"+keywordCount+"\" alt=\"\" src=\"\">";
        strs+="</td>";
        strs+="<td  width=\"100\">";
        strs+="<a class=\"easyui-linkbutton\" iconCls=\"icon-reload\" plain=\"true\" href=\"javascript:showImageWin("+keywordCount+");\">设置图片</a>";
        strs+="</td>";
        strs+="</tr>";
        strs+="</table>";
        strs+="<p>image_id:&nbsp;&nbsp;<label id=\"buttonImagID"+keywordCount+"\" stype=\"width:200px\"/></p>";
        strs+="</div>";
        strs+="</div>";
        strs+="</div>";
        strs+="<hr/>";
        strs+="</dd>";
        $("#keywordReplyDl").append(strs);

        $.formValidator.initConfig({validatorGroup:keywordCount.toString()});//关键字回复字数验证
        toValidate(keywordCount.toString());//关键字回复字数验证
        //单选框默认选择文本
        var radioText=$("#radioText"+keywordCount);
        radioText.prop("checked","checked");
        replyContentType(keywordCount);
        keywordCount=keywordCount+1;*/


        var html = uglcw.util.template($('#keywordReply-template').html())({
            keywordCount: keywordCount
        });

        $("#keywordReplyDl").append(html);
        uglcw.ui.init('#dd'+keywordCount);

        //单选框默认选择文本
        var data = {};
        data["radio"+keywordCount] = 'text';
        uglcw.ui.bind('body',data);

        //滚动滚动条
        $('html').animate({scrollTop: $(document).height()});

        keywordCount=keywordCount+1;

    }
    //返回上一个页面
    function goBack() {
        window.history.go(-1);
    }


    //单选框选择文字或者图片
    //单选框
    function replyContentType(id,value){
        switch(value){
            case "text":
                $("#replyContentTextareaDiv"+id).show();
                $("#replyContentImage"+id).hide();
                break;
            case "image":
                $("#replyContentTextareaDiv"+id).hide();
                $("#replyContentImage"+id).show();
                break;
            default:break;
        }
    }


</script>
</body>
</html>
