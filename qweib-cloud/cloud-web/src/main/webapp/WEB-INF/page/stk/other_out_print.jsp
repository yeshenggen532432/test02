<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    td{width:200px;height:30px;text-align: center;font-size:14px;<br/>color:#000000;}  
	td.waretd{border:1px solid #999999;}
</style>  
</head>  
<body>  
  
<div style=" text-align: center; margin:10px auto;width:794px;height:550px;border:1px solid #000000;" id="printcontent">  
    <table>  
	    <tr>
		<td colspan = "3" style="font-size:20px;color:#000000;font-weight:bold;">发货单</td>
		</tr>
        <tr>  
            <td style="text-align: left;">出库类型：${outType}</td>  
            <td >出货日期：${outTime}</td>  
            <td style="text-align: right;">单号:${billNo}</td>  
            
        </tr>  
        
       
      
    </table>   
	<table style="border-collapse: collapse;">  
	<thead>
		<tr>
		<td style="border:1px solid #999999;">产品编号</td>
		<td style="border:1px solid #999999;">产品名称</td>
		
		<td style="border:1px solid #999999;">单位</td>
		<td style="border:1px solid #999999;">单价</td>
		<td style="border:1px solid #999999;">出库数量</td>
		
		</tr>
	</thead>
    <tbody id="chooselist">
	</tbody>
	<c:forEach items="${warelist}" var="item" >
      <tr>  
            <td style="border:1px solid #999999;">${item.wareCode}</td>  
            <td style="border:1px solid #999999;">${item.wareNm}</td>  
             
            <td style="border:1px solid #999999;">${item.unitName}</td>  
			<td style="border:1px solid #999999;">${item.price}</td>  
			<td style="border:1px solid #999999;">${item.qty}</td>  
        </tr>  
    </c:forEach>
       
    </table>  
	
	
</div>  
  
<div id="printbtn" style=" width:100%;text-align: center; margin:10px auto;">  
  <input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()">  
</div>  
  
  
  
  
<script type="text/javascript">  
    function doPrint() {  
        window.print();  
    }  
    function printit()
    {
    	if (confirm('确定打印吗？')){
    		var newstr = document.getElementById('printcontent').innerHTML;
    		var oldstr = document.body.innerHTML;//
			document.body.innerHTML = newstr;
			 window.print();
			document.body.innerHTML = oldstr;
			return false;
        	}
    }
   
   
    
</script>  
</body>  
</html>  



