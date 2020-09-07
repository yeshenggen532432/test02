<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户类型商品价格设置</title>
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
							loadFilter:function(response){
							$(response).each(function(index,item){
							    if(item.text=='根节点'){
							        item.text='库存商品类'
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
                            <input type="hidden" uglcw-model="relaId" id="relaId" uglcw-role="textbox" value="${relaId}">
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
							pageable: true,
							rowNumber:true,
                    		url: '${base}manager/customerTypeSetWarePage',
                    		criteria: '.form-horizontal',
                    		dataBound: function(){
                       			 var data = this.dataSource.view();
                                 setTypeRate(data);
                       		}
                    	">
                        <div data-field="wareNm" uglcw-options="width:100">商品名称</div>
                        <div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
                        <div data-field="waretypePath" uglcw-options="hidden:true,width:100">所属分类路径</div>
                        <div data-field="waretype" uglcw-options="hidden:true,width:100">所属分类Id</div>
                        <div data-field="wareGg" uglcw-options="width:80">规格</div>
                        <div data-field="wareDw" uglcw-options="width:60">大单位</div>
                        <div data-field="minUnit" uglcw-options="width:60">小单位</div>
                        <div data-field="tempWareDj" uglcw-options="width:100">销售原价(大)</div>
                        <div data-field="tempSunitPrice" uglcw-options="width:100">销售原价(小)</div>
                        <div data-field="rate" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_rate').html()),
								template:function(row){
									return uglcw.util.template($('#rate_tmplate').html())({val:row.rate, data: row, field:'rate'})
								}
								">
                        </div>
                        <div data-field="wareDj" uglcw-options="
								width:160,
								headerTemplate: uglcw.util.template($('#header_pfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.wareDj, data: row, field:'wareDj'})
								}
								">
                        </div>
                        <%--<div data-field="lsPrice" uglcw-options="--%>
                        <%--width:120,--%>
                        <%--headerTemplate: uglcw.util.template($('#header_lsPrice').html()),--%>
                        <%--template:function(row){--%>
                        <%--return uglcw.util.template($('#price').html())({val:row.lsPrice, data: row, field:'lsPrice'})--%>
                        <%--}--%>
                        <%--">--%>
                        <%--</div>--%>
                        <%--<div data-field="fxPrice" uglcw-options="--%>
                        <%--width:120,--%>
                        <%--headerTemplate: uglcw.util.template($('#header_fxPrice').html()),--%>
                        <%--template:function(row){--%>
                        <%--return uglcw.util.template($('#price').html())({val:row.fxPrice, data: row, field:'fxPrice'})--%>
                        <%--}--%>
                        <%--">--%>
                        <%--</div>--%>
                        <%--<div data-field="cxPrice" uglcw-options="--%>
                        <%--width:120,--%>
                        <%--headerTemplate: uglcw.util.template($('#header_cxPrice').html()),--%>
                        <%--template:function(row){--%>
                        <%--return uglcw.util.template($('#price').html())({val:row.cxPrice, data: row, field:'cxPrice'})--%>
                        <%--}--%>
                        <%--">--%>
                        <%--</div>--%>
                        <div data-field="sunitPrice" uglcw-options="
								width:160,
								headerTemplate: uglcw.util.template($('#header_minPfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.sunitPrice, data: row, field:'sunitPrice'})
								}
								">
                        </div>
                        <%--<div data-field="minLsPrice" uglcw-options="--%>
                        <%--width:120,--%>
                        <%--headerTemplate: uglcw.util.template($('#header_minLsPrice').html()),--%>
                        <%--template:function(row){--%>
                        <%--return uglcw.util.template($('#price').html())({val:row.minLsPrice, data: row, field:'minLsPrice'})--%>
                        <%--}--%>
                        <%--">--%>
                        <%--</div>--%>
                        <%--<div data-field="minFxPrice" uglcw-options="--%>
                        <%--width:120,--%>
                        <%--headerTemplate: uglcw.util.template($('#header_minFxPrice').html()),--%>
                        <%--template:function(row){--%>
                        <%--return uglcw.util.template($('#price').html())({val:row.minFxPrice, data: row, field:'minFxPrice'})--%>
                        <%--}--%>
                        <%--">--%>
                        <%--</div>--%>
                        <%--<div data-field="minCxPrice" uglcw-options="--%>
                        <%--width:120,--%>
                        <%--headerTemplate: uglcw.util.template($('#header_minCxPrice').html()),--%>
                        <%--template:function(row){--%>
                        <%--return uglcw.util.template($('#price').html())({val:row.minCxPrice, data: row, field:'minCxPrice'})--%>
                        <%--}--%>
                        <%--">--%>
                        <%--</div>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script id="header_temp_lsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('tempWareDj');">大单位零售价</span>
</script>
<script id="header_temp_minLsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('tempSunitPrice');">小单位零售价</span>
</script>
<script id="header_rate" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('rate');">销售折扣率%✎</span>
</script>
<script id="header_inPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('inPrice');">大单位采购价✎</span>
</script>
<script id="header_pfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('wareDj');">批发价(大)✎</span>
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('lsPrice');">大单位零售价✎</span>
</script>
<script id="header_fxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('fxPrice');">大单位分销价✎</span>
</script>
<script id="header_cxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('cxPrice');">大单位促销价✎</span>
</script>
<script id="header_minInPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minInPrice');">小单位采购价✎</span>
</script>
<script id="header_minPfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('sunitPrice');">批发价(小)✎</span>
</script>
<script id="header_minLsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minLsPrice');">小单位零售价✎</span>
</script>
<script id="header_minFxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minFxPrice');">小单位分销价✎</span>
</script>
<script id="header_minCxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minCxPrice');">小单位促销价✎</span>
</script>

<script id="header_temp_lsPrice" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>
</script>

<script id="header_temp_minLsPrice" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>
</script>


<script id="rate_tmplate" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <div style="display: inline-flex">
        <div style="display: none">
            <input class="#=field#_input" id="#=field#_input_#=wareId#" name="#=field#_input" uglcw-role="numeric"
                   uglcw-options="min:0, max: 1000" style="height:25px;width: 60px"
                   onchange="changePrice(this,'#= field #',#= wareId #)" value='#= val #'>
        </div>
        <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>
        <span class="#=field#_org_rate" id="#=field#_org_#=wareId#" style='color:green'></span>
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
                   onchange="changePrice(this,'#= field #',#= wareId #)" value='#= val #'>
        </div>
        <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>
        <span class="#=field#_type_rate" id="#=field#_type_#=wareId#" style='color:green'></span>
    </div>
</script>

<script id="type_rate_template" type="text/x-uglcw-template">
    #=item.text#
    #if(item.id!=0){#
    &nbsp;&nbsp;<span class="itemRateClass" id="type_${relaId}_#= item.id#"></span>
    #}#
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#click-flag').value(1); //查询标记1
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
        var rate = $("#rate_input_" + wareId).val();
        if (field != 'rate' && o.value != '') {
            if (rate != '' && rate != 0) {
                uglcw.ui.info('有设置折扣率，不能设置价格!');
                $("#" + field + "_input_" + wareId).val("");
                return;
            }
        }
        if(field=='rate'&&rate!=''){
            var row = uglcw.ui.get('#grid').k().dataItem($(o).closest('tr'));
            var lsPrice = (row.tempWareDj==''||row.tempWareDj==null)?0:row.tempWareDj;
            var lsMinPrice =(row.tempSunitPrice==''||row.tempSunitPrice==null)?0:row.tempSunitPrice;
            if(lsPrice!=0){
                lsPrice = parseFloat(lsPrice)*parseFloat(rate)/100;
                $("#wareDj_span_" + wareId).text(lsPrice.toFixed(2));
            }
            if(lsMinPrice!=0){
                lsMinPrice = parseFloat(lsMinPrice)*parseFloat(rate)/100;
                $("#sunitPrice_span_" + wareId).text(lsMinPrice.toFixed(2));
            }
        }
        var ipt = o.value;
        if (ipt == "") {
            ipt = 0;
        }
        $.ajax({
            url: "${base}manager/updateCustomerTypeWarePrice",
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

        var rate = '${sysQdtype.rate}';
        if(rate!=''&&rate!=0){
            var itemRates = $(".itemRateClass");
            $.map(itemRates, function (item) {
                $(item).text(rate+"%");
            })
        }

        var path = "${base}/manager/qdTypeRateList";
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
                    datas = json.rows;
                    if (datas) {
                        setDatas()
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
            if (item.rate != '' && item.rate != 0) {
                $("#type_" + item.relaId + "_" + item.waretypeId).text(item.rate + "%");
            }
        })
    }

    function setTypeRate(rows) {
        //if(datas!=null&&datas!=""){
            var rate = '${sysQdtype.rate}';
            $(rows).each(function(idx, row){
                var warePath = row.waretypePath;
                //（1）===============客户类型对应的商品销售价格比例=================
                if((row.wareDj==undefined||row.wareDj==null||row.wareDj==0.00)){
                    var tc = row.tempWareDj;
                    if(tc!=null&&tc!=0&&tc!=undefined){
                        if(row.rate!=undefined&&row.rate!=null&&parseFloat(row.rate)!=0){
                            tc = parseFloat(tc)*parseFloat(row.rate)/100;
                            $("#wareDj_span_" + row.wareId).text(""+tc.toFixed(2)+ "");
                        }
                    }
                }
                if((row.sunitPrice==undefined||row.sunitPrice==null||row.sunitPrice==0.00)){
                    var tc = row.tempSunitPrice;
                    if(tc!=null&&tc!=0&&tc!=undefined){
                        if(row.rate!=undefined&&row.rate!=null&&parseFloat(row.rate)!=0){
                            tc = parseFloat(tc)*parseFloat(row.rate)/100;
                            $("#sunitPrice_span_" + row.wareId).text(""+tc.toFixed(2)+ "");
                        }
                    }
                }

                //（2）===============客户类型中设置的销售价格比例=================
                if(rate!=null&&rate!=0&&rate!=undefined){
                    $("#rate_org_" + row.wareId).text("("+rate + ")");
                    var tc = row.tempWareDj;
                    if(tc!=null&&tc!=0&&tc!=undefined){
                        tc = parseFloat(tc)*parseFloat(rate)/100;
                        $("#wareDj_type_" + row.wareId).text("("+tc.toFixed(2)+ ")");
                    }
                    tc = row.tempSunitPrice;
                    if(tc!=null&&tc!=0&&tc!=undefined){
                        tc = parseFloat(tc)*parseFloat(rate)/100;
                        $("#sunitPrice_type_" + row.wareId).text("("+tc.toFixed(2)+ ")");
                    }
                }
                //==============客户类型中设置的销售价格比例===================


                //（3）==============客户类型对应商品类别销售价格比例==========================================
                $(datas).each(function(dx, data){
                    if(warePath.indexOf("-"+data.waretypeId+"-")!=-1){
                        if(data.rate!=null&&data.rate!=0&&data.rate!=undefined){
                            $("#rate_org_" + row.wareId).text("("+data.rate + ")");
                            var tc = row.tempWareDj;
                            if(tc!=null&&tc!=0&&tc!=undefined){
                                tc = parseFloat(tc)*parseFloat(data.rate)/100;
                                $("#wareDj_type_" + row.wareId).text("("+tc.toFixed(2)+ ")");
                            }
                            tc = row.tempSunitPrice;
                            if(tc!=null&&tc!=0&&tc!=undefined){
                                tc = parseFloat(tc)*parseFloat(data.rate)/100;
                                $("#sunitPrice_type_" + row.wareId).text("("+tc.toFixed(2)+ ")");
                            }
                        }
                    }
                })
                //==============客户类型对应商品类别销售价格比例==========================================
            })
       // }

    }

</script>
</body>
</html>
