<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>自定义关键词回复关键词</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta name="referrer" content="never">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<style type="text/css">
		</style>
	</head>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="/manager/weiXinReply/keywordPage" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=5 pageList="[5,10,20,30,40,50]" nowrap="false" toolbar="#tb"
			data-opnions=""
			 >
			<thead>
				<tr>
					<th field="checkbox" checkbox="true"></th>
					<th field="keyword" width="200" align="center">
						关键词
					</th>
					<th field="edit" width="80" align="center" formatter="editFormatter">
						编辑
					</th>
					<th field="delete" width="80" align="center" formatter="deleteFormatter">
						删除
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			关键词&nbsp(共<label id="num">${keywordReplyCount}</label>个)&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp	
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:showKeywordAddDiv();">增加关键词</a>
			<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:queryKeyword();">刷新</a>
		</div>
		<!-- 增加关键词 -->
		<div id="keywordAddDiv" class="easyui-window" style="width:480px;height:260px;padding:10px;" 
				minimizable="false" maximizable="false" collapsible="false" closed="true">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:20px;">
				<tr>
					<td align="right">关键词：</td>
					<td style="margin-top: 10px;">
						<textarea class="reg_input" name="keywordTextarea" id="keywordTextarea" style="width:200px;height:100px;"></textarea>
						<span id="keywordTextareaTip" class="onshow"></span>
					</td>
				</tr>
				<tr height="20px"></tr>
				<tr height="40px">
					<td align="center" colspan="2">
						<a class="easyui-linkbutton" href="javascript:addKeyword();">保存</a>
						<a class="easyui-linkbutton" href="javascript:hideKeywordAddDiv();">关闭</a>
					</td>
				</tr>
			</table>
		</div>
		<script type="text/javascript">	
	 		$(function(){
	 			$.formValidator.initConfig();//关键词字数验证
	 			 toValidateKeyword();//关键词字数验证
			}); 
	 		//关键词表单验证
			 function toValidateKeyword(){ 
				$("#keywordTextarea").formValidator({onShow:"1~30个字",onFocus:"1~30个字",onCorrect:"通过"}).inputValidator({min:1,max:60,onError:"1~30个字"});
			} 
	 		//编辑
			function editFormatter(index,row){
				var str_row = JSON.stringify(row);
				   return "<input style='width:60px;height:27px' type='button' value='编辑' onclick='editKeyword("+index+","+str_row+")' />";
			}
			 function deleteFormatter(val,row,index){
					   var str_row = JSON.stringify(row);
					   return "<input style='width:60px;height:27px' type='button' value='删除' onclick='deleteKeyword("+index+","+str_row+")' />"; 
				} 
			 //打开编辑页面
			 function editKeyword(index,row){
				  console.log(row.keyword);
				  var url="/manager/weiXinReply/toKeywordReplyDetail?keyword="+row.keyword;
				  window.location.href=url;
			 }
		 	//刷新查询			
			function queryKeyword(){
				  var msg=$.ajax({url:"/manager/weiXinReply/getKeywordCount",async:false});
				  $("#num").html(msg.responseText);	
				  $("#datagrid").datagrid('reload');
			  }
			
			 //删除		
			function deleteKeyword(index,row){
				$("#datagrid").datagrid('refreshRow',index);
				$.messager.confirm('提示框', '你确定要删除吗?',function(data){
					if(data){
						var keyword=row.keyword;
						var deleteKeyword_url="/manager/weiXinReply/deleteKeyword?keyword="+keyword;
						var msg=$.ajax({url:deleteKeyword_url,async:false});
						var json=$.parseJSON(msg.responseText);
						if(json.state){
							alert("删除成功!");
							queryKeyword();					
						}else{
							alert("删除失败!");					
						}
					}else{
						alert("取消删除！");
					}
				})  
			 }	
			 
			//打开增加关键词窗口
			 function showKeywordAddDiv(){
				$("#keywordAddDiv").window({title:"增加关键词",modal:true});
				$("#keywordAddDiv").window({top:100,left:$(window).width()/2-240});
				$("#keywordTextarea").val("");
				$("#keywordAddDiv").window('open');
				$("#keywordTextarea").focus();
			 }
			//关闭修改关键词窗口
			function hideKeywordAddDiv(){
				$("#keywordAddDiv").window('close');
			}
			//增加关键词
			function addKeyword(){
				if($.formValidator.pageIsValid()){
					var addKeyword_url="/manager/weiXinReply/addKeyword";
					$.ajax({
						url:addKeyword_url,
						data:{"keyword":$.trim($("#keywordTextarea").val())},
						type:"post",
						success:function(data){
							if(data=="1"){
							    alert("保存成功!");
							    hideKeywordAddDiv();	
							    queryKeyword();
							}else{
								if(data=="0"){
								    alert("保存失败!关键词已存在!");						    
								}else{
									alert("保存失败");
								}
							}
						}
				  }); 
				}
			}
			
		</script>
	</body>
</html>
