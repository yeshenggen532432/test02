<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="<%=basePath%>/resource/wangEditor/wangEditor.min.js" ></script>
    <style type="text/css">
        .divDel{
            position: relative;
            width:200px;
            height:160px;
            margin:15px 0px 5px;
        }
        .imgDel{
            width:20px;
            height:20px;
            position: absolute;
            right: 5px;
            top: 5px;
        }
        .left_title{width:200px; display:inline-block; text-align:left; padding-left:30px}
        .right_input{width: 100px;font-size: 13px}
    </style>
</head>
<body>
<form action="manager/shopWare/updateWare" name="warefrm" id="warefrm" method="post" enctype="multipart/form-data">
    <input type="hidden" name="wareId" id="wareId" value="${ware.wareId}"/>
    <input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
    <input type="hidden" name="groupIds" id="groupIds" value="${groupIds}"/>

    <!-- ================= tab=================== -->
    <div id="easyTabs" class="easyui-tabs" style="width:auto;height:auto;">
        <!-- ================= 基础开始=================== -->
        <div title="商品信息" style="padding:20px;">
            <div class="box" >
                <dl id="dl1" style="font-size: 13px">
                    <!-- ================= 基础结束 =================== -->
                    <fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px;
					-webkit-border-radius: 5px;
					-khtml-border-radius: 5px;
					border-radius: 5px;" class="showClass">
                        <legend  style="border:0px;background-color:white;font-size: 13px;color:teal">一、商品基本信息</legend>
                        <dd>
                            <span class="left_title">1.商品名称*：</span>
                            <input class="reg_input" name="wareNm" id="wareNm" value="${ware.wareNm}" style="width: 150px;font-size: 13px" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">(一) 大单位信息</span>
                        </dd>
                        <dd>
                            <span class="left_title">1.大单位名称*：</span>
                            <input class="reg_input right_input" name="wareDw" id="wareDw" value="${ware.wareDw}" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">2.大单位规格*：</span>
                            <input class="reg_input right_input" name="wareGg" id="wareGg" value="${ware.wareGg}" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">3.大单位条码：</span>
                            <input class="reg_input right_input" name="packBarCode" id="packBarCode" value="${ware.packBarCode}" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">4.大单位批发价*：</span>
                            <input class="reg_input right_input" name="wareDj" id="wareDj" value="${ware.wareDj}"  disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">5.大单位原价：</span>
                            <input class="reg_input right_input" name="lsPrice" id="lsPrice" value="${ware.lsPrice}"  disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">(二) 小单位信息</span>
                        </dd>
                        <dd>
                            <span class="left_title">1.小单位名称*：</span>
                            <input class="reg_input right_input" name="minUnit" id="minUnit" value="${ware.minUnit}" disabled/>
                        </dd>
                        <dd>
                            <%--备注smallWareGg数据库暂时没有--%>
                            <span class="left_title">2.小单位规格*：</span>
                            <input class="reg_input right_input" name="smallWareGg" id="smallWareGg" value="$" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">3.小单位条码：</span>
                            <input class="reg_input right_input" name="beBarCode" id="beBarCode" value="${ware.beBarCode}" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">4.小单位批发价*：</span>
                            <input class="reg_input right_input" name="sunitPrice" id="sunitPrice" value="${ware.sunitPrice}"  disabled/>
                        </dd>
                        <dd>
                            <%--备注smallLsPrice数据库暂时没有--%>
                            <span class="left_title">5.小单位原价：</span>
                            <input class="reg_input right_input" name="minLsPrice" id="minLsPrice" value="${ware.minLsPrice}" disabled/>
                        </dd>
                    </fieldset>

                    <fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px;
					-webkit-border-radius: 5px;
					-khtml-border-radius: 5px;
					border-radius: 5px;" class="showClass">
                        <legend  style="border:0px;background-color:white;font-size: 13px;color:teal">二、自营商城商品信息</legend>
                        <dd>
                            <span class="left_title">1.自营商城商品别称：</span>
                            <input class="reg_input right_input" name="shopWareAlias" id="shopWareAlias" value="${ware.shopWareAlias}" />
                        </dd>
                        <dd>
                            <%----%>
                            <span class="left_title">2.自营商城商品大单位批发价：</span>
                            <input class="reg_input right_input" name="shopWarePrice" id="shopWarePrice" value="${ware.shopWarePrice}"/>

                        </dd>
                        <dd>
                            <span class="left_title">3.自营商城商品大单位原价：</span>
                            <input class="reg_input right_input" name="shopWareLsPrice" id="shopWareLsPrice" value="${ware.shopWareLsPrice}" />
                        </dd>
                        <dd>
                            <span class="left_title">4.自营商城商品大单位促销价：</span>
                            <input class="reg_input right_input" name="shopWareCxPrice" id="shopWareCxPrice" value="${ware.shopWareCxPrice}" />
                        </dd>
                        <dd>
                            <span class="left_title">5.自营商城商品小单位批发价：</span>
                            <input class="reg_input right_input" name="shopWareSmallPrice" id="shopWareSmallPrice" value="${ware.shopWareSmallPrice}" />
                        </dd>
                        <dd>
                            <span class="left_title">6.自营商城商品小单位原价：</span>
                            <input class="reg_input right_input" name="shopWareSmallLsPrice" id="shopWareSmallLsPrice" value="${ware.shopWareSmallLsPrice}" />
                        </dd>
                        <dd>
                            <span class="left_title">7.自营商城商品小单位促销价：</span>
                            <input class="reg_input right_input" name="shopWareSmallCxPrice" id="shopWareSmallCxPrice" value="${ware.shopWareSmallCxPrice}" />
                        </dd>
                    </fieldset>
                </dl>
            </div>
        </div>
        <!-- ================= 商品信息：结束 =================== -->

        <!-- ================= 商品描述：开始 =================== -->
        <div title="商品描述" style="padding:20px;">
            <div class="box" ><dl id="dl3" style="font-size: 13px"><dd><div id="editor">${ware.wareDesc}</div></dd></dl></div>
        </div>
        <!-- ================= 商品描述 =================== -->

        <!-- ================= 图片开始=================== -->
        <div title="商品图片" style="overflow:auto;padding:20px;">
            <dl id="dl2">
                <c:if test="${empty ware.warePicList}">
                    <dd id="ddphoto1">
                        <div class="divDel">
                            <img id="photoImg21" alt="" style="width: 200px;height: 160px;" src="resource/images/login_bg.jpg">
                            <img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows(1);"/>
                        </div>
                        <div id="editDiv2" >
                            <input type="file" accept="image/*" name="file21" id="file21" onchange="showPictrue(1)"  class="uploadFile"/>
                        </div>
                    </dd>
                </c:if>

                <c:if test="${!empty ware.warePicList}">
                    <c:forEach items="${ware.warePicList}" var="item" varStatus="s">
                        <dd id="ddphoto${s.index+1}">
                            <input type="hidden" name="subId" id="subId${s.index+1}" value="${item.id}"/>
                            <c:set var="subIds" value="${subIds},${item.id },"/>
                            <div class="divDel">
                                <c:if test="${!empty item.pic}">
                                    <img id="photoImg2${s.index+1}" alt=""   style="width: 200px;height: 160px;" src="upload/${item.pic}"/>
                                </c:if>
                                <c:if test="${empty item.pic}">
                                    <img id="photoImg2${s.index+1}" alt=""   style="width: 200px;height: 160px;" src="resource/images/login_bg.jpg"/>
                                </c:if>
                                <img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows('${s.index+1}');"/>
                            </div>

                            <div id="editDiv${s.index+1}" >
                                <a class="easyui-linkbutton" iconcls="icon-edit" href="javascript:void(0);" onclick="modifyRows('${s.index+1}');">编辑</a>
                            </div>
                        </dd>
                    </c:forEach>
                </c:if>
            </dl>
            <dd style="margin:20px 0px;">
                <a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加图片</a>
            </dd>
        </div>
        <!-- ================= 图片结束=================== -->
    </div>

    <!-- 保存；返回 -->
    <div class="f_reg_but" style="clear:both">
        <input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
        <input type="button" value="返回" class="b_button" onclick="toBack();"/>
    </div>

