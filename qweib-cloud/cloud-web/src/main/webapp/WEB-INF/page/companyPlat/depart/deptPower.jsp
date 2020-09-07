<%@ page language="java" pageEncoding="UTF-8"%>
<div id="treeDiv_power" class="easyui-window" style="width:400px;height:580px;" 
	minimizable="false" modal="true" collapsible="false" closed="true">
	<form name="powerfrm" id="powerfrm" method="post">
		<input type="hidden" name="deptId" id="deptpowerId"/>
		<input type="hidden" name="powertp" id="powertp"/>
		<div id="divHYGL_power" class="menuTree" data-options="region:'north'" style="width: 380px;height:510px;overflow: auto;padding-left: 5px;">
			<div id="divHYGL_tree_power" class="dtree"></div>
		</div>
		<div style="text-align: center;" data-options="region:'south',border:false">
			<a class="easyui-linkbutton" href="javascript:savepower();">保存</a>
			&nbsp;&nbsp;
			<a class="easyui-linkbutton" href="javascript:closetreewin_power();">关闭</a>
		</div>
	</form>
</div>
<script type="text/javascript">
	function todeptpower(deptId, tp){
		$("#divHYGL_tree_power").empty();
		$("#deptpowerId").val(deptId);
		$("#powertp").val(tp);
		var url,tl;
		if (tp=='1') {
			tl = "分配可见人员";
		} else {
			tl = "分配不可见人员";
		}
		$.ajax({
			type:"post",
			url:"manager/deptpowertree",
			data:"deptId="+deptId+"&tp="+tp,
			success:function(data){
				if(data){
					loadTree_usr("divHYGL_power","divHYGL_tree_power",tl,data);
				}
			}
		});
		$("#treeDiv_power").window('open');
	}
	//保存菜单应用分配功能
	function savepower(){
		var url = "manager/saveDeptPower";
		$("#powerfrm").form('submit',{
			url:url,
			success:function(data){
				showMsg(data);
				closetreewin_power();
			}
		});
	}
	//关闭窗口
	function closetreewin_power(){
		$("#treeDiv_power").window('close');
	}
</script>