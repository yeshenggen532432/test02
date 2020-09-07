<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/addKhfbszLs" name="BonusSharfrm" id="BonusSharfrm" method="post">
  				<dl id="dl">
	      			<c:if test="${!empty list}">
		        		<c:forEach items="${list}" var="list" varStatus="s">
		        		    <dd id="dds${s.count}">
			  					<span class="title"><b>${s.count}.</b>开始分钟：</span>
			  					<input id="snums${s.count}" name="KhfbszList[${s.count-1}].snums" value="${list.snums}" class="reg_input" style="width: 150px"/>
			         			<span id="snums${s.count}Tip" class="onshow"></span>
						    </dd>
						    <dd id="dde${s.count}">
			  					<span class="title">结束分钟：</span>
			  					<input id="enums${s.count}" name="KhfbszList[${s.count-1}].enums" value="${list.enums}" class="reg_input" style="width: 150px"/>
			         			<span id="enums${s.count}Tip" class="onshow"></span>
						    </dd>
		        			<dd id="ddbl${s.count}">
			  					<span class="title" >颜色：</span>
			  					<select id="ysz${s.count}" name="KhfbszList[${s.count-1}].ysz">
			  					  <option value="">请选择颜色</option>
			  					  <option value="红色" <c:if test="${list.ysz=='红色'}">selected</c:if>>红色</option>
			  					  <option value="绿色" <c:if test="${list.ysz=='绿色'}">selected</c:if>>绿色</option>
			  					  <option value="黑色" <c:if test="${list.ysz=='黑色'}">selected</c:if>>黑色</option>
			  					  <option value="黄色" <c:if test="${list.ysz=='黄色'}">selected</c:if>>黄色</option>
			  					</select>
			  					<span id="ysz${s.count}Tip" class="onshow"></span>
						    </dd>
						    <c:if test="${s.count==detailCount}">
								<dd id="ddbuttonM${s.count}"/>
							</c:if>
							<c:if test="${s.count!=detailCount}">
								<dd id="ddbuttonM${s.count}" style="display: none;"/>
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
	      		</div>
	  		</form>
		</div>
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
		   var index = "${detailCount}";
		   function toSubmit(){
			   if ($.formValidator.pageIsValid()==true){
					$("#BonusSharfrm").form('submit',{
						success:function(data){
							if(data=="1"){
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
				location.href="${base}/manager/queryKhfbszLs";
			}
			$(function(){
			    $.formValidator.initConfig();
				for(var i=1;i<=index;i++){
				   $("#snums"+i).formValidator({onShow:"请输分钟",onFocus:"请输分钟"}).regexValidator({regExp:"money",dataType:"enum",onError:"分钟格式不正确"});
				   $("#enums"+i).formValidator({onShow:"请输分钟",onFocus:"请输分钟"}).regexValidator({regExp:"money",dataType:"enum",onError:"分钟格式不正确"});
				   $("#ysz"+i).formValidator({onShow:"请选择颜色",onFocus:"请选择颜色",onCorrect:"通过"}).inputValidator({min:1,max:10,onError:"请选择颜色"});
				}
			});
			//添加
			function addRows(obj){
			    obj.parentNode.style.display="none";
				index++;
				var strs = "<dd id=\"dds"+index+"\"><span class=\"title\"><b>"+index+".</b>开始分钟：</span><input id=\"snums"+index+"\" name=\"KhfbszList["+(index-1)+"].snums\"  class=\"reg_input\" style=\"width: 150px\"/><span id=\"snums"+index+"Tip\" class=\"onshow\"></span></dd>";
				strs+="<dd id=\"dde"+index+"\"><span class=\"title\">结束分钟：</span><input id=\"enums"+index+"\" name=\"KhfbszList["+(index-1)+"].enums\" class=\"reg_input\" style=\"width: 150px\"/><span id=\"enums"+index+"Tip\" class=\"onshow\"></span></dd>";
				strs+="<dd id=\"ddbl"+index+"\"><span class=\"title\">颜色：</span><select id=\"ysz"+index+"\" name=\"KhfbszList["+(index-1)+"].ysz\">";
				strs+="<option value=\"\">请选择颜色</option>";
			  	strs+="<option value=\"红色\">红色</option>";
			  	strs+="<option value=\"绿色\">绿色</option>";
			  	strs+="<option value=\"黑色\">黑色</option>";
			  	strs+="<option value=\"黄色\">黄色</option>";
			  	strs+="</select><span id=\"ysz"+index+"Tip\" class=\"onshow\"></span></dd>";
				strs+="<dd id=\"ddbuttonM"+index+"\"><span class=\"title\"></span>&nbsp;<a class=\"easyui-linkbutton l-btn\" iconcls=\"icon-add\" href=\"javascript:void(0);\" onclick=\"addRows(this);\">";
				strs+="<span class=\"l-btn-left\"><span class=\"l-btn-text icon-add l-btn-icon-left\">增加</span></span></a>&nbsp;";
				strs+="<a class=\"easyui-linkbutton l-btn\" iconcls=\"icon-remove\" href=\"javascript:void(0);\" onclick=\"deleteRows('"+index+"');\">";
				strs+="<span class=\"l-btn-left\"><span class=\"l-btn-text icon-add l-btn-icon-left\">删除</span></span></a></dd>";
				$("#dl").append(strs);
				$("#snums"+index).formValidator({onShow:"请输分钟",onFocus:"请输分钟"}).regexValidator({regExp:"money",dataType:"enum",onError:"分钟格式不正确"});
				$("#enums"+index).formValidator({onShow:"请输分钟",onFocus:"请输分钟"}).regexValidator({regExp:"money",dataType:"enum",onError:"分钟格式不正确"});
				$("#ysz"+index).formValidator({onShow:"请选择颜色",onFocus:"请选择颜色",onCorrect:"通过"}).inputValidator({min:1,max:10,onError:"请选择颜色"});
		    }
			//删除
			function deleteRows(c){
				var dds = document.getElementById("dds"+c);
				var dde = document.getElementById("dde"+c);
				var ddbl = document.getElementById("ddbl"+c);
				var ddbuttonM = document.getElementById("ddbuttonM"+c);
				dds.parentNode.removeChild(dds);
				dde.parentNode.removeChild(dde);
				ddbl.parentNode.removeChild(ddbl);
				ddbuttonM.parentNode.removeChild(ddbuttonM);
				index--;
				document.getElementById("ddbuttonM"+(c-1)).style.display="block";
			}
		</script>
	</body>
</html>

