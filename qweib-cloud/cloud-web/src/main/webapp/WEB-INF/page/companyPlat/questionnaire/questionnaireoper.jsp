<%@ page language="java" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝管理</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
        <script src="resource/jquery.imgareaselect.pack.js"></script> 
        <link rel="stylesheet" type="text/css" href="resource/css/imgareaselect-default.css" /> 
        <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
       
	</head>
	<body>
		<div class="box">
  			<form action="manager/operquestionnaire" name="questionnairefrm" id="questionnairefrm" method="post">
  			    <input type="hidden" name="qid" id="qid" value="${questionnaire.qid}"/>
  			    <input type="hidden" name="dsck" id="dsck" value="${questionnaire.dsck}"/>
  			    <input type="hidden" name="memberId" id="memberId" value="${questionnaire.memberId}"/>
  			    <input type="hidden" name="stime" id="stime" value="${questionnaire.stime}"/>
  			    <input type="hidden" name="branchId" id="branchId"/>
  				<dl id="dl">
  				    <dt class="f14 b">问卷信息</dt>
	      			<dd>
	      				<span class="title">标题：</span>
	        			<input class="reg_input" name="title" id="title" value="${questionnaire.title}" style="width: 240px"/>
	        			<span id="titleTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">单多选项：</span>
	        			<input type="radio" name="pddsx" id="pddsx1" value="1" onclick="pddsxs(1);"/>单选项
	        			<input type="radio" name="pddsx" id="pddsx2" value="2" onclick="pddsxs(2);"/>多选项
	        		</dd>
	        		<dd id="yc">
	      				<span class="title">最多选择几项：</span>
	        			<input class="reg_input" name="zhi" id="zhi" value="${questionnaire.dsck}" style="width: 60px"/>
	        			<span class="onshow">设置最多选择几项，0为不限制</span>
	        		</dd>
	        		<dd>
	      				<span class="title">内容：</span>
	        			<textarea style="width:400px;height:180px;" name="content" id="content">${questionnaire.content}</textarea>
	        		</dd>
	        		<dd>
	      				<span class="title">截止时间：</span>
	        			<input name="etime" id="etime" value="${questionnaire.etime}" onClick="WdatePicker();" style="width: 150px;" readonly="readonly"/>
	         			<img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			<span id="etimeTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	        			<span class="title">所属部门：</span>
	        		 	<select id="branchId" class="easyui-combotree" style="width:200px;"   
        					data-options="url:'manager/departree',onClick: function(node){
								depart(node.id);}">
						</select>
						<span id="branchIdTip" class="onshow"></span>
	        		</dd>
	        		<dt class="f14 b">选项内容</dt>
	        		<c:if test="${empty details}">
	        			<dd id="ddphoto1" class="ovote">
		         			<span class="title">A.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		         			<input name="lsQuestionnaireDetail[0].no" id="no0" value="A" type="hidden"/>
		         			<input name="lsQuestionnaireDetail[0].content" id="content0" style="width: 240px;height:25px;" placeholder="请输入选项内容"/>
		     			</dd>
		  				<dd id="ddbutton1" class="ovote">
							<span class="title"></span>
							<a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加</a>
						</dd>
	        		</c:if>
	        		<c:if test="${!empty details}">
	        		<c:forEach items="${details}" var="detail" varStatus="s">
	        			<dd id="ddphoto${s.count}" class="ovote" >
		         			<span class="title">${detail.no}.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		         			<input name="lsQuestionnaireDetail[${s.count-1}].no" id="no[${s.count-1}]" value="${detail.no}" type="hidden"/>
		         			<input name="lsQuestionnaireDetail[${s.count-1}].content" id="content[${s.count-1}]" value="${detail.content}" style="width: 240px;height:25px;" />
		         		</dd>
		  				<c:if test="${s.count==detailCount}">
							<dd id="ddbutton${s.count}" class="ovote"/>
						</c:if>
						<c:if test="${s.count!=detailCount}" >
							<dd id="ddbutton${s.count}" style="display: none;" class="ovote"/>
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
	    			<input type="button"  value="保存" class="l_button" onclick="toSubmit();"/>
	      			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
	  		</form>
		</div>
		<script type="text/javascript">
			var index = "${detailCount}";
			//保存
			function toSubmit(){
			    var pddsx = document.getElementsByName("pddsx");
			    var dsck="";
				for(var i=0;i<pddsx.length;i++)
				{
				  if(pddsx[i].checked){
				    dsck=pddsx[i].value;
				  }
				}
				if(dsck=='1'){
				  $("#dsck").val(dsck);
				}else{
				  var zhi=$("#zhi").val();
				  if(!zhi){
				    alert("最多选择几项不能为空");
				    return;
				  }
				  $("#dsck").val(zhi);
				  //验证选项是否大于能选的最大选项
				}
				if ($.formValidator.pageIsValid()==true){
					$("#questionnairefrm").form('submit',{
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
			    location.href="${base}/manager/queryquestionnaire";
			}
			$(function(){
			    var dsck="${questionnaire.dsck}";
			    if(dsck=='1'){
			        document.getElementById("pddsx1").checked=true;
			        pddsxs(1);
			    }else{
			        document.getElementById("pddsx2").checked=true;
			        pddsxs(2);
			    }
			    if(!dsck){
			       document.getElementById("pddsx1").checked=true;
			       pddsxs(1);
			    }
			    $.formValidator.initConfig();
				$("#title").formValidator({onShow:"2-50个字符",onFocus:"2-50个字符",onCorrect:"标题可以用"}).inputValidator({min:2,max:50,onError:"请输入正确标题"});
				$("#etime").formValidator({onShow:"请选择截止时间",onFocus:"请选择截止时间",onCorrect:"通过"}).inputValidator({min:1,onError:"请选择截止时间"});
				$("#branchId").formValidator({onShow:"请选择部门",onFocus:"请选择部门",onCorrect:"通过"}).inputValidator({min:1,onError:"请选择部门"});
			});
			//添加套餐
			function addRows(obj){
				obj.parentNode.style.display="none";
				index++;
				var strs = "<dd id=\"ddphoto"+index+"\" class=\"ovote\"><span class=\"title\">"+String.fromCharCode(64 + parseInt(index))+".&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;";
				strs+="<input name=\"lsQuestionnaireDetail["+(index-1)+"].no\" id=\"no"+index+"\" value=\""+String.fromCharCode(64 + parseInt(index))+"\" type=\"hidden\"/>";
				strs+="<input name=\"lsQuestionnaireDetail["+(index-1)+"].content\" id=\"content"+index+"\" style=\"width: 240px;height:25px;\" placeholder=\"请输入选项内容\"/>";
				strs+="</dd>";
				strs+="<dd id=\"ddbutton"+index+"\"><span class=\"title\"></span>&nbsp;<a class=\"easyui-linkbutton l-btn\" iconcls=\"icon-add\" href=\"javascript:void(0);\" onclick=\"addRows(this);\">";
				strs+="<span class=\"l-btn-left\"><span class=\"l-btn-text icon-add l-btn-icon-left\">增加</span></span></a>&nbsp;";
				strs+="<a class=\"easyui-linkbutton l-btn\" iconcls=\"icon-remove\" href=\"javascript:void(0);\" onclick=\"deleteRows('"+index+"');\">";
				strs+="<span class=\"l-btn-left\"><span class=\"l-btn-text icon-add l-btn-icon-left\">删除</span></span></a></dd>";
				$("#dl").append(strs);
			}
			//删除选项
			function deleteRows(c){
				var ddphoto = document.getElementById("ddphoto"+c);
				var ddbutton = document.getElementById("ddbutton"+c);
				ddphoto.parentNode.removeChild(ddphoto);
				ddbutton.parentNode.removeChild(ddbutton);
				index--;
				document.getElementById("ddbutton"+(c-1)).style.display="block";
			}
            function pddsxs(num){
              if(num=='1'){
                 document.getElementById("yc").style.display="none";
              }else{
                 document.getElementById("yc").style.display="";
              }
            }
            //设置部门ID
            function depart(id){
            	$("#branchId").val(id);
            }
       </script>
	</body>
</html>
