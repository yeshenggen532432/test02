<%@ page language="java" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
		<title>添加菜单</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body onload="showMsg('${showMsg}');">
		<div id="wrapper" class="clearfix">
			<form action="manager/addSysMenu" method="post" id="menuFrm">
				<input type="hidden" name="pId" value="${menu.PId}"/>
				<div class="addMenu">
					<ul>
						<li>
							<label>
								菜单名称：
							</label>
							<input type="text" name="menuNm" id="menuNm" class="inputBg" style="width:176px;" />
						</li>
                   <li>
                           <label>
                                                       父级菜单：
                           </label>
                           <span id="parentMenuSpan">
                              ${parentMenuName}
                           </span>
                           <span id="parentMenuSpanSelect">
                           </span>
                           <input type="button" onclick="clickChangeMenuButton(this);" value="修改"/>
                        </li>
						<li>
							<label>
								菜单代码：
							</label>
							<input type="text" name="menuCd" id="menuCd" class="inputBg" style="width:176px;" />
						</li>
						<li>
							<label>
								排&nbsp;&nbsp;序&nbsp;&nbsp;号：
							</label>
							<input type="text" name="menuSeq" id="menuSeq" class="inputBg" style="width:176px;" />
						</li>
						<li>
							<label>
								是否有子菜单：
							</label>
							<input type="radio" name="menuLeaf" id="menuLeaf1" 
								value="1" ${menu.menuTp==1?'disabled':''} ${menu.menuLeaf==1?'checked':''}/>是
							<input type="radio" name="menuLeaf" id="menuLeaf0" 
								value="0" ${menu.menuTp==1?'disabled':''} checked="checked" ${menu.menuLeaf==0?'checked':''}/>否
							&nbsp;&nbsp;<span style="color: gray">*最后一级选择否</span>
						</li>
						<li>
							<label>
								链接地址：
							</label>
							<input type="text" name="menuUrl" id="menuUrl" class="inputBg" style="width:176px;" />
						</li>
						<li>
							<label>
								菜单样式：
							</label>
							<input type="text" name="menuCls" id="menuCls" class="inputBg" style="width:176px;" />
						</li>
						<li>
							<label>
								菜单类型：
							</label>
							<input type="radio" name="menuTp" id="menuTp0" value="0" ${menu.menuTp==0?'checked':''}/>功能菜单
							<input type="radio" name="menuTp" id="menuTp1" value="1" checked="checked" ${menu.menuTp==1?'checked':''}/>功能按钮
							&nbsp;&nbsp;<span style="color: gray">*最后一级选择功能按钮</span>
						</li>
						<li>
							<label>
								是否启用：
							</label>
							<input type="radio" name="isUse" id="isUse1" value="1" checked="checked"/>是
							<input type="radio" name="isUse" id="isUse0" value="0"/>否
						</li>
						<li class="remark">
							<label>
								备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：
							</label>
							<textarea name="menuRemo" id="menuRemo" style="width:60%"></textarea>
						</li>
						<li>
							<label></label>
							<input type="button" onclick="saveMenu();" class="btn" value="保存" />
							<input type="reset" class="btn" value="重置" />
                           <input type="button" class="btn" onclick="history.back();" value="返回" />
						</li>
					</ul>
				</div>
			</form>
		</div>
<script type="text/javascript">
//保存角色
function saveMenu(){
	var menuNm = document.getElementById("menuNm").value;
	if(menuNm==""){
		alert("请输入菜单名称");
		return false;
	}else if(menuNm.length>25){
		alert("菜单名称长度不能大于25个字");
		return false;
	}
	var menuCd = document.getElementById("menuCd").value;
	if(menuCd==""){
		alert("请输入菜单代码");
		return false;
	}else if(isExistZh(menuCd)){
		alert("菜单代码中不能存在中文");
		return false;
	}else if(menuCd.length>20){
		alert("菜单代码长度不能大于20个字");
		return false;
	}
	var menuSeq = document.getElementById("menuSeq").value;
	if(menuSeq==""){
		alert("请输入排序号");
		return false;
	}else if(!isNumber(menuSeq)){
		alert("排序号输入不为数字");
		return false;
	}
	var menuUrl = document.getElementById("menuUrl").value;
	if(isExistZh(menuUrl)){
		alert("链接地址中不能存在中文");
		return false;
	}else if(menuUrl.length>80){
		alert("链接地址长度不能大于80个字");
		return false;
	}
	var menuRemo = document.getElementById("menuRemo").value;
	if(menuRemo.length>100){
		alert("备注长度不能大于80个字");
		return false;
	}
	var menuCls = document.getElementById("menuCls").value;
	if(isExistZh(menuCls)){
		alert("菜单样式中不能存在中文");
		return false;
	}else if(menuCls.length>20){
		alert("菜单样式不能大于20个字");
		return false;
	}
	document.getElementById("menuTp0").disabled="";
	document.getElementById("menuTp1").disabled="";
	document.getElementById("menuLeaf1").disabled="";
	document.getElementById("menuLeaf0").disabled="";
	document.getElementById("menuFrm").submit();
}


//父级菜单-点击事件
function clickChangeMenuButton(th){
	if($("#parentMenuSpan").is(':hidden')){
		$("#parentMenuSpan").show();
		$("#parentMenuSpanSelect").hide();
		$("#pId").val('${menu.PId}');
		$(th).val('修改');
	}else{
		$("#parentMenuSpan").hide();
		$("#parentMenuSpanSelect").show();
		$(th).val('取消修改');
		if($("#parentMenuSpanSelect select").length==0)
		changeParentMenu();
		return;
	}
}
//获取下拉菜单
function changeParentMenu(parentId){	
	$.post("${base}/manager/querySysMenuChild",{parentId:parentId},function(data){
		var str='';
		$(data).each(function(ind,da){
			str+="<option value='"+da.treeId+"'>"+da.treeNm+"</option>";
		});		
		if(str){
			str="<option value=''>请选择</option>"+str;
			str="<select parentId="+parentId+" onchange='menuChange(this)'>"+str+"</select>";
			$("#parentMenuSpanSelect").append(str);
		}
	})
}

//下拉菜单改变时修改父ID
function menuChange(th){
	$(th).nextAll("select").remove();
	var value=th.value;
	if(!value)value=$(th).attr("parentId");
	$("#pId").val(th.value);
	if($("#parentMenuSpanSelect select").length<2)
	changeParentMenu(th.value);
}
</script>
	</body>
</html>
