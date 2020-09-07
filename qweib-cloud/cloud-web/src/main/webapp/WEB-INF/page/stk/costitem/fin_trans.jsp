<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>企微宝</title>
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	<script type="text/javascript" src="resource/md5.js"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>

<div class="box">
	<form action="manager/recProc" name="stkfrm" id="stkfrm" method="post">

		<input  type="hidden" name="saccId" id="saccId" value="${saccId}"/>
		<input  type="hidden" name="billNo" id="billNo" value="${billNo}"/>
		<input  type="hidden" name="taccId" id="taccId" value="${taccId}"/>
		<input  type="hidden" name="billId" id="billId" value="${billId}"/>
		<input  type="hidden" name="status" id="status" value="${status}"/>

		<dl id="dl">
			<dt class="f14 b">转移单</dt>
			<dd>
				<span class="title" id="billNoTitle">${billNo}</span>

				<span class="title" id="billStatus" style="color:red">${billStatus}</span>
			</dd>
			<dd>

				<span class="title">转出账户：</span>

				<select name=""  id = "payAccount1">

				</select>
			</dd>

			<dd>
				<span class="title">转入账户：</span>

					<select name=""  id = "payAccount2">

				</select>
			</dd>
			<dd>
				<span class="title">转移金额：</span>
				<input class="reg_input" name="cash" id="cash" value="${transAmt}"  style="width: 120px" onkeyup="makeAmtFormat(0,this.value)"/>
				<span class="title" id="lbcash">${transAmt}</span>

			</dd>

			<dd>
				<span class="title">收款时间：</span>
				<input name="sdate" id="recTime"  onClick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 120px;" value="${transTimeStr}" readonly="readonly"/>
			</dd>
			<dd>
				<span class="title">备注：</span>
				<textarea rows="4" cols="50" name="remarks" id="remarks">${remarks }</textarea>
			</dd>
		</dl>
		<div class="f_reg_but">
			<c:if test="${status eq 0 }">
				<input type="button" id="btndraft" value="暂存"  onclick="dragSave();"/>
				<input type="button" id="btndraftaudit" value="审批"  style="display: ${billId eq 0?'none':''}" onclick="audit();"/>
			</c:if>
			<input type="button" id="btnsave" value="保存并审批"  style="display:${(status eq 0 and billId eq 0)?'':'none'}" onclick="saveAudit();"/>
		</div>
	</form>
</div>
<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;"
	 minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
	<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
