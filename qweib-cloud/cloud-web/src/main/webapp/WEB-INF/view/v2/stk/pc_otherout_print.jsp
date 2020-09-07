<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
<input type = "hidden" id="billId" value="${billId}"/> 
  <div id="printbtn" style=" width:100%;text-align: center; margin:5px auto;">  
   <input id="btnBillMes" value="单据信息" style=" width:70px; height:22px; font-size:16px;" type="button" onclick = "showBill()"> 
  <input id="btnPrintSet" value="设置" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "toPrintSet()"> 
  <input id="btnPrintColumn" value="设置打印列" style=" width:80px; height:22px; font-size:16px;" type="button" onclick = "printDlgConfig()"> 
  <input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()"> 
  <input id="btnPrintTemplate" value="设置模版" style=" width:80px; height:22px; font-size:16px;" type="button" onclick = "addTemplate()"> 
  <input id="btnWareGroup" value="设置分组" style=" width:80px; height:22px; font-size:16px;" type="button" onclick = "addWareGroup()"> 
  <tag:select name="templateId" id="templateId" value="${templateId}" 
              onchange="changeTemplate(this)" tableName="stk_print_template"  
              displayKey="id" displayValue="fd_name" whereBlock="fd_type='2'">
  </tag:select>
  合并商品 
  <select id="mergeId" onchange="changeMerge(this)">
  	<option value="">否</option>
  	<option value="1">是</option>
  </select>
</div>
<div style=" text-align: center; margin:10px auto;width:794px;height:540px;" id="printcontent">  
	<table style="border-color: #000000;width:794px;">  
    	<tr>
    		<td colspan="6" style="">
    			<table>
    				<td style="width: 180px;vertical-align: top">
    				<span style="font-size: 10px"><c:if test="${not empty printSettings.other2}">工商号:${printSettings.other2 }</c:if></span>
    				</td>
    				<td align="center">
    				 <span style="font-size:18px;color:#000000;font-weight:bold;">
    				 	<c:choose>
    				 		<c:when test="${outType eq '销售出库' }">${printSettings.title}</c:when>
    				 		<c:when test="${outType eq '报损出库' }">报损出库单</c:when>
    				 		<c:when test="${outType eq '领用出库' }">领用出库单</c:when>
    				 		<c:otherwise>其它出库单</c:otherwise>
    				 	</c:choose>
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
            <td style="text-align: left;padding-left: 1px">${khNm}</td>  
            <td style="text-align: right;padding-right: 1px">电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话:</td>
            <td style="text-align: left;padding-left: 1px">${tel}</td>  
            <td style="text-align: right;padding-right: 1px">地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址:</td>
            <td style="text-align: left;padding-left: 1px">${address }</td>
        </tr>  
		<tr>  
            <td style="text-align: right;padding-right: 1px;width: 65px">日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;期:</td> 
            <td style="text-align: left;padding-left: 1px;width: 110px"><script>document.write('${outTime}'.substring(0,10))</script></td> 
            <td style="text-align: right;padding-right: 1px;width: 65px">单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号:</td>
            <td style="text-align: left;padding-left: 1px">${billNo}</td>  
            	<td style="text-align: right;padding-right: 1px;width: 65px"></td>
            <td style="text-align: left;padding-left: 1px;width: 180px"></td> 
            <%--  
            <td style="text-align: right;padding-right: 1px;width: 65px">单据日期：</td>
            <td style="text-align: left;padding-left: 1px">${outTime}</td>  
            --%>
        </tr>
         <tr>
        <td style="text-align: right;padding-right: 1px">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注:</td>
        <td style="text-align: left;" colspan = "5">${remarks}</td> 
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
	<c:set var="showAmt" value="0"/>
    <c:forEach items="${mapList}" var="item" varStatus="s">
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
					  document.write(qty.toFixed(2))
					 </script>
				</td>
				</c:when>
				<c:when test="${data.fdFieldKey eq 'price'}">
				<td style="border:1px solid #000000;">
					 <script>
					  var price = ${item[data.fdFieldKey] };
					  price = parseFloat(price);
					  document.write(price.toFixed(2))
					 </script>
				</td>
				</c:when>
				<c:when test="${data.fdFieldKey eq 'amt'}">
					<td style="border:1px solid #000000;">
							${item[data.fdFieldKey] }
					</td>
					<c:set var="showAmt" value="1"/>
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
	
    <%--
    <tr>  
            <td style="border:1px solid #999999;" colspan="2">合计：</td>  
            <td style="border:1px solid #999999;" colspan="2">整单折扣:${discount}</td>  
            <td style="border:1px solid #999999;" colspan="2">单据数量:${sumQty}</td>  
            <td style="border:1px solid #999999;"colspan="2">单据金额:${disamt}</td>  
            <td style="border:1px solid #999999;"colspan="2"></td>
    </tr>  
     --%>   
       <tr>  
       		<td>
       			<c:set var="coLen" value="0"/>
     	    </td>
       		<c:forEach items="${datas }" var="data">
				<c:choose>
					<c:when test="${data.fdFieldKey eq 'amt'}">
					<td style="border-left:1px solid #000000;border-right:1px solid #000000;">
						${disamt}
					</td>	
					</c:when>
					<c:when test="${data.fdFieldKey eq 'qty'}">
					<td style="border-left:1px solid #000000;border-right:1px solid #000000;">
					<script>
					  var sumQty = ${sumQty };
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
				<c:if test="${showAmt eq 1}">
					整单折扣:${discount}&nbsp;&nbsp;应收金额:${disamt}&nbsp;&nbsp;
				</c:if>
            	业务员:${staff }&nbsp;&nbsp;${staffTel}&nbsp;&nbsp;制单人:${operator}&nbsp;&nbsp;电话:${printSettings.tel}&nbsp;&nbsp;客户签字:____________
            </td> 
	</tr> 
	<c:if test="${not empty printMemo or not empty other1 }">
	<tr>
	 <td style="text-align: left;" colspan="6">  ${printMemo}</td>  
	</tr>
	<tr>
	 <td style="text-align: left;" colspan="6">  ${other1}</td>  
	</tr>
	</c:if>
	</table>
	
