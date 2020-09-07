<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>业务员提成计算表</title>
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
        .uglcw-query>li.xs-tp #billName_taglist {
            position: fixed;
            text-overflow: ellipsis;
            white-space: nowrap;
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
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-model="outType" id="outType" uglcw-role="combobox" uglcw-options="
                     placeholder:'出库类型',
                     change: function(){
                        uglcw.ui.get('#billName').k().dataSource.read();
                     }">
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>
                    </select>
                </li>
                <li style="width: 180px!important;" class="xs-tp">
                    <input id="billName" uglcw-role="multiselect" uglcw-model="billName" uglcw-options="
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
                <%--<li>--%>
                    <%--<select uglcw-model="billName" uglcw-options="placeholder: '销售类型'" id="xsTp" uglcw-role="combobox">--%>
                        <%--<option value="正常销售"selected>正常销售</option>--%>
                        <%--<option value="促销折让">促销折让</option>--%>
                        <%--<option value="消费折让">消费折让</option>--%>
                        <%--<option value="费用折让">费用折让</option>--%>
                        <%--<option value="其他销售">其他销售</option>--%>
                        <%--<option value="其它出库">其它出库</option>--%>
                        <%--<option value="借用出库">借用出库</option>--%>
                        <%--<option value="领用出库">领用出库</option>--%>
                        <%--<option value="报损出库">报损出库</option>--%>
                        <%--<option value="销售退货">销售退货</option>--%>
                    <%--</select>--%>
                <%--</li>--%>
                <li>
                    <input uglcw-role="textbox" uglcw-model="driverName" placeholder="业务员"/>
                </li>

 <%--               <li>
                    <select uglcw-model="isType" uglcw-role="combobox"
                            uglcw-options="placeholder:'资产类型',
                                      change: function(){
                                        uglcw.ui.get('#wtype').k().dataSource
                                     }
                                "
                            id="isType">
                        <option value="0">库存商品类</option>
                        <option value="1">原辅材料类</option>
                        <option value="2">低值易耗品类</option>
                        <option value="3">固定资产类</option>
                    </select>
                </li>
                <li>
                    <input uglcw-role="gridselector" placeholder="商品类别" uglcw-model="wtypename,wtype" uglcw-options="

                            click: function(){
                                var  isType=uglcw.ui.get('#isType').value();
                                uglcw.ui.Modal.showTreeSelector({
                                offset: 200,
                                selection:'single',
                                area: ['200px', '300px'],
                                url: '${base}manager/companyWaretypes?isType='+isType,
											dataTextField: 'text',
											dataValueField: 'id',
											yes:function(node){
                                                if(node.length>0){
                                                    uglcw.ui.bind('.uglcw-query',{
                                                        wtypename: node[0].text,
                                                        wtype: node[0].id
                                                    })
                                                }
											}
                                })
                            }
                    ">
                </li>--%>
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="0" id="isType">
                    <input  style="display:block;" uglcw-role="gridselector" uglcw-model="wtypename,wtype" id="wtype" placeholder="资产类型"
                            uglcw-options="
                            value:'库存商品类',
                            click:function(){
                                waretype()
                            }

                        "
                    >
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="品名"/>
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
                    autoBind: false,
                    responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/querySaleTotalStatPage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    aggregate:[
                     {field: 'outQty', aggregate: 'sum'}
                    ],
                    dblclick: function(row){
                        var q = uglcw.ui.bind('.form-horizontal');
                        q.driverName = row.driverName;
                        uglcw.ui.openTab('业务员客户统计表', '${base}manager/querySaleCustomerStat?'+ $.map(q, function(v, k){
                            return k+'='+(v||'');
                        }).join('&'));
                    },
                    loadFilter: {
                      data: function (response) {
                        if(!response || !response.rows || response.rows.length <1){
                            return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            outQty:0,
                            ioPrice:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="driverName" uglcw-options="">业务员</div>
                <div data-field="outQty"
                     uglcw-options="format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.outQty.sum != undefined ? data.outQty.sum : data.outQty,\'n2\')#'">
                    发货数量
                </div>
                <div data-field="ioPrice"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.ioPrice || 0, \'n2\')#'">
                    配送费用
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
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toRptData();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>业务员客户销售统计表
    </a>
    <a role="button" href="javascript:queryRpt();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>查看生成的报表
    </a>
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
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}',isType:'',wtypename:'',wtype:''});
        })
        $('#wtype').on('change',function () {
            if(!uglcw.ui.get('#wtype').value()){
                uglcw.ui.clear('.form-horizontal',{isType:''},{excludeHidden: false})
                //uglcw.ui.bind('.form-horizontal', {isType: ''})  //清空当前id为wtype搜索框内容

            }

        })
        uglcw.ui.loaded()
    })


    function showMainDetail() {
        var q = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('查看客户毛利明细', '${base}manager/queryCstStatDetailList?' + $.map(q, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function exportExcel() {
    }

    function toRptData() {
        var query = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('业务员销售客户统计表', "${base}manager/querySaleCustomerStat?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function queryRpt() {
        uglcw.ui.openTab('业务员销售客户生成的统计表', '${base}manager/querySaveRptDataStat?rptType=2');
    }

    function waretype() {
      var i= uglcw.ui.Modal.open({
          checkbox: true,
          selection: 'single',
          title: false,
          maxmin: false,
          resizable: false,
          move: true,
          btns: ['确定', '取消'],
          area: ['400', '415px'],
          content: $('#product-type-selector-template').html(),
          success:function (c) {
              uglcw.ui.init(c);
              
          },
          yes:function (c) {
              uglcw.ui.get('#wtype').value(uglcw.ui.get($(c).find('#wtypename')).value());
              uglcw.ui.get('#wtype').text(uglcw.ui.get($(c).find('#_type_id')).value());
              uglcw.ui.get('#isType').value(uglcw.ui.get($(c).find("#_isType")).value());
              uglcw.ui.Modal.close(i);
              return false;

          }
        })
        
    }
</script>
</body>
</html>
