<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>业务员提成计算表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        ::-webkit-input-placeholder {
            color: black;
        }

        .biz-type.k-combobox {
            font-weight: bold;

        }

        .biz-type .k-input {
            color: black;
            background-color: rgba(0, 123, 255, .35);
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
                    <select uglcw-model="timeType" uglcw-options="placeholder: '时间类型'" id="timeType" uglcw-role="combobox">
                        <option value="1" selected>发货单</option>
                        <option value="2">销售单</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="beginDate" id="beginDate" uglcw-role="datepicker" value="${beginDate}">
                </li>
                <li>
                    <input uglcw-model="endDate" id="endDate" uglcw-role="datepicker" value="${endDate}">
                </li>
                <li>
                    <select uglcw-model="billType" uglcw-options="placeholder: '销售类型'" id="xsTp" uglcw-role="combobox">
                        <option value="正常销售" selected>正常销售</option>
                        <option value="促销折让">促销折让</option>
                        <option value="消费折让">消费折让</option>
                        <option value="费用折让">费用折让</option>
                        <option value="其他销售">其他销售</option>
                        <option value="其它出库">其它出库</option>
                        <option value="借用出库">借用出库</option>
                        <option value="领用出库">领用出库</option>
                        <option value="报损出库">报损出库</option>
                        <option value="销售退货">销售退货</option>
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="salesmanName" placeholder="业务员"/>
                </li>
                <li>
                    <input uglcw-role="textbox" id="customerName" uglcw-model="customerName" placeholder="客户名称"/>
                </li>
                <%--<li>
                    <select id="wareTypeId" uglcw-role="dropdowntree" uglcw-options="
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
										" uglcw-model="wareTypeId"></select>
                </li>--%>
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="0" id="isType">
                    <input uglcw-role="gridselector" uglcw-model="wareTypeName,wareTypeId" id="wtype" placeholder="资产类型"
                           uglcw-options="
                           value:'库存商品类',
                           click: function(){
                                    waretype()
                           }
                    ">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="wareName" id="wareName" placeholder="品名"/>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li style="width: 200px;">
                    <select class="biz-type" id="type" uglcw-model="type" uglcw-role="combobox"
                            uglcw-options="placeholder:'提成类型类型'">
                        <c:forEach var="data" items="${pushMoneyTypeList}">
                        <option value="${data.value}">${data.name}</option>
                        </c:forEach>
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
                    id:'id',
                    type: 'post',
                    criteria: '.uglcw-query',
                    url: '${base}manager/report/salesman/push_money/count',
                    contentType: 'application/json',
                    parameterMap: function(o){
                        return JSON.stringify(o);
                    },
                    serverAggregates: false,
                    aggregate:[
                        {field: 'quantity', aggregate: 'sum'},
                        {field: 'amount', aggregate: 'sum'},
                        {field: 'pushMoney', aggregate: 'sum'},
                    ],
                    dblclick: function(row) {
                        var params = 'timeType=' + uglcw.ui.get('#timeType').value() + '&salesmanId=' + row.salesmanId + '&configType=' + uglcw.ui.get('#type').value()
                        + '&salesmanName=' + row.salesmanName + '&customerName=' + uglcw.ui.get('#customerName').value() + '&billType=' + uglcw.ui.get('#xsTp').value()
                        + '&beginDate=' + uglcw.ui.get('#beginDate').value() + '&endDate=' + uglcw.ui.get('#endDate').value();
                        var wareTypeId = uglcw.ui.get('#wtype').text();
                        if (wareTypeId > 0) {
                            params += '&wareTypeId=' + wareTypeId;
                        }
                        var wareName = uglcw.ui.get('#wareName').value();
                        if (wareName != '') {
                            params += '&wareName=' + wareName;
                        }
                        uglcw.ui.openTab('业务员提成详情', '${base}manager/report/salesman/push_money/detail/page?' + params);
                    },
                    loadFilter: {
                      data: function (response) {
                        if(response.code != 200) {
                            uglcw.ui.error(response.message);
                            return [];
                        } else {
                            return response.data;
                        }
                      }
                     }
                    ">
                <div data-field="salesmanName" uglcw-options="">业务员</div>
                <div data-field="quantity"
                     uglcw-options="format: '{0:n2}', aggregates:['sum'], footerTemplate: '#= uglcw.util.toString(sum || 0, \'n2\')#'">
                    数量
                </div>
                <div data-field="amount"
                     uglcw-options="format: '{0:n2}', aggregates:['sum'], footerTemplate: '#= uglcw.util.toString(sum || 0, \'n2\')#'">
                    金额
                </div>
                <div data-field="pushMoney"
                     uglcw-options="format: '{0:n2}', aggregates:['sum'], footerTemplate: '#= uglcw.util.toString(sum || 0, \'n2\')#'">
                    提成金额
                </div>
            </div>
        </div>
    </div>
</div>
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
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${beginDate}', edate: '${endDate}'});
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
