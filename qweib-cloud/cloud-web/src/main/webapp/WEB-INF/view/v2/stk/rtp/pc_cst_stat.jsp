<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售客户毛利统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>

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
        .uglcw-query>li.xs-tp #xsTp_taglist {
            position: fixed;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" id="database" uglcw-model="database" uglcw-role="textbox" value="${database}">
                    <select uglcw-role="combobox" uglcw-model="timeType"
                            uglcw-options="placeholder:'时间类型',value: '2'">
                        <option value="2">销售时间</option>
                        <option value="1">发货时间</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                <select uglcw-model="outType" id="outType" uglcw-role="combobox" uglcw-options="
                     placeholder:'出库类型',
                     change: function(){
                        uglcw.ui.get('#xsTp').k().dataSource.read();
                     }">
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
                    <input uglcw-role="textbox" uglcw-model="stkUnit" placeholder="客户名称"/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="staff" placeholder="业务员"/>
                </li>
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="0" id="isType">
                    <input uglcw-role="gridselector" uglcw-model="wtypename,wtype" id="wtype" placeholder="资产类型"
                        uglcw-options="
                        value:'库存商品类',
                        click:function(){
                                waretype()
                        }
                        "
                    >
                </li>
                <li>
                    <select uglcw-role="dropdowntree" uglcw-options="
											placeholder:'客户所属区域',
											url: '${base}manager/sysRegions',
											dataTextField: 'text',
											dataValueField: 'id'
										" uglcw-model="regionId"></select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="epCustomerName" placeholder="所属二批"/>
                </li>
                <li>
                    <input type="checkbox" uglcw-model="showItems" uglcw-role="checkbox" uglcw-options="type: 'number'"
                           id="showItems">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showItems">显示投入费用列</label>
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
                    responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    autoBind: false,
                    url: '${base}manager/queryCstStatPage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    aggregate:[
                     {field: 'sumQty', aggregate: 'sum'},
                    ],
                    dblclick: function(row){
                        var q = uglcw.ui.bind('.form-horizontal');
                        q.stkUnit = row.stkUnit;
                        uglcw.ui.openTab('客户毛利明细统计', '${base}manager/queryCstStatDetail?'+ $.map(q, function(v, k){
                            return k+'='+(v||'');
                        }).join('&'));
                    },
                    loadFilter: {
                      data: function (response) {
                        if(!response || !response.rows || response.rows.length <1){
                            return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            sumQty:0,
                            sumAmt:0,
                            avgPrice:0,
                            discount:0,
                            inputAmt:0,
                            sumCost:0,
                            disAmt:0,
                            avgAmt:0,
                            rate:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="stkUnit" uglcw-options="width: 150,footerTemplate:'合计'">客户名称</div>
                <div data-field="sumQty"
                     uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right', footerTemplate: '#= uglcw.util.toString(data.sumQty.sum != undefined ? data.sumQty.sum : data.sumQty , \'n2\')#'">
                    销售数量
                </div>
                <div data-field="sumAmt"
                     uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right', footerTemplate:'#= uglcw.util.toString(data.sumAmt || 0, \'n2\')#'">
                    销售收入
                </div>
                <div data-field="avgPrice"
                     uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right', footerTemplate: '#= uglcw.util.toString(data.avgPrice || 0, \'n2\')#'">
                    平均单位售价
                </div>
                <div data-field="discount"
                     uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right', footerTemplate: '#= uglcw.util.toString(data.discount || 0, \'n2\')#'">
                    整单折扣
                </div>
                <div data-field="inputAmt"
                     uglcw-options="width:100,titleAlign:'center',align:'right',
                                 template: uglcw.util.template($('#amtformatterInput').html()),footerTemplate: '#= uglcw.util.toString(data.inputAmt || 0, \'n2\')#'">
                    销售投入费用
                </div>
                <div data-field="showItems"
                     uglcw-options="width:220, format: '{0:n2}', hidden: true,titleAlign:'center',align:'right',
                                 template: uglcw.util.template($('#formatterItems').html()),footerTemplate: '#= uglcw.util.toString(data.showItems || 0, \'n2\')#'">
                    费用明细列
                </div>
                <div data-field="sumCost"
                     uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right', footerTemplate: '#= uglcw.util.toString(data.sumCost || 0, \'n2\')#'">
                    销售成本
                </div>
                <div data-field="disAmt"
                     uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right', footerTemplate: '#= uglcw.util.toString(data.disAmt || 0, \'n2\')#'">
                    销售毛利
                </div>
                <div data-field="avgAmt"
                     uglcw-options="width:120, format: '{0:n2}', titleAlign:'center',align:'right',footerTemplate: '#= uglcw.util.toString(data.avgAmt || 0, \'n2\')#'">
                    平均单位毛利
                </div>
                <div data-field="rate"
                     uglcw-options="width:120,titleAlign:'center',align:'right', template:'#=uglcw.util.toString(data.rate, \'n2\')#%', footerTemplate: '#= uglcw.util.toString(data.rate || 0, \'n2\')#%'">
                    毛利率
                </div>
                <div data-field="epCustomerName" uglcw-options="width:120">所属二批</div>
            </div>
        </div>
    </div>
</div>
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

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>导出
    </a>
</script>
<tag:exporter service="incomeStatService" method="sumCstIncome"
              bean="com.qweib.cloud.biz.erp.model.CstInComeVo"
              condition=".uglcw-query" description="客户销售毛利统计表"

/>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:exportExcel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>导出
    </a>
    <a href="javascript:showMainDetail()" class="k-button k-button-icontext">显示所有明细</a>
</script>
<script id="formatterItems" type="text/x-uglcw-template">
    <table class="product-grid" style="border-bottom:1px \\#3343a4 solid;padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            #var row = data.toJSON();#
            #$.map(row.autoMap, function(v, key){#
            <td style="width: 60px;">#= key#</td>
            #})#
        </tr>
        <tr>
            #$.map(row.autoMap, function(v, key){#
            <td>#= v #</td>
            #})#
        </tr>
        </tbody>
    </table>
</script>
<script id="amtformatterInput" type="text/x-uglcw-template">
    <button style="color: blue" class="k-button" onclick="showInputAmt('#= data.stkUnit#')">#=
        uglcw.util.toString(data.inputAmt || 0, 'n2')#
    </button>
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
            <input type="hidden" uglcw-role="textbox" id="wtypeName">
            <ul uglcw-role="accordion">
                <li>
                    <span>库存商品类</span>
                    <div>
                        <div uglcw-role="tree"
                             uglcw-options="
                                url:'${base}manager/syswaretypes?isType=0',
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
                                    uglcw.ui.get('#wtypeName').value(node.text);
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
                                url:'${base}manager/syswaretypes?isType=1',
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
                                    uglcw.ui.get('#wtypeName').value(node.text);
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
                                url:'${base}manager/syswaretypes?isType=2',
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
                                    uglcw.ui.get('#wtypeName').value(node.text);
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
                                url:'${base}manager/syswaretypes?isType=3',
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
                                    uglcw.ui.get('#wtypeName').value(node.text);
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

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        //费用明细列
        uglcw.ui.get('#showItems').on('change', function () {
            var checked = uglcw.ui.get('#showItems').value();
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('showItems');
            } else {
                grid.hideColumn('showItems');
            }
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}',isType:'',wtypename:'',wtype:''});
        })

        $('#wtype').on('change',function () {
            if(!uglcw.ui.get('#wtype').value()){
                uglcw.ui.bind('.uglcw-query',{isType:''});
                // uglcw.ui.clear('.form-horizontal',{isType:''},{excludeHidden: false})  //需要加配置，默认不会清除隐藏的控件
            }

        })
        uglcw.ui.loaded();
    })

    function showMainDetail() {
        var q = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('查看客户毛利明细', '${base}manager/queryCstStatDetailList?' + $.map(q, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function exportExcel() {
    }

    function createRptData() {
        var query = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('生成销售票据明细表', "${base}manager/toStkOutDetailSave?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function queryRpt() {
        uglcw.ui.openTab('生成的统计表', '${base}manager/toStkCstStatQuery?rptType=8');
    }

    function showInputAmt(stkUnit) {
        var q = uglcw.ui.bind('.form-horizontal');
        q.stkUnit=stkUnit;
        uglcw.ui.openTab('客户销售投入费用明细', '${base}manager/toCstSaleInputAmtList?' + $.map(q, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function waretype() {
        var i = uglcw.ui.Modal.open({
            checkbox:true,
            selection:'single',
            title:false,
            maxmin:false,
            resizable:false,
            move:true,
            btns:['确定','取消'],
            area:['400','415px'],
            content:$('#product-type-selector-template').html(),
            success:function (c) {
                uglcw.ui.init(c);
            },
            yes:function (c) {
                uglcw.ui.get('#wtype').value(uglcw.ui.get($(c).find('#wtypeName')).value());
                uglcw.ui.get('#wtype').text(uglcw.ui.get($(c).find("#_type_id")).value());
                uglcw.ui.get('#isType').value(uglcw.ui.get($(c).find("#_isType")).value());
                uglcw.ui.Modal.close(i);
                return false;

            }
        })

    }

</script>
</body>
</html>
