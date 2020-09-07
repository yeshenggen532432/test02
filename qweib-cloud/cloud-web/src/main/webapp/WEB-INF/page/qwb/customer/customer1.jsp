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
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/customerPage?khTp=1&dataTp=${dataTp}" title="经销商列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="ck" checkbox="true"></th>
				    <th field="id" width="50" align="center" hidden="true">
						经销商id
					</th>
					<th field="khCode" width="80" align="center" >
						经销商编码
					</th>
					<th field="khNm" width="120" align="center" >
						经销商名称
					</th>
					<th field="jxsjbNm" width="80" align="center" >
						经销商级别
					</th>
					<th field="jxsflNm" width="80" align="center" >
						经销商分类
					</th>
					<th field="jxsztNm" width="80" align="center" >
						经销商状态
					</th>
					<th field="bfpcNm" width="80" align="center" >
						拜访频次
					</th>
					<th field="memberNm" width="100" align="center" >
						业务员
					</th>
					<th field="memberMobile" width="100" align="center" >
						业务员手机号
					</th>
					<th field="branchName" width="80" align="center" >
						部门
					</th>
					<th field="shZt" width="80" align="center" >
						审核状态
					</th>
					<th field="fman" width="100" align="center" >
						法人
					</th>
					<th field="ftel" width="80" align="center" >
						法人电话
					</th>
					<th field="linkman" width="100" align="center" >
						主要联系人
					</th>
					<th field="tel" width="100" align="center" >
						联系人电话
					</th>
					<th field="mobile" width="100" align="center" >
						联系人手机
					</th>
					<th field="address" width="150" align="center" >
						收货地址
					</th>
					<th field="longitude" width="120" align="center" >
						经度
					</th>
					<th field="latitude" width="120" align="center" >
						纬度
					</th>
					<th field="province" width="80" align="center" >
						省
					</th>
					<th field="city" width="80" align="center" >
						城市
					</th>
					<th field="area" width="80" align="center" >
						区县
					</th>
					<th field="jyfw" width="80" align="center" >
						经营范围
					</th>
					<th field="fgqy" width="80" align="center" >
						覆盖区域
					</th>
					<th field="nxse" width="80" align="center" >
						年销售额
					</th>
					<th field="ckmj" width="80" align="center" >
						仓库面积
					</th>
					<th field="isYx" width="80" align="center" formatter="formatterSt2">
						是否有效
					</th>
					<th field="isOpen" width="80" align="center" formatter="formatterSt3">
						是否开户
					</th>
					<th field="isDb" width="80" align="center" formatter="formatterSt4">
						经销商状态
					</th>
					<th field="openDate" width="80" align="center" >
						开户日期
					</th>
					<th field="closeDate" width="80" align="center" >
						闭户日期
					</th>
					<th field="dlqtpl" width="150" align="center" >
						代理其他品类
					</th>
					<th field="dlqtpp" width="150" align="center" >
						代理其他品牌
					</th>
					<th field="remo" width="150" align="center" >
						备注
					</th>
					<th field="createTime" width="120" align="center" >
						创建日期
					</th>
					<th field="shTime" width="120" align="center" >
						审核时间
					</th>
					<th field="shMemberNm" width="120" align="center" >
						审核人
					</th>
					<th field="erpCode" width="80" align="center" >
						ERP编码
					</th>
					<th field="py" width="80" align="center" >
						助记码
					</th>
			    </tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			经销商名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			经销商状态：<select name="isDb" id="isDb">
			               <option value="">全部</option>
			               <option value="2" selected="selected">正常</option>
			               <option value="1">倒闭</option>
			               <option value="3">可恢复</option>
			           </select>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querycustomer();">查询</a>
			<tag:permission name="添加" image="icon-add" onclick="javascript:toaddcustomer();"   buttonCode="qwb.sysCustomer2.add"></tag:permission>
			<tag:permission name="修改" image="icon-edit" onclick="javascript:getSelected();"   buttonCode="qwb.sysCustomer2.modify"></tag:permission>
			<tag:permission name="转客户" image="icon-redo" onclick="javascript:updatekhTp();"   buttonCode="qwb.sysCustomer2.changecus"></tag:permission>
			<tag:permission name="转业代" image="icon-redo" onclick="javascript:zryd();"   buttonCode="qwb.sysCustomer2.changemem"></tag:permission>
			<tag:permission name="审批" image="icon-ok" onclick="javascript:updateShZt();"   buttonCode="qwb.sysCustomer2.audit"></tag:permission>
			<tag:permission name="删除" image="icon-remove" onclick="javascript:toDel();"   buttonCode="qwb.sysCustomer2.delete"></tag:permission>
			<tag:permission name="导出" image="icon-print" onclick="javascript:myexport();"   buttonCode="qwb.sysCustomer2.export"></tag:permission>
			<tag:permission name="设置费用" image="icon-edit" onclick="javascript:setPrice();"   buttonCode="qwb.sysCustomer2.setcost"></tag:permission>
			<%-- 
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddcustomer();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:updatekhTp();">转客户</a>
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:zryd();">转业代</a>
			<a class="easyui-linkbutton" iconCls="icon-ok" plain="true" href="javascript:updateShZt();">审核</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
			<a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:setPrice();">设置费用</a>
			--%>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:setPy();">生成助记码</a>
		</div>
		<!-- 审核框-->
		<div id="xxtsdiv" class="easyui-window" style="width:340px;height:auto;padding:10px;overflow: hidden;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" title="审核">
			<table width="100%" border="0" cellspacing="2px">
			        <input type="hidden" name="idz" id="idz"/>
			        <tr>
						<td style="text-align: center;">
							<input type="radio" name="shtp" id="shtp1" value="审核通过" checked="checked"/>通过
							<input type="radio" name="shtp" id="shtp2" value="审核不通过"/>不通过
						</td>
					</tr>
					<tr>
						<td style="text-align: center;">
							</br><a class="easyui-linkbutton" href="javascript:sh();" id="regbtn">审核</a>
						</td>
					</tr>
			</table>	
		</div>
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>	
		<script type="text/javascript">
		   $(function(){
			    $("#datagrid").datagrid('load',{
						isDb:2
				});
			});
		   function formatterSt2(val,row){
				if(val=='1'){
					return "有效";
				}else{
				    return "无效";
				}
				
			}
			function formatterSt3(val,row){
				if(val=='1'){
					return "是";
				}else{
				   return "否";
				}
				
			}
		    //查询经销商
			function querycustomer(){
				$("#datagrid").datagrid('load',{
					url:"manager/customerPage?khTp=1",
					khNm:$("#khNm").val(),
					memberNm:$("#memberNm").val(),
					isDb:$("#isDb").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querycustomer();
				}
			}
			//添加
			function toaddcustomer(){
				location.href="${base}/manager/toopercustomer?khTp=1";
			}
			//修改
			function getSelected(){
			  var rows = $("#datagrid").datagrid("getSelections");
			  if(rows.length<=1){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					location.href="${base}/manager/toopercustomer?khTp=1&Id="+row.id;
				}else{
					alert("请选择要修改的行！");
				}
			  }else{
			       alert("不能选择多行");
			  }	
			}
			
			function setPrice(){
				  var rows = $("#datagrid").datagrid("getSelections");
				  if(rows.length<=1){
					var row = $('#datagrid').datagrid('getSelected');
					if (row){
						window.parent.add(row.khNm+"-设置费用","manager/customerwaretype?customerId=" + row.id);
					}else{
						alert("请选择要设置的客户！");
					}
				  }else{
				       alert("不能选择多行");
				  }	
				}

			
			
			//删除
		    function toDel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/delcustomer",
								data : "ids=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
										showMsg("删除失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要删除的数据");
				}
			}
			//转客户
		    function updatekhTp(){
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for(var i=0;i<rows.length;i++){
					ids.push(rows[i].id);
				}
				if(ids.length>0){
					if(confirm("确认要转客户吗?")){
						$.ajax({
							url:"manager/updatekhTp",
							data:"ids="+ids+"&khTp=2",
							type:"post",
							success:function(json){
								if(json=="1"){
								    alert("操作成功");
								    querycustomer();
								}else{
								    alert("操作失败");
								    return;
								}
							}
						});
					}
				}else{
					alert("请选择要转客户的数据");
				}
			}

		    function setPy(){
				
				
					if(confirm("是否生成助记码?")){
						$.ajax({
							url:"manager/updateCustomerPy",
							data:"ids=0",
							type:"post",
							success:function(json){
								if(json=="1"){
								    alert("操作成功");
								    querycustomer();
								}else{
								    alert("操作失败");
								    return;
								}
							}
						});
					}
				
			}
			//审核框
		    function updateShZt(){
		        var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for(var i=0;i<rows.length;i++){
					ids.push(rows[i].id);
				}
				if(ids.length>0){
				    $("#idz").val(ids); 
				    $("#xxtsdiv").window("open");
				}else{
					alert("请选择要审核的数据");
				}	
			}
			//审核
			function sh(){
			  var idz=$("#idz").val();
			  var isSh="";
			  var chkObjs = document.getElementsByName("shtp");
              for(var i=0;i<chkObjs.length;i++){
                    if(chkObjs[i].checked){
                        isSh = chkObjs[i].value;
                    }
              }
			  $.ajax({
					url:"manager/updateShZt",
					type:"post",
					data:"ids="+idz+"&shZt="+isSh,
					success:function(data){
						if(data=='1'){
						    alert("审核成功");
						    $("#xxtsdiv").window("close");
							querycustomer();
						}else{
							alert("审核失败");
							$("#xxtsdiv").window("close");
							querycustomer();
							return;
						}
					}
			  });
			}
			//导出
			function myexport(){
			    var khNm=$("#khNm").val();
				var memberNm=$("#memberNm").val();
				var database="${datasource}";
				var isDb=$("#isDb").val();
				if(!isDb){
				   isDb=0;
				}
				exportData('sysCustomerService','queryCustomer','com.cnlife.qwb.model.SysCustomer',"{khNm:'"+khNm+"',memberNm:'"+memberNm+"',database:'"+database+"',khTp:1,isDb:"+isDb+"}","经销商记录");
  			}
  			function formatterSt4(val,row){
		       if(val==2){
		             return "<input style='width:60px;height:27px' type='button' value='正常' onclick='updatekhIsdb(this, "+row.id+",1)'/>";
		       }else if(val==1){
		             return "<input style='width:60px;height:27px' type='button' value='倒闭' onclick='updatekhIsdb(this, "+row.id+",2)'/>";
		       }else if(val==3){
		             return "<input style='width:60px;height:27px' type='button' value='可恢复' onclick='updatekhIsdb(this, "+row.id+",2)'/>";
		       }
		   } 
		    //修改客户是否倒闭
		   function updatekhIsdb(_this,id,isDb){
				$.ajax({
					url:"manager/updatekhIsdb",
					type:"post",
					data:"id="+id+"&isDb="+isDb,
					success:function(data){
						if(data=='1'){
						    alert("操作成功");
							$('#datagrid').datagrid('reload');
						}else{
							alert("操作失败");
							return;
						}
					}
				});
		   }
		   //转业代
		   function zryd(){
		        var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for(var i=0;i<rows.length;i++){
					ids.push(rows[i].id);
				}
				if(ids.length>0){
				    document.getElementById("windowifrm").src="manager/querychoicememberzr2?ids="+ids;
				    showWindow("选择业务员");
				}else{
					alert("请选择要转让的数据");
				}	
			}
			//显示弹出窗口
			function showWindow(title){
				$("#choiceWindow").window({
					title:title,
					top:getScrollTop()+50
				});
				$("#choiceWindow").window('open');
			}
			//转业代
		   function setMember(idss,mid2){
		        var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for(var i=0;i<rows.length;i++){
					ids.push(rows[i].id);
				}
			   $.ajax({
					url:"manager/updateZryd",
					type:"post",
					data:"ids="+ids+"&Mid="+mid2,
					success:function(data){
						if(data=='1'){
						    alert("转业代成功");
							$('#datagrid').datagrid('reload');
						}else{
							alert("转业代失败");
							return;
						}
					}
				});
			   $("#choiceWindow").window('close');
		   }
		</script>
	</body>
</html>
