<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>人员管理</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/md5.js"></script>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/opermember" name="memberfrm" id="memberfrm" method="post">
  			    <input  type="hidden" name="memberId" id="memberId" value="${member.memberId}"/>
  			    <input type="hidden" name="oldPwd" id="oldPwd" value="${member.memberPwd }" />
  				<input  type="hidden" name="memberHead" id="memberHead" value="${member.memberHead}"/>
  				<input  type="hidden" name="memberFans" id="memberFans" value="${member.memberFans}"/>
  				<input  type="hidden" name="memberAttentions" id="memberAttentions" value="${member.memberAttentions}"/>
  				<input  type="hidden" name="memberBlacklist" id="memberBlacklist" value="${member.memberBlacklist}"/>
  				<input  type="hidden" name="memberCompany" id="memberCompany" value="${member.memberCompany}"/>
  				<input  type="hidden" name="memberActivate" id="memberActivate" value="${member.memberActivate}"/>
  				<input  type="hidden" name="memberActivatime" id="memberActivatime" value="${member.memberActivatime}"/>
  				<input type="hidden" name="memberGraduated" id="memberGraduated" value="${member.memberGraduated}" />
  				<input  type="hidden" name="memberUse" id="memberUse" value="${member.memberUse}"/>
  				<input  type="hidden" name="memberCreator" id="memberCreator" value="${member.memberCreator}"/>
  				<input  type="hidden" name="memberCreatime" id="memberCreatime" value="${member.memberCreatime}"/>
  				<input  type="hidden" name="memberLogintime" id="memberLogintime" value="${member.memberLogintime}"/>
  				<input  type="hidden" name="memberLoginnum" id="memberLoginnum" value="${member.memberLoginnum}"/>
  				<input  type="hidden" name="smsNo" id="smsNo" value="${member.smsNo}"/>
  				<input  type="hidden" name="isAdmin" id="isAdmin" value="${member.isAdmin}"/>
  				<input  type="hidden" name="unitId" id="unitId" value="${member.unitId}"/>
  				<input  type="hidden" name="oldtel" id="oldtel" value="${member.memberMobile}"/>
  				<input  type="hidden" name="state" id="state" value="${member.state}"/>
  				<input  type="hidden" name="score" id="score" value="${member.score}"/>
  				<input  type="hidden" name="branchId" id="branchId"/>
  				<input type="hidden" name="oldisLead" value="${member.isLead }"/>
  				<input type="hidden" name="msgmodel" value="${member.msgmodel }"/>
  				<input type="hidden" name="unId" value="${member.unId }"/>
  				<input type="hidden" name="useDog" value="${member.useDog }"/>
				<input type="hidden" name="rzMobile" value="${member.rzMobile }"/>
				<input type="hidden" name="rzState" value="${member.rzState }"/>
  			    <dl id="dl">
	      			<dt class="f14 b">成员信息</dt>
	      			<dd>
	      				<span class="title">成员姓名：</span>
	        			<input class="reg_input" name="memberNm" id="memberNm" value="${member.memberNm}" style="width: 120px"/>
	        			<span id="memberNmTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">手机号码：</span>
	        			<input class="reg_input" name="memberMobile" id="memberMobile" value="${member.memberMobile}" style="width: 120px"/>
	        			<span id="memberMobileTip" class="onshow"></span>
	        		</dd>
	        		<c:if test="${not empty member.memberId}">
	        			<dd>
		      				<span class="title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;密码：</span>
		        			<input type="password" class="reg_input" name="memberPwd" id="memberPwd" value="${member.memberPwd}" style="width: 120px"/>
		        			<span id="memberPwdTip" class="onshow"></span>
	        			</dd>
	        		</c:if>
	        		<dd>
	      				<span class="title">职位：</span>
	        			<input class="reg_input" name="memberJob" id="memberJob" value="${member.memberJob}" style="width: 100px"/>
	        		</dd>
	        		<dd>
	      				<span class="title">行业：</span>
	        			<input class="reg_input" name="memberTrade" id="memberTrade" value="${member.memberTrade}" style="width: 100px"/>
	        		</dd>
	        		<dd>
	      				<span class="title">是否领导(VIP)：</span>
	        			<input type="radio" name="isLead" id="isLead1" value="1"/>是
	        			<input type="radio" name="isLead" id="isLead2" value="2"/>否
	        		</dd>
        			<dd>
        				<span class="title">角色选择：</span>
						<input id="comboxid" name="roleIds">
        			</dd>
        			<c:if test="${tpNm=='卖场'}">
        			  <dd>
        			    <input  type="hidden" name="cid" id="cid" value="${member.cid}"/> 
	      				<span class="title">所属客户：</span>
	        			<input name="khNm" id="khNm" value="${khNm}" style="width: 120px" readonly="readonly"/>
	        			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:choicecustomer();">查询</a>
	        		  </dd>
        			</c:if>
	        		   <dd>
	        		   		<span class="title">部门：</span>
		        		   	<select id="branchId2" class="easyui-combotree" style="width:200px;"   
	        					data-options="url:'manager/departs?dataTp=1',onClick: function(node){
									depart(node.id);}">
							</select>
	        		   </dd>
	        		<dd>
	      				<span class="title">家乡：</span>
	        			<input class="reg_input" name="memberHometown" id="memberHometown" value="${member.memberHometown}" style="width: 200px"/>
	        		</dd>
	        		<%--<dd>
	      				<span class="title">毕业院校：</span>
	        			<input class="reg_input" name="memberGraduated" id="memberGraduated" value="${member.memberGraduated}" style="width: 120px"/>
	        		</dd>
	        		--%>
	        		<dd>
	      				<span class="title">简介：</span>
	        			<textarea rows="4" cols="50" name="memberDesc" id="memberDesc">${member.memberDesc}</textarea>
	        		</dd>
	        	</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
	  		</form>
		</div>
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
		
		    $(function(){
				$.formValidator.initConfig();
				$("#memberNm").formValidator({onShow:"请输入(15个字符以内)",onFocus:"请输入(15个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:15,onError:"请输入(15个字符以内)"});
				$("#memberMobile").formValidator({onShow:"请输入(15个字符以内)",onFocus:"请输入(11个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:15,onError:"请输入(15个字符以内)"});
				var isLead="${member.isLead}";
				if(isLead=='1'){
				  document.getElementById("isLead1").checked=true;
				}else{
				   document.getElementById("isLead2").checked=true;
				}
				if("${member.memberId}"!=""){
					$('#memberMobile').attr("readonly","readonly");
				}
				var branchName ='${branchName}';
				if(branchName !=""){
					$('#branchId2').combotree('setValue', branchName);
					$("#branchId").val(${member.branchId});
				}
				//初始化角色
				var roleIds = "${roleIds}";
				if(roleIds!=""){
					$('#comboxid').combobox('setValues',roleIds.split(','))
				} else {
					$('#comboxid').combobox('setValue','4')
				}
			});

			function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					//验证手机号码
					var reg=new RegExp("^(13|15|18|14|17|19)[0-9]{9}$");
					var tel = $("#memberMobile").val();
					if(!reg.test(tel)){
						alert("请输入正确的电话号码格式");
						return;
					}
					var memberId = $("#memberId").val();
					if(memberId!='' && memberId!=undefined){
						var memberPwd = $("#memberPwd").val();
						var oldPwd = $("#oldPwd").val();
						if(memberPwd!=oldPwd){//密码
							$("#memberPwd").val(hex_md5(memberPwd));
						}
					}
					//成员角色必填
					var roleIds = $("input[name='roleIds']").val();
					if (roleIds=='' || roleIds==undefined) {
						alert("成员角色必填");
						return;
					}
					var branchId=$("#branchId").val();
					if(!branchId){
					    alert("请选择部门");
						return;
					}
					$("#memberfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("添加成功");
								toback();
							}else if(data=="2"){
								alert("修改成功");
								toback();
							}else if(data=="3"){
								alert("该手机号码已存在");
								return;
							}else if(data=="4"){
								alert("不能直接添加管理员与创建者角色");
								return;
							}else if(data=='5'){
								alert("当前企业有错误");
							}else{
								alert("操作失败");
							}
						}
					});
				}
			}
			function toback(){
				//location.href="${base}/manager/querymember";
				window.history.go(-1);
			}
			
			//设置部门ID
            function depart(id){
            	$("#branchId").val(id);
            }
            //选择客户
			function choicecustomer(){
				document.getElementById("windowifrm").src="manager/choicecustomer2";
				showWindow("选择客户");
			}
			//设置客户
			function setCustomer(id,khNm){
			   $("#cid").val(id);
			   $("#khNm").val(khNm);
			   $("#choiceWindow").window('close');
			}
			//显示弹出窗口
			function showWindow(title){
				$("#choiceWindow").window({
					title:title,
					top:getScrollTop()+50
				});
				$("#choiceWindow").window('open');
			}
			
			////////////////////////////
			$('#comboxid').combobox({
                url:'manager/queryRoleList',
                method:'post',
                valueField:'idKey',
                textField:'roleNm',
                panelHeight:'auto',
                multiple:true,
                formatter: function (row) {
                    var opts = $(this).combobox('options');
                    return '<input type="checkbox" class="combobox-checkbox">' + row[opts.textField]
                },
                onLoadSuccess : function(){//在加载远程数据成功的时候触发
				    var opts = $(this).combobox("options");
				    var target = this;
				    var values = $(target).combobox("getValues");
				    $.map(values, function(value){
				        var children = $(target).combobox("panel").children();
				        $.each(children, function(index, obj){
						    if(value == obj.getAttribute("value") && obj.children && obj.children.length > 0){
						        obj.children[0].checked = true;
					            }
						});
				    });
				},
				onSelect : function(row){//在用户选择列表项的时候触发。
				    var opts = $(this).combobox("options");
				    var objCom = null;
				    var children = $(this).combobox("panel").children();
				    $.each(children, function(index, obj){
				    console.log(obj.getAttribute("value"));
				        if(row[opts.valueField] == obj.getAttribute("value")){
					    objCom = obj;
					}
				    });
				    if(objCom != null && objCom.children && objCom.children.length > 0){
				        objCom.children[0].checked = true;
				    }
				},
				onUnselect : function(row){//在用户取消选择列表项的时候触发。
				    var opts = $(this).combobox("options");
				    var objCom = null;
				    var children = $(this).combobox("panel").children();
				    $.each(children, function(index, obj){
				        if(row[opts.valueField] == obj.getAttribute("value")){
					    	objCom = obj;
						}
				    });
				    if(objCom != null && objCom.children && objCom.children.length > 0){
				        objCom.children[0].checked = false;
				    }
				}
            });
            
		</script>
	</body>
</html>
