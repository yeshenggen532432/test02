<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3订单详情</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-in {
            width: 100%;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card master">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <c:if test="${bforder.orderZt == '未审核'}">
                            <li onclick="saveAudit()" class="k-info" data-icon="save">保存</li>
                        </c:if>
                    </ul>
                    <div class="bill-info">
                        <span class="status" id="orderNo" style="color:green;">${bforder.orderNo}</span>
                        <span class="status" id="divOrderStatus" style="color:green;">${bforder.orderZt}</span>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${bforder.id}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="payType" id="payType"
                               value="${bforder.payType}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">客户名称<c:if
                                    test="${!empty bforder.proType}">(${orderProTypeMap[bforder.proType]})</c:if> </label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" readonly uglcw-model="khNm" value="${bforder.khNm}"/>
                            </div>
                            <label class="control-label col-xs-3">送货日期</label>
                            <div class="col-xs-4">
                                <input id="shTime" uglcw-role="textbox" readonly uglcw-model="shTime"
                                       value="${bforder.shTime}">
                            </div>
                            <label class="control-label col-xs-3">订单日期</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="oddate" readonly uglcw-model="oddate"
                                       value="${bforder.oddate}"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">收货人</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="shr" uglcw-model="shr" value="${bforder.shr}"/>
                            </div>
                            <label class="control-label col-xs-3">客户地址</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="address" uglcw-model="address" value="${bforder.address}"
                                       title="${bforder.address}"/>
                            </div>
                            <label class="control-label col-xs-3">联系电话</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="tel" uglcw-model="tel" value="${bforder.tel}"/>
                            </div>

                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">配送指定</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" readonly uglcw-model="khNm" value="${bforder.pszd}"/>
                            </div>
                            <label class="control-label col-xs-3">业务员<c:if
                                    test="${!empty bforder.empType}">(${orderEmpTypeMap[bforder.empType]})</c:if> </label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" readonly uglcw-model="memberNm" value="${bforder.memberNm}"/>
                            </div>
                            <label class="control-label col-xs-3">仓库</label>
                            <div class="col-xs-4">
                                <tag:select2 name="stkId" id="stkId" tclass="pcl_sel" index="0" attrStr="disabled"
                                             value="${bforder.stkId }"
                                             tableName="stk_storage" displayKey="id" displayValue="stk_name"/>

                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom: 10px;">
                            <label class="control-label col-xs-3">商品总价</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="zje" readonly uglcw-model="zje" title="原单价*数量"
                                       value="${bforder.zje}"/>
                            </div>
                            <label class="control-label col-xs-3">促销总额</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="promotionCost" readonly uglcw-model="promotionCost"
                                       title="商品净收入总额-商品总价"
                                       value="${bforder.promotionCost}"/>
                            </div>
                            <label class="control-label col-xs-3">优惠券</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="couponCost" readonly uglcw-model="couponCost" title="优惠金额"
                                       value="${bforder.couponCost}"/>
                            </div>
                        </div>

                        <div class="form-group" style="margin-bottom: 10px;">
                            <label class="control-label col-xs-3">商品净收入总额</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="cjje" readonly uglcw-model="cjje" title="商品总价-促销总额"
                                       value="${bforder.cjje}"/>
                            </div>
                            <label class="control-label col-xs-3">运费</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="freight" uglcw-model="freight"
                                       value="${bforder.freight}"/>
                            </div>

                            <label class="control-label col-xs-3">订单实付</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="orderAmount" readonly uglcw-model="orderAmount"
                                       title="商品净收入总额+运费"
                                       value="${bforder.orderAmount}"/>
                            </div>
                        </div>

                        <div class="form-group" style="margin-bottom: 10px;">
                            <label class="control-label col-xs-3">状态</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" id="statusStr" readonly uglcw-model="statusStr"
                                       value="${orderStateMap[bforder.status]}"/>
                            </div>
                        </div>

                        <c:if test="${bforder.distributionMode==2}">
                            <div class="form-group" style="margin-bottom: 10px;">
                                <label class="control-label col-xs-3">配送方式</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="textbox" id="distributionModeStr" readonly
                                           value="${bforder.distributionMode==2?'自提':'邮寄'}"/>
                                </div>

                                <label class="control-label col-xs-3">提货人</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="textbox" id="takeName" readonly uglcw-model="takeName"
                                           value="${bforder.takeName}"/>
                                </div>
                                <label class="control-label col-xs-3">提货电话</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="textbox" id="takeTel" readonly uglcw-model="takeTel"
                                           value="${bforder.takeTel}"/>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${!empty bforder.transportName || !empty bforder.transportCode}">
                            <div class="form-group" style="margin-bottom: 10px;">

                                <label class="control-label col-xs-3">快递名称</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="textbox" id="transportName" readonly uglcw-model="transportName"
                                           value="${bforder.transportName}"/>
                                </div>

                                <label class="control-label col-xs-3">快递号</label>
                                <div class="col-xs-4">
                                    <input uglcw-role="textbox" id="transportCode" readonly uglcw-model="transportCode"
                                           value="${bforder.transportCode}"/>
                                </div>
                            </div>
                        </c:if>
                        <div class="form-group">
                            <label class="control-label col-xs-3">备注</label>
                            <div class="col-xs-18">
                                <textarea uglcw-role="textbox" uglcw-model="remo"
                                          style="width: 100%;">${bforder.remo}</textarea>
                            </div>

                        </div>
                    </form>
                </div>
            </div>
            <div class="layui-row layui-col-space15">
                <div class="layui-col-md12">
                    <div class="layui-card">
                        <div class="layui-card-body full">
                            <div id="grid" uglcw-role="grid"
                                 uglcw-options='
                          responsive:[".master",40],
						  toolbar: uglcw.util.template($("#toolbar").html()),
                          id: "ids",
                          editable: true,
                          add: function(row){
                            row = uglcw.extend({
                                xsTp: "正常销售",
                                id: uglcw.util.uuid()
                            }, row);
                            row.beUnit = row.maxUnitCode;
                            return row;
                          },
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "wareZj", aggregate: "sum"},
                            {field: "wareNum", aggregate: "sum"}
                          ],
                          <%--change: calTotalAmount,--%>
                          dataSource: gridDataSource
                        '>
                                <div data-field="detailWareNm" uglcw-options="width: 210,
                            schema:{
                                validation:{
                                    required: true,
                                    warecodevalidation:function(input){
                                        input.attr('data-warecodevalidation-msg', '请选择商品');
                                        if(!uglcw.ui.get(input).value()){
                                            uglcw.ui.toast('请选择商品');
                                        }
                                        return true;
                                    }
                                }
                            },
                            editor: function(container, options){
                                var rowIndex = $(container).closest('tr').index();
                                var cellIndex = $(container).index();
                                var input = $('<input name=\'_wareCode\' data-bind=\'value: wareNm\' placeholder=\'输入商品名称、商品代码、商品条码\' />');
                                input.appendTo(container);
                                $('<span data-for=\'_wareCode\' class=\'k-widget k-tooltip k-tooltip-validation k-invalid-msg\'>请选择商品</span>').appendTo(container);
                                new uglcw.ui.AutoComplete(input).init({
                                    highlightFirst: true,
                                    dataTextField: 'wareNm',
                                    autoWidth: true,
                                    url: '${base}manager/shopEndPrice/shopWareEndPricePageByShopMemberId?shopMemberId=${bforder.cid}',
                                    data: function(){
                                        return {
                                            page:1, rows: 20,
                                            wareType: '',
                                            stkId: uglcw.ui.get('#stkId').value(),
                                            wareNm: uglcw.ui.get(input).value()
                                        }
                                    },
                                    loadFilter:{
                                        data: function(response){
                                          return response.rows || [];
                                        }
                                    },
                                    template: '<div><span>#= data.wareNm#</span><span style=\'float: right\'>#= data.wareGg#</span></div>',
                                    select: function (e) {
                                        var item = e.dataItem;
                                        var model = options.model;
                                        addDetail1(model,item,rowIndex, cellIndex)
                                    }
                                });
                           }
                        ">产品名称
                                </div>
                                <%--<div data-field="wareGg" uglcw-options="width: 120, schema:{editable: false}">产品规格</div>--%>
                                <div data-field="detailWareGg" uglcw-options="width: 120,editable: false">产品规格</div>
                                <div data-field="xsTp"
                                     uglcw-options="width: 120, editor: function(container, options){
                                       var rowIndex = $(container).closest('tr').index();
                                        var cellIndex = $(container).index();
                                        var input = $('<input data-bind=\'value:xsTp\' />')
                                        input.appendTo(container);
                                        var widget = new uglcw.ui.ComboBox(input);
                                        widget.init({
                                            value: options.model.xsTp,
                                            dataTextField: 'text',
                                            dataValueField: 'value',
                                            dataSource:[{text:'正常销售',value:'正常销售'},{text:'促销折让',value:'促销折让'},
                                            {text:'消费折让',value:'消费折让'},{text:'费用折让',value:'费用折让'},{text:'其他销售',value:'其他销售'}],
                                            change: function(){
                                              uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
                                            }

                                        })
                                     }">
                                    销售类型
                                </div>
                                <div data-field="wareDw"
                                     uglcw-options="width:100,
                             editor: function(container, options){
                             var model = options.model;
                             var input = $('<input name=\'beUnit\' data-bind=\'value:beUnit\'>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.ComboBox(input);
                             var dataSource=[];
                             dataSource.push({ text: model.newWareDw, value:model.maxUnitCode});
                             if(model.newMinUnit)
                                dataSource.push({ text: model.newMinUnit, value:model.minUnitCode});

                             widget.init({
                              dataTextFiled: 'text',
                              dataValueField: 'value',
                              change: function(){
                                   changeWareDw(this.value(),this.text(),model);
                              },
                              dataSource:dataSource
                             })
                             }">单位
                                </div>

                                <div data-field="wareDj" uglcw-options="
                                width: 80,
                                template: uglcw.util.template($('#wareDjTempl').html()),
                                 editor: function(container, options){
                             var model = options.model;
                            var dataStyle='';
                            if(options.field=='wareDj'){
                                if(!model.wareDjOriginal){model.wareDjOriginal=model.wareDj}
                                if(model.wareDjOriginal && model.wareDjOriginal != model.wareDj){
                                    var oriInput=$('<input disabled style=\'width:35%\' data-bind=\'value:wareDjOriginal\'>');
                                    oriInput.appendTo(container);
                                    new uglcw.ui.TextBox(oriInput).init();
                                    dataStyle='style=\'width:55%\'';
                                }
                            }
                             var input = $('<input '+dataStyle+' name=\'wareDj\' data-bind=\'value:wareDj\'>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.Numeric(input);
                               widget.init({
                             value: model.wareDj
                             })
                             }">单价
                                </div>
                                <div data-field="wareNum"
                                     uglcw-options="width: 80,
                                     aggregates: ['sum'],
                                     schema:{ type: 'number'},
                                     footerTemplate: '#= (sum||0) #', format: '{0:n2}'
                                    ">订单数量
                                </div>
                                <div data-field="wareZj"
                                     uglcw-options="width: 100,
                                        format:'{0:n2}',
                                        schema:{ type: 'number'},
                                        aggregates: ['sum'],
                                         footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#'"
                                >
                                    订单金额
                                </div>
                                <div data-field="remark" uglcw-options="width: 120,schema:{editable: true}">备注</div>
                                <div data-field="options" uglcw-options="width: 120, command:'destroy'">操作</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:showAddWare();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加商品

    </a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<script id="wareDjTempl" type="text/x-uglcw-template">
    <%--不能换行--%>
    <c:set var="delDj" value="'<del>'+ data.wareDjOriginal +'</del>&nbsp;'+ data.wareDj"/>
    #= (data.wareDjOriginal && data.wareDjOriginal != data.wareDj) ? ${delDj} :  data.wareDj||'' #
</script>


<script>
    var gridDataSource = ${fns:toJson(warelist)};
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange') {
                var item = e.items[0];
                var commit = false;
                if (e.field == 'wareZj') {
                    item.set('wareDj', Number(item.wareZj / item.wareNum).toFixed(2));//订单金额/数量=单价
                    commit = true;
                } else if (e.field == 'wareNum' || e.field == 'wareDj') {
                    var wareZj = Number(item.wareDj * item.wareNum).toFixed(2);
                    item.set('wareZj', Number(item.wareDj * item.wareNum).toFixed(2));
                    if (!item.wareDjOriginal)//如果原价为空时直接等于现价
                        item.set('wareDjOriginal', item.wareDj);
                    commit = true;
                } else if (e.field === 'xsTp') { //销售类型
                    if (item.xsTp === '促销折让') {
                        item.set('wareDj', 0);
                        item.set('wareZj', 0);
                        commit = true;
                    }
                }
                if (commit) {
                    uglcw.ui.get('#grid').commit();
                }
                calTotalAmount();
                //uglcw.ui.get('#grid').commit();
            }
            if (e.action == 'remove') {
                calTotalAmount();
            }
        });

        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        $("#freight").on('change', calTotalAmount);//运费修改时重新计算价格
        //$("#wareDjOriginal").on('change', calTotalAmount);
        //setTimeout(uglcw.ui.loaded, 210);
        uglcw.ui.loaded();
    })

    //计算总价和
    function calTotalAmount() {
        var ds = uglcw.ui.get('#grid').k().dataSource;
        var data = ds.data().toJSON();
        var cjje = 0;
        var zje = 0;
        $(data).each(function (idx, item) {
            cjje += (Number(item.wareZj));
            if (!item.wareDjOriginal) {
                item.wareDjOriginal = item.wareDj
            }
            zje += (Number(item.wareDjOriginal) * Number(item.wareNum));//原单价*数量=商品总价
        })
        var promotionCost = (zje - cjje);
        uglcw.ui.get('#zje').value(zje.toFixed(2));
        uglcw.ui.get('#cjje').value(cjje.toFixed(2));
        uglcw.ui.get('#promotionCost').value(promotionCost.toFixed(2));
        var freight = uglcw.ui.get('#freight').value();
        if (!freight) {
            uglcw.ui.get('#freight').value(0);
            freight = 0;
        }
        uglcw.ui.get('#orderAmount').value((cjje + Number(freight)).toFixed(2));
    }

    function saveAudit() {//保存
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');

        //form.orderTp = form.orderTp || "销售订单";
        //form.orderLb = form.orderLb || "电话单";

        var row = uglcw.ui.get('#grid').bind();//绑定表单数据
        if (row.length == 0) {
            uglcw.ui.warning("请选择商品！");
            return false;
        }
        var msg = "";
        var i = 0;
        row = $.map(row, function (product) {
            i++;
            if (!product.wareId) {
                msg += "第" + i + "行请选择商品<br/>";
            }
            //if (!product.wareDw && !product.detailWareGg) {
            //    msg += "第" + i + "行请产品规格和单位不能同时为空<br/>";
            //}
            //if (!product.wareDjOriginal) {
            //    msg += "第" + i + "行原单价不能为空<br/>";
            //}
            if (!product.wareDj && product.wareDj !=0) {
                msg += "第" + i + "行单价不能为空<br/>";
            }
            if (!product.wareNum) {
                msg += "第" + i + "行订单数量不能为空<br/>";
            }
            if (!product.wareZj && product.wareZj !=0) {
                msg += "第" + i + "行订单金额不能为空<br/>";
            }
            if (!product.beUnit) {
                msg += "第" + i + "行单位不能为空<br/>";
            }
            return product;
        });
        if (msg) {
            uglcw.ui.error(msg);
            return false;
        }

        if (isNaN(form.cjje)) {
            uglcw.ui.error("商品净收入总额不是有效数字");
            return false;
        }
        if (isNaN(form.orderAmount)) {
            uglcw.ui.error("订单实付不是有效数字");
            return false;
        }
        if (isNaN(form.orderAmount)) {
            uglcw.ui.error("订单实付不是有效数字");
            return false;
        }

        if (form.payType && (form.payType == 3 || form.payType == 4)) {
            uglcw.ui.error("订单已提交第三方支付平台不能修改");
            return false;
        }
        form.wareStr = JSON.stringify(row);
        uglcw.ui.confirm('是否确定保存?', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/shopBforder/saveSaleorder',
                type: 'post',
                dataType: 'json',
                data: form,
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.success(json.message);
                        //location.href=location.href;
                    } else {
                        uglcw.ui.error(json.message || '保存失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded()
                }
            })
        })

    }

    //选择商品加入模版或所有商品对应的运费模版
    function showAddWare() {
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                url: '${base}manager/shopWareNewType/shopWaretypesExists',
                lazy: false,
                model: 'waretype',
                id: 'id',
                expandable: function (node) {
                    return node.id == 0;
                },
                loadFilter: function (response) {
                    $(response).each(function (index, item) {
                        if (item.text == '根节点') {
                            item.text = '商品分类'
                        }
                    })
                    return response;
                },
            },
            title: "选择商品",
            width: 900,
            id: 'wareId',
            pageable: true,
            url: '${base}manager/shopEndPrice/shopWareEndPricePageByShopMemberId?shopMemberId=${bforder.cid}',
            query: function (params) {
                //params.stkId = uglcw.ui.get('#stkId').value()
            },
            checkbox: true,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
            columns: [
                {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
                {field: 'wareNm', title: '商品名称', width: 250},
                {field: 'wareGg', title: '规格', width: 120},
                <c:choose>
                <c:when test="${'3'==source}">
                {field: 'shopWarePrice', title: '商城批发价(大)', width: 120},
                {field: 'shopWareLsPrice', title: '商城零售价(大)', width: 120},
                {field: 'shopWareSmallPrice', title: '商城批发价(小)', width: 120},
                {field: 'shopWareSmallLsPrice', title: '商城零售价(小)', width: 120},
                </c:when>
                <c:otherwise>
                {field: 'shopWareLsPrice', title: '商城零售价(大)', width: 120},
                {field: 'shopWareSmallLsPrice', title: '商城零售价(小)', width: 120},
                </c:otherwise>
                </c:choose>
                {field: 'wareDw', title: '大单位', width: 120},
                {field: 'minUnit', title: '小单位', width: 120},
                {field: 'maxUnitCode', title: '大单位代码', width: 120, hidden: true},
                {field: 'minUnitCode', title: '小单位代码', width: 120, hidden: true}
            ],
            yes: addDetail
        })
    }

    //增加订单商品明细
    function addDetail(data) {
        if (data) {
            $(data).each(function (i, item) {
                var obj = getWareExtract(null, item);
                data[i] = obj;
            })
            uglcw.ui.get('#grid').addRow(data);//添加到表单
            uglcw.ui.get('#grid').commit();
            uglcw.ui.get('#grid').scrollBottom();
            calTotalAmount();//触发成交金额总金额
        }
    }

    function addDetail1(model, item, rowIndex, cellIndex) {
        /*model.xsTp = '正常销售';
        model.hsNum = item.hsNum;
        model.wareCode = item.wareCode;
        model.wareGg = item.wareGg;
        model.wareNm = item.wareNm;
        model.wareDw = item.wareDw;
        model.price = item.inPrice;
        model.qty = 1;
        model.amt = model.price * model.qty;
        model.beUnit = item.maxUnitCode;
        model.wareId = item.wareId;
        model.minUnit = item.minUnit;
        model.minUnitCode = item.minUnitCode;
        model.maxUnitCode = item.maxUnitCode;
        model.productDate = item.productDate || new Date();*/
        getWareExtract(model, item);
        uglcw.ui.get('#grid').commit();
        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
    }

    function getWareExtract(obj, ware) {
        if (!obj) obj = {};
        obj.wareId = ware.wareId;//商品id
        if (!obj.wareNum)
            obj.wareNum = 1;//数量


        //如果是普通客户时批发价=零售价
        var shopWarePrice = ware.shopWareLsPrice;
        var shopWareLsPrice = ware.shopWareLsPrice;
        var shopWareSmallPrice = ware.shopWareSmallLsPrice;
        var shopWareSmallLsPrice = ware.shopWareSmallLsPrice;

        //如果是批发客户时重新计算
        <c:if test="${'3'==source}">
        shopWarePrice = ware.shopWarePrice;
        shopWareLsPrice = ware.shopWareLsPrice;

        shopWareSmallPrice = ware.shopWareSmallPrice;
        shopWareSmallLsPrice = ware.shopWareSmallLsPrice;
        </c:if>

        if (!shopWareLsPrice) shopWareLsPrice = shopWarePrice;
        obj.wareDj = shopWarePrice;//单价
        obj.wareDjOriginal = shopWareLsPrice;//商品原价(如果不存在促销或优惠卷时这个价和wareDj相等)


        obj.xsTp = '正常销售';//销售类型
        obj.wareDw = ware.wareDw;//单位
        obj.remark = "";//备注

        obj.beUnit = ware.maxUnitCode;
        obj.detailWareNm = ware.wareNm;//商品名称zzx
        obj.detailWareGg = ware.wareGg;//规格zzx
        obj.detailShopWareAlias = ware.shopWareAlias;//自营商城商品别称zzx
        obj.detailWareDesc = ware.wareDesc;//商品描述zzx

        obj.detailPromotionCost = 0;//商品促销总额
        obj.detailCouponCost = 0;//商品低优惠卷总额

        obj.minUnitCode = ware.minUnitCode;
        obj.maxUnitCode = ware.maxUnitCode;

        //数据源
        obj.newWareDw = ware.wareDw;//大单位名称
        obj.newWareGg = ware.wareGg;//大单位规格

        obj.newMinUnit = ware.minUnit;//小单位名称
        obj.newMinWareGg = ware.minWareGg;//小单位规格

        obj.shopWarePrice = shopWarePrice;//自营商城商品大单位批发价
        obj.shopWareLsPrice = shopWareLsPrice;//自营商城商品大单位零售价

        obj.shopWareSmallPrice = shopWareSmallPrice;//自营商城商品小单位批发价
        obj.shopWareSmallLsPrice = shopWareSmallLsPrice;//自营商城商品小单位零售价

        if (obj.wareNum && obj.wareDj)
            obj.wareZj = parseFloat(obj.wareNum) * parseFloat(obj.wareDj);
        return obj;
    }

    /**
     * 单位切换时
     * @param value
     * @param text
     * @param model
     */
    function changeWareDw(value, text, model) {
        if (!model.shopWareLsPrice && !model.shopWarePrice) {
            queryWarePrice(value, text, model);
        } else {
            setModel(value, text, model);
        }

    }

    //根据商品ID获取最新价格
    function queryWarePrice(value, text, model) {
        $.ajax({
            url: "${base}manager/shopEndPrice/shopWareEndPricePageByShopMemberId?shopMemberId=${bforder.cid}",
            data: {wareId: model.wareId},
            success: function (data) {
                if (data && data.rows && data.rows.length > 0) {
                    var ware = data.rows[0];
                    model = getWareExtract(model, ware);
                    setModel(value, text, model);
                }
            }
        });
    }

    //设置客户价格
    function setModel(value, text, model) {
        var detailWareGg = model.newMinWareGg;
        var wareDjOriginal = model.shopWareSmallLsPrice;

        var wareDj = model.shopWareSmallPrice;
        if ('B' == value) {
            detailWareGg = model.newWareGg;
            wareDjOriginal = model.shopWareLsPrice;
            wareDj = model.shopWarePrice;
        }
        if (!wareDjOriginal) wareDjOriginal = wareDj;
        model.set('detailWareGg', detailWareGg);
        model.set('wareDjOriginal', wareDjOriginal);
        model.set('wareDj', wareDj);
        model.set('wareDw', text);
        model.set('beUnit', value);
    }

</script>
</body>
</html>
