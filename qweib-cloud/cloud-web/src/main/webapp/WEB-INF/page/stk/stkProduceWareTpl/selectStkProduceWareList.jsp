<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>选择配料信息</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
		<div  id="tb">
			产品名称:
			<input name="relaWareNm" id="relaWareNm" style="width:120px;height: 20px;" />
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		  	<a class="easyui-linkbutton" iconCls="icon-select" href="javascript:confirmSelectWare();">确定选择</a>
		</div>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="<%=basePath %>/manager/stkProduceWareTpl/getProduceRelaWareTplList" 
					 title="" iconCls="icon-save" border="false" rownumbers="true"
			 		fitColumns="true" data-options="onDblClickRow: onDblClickRow"
			 		toolbar="#tb"
			 		>
			<thead>
				<tr>
					<th  field="wareId" checkbox="true"></th>
					<th field="wareCode" width="80" align="center" >
						商品编码
					</th>
					<th field="wareNm" width="150" align="left">
						商品名称
					</th>
					<th field="wareGg" width="80" align="center">
						规格
					</th>
					<th field="wareDw" width="60" align="center"  hidden="true">
						大单位
					</th>
					<th field="minUnit" width="100" align="center"  hidden="true">
						小单位
					</th>
					<th field="maxUnitCode" width="100" hidden="true">
						大单位代码
					</th>
					<th field="minUnitCode" width="100" hidden="true">
						小单位代码
					</th>
					<th field="hsNum" width="100" hidden="true">
						换算比例
					</th>
					<th field="sunitFront" width="100" hidden="true">
						开单默认选中小单位
					</th>
					<th field="inPrice" width="100" hidden="true">
					 采购价
					</th>

				</tr>
			</thead>
		</table>
        </div>
		<script type="text/javascript">
		function confirmSelectWare(){
			var rows = $('#datagrid').datagrid('getSelections');
			var json = {};
		    var  wareList = new Array();
				for(var i=0;i<rows.length;i++){
					 	var row = rows[i];
					 	var data = {
								wareId:row.wareId,
								wareNm:row.wareNm,
								wareGg:row.wareGg,
								wareCode:row.wareCode,
								wareDw:row.wareDw,
								minUnit:row.minUnit,
								minUnitCode:row.minUnitCode,
								maxUnitCode:row.maxUnitCode,
								hsNum:row.hsNum,
								stkQty:1,
								sunitFront:row.sunitFront,
								price:row.inPrice,
							    beUnit:row.beUnit
						};
						wareList.push(data);
					} 
			json ={
					list:wareList
			}
			window.parent.callBackFun(json);
			window.parent.$('#wareDlg').dialog('close');
		}

		function query() {
			$("#datagrid").datagrid('load',{
				url:"manager/stkProduceWareTpl/getProduceRelaWareTplList",
				relaWareNm:$("#relaWareNm").val()
			});
		}


		function onDblClickRow(rowIndex, row)
	    {
			var json = {};
			 var  wareList = new Array();
			var data = {
					wareId:row.wareId,
					wareNm:row.wareNm,
					wareGg:row.wareGg,
					wareCode:row.wareCode,
					wareDw:row.wareDw,
					minUnit:row.minUnit,
					minUnitCode:row.minUnitCode,
					maxUnitCode:row.maxUnitCode,
					hsNum:row.hsNum,
					stkQty:1,
					sunitFront:row.sunitFront,
					price:row.inPrice,
				    beUnit:row.beUnit
			};
			wareList.push(data); 
			json ={
					list:wareList
			}
			window.parent.callBackFun(json);
	    }
		</script>
	</body>
</html>
