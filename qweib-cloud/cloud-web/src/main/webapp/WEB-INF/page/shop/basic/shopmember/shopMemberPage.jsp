<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员分页</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<style type="text/css">
			#weixinMsgMemberCountLabel{
				color: red;
			}
			#weixinMsgChatMemberCountLabel{
				color: red;
			}
		</style>
	</head>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/shopMember/page" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th  field="id" checkbox="true"></th>
					<th field="name" width="80" align="center" >
						会员名称
					</th>
					<th field="mobile" width="100" align="center">
						电话
					</th>
					<th field="gradeName" width="100" align="center">
						会员等级
					</th>
					<th field="customerName" width="100" align="center">
						客户
					</th>
					<th field="defaultAddress" width="200" align="center">
						地址
					</th>
					<th field="remark" width="100" align="center">
						备注
					</th>
					<th field="status" width="100" align="center" formatter="formatterStatus">
						状态
					</th>
					<th field="_oper" width="150" align="center" formatter="formatterOper">
						操作
					</th>
					<th field="shopNo" width="70" align="center" formatter="formatterShopNo">
						会员来源
					</th>
					<th field="isXxzf" width="100" align="center" formatter="formatterIsXxzf">
						线下支付
					</th>
					<th field="pic" width="60" align="center" formatter="imgFormatter">
						微信头像
					</th>
					<th field=nickname width="80" align="center" >
						微信昵称
					</th>
					<th field="sex" width="50" align="center">
						性别
					</th>
					<th field="country" width="60" align="center">
						国家
					</th>
					<th field="province" width="60" align="center">
						省份
					</th>
					<th field="city" width="60" align="center">
						城市
					</th>
					<th field="send" width="80" align="center" formatter="formatterSender">
						回复消息
					</th>
					<th field="msg" width="80" align="center" formatter="formatterMsg">
						查看消息
					</th>
					<th field="templateMsg" width="80" align="center" formatter="formatterTemplateMsg">
						模板消息
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     会员名称: <input name="name" id="name" style="width:100px;height: 20px;" />
		     手机号: <input name="mobile" id="mobile" style="width:100px;height: 20px;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
			<%--<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toadd();">添加</a> --%>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toedit();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:todel();">删除</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true"  href="javascript:openDialogUpdateSpMemGrade();">批量设置会员等级</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true"  href="javascript:openDialogUpdateXxzf();">批量设置线下支付</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:showTemplateMsgWin();">设置模板消息</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:getTemplateList();">获取模板列表</a>
			<a class="easyui-linkbutton" iconCls="icon-email" plain="false" href="javascript:checkWeixinMemberMsgAndChat();">
				未读消息<label id="weixinMsgMemberCountLabel"></label>&nbsp;聊天<label id="weixinMsgChatMemberCountLabel"></label>
			</a>
		</div>
		<div id="msgDiv" class="easyui-window" style="width:600px;height:400px;padding:10px;"
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="" id="msgFrm" method="post">
				<input  type="hidden" name="openIdKey" id="openIdKey"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">

					<tr height="20px">
					</tr>
					<tr>
						<td align="center" width="10%"></td>
						<td align="left" >
							<p>订阅消息每日只能发送1条！</p><br/>
						</td>
					</tr>
					<tr>
						<td align="center" width="10%"></td>
						<td align="left" >
							<p>客服消息需要客户在48小时内有回复才能发送！</p><br/>
						</td>
					</tr>
					<tr>
						<td align="center" width="10%"></td>
						<td align="left" >
							<p>收到客户消息后，客服消息最多只能回复20条！</p><br/>
						</td>
					</tr>
					<tr height="20px">
					</tr>
					<tr height="130px">
						<td align="center" width="10%">文本消息：</td>
						<td style="margin-top: 10px;" width="50%">
							<textarea class="reg_input" name="remo" id="remo" style="width:280px;height:130px;"></textarea>
							<span id="remoTip" class="onshow"></span>
						</td>
					</tr>
					<tr height="20px">
					</tr>
					<tr height="40px">
						<td align="center" colspan="2">
							<a class="easyui-linkbutton" href="javascript:sendTextMsg();">发送</a>
							<a class="easyui-linkbutton" href="javascript:hideMsgWin();">关闭</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="templateMsgDiv" class="easyui-window" style="width:600px;height:400px;padding:10px;"
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="" id="templateMsgFrm" method="post">
				<input  type="hidden" name="openIdKey2" id="openIdKey2"/>您所在的行业？<br /><br />
				<label><input name="industry" type="radio" value="1" checked="checked" />互联网/电子商务 </label>
				<label><input name="industry" type="radio" value="10" />餐饮 </label>
				<a class="easyui-linkbutton" href="javascript:setTemplateMsg();">设置</a>
				<a class="easyui-linkbutton" href="javascript:hideTemplateMsgWin();">关闭</a>
			</form>
		</div>

		<%--对话框：批量设置会员等级--%>
		<div id="dialogUpdateSpMemGrade" closed="true" class="easyui-dialog" title="批量设置会员等级" style="width:250px;height:130px;padding:10px;"
			 data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						<%--批量修改会员等级--%>
						batchUpdateSpMemGrade();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dialogUpdateSpMemGrade').dialog('close');
					}
				}]
			">
			<input class="easyui-combobox" name="updateSpMemGradeComb" id="updateSpMemGradeComb"
				   data-options="
					url:'manager/shopMemberGrade/list',
					method:'post',
					valueField:'id',
					textField:'gradeName',
					multiple:false,
					panelHeight:'auto'
			">
		</div>
		<%--对话框：批量设置线下支付--%>
		<div id="dialogUpdateXxzf" closed="true" class="easyui-dialog" title="批量设置线下支付" style="width:250px;height:130px;padding:10px;"
			 data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						<%--批量设置线下支付--%>
						batchUpdateXxzf();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dialogUpdateXxzf').dialog('close');
					}
				}]
			">
			<div>
				<%--<div style="display: inline-block;margin-right: 10px">--%>
					<%--<label for="isXxzf_w">无:</label>--%>
					<%--<input type="radio" name="isXxzf" value="" id="isXxzf_w">--%>
				<%--</div>--%>
				<div style="display: inline-block;margin-right: 10px">
					<label for="isXxzf_0">不显示:</label>
					<input type="radio" name="isXxzf" value="0" id="isXxzf_0">
				</div>
				<div style="display: inline-block;margin-right: 10px">
					<label for="isXxzf_1">显示:</label>
					<input type="radio" name="isXxzf" value="1" id="isXxzf_1">
				</div>
				<br>
				<span style="color: #3388FF;font-size: 10px;">备注:会员下单选择支付方式是否显示“线下支付”</span>
			</div>
		</div>

		<%--js--%>
		<script type="text/javascript">
			$(function () {
			    //未读消息人数
			    var weiXinMsgMemberCount=${weiXinMsgMemberCount};
				$("#weixinMsgMemberCountLabel").html(weiXinMsgMemberCount+"人");
            })
		    //查询会员
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopMember/page",
					   name:$("#name").val(),
					   mobile:$("#mobile").val()
				});
			}
			//添加会员
			function toadd(){
				window.location.href="${base}/manager/shopMember/add";
			}
			//修改会员
			function toedit(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
				    var id = row.id;
					window.location.href="${base}/manager/shopMember/edit?id="+id;
				}else{
					alert("请选择行");
				}
			}
			//删除会员
			function todel(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(confirm("是否要删除选中的会员?")){
						$.ajax({
							url:"manager/shopMember/delete",
							data:"id="+row.id,
							type:"post",
							success:function(json){
								if(json=="1"){
								    alert("删除成功");
								    query();
								}else{
								    alert("删除失败");
								    return;
								}
							}
						});
					}
				}
			}
			//显示会员启用状态
			function formatterStatus(val,row){
			      if(val=='-2'){
			             return "已取消关注";
			       }else if(val=='-1'){
			             return "申请中";
			       }else if(val=='0'){
			             return "未启用";
			       }else if(val=='1'){
			             return "正常";
			       }
			}

			//显示会员来源
			function formatterShopNo(val,row){
				if(val!=null && val!=undefined && val!=""){
					if(val=='9997'){
						return "app";
					}else if(val=='9999'){
						return "微信公众号";
					}else if(val=='9998'){
						return "员工";
					}else{
						return "门店";
					}
				}
			}

			//线下支付
			function formatterIsXxzf(val,row){
				console.log("val:"+val);
				var str = "";
				if(0 === val){
					str = "不显示";
				}else if(1 === val){
					str = "显示";
				}
				return str;
			}

			//操作会员启用；不启用
			function updateStatus(id,status){
					if(confirm("是否确定操作?")){
						$.ajax({
							url:"manager/shopMember/updateStatus",
							data:"id="+id+"&status="+status,
							type:"post",
							success:function(json){
								if(json=="1"){
								    alert("操作成功!");
								    query();
								}else{
								    alert("操作失败");
								    return;
								}
							}
						});
					}
			}
			//显示会员启用状态
			function formatterOper(val,row){
			    var html ="";
				if(row.status=='-2'){
		             html ="";
		        }else if(row.status=='-1'){
		             html = "<input value='通过' type='button' onclick='updateStatus("+row.id+",1)'/>";
		        }else if(row.status=='0'){
		             html = "<input value='启用' type='button' onclick='updateStatus("+row.id+",1)'/>";
		        }else if(row.status=='1'){
		             html = "<input value='不启用' type='button' onclick='updateStatus("+row.id+",0)'/>";
		        }
		        html = html + "<input value='地址列表' type='button' onclick='showAddressList("+row.id+",\""+row.name+"\")'/>";
		        return html;
			}
			//地址列表
			function showAddressList(id,name){
				parent.closeWin(name+'_地址列表');
		    	parent.add(name+'_地址列表','manager/shopMemberAddress/toPage?hyId='+id);
			}
			//打开对话框：批量设置会员等级
			function openDialogUpdateSpMemGrade(){
				var rows = $('#datagrid').datagrid('getSelections');
				var ids = "";
				for(var i=0;i<rows.length;i++){
					ids=ids+","+rows[i].wareId;
				}
				$('#updateSpMemGradeComb').combobox('setValues', []);
				$('#dialogUpdateSpMemGrade').dialog('open');
			}
			//批量设置会员等级
			function batchUpdateSpMemGrade(){
				var rows = $('#datagrid').datagrid('getSelections');
				var ids = "";
				for(var i=0;i<rows.length;i++){
					if(ids!=''){
						ids=ids+",";
					}
					ids=ids+rows[i].id;
				}
				if(ids==""){
					alert('请选择会员！');
					return;
				}
				var gradeId=$("#updateSpMemGradeComb").combobox("getValues");
				$.ajax({
					url:"manager/shopMember/batchUpdateShopMemberGrade",
					data:"ids="+ids+"&gradeId="+gradeId,
					type:"post",
					success:function(json){
						if(json!="-1"){
							$('#dialogUpdateSpMemGrade').dialog('close');
							query();
						}else{
							alert('批量修改会员等级更新失败');
						}
					}
				});

			}

			//打开对话框：批量设置线下支付
			function openDialogUpdateXxzf(){
				var rows = $('#datagrid').datagrid('getSelections');
				var ids = "";
				for(var i=0;i<rows.length;i++){
					ids=ids+","+rows[i].wareId;
				}
				if(ids==""){
					alert('请选择会员！');
					return;
				}
				$("input:radio[name=isXxzf]").attr("checked",false);//清空上次的选中
				$('#dialogUpdateXxzf').dialog('open');
			}
			//批量设置会员等级
			function batchUpdateXxzf(){
				var rows = $('#datagrid').datagrid('getSelections');
				var ids = "";
				for(var i=0;i<rows.length;i++){
					if(ids!=''){
						ids=ids+",";
					}
					ids=ids+rows[i].id;
				}
				var isXxzf=$("input[name=isXxzf]:checked").val();
				$.ajax({
					url:"manager/shopMember/batchUpdateXxzf",
					data:"ids="+ids+"&isXxzf="+isXxzf,
					type:"post",
					success:function(json){
						if(json === "1"){
							$('#dialogUpdateXxzf').dialog('close');
							query();
						}else{
							alert('批量修改线下支付失败');
						}
					}
				});

			}




			//---------------------------------微信公众号相关：开始---------------------------------------------------
			function imgFormatter(val,row){
				if(val!=""){
					 return "<input  type=\"image\" src=\""+val+"\" height=\"30\" width=\"30\" align=\"middle\" />";
				}
			}
			function formatterSender(val,row){
				if(row.openId!=""){
					 var str_row = JSON.stringify(row);
				     return "<input style='width:60px;height:27px' type='button' value='回复消息' onclick='toSend("+str_row+")' />";
				} 
			}  
		   function formatterMsg(val,row){
			   if(row.openId!=""){
				   var str_row = JSON.stringify(row);
				   return "<input style='width:60px;height:27px' type='button' value='查看消息' onclick='showTextMsg("+str_row+")' />";
			   }   
			} 
		   function formatterTemplateMsg(val,row){
			   if(row.openId!=""){
				   var str_row = JSON.stringify(row);
				   return "<input style='width:60px;height:27px' type='button' value='模板消息' onclick='sendTeplateMsg("+str_row+")' />";
			   }   
			}
		   $(function(){
				$.formValidator.initConfig();
				toformyz();
			});
			//表单验证
			 function toformyz(){
				$("#remo").formValidator({onShow:"500个字以内",onFocus:"500个字以内",onCorrect:"通过"}).inputValidator({max:1000,onError:"500个字以内"});
			} 
			 function toSend(row){
					toreset('msgFrm');
					$("#openIdKey").val(row.openId);
					showMsgWin("客服回复文本消息");
					toformyz();
				}
			   
			  function showTextMsg(row){
				   location.href="${base}/manager/toPageWeixinMemberTextMsg?openId="+row.openId+"&name="+row.name;
				}
			   
				//显示角色框
				function showMsgWin(title){
					$("#msgDiv").window({title:title,modal:true});
					$("#msgDiv").window('open');
				}
				function hideMsgWin(){
					$("#msgDiv").window('close');
					$('#datagrid').datagrid('reload');
				}
				//发送文本消息
				function sendTextMsg(){
					if ($.formValidator.pageIsValid()==true){
						var textMsg=$("#remo").val();
						var textMsg_url="/manager/sendCustomerTextMsg?sendTextMsg=1"+"&textMsg="+textMsg+"&openId="+$("#openIdKey").val();
						var msg=$.ajax({url:textMsg_url,async:false});
						var json=$.parseJSON(msg.responseText);
						if(json.errcode==0){
							alert("回复成功!");
						}else{
							if(json.errcode==45047){
								alert("回复失败! 已经发送20条消息！ 客户应答后才可以再发送消息！ ");
							}else{
								alert("回复失败!"+" json.errcode:"+json.errcode+" ,json.errmsg:"+json.errmsg);
							}
							
						}
					}
					hideMsgWin();
				}
				
				//发送模板消息
				function sendTeplateMsg(row){
						var teplateMsgMsg_url="/manager/sendTeplateMsg?sendTemplateMsg=1&openId="+row.openId;
						var msg=$.ajax({url:teplateMsgMsg_url,type:"post",async:false});
						var json=$.parseJSON(msg.responseText);
						if(json.errcode==0){
							alert("发送模板消息成功!");
						}else{
							alert("发送模板消息失败!"+" json.errcode:"+json.errcode+" ,json.errmsg:"+json.errmsg);
						}
					}
				//显示设置模板消息框
				function showTemplateMsgWin(){
					$("#templateMsgDiv").window({title:"设置模板",modal:true});
					$("#templateMsgDiv").window('open');
				}
				function hideTemplateMsgWin(){
					$("#templateMsgDiv").window('close');
				}
				//设置模板消息
				function setTemplateMsg(){
					 var val=$('input:radio[name="industry"]:checked').val();
					 var json="{\"industry_id1\":"+"\""+val+"\""+"}";
					 var templateMsg_url="/manager/setTemplateMsg";
					 var msg=$.ajax({url:templateMsg_url,data:"weixinTemplateMsgSetIndustry="+json,type:"post",async:false});	
					 var json=$.parseJSON(msg.responseText);
						if(json.errcode==0){
							alert("设置成功!");
						}else{
							if(json.errcode==43100){
								alert("设置失败! 1个月只能设置1次您所在的行业！ ");
							}else{
								alert("设置失败!"+" json.errcode:"+json.errcode+" ,json.errmsg:"+json.errmsg);
							}
						}
				}
				//获取模板消息的模板列表
				function getTemplateList(){
					 var getTemplateList_url="/manager/getTemplateList";
					 var msg=$.ajax({url:getTemplateList_url,data:"getTemplateList",type:"get",async:false});
					 alert(msg.responseText);var json=$.parseJSON(msg.responseText);
						if(json.template_list!=""){
							alert("获取模板列表成功!");
						}else{
							alert("没有添加消息模板!");
						}
				}
				//查看未读会员消息
			function  checkWeixinMemberMsgAndChat() {
                location.href="${base}/manager/toCheckWeixinMemberMsgAndChatPage";
               /* var checkIsCustmerServiceChatToMember_url="/manager/checkIsCustmerServiceChatToMember";
                var msg=$.ajax({url:checkIsCustmerServiceChatToMember_url,async:false});
                var json=$.parseJSON(msg.responseText);
               if(json.state==("1")){
                   alert("客服 "+json.userName+" 回复会员中，请稍后查看未读会员消息!");
               }
                if(json.state==("0")){
                    location.href="${base}/manager/toCheckWeixinMemberMsgAndChatPage";
                }
                if(json.state==("-1")){
                    alert("查询是否已经有客服与会员聊天出错!");
                }*/
            }

			//---------------------------------微信公众号相关：结束---------------------------------------------------
				
				
		</script>
	</body>
</html>
