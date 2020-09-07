<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>其他往来应收账初始化</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>
	<body onload="initGrid()">
		<table id="datagrid"  fit="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
		<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="billNo" width="135" align="center">
						单号
					</th>
				</tr>
			</thead>
		</table>

		<div id="tb" style="padding:5px;height:auto">
		<div style="margin-bottom:5px">

		</div>
		<div>


		    单号: <input name="orderNo" id="billNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>

			单据日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         状态: <select name="status" id="status">
	                    <option value="-1">全部</option>
	                    <option value="1">已审核</option>
	                    <option value="-2">暂存</option>
						<option value="2">已作废</option>
	                </select>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:initGrid();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:battchAudit();">批量审批</a>
			<a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:toWlJkModel();">下载模版</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:toUpQtwl();">上传数据</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:toAdd();">添加</a>
			&nbsp;
			</div>
		</div>
		</div>

  	    <div id="upDiv" class="easyui-window" style="width:500px;height:100px;padding:10px;"
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/finInitQtWlMain/toUpWljkInitAmt?bizType=${bizType}" id="upFrm" method="post" enctype="multipart/form-data">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr height="30px">
						<td >选择文件：</td>
						<td>
						<input type="file" name="upFile" id="upFile" title="check"/>
						</td>
						<td><input type="button" onclick="toUpQtwlExcel();" style="width: 50px" value="上传" /></td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript">
		    function initGrid()
		    {
		    	    var cols = new Array();
		    	    var col = {
							   field : 'ck',
				               checkbox : true
						};
			    	    cols.push(col);
		    	    var col = {
							field: 'id',
							title: 'id',
							width: 50,
							align:'center',
							hidden:'true'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'proName',
							title: '往来对象',
							width: 140,
							align:'center'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '单号',
							width: 150,
							align:'center'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billTime',
							title: '单据日期',
							width: 120,
							align:'center',
							formatter:fromatterDate

					};
		    	    cols.push(col);

		    	    var col = {
							field: 'operator',
							title: '经办人',
							width: 80,
							align:'center'
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'amt',
							title: '初始化借款金额',
							width: 120,
							align:'center'
					};
		    	    cols.push(col);

					var col = {
						field: 'payAmt',
						title: '已还金额',
						width: 120,
						align:'center'
					};
					cols.push(col);

					var col = {
						field: '_unPayAmt',
						title: '未还金额',
						width: 120,
						align:'center',
						formatter:formatterUnPayAmt
					};
					cols.push(col);

		    	    var col = {
							field: 'status',
							title: '状态',
							width: 80,
							align:'center',
							formatter:formatterStatus
					};
		    	    cols.push(col);

					var col = {
						field: '_skStatus',
						title: '还款状态',
						width: 80,
						align:'center',
						formatter:formatterSkStatus
					};
					cols.push(col);

		    	    var col = {
							field: '_operator',
							title: '操作',
							width: 210,
							align:'center',
							formatter:formatterSt3
					};
		    	    cols.push(col);
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/finInitQtWlMain/page",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#billNo").val(),
							status:$("#status").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							bizType:'${bizType}'
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	],
	    	    		  	 rowStyler:function(index,row){
			    	    		  	 if (row.status==2){
			   	    		             return 'color:blue;text-decoration:line-through;font-weight:bold;';
			   	    		         }
			   	    		         if (row.status==3){
			   	    		             return 'color:#FF00FF;font-weight:bold;';
			   	    		         }
			   	    		         if (row.status==4){
			   	    		             return 'color:red;font-weight:bold;';
			   	    		         }
	    	    		     }
		    	    }
		    	    );
			}
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/finInitQtWlMain/page",
					jz:"1",
					billNo:$("#billNo").val(),
					status:$("#status").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					bizType:'${bizType}'
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					initGrid();
				}
			}

			function amtformatter(v,row)
			{
				if (row != null) {
                    return toThousands(v);//numeral(v).format("0,0.00");
                }
			}

			function formatterSt3(val,row){
		      	var ret ="";
		      	if(row.status == -2)
		      	ret = ret + "<input style='width:60px;height:27px' type='button' value='审核' onclick='auditBill("+row.id+")'/>";
				if(row.status != 2)
					ret = ret + "<input style='width:60px;height:27px' type='button' value='作废' onclick='cancelBill("+row.id+")'/>";
	      	    return ret;
		   }

		    function cancelBill(id){

			      $.messager.confirm('确认', '您确认要作废吗？', function(r) {
				  if (r) {
					$.ajax({
						url:"manager/finInitQtWlMain/cancelBill",
						type:"post",
						data:"billId="+id,
						success:function(json){
							if(json.state){
							    alert("作废成功");
							    $('#datagrid').datagrid('reload');
							    $('#dlg').dialog('close');
							}else{
								alert(json.msg);
								return;
							}
						}
					});
				  }
				 });
				 }

		    function toWlJkModel() {
                if(confirm("是否下载模版?")){
					window.location.href="manager/finInitQtWlMain/toWlJkInitAmtTemplate?bizType=${bizType}";
				}
            }

		    function auditBill(id){
			      $.messager.confirm('确认', '您确认要审核吗？', function(r) {
				  if (r) {
					$.ajax({
						url:"manager/finInitQtWlMain/auditBatch",
						type:"post",
						data:"billId="+id,
						success:function(json){
							if(json.state){
							    alert("操作成功");
							    $('#datagrid').datagrid('reload');
							    $('#dlg').dialog('close');
							}else{
								alert(json.msg);
								return;
							}
						}
					});
				  }
				 });
				 }

			function toThousands(num1) {
			    var num = (num1|| 0).toString(), result = '';
			    while (num.length > 3) {
			        result = ',' + num.slice(-3) + result;
			        num = num.slice(0, num.length - 3);
			    }
			    if (num) { result = num + result; }
			    return result;
			}

			   //显示上传框
			function toUpQtwl(){
				$("#upDiv").window({title:'上传',modal:true});
				$("#upDiv").window('open');
			}
			//上传文件
			function toUpQtwlExcel(){
			       $("#upFrm").form('submit',{
					success:function(data){
						if(data=='1'){
							alert("上传成功");
							$("#upDiv").window('close');
							 $('#datagrid').datagrid('reload');
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

			function battchAudit()
		    {
			 	var ids = "";
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					//ids.push(rows[i].id);
					if(ids!=""){
						ids +=",";
					}
					ids +=rows[i].id;
				}
				if(ids=="")
					{
						$.messager.alert('消息','请选择单据','info');
						return;
					}

				$.messager.confirm('确认', '您确认要批量审核吗？', function(r) {
					  if (r) {
						$.ajax({
							url:"manager/finInitQtWlMain/auditBatch",
							type:"post",
							data:"billId=&ids="+ids,
							success:function(json){
								if(json.state){
								    alert("操作成功");
								    $('#datagrid').datagrid('reload');
								    $('#dlg').dialog('close');
								}else{
									alert("操作失败" + json.msg);
									return;
								}
							}
						});
					  }
					 });
		    }

			function fromatterDate(v,row){
					v = v + "";
		            var date = "";
		            var month = new Array();
		            month["Jan"] = 1; month["Feb"] = 2; month["Mar"] = 3; month["Apr"] = 4; month["May"] = 5; month["Jan"] = 6;
		            month["Jul"] = 7; month["Aug"] = 8; month["Sep"] = 9; month["Oct"] = 10; month["Nov"] = 11; month["Dec"] = 12;
		            var week = new Array();
		            week["Mon"] = "一"; week["Tue"] = "二"; week["Wed"] = "三"; week["Thu"] = "四"; week["Fri"] = "五"; week["Sat"] = "六"; week["Sun"] = "日";
		            str = v.split(" ");
		            date = str[5] + "-";
		            date = date + month[str[1]] + "-" + str[2]+" "+str[3];
				return date;
			}

		    function formatterStatus(v,row){
				   if(v==-2){
					   return "暂存";
				   }
				   else if(v==1){
					   return "已审批";
				   }
				   else if(v==2){
					   return "已作废";
				   }

			   }
			 function formatterSkStatus(v,row) {
				 var totalAmt = row.amt;
				 var payAmt = row.payAmt;
				 var freeAmt = row.freeAmt;
				 var skStatus = "未还款";
				 if((payAmt+freeAmt)>0&&(payAmt+freeAmt)<totalAmt){
					 skStatus="部分还款"
				 }else if(totalAmt==(payAmt+freeAmt)){
					 skStatus="已还完"
				 }
				 return skStatus;
			 }

			function formatterUnPayAmt(v,row) {
				var totalAmt = row.amt;
				var payAmt = row.payAmt;
				var freeAmt = row.freeAmt;
				return totalAmt-payAmt-freeAmt;
			}

			function toAdd(){
		    	var bizType='${bizType}';
		    	var proType=1;
		    	title='员工借款初始化录入';
		    	if(bizType=='CSHGYSJC'){
					title='供应商借款初始化录入';
					proType=0;
				}else if(bizType=='CSHKHJC'){
					title='客户借款初始化录入';
					proType=2;
				}else{
					title='员工借款初始化录入';
					proType=1;
				}
				parent.parent.closeWin(title);
				parent.parent.add(title,'manager/finInitQtWlMain/add?bizType=${bizType}&proType='+proType);
			}

		</script>
	</body>
</html>
