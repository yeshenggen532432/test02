<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售客户毛利费用表</title>
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
    <style>
        .k-grid-toolbar {
            padding: 0px 10px 0px 10px !important;
            width: 100%;
            display: inline-flex;
            vertical-align: middle;
        }

        .k-grid-toolbar .k-checkbox-label {
            margin-top: 7px !important;

        }

        .k-grid-toolbar label {
            padding-left: 20px;
            margin-left: 10px;
            margin-top: 7px;
            margin-bottom: 0px !important;
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
                    <input type="hidden" uglcw-role="textbox" uglcw-model="showAutoFeeNoZero" id="showAutoFeeNoZero"/>
                    <select uglcw-role="combobox" uglcw-model="timeType"
                            uglcw-options="placeholder:'时间类型'">
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
                    <input uglcw-role="textbox" uglcw-model="stkUnit" placeholder="客户名称"/>
                </li>
                <li>
                    <input type="hidden" uglcw-model="isType" id="isType" value="0" uglcw-role="textbox">
                    <input uglcw-role="gridselector" uglcw-model="wtypename,wtype" id="wtype" placeholder="资产类型"
                           uglcw-options="
                           value:'库存商品类',
                           click:function(){
                                 waretype()
                           }
                            ">
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
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li>
                    <select class="biz-type" id="saleType" uglcw-model="saleType" uglcw-role="combobox"
                            uglcw-options="placeholder:'业务类型', value: ''">
                        <option value="001" selected>传统业务类</option>
                        <option value="003">线上商城</option>
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
                    dblclick: function(row){
                        var q = uglcw.ui.bind('.form-horizontal');
                        q.epCustomerName=row.epCustomerName;
                        q.stkUnit=row.stkUnit;
                        uglcw.ui.openTab('客户毛利明细统计', '${base}manager/queryAutoCstStatDetail?'+ $.map(q, function(v, k){
                            return k+'='+(v||'');
                        }).join('&'));
                    }
                    ">
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
<%--    <a role="button" href="javascript:showMainDetail();" class="k-button k-button-icontext">--%>
<%--        <span class="k-icon k-i-info"></span>明细表--%>
<%--    </a>--%>
    <a role="button" href="javascript:createRptData();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>生成报表
    </a>
    <a role="button" href="javascript:queryRpt();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>查询生成的报表
    </a>

    <a role="button" href="javascript:createAutoFee();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>生成变动费用单
    </a>
    <%--<a role="button" href="javascript:CustomerFee();" class="k-button k-button-icontext">--%>
        <%--<span class="k-icon k-i-cog"></span>设置固定费用--%>
    <%--</a>--%>

    <input type="checkbox" class="k-checkbox"  uglcw-role="checkbox" uglcw-model="showAutoFeeNoZeroFlag"
           id="showAutoFeeNoZeroFlag">
    <label style="margin-left: 10px;" class="k-checkbox-label" for="showAutoFeeNoZeroFlag">过滤变动费用为0的数据</label>

</script>
<script id="product-tpl" type="text/x-uglcw-template">
    <table class="product-grid" style="border-bottom:1px \\#3343a4 solid;padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">销售类型</td>
            <td style="width: 80px;">计量单位</td>
            <td style="width: 80px;">价格</td>
        </tr>
        #for (var i=0; i< data.products.length; i++) { #
        <tr>
            <td>#= data.products[i].wareNm #</td>
            <td>#= data.products[i].xsTp #</td>
            <td>#= data.products[i].unitName #</td>
            <td>#= uglcw.util.toString(data.products[i].price,'n2')#</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="product-type-selector-template" type="text/uglcw-template">
    <div class="uglcw-selector-container">
        <div style="line-height: 30px" class="drag-area">
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

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<script>
    var autoTitleDatas = eval('${autoTitleJson}');
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            var query = uglcw.ui.bind('.form-horizontal');
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
            if((dis+1)>2){
                uglcw.ui.info("最多只能查询两个月之间的数据");
                return;
            }
            var showAutoFeeNoZeroFlag = $("#showAutoFeeNoZeroFlag").is(':checked');
            if (!showAutoFeeNoZeroFlag) {
                uglcw.ui.get("#showAutoFeeNoZero").value(0);
            } else {
                uglcw.ui.get("#showAutoFeeNoZero").value(1);
            }
            uglcw.ui.get('#grid').reload();
        })

        $('#wtype').on('change', function () {
            if(!uglcw.ui.get('#wtype').value()){
                uglcw.ui.clear('.form-horizontal', {isType: ''},{excludeHidden: false})  //清空当前id为wtype搜索框内容
            }
        })

        $("#grid").on('click','.autoCostClass',function(){
            $(this).toggleClass('show hide');
            var show = $(this).hasClass('show')
            if (autoTitleDatas.length > 0) {
                for (var i = 0; i < autoTitleDatas.length; i++) {
                    var col = autoTitleDatas[i].name;
                    if(show){
                        uglcw.ui.get('#grid').showColumn(col);
                    }else{
                        uglcw.ui.get('#grid').hideColumn(col);
                    }
                }
            }
        });

        uglcw.ui.get('#xsTp').k().dataSource.read();
        initGrid();
        uglcw.ui.loaded()
    })

    function showMainDetail() {//明细表
        var q = uglcw.ui.bind('.form-horizontal');
        delete q['regionId'];
        uglcw.ui.openTab('客户毛利明细统计表', '${base}manager/queryAutoCstStatDetail?' + $.map(q, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }


    function createRptData() {//生成报表
        var query = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('生成客户费用统计表', "${base}manager/queryAutoCstStatDetailList?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }


    function createAutoFee() {//生成变动费用表
        var selection = uglcw.ui.get('#grid').selectedRow();
        var customerIds = $.map(selection, function (row) {   return row.stkUnitId}).join(',');

        var showAutoFeeNoZeroFlag = $("#showAutoFeeNoZeroFlag").is(':checked');
        if (!showAutoFeeNoZeroFlag) {
            uglcw.ui.get("#showAutoFeeNoZero").value(0);
        } else {
            uglcw.ui.get("#showAutoFeeNoZero").value(1);
        }
        var query = uglcw.ui.bind('.form-horizontal');
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
        if((dis+1)>2){
            uglcw.ui.info("最多只能生成2个月之间的费用数据");
            return;
        }
        query.customerIds=customerIds;
        //query.proType=2;
        uglcw.ui.confirm('是否确定生成变动费用单，若未选中，将全部生成？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/mergeAutoCustomerWarePrice',
                type: 'post',
                data: query,
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success("变动费用生成成功!");
                        uglcw.ui.get('#grid').reload({stay: true});
                    } else {
                        uglcw.ui.error('变动费用生成失败！');
                    }
                }
            })
        })
    }


    function initGrid() {

        var checkboxColumn = {
            width: 35,
            selectable: true,
            type: 'checkbox',
        };


        var cols = [
            checkboxColumn,
            // {field: 'wareCode', title: '商品编码',width:80},
            {field: 'stkUnitId', title: '客户名称',hidden:true,width:100},
            {field: 'stkUnit', title: '客户名称',width:100},
            {field: 'sumQty', title: '销售数量',width:100,format: '{0:n2}', attributes:{'style': 'text-align:right'},headerAttributes:{'style': 'text-align:center'}},
            {field: 'sumAmt', title: '销售收入',width:100,format: '{0:n2}',attributes:{'style': 'text-align:right'},headerAttributes:{'style': 'text-align:center'}},
            {field: 'avgPrice', title: '平均单位售价',width:100,format: '{0:n2}',attributes:{'style': 'text-align:right'},headerAttributes:{'style': 'text-align:center'}},
            {field: 'discount', title: '整单折扣',width:100,format: '{0:n2}',attributes:{'style': 'text-align:right'},headerAttributes:{'style': 'text-align:center'}},
            {field: 'inputAmt', title: '销售投入费用',width:100,format: '{0:n2}',attributes:{'style': 'text-align:right'},headerAttributes:{'style': 'text-align:center'}},
            {field: 'sumCost', title: '销售成本',width:100,format: '{0:n2}',attributes:{'style': 'text-align:right'},headerAttributes:{'style': 'text-align:center'}},
            {field: 'autoCost', title: '市场变动费用▷',width:100,format: '{0:n2}',attributes:{'style': 'text-align:right'},headerAttributes:{'class':'autoCostClass','style': 'text-align:center'}}
        ];
        if (autoTitleDatas.length > 0) {
            for (var i = 0; i < autoTitleDatas.length; i++) {
                var json = autoTitleDatas[i];
                if(json.fdCode=="YWTC01"||json.fdCode=="YWTC02"){
                    continue;
                }
                var field = json.name;
                var title = json.name;
                var titleId = json.id;
                var createColumn = function(f, t,tid){
                    var col = {
                        field: f,
                        width: 120,
                        title: t,
                        hidden:true,
                        attributes:{'style': 'text-align:right'},headerAttributes:{'style': 'text-align:center'},
                        template: function (row) {
                            var map = row.autoMap||{};
                            var  html = uglcw.util.toString(map[tid],'n2')||'';
                            return html;
                        }
                    };
                    cols.push(col);
                }
                createColumn(field, title,titleId);
            }
        }
        var col =  {field: 'fee', title: '固定费用',width:100,format: '{0:n2}',attributes:{'style': 'text-align:right'},headerAttributes:{'style': 'text-align:center'}};
        cols.push(col);
        col =  {field: 'disAmt', title: '销售毛利',width:100,format: '{0:n2}',attributes:{'style': 'text-align:right'},headerAttributes:{'style': 'text-align:center'}};
        cols.push(col);
        col =  {field: 'avgAmt', title: '平均单位毛利',width:100,format: '{0:n2}',attributes:{'style': 'text-align:right'},headerAttributes:{'style': 'text-align:center'}};
        cols.push(col);
        col =  {field: 'epCustomerName', title: '所属二批',width:100};
        cols.push(col);



        uglcw.ui.get('#grid').kInit({
            toolbar: uglcw.util.template($('#toolbar').html()),
            responsive:['.header',40],
            dblclick: function(row){
                var q = uglcw.ui.bind('.form-horizontal');
                q.epCustomerName=row.epCustomerName;
                q.stkUnit=row.stkUnit;
                uglcw.ui.openTab('客户毛利明细统计', '${base}manager/queryAutoCstStatDetail?'+ $.map(q, function(v, k){
                    return k+'='+(v||'');
                }).join('&'));
            },
            pageable: {
                numeric: true,
                refresh: true,
                buttonCount: 5,
                previousNext: true,
                pageSizes: [10, 20, 50]
            },
            columns: cols,
            autoBind: false,
            dataSource: {
                schema: {
                    data: function (response) {
                        var rows = response.rows || [];
                        return rows;
                    },
                    total: function (response) {
                        return response.total;
                    },
                },
                transport: {
                    read: {
                        url: '${base}manager/queryAutoCstStatPage',
                        data: function (param) {
                            var q = uglcw.ui.bind('.form-horizontal')
                            return uglcw.extend(q, {
                                page: param.page,
                                rows: param.pageSize
                            })
                        }
                    }
                },
                serverPaging: true,
                pageSize: 20
            }
        })
    }


    function queryRpt() {//查询生成的报表
        uglcw.ui.openTab('生成的统计表', '${base}manager/querySaveRptDataStat?rptType=4');
    }

    function CustomerFee() {//设置固定费用
        uglcw.ui.openTab('客户固定费用', '${base}manager/toCustomerFee');
    }

    function waretype() {
        var i = uglcw.ui.Modal.open({
            checkbox:true,
            selection:'single',
            title:false,
            maxmin:false,
            resizable:false,
            move:'.drag-area',
            btns:['确定','取消'],
            area:['400','415px'],
            content:$('#product-type-selector-template').html(),
            success:function (c) {
                uglcw.ui.init(c);
            },
            yes:function (c) {
                uglcw.ui.get('#wtype').value(uglcw.ui.get($(c).find('#wtypename')).value());
                uglcw.ui.get('#wtype').text(uglcw.ui.get($(c).find('#_type_id')).value());
                uglcw.ui.get('#isType').value(uglcw.ui.get($(c).find('#_isType')).value());
                uglcw.ui.Modal.close(i);
                return false;
            }
        })
    }

</script>
</body>
</html>
