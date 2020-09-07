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
    td{height:20px;text-align: center;font-family:'微软雅黑';font-size:12px;<br/>color:#000000;}  
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
    <table border="1" cellpadding="0" cellspacing="1" style="border-color: #000000">  
    	<tr>
    		<td colspan="6" style="text-align: center;font-size:20px;color:#000000;font-weight:bold;border-top:1px solid #FFFFFF;">${printTitle}</td>
    	</tr>
		<tr>  
			<td style="text-align: right;padding-right: 1px;width: 60px">退货单位：</td>
            <td style="text-align: left;padding-left: 1px;width: 180px">${proName}</td> 
            <td style="text-align: right;padding-right: 1px;width: 60px">退货时间：</td> 
            <td style="text-align: left;padding-left: 1px;width: 110px">${inTime}</td>  
            <td style="text-align: right;padding-right: 1px;width: 60px">单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号：</td>
            <td style="text-align: left;padding-left: 1px">${billNo}</td>  
        </tr>
        <tr>  
			<td style="text-align: right;padding-right: 1px;width: 60px">业&nbsp;务&nbsp;员：</td>
            <td style="text-align: left;padding-left: 1px;width: 180px">${empNm }</td> 
            <td style="text-align: right;padding-right: 1px;width: 60px"></td> 
            <td style="text-align: left;padding-left: 1px;width: 110px"></td>  
            <td style="text-align: right;padding-right: 1px;width: 60px"></td>
            <td style="text-align: left;padding-left: 1px"></td>  
        </tr>
        <tr>
        <td style="text-align: right;padding-right: 1px">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
        <td style="text-align: left;" colspan = "5">${remarks}</td> 
        </tr>
        <tr>
        <td colspan="6">
        <table style="border-collapse: collapse;">  
	<thead>
		<tr>
		<c:forEach items="${datas }" var="data">
		<td style="font-weight:bold;border:1px solid #000000;width:${data.fdWidth}%;">${data.fdFieldName }</td>
		</c:forEach>
		<td  style="border-bottom:1px solid #000000;">
			&nbsp;
		</td>
		</tr>
	</thead>
    <tbody id="chooselist">
	</tbody>
	<c:forEach items="${mapList}" var="item" >
      <tr> 
      	<c:forEach items="${datas }" var="data">
      		<c:choose>
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
    </table>  
        </td>
        </tr>
         <tr>  
        	<td style="text-align: right;padding-right: 1px;border:1px solid #FFFFFF;">退货数量：</td>
            <td style="text-align: left;padding-left: 1px;border:1px solid #FFFFFF;">${sumQty}</td>  
            <td style="text-align: right;padding-right: 1px;border:1px solid #FFFFFF;">退货金额：</td>
            <td style="text-align: left;padding-left: 1px;border:1px solid #FFFFFF;">${disamt}</td>  
            <td style="text-align: right;padding-right: 1px;border:1px solid #FFFFFF;"></td>
            <td style="text-align: left;padding-left: 1px;border:1px solid #FFFFFF;"></td>
           
        </tr>  
    </table> 
	<table> 
	<tr>
	 <td style="text-align: left;">制单人：${operator}</td> 
	 <td></td> 
            <td style="text-align: left;">客户签字:____________</td>  
            
            <td style="text-align: left;">咨询电话:${comTel}</td>  
	</tr> 
	</table>
	
</div>  
  <div id="printDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="设置打印列" iconCls="icon-edit">
      
  </div>
  
  
<div id="dlg" closed="true" class="easyui-dialog" title="设置" style="width:400px;height:250px;padding:10px"
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
		单据标题: <input name="printTitle" id="printTitle" style="width:120px;height: 20px;" value="${printTitle}"/>
		咨询电话:<input name="comTel" id="comTel" style="width:120px;height: 20px;" value="${comTel}"/><br /><br />
		备注1:<input name="printMemo" id="printMemo" style="width:240px;height: 20px;" value="${printMemo}"/><br /><br />
		备注2:<input name="other1" id="other1" style="width:240px;height: 20px;" value="${other1}"/><br /><br />
		备注3:<input name="other2" id="other2" style="width:240px;height: 20px;" value="${other2}"/>
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
					data :  {"billName":"销售退货","printTitle":title1,"tel":tel,"printMemo":printMemo,"other1":other1,"other2":other2},
					type : "post",
					success : function(json) {
						if (json.state) {
							//showMsg("保存成功");
							$('#dlg').dialog('close');
							window.location.href='manager/showstkinprint?billId=' + billId;
							
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
            href: "manager/queryPrintConfigList?fdModel=com.cnlife.stk.model.StkXsThsub",
            onClose: function(){
            	window.location.href='manager/showstkinprint?billId=' + '${billId}';
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
			data :  {id:id,fdStatus:fdStatus,fdModel:'com.cnlife.stk.model.StkXsThsub'},
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
			data :  {id:id,fdFieldName:obj.value,fdModel:'com.cnlife.stk.model.StkXsThsub'},
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
			data :  {id:id,fdWidth:obj.value,fdModel:'com.cnlife.stk.model.StkXsThsub'},
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



