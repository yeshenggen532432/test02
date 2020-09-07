<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html style="font-size: 50px;">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
		<title>借入往来新增</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/default/easyui.css">
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/icon.css">
		<script src="<%=basePath %>/resource/stkstyle/js/Map.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
		
		<style type="text/css">
			.menu_btn .item p{
				font-size: 12px;
			}
			.menu_btn .item img:last-of-type{
				display: none;
			}
			.menu_btn .item a{
				color: #00a6fb;
			}
			.menu_btn .item.on img:first-child{
				display: none;
			}
			.menu_btn .item.on img:last-of-type{
				display: inline;
			}
			.menu_btn .item.on a{
				color: #333;
			}
		</style>
		<form action="<%=basePath %>/manager/finInitQtJrMain/save" name="savefrm" id="savefrm" method="post">
		<div class="center">
			<div class="pcl_lib_out">
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<div class="item" id="btnsave" >
							<a href="javascript:submitStk();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>暂存</p>
							</a>
						</div>
						</div>
						</div>
					</div>
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1">
						<table id="more_list">
							<thead>
								<tr>
									<td width="15%">
										<c:if test="${bizType eq 'CSHGYSJR'}">
											往来供应商
										</c:if>
										<c:if test="${bizType eq 'CSHKHJR'}">
											往来客户
										</c:if>
										<c:if test="${bizType eq 'CSHYGJR'}">
											员工名称
										</c:if>
									</td>
									<td  width="20%">初始化借入金额</td>
									<td  width="60px"><a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:add();">添加</a></td>
									<td></td>
								</tr>
							</thead>
							<tbody id="chooselist">

							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
        </form>
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:500px;"
			 minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>

	</body>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">

	var rowIndex=1000;
	function add(){
		var down = $("#more_list").find("tr").length ;
		down = down-1;
		var html="";
		$("#more_list tbody").append(
				'<tr>'+
					'<td >'+
					'<input type="hidden"   name="list['+down+'].proId"/>'+
					'<input type="hidden"   name="list['+down+'].ioMark" value="-1"/>'+
					'<input type="hidden"  name="list['+down+'].bizType" value="${bizType}"/>'+
					'<input type="hidden"  name="list['+down+'].proType" value="${proType}"/>'+
				'<input type="text" class="pcl_i2" readonly="readonly" style="width: 150px" name="list['+down+'].proName"/><input type="button" value="选择" onclick="selectMember(this)"/></td>'+
					'</td>'+
					'<td><input type="text" class="pcl_i2"  name="list['+down+'].amt"/></td>'+
					'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
					'<td></a></td>'+
				'</tr>'
			);
		rowIndex++;
		var len = $("#more_list").find("tr").length ;
		var row = $("#more_list tbody tr").eq(len-2);
	}
	var currRow = "";
	function selectMember(o){
		currRow = o.parentNode.parentNode;
		var url = "<%=basePath %>manager/selectmember";
		var title = "选择人员";
		if('${bizType}'=='CSHGYSJR'){
			url = "<%=basePath %>manager/toProviderDialog";
			title="选择供应商";
		}else if('${bizType}'=='CSHKHJR'){
			url = "<%=basePath %>manager/toDialogCustomer";
			title="选择客户";
		}
		document.getElementById("windowifrm").src=url;
		$("#choiceWindow").window({
			title:title
		});
		$("#choiceWindow").window('open');
	}
	function setMember(memberId,memberNm){
		if(memberId.indexOf(",")!=-1){
			alert("只能选择一个");
			return;
		}
		$(currRow).find("input[name$='proId']").val(memberId);
		$(currRow).find("input[name$='proName']").val(memberNm);
		$("#choiceWindow").window('close');
	}
	
	function deleteChoose(lineObj)
	{
		var status = $("#status").val();
		if(status > 0)return;
		if(confirm('确定删除？')){
			//alert(lineObj.innerHTML);
			$(lineObj).parents('tr').remove();
			resetTabIndex();
		}
	}
	function resetTabIndex(){
		var trList = $("#chooselist").children("tr");
		if(index<0){
			return;
		}
		for(var i=0;i<trList.length;i++){
			var tdArr = trList.eq(i);
			$(tdArr).find("input[name$='ioMark']").attr("name","list["+i+"].ioMark");
			 $(tdArr).find("input[name$='proId']").attr("name","list["+i+"].proId");
			$(tdArr).find("input[name$='bizType']").attr("name","list["+i+"].bizType");
			$(tdArr).find("input[name$='proType']").attr("name","list["+i+"].proType");
			$(tdArr).find("input[name$='proName']").attr("name","list["+i+"].proName");
			$(tdArr).find("input[name$='amt']").attr("name","list["+i+"].amt");
		}
	}
	
	function submitStk(){
			var trList = $("#chooselist").children("tr");
			if(trList.length==0){
				alert("请添加明细!");
				return false;
			}
			var m = new Map()
			for(var i=0;i<trList.length;i++){
				var tdArr = trList.eq(i);
				var proName=  $(tdArr).find("input[name$='proName']").val();
				var proId=  $(tdArr).find("input[name$='proId']").val();
				if(proName==""){
					alert("第"+(i+1)+"行请选择对象!");
					return;
				}
				var amt=  $(tdArr).find("input[name$='amt']").val();
				if(amt==""){
					alert("第"+(i+1)+"行请输入金额!");
					return;
				}
				proId = $(tdArr).find("input[name$='proId']").val();
				var key = proId;
				if(m.containsKey(key)){
					alert(proName+",该对象在重复！");
					return;
				}
				m.put(key,key);
			}
		if(!confirm('是否确定暂存？'))return;
		$("#savefrm").form('submit',{
			success:function(data){
				var json = eval("("+data+")");
				if(json.state){
	        		alert("暂存成功");
					var bizType='${bizType}';
					title='员工借入初始化录入';
					if(bizType=='CSHGYSJR'){
						title='供应商借入初始化录入';
					}else if(bizType=='CSHKHJR'){
						title='客户借入初始化录入';
					}
					parent.closeWin(title);
	        	}else{
	        		alert(json.msg);
	        	}
			}
		});
	}
	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>