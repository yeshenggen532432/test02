<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>盘点开单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .snapshot-badge-dot {
            display: none;
            position: absolute;
            -webkit-transform: translateX(-50%);
            transform: translateX(-50%);
            -webkit-transform-origin: 0 center;
            transform-origin: 0 center;
            top: 4px;
            right: 8px;
            height: 8px;
            width: 8px;
            border-radius: 100%;
            background: #ed4014;
            z-index: 10;
            box-shadow: 0 0 0 1px #fff;
        }

        .color_class .k-dirty2 {
            margin: 0;
            top: 0;
            left: 0;
        }

        .color_class .k-dirty2 {
            position: absolute;
            width: 0;
            height: 0;
            border-style: solid;
            border-width: 3px;
            border-color: red transparent transparent red;
            padding: 0;
            overflow: hidden;
            vertical-align: top;
        }

        .row-color-blue {
            color: blue !important;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <form id="newWareFrom" style="display:none;">

    </form>
    <form id="export" action="${base}manager/downloadCheckDataToExcel" method="post" style="display: none;">
        <textarea uglcw-role="textbox" name="wareStr" id="wareStr"></textarea>
    </form>
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" id="wareTypeDiv" style="width: 150px;" uglcw-options="collapsed: true">
            <div class="layui-card" uglcw-role="resizable" uglcw-options="responsive:[35]">
                <ul uglcw-role="accordion">
                    <li>
                        <span>库存商品类</span>
                        <div uglcw-role="tree"
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
                                    onWareTypeSelect(node.id);
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
                                     onWareTypeSelect(node.id);
                                   }">
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
                                   onWareTypeSelect(node.id);
                                   } ">

                        </div>
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
                                        onWareTypeSelect(node.id);
                                   }">
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-header btn-group" style="height: 40px;">
                    <ul class="uglcw-query form-horizontal query">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="wtype" id="wtype" value="${wtype}"/>
                        <input id="billId" type="hidden" uglcw-role="textbox" uglcw-model="id" value="${billId}"/>
                        <li style="width: 150px">
                            <input uglcw-model="checkTimeStr" uglcw-role="datetimepicker"
                                   uglcw-options="format: 'yyyy-MM-dd HH:mm'"
                                   value="${checkTime}" placeholder="盘点时间">
                        </li>
                        <li style="width: 150px">
                            <select uglcw-model="stkId" id="stkId" uglcw-role="combobox"
                                    uglcw-options="
                                            index: 0,
                                            value: '${stkId}',
                                            url: '${base}manager/queryBaseStorage',
                                            dataTextField: 'stkName',
                                            dataValueField: 'id'
                                        "
                                    placeholder="盘点仓库"></select>
                        </li>
                        <li style="width: 150px">
                            <input value="${staff}" placeholder="选择人员" uglcw-model="staff,empId"
                                   uglcw-role="gridselector"
                                   uglcw-options="click: function(){
                                         selectEmployee();
                                        }"/>
                        </li>
                        <li style="padding-top: 8px;padding-left: 10px;">
                            <input type="checkbox" uglcw-role="checkbox" uglcw-model="checkScope" uglcw-value="${checkScope}"
                                   uglcw-options="type:'number'"
                                   class="k-checkbox" id="checkScope"/>
                            <label style="margin-bottom: 0;" class="k-checkbox-label" for="checkScope">剩余清零</label>
                        </li>

                        <li>
                            <button uglcw-role="button"
                               onclick="showPc();" id="isPc">
                                <span class="k-icon k-i-save"></span>按批次盘点
                            </button>
                        </li>


                    </ul>
                    <div class="bill-info">
                        <input type="hidden" id="snapshotId" uglcw-role="textbox" uglcw-model="snapshot"/>
                        <div id="snapshot" onclick="showSnapshot()" style="border: none;" class="k-info ghost">
                            快照<i class="k-icon k-i-clock"></i>
                            <sup class="snapshot-badge-dot"></sup>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-card">

                <%--url: '${base}manager/queryCheckSub?billId=${billId}'--%>

                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid-advanced"
                         uglcw-options="
                            responsive: ['.header', 40],
                            editable: true,
                            autoAppendRow: false,
                            rowNumber: true,
                            lockable: false,
                            toolbar: uglcw.util.template($('#toolbar').html()),
                            id:'id',
                            serverFiltering: false,
                            speedy:{
							  className: 'uglcw-cell-speedy'
							},
                    ">
                        <div data-field="" uglcw-options="
                          width:60,
                          template: function(dataItem){
                           return kendo.template($('#confirmBtn').html())(dataItem);
                          }
                        ">
                        </div>
                        <div data-field="wareCode" uglcw-options="width:120,hidden:true,tooltip: true">商品编码</div>
                        <div data-field="appendData" uglcw-options="width:120,hidden:true, tooltip: true">是否清除</div>
                        <div data-field="wareNm" uglcw-options="width:120, tooltip: true">商品名称</div>
                        <div data-field="wareGg" uglcw-options="width:90">规格</div>
                        <div data-field="minStkQty" uglcw-options="width:90,hidden:true">账面数量(小)</div>
                        <div data-field="stkQty" uglcw-options="width:90,hidden:true">账面数量(大)</div>
                        <div data-field="_stkQty" uglcw-options="width:90,format:'{0:n2}'">账面数量</div>
                        <div data-field="_sum_Qty" uglcw-options="width:90">账面大小数量</div>
                        <div data-field="maxQtyFlag" uglcw-options="width:90,hidden:true">大单位修改标示</div>
                        <div data-field="minQtyFlag" uglcw-options="width:90,hidden:true">小单位修改标示</div>
                        <div data-field="checkQty" uglcw-options="width:90">盘点数</div>
                        <div data-field="qty"
                             uglcw-options="width:120,hidden:true">盘点数(大)
                        </div>
                        <div data-field="_qty"
                             uglcw-options="width:120,
                              attributes:{class: 'uglcw-cell-speedy k-dirty-cell maxQtyFlag'},
                              template: function(data){
                                return uglcw.util.template($('#checkedTemplate').html())({
                                    checked: data.maxQtyFlag,
                                    value: data._qty
                                })
                              },
                              editor: _qtyEditor">盘点数(大)
                        </div>
                        <div data-field="unitName" uglcw-options="width:50">大单位</div>
                        <div data-field="minQty"
                             uglcw-options="width:120,
                              attributes:{class: 'k-dirty-cell minQtyFlag'},
                              template: function(data){
                                return uglcw.util.template($('#checkedTemplate').html())({
                                    checked: data.minQtyFlag,
                                    value: data.minQty
                                })
                              },
                              editor: minQtyEditor">
                            盘点数(小)
                        </div>
                        <div data-field="minUnit" uglcw-options="width:50">小单位</div>
                        <div data-field="disQty" uglcw-options="width:90,hidden:true">盘盈亏±</div>
                        <div data-field="_disQty" uglcw-options="width:90">盘盈亏±</div>
                        <div data-field="productDate" uglcw-options="width: 100, format: 'yyyy-MM-dd',
                             schema:{ type: 'date'},
                             editor: function(container, options){
                                var model = options.model;
                                var input = $('<input  data-bind=\'value:productDate\' />');
                                input.appendTo(container);
                                var picker = new uglcw.ui.DatePicker(input);
                                picker.init({
                                    editable: true,
                                    format: 'yyyy-MM-dd',
                                    value: model.productDate ? model.productDate : new Date()
                                });
                                picker.k().open();
                             }
                            ">生产日期
                        </div>
                        <div data-field="options" uglcw-options="width: 100, command:'destroy'">
                            操作
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script id="confirmBtn" type="text/x-kendo-template">
    #var bool = (data.priceFlag==1||data.maxQtyFlag==1||data.minQtyFlag==1) #
    #if(bool){#
    <a onclick="confirmBtn(this);" id="btn_id_#=data.wareId#"
       style="color:\\#61a05c;font-size: 12px; font-weight: bold;">已盘</a>
    #}else{#
    <a onclick="confirmBtn(this);" id="btn_id_#=data.wareId#"
       style="color:\\#337ab7;font-size: 12px; font-weight: bold;">未盘</a>
    #}#

