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
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	    </style>
	</head>

	<body class="easyui-layout" fit="true">
	<div data-options="region:'west',split:true,title:'部门分类树'"
			style="width:150px;padding-top: 5px;">
			<div id="divHYGL" style="overflow: auto;">
				<ul id="departtree" class="easyui-tree" fit="true"
					data-options="url:'manager/departs?depart=${depart }&dataTp=1',animate:true,dnd:false,onClick: function(node){
						queryByBranchId(node.id);
					},onDblClick:function(node){
						$(this).tree('toggle', node.target);
					}">
				</ul>
			</div>
		</div>
		<div id="departDiv" data-options="region:'center'" >
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					
					<th field="memberNm" width="80" align="center">
						姓名
					</th>
					<th field="bcName" width="120" align="center" >
						班次
					</th>
					<th field="kqDate" width="100" align="center">
						日期
					</th>	
					<th field="tfrom1" width="150" align="center">
						开始时间
					</th>					
					<th field="dto1" width="150" align="center">
						结束时间
					</th>	
					<th field="tfrom2" width="150" align="center">
						开始时间
					</th>					
					<th field="dto2" width="150" align="center">
						结束时间
					</th>	
					<th field="kqStatus" width="80" align="center">
						考勤状态
					</th>
					<th field="remarks1" width="120" align="center" >
						备注
					</th>		

				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		考勤日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	     
		     员工姓名: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryAllData();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toProcData();">计算处理</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:showRemarks();">添加备注</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:deleteRemarks();">删除备注</a>
			<input type="hidden" id="branchId" value=""/>
		</div>
		</div>
		
		<div id="dlg" closed="true" class="easyui-dialog" title="备注" style="width:500px;height:300px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						saveRemarks();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
		<div class="box">
		<dd>
		<input type="hidden" id="memberId"  />
			<input type="hidden" id="kqDate" />
		</dd>
		<dd>
		<span class="title" >常用：</span>
		<select id="mkType" name="mkType" onchange="mkTypeChange(this)">
			  					  <option value=""> </option>
			  					  <option value="漏打卡">漏打卡</option>	
			  					  <option value="外出办事">外出办事</option>	
			  					  <option value="临时调休">临时调休</option>		
			  					  <option value="临时事假">临时事假</option>	
			  					  <option value="病假">病假</option>	
			  					  <option value="其它情况">其它情况</option>	
			  					  			  
			  					</select>
			  					
			  					
	    </dd>
	    
		<dd>
	<span class="title">备注：</span>
	       			<input class="reg_input" name="remarks1" id="remarks1"  style="width: 220px"/>
	       			</dd>
		</div>
		</div>
		
		<script type="text/javascript"><!--
		    var id="${info.datasource}";
		    var dataTp = "${dataTp}";
		    
			function mkTypeChange(sel)
			{
				$("#remarks1").val(sel.value);
			}
			
			function queryByBranchId(id)
			{
				$("#branchId").val(id);
				queryDetailPage();
			}
		    //查询商品
		    function queryAllData()
		    {
		    	$("#branchId").val(0);
		    	queryDetailPage();
		    }
			function queryDetailPage(){
		    	var aa = $("#branchId").val();		  
				
				
				$('#datagrid').datagrid({
					url:"manager/kqrpt/queryKqDetailPage",
					queryParams:{					
					memberNm:$("#memberNm").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					branchId:$("#branchId").val()
					}
					
				});
			  
			  
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryDetailPage();
				}
			}
			
			function toProcData() {
				var memberNm = $("#memberNm").val();
				var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				var branchId = $("#branchId").val();
				$.messager.confirm('确认', '计算考勤数据可能需要花费较长时间，请耐心等待？', function(r) {
					if (r) {
						$.ajax( {
							url : "manager/kqrpt/SumKqDetail",
							data : {"memberNm":memberNm,"sdate":sdate,"edate":edate,"branchId":branchId},
							type : "post",
							success : function(json) {
								if (json.state) {
									showMsg("计算成功");
									queryDetailPage();
								}else{
									showMsg("计算失败");
								} 
							}
						});
					}
				});	
				 
			}
			//添加
			function toaddrule(){
				location.href="${base}/manager/kqrule/toBaseKqRuleNew";
			}
			

		   function showRemarks()
		   {
			   var rows = $("#datagrid").datagrid("getSelections");
				if(rows.length == 0)
					{
						alert("请选择要备注的记录");
						return;
					}
				$("#memberId").val(rows[0].memberId);
				$("#kqDate").val(rows[0].kqDate);
				$('#dlg').dialog('open');
		   }
		   
		 //保存
			function saveRemarks(){
				var ids = "";
				var memberId = $("#memberId").val();
				var kqDate = $("#kqDate").val();
				var remarks = $("#remarks1").val();
				if(remarks == "")
					{
					alert('请选填写备注');
					return;
					}			
				
					var path = "manager/kqrpt/addKqRemarks";
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"memberId":memberId,"kqDate":kqDate,"remarks":remarks},
				        dataType: 'json',
				        async : false,
				        success: function (json) {
				        	if(json.state){
				        		$("#datagrid").datagrid("reload");
				        		$('#dlg').dialog('close');
				        		alert("保存成功");
				        	}
				        	else
				        		{
				        		alert("保存失败");
				        		}
				        }
				    });
				
				
			}
	
			function deleteRemarks(){
				var rows = $("#datagrid").datagrid("getSelections");
				if(rows.length == 0)
					{
						alert("请选择要备注的记录");
						return;
					}
				var memberId = rows[0].memberId;
				var kqDate = rows[0].kqDate;
						
				
					var path = "manager/kqrpt/deleteKqRemarks";
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"memberId":memberId,"kqDate":kqDate},
				        dataType: 'json',
				        async : false,
				        success: function (json) {
				        	if(json.state){
				        		$("#datagrid").datagrid("reload");
				        		$('#dlg').dialog('close');
				        		alert("保存成功");
				        	}
				        	else
				        		{
				        		alert("保存失败");
				        		}
				        }
				    });
				
				
			}
		</script>
	</body>
</html>
