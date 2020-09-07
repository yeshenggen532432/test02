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
			<input type="hidden" name="levelId" id="levelId" value="${levelId}"/>
			<input type="hidden" name="isType" id="isType" value="${isType}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
		</div>
		<script type="text/javascript">
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
					field: 'rate',
					title: '<span onclick="operatePrice(\'rate\')">销售折扣率%✎</span>',
					width: 100,
					align:'center',
					formatter:formatPrice
				};
				cols2.push(col);

				var col = {
					field: 'wareDj',
					title: '<span onclick="operatePrice(\'wareDj\')">大单位批发价✎</span>',
					width: 100,
					align:'center',
					formatter:formatPrice

				};
				cols2.push(col);

				var col = {
					field: 'lsPrice',
					title: '<span onclick="operatePrice(\'lsPrice\')">大单位零售价✎</span>',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);

				var col = {
					field: 'fxPrice',
					title: '<span onclick="operatePrice(\'fxPrice\')">大单位分销价✎</span>',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);

				var col = {
					field: 'cxPrice',
					title: '<span onclick="operatePrice(\'cxPrice\')">大单位促销价✎</span>',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);

				var col = {
					field: 'sunitPrice',
					title: '<span onclick="operatePrice(\'sunitPrice\')">小单位批发价✎</span>',
					width: 100,
					align:'center',
					formatter:formatPrice

				};
				cols2.push(col);

				var col = {
					field: 'minLsPrice',
					title: '<span onclick="operatePrice(\'minLsPrice\')">小单位零售价✎</span>',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);

				var col = {
					field: 'minFxPrice',
					title: '<span onclick="operatePrice(\'minFxPrice\')">小单位分销价✎</span>',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);

				var col = {
					field: 'minCxPrice',
					title: '<span onclick="operatePrice(\'minCxPrice\')">小单位促销价✎</span>',
					width: 100,
					align:'center',
					formatter:formatPrice,
					hidden:'true'

				};
				cols2.push(col);
				$('#datagrid').datagrid({
					url:"manager/customerLevelSetWarePage",
					queryParams:{
						wareNm:$("#wareNm").val(),
						wtype:'${wtype}',
						levelId:'${levelId}',
						isType:'${isType}'
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
				 url:"manager/customerPriceSetWarePage",
					 wareNm:$("#wareNm").val(),
					 wtype:$("#wtype").val(),
					 levelId:$("#levelId").val(),
					 isType:'${isType}'
			 });
		 }



		 function formatPrice(val,row,index) {
			 if (val == undefined || val== "undefined") {
				 val = "";
			 }
			 if(val=="0"||val=="0.0"){
				val = "";
			 }
			 return "<input class="+this.field+"_imput"+" type='text' style='display:none' size='7' onclick='gjr_CellClick(this)' onchange='changePrice(this,\""+this.field+"\",\"" + row.wareId + "\")' value='"+val+"' name="+this.field+"_input"+" /><span class="+this.field+"_span"+" id="+this.field+"_span_"+row.wareId+">"+val+"</span>";
		 }

		 function changePrice(o,field,wareId){
			 $.ajax({
				 url: "manager/updateCustomerLevelWarePrice",
				 type: "post",
				 data: "levelId=${levelId}&wareId=" + wareId + "&price=" + o.value+"&field="+field,
				 success: function (data) {
					 if (data == '1') {
						 $("#"+field+"_span_"+wareId).text(o.value);
					 } else {
						 alert("操作失败");
						 return;
					 }
				 }
			 });
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

		 function gjr_CellClick(o) {
			 o.select();
		 }

			initGrid();
		</script>
	</body>
</html>
