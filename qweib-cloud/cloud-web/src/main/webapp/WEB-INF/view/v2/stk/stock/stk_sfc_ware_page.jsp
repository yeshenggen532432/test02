<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>存货收发存</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .k-grid-toolbar{
            padding: 5px 10px 5px 10px!important;
            width: 100%;
            display: inline-flex;
            vertical-align: middle;
        }
        .k-grid-toolbar .k-checkbox-label{
            margin-top: 0px!important;

        }
        .k-grid-toolbar label{
            padding-left: 20px;
            margin-left: 10px;
            margin-bottom: 0px!important;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px;">
            <div class="layui-card" uglcw-role="resizable" uglcw-options="responsive:[35]">
                <ul uglcw-role="accordion">
                    <li>
                        <span>库存商品类</span>
                        <div uglcw-role="tree"  id="tree1"
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
                                        uglcw.ui.get('#wareType').value(node.id);
                                        uglcw.ui.get('#isType').value(0);
                                        uglcw.ui.get('#grid').reload();
                                   },
                                 dataBound: function(){
                                   var tree = this;
                                   clearTimeout($('#tree1').data('_timer'));
                                   $('#tree1').data('_timer', setTimeout(function(){
                                       tree.select($('#tree1 .k-item:eq(0)'));
                                       var nodes = tree.dataSource.data().toJSON();
                                       if(nodes && nodes.length > 0){
                                           uglcw.ui.bind('.uglcw-query', {
                                               isType: 0,
                                               waretype: nodes[0].id}
                                           );
                                           //uglcw.ui.get('#grid').reload();
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
                                        var node = this.dataItem(e.node);
                                        uglcw.ui.get('#wareType').value(node.id);
                                        uglcw.ui.get('#isType').value(1);
                                        uglcw.ui.get('#grid').reload();
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
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#wareType').value(node.id);
                                    uglcw.ui.get('#isType').value(2);
                                    uglcw.ui.get('#grid').reload();
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
                                        var node = this.dataItem(e.node);
                                        uglcw.ui.get('#wareType').value(node.id);
                                        uglcw.ui.get('#isType').value(3);
                                        uglcw.ui.get('#grid').reload();
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
                            <input type="hidden" uglcw-model="isType" id="isType" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="waretype" value="0" id="wareType" uglcw-role="textbox">
                            <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox"  id="stkId" uglcw-model="stkId" uglcw-options="
                                    dataTextField: 'stkName',
                                    dataValueField: 'id',
                                    url: '${base}manager/queryBaseStorage',
                                    placeholder: '仓库'
                                "></select>
                        </li>
                        <li>
                            <input type="checkbox" uglcw-role="checkbox" uglcw-model="showNoZero"
                                   id="showNoZero" uglcw-value="1">
                            <label style="margin-top: 10px;" class="k-checkbox-label" for="showNoZero">过滤为0的数据</label>

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
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    pageable:{
                        pageSize: 20
                    },
                    url: '${base}manager/stkSfcWare/querySfcPage',
                    criteria: '.form-horizontal',
                    dblclick: function(row){
                    console.log('aa');
                     var query = uglcw.ui.bind('.uglcw-query');
                         var q = {
                            wareId: row.ware_id,
                            sdate: query.sdate,
                            edate: query.edate,
                            billName: '全部',
                            stkId: query.stkId
                         };
                         uglcw.ui.openTab('出入库明细', '${base}manager/queryIoDetail?' + $.map(q, function (v, k) {
                            return k + '=' + (v || '');
                        }).join('&'));
                    },
                    aggregate:[
                     {field: 'qc_qty', aggregate: 'SUM'},
                     {field: 'qc_min_qty', aggregate: 'SUM'},
                     {field: 'qc_amt', aggregate: 'SUM'},
                     {field: 'qm_qty', aggregate: 'SUM'},
                     {field: 'qm_min_qty', aggregate: 'SUM'},
                     {field: 'qm_amt', aggregate: 'SUM'},
                     {field: 'bq_qty', aggregate: 'SUM'},
                     {field: 'bq_amt', aggregate: 'SUM'},
                     {field: 'bq_in_qty', aggregate: 'SUM'},
                     {field: 'bq_in_min_qty', aggregate: 'SUM'},
                        {field: 'bq_in_amt', aggregate: 'SUM'},
                          {field: 'bq_out_qty', aggregate: 'SUM'},
                          {field: 'bq_out_min_qty', aggregate: 'SUM'},
                            {field: 'bq_out_amt', aggregate: 'SUM'},
                              {field: 'in_cgrk_qty', aggregate: 'SUM'},
                                {field: 'in_cgrk_amt', aggregate: 'SUM'},
                                  {field: 'in_cgth_qty', aggregate: 'SUM'},
                                {field: 'in_cgth_amt', aggregate: 'SUM'},
                              {field: 'in_qtrk_qty', aggregate: 'SUM'},
                            {field: 'in_qtrk_amt', aggregate: 'SUM'},
                          {field: 'in_ykrk_qty', aggregate: 'SUM'},
                        {field: 'in_ykrk_amt', aggregate: 'SUM'},
                     {field: 'in_zzrk_qty', aggregate: 'SUM'},
                        {field: 'in_zzrk_amt', aggregate: 'SUM'},
                          {field: 'in_cxrk_qty', aggregate: 'SUM'},
                            {field: 'in_cxrk_amt', aggregate: 'SUM'},
                              {field: 'in_scrk_qty', aggregate: 'SUM'},
                                {field: 'in_scrk_amt', aggregate: 'SUM'},
                                  {field: 'in_llrk_qty', aggregate: 'SUM'},
                                {field: 'in_llrk_amt', aggregate: 'SUM'},
                              {field: 'in_cshrk_qty', aggregate: 'SUM'},
                             {field: 'in_cshrk_amt', aggregate: 'SUM'},
                            {field: 'in_pyrk_qty', aggregate: 'SUM'},
                          {field: 'in_pyrk_amt', aggregate: 'SUM'},
                        {field: 'out_zcxs_qty', aggregate: 'SUM'},
                     {field: 'out_zcxs_amt', aggregate: 'SUM'},
                        {field: 'out_cxzr_qty', aggregate: 'SUM'},
                          {field: 'out_cxzr_amt', aggregate: 'SUM'},
                             {field: 'out_xszr_qty', aggregate: 'SUM'},
                           {field: 'out_xszr_amt', aggregate: 'SUM'},
                         {field: 'out_fyzr_qty', aggregate: 'SUM'},
                       {field: 'out_fyzr_amt', aggregate: 'SUM'},
                     {field: 'out_qtxs_qty', aggregate: 'SUM'},
                      {field: 'out_qtxs_amt', aggregate: 'SUM'},
                       {field: 'out_xsth_qty', aggregate: 'SUM'},
                        {field: 'out_xsth_amt', aggregate: 'SUM'},
                         {field: 'out_lszd_qty', aggregate: 'SUM'},
                          {field: 'out_lszd_amt', aggregate: 'SUM'},
                           {field: 'out_qtck_qty', aggregate: 'SUM'},
                            {field: 'out_qtck_amt', aggregate: 'SUM'},
                             {field: 'out_ykck_qty', aggregate: 'SUM'},
                              {field: 'out_ykck_amt', aggregate: 'SUM'},
                               {field: 'out_zzck_qty', aggregate: 'SUM'},
                                {field: 'out_zzck_amt', aggregate: 'SUM'},
                                 {field: 'out_cxck_qty', aggregate: 'SUM'},
                                  {field: 'out_cxck_amt', aggregate: 'SUM'},
                                   {field: 'out_llck_qty', aggregate: 'SUM'},
                                    {field: 'out_llck_amt', aggregate: 'SUM'},
                                   {field: 'out_bsck_qty', aggregate: 'SUM'},
                                  {field: 'out_bsck_amt', aggregate: 'SUM'},
                                 {field: 'out_jcck_qty', aggregate: 'SUM'},
                                {field: 'out_jcck_amt', aggregate: 'SUM'},
                               {field: 'out_pkck_qty', aggregate: 'SUM'},
                              {field: 'out_pkck_amt', aggregate: 'SUM'},
                            {field: 'out_lyck_qty', aggregate: 'SUM'},
                           {field: 'out_lyck_amt', aggregate: 'SUM'}
                    ],
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
                        <div data-field="ware_nm" uglcw-options="width:150, tooltip:true">商品名称</div>
                        <div data-field="unit_name" uglcw-options="width: 100">单位</div>
                        <div data-field="qc_qty"
                             uglcw-options="width:140,titleAlign:'center',align:'right',
                              template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.qc_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.qc_qty||0),\'n2\')#'">
                            期初数量
                        </div>
                        <div data-field="qc_min_qty"
                             uglcw-options="width:140,hidden:true,titleAlign:'center',align:'right',
                              template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.qc_min_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.qc_min_qty||0),\'n2\')#'">
                            期初数量(小)
                        </div>
                        <div data-field="qc_amt"
                             uglcw-options="width:140,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               footerTemplate: '#=uglcw.util.toString((data.qc_amt||0),\'n2\')#'
                            ">
                            期初金额
                        </div>
                        <div data-field="bq_qty"
                             uglcw-options="width:140,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right'">
                            本期数量
                        </div>
                        <div data-field="bq_in_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                               headerTemplate: uglcw.util.template($('#header_bq_in_qty_title').html()),
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.bq_in_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.bq_in_qty||0),\'n2\')#'">
                            本期入库数量▷
                        </div>
                        <div data-field="bq_in_min_qty"
                             uglcw-options="width:120, hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.bq_in_min_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.bq_in_min_qty||0),\'n2\')#'">
                            本期入库数量(小)
                        </div>
                        <div data-field="bq_in_amt"
                             uglcw-options="width:120,hidden:true,
                              headerTemplate: uglcw.util.template($('#header_bq_in_amt_title').html()),
                             format: '{0:n2}',titleAlign:'center',align:'right',
                              footerTemplate: '#=uglcw.util.toString((data.bq_in_amt||0),\'n2\')#'
                            ">
                            本期入库金额▷
                        </div>
                        <div data-field="in_cgrk_qty"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_cgrk_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_cgrk_qty||0),\'n2\')#'">
                            采购入库
                        </div>
                        <div data-field="in_cgrk_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_cgrk_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_cgrk_amt||0),\'n2\')#'">
                            采购入库金额
                        </div>
                        <div data-field="in_cgth_qty"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_cgth_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_cgth_qty||0),\'n2\')#'">
                            采购退货
                        </div>
                        <div data-field="in_cgth_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_cgth_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_cgth_amt||0),\'n2\')#'">
                            采购退货金额
                        </div>
                        <div data-field="in_qtrk_qty"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_qtrk_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_qtrk_qty||0),\'n2\')#'">
                            其它入库
                        </div>
                        <div data-field="in_qtrk_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_qtrk_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_qtrk_amt||0),\'n2\')#'">
                            其它入库金额
                        </div>
                        <div data-field="in_ykrk_qty"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_ykrk_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_ykrk_qty||0),\'n2\')#'">
                            移库入库
                        </div>
                        <div data-field="in_ykrk_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_ykrk_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_ykrk_amt||0),\'n2\')#'">
                            移库入库金额
                        </div>
                        <div data-field="in_zzrk_qty"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_zzrk_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_zzrk_qty||0),\'n2\')#'">
                            组装入库
                        </div>
                        <div data-field="in_zzrk_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_zzrk_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_zzrk_amt||0),\'n2\')#'">
                            组装入库金额
                        </div>
                        <div data-field="in_cxrk_qty"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_cxrk_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_cxrk_qty||0),\'n2\')#'">
                            拆卸入库
                        </div>
                        <div data-field="in_cxrk_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_cxrk_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_cxrk_amt||0),\'n2\')#'">
                            拆卸入库金额
                        </div>
                        <div data-field="in_scrk_qty"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_scrk_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_scrk_qty||0),\'n2\')#'">
                            生产入库
                        </div>
                        <div data-field="in_scrk_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_scrk_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_scrk_amt||0),\'n2\')#'">
                            生产入库金额
                        </div>
                        <div data-field="in_llrk_qty"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_llrk_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_llrk_qty||0),\'n2\')#'">
                            领料回库
                        </div>
                        <div data-field="in_llrk_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_llrk_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_llrk_amt||0),\'n2\')#'">
                            领料回库金额
                        </div>
                        <div data-field="in_cshrk_qty"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_cshrk_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_cshrk_qty||0),\'n2\')#'">
                            初始化入库
                        </div>
                        <div data-field="in_cshrk_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_cshrk_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_cshrk_amt||0),\'n2\')#'">
                            初始化入库金额
                        </div>
                        <div data-field="in_pyrk_qty"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_pyrk_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_pyrk_qty||0),\'n2\')#'">
                            盘盈
                        </div>
                        <div data-field="in_pyrk_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                               template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.in_pyrk_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.in_pyrk_amt||0),\'n2\')#'">
                            盘盈金额
                        </div>

                        <div data-field="bq_out_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                              headerTemplate: uglcw.util.template($('#header_bq_out_qty_title').html()),
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.bq_out_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.bq_out_qty||0),\'n2\')#'
                             ">
                            本期出库数量▷
                        </div>
                        <div data-field="bq_out_min_qty"
                             uglcw-options="width:140,hidden:true,titleAlign:'center',align:'right',
                              template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.bq_out_min_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.bq_out_min_qty||0),\'n2\')#'">
                            本期出库数量(小)
                        </div>
                        <div data-field="bq_out_amt"
                             uglcw-options="width:120,hidden:true,
                               headerTemplate: uglcw.util.template($('#header_bq_out_amt_title').html()),
                              format: '{0:n2}',titleAlign:'center',align:'right',
                               footerTemplate: '#=uglcw.util.toString((data.bq_out_amt||0),\'n2\')#'
