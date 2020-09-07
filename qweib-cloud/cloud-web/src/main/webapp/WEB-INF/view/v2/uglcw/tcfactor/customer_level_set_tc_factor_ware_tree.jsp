<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户等级商品提成系数设置</title>
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
        <div class="uglcw-layout-fixed" style="width:200px">
            <div class="layui-card">
                <div class="layui-card-header">库存商品类</div>
                <div class="layui-card-body">
                    <div uglcw-role="tree" id="tree"
                         uglcw-options="
							url: '${base}manager/companyStockWaretypes',
							template:uglcw.util.template($('#type_rate_template').html()),
							expandable:function(node){return node.id == '0'},
							loadFilter: function (response) {
                            $(response).each(function (index, item) {
                                if (item.text == '根节点') {
                                    item.text = '库存商品类'
                                }
                            })
                            return response;
                            },
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#wareType').value(node.id);
								uglcw.ui.get('#click-flag').value(0);
								uglcw.ui.get('#grid').reload();
                       		},
                       		dataBound: function(){
                       			uglcw.ui.init('#tree');
                       			laodData();
                       		}
                    	">
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="wtype" id="wareType" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="rateId" id="rateId" uglcw-role="textbox" value="${rateId}">
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li>

                            <input type="hidden" uglcw-role="textbox"id="click-flag" value="0"/>
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
							id:'id',
							query: function(params){
                            if(uglcw.ui.get('#click-flag').value()==1){
                                delete params['wtype']
                            }
                            return params;
                            },
							autoBind:false,
							pageable: true,
							rowNumber:true,
                    		url: '${base}manager/customerLevelTcFactorSetWarePage',
                    		criteria: '.form-horizontal',
                       		dataBound: function(){
                                 var data = this.dataSource.view();
                                    setTypeFactors(data);
                       		}
                    	">
                        <div data-field="wareNm" uglcw-options="width:100">商品名称</div>
                        <div data-field="waretypePath" uglcw-options="hidden:true,width:100">所属分类路径</div>
                        <div data-field="waretype" uglcw-options="hidden:true,width:100">所属分类Id</div>
                        <div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
                        <div data-field="wareGg" uglcw-options="width:80">规格</div>
                        <div data-field="wareDw" uglcw-options="width:60">大单位</div>
                        <div data-field="tempTcAmt" uglcw-options="width:160,hidden:${type eq 1?false:true}">原业务提成按数量</div>
                        <div data-field="tempSaleProTc" uglcw-options="width:160,hidden:${type eq 2?false:true}">原业务提成按收入%</div>
                        <div data-field="tempSaleGroTc" uglcw-options="width:160,hidden:${type eq 3?false:true}">原业务提成按毛利%</div>

                        <div data-field="saleQtyTcRate" uglcw-options="
								width:160,
								hidden:${type eq 1?false:true},
								headerTemplate: uglcw.util.template($('#header_saleQtyTcRate').html()),
								template:function(row){
									return uglcw.util.template($('#price_rate').html())({val:row.saleQtyTcRate, data: row, field:'saleQtyTcRate'})
								}
								">业务提成按数量系数</div>

                        <div data-field="saleQtyTc" uglcw-options="
								width:160,
								hidden:${type eq 1?false:true},
								headerTemplate: uglcw.util.template($('#header_saleQtyTc').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.tcAmt, data: row, field:'saleQtyTc'})
								}
								">业务提成按数量</div>

                        <div data-field="saleProTcRate" uglcw-options="
								width:160,
								hidden:${type eq 2?false:true},
								headerTemplate: uglcw.util.template($('#header_saleProTcRate').html()),
								template:function(row){
									return uglcw.util.template($('#price_rate').html())({val:row.saleProTcRate, data: row, field:'saleProTcRate'})
								}
								">业务提成按收入系数</div>

                        <div data-field="saleProTc" uglcw-options="
								width:160,
								hidden:${type eq 2?false:true},
								headerTemplate: uglcw.util.template($('#header_saleProTc').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.saleProTc, data: row, field:'saleProTc'})
								}
								">业务提成按收入%</div>

                        <div data-field="saleGroTcRate" uglcw-options="
								width:160,
								hidden:${type eq 3?false:true},
								headerTemplate: uglcw.util.template($('#header_saleGroTcRate').html()),
								template:function(row){
									return uglcw.util.template($('#price_rate').html())({val:row.saleGroTcRate, data: row, field:'saleGroTcRate'})
								}
								">业务提成按毛利系数✎</div>

                        <div data-field="saleGroTc" uglcw-options="
								width:160,
								hidden:${type eq 3?false:true},
								headerTemplate: uglcw.util.template($('#header_saleGroTc').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.saleGroTc, data: row, field:'saleGroTc'})
								}
								">业务提成按毛利%✎</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script id="header_saleQtyTcRate" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('saleQtyTcRate');">业务提成按数量系数✎</span>
</script>
<script id="header_saleProTcRate" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('saleProTcRate');">业务提成按收入系数✎</span>
</script>
<script id="header_saleGroTcRate" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('saleGroTcRate');">业务提成按毛利系数✎</span>
</script>

