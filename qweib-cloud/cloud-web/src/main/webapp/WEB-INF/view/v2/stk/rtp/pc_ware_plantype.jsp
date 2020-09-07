<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>按客户等级设置商品销售价格</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width:200px">
            <div class="layui-card" uglcw-role="resizable" uglcw-options="responsive:[35]">
                <ul uglcw-role="accordion" uglcw-options="expandMode: 'single'" id="accordion">
                    <li>
                        <span>库存商品类</span>
                    <div id="tree" uglcw-role="tree"
                         uglcw-options="
                        url:'manager/waretypes',
                        expandable:function(node){return node.id == '0'},
                        loadFilter:function(response){
                        $(response).each(function(index,item){
                                if(item.text=='根节点'){
                                    item.text='库存商品类'
                                }
                            })
                            return response;
                        },
                        select: function(e){
                            var node = this.dataItem(e.node)
                           uglcw.ui.get('#grid').k().dataSource.filter({
                            field: 'waretypePath',
                            operator: 'contains',
                           	value: node.id || ''
                           })
                        }
                    "
                    >
                    </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                                <input type="hidden" uglcw-model="stkId" id="stkId" uglcw-role="textbox" value="0">
                                <input type="hidden" uglcw-model="billId" id="billId" uglcw-role="textbox"
                                       value="${billId}">
                                <input uglcw-model="remarks" id="remarks" uglcw-role="textbox" placeholder="备注">
                        </li>
                        <li>
                                <button class="k-button k-info" onclick="showDiscount()">保存</button>
                        </li>
                        <li>
                                <input type="checkbox" uglcw-role="checkbox" id="checkshow">
                                <label class="k-checkbox-label" for="checkshow">显示计划促销否</label>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
					responsive:['.header',40],
                    id:'id',
                    url: '${base}${ empty billId ? 'manager/queryPlanWare1' : 'manager/queryPlanSub'}',
                    criteria: '.form-horizontal',
					query: function(param){
						if(param.billId > 0){
							delete param['stkId']
						}else{
							delete param['billId']
						}
						return param;
					},
					loadFilter:{
						data: function(resp){
							return resp.list || [];
						}
					}
                    ">
                        <div data-field="wareCode" uglcw-options="width:120">商品编码</div>
                        <div data-field="wareNm" uglcw-options="width:120">商品名称</div>
                        <div data-field="price" uglcw-options="width:120">计划倍价</div>
                        <div data-field="inPrice" uglcw-options="width:100">计划进价</div>
                        <div data-field="discount2" uglcw-options="width:80,hidden: true">计划促销2</div>
                        <div data-field="discount3" uglcw-options="width:80,hidden: true">计划促销3</div>
                        <div data-field="discount4" uglcw-options="width:80,hidden: true">计划促销4</div>
                        <div data-field="startTime" uglcw-options="width:80">开始日期</div>
                        <div data-field="endTime" uglcw-options="width:80">结束日期</div>
                        <div data-field="disAmt" uglcw-options="width:80">计划毛利</div>


                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()

        //显示商品
        uglcw.ui.get('#checkshow').on('change', function () {
            var checked = uglcw.ui.get('#checkshow').value();
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('discount2');
                grid.showColumn('discount3');
                grid.showColumn('discount4');
            } else {
                grid.hideColumn('discount2');
                grid.hideColumn('discount3');
                grid.hideColumn('discount4');

            }
        })
    })

</script>
</body>
</html>
