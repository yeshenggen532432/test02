<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="<%=request.getContextPath()%>/resource/WdatePicker.js" defer="defer"></script>
		<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	    </style>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/auditPage?dataTp=${dataTp }" title="审核列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
				    <th field="auditNo" width="150" align="center" >
						审批编号
					</th>
					<th field="auditTp" width="120" align="center" formatter="formatterTp">
						类型
					</th>
					<th field="branchName" width="120" align="center" formatter="formatterbm">
						部门
					</th>
					<th field="memberNm" width="120" align="center">
						申请人
					</th>
					<th field="addTime" width="120" align="center">
						申请时间
					</th>
					<th field="checkTime" width="120" align="center">
						审批时间
					</th>
					<th field="tp" width="120" align="center">
						内容
					</th>
					<th field="dsc" width="250" align="center" formatter="formatterDsc" >
						详情
					</th>
					<th field="opera" width="100" align="center" formatter="formatterOpear">
						操作
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			申请时间: 
			<input type="text" name="atime" id="atime" value="${atime}"
				class="inputBg" style="width: 82px;"
				onClick="WdatePicker({'dateFmt':'yyyy-MM-dd'});" class="shortTxt" onkeydown="toQuery(event);"/>
			-
			<input type="text" name="btime" id="btime" value="${btime}"
				class="inputBg" style="width: 83px;"
				onClick="WdatePicker({'dateFmt':'yyyy-MM-dd'});" class="shortTxt" onkeydown="toQuery(event);"/>
			类型: <select name="auditTp" id="auditTp">
					<option value="">全部</option>
					<option value="1">请假</option>
					<option value="2">报销</option>
					<option value="3">出差</option>
					<option value="4">物品领用</option>
					<option value="5">通用审批</option>
				</select>
			申请人: <input name="memberNm" id="memberNm" style="width:60px;height: 20px;" onkeydown="toQuery(event);"/>	
			内容: <input name="tp" id="tp" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			详情: <input name="dsc" id="dsc" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search"  href="javascript:queryAudit();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toLoadExcel();">导出</a>
		</div>
		<!-- 导出审核记录 -->
		<div>
		  	<form action="manager/loadAuditExcel" name="loadfrm" id="loadfrm" method="post">
		  		<input type="text" name="time1" id="time1"/>
				<input type="text" name="time2" id="time2"/>
				<input type="text" name="etp" id="etp"/>
				<input type="text" name="edsc" id="edsc"/>
				<input type="text" name="tps" id="tps"/>
				<input type="text" name="memberNmS" id="memberNmS"/>
				<input type="hidden" name="dataTp" value="${dataTp }"/>
		  	</form>
	  	</div>
		<script type="text/javascript">
			//描述
			function formatterDsc(val,row){
				if(val.length>20){
					return val.substr(1,20)+"...";
				}else{
					return val;
				}
				//return val;
			}
			//类型
			function formatterTp(val){
				if(val=='1'){
					return "请假";
				}else if(val=='2'){
					return "报销";
				}else if(val=='3'){
					return "出差";
				}else if(val=='4'){
					return "物品领用";
				}else if(val=='5'){
					return "通用审批";
				}
			}
			//部门
			function formatterbm(val){
				if(val==''){
					return "公司本级";
				}else {
					return val;
				}
			}
			//操作
			function formatterOpear(val,row){
				return "<a href='javascript:todetail(\""+row.auditNo+"\");' title='审批详情' style='text-decoration:none;'>详情</>";
			}
		    //查询
			function queryAudit(){
				$("#datagrid").datagrid('load',{
					url:"manager/auditPage",
					atime:$("#atime").val(),
					btime:$("#btime").val(),
					auditTp:$("#auditTp").val(),
					dsc:$("#dsc").val(),
					tp:$("#tp").val(),
					memberNm:$("#memberNm").val(),
					jz:"1",
					onLoadSuccess: function (data) {
						$('#time1').val($('#atime').val());
						$('#time2').val($('#btime').val());
						$('#etp').val($('#auditTp').val());
						$('#edsc').val($('#dsc').val());
						$('#tps').val($('#tp').val());
						$('#memberNmS').val($('#memberNm').val());
					}
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryAudit();
				}
			}
			//显示上传框
			function toUpLoad(){
				$("#upDiv").window({title:'上传',modal:true});
				$("#upDiv").window('open');
			}
			//导出成excel
		    function toLoadExcel(){
					$('#loadfrm').form('submit',{
						success:function(data){
							alert(data);
						}
					});
			}
			//到详情页
			function todetail(auditNo){
				window.parent.add(auditNo,"${base}/manager/toAuditDetail?auditNo="+auditNo);
			}
			//删除
			function toDel(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(confirm("是否要删除选中的审批?")){
						$.ajax({
							url:"manager/deleteAuditByNo",
							data:"auditNo="+row.auditNo,
							type:"post",
							success:function(json){
								if(json=="1"){
								    alert("删除成功");
									queryAudit();
								}else{
								    alert("删除失败");
								    return;
								}
							}
						});
					}
				}
			}
		</script>
	</body>
</html>
