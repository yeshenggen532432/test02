<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>商城商品</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
	<body>
	<%--备注：class="easyui-datagrid" 默认会请求一次数据--%>
	<%--url="manager/shopWare/page?wtype=${wtype}&groupIds=${groupIds}" class="easyui-datagrid"--%>
		<%--<input type="hidden" name="wtype" id="wtype" value="${wareType}"/>--%>
		<table id="datagrid"  fit="true"  singleSelect="false" border="false"
			   url="manager/shopWare/shopWarePricePage?wareType=${wareType}"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<%--<tr>--%>
					<%--<th  field="wareId" checkbox="true"></th>--%>
					<%--<th field="waretypeNm" width="80" align="center">--%>
						<%--所属分类--%>
					<%--</th>--%>
					<%--<th field="wareNm" width="100" align="center">--%>
						<%--商品名称--%>
					<%--</th>--%>
					<%--<th field="wareGg" width="80" align="center">--%>
						<%--规格--%>
					<%--</th>--%>
					<%--<th field="wareDw" width="80" align="center">--%>
						<%--单位--%>
					<%--</th>--%>
					<%--<th field="wareDj" width="80" align="center">--%>
						<%--批发价--%>
					<%--</th>--%>
					<%--<th field="lsPrice" width="80" align="center">--%>
						<%--原价--%>
					<%--</th>--%>
					<%--<th field="shopWarePrice" width="100" align="center" formatter="formatShopWarePrice">--%>
						<%--商城批发价(大)--%>
					<%--</th>--%>
					<%--<th field="shopWareLsPrice" width="100" align="center" formatter="formatShopWareLsPrice">--%>
						<%--商城零售价(大)--%>
					<%--</th>--%>
					<%--<th field="putOn" width="100" align="center" formatter="formatPutOn">--%>
						<%--上架状态--%>
					<%--</th>--%>
					<%--<th field="groupNms" width="200" align="left">--%>
						<%--商品分组--%>
					<%--</th>--%>
					<%--<th field="wareDesc" width="105" align="left" formatter="formatWareDesc">--%>
						<%--商品描述--%>
					<%--</th>--%>
					<%--<th field="_picture" width="600" align="left" formatter="formatPicture">--%>
						<%--图片--%>
					<%--</th>--%>
				<%--</tr>--%>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			<input type="hidden" name="wtype" id="wtypeid" value="${wareType}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true"  href="javascript:queryWare();">查询</a>
		</div>
	</div>
		
		<script type="text/javascript">
			$(function(){
				initGrid();
			})

			function initGrid(){
				var cols = new Array();
				var col = {
					field: 'wareId',
					title: 'id',
					width: 50,
					align:'center',
					checkbox:'true'
				};
				cols.push(col);
				var col = {
					field: 'waretypeNm',
					title: '所属分类',
					width: 80,
					align:'center',
				};
				cols.push(col);
				var col = {
					field: 'wareNm',
					title: '商品名称',
					width: 100,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'wareGg',
					title: '规格',
					width: 80,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'wareDj',
					title: '批发价',
					width: 80,
					align:'center'
				};
				cols.push(col);
				var col = {
					field: 'lsPrice',
					title: '原价',
					width: 80,
					align:'center'
				};
				cols.push(col);
				/*var col = {
					field: 'shopWarePrice',
					title: '<span onclick="javascript:editPrice(1);">商城批发价(大)✎</span>',
					width: 120,
					align:'center',
					formatter:formatShopWarePrice
				};
				cols.push(col);*/
				var col = {
					field: 'shopWareLsPrice',
					title: '<span onclick="javascript:editPrice(2);">商城零售价(大)✎</span>',
					width: 120,
					align:'center',
					formatter:formatShopWareLsPrice
				};
				cols.push(col);
				/*var col = {
					field: 'shopWareCxPrice',
					title: '<span onclick="javascript:editPrice(3);">商城大单位促销价✎</span>',
					width: 120,
					align:'center',
					formatter:formatShopWareCxPrice
				};
				cols.push(col);
				var col = {
					field: 'shopWareSmallPrice',
					title: '<span onclick="javascript:editPrice(4);">商城批发价(小)✎</span>',
					width: 120,
					align:'center',
					formatter:formatShopWareSmallPrice
				};
				cols.push(col);*/
				var col = {
					field: 'shopWareSmallLsPrice',
					title: '<span onclick="javascript:editPrice(5);">商城零售价(小)✎</span>',
					width: 120,
					align:'center',
					formatter:formatShopWareSmallLsPrice
				};
				cols.push(col);
				/*var col = {
					field: 'shopWareSmallCxPrice',
					title: '<span onclick="javascript:editPrice(6);">商城小单位促销价✎</span>',
					width: 120,
					align:'center',
					formatter:formatShopWareSmallCxPrice
				};
				cols.push(col);*/
				$('#datagrid').datagrid({
					url:"manager/shopWare/shopWarePricePage?wareType=${wareType}",
					columns:[
						cols
					]}
				);
			}

		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopWare/shopWarePricePage",
					   wareNm:$("#wareNm").val(),
				});
			}

			//-----------------------商城商品价格体系：开始----------------------------------
			//商城商品大单位价格
			function formatShopWarePrice(val,row){
				var shopWarePrice = row.shopWarePrice;
				if(shopWarePrice == null || shopWarePrice == undefined || shopWarePrice === ''){
					// shopWarePrice = row.wareDj;
					shopWarePrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.wareId + ")' name='priceInput' id='priceInput"+row.wareId+"' value='" + shopWarePrice + "'/><span name='priceSpan' id='priceSpan"+row.wareId+"' >" + shopWarePrice + "</span>";
			}
			//商城商品大单位原价格
			function formatShopWareLsPrice(val,row){
				var shopWareLsPrice = row.shopWareLsPrice;
				// var lsPrice = row.lsPrice;
				if(shopWareLsPrice == null || shopWareLsPrice == undefined || shopWareLsPrice ==''){
					// shopWareLsPrice = lsPrice;
					// if(lsPrice == null || lsPrice == undefined || lsPrice === ''){
						shopWareLsPrice = "";
					// }
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.wareId + ")' name='lsPriceInput' id='lsPriceInput"+row.wareId+"' value='" + shopWareLsPrice + "'/><span name='lsPriceSpan' id='lsPriceSpan"+row.wareId+"' >" + shopWareLsPrice + "</span>";
			}
			//商城商品大单位促销价
			function formatShopWareCxPrice(val,row){
				var shopWareCxPrice = row.shopWareCxPrice;
				if(shopWareCxPrice == null || shopWareCxPrice == undefined || shopWareCxPrice ==''){
					shopWareCxPrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.wareId + ")' name='cxPriceInput' id='cxPriceInput"+row.wareId+"' value='" + shopWareCxPrice + "'/><span name='cxPriceSpan' id='cxPriceSpan"+row.wareId+"' >" + shopWareCxPrice + "</span>";
			}
			//商城商品小单位批发价
			function formatShopWareSmallPrice(val,row){
				var shopWareSmallPrice = row.shopWareSmallPrice;
				if(shopWareSmallPrice == null || shopWareSmallPrice == undefined || shopWareSmallPrice ==''){
					shopWareSmallPrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.wareId + ")' name='smallPriceInput' id='smallPriceInput"+row.wareId+"' value='" + shopWareSmallPrice + "'/><span name='smallPriceSpan' id='smallPriceSpan"+row.wareId+"' >" + shopWareSmallPrice + "</span>";
			}
			//商城商品小单位原价
			function formatShopWareSmallLsPrice(val,row){
				var shopWareSmallLsPrice = row.shopWareSmallLsPrice;
				if(shopWareSmallLsPrice == null || shopWareSmallLsPrice == undefined || shopWareSmallLsPrice ==''){
					shopWareSmallLsPrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.wareId + ")' name='smallLsPriceInput' id='smallLsPriceInput"+row.wareId+"' value='" + shopWareSmallLsPrice + "'/><span name='smallLsPriceSpan' id='smallLsPriceSpan"+row.wareId+"' >" + shopWareSmallLsPrice + "</span>";

			}
			//商城商品小单位促销价
			function formatShopWareSmallCxPrice(val,row){
				var shopWareSmallCxPrice = row.shopWareSmallCxPrice;
				if(shopWareSmallCxPrice == null || shopWareSmallCxPrice == undefined || shopWareSmallCxPrice ==''){
					shopWareSmallCxPrice = "";
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.wareId + ")' name='smallCxPriceInput' id='smallCxPriceInput"+row.wareId+"' value='" + shopWareSmallCxPrice + "'/><span name='smallCxPriceSpan' id='smallCxPriceSpan"+row.wareId+"' >" + shopWareSmallCxPrice + "</span>";
			}
			//-----------------------商城商品价格体系：结束----------------------------------


			//-----------------------批量修改价格：开始----------------------------------
			//修改：商城批发价(大)
			function changePrice(obj, wareId) {
				var price = $("#priceInput"+wareId).val();
				var lsPrice = $("#lsPriceInput"+wareId).val();
				var cxPrice = $("#cxPriceInput"+wareId).val();
				var smallPrice = $("#smallPriceInput"+wareId).val();
				var smallLsPrice = $("#smallLsPriceInput"+wareId).val();
				var smallCxPrice = $("#smallCxPriceInput"+wareId).val();
				$("#priceSpan"+wareId).text(price);
				$("#lsPriceSpan"+wareId).text(lsPrice);
				$("#cxPriceSpan"+wareId).text(cxPrice);
				$("#smallPriceSpan"+wareId).text(smallPrice);
				$("#smallLsPriceSpan"+wareId).text(smallLsPrice);
				$("#smallCxPriceSpan"+wareId).text(smallCxPrice);
				$.ajax({
					url: "manager/shopWare/updateShopWarePrice",
					type: "post",
					data:{
						"wareId":wareId,
						"shopWarePrice":price,
						"shopWareLsPrice":lsPrice,
						"shopWareCxPrice":cxPrice,
						"shopWareSmallPrice":smallPrice,
						"shopWareSmallLsPrice":smallLsPrice,
						"shopWareSmallCxPrice":smallCxPrice,
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
				for (var i = 0; i < lsPriceInput.length; i++) {
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
