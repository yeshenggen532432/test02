<%@ page pageEncoding="UTF-8" %>
<ul id="grid-menu"></ul>
<script type="text/x-uglcw-template" id="product-code-tpl">
    <div class="product-code">
        <span>#= data.wareCode || ''#</span>
        # if(data.wareId) {#
        <span onclick="showHistoryPrices(this)" class="k-icon k-i-clock product-code-tooltip"
              style="font-weight: bold;color: \\#1c77f0;"></span>
        #}#
    </div>
</script>
<script type="text/x-uglcw-template" id="product-date-tpl">
    <div class="product-code">
        <span>#= data.productDate || ''#</span>
        # if(data.wareId) {#
        <span onclick="showRelatedProductDate(this)" class="product-date-tooltip"
              style="font-weight: bold;color: \\#1c77f0;">关联</span>
        #}#
    </div>
</script>
<script type="text/x-uglcw-template" id="autocomplete-template">
    <div><span>#= data.wareNm#</span><span style="float: right">#= data.wareGg#</span></div>
</script>
<script type="text/x-uglcw-template" id="customer-no-result-tpl">
    <div>
        #if(xsfpQuickBill === ''){#
        <div>
            未找到相关客户。是否立即添加 <span style="color: red;">#: instance.element.val()#</span>？
        </div>
        <br/>
        <button class="k-button k-primary" onclick="quickAddNewCustomer('#: instance.element.val()#')">
            <i class="k-icon k-i-plus"></i>立即添加
        </button>
        #} else { #
        <div>
            未找到相关客户:<span style="color: red;">#: instance.element.val()#</span>
        </div>
        #}#
    </div>
</script>
<script type="text/x-uglcw-template" id="product-no-result-tpl">
    <div>
        <div>
            未找到商品<span style="color: red;">#= value#</span>。是否立即添加？
        </div>
        <br/>
        <button class="k-button k-primary" onclick="addProductOnNoFound('#= value#')">
            <i class="k-icon k-i-plus"></i>立即添加
        </button>
    </div>
</script>
<script type="text/x-uglcw-template" id="add-product-tpl">
    <div class="add-product-form" uglcw-role="validator">
        <div uglcw-role="tabs">
            <ul>
                <li>基础信息</li>
                <li>附加信息</li>
            </ul>
            <div>
                <div class="form-group">
                    <div class="form-item-flex" ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_WARE_AUTO_CODE\"  and status=1") eq 'none'?"style='display:none'":''}>
                        <label class="control-label">商品编号</label>
                        <div class="form-input">
                            <input uglcw-model="wareCode" uglcw-role="textbox" placeholder="自动生成"/>
                        </div>
                    </div>
                    <label class="control-label required">商品名称</label>
                    <div class="form-input">
                        <input uglcw-validate="required" uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label">单位名称</label>
                    <div class="form-input">
                        <input uglcw-model="wareDw" uglcw-role="textbox" placeholder="单位名称"/>
                    </div>
                    <label class="control-label">规&nbsp;&nbsp;&nbsp;&nbsp;格</label>
                    <div class="form-input">
                        <input uglcw-model="wareGg" uglcw-role="textbox" placeholder="规格"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label">商品类别</label>
                    <div class="form-input">
                        <input uglcw-model="waretype" uglcw-role="dropdowntree" placeholder="商品类别"
                               uglcw-options="
                               url: '${base}manager/syswaretypes',
                               autoWidth: true,
                               select: function(e){
                                var node = this.dataItem(e.node);
                                if(node.hasChildren){
                                    uglcw.ui.warning('请选择末端分类');
                                    e.preventDefault();
                                }
                               }
                            "
                        />
                    </div>
                    <label class="control-label">成本价</label>
                    <div class="form-input">
                        <input uglcw-model="inPrice" uglcw-role="numeric" placeholder="成本价"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label">销售价</label>
                    <div class="form-input">
                        <input uglcw-model="wareDj" uglcw-role="numeric" placeholder="销售价"/>
                    </div>
                    <label class="control-label">销售数量</label>
                    <div class="form-input">
                        <input uglcw-model="initQty" uglcw-role="numeric" placeholder="销售数量"/>
                    </div>
                </div>
            </div>
            <div>
                <div class="form-group">
                    <label class="control-label" style="width: 100px;">小单位名称</label>
                    <div class="form-input">
                        <input uglcw-model="minUnit" uglcw-role="textbox"
                               placeholder="小单位名称"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label" style="width: 100px;">大小单位换算比例</label>
                    <div class="form-input" style="width: 50px;">
                        <input uglcw-model="bUnit" value="1" disabled uglcw-role="numeric" placeholder="大单位"/>
                    </div>
                    <span class="control-label" style="width: 50px;">大单位=</span>
                    <div class="form-input" style="width: 50px;">
                        <input uglcw-model="sUnit" value="" uglcw-role="numeric" placeholder="小单位"/>
                    </div>
                    <span class="control-label" style="width: 40px;">小单位</span>
                </div>
            </div>
        </div>
    </div>