</div>
<script type="text/javascript">
	var editstatus = 1;
	var isModify = false;
	$(function(){
		queryAccount();

	});
	function dragSave(){
		//验证手机号码
		if($("#status").val()!= 0)return;
		var cash = $("#cash").val();
		var saccId = $("#saccId").val();
		var taccId = $("#taccId").val();
		var remarks = $("#remarks").val();

		var billId = $("#billId").val();
		var recTime = $("#recTime").val();
		var status = $("#status").val();
		if(status==1){
			alert("该单据已审批，不能操作！");
			return;
		}
		if(status==2){
			alert("该单据已作废，不能操作!");
			return;
		}

		if(cash == "")
		{
			alert("请输入收款金额");
			return;
		}
		if(taccId == ""||saccId == "")
		{
			alert("请选择收款账户");
			return;
		}
		var path = "manager/addFinTrans"
		if(!confirm('是否确定暂存？'))return;
		$("#btnsave").attr('disabled','disabled');
		$.ajax({
			url: path,
			type: "POST",
			data : {"token":"111","id":billId,"taccId":taccId,"status":0,"saccId":saccId,"transAmt":cash,"remarks":remarks,"transTimeStr":recTime},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){
					alert("暂存成功");
					$("#billNoTitle").html(json.billNo);
					$("#billId").val(json.id);
					$("#btnsave").hide();
					$("#btndraftaudit").show();
					$("#btnaudit").hide();
					editstatus = 0;
					isModify=false;
				}
			}
		});
	}

	function saveAudit(){
		//验证手机号码
		if($("#status").val()!= 0)return;
		var cash = $("#cash").val();
		var saccId = $("#saccId").val();
		var taccId = $("#taccId").val();
		var remarks = $("#remarks").val();

		var billId = $("#billId").val();
		var recTime = $("#recTime").val();
		var status = $("#status").val();
		if(status==1){
			alert("该单据已审批，不能操作！");
			return;
		}
		if(status==2){
			alert("该单据已作废，不能操作!");
			return;
		}

		if(cash == "")
		{
			alert("请输入收款金额");
			return;
		}
		if(taccId == ""||saccId == "")
		{
			alert("请选择收款账户");
			return;
		}
		var path = "manager/addFinTrans"
		if(!confirm('是否确定保存并审批？'))return;
		$("#btnsave").attr('disabled','disabled');
		$.ajax({
			url: path,
			type: "POST",
			data : {"token":"111","id":billId,"taccId":taccId,"status":1,"saccId":saccId,"transAmt":cash,"remarks":remarks,"transTimeStr":recTime},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){
					alert("提交成功");
					$("#billId").val(json.id);
					$("#status").val(1);
					$("#btndraft").hide();
					$("#btndraftaudit").hide();
					$("#btnsave").hide();
				}
			}
		});
	}


	function audit(){
		var status = $("#status").val();
		if(status==1){
			alert("该单据已审批，不能操作！");
			return;
		}
		if(status==2){
			alert("该单据已作废，不能操作!");
			return;
		}
		if(isModify){
			$.messager.alert('消息','单据已修改，请先保存!','info');
			return;
		}
		$("#btndraftaudit").attr("disabled",true);
		var id = $("#billId").val();
		if(!confirm('是否确定审批？'))return;
		$.ajax({
			url:"manager/updateFinTransAudit",
			type:"post",
			data:"billId="+id,
			success:function(json){
				if(json.state){
					alert("审批成功！");
					$("#billStatus").html("已审！");
					$("#status").val(1);
					$("#btndraft").hide();
					$("#btndraftaudit").hide();
					$("#btnsave").hide();
				}else{
					alert("操作失败" + json.msg);
					$("#btndraftaudit").attr("disabled",false);
					return;
				}
			}
		});
	}

	//显示弹出窗口
	function showWindow(title){
		$("#choiceWindow").window({
			title:title,
			top:getScrollTop()+50
		});
		$("#choiceWindow").window('open');
	}


	function makeAmtFormat(payType,amt)
	{
		if(payType == 0)
		{
			$("#lbcash").text('¥' +numeral(amt).format("0,0.00"));
		}
		if(payType == 1)
		{
			$("#lbbank").text('¥' + numeral(amt).format("0,0.00"));
		}
		if(payType == 2)
		{
			$("#lbwx").text('¥' + numeral(amt).format("0,0.00"));
		}
		if(payType == 3)
		{
			$("#lbzfb").text('¥' + numeral(amt).format("0,0.00"));
		}
		isModify=true;
	}


	function queryAccount(){
		var path = "manager/queryAccountList";
		$.ajax({
			url: path,
			type: "POST",
			data : {"token11":""},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){

					var size = json.rows.length;
					gstklist = json.rows;
					var objSelect = document.getElementById("payAccount1");
					objSelect.options.add(new Option(''),'');
					for(var i = 0;i < size; i++)
					{
						objSelect.options.add( new Option(json.rows[i].accName,json.rows[i].id));
					}
					$("#payAccount1").val($("#saccId").val());
					objSelect = document.getElementById("payAccount2");
					objSelect.options.add(new Option(''),'');
					for(var i = 0;i < size; i++)
					{
						objSelect.options.add( new Option(json.rows[i].accName,json.rows[i].id));
					}
					$("#payAccount2").val($("#taccId").val());


				}
			}
		});
	}

	$("#payAccount1").change(function(){
		var index = this.selectedIndex;
		var accId = this.options[index].value;
		$("#saccId").val(accId);
		isModify=true;
	});
	$("#payAccount2").change(function(){
		var index = this.selectedIndex;
		var accId = this.options[index].value;
		$("#taccId").val(accId);
		isModify=true;
	});
</script>
</body>
</html>
