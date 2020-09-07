<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body onload="initData()">
	<input type="hidden" id="accId" value="${accId}"/>
			
		
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false"
			toolbar="#tb" >
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
			<a id = "refreshBtn" class="easyui-linkbutton" iconCls="icon-fresh" plain="true" href="javascript:toFresh();">刷新</a>

			<c:if test="${permission:checkUserButtonPdm('fin.finAccount.updateResetAcc') }">
				<a id = "resetAccAmtBtn" class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toResetAccAmt();">更新账户资金</a>
			</c:if>
		</div>
		<div id="wxdlg" closed="true" class="easyui-dialog" title="微信账号" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						editWx();
					}
				},{
					text:'取消',
					handler:function(){
						$('#wxdlg').dialog('close');
					}
				}]
			">
		账号: <input name="accNo" id="accNo" value="${accNo}" style="width:120px;height: 20px;"/>
		<br/>
		<br/>
		备注: <input name="wxremarks" id="wxremarks" value="${remarks}" style="width:150px;height: 20px;"/>
		</div>
		
		<div id="zfbdlg" closed="true" class="easyui-dialog" title="支付宝账号" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						editZfb();
					}
				},{
					text:'取消',
					handler:function(){
						$('#zfbdlg').dialog('close');
					}
				}]
			">
		账号: <input name="accNo1" id="accNo1" value="${accNo}" style="width:120px;height: 20px;"/>
		<br/>
		<br/>
		备注: <input name="zfbremarks" id="zfbremarks" value="${remarks}" style="width:150px;height: 20px;"/>
		</div>
		
		<div id="bankdlg" closed="true" class="easyui-dialog" title="银行账号" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						edtBank();
					}
				},{
					text:'取消',
					handler:function(){
						$('#bankdlg').dialog('close');
					}
				}]
			">
		账号: <input name="accNo2" id="accNo2" value="${accNo}" style="width:220px;height: 20px;"/>
		<br/>
		<br/>
		
		<div style="position:relative;">
		银行: 
		<span style="margin-left:100px;width:18px;overflow:hidden;">
		<select id="bankSel" style="width:220px;margin-left:-100px" onchange="this.parentNode.nextSibling.value=this.value">
		
 		</select></span><input name="box" style="width:193px;position:absolute;left:30px;" id="bankName">
		</div>
	   
		<br/>            
		备注: <input name="bankremarks" id="bankremarks" value="${remarks}" style="width:250px;height: 20px;"/>
		</div>
		
		<script type="text/javascript">
		    var database="${database}";
		    //queryBasestorage();
		    
		    function initData()
		    {
		    	initGrid();
		    	
		    }
		    //querydata;
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'id',
							title: 'id',
							width: 100,
							align:'center',
							hidden:true				
					};
				   cols.push(col);	
				   var col = {
							field: 'accTypeName',
							title: '账号类型',
							width: 100,
							align:'center'
										
					};
				   cols.push(col);		
				   
				   
				   var col = {
							field: 'accNo',
							title: '账号',
							width: 150,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    
		    	   
		    	    
		    	    var col = {
							field: 'bankName',
							title: '其它',
							width: 120,
							align:'center'
							
											
					};
		    	    cols.push(col);
				   
		    	    var col = {
							field: 'remarks',
							title: '备注',
							width: 120,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'accAmt',
							title: '账户余额',
							width: 120,
							align:'center',
							formatter:function(value,row,index){
								return  '<u style="color:blue;cursor:pointer">'+numeral(value).format("0,0.00")+'</u>';
								 }
					};
		    	    cols.push(col);
	    	   
		    	    var col = {
							field: '_operator',
							title: '操作',
							width: 100,
							align:'center',
							formatter:formatterSt3
							
											
					};
		    	    cols.push(col);
					
	    	    $('#datagrid').datagrid({
	    	    	url:"manager/queryAccountList",
	    	    	queryParams:{
	    	    		jz:"1"
						
		    	    	
		    	    	},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	   // $('#datagrid').datagrid('reload'); 
			   }
		    
			function formatterSt3(val,row){
			     
		      	var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='showDetail("+row.id + ")'/>"
		      
	      	       ;
	      	        return ret;
		      		
		   } 
			
		function	toFresh(){
			initGrid();
		}
			function toResetAccAmt()
			{
				$.messager.confirm('确认', '您确认更新资金吗？', function(r) {
					if (r) {
						$.ajax( {
							url : "manager/updateResetBatchAccAmt",
							data : "",
							type : "post",
							success : function(json) {
								if(json.state){
									alert("操作成功！");
									initGrid();
								}else{
									alert(json.msg);
								}
							}
						});  }
				});
			}
			
		function showDetail(accId)
		{
			parent.closeWin('账户明细');
	    	parent.add('账户明细','manager/toFinAccIo?accId=' + accId);
		}
		</script>
	</body>
</html>
