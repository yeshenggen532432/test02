<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>快速领料商品</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body style="text-align: center;">
			<form name="savefrm" id="savefrm" action="<%=basePath%>/manager/stkPickup/addQuick" method="post">
			<input name="bizType" type="hidden" value="LLCK"/>
			<table   style="width: 350px;margin-top: 5px;margin-left: 5px;border:1px solid teal;">
			<tr style="height: 25px;border:1px solid teal;">
			<td style="text-align: center;border:1px solid teal;width: 40px">序号</td> 
			<td  style="text-align: center;border:1px solid teal;width:140px">产品名称</td> 
			<td style="text-align: center;border:1px solid teal;">计划生产数量</td>
			</tr>
			<c:forEach items="${mainList }" var="data" varStatus="s">
			<tr style="height: 25px;border:1px solid teal;">
			<td style="text-align: center;border:1px solid teal;">
			${s.index+1}
			</td> 
			<td style="text-align: left;border:1px solid teal;">
			<input name="subList[${s.index}].wareId" type="hidden" style="border: 0px solid #ddd;" value="${data.relaWareId}" />
			<input name="subList[${s.index}].wareNm" readonly="readonly" type="text" style="border:0px solid #ddd;" value="${data.relaWareNm}"/>
			</td> 
			<td style="text-align: center;border:1px solid teal;">
			<input name="subList[${s.index}].qty"  onclick="cellClick(this)"  onkeyup="CheckInFloat(this)" type="text" style="border: 0px solid #ddd;width: 100px"  value="0" />
			</td> 
			</tr>
			</c:forEach>
			<tr style="height: 30px;"><td colspan="2" style="text-align: center;border:1px solid teal;">
			</td>
			<td align="left">
			 <a class="easyui-linkbutton" iconCls="icon-edit" style="margin-left: 10px" href="javascript:toSaveQuick();">确定</a>
			</td></tr>
			</table>
			</form>
	</body>
	<script>
	  function toSaveQuick(){
		 document.savefrm.submit();
	  }
	  
	  function cellClick(o){
		  o.select();
	  }
	
	</script>
</html>
