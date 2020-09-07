<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员界面</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<style type="text/css">
		</style>
	</head>
	<body>
		<div class="box">
  			<form action="manager/shopMember/update" name="shopMemberFrm" id="shopMemberFrm" method="post">
  			    <input  type="hidden" name="id" id="id" value="${model.id}"/>
				<dl id="dl">
	      			<dt class="f14 b">会员信息</dt>
	      			<dd>
	      				<span class="title">会员名称：</span>
	        			<input class="reg_input" name="name" id="name" readonly="readonly" value="${model.name}" style="width: 240px"/>
	        			<span id="nameTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">手&nbsp;&nbsp;机&nbsp;&nbsp;号：</span>
	        			<input class="reg_input" name="mobile" id="mobile" readonly="readonly" value="${model.mobile}" style="width: 240px"/>
	        			<span id="mobileTip" class="onshow"></span>
	        		</dd>

                    <%--员工会员不需要关联客户--%>
                    <c:if test="${''==source || '1'==source || '3'==source }" >
                        <dd id="dd_costomer">
                            <span class="title">关联客户：</span>
                            <input type="hidden" name="customerId" id="customerId" value="${model.customerId}"/>
                            <input class="reg_input"  name="customerName" id="customerName" value="${model.customerName}" style="width: 120px" readonly="readonly"/>
                            <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:choicecustomer();">选择</a>
                        </dd>
                        <dd>
                            <span class="title">关联客户：</span>
                            <div style="display: inline-block;margin-right: 10px">
                                <label for="qxCustomer_yes">是:</label>
                                <input type="radio" name="qxCustomer" value="1" id="qxCustomer_yes" <c:if test="${model.customerId !=null}">checked="checked"</c:if>>
                            </div>
                            <div style="display: inline-block;margin-right: 10px">
                                <label for="qxCustomer_no">否:</label>
                                <input type="radio" name="qxCustomer" value="0" id="qxCustomer_no" <c:if test="${model.customerId ==null}">checked="checked"</c:if>>
                            </div>
                        </dd>
                    </c:if>

					<%--进销存会员不需要:会员等级--%>
					<%--<c:if test="${'1'==source || '2'==source}" >--%>
						<dd>
					<span class="title">会员等级：</span><%--${source==3?'':' and is_jxc is null'}--%>
					<tag:select name="spMemGradeId" id="spMemGradeId" tableName="shop_member_grade" whereBlock="status=1" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="grade_name" value="${model.spMemGradeId}" tclass="selectClass"
								attrJson='[{"isJxc":"is_jxc"}]'/>
							<span style="color: #3388FF;font-size: 12px"> 常规会员只佣有普通等级，进销存客户可佣金普通等级</span>
				</dd>
					<%--</c:if>--%>
		        	<dd>
	      				<span class="title">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</span>
	        			<input class="reg_input" name="remark" id="remark" value="${model.remark}" style="width: 240px"/>
	        			<span id="remarkTip" class="onshow"></span>
	        		</dd>
					<%--员工会员，进销存会员不需要:线下支付--%>
					<%--<c:if test="${'1'==source}" >--%>
						<dd>
							<span class="title">线下支付：</span>
							<%--<div style="display: inline-block;margin-right: 10px">--%>
								<%--<label for="isXxzf_w">无:</label>--%>
								<%--<input type="radio" name="isXxzf" value="" id="isXxzf_w">--%>
							<%--</div>--%>
							<div style="display: inline-block;margin-right: 10px">
								<label for="isXxzf_0">不显示:</label>
								<input type="radio" name="isXxzf" value="0" id="isXxzf_0" <c:if test="${model.isXxzf eq 0}">checked="checked" </c:if>>
							</div>
							<div style="display: inline-block;margin-right: 10px">
								<label for="isXxzf_1">显示:</label>
								<input type="radio" name="isXxzf" value="1" id="isXxzf_1" <c:if test="${model.isXxzf eq 1}">checked="checked" </c:if>>
							</div>
							<span style="color: #3388FF;font-size: 12px">说明:会员下单选择支付方式是否显示“线下支付”</span>
						</dd>
					<%--</c:if>--%>
					<c:if test="${'3'==source}" >
					<dd>
						<span class="title">进销存客户：</span>
						<div style="display: inline-block;margin-right: 10px">
							<label for="khClose-0">不关闭:</label>
							<input type="radio" name="khClose" value="0" id="khClose-0" <c:if test="${model.khClose eq 0}">checked="checked" </c:if>>
						</div>
						<div style="display: inline-block;margin-right: 10px">
							<label for="khClose-1">关闭:</label>
							<input type="radio" name="khClose" value="1" id="khClose-1" <c:if test="${model.khClose eq 1}">checked="checked" </c:if>>
						</div>
						<span style="color: #3388FF;font-size: 12px">说明:关闭之后只会享受'常规会员'的价格</span>
					</dd>
					</c:if>
	        	</dl>
	        	  <div class="f_reg_but" style="clear:both">
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
		   function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					var qxCustomer=$("[name=qxCustomer]:checked").val();
					if(qxCustomer==1 && !$("#customerId").val()){
						alert("请选择关联客户");
						return false;
					}
					var isJxc=$("#spMemGradeId").find("option:selected").attr('isJxc');
					if(qxCustomer==0 && isJxc==1){
						alert("常规会员不可使用进销存等级");
						return false;
					}

					$("#shopMemberFrm").form('submit',{
						dataType: 'json',
						onSubmit:function(param){
							param.qxCustomer=$("[name=qxCustomer]:checked").val();
						},
						success:function(data){
							if("1"==data){
								alert("保存成功");
								toback();
								//location.href="${base}/manager/shopMember/toShopMemberPage";
							}else{
								alert("保存失败");
							}
						}
					});
				}
			}
			function toback(){
				history.back();
			}
			
			//选择客户
			function choicecustomer(){
				document.getElementById("windowifrm").src="manager/choicecustomer2";
				showWindow("选择客户");
			}
			//设置客户
			function setCustomer(id,khNm){
			   $("#customerId").val(id);
			   $("#customerName").val(khNm);
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
			$(function(){
				isShowCostomer();
			    $.formValidator.initConfig();
			    $("#name").formValidator({onShow:"请输入(25个字以内)",onFocus:"请输入(25个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:50,onError:"请输入(25个字以内)"});
			    $("#mobile").formValidator({onShow:"请输入(20个字符以内)",onFocus:"请输入(20个字符以内)",onCorrect:"通过"}).inputValidator({min:5,max:20,onError:"请输入(11个字符以上)"});
			});

		   //取消关联客户-单选框change事件
			$("input[type=radio][name=qxCustomer]").change(function(e){
				isShowCostomer();
			});

			function isShowCostomer() {
				var dd_costomer = $("#dd_costomer");
				var value=$("[name=qxCustomer]:checked").val();
				//取消关联客户--0:否；1:是
				if("1"===value){
					dd_costomer.show();
				}else if("0"===value){
					dd_costomer.hide();
				}
				changeMemberGrade();
			}

		   /**
			* 选择关联客户改变时修改等级可选状态
			*/
			function changeMemberGrade() {
				var qxCustomer=$("[name=qxCustomer]:checked").val();
				if(!qxCustomer || qxCustomer==0)
					$("#spMemGradeId").find("option[isJxc=1]").prop("disabled",true);
				else
					$("#spMemGradeId").find("option[isJxc=1]").prop("disabled",false);
			}
		</script>	
	</body>
</html>