</script>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showProductSelector();">
        <span class="k-icon k-i-search"></span>选择商品
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:drageSaveStk();" id="savedrage">
        <span class="k-icon k-i-save"></span>暂存
    </a>

    <a role="button" class="k-button k-button-icontext"
       href="javascript:audit();" id="btndraftaudit" style="display: ${billId eq 0?'none':''}">
        <span class="k-icon k-i-check"></span>审批
    </a>
    <c:if test="${billId eq 0}">

        <a role="button" class="k-button k-button-icontext"
           href="javascript:submitStk();" id="saveaudit">
            <span class="k-icon k-i-check"></span>保存并审批
        </a>
    </c:if>
    <%--   <a role="button" class="k-button k-button-icontext"
          href="javascript:showWareType(1);">
           <span class="k-icon k-i-search"></span>按类别查看当前数据
       </a>--%>

    <c:if test="${billId eq 0}">
        <a role="button" class="k-button k-button-icontext"
           href="javascript:loadNotZeroData(1);" id="loadZeroData">
            <span class="k-icon k-i-search"></span>加载库存不为0商品
        </a>
        <a role="button" class="k-button k-button-icontext"
           href="javascript:loadNotZeroData(2);" id="loadZeroData">
            <span class="k-icon k-i-search"></span>加载库存含负的商品
        </a>
    </c:if>

    <div class="k-button">
        <input type="checkbox" uglcw-role="checkbox" onclick="fiterData('')" uglcw-model="showModifyChk"
               uglcw-options="type:'number'"
               class="k-checkbox" id="showModifyChk"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="showModifyChk">已修改数据</label>
    </div>

    <div class="k-button">
        <input type="checkbox" uglcw-role="checkbox" onclick="fiterData('')" uglcw-model="showUnModifyChk"
               uglcw-options="type:'number'"
               class="k-checkbox" id="showUnModifyChk"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="showUnModifyChk">未修改数据</label>
    </div>

    <c:if test="${billId eq 0}">
        <a role="button" class="k-button k-button-icontext"
           href="javascript:toDownloadDataExcel();">
            <span class="k-icon k-i-download"></span>下载当前数据
        </a>
        <a role="button" class="k-button k-button-icontext"
           href="javascript:toDownloadCheckCustomTemplate();">
            <span class="k-icon k-i-download"></span>下载模版
        </a>
        <a role="button" class="k-button k-button-icontext"
           href="javascript:toUpCustomWare();">
            <span class="k-icon k-i-upload"></span>上传数据
        </a>
    </c:if>
    <span style="color: red;">（盘点数(大)+盘点数(小)-账面数量=盘盈亏±）</span>
