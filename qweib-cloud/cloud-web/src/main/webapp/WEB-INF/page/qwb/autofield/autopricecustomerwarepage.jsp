<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<input type="hidden" name="customerId" id="customerId" value="${param.customerId}"/>
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
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			<input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
			<%-- 
			<a class="easyui-linkbutton" iconCls="easyui-linkbutton" href="javascript:setCostPrice();">设置显示列</a>
			--%>
		</div>
		
		<script type="text/javascript">
		 var autoTitleDatas = eval('${autoTitleJson}');
		 var autoPriceDatas = eval('${autoPriceJson}');
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
		    	    if(autoTitleDatas.length>0){
		    	    	for(var i=0;i<autoTitleDatas.length;i++){
		    	    		var json = autoTitleDatas[i];
							var field = "auto"+json.name;
							var title = "<span onclick='operatePrice(\""+field+"\")'>"+json.name+"✎</span>";
		    	    		  var col = {
		  							field: field,
		  							title: title,
		  							width: 100,
		  							align:'center',
		  							formatter:formatAutoAmt,
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
			function queryWare(){
				isShow=0;
				$("#datagrid").datagrid('load',{
					url:"manager/wares",
					wareNm:$("#wareNm").val(),
					wtype:'${wtype}'
				});
			}
		    var isShow=0;
			function show(){
				$("#datagrid").datagrid('load',{
					url:"manager/wares",
					wareNm:$("#wareNm").val(),
					wtype:'${wtype}'
				});
				isShow=1;
			}
		    function formatAutoAmt(val,row,index){
		    	var price = "";
		    	if(isShow==1){
		    		price = "";
		    	}
		    	var html ="<input type='hidden' id='auto_price_Id_"+row.wareId+"_"+this.value+"'/><input type='text' class="+this.field+"_imput"+" name='autoPrice' size='7' style='display:none' onchange='changeWareAutoPrice("+row.wareId+","+this.value+")' id='auto_Price_"+row.wareId+"_"+this.value+"' value='"+price+"' />";
				html+="<span class="+this.field+"_span"+" id='auto_span_"+row.wareId+"_"+this.value+"'>"+price+"</span>";
		    	if(autoPriceDatas.length>0){
		    		for(var i=0;i<autoPriceDatas.length;i++){
		    			var json = autoPriceDatas[i];
		    			if(json.wareId==row.wareId&&json.autoId==this.value){
		    				html ="<input type='hidden' id='auto_price_Id_"+row.wareId+"_"+this.value+"' value='"+json.id+"'/><input class="+this.field+"_imput"+" type='text' style='display:none' name='autoPrice' size='7' onchange='changeWareAutoPrice("+row.wareId+","+this.value+")' id='auto_Price_"+row.wareId+"_"+this.value+"' value='"+json.price+"' />";
							html+="<span class="+this.field+"_span"+" id='auto_span_"+row.wareId+"_"+this.value+"'>"+json.price+"</span>";
		    				break;
		    			}
		    		}
		    	}
		    	return html;
		    }

		 function operatePrice(field) {
			 var display =$("."+field+"_imput").css('display');
			 if(display == 'none'){
				 $("."+field+"_imput").show();
				 $("."+field+"_span").hide();
			 }else{
				 $("."+field+"_imput").hide();
				 $("."+field+"_span").show();
			 }
		 }

		    function changeWareAutoPrice(wareId,autoId){
		    	var autoPriceId = document.getElementById("auto_price_Id_"+wareId+"_"+autoId).value;
				var autoPrice =  document.getElementById("auto_Price_"+wareId+"_"+autoId).value;
				$.ajax({
					url:"manager/updateAutoCustomerPrice",
					type:"post",
					data:"id="+autoPriceId+"&wareId="+wareId+"&price="+autoPrice+"&autoId="+autoId+"&customerId=${param.customerId}",
					success:function(data){
						if(data!='0'){
							if(autoPriceId==""){
								document.getElementById("auto_price_Id_"+wareId+"_"+autoId).value=data;
								$("#auto_span_"+wareId+"_"+autoId).text(autoPrice);
							}
						}else{
							alert("操作失败");
							return;
						}
					}
				});
		    }
		    
		    $(function () {  
                $("#btnShowColumn").click(function () {  
                	
                	if(autoTitleDatas.length>0){
		    	    	for(var i=0;i<autoTitleDatas.length;i++){
		    	    		var json = autoTitleDatas[i];
		    	    		$('#datagrid').datagrid('showColumn', 'auto'+json.khdjNm);//列的field值 
		    	    	}
					}
                });  
                $("#btnHideColumn").click(function () {  
                	if(autoTitleDatas.length>0){
		    	    	for(var i=0;i<autoTitleDatas.length;i++){
		    	    		var json = autoTitleDatas[i];
		    	    		$('#datagrid').datagrid('hideColumn', 'auto'+json.khdjNm);//列的field值 
		    	    	}
					}
                });  
            }); 
		    function setCostPrice(){
				window.parent.parent.add("设置费用显示列","manager/queryAutoField");
			}
			initGrid();
		</script>
	</body>
</html>
