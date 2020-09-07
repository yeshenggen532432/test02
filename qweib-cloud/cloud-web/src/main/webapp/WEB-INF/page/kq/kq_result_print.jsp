<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
<style>  
    table{width:100%;}
    td{height:16px;text-align: center;font-family:'微软雅黑';font-size:14px;<br/>color:#000000;}  
	td.waretd{border:1px solid #000000;}
</style>  
</head>  
<body>  
<div id="printbtn" style=" width:100%;text-align: center; margin:5px auto;">  
<input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()"> 
 </input> 
<div style=" text-align: center; margin:10px auto;width:794px;height:540px;" id="printcontent">  
	<table style="border-color: #000000;width:794px;">  
    	<tr>
    		<td colspan="6" style="">
    			<table>
    				<td style="width: 180px;vertical-align: top">
    				
    				</td>
    				<td align="center">
    				 <span style="font-size:18px;color:#000000;font-weight:bold;">
    				 	${printTitle}
	   		 		  </span>
    				</td>
    				<td width="150px">
    					<span id="paramStr">
	     	正常√&nbsp; &nbsp; 
	    
	     	迟到L&nbsp; &nbsp; 
	         
	     
	      
	     	缺勤×&nbsp; &nbsp; 
	    
	     
	      
	     	备注≠&nbsp; &nbsp; 
	     
	     	早退E&nbsp; &nbsp; 
	     
	     	漏卡■
	     </span>   
	     <span id="paramStr">
	     	考勤地点错误O
	     </span>     
    				</td>
    			</table>
    		</td>
    	</tr>
    </table>	
    <table border="1" cellpadding="0" cellspacing="1" style="border-color: #000000;width:794px;">  
    	
    	
        
         
       
        
	<thead>
		<tr>
		<td style="font-weight:bold;border:1px solid #000000;width:2px">
		no.
		</td>
		<c:forEach items="${datas }" var="data">
		<td style="font-weight:bold;border:1px solid #000000;width:${data.fdWidth}%;">${data.fdFieldName }</td>
		</c:forEach>
		
		</tr>
	</thead>
    <tbody id="chooselist">
    <c:forEach items="${mapList}" var="item" varStatus="s">
      <tr> 
      <td style="border:1px solid #000000;">
      		${s.index +1}
      </td>
      	<c:forEach items="${datas }" var="data">
			<td style="border:1px solid #000000;">
			${item[data.fdFieldKey]}
			</td>
			
		
		</c:forEach> 
			
        </tr>  
    </c:forEach>
	</tbody>
	
    <%--
    <tr>  
            <td style="border:1px solid #999999;" colspan="2">合计：</td>  
            <td style="border:1px solid #999999;" colspan="2">整单折扣:${discount}</td>  
            <td style="border:1px solid #999999;" colspan="2">发票数量:${sumQty}</td>  
            <td style="border:1px solid #999999;"colspan="2">发票金额:${disamt}</td>  
            <td style="border:1px solid #999999;"colspan="2"></td>
    </tr>  
     --%>   
       
    
        
    </table> 
	
	
</div>  
  
  

<script type="text/javascript">  
    function doPrint() {  
        window.print();  
    }  
    function printit()
    {
    	//if (confirm('确定打印吗？')){
    		var newstr = document.getElementById('printcontent').innerHTML;
    		var oldstr = document.body.innerHTML;//
			document.body.innerHTML = newstr;
			window.print();
			document.body.innerHTML = oldstr;
			
			
    }
   
    
</script>  
</body>  
</html>  



