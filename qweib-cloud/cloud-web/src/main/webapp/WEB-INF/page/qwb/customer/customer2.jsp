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
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script type="text/javascript" src="resource/dtree.js"></script>
	</head>

	<body onload="onload">
		<table id="datagrid"  fit="true" singleSelect="false"
			 iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="
				onLoadSuccess:onLoadSuccess
			">
			<thead>
				<tr>
				    <th field="ck" checkbox="true"></th>
				    <th field="id" width="50" align="center" hidden="true">
						客户id
					</th>
					<th field="khCode" width="80" align="center" >
						客户编码
					</th>
					<th field="khNm" width="120" align="center" >
						客户名称
					</th>
					<th field="linkman" width="100" align="center" >
						负责人
					</th>
					<th field="tel" width="120" align="center" >
						负责人电话
					</th>
					<th field="mobile" width="120" align="center" >
						负责人手机
					</th>
					<%--老版本不支持认证手机号
					<th field="rzMobile" width="128" align="center" formatter="formatRzMobile">
						<span onclick="javascript:editRzMobile();">认证手机✎</span>
					</th>--%>
					<th field="address" width="275" align="center" >
						地址
					</th>
					<th field="qdtpNm" width="80" align="center" >
						客户类型
					</th>
					<th field="khdjNm" width="80" align="center" >
						客户等级
					</th>
					<th field="bfpcNm" width="80" align="center" >
						拜访频次
					</th>
					<th field="xsjdNm" width="80" align="center" >
						销售阶段
					</th>
					<th field="sctpNm" width="80" align="center" >
						市场类型
					</th>
					<th field="hzfsNm" width="80" align="center" >
						合作方式
					</th>
					<th field="regionNm" width="100" align="center" >
						客户归属片区
					</th>
					<th field="shZt" width="80" align="center" >
						审核状态
					</th>
					<th field="uscCode" width="120" align="center" >
						社会信用统一代码
					</th>
					<th field="memberNm" width="120" align="center" >
						业务员
					</th>
					<th field="memberMobile" width="120" align="center" >
						业务员手机号
					</th>
					<th field="branchName" width="80" align="center" >
						部门
					</th>
					<th field="ghtpNm" width="80" align="center" >
						供货类型
					</th>
					<th field="pkhCode" width="80" align="center" >
						供货经销商编码
					</th>
					<th field="pkhNm" width="120" align="center" >
						供货经销商
					</th>
					<th field="jyfw" width="80" align="center" >
						销售区域
					</th>
					<th field="fgqy" width="80" align="center" >
						覆盖区域
					</th>
					<th field="longitude" width="100" align="center" >
						经度
					</th>
					<th field="latitude" width="100" align="center" >
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
					<th field="openDate" width="80" align="center" >
						开户日期
					</th>
					<th field="closeDate" width="80" align="center" >
						闭户日期
					</th>
					<th field="isYx" width="80" align="center" formatter="formatterSt2">
						是否有效
					</th>
					<th field="isDb" width="80" align="center" formatter="formatterSt3">
						客户状态
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
			客户类型： <select name="qdtpNm" id="qdtpNm" style="width: 125px;" ></select>
		    客户等级: <select name="khdjNm" id="khdjNm">
	                  <option value="">全部</option>
	                  <c:forEach items="${list}" var="list">
						<option value="${list.khdjNm}">${list.khdjNm}</option>
					  </c:forEach>
	               </select>
			客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			无业务员客户 <input type="checkbox" id="nullStaff"/>
			客户状态：<select name="isDb" id="isDb">
			               <option value="">全部</option>
			               <option value="2" selected="selected">正常</option>
			               <option value="1">倒闭</option>
			               <option value="3">可恢复</option>
			           </select>
			合作方式：<select name="hzfsNm" id="hzfsNm" style="width: 125px;">
	        		              <option value="">全部</option>
			        			 <c:forEach items="${hzfsls}" var="hzfsls">
			        			  <option value="${hzfsls.hzfsNm}" <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
			        			 </c:forEach>
			        		   </select>
			客户所属片区: <input name="regionNm" id="regionNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querycustomer();">查询</a>
			<tag:permission name="添加" image="icon-add" onclick="javascript:toaddcustomer();"   buttonCode="qwb.sysCustomer.add"></tag:permission>
			<tag:permission name="修改" image="icon-edit" onclick="javascript:getSelected();"   buttonCode="qwb.sysCustomer.modify"></tag:permission>
			<tag:permission name="转经销商" image="icon-redo" onclick="javascript:updatekhTp();"   buttonCode="qwb.sysCustomer.changejx"></tag:permission>
			<tag:permission name="转业代" image="icon-redo" onclick="javascript:zryd();"   buttonCode="qwb.sysCustomer.changemem"></tag:permission>
			<tag:permission name="审批" image="icon-ok" onclick="javascript:updateShZt();"   buttonCode="qwb.sysCustomer.audit"></tag:permission>
			<tag:permission name="删除" image="icon-remove" onclick="javascript:toDel();"   buttonCode="qwb.sysCustomer.delete"></tag:permission>
			<%--<tag:permission name="下载模板" image="icon-redo" onclick="javascript:toCustomerModel();"   buttonCode="qwb.sysCustomer.download"></tag:permission>
			<tag:permission name="上传客户" image="icon-edit" onclick="javascript:toUpCustomer();"   buttonCode="qwb.sysCustomer.upload"></tag:permission>--%>
			<tag:permission name="导出" image="icon-print" onclick="javascript:myexport();"   buttonCode="qwb.sysCustomer.export"></tag:permission>
			<tag:permission name="设置费用" image="icon-edit" onclick="javascript:setPrice();"   buttonCode="qwb.sysCustomer.setcost"></tag:permission>
			<%--
			<tag:permission name="设置自定义费用" image="icon-edit" onclick="javascript:setAutoPrice();"   buttonCode="qwb.sysCustomer.setautocost"></tag:permission>
	    	--%>
	    	<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:setPy();">生成助记码</a>
	    	<tag:permission name="批量调整客户信息" image="icon-edit" onclick="javascript:updateCustomerType();"   buttonCode="qwb.sysCustomer.batchcustype"></tag:permission>
			<%--
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddcustomer();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:updatekhTp();">转经销商</a>
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:zryd();">转业代</a>
			<a class="easyui-linkbutton" iconCls="icon-ok" plain="true" href="javascript:updateShZt();">审核</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toCustomerModel();">下载模板</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toUpCustomer();">上传客户</a>
			<a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:setPrice();">设置费用</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:setAutoPrice();">设置自定义费用</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:setPy();">生成助记码</a>
			<a href="javascript:updateCustomerType()">批量调整客户类别</a>
			--%>
		</div>
		<!-- 上传框 -->
		<div class="file-box">
		  	<form action="manager/uploadtemp" name="uploadfrm" id="uploadfrm" method="post" enctype="multipart/form-data">
		  		<input type="hidden" name="width" value="${width}"/>
				<input type="hidden" name="height" value="${height}"/>
				<input type="button" class="uploadBtn" value="上传客户" />
				<input type="file" name="upFile" id="upFile" onchange="toUpCustomer(this);" class="uploadFile"/>
		  	</form>
	  	</div>
  	    <div id="upDiv" class="easyui-window" style="width:500px;height:100px;padding:10px;"
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/toUpCustomerExcel" id="upFrm" method="post" enctype="multipart/form-data">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr height="30px">
						<td >选择文件：</td>
						<td>
						<input type="file" name="upFile" id="upFile" title="check"/>
						</td>
						<td><input type="button" onclick="toUpCustomerExcel();" style="width: 50px" value="上传" /></td>
					</tr>
				</table>
			</form>
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
		<div id="dlg" closed="true" class="easyui-dialog" title="客户类别" style="width:350px;height:330px;padding:10px"
			data-options="
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						batchUpdateCustomerType();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
			<div class="box">
			<input type= "hidden" id="pageNo" value="${page}" />
			<dd></dd>
			客户类型:<tag:select name="customerType" id="customerType" displayValue="qdtp_nm" headerKey="" headerValue="不修改" width="120px" displayKey="id" tableName="sys_qdtype"></tag:select>
			</dd>
			<dd>
			 客户等级: <select name="khdjNm" id="khdjNm1">
	                  <option value="">不修改</option>
	                  <c:forEach items="${list}" var="list">
						<option value="${list.khdjNm}">${list.khdjNm}</option>
					  </c:forEach>
	               </select>
	        </dd>
	        <dd>
	        	合作方式：<select name="hzfsNm" id="hzfsNm1" style="width: 125px;">
	        		              <option value="">不修改</option>
			        			 <c:forEach items="${hzfsls}" var="hzfsls">
			        			  <option value="${hzfsls.hzfsNm}" <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
			        			 </c:forEach>
			        		   </select>
	        </dd>
	        <dd>
	        	客户状态：<select name="isDb" id="isDb1">
	        				<option value="0"  selected="selected">不修改</option>
			               <option value="2">正常</option>
			               <option value="1">倒闭</option>
			               <option value="3">可恢复</option>
			           </select>
	        </dd>
			<dd>
				客户归属片区：
				<select id="regioncomb" class="easyui-combotree" style="width:200px;"
						data-options="url:'manager/sysRegions',animate:true,dnd:true,onClick: function(node){
							setRegion(node.id);
							}"></select>
				<input type="hidden" name="regionId" id="regionId" value="${customer.regionId}"/>
			</dd>
			</div>

	</div>
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;"
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<input type="hidden" id="dataTp" value="${dataTp}"/>
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>

		</div>
		<div id="editdlg" closed="true" class="easyui-dialog" maximized="true" title="编辑" style="width:600px;height:500px;padding:10px">
			<iframe  name="editfrm" id="editfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">

		    $(function(){

			   /* $("#datagrid").datagrid('load',{
						isDb:2
				});
			    gFlag = 1;*/
			    $('#datagrid').datagrid({
					url:"manager/customerPage",
					queryParams:{
						khTp:2,
						dataTp:$("#dataTp").val(),
						isDb:2
					}

				});
			    //url="manager/customerPage?khTp=2&dataTp=${dataTp }"
			    //alert($('#datagrid').datagrid('options').total);
			    $('#datagrid').datagrid('options').pageNumber = $("#pageNo").val();
			    //$('#datagrid').datagrid('options').num = $("#pageNo").val();
			    $("#datagrid").datagrid('reload');
			    /*pager.pagination('select',$("#pageNo").val());*/
			    //$('#datagrid').pagination('select', $("#pageNo").val());

			});
		    function onLoadSuccess(data)
			{



			}
		    function onload()
		    {

		    }
		    function formatterSt2(val,row){
				if(val=='1'){
					return "有效";
				}else{
				    return "无效";
				}
			}
		    //查询经销商
			function querycustomer(){
		    	var nullStaff = 0;
				if(document.getElementById("nullStaff").checked)nullStaff = 1;
				$("#datagrid").datagrid('load',{
					url:"manager/customerPage?khTp=2",
					khNm:$("#khNm").val(),
					qdtpNm:$("#qdtpNm").val(),
					khdjNm:$("#khdjNm").val(),
					memberNm:$("#memberNm").val(),
					isDb:$("#isDb").val(),
					hzfsNm:$("#hzfsNm").val(),
					regionNm:$("#regionNm").val(),
					nullStaff:nullStaff
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
				//$('#datagrid').pagination('select', $("#pageNo").val());
				//$(".datagrid-pager pagination").pagination('select',2);
				//var pager = $('#datagrid').datagrid('getPager');
				//pager.pagination('select',2);
				//location.href="${base}/manager/toopercustomer?khTp=2&page=" + $('#datagrid').datagrid('options').pageNumber;
				document.getElementById("editfrm").src="${base}/manager/toopercustomer?khTp=2";
				$('#editdlg').dialog('open');
				//$('#datagrid').datagrid('options').pageNumber = 2;
			    //$("#datagrid").datagrid('reload');
			    //$('#datagrid').datagrid('reload',{pageindex:2});
				//alert($('#datagrid').datagrid('options').pageNumber);
				//parent.closeWin('客户资料编辑');
		    	//parent.add('客户资料编辑','manager/toopercustomer?khTp=2');
			}
			//修改
			function getSelected(){
			  var rows = $("#datagrid").datagrid("getSelections");
			  if(rows.length<=1){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					var page = $('#datagrid').datagrid('options').pageNumber;
					//location.href="${base}/manager/toopercustomer?khTp=2&Id="+row.id+ "&page=" + page;
					document.getElementById("editfrm").src="${base}/manager/toopercustomer?khTp=2&Id="+row.id;
					$('#editdlg').dialog('open');
					//parent.closeWin('客户资料编辑');
			    	//parent.add('客户资料编辑','manager/toopercustomer?khTp=2&Id='+row.id);
				}else{
					alert("请选择要修改的行！");
				}
			  }else{
			       alert("不能选择多行");
			  }
			}
			function reloadCustomer()
			{
				$("#datagrid").datagrid("reload");
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
			//转经销商
		    function updatekhTp(){
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for(var i=0;i<rows.length;i++){
					ids.push(rows[i].id);
				}
				if(ids.length>0){
					if(confirm("确认要转经销商吗?")){
						$.ajax({
							url:"manager/updatekhTp",
							data:"ids="+ids+"&khTp=1",
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
					alert("请选择要转经销商的数据");
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
				var nullStaff = 0;
				if(document.getElementById("nullStaff").checked)nullStaff = 1;
				exportData('sysCustomerService','queryCustomer2','com.qweib.cloud.core.domain.SysCustomer',"{khNm:'"+khNm+"',memberNm:'"+memberNm+"',database:'"+database+"',khTp:2,isDb:"+isDb+"," + "nullStaff:" + nullStaff +"}","客户记录");
  			}
  			function formatterSt3(val,row){
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
		   //下载模板
		    function toCustomerModel() {
                  if(confirm("是否下载客户上传需要的文档?")){
					window.location.href="manager/toCustomerModel";
				}
           }
           //显示上传框
			function toUpCustomer(){
				$("#upDiv").window({title:'上传',modal:true});
				$("#upDiv").window('open');
			}
			//上传文件
			function toUpCustomerExcel(){
			       $("#upFrm").form('submit',{
					success:function(data){
						if(data=='1'){
							alert("上传成功");
							$("#upDiv").window('close');
							window.location.href="${base}/manager/querycustomer2";
						}else {
							alert(data);
						}
						onclose();
					},
					onSubmit:function(){
						DIVAlert("<img src='resource/images/loading.gif' width='50px' height='50px'/>");
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
			function setAutoPrice(){
				  var rows = $("#datagrid").datagrid("getSelections");
				  if(rows.length<=1){
					var row = $('#datagrid').datagrid('getSelected');
					if (row){
						window.parent.add(row.khNm+"-设置自定义费用","manager/autopricecustomerwaretype?customerId=" + row.id);
					}else{
						alert("请选择要设置的客户！");
					}
				  }else{
				       alert("不能选择多行");
				  }
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
		   //获取客户类别
		function arealist1(){
				$.ajax({
					url:"manager/queryarealist1",
					type:"post",
					success:function(data){
						if(data){
						   var list = data.list1;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						      if(list[i].qdtpNm!=''){
						        if(list[i].qdtpNm==qdtpNm){
						          img +='<option value="'+list[i].qdtpNm+'" selected="selected">'+list[i].qdtpNm+'</option>';
						        }else{
						           img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
						        }
						       }
						    }
						   $("#qdtpNm").html(img);
						 }
					}
				});
			}
			arealist1();
			function updateCustomerType(){
				$("#customerType").val('');
				$('#dlg').dialog('open');
			}

			function batchUpdateCustomerType(){
				var rows = $('#datagrid').datagrid('getSelections');
				var ids = "";
				for(var i=0;i<rows.length;i++){
					if(ids!=''){
						ids=ids+",";
					}
					ids=ids+rows[i].id;
				}
				if(ids==""){
					$.messager.alert('Warning','请选择客户！');
					return;
				}
				var customerTypeId=$("#customerType").val();
				var hzfsNm = $("#hzfsNm1").val();
				var khdjNm = $("#khdjNm1").val();
				var isDb = $("#isDb1").val();
				var regionId = $("#regionId").val();
				if(customerTypeId==""&&hzfsNm== ""&&khdjNm==""&&isDb== "0"&&regionId==""){
					$.messager.alert('Warning','致少选择一项修改内容');
					return;
				}
				var customerType = "";
				if(customerTypeId!= "")
				customerType =$("#customerType").find("option:selected").text();

				$.messager.confirm('Confirm','是否确定更改客户类别?',function(r){
				    if (r){
				    	$.ajax({
							url:"manager/batchUpdateCustomerType",
							data:"ids="+ids+"&customerType="+customerType + "&hzfsNm=" + hzfsNm + "&khdjNm=" + khdjNm + "&isDb=" + isDb+"&regionId="+regionId,
							type:"post",
							success:function(json){
								$("#regionId").val("");
								$('#regioncomb').combotree('setValue', '');
								if(json!="-1"){
								    //alert("更新成功");
								    $('#dlg').dialog('close');
								    querycustomer();
								}else{
									$.messager.alert('Error','客户类别更新失败！');
								    return;
								}
							}
						});
				    }
				});

			}
			function setRegion(regionId){
				$("#regionId").val(regionId);
			}

			//------------------手机认证相关：start--------------------
			function formatRzMobile(val,row){
				var rzMobile = row.rzMobile;
				var text="修改";
				if(rzMobile == null || rzMobile == undefined || rzMobile === ''){
					rzMobile = "";
					text="认证";
				}
				return "<input type='text' style='display:none;width:75px' size='11' name='rzMobileInput' id='rzMobileInput"+row.id+"' value='" + rzMobile + "' maxlength='11'/>" +
						"<button style='display:none;width:35px;height:20px;font-size:12px;margin-left:5px' name='rzMobileButton' id='rzMobileButton"+row.id+"' data-oldMobile='"+rzMobile+"' onclick='javaScript:rzMobile("+row.id+",this);'>"+text+"</button>" +
						"<span name='rzMobileSpan' id='rzMobileSpan"+row.id+"'>" + rzMobile + "</span>";
			}
			var k1 = true;
			function editRzMobile() {
				var rzMobileInput = document.getElementsByName("rzMobileInput");
				var rzMobileButton = document.getElementsByName("rzMobileButton");
				var rzMobileSpan = document.getElementsByName("rzMobileSpan");
				//获取当前页的数据
				var rows = $('#datagrid').datagrid('getRows');
				for (var i = 0; i < rzMobileInput.length; i++) {
					var row = rows[i];
					if (k1) {
						var rzMobile = row.rzMobile;
						//if(rzMobile==null || rzMobile == undefined || rzMobile ==''){
							rzMobileInput[i].style.display = '';
							rzMobileButton[i].style.display = '';
							rzMobileSpan[i].style.display = 'none';
						//}
					} else {
						rzMobileInput[i].style.display = 'none';
						rzMobileButton[i].style.display = 'none';
						rzMobileSpan[i].style.display = '';
					}
				}
				k1 = !k1;
			}

			/*function rzMobile(cid,oldMobile){
				var rzMobile = $("#rzMobileInput"+cid).val();
				$.ajax({
					url: "manager/updateCustomerByRzMobile",
					type: "post",
					data:{
						"id":cid,
						"rzMobile":rzMobile,
						"oldMobile":oldMobile
					},
					success: function (data) {
						//1.认证成功；2.该手机号已认证过；3.该手机号已在客户管理中认证过
						if (data == '1') {
							//刷新当前页
							$("#datagrid").datagrid("reload");
							alert("认证成功");
						}else if(data == '2') {
							alert("该手机号已认证过");
						}else if(data == '3') {
							alert("该手机号已在客户管理中认证过");
						}else{
							alert("操作失败");
						}
					}
				});
			}*/

			function rzMobile(cid,th){
				var rzMobile = $("#rzMobileInput"+cid).val();
				var oldMobile=$(th).attr("data-oldMobile");
				if((rzMobile==null || rzMobile==undefined) || rzMobile.length!=11){
					alert("请填写11位手机号！");
					return false;
				}
				if(rzMobile==oldMobile){
					alert("新认证手机号与原有手机号相同！");
					return false;
				}
				$.messager.confirm("确认", "确认此操作吗？", function (r) {
					if (r) {
						$.ajax({
							url: "manager/updateCustomerByRzMobile",
							type: "post",
							data:{
								"id":cid,
								"rzMobile":rzMobile,
								"oldMobile":oldMobile
							},
							success: function (data) {
							    alert(data);
							    if(data=='操作成功')
                                	$(th).attr("data-oldMobile",rzMobile);
								//1.认证成功；2.该手机号已认证过；3.该手机号已在客户管理中认证过
								/*if (data == '1') {
									//刷新当前页
									$("#datagrid").datagrid("reload");
									alert("认证成功");
								}else if(data == '2') {
									alert("该手机号已认证过");
								}else if(data == '3') {
									alert("该手机号已在客户管理中认证过");
								}else{
									alert("操作失败");
								}*/
							}
						});
						return true;
					}
				});
				return false;
			}
			//------------------手机认证相关：end--------------------

		</script>
	</body>
</html>
