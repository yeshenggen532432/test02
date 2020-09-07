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
                    
                    <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryDate();">查询</a></th>
                    <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-remove" href="javascript:cancelSelect();">清空选择</a></th>
                    <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-remove" href="javascript:deletePb();">删除排班</a></th>
                    <td>&nbsp;&nbsp;注：如果有分配规则班和排班，则以排班为准</td>
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
			<table width="100%" height="100%" border="0"  align="left"  cellpadding="0" cellspacing="0" class="commTab car_set" >
			                <tr>
							<td align="center" valign="top" style="height: 30px" >
							<table id="dataTable"  border="0" style='font-size:12px;' cellspacing="1" width="100%" cellpadding="1" bgcolor="#000000" align="center">
							 
							<tr>
							<td height="30" bgcolor="#C0C0C0" style='text-align:center;'><span class="rl_font1">星期日</span></td>
							<td bgcolor="#C0C0C0" style='text-align:center;'><span class="rl_font2">星期一</span></td>
							<td bgcolor="#C0C0C0" style='text-align:center;'><span class="rl_font2">星期二</span></td>
							<td bgcolor="#C0C0C0" style='text-align:center;'><span class="rl_font2">星期三</span></td>
							<td bgcolor="#C0C0C0" style='text-align:center;'><span class="rl_font2">星期四</span></td>
							<td bgcolor="#C0C0C0" style='text-align:center;'><span class="rl_font2">星期五</span></td>
							<td bgcolor="#C0C0C0" style='text-align:center;'><span class="rl_font1">星期六</span></td> 
							</tr>
							</table> 
							<div style="margin-bottom: 20px;background-color: green;"></div>
							</td>
							</tr>
							<tr  onclick = "event.cancelBubble = true;" >
							<td align="center" valign="top" >
							 
								<table id="dataTable" class='tablefixed' border="0" style='font-size:12px;' cellspacing="1" width="100%" cellpadding="1" bgcolor="#000000" align="center" >
								<tr>
								<td height="30" bgcolor="#C0C0C0" style='text-align:center;'><span id='span_0' class="rl_font1"></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_1'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_2'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_3'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_4'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_5'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_6' class="rl_font1"></span></td> 
								</tr>
							   <tr onclick = "event.cancelBubble = true;" >
								<td  height="30" bgcolor="#ffffff" id='td_1_1' idx="0"  onmousedown=" keyDown(1,1);" onmouseup=" keyUp(1,1);" style='text-align:center;' onmouseover=" tableMove(1,1)"><div id='div_0' onclick='showTip(0)'></div></td>
								<td bgcolor="#ffffff" id='td_1_2' idx="1"  onmousedown=" keyDown(1,2);" onmouseup=" keyUp(1,2);" style='text-align:center;' onclick='showTip(1)' onmouseover=" tableMove(1,2)"><div id='div_1'></div></td>
								<td bgcolor="#ffffff" id='td_1_3' idx="2" onmousedown=" keyDown(1,3);" onmouseup=" keyUp(1,3);" style='text-align:center;' onclick='showTip(2)' onmouseover=" tableMove(1,3)"><div id='div_2'></div></td>
								<td bgcolor="#ffffff" id='td_1_4' idx="3" onmousedown=" keyDown(1,4);" onmouseup=" keyUp(1,4);" style='text-align:center;' onclick='showTip(3)' onmouseover=" tableMove(1,4)"><div id='div_3'></div></td>
								<td  bgcolor="#ffffff" id='td_1_5' idx="4"  onmousedown=" keyDown(1,5);" onmouseup=" keyUp(1,5);" style='text-align:center;' onclick='showTip(4)' onmouseover=" tableMove(1,5)"><div id='div_4'></div></td>
								<td bgcolor="#ffffff" id='td_1_6' idx="5" onmousedown=" keyDown(1,6);" onmouseup=" keyUp(1,6);" style='text-align:center;' onclick='showTip(5)' onmouseover=" tableMove(1,6)"><div id='div_5'></div></td> 
								<td bgcolor="#ffffff" id='td_1_7' idx="6" onmousedown=" keyDown(1,7);" onmouseup=" keyUp(1,7);" style='text-align:center;' onclick='showTip(6)' onmouseover=" tableMove(1,7)"><div id='div_6'></div></td>
								</tr>
								<tr>
								<td  height="30" bgcolor="#C0C0C0" style='text-align:center;'><span id='span_7' class="rl_font1"></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_8'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_9'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_10'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_11'></span></td>
								<td  bgcolor="#C0C0C0" style='text-align:center;'><span id='span_12'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_13' class="rl_font1"></span></td> 
								</tr>
								  <tr onclick = "event.cancelBubble = true;">
								<td  height="30" bgcolor="#ffffff" id='td_2_1' idx="7" onmousedown=" keyDown(2,1);" onmouseup=" keyUp(2,1);" style='text-align:center;' onmouseover=" tableMove(2,1)" onclick='showTip(7)'><div id='div_7'></div></td>
								<td bgcolor="#ffffff" id='td_2_2' idx="8" onmousedown=" keyDown(2,2);" onmouseup=" keyUp(2,2);" style='text-align:center;' onmouseover=" tableMove(2,2)" onclick='showTip(8)'><div id='div_8'></div></td>
								<td bgcolor="#ffffff" id='td_2_3' idx="9" onmousedown=" keyDown(2,3);" onmouseup=" keyUp(2,3);"  style='text-align:center;' onmouseover=" tableMove(2,3)" onclick='showTip(9)'><div id='div_9'></div></td>
								<td bgcolor="#ffffff" id='td_2_4' idx="10" onmousedown=" keyDown(2,4);" onmouseup=" keyUp(2,4);"  style='text-align:center;' onmouseover=" tableMove(2,4)" onclick='showTip(10)'><div id='div_10'></div></td>
								<td bgcolor="#ffffff" id='td_2_5' idx="11" onmousedown=" keyDown(2,5);" onmouseup=" keyUp(2,5);"  style='text-align:center;' onmouseover=" tableMove(2,5)" onclick='showTip(11)'><div id='div_11'></div></td>
								<td  bgcolor="#ffffff" id='td_2_6' idx="12"  onmousedown=" keyDown(2,6);" onmouseup=" keyUp(2,6);" style='text-align:center;' onmouseover=" tableMove(2,6)" onclick='showTip(12)'><div id='div_12'></div></td>
								<td bgcolor="#ffffff" id='td_2_7' idx="13" onmousedown=" keyDown(2,7);" onmouseup=" keyUp(2,7);" style='text-align:center;' onmouseover=" tableMove(2,7)" onclick='showTip(13)'><div id='div_13'></div></td> 
								</tr>
								<tr>
								<td  height="30" bgcolor="#C0C0C0" style='text-align:center;'><span id='span_14' class="rl_font1"></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_15'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_16'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_17'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_18'></span></td>
								<td  bgcolor="#C0C0C0" style='text-align:center;'><span id='span_19'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_20' class="rl_font1"></span></td> 
								</tr>
								  <tr  onclick = "event.cancelBubble = true;">
								<td  height="30" bgcolor="#ffffff" id='td_3_1' idx="14" onmousedown=" keyDown(3,1);" onmouseup=" keyUp(3,1);" onmouseover=" tableMove(3,1)" style='text-align:center;'><div id='div_14' onclick='showTip(14)'></div></td>
								<td bgcolor="#ffffff" id='td_3_2' idx="15" onmousedown=" keyDown(3,2);" onmouseup=" keyUp(3,2);" style='text-align:center;' onmouseover=" tableMove(3,2)"><div id='div_15' onclick='showTip(15)'></div></td>
								<td bgcolor="#ffffff" id='td_3_3' idx="16" onmousedown=" keyDown(3,3);" onmouseup=" keyUp(3,3);" style='text-align:center;' onmouseover=" tableMove(3,3)"><div id='div_16' onclick='showTip(16)'></div></td>
								<td bgcolor="#ffffff" id='td_3_4' idx="17" onmousedown=" keyDown(3,4);" onmouseup=" keyUp(3,4);" style='text-align:center;' onmouseover=" tableMove(3,4)"><div id='div_17' onclick='showTip(17)'></div></td>
								<td bgcolor="#ffffff" id='td_3_5' idx="18" onmousedown=" keyDown(3,5);" onmouseup=" keyUp(3,5);" style='text-align:center;' onmouseover=" tableMove(3,5)"><div id='div_18' onclick='showTip(18)'></div></td>
								<td  bgcolor="#ffffff" id='td_3_6' idx="19" onmousedown=" keyDown(3,6);" onmouseup=" keyUp(3,6);" style='text-align:center;' onmouseover=" tableMove(3,6)"><div id='div_19' onclick='showTip(19)'></div></td>
								<td bgcolor="#ffffff" id='td_3_7' idx="20" onmousedown=" keyDown(3,7);" onmouseup=" keyUp(3,7);" style='text-align:center;' onmouseover=" tableMove(3,7)"><div id='div_20' onclick='showTip(20)'></div></td> 
								</tr>
								<tr>
								<td  height="30" bgcolor="#C0C0C0" style='text-align:center;'><span id='span_21' class="rl_font1"></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_22'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_23'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_24'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_25'></span></td>
								<td  bgcolor="#C0C0C0" style='text-align:center;'><span id='span_26'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_27' class="rl_font1"></span></td> 
								</tr>
								  <tr onclick = "event.cancelBubble = true;">
								<td  height="30" bgcolor="#ffffff" id='td_4_1' idx="21" onmousedown=" keyDown(4,1);" onmouseup=" keyUp(4,1);" style='text-align:center;' onmouseover=" tableMove(4,1)"><div id='div_21' onclick='showTip(21)'></div></td>
								<td bgcolor="#ffffff" id='td_4_2' idx="22" onmousedown=" keyDown(4,2);" onmouseup=" keyUp(4,2);"  style='text-align:center;' onmouseover=" tableMove(4,2)"><div id='div_22' onclick='showTip(22)'></div></td>
								<td bgcolor="#ffffff" id='td_4_3' idx="23" onmousedown=" keyDown(4,3);" onmouseup=" keyUp(4,3);"  style='text-align:center;' onmouseover=" tableMove(4,3)"><div id='div_23' onclick='showTip(23)'></div></td>
								<td bgcolor="#ffffff" id='td_4_4' idx="24" onmousedown=" keyDown(4,4);" onmouseup=" keyUp(4,4);" style='text-align:center;' onmouseover=" tableMove(4,4)"><div id='div_24' onclick='showTip(24)'></div></td>
								<td bgcolor="#ffffff"  id='td_4_5' idx="25" onmousedown=" keyDown(4,5);" onmouseup=" keyUp(4,5);" style='text-align:center;' onmouseover=" tableMove(4,5)"><div id='div_25' onclick='showTip(25)'></div></td>
								<td  bgcolor="#ffffff" id='td_4_6' idx="26" onmousedown=" keyDown(4,6);" onmouseup=" keyUp(4,6);" style='text-align:center;' onmouseover=" tableMove(4,6)"><div id='div_26' onclick='showTip(26)'></div></td>
								<td bgcolor="#ffffff" id='td_4_7' idx="27" onmousedown=" keyDown(4,7);" onmouseup=" keyUp(4,7);" style='text-align:center;' onmouseover=" tableMove(4,7)"><div id='div_27' onclick='showTip(27)'></div></td> 
								</tr>
								<tr>
								<td  height="30" bgcolor="#C0C0C0" style='text-align:center;'><span id='span_28' class="rl_font1"></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_29'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_30'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_31'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_32'></span></td>
								<td  bgcolor="#C0C0C0" style='text-align:center;'><span id='span_33'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_34' class="rl_font1"></span></td> 
								</tr>
								  <tr onclick = "event.cancelBubble = true;">
								<td  height="30" bgcolor="#ffffff"  id='td_5_1' idx="28" onmousedown=" keyDown(5,1);" onmouseup=" keyUp(5,1);" style='text-align:center;' onmouseover=" tableMove(5,1)"><div id='div_28' onclick='showTip(28)'></div></td>
								<td bgcolor="#ffffff" id='td_5_2' idx="29" onmousedown=" keyDown(5,2);" onmouseup=" keyUp(5,2);" style='text-align:center;' onmouseover=" tableMove(5,2)"><div id='div_29' onclick='showTip(29)'></div></td>
								<td bgcolor="#ffffff" id='td_5_3' idx="30" onmousedown=" keyDown(5,3);" onmouseup=" keyUp(5,3);" style='text-align:center;' onmouseover=" tableMove(5,3)"><div id='div_30' onclick='showTip(30)'></div></td>
								<td bgcolor="#ffffff" id='td_5_4' idx="31" onmousedown=" keyDown(5,4);" onmouseup=" keyUp(5,4);" style='text-align:center;' onmouseover=" tableMove(5,4)"><div id='div_31' onclick='showTip(31)'></div></td>
								<td bgcolor="#ffffff" id='td_5_5' idx="32" onmousedown=" keyDown(5,5);" onmouseup=" keyUp(5,5);" style='text-align:center;' onmouseover=" tableMove(5,5)"><div id='div_32' onclick='showTip(32)'></div></td>
								<td  bgcolor="#ffffff" id='td_5_6' idx="33" onmousedown=" keyDown(5,6);" onmouseup=" keyUp(5,6);" style='text-align:center;' onmouseover=" tableMove(5,6)"><div id='div_33' onclick='showTip(33)'></div></td>
								<td bgcolor="#ffffff" id='td_5_7' idx="34" onmousedown=" keyDown(5,7);" onmouseup=" keyUp(5,7);" style='text-align:center;' onmouseover=" tableMove(5,7)"><div id='div_34' onclick='showTip(34)'></div></td> 
								</tr>
								<tr>
								<td  height="30" bgcolor="#C0C0C0" style='text-align:center;'><span id='span_35' class="rl_font1"></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_36'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_37'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_38'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_39'></span></td>
								<td  bgcolor="#C0C0C0" style='text-align:center;'><span id='span_40'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_41' class="rl_font1"></span></td> 
								</tr>
								  <tr onclick = "event.cancelBubble = true;">
								<td  height="30" bgcolor="#ffffff" id='td_6_1' idx="35" onmousedown=" keyDown(6,1);" onmouseup=" keyUp(6,1);" style='text-align:center;' onmouseover=" tableMove(6,1)"><div id='div_35' onclick='showTip(35)'></div></td>
								<td bgcolor="#ffffff" id='td_6_2' idx="36" onmousedown=" keyDown(6,2);" onmouseup=" keyUp(6,2);" style='text-align:center;' onmouseover=" tableMove(6,2)"><div id='div_36' onclick='showTip(36)'></div></td>
								<td bgcolor="#ffffff" id='td_6_3' idx="37" onmousedown=" keyDown(6,3);" onmouseup=" keyUp(6,3);" style='text-align:center;' onmouseover=" tableMove(6,3)"><div id='div_37' onclick='showTip(37)'></div></td>
								<td bgcolor="#ffffff" id='td_6_4' idx="38" onmousedown=" keyDown(6,4);" onmouseup=" keyUp(6,4);" style='text-align:center;' onmouseover=" tableMove(6,4)"><div id='div_38' onclick='showTip(38)'></div></td>
								<td bgcolor="#ffffff" id='td_6_5' idx="39" onmousedown=" keyDown(6,5);" onmouseup=" keyUp(6,5);" style='text-align:center;' onmouseover=" tableMove(6,5)"><div id='div_39' onclick='showTip(39)'></div></td>
								<td  bgcolor="#ffffff" id='td_6_6' idx="40" onmousedown=" keyDown(6,6);" onmouseup=" keyUp(6,6);" style='text-align:center;' onmouseover=" tableMove(6,6)"><div id='div_40' onclick='showTip(40)'></div></td>
								<td bgcolor="#ffffff" id='td_6_7' idx="41" onmousedown=" keyDown(6,7);" onmouseup=" keyUp(6,7);" style='text-align:center;' onmouseover=" tableMove(6,7)"><div id='div_41' onclick='showTip(41)'></div></td> 
								</tr>
								<tr>
								<td  height="30" bgcolor="#C0C0C0" style='text-align:center;'><span id='span_42' class="rl_font1"></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_43'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_44'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_45'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_46'></span></td>
								<td  bgcolor="#C0C0C0" style='text-align:center;'><span id='span_47'></span></td>
								<td bgcolor="#C0C0C0" style='text-align:center;'><span id='span_48' class="rl_font1"></span></td> 
								</tr>
								  <tr onclick = "event.cancelBubble = true;">
								<td  height="30" bgcolor="#ffffff" id='td_7_1' idx="42" onmousedown="keyDown(7,1);" onmouseup="keyUp(7,1);" style='text-align:center;' onmouseover="tableMove(7,1)"><div id='div_42' onclick='showTip(42)'></div></td>
								<td bgcolor="#ffffff" id='td_7_2' idx="43" onmousedown="keyDown(7,2);" onmouseup="keyUp(7,2);" style='text-align:center;' onmouseover="tableMove(7,2)"><div id='div_43' onclick='showTip(43)'></div></td>
								<td bgcolor="#ffffff" id='td_7_3' idx="44" onmousedown="keyDown(7,3);" onmouseup="keyUp(7,3);" style='text-align:center;' onmouseover="tableMove(7,3)"><div id='div_44' onclick='showTip(44)'></div></td>
								<td bgcolor="#ffffff" id='td_7_4' idx="45" onmousedown="keyDown(7,4);" onmouseup="keyUp(7,4);" style='text-align:center;' onmouseover="tableMove(7,4)"><div id='div_45' onclick='showTip(45)'></div></td>
								<td bgcolor="#ffffff" id='td_7_5' idx="46" onmousedown="keyDown(7,5);" onmouseup="keyUp(7,5);" style='text-align:center;' onmouseover="tableMove(7,5)"><div id='div_46' onclick='showTip(46)'></div></td>
								<td  bgcolor="#ffffff" id='td_7_6' idx="47" onmousedown="keyDown(7,6);" onmouseup="keyUp(7,6);" style='text-align:center;' onmouseover="tableMove(7,6)"><div id='div_47' onclick='showTip(47)'></div></td>
								<td bgcolor="#ffffff" id='td_7_7' idx="48" onmousedown="keyDown(7,7);" onmouseup="keyUp(7,7);" style='text-align:center;' onmouseover="tableMove(7,7)"><div id='div_48' onclick='showTip(48)'></div></td> 
								</tr>
								  
								 
								</table> 
								
								</td>
								</tr>
								</table>
                        
		
		</div>
		<div id="tb" style="padding:5px;height:auto">
		    查询(姓名/手机号码): <input name="memberNm" id="memberNm" style="width:156px;height: 20px;" onkeydown="queryEmpPage();"/>
		       规则名称: <input name="ruleName" id="ruleName" style="width:156px;height: 20px;" onkeydown="queryEmpPage();"/>
			<input type="hidden" name="branchId" id="branchId" value="${branchId}"/>	
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryEmpPage();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:ruleclick();">分配规则</a>
		</div>
			
		</div>
		</div>
		<div id="dlg" closed="true" class="easyui-dialog" title="请选择考勤规则" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						saveemprule();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
		考勤规则: <select id="kqruleselect" name="kqruleselect">
			  					  <option value="0">请选择规则</option>
			  					  <option value="0">不分配</option>			  					  
			  					</select>
	        	
		
		
		
		</div>
		<div id="div3" style="display:none;background-color:beige;width:250;height:50" onclick = "event.cancelBubble = true;">    
		</div>  
		<div id="div2" style="display:none;background-color:green" >     
		<h4 color="blue">
			<div style="height:180px;width:98%;_width:100%;overflow-y:auto;overflow-x:auto;">
		                        <table class="commTab car_set_tab pre_tab">
		                          <tbody id='bcsd1_list'>
								  </tbody>
		                        </table>
		     </div>
		</h4>  
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
				loadKqRule();
			});
			
			function showTip(index){    
				var div3 = document.getElementById('div3'); //将要弹出的层    
				div3.style.display="block"; //div3初始状态是不可见的，设置可为可见    
				//window.event代表事件状态，如事件发生的元素，键盘状态，鼠标位置和鼠标按钮状.    
				//clientX是鼠标指针位置相对于窗口客户区域的 x 坐标，其中客户区域不包括窗口自身的控件和滚动条。    
				div3.style.left=event.clientX+10; //鼠标目前在X轴上的位置，加10是为了向右边移动10个px方便看到内容    
				div3.style.top=event.clientY+5;    
				div3.style.position="absolute"; //必须指定这个属性，否则div3层无法跟着鼠标动    
				var div2 =document.getElementById('div2');    
				div3.innerHTML=div2.innerHTML;    
				$("#txt_rq").attr("value",$("#span_"+index).html());
				$("#txt_index").attr("value",index);
		    }    
		    //关闭层div3的显示    
		    function closeTip(){    
				var div3 = document.getElementById('div3');    
				div3.style.display="none";    
			}    
			
			function ruleclick()
			{
				var rows = $("#datagrid").datagrid("getSelections");
				if(rows.length == 0)
					{
					alert("请选择要分配的员工");
					return;
					}
				$('#dlg').dialog('open');
			}
			
			function queryEmpPageByBranchId(branchId){
				  
				$("#datagrid1").datagrid('load',{
					url:"manager/kqrule/queryKqEmpRulePage",
							branchId:branchId,
							memberUse:1
					
					
				});
			  
			  
			}
			function loadKqRule(){
				
				var path = "manager/kqrule/queryKqRulePage";
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"status":1},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		var size = json.rows.length;			        		
			        		for(var i = 0;i<size;i++)
			        		$("#kqruleselect").append("<option value='"+json.rows[i].id+"'>"+json.rows[i].ruleName+"</option>");  //.options.add( new Option(json.rows[i].bcName,json.rows[i].id));
			        		
			        	}
			        }
			    });
				
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
			
			//保存
			function saveemprule(){
				var ids = "";
				var ruleId = $("#kqruleselect").val();
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					if(i == 0)ids = rows[i].memberId;
					else ids = ids + "," + rows[i].memberId;
					
				}
				if (ids.length > 0) {
					var path = "manager/kqrule/saveEmpKqRule";
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"ids":ids,"ruleId":ruleId},
				        dataType: 'json',
				        async : false,
				        success: function (json) {
				        	if(json.state){
				        		$("#datagrid").datagrid("reload");
				        		$('#dlg').dialog('close');
				        		
				        	}
				        	else
				        		{
				        		alert("保存失败");
				        		}
				        }
				    });
				}
				
			}
			
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
			        		var fileList = [];
			        		fileList.push("<tr class='table_td_font' style='CURSOR: pointer;' ondblclick=\"submitPb(this,'-1','-')\" onclick=\"submitPb(this,'-1','-')\" bgColor='#ffffff'>");
							fileList.push("<td align='left'  height='25px'>不排班</td>");
							fileList.push("</tr>");
			        		fileList.push("<tr class='table_td_font' style='CURSOR: pointer;' ondblclick=\"submitPb(this,'0','休')\" onclick=\"submitPb(this,'0','休')\" bgColor='#ffffff'>");
							fileList.push("<td align='left'  height='25px'>休</td>");
							fileList.push("</tr>");
			        		
			        		if(json.rows.length > 0){
								$(json.rows).each(function(i) {
									fileList.push("<tr class='table_td_font' style='CURSOR: pointer;' ondblclick=\"submitPb(this,'"+isNullValue(json.rows[i].id)+"','"+isNullValue(json.rows[i].bcName) + "')\" onclick=\"submitPb(this,'"+isNullValue(json.rows[i].id)+"','"+isNullValue(json.rows[i].bcName) + "')\" bgColor='#ffffff'>");
									fileList.push("<td align='left'  height='25px'>"+isNullValue(json.rows[i].bcName)+"</td>");
									fileList.push("</tr>");
								});
							}
			        		$("#bcsd1_list").html(fileList.join(""));
			        		
			        	}
			        }
			    });
				
			}
			
			function initPage()
			{
				queryDate();
				loadKqBc();
			}
			
			function initDate(){
				   for(var i = 0;i<55;i++){
				      $("#span_"+i).html("");
				   }
				   for(var i = 0;i<55;i++){
				      $("#div_"+i).html("");
				   }
				   var beginDateStr = $("#sdate").val() + "";
				   var endDateStr = $("#edate").val() +"";
				   var beginDate = new Date(beginDateStr.replace(/\-/g, "/"));
				   var endDate = new Date(endDateStr.replace(/\-/g, "/"));
				   var beginDay = beginDate.getDate();
				   var endDay = endDate.getDate();
				   var days = dateDiff(endDate,beginDate);
				   var beginWeek = beginDate.getDay();
				   for(var i = 0;i<=days;i++){
				       if(i == 0){
				       	 $("#span_"+beginWeek).html(beginDate.format("yyyy-MM-dd"));
				       }else{
				         $("#span_"+beginWeek).html(beginDate);
				       }
				       var objDate = addDays(beginDate,1);
				       beginDate = objDate.dateString;
				       beginWeek ++ ;
				   }
				}	
			
			function initDiv(){
				   var beginDateStr = $("#sdate").val() + "";
				   var endDateStr = $("#edate").val() + "";
				   var beginDate = new Date(beginDateStr.replace(/\-/g, "/"));
				   var endDate = new Date(endDateStr.replace(/\-/g, "/"));
				   var beginDay = beginDate.getDate();
				   var endDay = endDate.getDate();
				   var days = dateDiff(endDate,beginDate);
				   var beginWeek = beginDate.getDay();
				   for(var i = 0;i<=days;i++){
				       $("#div_"+beginWeek).html("未排班");
				       document.getElementById("div_"+beginWeek).className = "busi_bz";
				       var objDate = addDays(beginDate,1);
				       beginDate = objDate.dateString;
				       beginWeek ++ ;
				   }
				}
			function queryDate(){
				    var beginDate = $("#sdate").val();
				    var endDate = $("#edate").val();
				    var days = dateDiff(endDate,beginDate);
			        if(days < 0){
			           alert("结束日期必须要大于开始日期");
			           parent.document.getElementById("txt_endDate").focus();
			           return;
			        }
			        if(days > 40){
			           alert("排班的日期间隔只能为40天");
			           parent.document.getElementById("txt_endDate").focus();
			           return;
			        }
				    initDate();
					initDiv();
				}
			
		function initSelectTd(){
				 this.selectTds = [];
			 }
		
		function initSelectTdColor(){
	    	for(var i = 0;i<this.selectTds.length;i++){
	    		var tdObj = this.selectTds[i];
	    		tdObj.style.backgroundColor = "#ffffff";
	    	}
	    }
		function tableMove(row,col){
	    	if(this.keyDownFlag){
	    		this.endRow = row;
	        	this.endCol = col;
	        	this.selectArea();
	    	}
	    	
	    }
		function keyDown(row,col){
	    	this.beginRow = row;
	    	this.beginCol = col;
	    	this.keyDownFlag = true;
	    }
		function keyUp(row,col){
	    	this.endRow = row;
	    	this.endCol = col;
	    	this.keyDownFlag = false;
	    	
	    	this.selectArea();
	    	if(this.selectTds != null && this.selectTds.length > 0){
	    		var td = document.getElementById("td_"+row+"_"+col);
				 var index = $(td).attr("idx");
				 showTip(index);
	    		
	    	}
	    }
	    /**
	     * 选择区域
	     * */
	     function selectArea(){
	    	var beginRow = this.beginRow;
	    	var beginCol = this.beginCol;
	    	
	    	var endRow = this.endRow;
	    	var endCol = this.endCol;
	    	var area = {};
	    	for(var i = 1;i<=5;i++){
	    		var areaList = [];
	    		for(var j = 1;j<=7;j++){
	    			areaList.push(j);
	    		}
	    		area[i] = areaList;
	    	}
	    	
	    	//计算中间TD
	    	//首先找出另外两点
	    	var row2 = beginRow;
	    	var col2 = endCol;
	    	
	    	
	    	var row3 = endRow;
	    	var col3 = beginCol;
	    	
	    	var diffRow = endRow - beginRow;
	    	var diffCol = endCol - beginCol;
	    	
	    	
	    	var brow = beginRow;
	    	var erow = endRow;
	    	if(beginRow > endRow){
	    		brow = endRow;
	    		erow = beginRow;
	    	}
	    	
	    	var bcol = beginCol;
	    	var ecol = endCol;
	    	if(beginCol > endCol){
	    		bcol = endCol;
	    		ecol = beginCol;
	    	}
	    	var tdIdPres = [];
	    	//循环遍历
	    	for(var row = brow;row<=erow;row++){
	    		for(var col = bcol;col<=ecol;col++){
	    			var tdIdPre = row+"_"+col;
	    			tdIdPres.push(tdIdPre);
	    		}
	    	}
	    	if(tdIdPres.length > 0){
	    		for(var i = 0;i<tdIdPres.length;i++){
	    			var idpre = tdIdPres[i];
	    			var td = document.getElementById("td_"+idpre);
	    			if(td){
	    				tableJS.setTdClickColor2(td);
	    				var exist = false;
	    				if(this.selectTds != null && this.selectTds.length > 0){
	    					for(var j = 0 ;j<this.selectTds.length;j++){
	    						var sysTd = this.selectTds[j];
	    						if(sysTd == td){
	    							exist = true;
	    							break;
	    						}
	    					}
	    				}
	    				if(!exist){
	    					this.selectTds.push(td);
	    				}
	    				
	    				//console.log("td.attr:"+$(td).attr("idx"));
	    			}
	    		}
	    	}
	    	  
	    }
		
	    
	    function submitPb(obj,bcId,bcName)
	    {
	    	var rqStr = "";
	        if(this.selectTds != null && this.selectTds.length > 0){
	        	for(var i = 0;i<this.selectTds.length;i++){
	        		var td = this.selectTds[i];
	        		var index = $(td).attr("idx");
	        		var rq1 = $("#span_"+index).html();
	        		if(rq1 != ""){
	        			rqStr += rq1;
		        		if(i < this.selectTds.length - 1){
		        			rqStr += ",";
		        		}
	        		}
	        		
	        	}
	    	}
	        if(rqStr == "")
	        	{
	        		alert("请选择排班的日期");
	        		return;
	        	}
	        var ids = "";
	        var memberId = 0;
			var rows = $("#datagrid1").datagrid("getSelections");
			for ( var i = 0; i < rows.length; i++) {
				if(i == 0)ids = rows[i].memberId;
				else ids = ids + "," + rows[i].memberId;
				if(i == 0)memberId = rows[i].memberId;
			}
			if(memberId == 0)
				{
				alert("请选择员工");
				return;
				}
			$.ajax( {
				url : "manager/kqpb/saveBatKqPb",
				data : "dateStr=" + rqStr+"&empStr=" + ids + "&bcId=" + bcId,
				type : "post",
				success : function(json) {
					if (json.state) {
						closeTip();
						showMsg("排班成功");
						initSelectTdColor();
    			        initSelectTd();
						var sdate = $("#sdate").val();
						var edate = $("#edate").val();
						showPb(memberId,sdate,edate);
						//$("#datagrid").datagrid("reload");
					}else{
						showMsg("保存失败");
					} 
				}
			});
	    }
	    
	    function showPb(memberId,sdate,edate)
	    {
	    	$.ajax( {
				url : "manager/kqpb/queryKqPbPage",
				data : "sdate=" + sdate+"&edate=" + edate + "&memberId=" + memberId,
				type : "post",
				success : function(json) {
					if (json.state) {
						
						var dataList = json.rows;
						   var beginDateStr = $("#sdate").val();
						   var endDateStr = $("#edate").val();
						   var beginDate = new Date(beginDateStr.replace(/\-/g, "/"));
						   var endDate = new Date(endDateStr.replace(/\-/g, "/"));
						   var beginWeek = beginDate.getDay();
						   for(var i = 0;i<dataList.length;i++){
						        var rq = dataList[i].bcDate;
						        var rqDate = new Date(rq.replace(/\-/g, "/"));
						        var days = dateDiff(rqDate,beginDate);
						        var divId = parseInt(days) + parseInt(beginWeek);
						        $("#div_"+divId).html(dataList[i].bcName);
						        var className = "busi_penson";
						        if(dataList[i].bcName == "休"){
						            className = "not_busi";
						        }
						        if(dataList[i].bcName == "未排班"){
						            className = "busi_bz";
						        }
						        document.getElementById("div_"+divId).className = className;
						   }
					}else{
						showMsg("保存失败");
					} 
				}
			});
	    }
	    
	    function deletePb()
	    {
	    	var sdate = $("#sdate").val();
	    	var edate = $("#edate").val();
	        var ids = "";
	        var memberId = 0;
			var rows = $("#datagrid1").datagrid("getSelections");
			for ( var i = 0; i < rows.length; i++) {
				if(i == 0)ids = rows[i].memberId;
				else ids = ids + "," + rows[i].memberId;
				if(i == 0)memberId = rows[i].memberId;
			}
			if(memberId == 0)
				{
				alert("请选择员工");
				return;
				}
			$.ajax( {
				url : "manager/kqpb/deleteKqPb",
				data : "ids=" + ids+"&sdate=" + sdate + "&edate=" + edate,
				type : "post",
				success : function(json) {
					if (json.state) {						
						showMsg("删除成功");
						initSelectTdColor();
    			        initSelectTd();	
    			        initDiv();
						showPb(memberId,sdate,edate);
						//$("#datagrid").datagrid("reload");
					}else{
						showMsg("删除失败");
					} 
				}
			});
	    }
	    
	    function onClickRow(rowIndex, rowData) { 
	    	var sdate = $("#sdate").val();
			var edate = $("#edate").val();
			initDiv();
	    	showPb(rowData.memberId,sdate,edate);
	    	
	    }
	    
	    this.onclick = function()
	    {
	    	cancelSelect();
          
	    }
	    function tableClick()
	    {
	    	
	    	cancelSelect();
	    }
	    function cancelSelect()
	    {
	    	initSelectTdColor();
	          initSelectTd();
			  closeTip();
	    }
	    
	    
			
		</script>
	</body>
</html>
