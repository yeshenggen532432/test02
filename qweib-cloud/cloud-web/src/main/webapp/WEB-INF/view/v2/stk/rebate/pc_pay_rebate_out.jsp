<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>进销存-返利付款单</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/md5.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
	
		<div class="box">
  			
  			  
  			<input  type="hidden" name="proId" id="proId" value="${proId}"/> 
  			<input  type="hidden" name="billId" id="billId" value="${billId}"/> 	
  			<input  type="hidden" name="accId" id="accId" value="0"/> 	
  				
  			    <dl id="dl">
	      			<dt class="f14 b">付款单</dt>
	      			
	        		<dd>
	        		   
	      				<span class="title">付款对象：</span>
	        			<input class="reg_input" name="proName" id="proName" value="${proName}" style="width: 120px" readonly="readonly"/>
	        			<span id="memberNmTip" class="onshow"></span>
	        		</dd>
	        		
	        		<dd>
	      				<span class="title" >已付款：${payAmt}</span>
	        			
	        			<span class="title" style="color:red">还应支付：${needPay}</span>
	        		</dd>
	        		
	        		<dd>
	        		<span class="title">付款时间：</span>
	        		<input name="sdate" id="recTime"  onClick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 120px;" value="${payTimeStr}" readonly="readonly"/>
	        		</dd>
	        		
	        		<dd>
	      				<span class="title">本次付款：</span>
	        			<input class="reg_input" name="cash" id="cash" value="${needPay }"  style="width: 120px" value="" onkeyup="makeAmtFormat(0,this.value)"/>
	        			<span class="title" id="lbcash">0</span>
	        			
	        		</dd>
	        		<dd>
	      				<span class="title">付款账户：</span>
	        			
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
	      			<%-- <input type="button" value="返回" class="b_button" onclick="toback();"/>--%>
	     		</div>
	  		
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
						  alert("请输入支付金额");
						  return;
						}
					var needPay = ${needPay};
					if(cash == "")cash = 0;
					var proName = $("#proName").val();
					var remarks = $("#remarks").val();
					var recTime = $("#recTime").val();
					var accId = $("#accId").val();
					var billId = $("#billId").val();
					var proId = $("#proId").val();
					if(accId == 0)
						{
							alert("请选择收款账户 ");
							return;
						}
					if(parseInt(Math.abs(needPay))< parseInt(Math.abs(cash)))
					{
						alert("收款金额不能大于应收金额");
						return;
					}
					if(!confirm('是否确定保存？'))return;
					var path = "manager/stkRebateOut/payRebetaOut";
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"token":"111","billId":billId,"proId":proId,"accId":accId,"proName":proName,"cash":cash,"remarks":remarks,"payTimeStr":recTime},
				        dataType: 'json',
				        async : false,
				        success: function (json) {
				        	if(json.state){
				        		$("#billId").val(json.id);
				        		alert("保存成功");
				        		//location.href="${base}/manager/toFinRecList";
				        		//toback();
				        		$('.l_button').attr('disabled',"true");
				        	}
				        	else
					        {
						        alert(json.msg);
					        }
				        }
				    });
				
			}
			function toback(){
				var billId = $("#billId");
				location.href="${base}/manager/queryPayPage?dataTp=1";
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
		</script>
	</body>
</html>
