<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>付货款管理</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body onload="initGrid()">
			<div id="tb" style="padding:5px;height:auto;">
			 发票类型: <select name="inType" id="inType">
				<option value="">全部</option>
				<option value="采购入库">采购入库</option>
				<option value="其它入库">其它入库</option>
				<option value="采购退货">采购退货</option>
				<option value="销售退货">销售退货</option>
			</select>
			往来单位: <input class="easyui-textbox" name="proName" id="proName" style="width:120px;" onkeydown="querydata();"/>

	                发票日期: <input class="easyui-textbox" readonly="readonly" name="sdate" id="sdate"  onClick="WdatePicker();" value="${sdate}" style="width: 70px;"  />
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16"  height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input class="easyui-textbox" name="edate" readonly="readonly" id="edate"  onClick="WdatePicker();" style="width: 70px;" value="${edate}" />
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
				发票金额范围:<input name="beginAmt" id="beginAmt" onkeyup="CheckInFloat(this)" style="width:60px;" />
				到<input name="endAmt" onkeyup="CheckInFloat(this)" id="endAmt" style="width:60px;" />
				<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>
				  <a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:showPayList();">付款纪录</a>
				  <a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:toUnitRecPage();">待付款单据</a>

	         		  
			</div>
		<table id="datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" 
			data-options="onDblClickRow: onDblClickRow" toolbar="#tb">
		</table>

			<div id="accDlg" closed="true" class="easyui-dialog" title="付款窗口" style="width:400px;height:300px;padding:10px"
				 data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						autoRecBill();
					}
				},{
					text:'取消',
					handler:function(){
						$('#accDlg').dialog('close');
					}
				}]
			">
				往来单位:<input class="reg_input" type="hidden" name="proId" id="proId" style="width: 120px"/>
				       <input class="reg_input" name="proName1" readonly="readonly" id="proName1" style="width: 120px"/><br/>
				应付金额:<input class="reg_input" name="amt" id="amt" readonly="readonly"   style="width: 120px;"/><br/>
				本次应付:<input class="reg_input" name="cash" id="cash"  style="width: 120px;color: blue" /><br/>
				付款账号:<tag:select name="accId" id="accId" tableName="fin_account" headerKey="" whereBlock="status=0" headerValue="--请选择--" displayKey="id" displayValue="acc_name"/><br/>

				备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注: <textarea rows="4" cols="40"  name="remarks" id="remarks"></textarea>
				<br/>
				<span style=" color: red">
					说明：自动匹配付款功能，在付款时不需要选择待付款单，系统会自己根据付款的金额匹配相应的未付款发票单且会根据发票最早的时间逐单匹配，此操作不含【销售退货】；
				</span>

			</div>

		<script type="text/javascript">
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'proId',
							title: 'proId',
							width: 100,
							align:'center',
							hidden:true				
					};
				   cols.push(col);		
				   
				   var col = {
							field: 'proName',
							title: '往来单位',
							width: 200,
							align:'center'
					};
		    	    cols.push(col);	
		    	    var col = {
							field: 'disAmt',
							title: '发票金额',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	   
		    	    var col = {
							field: 'disAmt1',
							title: '发货金额',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'payAmt',
							title: '已付金额',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'freeAmt',
							title: '核销金额',
							width: 60,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'totalAmt',
							title: '应付金额',
							width: 120,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);   

				   var col = {
					   field: '_operator',
					   title: '操作',
					   width: 120,
					   align:'center',
					   formatter:formatterOper
				   };
				   cols.push(col);
					var inType = $("#inType").val();
					$('#datagrid').datagrid({
						url:'manager/queryYfkUnitStat',
						fitColumns:false,
			            rownumbers:true,
			            pagination:true, 
						queryParams:{
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							inType:inType,
							proName:$("#proName").val(),
							beginAmt:$("#beginAmt").val(),
							endAmt:$("#endAmt").val()
							},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]
							}
	    	    );
			   }
			   
			function querydata(){			
				var inType = $("#inType").val();
				$("#datagrid").datagrid('load',{
					url:"manager/queryYfkUnitStat",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					inType:inType,
					proName:$("#proName").val(),
					beginAmt:$("#beginAmt").val(),
					endAmt:$("#endAmt").val()
				});
			}
		    
			
			function amtformatter(v,row)
			{
				if(v == null)return "";
				if(v=="0E-7"){
					return "0.00";
				}
				if (row != null) {
			        return numeral(v).format("0,0.00");
			    } 
			}
		    
		    function onDblClickRow(rowIndex, rowData)
		    {
				var inType = $("#inType").val();
				var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				parent.closeWin('待付款单据');
		    	parent.add('待付款单据','manager/toUnitPayPage?sdate=' + sdate + '&edate=' + edate + '&inType=' + inType + '&proName=' + rowData.proName);
					
		    }
		    function showPayList()
		    {
		    	parent.closeWin('付款记录');
		    	parent.add('付款记录','manager/queryPayPageByBillId?dataTp=1');
		    }

		    function toUnitRecPage()
		    {
				var inType = $("#inType").val();
				var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				var proName = $("#proName").val();
				parent.closeWin('待付款单据');
		    	parent.add('待付款单据','manager/toUnitPayPage?sdate=' + sdate + '&edate='+ edate +'&inType='+ inType +'&proName='+proName);
		    }

			   /**
				* 自动匹配单据付款
				*/
			   function autoRecBill(){
				   var accId = $("#accId").val();
				   if(accId==""){
					   $.messager.alert('消息','请选择付款账号','info');
					   return;
				   }
				   var proId = $("#proId").val();
				   var proName = $("#proName1").val();
				   var amt = $("#amt").val();
				   var cash = $("#cash").val();
				   var remarks = $("#remarks").val();
				   if(parseFloat(amt)<parseFloat(cash)){
					   $.messager.alert('消息',"本次付款不能大于"+amt,'info');
					   return;
				   }
				   $.messager.confirm('确认', '您确认付款吗？', function(r) {
					   if (r) {
						   $.ajax( {
							   url : "manager/autoPayBill",
							   data : "proId=" + proId+"&accId="+accId+"&cash="+cash+"&proName="+proName+"&remarks="+remarks,
							   type : "post",
							   success : function(json) {
								   if (json.state) {
									   alert(json.msg);
									   $("#accId").val("");
									   $("#proId").val("");
									   $("#proName1").val("");
									   $("#amt").val("");
									   $("#cash").val("");
									   $("#remarks").val("");
									   $("#datagrid").datagrid("reload");
								   } else {
									   alert(json.msg);
								   }
								   $('#accDlg').dialog('close');
							   }
						   });
					   }
				   });
				   $('#accDlg').dialog('close');

			   }

			   function toAutoRec(proId,proName,amt)
			   {
				   $('#accDlg').dialog('open');
				   $("#proId").val(proId);
				   $("#proName1").val(proName);
				   $("#amt").val(amt);
				   $("#cash").val(amt);
				   $("#cash").focus();
			   }

			   function formatterOper(val,row){
				   if(row.unitname=="合计"){
					return "";
				   }
				   var ret="";
				   var ret = "<input style='width:100px;height:27px' type='button' value='付款' onclick='toAutoRec("+row.proId+",\""+row.proName+"\",\""+row.totalAmt+"\")'/>";
				   return ret;

			   }
		</script>
	</body>
</html>