</form>
		
	    <script type="text/javascript">
	         
		    window.onload = function(){
                warBaseInfo();
                wangEditorConfig();
		    }
		    
		    //富文本配置
		    var editor;
		    function wangEditorConfig(){
		    	var E = window.wangEditor
		    	editor = new E('#editor');
		        editor.customConfig.uploadImgServer = "/manager/photo/wangEditorUpload";
		        editor.customConfig.uploadFileName = "file";
		        editor.customConfig.uploadImgMaxSize = 3 * 1024 * 1024;
		        editor.customConfig.uploadImgMaxLength = 5;
		        editor.customConfig.uploadImgHooks = {
		                before: function (xhr, editor, files) {
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
		        editor.customConfig.customAlert = function (info) {
		            alert("自定义提示：" + info);
		        }
		        editor.create();
		    }
		    //提交
		    function toSubmit(){
		    	//取得富文本HTML内容
		    	var html = editor.txt.html();
		    	console.log("html:"+html);
		    	if("<p><br></p>"==html){
                    html=null;
                }

		    	//easyUi的from表单的ajax请求接口
				$("#warefrm").form('submit',{
					type:"POST",
					url:"<%=basePath%>/manager/shopWare/updateWare",
					onSubmit: function(param){//参数
						param.delPicIds = delPicIds;
						param.html = html;
				    },
					success:function(data){
						if(data=="1"){
							alert("添加成功");
                            toBack();
						}else if(data=="2"){
							alert("修改成功");
                            toBack();
						}else if(data=="-2"){
							alert("该商品名称已存在了");
							return;
						}else if(data=="-3"){
							alert("该商品编码已存在了");
							return;
						}else{
							alert("操作失败");
						}
					}
				});
			}
		    //返回
		    function toBack(){
		    	var groupIds=$("#groupIds").val();
		    	if(groupIds!=null && groupIds!=""){
		    		location.href="${base}/manager/shopWare/toPage?groupIds="+groupIds;
		    	}else{
		    		location.href="${base}/manager/shopWare/toPage?wtype="+$("#wtype").val();
		    	}
		    }

		    //--------------------图片相关：开始-----------------
		   //显示图片
			function showPictrue(n){
				console.log("showPictrue:"+n);
				var r= new FileReader();
				f=document.getElementById("file2"+n).files[0];
				r.readAsDataURL(f);
				r.onload=function  (e) {
					document.getElementById('photoImg2'+n).src=this.result;
				}
				//修改时记录要删除的图片id
				if(Number(len)>=Number(n)){
					var picId = $("#subId"+n).val();
					console.log("picId:"+picId);
					if(picId!=null && picId!=undefined && picId!=""){
						//记录删除的图片id
						if(delPicIds==""){
							delPicIds=""+picId;
						}else{
							delPicIds+=","+picId;
						}
						console.log(delPicIds);
					}
				}
			}
			//添加照片
			var index="${len}";
			var len="${len}";//记录个数
			function addRows(obj){
				index++;
				var strs = "<dd id=\"ddphoto"+index+"\">";
				strs+="<span class=\"title\">";
				strs+="<div class=\"divDel\">";
				strs+="<img id=\"photoImg2"+index+"\" alt=\"\" style=\"width: 200px;height: 160px;\" src=\"resource/images/login_bg.jpg\" />";
				strs+="<img class=\"imgDel\" src=\"resource/shop/mobile/images/delete_1.png\" onclick=\"deleteRows('"+index+"');\" />" 
				strs+="</div>";
				strs+="<div id=\"editDiv"+index+"\">";
				strs+="<input type=\"file\" accept=\"image/*\" name=\"file2"+index+"\" id=\"file2"+index+"\" onchange=\'showPictrue("+index+")\'  class=\"uploadFile\"/>";
				strs+="</div>";
				strs+="</dd>";
				$("#dl2").append(strs);
			}
			//删除照片
			var delPicIds="";
			function deleteRows(c){
				var picId = $("#subId"+c).val();
				if(picId!=null && picId!=undefined && picId!=""){
					//记录删除的图片id
					if(delPicIds==""){
						delPicIds=""+picId;
					}else{
						delPicIds+=","+picId;
					}
				}
				console.log(delPicIds);
				
				var ddphoto = document.getElementById("ddphoto"+c);
				ddphoto.parentNode.removeChild(ddphoto);
			}
			//编辑图片
			function modifyRows(n){
				var str="<input type='file' accept='image/*' name='file2"+n+"' id='file2"+n+"'  onchange='showPictrue("+n+")'   class='uploadFile'/>";
				if($("#file2"+n+"").length>0){
				}else{
					$("#editDiv"+n).append(str);
				}
			}
            //--------------------图片相关：结束-----------------

            function warBaseInfo() {
                var wareDj = "${ware.wareDj}";
                var lsPrice = "${ware.lsPrice}";
                var shopWarePrice = "${ware.shopWarePrice}";
                var shopWareLsPrice = "${ware.shopWareLsPrice}";

                if(shopWarePrice == null || shopWarePrice == undefined || shopWarePrice == ''){
                    $("#shopWarePrice").val(wareDj);
                }else{
                    $("#shopWarePrice").val(shopWarePrice);
                }
                if(shopWareLsPrice == null || shopWareLsPrice == undefined || shopWareLsPrice == ''){
                    $("#shopWareLsPrice").val(lsPrice);
                }else{
                    $("#shopWareLsPrice").val(shopWareLsPrice);
                }
            }
			
		</script>	
	</body>
</html>
