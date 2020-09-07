<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/opergroupgoods" name="groupgoodsfrm" id="groupgoodsfrm" method="post">
  			    <input  type="hidden" name="id" id="id" value="${groupgoods.id}"/>
  				<input type="hidden" name="pic" id="pic" value="${groupgoods.pic}" />
				<input type="hidden" name="oldpic" id="oldpic" value="${groupgoods.pic}" />
				<dl id="dl">
	      			<dt class="f14 b">商品信息</dt>
	      			<dd>
	      				<span class="title">商品图片：</span>
	        			<img id="photoImg" alt="" style="width: 210px;height: 220px;" />
	     				<iframe src="manager/toupfile?width=210&height=220" name="filefrm" id="filefrm" frameborder="0" marginheight="0" marginwidth="0" 
	     					height="22px" width="70px" scrolling="no"></iframe>
	     				<span id="picTip" class="onshow"></span>
	        		</dd>
	      			<dd>
	      				<span class="title">商品名称：</span>
	        			<input class="reg_input" name="gname" id="gname" value="${groupgoods.gname}" style="width: 240px"/>
	        			<span id="gnameTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">原价：</span>
	        			<input class="reg_input" name="yprice" id="yprice" value="${groupgoods.yprice}" style="width: 100px"/>
	        			<span id="ypriceTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">现价：</span>
	        			<input class="reg_input" name="xprice" id="xprice" value="${groupgoods.xprice}" style="width: 100px"/>
	        			<span id="xpriceTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">库存：</span>
	        			<input class="reg_input" name="stock" id="stock" value="${groupgoods.stock}" style="width: 100px"/>
	        			<span id="stockTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">销售量：</span>
	        			<input class="reg_input" name="salesvolume" id="salesvolume" value="${groupgoods.salesvolume}" style="width: 100px"/>
	        			<span id="salesvolumeTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">是否热销：</span>
	      				<input type="radio" name="isrx" id="isrx2" value="2"/>否
	        			<input type="radio" name="isrx" id="isrx1" value="1"/>是
	        		</dd>
	        		<dd>
	      				<span class="title">开始时间：</span>
	        			<input name="stime" id="stime" value="${groupgoods.stime}" onClick="WdatePicker();" style="width: 150px;" readonly="readonly"/>
	         			<img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        			<span id="stimeTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">结束时间：</span>
	        			<input name="etime" id="etime" value="${groupgoods.etime}" onClick="WdatePicker();" style="width: 150px;" readonly="readonly"/>
	         			<img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        			<span id="etimeTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">淘宝网址：</span>
	        			<input class="reg_input" name="url" id="url" value="${groupgoods.url}" style="width: 240px"/>
	        			<span id="urlTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">商品介绍：</span>
	        			<textarea style="width: 350px;;height: 150px;" name="remark" id="remark">${groupgoods.remark}</textarea>
	        		</dd>
	        		<dt class="f14 b">图片详情</dt>
	        		<c:if test="${empty details}">
	        			<dd id="ddphoto1">
		         			<span class="title">1.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;照片：</span>
		         			<input type="hidden" name="gpDetails[0].pic" id="photo1"/>
		         			<img id="photoImg1" alt="" style="width: 150px;height: 160px;" src="resource/images/login_bg.jpg"/ >
		     				<iframe src="manager/toupfile2?str1=photo1&str2=photoImg1&width=210&height=220" name="filefrm" id="filefrm" frameborder="0" marginheight="0" marginwidth="0" 
		     					height="22px" width="70px" scrolling="no"></iframe>
		     				<span id="photo1Tip" class="onshow"></span>
		 				</dd>
		  				<dd id="ddbutton1">
							<span class="title"></span>
							<a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加</a>
						</dd>
	        		</c:if>
	        		<c:if test="${!empty details}">
	        		<c:forEach items="${details}" var="detail" varStatus="s">
	        			<dd id="ddphoto${s.count}">
		         			<span class="title">${s.count}.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;照片：</span>
		         			<input type="hidden" name="gpDetails[${s.count-1}].oldpic" value="${detail.pic}"/>
		         			<input type="hidden" name="gpDetails[${s.count-1}].pic" id="photo${s.count}" value="${detail.pic}"/>
		         			<c:if test="${!empty detail.pic}">
		         				<img id="photoImg${s.count}" alt="" style="width: 150px;height: 160px;" src="upload/groupgoodsdetail/${detail.pic}"/>
		         			</c:if>
		         			<c:if test="${empty detail.pic}">
		         				<img id="photoImg${s.count}" alt="" style="width: 150px;height: 160px;" src="resource/images/login_bg.jpg"/>
		         			</c:if>
		     				<iframe src="manager/toupfile2?str1=photo${s.count}&str2=photoImg${s.count}&width=210&height=220" frameborder="0" marginheight="0" marginwidth="0" 
		     					height="22px" width="70px" scrolling="no"></iframe>
		     				<span id="photo${s.count}Tip" class="onshow"></span>
		 				</dd>
		  				<c:if test="${s.count==detailCount}">
							<dd id="ddbutton${s.count}"/>
						</c:if>
						<c:if test="${s.count!=detailCount}">
							<dd id="ddbutton${s.count}" style="display: none;"/>
						</c:if>
							<span class="title"></span>
							<a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加</a>
							<c:if test="${s.count>1}">
								<a class="easyui-linkbutton" iconcls="icon-remove" href="javascript:void(0);" onclick="deleteRows('${s.count}');">删除</a>
							</c:if>
					</c:forEach>
	        		</c:if>
	        	</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
	  		</form>
		</div>
		<div id="imgWindow" class="easyui-window" title="裁剪窗" closed="true" style="width:700; height:550"
			minimizable="false" maximizable="true" collapsible="false">
			<iframe name="imgiframe" id="imgiframe" frameborder="0" marginheight="0" marginwidth="0" 
		     	height="100%" width="100%" scrolling="no">
		     </iframe>
		</div>
		<div id="imgWindow2" class="easyui-window" title="裁剪窗" closed="true" style="width:700; height:550"
			minimizable="false" maximizable="true" collapsible="false">
			<iframe name="imgiframe2" id="imgiframe2" frameborder="0" marginheight="0" marginwidth="0" 
		     	height="100%" width="100%">
		    </iframe>
		</div>
		<script type="text/javascript">
		    var index = "${detailCount}";
			function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					$("#groupgoodsfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("添加成功");
								toback();
							}else if(data=="2"){
								alert("修改成功");
								toback();
							}else{
								alert("操作失败");
							}
						}
					});
				}
			}
			function toback(){
				location.href="${base}/manager/queryGroupGoods";
			}
			$(function(){
			    var isrx="${groupgoods.isrx}";
			    if(!isrx){
			      document.getElementById("isrx2").checked=true;
			    }else{
			      document.getElementById("isrx"+isrx).checked=true;
			    }
				$.formValidator.initConfig();
				$("#pic").formValidator({onShow:"请选择照片",onFocus:"请选择照片",onCorrect:"通过"}).inputValidator({min:1,max:30,onError:"请选择照片"});
				$("#gname").formValidator({onShow:"请输入(25个字以内)",onFocus:"请输入(100个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:50,onError:"请输入(25个字以内)"});
				$("#yprice").formValidator({onShow:"请输入金额",onFocus:"请输入金额"}).regexValidator({regExp:"money",dataType:"enum",onError:"金额格式不正确"});
				$("#xprice").formValidator({onShow:"请输入金额",onFocus:"请输入金额"}).regexValidator({regExp:"money",dataType:"enum",onError:"金额格式不正确"});
				$("#stock").formValidator({onShow:"请输数量",onFocus:"请输数量"}).regexValidator({regExp:"money",dataType:"enum",onError:"数量格式不正确"});
				$("#salesvolume").formValidator({onShow:"请输数量",onFocus:"请输数量"}).regexValidator({regExp:"money",dataType:"enum",onError:"数量格式不正确"});
				$("#stime").formValidator({onShow:"请选择开始时间",onFocus:"请选择开始时间",onCorrect:"通过"}).inputValidator({min:1,onError:"请选择开始时间"});
				$("#etime").formValidator({onShow:"请选择结束时间",onFocus:"请选择结束时间",onCorrect:"通过"}).inputValidator({min:1,onError:"请选择结束时间"});
				for(var i=1;i<=index;i++){
					$("#photo"+i).formValidator({onShow:"请选择照片",onFocus:"请选择照片",onCorrect:"通过"}).inputValidator({min:1,max:30,onError:"请选择照片"});
				}
				//图片
				var pic = $("#pic").val();
				if(pic!=""){
					document.getElementById("photoImg").setAttribute("src","upload/groupgoods/"+pic+"?"+Math.random());
				}else{
					document.getElementById("photoImg").setAttribute("src","resource/images/login_bg.jpg");
				}
			});
			//添加照片
			function addRows(obj){
				obj.parentNode.style.display="none";
				index++;
				var strs = "<dd id=\"ddphoto"+index+"\"><span class=\"title\"><input type=\"hidden\" name=\"gpDetails["+(index-1)+"].pic\" id=\"photo"+index+"\"/>"+index+".&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;照片：</span>&nbsp;<img id=\"photoImg"+index+"\" alt=\"\" style=\"width: 150px;height: 160px;\" src=\"resource/images/login_bg.jpg\" />";
				strs+="&nbsp;<iframe name=\"filefrm"+index+"\" id=\"filefrm"+index+"\" frameborder=\"0\" marginheight=\"0\" marginwidth=\"0\" ";
				strs+="height=\"22px\" width=\"70px\" scrolling=\"no\"></iframe><span id=\"photo"+index+"Tip\" class=\"onshow\"></span></dd>";
			    strs+="<dd id=\"ddbutton"+index+"\"><span class=\"title\"></span>&nbsp;<a class=\"easyui-linkbutton l-btn\" iconcls=\"icon-add\" href=\"javascript:void(0);\" onclick=\"addRows(this);\">";
				strs+="<span class=\"l-btn-left\"><span class=\"l-btn-text icon-add l-btn-icon-left\">增加</span></span></a>&nbsp;";
				strs+="<a class=\"easyui-linkbutton l-btn\" iconcls=\"icon-remove\" href=\"javascript:void(0);\" onclick=\"deleteRows('"+index+"');\">";
				strs+="<span class=\"l-btn-left\"><span class=\"l-btn-text icon-add l-btn-icon-left\">删除</span></span></a></dd>";
				$("#dl").append(strs);
				document.getElementById("filefrm"+index).src="manager/toupfile2?str1=photo"+index+"&str2=photoImg"+index+"&width=210&height=220";
				$("#photo"+index).formValidator({onShow:"请选择照片",onFocus:"请选择照片",onCorrect:"通过"}).inputValidator({min:1,max:30,onError:"请选择照片"});
			}
			//删除照片
			function deleteRows(c){
				var ddphoto = document.getElementById("ddphoto"+c);
				var ddexplain = document.getElementById("ddexplain"+c);
				var ddbutton = document.getElementById("ddbutton"+c);
				ddphoto.parentNode.removeChild(ddphoto);
				ddbutton.parentNode.removeChild(ddbutton);
				index--;
				document.getElementById("ddbutton"+(c-1)).style.display="block";
			}
			//判断图片
			function checkImg(obj){
				return checkExt(obj,"照片");
			}
				//显示上传消息
			function showUploadMsg(tp){
				if(tp==1){
					alert("上传的照片大小要大于210*220像素");
				}else if(tp==2){
					alert("上传出错");
				}
			}
			//显示图片
			function showPic(data){
			   document.getElementById("imgiframe").src="${base}/manager/groupgoodsToImgCoord?imgsrc="+data;
				$("#imgWindow").window({
					title:"商品图片",
					top:getScrollTop()+30
				});
				$("#imgWindow").window('open');
			}
			//显示截图小图
			function showPhotoMini(data,dataOld){
			    $("#pic").val(data);
				document.getElementById("photoImg").setAttribute("src","upload/temp/"+data+"?"+Math.random());
				hideImgWin();
			}
			//底下显示图片
			function showPic2(data,str1,str2){
				//设置原图的图片名称
				//$("#"+str1).val(data);
				document.getElementById("imgiframe2").src="${base}/manager/groupgoodsToImgCoord2?imgsrc="+data+"&str1="+str1+"&str2="+str2;
				$("#imgWindow2").window({
					title:"图片详情",
					top:getScrollTop()+30
				});
				$("#imgWindow2").window('open');
			}
			function showPhotoMini2(data,str2,str1,dataOld){
			    //设置剪裁后的图片名称
			    $("#"+str1).val(data);
				document.getElementById(str2).setAttribute("src","upload/temp/"+data+"?"+Math.random());
				hideImgWin2();
			}
			function hideImgWin(){
				$("#imgWindow").window('close');
			}
			function hideImgWin2(){
				$("#imgWindow2").window('close');
			}
		</script>
	</body>
</html>
