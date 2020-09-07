<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售发货明细</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-grid td.router-link {
            color: blue;
            cursor: pointer;
        }

        .uglcw-grid .product-grid {
            padding: 0;
        }

        .uglcw-grid .product-footer {
            padding: 0;
            text-align: right !important;
        }
        .biz-type .k-input{
            color: black;
            background-color: rgba(0, 123, 255, .35);
        }

        .uglcw-grid .product-footer span {
            text-align: left;
            display: inline-block;
            text-overflow: ellipsis;
            white-space: nowrap;
            position: relative;
            padding: 0 .75rem;
        }
        .uglcw-query>li.xs-tp #xsTp_taglist {
            position: fixed;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        #grid .k-grid-toolbar{
            padding: 0px 10px 0px 10px!important;
            width: 100%;
            display: inline-flex;
            vertical-align: middle;
        }
        #grid .k-grid-toolbar .k-checkbox-label{
            margin-top: 5px!important;

        }
       #grid .k-grid-toolbar label{
            padding-left: 20px;
            margin-left: 10px;
            margin-top: 7px;
            margin-bottom: 0px!important;
        }

    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query" style="display: none">
                <li>
                    <input id="timeType"  uglcw-role="textbox" uglcw-model="timeType" value="1" />
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${query.sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${query.edate}">
                </li>

                <li>
                    <input uglcw-role="textbox" uglcw-model="billNo" value="${query.billNo}" placeholder="单据号"/>
                </li>
                <li id="showSourceBillNo" style="display: none">
                    <input uglcw-role="textbox" uglcw-model="sourceBillNo" value="${query.sourceBillNo}" placeholder="发票单号"/>
                </li>
                <li>
                    <input uglcw-role="textbox"  uglcw-model="outType" value="${query.outType}" />
                </li>
                <li >
                    <input uglcw-role="textbox"  uglcw-model="xsTp" value="${query.xsTp}" />
                    <input id="wareId"  uglcw-role="textbox" uglcw-model="wareId" value="${query.wareId}" />
                </li>
                <li>
                    <input uglcw-model="customerTypeId" value="${query.customerTypeId}" />
                </li>
                <li>
                    <input uglcw-role="textbox" value="${query.proName}" uglcw-model="proName" placeholder="客户名称"/>
                    <input uglcw-role="textbox" value="${query.proId}" uglcw-model="proId" placeholder="客户名称"/>
                    <input uglcw-role="textbox" value="${query.sourceBillNo}" uglcw-model="sourceBillNo" placeholder="客户名称"/>
                </li>
                <li>
                    <input uglcw-role="textbox" value="${query.empName}" placeholder="业务员" uglcw-model="empName">
                </li>
                <li>
                    <input uglcw-role="textbox" value="${query.wareNm}" placeholder="商品名称" uglcw-model="wareNm">
                </li>
                <li>
                    <input type="hidden" value="${query.carId}"  uglcw-role="textbox" uglcw-model="carId" id="carId">
                    <input type="hidden" value="${query.isType}"  uglcw-role="textbox" uglcw-model="isType" id="isType">
                    <input uglcw-role="textbox" value="${query.wareNm}" placeholder="商品名称" uglcw-model="wareNm">
                    <input uglcw-role="textbox" value="${query.waretype}" placeholder="商品类别" uglcw-model="waretype">
                </li>
                <li>
                    <input type="hidden" value="${query.regionId}"  uglcw-role="textbox" uglcw-model="regionId" id="regionId">
                </li>
                <li>
                    <input uglcw-role="textbox" value="${query.epCustomerName}" uglcw-model="epCustomerName" placeholder="所属二批"/>
                    <input uglcw-role="textbox" value="${query.saleType}" uglcw-model="saleType" placeholder="所属二批"/>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    mergeBy:'billNo',
                    id:'id',
                    url: '${base}manager/saleBillsStat/statOutSendPages',
                    criteria: '.uglcw-query',
                    query: function(params){
                        return params;
                    },
                    pageable: true,
                    rowNumber: true,
                    pageable: {
                        pageSizes: [20,40,50,100]
                    },
                    pageSize: 20,
                    aggregate:[
                     {field: 'qty', aggregate: 'sum'}
                    ],
                     dataBound: function(){
                        filterField();
                     },
                      dblclick: function(row){
                         var url = '';
                         var title ='';
                         var timeType=uglcw.ui.get('#timeType').value();
                         if(timeType==1){
                              if(row.xsTp=='销售退货'){
                                url='${base}manager/showstkinchecklook?billId=' + row.billId;
                                title='销售退货收货信息';
                              }else{
                                url='${base}manager/lookstkoutcheck?sendId=' + row.billId;
                                title='销售发票发货信息';
                              }
                         }else{
                             if(row.xsTp=='销售退货'){
                                url='${base}manager/showstkin?billId=' + row.billId;
                                title='销售退货信息';
                             }else{
                                url='${base}manager/showstkout?billId=' + row.billId;
                                title='销售发票信息';
                             }
                         }
                        uglcw.ui.openTab(title,url);
                    },
                     loadFilter: {
                      data: function (response) {
                        if(response && response.code == 200){
                            response.data.rows.splice(response.data.rows.length - 1, 1);
                            return response.data.rows || [];
                        }
                        return []
                      },
                        total: function(response){
                        return response.data ? response.data.total : 0;
                      },
                       aggregates: function (response) {
                        var aggregate = {};
                        if (response.data.rows && response.data.rows.length > 0) {
                            aggregate = response.data.rows[response.data.rows.length - 1]
                        }
                        return aggregate;
                      }
                     }
                    ">
                <div data-field="billNo" uglcw-options="width:150,merge:true, tooltip: true, footerTemplate:'合计'">
                        单据号
                </div>
                <div data-field="billDate" uglcw-options="merge:true,
                            width:140,
                            template: function(dataItem){
                                return kendo.template($('#formateData-template').html())(dataItem);
                          }">
                        单据日期
                </div>
                <div data-field="proName" uglcw-options="width:150,merge:true">客户名称</div>
                <div data-field="wareNm" uglcw-options="width:120">商品名称</div>
                <div data-field="xsTp" uglcw-options="width:120">销售类型</div>
                <div data-field="unitName" uglcw-options="width:80,hidden:true">计量单位</div>
                <div data-field="price" uglcw-options="width:80, format: '{0:n2}',hidden:true">销售单价</div>
                <div data-field="qty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.qty || 0, \'n2\')#'">
                    销售数量
                </div>
                <div data-field="outQty"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty || 0, \'n2\')#'">
                    发货数量
                </div>
                <div data-field="unitName" uglcw-options="width:100,hidden:true">计量单位(小)</div>
                <div data-field="minPrice" uglcw-options="width:100,format: '{0:n2}', hidden:true">销售单价(小)</div>
                <div data-field="minQty"
                     uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minQty || 0, \'n2\')#'">
                    销售数量(小)
                </div>
                <div data-field="minOutQty"
                     uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.minOutQty || 0, \'n2\')#'">
                    发货数量(小)
                </div>
                <div data-field="amt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.amt || 0, \'n2\')#'">
                    销售金额
                </div>
                <div data-field="outAmt"
                     uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt || 0, \'n2\')#'">
                    发货金额
                </div>
                <div data-field="payAmt"
                     uglcw-options="width:120,merge:true,format: '{0:n2}'">
                    回款金额
                </div>
                <div data-field="unPayAmt"
                     uglcw-options="width:120,merge:true,format: '{0:n2}'">
                    未回款金额
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120,merge:true,format: '{0:n2}'">
                    核销金额
                </div>
                <div data-field="sourceBillNo" uglcw-options="width:140 ,
                         template: function(dataItem){
                           return kendo.template($('#source-bill-no').html())(dataItem);
                          }">
                    对应销售单
                </div>
                <div data-field="proTel" uglcw-options="width:80,merge:true">客户电话</div>
                <div data-field="address" uglcw-options="width:80,merge:true">客户地址</div>
                <div data-field="empName" uglcw-options="width:80,merge:true">业务员</div>

                <div data-field="">
                </div>
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
<script id="formateData-template" type="text/x-kendo-template">
    #if(data.billDate){#
    #= uglcw.util.toString(new Date(data.billDate + 'GMT+0800'), 'yyyy-MM-dd HH:mm:ss')#
    #}#
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
<script id="source-bill-no" type="text/x-kendo-template">
    <a href="javascript:showSourceNoDetail(#=data.sourceBillId#);" style="color:blue;font-size: 12px; font-weight: bold;"> #= data.sourceBillNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<script>
    $(function () {
        uglcw.ui.init();
        filterField();
        uglcw.ui.loaded()
    })

    var filterDataType = ${query.filterDataType};
    function filterField(){
        var grid = uglcw.ui.get('#grid');
        if(filterDataType==1){
            grid.showColumn('unitName');
            grid.showColumn('price');
            grid.showColumn('qty');
            grid.showColumn('outQty');
            grid.hideColumn('minQty');
            grid.hideColumn('minOutQty');
            grid.hideColumn('minUnitName');
            grid.hideColumn('minPrice');
        }else if(filterDataType==2){
            grid.hideColumn('qty');
            grid.hideColumn('outQty');
            grid.hideColumn('unitName');
            grid.hideColumn('price');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
            grid.showColumn('minUnitName');
            grid.showColumn('minPrice');
        }else if(filterDataType==3){
            grid.showColumn('qty');
            grid.showColumn('outQty');
            grid.showColumn('minQty');
            grid.showColumn('minOutQty');
            grid.showColumn('unitName');
            grid.showColumn('price');
            grid.showColumn('minUnitName');
            grid.showColumn('minPrice');
        }

        var timeType = uglcw.ui.get("#timeType").value();
        if(timeType==1){
            grid.hideColumn('qty');
            grid.hideColumn('minQty');
            grid.hideColumn('amt');
            grid.hideColumn('payAmt');
            grid.hideColumn('unPayAmt');
            grid.hideColumn('freeAmt');
            grid.showColumn('sourceBillNo');
        }else{
            grid.showColumn('amt');
            grid.showColumn('payAmt');
            grid.showColumn('unPayAmt');
            grid.showColumn('freeAmt');
            if(filterDataType==1){
                grid.showColumn('qty');
            }
            if(filterDataType==2||filterDataType==3){
                grid.showColumn('minQty');
            }
            grid.hideColumn('sourceBillNo');
        }
    }

    function print() {
        var query = uglcw.ui.bind('.form-horizontal');
        query.filterDataType=filterDataType;
        var sdate = query.sdate;
        var edate = query.edate;
        if(sdate==""){
            uglcw.ui.info("开始日期不能为空!");
            return;
        }
        if(edate==""){
            uglcw.ui.info("结束日期不能为空!");
            return;
        }
        var dis =$.date.diff(sdate, 'm', edate);
        if((dis+1)>3){
            uglcw.ui.info("最多只能打印3个月之间的数据");
            return;
        }
        uglcw.ui.openTab('打印销售票据明细表', "${base}manager/saleBillsStat/toStatItemPrint?" + $.map(query, function (v, k) {
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
                uglcw.ui.get("#isType").value(uglcw.ui.get($(c).find('#_isType')).value())
                uglcw.ui.get("#waretype").value(uglcw.ui.get($(c).find('#wtypename')).value());
                uglcw.ui.get("#waretype").text(uglcw.ui.get($(c).find('#_type_id')).value());
                uglcw.ui.Modal.close(i);
                return false;

            }
        })
    }

    function showSourceNoDetail(id) {
        uglcw.ui.openTab('发票信息' + id, "${base}manager/showstkout?dataTp=1&billId=" + id)
    }


</script>
</body>
</html>
