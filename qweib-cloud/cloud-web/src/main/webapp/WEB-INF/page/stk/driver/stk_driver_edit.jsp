<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/md5.js"></script>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/saveDriver" name="stkfrm" id="stkfrm" method="post">
  			<input  type="hidden" name="id" id="id" value="${driver.id}"/>    
  				
  				
  			    <dl id="dl">
	      			<dt class="f14 b">司机信息</dt>
	      			
	        		<dd>
	      				<span class="title">司机姓名：</span>
	        			<input class="reg_input" name="driverName" id="driverName" value="${driver.driverName}" style="width: 120px"/>
	        			<span id="memberNmTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">联系电话：</span>
	        			<input class="reg_input" name="tel" id="tel" value="${driver.tel}" style="width: 120px"/>
	        		</dd>
					<dd>
						<span class="title">关联员工：</span>
						<tag:select name="memberId" id="memberId" tableName="sys_mem" headerKey="-1" headerValue="--请选择--"
									   displayKey="member_id" displayValue="member_nm"/>
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
				$("#driverName").formValidator({onShow:"请输入(15个字符以内)",onFocus:"请输入(15个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:15,onError:"请输入(15个字符以内)"});
			});

			function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					//验证手机号码
					$("#stkfrm").form('submit',{
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
							}else{
								alert("操作失败");
							}
						}
					});
				}
			}
			function toback(){
				location.href="${base}/manager/toStkDriver";
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
