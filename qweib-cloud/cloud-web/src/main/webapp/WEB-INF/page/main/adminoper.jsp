<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝用户密码修改</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/md5.js"></script>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/operAdmin" name="memberfrm" id="memberfrm" method="post">
  			    <input  type="hidden" name="memberId" id="memberId" value="${member.memberId}"/>
  			    <input type="hidden" name="oldPwd" id="oldPwd" value="${member.memberPwd }" />
  				<input  type="hidden" name="memberHead" id="memberHead" value="${member.memberHead}"/>
  				<input  type="hidden" name="memberActivate" id="memberActivate" value="${member.memberActivate}"/>
  				<input  type="hidden" name="memberUse" id="memberUse" value="${member.memberUse}"/>
  				<input  type="hidden" name="memberCreatime" id="memberCreatime" value="${member.memberCreatime}"/>
  				<input  type="hidden" name="isAdmin" id="isAdmin" value="${member.isAdmin}"/>
  				<input  type="hidden" name="oldtel" id="oldtel" value="${member.memberMobile}"/>
  				<input  type="hidden" name="state" id="state" value="${member.state}"/>
  				<input  type="hidden" name="score" id="score" value="${member.score}"/>
  				<input type="hidden" name="oldisLead" value="${member.isLead }"/>
  				<input type="hidden" name="memberName" value="${member.memberName }"/>
  				<span style="color: red"><c:if test="${not empty param.msg }">${param.msg }</c:if></span>
  				<dl id="dl">
	      			<dd>
	      				<span class="title">用户名：</span>
	        			<input class="reg_input" readonly="readonly" name="memberNm" id="memberNm" value="${member.memberNm}" style="width: 120px"/>
	        			<span id="memberNmTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">账号：</span>
	        			<input class="reg_input" name="memberMobile" readonly="readonly" id="memberMobile" value="${member.memberMobile}" style="width: 120px"/>
	        			<!-- <span id="memberMobileTip" class="onshow"></span> -->
	        		</dd>
	        		<dd>
	      				<span class="title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;原密码：</span>
	        			<input type="password" class="reg_input" name="oldMemberPwd" id="oldMemberPwd"    style="width: 120px"/>
	        			<span id="oldMemberPwdTip" class="onshow"></span>
        			</dd>
        			<dd>
	      				<span class="title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;密&nbsp;&nbsp;码：</span>
	        			<input type="password" class="reg_input" name="memberPwd" id="memberPwd"  style="width: 120px"/>
	        			<span id="memberPwdTip" class="onshow"></span>
        			</dd>
	        	</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	     		</div>
	  		</form>
		</div>
		
		<script type="text/javascript">
		
		    $(function(){
				$.formValidator.initConfig();
				//$("#memberNm").formValidator({onShow:"请输入(15个字符以内)",onFocus:"请输入(15个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:15,onError:"请输入(15个字符以内)"});
				//$("#memberMobile").formValidator({onShow:"请输入(15个字符以内)",onFocus:"请输入(10个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:15,onError:"请输入(15个字符以内)"});
				$("#oldMemberPwd").formValidator({onShow:"请输入(至少6个字符以上)",onFocus:"请输入(至少6个字符以上)",onCorrect:"通过"}).inputValidator({min:6,max:100,onError:"请输入(至少6个字符以上)"});
				$("#memberPwd").formValidator({onShow:"请输入(至少6个字符以上)",onFocus:"请输入(至少6个字符以上)",onCorrect:"通过"}).inputValidator({min:6,max:100,onError:"请输入(至少6个字符以上)"});
			});

		    //更改角色判断
			function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					//验证手机号码
					//var reg=new RegExp("^(13|15|18|14)[0-9]{9}$");
					//var tel = $("#memberMobile").val();
					//if(!reg.test(tel)){
					//	alert("请输入正确的电话号码格式");
					//	return;
					//}
					var oldPwd = $("#oldPwd").val();
					var oldMemberPwd=$("#oldMemberPwd").val();
					oldMemberPwd = hex_md5(oldMemberPwd);
					if(oldMemberPwd!=oldPwd){
						 $.messager.alert('消息','原密码输入不正确!','info');
						 return;
					}
					var memberPwd = $("#memberPwd").val();
					if(memberPwd=="123456"){
						$.messager.alert('消息','密码不能为123456!','info');
						return;
					}
					memberPwd=hex_md5(memberPwd);
					if(oldMemberPwd==memberPwd){
						 $.messager.alert('消息','新密码不能等于原密码!','info');
						 return;
					}
					if(memberPwd!=oldPwd){//密码
						$("#memberPwd").val(memberPwd);
					}
					$("#memberfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("修改成功");
								var memberNm = $("#memberNm").val();
								window.parent.close(memberNm);
								return;
							}else{
								alert("修改失败");
							}
						}
					});
				}
			}
			
			//设置部门ID
		</script>
	</body>
</html>
