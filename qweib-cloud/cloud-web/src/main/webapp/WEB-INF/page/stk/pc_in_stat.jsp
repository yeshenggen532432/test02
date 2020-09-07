<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body class="easyui-layout" onload="initGrid()">
	<input type="hidden" id="waretype" />

	<div data-options="region:'west',split:true,title:'商品分类树'"
			style="width:150px;padding-top: 5px;">
			<%--<ul id="waretypetree" class="easyui-tree"--%>
				<%--data-options="url:'manager/waretypes',animate:true,dnd:true,onClick: function(node){--%>
					<%--toShowWare(node.id);--%>
				<%--},onDblClick:function(node){--%>
					<%--$(this).tree('toggle', node.target);--%>
				<%--}">--%>
			<%--</ul>--%>
				<div class="easyui-accordion" data-options="border:false,fit:true">
					<div title="库存商品类" data-options="iconCls:'icon-application-cascade'" style="padding:5px;">
						<ul id="waretypetree" class="easyui-tree"
							data-options="url:'${base}manager/companyWaretypes?isType=0',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id,0);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
						</ul>
					</div>
					<div title="原辅材料类" data-options="iconCls:'icon-application-form-edit'" style="padding:5px;">
						<ul id="waretypetree1" class="easyui-tree"
							data-options="url:'${base}manager/companyWaretypes?isType=1',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id,1);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
						</ul>
					</div>

					<div title="低值易耗品类" data-options="iconCls:'icon-application-form-edit'" style="padding:5px;">
						<ul id="waretypetree2" class="easyui-tree"
							data-options="url:'${base}manager/companyWaretypes?isType=2',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id,2);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
						</ul>
					</div>
					<div title="固定资产类" data-options="iconCls:'icon-application-form-edit'" style="padding:5px;">
						<ul id="waretypetree3" class="easyui-tree"
							data-options="url:'${base}manager/companyWaretypes?isType=3',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id,3);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
						</ul>
					</div>
				</div>

		</div>
		<div id="wareTypeDiv" data-options="region:'center'" >
		<table id="datagrid"  fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
			<input type="hidden" id="isType" value="0"/>
		   时间类型:<select name="timeType" id="timeType">
	                  <option value="1">收货时间</option>
	                  <option value="2">发票时间</option>
	            </select>  
		   时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        入库类型:<select    name="inType" id="inType">
	                  <option value="">全部</option>
	                  <option value="采购入库">采购入库</option>
	                  <option value="采购退货">采购退货</option>
	                  <option value="其它入库">其它入库</option>
	                  <option value="销售退货">销售退货</option>
	                  <option value="移库入库">移库入库</option>
	                  <option value="组装入库">组装入库</option>
	                  <option value="拆卸入库">拆卸入库</option>
			          <option value="生产入库">生产入库</option>
			          <option value="领料回库">领料回库</option>
	                  <option value="盘盈">盘盈</option>
	               </select>
	        入库仓库:
	        <tag:select name="stkid" id="stkId"  tableName="stk_storage"  headerKey="0" headerValue="全部"
						whereBlock="status=1 or status is null"
						displayKey="id" displayValue="stk_name"/>
	        供应商名称: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			商品名称: <input type="text" name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		    <input name="memberNm" id="memberNm" style="width:120px;height: 20px;display: none" onkeydown="toQuery(event);"/>   
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryClick();">查询</a>
		</div>
		</div>
		<script type="text/javascript">
		   //查询
		   //queryDict();
		   //querystorage();
		   //initGrid();
		  // queryindetail();
		   function initGrid()
		   {
			   var cols = new Array(); 
			   /*var col = {
						field: 'unitId',
						title: 'unitid',
						width: 100,
						align:'center',
						hidden:true
						
										
				};
	    	    cols.push(col);*/
			   var col = {
						field: 'wareId',
						title: '商品id',
						width: 100,
						align:'center',
						hidden:true
						
										
				};
	    	    cols.push(col);
	    	    /*var col = {
						field: 'stkUnit',
						title: '往来单位',
						width: 100,
						align:'center'
						
										
				};
	    	    cols.push(col);*/
	    	    var col = {
						field: 'wareNm',
						title: '商品名称',
						width: 100,
						align:'center'
						
										
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'unitName',
						title: '单位',
						width: 80,
						align:'center'
						
										
				};
	    	    cols.push(col);
				
	    	    var col = {
						field: 'sumQty',
						title: '发票数量',
						width: 80,
						align:'center',
						formatter:function(value,row,index){
							
							if(value==""){
								value =0.0;
							}
							if(value=="0E-7"){
								value =0.0;
							}
							if(value=="0E-9"){
								value =0.0;
							}
							return  '<u style="color:blue;cursor:pointer">'+numeral(value).format("0,0.00")+'</u>';
						}
						
										
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'sumQty1',
						title: '收货数量',
						width: 80,
						align:'center',
						formatter:function(value,row,index){
							if(value==""){
								value =0.0;
							}
							if(value=="0E-7"){
								value =0.0;
							}
							if(value=="0E-9"){
								value =0.0;
							}
							return  '<u style="color:blue;cursor:pointer">'+numeral(value).format("0,0.00")+'</u>';
						}
						
										
				};
	    	    cols.push(col);
					
				
	    	    var col = {
						field: 'sumAmt',
						title: '采购金额',
						width: 80,
						align:'center',
						formatter:amtformatter,
						hidden:${!permission:checkUserFieldPdm("stk.wareInStat.showamt")}
						
										
				};
	    	    cols.push(col);

			   var col = {
				   field: 'sumAmt1',
				   title: '收货金额',
				   width: 80,
				   align:'center',
				   formatter:amtformatter,
				   hidden:${!permission:checkUserFieldPdm("stk.wareInStat.showamt")}


			   };
			   cols.push(col);


	    	    var col = {
						field: 'avgPrice',
						title: '平均单价',
						width: 80,
						align:'center',
						formatter:amtformatterAvg,
						hidden:${!permission:checkUserFieldPdm("stk.wareInStat.showprice")}
						
										
				};
	    	    cols.push(col);
	    	    
	    	    /*var col = {
						field: 'sumAmt1',
						title: '收货金额',
						width: 80,
						align:'center'
						
										
				};
	    	    cols.push(col);*/
				$('#datagrid').datagrid({
					url:"manager/stkInSubStatPage",
					queryParams:
						{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						inType:$("#inType").val(),
						stkId:$("#stkId").val(),
						proName:$("#proName").val(),
						memberNm:$("#memberNm").val(),
						timeType:$("#timeType").val(),
						wareNm:$("#wareNm").val(),
						isType:$("#isType").val(),
						waretype:$("#waretype").val()

						},
    	    		columns:[
    	    		  		cols
    	    		  	]}
    	    );
    	    //$('#datagrid').datagrid('reload'); 
	    	    
			}
		   function toShowWare(waretype,isType)
		   {
			   $("#waretype").val(waretype);
			   $("#isType").val(isType);
			   queryindetail();
		   }
		   
		   function queryClick()
		   {
			   //$("#waretype").val(0);
			   queryindetail();
		   }
		   
			function queryindetail(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkInSubStatPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					inType:$("#inType").val(),
					stkId:$("#stkId").val(),
					proName:$("#proName").val(),
					memberNm:$("#memberNm").val(),
					timeType:$("#timeType").val(),
					waretype:$("#waretype").val(),
					isType:$("#isType").val(),
					wareNm:$("#wareNm").val()
				});
			}
			function amtformatterAvg(v,row)
			{
				if (row != null) {
					var avg = parseFloat(row.sumAmt)/parseFloat(row.sumQty);
                    return numeral(avg).format("0,0.00");
                }
			}
			
			function amtformatter(v,row)
			{
				if(v==""){
					return "";
				}
				if(v=="0E-7"){
					return "0.00";
				}
				if(v=="0E-9"){
					return "0.00";
				}
				if (row != null) {
                    return numeral(v).format("0,0.00");
                } 
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querycpddtj();
				}
			}
			
			function queryDict(){

			}
			
			function querystorage(){
				var path = "manager/queryBaseStorage";
				//var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token11":""},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		
			        		var size = json.list.length;
			        		gstklist = json.list;
			        		var objSelect = document.getElementById("stkId");
			        		objSelect.options.add(new Option(''),'');
			        		for(var i = 0;i < size; i++)
			        			{
			        				objSelect.options.add( new Option(json.list[i].stkName,json.list[i].id));
			        				
			        			}
							
			        		
			        	}
			        }
			    });
			}
			
			function onDblClickRow(rowIndex, rowData)
		    {
				//"&sdate=" + sdate + "&edate=" + edate +"&stkId=" + stkId+"&wareId=" + wareId+"&proName=" + proName+ "&memberNm="+memberNm
				var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				var stkId= $("#stkId").val();
				var timeType= $("#timeType").val();
				var wareId = rowData.wareId;
				//var unitId = rowData.unitId;
				//var proName = $("#proName").val();
				var memberNm = $("#memberNm").val();
				var inType = $("#inType").val();
				parent.closeWin('明细_' + rowData.wareNm);
				parent.add('明细_' + rowData.wareNm,'manager/queryIndetailList?dataTp=1&sdate=' + sdate + "&edate=" + edate +"&timeType="+timeType+"&stkId=" + stkId+"&wareId=" + wareId+ "&memberNm="+memberNm + '&inType=' + inType);
		    }

			function onClickCell(index, field, value){
		    	var rows = $("#datagrid").datagrid("getRows");
		    	var row = rows[index];
		    	var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				var stkId= $("#stkId").val();
				var wareId = row.wareId;
				//var unitId = rowData.unitId;
				//var proName = $("#proName").val();
				var memberNm = $("#memberNm").val();
				var inType = $("#inType").val();
				var timeType= $("#timeType").val();
				parent.closeWin('明细_' + row.wareNm);
		    	//if(field == "sumQty")
		    	//{
		    		parent.add('明细_' + row.wareNm,'manager/queryIndetailList?dataTp=1&sdate=' + sdate + "&edate=" + edate +"&stkId=" + stkId+"&wareId=" + wareId+ "&timeType="+timeType+"&memberNm="+memberNm + '&inType=' + inType);
		    	//}
		    	/* if(field == "sumQty1")
		    	{
		    		parent.add('明细_' + row.wareNm,'manager/queryIndetailList2?dataTp=1&sdate=' + sdate + "&edate=" + edate +"&stkId=" + stkId+"&wareId=" + wareId+ "&timeType="+timeType+"&memberNm="+memberNm + '&inType=' + inType);
		    	}
		    	 */
		    }
		</script>
	</body>
</html>
