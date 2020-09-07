<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>领料库存</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-query > li{
            width: 150px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal query">
                        <li>
                            <input type="textbox" uglcw-role="textbox" uglcw-model="wareNm" placeholder="物料名称"/>
                        </li>
                        <li>
                            <tag:select2 name="proId" id="proId" tclass="pcl_sel" tableName="sys_depart"
                                         headerKey="" headerValue="--领料车间--" displayKey="branch_id"
                                         displayValue="branch_name"/>
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                        responsive:['.header',40],
                        checkbox: true,
                        toolbar: uglcw.util.template($('#toolbar').html()),
                        id:'id',
                        aggregate:[
							 {field: 'cost_price', aggregate: 'SUM'},
							 {field: 'qty', aggregate: 'SUM'},
							 {field: 'out_qty', aggregate: 'SUM'},
							 {field: '_jcQty', aggregate: 'SUM'},
							 {field: 'cost_amt', aggregate: 'SUM'}
                    	],
                        loadFilter:{
                        	data:function(response){
                        		if(!response || !response.rows || response.rows.length < 2){
                        			return []
                        		}
                        		response.rows.splice(response.rows.length-1, 1);
                        		$(response.rows).each(function(idx, row){
                        			row._jcQty = parseFloat(row.qty) - parseFloat(row.out_qty);
                        		})
                        		return response.rows || [];
                        	},
                        	aggregates: function(response){
                        		var aggregate = {
                        			cost_price: 0,
                        			qty: 0,
                        			out_qty: 0,
                        			_jcQty: 0,
                        			cost_amt: 0,
                        		};
								if (response.rows && response.rows.length > 0) {
									aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
									aggregate._jcQty = parseFloat(aggregate.qty) - parseFloat(aggregate.out_qty);
								}
								return aggregate;
                        	}
                        },
                        dblclick: function(row){
                          uglcw.ui.openTab('领料结存明细', '${base}manager/stkPickup/tostockitempage?proId='+row.pro_id + '&wareIds='+row.ware_id);
                        },
                        url: '${base}manager/stkPickup/stockpage',
                        criteria: '.query',
                        pageable: true
                    ">
                        <div data-field="pro_name" uglcw-options="width:160">车间</div>
                        <div data-field="ware_nm" uglcw-options="width:160">物料名称</div>
                        <div data-field="ware_gg" uglcw-options="width:140">规格</div>
                        <div data-field="cost_price"
                             uglcw-options="width:120, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cost_price,\'n2\')#'">
                            平均成本价
                        </div>
                        <div data-field="qty"
                             uglcw-options="width:120,hidden:true, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data.qty,\'n2\')#'">
                            领料数量
                        </div>
                        <div data-field="out_qty"
                             uglcw-options="width:120,hidden:true, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data.out_qty,\'n2\')#'">
                            已用数量
                        </div>
                        <div data-field="_jcQty"
                             uglcw-options="width:120, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data._jcQty,\'n2\')#'">
                            结存
                        </div>
                        <div data-field="cost_amt"
                             uglcw-options="width:120, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cost_amt,\'n2\')#'">
                            成本金额
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:add();">
        <span class="k-icon k-i-file-add"></span>领料回库
    </a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })


    function add() {
        var rows = uglcw.ui.get('#grid').selectedRow();
        if (rows && rows.length > 0) {
            var proId, proName, valid = true;
            var wareIds = $.map(rows, function (row) {
                if (!proId) {
                    proId = row.pro_id
                    proName = row.pro_name
                }
                if (proId != row.pro_id) {
                    valid = false;
                    return valid;
                }
                return row.ware_id;
            });
            if (!valid) {
                return uglcw.ui.error('请选择相同的车间回库！');
            }
            uglcw.ui.openTab('领料回库制单', '${base}manager/pcllhkIn?proId=' + proId + '&proName=' + proName + '&wareIds=' + wareIds.join(','));
        } else {
            uglcw.ui.warning('请勾选记录');
        }
    }
</script>
</body>
</html>