<script id="header_saleQtyTc" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('saleQtyTc');">业务提成按数量✎</span>
</script>
<script id="header_saleProTc" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('saleProTc');">业务提成按收入%✎</span>
</script>
<script id="header_saleGroTc" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('saleGroTc');">业务提成按毛利%✎</span>
</script>


<script id="price_rate" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <div style="display: inline-flex">
        <div style="display: none">
            <input class="#=field#_input" id="#=field#_input_#=wareId#" name="#=field#_input" uglcw-role="numeric"
                   uglcw-validate="number" style="height:25px;width: 60px"
                   onchange="changePrice(this,'#=field #','#=wareId#')" value='#= val #'>
        </div>
        <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>
        <span class="#=field#_org_factor" id="#=field#_org_#=wareId#" style='color:green'></span>
    </div>
</script>

<script id="price" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <div style="display: inline-flex">
        <div style="display: none">
            <input class="#=field#_input" id="#=field#_input_#=wareId#" name="#=field#_input" uglcw-role="numeric"
                   uglcw-validate="number" style="height:25px;width: 60px"
                   onchange="changePrice(this,'#=field #','#=wareId#')" value='#= val #'>
        </div>

        <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>

        <span class="#=field#_type_factor" id="#=field#_type_#=wareId#" style='color:green'></span>
    </div>
</script>


