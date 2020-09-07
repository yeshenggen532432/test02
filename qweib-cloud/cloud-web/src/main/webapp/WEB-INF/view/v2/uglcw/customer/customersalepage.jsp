<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>驰用T3</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/wares?wtype=${wtype}" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="wareId" width="10" align="center" hidden="true">
						商品id
					</th>
					<th field="wareCode" width="80" align="center">
						商品编码
					</th>
					<th field="wareNm" width="100" align="center">
						商品名称
					</th>
					<th field="waretypeNm" width="80" align="center">
						所属分类
					</th>
					<th field="wareGg" width="80" align="center">
						规格
					</th>
					<th field="wareDw" width="60" align="center">
						单位
					</th>
					<th field="wareDj" width="60" align="center">
						单价
					</th>
					<th field="tcAmt" width="60" align="center" formatter="formattcAmt">
						业务提成
					</th>
					<th field="fbtime" width="100" align="center">
						发布时间
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			<input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" id="editPrice" href="javascript:editPrice();">编辑费用</a>
		</div>
		<script type="text/javascript">
		 var salePriceDatas = eval('${salePrice}');
		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/wares",
					wareNm:$("#wareNm").val()
				});
			}
			
			function formattcAmt(val,row,index){
				var tcAmt = row.tcAmt;
				if(tcAmt==undefined||tcAmt=="undefined"){
					tcAmt=0.0;
				}
				var html = "<input type='hidden' id='clientWareId"+index+"' /><input type='text' style='display:none' size='7' onchange='changeTranPrice(this,"+row.wareId+","+index+")' name='tcAmt' value='"+tcAmt+"'/><span name='tcAmt1'>"+tcAmt+"</span>";
				if(salePriceDatas.length>0){
					for(var i=0;i<salePriceDatas.length;i++){
						var json = salePriceDatas[i];
						if(json.wareId==row.wareId){
							tcAmt = json.tcAmt;
							html = "<input type='hidden' id='clientWareId"+index+"' value="+json.id+" /><input type='text' style='display:none' size='7' onchange='changeTranPrice(this,"+row.wareId+","+index+")' name='tcAmt' value='"+tcAmt+"'/><span  name='tcAmt1'>"+tcAmt+"</span>";
							break;
						}
					}
					return html;
					}else{
				return "<input type='hidden' id='clientWareId"+index+"'/><input type='text' style='display:none' size='7' onchange='changeTranPrice(this,"+row.wareId+","+index+")' name='tcAmt' value='"+tcAmt+"'/><span name='tcAmt1'>"+tcAmt+"</span>";
				}
			}
			function changeTranPrice(obj,wareId,index){
				var id = document.getElementById("clientWareId"+index).value;
				$.ajax({
					url:"manager/updateSysCustomerSalePrice",
					type:"post",
					data:"id="+id+"&wareId="+wareId+"&tcAmt="+obj.value+"&customerId=${param.customerId}",
					success:function(data){
						if(data!='0'){
						    //alert("操作成功");
							//queryWare();
						}else{
							alert("操作失败");
							return;
						}
					}
				});
			}
			var k=1;
			function editPrice(){
				var tcAmt = document.getElementsByName("tcAmt");
				var tcAmt1 = document.getElementsByName("tcAmt1");
				for(var i=0;i<tcAmt.length;i++){
					if(k==1){
						tcAmt[i].style.display='';
						tcAmt1[i].style.display='none';
					}else{
						tcAmt[i].style.display='none';
						tcAmt1[i].style.display='';
					}
				}
				if(k==1){
					document.getElementById("editPrice").innerHTML="关闭单位提成费用";
					k=0;
				}else{
					document.getElementById("editPrice").innerHTML="编辑单位提成费用";
					k=1;
				}
			}
		</script>
	</body>
</html>
