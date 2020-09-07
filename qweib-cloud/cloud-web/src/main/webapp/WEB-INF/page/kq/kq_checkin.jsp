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
                    <td style='width:130px;'><label>&nbsp;<input type="text" name="memberNm" id="memberNm" style="width:120px;" onkeydown="queryEmpPage();"/></label></td>
                    <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a></th>
                    <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:showCheck();">补签</a></th>
                    <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:deleteCheckIn();">删除补签</a></th>
                    <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:chgCheckInPos();">校正考勤位置</a></th>
                    <td>&nbsp;&nbsp;注：补签或较正后需要重新计算考勤</td>
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
		<table id="datagrid1" class="easyui-datagrid" fit="true" singleSelect="true"
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
			url="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onLoadSuccess: onLoadSuccess">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
					<th field="id" width="50" align="center" hidden="true">
						id
					</th>
				    <th field="memberId" width="50" align="center" hidden="true">
						psnId
					</th>
					<th field="branchNm" width="100" align="center">
						部门
					</th>
					<th field="memberNm" width="100" align="center">
						姓名
					</th>
					<th field="cdate" width="120" align="center" formatter="dateMatter">
						工作日期
					</th>
					<th field="location" width="300" align="center">
						地址
					</th>
					<th field="stime" width="100" align="center" >
						上班时间
					</th>
					<th field="etime" width="100" align="center" >
						下班时间
					</th>	
					<th field="cdzt" width="100" align="center" >
						考勤状态
					</th>		
					<th field="picList" width="200" align="center" formatter="formatterSt">
						签到拍照
					</th>
					
				</tr>
			</thead>
		</table>
								
                        
		
		</div>
		
			
		</div>
		</div>
		<div id="dlg" closed="true" class="easyui-dialog" title="补签到" style="width:500px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						saveCheckIn();
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
		<span class="title" >类型：</span>
		<select id="checkInTp" name="tp">			  					  
			  					  <option value="1-1">上班</option>	
			  					  <option value="1-2">下班</option>				  					  		  
			  					</select>
			  					
	    </dd>
	    <dd>
	    </dd>
	    <dd>
	     <span class="title" >时间：</span>
         <input name="text" id="startTime"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${sendTime}"  readonly="readonly"/>
       </dd>  
	   <dd>
	   </dd>
		<dd>
	<span class="title">备注：</span>
	       			<input class="reg_input" name="remarks1" id="remarks1"  style="width: 220px"/>
	       			</dd>
		</div>
		</div>
		
		<div id="bigPicDiv"  class="easyui-window" title="图片" style="width:315px;top: 110px;overflow: hidden;" 
			minimizable="false" maximizable="false" modal="true"  collapsible="false" 
			 closed="true">
			  <img style="width: 300px;" id="photoImg" alt=""/>
		</div>
		
		
		<div id="dlg1" closed="true" class="easyui-dialog" title="较正" style="width:500px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						chgCheckInPos();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg1').dialog('close');
					}
				}]
			">
		<div class="box">
		<dd>
		</dd>
		<dd>
		<span class="title" >参考班次：</span>
		<select id="bcSel" name="tp" onchange="onBcSelChange(this.value);">			  					 
			  					  		  					  		  
			  					</select>
			  					
	    </dd>
	    <dd>
	    </dd>
	    <dd>
	     <span class="title" >位置：</span>
         <input name="text" id="address"    readonly="readonly"/>
       </dd>  
	   <dd>
	   </dd>
		
		</div>
		</div>
		<script type="text/javascript">
		var trunPageObj = null;
        var bm = null;
        var kh = null;
        var bcList = null;
        var keyDownFlag = false;
        var kqfa1List = null;
        var selectTds = [];
        
        var beginRow = 0;
        var endRow = 0;
        var beginCol = 0;
        var endCol = 0;
			$(function(){
				
			});
			function queryData()
			{
				queryEmpPage();
				querycheckIn();
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
				loadBc();
			}
			
			
			function queryEmpPageByBranchId(branchId){
				  
				$("#datagrid1").datagrid('load',{
					url:"manager/kqrule/queryKqEmpRulePage",
							branchId:branchId,
							memberUse:1
					
					
				});
				
				$("#datagrid2").datagrid('load',{
					url:"manager/checkInPage",
							branchId:branchId,
							atime:$("#sdate").val(),
							btime:$("#edate").val()		
					
					
				});
			  
			  
			}

			
			
			
			function showCheck()
			{
				var rows = $("#datagrid1").datagrid("getSelections");
				if(rows.length == 0)
					{
						alert("请选择要补签的员工");
						return;
					}
				$('#dlg').dialog('open');
			}
			//保存
			function saveCheckIn(){
				var ids = "";				
				var rows = $("#datagrid1").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {					
					if(i == 0)ids = rows[i].memberId;
					
					
				}
				var tp = $("#checkInTp").val();
				
				if(tp == "")
					{
					alert('请选择类型');
					return;
					}
				var checkTime = $("#startTime").val() + ':00';				
				var remarks = $("#remarks1").val();				
					var path = "manager/manuAddCheckIn";
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"psnId":ids,"tp":tp,"checkTime":checkTime,"remark":remarks},
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
			
			function deleteCheckIn(){
				var ids = "";				
				var rows = $("#datagrid2").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].cdzt!= "补签")
						{
							alert("只能删除补签记录");
							return;
						}
					if(i == 0)ids = rows[i].id;
					else ids=ids + "," + rows[i].id;
					
					
				}
				
					var path = "manager/deleteCheckIn";
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"ids":ids},
				        dataType: 'json',
				        async : false,
				        success: function (json) {
				        	if(json.state){
				        		$("#datagrid2").datagrid("reload");				        		
				        		alert("删除成功");
				        	}
				        	else
				        		{
				        		alert("删除失败");
				        		}
				        }
				    });
				
				
			}
	
	    function onClickRow(rowIndex, rowData) { 
	    	
	    	querycheckInByEmpId(rowData.memberId);
	    }
	    
	    
	    function dateMatter(val,row){
	    	var dtime=val;
	    	var dateweek = row.dateweek;
			if(dateweek==1){
				dtime+=' 星期日';
			}else if(dateweek==2){
				dtime+=' 星期一';
			}else if(dateweek==3){
				dtime+=' 星期二';
			}else if(dateweek==4){
				dtime+=' 星期三';
			}else if(dateweek==5){
				dtime+=' 星期四';
			}else if(dateweek==6){
				dtime+=' 星期五';
			}else if(dateweek==7){
				dtime+=' 星期六';
			}
			return dtime;
		}
		function onLoadSuccess(data) {
			$('#memNm').val($('#memberNm').val());
			$('#branchId2').val($('#branchId').val());
			$('#time1').val($('#atime').val());
			$('#time2').val($('#btime').val());

		}
	  //查询签到manager/checkInPage?dataTp=${dataTp }
		function querycheckIn(){
			$('#datagrid2').datagrid({
				url:"manager/checkInPage",
				queryParams:{
					memberNm:$("#memberNm").val(),
					branchId:$("#branchId").val(),
					atime:$("#sdate").val(),
					btime:$("#edate").val()
				}

			});
			/*$("#datagrid2").datagrid('load',{
				url:"manager/checkInPage",
				memberNm:$("#memberNm").val(),
				branchId:$("#branchId").val(),
				atime:$("#sdate").val(),
				btime:$("#edate").val(),
				onLoadSuccess: function (data) {
					$('#memNm').val($('#memberNm').val());
					$('#branchId2').val($('#branchId').val());
					$('#time1').val($('#atime').val());
					$('#time2').val($('#btime').val());
				}
			});*/
		}
	    
		function querycheckInByEmpId(memberId)
		{
			$("#datagrid2").datagrid('load',{
				url:"manager/checkInPage",
						psnId:memberId,
						atime:$("#sdate").val(),
						btime:$("#edate").val()		
				
				
			});
		}
		
		 function formatterSt(v,row){
		        var hl='<table>';
		        hl +='<tr>';
		        for(var i=0;i<v.length;i++){
		           if((i+1)%4==0){
		              hl +='<td>&nbsp;&nbsp;&nbsp;<a href="javascript:toBigPic(\''+v[i].pic+'\');"><img style="width: 85px;" src="${base}upload/'+v[i].picMini+'"/></a></br>&nbsp;&nbsp;&nbsp;</td>';
		              hl +='</tr>';
		              hl +='<tr>';
		           }else{
		             hl +='<td>&nbsp;&nbsp;&nbsp;<a href="javascript:toBigPic(\''+v[i].pic+'\');"><img style="width: 85px;" src="${base}upload/'+v[i].picMini+'"/></a></br>&nbsp;&nbsp;&nbsp;</td>';
		           }
		        }
		        hl +='</tr>';
			    hl +='</table>';
			    return hl;
			}
		 
		 function toBigPic(picurl){
			   document.getElementById("photoImg").setAttribute("src","${base}upload/"+picurl);
			   $("#bigPicDiv").window("open");
		   }
		 
		 function loadBc(){
				
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
			        		bcList = json.rows;
			        		for(var i = 0;i<size;i++)
			        		$("#bcSel").append("<option value='"+json.rows[i].id+"'>"+json.rows[i].bcName+"</option>");  //.options.add( new Option(json.rows[i].bcName,json.rows[i].id));
			        		if(i == 0)$("#address").val(json.rows[i].address);
			        		
			        	}
			        }
			    });
				
			}
		 
		 function onBcSelChange(bcId)
		 {
			 for(var i = 0;i<bcList.length;i++)
				 {
				 if(bcId == bcList[i].id)
					 {
					 	$("#address").val(bcList[i].address);
					 	break;
					 }
				 }
		 }
		 
		 function showChgDlg()
		 {
			 var rows = $("#datagrid2").datagrid("getSelections");
				if(rows.length == 0)
					{
						alert("请选择要较正位置的员工");
						return;
					}
				$('#dlg1').dialog('open');
		 }
		 
		//较正
		function chgCheckInPos(){
				var ids = "";				
				var rows = $("#datagrid2").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {					
					if(i == 0)ids = rows[i].id;
					
					
				}
								
						
					var path = "manager/chgCheckInPos";
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"checkId":ids},
				        dataType: 'json',
				        async : false,
				        success: function (json) {
				        	if(json.state){
				        		$("#datagrid2").datagrid("reload");
				        		$('#dlg1').dialog('close');
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