<script id="type_rate_template" type="text/x-uglcw-template">
    #=item.text#
    #if(item.id!=0){#
    &nbsp;&nbsp;<span data-ware-id="#= item.id#" id="type_${relaId}_#= item.id#"></span>
    #}#
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#click-flag').value(1);
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })
        //设置tree高度
        var treeHeight = $(window).height() - $("div.layui-card-header").height() - 60;
        $("#tree").height(treeHeight + "px");
        uglcw.ui.loaded();
    })

    //---------------------------------------------------------------------------------------------------------------

    function operatePrice(field) {
        var display = $("." + field + "_input").closest("div").css('display');
        if (display == 'none') {
            $("." + field + "_input").closest("div").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").closest("div").hide();
            $("." + field + "_span").show();
        }
    }

    function changePrice(o, field, wareId) {
        if (isNaN(o.value)) {
            uglcw.ui.toast("请输入数字")
            return;
        }
        var ipt = o.value;
        if (ipt == "") {
            ipt = 0;
        }

        if(field=='saleQtyTc'&&o.value!=''){
            var rate = $("#saleQtyTcRate_input_" + wareId).val();
            if (rate != '' && rate != 0) {
                uglcw.ui.info('有相应系数，不允许输入!');
                $("#" + field + "_input_" + wareId).val("");
                return;
            }
        }

        if(field=='saleProTc'&&o.value!=''){
            var rate = $("#saleProTcRate_input_" + wareId).val();
            if (rate != '' && rate != 0) {
                uglcw.ui.info('有相应系数，不允许输入!');
                $("#" + field + "_input_" + wareId).val("");
                return;
            }
        }

        if(field=='saleGroTc'&&o.value!=''){
            var rate = $("#saleGroTcRate_input_" + wareId).val();
            if (rate != '' && rate != 0) {
                uglcw.ui.info('有相应系数，不允许输入!');
                $("#" + field + "_input_" + wareId).val("");
                return;
            }
        }


        if(field=='saleQtyTcRate'&&o.value!=''){
            var row = uglcw.ui.get('#grid').k().dataItem($(o).closest('tr'));
            var tempTcAmt =  row.tempTcAmt;
            tempTcAmt = parseFloat(tempTcAmt)*parseFloat(o.value);
            $("#saleQtyTc_span_" + row.wareId).text("("+tempTcAmt+ ")");
        }

        if(field=='saleProTcRate'&&o.value!=''){
            var row = uglcw.ui.get('#grid').k().dataItem($(o).closest('tr'));
            var saleProTc =  row.tempSaleProTc;
            saleProTc = parseFloat(saleProTc)*parseFloat(o.value);
            $("#saleProTc_span_" + row.wareId).text("("+saleProTc+ ")");
        }

        if(field=='saleGroTcRate'&&o.value!=''){
            var row = uglcw.ui.get('#grid').k().dataItem($(o).closest('tr'));
            var tempSaleGroTc =  row.tempSaleGroTc;
            tempSaleGroTc = parseFloat(tempSaleGroTc)*parseFloat(o.value);
            $("#saleGroTc_span_" + row.wareId).text("("+tempSaleGroTc+ ")");
        }

        $.ajax({
            url: "${base}manager/updateCustomerLevelWareTcFactor",
            type: "post",
            data: "relaId=${relaId}&wareId=" + wareId + "&price=" + ipt + "&field=" + field,
            success: function (data) {
                if (data == '1') {
                    uglcw.ui.info('更新成功!');
                    $("#" + field + "_span_" + wareId).text(o.value);
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }
    var datas = "";
    function laodData() {
        var path = "${base}/manager/customerLevelTcRateList";
        var relaId = '${relaId}';
        if (relaId == "") {
            return;
        }
        if(datas!=""){
            setDatas();
        }
        $.ajax({
            url: path,
            type: "POST",
            data: {"relaId": relaId},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    var list = json.rows;
                    datas  = json.rows;
                    if (list) {
                        setDatas();
                    }
                    uglcw.ui.get('#grid').reload();
                }
            }
        });
    }
    function setDatas(){
        if(datas==""){
            return;
        }
        $.map(datas, function (item) {
            if('${type}'==1){
                if(item.saleQtyTcRate!=''&&item.saleQtyTcRate!=0&&item.saleQtyTcRate!=undefined){
                    $("#type_" + item.relaId + "_" + item.waretypeId).text(item.saleQtyTcRate + "");
                }
            }else if('${type}'==2){
                if(item.saleProTcRate!=''&&item.saleProTcRate!=0&&item.saleProTcRate!=undefined){
                    $("#type_" + item.relaId + "_" + item.waretypeId).text(item.saleProTcRate + "");
                }
            }else if('${type}'==3){
                if(item.saleGroTcRate!=''&&item.saleGroTcRate!=0&&item.saleGroTcRate!=undefined){
                    $("#type_" + item.relaId + "_" + item.waretypeId).text(item.saleGroTcRate + "");
                }
            }
        })
    }

    function setTypeFactors(rows){
        if(datas!=null&&datas!=""){
            $(rows).each(function(idx, row){
                var warePath = row.waretypePath;
                if('${type}'==1&&(row.tcAmt==undefined||row.tcAmt==null||row.tcAmt==0.00)){
                    var tc = row.tempTcAmt;
                    if(tc!=null&&tc!=0&&tc!=undefined){
                        if(row.saleQtyTcRate!=undefined&&row.saleQtyTcRate!=null&&parseFloat(row.saleQtyTcRate)!=0){
                            tc = parseFloat(tc)*parseFloat(row.saleQtyTcRate);
                            $("#saleQtyTc_span_" + row.wareId).text("("+tc.toFixed(2)+ ")");
                        }

                    }
                }else if('${type}'==2&&(row.saleProTc==null||row.saleProTc==0.00||row.saleProTc==undefined)){
                    var tc = row.tempSaleProTc;
                    if(tc!=null&&tc!=0&&tc!=undefined){
                        if(row.saleProTcRate!=undefined&&row.saleProTcRate!=null&&parseFloat(row.saleProTcRate)!=0){
                            tc = parseFloat(tc)*parseFloat(row.saleProTcRate);
                            $("#saleProTc_span_" + row.wareId).text("("+tc.toFixed(2)+ ")");
                        }

                    }
                }else if('${type}'==3&&(row.saleGroTc==null||row.saleGroTc==0.00||row.saleGroTc==undefined)){
                    var tc = row.tempSaleGroTc;
                    if(tc!=null&&tc!=0&&tc!=undefined){
                        if(row.saleGroTcRate!=undefined&&row.saleGroTcRate!=null&&parseFloat(row.saleGroTcRate)!=0){
                            tc = parseFloat(tc)*parseFloat(row.saleGroTcRate);
                            $("#saleGroTc_span_" + row.wareId).text("("+tc.toFixed(2)+ ")");
                        }
                    }
                }

                $(datas).each(function(dx, data){
                    if(warePath.indexOf("-"+data.waretypeId+"-")!=-1){
                        if('${type}'==1&&data.saleQtyTcRate!=null&&data.saleQtyTcRate!=0&&data.saleQtyTcRate!=undefined){
                                $("#saleQtyTcRate_org_" + row.wareId).text("("+data.saleQtyTcRate + ")");
                                var tc = row.tempTcAmt;
                                if(tc!=null&&tc!=0&&tc!=undefined){
                                    tc = parseFloat(tc)*parseFloat(data.saleQtyTcRate);
                                    $("#saleQtyTc_type_" + row.wareId).text("("+tc.toFixed(2)+ ")");
                                }
                        }else if('${type}'==2&&data.saleProTcRate!=null&&data.saleProTcRate!=0&&data.saleProTcRate!=undefined){
                                $("#saleProTcRate_org_" + row.wareId).text("("+data.saleProTcRate + ")");
                                var tc = row.tempSaleProTc;
                                if(tc!=null&&tc!=0&&tc!=undefined){
                                    tc = parseFloat(tc)*parseFloat(data.saleProTcRate);
                                    $("#saleProTc_type_" + row.wareId).text("("+tc.toFixed(2)+ ")");
                                }
                                $("#saleProTcRate_type_" + row.wareId).text("("+data.saleProTcRate + ")");
                        }else if('${type}'==3&&data.saleGroTcRate!=null&&data.saleGroTcRate!=0&&data.saleGroTcRate!=undefined){
                                $("#saleGroTcRate_org_" + row.wareId).text("("+data.saleGroTcRate + ")");
                                var tc = row.tempSaleProTc;
                                if(tc!=null&&tc!=0&&tc!=undefined){
                                    tc = parseFloat(tc)*parseFloat(data.saleGroTcRate);
                                    $("#saleGroTc_type_" + row.wareId).text("("+tc.toFixed(2)+ ")");
                                }
                        }
                    }
                })
            })
        }
    }

</script>
</body>
</html>
