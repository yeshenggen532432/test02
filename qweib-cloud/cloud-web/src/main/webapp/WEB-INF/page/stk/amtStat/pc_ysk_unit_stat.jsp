<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>收货款管理</title>
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
			 出库类型: <select name="outType" id="outType"  style="width: 120px;">
	                    <option value="">全部</option>
						<option value="销售出库">销售出库</option>
						<option value="其它出库">其它出库</option>
						<option value="报损出库">报损出库</option>
						<option value="领用出库">领用出库</option>
						<option value="借出出库">借出出库</option>
	                </select>	
	        客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>       
			往来单位: <input class="easyui-textbox" name="khNm" id="khNm" style="width:120px;" onkeydown="querydata();"/>

	                发票日期: <input class="easyui-textbox" readonly="readonly" name="sdate" id="sdate"  onClick="WdatePicker();" value="${sdate}" style="width: 70px;"  />
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16"  height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input class="easyui-textbox" name="edate" readonly="readonly" id="edate"  onClick="WdatePicker();" style="width: 70px;" value="${edate}" />
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
				发票金额范围:<input name="beginAmt" id="beginAmt" onkeyup="CheckInFloat(this)" style="width:60px;" />
				到<input name="endAmt" onkeyup="CheckInFloat(this)" id="endAmt" style="width:60px;" />
				所属二批: <input class="easyui-textbox" name="epCustomerName" id="epCustomerName" style="width:120px;" onkeydown="querydata();"/>
	         		  <br/>
	         		  <a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:showPayList();">收款纪录</a>
	         		  <a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:toUnitRecPage();">待收款单据</a>
	         		  <a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:showRecStat();">收款货统计</a>
	         		   <a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:showYshkStat();">预收货款信息</a>
	         		     <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>
	         		  
			</div>
		<table id="datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" 
			data-options="onDblClickRow: onDblClickRow" toolbar="#tb">
		</table>

			<div id="accDlg" closed="true" class="easyui-dialog" title="收款窗口" style="width:400px;height:300px;padding:10px"
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
				往来单位:<input class="reg_input" type="hidden" name="cstId" id="cstId" style="width: 120px"/>
				       <input class="reg_input" name="cstName" readonly="readonly" id="cstName" style="width: 120px"/><br/>
				欠款金额:<input class="reg_input" name="amt" id="amt" readonly="readonly"   style="width: 120px;"/><br/>
				本次收款:<input class="reg_input" name="cash" id="cash"  style="width: 120px;color: blue" /><br/>
				收款账号:<tag:select name="accId" id="accId" tableName="fin_account" headerKey="" headerValue="--请选择--" whereBlock="status=0" displayKey="id" displayValue="acc_name"/><br/>

				备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注: <textarea rows="4" cols="40"  name="remarks" id="remarks"></textarea>
				<br/>
				<span style="color: red">
					说明：自动匹配收款功能，在收款时不需要选择待收款单，系统会自己根据收款的金额匹配相应的待收款发票单且会根据发票最早的时间逐单匹配；
				</span>
			</div>

		<script type="text/javascript">
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'unitid',
							title: 'unitid',
							width: 100,
							align:'center',
							hidden:true				
					};
				   cols.push(col);		
				   
				   var col = {
							field: 'unitname',
							title: '往来单位',
							width: 200,
							align:'center'
					};
		    	    cols.push(col);	
		    	    var col = {
							field: 'disamt',
							title: '发票金额',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	   
		    	    var col = {
							field: 'disamt1',
							title: '发货金额',
							width: 100,
							align:'center'

					};
		    	    cols.push(col);

		    	    var col = {
							field: 'recamt',
							title: '已收金额',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'freeamt',
							title: '核销金额',
							width: 60,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'sumamt',
							title: '欠款金额',
							width: 120,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);   
		    	    var col = {
							field: 'epcustomername',
							title: '所属二批',
							width: 150,
							align:'center'
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
					var outType = $("#outType").val();
					$('#datagrid').datagrid({
						url:'manager/queryYskUnitStat',
						fitColumns:false,
			            rownumbers:true,
			            pagination:true, 
						queryParams:{
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							outType:outType,
							epCustomerName:$("#epCustomerName").val(),
							unitName:$("#khNm").val(),
							beginAmt:$("#beginAmt").val(),
							endAmt:$("#endAmt").val(),
							customerType:$("#customerType").val()
							},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]
							/*,
	    	    		  	toolbar: [
	    	    		                { text: '收款纪录',iconCls:'icon-redo', handler: function () { showPayList();} },
	    	    		                { text: '待收款单据',iconCls:'icon-redo', handler: function () {toUnitRecPage(); } },
	    	    		                { text: '收款货统计',iconCls:'icon-redo', handler: function () {showRecStat(); } },
	    	    		                '-',
	    	    		                { text: '查询', iconCls: 'icon-search', handler: function () { querydata(); } }]*/
							}
	    	    );
			   }
			   
			function querydata(){			
				var outType = $("#outType").val();
				$("#datagrid").datagrid('load',{
					url:"manager/queryYskUnitStat",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					outType:outType,
					unitName:$("#khNm").val(),
					beginAmt:$("#beginAmt").val(),
					endAmt:$("#endAmt").val(),
					epCustomerName:$("#epCustomerName").val(),
					customerType:$("#customerType").val()
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
		    //alert(rowData.inQty);
				var outType = $("#outType").val();
				var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				parent.closeWin('待收款单据');
		    	parent.add('待收款单据','manager/toUnitRecPage?sdate=' + sdate + '&edate=' + edate + '&outType=' + outType + '&proType='+rowData.proType+'&unitName=' + rowData.unitname+'&epCustomerName='+rowData.epcustomername );
					
		    }
		    function showPayList()
		    {
		    	parent.closeWin('收款记录');
		    	parent.add('收款记录','manager/queryRecPageByBillId?dataTp=1');
		    }
		    function toUnitRecPage()
		    {
				var outType = $("#outType").val();
				var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				var epCustomerName = $("#epCustomerName").val();
				var unitName = $("#khNm").val();
				parent.closeWin('待收款单据');
		    	parent.add('待收款单据','manager/toUnitRecPage?sdate=' + sdate + '&edate='+ edate +'&outType='+ outType +'&unitName='+unitName+'&epCustomerName='+epCustomerName+'' );
		    }
		    function compute(colName) {
	            var rows = $('#datagrid').datagrid('getRows');
	            var total = 0;
	            for (var i = 0; i < rows.length; i++) {
	                total += parseFloat(rows[i][colName]);
	            }
	            return total;
	        }

			   /**
				* 自动匹配单据收款
				*/
			   function autoRecBill(){
				   var accId = $("#accId").val();
				   if(accId==""){
					   $.messager.alert('消息','请选择收款账号','info');
					   return;
				   }
				   var cstId = $("#cstId").val();
				   var cstName = $("#cstName").val();
				   var amt = $("#amt").val();
				   var cash = $("#cash").val();
				   var remarks = $("#remarks").val();
				   if(parseFloat(amt)<parseFloat(cash)){
					   $.messager.alert('消息',"本次收款不能大于"+amt,'info');
					   return;
				   }
				   $.messager.confirm('确认', '您确认收款吗？', function(r) {
					   if (r) {
						   $.ajax( {
							   url : "manager/autoRecBill",
							   data : "cstId=" + cstId+"&accId="+accId+"&cash="+cash+"&khNm="+cstName+"&remarks="+remarks,
							   type : "post",
							   success : function(json) {
								   if (json.state) {
									   alert(json.msg);
									   $("#accId").val("");
									   $("#cstId").val("");
									   $("#cstName").val("");
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

			   function toAutoRec(cstId,cstName,amt)
			   {
				   $('#accDlg').dialog('open');
				   $("#cstId").val(cstId);
				   $("#cstName").val(cstName);
				   $("#amt").val(amt);
				   $("#cash").val(amt);
				   $("#cash").focus();
			   }

			   function showRecStat()
		    {
		    	parent.closeWin('收货款统计');
		    	parent.add('收货款统计','manager/toRecStat?dataTp=1');
		    }

		    function showYshkStat(){
		    	parent.closeWin('预收货款信息');
		    	parent.add('预收货款信息','manager/toYshkPage?dataTp=1');
		    }

			   function formatterOper(val,row){
				   if(row.unitname=="合计"){
				   	return "";
				   }
				   var ret = "<input style='width:90px;height:27px' type='button' value='收款' onclick='toAutoRec("+row.unitid+",\""+row.unitname+"\",\""+row.sumamt+"\")'/>";
				   return ret;

			   }

			   function loadCustomerType(){
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
						           img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
						       }
						    }
						   $("#customerType").html(img);
						 }
					}
				});
			}
	 loadCustomerType();
		</script>
	</body>
</html>
