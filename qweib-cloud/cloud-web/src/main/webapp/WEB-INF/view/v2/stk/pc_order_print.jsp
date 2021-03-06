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
<input type = "hidden" id="billId" value="${billId}"/> 
  <div id="printbtn" style=" width:100%;text-align: center; margin:5px auto;">  
  <input id="btnPrint" value="设置" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "toPrintSet()"> 
  <input id="btnPrint1" value="设置打印列" style=" width:80px; height:22px; font-size:16px;" type="button" onclick = "printDlgConfig()"> 
  <input id="btnPrint" value="打印" style=" width:50px; height:22px; font-size:16px;" type="button" onclick = "printit()"> 
</div>
<div style=" text-align: center; margin:10px auto;width:794px;height:540px;border:1px solid #000000;" id="printcontent">  
    <table border="1" cellpadding="0" cellspacing="1" style="border-color: #000000;width:794px;">  
    	<tr>
    		<td colspan="6">
    			<table>
    				<td style="width: 180px;vertical-align: top">
    				<span style="font-size: 10px"><c:if test="${not empty printSettings.other2}">工商号:${printSettings.other2 }</c:if></span>
    				</td>
    				<td align="center">
    				 <span style="font-size:18px;color:#000000;font-weight:bold;">
    				 	销售订单
	   		 		  </span>
    				</td>
    				<td width="150px">
    					&nbsp;
    				</td>
    			</table>
    		</td>
    	</tr>
    	<tr>  
        	<td style="text-align: right;padding-right: 1px">客户名称:</td>
            <td style="text-align: left;padding-left: 1px">${khNm}</td>  
            <td style="text-align: right;padding-right: 1px">电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话:</td>
            <td style="text-align: left;padding-left: 1px">${tel}</td>  
            <td style="text-align: right;padding-right: 1px">地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址:</td>
            <td style="text-align: left;padding-left: 1px">${address }</td>
        </tr>  
		<tr>  
			<td style="text-align: right;padding-right: 1px;width: 65px">配送指定:</td>
            <td style="text-align: left;padding-left: 1px;width: 180px">${pszd}</td> 
            <td style="text-align: right;padding-right: 1px;width: 65px">日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;期:</td> 
            <td style="text-align: left;padding-left: 1px;width: 110px">${outTime}</td> 
            <td style="text-align: right;padding-right: 1px;width: 65px">单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号:</td>
            <td style="text-align: left;padding-left: 1px">${billNo}</td>  
            <%--  
            <td style="text-align: right;padding-right: 1px;width: 65px">发票日期：</td>
            <td style="text-align: left;padding-left: 1px">${outTime}</td>  
            --%>
        </tr>
         <c:if test="${pszd eq '直供转单二批' }">
        <tr>  
			<td style="text-align: right;padding-right: 1px;">所属二批:</td>
            <td style="text-align: left;padding-left: 1px;">${epCustomerName}</td> 
            <td style="text-align: right;padding-right: 1px;"></td> 
            <td style="text-align: left;padding-left: 1px;"></td>  
            <td style="text-align: right;padding-right: 1px;"></td>
            <td style="text-align: left;padding-left: 1px"></td>  
        </tr>
        </c:if>
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
            <td style="border:1px solid #999999;" colspan="2">发票数量:${sumQty}</td>  
            <td style="border:1px solid #999999;"colspan="2">发票金额:${disamt}</td>  
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
						${sumQty}
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
            	整单折扣:${discount}&nbsp;&nbsp;应收金额:${disamt}&nbsp;&nbsp;业务员:${staff }&nbsp;&nbsp;${staffTel}&nbsp;&nbsp;制单人:${operator}&nbsp;&nbsp;电话:${printSettings.tel}&nbsp;&nbsp;客户签字:____________
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
			if('${param.fromFlag}'==0){
				parent.closeWin('订单打印');

			}else{
				parent.closeWin('订单打印');
			}
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
					data :  {"billName":"销售订单","printTitle":title1,"tel":tel,"printMemo":printMemo,"other1":other1,"other2":other2},
					type : "post",
					success : function(json) {
						if (json.state) {
							//showMsg("保存成功");
							$('#dlg').dialog('close');
							
							window.location.href='manager/showorderprint?billId=' + billId;
							
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
            href: "manager/queryPrintConfigList?fdModel=com.cnlife.stk.model.StkOrderSub",
            onClose: function(){
            	window.location.href='manager/showorderprint?billId=' + '${billId}';
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
			data :  {id:id,fdStatus:fdStatus,fdModel:'com.cnlife.stk.model.StkOrderSub'},
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
			data :  {id:id,fdFieldName:obj.value,fdModel:'com.cnlife.stk.model.StkOrderSub'},
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
			data :  {id:id,fdWidth:obj.value,fdModel:'com.cnlife.stk.model.StkOrderSub'},
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
			data :  {id:id,orderCd:obj.value,fdModel:'com.cnlife.stk.model.StkOrderSub'},
			type : "post",
			success : function(json) {
				if (json.state) {
				} else{
					showMsg("保存失败" + json.msg);
				}
			}
		});
	}
</script>  
</body>  
</html>  



