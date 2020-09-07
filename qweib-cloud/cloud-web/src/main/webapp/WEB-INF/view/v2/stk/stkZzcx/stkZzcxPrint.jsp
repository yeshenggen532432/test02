<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!doctype html>  
<html lang="en">  
 <head>  
  <meta charset="UTF-8">  
  <meta name="Generator" content="EditPlus®">  
  <meta name="Author" content="">  
  <meta name="Keywords" content="">  
  <meta name="Description" content="">  
  <script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
 
<style>  
    table{width:794px;}
    td{height:26px;text-align: center;font-size:12px;<br/>color:#000000;}  
	td.waretd{border:1px solid #999999;}
</style>  
</head>  
<body>  
 <div id="printbtn" style=" width:100%;text-align: center; margin:10px auto;">  
  <input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()">  
</div>  
<div style=" text-align: center; margin:10px auto;width:794px;height:550px;border:1px solid #000000;" id="printcontent">  
    <table style="border-color: #000000;width:794px;">  
	    <tr>
		<td colspan = "6" style="font-size:18px;color:#000000;font-weight:bold;">拆装单</td>
		</tr>
       <tr>
								<td style="text-align: right;padding-right: 1px;width: 80px">单据时间：</td>
								<td style="text-align: left;padding-left: 1px;width: 110px">
								${stkMove.inDate}
								</td>
								<td style="text-align: right;padding-right: 1px;width: 80px">出库仓库：</td>
								<td style="text-align: left;padding-left: 1px;width: 110px">
								${stkMove.stkName}
								</td>
								<td style="text-align: right;padding-right: 1px;width: 80px">入库仓库：</td>
								<td style="text-align: left;padding-left: 1px;width: 110px">
								${stkMove.stkInName}
								</td>
							</tr>
							<tr>
								<td style="text-align: right;padding-right: 1px" valign="top">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
								<td style="text-align: left;" colspan="5">
									${remarks.remarks}
								</td>
							</tr>  
    </table>   
	<table style="border-collapse: collapse;">  
	<thead>
		<tr>
		<td style="font-weight:bold;border:1px solid #000000;">产品编号</td>
		<td style="font-weight:bold;border:1px solid #000000;">产品名称</td>
		<td style="font-weight:bold;border:1px solid #000000;">产品规格</td>
		<td style="font-weight:bold;border:1px solid #000000;">单位</td>
		<td style="font-weight:bold;border:1px solid #000000;">移库数量</td>
		<td style="font-weight:bold;border:1px solid #000000;display: ${permission:checkUserFieldDisplay('stk.stkMove.lookprice')}">单价</td>
		<td style="font-weight:bold;border:1px solid #000000;display: ${permission:checkUserFieldDisplay('stk.stkMove.lookamt')}">移库金额</td>
		</tr>
	</thead>
    <tbody id="chooselist">
	</tbody>
	<c:set var="sumQty" value="0"/>
	<c:set var="sumAmt" value="0"/>
	<c:forEach items="${stkMove.list}" var="item" >
      <tr>  
            <td style="border:1px solid #999999;">${item.wareCode}</td>  
            <td style="border:1px solid #999999;">${item.wareNm}</td>  
            <td style="border:1px solid #999999;">${item.unitName}</td>  
             <td style="border:1px solid #999999;">${item.wareGg}</td>  
			<td style="border:1px solid #999999;">${item.qty}</td> 
			<td style="border:1px solid #999999;display: ${permission:checkUserFieldDisplay('stk.stkMove.lookprice')}">${item.price}</td>  
			<td style="border:1px solid #999999;display: ${permission:checkUserFieldDisplay('stk.stkMove.lookamt')}">${item.amt}</td>  
        </tr>  
         <c:set var="sumQty" value="${sumQty+item.qty}"/>
         <c:set var="sumAmt" value="${sumAmt+item.amt}"/>
    </c:forEach>
         <tr>
      		<td style="border:1px solid #999999;"></td>
      		<td style="border:1px solid #999999;"></td>
      		<td style="border:1px solid #999999;"></td>
      		<td style="border:1px solid #999999;"></td>
      		<td style="border:1px solid #999999;">${sumQty}</td>
      		<td style="border:1px solid #999999;display: ${permission:checkUserFieldDisplay('stk.stkMove.lookprice')}"></td>
      		<td style="border:1px solid #999999;display: ${permission:checkUserFieldDisplay('stk.stkMove.lookamt')}">${sumAmt}</td>
      </tr>
    </table>  
	
	
</div>  
  
<script type="text/javascript">  
    function doPrint() {  
        window.print();  
    }  
    function printit()
    {
    		var newstr = document.getElementById('printcontent').innerHTML;
    		var oldstr = document.body.innerHTML;//
			document.body.innerHTML = newstr;
			 window.print();
			document.body.innerHTML = oldstr;
			return false;
    }
</script>  
</body>  
</html>  



