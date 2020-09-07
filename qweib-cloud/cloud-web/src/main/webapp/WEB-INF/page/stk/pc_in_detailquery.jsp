<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>采购发票-收货单据列表</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			title="" iconCls="icon-save" border="false"
			rownumbers="true"  pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
		<thead>
				<tr>
				</tr>
			</thead>
		</table>
		<input id="billId" name="billId" value="${billId }"/>
		<div id="tb" style="padding:5px;height:auto;">
			<div style="display:<c:if test="${billId ne ''}">none</c:if>">
		     收货单号: <input name="voucherNo" id="voucherNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		     发票单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			往来单位: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>

			发票日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        入库类型: <select name="inType" id="inType">
	                    <option value="">全部</option>
	                    <option value="采购入库">采购入库</option>
				        <option value="销售退货">销售退货入库</option>
				        <option value="采购退货">采购退货</option>
	                    <option value="其它入库">其它入库</option>
	                </select>
	         状态: <select name="orderZt" id="billStatus">
	                    <option value="-1">全部</option>
	                    <option value="0">正常</option>
	                    <option value="2">作废</option>
	                </select>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>

			</div>
		</div>
		<script type="text/javascript">
		    var database="${database}";
		    initGrid();
		    function initGrid()
		    {
		    	var cols = new Array();
				   var col = {
							field: 'id',
							title: 'id',
							width: 120,
							align:'center',
							hidden:true
					};
				   cols.push(col);


				   var col = {
							field: 'voucherNo',
							title: '收货单号',
							width: 130,
							align:'center'


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'billNo',
							title: '发票单号',
							width: 130,
							align:'center'
					};
		    	    cols.push(col);

				   var col = {
							field: 'comeTimeStr',
							title: '日期',
							width: 120,
							align:'center'


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'proName',
							title: '往来单位',
							width: 100,
							align:'center'


					};
		    	    cols.push(col);

		    	    var col = {
							field: 'status',
							title: '状态',
							width: 100,
							align:'center',
							formatter:formatterStatus
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'count',
							title: '商品信息',
							width: 300,
							align:'center',
							formatter:formatterSt


					};
		    	    cols.push(col);
		    	     var col = {
							field: '_operator',
							title: '操作',
							width: 80,
							align:'center',
							formatter:formatterOper
					};
		    	    cols.push(col);

					$('#datagrid').datagrid({
						url:"manager/queryInComePage",
						queryParams:{
							jz:"1",
							billNo:$("#orderNo").val(),
							stkUnit:$("#proName").val(),
							memberNm:$("#memberNm").val(),
							billName:$("#inType").val(),
							voucherNo:$("#voucherNo").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							ioType:0,
							status:$("#billStatus").val(),
							billId:$("#billId").val()
							},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	    //$('#datagrid').datagrid('reload');
			}
		    //查询物流公司
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryInComePage?database="+database,
					jz:"1",
					billNo:$("#orderNo").val(),
					stkUnit:$("#proName").val(),
					memberNm:$("#memberNm").val(),
					billName:$("#inType").val(),
					voucherNo:$("#voucherNo").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					ioType:0,
					status:$("#billStatus").val(),
					billId:$("#billId").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
				}
			}

			// function formatterSt(v,row){
			// 	var hl='<table>';
			// 	if(row.list.length>0){
			//         hl +='<tr>';
			//         hl +='<td width="120px;"><b>商品名称</b></td>';
			//
			//         hl +='<td width="60px;"><b>单位</font></b></td>';
			//         hl +='<td width="80px;"><b>规格</font></b></td>';
			//         hl +='<td width="60px;"><b>数量</font></b></td>';
			//         hl +='<td width="60px;"><b>单价</font></b></td>';
			//         hl +='<td width="60px;"><b>总价</font></b></td>';
			//         hl +='<td width="60px;"><b>已收数量</font></b></td>';
			//         hl +='<td width="60px;"><b>未收数量</font></b></td>';
			//         hl +='</tr>';
		    //     }
		    //     for(var i=0;i<row.list.length;i++){
		    //         hl +='<tr>';
			//         hl +='<td>'+row.list[i].wareNm+'</td>';
			//
			//         hl +='<td>'+row.list[i].unitName+'</td>';
			//         hl +='<td>'+row.list[i].wareGg+'</td>';
			//         hl +='<td>'+row.list[i].qty+'</td>';
			//         hl +='<td>'+row.list[i].price+'</td>';
			//         hl +='<td>'+row.list[i].qty *row.list[i].price +'</td>';
			//         hl +='<td>'+row.list[i].inQty+'</td>';
			//         hl +='<td>'+row.list[i].inQty1+'</td>';
			//         hl +='</tr>';
		    //     }
		    //     hl +='</table>';
  			//     return hl;
			// }

			function amtformatter(v,row)
			{
				if(v==""){
					return "";
				}
				if(v=="0E-7"){
					return "0.00";
				}
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}


			function onDblClickRow(rowIndex, rowData)
		    {
				//if(rowData.inType == "采购入库")
				if(rowData.id==null||rowData.id==0||rowData.id==undefined){
					parent.add('收货入库确认' + rowData.inId,'manager/showstkincheck?dataTp=1&billId=' + rowData.inId);
				}else{
					parent.add('收货确认单' + rowData.id,'manager/showstkinchecklook?dataTp=1&billId=' + rowData.id);
				}

		    }

			function formatterSt(v,row){
				var hl='<table>';
				if(row.subList.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>商品名称</b></td>';
			        hl +='<td width="60px;"><b>单位</font></b></td>';
			        hl +='<td width="60px;" style="display:${permission:checkUserFieldDisplay("stk.stkCome.lookqty")}"><b>收货数量</font></b></td>';
			        hl +='<td width="60px;" style="display:${permission:checkUserFieldDisplay("stk.stkCome.lookprice")}"><b>单价</font></b></td>';
			        hl +='<td width="60px;" style="display:${permission:checkUserFieldDisplay("stk.stkCome.lookamt")}"><b>总价</font></b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.subList.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.subList[i].wareNm+'</td>';
			        hl +='<td>'+row.subList[i].unitName+'</td>';
			        hl +='<td style="display:${permission:checkUserFieldDisplay("stk.stkCome.lookqty")}">'+numeral(row.subList[i].inQty).format("0,0.00")+'</td>';
			        hl +='<td style="display:${permission:checkUserFieldDisplay("stk.stkCome.lookprice")}">'+row.subList[i].price+'</td>';
			        hl +='<td style="display:${permission:checkUserFieldDisplay("stk.stkCome.lookamt")}">'+numeral(row.subList[i].inQty *row.subList[i].price).format("0,0.00") +'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}

			function formatterOper(val,row){
				var ret = "";
				if(row.status==0||row.status==1){
					 ret = "<input style='width:60px;height:27px;display:${permission:checkUserFieldDisplay('stk.stkCome.cancel')}' type='button' value='作废' onclick='cancelBill("+row.id+",\""+row.inId+"\")'/>";
					}
				return ret;
		    }

			function cancelBill(id,inId){
				if(id==undefined){
					$.messager.confirm('确认', '是否确认作废收货明细？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/cancelStkInByBillId",
								data : "billId=" + inId,
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else{
										showMsg("作废失败:" + json.msg);
									}
									alert(json);
								},
								error: function (XMLHttpRequest, textStatus, errorThrown) {
				                }
							});
						}
					});
				}else{
						$.messager.confirm('确认', '是否确认作废收货明细？', function(r) {
							if (r) {
								$.ajax( {
									url : "manager/cancelStkInCome",
									data : "billId=" + id,
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
				}
			}

			function formatterStatus(val,row){
				if(val==0||val==1){
				  return "正常";
				}
				if(val==2){
					return "作废";
				}
			}
		</script>
	</body>
</html>
