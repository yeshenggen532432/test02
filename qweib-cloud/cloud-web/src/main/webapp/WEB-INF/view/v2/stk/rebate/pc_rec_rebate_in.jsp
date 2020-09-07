<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>收款单管理</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/md5.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
	
		<div class="box">
  			
  			  
  			<input  type="hidden" name="cstId" id="cstId" value="${cstId}"/> 
  			<input  type="hidden" name="billId" id="billId" value="${billId}"/> 	
  			<input  type="hidden" name="accId" id="accId" value="0"/> 	
  			    <dl id="dl">
	      			<dt class="f14 b">收款单</dt>
	      			
	        		<dd>
	        		   
	      				<span class="title">往来单位：</span>
	        			<input class="reg_input" name="cstName" id="cstName" value="${cstName}" style="width: 120px"/>
	        			<span id="memberNmTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	        		    <span class="title">剩余单据金额：</span><span style="color: red">${needRec1}</span>
	        		</dd>
	        		<dd>
	      				<span class="title" >已收款：${recAmt}</span>
	        			<span class="title" style="color:red">应收款：${needRec}</span>
	        		</dd>
	        		<dd>
	        		<span class="title">收款时间：</span>
	        		<input name="sdate" id="recTime"  onClick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 120px;" value="${recTimeStr}" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">本次收款：</span>
	        			<input class="reg_input" name="cash" id="cash" value="${needRec}"  style="width: 120px" onkeyup="makeAmtFormat(0,this.value)"/>&nbsp;<span id="lbcash">0</span>&nbsp;&nbsp;&nbsp;
	        			<input type="checkbox" id="preAmtChk" onclick="showPreAmtDic()"/><span style="font-size: 5px;color: blue">(勾选关联往来预收款单)</span>
	        		</dd>
	        		<div id="preAmtDiv" style="display: none">
	        		<dd>
	      				<span class="title">预收款单：</span>
	        			<input type="hidden" name="preId" id="preId"/>
	        			<input type="text" class="reg_input"  name="preNo" id="preNo"  readonly="readonly" placeholder="点击选择往来预收款单"  onclick="selectFinPreIn()"/>
	        			<input class="reg_input" name="preAmt" id="preAmt" placeholder="本次抵扣金额" onkeyup="checkInAmt(this)"  style="width: 80px"/>
	        			<input class="reg_input" name="oldPreAmt" id="oldPreAmt" type="hidden"/>
	        		</dd>
	        		<dd>
	      				<span class="title">实际收款金额：</span>
	        			<input class="reg_input" name="retAmt" id="retAmt" readonly="readonly" style="width: 120px"/>
	        		</dd>
	        		</div>
	        		<dd>
	      				<span class="title">收款账户：</span>
										<select name=""  id = "payAccount">
										</select>
	        		</dd>	        		
	        		<dd>
	      				<span class="title">备注：</span>
	        			<textarea rows="4" cols="50" name="remarks" id="remarks"></textarea>
	        		</dd>
	        	</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      			<%--<input type="button" value="返回" class="b_button" onclick="toback();"/> --%>
	     		</div>
	  		
		</div>
		 <div id="selectFinPreIn" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="选择预收款单" iconCls="icon-select">
      
 		 </div>
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
		    $(function(){
		    	queryAccount();
			});
			function toSubmit(){
					var cash = $("#cash").val();
					if(cash == "")
						{
						$.messager.alert('消息','请输入本次收款金额!','info');
						  return;
						}
					var preAmt = $("#preAmt").val();
					if(preAmt==""){
						preAmt = 0;
					}
					if(parseFloat(cash)<parseFloat(preAmt)){
						$.messager.alert('消息','抵扣金额不能大于本次收款金额!','info');
						return;
					}
					var needRec = ${needRec1};
					if(cash == "")cash = 0;
					//if(bank == "")bank = 0;
					//if(wx == "")wx = 0;
					//if(zfb == "")zfb = 0;
					var cstName = $("#cstName").val();
					var remarks = $("#remarks").val();
					var recTime = $("#recTime").val();
					var accId = $("#accId").val();
					var billId = $("#billId").val();
					var cstId = $("#cstId").val();
					var preId = $("#preId").val();
					var preNo = $("#preNo").val();
					if(accId == 0)
						{
						    if(parseFloat(cash)>parseFloat(preAmt)){
							$.messager.alert('消息','请选择收款账户!','info');
							return;
						    }
						}
					if(parseInt(needRec)< parseInt(cash))
					{
						$.messager.alert('消息','收款金额不能大于单据金额('+needRec+')!','info');
						return;
					}
					$.messager.confirm('确认', '是否确定保存?',function(r){
						if(r){
							var path = "manager/stkRebateIn/recRebetaIn";
							$.ajax({
						        url: path,
						        type: "POST",
						        data : {"token":"111","billId":billId,"cstId":cstId,"accId":accId,"cstName":cstName,"cash":cash,"preAmt":preAmt,"preId":preId,"preNo":preNo,"remarks":remarks,"recTimeStr":recTime},
						        dataType: 'json',
						        async : false,
						        success: function (json) {
						        	if(json.state){
						        		$("#billId").val(json.id);
						        		$.messager.alert('消息','保存成功!','info');
						        		//location.href="${base}/manager/toFinRecList";
						        		//toback();
						        		$('.l_button').attr('disabled',"true");
						        	}
						        	else
							        {
						        		$.messager.alert('消息',json.msg,'info');
							        }
						        }
						    });
				}});
				
			}
			function toback(){
				var billId = $("#billId");
				//location.href="${base}/manager/queryRecPage?dataTp=1";
				location.href="${base}/manager/toUnitRecPage?dataTp=1";
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
                calAmt(document.getElementById("preAmt"));
            }
			function queryAccount(){
				var path = "manager/queryAccountList";
				//var token = $("#tmptoken").val();
				//alert(token);
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
			        		var objSelect = document.getElementById("payAccount");
			        		objSelect.options.add(new Option(''),'');
			        		for(var i = 0;i < size; i++)
			        			{
			        				objSelect.options.add( new Option(json.rows[i].accName,json.rows[i].id));
			        			}
			        	}
			        }
			    });
			    $("#payAccount").val($("#accId").val());
			}
			
			$("#payAccount").change(function(){
				var index = this.selectedIndex;
			    var accId = this.options[index].value;
			    $("#accId").val(accId);
			});
            
			function selectFinPreIn(){
		    	$('#selectFinPreIn').dialog({
		            title: '选择预收款单',
		            iconCls:"icon-select",
		            width: 800,
		            height: 400,
		            modal: true,
		            href: "manager/toSelectFinPreInPage?proName=${cstName}",
		            onClose: function(){
		            	//window.location.href='manager/showstkoutprint?billId=' + '${billId}';
		            }
		        });
		    	$('#selectFinPreIn').dialog('open');
		    }
			function checkInAmt(oInput)
			{
				if(window.event.keyCode==37||window.event.keyCode==37){
					return;
				}
				var preId =	$("#preId").val();
				if(preId==""){
					 $.messager.alert('消息','请先选择预收款单!','info');
					 oInput.value="";
					 calAmt(document.getElementById("preAmt"));
					 return;
				}
				if('' != oInput.value.replace(/\d{1,}\.{0,1}\d{0,}/,''))
			    {
			        oInput.value = oInput.value.match(/\d{1,}\.{0,1}\d{0,}/) == null ? '' :oInput.value.match(/\d{1,}\.{0,1}\d{0,}/);
			    }
				
			    calAmt(oInput);
			}
			function calAmt(oInput){
				var preAmt = oInput.value;//抵扣款
				if(preAmt==""){
					preAmt=0;
				}
				var cash = $("#cash").val();//本次收款
				if(cash==""){
					cash=0;
				}
				var oldPreAmt = $("#oldPreAmt").val();//总抵扣款
				if(oldPreAmt==""){
					oldPreAmt=0;
				}
				if(parseFloat(oldPreAmt)<parseFloat(preAmt)){
					 $.messager.alert('消息','抵扣金额不能大于('+oldPreAmt+')!','info');
					 preAmt = 0;
					 oInput.value = "";
				}
				if(parseFloat(cash)<parseFloat(preAmt)){
					 //$.messager.alert('消息','抵扣金额不能大于本次收款金额!','info');
					 //preAmt = cash;
					 //oInput.value = cash;
				}
				var amt = parseFloat(cash)-parseFloat(preAmt);
				 $("#retAmt").val(amt.toFixed(2));
			}
			function setPreAmt(rowIndex, rowData)
		    {
				var preAmt = rowData.totalAmt-rowData.payAmt;
				$("#preAmt").val(preAmt);
				$("#oldPreAmt").val(oldPreAmt);
				$("#preId").val(rowData.id);
				$("#preNo").val(rowData.billNo);
				 calAmt(document.getElementById("preAmt"));
				$('#selectFinPreIn').dialog('close');
		    }
			function showPreAmtDic(){
				if($("#preAmtChk").is(":checked")== true){
					$("#preAmtDiv").show();
				}else{
					$("#preAmtDiv").hide();
				}
			}
		</script>
	</body>
</html>