">
                            本期出库金额▷
                        </div>
                        <div data-field="out_zcxs_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_zcxs_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_zcxs_qty||0),\'n2\')#'
                             ">
                            正常销售
                        </div>
                        <div data-field="out_zcxs_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_zcxs_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_zcxs_amt||0),\'n2\')#'
                             ">
                            正常销售金额
                        </div>
                        <div data-field="out_cxzr_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_cxzr_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_cxzr_qty||0),\'n2\')#'
                             ">
                            促销折让
                        </div>
                        <div data-field="out_cxzr_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_cxzr_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_cxzr_amt||0),\'n2\')#'
                             ">
                            促销折让金额
                        </div>
                        <div data-field="out_xszr_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_xszr_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_xszr_qty||0),\'n2\')#'
                             ">
                            消费折让
                        </div>
                        <div data-field="out_xszr_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_xszr_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_xszr_amt||0),\'n2\')#'
                             ">
                            消费折让金额
                        </div>
                        <div data-field="out_fyzr_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_fyzr_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_fyzr_qty||0),\'n2\')#'
                             ">
                            费用折让
                        </div>
                        <div data-field="out_fyzr_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_fyzr_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_fyzr_amt||0),\'n2\')#'
                             ">
                            费用折让金额
                        </div>
                        <div data-field="out_qtxs_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_qtxs_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_qtxs_qty||0),\'n2\')#'
                             ">
                            其他销售
                        </div>
                        <div data-field="out_qtxs_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_qtxs_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_qtxs_amt||0),\'n2\')#'
                             ">
                            其他销售金额
                        </div>
                        <div data-field="out_xsth_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_xsth_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_xsth_qty||0),\'n2\')#'
                             ">
                            销售退货
                        </div>
                        <div data-field="out_xsth_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_xsth_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_xsth_amt||0),\'n2\')#'
                             ">
                            销售退货金额
                        </div>
                        <div data-field="out_lszd_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_lszd_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_lszd_qty||0),\'n2\')#'
                             ">
                            终端零售
                        </div>
                        <div data-field="out_lszd_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_lszd_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_lszd_amt||0),\'n2\')#'
                             ">
                            终端零售金额
                        </div>
                        <div data-field="out_qtck_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_qtck_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_qtck_qty||0),\'n2\')#'
                             ">
                            其它出库
                        </div>
                        <div data-field="out_qtck_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_qtck_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_qtck_amt||0),\'n2\')#'
                             ">
                            其它出库金额
                        </div>
                        <div data-field="out_ykck_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_ykck_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_ykck_qty||0),\'n2\')#'
                             ">
                            移库出库
                        </div>
                        <div data-field="out_ykck_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_ykck_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_ykck_amt||0),\'n2\')#'
                             ">
                            移库出库金额
                        </div>
                        <div data-field="out_zzck_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_zzck_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_zzck_qty||0),\'n2\')#'
                             ">
                            组装出库
                        </div>
                        <div data-field="out_zzck_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_zzck_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_zzck_amt||0),\'n2\')#'
                             ">
                            组装出库金额
                        </div>
                        <div data-field="out_cxck_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_cxck_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_cxck_qty||0),\'n2\')#'
                             ">
                            拆卸出库
                        </div>
                        <div data-field="out_cxck_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_cxck_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_cxck_amt||0),\'n2\')#'
                             ">
                            拆卸出库金额
                        </div>
                        <div data-field="out_llck_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_llck_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_llck_qty||0),\'n2\')#'
                             ">
                            领料出库
                        </div>
                        <div data-field="out_llck_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_llck_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_llck_amt||0),\'n2\')#'
                             ">
                            领料出库金额
                        </div>
                        <div data-field="out_bsck_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_bsck_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_bsck_qty||0),\'n2\')#'
                             ">
                            报损出库
                        </div>
                        <div data-field="out_bsck_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_bsck_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_bsck_amt||0),\'n2\')#'
                             ">
                            报损出库金额
                        </div>
                        <div data-field="out_jcck_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_jcck_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_jcck_qty||0),\'n2\')#'
                             ">
                            借出出库
                        </div>
                        <div data-field="out_jcck_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_jcck_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_jcck_amt||0),\'n2\')#'
                             ">
                            借出出库金额
                        </div>
                        <div data-field="out_pkck_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_pkck_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_pkck_qty||0),\'n2\')#'
                             ">
                            盘亏
                        </div>
                        <div data-field="out_pkck_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_pkck_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_pkck_amt||0),\'n2\')#'
                             ">
                            盘亏金额
                        </div>
                        <div data-field="out_lyck_qty"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_lyck_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_lyck_qty||0),\'n2\')#'
                             ">
                            领用出库
                        </div>
                        <div data-field="out_lyck_amt"
                             uglcw-options="width:120, format: '{0:n2}',titleAlign:'center',align:'right',
                             hidden:true,
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.out_lyck_amt})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.out_lyck_amt||0),\'n2\')#'
                             ">
                            领用出库金额
                        </div>
                        <div data-field="qm_qty"
                             uglcw-options="width:120,format: '{0:n2}',titleAlign:'center',align:'right',
                             template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.qm_qty})
							  },
                            footerTemplate: '#=uglcw.util.toString((data.qm_qty||0),\'n2\')#'
                            ">
                            期末数量
                        </div>
                        <div data-field="qm_min_qty"
                             uglcw-options="width:140,hidden:true,titleAlign:'center',align:'right',
                              template:function(row){
									return uglcw.util.template($('#formatterNum').html())({val:row.qm_min_qty})
							  },
                             footerTemplate: '#=uglcw.util.toString((data.qm_min_qty||0),\'n2\')#'">
                            期末数量(小)
                        </div>
                        <div data-field="qm_amt"
                             uglcw-options="width:120,hidden:true, format: '{0:n2}',titleAlign:'center',align:'right',
                              footerTemplate: '#=uglcw.util.toString((data.qm_amt||0),\'n2\')#'
                            ">
                            期末金额
                        </div>
                        <div data-field=""
                             uglcw-options="
                            ">
                            &nbsp;
                        </div>
                        <%--<div data-field="bq_amt"--%>
                             <%--uglcw-options="width:140, format: '{0:n2}',titleAlign:'center',align:'right'">--%>
                            <%--本期金额--%>
                        <%--</div>--%>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script id="header_bq_in_qty_title" type="text/x-uglcw-template">
    <span onclick="javascript:filterColumn('bq_in_qty');">本期入库数量<span style="color:blue;font-weight: bold">▷</span><div style="display: none"><input type="checkbox" id="bq_in_qty_chk"></div></span>
