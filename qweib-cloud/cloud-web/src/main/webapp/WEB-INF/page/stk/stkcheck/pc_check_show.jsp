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
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/stkcheck.css"/>		
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body onload="displaySub()">
		<input type="hidden" id="billId" value="${billId}"/>
		<input type="hidden" id="stkId" value="${stkId}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			border="false"
			rownumbers="true" fitColumns="true" pagination="false" pagePosition=3
			 toolbar="#tb" >
			<thead>
				<tr>
				<th field="id" width="10" align="center" hidden="true">
						商品id
					</th>
				    <th field="wareId" width="10" align="center" hidden="true">
						商品id
					</th>
					<th field="wareCode" width="80" align="left">
						商品编码
					</th>
					<th field="wareNm" width="100" align="left">
						商品名称
					</th>
					<th field="wareGg" width="80" align="center">
						规格
					</th>
					<th field="stkQty" width="60" align="center" formatter="amtformatter">
						账面数量
					</th>
					<th field="unitName" width="60" align="center">
						大单位
					</th>
					<th data-options="field:'qty',width:80,align:'center',editor:{type:'text'}" formatter="amtformatter"> 
						大单位数量
					</th>
					<th field="minUnit" width="60" align="center">
						小单位
					</th>
					<th field="minQty" width="80" align="center" editor="{type:'text'}" formatter="amtformatter">
						小单位数量
					</th>
					<th field="hsNum" width="60" align="center"  hidden="true">
						换算数量
					</th>
					<th field="disQty" width="60" align="center" formatter="amtformatter">
						差量
					</th>
					<th field="produceDate" width="60" align="center">
						生产日期
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		 盘点时间:${checkTime}
		 盘点仓库: ${stkName }
	      盘点人:${staff}
		单据状态:
		<c:if test="${status eq -2}">
			暂存
		</c:if>
		<c:if test="${status eq 0}">
			已审批
		</c:if>
		<c:if test="${status eq -2}">
			已作废
		</c:if>
		</div>
		<script type="text/javascript">
			function displaySub()
			{
				var path = "manager/queryCheckSub";
				var billId = $("#billId").val(); 
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"billId":billId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		var size = json.list.length;
			        		for(var i = 0;i < size; i++)
			        			{
			        			$('#datagrid').datagrid("appendRow", {  
			        				wareId:json.list[i].wareId,
			        				wareNm:json.list[i].wareNm,
			        				wareGg:json.list[i].wareGg,
			        				wareCode:json.list[i].wareCode,
			        				unitName:json.list[i].unitName,
			        				stkQty:formatterNumber(json.list[i].stkQty),
			        				qty:formatterNumber(json.list[i].qty),
			        				minQty:formatterNumber(json.list[i].minQty),
			        				minUnit:json.list[i].minUnit,
			        				hsNum:json.list[i].hsNum,
			        				produceDate:json.list[i].produceDate,
			        				disQty:formatterNumber(json.list[i].disQty)				
			        			});
			        	}
			        }
			        }
			    });
			}
		  function amtformatter(v,row)
			{
				if (row != null) {
                  return numeral(v).format("0.000");
              }
			}
		  function formatterNumber(v,f)
			{
				if (v != null&&(f==null ||f==undefined)) {
                return numeral(v).format("0.000");
            	}else if(v !=null&&f!=null){
            		 return numeral(v).format(f);
            	}else{
            		return 0;
            	}
			}
		</script>
	</body>
</html>
