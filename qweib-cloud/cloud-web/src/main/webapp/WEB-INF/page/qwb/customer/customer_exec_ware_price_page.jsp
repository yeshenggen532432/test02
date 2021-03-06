<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script src="<%=basePath %>/resource/stkstyle/js/Map.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body>
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<table id="datagrid" fit="true" singleSelect="true"
			 border="false"
			rownumbers="true" striped="true"  pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" value="${param.wareNm }" onkeydown="toQuery(event);"/>
			<input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>
			<input type="hidden" name="customerId" id="customerId" value="${customerId}"/>
			<input type="hidden" name="isType" id="isType" value="${isType}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
			&nbsp;&nbsp;
			<span style="background-color:#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>商品原价
			<span style="background-color:rebeccapurple">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>客户类型价
			<span style="background-color:#4db3ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>客户等级价
			<span style="background-color:green">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>客户商品价
		</div>
		<script type="text/javascript">
			var colorMap = new Map();
			colorMap.put(0,'#000000');
			colorMap.put(1,'rebeccapurple');
			colorMap.put(2,'#4db3ff');
			colorMap.put(3,'green');
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
				var cols2 = new Array();
		    	    var col = {
							field: 'waretypeNm',
							title: '所属分类',
							width: 70,
							align:'center'
											
					};
				cols2.push(col);
		    	    var col = {
							field: 'wareGg',
							title: '规格',
							width: 60,
							align:'center'
											
					};
				cols2.push(col);

		    	    var col = {
							field: 'wareDw',
							title: '大单位',
							width: 60,
							align:'center'
											
					};
				cols2.push(col);
					var col = {
						field: 'minUnit',
						title: '小单位',
						width: 60,
						align:'center'

					};
				cols2.push(col);

				var col = {
					field: 'wareDj',
					title: '大单位批发价',
					width: 100,
					align:'center',
					formatter:formatPrice

				};
				cols2.push(col);

				var col = {
					field: 'lsPrice',
					title: '大单位零售价',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);

				var col = {
					field: 'fxPrice',
					title: '大单位分销价',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);

				var col = {
					field: 'cxPrice',
					title: '大单位促销价',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);

				var col = {
					field: 'sunitPrice',
					title: '小单位批发价',
					width: 100,
					align:'center',
					formatter:formatPrice

				};
				cols2.push(col);

				var col = {
					field: 'minLsPrice',
					title: '小单位零售价',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);

				var col = {
					field: 'minFxPrice',
					title: '小单位分销价',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);

				var col = {
					field: 'minCxPrice',
					title: '小单位促销价',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);
				$('#datagrid').datagrid({
					url:"manager/customerExecWarePricePage",
					queryParams:{
						wareNm:$("#wareNm").val(),
						wtype:'${wtype}',
						isType:'${isType}',
						customerId:'${customerId}'
						},
						frozenColumns:[
									cols
								],
						columns:[
								cols2
							]}
				);
			}

		 function queryWare(){
			 $("#datagrid").datagrid('load',{
				 url:"manager/customerExecWarePricePage",
					 wareNm:$("#wareNm").val(),
					 wtype:'${wtype}',
					 isType:'${isType}',
				 	 customerId:'${customerId}'
			 });
		 }


		 function formatPrice(val,row,index) {
			 if (val == undefined || val== "undefined") {
				 val = "";
			 }
			 if(val=="0"||val=="0.0"){
				val = "";
			 }
			 var color="";
			 if(this.field=='wareDj'){
				 color=colorMap.get(row.pfPriceType);
			 }else if(this.field=='lsPrice'){
				 color=colorMap.get(row.lsPriceType);
			 } else if(this.field=='fxPrice'){
				 color=colorMap.get(row.fxPriceType);
			 } else if(this.field=='cxPrice'){
				 color=colorMap.get(row.cxPriceType);
			 } else if(this.field=='sunitPrice'){
				 color=colorMap.get(row.minPfPriceType);
			 } else if(this.field=='minLsPrice'){
				 color=colorMap.get(row.minLsPriceType);
			 } else if(this.field=='minFxPrice'){
				 color=colorMap.get(row.minFxPriceType);
			 } else if(this.field=='minCxPrice'){
				 color=colorMap.get(row.minCxPriceType);
			 }
			 return "<span style='color:"+color+"' class="+this.field+"_span"+" id="+this.field+"_span_"+row.wareId+">"+val+"</span>";
		 }
			initGrid();
		</script>
	</body>
</html>
