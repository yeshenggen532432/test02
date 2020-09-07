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
<input type = "hidden" id="billIds" value="${billIds}"/> 
  <div id="printbtn" style=" width:100%;text-align: center; margin:5px auto;">  
  <input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()"> 
  <tag:select name="templateId" id="templateId" value="${templateId}" 
              onchange="changeTemplate(this)" tableName="stk_print_template"  
              displayKey="id" displayValue="fd_name" whereBlock="fd_type='1'">
  </tag:select> 
  <%-- 
   合并商品 
  <select id="mergeId" onchange="changeMerge(this)">
  	<option value="">否</option>
  	<option value="1">是</option>
  </select>
  --%>
</div>
<div style=" text-align: center; margin:10px auto;width:794px;" id="printcontent">  
<c:forEach items="${mainDatas}" var="main">
	<table style="border-color: #000000;width:794px;">  
    	<tr>
    		<td colspan="6" style="">
    			<table>
    				<td style="width: 180px;vertical-align: top">
    				<span style="font-size: 10px"><c:if test="${not empty printSettings.other2}">工商号:${printSettings.other2 }</c:if></span>
    				</td>
    				<td align="center">
    				 <span style="font-size:18px;color:#000000;font-weight:bold;">
    				 	${printSettings.title}
	   		 		  </span>
    				</td>
    				<td width="150px">
    					&nbsp;
    				</td>
    			</table>
    		</td>
    	</tr>
    </table>	
    <table border="1" cellpadding="0" cellspacing="1" style="border-color: #000000;width:794px;">  
    	<tr>  
        	<td style="text-align: right;padding-right: 1px">客户名称:</td>
            <td style="text-align: left;padding-left: 1px">${main.khNm}</td>  
            <td style="text-align: right;padding-right: 1px">电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话:</td>
            <td style="text-align: left;padding-left: 1px">${main.tel}</td>  
            <td style="text-align: right;padding-right: 1px">地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址:</td>
            <td style="text-align: left;padding-left: 1px">${main.address }</td>
        </tr>  
		<tr>  
			<td style="text-align: right;padding-right: 1px;width: 65px">配送指定:</td>
            <td style="text-align: left;padding-left: 1px;width: 180px">${main.pszd}</td> 
            <td style="text-align: right;padding-right: 1px;width: 65px">日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;期:</td> 
            <td style="text-align: left;padding-left: 1px;width: 110px"><script>document.write('${main.outDate}'.substring(0,10))</script></td> 
            <td style="text-align: right;padding-right: 1px;width: 65px">单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号:</td>
            <td style="text-align: left;padding-left: 1px">${main.billNo}</td>  
            <%--  
            <td style="text-align: right;padding-right: 1px;width: 65px">单据日期：</td>
            <td style="text-align: left;padding-left: 1px">${outTime}</td>  
            --%>
        </tr>
         <c:if test="${pszd eq '直供转单二批' }">
        <tr>  
			<td style="text-align: right;padding-right: 1px;">所属二批:</td>
            <td style="text-align: left;padding-left: 1px;">${main.epCustomerName}</td> 
            <td style="text-align: right;padding-right: 1px;"></td> 
            <td style="text-align: left;padding-left: 1px;"></td>  
            <td style="text-align: right;padding-right: 1px;"></td>
            <td style="text-align: left;padding-left: 1px"></td>  
        </tr>
        </c:if>
         <tr>
        <td style="text-align: right;padding-right: 1px">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注:</td>
        <td style="text-align: left;" colspan = "5">${main.remarks}</td> 
        </tr>
        <tr>
        <td colspan="6">
        <table style="border-collapse: collapse;">  
	<thead>
		<tr>
		<td style="font-weight:bold;border:1px solid #000000;width:6px">
		no.
		</td>
		<c:forEach items="${datas }" var="data">
		<td style="font-weight:bold;border:1px solid #000000;width:${data.fdWidth}%;">${data.fdFieldName }</td>
		</c:forEach>
		<td  style="border-bottom:1px solid #000000;">
			&nbsp;
		</td>
		</tr>
	</thead>
    <tbody id="chooselist">
    <c:forEach items="${main.maps}" var="item" varStatus="s">
      <tr> 
      <td style="border:1px solid #000000;">
      		${s.index +1}
      </td>
      	<c:forEach items="${datas }" var="data">
		
			<c:choose>
				<c:when test="${data.fdFieldKey eq 'beBarCode'}">
				<td style="border:1px solid #000000;">
					<c:if test="${item['beUnit'] eq 'B'}">
						${item['packBarCode'] }
					</c:if>
					<c:if test="${item['beUnit'] eq 'S'}">
						${item['beBarCode'] }
					</c:if>
				</td>
				</c:when>
				<c:when test="${data.fdFieldKey eq 'wareNm'}">
				<td style="border:1px solid #000000;text-align: left">
					${item[data.fdFieldKey] }
				</td>
				</c:when>
				<c:when test="${data.fdFieldKey eq 'qty'}">
				<td style="border:1px solid #000000;">
					 <script>
					  var qty = ${item[data.fdFieldKey] };
					  qty = parseFloat(qty);
					  document.write(qty)
					 </script>
				</td>
				</c:when>
				<c:otherwise>
				<td style="border:1px solid #000000;">
				${item[data.fdFieldKey] }
				</td>
				</c:otherwise>
			</c:choose>
		
		</c:forEach> 
			<td style="border-bottom:1px solid #000000;">
				&nbsp;
			</td>
        </tr>  
    </c:forEach>
	</tbody>
       <tr>  
       		<td>
       			<c:set var="coLen" value="0"/>
     	    </td>
       		<c:forEach items="${datas }" var="data">
				<c:choose>
					<c:when test="${data.fdFieldKey eq 'amt'}">
					<td style="border-left:1px solid #000000;border-right:1px solid #000000;">
						${main.disAmt}
					</td>	
					</c:when>
					<c:when test="${data.fdFieldKey eq 'qty'}">
					<td style="border-left:1px solid #000000;border-right:1px solid #000000;">
					<script>
					  var sumQty = ${main.ddNum };
					  sumQty = parseFloat(sumQty);
					  document.write(sumQty)
					 </script>
					</td>
					</c:when>
					<c:when test="${data.fdFieldKey eq 'price'}">
					<td style="border-left:1px solid #000000;border-right:1px solid #000000;">
					
					</td>
					</c:when>
						<c:otherwise>
						<td style="border:1px solid #ffffff;">
						  
						</td>
						</c:otherwise>
				</c:choose>	
				</td>
			</c:forEach>
				<td >
				&nbsp;
			</td>
        </tr> 
    </table>  
        </td>
        </tr>
    </table> 
	<table> 
	<tr>
            <td colspan="6" style="text-align: left;padding-left: 10px">
            	整单折扣:${disccunt}&nbsp;&nbsp;应收金额:${main.disAmt}&nbsp;&nbsp;业务员:${main.staff }&nbsp;&nbsp;${mian.staffTel}&nbsp;&nbsp;制单人:${main.operator}&nbsp;&nbsp;电话:${printSettings.tel}&nbsp;&nbsp;客户签字:____________
            </td> 
	</tr> 
	<c:if test="${not empty printSettings.printMemo or not empty printSettings.other1 }">
	<tr>
	 <td style="text-align: left;" colspan="6">  ${printSettings.printMemo}</td>
	</tr>
	<tr>
	 <td style="text-align: left;" colspan="6">  ${printSettings.other1}</td>
	</tr>
	</c:if>
	</table>
	<div style="page-break-after: always;"></div>
</c:forEach>
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
			
			$.ajax( {
				url : "manager/sysPrintRecord/addPrintRecordBatch",
				data :  {fdSourceId:'${ids}',fdSourceNo:'${voucherNos}',fdModel:'${fdModel}'},
				type : "post",
				success : function(json) {
							parent.closeWin('批量打印单据');
				}
			});
			return false;
    }
   
    function changeTemplate(o){
    	var mergeId = $("#mergeId").val();
		location = 'manager/showstkoutbatchprint?dataTp=1&billIds=${billIds}&fromFlag=${param.fromFlag}&templateId='+o.value+"&merge="+mergeId;
	}
	
    function changeMerge(o){
		var  templateId =$("#templateId").val();
		location = 'manager/showstkoutbatchprint?dataTp=1&billIds=${billIds}&fromFlag=${param.fromFlag}&templateId='+templateId+"&merge="+o.value;
	}
  $("#mergeId").val('${merge}');
 
</script>  
</body>  
</html>  



