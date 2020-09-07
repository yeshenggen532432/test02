<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品销售日报表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        ::-webkit-input-placeholder {
            color:black;
        }
        .biz-type.k-combobox{
            font-weight: bold;

        }
        .biz-type .k-input{
            color: black;
            background-color: rgba(0, 123, 255, .35);
        }

        .uglcw-grid .product-footer {
            padding: 0;
            text-align: right !important;
        }

        .uglcw-grid .product-footer span {
            text-align: left;
            display: inline-block;
            text-overflow: ellipsis;
            white-space: nowrap;
            position: relative;
            padding: 0 .75rem;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <select uglcw-model="timeType" id="timeType" uglcw-role="combobox">
                        <option value="1">发货时间</option>
                        <option value="2">销售时间</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-model="outType" id="outType" uglcw-role="combobox" uglcw-options="value:'销售出库',
                     placeholder:'出库类型',
                     change: function(){
                        uglcw.ui.get('#xsTp').k().dataSource.read();
                     }
">
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>

                    </select>
                </li>
                <li style="width: 180px!important;" class="xs-tp">
                    <input id="xsTp" uglcw-role="multiselect" uglcw-model="xsTp" uglcw-options="
                    placeholder:'销售类型',
                    tagMode: 'single',
                    tagTemplate: uglcw.util.template($('#xp-type-tag-template').html()),
                    autoClose: false,
                    url: '${base}manager/loadXsTp',
                    data: function(){
                        return {
                            outType: uglcw.ui.get('#outType').value()
                        }
                    },
                    loadFilter:{
                        data: function(response){
                            return response.list || []
                        }
                    },
                    dataTextField: 'xsTp',
                    dataValueField: 'xsTp'
                ">


                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="stkId" uglcw-options="
                                    dataTextField: 'stkName',
                                    dataValueField: 'id',
                                    url: '${base}manager/queryBaseStorage',
                                    placeholder: '仓库'
                                "></select>
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="业务员" uglcw-model="staff">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="customerTypeId" uglcw-options="
                                                url: '${base}manager/queryarealist1',
                                                placeholder: '客户类型',
                                                dataTextField: 'qdtpNm',
                                                dataValueField: 'id',
                                                loadFilter:{
                                                    data: function(response){
                                                        return response.list1 || [];
                                                    }
                                                }
                                             ">
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="客户名称" uglcw-model="khNm">
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="商品名称" uglcw-model="wareNm">
                </li>
                <%--<li>
                    <select uglcw-role="dropdowntree" uglcw-options="
											placeholder:'商品类别',
											url: '${base}manager/waretypes',
											loadFilter:function(response){
                                            $(response).each(function(index,item){
                                                    if(item.text=='根节点'){
                                                     item.text='库存商品类';
                                                    }
                                                })
                                                return response;
                                            },
											dataTextField: 'text',
											dataValueField: 'id'
										" uglcw-model="waretype"></select>
                </li>--%>
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="0" id="isType">
                    <input uglcw-role="gridselector" uglcw-model="wtypename,waretype" id="wtype" placeholder="资产类型"
                           uglcw-options="
                           value:'库存商品类',
                           click: function(){
                                    waretype()
                           }
                    ">
                </li>
                <li>
                    <input type="checkbox" uglcw-model="isShowDate" uglcw-value="1" uglcw-role="checkbox"
                           uglcw-options="type:'number'"
                           id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示日期</label>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li>
                    <select class="biz-type" id="saleType" uglcw-model="saleType" uglcw-role="combobox"
                            uglcw-options="placeholder:'业务类型', value: ''">
                        <option value="001" selected>传统业务类</option>
                        <option value="003">线上商城</option>
                        <option value="004">线下门店</option>
                    </select>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    autoBind: false,
                    responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/queryWareDayStat',
                    criteria: '.form-horizontal',
                    pageable: true,
                    aggregate:[
                     {field: 'qty', aggregate: 'SUM'},
                     {field: 'amt', aggregate: 'SUM'},
                     {field: 'outQty', aggregate: 'SUM'},
                     {field: 'outAmt', aggregate: 'SUM'}

                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        var rows = []
                        $(response.rows).each(function(idx, row){
                            var hit = rows.find(function(item){
                               return item.dateStr == row.dateStr&&item.wareId==row.wareId
                            })
                            console.log(hit);
                            if(!hit){
                                row.products = [
                                    {khNm: row.khNm, xsTp: row.xsTp, qty: row.qty, amt: row.amt, outQty: row.outQty,outAmt:row.outAmt}
                                ]
                                rows.push(row);
                            }else{
                               // hit.qty+=row.qty;
                               // hit.amt+=row.amt;
                               // hit.outQty+=row.outQty;
                               // hit.outAmt+=row.outAmt;

                                hit.products.push({khNm: row.khNm, xsTp: row.xsTp, qty: row.qty, amt: row.amt, outQty: row.outQty,outAmt:row.outAmt})
                            }
                        })
                        return rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            qty: 0,amt:0, outQty: 0, outAmt:0, recAmt:0, needRec:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="dateStr" uglcw-options="width:150, tooltip: true, footerTemplate:'合计'">日期</div>
                <div data-field="wareNm" uglcw-options="width: 200, tooltip: true">商品名称</div>
                <div data-field="unitName" uglcw-options="width: 80, tooltip: true">计量单位</div>
                <%--  <div data-field="wareNm" uglcw-options="width:120,hidden:true, tooltip: true">商品名称</div>
                  <div data-field="xsTp" uglcw-options="width:120,hidden:true">销售类型</div>
                  <div data-field="unitName" uglcw-options="width:100, hidden:true">计量单位</div>
                  <div data-field="price" uglcw-options="width:120,hidden:true, format: '{0:n2}'">销售单价</div>--%>
                <%--  <div data-field="products"
                      uglcw-options="width: 450, template: uglcw.util.template($('#product-tpl').html())">商品信息
                 </div>--%>
                 <div data-field="products"
                      uglcw-options="width: 450,
                       attributes:{class: 'product-grid'},
                       footerAttributes: {class: 'product-footer'},
                       footerTemplate: uglcw.util.template($('#product-footer-tpl').html()),
                       template: uglcw.util.template($('#product-tpl').html())">商品信息
                 </div>


</div>
</div>
</div>
</div>
<script type="text/x-kendo-template" id="toolbar">

</script>

<script type="text/x-uglcw-template" id="xp-type-tag-template">
    <div style="width: 130px;
            text-overflow: ellipsis;
            white-space: nowrap">
        # for(var idx = 0; idx < values.length; idx++){ #
        #: values[idx]#
        # if(idx < values.length - 1) {# , # } #
        # } #
    </div>
</script>

<script id="product-footer-tpl" type="text/x-uglcw-template">
    <div class="product-table">
        <span class="router-link" data-field="qty" style="width: 60px;">#= uglcw.util.toString(data.qty, 'n2')#</span>
        <span class="router-link" data-field="amt" style="width: 60px;">#= uglcw.util.toString(data.amt, 'n2')#</span>

        <span class="router-link" data-field="outQty"
              style="width: 60px;">#= uglcw.util.toString(data.outQty, 'n2')#</span>
        <span class="router-link" data-field="outAmt"
              style="width: 60px;">#= uglcw.util.toString(data.outAmt, 'n2')#</span>
    </div>
</script>

<script id="product-tpl" type="text/x-uglcw-template">
<table class="product-grid" style="border-bottom:1px \\#3343a4 solid;padding-left: 5px;">
<tbody>
<tr style="font-weight: bold;">
<td style="width: 120px;">客户名称</td>
<td style="width: 80px;">销售类型</td>
<td style="width: 60px;">销售数量</td>
<td style="width: 60px;">销售金额</td>
<td style="width: 60px;">发货数量</td>
<td style="width: 60px;">发货金额</td>
</tr>
#for (var i=0; i< data.products.length; i++) { #
<tr>
<td>#= data.products[i].khNm #</td>
<td>#= data.products[i].xsTp #</td>
    <td
            data-field="qty"
            data-ware-id="#= data.products[i].wareId#"
            #if(data.products[i].qty){#
            class="router-link"
            #}#
    >#= uglcw.util.toString(data.products[i].qty,'n2')#
    </td>
    <td
            data-field="amt"
            data-ware-id="#= data.products[i].wareId#"
            #if(data.products[i].amt){#
            class="router-link"
            #}#
    >#= uglcw.util.toString(data.products[i].amt,'n2')#
    </td>
    <td
            data-field="outQty"
            data-ware-id="#= data.products[i].wareId#"
            #if(data.products[i].outQty){#
            class="router-link"
            #}#
    >#= uglcw.util.toString(data.products[i].outQty,'n2')#
    </td>
    <td
            data-field="outAmt"
            data-ware-id="#= data.products[i].wareId#"
            #if(data.products[i].outAmt){#
            class="router-link"
            #}#
    >#= uglcw.util.toString(data.products[i].outAmt,'n2')#
    </td>
</tr>
# }#
</tbody>
</table>
</script>
<script id="product-type-selector-template" type="text/uglcw-template">
    <div class="uglcw-selector-container">
        <div style="line-height: 30px">
            已选:
            <button style="display: none;" id="_type_name" class="k-button k-info ghost"></button>
        </div>
        <div style="padding: 2px;height: 344px;">
            <input type="hidden" uglcw-role="textbox" id="_type_id">
            <input type="hidden" uglcw-role="textbox" id="_isType">
            <input type="hidden" uglcw-role="textbox" id="wtypename">
            <ul uglcw-role="accordion">
                <li>
                    <span>库存商品类</span>
                    <div>
                        <div uglcw-role="tree"
                             uglcw-options="
                                url:'${base}manager/syswaretypes?isType=0&noCompany=0',
                                id:'id',
                                expandable:function(node){
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
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(0);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
                                }
                            ">
                        </div>
                    </div>
                </li>
                <li>
                    <span>原辅材料类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=1&noCompany=0',
                                id:'id',
                                expandable:function(node){
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
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(1);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
                                }
                            ">
                    </div>
                </li>
                <li>
                    <span>低值易耗品类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=2&noCompany=0',
                                id:'id',
                                expandable:function(node){
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
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(2);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
                                }
                            ">
                    </div>
                </li>
                <li>
                    <span>固定资产类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=3&noCompany=0',
                                id:'id',
                                expandable:function(node){
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
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(3);
                                    uglcw.ui.get('#wtypename').value(node.text);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();

                                }
                            ">
                    </div>
                </li>
            </ul>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

$(function () {
uglcw.ui.init();
$('.q-box-arrow').on('click', function () {
$(this).find('i').toggleClass('k-i-arrow-chevron-left k-i-arrow-chevron-down');
$('.q-box-more').toggle();
$('.q-box-wrapper').closest('.layui-card').toggleClass('box-shadow')
})

//显示商品
uglcw.ui.get('#showProducts').on('change', function () {
var checked = uglcw.ui.get('#showProducts').value();
var grid = uglcw.ui.get('#grid');
if (checked) {
 grid.showColumn('dateStr');
} else {
 grid.hideColumn('dateStr');
}
uglcw.ui.get('#grid').reload();
})

uglcw.ui.get('#search').on('click', function () {
uglcw.ui.get('#grid').reload();
})

uglcw.ui.get('#reset').on('click', function () {
uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
})


uglcw.ui.loaded()
})

//资产类型
function waretype() {
    var i = uglcw.ui.Modal.open({
        checkbox: true,
        selection: 'single',
        title: false,
        maxmin: false,
        resizable: false,
        move: true,
        btns: ['确定', '取消'],
        area: ['400', '415px'],
        content: $('#product-type-selector-template').html(),
        success: function (c) {
            uglcw.ui.init(c);
        },
        yes: function (c) {
            uglcw.ui.get("#isType").value(uglcw.ui.get($(c).find('#_isType')).value());
            uglcw.ui.get("#wtype").value(uglcw.ui.get($(c).find('#wtypename')).value());
            uglcw.ui.get("#wtype").text(uglcw.ui.get($(c).find('#_type_id')).value());
            uglcw.ui.Modal.close(i);
            return false;

        }

    })


}

</script>
</body>
</html>
