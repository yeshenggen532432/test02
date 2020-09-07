<%@ page language="java" pageEncoding="UTF-8"%>
<!doctype html>  
<html lang="en">  
 <head>  
  <meta charset="UTF-8">  
  <meta name="Generator" content="EditPlus®">  
  <meta name="Author" content="">  
  <meta name="Keywords" content="">  
  <meta name="Description" content="">  
   <%@include file="/WEB-INF/page/include/source.jsp"%>
  <script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<style>  
    table{width:100%;}
    td{height:16px;text-align: center;font-family:'微软雅黑';font-size:14px;<br/>color:#000000;}  
	td.waretd{border:1px solid #000000;}
</style>  
</head>  
<body>  
    
<div id="printbtn" style=" width:100%;text-align: center; margin:10px auto;">  
  <input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()">  
</div>  
  
<div style=" text-align: center; margin:10px auto;width:794px;height:550px;border:0px solid #000000;" id="printcontent">  
    <table>  
	    <tr>
		<td colspan = "4" style="font-size:20px;color:#000000;text-align:center;font-weight:bold;">
		其它入库单
		</td>
		</tr>
    </table>   
     <table border="1" cellpadding="0" cellspacing="1" style="border-color: #000000;width:794px;">  
        <tr>  
            <td style="text-align: right;padding-right: 1px">入库对象：</td>  
            <td style="text-align: left;padding-left: 1px">${proName}</td>
            <td style="text-align: right;padding-right: 1px">入库日期：</td>  
            <td style="text-align: left;padding-left: 1px">${inTime}</td>
            <td style="text-align: right;padding-right: 1px">单号：</td>  
            <td style="text-align: left;padding-left: 1px">${billNo}</td>
        </tr>  
    </table>  
	<table style="border-collapse: collapse;">  
	<thead>
		<tr>
		<td style="font-weight:bold;border:1px solid #000000;width:6px">
		no.
		</td>
		<td style="font-weight:bold;border:1px solid #999999;">产品编号</td>
		<td style="font-weight:bold;border:1px solid #999999;">产品名称</td>
		<td style="font-weight:bold;border:1px solid #999999;">规格</td>
		<td style="font-weight:bold;border:1px solid #999999;">单位</td>
		<td style="font-weight:bold;border:1px solid #999999;">单价</td>
		<td style="font-weight:bold;border:1px solid #999999;">入库数量</td>
		<td style="font-weight:bold;border:1px solid #999999;">入库金额</td>
		<td style="font-weight:bold;border:1px solid #999999;">生产日期</td>
		</tr>
	</thead>
    <tbody id="chooselist">
	</tbody>
		<c:set var="sumQty" value="0"/>
		<c:set var="sumAmt" value="0"/>
	<c:forEach items="${warelist}" var="item" varStatus="s">
       <tr>  
       		<td style="border:1px solid #000000;">
      		${s.index +1}
    	  </td>
            <td style="border:1px solid #999999;">${item.wareCode}</td>  
            <td style="border:1px solid #999999;">${item.wareNm}</td>  
             <td style="border:1px solid #999999;text-align: left">${item.wareGg}</td>
            <td style="border:1px solid #999999;">${item.unitName}</td>  
			<td style="border:1px solid #999999;">${item.price}</td>  
			<td style="border:1px solid #999999;">${item.qty}</td> 
			<td style="border:1px solid #999999;">${item.amt}</td>  
			<td style="border:1px solid #999999;">${item.productDate}</td>  
        </tr>  
        <c:set var="sumQty" value="${sumQty+item.qty }"/>
        <c:set var="sumAmt" value="${sumAmt+item.amt }"/>
    </c:forEach>
      <tr>
      		<td style="border:1px solid #999999;"></td>
      		<td style="border:1px solid #999999;"></td>
      		<td style="border:1px solid #999999;"></td>
      		<td style="border:1px solid #999999;"></td>
      		<td style="border:1px solid #999999;"></td>
      		<td style="border:1px solid #999999;"></td>
      		<td style="border:1px solid #999999;">${sumQty }</td>
      		<td style="border:1px solid #999999;">${sumAmt}</td>
      		<td style="border:1px solid #999999;"></td>
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



