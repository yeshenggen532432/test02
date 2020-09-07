<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>虚拟库存</title>
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
        <div class="uglcw-layout-fixed" style="width: 150px;" uglcw-options="collapsed: true">
            <div class="layui-card" uglcw-role="resizable" uglcw-options="responsive:[35]">
                <ul uglcw-role="accordion">
                    <li>
                        <span>库存商品类</span>
                        <div uglcw-role="tree" id="tree1"
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
                                       onWareTypeSelect.call(this, e, 0);
                                   },
                                 dataBound: function(){
                                   var tree = this;
                                   clearTimeout($('#tree1').data('_timer'));
                                   $('#tree1').data('_timer', setTimeout(function(){
                                       tree.select($('#tree1 .k-item:eq(0)'));
                                       var nodes = tree.dataSource.data().toJSON();
                                       if(nodes && nodes.length > 0){
                                           uglcw.ui.bind('.uglcw-query', {
                                               isType: 0
                                              });
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
                                        onWareTypeSelect.call(this, e, 1);
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
                                    onWareTypeSelect.call(this, e, 2);
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
                                        onWareTypeSelect.call(this, e, 3);
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
                            <select uglcw-model="isType" uglcw-role="combobox" id="type" placeholder="资产类型"
                                    uglcw-options='value:"",change: function(){
                                     if(uglcw.ui.get("#type").value() == ""){
                                        uglcw.ui.get("#level2").k().text("");
                                        uglcw.ui.get("#level2").k().value("");
                                        uglcw.ui.get("#level2").k().dataSource.data([]);
                                        uglcw.ui.get("#level3").k().text("");
                                        uglcw.ui.get("#level3").k().value("");
                                        uglcw.ui.get("#level3").k().dataSource.data([]);
                                      }else{
                                        uglcw.ui.get("#level2").k().text("");
                                        uglcw.ui.get("#level2").k().value("");
                                        uglcw.ui.get("#level2").k().dataSource.read();
                                        uglcw.ui.get("#level3").k().text("");
                                        uglcw.ui.get("#level3").k().value("");
                                        uglcw.ui.get("#level3").k().dataSource.data([]);
                                        }
                                    }'
                            >
                                <option value="0">库存商品类</option>
                                <option value="1">原辅材料类</option>
                                <option value="2">低值易耗品类</option>
                                <option value="3">固定资产类</option>
                            </select>
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="level2" id="level2" placeholder="二级分类"
                                    uglcw-options="
                                    dataTextField: 'text',
                                    dataValueField: 'id',
                                    loadFilter: {
                                        data: function(response){
                                            return response[0].children||[]
                                        }
                                    },
                                    change: function(){
                                        uglcw.ui.get('#level3').k().dataSource.data([]);
                                        uglcw.ui.get('#level3').k().value('');
                                        uglcw.ui.get('#level3').k().dataSource.read();
                                    },
                                    data:function(){
                                        return {
                                            isType: uglcw.ui.get('#type').value(),
                                            id: 0
                                        }
                                    },
                                    url:'${base}manager/companyWaretypes'
                            ">

                            </select>
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="level3" id="level3" placeholder="三级分类"
                                    uglcw-options="
                                    dataTextField: 'text',
                                    dataValueField: 'id',
                                     loadFilter: {
                                        data: function(response){
                                            return response||[]
                                        }
                                    },
                                    data:function(){
                                        return {
                                            isType: uglcw.ui.get('#type').value(),
                                            id: uglcw.ui.get('#level2').value(),
                                        }
                                    },
                                    url:'${base}manager/companyWaretypes',
                            ">
                            </select>
                        </li>
                        <li >
                            <input type="hidden" id="scope" uglcw-model="scope" uglcw-role="textbox"
                                   value="1">
                            <input type="hidden" id="hbCk" uglcw-model="hbCk" uglcw-role="textbox"
                                   value="0">
                            <input uglcw-model="wareNm" id="wareNm" uglcw-role="textbox" placeholder="商品名称,商品条码,商品代码">
                        </li>
                        <li>
                            <tag:select2 id="brandId" name="brandId" headerKey="" headerValue=""
                                         value="${ware.brandId}" displayKey="id"
                                         displayValue="name" tableName="sys_brand" placeholder="品牌名称">
                            </tag:select2>
                        </li>
                        <li>
                            <select uglcw-role="combobox" id="stkId" uglcw-model="stkId" uglcw-options="
                                    dataTextField: 'stkName',
                                    dataValueField: 'id',
                                    url: '${base}manager/queryBaseStorage',
                                    placeholder: '仓库'
                                "></select>
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="flag"
                                    placeholder="范围"
                                    uglcw-options="value: ''"
                            >
                                <option value="0">未发货销售单据</option>
                                <option value="1">未生成销售的订单</option>
                            </select>
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
                    autoBind:false,
                    responsive:['.header',40],
                    rowNumber: true,
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    query: function(params){
                        params.waretype = params.level3 || params.level2
                        return params;
                    },
                    pageable:{
                        pageSize: 20
                    },
                    url: '${base}manager/queryStorageOccWarePage',
                    criteria: '.form-horizontal',
                    aggregate:[
                     {field: 'sumQty', aggregate: 'SUM'},
                     {field: 'sumAmt', aggregate: 'SUM'},
                     {field: 'avgPrice', aggregate: 'SUM'},
                     {field: 'minSumQty', aggregate: 'SUM'}
                    ],
                      dblclick: function(row){
                       // showItems(row);
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
                        <div data-field="stkName" uglcw-options="width:130, tooltip:true, footerTemplate: '合计:' ">仓库名称</div>
                        <div data-field="wareNm" uglcw-options="width:150, tooltip:true">商品名称</div>
                        <div data-field="wareGg" uglcw-options="width: 100">规格</div>
                        <div data-field="packBarCode" uglcw-options="width: 100, hidden: true">条码(大)</div>
                        <div data-field="beBarCode" uglcw-options="width: 100,hidden: true">条码(小)</div>
                        <div data-field="sumQty"
                             uglcw-options="width:100, format: '{0:n2}',titleAlign:'center',align:'right',template: uglcw.util.template($('#formatterNum').html()),footerTemplate: '#=uglcw.util.toString((data.sumQty||0),\'n2\')#'">
                            实际库存
                        </div>
                        <div data-field="unitName" uglcw-options="width: 100">单位(大)</div>
                        <div data-field="minSumQty"
                             uglcw-options="width:120, format: '{0:n6}',titleAlign:'center',align:'right',template: uglcw.util.template($('#formatterNum1').html()), footerTemplate:'#= uglcw.util.toString((data.minSumQty||0),\'n2\')#'">
                            实际库存(小)
                        </div>
                        <div data-field="_sum_Qty" uglcw-options="width:120,tooltip: true,titleAlign:'center',align:'right',
                                template: function(data){
                                    return formatQty(data);
                                }">实际大小数量
                        </div>
                        <div data-field="minUnitName" uglcw-options="width:90">单位(小)</div>
                        <div data-field="occQty"
                             uglcw-options="width:90, format: '{0:n5}',titleAlign:'center',align:'right'">
                            占用库存
                        </div>
                        <div data-field="minOccQty"
                             uglcw-options="width:100, format: '{0:n5}',titleAlign:'center',align:'right'">
                            占用库存(小)
                        </div>
                        <div data-field="virtualQty"
                             uglcw-options="width:110, format: '{0:n5}',titleAlign:'center',align:'right'">
                            虚拟库存
                        </div>
                        <div data-field="minVirtualQty"
                             uglcw-options="width:110, format: '{0:n5}',titleAlign:'center',align:'right'">
                            虚拟库存(小)
                        </div>
                        <div data-field="_virtual_sum_Qty" uglcw-options="width:120,tooltip: true,titleAlign:'center',align:'right',
                                template: function(data){
                                    return formatVirtualQty(data);
                                }">
                            虚拟大小数量
                        </div>
                        <div data-field="">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="formatterQty">
    #var hsNum=data.hsNum;#
    #var sumQty =  data.sumQty;#

    #var rtn = (Math.floor(sumQty * 1000)/1000)+data.unitName #
    #if(parseFloat(hsNum)>1){#
    #var str = sumQty+"";#
    #if(str.indexOf(".")!=-1){#
    #var nums = str.split(".");#
    #var num1 = nums[0];#
    #var num2 = nums[1];#
    #if(parseFloat(num2)>0){#
    #var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);#
    #var minQty1 = parseFloat(0+"."+num2)*parseFloat(hsNum);#
    #minQty =   Math.floor(minQty * 100)/100;#
    #rtn = num1+""+data.unitName+""+minQty+""+data.minUnitName#
    #}#
    #}#
    #}#
    #= (rtn)#

</script>

<script type="text/x-kendo-template" id="formatterNum">
    #var sumQty =  Math.floor(data.sumQty * 100000)/100000;#
    #sumQty = sumQty;#
    #var rtn = sumQty; #
    #= (parseFloat(rtn))#
</script>


<script type="text/x-kendo-template" id="formatterNum1">
    #var minSumQty =  Math.floor((data.minSumQty||0) * 100000)/100000;#
    #minSumQty = minSumQty;#
    #var rtn = minSumQty; #
    #= (parseFloat(rtn))#
</script>

<script type="text/x-kendo-template" id="toolbar">

    <div class="k-button">
        <input type="checkbox" uglcw-role="checkbox" onclick="query()" uglcw-model="hbCkChk"
               uglcw-options="type:'number'"
               class="k-checkbox" id="hbCkChk"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="hbCkChk"><span style="font-size: 11px">合并仓库显示</span></label>
    </div>


    <div class="k-button">
        <input type="checkbox" uglcw-role="checkbox" onclick="showWareBar()" uglcw-model="showWareBar"
               uglcw-options="type:'number'"
               class="k-checkbox" id="showWareBar"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="showWareBar"><span style="font-size: 11px">显示条码</span></label>
    </div>
    <%--<a role="button" href="javascript:correctQty();"--%>
       <%--style="display: ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_START_UP_STOCK_CORRECT\"  and status=1")}"--%>
       <%--class="k-button k-button-icontext">--%>
        <%--<span class="k-icon k-i-edit"></span>库存纠偏--%>
    <%--</a>--%>
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
            uglcw.ui.get('#grid').reload();
        })
        $('.uglcw-layout-fixed').kendoTooltip({
            filter: 'li.k-item',
            position: 'right',
            content: function(e){
                return '<span class="k-in" style="width: 100px;display: inline-flex;">'+$(e.target).find('span.k-in').html()+'</span>';
            }
        });
        uglcw.ui.loaded()

    })
    
    function query() {
        var grid = uglcw.ui.get('#grid');
        if ($("#hbCkChk").is(":checked") == true) {
            uglcw.ui.get('#hbCk').value(1);
            grid.hideColumn('stkName');
        }else{
            uglcw.ui.get('#hbCk').value(0);
            grid.showColumn('stkName');
        }
        uglcw.ui.get('#grid').reload();
    }
    
    function onWareTypeSelect(e, isType){
        var node = this.dataItem(e.node);
        uglcw.ui.get('#type').value(isType);
        if(node.id == 0){
            uglcw.ui.get('#level2').k().dataSource.read();
            uglcw.ui.get('#level2').value('');
            uglcw.ui.get('#level3').k().dataSource.data([]);
            uglcw.ui.get('#level3').value('');
        }else if(node.pid == 0){
            uglcw.ui.get('#level2').k().dataSource.read();
            uglcw.ui.get('#level2').value(node.id);
            uglcw.ui.get('#level3').k().dataSource.data([]);
            uglcw.ui.get('#level3').value('');
        }else if(node.pid > 0){
            uglcw.ui.get('#level2').k().dataSource.read();
            uglcw.ui.get('#level2').value(node.pid);
            uglcw.ui.get('#level3').k().dataSource.read();
            uglcw.ui.get('#level3').value(node.id);
        }
        uglcw.ui.get('#grid').reload();
    }
    function correctQty() {
        uglcw.ui.openTab('库存纠偏', '${base}manager/toCorrectWareQty');
    }

    function showItems(data) {
        if ($("#hbCkChk").is(":checked") == true) {
            return;
        }
        uglcw.ui.openTab('库存明细' + data.wareId, '${base}manager/toStkDetail?stkId=' + data.stkId + '&wareId=' + data.wareId + "&scope=" + $("#scope").val());
    }

    function showWareBar() {
        var grid = uglcw.ui.get('#grid');
        if ($("#showWareBar").is(":checked") == true) {
            grid.showColumn('beBarCode');
            grid.showColumn('packBarCode');
        }else{
            grid.hideColumn('beBarCode');
            grid.hideColumn('packBarCode');
        }
    }


    function formatQty(data) {
        var hsNum = data.hsNum || 1;
        var minSumQty = data.minSumQty||0;
        var result = "";
        if((hsNum+"").indexOf(".")!=-1){
            var sumQty = minSumQty/hsNum;
            var str = sumQty+"";
            if(str.indexOf(".")!=-1){
                var nums = str.split(".");
                var num1 = nums[0];
                var num2 = nums[1];
                if(parseFloat(num2)>0){
                    var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);
                    minQty = minQty.toFixed(2);
                    result = num1+""+data.unitName+""+minQty+""+data.minUnitName;
                }
            }else{
                result = sumQty+data.unitName;
            }
        }else{
            var remainder = (minSumQty) % (hsNum);
            if (remainder === 0) {
                //整数件
                result += '<span>' + minSumQty / hsNum + '</span>' + data.unitName;
            } else if (remainder === minSumQty) {
                //不足一件
                var minQty =   Math.floor(minSumQty*100)/100;
                result += '<span>' + minQty + '</span>' + data.minUnitName;
            } else {
                //N件有余
                var minQty = Math.floor(remainder*100)/100;
                result += '<span>' + parseInt(minSumQty / hsNum) + '</span>' + data.unitName + '<span>' + minQty + '</span>' + data.minUnitName;
            }
        }
        return result;
    }

    function formatQty(data) {
        var hsNum = data.hsNum || 1;
        var minSumQty = data.minSumQty||0;
        var result = "";
        if((hsNum+"").indexOf(".")!=-1){
            var sumQty = minSumQty/hsNum;
            var str = sumQty+"";
            if(str.indexOf(".")!=-1){
                var nums = str.split(".");
                var num1 = nums[0];
                var num2 = nums[1];
                if(parseFloat(num2)>0){
                    var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);
                    minQty = minQty.toFixed(2);
                    result = num1+""+data.unitName+""+minQty+""+data.minUnitName;
                }
            }else{
                result = sumQty+data.unitName;
            }
        }else{
            var remainder = (minSumQty) % (hsNum);
            if (remainder === 0) {
                //整数件
                result += '<span>' + minSumQty / hsNum + '</span>' + data.unitName;
            } else if (remainder === minSumQty) {
                //不足一件
                var minQty =   Math.floor(minSumQty*100)/100;
                result += '<span>' + minQty + '</span>' + data.minUnitName;
            } else {
                //N件有余
                var minQty = Math.floor(remainder*100)/100;
                result += '<span>' + parseInt(minSumQty / hsNum) + '</span>' + data.unitName + '<span>' + minQty + '</span>' + data.minUnitName;
            }
        }
        return result;
    }

    function formatVirtualQty(data) {
        var hsNum = data.hsNum || 1;
        var minSumQty = data.minVirtualQty||0;
        var result = "";
        if((hsNum+"").indexOf(".")!=-1){
            var sumQty = parseFloat(minSumQty*10000)/parseFloat(hsNum*10000);
            var str = sumQty+"";
            if(str.indexOf(".")!=-1){
                var nums = str.split(".");
                var num1 = nums[0];
                var num2 = nums[1];
                if(parseFloat(num2)>0){
                    var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);
                    minQty = minQty.toFixed(2);
                    result = num1+""+data.unitName+""+minQty+""+data.minUnitName;
                }
            }else{
                result = sumQty+data.unitName;
            }
        }else{
            var remainder = (minSumQty) % (hsNum);
            if (remainder === 0) {
                //整数件
                result += '<span>' + minSumQty / hsNum + '</span>' + data.unitName;
            } else if (remainder === minSumQty) {
                //不足一件
                var minQty =   Math.floor(minSumQty*100)/100;
                result += '<span>' + minQty + '</span>' + data.minUnitName;
            } else {
                //N件有余
                var minQty = Math.floor(remainder*100)/100;
                result += '<span>' + parseInt(minSumQty / hsNum) + '</span>' + data.unitName + '<span>' + minQty + '</span>' + data.minUnitName;
            }
        }
        return result;
    }
</script>
</body>
</html>
