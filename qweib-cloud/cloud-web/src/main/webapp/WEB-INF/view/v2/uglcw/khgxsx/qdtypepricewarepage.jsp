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
			rownumbers="true" striped="true"  pagination="true" pagePosition=3
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
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" value="${param.wareNm }" onkeydown="toQuery(event);"/>
			<input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
			<%--<a class="easyui-linkbutton" iconCls="easyui-linkbutton" href="javascript:queryWare();">只显示修改的渠道价格</a>

			<a id="btnShowColumn" class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true">显示列</a>
			<a id="btnHideColumn" class="easyui-linkbutton" data-options="iconCls:'icon-import',plain:true">隐藏列</a>
			--%>
		</div>
		<script type="text/javascript">
		 var datas = '${typePriceJson}';
		 var typeTitleDatas = eval('${typeTitleJson}');
		 var typePriceDatas = eval(datas);
		 function initGrid()
		    {
		    	    var cols = new Array();
		    	    var col = {
							field: 'wareId',
							title: '商品id',
							width: 50,
							align:'center',
							hidden:'true'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'wareCode',
							title: '商品编码',
							width: 50,
							align:'center',
							hidden:'true'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'wareNm',
							title: '商品名称',
							width: 135,
							align:'center'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'waretypeNm',
							title: '所属分类',
							width: 70,
							align:'center'

					};
		    	    cols.push(col);
		    	    var col = {
							field: 'wareGg',
							title: '规格',
							width: 60,
							align:'center'

					};
		    	    cols.push(col);

		    	    var col = {
							field: 'wareDw',
							title: '单位',
							width: 30,
							align:'center'

					};
		    	    cols.push(col);
		    	    var cols2 = new Array();
		    	    if(typeTitleDatas.length>0){
		    	    	for(var i=0;i<typeTitleDatas.length;i++){
		    	    		var json = typeTitleDatas[i];
		    	    		  var col = {
		  							field: 'type'+json.qdtpNm,
		  							title: ''+json.qdtpNm,
		  							width: 70,
		  							align:'center',
		  							formatter:formatTypeAmt,
		  							value:json.id
		  					};
		  		    	    cols2.push(col);
		    	    	}
					}
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/wares",
		    	    	queryParams:{
		    	    		wareNm:$("#wareNm").val(),
		    	    		wtype:'${wtype}'
			    	    	},
			    	    	frozenColumns:[
			    	    		  		cols
			    	    		  	],
		    	    		columns:[
		    	    		  		cols2
		    	    		  	]}
		    	    );
			}
		    //查询
		    var isShow=1;
			function queryWare(){

				/*isShow=isShow*(-1);
				$("#datagrid").datagrid('load',{
					url:"manager/wares",
					wareNm:$("#wareNm").val(),
					wtype:'${wtype}'
				});*/
				//isShow=isShow*(-1);
				window.location.href="${base}/manager/qdtypepricewarepage?isShow="+isShow+"&wareNm="+$("#wareNm").val()+"&wtype:${wtype}";
			}

			function show(){
				$("#datagrid").datagrid('load',{
					url:"manager/wares",
					wareNm:$("#wareNm").val(),
					wtype:'${wtype}'
				});
				isShow=1;
			}
		    function formatTypeAmt(val,row,index){
		    	var price = "";
		    	/*if('${param.isShow}'==1){
		    		price = "";
		    	}
		    	if('${param.isShow}'!=""){
		    		isShow = '${param.isShow}';
		    	}*/

		    	var html ="<input type='hidden' id='type_price_Id_"+row.wareId+"_"+this.value+"'/><input type='text' name='typePrice' size='7' onchange='changeWareTypePrice("+row.wareId+","+this.value+")' id='type_Price_"+row.wareId+"_"+this.value+"' value='"+price+"' />";
		    	if(typePriceDatas.length>0){
		    		for(var i=0;i<typePriceDatas.length;i++){
		    			var json = typePriceDatas[i];
		    			if(json.wareId==row.wareId&&json.relaId==this.value){
		    				html ="<input type='hidden' id='type_price_Id_"+row.wareId+"_"+this.value+"' value='"+json.id+"'/><input type='text' name='typePrice' size='7' onchange='changeWareTypePrice("+row.wareId+","+this.value+")' id='type_Price_"+row.wareId+"_"+this.value+"' value='"+json.price+"' />";
		    				break;
		    			}
		    		}
		    	}
		    	return html;
		    }

		    function changeWareTypePrice(wareId,typeId){
		    	var typePriceId = document.getElementById("type_price_Id_"+wareId+"_"+typeId).value;
				var typePrice =  document.getElementById("type_Price_"+wareId+"_"+typeId).value;
				$.ajax({
					url:"manager/updateQdTypePrice",
					type:"post",
					data:"id="+typePriceId+"&wareId="+wareId+"&price="+typePrice+"&relaId="+typeId,
					success:function(data){
						if(data!='0'){
							if(typePriceId==""){
								document.getElementById("type_price_Id_"+wareId+"_"+typeId).value=data;
							}
						}else{
							alert("操作失败");
							return;
						}
					}
				});
		    }

			initGrid();
		</script>
	</body>
</html>
