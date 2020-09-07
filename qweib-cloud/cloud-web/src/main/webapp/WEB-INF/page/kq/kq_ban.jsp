]<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员管理</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="${base}resource/kqstyle/js/com.js" type="text/javascript"></script>
		<link href="${base}resource/kqstyle/css/style.css" rel="stylesheet" type="text/css" />
		<link href="${base}resource/kqstyle/css/pop.css" rel="stylesheet" type="text/css" />
		<style id="style1" rel="stylesheet">
		<!--
		.bgtable{
		    background-color:#000000;
		}
		.printtd{
		    background-color:#FFFFFF;
		}
		.rl_font1 {
			color: #C00000;
			font-weight: bold;
		}
		.rl_font2 { 
			font-weight: bold;
		}
		.busi_penson{
		  color : #0000FF;
		}
		.busi_bz{
		  color : black;
		}
		.not_busi{
		  color : red;
		}
			-->
	</style>    
	</head>

	<body class="easyui-layout" fit="true" onload="initPage();">
	<div data-options="region:'north'" style="height:45px">
	
	<table style="height:40px;margin-top: 1px;">	
                  <tr>
                    <th style='width:80px;' >开始日期：</th>
                    <td style='width:140px;'><label>&nbsp;<input type="text" id="sdate" style='width:130px;' class="Wdate"  onFocus="WdatePicker({isShowClear:false,readOnly:true})" value="${sdate}"  /></label></td>
                    <th style='width:80px;' >结束日期：</th>
                    <td style='width:140px;'><label>&nbsp;<input type="text" id="edate" style='width:130px;' class="Wdate"  onFocus="WdatePicker({isShowClear:false,readOnly:true})" value="${edate}"/></label></td>
                    <th style='width:120px;' >查询(姓名/手机号码):</th>
                    <td style='width:140px;'><label>&nbsp;<input name="memberNm" id="memberNm" style="width:130px;" onkeydown="queryEmpPage();"/></label></td>
                    <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a></th>
                    <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:showBan();">添加加班</a></th>
                    <td></td>
                    <th></th>
                    <td></td>
                  </tr>
                </table>
		
	         		  
		</div>
		<div data-options="region:'west',split:true,title:'部门分类树'"
			style="width:150px;padding-top: 5px;">
			<div id="divHYGL" style="overflow: auto;">
				<ul id="departtree" class="easyui-tree" fit="true"
					data-options="url:'manager/departs?depart=${depart }&dataTp=1',animate:true,dnd:false,onClick: function(node){
						queryEmpPageByBranchId(node.id);
					},onDblClick:function(node){
						$(this).tree('toggle', node.target);
					}">
				</ul>
			</div>
		</div>
		<div id="empDiv" data-options="region:'center'" >
		<div class="easyui-layout" data-options="fit:true">
		
		<div data-options="region:'west',split:true" title="员工" style="width:200px;">
		<table id="datagrid1" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/kqrule/queryKqEmpRulePage" border="false"
			rownumbers="true" fitColumns="true" pagination="false" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" data-options="onClickRow: onClickRow">
			<thead>
				<tr>
				<th field="ck" checkbox="true"></th>
				<th field="member_id" width="10" align="center" hidden="true">
					memberid
					</th>

					<th field="memberNm" width="100" align="center">
						姓名
					</th>
					
					
					
				</tr>
			</thead>
		</table>
		</div>
		<div id="classDiv" data-options="region:'center'" >
			<table id="datagrid2" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/kqban/queryKqBanPage" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
					<th field="id" width="50" align="center" hidden="true">
						id
					</th>
				    <th field="memberId" width="50" align="center" hidden="true">
						memberId
					</th>
					
					<th field="memberNm" width="100" align="center">
						姓名
					</th>
					<th field="banNm" width="100" align="center">
						加班类型
					</th>
					<th field="banDateStr" width="120" align="center" >
						加班申请日期
					</th>
					<th field="startTime" width="120" align="center">
						开始时间
					</th>	
					<th field="endTime" width="120" align="center">
						结束时间
					</th>	
					<th field="hours" width="80" align="center">
						加班小时数
					</th>					
					<th field="remarks" width="80" align="center">
						备注
					</th>	
					<th field="operator" width="80" align="center">
						操作员
					</th>					
					<th field="status" width="80" align="center" formatter="formatterSt4">
						状态
					</th>	
					
					<th field="ope" width="120" align="center" formatter="formatterSt3">
						操作
					</th>
				</tr>
			</thead>
		</table>
								
                        
		
		</div>
		
			
		</div>
		</div>
		<div id="dlg" closed="true" class="easyui-dialog" title="加班" style="width:500px;height:300px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						saveBan();
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
		</dd>
		<dd>
		<span class="title" >加班类型：</span>
		<select id="banNm" name="banNm">
			  					  <option value=""> </option>
			  					  <option value="平时加班">平时加班</option>	
			  					  <option value="周末加班">周末加班</option>	
			  					  <option value="假日加班">假日加班</option>		
			  					  <option value="任务加班">任务加班</option>	
			  					  <option value="其它1">其它1</option>	
			  					  <option value="其它2">其它2</option>	
			  					  			  
			  					</select>
			  					
	    </dd>
	    <dd>
	       			<span class="title">参考班次：</span>
	       			<select id="bc" name="bc1" onchange="changeBc(this.value)">
			  					  <option value="">请选班次</option>
			  					  	  					  
			  					</select>
	       			</dd>
	    <dd>
	     <span class="title" >开始日期：</span>
         <input type="text" name="text" id="startDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd'});" style="width: 100px;" value=""  readonly="readonly"/>
         时间：<input name="text" id="startTime"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'HH:mm'});" style="width: 100px;" value=""  readonly="readonly"/>
       </dd>  
	    <dd> 
		<span class="title" >结束时间：</span>
        <input name="text" id="endTimeStr"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'HH:mm'});" style="width: 100px;" value=""  readonly="readonly"/>
		</dd>
		<dd>
	<span class="title">备注：</span>
	       			<input class="reg_input" name="remarks1" id="remarks1"  style="width: 220px"/>
	       			</dd>
	       			
		</div>
		</div>
		
		
		<script type="text/javascript">
		var trunPageObj = null;
        var bm = null;
        var kh = null;
        
        var keyDownFlag = false;
        var kqfa1List = null;
        var selectTds = [];
        
        var beginRow = 0;
        var endRow = 0;
        var beginCol = 0;
        var endCol = 0;
			$(function(){
				 $.formValidator.initConfig();						
						
						$("#endTimeStr").formValidator({ // 验证：发送时间
				            onshow: "（必填）",
				            onfocus: "（必填）请输入下班时间 HH:mm",
				            oncorrect: "（正确）"
				        }).functionValidator({
				            fun: function (val, elem) {
				                if (!/^\d{2}:\d{2}$/.test(val)) {
				                    return "（错误）请输入下班时间";
				                }
				                return true;
				            }
				        });
					   //$("#startTime"+i).formValidator({onShow:"请输分钟",onFocus:"请输分钟"}).regexValidator({regExp:"money",dataType:"enum",onError:"时间格式不正确"});
					   //$("#endTime"+i).formValidator({onShow:"请输分钟",onFocus:"请输分钟"}).regexValidator({regExp:"money",dataType:"enum",onError:"时间格式不正确"});
					   
					
				
			});
			function queryData()
			{
				queryEmpPage();
				queryBanPage();
			}
			function queryEmpPage()
			{
				$("#datagrid1").datagrid('load',{
					url:"manager/kqrule/queryKqEmpRulePage",
							memberNm:$("#memberNm").val(),
							ruleName:$("#ruleName").val(),
							memberUse:1
					
					
				});
			}
			function initPage()
			{
				
			}
			function queryBanPage()
			{
				$("#datagrid2").datagrid('load',{
					url:"manager/kqban/queryKqBanPage",
							memberNm:$("#memberNm").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val()		
					
					
				});
			}
			
			function queryEmpPageByBranchId(branchId){
				  
				$("#datagrid1").datagrid('load',{
					url:"manager/kqrule/queryKqEmpRulePage",
							branchId:branchId,
							memberUse:1
					
					
				});
				
				$("#datagrid2").datagrid('load',{
					url:"manager/kqban/queryKqBanPage",
							branchId:branchId,
							sdate:$("#sdate").val(),
							edate:$("#edate").val()		
					
					
				});
			  
			  
			}
			
			function queryKqBanByEmpId(memberId)
			{
				$("#datagrid2").datagrid('load',{
					url:"manager/kqban/queryKqBanPage",
							memberId:memberId,
							sdate:$("#sdate").val(),
							edate:$("#edate").val()		
					
					
				});
			}
			
			function showBan()
			{
				var rows = $("#datagrid1").datagrid("getSelections");
				if(rows.length == 0)
					{
						alert("请选择要加班的员工");
						return;
					}
				$('#dlg').dialog('open');
			}
			//保存
			function saveBan(){
				var ids = "";
				var ruleId = $("#kqruleselect").val();
				var rows = $("#datagrid1").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					if(i == 0)ids = rows[i].memberId;
					
					
				}
				var jiaNm = $("#banNm").val();
				if(jiaNm == "")
					{
					alert('请选择加班类型');
					return;
					}
				var startTime = $("#startDate").val() + " " + $("#startTime").val();
				var endTime = $("#endTimeStr").val();
				var remarks = $("#remarks1").val();
				var bcId = $("#bc").val();
					var path = "manager/kqban/addKqBan";
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"memberId":ids,"banNm":jiaNm,"startTime":startTime,"endTimeStr":endTime,"remarks":remarks,"bcId":bcId},
				        dataType: 'json',
				        async : false,
				        success: function (json) {
				        	if(json.state){
				        		$("#datagrid2").datagrid("reload");
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
	
	    function onClickRow(rowIndex, rowData) { 
	    	
	    	queryKqBanByEmpId(rowData.memberId);
	    }
	    
	    
	    var gBcList ;
		function loadKqBc(){
			
			var path = "manager/bc/queryKqBcPage";
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"status":1},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		var size = json.rows.length;
		        		gBcList = json.rows;
		        		for(var i = 0;i<size;i++)
		        		$("#bc").append("<option value='"+json.rows[i].id+"'>"+json.rows[i].bcName+"</option>");  //.options.add( new Option(json.rows[i].bcName,json.rows[i].id));
		        		
		        	}
		        }
		    });
			
		}
	    
		loadKqBc();	
		
		function changeBc(bcId)
		{
			var path = "manager/kqrpt/getKqBcTimeById";
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"bcId":bcId},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		var startTime = json.startTime;
		        		var endTime = json.endTime;
		        		
		        				if(startTime!= "")$("#startTime").val(startTime);
		        		
		        				if(endTime != "")$("#endTimeStr").val(endTime);
		        			
		        	}
		        	else
		        		{
		        		
		        		}
		        }
		    });
		}
		
		
		function formatterSt4(val,row){
		      if(val==0){
		      		
		      			return "正常";
		      		} else {
		      			return "作废";
		      		}
		      		
		   } 
		
		function formatterSt3(val,row){
			if(val == 0)
			   return "<input style='width:60px;height:27px' type='button' value='作废' onclick='updateStatus("+row.id+")'/>"; 
			   else return "";
		      
		   } 
		
		function updateStatus(id)
		{
			$.messager.confirm('确认', '是否确定作废?',function(r){
				if(!r){
					return;
				
				}
			});
			
			
			var path = "manager/kqban/updateBanStatus";
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"banId":id,"status":2},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		$("#datagrid2").datagrid("reload");
		        			
		        	}
		        	else
		        		{
		        		
		        		}
		        }
		    });
		}
		</script>
	</body>
</html>