</script>
<script id="checkedTemplate" type="text/x-uglcw-template">
    #if(data.checked){#
    <span class="k-dirty"></span>
    #}#
    #= data.value#
</script>
<tag:product-check-selector-template query="onProductQuery"/>
<script type="text/x-uglcw-template" id="snapshot-tpl">
    <div uglcw-role="grid" uglcw-options="
            id: 'id',
            pageable: false,
            url: '${base}manager/common/bill/snapshot?billType=inventory-check',
            data: function(params){
                var billId = uglcw.ui.get('#billId').value();
                if(billId && billId != '0'){
                    params.billId = billId;
                }
                return params;
            },
            loadFilter:{
                data: function(response){
                    return response.data || [];
                }
            }
        ">
        <div data-field="updateTime" uglcw-options="schema:{type: 'timestamp',format: 'yyyy-MM-dd HH:mm:ss'}">更新时间</div>
        <div data-field="title" uglcw-options="tooltip: true">仓库</div>
        <div data-field="opts" uglcw-options="template: uglcw.util.template($('#snapshot-opt-tpl').html())">操作</div>
    </div>
</script>
<script type="text/x-uglcw-template" id="snapshot-opt-tpl">
    <button class="k-button k-info ghost" onclick="removeSnapshot(this, '#= data.id#')">删除</button>
    <button class="k-button k-info ghost" onclick="loadSnapshot('#= data.id#')">读取</button>
    <%--<button class="k-button k-info ghost" onclick="recovery(#= data.id#)">恢复</button>--%>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var modify = false;
    $(function () {
        uglcw.ui.init();
        $('.uglcw-layout-fixed').kendoTooltip({
            filter: 'li.k-item',
            position: 'right',
            content: function (e) {
                return '<span class="k-in" style="width: 100px;display: inline-flex;">' + $(e.target).find('span.k-in').html() + '</span>';
            }
        });
        uglcw.ui.get('#stkId').on('change', function () {
            uglcw.ui.get('#grid').bind([]);
        });

        uglcw.ui.get('#checkScope').on('change', function () {
            var checked = uglcw.ui.get('#checkScope').value();
            if (checked) {
                uglcw.ui.confirm("是否确定将剩余未的商品数据清零，并追加到当前表中！", function () {
                        appendSubList();
                    },
                    function () {
                        uglcw.ui.get('#checkScope').value(0);
                    }
                )
            } else {
                uglcw.ui.confirm("是否确定将蓝色字体商品\"清零操作\"撤销，并从当前表中移除！", function () {
                        var data = uglcw.ui.get('#grid').k().dataSource.data();
                        var dataArr = [];
                        $(data).each(function (i, row) {
                            if (row.appendData != 1) {
                                dataArr.push(row);
                            }
                        })
                        uglcw.ui.get('#grid').bind(dataArr || []);
                    },
                    function () {
                        uglcw.ui.get('#checkScope').value(1);
                    }
                )
            }
        });

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange' || action === 'add' || 'action' === 'remove') {
                saveSnapshot();
            }

        })
        load();
        uglcw.ui.loaded();
        displaySub();

    });

    function onRowChange(item) {
        var disQty = item._qty - item.stkQty;
        var hsNum = item.hsNum || 1;
        var hsQty = item.minQty / hsNum;
        disQty = disQty + hsQty;
        disQty = parseFloat(disQty);
        item.disQty = disQty.toFixed(10);
        item._disQty = disQty.toFixed(2);
        item.qty = item._qty;
        $("#btn_id_" + item.wareId).text("已盘");

        var checkQty = parseFloat(item._qty) + parseFloat(hsQty);
        item.checkQty = (Math.floor(checkQty * 100) / 100) || 0;
    }

    function onRowChange2(item) {
        var disQty = item._qty - item.stkQty;
        var hsNum = item.hsNum || 1;
        var hsQty = item.minQty / hsNum;
        disQty = disQty + hsQty;
        disQty = parseFloat(disQty);
        item.disQty = disQty.toFixed(10);
        item._disQty = disQty.toFixed(2);

        var checkQty = parseFloat(item._qty) + parseFloat(hsQty);
        item.checkQty = (Math.floor(checkQty * 100) / 100) || 0;
    }

    function _qtyEditor(container, options) {
        var grid = uglcw.ui.get('#grid').k();
        var row = $(container).closest('tr');
        var model = options.model, input = $('<input />');
        input.appendTo(container);
        var widget = new uglcw.ui.Numeric(input);
        widget.init({
            step: false,
            value: model._qty,
            decimals: 10,
            change: function () {
                model._qty = this.value();
                model.maxQtyFlag = 1;
                onRowChange(model);
                reDrawRow(grid, row);
            }
        });
    }

    function minQtyEditor(container, options) {
        var grid = uglcw.ui.get('#grid').k();
        var row = $(container).closest('tr');
        var model = options.model, input = $('<input />');
        input.appendTo(container);
        var widget = new uglcw.ui.Numeric(input);
        widget.init({
            step: false,
            value: model.minQty,
            decimals: 10,
            change: function () {
                model.minQty = this.value();
                model.minQtyFlag = 1;
                onRowChange(model);
                reDrawRow(grid, row);
            }
        });
    }

    function confirmBtn(el) {
        var grid = uglcw.ui.get('#grid').k();
        var row = uglcw.ui.get("#grid").k().dataItem($(el).closest("tr"));
        var maxQtyFlag = row.get("maxQtyFlag");
        row.maxQtyFlag = 1;
        row.minQtyFlag = 1;
        var wareId = row.get("wareId");
        var _disQty = row.get("_disQty");
        if (_disQty != 0) {
            return;
        }
        if (maxQtyFlag == 1) {
            row.maxQtyFlag = 0;
            row.minQtyFlag = 0;
            //$("#btn_id_" + wareId).text("未盘");
        } else {

            row.maxQtyFlag = 1;
            row.minQtyFlag = 1;
            //$("#btn_id_" + wareId).text("已盘");
        }
        //resetData();

        reDrawRow(grid, $(el).closest("tr"));
    }

    function fiterData(t) {
        typeId = t;
        var filters = new Array();
        filters.push({
            field: 'waretypePath',
            operator: 'contains',
            value: typeId || ''
        });

        if ($("#showModifyChk").is(":checked") == true) {

            filters.push({
                logic: "or", filters: [{
                    field: 'maxQtyFlag',
                    operator: 'eq',
                    value: 1
                }, {
                    field: 'minQtyFlag',
                    operator: 'eq',
                    value: 1
                }]
            });
        }
        if ($("#showUnModifyChk").is(":checked") == true) {
            filters.push({
                field: 'maxQtyFlag',
                operator: 'eq',
                value: 0
            });
            filters.push({
                field: 'minQtyFlag',
                operator: 'eq',
                value: 0
            });
        }
        uglcw.ui.get('#grid').k().dataSource.filter(filters);
        resetData();
    }

    function selectEmployee() {
        <tag:dept-employee-selector callback="onEmployeeSelect"/>
    }

    function onEmployeeSelect(result) {
        if (result && result.length > 0) {
            var employee = result[0];
            uglcw.ui.bind('body', {
                staff: employee.memberNm,
                empId: employee.memberId
            })
        }
    }

    var typeId = "";

    function onWareTypeSelect(typeId) {
        if (typeId == 0) {
            typeId = "";
        } else {
            typeId = '-' + typeId + '-';
        }
        // uglcw.ui.get('#grid').k().dataSource.filter({
        //     field: 'waretypePath',
        //     operator: 'contains',
        //     value: typeId || ''
        // })
        fiterData(typeId);
    }

    function showProductSelector() {
        if (!uglcw.ui.get('#stkId').value()) {
            return uglcw.ui.error('请选择仓库');
        }
        showWareType(0);
        <tag:product-out-selector-script selection="#grid"  callback="onProductSelect"/>
    }


    function onProductQuery(params) {
        params.stkId = uglcw.ui.get('#stkId').value();
        return params;
    }

    function onProductSelect(products) {
        var data = uglcw.ui.get('#grid').bind();
        modify = true;
        var dataToAdd = [];
        if (products && products.length > 0) {
            $.map(products, function (p) {
                if (p.stkQty == null || p.stkQty == "") {
                    p.stkQty = 0;
                }
                var stkQty = p.stkQty;
                if (Math.abs(stkQty) < 0.01) {
                    stkQty = 0.00;
                } else {
                    stkQty = Math.floor(stkQty * 100) / 100;
                }

                if (p.minSumQty == null || p.minSumQty == "") {
                    p.minSumQty = 0;
                }
                p.minStkQty = p.minSumQty;
                var maxQty = parseInt(p.minSumQty / p.hsNum);
                p.qty = maxQty;
                p._qty = maxQty;
                var minQty = p.minSumQty % p.hsNum;

                p.minQty = (Math.floor(minQty * 100000) / 100000) || 0;
                p._sum_Qty = maxQty + "" + p.wareDw + "" + (Math.floor(minQty * 100000) / 100000) + "" + p.minUnit;
                p._stkQty = stkQty;
                p.unitName = p.wareDw;
                onRowChange2(p);

                p.maxQtyFlag = p.maxQtyFlag || 0;
                p.minQtyFlag = p.minQtyFlag || 0;
                var hit = false;
                $(data).each(function (j, row) {
                    if (row.wareId == p.wareId) {
                        hit = true;
                        return false;
                    }
                })
                if (!hit) {
                    dataToAdd.push(p);
                    //uglcw.ui.get('#grid').addRow(p);
                }
            })
        }
        if (dataToAdd.length) {
            data = data.concat(dataToAdd)
            uglcw.ui.get('#grid').bind(data);
        }
        onWareTypeSelect(0);
    }


    function toDownloadDataExcel() {
        var list = uglcw.ui.get('#grid').bind();
        $.map(list, function (item) {
            item.produceDate = item.productDate instanceof Date ? uglcw.util.toString(item.productDate, 'yyyy-MM-dd') : item.productDate;
        });
        uglcw.ui.get('#wareStr').value(JSON.stringify(list));
        $('#export').submit();
    }

    function drageSaveStk() {
        onWareTypeSelect(0);
        showWareType(0);
        var data = uglcw.ui.bind('.query');
        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 1) {
            return uglcw.ui.error('请选择商品');
        }

        var msg = '是否确定暂存';
        var bool = false;
        $.map(list, function (item) {
            item.produceDate = item.productDate instanceof Date ? uglcw.util.toString(item.productDate, 'yyyy-MM-dd') : item.productDate;
            if (item.price == "" || item.price <= 0) {
                bool = true;
            }
        });

        // if(bool){
        //     msg = msg+",您有单位成本小于等于0的商品，建议取消并重新修改！"
        // }

        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择仓库');
        }
        data.wareStr = JSON.stringify(list);
        uglcw.ui.confirm(msg, function () {
            $.ajax({
                url: '${base}manager/drageStkCheck',
                type: 'post',
                data: data,
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.get('#billId').value(response.id);
                        uglcw.ui.success(response.msg);
                        uglcw.ui.get('#grid').commit();
                        $("#saveaudit").hide();
                        $("#btndraftaudit").show();
                        modify = false;
                    } else {
                        uglcw.ui.error(response.msg);
                    }
                }
            })


        })
    }

    function submitStk() {
        onWareTypeSelect(0);
        showWareType(0);
        var data = uglcw.ui.bind('.query');
        if (data.billId > 0) {
            return uglcw.ui.warning('盘点单不能修改');
        }
        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 0) {
            return uglcw.ui.error('请选择商品');
        }
        var bool = false;
        $.map(list, function (item) {
            item.produceDate = item.productDate instanceof Date ? uglcw.util.toString(item.productDate, 'yyyy-MM-dd') : item.productDate;
            if (item.appendData == 1) {
                bool = true;
            }
        });
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择仓库');
        }
        data.wareStr = JSON.stringify(list);
        uglcw.ui.confirm('保存并审批后将不能修改，是否确定保存并审批', function () {

            if ($("#checkScope").is(":checked") == true) {
                if (bool == false) {
                    uglcw.ui.warning('您选择剩余库存清零，剩余清零的数据将追加到当前数据行后面，请确认！');
                    appendSubList();
                } else {
                    uglcw.ui.confirm("您选择了蓝色字体商品库存清零操作，请慎重！", function () {
                            $.ajax({
                                url: '${base}manager/addStkCheck',
                                type: 'post',
                                data: data,
                                success: function (response) {
                                    if (response.state) {
                                        uglcw.ui.success(response.msg);
                                        setTimeout(function () {
                                            uglcw.ui.replaceCurrentTab('盘点详情', '${base}manager/showStkcheck?billId=' + response.id);
                                        }, 1000)

                                    } else {
                                        uglcw.ui.error(response.msg);
                                    }
                                }
                            })
                        }
                    )
                }
            } else {
                $.ajax({
                    url: '${base}manager/addStkCheck',
                    type: 'post',
                    data: data,
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success(response.msg);
                            setTimeout(function () {
                                uglcw.ui.replaceCurrentTab('盘点详情', '${base}manager/showStkcheck?billId=' + response.id);
                            }, 1000)

                        } else {
                            uglcw.ui.error(response.msg);
                        }
                    }
                })
            }


        })
    }

    function audit() {
        onWareTypeSelect(0);
        showWareType(0);
        var billId = $("#billId").val();
        if (modify) {
            uglcw.ui.error("清算数据已修改，请先暂存");
            return;
        }
        var msg = '确定审核？';
        var bool = false;
        var list = uglcw.ui.get('#grid').bind();
        $.map(list, function (item) {
            if (item.appendData == 1) {
                bool = true;
            }
        });
        uglcw.ui.confirm(msg, function () {
            if ($("#checkScope").is(":checked") == true) {
                if (bool == false) {
                    alert('您选择剩余库存清清零，剩余清零的数据将追加到当前数据行后面，请确认！');
                    appendSubList();
                } else {
                    uglcw.ui.confirm("您选择了蓝色字体商品库存清零操作，请慎重！", function () {
                            uglcw.ui.loading();
                            $.ajax({
                                url: '${base}manager/auditCheck',
                                type: 'post',
                                dataType: 'json',
                                data: {billId: billId},
                                success: function (response) {
                                    uglcw.ui.loaded();
                                    if (response.state) {
                                        uglcw.ui.success(response.msg);
                                        setTimeout(function () {
                                            uglcw.ui.replaceCurrentTab('库存盘点详情', '${base}manager/showStkcheck?billId=' + billId);
                                        }, 1000)
                                    } else {
                                        uglcw.ui.error(response.msg);
                                    }
                                },
                                error: function () {
                                    uglcw.ui.loaded();
                                }
                            })
                        }
                    )
                }
            } else {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/auditCheck',
                    type: 'post',
                    dataType: 'json',
                    data: {billId: billId},
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.state) {
                            uglcw.ui.success(response.msg);
                            setTimeout(function () {
                                uglcw.ui.replaceCurrentTab('库存盘点详情', '${base}manager/showStkcheck?billId=' + billId);
                            }, 1000)
                        } else {
                            uglcw.ui.error(response.msg);
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                    }
                })
            }

        })
    }


    function toUpWare() {
        uglcw.ui.Modal.showUpload({
            url: '${base}manager/toUpCheckData',
            field: 'upFile',
            error: function () {
                console.log('error', arguments)
            },
            complete: function () {
                console.log('complete', arguments);
            },
            success: function (e) {
                if (!e.response.state) {
                    uglcw.ui.error(e.response);
                } else {
                    uglcw.ui.get('#grid').bind(e.response.list);
                    uglcw.ui.success('导入成功');
                }
            }
        })
    }

    var wareList = [];
    var wareIds = "";

    function load() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            uglcw.ui.bind('.query', {
                checkTimeStr: uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm')
            });
        }
    }

    function toDownloadCheckCustomTemplate() {
        uglcw.ui.confirm('是否确定下载自定义模版?', function () {
            window.location.href = "manager/downloadCheckCustomTemplate";
        })
    }

    function toUpCustomWare() {
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择仓库');
        }
        wareIds = "";
        uglcw.ui.Modal.showUpload({
            url: '${base}manager/toUpCheckCustomData?upStkId=' + stkId,
            field: 'upFile',
            error: function () {
                console.log('error', arguments)
            },
            complete: function () {
                console.log('complete', arguments);
            },
            success: function (e) {
                if (!e.response.state) {
                    uglcw.ui.error(e.response);
                } else {
                    var datas = e.response.newScsList;
                    if (datas != "") {
                        if (window.confirm("导入商品信息中有待新增的商品，请去确认")) {
                            showUpdateWares(datas);
                        }
                    }
                    e.response.list = $.map(e.response.list, function (item) {
                        var stkQty = Math.floor(item.stkQty * 100) / 100;
                        item._stkQty = stkQty;
                        item._qty = parseFloat(item.qty);
                        item._disQty = parseFloat(item.disQty).toFixed(2);
                        item.productDate = item.produceDate;
                        if (item.minStkQty == null || item.minStkQty == "") {
                            item.minSumQty = 0;
                        }
                        var maxQty = parseInt(item.minStkQty / item.hsNum);
                        var minQty = item.minStkQty % item.hsNum;
                        item._sum_Qty = maxQty + "" + item.unitName + "" + (Math.floor(minQty * 100000) / 100000) + "" + item.minUnit;
                        onRowChange2(item);
                        return item;
                    });
                    uglcw.ui.get('#grid').value(e.response.list);
                    uglcw.ui.success('导入成功');
                }
            }
        })
    }

    var win = null

    function showUpdateWares(datas) {
        var data = {};
        data.wareStr = JSON.stringify(datas);
        window.localStorage.removeItem("new_ware_key_list");
        window.localStorage.setItem("new_ware_key_list", JSON.stringify(data));
        win = uglcw.ui.Modal.open({
            title: '请确认当前待新增商品',
            id: "newWareFrame",
            url: "<%=basePath%>/manager/checkNewWareList",
            data: data,
            area: '600px',
            full: true,
            closable: true,
            btns: [],
            success: function (container) {
                // uglcw.ui.toast('open success');
            },
            yes: function (container) {
                // refreshCheckWare(ids);

                // uglcw.ui.Modal.close(win);
            },
            cancel: function () {
                uglcw.ui.toast('cancel');
            }
        })
    }

    function appendNewWareData() {
        uglcw.ui.Modal.close(win);
        var datas = window.localStorage.getItem("new_ware_key_datas");
        var json = JSON.parse(datas);

        $.map(json, function (item) {
            var stkQty = Math.floor(item.stkQty * 100) / 100;
            item._stkQty = stkQty;
            item._qty = parseFloat(item.qty);
            item._disQty = parseFloat(item.disQty).toFixed(2);
            item.productDate = item.produceDate;
            if (item.minStkQty == null || item.minStkQty == "") {
                item.minSumQty = 0;
            }
            var maxQty = parseInt(item.minStkQty / item.hsNum);
            var minQty = item.minSumQty % item.hsNum;
            item._sum_Qty = maxQty + "" + item.unitName + "" + (Math.floor(minQty * 100000) / 100000) + "" + item.minUnit;
            onRowChange2(item);
            uglcw.ui.get('#grid').addRow(item);
            return item;
        });
        uglcw.ui.Modal.close(win);
    }


    function showWareType(v) {
        if (v == 1) {
            $("#wareTypeDiv").show();
            setTimeout(function () {
                uglcw.ui.get('#grid').resize();
            }, 500)
        } else {
            $("#wareTypeDiv").hide();
        }
    }

    function getNewWare(wareId, wareDatas) {
        var newWare = "";
        for (var i = 0; i < wareDatas.length; i++) {
            var data = wareDatas[i];
            if (wareId == data.wareId) {
                newWare = data;
                break;
            }
        }
        return newWare;
    }

    function formatterNumber(v, f) {
        if (v != null && (f == null || f == undefined)) {
            return parseFloat(Number(v).toFixed(10));
        } else if (v != null && f != null) {
            return parseFloat(Number(v).toFixed(10));
        } else {
            return 0;
        }
    }

    function displaySub() {
        var path = "${base}/manager/queryCheckSub";
        var billId = $("#billId").val();
        if (billId == "" || billId == 0) {
            return;
        }
        $.ajax({
            url: path,
            type: "POST",
            data: {"billId": billId},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    json.list = $.map(json.list, function (item) {
                        var stkQty = Math.floor(item.stkQty * 100) / 100;
                        item._stkQty = stkQty;
                        item._qty = parseFloat(item.qty);
                        item._disQty = parseFloat(item.disQty).toFixed(2);
                        item.productDate = item.produceDate;
                        if (item.minStkQty == null || item.minStkQty == "") {
                            item.minStkQty = 0;
                        }
                        var maxQty = parseInt(item.minStkQty / item.hsNum);
                        var minQty = item.minStkQty % item.hsNum;
                        item._sum_Qty = maxQty + "" + item.unitName + "" + (Math.floor(minQty * 100000) / 100000) + "" + item.minUnit;

                        var hsQty = item.minQty / item.hsNum;
                        var checkQty = parseFloat(item._qty) + parseFloat(hsQty);
                        item.checkQty = (Math.floor(checkQty * 100) / 100) || 0;
                        return item;
                    });
                    //uglcw.ui.get('#grid').value(data);
                    uglcw.ui.get('#grid').bind(json.list || []);
                    resetData();
                }
            }
        });
    }

    function appendSubList() {
        var path = "${base}/manager/appendSubList";
        var data = uglcw.ui.bind('.query');
        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 1) {
            uglcw.ui.get('#checkScope').value(0)
            return uglcw.ui.error('请选择商品');
        }
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择仓库');
        }
        data.wareStr = JSON.stringify(list);
        $.ajax({
            url: path,
            type: "POST",
            data: data,
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    json.rows = $.map(json.rows, function (item) {
                        var stkQty = Math.floor(item.stkQty * 100) / 100;
                        item._stkQty = stkQty;
                        item._qty = parseFloat(item.qty);
                        item._disQty = parseFloat(item.disQty).toFixed(2);
                        item.productDate = item.produceDate;

                        if (item.minSumQty == null || item.minSumQty == "") {
                            item.minSumQty = 0;
                        }
                        var maxQty = parseInt(item.minSumQty / item.hsNum);
                        var minQty = item.minSumQty % item.hsNum;
                        item._sum_Qty = maxQty + "" + item.unitName + "" + (Math.floor(minQty * 100000) / 100000) + "" + item.minUnit;

                        return item;
                    });
                    uglcw.ui.get('#grid').bind(json.rows || []);
                    modify = true;
                    resetData();
                }
            }
        });
    }

    function resetData() {
        var data = uglcw.ui.get('#grid').k().dataSource.data();
        var clazz = 'row-color-blue';
        $(data).each(function (i, row) {
            if (row.maxQtyFlag == 1) {
                $('#grid .k-grid-content tr[data-uid=' + row.uid + '] td.maxQtyFlag').addClass('color_class').prepend("<span class='k-dirty2'></span>");
            }
            if (row.minQtyFlag == 1) {
                $('#grid .k-grid-content tr[data-uid=' + row.uid + '] td.minQtyFlag').addClass('color_class').prepend("<span class='k-dirty2'></span>");
            }

            if (row.appendData == 1) {
                $('#grid .k-grid-content tr[data-uid=' + row.uid + ']').addClass(clazz);
            }
        })
    }

    /**
     * 加载库存不为0商品
     */
    function loadNotZeroData(k) {

        var path = "${base}/manager/loadNotZeroWareDataList";
        var billId = $("#billId").val();
        if (billId != "" && billId != 0) {
            return;
        }
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择仓库');
        }
        $.ajax({
            url: path,
            type: "POST",
            data: {"chooseFlag": k, "stkId": stkId},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    uglcw.ui.get('#grid').bind([]);
                    json.rows = $.map(json.rows, function (item) {
                        var stkQty = parseFloat(item.stkQty);
                        if (Math.abs(stkQty) < 0.01) {
                            stkQty = 0.00;
                        } else {
                            stkQty = Math.floor(stkQty * 100) / 100;
                        }
                        item.qty = stkQty;
                        item._qty = stkQty;
                        item._stkQty = stkQty;

                        if (item.minSumQty == null || item.minSumQty == "") {
                            item.minSumQty = 0;
                        }
                        item.minStkQty = item.minSumQty;
                        var maxQty = parseInt(item.minSumQty / item.hsNum);
                        // p.qty = stkQty;
                        // p._qty = stkQty;
                        item.qty = maxQty;
                        item._qty = maxQty;
                        var minQty = item.minSumQty % item.hsNum;

                        item.minQty = (Math.floor(minQty * 100000) / 100000) || 0;
                        item._sum_Qty = maxQty + "" + item.wareDw + "" + (Math.floor(minQty * 100000) / 100000) + "" + item.minUnit;
                        item.unitName = item.wareDw;
                        onRowChange2(item);

                        item.price = item.inPrice || 0;
                        item.zmPrice = item.inPrice || 0;
                        item.priceFlag = item.priceFlag || 0;
                        item.maxQtyFlag = item.maxQtyFlag || 0;
                        item.minQtyFlag = item.minQtyFlag || 0;
                        var maxAmt = parseFloat(item.price) * parseFloat(item._qty);
                        item.maxAmt = parseFloat(maxAmt).toFixed(2);
                        item.productDate = item.produceDate;
                        return item;
                    });
                    uglcw.ui.get('#grid').bind(json.rows || []);
                    uglcw.ui.info("数据加载成功");
                    resetData();
                }
            }
        });
    }

    function reDrawRow(grid, row) {
        var dataItem = grid.dataItem(row);

        var rowChildren = $(row).children('td[role="gridcell"]');

        for (var i = 0; i < grid.columns.length; i++) {

            var column = grid.columns[i];
            var template = column.template;
            var cell = rowChildren.eq(i);

            if (template !== undefined) {
                var kendoTemplate = kendo.template(template);

                // Render using template
                cell.html(kendoTemplate(dataItem));
            } else {
                var fieldValue = dataItem[column.field];

                var format = column.format;
                var values = column.values;

                if (values !== undefined && values != null) {
                    // use the text value mappings (for enums)
                    for (var j = 0; j < values.length; j++) {
                        var value = values[j];
                        if (value.value == fieldValue) {
                            cell.html(value.text);
                            break;
                        }
                    }
                } else if (format !== undefined) {
                    // use the format
                    cell.html(kendo.format(format, fieldValue));
                } else {
                    // Just dump the plain old value
                    cell.html(fieldValue);
                }
            }
        }
        row.find('.row-number').text($(row).index() + 1);
        saveSnapshot();
    }

    function showSnapshot() {
        uglcw.ui.Modal.open({
            title: '快照列表',
            area: ['600px', '350px'],
            content: $('#snapshot-tpl').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            btns: false
        })
    }

    var saveSnapshotDelay;

    function saveSnapshot() {
        window.clearTimeout(saveSnapshotDelay);
        saveSnapshotDelay = setTimeout(function () {
            var billId = uglcw.ui.get('#billId').value();
            var query = uglcw.ui.bind('.uglcw-query');
            var data = uglcw.ui.get('#grid').value();
            billId = (billId && billId != '0') ? billId : undefined;
            $.ajax({
                url: CTX + '/manager/common/bill/snapshot',
                contentType: 'application/json',
                type: 'POST',
                data: JSON.stringify({
                    title: uglcw.ui.get('#stkId').k().text(),
                    id: uglcw.ui.get('#snapshotId').value(),
                    billType: 'inventory-check',
                    data: {
                        query: query,
                        data: data
                    },
                    billId: billId
                }),
                success: function (response) {
                    if (response.success) {
                        $('.snapshot-badge-dot').show();
                        uglcw.ui.get('#snapshotId').value(response.data)
                    }
                }
            })
        }, 1500);
    }

    function loadSnapshot(id) {
        $.ajax({
            url: CTX + 'manager/common/bill/snapshot/' + id,
            type: 'get',
            success: function (response) {
                if (response.success) {
                    var data = JSON.parse(response.data.data);
                    uglcw.ui.get('#snapshotId').value(response.data.id);
                    uglcw.ui.bind('.uglcw-query', data.query);
                    uglcw.ui.get('#grid').value(data.data);
                    uglcw.ui.success('快照加载成功');
                    uglcw.ui.Modal.close();
                } else {
                    uglcw.ui.error(response.message || '快照加载失败');
                }
            }
        })
    }

    function removeSnapshot(el, id) {
        var remove = function (e, id) {
            $.ajax({
                url: CTX + '/manager/common/bill/snapshot/' + id,
                type: 'delete',
                success: function (response) {
                    if (response.success) {
                        if (e) {
                            uglcw.ui.get($(e).closest('.uglcw-grid')).reload();
                            uglcw.ui.success('快照删除成功');
                            var snapshotId = uglcw.ui.get('#snapshotId').value();
                            if (snapshotId === id) {
                                uglcw.ui.get('#snapshotId').value('');
                            }
                        }
                    } else {
                        uglcw.ui.error(response.message || '快照删除失败');
                    }
                }
            })
        }
        if (el) {
            uglcw.ui.confirm('确定删除快照吗？', function () {
                remove(el, id)
            })
        } else {
            remove(null, id);
        }

    }

    function showPc() {
        uglcw.ui.openTab('库存按批次盘点', '${base}manager/pcstkcheckpctype');
    }

</script>
</body>
</html>
