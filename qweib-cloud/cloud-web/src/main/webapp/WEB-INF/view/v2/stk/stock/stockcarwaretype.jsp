<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.product-grid td {
			padding: 0;
		}
	</style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="uglcw-layout-container">
		<div class="uglcw-layout-fixed" style="width: 200px;display: none">
			<div class="layui-card" uglcw-role="resizable" uglcw-options="responsive:[35]">
				<ul uglcw-role="accordion">
					<li>
						<span>库存商品类</span>
						<div uglcw-role="tree"  id="tree1"
							 uglcw-options="
                                 url: '${base}manager/companyWaretypes?isType=0',
                                 expandable: function(node){
                                 return node.id == '0';
                                 },
                                 loadFilter:function(response){
                                    $(response).each(function(index,item){
                                      if(item.text=='根节点'){
                                             item.text='库存商品类';
                                       }
                                     })
                                       return response;
                                     },
                                 select: function(e){
                                        var node = this.dataItem(e.node);
                                        uglcw.ui.get('#wareType').value(node.id);
                                        uglcw.ui.get('#isType').value(0);
                                        uglcw.ui.get('#grid').reload();
                                   },
                                 dataBound: function(){
                                   var tree = this;
                                   clearTimeout($('#tree1').data('_timer'));
										   $('#tree1').data('_timer', setTimeout(function(){
											   tree.select($('#tree1 .k-item:eq(0)'));
											   var nodes = tree.dataSource.data().toJSON();
												   if(nodes && nodes.length > 0){
														   <%--uglcw.ui.bind('.uglcw-query', {--%>
															   <%--isType: 0,--%>
															   <%--waretype: nodes[0].id--%>
															   <%--}--%>
														   <%--);--%>
													  	 uglcw.ui.get('#grid').reload();
													 }
										  })
                                  )
                                }
                                "
						></div>
					</li>
					<li>
						<span>原辅材料类</span>
						<div uglcw-role="tree"
							 uglcw-options="
                                   url: '${base}manager/companyWaretypes?isType=1',
                                   expandable: function(node){
                                   return node.id == '0';
                                   },
                                    loadFilter:function(response){
                                    $(response).each(function(index,item){
                                      if(item.text=='根节点'){
                                             item.text='原辅材料类';
                                       }
                                     })
                                       return response;
                                     },
                                       select: function(e){
                                        var node = this.dataItem(e.node);
                                        uglcw.ui.get('#wareType').value(node.id);
                                        uglcw.ui.get('#isType').value(1);
                                        uglcw.ui.get('#grid').reload();
                                       }
                    ">

						</div>
					</li>
					<li>
						<span>低值易耗品类</span>
						<div uglcw-role="tree"
							 uglcw-options="
                               url: '${base}manager/companyWaretypes?isType=2',
                               expandable: function(node){
                                  return node.id == '0';
                               },
                                    loadFilter:function(response){
                                    $(response).each(function(index,item){
                                      if(item.text=='根节点'){
                                             item.text='低值易耗品类';
                                       }
                                     })
                                       return response;
                                     },
                                   select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#wareType').value(node.id);
                                    uglcw.ui.get('#isType').value(2);
                                    uglcw.ui.get('#grid').reload();
                                   }

                                "
						></div>
					</li>
					<li>
						<span>固定资产类</span>
						<div uglcw-role="tree"
							 uglcw-options="
                                   url: '${base}manager/companyWaretypes?isType=3',
                                   expandable: function(node){
                                        return node.id == '0';
                                   },
                                     loadFilter:function(response){
                                        $(response).each(function(index,item){
                                          if(item.text=='根节点'){
                                                 item.text='固定资产类';
                                           }
                                         })
                                           return response;
                                         },
                                       select: function(e){
                                        var node = this.dataItem(e.node);
                                        uglcw.ui.get('#wareType').value(node.id);
                                        uglcw.ui.get('#isType').value(3);
                                        uglcw.ui.get('#grid').reload();
                                       }

                                    "
						></div>
					</li>
				</ul>
			</div>
		</div>
		<div class="uglcw-layout-content">
			<div class="layui-card header">
				<div class="layui-card-body">
					<ul class="uglcw-query form-horizontal">
						<li>
							<input type="hidden" id="isType" uglcw-model="isType" uglcw-role="textbox">
							<input type="hidden" uglcw-model="waretype" id="wareType" uglcw-role="textbox">
							<input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
						</li>
						<li>
							<tag:select2  name="stkId" id="stkId"
										tableName="stk_storage"
										headerKey=""
										headerValue="--请选择--"
										whereBlock="sale_Car=1 and (status=1 or status is null)"
										displayKey="id"
										displayValue="stk_name"
										value="${stkId}"
							/>
							<%--<select uglcw-role="combobox" uglcw-model="stkId" uglcw-options="--%>
                                    <%--dataTextField: 'stkName',--%>
                                    <%--dataValueField: 'id',--%>
                                    <%--url: '${base}manager/queryBaseStorage',--%>
                                    <%--placeholder: '仓库'--%>
                                <%--"></select>--%>
						</li>
						<li>
							<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
							<button id="reset" class="k-button" uglcw-role="button">重置</button>
							<%--<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:toBatchRtn();">车销回库</a>--%>
						</li>
					</ul>
				</div>
			</div>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
                    autoBind:false,
				    checkbox: true,
                    responsive:['.header',40],
                     toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    pageable:{
                        pageSize: 20
                    },
                    url: '${base}manager/queryStorageWareCarPage',
                    criteria: '.form-horizontal',
                    aggregate:[
                     {field: 'sumQty', aggregate: 'SUM'},
                     {field: 'sumAmt', aggregate: 'SUM'},
                     {field: 'avgPrice', aggregate: 'SUM'},
                     {field: 'minSumQty', aggregate: 'SUM'}
                    ],
                      dblclick: function(row){
                        showItems(row);
                    },
                    loadFilter: {
                      data: function (response) {
                        response.rows = response.rows || []
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     }
                    ">
						<div data-field="stkName" uglcw-options="width:150, tooltip:true, footerTemplate: '合计:' ">仓库名称
						</div>
						<div data-field="wareNm" uglcw-options="width:150, tooltip:true">商品名称</div>
						<div data-field="unitName" uglcw-options="width: 100">大单位</div>
						<div data-field="sumQty"
							 uglcw-options="width:140, format: '{0:n2}',titleAlign:'center',align:'right',template: uglcw.util.template($('#formatterNum').html()),footerTemplate: '#=uglcw.util.toString((data.sumQty||0),\'n2\')#'">车载数量
						</div>
						<div data-field="_sumQty" uglcw-options="width:120,tooltip: true,titleAlign:'center',align:'right',
                                template: uglcw.util.template($('#formatterQty').html())">大小数量
						</div>
						<c:if test="${permission:checkUserFieldPdm('stk.storageWare.showamt')}">
							<div data-field="sumAmt"
								 uglcw-options="width:140, format: '{0:n2}',titleAlign:'center',align:'right', footerTemplate: '#=uglcw.util.toString((data.sumAmt||0),\'n2\')#'">
								总金额
							</div>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.storageWare.showprice')}">
							<div data-field="avgPrice"
								 uglcw-options=" width:100, format: '{0:n2}',titleAlign:'center',align:'right', footerTemplate:'#=uglcw.util.toString((data.avgPrice||0),\'n2\')#'">
								平均单价
							</div>
						</c:if>
						<div data-field="minUnitName" uglcw-options="width:100">小单位</div>
						<div data-field="minSumQty"
							 uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right', footerTemplate:'#= uglcw.util.toString((data.minSumQty||0),\'n2\')#'">
							小单位数量
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script id="toolbar" type="text-x-uglcw-template">
	<button class="k-button"  id="restock" onclick="toBatchRtn()" uglcw-role="button"><i class="k-icon"></i>车销回库
	</button>

</script>

<script type="text/x-kendo-template" id="formatterQty">
	#var hsNum=data.hsNum;#
	#var sumQty = parseInt( data.sumQty * 100 );#
	#sumQty = (sumQty/100).toFixed(2);#
	#var rtn = sumQty+data.unitName #
	#if(parseFloat(hsNum)>1){#
	#var str = sumQty+"";#
	#if(str.indexOf(".")!=-1){#
	#var nums = str.split(".");#
	#var num1 = nums[0];#
	#var num2 = nums[1];#
	#if(parseFloat(num2)>0){#
	#var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);#
	#minQty = minQty.toFixed(2);#
	#rtn = num1+""+data.unitName+""+minQty+""+data.minUnitName#
	#}#
	#}#
	#}#
	#= (rtn)#

</script>

<script type="text/x-kendo-template" id="formatterNum">
	#var sumQty = parseInt( data.sumQty * 100 );#
	#sumQty = (sumQty/100).toFixed(2);#
	#var rtn = sumQty; #
	#= (rtn)#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		uglcw.ui.init();
		uglcw.layout.init();
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#grid').reload();
		})

		uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.form-horizontal');
			uglcw.ui.get('#gird').reload();
		})

		uglcw.ui.get('#restock').on('click', function () {
			toBatchRtn();
		})
		uglcw.ui.loaded()
	})

	function toBatchRtn() {
		var stkId = "";
		var stkName = "";
		var wareIds = "";
		var bool = true;
		var selection = uglcw.ui.get('#grid').selectedRow();
		if (selection && selection.length > 0) {
			var wareIds = $.map(selection, function (row) {
				if(stkId==""){
					stkId = row.stkId;
					stkName = row.stkName;
				}
				if(stkId!=row.stkId){
					bool = false;
					return;
				}
				return "" + row.wareId + "";
			}).join(',');
		} else {
			uglcw.ui.warning('请选择商品！');
		}
		if(bool==false){
			uglcw.ui.warning('请选择相同的仓库！');
		}
		uglcw.ui.openTab('车销回库', '${base}manager/stkMove/add?billType=2&stkId='+stkId+'&stkName='+stkName+'&wareIds='+wareIds);
	}

	function showItems(data) {
		uglcw.ui.openTab('库存明细' + data.wareId, '${base}manager/toStkDetail?stkId=' + data.stkId + '&wareId=' + data.wareId);
	}

</script>
</body>
</html>
