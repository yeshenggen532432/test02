<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员分页</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<style type="text/css">
		</style>
	</head>
	<body>
		<table id="datagrid"  fit="true" singleSelect="false" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>

			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     会员名称: <input name="name" id="name" style="width:100px;height: 20px;" />
		     手机号: <input name="mobile" id="mobile" style="width:100px;height: 20px;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
			<%--<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare();">选择商品</a>--%>
			<input name="wareId" id="wareId" value="" hidden="true"/>
			<span name="wareNm" id="wareNm" style="color: #FF0000;font-size: 13px"></span>
		</div>
		<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
		</div>

		<%--js--%>
		<script type="text/javascript">
			$(function () {
				initGrid();
				//双击事件
				onDblClickRow();
            })
		    //查询会员
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopMemberPrice/shopMemberPricePage?source=3",
					name:$("#name").val(),
					mobile:$("#mobile").val(),
					wareId:$("#wareId").val(),
				});
			}

			//双击事件
			function onDblClickRow() {
				<%--$("#datagrid").datagrid({--%>
					<%--onDblClickRow: function (index, row) {--%>
						<%--var shopMemberId = row.id;--%>
						<%--var name = row.name;--%>
						<%--window.parent.parent.add("商品价格编辑_"+name, "${base}/manager/shopMemberPrice/toShopWarePrice?shopMemberId=" + shopMemberId);--%>
					<%--}--%>
				<%--});--%>
			}

			function dialogSelectWare(){
				$('#wareDlg').dialog({
					title: '商品选择',
					iconCls:"icon-edit",
					width: 800,
					height: 400,
					modal: true,
					href: "<%=basePath %>/manager/shopWare/dialogWareType",
					onClose: function(){
					}
				});
				$('#wareDlg').dialog('open');
			}

			//选择商品-回调
			function callBackFun(wareId,wareNm){
				$("#wareId").val(wareId);
				$("#wareNm").text("批量编辑：《"+wareNm+"》价格");
				query();
			}

			function initGrid(){
				var cols = new Array();
				var col = {
					field: 'name',
					title: '会员名称',
					width: 80,
					align:'center',
				};
				cols.push(col);
				var col = {
					field: 'oper',
					title: '操作',
					width: 100,
					align:'center',
					formatter:formatterOper
				};
				cols.push(col);
				var col = {
					field: 'mobile',
					title: '电话',
					width: 100,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'customerName',
					title: '关联客户',
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
					field: 'defaultAddress',
					title: '收货地址',
					width: 100,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'pic',
					title: '微信头像',
					width: 100,
					align:'center',
					formatter:imgFormatter
				};
				cols.push(col);
				var col = {
					field: 'nickname',
					title: '微信昵称',
					width: 100,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'sex',
					title: '性别',
					width: 100,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'country',
					title: '国家',
					width: 100,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'province',
					title: '省份',
					width: 100,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'city',
					title: '城市',
					width: 100,
					align:'center'
				};
				cols.push(col);
				// var col = {
				// 	field: 'shopWarePrice',
				// 	title: '<span onclick="javascript:editPrice(1);">商城批发价(大)✎</span>',
				// 	width: 120,
				// 	align:'center',
				// 	formatter:formatShopWarePrice
				// };
				// cols.push(col);
				// var col = {
				// 	field: 'shopWareLsPrice',
				// 	title: '<span onclick="javascript:editPrice(2);">商城零售价(大)✎</span>',
				// 	width: 120,
				// 	align:'center',
				// 	formatter:formatShopWareLsPrice
				// };
				// cols.push(col);
				// var col = {
				// 	field: 'shopWareCxPrice',
				// 	title: '<span onclick="javascript:editPrice(3);">商城大单位促销价✎</span>',
				// 	width: 120,
				// 	align:'center',
				// 	formatter:formatShopWareCxPrice
				// };
				// cols.push(col);
				// var col = {
				// 	field: 'shopWareSmallPrice',
				// 	title: '<span onclick="javascript:editPrice(4);">商城批发价(小)✎</span>',
				// 	width: 120,
				// 	align:'center',
				// 	formatter:formatShopWareSmallPrice
				// };
				// cols.push(col);
				// var col = {
				// 	field: 'shopWareSmallLsPrice',
				// 	title: '<span onclick="javascript:editPrice(5);">商城零售价(小)✎</span>',
				// 	width: 120,
				// 	align:'center',
				// 	formatter:formatShopWareSmallLsPrice
				// };
				// cols.push(col);
				// var col = {
				// 	field: 'shopWareSmallCxPrice',
				// 	title: '<span onclick="javascript:editPrice(6);">商城小单位促销价✎</span>',
				// 	width: 120,
				// 	align:'center',
				// 	formatter:formatShopWareSmallCxPrice
				// };
				// cols.push(col);
				$('#datagrid').datagrid({
					url:"manager/shopMemberPrice/shopMemberPricePage?source=3",
					columns:[
						cols
					]}
				);
			}

			//显示会员启用状态
			function formatterStatus(val,row){
				if(val=='-2'){
					return "已取消关注";
				}else if(val=='-1'){
					return "申请中";
				}else if(val=='0'){
					return "未启用";
				}else if(val=='1'){
					return "正常";
				}
			}

			//显示会员启用状态
			function formatterOper(val,row){
				var id = row.id;
				var name = row.name;
				return "<input value='设置商品价格' type='button' onclick='setPrice("+id+",\""+name+"\")' />";
			}

			function imgFormatter(val,row){
				if(val!=""){
					return "<input  type=\"image\" src=\""+val+"\" height=\"30\" width=\"30\" align=\"middle\" />";
				}
			}

			//设置商品价格
			function setPrice(id,name){
				parent.closeWin("会员价格设置_"+name);
				window.parent.add("会员价格设置_"+name,"manager/shopMemberPrice/shopMemberPriceWareType?shopMemberId="+id);
			}





			//-----------------------商城商品价格体系：开始----------------------------------
			//商城商品大单位价格
			function formatShopWarePrice(val,row){
				var shopWarePrice = row.shopWarePrice;
				if(shopWarePrice == null || shopWarePrice == undefined || shopWarePrice === ''){
					shopWarePrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.id + ")' name='priceInput' id='priceInput"+row.id+"' value='" + shopWarePrice + "'/><span name='priceSpan' id='priceSpan"+row.id+"' >" + shopWarePrice + "</span>";
			}
			//商城商品大单位原价格
			function formatShopWareLsPrice(val,row){
				var shopWareLsPrice = row.shopWareLsPrice;
				if(shopWareLsPrice == null || shopWareLsPrice == undefined || shopWareLsPrice ==''){
					shopWareLsPrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.id + ")' name='lsPriceInput' id='lsPriceInput"+row.id+"' value='" + shopWareLsPrice + "'/><span name='lsPriceSpan' id='lsPriceSpan"+row.id+"' >" + shopWareLsPrice + "</span>";
			}
			//商城商品大单位促销价
			function formatShopWareCxPrice(val,row){
				var shopWareCxPrice = row.shopWareCxPrice;
				if(shopWareCxPrice == null || shopWareCxPrice == undefined || shopWareCxPrice ==''){
					shopWareCxPrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.id + ")' name='cxPriceInput' id='cxPriceInput"+row.id+"' value='" + shopWareCxPrice + "'/><span name='cxPriceSpan' id='cxPriceSpan"+row.id+"' >" + shopWareCxPrice + "</span>";
			}
			//商城商品小单位批发价
			function formatShopWareSmallPrice(val,row){
				var shopWareSmallPrice = row.shopWareSmallPrice;
				if(shopWareSmallPrice == null || shopWareSmallPrice == undefined || shopWareSmallPrice ==''){
					shopWareSmallPrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.id + ")' name='smallPriceInput' id='smallPriceInput"+row.id+"' value='" + shopWareSmallPrice + "'/><span name='smallPriceSpan' id='smallPriceSpan"+row.id+"' >" + shopWareSmallPrice + "</span>";
			}
			//商城商品小单位原价
			function formatShopWareSmallLsPrice(val,row){
				var shopWareSmallLsPrice = row.shopWareSmallLsPrice;
				if(shopWareSmallLsPrice == null || shopWareSmallLsPrice == undefined || shopWareSmallLsPrice ==''){
					shopWareSmallLsPrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.id + ")' name='smallLsPriceInput' id='smallLsPriceInput"+row.id+"' value='" + shopWareSmallLsPrice + "'/><span name='smallLsPriceSpan' id='smallLsPriceSpan"+row.id+"' >" + shopWareSmallLsPrice + "</span>";

			}
			//商城商品小单位促销价
			function formatShopWareSmallCxPrice(val,row){
				var shopWareSmallCxPrice = row.shopWareSmallCxPrice;
				if(shopWareSmallCxPrice == null || shopWareSmallCxPrice == undefined || shopWareSmallCxPrice ==''){
					shopWareSmallCxPrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.id + ")' name='smallCxPriceInput' id='smallCxPriceInput"+row.id+"' value='" + shopWareSmallCxPrice + "'/><span name='smallCxPriceSpan' id='smallCxPriceSpan"+row.id+"' >" + shopWareSmallCxPrice + "</span>";
			}
			//-----------------------商城商品价格体系：结束----------------------------------


			//-----------------------批量修改价格：开始----------------------------------
			//修改：商城批发价(大)
			function changePrice(obj, shopMemberId) {
				var price = $("#priceInput"+shopMemberId).val();
				var lsPrice = $("#lsPriceInput"+shopMemberId).val();
				var cxPrice = $("#cxPriceInput"+shopMemberId).val();
				var smallPrice = $("#smallPriceInput"+shopMemberId).val();
				var smallLsPrice = $("#smallLsPriceInput"+shopMemberId).val();
				var smallCxPrice = $("#smallCxPriceInput"+shopMemberId).val();
				var wareId = $("#wareId").val();;
				$("#priceSpan"+shopMemberId).text(price);
				$("#lsPriceSpan"+shopMemberId).text(lsPrice);
				$("#cxPriceSpan"+shopMemberId).text(cxPrice);
				$("#smallPriceSpan"+shopMemberId).text(smallPrice);
				$("#smallLsPriceSpan"+shopMemberId).text(smallLsPrice);
				$("#smallCxPriceSpan"+shopMemberId).text(smallCxPrice);

				$.ajax({
					url: "manager/shopMemberPrice/updateShopMemeberPrice",
					type: "post",
					data:{
						"wareId":wareId,
						"shopWarePrice":price,
						"shopWareLsPrice":lsPrice,
						"shopWareCxPrice":cxPrice,
						"shopWareSmallPrice":smallPrice,
						"shopWareSmallLsPrice":smallLsPrice,
						"shopWareSmallCxPrice":smallCxPrice,
						"shopMemberId":shopMemberId,
					},
					success: function (data) {
						if (data == '1') {
							//alert("操作成功");
						} else {
							alert("操作失败");
							return;
						}
					}
				});
			}

			var k1 = true;
			var k2 = true;
			var k3 = true;
			var k4 = true;
			var k5 = true;
			var k6 = true;
			function editPrice(kStr) {
				//验证商品id
				var wareId = $("#wareId").val();
				if(wareId == null || wareId == undefined || wareId === ""){
					alert("请先选择商品");
					return ;
				}

				var priceInput = document.getElementsByName("priceInput");
				var priceSpan = document.getElementsByName("priceSpan");
				var lsPriceInput = document.getElementsByName("lsPriceInput");
				var lsPriceSpan = document.getElementsByName("lsPriceSpan");
				var cxPriceInput = document.getElementsByName("cxPriceInput");
				var cxPriceSpan = document.getElementsByName("cxPriceSpan");
				var smallPriceInput = document.getElementsByName("smallPriceInput");
				var smallPriceSpan = document.getElementsByName("smallPriceSpan");
				var smallLsPriceInput = document.getElementsByName("smallLsPriceInput");
				var smallLsPriceSpan = document.getElementsByName("smallLsPriceSpan");
				var smallCxPriceInput = document.getElementsByName("smallCxPriceInput");
				var smallCxPriceSpan = document.getElementsByName("smallCxPriceSpan");
				for (var i = 0; i < priceInput.length; i++) {
					switch (kStr) {
						case 1:
							if (k1) {
								priceInput[i].style.display = '';
								priceSpan[i].style.display = 'none';
							} else {
								priceInput[i].style.display = 'none';
								priceSpan[i].style.display = '';
							}
							break;
						case 2:
							if (k2) {
								lsPriceInput[i].style.display = '';
								lsPriceSpan[i].style.display = 'none';
							} else {
								lsPriceInput[i].style.display = 'none';
								lsPriceSpan[i].style.display = '';
							}
							break;
						case 3:
							if (k3) {
								cxPriceInput[i].style.display = '';
								cxPriceSpan[i].style.display = 'none';
							} else {
								cxPriceInput[i].style.display = 'none';
								cxPriceSpan[i].style.display = '';
							}
							break;
						case 4:
							if (k4) {
								smallPriceInput[i].style.display = '';
								smallPriceSpan[i].style.display = 'none';
							} else {
								smallPriceInput[i].style.display = 'none';
								smallPriceSpan[i].style.display = '';
							}
							break;
						case 5:
							if (k5) {
								smallLsPriceInput[i].style.display = '';
								smallLsPriceSpan[i].style.display = 'none';
							} else {
								smallLsPriceInput[i].style.display = 'none';
								smallLsPriceSpan[i].style.display = '';
							}
							break;
						case 6:
							if (k6) {
								smallCxPriceInput[i].style.display = '';
								smallCxPriceSpan[i].style.display = 'none';
							} else {
								smallCxPriceInput[i].style.display = 'none';
								smallCxPriceSpan[i].style.display = '';
							}
							break;
					}
				}
				switch (kStr) {
					case 1:
						k1 = !k1;
						break;
					case 2:
						k2 = !k2;
						break;
					case 3:
						k3 = !k3;
						break;
					case 4:
						k4 = !k4;
						break;
					case 5:
						k5 = !k5;
						break;
					case 6:
						k6 = !k6;
						break;
				}
			}

		</script>
	</body>
</html>
