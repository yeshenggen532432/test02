<%@ page language="java" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
		<title>添加应用</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body onload="showMsg('${showMsg}');">
		<div id="wrapper" class="clearfix">
			<form action="manager/addSysApply" method="post" id="applyFrm">
				<input type="hidden" name="pId" value="${applyDTO.PId}"/>
				<div class="addMenu">
					<ul>
						<li>
							<label>
								应用名称：
							</label>
							<input type="text" name="applyName" id="applyName" class="inputBg" style="width:176px;" />
						</li>
						<li>
							<label>
								应用代码：
							</label>
							<input type="text" name="applyCode" id="applyCode" class="inputBg" style="width:176px;" />
						</li>
						<li>
							<label>
								排&nbsp;&nbsp;序&nbsp;&nbsp;号：
							</label>
							<input type="text" name="applyNo" id="applyNo" class="inputBg" style="width:176px;" />
						</li>
						<li>
							<label>
								是否有子菜单：
							</label>
							<input type="radio" name="menuLeaf" id="menuLeaf1" 
								value="1" ${applyDTO.menuTp==1?'disabled':''} ${applyDTO.menuLeaf==1?'checked':''}/>是
							<input type="radio" name="menuLeaf" id="menuLeaf0" 
								value="0" ${applyDTO.menuTp==1?'disabled':''} checked="checked" ${applyDTO.menuLeaf==0?'checked':''}/>否
							&nbsp;&nbsp;<span style="color: gray">*最后一级选择否</span>
						</li>
						<li>
							<label>
								菜单类型：
							</label>
							<input type="radio" name="menuTp" id="menuTp0" value="0" ${applyDTO.menuTp==0?'checked':''}/>功能菜单
							<input type="radio" name="menuTp" id="menuTp1" value="1" checked="checked" ${applyDTO.menuTp==1?'checked':''}/>功能按钮
							&nbsp;&nbsp;<span style="color: gray">*最后一级选择功能按钮</span>
						</li>
						<li id="applyIfwapLi">
							<label>
								应用类型：
							</label>
							<input type="radio" name="applyIfwap" id="applyIfwap0" 
								value="0" ${applyDTO.applyIfwap==0?'disabled':''} ${applyDTO.applyIfwap==1?'checked':''}/>原生
							<input type="radio" name="applyIfwap" id="applyIfwap1" 
								value="1" ${applyDTO.applyIfwap==0?'disabled':''} checked="checked" ${applyDTO.applyIfwap==1?'checked':''}/>wap
						</li>
						<li id="applyUrlLi">
							<label>
								URL访问地址：
							</label>
							<input type="text" name="applyUrl" id="applyUrl" class="inputBg" style="width:176px;" />
						</li>
						<!-- <li>
							<label>
								菜单样式：
							</label>
							<input type="text" name="menuCls" id="menuCls" class="inputBg" style="width:176px;" />
						</li> -->
						<li>
							<label>
								是否启用：
							</label>
							<input type="radio" name="isUse" id="isUse1" value="1" checked="checked"/>是
							<input type="radio" name="isUse" id="isUse0" value="0"/>否
						</li>
						<li>
							<label>
								绑定菜单：
							</label>
							<select id="menuId" name="menuId" class="easyui-combotree" style="width:200px;"   
	        					data-options="url:'manager/querySysMenuAll',onClick: function(node){
									setMenu(node.id);}">
							</select>
						</li>
						<li class="remark">
							<label>
								备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：
							</label>
							<textarea name="applyDesc" id="applyDesc" style="width:60%"></textarea>
						</li>
						<li>
							<label></label>
							<input type="button" onclick="saveApply();" class="btn" value="保存" />
							<input type="reset" class="btn" value="重置" />
						</li>
					</ul>
				</div>
			</form>
		</div>
<script type="text/javascript">
//保存应用
function saveApply(){
	var applyName = document.getElementById("applyName").value;
	if(applyName==""){
		alert("请输入应用名称");
		return false;
	}else if(applyName.length>25){
		alert("应用名称长度不能大于25个字");
		return false;
	}
	var applyCode = document.getElementById("applyCode").value;
	if(applyCode==""){
		alert("请输入应用代码");
		return false;
	}else if(isExistZh(applyCode)){
		alert("应用代码中不能存在中文");
		return false;
	}else if(applyCode.length>20){
		alert("应用代码长度不能大于20个字");
		return false;
	}
	var applyNo = document.getElementById("applyNo").value;
	if(applyNo==""){
		alert("请输入排序号");
		return false;
	}else if(!isNumber(applyNo)){
		alert("排序号输入不为数字");
		return false;
	}
	var applyUrl = document.getElementById("applyUrl").value;
	if(isExistZh(applyUrl)){
		alert("链接地址中不能存在中文");
		return false;
	}else if(applyUrl.length>80){
		alert("链接地址长度不能大于80个字");
		return false;
	}
	var applyDesc = document.getElementById("applyDesc").value;
	if(applyDesc.length>100){
		alert("备注长度不能大于80个字");
		return false;
	}
	document.getElementById("menuTp0").disabled="";
	document.getElementById("menuTp1").disabled="";
	document.getElementById("menuLeaf1").disabled="";
	document.getElementById("menuLeaf0").disabled="";
	document.getElementById("applyFrm").submit();
}

//设置菜单
function setMenu(id){
	$("#menuId").val(id);
}

$(function(){
	//菜单类型选择，应用类型、url显示或隐藏
	$('input:radio[name="menuTp"]').change( function(){
		var menuTp = $(this).val();
		if (menuTp=='0'){
			$("#applyIfwapLi").hide();
			$("#applyUrlLi").hide();
		} else {
			$("#applyIfwapLi").show();
			$("#applyUrlLi").show();
		}
	})
	//选择应用类型，显示或隐藏url
	$('input:radio[name="applyIfwap"]').change( function(){
		var applyIfwap = $(this).val();
		if (applyIfwap=='0'){
			$("#applyUrlLi").hide();
		} else {
			$("#applyUrlLi").show();
		}
	})
})
</script>
	</body>
</html>
