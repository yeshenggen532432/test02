<%@ page language="java" pageEncoding="UTF-8"%>
<div id="treeDiv2_Com" class="easyui-window" style="width:400px;height:580px;" 
	minimizable="false" modal="true" collapsible="false" closed="true">
	<form name="cormenufrm" id="cormenufrm" method="post">
		<input type="hidden" name="deptId" id="dId"/>
		<input type="hidden" name="menuapplytp" id="menuapplytp"/>
		<div id="divHYGL2com" class="menuTree" data-options="region:'north'" style="width: 380px;height:510px;overflow: auto;padding-left: 5px;">
			<div id="divHYGL_tree2com" class="dtree"></div>
		</div>
		<div style="text-align: center;" data-options="region:'south',border:false">
			<a class="easyui-linkbutton" href="javascript:savecorpri();" id="saveMsg">保存</a>
			&nbsp;&nbsp;
			<a class="easyui-linkbutton" href="javascript:closetreewin2();">关闭</a>
		</div>
	</form>
</div>
<script type="text/javascript">
	function tocompanymenuapply(idKey, tp){
		$("#divHYGL_tree2com").empty();
		$("#dId").val(idKey);
		$("#menuapplytp").val(tp);
		var url,tl;
		if (tp=='1') {
			url="manager/companyMenutree";
			tl = "分配菜单";
			$("#saveMsg").find(".l-btn-text").text("保存");
		} else {
			url="manager/companyApplytree";
			tl = "分配应用";
			$("#saveMsg").find(".l-btn-text").text("保存并通知移动端用户");
		}
		$.ajax({
			type:"post",
			url:url,
			data:"deptId="+idKey,
			success:function(data){
				if(data){
					loadTree_menu("divHYGL2com","divHYGL_tree2com",tl,data);
				}
			}
		});
		$("#treeDiv2_Com").window('open');
	}
	
	//显示菜单树
	function loadTree_menu_com(treeName,objDiv,title,data){
		var treeName=treeName+"_d";
		var objTree =treeName;
		objTree = new dTree(treeName);
		objTree.add(0,-1,title);
		if(data){
			for(var i=0;i<data.length;i++){
				var nodeid  = data[i].idKey;
				var nodevl  = data[i].menuNm;
				var parid   = data[i].PId;
				var menuTp = data[i].menuTp;
   				var menuSeq = data[i].menuSeq;
   				var chosevalue;
			    if(menuSeq=="0"){
			    	chosevalue="<input type=\"checkbox\" name=\"menuid\" value=\""+nodeid+"\" id=\""+nodeid+"_"+parid+"_"+menuTp+"\" onclick=\"setCheckboxSelectedCom(this,'"+parid+"','"+menuTp+"')\"/>";
			    }else{
			    	chosevalue="<input type=\"checkbox\" name=\"menuid\" checked=\"checked\" value=\""+nodeid+"\" id=\""+nodeid+"_"+parid+"_"+menuTp+"\" onclick=\"setCheckboxSelectedCom(this,'"+parid+"','"+menuTp+"')\"/>";
			    }
				objTree.add(nodeid,parid,nodevl+chosevalue,"javascript:void();");	
			}
		    document.getElementById(objDiv).innerHTML=objTree;
		}
	}
	
	//设置复选框选中状态
	function setCheckboxSelectedCom(obj,parentId,menuTp){
		//如果是父级菜单只向上选
		if(parentId==0){
			//向下选
			setCheckedCom(obj,1);
		}else{
			setCheckedCom(obj,0);
			if(menuTp==0){
				//向下选
				setCheckedCom(obj,1);
			}
		}
	}
	//向上、向下选
	function setCheckedCom(obj,tp){
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
			var xzCount=getCheckedCountCom(pId);
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
						setCheckedCom(inputObjs[i],tp)
					}
				}
			}else if(tp==0){
				if(tempMenuId==pId){
					inputObjs[i].checked=obj.checked;
					if(pId!=0){
						setCheckedCom(inputObjs[i],tp);
					}
				}
			}
			
		}
	}
	//获取当前级别选中的个数
	function getCheckedCountCom(pId){
		//当前级别已选中的个数
		var xzCount=0;
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
			if(tempPId==pId){
				if(inputObjs[i].checked)
					xzCount++;
			}
		}
		return xzCount;
	}
	
	
	
	
	//保存菜单应用分配功能
	function savecorpri(){
		var url = "manager/saveCompanyMenuApply";
		$("#cormenufrm").form('submit',{
			url:url,
			success:function(data){
				showMsg(data);
				closetreewin2();
			}
		});
	}
	//关闭窗口
	function closetreewin2(){
		$("#treeDiv2_Com").window('close');
	}
</script>