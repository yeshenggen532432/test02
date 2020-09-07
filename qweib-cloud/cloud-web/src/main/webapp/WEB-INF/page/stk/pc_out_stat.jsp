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
	<input type="hidden" id="waretype"/>
	<input type="hidden" id="isType" value="0"/>
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
			 iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		   时间类型:<select name="timeType" id="timeType">
	                  <option value="1">发货时间</option>
	                  <option value="2">发票时间</option>
	              </select>   时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			出库类型:<tag:outtype id="outType" name="outType" style="width:100px" onchange="changeOutType()"></tag:outtype>
			销售类型:<tag:saleType id="xsTp" name="xsTp"></tag:saleType>
		<%--出库类型: <select name="outType" id="outType">--%>
	                    <%--<option value=""></option>	                   --%>
	                    <%--<option value="销售出库">销售出库</option>--%>
	                    <%--<option value="其它出库">其它出库</option>--%>
	                    <%--<option value="移库出库">移库出库</option>--%>
	                    <%--<option value="组装出库">组装出库</option>--%>
	                    <%--<option value="拆卸出库">拆卸出库</option>--%>
	                    <%--<option value="领用出库">领用出库</option>   --%>
	                    <%--<option value="领料出库">领料出库</option>   --%>
	                    <%--<option value="报损出库">报损出库</option>   --%>
	                    <%--<option value="借出出库">借出出库</option>   --%>
	                    <%--<option value="盘亏">盘亏</option>   --%>
	                <%--</select>     --%>
	        <%--销售类型:<select name="xsTp" id="xsTp">--%>
	                  <%--<option value="">全部</option>--%>
	                  <%--<option value="正常销售">正常销售</option>--%>
	                  <%--<option value="促销折让">促销折让</option>--%>
	                  <%--<option value="消费折让">消费折让</option>--%>
	                  <%--<option value="费用折让">费用折让</option>--%>
	                  <%--<option value="其他销售">其他销售</option>--%>
	               <%--</select>--%>
	  		 出库仓库:
	    		<tag:select name="stkid" id="stkId"  tableName="stk_storage"  headerKey="0" headerValue="全部"
							whereBlock="status=1 or status is null"
							displayKey="id" displayValue="stk_name"/>
	            
	        客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		   业务员名称: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			商品名称: <input type="text" name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryClick();">查询</a>
		</div>
		</div>
		<script type="text/javascript">
		   //查询
		   querystorage();
		   
		   function initGrid()
		   {
			   var cols = new Array(); 
			   /*var col = {
						field: 'unitId',
						title: 'unitId',
						width: 100,
						align:'center',
						hidden:true
						
						
										
				};
	    	    cols.push(col);*/
			   var col = {
						field: 'wareId',
						title: '商品名称',
						width: 100,
						align:'center',
						hidden:true
						
										
				};
	    	    cols.push(col);
	    	   /* var col = {
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
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'sumQty1',
						title: '发货数量',
						width: 80,
						align:'center',
						formatter:amtformatter
										
				};
	    	    cols.push(col);
					
				
	    	    var col = {
						field: 'sumAmt',
						title: '发票金额',
						width: 80,
						align:'center',
						formatter:amtformatter,
						hidden:${!permission:checkUserFieldPdm("stk.wareOutStat.showamt")}
						
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'sumAmt1',
						title: '发货金额',
						width: 80,
						align:'center',
						formatter:amtformatter,
						hidden:${!permission:checkUserFieldPdm("stk.wareOutStat.showamt")}
										
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'avgPrice',
						title: '平均售价',
						width: 80,
						align:'center',
						formatter:amtformatterAvg,
						hidden:${!permission:checkUserFieldPdm("stk.wareOutStat.showprice")}
						
										
				};
	    	    cols.push(col);

			    var xsTp = $('#xsTp').combobox('getValues')+"";
				$('#datagrid').datagrid({
					url:"manager/stkOutSubStatPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						xsTp:xsTp,
						pszd:$("#pszd").val(),
						khNm:$("#khNm").val(),
						stkId:$("#stkId").val(),
						memberNm:$("#memberNm").val(),
	 					outType:$("#outType").val(),

						isType:$("#isType").val(),
	 					timeType:$("#timeType").val()
						},
    	    		columns:[
    	    		  		cols
    	    		  	]}
    	    );
    	   // $('#datagrid').datagrid('reload'); 
		   }

		   function toShowWare(waretype,isType)
		   {
			   $("#waretype").val(waretype);
			   $("#isType").val(isType);
			   querycpddtj();
		   }
		   
		   function queryClick()
		   {
			   $("#waretype").val(0);
			   querycpddtj();
		   }
			function querycpddtj(){
				var xsTp = $('#xsTp').combobox('getValues')+"";
				$("#datagrid").datagrid('load',{
					url:"manager/stkOutSubStatPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					xsTp:xsTp,
					pszd:$("#pszd").val(),
					khNm:$("#khNm").val(),
					stkId:$("#stkId").val(),
					memberNm:$("#memberNm").val(),
 					outType:$("#outType").val(),
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
				if (row != null) {
                    return numeral(v).format("0,0.00");
                } 
			}

		   function changeOutType(){
			   var v = $("#outType").val();
			   $('#xsTp').combobox('loadData',{});
			   $('#xsTp').combobox('setValue', '');
			   // if(v==""){
			   //    $('#xsTp').combobox('loadData',allData);
			   // }else
			   //
			   if(v=="销售出库"){
				   $('#xsTp').combobox('loadData',outData);
			   }else if(v=="其它出库"){
				   $('#xsTp').combobox('loadData',otherData2);
			   }
		   }
		   $(function(){
			   $("#xsTp").combobox('loadData', outData);
		   })

			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querycpddtj();
				}
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
				var wareId = rowData.wareId;
				//var khNm = $("#khNm").val();
				var memberNm = $("#memberNm").val();
				var xsTp = $('#xsTp').combobox('getValues')+"";
				//var xsTp = $("#xsTp").val();
				var outType = $("#outType").val();
				var pszd = $("#pszd").val();
				//var unitId = rowData.unitId;
				parent.closeWin('明细_' + rowData.wareNm);
				parent.add('明细_' + rowData.wareNm,'manager/queryOutdetailList?dataTp=1&sdate=' + sdate + "&edate=" + edate +"&stkId=" + stkId+"&outType="+outType+"&wareId=" + wareId+ "&memberNm="+memberNm+'&xsTp=' + xsTp + '&pszd=' + pszd );
		    }
		</script>
	</body>
</html>
