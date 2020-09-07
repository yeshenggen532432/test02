<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>库存初始化</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-grid-norecords-template {
            position: absolute !important;
        }

        .badge-dot {
            display: none;
            position: absolute;
            -webkit-transform: translateX(-50%);
            transform: translateX(-50%);
            -webkit-transform-origin: 0 center;
            transform-origin: 0 center;
            top: 1px;
            right: -2px;
            height: 8px;
            width: 8px;
            border-radius: 100%;
            background: #ed4014;
            z-index: 10;
            box-shadow: 0 0 0 1px #fff;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <form id="export" action="${base}manager/downloadInitDataToExcel" method="post" style="display: none;">
        <textarea uglcw-role="textbox" name="wareStr" id="wareStr"></textarea>
    </form>
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px;" uglcw-options="collapsed:true">
            <div class="layui-card">
                <div class="layui-card-body full" uglcw-role="resizable" uglcw-options="responsive:[35]">
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
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <div class="form-horizontal query">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="wtype" id="wtype" value="${wtype}"/>
                        <input id="billId" type="hidden" uglcw-role="textbox" uglcw-model="id" value="${billId}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="stkId" value="${stkId}"/>
                        <div class="form-group" style="margin-bottom: 5px!important;">
                            <div class="col-xs-4" style="width: 250px">
                                <input uglcw-model="checkTimeStr" uglcw-role="datetimepicker"
                                       uglcw-options="format: 'yyyy-MM-dd HH:mm'"
                                       value="${checkTime}" placeholder="初始化时间">
                            </div>
                            <div class="col-xs-4" style="width: 250px">
                                <select uglcw-model="stkId" id="stkId" uglcw-role="combobox"
                                        uglcw-options="
                                            index: 0,
                                            value: '${stkId}',
                                            url: '${base}manager/queryBaseStorage',
                                            dataTextField: 'stkName',
                                            dataValueField: 'id'
                                        "
                                        placeholder="初始化仓库"></select>
                            </div>
                            <div class="col-xs-4 " style="width: 250px">
                                <input value="${staff}" placeholder="选择人员" uglcw-model="staff,empId"
                                       uglcw-role="gridselector"
                                       uglcw-options="click: function(){
                                         selectEmployee();
                                        }"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid-advanced"
                         uglcw-options="
                            autoAppendRow: false,
                            responsive: ['.header', 40],
							editable: true,
							speedy:{
							  className: 'uglcw-cell-speedy'
							},
							toolbar: uglcw.util.template($('#toolbar').html()),
							id:'id',
                    ">
                        <div data-field="wareCode" uglcw-options="width:120,tooltip: true,hidden:true">商品编码</div>
                        <div data-field="wareNm" uglcw-options="width:120, tooltip: true">商品名称</div>
                        <div data-field="wareGg" uglcw-options="width:90">规格</div>
                        <div data-field="unitName" uglcw-options="width:70">大单位</div>
                        <div data-field="qty"
                             uglcw-options="width:120, format: '{0:n2}',
                                attributes:{class: 'uglcw-cell-speedy k-dirty-cell'},
                                editable: true,
                                schema:{type: 'number', validation:{required: true}}">
                            初始大单位数量
                        </div>
                        <div data-field="inPrice"
                             uglcw-options="width:100,  editable: true,
                             attributes:{class: 'uglcw-cell-speedy k-dirty-cell'},
                              schema:{type: 'number', validation:{required: true}}">大单位价格
                        </div>
                        <div data-field="minUnit" uglcw-options="width:70">小单位</div>
                        <div data-field="minQty"
                             uglcw-options="width:120, format: '{0:n2}',
                               attributes:{class: 'uglcw-cell-speedy k-dirty-cell'},
                               editable: true, schema:{type: 'number', validation:{required: true}}">
                            初始小单位数量
                        </div>
                        <div data-field="sunitPrice"
                             uglcw-options="width:100,  editable: true,
                             attributes:{class: 'uglcw-cell-speedy k-dirty-cell'},
                              schema:{type: 'number', validation:{required: true}}">小单位价格
                        </div>
                        <div data-field="disQty"
                             uglcw-options="width:90, format:'{0:n2}'">
                            初始数量
                        </div>
                        <div data-field="productDate" uglcw-options="width: 120, format: 'yyyy-MM-dd',
                             schema:{ type: 'date'},
                             editor: function(container, options){
                                var model = options.model;
                                var input = $('<input  data-bind=\'value:productDate\' />');
                                input.appendTo(container);
                                var picker = new uglcw.ui.DatePicker(input);
                                picker.init({
                                    editable: true,
                                    format: 'yyyy-MM-dd',
                                    value: model.produceDate ? model.productDate : ''
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
<ul id="grid-menu"></ul>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:dialogSelectWare();">
        <span class="k-icon k-i-search"></span>选择商品
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:drageSaveStk();" id="savedrage">
        <span class="k-icon k-i-save"></span>暂存
        <sup class="badge-dot"></sup>
    </a>
    <c:if test="${billId eq 0}">
        <a role="button" class="k-button k-button-icontext"
           href="javascript:submitStk();" id="saveaudit">
            <span class="k-icon k-i-check"></span>保存并审批
        </a>
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
    <span style="color: red;">选中行右键复制插入</span>
</script>
<tag:product-check-selector-template query="onProductQuery"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#stkId').on('change', function () {
            uglcw.ui.get('#grid').bind([]);
        });

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
                if (e.field === 'minQty' || e.field === 'qty') {
                    var minQty = item.minQty || 0;
                    var disQty = item.qty;
                    var hsNum = item.hsNum || 1;
                    var hsQty = item.minQty / hsNum;
                    disQty = disQty + hsQty;
                    item.set('disQty', disQty);
                    item.set('minQty', minQty);
                }
            }
            $('#grid').data('_change', true);
            $('.badge-dot').show();
        });
        load();
        initGridContextMenu();
        uglcw.ui.loaded();
    });

    function onTabLeave(promise) {
        if ($('#grid').data('_change')) {
            uglcw.ui.confirm('当前修改未暂存，是否暂存？', function () {
                drageSaveStk(promise)
            }, function () {
                promise.resolve();
            })
        }else{
            promise.resolve();
        }
    }

    function initGridContextMenu() {
        $('#grid-menu').kendoContextMenu({
            filter: ".k-grid-content td",
            target: '#grid',
            hideOnClick: true,
            dataSource: [
                {
                    text: '复制插入',
                    attr: {
                        action: 'insert'
                    }
                },
                {
                    text: '删除',
                    attr: {
                        action: 'remove'
                    }
                }
            ],
            select: function (e) {
                var grid = uglcw.ui.get('#grid');
                var target = $(e.target),
                    row = target.closest('tr');
                var rowData = grid.k().dataItem(row).toJSON();
                var action = $(e.item).attr("action");
                switch (action) {
                    case 'insert':
                        var rowIndex = $(row).index();
                        // grid.addRow(null, {index: rowIndex + 1, move: false});
                        // if ($.isFunction(grid.options.onInsert)) {
                        //     grid.options.onInsert.call(grid, rowIndex + 1);
                        // }


                        uglcw.ui.get('#grid').k().dataSource.insert(rowIndex + 1, rowData);

                        //grid.insert(rowIndex+1, row);
                        // if ($.isFunction(grid.options.onInsert)) {
                        //     grid.options.onInsert.call(grid, rowIndex + 1);
                        // }
                        // dataSource.insert(rowIndex+1, row);

                        break;
                    case 'remove':
                        // uglcw.ui.confirm('确定删除[' + ($(row).index() + 1) + ']行数据吗?', function () {
                        var rowData = grid.k().dataItem($(row));
                        grid.k().dataSource.remove(rowData);
                        // });
                        break;
                    default:
                        break;
                }
            }
        })
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

    function onWareTypeSelect(typeId) {
        if (typeId == 0) {
            typeId = "";
        } else {
            typeId = '-' + typeId + '-';
        }

        fiterData(typeId);
    }

    function fiterData(t) {
        typeId = t;
        var filters = new Array();
        filters.push({
            field: 'waretypePath',
            operator: 'contains',
            value: typeId || ''
        });
        uglcw.ui.get('#grid').k().dataSource.filter(filters);
        //resetData();
    }

    // function onWareTypeSelect(typeId) {
    //     uglcw.ui.get('#grid').k().dataSource.filter({
    //         field: 'waretypePath',
    //         operator: 'contains',
    //         value: typeId || ''
    //     })
    // }

    function dialogSelectWare() {
        <%--<tag:product-selector2 selection="#grid" callback="onProductSelect" query="onProductQuery" />--%>
        showWareType(0);
        <tag:product-out-selector-script selection="#grid" callback="onProductSelect"/>
    }

    function onProductQuery(params) {
        params.stkId = uglcw.ui.get('#stkId').value();
        return params;
    }

    function onProductSelect(products) {
        var data = uglcw.ui.get('#grid').bind();
        if (products && products.length > 0) {
           var newData = $.map(products, function (p) {
                p.qty = 0;
                p.unitName = p.wareDw;
                p.disQty = 0;
                p.produceDate = p.productDate;
                p.minQty = 0;
                p.inPrice = p.inPrice2;
                var hit = false;
                $(data).each(function (j, row) {
                    if (row.wareId == p.wareId) {
                        hit = true;
                        return false;
                    }
                })
                if (!hit) {
                    return p;
                }
            })
            uglcw.ui.get('#grid').k().dataSource.data(data.concat(newData));
        }

    }

    function showWareType(v) {
        if (v == 1) {
            // $("#wareTypeDiv").show();
            setTimeout(function () {
                uglcw.ui.get('#grid').resize();
            }, 500)
        } else {
            //   $("#wareTypeDiv").hide();
        }
        onWareTypeSelect(0);
    }

    function drageSaveStk(promise) {
        showWareType(0);
        var data = uglcw.ui.bind('.query');
        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 1) {
            return uglcw.ui.error('请选择商品');
        }
        $.map(list, function (item) {
            item.produceDate = item.productDate instanceof Date ? uglcw.util.toString(item.productDate, 'yyyy-MM-dd') : item.productDate;
            item.price = item.inPrice;
        });
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择仓库');
        }
        data.wareStr = JSON.stringify(list);

        var saveCheck = function(){
            $.ajax({
                url: '${base}manager/dragStkCheckInit',
                type: 'post',
                data: data,
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.get('#billId').value(response.id);
                        uglcw.ui.success(response.msg);
                        uglcw.ui.get('#grid').commit();
                        $("#saveaudit").hide();
                        $('#grid').removeData('_change');
                        $('.badge-dot').hide();
                        uglcw.io.emit('onInventoryCheckSaved')
                    } else {
                        uglcw.ui.error(response.msg);
                    }
                }
            })
        }
        if(!promise){
            uglcw.ui.confirm('是否确定暂存？', saveCheck)
        }else{
            saveCheck()
        }

    }

    function submitStk() {
        showWareType(0);
        var data = uglcw.ui.bind('.query');
        if (data.billId > 0) {
            return uglcw.ui.warning('已提交不能修改');
        }
        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 0) {
            return uglcw.ui.error('请选择商品');
        }
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择仓库');
        }
        $.map(list, function (item) {
            item.produceDate = item.productDate instanceof Date ? uglcw.util.toString(item.productDate, 'yyyy-MM-dd') : item.productDate;
            item.price = item.inPrice;
        });
        data.wareStr = JSON.stringify(list);
        uglcw.ui.confirm('保存后将不能修改，是否确定保存', function () {
            $.ajax({
                url: '${base}manager/addStkCheckInit',
                type: 'post',
                data: data,
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.success(response.msg);
                        setTimeout(function () {
                            uglcw.ui.replaceCurrentTab('库存初始化详情', '${base}manager/showStkcheckInit?billId=' + response.id);
                        }, 1000)

                    } else {
                        uglcw.ui.error(response.msg);
                    }
                }
            })
        })
    }

    function load() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            uglcw.ui.bind('.query', {
                checkTimeStr: uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm')
            });
        } else {
            $.ajax({
                url: '${base}manager/queryCheckSub',
                type: 'post',
                data: {
                    billId: billId
                },
                success: function (response) {
                    if (response.state) {
                        response.list = $.map(response.list, function (item) {
                            item.productDate = item.produceDate;
                            item.inPrice = item.price;
                            return item;
                        });

                        uglcw.ui.get('#grid').bind(response.list || []);

                        $('#grid').removeData('_change');
                    }
                }
            })
        }
    }


    function toUpCustomWare() {
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择仓库');
        }
        wareIds = "";
        uglcw.ui.Modal.showUpload({
            url: '${base}manager/toUpInitCustomData?upStkId=' + stkId,
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
                    var datas  = e.response.newScsList;
                    if (datas != "") {
                        if (window.confirm("导入商品信息中有待新增的商品，请去确认")) {
                            showUpdateWares(datas);
                        }
                    }
                    e.response.list = $.map(e.response.list, function (item) {
                        item.productDate = item.produceDate;
                        item.inPrice = item.price;
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
        var data ={};
        data.wareStr = JSON.stringify(datas);
        window.localStorage.removeItem("new_ware_key_list");
        window.localStorage.setItem("new_ware_key_list", JSON.stringify(data));
        win = uglcw.ui.Modal.open({
            title: '请确认当前待新增商品',
            id:"newWareFrame",
            url: "<%=basePath%>/manager/checkNewWareList",
            data:data,
            area: '600px',
            full: true,
            closable: false,
            btns: [],
            success: function (container) {
            },
            yes: function (container) {
            },
            cancel: function () {
                uglcw.ui.toast('cancel');
            }
        })
    }
    function appendNewWareData(){
        uglcw.ui.Modal.close(win);
        var datas=window.localStorage.getItem("new_ware_key_datas");
        var json = JSON.parse(datas);
        $.map(json, function (item) {
            item.productDate = item.produceDate;
            item.inPrice = item.price;
            uglcw.ui.get('#grid').addRow(item);
            return item;
        });
        uglcw.ui.Modal.close(win);
    }

    function toDownloadDataExcel() {
        var list = uglcw.ui.get('#grid').bind();
        $.map(list, function (item) {
            item.produceDate = item.productDate instanceof Date ? uglcw.util.toString(item.productDate, 'yyyy-MM-dd') : item.productDate;
        });
        uglcw.ui.get('#wareStr').value(JSON.stringify(list));
        $('#export').submit();
    }

    function toDownloadCheckCustomTemplate() {
        uglcw.ui.confirm('是否确定下载模版?', function () {
            window.location.href = "manager/downloadInitCustomTemplate";
        })
    }

</script>
</body>
</html>
