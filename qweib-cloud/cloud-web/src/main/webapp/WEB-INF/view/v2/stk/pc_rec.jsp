<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>驰用T3</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/md5.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/recProc" name="stkfrm" id="stkfrm" method="post">
  			  
  			<input  type="hidden" name="cstId" id="cstId" value="${cstId}"/> 
  			<input  type="hidden" name="billId" id="billId" value="${billId}"/> 	
  				
  			    <dl id="dl">
	      			<dt class="f14 b">收款单</dt>
	      			
	        		<dd>
	        		   
	      				<span class="title">收款对象：</span>
	        			<input class="reg_input" name="cstName" id="cstName" value="${cstName}" style="width: 120px"/>
	        			<span id="memberNmTip" class="onshow"></span>
	        		</dd>
	        		
	        		<dd>
	      				<span class="title" >已收款：${recAmt}</span>
	        			
	        			<span class="title" style="color:red">应收款：${needRec}</span>
	        		</dd>
	        		<dd>
	      				<span class="title">现金：</span>
	        			<input class="reg_input" name="cash" id="cash"  style="width: 120px" onkeyup="makeAmtFormat(0,this.value)"/>
	        			<span class="title" id="lbcash">0</span>
	        			
	        		</dd>
	        		<dd>
	      				<span class="title">银行转账：</span>
	        			<input class="reg_input" name="bank" id="bank"  style="width: 120px" onkeyup="makeAmtFormat(1,this.value)"/>
	        			<span class="title" id="lbbank">0</span>
	        		</dd>
	        		<dd>
	      				<span class="title">微信支付：</span>
	        			<input class="reg_input" name="wx" id="wx"  style="width: 120px" onkeyup="makeAmtFormat(2,this.value)"/>
	        			<span class="title" id="lbwx">0</span>
	        			
	        		</dd>
	        		<dd>
	      				<span class="title">支付宝：</span>
	        			<input class="reg_input" name="zfb" id="zfb"  style="width: 200px" onkeyup="makeAmtFormat(3,this.value)"/>
	        			<span class="title" id="lbzfb">0</span>
	        		</dd>
	        		<dd>
	      				<span class="title">备注：</span>
	        			<textarea rows="4" cols="50" name="remarks" id="remarks"></textarea>
	        		</dd>
	        	</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
	  		</form>
		</div>
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
			function toSubmit(){
				
					//验证手机号码
					
					var cash = $("#cash").val();
					var bank = $("#bank").val();
					var wx = $("#wx").val();
					var zfb = $("#zfb").val();
					if(cash == ""&&bank== ""&&wx==""&&zfb=="")
						{
						  alert("请输入支付金额");
						  return;
						}
					var needRec = ${needRec};
					if(cash == "")cash = 0;
					if(bank == "")bank = 0;
					if(wx == "")wx = 0;
					if(zfb == "")zfb = 0;
					
					
					if(parseFloat(needRec)< parseFloat(cash)+ parseFloat(bank) + parseFloat(wx) + parseFloat(zfb))
					{
						alert("收款金额不能大于应收金额");
						return;
					}
					$("#stkfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("收款成功");
								toback();
							}else if(data=="2"){
								alert("修改成功");
								toback();
							}else {
								alert(data);
							}
						}
					});
				
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
			
			////////////////////////////
			$('#comboxid').combobox({
                url:'manager/queryRoleList',
                method:'post',
                valueField:'idKey',
                textField:'roleNm',
                panelHeight:'auto',
                multiple:true,
                formatter: function (row) {
                    var opts = $(this).combobox('options');
                    return '<input type="checkbox" class="combobox-checkbox">' + row[opts.textField]
                },
                onLoadSuccess : function(){//在加载远程数据成功的时候触发
				    var opts = $(this).combobox("options");
				    var target = this;
				    var values = $(target).combobox("getValues");
				    $.map(values, function(value){
				        var children = $(target).combobox("panel").children();
				        $.each(children, function(index, obj){
						    if(value == obj.getAttribute("value") && obj.children && obj.children.length > 0){
						        obj.children[0].checked = true;
					            }
						});
				    });
				},
				onSelect : function(row){//在用户选择列表项的时候触发。
				    var opts = $(this).combobox("options");
				    var objCom = null;
				    var children = $(this).combobox("panel").children();
				    $.each(children, function(index, obj){
				    console.log(obj.getAttribute("value"));
				        if(row[opts.valueField] == obj.getAttribute("value")){
					    objCom = obj;
					}
				    });
				    if(objCom != null && objCom.children && objCom.children.length > 0){
				        objCom.children[0].checked = true;
				    }
				},
				onUnselect : function(row){//在用户取消选择列表项的时候触发。
				    var opts = $(this).combobox("options");
				    var objCom = null;
				    var children = $(this).combobox("panel").children();
				    $.each(children, function(index, obj){
				        if(row[opts.valueField] == obj.getAttribute("value")){
					    	objCom = obj;
						}
				    });
				    if(objCom != null && objCom.children && objCom.children.length > 0){
				        objCom.children[0].checked = false;
				    }
				}
            });

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
            
		</script>
	</body>
</html>
