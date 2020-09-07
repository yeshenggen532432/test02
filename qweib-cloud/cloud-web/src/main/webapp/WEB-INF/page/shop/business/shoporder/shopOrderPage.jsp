<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>会员订单</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="${base}/resource/WdatePicker.js"></script>
	<script type="text/javascript" src="${base}/resource/shop/pc/js/bforder.js"></script>
</head>
<body>
	<table id="datagrid"  fit="true" singleSelect="true"
		 iconCls="icon-save" border="false"
		rownumbers="true" fitColumns="false" pagination="true"
		nowrap="false",
		pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
	</table>
	<div id="tb" style="padding:5px;height:auto">
		订单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" value="${order.orderNo}" onkeydown="toQuery(event);"/>
		客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		会员名称: <input name="shopMemberName" id="shopMemberName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		下单日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
					<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
					-
				 <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
					<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
<c:if test="${order.isPay !=10}">
		订单状态: <select name="orderZt" id="orderZt">
					<option value="正常订单">正常订单</option>
					<c:forEach items="${orderZtMap}" var="ztMap">
						<option value="${ztMap.key}">${ztMap.value}</option>
					</c:forEach>
					<option value="">全部</option>
				</select>
</c:if>
		付款类型: <select name="payType" id="payType">
					<option value="" >全部</option>
                    <c:forEach items="${orderPayTypeMap}" var="payTypeMap">
                        <option value="${payTypeMap.key}" <c:if test="${order.payType eq payTypeMap.key}">selected</c:if> >${payTypeMap.value}</option>
                    </c:forEach>
				</select>
		仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>
		<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
		<c:if test="${order.isPay !=10}">
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toZf();" title="未支付和线下支付订单才能作废">作废</a>
			<%--<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>--%>

			<c:if test="${order.isPay !=0 && permission:checkUserFieldPdm('shop.order.refund')}">
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_SHOP_ORDER_REFUND\"  and status=1") eq 'none'?'style="display:none"':""} href="javascript:toTk();" title="在线支付订单才可退款并作废">退款并作废</a>
			</c:if>
		</c:if>
        <c:if test="${order.isPay == 0 && order.payType==3}">
            <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:verifyWechatPayment();">同步微信验证是否支付成功</a>
        </c:if>
		<%--<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toShow();">修改</a>--%>
	</div>
	<script type="text/javascript">

		//查询订单
		function queryorder(){
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
				field: 'orderNo',
				title: '订单号',
				width: 135,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'status',
				title: '状态',
				width: 75,
				align:'center',
				formatter:formatStatus
			};
			cols.push(col);
			var col = {
				field: 'orderZt',
				title: '订单状态',
				width: 75,
				align:'center',
				formatter:formatOrderZt
			};
			cols.push(col);
			var col = {
				field: 'isPay',
				title: '付款状态',
				width: 60,
				align:'center',
				formatter:formatterIsPay
			};
			cols.push(col);
			var col = {
				field: 'payTime',
				title: '付款时间',
				width: 120,
				align:'center',
			};
			cols.push(col);
			var col = {
				field: 'payType',
				title: '付款类型',
				width: 70,
				align:'center',
				formatter:formatterPayType
			};
			cols.push(col);
			var col = {
				field: 'pszd',
				title: '配送指定',
				width: 100,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'oddate',
				title: '下单日期',
				width: 100,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'odtime',
				title: '时间',
				width: 80,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'shTime',
				title: '送货时间',
				width: 120,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'khNm',
				title: '客户名称',
				width: 100,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'shopMemberName',
				title: '会员名称',
				width: 100,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'count',
				title: '商品信息',
				width: 520,
				align:'center',
				formatter:formatterSt
			};
			cols.push(col);
			var col = {
				field: 'zje',
				title: '总金额',
				width: 60,
				align:'center',
			};
			cols.push(col);
			var col = {
				field: 'zdzk',
				title: '整单折扣',
				width: 60,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'cjje',
				title: '成交金额',
				width: 60,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'remo',
				title: '备注',
				width: 200,
				align:'center',
				nowrap:false
			};
			cols.push(col);
			var col = {
				field: 'shr',
				title: '收货人',
				width: 80,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'tel',
				title: '电话',
				width: 100,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'address',
				title: '地址',
				width: 275,
				align:'center'
			};
			cols.push(col);
			$('#datagrid').datagrid({
				url:"manager/shopBforder/page",
				nowrap:false,
				cache:false,
				border: false,
				rownumbers: true,
				striped : true,
				fixed:true,
				queryParams:{
					jz:"1",
					orderNo:$("#orderNo").val(),
					khNm:$("#khNm").val(),
					shopMemberName:$("#shopMemberName").val(),
					orderZt:$("#orderZt").val(),
					pszd:$("#pszd").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					stkId:$("#stkId").val(),
					payType:$("#payType").val(),
					isPay:"${order.isPay}"
				},
				columns:[cols]
			});
			//$('#datagrid').datagrid('reload');
		}

		//状态
		function formatStatus(val,row) {
			<c:forEach items="${orderStateMap}" var="stateMap">
			if(val==${stateMap.key}){
				return "${stateMap.value}";
			}
			</c:forEach>
		}

		//付款类型
		function formatterPayType(val,row){
            <c:forEach items="${orderPayTypeMap}" var="payTypeMap">
            if(val==${payTypeMap.key}){
                if(val==0){
                    return "<a href='javascript:updatePayType("+row.id+")' title='修改为线下支付类型'>${payTypeMap.value}</span>";
                }
               return "${payTypeMap.value}";
            }
            </c:forEach>
		}

