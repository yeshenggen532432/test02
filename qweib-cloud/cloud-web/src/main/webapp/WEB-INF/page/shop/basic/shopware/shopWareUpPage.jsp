<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>商城分组商品</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
	<body>
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/shopWare/uppage?wtype=${wtype}&groupIds=${groupIds}" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th  field="wareId" checkbox="true"></th>
					<c:choose><%--排序分为商品排序和分组排序zzx--%>
						<c:when test="${groupIds!=null && groupIds !=''}"><th field="groupSort" width="80" align="center" formatter="formatSort"></c:when>
						<c:otherwise><th field="shopSort" width="80" align="center" formatter="formatSort"></c:otherwise>
					</c:choose>
						<span onclick="javascript:editSort();" title="越小越前">排序✎</span>
					</th>
					<th field="wareNm" width="100" align="center">
						商品名称
					</th>
					<th field="wareGg" width="80" align="center">
						规格
					</th>
					<th field="wareDw" width="80" align="center">
						单位
					</th>
					<th field="wareDj" width="80" align="center">
						批发价
					</th>
					<th field="lsPrice" width="80" align="center">
						原价
					</th>
					<%--<th field="shopWarePrice" width="120" align="center" formatter="formatShopWarePrice">
						<span onclick="javascript:editPrice();">商城批发价(大)✎</span>
					</th>
					<th field="shopWareLsPrice" width="120" align="center" formatter="formatShopWareLsPrice">
						<span onclick="javascript:editLsPrice();">商城零售价(大)✎</span>
					</th>--%>
					<th field="shopWarePrice" width="120" align="center">
						商城批发价(大)
					</th>
					<th field="shopWareLsPrice" width="120" align="center">
						商城零售价(大)
					</th>
					<th field="_picture" width="600" align="left" formatter="formatPicture">
						图片
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
		    <input id="groupIds" name="groupIds" type="hidden" value="${groupIds }">
			<input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
		</div>
		<div id="bigPicDiv"  class="easyui-window" title="图片" style="width:315px;height:400px;top: 110px;overflow: hidden;" 
			minimizable="false" maximizable="false"   collapsible="false" 
			 closed="true">
			  <img style="width: 300px;height:300px;" id="photoImg" alt=""/>
			  <input type="hidden" id="photoId" />
			   <input type="hidden" id="wareId" />
		</div>	
	</div>
	<script type="text/javascript">
		//--------------排序修改开始
		function formatSort(val,row){
			if(!val)val="";
			return "<input type='text' class='number' style='display:none' size='5' maxlength='5'  onchange='changeSort(this," + row.wareId + ")' name='sortInput' value='" + val + "'/><span name='sortSpan'>" + val + "</span>";
		}
		function editSort() {
			var sortInput = document.getElementsByName("sortInput");
			var sortSpan = document.getElementsByName("sortSpan");
			var isShow=sortInput[0].style.display;
			for (var i = 0; i < sortInput.length; i++) {
				if (isShow=='none') {
					sortInput[i].style.display = '';
					sortSpan[i].style.display = 'none';
				} else {
					sortInput[i].style.display = 'none';
					sortSpan[i].style.display = '';
				}
			}
		}
		function changeSort(obj, wareId) {
			var value=obj.value;
			if(value && !isNumber(value)){
				alert("请输入正整数");
				return false;
			}
			$(obj).parent("div").find("span").text(value);
			var url="/manager/shopWare/updateSort";
			<c:if test="${groupIds !=null && groupIds !=''}">
			url="/manager/shopGroupWare/updateSort";
			</c:if>
			$.ajax({
				url: url,
				type: "post",
				data: "groupIds=${groupIds }&wareId=" + wareId + "&sort=" + value,
				success: function (data) {
					if (data==1) {
						//alert("操作成功");
					} else {
						alert("操作失败");
						return;
					}
				}
			});
		}
		//--------------排序修改结束

		//查询
		function queryWare(){
			$("#datagrid").datagrid('load',{
				url:"manager/shopWare/topage",
				   wareNm:$("#wareNm").val(),
				   putOn:$("#putOn").val()
			});
		}

		//图片
		function formatPicture(val,row){
			var html="";
			if(row.warePicList!=null && row.warePicList.length>0){
				for(var i=0;i<row.warePicList.length;i++){
					var color = "";
					if(row.warePicList[i].type=="1"){
						color = "border:1px solid #ff0000";
					}
					html+="&nbsp;&nbsp;<img  onclick='toBigPic(\""+row.warePicList[i].pic+"\",\""+row.warePicList[i].id+"\",\""+row.wareId+"\")' style='width: 80px;height: 80px;"+color+"' src='upload/"+row.warePicList[i].picMini+"'/>";
				}
			}
			return html;
		}

		//放大图片
		function toBigPic(picurl,photoId,wareId){
			   document.getElementById("photoImg").setAttribute("src","${base}upload/"+picurl);
			   document.getElementById("photoId").value=photoId;
			   document.getElementById("wareId").value=wareId;
			   $("#bigPicDiv").window("open");
		   }
		   $('#bigPicDiv').window({
			 onBeforeClose:function(){
			   document.getElementById("photoImg").setAttribute("src","");
			   document.getElementById("photoId").value="";
			   document.getElementById("wareId").value="";
			 }
		   });

		//-----------------------商城商品价格体系：开始----------------------------------
		//商城商品大单位价格
		function formatShopWarePrice(val,row){
			var shopWarePrice = row.shopWarePrice;
			if(shopWarePrice == null || shopWarePrice == undefined || shopWarePrice ===''){
				shopWarePrice = row.wareDj;
			}
			return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.wareId + ")' name='priceInput' id='priceInput"+row.wareId+"' value='" + shopWarePrice + "'/><span name='priceSpan' id='priceSpan"+row.wareId+"' >" + shopWarePrice + "</span>";
		}
		//商城商品大单位原价格
		function formatShopWareLsPrice(val,row){
			var shopWareLsPrice = row.shopWareLsPrice;
			var lsPrice = row.lsPrice;
			if(shopWareLsPrice == null || shopWareLsPrice == undefined || shopWareLsPrice ===''){
				shopWareLsPrice = lsPrice;
				if(lsPrice == null || lsPrice == undefined || lsPrice ==''){
					shopWareLsPrice = "";
				}
			}
			return "<input type='text' style='display:none' size='7'  onchange='changeLsPrice(this," + row.wareId + ")' name='lsPriceInput' id='lsPriceInput"+row.wareId+"' value='" + shopWareLsPrice + "'/><span name='lsPriceSpan' id='lsPriceSpan"+row.wareId+"' >" + shopWareLsPrice + "</span>";
		}
		//-----------------------商城商品价格体系：结束----------------------------------


		//-----------------------批量修改价格：开始----------------------------------
		var k = 1;
		//编辑：商城批发价(大)
		function editPrice() {
			var priceInput = document.getElementsByName("priceInput");
			var priceSpan = document.getElementsByName("priceSpan");
			// var lsPriceInput = document.getElementsByName("lsPriceInput");
			// var lsPriceSpan = document.getElementsByName("lsPriceSpan");
			for (var i = 0; i < priceInput.length; i++) {
				if (k == 1) {
					priceInput[i].style.display = '';
					priceSpan[i].style.display = 'none';
					// lsPriceInput[i].style.display = '';
					// lsPriceSpan[i].style.display = 'none';
				} else {
					priceInput[i].style.display = 'none';
					priceSpan[i].style.display = '';
					// lsPriceInput[i].style.display = 'none';
					// lsPriceSpan[i].style.display = '';
				}
			}
			if (k == 1) {
				// document.getElementById("editPrice").innerHTML = "关闭编辑商城批发价(大)";
				k = 0;
			} else {
				// document.getElementById("editPrice").innerHTML = "编辑商城批发价(大)";
				k = 1;
			}
		}

		var lsK = 1;
		//编辑：商城零售价(大)
		function editLsPrice() {
			var lsPriceInput = document.getElementsByName("lsPriceInput");
			var lsPriceSpan = document.getElementsByName("lsPriceSpan");
			for (var i = 0; i < lsPriceInput.length; i++) {
				if (lsK == 1) {
					lsPriceInput[i].style.display = '';
					lsPriceSpan[i].style.display = 'none';
				} else {
					lsPriceInput[i].style.display = 'none';
					lsPriceSpan[i].style.display = '';
				}
			}
			if (lsK == 1) {
				// document.getElementById("editLsPrice").innerHTML = "关闭编辑商城零售价(大)";
				lsK = 0;
			} else {
				// document.getElementById("editLsPrice").innerHTML = "编辑商城零售价(大)";
				lsK = 1;
			}
		}

		//修改：商城批发价(大)
		function changePrice(obj, wareId) {
			$("#priceSpan"+wareId).text(obj.value);
			var lsPrice = $("#lsPriceInput"+wareId).val();
			$.ajax({
				url: "manager/shopWare/updateShopWarePrice",
				type: "post",
				data: "wareId=" + wareId + "&shopWarePrice=" + obj.value+"&shopWareLsPrice="+lsPrice,
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

		//修改：商城零售价(大)
		function changeLsPrice(obj, wareId) {
			$("#lsPriceSpan"+wareId).text(obj.value);
			var price = $("#priceInput"+wareId).val();
			$.ajax({
				url: "manager/shopWare/updateShopWarePrice",
				type: "post",
				data: "wareId=" + wareId + "&shopWarePrice=" + price+"&shopWareLsPrice="+obj.value,
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

		</script>
	</body>
</html>