</script>
<script id="header_bq_in_amt_title" type="text/x-uglcw-template">
    <span onclick="javascript:filterColumn('bq_in_amt');">本期入库金额<span style="color:blue;font-weight: bold">▷</span><div style="display: none"><input style="display: none" type="checkbox" id="bq_in_amt_chk"></div></span>
</script>
<script id="header_bq_out_qty_title" type="text/x-uglcw-template">
    <span onclick="javascript:filterColumn('bq_out_qty');">本期出库数量<span style="color:blue;font-weight: bold">▷</span><div style="display: none"><input style="display: none" type="checkbox" id="bq_out_qty_chk"></div></span>
</script>
<script id="header_bq_out_amt_title" type="text/x-uglcw-template">
    <span onclick="javascript:filterColumn('bq_out_amt');">本期出库金额<span style="color:blue;font-weight: bold">▷</span><div style="display: none"><input style="display: none" type="checkbox" id="bq_out_amt_chk"></div></span>
</script>

<script type="text/x-kendo-template" id="toolbar">
    <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <input id="showDataRadio1" class="k-radio" type="radio" onclick="javascript:filterData(1);" checked name="showDataRadio" value="1"/><label class="k-radio-label" for="showDataRadio1">只显示数量</label>
    <input id="showDataRadio2" type="radio"  class="k-radio" onclick="javascript:filterData(2);"  name="showDataRadio" value="2"/><label class="k-radio-label" for="showDataRadio2">只显示金额</label>
    <input id="showDataRadio3" type="radio"  class="k-radio" onclick="javascript:filterData(3);"  name="showDataRadio" value="3"/><label class="k-radio-label" for="showDataRadio3">显示数量与金额</label>
    <input type="checkbox" class="k-checkbox" onclick="minQuantityToggle();" uglcw-role="checkbox" uglcw-model="showMinQuantity" id="showMinQuantity">
    <label style="margin-left: 10px;" class="k-checkbox-label" for="showMinQuantity">小单位数量</label>
