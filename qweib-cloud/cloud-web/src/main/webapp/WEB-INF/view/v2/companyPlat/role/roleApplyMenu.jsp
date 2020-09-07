<%@ page language="java" pageEncoding="UTF-8"%>
<div id="treeDiv_role" class="easyui-window" style="width:420px;height:580px;" 
	minimizable="false" modal="true" collapsible="false" closed="true">
	<form name="menufrm_role" id="menufrm_role" method="post">
		<input type="hidden" name="companyroleId" id="companyroleId"/>
		<input type="hidden" name="menuapplytype" id="menuapplytype"/>
		<div id="divHYGL_role" class="menuTree" data-options="region:'north'" style="width: 400px;height:510px;overflow: auto;padding-left: 5px;">
			<div id="divHYGL_tree_role" class="dtree"></div>
		</div>
		<div id="operate_panel" style="text-align: center;" data-options="region:'south',border:false">
			<a class="easyui-linkbutton" href="javascript:savecorpri_role();" id="saveMessage">保存</a>
			&nbsp;&nbsp;
			<a class="easyui-linkbutton" href="javascript:closetreewin_role();">关闭</a>
		</div>
	</form>
</div>
<script type="text/javascript">
	function torolemenuapply(idKey, tp, creatorAndAdmin){
		$("#divHYGL_tree_role").empty();
		$("#companyroleId").val(idKey);
		$("#menuapplytype").val(tp);
		var tl;
		if (creatorAndAdmin) {
			$("#operate_panel").hide();
		} else {
			$("#operate_panel").show();
		}
		if (tp=='1') {
			tl = "分配菜单";
			$("#saveMessage").find(".l-btn-text").text("保存");
		} else {
			tl = "分配应用";
			$("#saveMessage").find(".l-btn-text").text("保存并通知移动端用户");
		}
		$.ajax({
			type:"post",
			url:"manager/companyRoletree",
			data:"roleId="+idKey+"&tp="+tp,
			success:function(data){
				if(data){
					loadTree_menu_role("divHYGL_role","divHYGL_tree_role",tl,data,idKey, creatorAndAdmin);
				}
			}
		});
		$("#treeDiv_role").window('open');
	}
	//显示菜单树
	function loadTree_menu_role(treeName,objDiv,title,data,roleId, creatorAndAdmin){
		var treeName=treeName+"_d";
		var objTree =treeName;
		objTree = new dTree(treeName);
		objTree.add(0,-1,title);
		if(data){
			for(var i=0;i<data.length;i++){
				var nodeid  = data[i].id;
				var nodevl  = data[i].applyName;
				var parid   = data[i].PId;
				var menuTp = data[i].menuTp;
   				var menuSeq = data[i].applyNo;
   				var tp = data[i].tp;
   				var bindId = data[i].menuId;
   				var dataTp = data[i].menuLeaf;
   				var sgtjz = data[i].sgtjz;
   				var mids = data[i].mids;
   				var chosevalue = "<input type=\"checkbox\" name=\"roleMenu["+i+"].ifChecked\" id=\""+nodeid+"_"+parid+"_"+menuTp+"\"";
   				if (menuSeq == 0) {
   					chosevalue += " value=\"false\"";
				} else {
   					chosevalue += " checked=\"checked\" value=\"true\"";
				}

   				if (creatorAndAdmin) {
   					chosevalue += " disabled/>";
				} else {
			    	chosevalue += " onclick=\"setCheckboxSelected(this,'"+parid+"','"+menuTp+"')\"/>";
			    }
			    var menuidhtml = "<input name='roleMenu["+i+"].menuId' value='"+nodeid+"' type='hidden'/>";
			    var tphtml = "<input name='roleMenu["+i+"].tp' value='"+tp+"' type='hidden'/>";
			    var bindidhtml = "<input name='roleMenu["+i+"].bindId' value='"+bindId+"' type='hidden'/>";
			    var midshtml = "<input name='roleMenu["+i+"].mids' value='"+mids+"' type='hidden'/>";
			    var dataTpHtml="";
			    if (menuTp=='1') {//功能按钮即最后一级
				    if (dataTp=='1') {
				    	dataTpHtml = "&nbsp;&nbsp;<input value='1' name='roleMenu["+i+"].dataTp' type='radio' checked />全部<input value='2' name='roleMenu["+i+"].dataTp' type='radio'/>部门及子部门<input value='3' name='roleMenu["+i+"].dataTp' type='radio'/>个人<input value='4' name='roleMenu["+i+"].dataTp' type='radio' onclick=\"toroleusrs2("+nodeid+","+roleId+",'"+mids+"');\"/>自定义"
				    } else if(dataTp=='2'){
				    	dataTpHtml = "&nbsp;&nbsp;<input value='1' name='roleMenu["+i+"].dataTp' type='radio'/>全部<input value='2' name='roleMenu["+i+"].dataTp' type='radio' checked/>部门及子部门<input value='3' name='roleMenu["+i+"].dataTp' type='radio'/>个人<input value='4' name='roleMenu["+i+"].dataTp' type='radio' onclick=\"toroleusrs2("+nodeid+","+roleId+",'"+mids+"');\" />自定义"
				    } else if (dataTp=='3') {
				    	dataTpHtml = "&nbsp;&nbsp;<input value='1' name='roleMenu["+i+"].dataTp' type='radio'/>全部<input value='2' name='roleMenu["+i+"].dataTp' type='radio'/>部门及子部门<input value='3' name='roleMenu["+i+"].dataTp' type='radio' checked/>个人<input value='4' name='roleMenu["+i+"].dataTp' type='radio' onclick=\"toroleusrs2("+nodeid+","+roleId+",'"+mids+"');\"/>自定义"
				    } else if (dataTp=='4') {
				    	dataTpHtml = "&nbsp;&nbsp;<input value='1' name='roleMenu["+i+"].dataTp' type='radio'/>全部<input value='2' name='roleMenu["+i+"].dataTp' type='radio'/>部门及子部门<input value='3' name='roleMenu["+i+"].dataTp' type='radio'/>个人<input value='4' name='roleMenu["+i+"].dataTp' type='radio' checked onclick=\"toroleusrs2("+nodeid+","+roleId+",'"+mids+"');\"/>自定义"
				    }
			    }
			    var dataTpHtml2="";
			    if(nodevl=='报表统计'){
			        dataTpHtml2+= "</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			        dataTpHtml2+= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			        dataTpHtml2+= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				    if(sgtjz.indexOf("1") >=0 ){
					    dataTpHtml2+= "<input name='roleMenu["+i+"].sgtjz'  type='checkbox' value='1' checked/>业务执行";
					}else{
					    dataTpHtml2+= "<input name='roleMenu["+i+"].sgtjz'  type='checkbox' value='1'/>业务执行";
					}
					if(sgtjz.indexOf("2") >=0 ){
					    dataTpHtml2+= "<input name='roleMenu["+i+"].sgtjz'  type='checkbox' value='2' checked/>客户拜访";
					}else{
					    dataTpHtml2+= "<input name='roleMenu["+i+"].sgtjz'  type='checkbox' value='2'/>客户拜访";
					}
					if(sgtjz.indexOf("3") >=0 ){
					     dataTpHtml2+= "<input name='roleMenu["+i+"].sgtjz' type='checkbox' value='3' checked/>产品订单";
					}else{
					    dataTpHtml2+= "<input name='roleMenu["+i+"].sgtjz'  type='checkbox' value='3'/>产品订单";
					}
					if(sgtjz.indexOf("4") >=0 ){
					    dataTpHtml2+= "<input name='roleMenu["+i+"].sgtjz'  type='checkbox' value='4' checked/>销售订单";
					}else{
					    dataTpHtml2+= "<input name='roleMenu["+i+"].sgtjz'  type='checkbox' value='4'/>销售订单";
					}
				    
			    }
			    objTree.add(nodeid,parid,nodevl+chosevalue+menuidhtml+tphtml+bindidhtml+midshtml+dataTpHtml+dataTpHtml2,"javascript:void();");	
			}
		    eval(treeName +"= objTree");
		    document.getElementById(objDiv).innerHTML=objTree;
		}
	}
	function bindClick(){
		var ipts = $("input[name$='.ifChecked']");
            ipts.each(function() {
                var that = $(this);
                
                if(that.is(':checked')){
                    that.val('true');
                }else{
                    that.val('false');
                }
                console.log($(this).val());
                //that.bind("click",function() {
                //});
            });
	}
	//设置复选框选中状态
	/*function setCheckboxSelected(obj,parentId,menuTp){
		//如果是父级菜单只向上选
		if(parentId==0){
			//向下选
			setChecked(obj,1);
		}else{
			if(menuTp==0){
				//向下选
				setChecked(obj,1);
			} else {
				setChecked(obj,0);
			} 
			//setChecked(obj,0);
			//if(menuTp==0){
				//向下选
			//	setChecked(obj,1);
			//}
		}
	}*/
	//向上、向下选
	/*function setChecked(obj,tp){
		var objId_1 = obj.id;
		var index_1 = objId_1.indexOf("_");
		//菜单id
		var menuId = objId_1.substring(0,index_1);
		var objId_2 = objId_1.substring(index_1+1);
		var index_2 = objId_2.indexOf("_");
		//父id
		var pId = objId_2.substring(0,index_2);
		//菜单类型
		var menuTp = objId_2.substring(index_2+1);
		if(tp==1){
			if(menuTp==1){return;}
		}else if(tp==0){
			var xzCount=getCheckedCount(pId);
			var dqChecked = obj.checked;
			if(dqChecked){
				if(xzCount!=1){
					return;
				}
			}else{
				if(xzCount!=0){
					return;
				}
			}
			if(pId==0){return;}
		}
		var baseTreeDiv = document.getElementById("baseTreeDiv");
		var inputObjs = baseTreeDiv.getElementsByTagName("input");
		for(var i=0;i<inputObjs.length;i++){
			var tempId_1 = inputObjs[i].id;
			var tempIndex_1 = tempId_1.indexOf("_");
			//菜单id
			var tempMenuId = tempId_1.substring(0,tempIndex_1);
			var tempId_2 = tempId_1.substring(tempIndex_1+1);
			var tempIndex_2 = tempId_2.indexOf("_");
			//父id
			var tempPId = tempId_2.substring(0,tempIndex_2);
			//菜单类型
			var tempMenuTp = tempId_2.substring(tempIndex_2+1);
			if(tp==1){
				if(tempPId==menuId){
					inputObjs[i].checked=obj.checked;
					if(tempMenuTp!=1){
						setChecked(inputObjs[i],tp)
					}
				}
			}else if(tp==0){
				if(tempMenuId==pId){
					inputObjs[i].checked=obj.checked;
					if(pId!=0){
						setChecked(inputObjs[i],tp);
					}
				}
			}
			
		}
	}*/
	//保存菜单应用分配功能
	function savecorpri_role(){
		bindClick();//绑定点击事件
		var url = "manager/saveRoleMenuApply";
		$("#menufrm_role").form('submit',{
			url:url,
			success:function(data){
				showMsg(data);
				closetreewin_role();
			}
		});
	}
	//关闭窗口
	function closetreewin_role(){
		$("#treeDiv_role").window('close');
	}
	//分配用户
	function toroleusrs2(cdid,roleid,mids){
	    window.parent.parent.toroleusr2(roleid,cdid,mids);
	}
</script>