</script>
<tag:compositive-selector-template index="2"/>
<tag:product-out-selector-template  query="onQueryProduct"/>
<script id="wareinprice-setting-tpl" type="text/x-uglcw-template">
    <div uglcw-role="grid"
         uglcw-options="
            url: '${base}manager/getWareByIds?ids=#= ids#',
            rowNumber: true,
            height: 300,
            editable: true,
            autoAppendRow: false
        "
    >
        <div data-field="wareNm" uglcw-options="width: 'auto'">商品名称</div>
        <div data-field="inPrice" uglcw-options="width: 'auto',format:'{0:n2}', schema:{type:'number'}">采购价</div>
    </div>
</script>
<script id="bill-version-tpl" type="text/x-uglcw-template">
    <c:if test="${not empty verList}">
        <c:forEach items="${verList}" var="v">
            <p onclick="uglcw.ui.openTab('销售发票版本记录', '${base}manager/showstkoutversion?billId=${v.id}')">${v.relaTime}</p>
        </c:forEach>
    </c:if>
</script>
<script id="accDlg" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="col-xs-8 control-label required">收款账号</label>
                    <div class="col-xs-12">
                        <tag:select2 validate="required" name="accId" id="accId" tableName="fin_account" headerKey=""
                                     whereBlock="status=0"
                                     headerValue="--请选择--" displayKey="id" displayValue="acc_name" value="${defaultAcc}"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-xs-8 control-label required">收款金额</label>
                    <div class="col-xs-12">
                        <input uglcw-role="numeric" uglcw-model="recAmt">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-xs-8 control-label required">是否自动发货</label>
                    <div class="col-xs-12">
                        <ul uglcw-role="radio" uglcw-model="autoSend"
                            uglcw-value="1"
                            uglcw-options='layout:"horizontal",
                                                             dataSource:[{"text":"是","value":"1"},{"text":"否","value":"2"}]
                                                 '></ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<script id="reAuditDlg" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="col-xs-6">发货日期</label>
                    <div class="col-xs-18">
                        <input
                               uglcw-options="format: 'yyyy-MM-dd HH:mm'"
                               uglcw-role="datetimepicker" uglcw-model="sendTime"
                               value="${sendTime}">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<script id="stock-info-tpl" type="text/x-uglcw-template">
    <div style="text-align: left">
        <label>实际库存</label>：[<span id="stkQty" class="actual-stock">#= data.stkQty#</span>]<br>
        #if(data.showBlockQty){#
        <label>占用库存</label>：[<span id="occQty" class="block-stock">#= data.occQty#</span>]<br>
        #}#
        <label>虚拟库存</label>：[<span id="xnQty" class="virtual-stock">#= data.xnQty#</span>]
    </div>
</script>
<script id="price-tpl" type="text/x-uglcw-template">
    <div style="text-align: left">
        <label>历史价</label>：[<span id="hisPrice" style="color:red;" class="history-price">#= uglcw.util.toString((data.hisPrice||0)/data.hsNum, 'n2')#</span>]<br>
        <label>执行价</label>：[<span style="margin-right: 2px;color: red;" id="zxPrice" class="strike-price">#= uglcw.util.toString((data.zxPrice||0)/data.hsNum, 'n2')#</span>]<br>
        <label>商品价</label>：[<span id="orgPrice" style="color:red;" class="sale-price">#= uglcw.util.toString((data.orgPrice||0)/data.hsNum, 'n2')#</span>]<br>
        <div ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_SALE_SHOW_INPRICE\"  and status=1") eq 'none'?'style="display:none"':""}>
            <label>成本价</label>：[<span id="inPrice" style="color:red;" class="cost-price">#= uglcw.util.toString((data.inPrice||0)/data.hsNum, 'n2')#</span>]<br>
        </div>
        #if(data.orgPrice && data.status != -2){#
        <div><label>上次售价</label>：[<span style="color:red;">#= uglcw.util.toString(data.orgPrice, 'n2')#</span>]</div>
        #}#
    </div>
</script>
<script id="help-info-tpl" type="text/x-uglcw-template">
    <table class="layui-table" lay-skin="line" lay-size="sm">
        <colgroup>
            <col width="250">
            <col width="200">
            <col>
            <col>
        </colgroup>
        <tbody>
        <tr>
            <td>空格(SPACE)</td>
            <td>切换当前行单位</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>F2</td>
            <td>快速添加行</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>CTRL+空格(CTRL+SPACE)</td>
            <td>隐藏/展开主表信息</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>CTRL+向上(CTRL+↑)</td>
            <td>商品表格最大化</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>CTRL+向下(CTRL+↓)</td>
            <td>取消商品表格最大化</td>
            <td></td>
            <td></td>
        </tr>
        </tbody>
    </table>
</script>
<script id="column-setting-checkbox-tpl" type="text/x-uglcw-template">
    <input
            #if(data.reserved){#
            disabled
            #}#
            #if(!data.hidden){#
            checked
            #}#
            class="k-checkbox" id="#=data.uid#" onchange="onCheckboxChange(this)" type="checkbox">
    <label for="#= data.uid#" class="bill-setting-checkbox k-checkbox-label k-no-text"></label>
</script>
<script id="custom-settings-tpl" type="text/x-uglcw-template">
    <div class="bill-custom-settings uglcw-layout-container">
        <div class="uglcw-layout-content">
            <div class="layui-card">
                <div uglcw-role="tabs">
                    <ul>
                        <li>明细设置</li>
                        <li>主表设置</li>
                        <li>附加项配置</li>
                    </ul>
                    <div>
                        <div data-type="1" data-name="slave" class="grid-slave" uglcw-role="grid" uglcw-options="
                         draggable: true,
                         editable: true,
                         id: 'id',
                         height: 300,
                         rowNumber: true,
                         autoAppendRow: false,
                         lockable:false
                        ">
                            <div data-field="checkbox" uglcw-options="
                            width: 60,
                            attributes: { class: 'column-checkbox'},
                            template: uglcw.util.template($('#column-setting-checkbox-tpl').html())
                            ">显示
                            </div>
                            <div data-field="title" uglcw-options="
                                     headerTemplate: '字段名<span style=\'color: red;\'>(拖动排序↑↓)</span>'
                                "></div>
                            <div data-field="width" uglcw-options="schema:{type:'number'}">列宽</div>
                        </div>
                    </div>
                    <div>
                        <div data-type="0" data-name="master" class="grid-master" uglcw-role="grid" uglcw-options="
                            editable: true,
                            draggable: true,
                            id: 'id',
                            autoAppendRow: false,
                            lockable:false,
                            height: 300,
                        ">
                            <div data-field="checkbox" uglcw-options="
                            width: 60,
                            attributes: { class: 'column-checkbox'},
                            template: uglcw.util.template($('#column-setting-checkbox-tpl').html())
                            ">显示
                            </div>
                            <div data-field="title"  uglcw-options="
                                    headerTemplate: '字段名<span style=\'color: red;\'>(拖动排序↑↓)</span>'
                                "></div>
                        </div>
                    </div>
                    <div>
                        <div data-type="2" data-name="other" class="grid-other" uglcw-role="grid" uglcw-options="
                            height: 300,
                            id: 'id',
                        ">
                            <div data-field="checkbox" uglcw-options="
                            width: 60,
                            attributes: { class: 'column-checkbox'},
                            template: uglcw.util.template($('#column-setting-checkbox-tpl').html())
                            ">启用
                            </div>
                            <div data-field="title">选项名</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script id="unit-tpl" type="text/x-uglcw-template">
    #= data.beUnit == data.maxUnitCode ? data.wareDw||'' : data.minUnit||'' #
</script>
<script id="footer-sum-tpl" type="text/x-uglcw-template">
    #= uglcw.util.toString((data.sum || 0), 'n2')#
</script>
<script id="slave-tpl" type="text/x-uglcw-template">
    <div data-field="wareCode" uglcw-options="
                            width: #= data.wareCode.width#,
                            hidden: #= data.wareCode.hidden#,
                            filterable:{ multi: true, search: true},
                            template: uglcw.util.template($('\\#product-code-tpl').html()),
                        ">产品编号
    </div>
    <div data-field="packBarCode" uglcw-options="
                            width: #= data.packBarCode && (data.packBarCode.width || 100) #,
                            hidden: #= data.packBarCode && data.packBarCode.hidden #,
                            filterable:{ multi: true, search: true},
                        ">大单位条码
    </div>
    <div data-field="beBarCode" uglcw-options="
                            width: #= data.beBarCode && (data.beBarCode.width || 100)#,
                            hidden: #= data.beBarCode && data.beBarCode.hidden#,
                        ">小单位条码
    </div>
    <div data-field="wareNm" uglcw-options="
                            width: #= data.wareNm.width#,
                            hidden: #= data.wareNm.hidden#,
                            locked: false,
                            tooltip: true,
                            align: 'left',
                            titleAlign: 'center',
                            attributes:{
                                class: 'cell-product-name uglcw-cell-speedy'
                            },
                            schema: {
                                validation:{
                                    required: true,
                                    warenmvalidation: function(input){
                                        if(input.is('[data-model=wareNm]')){
                                            input.closest('td').find('.warenmvalidation').attr('data-warenmvalidation-msg', '请选择商品');
                                            var row = uglcw.ui.get('\\#grid').k().dataItem(input.closest('tr'));
                                            if(!row.wareId){
                                                  var k = layer.tips('请选择商品', $(input.closest('td')), {
                                                        maxWidth: 300,
                                                        tips: 1
                                                  });
                                                  setTimeout(function(){
                                                      layer.close(k)
                                                  }, 1000)
                                                return true
                                            }
                                            return true;
                                        }
                                        return true;
                                    }
                                }
                            },
                            filterable:{ multi: true, search: true},
                            footerTemplate: '合计： ',
                            editor: productNameEditor">产品名称
    </div>

    <div data-field="wareGg" uglcw-options=" width: #= data.wareGg.width#,
                            hidden: #= data.wareGg.hidden#, editable: false">产品规格
    </div>
    <div data-field="xsTp" uglcw-options="width: #= data.xsTp.width#,
                            hidden: #= data.xsTp.hidden#, editor: xsTpEditor">销售类型
    </div>
    <div data-field="beUnit" uglcw-options="
                            width: #= data.beUnit.width#,
                            hidden: #= data.beUnit.hidden#,
                            attributes: {class: 'k-dirty-cell'},
                            template: function(data){
                                return (data.beUnit == data.maxUnitCode ? data.wareDw : data.minUnit) || '';
                            },
                            editor: beUnitEditor
                        ">单位
    </div>
    <c:if test="${permission:checkUserFieldPdm('stk.stkOut.lookqty')}">
        <div data-field="qty" uglcw-options="  width: #= data.qty.width#,
                            hidden: #= data.qty.hidden#,
                                attributes: {class: 'uglcw-cell-speedy k-dirty-cell'},
                                editor: qtyEditor,
                                aggregates: ['sum'],
                                footerTemplate: '\\#= toCurrency(sum||0)\\#'
                        ">销售数量
        </div>
    </c:if>
    <c:if test="${permission:checkUserFieldPdm('stk.stkOut.lookprice')}">
        <div data-field="price"
             uglcw-options="width: #= data.price.width#,
                            hidden: #= data.price.hidden#,
                         attributes: {class: 'uglcw-cell-speedy k-dirty-cell cell-price'},
                         editor: priceEditor">单价
        </div>
    </c:if>
    <c:if test="${permission:checkUserFieldPdm('stk.stkOut.lookamt')}">
        <div data-field="amt" uglcw-options="width: #= data.amt.width#,
                            hidden: #= data.amt.hidden#,
                            format:'{0:n2}',
                            aggregates: ['sum'],
                            attributes: {class: 'k-dirty-cell'},
                            editor: amtEditor,
                            footerTemplate: '\\#= toCurrency(sum||0)\\#'">销售金额
        </div>
    </c:if>
    <c:if test="${fns:checkFieldBool('sys_config','*','code=\"CONFIG_OUT_FANLI_PRICE\" and status =1')}">
        <div data-field="rebatePrice"
             uglcw-options="width: #= data.rebatePrice.width#,
                            editor: rebatePriceEditor,
                            hidden: #= data.rebatePrice.hidden#">应付返利单价
        </div>
    </c:if>
    <div data-field="productDate" uglcw-options="width: #= data.productDate.width#,
                             hidden: #= data.productDate.hidden#,
                             template: uglcw.util.template($('\\#product-date-tpl').html()),
                             editor: productDateEditor,
                             attributes: {class: 'cell-product-date'},
                             headerAttributes:{
                                'data-intro': '点击[关联]可以选中具体批次的商品生产日期，</p><p>且该批次生产日期的商品将会被占用'
                             }
                            ">生产日期
    </div>
    <div data-field="bUnitSummary" uglcw-options="hidden:#= data.bUnitSummary && data.bUnitSummary.hidden#
    ,width:#= data.bUnitSummary ? data.bUnitSummary.width: 100#,  attributes: {class: 'cell-unit-summary'},">件数</div>
    <div data-field="activeDate" uglcw-options="width: #= data.activeDate ? data.activeDate.width: 80#,
                            hidden: #= data.activeDate && data.activeDate.hidden#, schema:{type: 'string'}">有效期
    </div>
    <div data-field="remarks"
         uglcw-options="width: #= data.remarks.width#,
                            hidden: #= data.remarks.hidden#,schema:{type: 'string'}">备注
    </div>
    <div data-field="sunitQty" uglcw-options="width: #= data.sunitQty.width#,
                            aggregates: ['sum'],
                            footerTemplate: '\\#= toCurrency(sum||0)\\#',
                            hidden: #= data.sunitQty.hidden#">小单位数量
    </div>
    <div data-field="sunitJiage" uglcw-options="width: #= data.sunitJiage.width#,
                            hidden: #= data.sunitJiage.hidden#">小单位价格
    </div>
    <c:if test="${fns:checkFieldBool('sys_config','*','code=\"CONFIG_SALE_SHOW_HELP_UNIT\"  and status=1')}">
        <div data-field="helpQty" uglcw-options="width: #= data.helpQty.width#,
                            schema:{ type: 'number', decimals: 10},
                            aggregates: ['sum'],
                            footerTemplate: '\\#= toCurrency(sum||0)\\#',
                            hidden: #= data.helpQty.hidden#">辅助销售数量
        </div>
        <div data-field="helpUnit" uglcw-options="width: #= data.helpUnit.width#,
                            schema:{ type: 'string'},
                            hidden: #= data.helpUnit.hidden#">辅助销售单位
        </div>
    </c:if>
    <div data-field="op" uglcw-options="width: #= data.op.width#,
                            hidden: #= data.op.hidden#,command:['create','destroy']">操作
    </div>
</script>
<script type="text/x-uglcw-template" id="toolbar-prototype">
    <a href="javascript:maxMin(this);"
       data-intro="切换表格最大化"
    >
        <span style="margin-left: 5px;" uglcw-role="tooltip" uglcw-options="content: '<span>切换表格至最大化</span>'"
              class="k-icon uglcw-grid-maxmin ion-md-expand"></span>
    </a>
    <a
            data-intro="增加空行"
            role="button" href="javascript:addRow();" class="k-button">
        <span class="k-icon k-i-add"></span>增行
    </a>
    <a
            data-intro="批量挑选产品"
            role="button" href="javascript:showProductSelector()" class="k-button">
        <span class="k-icon k-i-search"></span>批量挑选
    </a>
    # if(data.xsfpQuickBill && !data.quickAdd.hidden){ #
    <a data-intro="快速创建新产品" role="button" href="javascript:addProduct();" class="k-button">
        <span class="k-icon k-i-add"></span>快速添加商品
    </a>
    # } #

    <div class="k-button k-button-icontext"
         # if(data.checkProduct.hidden){ #
         style="display: none;"
         #}#
         data-intro="商品校验">
        <input type="checkbox" uglcw-role="checkbox" uglcw-model="checkLabel"
               uglcw-options="type:'number'"
               class="k-checkbox" id="checkProduct"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="checkProduct">商品校验</label>
    </div>
    <input # if(data.checkProduct.hidden){ #
           style="display: none;"
           #}#
           uglcw-role="autocomplete"
           placeholder="请输入商品名称、商品代码、商品条码"
           uglcw-options="
             autoWidth: true,
             highlightFirst: true,
             dataTextField: 'wareNm',
             url: '${base}manager/dialogOutWarePage',
             loadFilter:{
                data: function(response){
                    return (uglcw.ui.get('\\\\#checkProduct').value() ? response.list : response.rows ) || [];
                }
            },
             data: function(){
                var $ac = $('\\\\#autocomplete');
                var checkProduct = uglcw.ui.get('\\\\#checkProduct').value();
                var query = {
                page:1, rows: 20,
                waretype: '',
                customerId: uglcw.ui.get('\\\\#cstId').value(),
                stkId: uglcw.ui.get('\\\\#stkId').value(),
               };
               if(checkProduct){
                  query.keyWord = $ac.val();
                  query.status = 1;
               }else{
                  query.wareNm =  $ac.val();
               }
               return query;
             },
             requestStart: function (e) {
                var stkId = uglcw.ui.get('\\\\#stkId').value();
                if (!stkId) {
                    uglcw.ui.warning('请选择仓库');
                    e.preventDefault();
                }
                var cstId = uglcw.ui.get('\\\\#cstId').value();
                if (!cstId) {
                    uglcw.ui.warning('请选择客户');
                    $('\\\\#autocomplete').val('')
                    selectCustomer(false);
                    e.preventDefault();
                }
            },
             dataBound: function () {
                var $ac = $('\\\\#autocomplete');
                var data = this.dataSource.data();
                var input = $ac.val()
                if (data.length === 1 && $ac.data('scanner')) {
                    this.select(this.ul.children().eq(0));
                    this.trigger('select', {dataItem: data[0], input: input});
                } else if (data.length === 0 && $ac.data('scanner')) {
                    //未找到
                    uglcw.ui.warning('无匹配结果');
                    this.value('')
                }
             },
             close: function(){
                var that = this;
                setTimeout(function(){
                    that.value('');
                }, 100)
             },
             select: onProductCheck
            "
           id="autocomplete" class="autocomplete" placeholder="搜索产品..." style="width: 250px;"/>
    <c:if test="${permission:checkUserFieldPdm('stk.stkOut.effect')}">
        <div class="k-button k-button-icontext" style="display:none;">
            <input type="checkbox" uglcw-role="checkbox" uglcw-model="effectOrderPrice"
                   uglcw-options="type:'number'"
                   uglcw-value="#= uglcw.util.toInt(!data.changeOrderPrice.hidden)#"
                   class="k-checkbox" id="changeOrderPrice"/>
            <label style="margin-bottom: 0px;" class="k-checkbox-label" for="changeOrderPrice">审批影响订单商品价格</label>
        </div>
    </c:if>
    <div class="k-button k-button-icontext"
         style="display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_CLOSE_XSPRICE_AUTO_WRITE\'  and status!=1')};">
        <input type="checkbox" uglcw-role="checkbox" uglcw-model="effectOrderPrice"
               uglcw-options="type:'number'"
               uglcw-value="${effectOrderPrice}"
               class="k-checkbox" id="wareXsPrice"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="wareXsPrice">同步价格至商品信息</label>
    </div>
    <div class="k-button" style="display: none;">
        <input type="checkbox" uglcw-role="checkbox" uglcw-model="loadStock"
               uglcw-options="type:'number'"
               uglcw-value="#= uglcw.util.toInt(!data.loadStock.hidden)#"
               class="k-checkbox" id="loadStock"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="loadStock">加载占用库存</label>
    </div>
    <div class="k-button"
         style="display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_XSFP_TO_CUSTOMER_PRICE\'  and status!=1')};">
        <input type="checkbox" uglcw-role="checkbox" uglcw-model="effectOrderPrice"
               uglcw-options="type:'number'"
               uglcw-value="#= uglcw.util.toInt(!data.effectOrderPrice.hidden) #"
               class="k-checkbox" id="wareCustomerPrice"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="wareCustomerPrice">同步至客户执行价</label>
    </div>


    <div class="k-button"
         style="display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_XSFP_AUTO_CREATE_FHD\'  and status=1')};">
        <input type="checkbox" uglcw-role="checkbox" uglcw-model="autoCreateFhd1"
               uglcw-options="type:'number'"
               uglcw-value="${(fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_XSFP_AUTO_CREATE_FHD\'  and status=1') eq '')?'0':'1'}"
               class="k-checkbox" id="autoCreateFhd1"/>
        <label style="margin-bottom: 0;" class="k-checkbox-label" for="autoCreateFhd1">分批发货</label>
    </div>

</script>
<%--<script type="text/x-uglcw-template" id="toolbar"></script>--%>
<%
    pageContext.setAttribute("enter","\n");
%>
<script>
    var _master_tpl_data = {
        address: '${fn:replace(address, enter, "")}',
        tel: '${tel}',
        epCustomerName: '${epCustomerName}',
        staff: '${staff}',
        stafftel: '${stafftel}'
    }
</script>
<script type="text/x-uglcw-template" id="master-tpl">
    <div data-field="address" data-span="7">
        <label class="control-label col-xs-3">配送地址</label>
        <div class="col-xs-4 address">
            <input uglcw-role="textbox" uglcw-model="address"/>
        </div>
    </div>
    <div data-field="tel" data-span="7">
        <label class="control-label col-xs-3">客户电话</label>
        <div class="col-xs-4">
            <input uglcw-role="textbox" uglcw-model="tel"/>
        </div>
    </div>
    <div data-field="pszd" data-span="10">
        <label class="control-label col-xs-3 required">配送指定</label>
        <div class="col-xs-4">
            <select uglcw-role="combobox" uglcw-model="pszd"
                    uglcw-validate="required"
                    uglcw-options="
                                value: '${billId > 0 ? pszd: '公司直送'}',
                                change: function(){
                                    if(this.value() === '直供转单二批'){
                                        $('\\#ep-customer').show();
                                    }else{
                                        $('\\#ep-customer').hide();
                                    }
                                    uglcw.ui.clear('\\#ep-customer');
                                }
                                "
                    placeholder="配送指定">
                <option value="公司直送" selected>公司直送</option>
                <option value="直供转单二批">直供转单二批</option>
            </select>
        </div>
        <div id="ep-customer"
             style="<c:if test="${empty epCustomerName}">display: none;</c:if>padding-left: 5px; padding-right: 5px;"
             class="col-xs-3">
            <input type="hidden" uglcw-role="textbox" uglcw-model="epCustomerId"
                   value="${epCustomerId}"/>
            <input uglcw-role="gridselector"
                   placeholder="二批客户"
                   uglcw-options="click: selectEpCustomer"
                   uglcw-model="epCustomerName"/>
        </div>
    </div>
    <div data-field="stkName" data-span="7">
        <label class="control-label col-xs-3">出货仓库</label>
        <div class="col-xs-4">
            <select id="stkId" uglcw-validate="required" uglcw-role="combobox"
                    uglcw-options="
                                url: '${base}manager/queryBaseStorage',
                                loadFilter:{
                                    data:function(response){
                                        var data = response.list || [];
                                        data.sort(function(a, b){
                                            return (b.isSelect || 0) - (a.isSelect||0);
                                        });
                                        return data;
                                    },
                                },
                                dataTextField: 'stkName',
                                dataValueField: 'id',
                                index: 0,
                                value: '${stkId}'
                    "
                    uglcw-model="stkId,stkName"></select>
        </div>
    </div>
    <div data-field="staff" data-span="7">
        <label class="control-label col-xs-3">业务员</label>
        <div class="col-xs-4">
            <input type="hidden" uglcw-model="empId" uglcw-role="textbox" id="empId"
                   value="${empId}"/>
            <input uglcw-role="gridselector" uglcw-model="staff"
                   placeholder="请选择业务员"
                   uglcw-options="click: selectEmployee"/>
        </div>
    </div>
    <div data-field="stafftel" data-span="7">
        <label class="control-label col-xs-3">联系电话</label>
        <div class="col-xs-4">
            <input uglcw-role="textbox" uglcw-model="stafftel"/>
        </div>
    </div>
    <div data-field="totalamt" data-span="7">
        <label class="control-label col-xs-3">合计金额</label>
        <div class="col-xs-4">
            <input id="totalAmount" uglcw-options="spinners: false, format: 'n2'"
                   uglcw-role="numeric"
                   uglcw-model="totalamt" value="${totalamt}"
                   disabled>
        </div>
    </div>
    <div data-field="discount" data-span="7">
        <label class="control-label col-xs-3">整单折扣</label>
        <div class="col-xs-4">
            <input id="discount" uglcw-role="numeric" uglcw-model="discount" value="${discount}">
        </div>
    </div>
    <div data-field="disamt" data-span="7">
        <label class="control-label col-xs-3">单据金额</label>
        <div class="col-xs-4">
            <input id="discountAmount"
                   uglcw-options="spinners: false, format: 'n2'"
                   uglcw-role="numeric" uglcw-model="disamt" disabled
                   value="${disamt}">
        </div>
    </div>
    <div data-field="vehId" data-span="7">
        <label class="control-label col-xs-3">车&nbsp;&nbsp;辆</label>
        <div class="col-xs-4">
            <tag:select2 name="vehId" id="vehId" tclass="pcl_sel" value="${vehId }" headerKey="" placeholder="请选择车辆"
                         headerValue="" tableName="stk_vehicle" onchange="changeVehicle(this.value)" displayKey="id"
                         displayValue="veh_no"/>
        </div>
    </div>
    <div data-field="driverId" data-span="7">
        <label class="control-label col-xs-3">司&nbsp;&nbsp;机</label>
        <div class="col-xs-4">
            <tag:select2 name="driverId" id="driverId" tclass="pcl_sel" value="${driverId }" placeholder="请选择司机"
                         headerKey=""
                         headerValue="" tableName="stk_driver" displayKey="id"
                         displayValue="driver_name"/>
        </div>
    </div>
    <div data-field="transportName" data-span="7" data-hide="${saleType ne '003'}" >
        <label class="control-label col-xs-3">物流名称</label>
        <div class="col-xs-4">
            <input id="transportName" uglcw-role="textbox" uglcw-model="transportName" value="${transportName}">
        </div>
    </div>
    <div data-field="transportCode" data-span="7" data-hide="${saleType ne '003'}">
        <label class="control-label col-xs-3">物流单号</label>
        <div class="col-xs-4">
            <input id="transportCode" uglcw-role="textbox" uglcw-model="transportCode" value="${transportCode}">
        </div>
    </div>

    <div data-field="freight" data-span="7" data-hide="${saleType ne '003'}">
        <label class="control-label col-xs-3">代收运费</label>
        <div class="col-xs-4">
            <input id="freight" uglcw-role="textbox" uglcw-model="freight" value="${freight}">
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="snapshot-tpl">
    <div uglcw-role="grid" uglcw-options="
            id: 'id',
            pageable: false,
            url: '${base}manager/common/bill/snapshot?billType=xxfp',
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
        <div data-field="title" uglcw-options="tooltip: true">客户</div>
        <div data-field="opts" uglcw-options="template: uglcw.util.template($('#snapshot-opt-tpl').html())">操作</div>
    </div>
</script>
<script type="text/x-uglcw-template" id="snapshot-opt-tpl">
    <button class="k-button k-info ghost" onclick="removeSnapshot(this, '#= data.id#')">删除</button>
    <button class="k-button k-info ghost" onclick="loadSnapshot('#= data.id#')">读取</button>
    <%--<button class="k-button k-info ghost" onclick="recovery(#= data.id#)">恢复</button>--%>
</script>