</script>
<script type="text/x-kendo-template" id="formatterNum">
<%--    #var sumQty =  Math.floor(val * 100)/100;#--%>
<%--    #sumQty = sumQty;#--%>
<%--    #var rtn = sumQty; #--%>
<%--    #if(rtn==0){rtn=""}#--%>
<%--    #= (rtn)#--%>
    #= uglcw.util.toString(val,'n2')#
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var filterDataType = 1;

    $(function () {
        uglcw.ui.init();
        uglcw.layout.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#gird').reload();
        })
        uglcw.ui.loaded()
    })

    function filterData(v){
        filterDataType = v;
        var grid = uglcw.ui.get('#grid');
            if(v==1){
                grid.showColumn('qc_qty');
                grid.showColumn('bq_in_qty');
                grid.showColumn('bq_out_qty');
                grid.showColumn('qm_qty');

                grid.hideColumn('qc_amt');
                grid.hideColumn('bq_in_amt');
                grid.hideColumn('bq_out_amt');
                grid.hideColumn('qm_amt');

                hiddenSubOutAmt(grid);
                hiddenSubInAmt(grid);
            }else if(v==2){
                grid.showColumn('qc_amt');
                grid.showColumn('bq_in_amt');
                grid.showColumn('bq_out_amt');
                grid.showColumn('qm_amt');

                grid.hideColumn('qc_qty');
                grid.hideColumn('bq_in_qty');
                grid.hideColumn('bq_out_qty');
                grid.hideColumn('qm_qty');

                hiddenSubOutQty(grid);
                hiddenSubInQty(grid);
            }else if(v==3){
                grid.showColumn('qc_qty');
                grid.showColumn('bq_in_qty');
                grid.showColumn('bq_out_qty');
                grid.showColumn('qm_qty');
                grid.showColumn('qc_amt');
                grid.showColumn('bq_in_amt');
                grid.showColumn('bq_out_amt');
                grid.showColumn('qm_amt');
            }

        minQuantityToggle()
    }

    function minQuantityToggle() {
        var minQuantityShow = $("#showMinQuantity").is(':checked');
        var grid = uglcw.ui.get('#grid');
        if (!minQuantityShow || filterDataType == 2) {
            grid.hideColumn('qc_min_qty');
            grid.hideColumn('bq_in_min_qty');
            grid.hideColumn('bq_out_min_qty');
            grid.hideColumn('qm_min_qty');
        } else {
            grid.showColumn('qc_min_qty');
            grid.showColumn('bq_in_min_qty');
            grid.showColumn('bq_out_min_qty');
            grid.showColumn('qm_min_qty');
        }
    }

    function filterColumn(field){
        var grid = uglcw.ui.get('#grid');
        var chk=$('#'+field+"_chk").is(':checked');
        if(chk){
            $('#'+field+"_chk").prop("checked",false);
        }else{
            $('#'+field+"_chk").prop("checked",true);
        }
        if(field=='bq_in_qty'){
            if(!chk){
                showSubInQty(grid);
            }else{
                hiddenSubInQty(grid);
            }
        }else if(field=='bq_in_amt'){
            if(!chk){
                showSubInAmt(grid);
            }else{
                hiddenSubInAmt(grid);
            }

        }else if(field=='bq_out_qty'){
            if(!chk){
                showSubOutQty(grid);
            }else{
                hiddenSubOutQty(grid);
            }
        }else if(field=='bq_out_amt'){
            if(!chk){
                showSubOutAmt(grid);
            }else{
                hiddenSubOutAmt(grid);
            }
        }
    }

    function showSubInQty(grid) {
        grid.showColumn('in_cgrk_qty');
        grid.showColumn('in_cgth_qty');
        grid.showColumn('in_qtrk_qty');
        grid.showColumn('in_ykrk_qty');
        grid.showColumn('in_zzrk_qty');
        grid.showColumn('in_cxrk_qty');
        grid.showColumn('in_scrk_qty');
        grid.showColumn('in_llrk_qty');
        grid.showColumn('in_cshrk_qty');
        grid.showColumn('in_pyrk_qty');
    }
    function hiddenSubInQty(grid) {
        grid.hideColumn('in_cgrk_qty');
        grid.hideColumn('in_cgth_qty');
        grid.hideColumn('in_qtrk_qty');
        grid.hideColumn('in_ykrk_qty');
        grid.hideColumn('in_zzrk_qty');
        grid.hideColumn('in_cxrk_qty');
        grid.hideColumn('in_scrk_qty');
        grid.hideColumn('in_llrk_qty');
        grid.hideColumn('in_cshrk_qty');
        grid.hideColumn('in_pyrk_qty');
    }

    function showSubInAmt(grid) {
        grid.showColumn('in_cgrk_amt');
        grid.showColumn('in_cgth_amt');
        grid.showColumn('in_qtrk_amt');
        grid.showColumn('in_ykrk_amt');
        grid.showColumn('in_zzrk_amt');
        grid.showColumn('in_cxrk_amt');
        grid.showColumn('in_scrk_amt');
        grid.showColumn('in_llrk_amt');
        grid.showColumn('in_cshrk_amt');
        grid.showColumn('in_pyrk_amt');
    }
    function hiddenSubInAmt(grid) {
        grid.hideColumn('in_cgrk_amt');
        grid.hideColumn('in_cgth_amt');
        grid.hideColumn('in_qtrk_amt');
        grid.hideColumn('in_ykrk_amt');
        grid.hideColumn('in_zzrk_amt');
        grid.hideColumn('in_cxrk_amt');
        grid.hideColumn('in_scrk_amt');
        grid.hideColumn('in_llrk_amt');
        grid.hideColumn('in_cshrk_amt');
        grid.hideColumn('in_pyrk_amt');
    }

    function showSubOutQty(grid) {
        grid.showColumn('out_zcxs_qty');
        grid.showColumn('out_cxzr_qty');
        grid.showColumn('out_xszr_qty');
        grid.showColumn('out_fyzr_qty');
        grid.showColumn('out_qtxs_qty');
        grid.showColumn('out_xsth_qty');
        grid.showColumn('out_lszd_qty');
        grid.showColumn('out_qtck_qty');
        grid.showColumn('out_ykck_qty');
        grid.showColumn('out_zzck_qty');
        grid.showColumn('out_cxck_qty');
        grid.showColumn('out_llck_qty');
        grid.showColumn('out_bsck_qty');
        grid.showColumn('out_jcck_qty');
        grid.showColumn('out_pkck_qty');
        grid.showColumn('out_lyck_qty');
    }

    function hiddenSubOutQty(grid) {
        grid.hideColumn('out_zcxs_qty');
        grid.hideColumn('out_cxzr_qty');
        grid.hideColumn('out_xszr_qty');
        grid.hideColumn('out_fyzr_qty');
        grid.hideColumn('out_qtxs_qty');
        grid.hideColumn('out_xsth_qty');
        grid.hideColumn('out_lszd_qty');
        grid.hideColumn('out_qtck_qty');
        grid.hideColumn('out_ykck_qty');
        grid.hideColumn('out_zzck_qty');
        grid.hideColumn('out_cxck_qty');
        grid.hideColumn('out_llck_qty');
        grid.hideColumn('out_bsck_qty');
        grid.hideColumn('out_jcck_qty');
        grid.hideColumn('out_pkck_qty');
        grid.hideColumn('out_lyck_qty');
    }
    function showSubOutAmt(grid) {
        grid.showColumn('out_zcxs_amt');
        grid.showColumn('out_cxzr_amt');
        grid.showColumn('out_xszr_amt');
        grid.showColumn('out_fyzr_amt');
        grid.showColumn('out_qtxs_amt');
        grid.showColumn('out_xsth_amt');
        grid.showColumn('out_lszd_amt');
        grid.showColumn('out_qtck_amt');
        grid.showColumn('out_ykck_amt');
        grid.showColumn('out_zzck_amt');
        grid.showColumn('out_cxck_amt');
        grid.showColumn('out_llck_amt');
        grid.showColumn('out_bsck_amt');
        grid.showColumn('out_jcck_amt');
        grid.showColumn('out_pkck_amt');
        grid.showColumn('out_lyck_amt');
    }
    function hiddenSubOutAmt(grid) {
        grid.hideColumn('out_zcxs_amt');
        grid.hideColumn('out_cxzr_amt');
        grid.hideColumn('out_xszr_amt');
        grid.hideColumn('out_fyzr_amt');
        grid.hideColumn('out_qtxs_amt');
        grid.hideColumn('out_xsth_amt');
        grid.hideColumn('out_lszd_amt');
        grid.hideColumn('out_qtck_amt');
        grid.hideColumn('out_ykck_amt');
        grid.hideColumn('out_zzck_amt');
        grid.hideColumn('out_cxck_amt');
        grid.hideColumn('out_llck_amt');
        grid.hideColumn('out_bsck_amt');
        grid.hideColumn('out_jcck_amt');
        grid.hideColumn('out_pkck_amt');
        grid.hideColumn('out_lyck_amt');
    }

</script>
</body>
</html>