<c:if test="${permission:checkUserFieldPdm('shop.order.refund')}">
		//退款并作废订单
		function toTk() {
			var id = "";
			var rows = $("#datagrid").datagrid("getSelections");
			if(!rows||rows.length==0){
				alert("请勾选你要操作的行！");
				return false;
			}
			if(rows.length > 1){
				alert("请勿多选订单！");
				return false;
			}

			if(rows[0].isPay!=1){
				alert("该订单未付款，不能退款");
				return;
			}
			if(rows[0].orderZt=='已作废'){
				alert("该订单已作废，不能再退款");
				return;
			}
			if(rows[0].payType==0 || rows[0].payType==1){
				alert("非线上支付订单，不能申请退款并作废");
				return;
			}
			id=rows[0].id;
			if (id) {
				$.messager.confirm('确认', '您确认想要退款并作废该记录吗？', function(r) {
					if (r) {
						$.messager.confirm('确认', '资金将原路退回用户？', function(r) {
							if (!r) return false;
							$.ajax( {
								url : "/manager/shopBforder/doRefund",
								data : "orderId=" + id,
								type : "post",
								success : function(data) {
									showMsg(data.message);
									if (data.state) {
										$("#datagrid").datagrid("reload");
									}
								}
							});
						});
					}
				});
			} else {
				showMsg("请选择要作废的数据");
			}
		}
		</c:if>

        //同步微信验证是否支付成功
        function verifyWechatPayment() {

            var rows = $("#datagrid").datagrid("getSelections");
            if(!rows||rows.length==0){
                alert("请勾选你要操作的行！");
                return false;
            }
            if(rows.length > 1){
                alert("请勿多选订单！");
                return false;
            }

            if(rows[0].isPay==1){
                alert("该订单已付款，不能继续操作");
                return;
            }
            if(rows[0].orderZt=='已作废'){
                alert("该订单已作废，不能继续操作");
                return;
            }
            if(rows[0].payType !=3){
                alert("非微信支付订单，不能继续操作");
                return;
            }
            var orderNo=rows[0].orderNo;
            if (orderNo) {
                $.messager.confirm('确认', '验证微信是否收到货款,请耐心等待返回结果!', function(r) {
                    if (r) {
                        $.ajax( {
                            url : "/manager/shopBforder/doVerifyWechatPayment",
                            data : "orderNo=" + orderNo,
                            type : "post",
                            success : function(data) {
                                showMsg(data.message);
                                if (data.state) {
                                    $("#datagrid").datagrid("reload");
                                }
                            }
                        });
                    }
                });
            } else {
                showMsg("请选择要作废的数据");
            }
        }


		if('${order.orderNo}'!=""){
			queryorder();
		}
	</script>

</body>
</html>