</div>  
  <div id="printDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="设置打印列" iconCls="icon-edit">
      
  </div>
  
  
<div id="dlg" closed="true" class="easyui-dialog" title="设置" style="width:400px;height:310px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						submitSet();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
		工商号：<input name="other2" id="other2" style="width:240px;height: 20px;" value="${printSettings.other2}"/>
		<br/>
		单&nbsp;据&nbsp;标&nbsp;题：<input name="printTitle" id="printTitle" style="width:240px;height: 20px;" value="${printSettings.title}"/>
		<br/>
		咨&nbsp;询&nbsp;电&nbsp;话：<input name="comTel" id="comTel" style="width:120px;height: 20px;" value="${printSettings.tel}"/><br />
		备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注1：
		<textarea name="printMemo" id="printMemo" rows="5" cols="40">${printSettings.printMemo}</textarea><br/>
		备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注2：
		<textarea name="other1" id="other1" rows="5" cols="40">${printSettings.other1}</textarea>
		
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
			$.ajax( {
				url : "manager/sysPrintRecord/addPrintRecord",
				data :  {fdSourceId:'${billId}',fdSourceNo:'${billNo}',fdModel:'${fdModel}'},
				type : "post",
				success : function(json) {
						if('${param.fromFlag}'==0){
							parent.closeWin('销售开单');
						}else{
							parent.closeWin('单据信息${billId}');
						}
				}
			});
			return false;
        //	}
    }
   
    function submitSet()
	{
		
		var title1 = $("#printTitle").val();
		var tel = $("#comTel").val();
		 var printMemo = $("#printMemo").val();
		 var other1 = $("#other1").val();
		 var other2 = $("#other2").val();
		if(title1 == "")
			{
				alert("请输入标题");
				return;
			}
		var billId = $("#billId").val();
		$.messager.confirm('确认', "是否确认保存", function(r) {
			if (r) {
				$.ajax( {
					url : "manager/savePrintSet",
					data :  {"billName":"${billName}","printTitle":title1,"tel":tel,"printMemo":printMemo,"other1":other1,"other2":other2},
					type : "post",
					success : function(json) {
						if (json.state) {
							//showMsg("保存成功");
							$('#dlg').dialog('close');
							var templateId = $("#templateId").val();
							window.location.href='manager/showstkoutprint?billId=' + billId+'&templateId='+templateId;
							
						} else{
							showMsg("保存失败" + json.msg);
						}
					}
				});
			}
		});
		
	}
    
    function toPrintSet()
	{
		$('#dlg').dialog('open');
	}
    
    function printDlgConfig(){
    	//$('#printDlg').dialog('open');
    	/**/
    	$('#printDlg').dialog({
            title: '设置打印列',
            iconCls:"icon-edit",
            width: 500,
            height: 400,
            modal: true,
            href: "manager/queryPrintConfigList?fdModel=${fdModel}",
            onClose: function(){
            	var templateId = $("#templateId").val();
            	window.location.href='manager/showstkoutprint?billId=' + '${billId}'+'&templateId='+templateId;
            }
        });
    	$('#printDlg').dialog('open');
    }
	function updateFdStatus(index,id){
		var fdStatus = 0;
	    var txtStatus = document.getElementById("fdStatus"+index).value;
	    if(txtStatus==0){
	    	fdStatus=1;
	    }
		$.ajax( {
			url : "manager/updatePrintConfig",
			data :  {id:id,fdStatus:fdStatus,fdModel:'${fdModel}'},
			type : "post",
			success : function(json) {
				if (json.state) {
					
					if(fdStatus==0){
						document.getElementById("fdStatus"+index).value = 0;
						document.getElementById("fdStatusTxt"+index).innerHTML = "否";
						document.getElementById("btnfield"+index).value = "显示";
					}else{
						document.getElementById("fdStatus"+index).value = 1;
						document.getElementById("fdStatusTxt"+index).innerHTML = "是";
						document.getElementById("btnfield"+index).value = "不显示";
					}
					
				} else{
					showMsg("保存失败" + json.msg);
				}
			}
		});
	}
	function changeFieldName(obj,id){
		if(obj.value==""){
			alert("列名不能为空！");
			return;
		}
		$.ajax( {
			url : "manager/updatePrintConfig",
			data :  {id:id,fdFieldName:obj.value,fdModel:'${fdModel}'},
			type : "post",
			success : function(json) {
				if (json.state) {
				} else{
					showMsg("保存失败" + json.msg);
				}
			}
		});
	}
	function changeFdWidth(obj,id){
		if(obj.value==""){
			alert("宽度不能为空！");
			return;
		}
		$.ajax( {
			url : "manager/updatePrintConfig",
			data :  {id:id,fdWidth:obj.value,fdModel:'${fdModel}'},
			type : "post",
			success : function(json) {
				if (json.state) {
				} else{
					showMsg("保存失败" + json.msg);
				}
			}
		});
	}
	function changeOrderCd(obj,id){
		if(obj.value==""){
			alert("排序不能为空！");
			return;
		}
		$.ajax( {
			url : "manager/updatePrintConfig",
			data :  {id:id,orderCd:obj.value,fdModel:'${fdModel}'},
			type : "post",
			success : function(json) {
				if (json.state) {
				} else{
					showMsg("保存失败" + json.msg);
				}
			}
		});
	}
	function showBill()
	{
		location = 'manager/showstkout?dataTp=1&billId=${billId}';
	}
	
	function addTemplate(){
		parent.closeWin('设置模版');
    	parent.add('设置模版','manager/stkPrintTemplate/page?fdType=2');
	}
	function addWareGroup(){
		
		var customerName = "${khNm}";
		var cstId = '${cstId}';
		parent.closeWin(customerName+'_设置客户商品分组');
    	parent.add(customerName+'_设置客户商品分组','manager/stkCustomerWareGroup/queryStkWareGroup?cstId='+cstId);
	}
	
	function changeTemplate(o){
		var mergeId = $("#mergeId").val();
		location = 'manager/showstkoutprint?dataTp=1&billId=${billId}&fromFlag=${param.fromFlag}&templateId='+o.value+"&merge="+mergeId;
	}
	
  $.ajax( {
		url : "manager/sysPrintRecord/queryPrintCount",
		data :  {fdSourceId:'${billId}',fdModel:'${fdModel}'},
		type : "post",
		async : true,
		success : function(json) {
			    	document.getElementById("btnPrint").value="打印("+json.count+")";
			    }
	});
  function changeMerge(o){
		var  templateId =$("#templateId").val();
		location = 'manager/showstkoutprint?dataTp=1&billId=${billId}&fromFlag=${param.fromFlag}&templateId='+templateId+"&merge="+o.value;
	}
  $("#mergeId").val('${merge}');
</script>  
</body>  
</html>  



