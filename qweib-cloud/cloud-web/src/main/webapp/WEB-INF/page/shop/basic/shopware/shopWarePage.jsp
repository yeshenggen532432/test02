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
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<table id="datagrid"  fit="true"  singleSelect="false" border="false"
			   url="manager/shopWare/page?waretype=${wtype}&groupIds=${groupIds}"
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
		     上架状态: <select name="putOn" id="putOn">
		     			<option value="-1">全部</option>
						<option value="0" >未上架</option>
						<option value="1" selected>已上架</option>
		     		</select>
		    <input type="hidden" name="groupIds" id="groupIds" value="${groupIds}"/>
			<input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true"  href="javascript:queryWare();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true"  href="javascript:putOn(1);">上架</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true"  href="javascript:putOn(0);">下架</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true"  href="javascript:updateWareGroup();">设置分组</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true"  href="javascript:toupdateware();">修改</a>
		</div>
		<div id="bigPicDiv"  class="easyui-window" title="图片" style="width:315px;height:400px;top: 110px;overflow: hidden;" 
			minimizable="false" maximizable="false"  collapsible="false" 
			 closed="true">
			  <img style="width: 300px;height:300px;" id="photoImg" alt=""/>
			  <input type="hidden" id="photoId" />
			   <input type="hidden" id="wareId" />
			  <input type="button" value="设为主图" onclick="setWareMainPic()" style="margin-left: 130px;margin-top: 10px"/>
		</div>	
		<div id="dlg" closed="true" class="easyui-dialog" title="商品分组" style="width:250px;height:130px;padding:10px;"
				   data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						batchUpdateWareGroup();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
			<input class="easyui-combobox"
				   name="wareGroupComb",
				   id="wareGroupComb"
				   data-options="
					url:'manager/shopWareGroup/list',
					method:'post',
					valueField:'id',
					textField:'name',
					multiple:true,
					panelHeight:'auto'
			">
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
					<%--排序分为商品排序和分组排序zzx--%>
					<c:choose>
					<c:when test="${groupIds!=null && groupIds !=''}">field: 'groupSort',</c:when>
					<c:otherwise>field: 'shopSort',</c:otherwise>
					</c:choose>
					title: '<span onclick="javascript:editSort();" title="越小越前">排序✎</span>',
					width: 80,
					align:'center',
					formatter:formatSort
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
				var col = {
					field: 'shopWarePrice',
					//title: '<span onclick="javascript:editPrice();">商城批发价(大)✎</span>',
					title: '商城批发价(大)',
					width: 120,
					align:'center',
					formatter:formatShopWarePrice
				};
				cols.push(col);
				var col = {
					field: 'shopWareLsPrice',
					//title: '<span onclick="javascript:editLsPrice();">商城零售价(大)✎</span>',
					title: '商城零售价(大)',
					width: 120,
					align:'center',
					formatter:formatShopWareLsPrice
				};
				cols.push(col);
				var col = {
					field: 'putOn',
					title: '上架状态',
					width: 80,
					align:'center',
					formatter:formatPutOn
				};
				cols.push(col);
				var col = {
					field: 'groupNms',
					title: '商品分组',
					width: 200,
					align:'left',
				};
				cols.push(col);
				var col = {
					field: 'wareDesc',
					title: '商品描述',
					width: 105,
					align:'left',
					formatter:formatWareDesc
				};
				cols.push(col);
				var col = {
					field: '_picture',
					title: '图片',
					width: 600,
					align:'left',
					formatter:formatPicture
				};
				cols.push(col);
				$('#datagrid').datagrid({
					url:"manager/shopWare/page?waretype=${wtype}&groupIds=${groupIds}",
					queryParams:{
						putOn:$("#putOn").val(),
					},
					columns:[
						cols
					]}
				);
			}


		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopWare/page",
					   wareNm:$("#wareNm").val(),
					   putOn:$("#putOn").val()
				});
			}

			//修改商品分组
			function updateWareGroup(){
				var rows = $('#datagrid').datagrid('getSelections');
				var ids = "";
				for(var i=0;i<rows.length;i++){
					ids=ids+","+rows[i].wareId;
				}
				$('#wareGroupComb').combobox('setValues', []);
				$('#dlg').dialog('open');
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
			//上架状态
			function formatPutOn(val,row){
				var html="未上架";
				if(val=="1"){
					html="已上架";
				}
				return html;
			}
			//商品描述
			function formatWareDesc(val,row){
				var html="<button onclick=\"toupdateware2("+row.wareId+");\">请设置商品描述</button>";
				if(val!=null && val!=""){
					html="<button onclick=\"toupdateware2("+row.wareId+");\">已描述</button>";
				}
				return html;
			}
			//设置商品主图
			function setWareMainPic(){
				var photoId= document.getElementById("photoId").value;
				if(photoId==""){
					$.messager.alert('Info','请选中图片!');
					return;
				}
				var wareId=  document.getElementById("wareId").value;
				$.messager.confirm('确定','确定设置该主图?',function(r){
				    if (r){
				    	$.ajax({
							url:"manager/shopWare/updateWareMainPic",
							data:"wareId="+wareId+"&picId="+photoId,
							type:"post",
							success:function(json){
								if(json!="-1"){
									$.messager.alert('Info','设置主图成功！');
								}else{
									$.messager.alert('Error','设置失败！');
								    return;
								}
							}
						});
				    }
				});
			}
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

			//修改上架或下架
			function putOn(putOn){
				var rows = $('#datagrid').datagrid('getSelections');
				var ids = "";
				for(var i=0;i<rows.length;i++){
					if(ids!=''){
						ids=ids+",";
					}
					ids=ids+rows[i].wareId;
				}
				if(ids==""){
					$.messager.alert('Warning','请选择商品！');
					return;
				}
				$.messager.confirm('确定','是否确定该操作?',function(r){
					if (r){
						$.ajax({
							url:"manager/shopWare/updateBatchPutOnWare",
							data:"ids="+ids+"&putOn="+putOn,
							type:"post",
							success:function(json){
								if(json!="-1"){
									queryWare();
								}else{
									$.messager.alert('Error','更新失败！');
									return;
								}
							}
						});
					}
				});
			}
				
			$('#wareGroup').combobox({
				url:'manager/shopWareGroup/list',
				method:'post',
				valueField:'id',
				textField:'name',
				panelHeight:'auto',
				multiple:true,
				formatter: function (row) {
					var opts = $(this).combobox('options');
					return '<input type="checkbox" class="combobox-checkbox">' + row[opts.textField]
				},
				onLoadSuccess : function(){//在加载远程数据成功的时候触发
					var opts = $(this).combobox("options");
					var target = this;
					var values = $(target).combobox("getValues");
					$.map(values, function(value){
						var children = $(target).combobox("panel").children();
						$.each(children, function(index, obj){
							if(value == obj.getAttribute("value") && obj.children && obj.children.length > 0){
								obj.children[0].checked = true;
								}
						});
					});
				},
				onSelect : function(row){//在用户选择列表项的时候触发。
					var opts = $(this).combobox("options");
					var objCom = null;
					var children = $(this).combobox("panel").children();
					$.each(children, function(index, obj){
					console.log(obj.getAttribute("value"));
						if(row[opts.valueField] == obj.getAttribute("value")){
						objCom = obj;
					}
					});
					if(objCom != null && objCom.children && objCom.children.length > 0){
						objCom.children[0].checked = true;
					}
				},
				onUnselect : function(row){//在用户取消选择列表项的时候触发。
					var opts = $(this).combobox("options");
					var objCom = null;
					var children = $(this).combobox("panel").children();
					$.each(children, function(index, obj){
						if(row[opts.valueField] == obj.getAttribute("value")){
							objCom = obj;
						}
					});
					if(objCom != null && objCom.children && objCom.children.length > 0){
						objCom.children[0].checked = false;
					}
				}
			});
				
			function batchUpdateWareGroup(){
				var rows = $('#datagrid').datagrid('getSelections');
				var ids = "";
				for(var i=0;i<rows.length;i++){
					if(ids!=''){
						ids=ids+",";
					}
					ids=ids+rows[i].wareId;
				}
				if(ids==""){
					$.messager.alert('Warning','请选择商品！');
					return;
				}
				var wareGroupId=$("#wareGroupComb").combobox("getValues");
				var wareGroupName=$("#wareGroupComb").combobox("getText");

				$.messager.confirm('Confirm','是否确定更改商品分组?',function(r){
					if (r){
						$.ajax({
							url:"manager/shopGroupWare/batchUpdateWareGroup",
							data:"ids="+ids+"&groupIds="+wareGroupId+"&groupNms="+wareGroupName,
							type:"post",
							success:function(json){
								if(json!="-1"){
									//alert("更新成功");
									$('#dlg').dialog('close');
									queryWare();
								}else{
									$.messager.alert('Error','商品类别更新失败！');
									return;
								}
							}
						});
					}
				});

			}
				
			//修改商品
			function toupdateware(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
				    var wareId = row.wareId;
				    window.location.href="${base}/manager/shopWare/toUpdateWare?Id="+wareId+"&wtype="+$("#wtype").val()+"&groupIds="+$("#groupIds").val();
				}else{
					alert("请选择行");
				}
			}
			//修改商品
			function toupdateware2(wareId){
				window.location.href="${base}/manager/shopWare/toUpdateWare?Id="+wareId+"&wtype="+$("#wtype").val()+"&groupIds="+$("#groupIds").val();
			}


			//-----------------------商城商品价格体系：开始----------------------------------
			//商城商品大单位价格
			function formatShopWarePrice(val,row){
				var shopWarePrice = row.shopWarePrice;
				if(shopWarePrice == null || shopWarePrice == undefined || shopWarePrice ==''){
					shopWarePrice = row.wareDj;
				}
				return "<input type='text' style='display:none' size='7'  onchange='changePrice(this," + row.wareId + ")' name='priceInput' id='priceInput"+row.wareId+"' value='" + shopWarePrice + "'/><span name='priceSpan' id='priceSpan"+row.wareId+"' >" + shopWarePrice + "</span>";
			}
			//商城商品大单位原价格
			function formatShopWareLsPrice(val,row){
				var shopWareLsPrice = row.shopWareLsPrice;
				var lsPrice = row.lsPrice;
				if(shopWareLsPrice == null || shopWareLsPrice == undefined || shopWareLsPrice ==''){
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
					data: "groupIds=${groupIds}&wareId=" + wareId + "&sort=" + value,
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
		</script>
	</body>
</html>
