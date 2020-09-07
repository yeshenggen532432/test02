<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<meta content="email=no,telephone=no" name="format-detection"/>
	<title>任务执行情况统计</title>
	<link href="<%=basePath %>/resource/css/task.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<div class="content">
		<select name="year" style="width: 80px" id="year">
		   <option value="2015">2015</option>
	       <option value="2016">2016</option>
		   <option value="2017">2017</option>
		   <option value="2018">2018</option>
		   <option value="2019">2019</option>
		   <option value="2020">2020</option>
		   <option value="2021">2021</option>
		</select>
		
		<select name="date" id="date" onchange="taskzhixing(this)">
		   <option value="01">1月</option>
	       <option value="02">2月</option>
		   <option value="03">3月</option>
		   <option value="04">4月</option>
		   <option value="05">5月</option>
		   <option value="06">6月</option>
		   <option value="07">7月</option>
		   <option value="08">8月</option>
		   <option value="09">9月</option>
		   <option value="10">10月</option>
		   <option value="11">11月</option>
		   <option value="12">12月</option>     
		</select>
		
		<%-- 
		<input type="button" value="1月" onclick="javascript:taskzhixing('01')"/>
		<input type="button" value="2月" onclick="javascript:taskzhixing('02')"/>
		<input type="button" value="3月" onclick="javascript:taskzhixing('03')"/>
		<input type="button" value="4月" onclick="javascript:taskzhixing('04')"/>
		<input type="button" value="5月" onclick="javascript:taskzhixing('05')"/>
		<input type="button" value="6月" onclick="javascript:taskzhixing('06')"/>
		<input type="button" value="7月" onclick="javascript:taskzhixing('07')"/>
		<input type="button" value="8月" onclick="javascript:taskzhixing('08')"/>
		<input type="button" value="9月" onclick="javascript:taskzhixing('09')"/>
		<input type="button" value="10月" onclick="javascript:taskzhixing('10')"/>
		<input type="button" value="11月" onclick="javascript:taskzhixing('11')"/>
		<input type="button" value="12月" onclick="javascript:taskzhixing('12')"/>
		--%>
		当前月份:<span style="color: red">${month}</span>
		
		<table id="datagrid" width="100%">
			<thead>
				<tr>
					<th>
						部门
					</th>
					<th style="display:none">
						公司
					</th>
					<th>
						人员
					</th>
					<%--
					<th>
						月份
					</th>
					 --%>
					<th>
						任务总数
					</th>
					<th >
						超期数
					</th>
					<th >
						超期率(%)
					</th>
				</tr>
				<c:forEach items="${list}" var="item" varStatus="s">
			    <tr <c:if test="${s.index%2 eq 0}"> class="ys"</c:if> >
			      <td>${item["branch_name"]}<br></td>
			      <td style="display:none">${item["member_company"]}<br></td>
			      <td>${item["member_nm"]}</td>
			      <%--<td>${item["month"]}</td> --%>
			      <td>${item["total"]}</td>
			      <td>${item["cq_count"]}</td>
			      <td>${item["cq_rate"]}</td>
			    </tr>
			    </c:forEach>
			</thead>
		</table>
		</div>
	</body>
</html>
<script>
  function	taskzhixing(obj){
		var year = document.getElementById("year").value;
		var month = year+obj.value;
		var url = "<%=basePath %>/manager/taskzhixingpages?year="+year+"&date="+obj.value+"&month="+month;
		document.location.href = url;
	}
	document.getElementById("year").value='${year}';
	document.getElementById("date").value='${date}';
</script>