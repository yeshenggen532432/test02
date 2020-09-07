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
	<body onload="initGrid()">
					<table id="datagrid"  fit="true" singleSelect="true"
						 title="" iconCls="icon-save" border="false"
						rownumbers="true" fitColumns="false" pagination="true"
						pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
					<thead>
							<tr>
							    <th field="id" width="50" align="center" hidden="true">
									id
								</th>
								<th field="billNo" width="135" align="center">
									单号
								</th>

								<th field="costTimeStr" width="80" align="center">
									报销日期
								</th>
								<th field="proName" width="100" align="center">
									报销对象
								</th>

								<th field=branchName width="100" align="center" >
									部门
								</th>
								<th field="payAmt" width="80" align="center" >
									付款金额
								</th>
								<th field="count" width="400" align="center" formatter="formatterSt">
									商品信息
								</th>
								<th field="remarks" width="80" align="center" >
									备注
								</th>

							</tr>
						</thead>
					</table>

					<div id="tb" style="padding:5px;height:auto">
					<div style="margin-bottom:5px">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newBill();">费用报销付款开单</a>
					</div>
					<div>
					     单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
						报销对象: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
						明细科目名称:  <input name="itemName" id="itemName" style="width:100px;height: 20px;"/>
						报销日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>

						<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
						<%--
						<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:toHis();">历史付款凭证</a>
						--%>
						</div>
					</div>

		<script type="text/javascript">
		    function initGrid()
		    {


		    	var cols = new Array();
	    	    var col = {
						field: 'id',
						title: 'id',
						width: 50,
						align:'center',
						hidden:'true'

				};
	    	    cols.push(col);
	    	    var col = {
						field: 'status',
						title: 'status',
						width: 50,
						align:'center',
						hidden:'true'

				};
	    	    cols.push(col);
	    	    var col = {
						field: 'billNo',
						title: '单号',
						width: 135,
						align:'center'

				};
	    	    cols.push(col);
	    	    var col = {
						field: 'costTimeStr',
						title: '费用日期',
						width: 100,
						align:'center'

				};
	    	    cols.push(col);
	    	    var col = {
						field: 'proName',
						title: '报销对象',
						width: 100,
						align:'center'

				};
	    	    cols.push(col);
	    	    var col = {
						field: 'totalAmt',
						title: '报销金额',
						width: 80,
						align:'center'

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
						field: 'billStatus',
						title: '状态',
						width: 80,
						align:'center',
						formatter:formatterStatus


				};
	    	    cols.push(col);
	    	    var col = {
						field: '_oper',
						title: '操作',
						width: 140,
						align:'center',
						formatter:formatterOper


				};
	    	    cols.push(col);
	    	    var col = {
						field: 'count',
						title: '科目信息',
						width: 200,
						align:'center',
						formatter:formatterSt
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'remarks',
						title: '备注',
						width: 200,
						align:'center'

				};
	    	    cols.push(col);

	    	    $('#datagrid').datagrid({
	    	    	url:"manager/queryFinCostToPayPage",
	    	    	queryParams:{
	    	    		jz:"1",
						billNo:$("#orderNo").val(),
						proName:$("#proName").val(),
						billStatus:'未付',
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
						itemName:$("#itemName").val()

		    	    	},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
			}
		    //查询物流公司
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryFinCostToPayPage",
					jz:"1",
					billNo:$("#orderNo").val(),
					proName:$("#proName").val(),
					billStatus:'未付',
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					itemName:$("#itemName").val()

				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					//queryorder();
				}
			}

			function formatterSt(v,row){
				var hl='<table>';
				var rowIndex = $("#datagrid").datagrid("getRowIndex",row);
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>明细科目名称</b></td>';

			        hl +='<td width="60px;"><b>费用金额</font></b></td>';

			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].itemName+'</td>';

			        hl +='<td>'+row.list[i].amt+'</td>';

			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}


			function formatterStatus(v,row){

				if(v=='已审'){
					return "待支付";
				}
			}


			function amtformatter(v,row)
			{
				if (row != null) {
                    return toThousands(v);//numeral(v).format("0,0.00");
                }
			}

		    function formatterOper(val,row){

				var ret ="" ;
				ret =  "<input style='width:60px;height:27px' type='button' value='付款' onclick='finPay("+row.id+")'/>";
		    	if(row.status != 2){
					ret=ret+ "<input style='width:60px;height:27px' type='button' value='作废' onclick='cancelBill("+row.id+")'/>";
		    	}

		    	 return ret;
		    }

			function cancelBill(id){
				$.messager.confirm('确认', '您确认要作废吗？', function(r) {
					if (r) {
						$.ajax({
							url:"manager/cancelFinCost",
							type:"post",
							data:"billId="+id,
							success:function(json){
								if(json.state){
									alert("操作成功");
									$('#datagrid').datagrid('reload');
								}else{
									alert("操作失败" + json.msg);
									return;
								}
							}
						});
					}
				});
			}


			function finPay(id)
		    {
				parent.parent.closeWin('付款凭证');
				parent.parent.add('付款凭证','manager/toFinPayEdit?costBillId=' + id);
		    }

		    function newBill()
			{

				parent.parent.parent.closeWin('费用报销付款开单');
				parent.parent.parent.add('费用报销付款开单','manager/toFinPayEdit?costBillId=0');
			}

			function toHis()
			{
				parent.parent.closeWin('历史付款凭证');
				parent.parent.add('历史付款凭证','manager/toFinPayHis');
			}


			function onDblClickRow(rowIndex, rowData)
		    {

				parent.parent.closeWin('支付凭证');
				parent.parent.add('支付凭证','manager/toFinPayEdit?costBillId=' + rowData.id);

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

		</script>
	</body>
</html>
