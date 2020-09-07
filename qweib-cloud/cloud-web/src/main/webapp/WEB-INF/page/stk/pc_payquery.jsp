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
	</head>

	<body>
	<input type = "hidden" id="billId" value="${billId}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/stkPayPage?dataTp=${dataTp }&inType=${inType}&billId=${billId}&sourceBillNo=${sourceBillNo}" title="" iconCls="icon-save" border="false"
			rownumbers="true"  pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true">

		</table>
		<div id="tb" style="padding:5px;height:auto">
		   时间: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         <select name="inType" id="inType" style="display: none">
                   <option value="1">非返利付款</option>
                   <option value="2">返利付款</option>
               </select>
	          往来对象: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		      付款人: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	          类型:  <select name="billType" id="billType">
	                    <option value="">全部</option>
	                    <option value="0">付款</option>
	                    <option value="1">核销</option>
						<option value="2">收款抵扣</option>
	                </select>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querypaydetail();">查询</a>
	              <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:void(0)" onclick="cancelPay()">作废</a>

	              <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>&nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>&nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
		</div>
		<script type="text/javascript">
		$("#inType").val('${inType}');
		   //查询
		   initGrid();
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
							field: 'billNo',
							title: '单据号',
							width: 140,
							align:'center'
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'proName',
							title: '往来对象',
							width: 120,
							align:'center',
							formatter:formatterProName


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'payTimeStr',
							title: '付款日期',
							width: 100,
							align:'center'


					};
				   cols.push(col);

		    	    var col = {
							field: 'memberNm',
							title: '付款人',
							width: 100,
							align:'center'


					};
		    	    cols.push(col);


						var col = {
								field: 'sumAmt',
								title: '总付款/核销金额',
								width: 100,
								align:'center'


						};
			    	    cols.push(col);

					var col = {
							field: 'cash',
							title: '现金',
							width: 100,
							align:'center'


					};
		    	    cols.push(col);
		    	    var col = {
							field: 'bank',
							title: '银行转账',
							width: 100,
							align:'center'


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'wx',
							title: '微信',
							width: 100,
							align:'center'


					};
		    	    cols.push(col);
		    	    var col = {
							field: 'zfb',
							title: '支付宝',
							width: 100,
							align:'center'


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'preAmt',
							title: '抵扣预付款',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);

					var col = {
							field: 'remarks',
							title: '备注',
							width: 150,
							align:'center'



					};
		    	    cols.push(col);
		    	    var col = {
							field: 'itemName',
							title: '费用项目',
							width: 150,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billTypeStr',
							title: '类型',
							width: 100,
							align:'center'


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'status',
							title: '状态',
							width: 80,
							align:'center',
							formatter:formatterStr
					};
		    	    cols.push(col);
					$('#datagrid').datagrid({
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
	    	    $('#datagrid').datagrid('reload');
			   }
			function querypaydetail(){
				var billId = $("#billId").val();
				var inType = $("#inType").val();
				$("#datagrid").datagrid('load',{
					url:"manager/stkPayPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					billId:billId,
					proName:$("#proName").val(),
					memberNm:$("#memberNm").val(),
					billType:$("#billType").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querypaydetail();
				}
			}

			function cancelPay()
			{
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					/*
					if(rows[i].billStatus=='作废'){
					   alert("该单已经作废");
					   return;
					}*/
					if(rows[i].status!=0){
						   alert("非正常单，不能作废");
						   return;
						}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '是否确认作废付款单？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/cancelPay",
								data : "id=" + ids[0],
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else{
										showMsg("作废失败:" + json.msg);
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要删除的数据");
				}
			}

		   function formatterProName(v,row){
			   if(v==""||v==undefined||v==null){
				   return row.proName1;
			   }else{
				   return v;
			   }

		   }

		   function formatterStr(v,row){
			   if(v==0){
				   return "正常";
			   }else if(v==2){
				   return "作废";
			   }else if(v==3){
				   return "被冲红单";
			   }else if(v==4){
				   return "冲红单";
			   }

		   }

		</script>
	</body>
</html>
