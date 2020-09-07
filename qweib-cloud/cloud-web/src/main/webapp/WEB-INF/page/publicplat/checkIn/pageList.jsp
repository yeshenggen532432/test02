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
			url="manager/checkInPage?dataTp=${dataTp }" title="考勤列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="dateweek" width="50" align="center" hidden="true">
						dateweek
					</th>
					<th field="branchNm" width="120" align="center">
						部门
					</th>
					<th field="memberNm" width="120" align="center">
						姓名
					</th>
					<th field="cdate" width="120" align="center" formatter="dateMatter">
						工作日期
					</th>
					<th field="location" width="150" align="center">
						地址
					</th>
					<th field="stime" width="100" align="center" >
						上班时间
					</th>
					<th field="etime" width="100" align="center" >
						下班时间
					</th>
					<th field="cdzt" width="100" align="center" >
						迟到/早退情况
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     姓名: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
		     部门：<select name="branchId" id="branchId">
		            <option value="">全部</option>
		            <c:forEach items="${listb}" var="list">
		               <option value="${list.branchId}">${list.branchName}</option>
		            </c:forEach>
		         </select>
			&nbsp;&nbsp;工作日期: 
			<input type="text" name="atime" id="atime" value=""
				class="inputBg" style="width: 82px;"
				onClick="WdatePicker({'dateFmt':'yyyy-MM-dd'});" class="shortTxt" onkeydown="toQuery(event);"/>
			-
			<input type="text" name="btime" id="btime" value=""
				class="inputBg" style="width: 83px;"
				onClick="WdatePicker({'dateFmt':'yyyy-MM-dd'});" class="shortTxt" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querycheckIn();">查询</a>
		    <a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toLoadExcel();">导出</a>
		</div>
		<div>
		  	<form action="manager/loadForExcel" name="loadfrm" id="loadfrm" method="post">
		  		<input type="text" name="memNm" id="memNm"/>
				<input type="text" name="time1" id="time1"/>
				<input type="text" name="time2" id="time2"/>
				<input type="text" name="branchId2" id="branchId2"/>
		  	</form>
	  	</div>
		<script type="text/javascript">
		    function dateMatter(val,row){
		    	var dtime=val;
		    	var dateweek = row.dateweek;
				if(dateweek==1){
					dtime+=' 星期日';
				}else if(dateweek==2){
					dtime+=' 星期一';
				}else if(dateweek==3){
					dtime+=' 星期二';
				}else if(dateweek==4){
					dtime+=' 星期三';
				}else if(dateweek==5){
					dtime+=' 星期四';
				}else if(dateweek==6){
					dtime+=' 星期五';
				}else if(dateweek==7){
					dtime+=' 星期六';
				}
				return dtime;
			}
		    //查询签到
			function querycheckIn(){
				$("#datagrid").datagrid('load',{
					url:"manager/checkInPage",
					memberNm:$("#memberNm").val(),
					branchId:$("#branchId").val(),
					atime:$("#atime").val(),
					btime:$("#btime").val(),
					onLoadSuccess: function (data) {
						$('#memNm').val($('#memberNm').val());
						$('#branchId2').val($('#branchId').val());
						$('#time1').val($('#atime').val());
						$('#time2').val($('#btime').val());
					}
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querycheckIn();
				}
			}
		    //导出成excel
		    function toLoadExcel(){
					$('#loadfrm').form('submit',{
						success:function(data){
							alert(data);
						}
					});
			}
		</script>
	</body>
</html>
