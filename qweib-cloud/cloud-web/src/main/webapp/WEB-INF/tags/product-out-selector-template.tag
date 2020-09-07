<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%@ attribute name="query" type="java.lang.String" required="false" %>
<%@ attribute name="selection" type="java.lang.String" required="false" %>
<%@ attribute name="checkbox" type="java.lang.Boolean" required="false" %>
<c:set var="ck" value="${checkbox == null ? true: checkbox}"/>
<script type="text/x-qwb-template" id="product-out-selector-no-result-tpl">
    <div style="margin-top: 20px;">
        <div>
            未找到商品:<span style="color: red;">#= data.wareNm#</span>。是否立即添加 ？
        </div>
        <br/>
        <button class="k-button k-info" onclick="_quickAddProduct('#= data.wareNm#')">
            <i class="k-icon k-i-plus"></i>立即添加#= data.wareNm#
        </button>
    </div>
</script>
<script>
    function _quickAddProduct(wareNm) {
        var data = qwb.extend({wareNm: wareNm}, {
            putOn: 0,
            status: 1,
            isCy: 1
        });
        qwb.ui.loading();
        $.ajax({
            url: '${base}manager/saveQuickWare',
            type: 'post',
            data: data,
            success: function (response) {
                qwb.ui.loaded();
                if (response.state) {
                    qwb.ui.success('添加成功');
                    qwb.ui.get('.qwb-selector-container .qwb-grid').reload();
                }
            },
            error: function () {
                qwb.ui.loaded();
                qwb.ui.error('添加失败');
            }
        });
    }
</script>
<script type="text/x-qwb-template" id="product-out-selector-template">
    <div class="qwb-selector-container">
        <div class="qwb-layout-container">
            <div class="qwb-layout-fixed" style="height: 100%;width: 200px; padding-right: 0px; ">
                <div class="accordion-wrapper">
                    <ul qwb-role="accordion">
                        <li>
                            <span>库存商品类</span>
                            <div>
                                <div qwb-role="tree" id="tree1"
                                     qwb-options="
                                 url: '${base}manager/companyWaretypes?isType=0',
                                 id: 'id',
                                 expandable: function(node){
                                    return node.id == 0;
                                 },
                                 loadFilter:function(response){
                                 $(response).each(function(index,item){
                                    if(item.text=='根节点'){
                                        item.text='库存商品类'
                                    }
                                 })
                                 return response;
                                 },
                                 select: function(e){
                                    onWareTypeSelect.call(this, e, 0);
                                 },
                                 dataBound: function(){
                                    var tree = this;
                                    clearTimeout($('\\#tree1').data('_timer'));
                                    $('\\#tree1').data('_timer', setTimeout(function(){
                                        tree.select($('\\#tree1 .k-item:eq(0)'));
                                        var nodes = tree.dataSource.data().toJSON();
                                        if(nodes && nodes.length > 0){
                                            qwb.ui.bind('.qwb-selector-container .criteria', {
                                                isType: 0
                                            })
                                            qwb.ui.get('.qwb-selector-container .qwb-grid').reload();
                                        }
                                    }, 100))

                                 }

                                "
                                ></div>
                            </div>
                        </li>
                        <li>
                            <span>原辅材料类</span>
                            <div>
                                <div qwb-role="tree"
                                     qwb-options="
                                 url: '${base}manager/companyWaretypes?isType=1',
                                 id: 'id',
                                 expandable: function(node){
                                    return node.id == 0;
                                 },
                                 loadFilter:function(response){
                                 $(response).each(function(index,item){
                                     if(item.text=='根节点'){
                                        item.text='原辅材料类'
                                     }
                                 })
                                 return response;
                                 },
                                 select: function(e){
                                    onWareTypeSelect.call(this, e, 1);
                                 }
                                "
                                ></div>
                            </div>
                        </li>
                        <li>
                            <span>低值易耗品类</span>
                            <div>
                                <div qwb-role="tree"
                                     qwb-options="
                                 url: '${base}manager/companyWaretypes?isType=2',
                                 id: 'id',
                                 expandable: function(node){
                                    return node.id == 0;
                                 },
                                 loadFilter:function(response){
                                 $(response).each(function(index,item){
                                    if(item.text=='根节点'){
                                        item.text='低值易耗品类'
                                    }
                                 })
                                 return response;
                                 },
                                 select: function(e){
                                    onWareTypeSelect.call(this, e, 2);
                                 }
                                "
                                ></div>
                            </div>
                        </li>
                        <li>
                            <span>固定资产类</span>
                            <div>
                                <div qwb-role="tree"
                                     qwb-options="
                                 url: '${base}manager/companyWaretypes?isType=3',
                                 model: 'waretype',
                                 id: 'id',
                                 expandable: function(node){
                                    return node.id == 0;
                                 },
                                 loadFilter:function(response){
                                 $(response).each(function(index,item){
                                    if(item.text=='根节点'){
                                        item.text='固定资产类'
                                    }
                                 })
                                 return response;
                                 },
                                 select: function(e){
                                   onWareTypeSelect.call(this, e, 3);
                                 }
                                "
                                ></div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="qwb-layout-content" style="padding-left: 5px;padding-right: 5px;">
                <div class="criteria">
                    <input class="search-input" qwb-role="textbox" onclick="funCellClick(this)" qwb-model="wareNm"
                           placeholder="商品名称"/>
                    <select qwb-model="isType" qwb-role="combobox" id="__ware_type" placeholder="资产类型" qwb-options='value:"",change:function(){
                        if(qwb.ui.get("\\#__ware_type").value() == ""){
                            qwb.ui.get("\\#__selector_ware_level2").k().dataSource.data([]);
                            qwb.ui.get("\\#__selector_ware_level2").value("");
                            qwb.ui.get("\\#__selector_ware_level3").k().dataSource.data([]);
                            qwb.ui.get("\\#__selector_ware_level3").value("");
                         }else{
                            qwb.ui.get("\\#__selector_ware_level2").k().dataSource.data([]);
                            qwb.ui.get("\\#__selector_ware_level2").value("");
                            qwb.ui.get("\\#__selector_ware_level2").k().dataSource.read();
                            qwb.ui.get("\\#__selector_ware_level3").k().dataSource.data([]);
                            qwb.ui.get("\\#__selector_ware_level3").value("");
                          }

                        }'>
                        <option value="0">库存商品类</option>
                        <option value="1">原辅材料类</option>
                        <option value="2">低值易耗品类</option>
                        <option value="3">固定资产类</option>
                    </select>
                    <select qwb-role="combobox" qwb-model="level2" id="__selector_ware_level2" placeholder="二级分类"
                            qwb-options="
                            dataTextField:'text',
                            dataValueField:'id',
                            loadFilter:{
                                data:function(response){
                                     return response[0].children||[]
                                }
                            },
                            change:function(){
                                qwb.ui.get('\\#__selector_ware_level3').k().dataSource.data([]);
                                qwb.ui.get('\\#__selector_ware_level3').k().value('');
                                qwb.ui.get('\\#__selector_ware_level3').k().dataSource.read();
                            },
                            data:function(){
                                return {
                                    isType: qwb.ui.get('\\#__ware_type').value(),
                                    id: 0
                                }
                            },
                            url:'${base}manager/companyWaretypes'
                        ">
                    </select>
                    <select qwb-role="combobox" qwb-model="level3" id="__selector_ware_level3" placeholder="三级分类"
                            qwb-options="
                           url:'${base}manager/companyWaretypes',
                           dataTextField:'text',
                           dataValueField: 'id',
                           loadFilter: {
                                    data: function(response){
                                          return response||[]
                                        }
                            },
                            data:function(){
                                return {
                                   isType: qwb.ui.get('\\#__ware_type').value(),
                                   id : qwb.ui.get('\\#__selector_ware_level2').value()
                                }
                            }
                    ">

                    </select>
                    <tag:select2 id="brandId" name="brandId" headerKey="" headerValue=""
                                 value="${ware.brandId}" displayKey="id"
                                 displayValue="name" tableName="sys_brand" placeholder="品牌名称">
                    </tag:select2>
                    <button class="k-info search-btn" qwb-role="button">搜索</button>
                        <input type="checkbox" class="k-checkbox"
                               qwb-value="0"
                               qwb-role="checkbox" qwb-model="isRegular"
                               onclick="changeIsRegular()"
                               id="isRegular">
                        <label style="margin-left: 10px;" class="k-checkbox-label" for="isRegular">客户常售商品</label>
                </div>
                <div class="qwb-small" qwb-role="grid" qwb-options="
                        height: 300,
                        pageable: {
                            refresh:false,
                            buttonCount: 3,
                            messages:{
                                display: '总计:{2}',
                                empty:'当前无数据',
                                page: '第'
                            }
                        },
                        click: function(row){
                           var _sort = this._sort || 1;
                           _sort += 10;
                           row._sort = _sort;
                           this._sort = _sort;
                        },
                        autoBind: false,
                        noRecords:{
                            template: function(){
                               return qwb.util.template($('\\#product-out-selector-no-result-tpl').html())({data: qwb.ui.bind('.qwb-selector-container .criteria')});
                            }
				        },
                        criteria: '.qwb-selector-container .criteria',
                        url: '${base}manager/dialogOutWarePage',
                        id: 'wareId',
                        checkbox: #= data.checkbox#,
                        persistSelection: true,
                        query: function (params) {
                        <c:if test="${not empty query}">
                            params = ${query}(params);
                        </c:if>
                           params.waretype = params.level3 || params.level2
                           return params;
                        },
                         <c:if test="${not empty selection}">
                        selection: qwb.ui.get('${selection}').value(),
                        </c:if>
                    ">
                    <div data-field="packBarCode" qwb-options="width:120">商品条码</div>
                    <div data-field="wareNm" qwb-options="width:180">商品名称</div>
                    <div data-field="wareGg" qwb-options="width:100">规格</div>
                    <div data-field="wareCode" qwb-options="width:100">商品编码</div>
                    <div data-field="stkQty"
                         qwb-options="width:120, template: function(data){ return formatQty(data)}">实际数量
                    </div>
                    <div data-field="occQty" qwb-options="width:80, hidden:true">占用数量</div>
                    <div data-field="_xnQty" qwb-options="width:80, hidden:true">虚拟库存</div>
                    <div data-field="wareDj" qwb-options="width:80">销售价</div>
                    <div data-field="wareDw" qwb-options="width:70">大单位</div>
                    <div data-field="minUnit" qwb-options="width:70">小单位</div>
                    <c:if test="${fns:checkFieldDisplay('sys_config',''*'','code=\"CONFIG_SALE_SHOW_INPRICE\"  and status=1') ne 'none'}">
                        <div data-field="inPrice" qwb-options="width:120">成本价</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</script>
<script>


    function changeIsRegular(){
        qwb.ui.get('.qwb-selector-container .qwb-grid').reload();
    }

    function _formatStkQty(row) {
        console.log(row);
        var v = row.stkQty;
        var hsNum = row.hsNum;
        if (hsNum > 1) {
            var str = v + "";
            if (str.indexOf(".") != -1) {
                var nums = str.split(".");
                var num1 = nums[0];
                var num2 = nums[1];
                if (parseFloat(num2) > 0) {
                    var minQty = parseFloat(0 + "." + num2) * parseFloat(hsNum);
                    //minQty = minQty.toFixed(2);
                    minQty = (Math.floor(minQty * 100) / 100)
                    return num1 + "" + row.wareDw + "" + minQty + "" + row.minUnit;
                }
            }
        }
        v = (Math.floor(v * 100) / 100)
        return v + row.wareDw;

    }

    function formatQty(data) {
        var hsNum = data.hsNum || 1;
        var minSumQty = data.minStkQty||0;
        var unitName = data.wareDw;
        if(unitName==""){
            unitName="/";
        }
        var result = "";
        if((hsNum+"").indexOf(".")!=-1){
            var sumQty = parseFloat(minSumQty*10000)/parseFloat(hsNum*10000);
            var str = sumQty+"";
            if(str.indexOf(".")!=-1){
                var nums = str.split(".");
                var num1 = nums[0];
                var num2 = nums[1];
                if(parseFloat(num2)>0){
                    var minQty =   qwb.util.multiply(0+"."+num2,hsNum); //parseFloat(0+"."+num2)*parseFloat(hsNum);
                    minQty = qwb.util.toString(minQty,'n2'); //minQty.toFixed(2);
                    result = num1+""+unitName+""+minQty+""+data.minUnit;
                }
            }else{
                result = sumQty+unitName;
            }
        }else{
            var remainder = (minSumQty) % (hsNum);
            if (remainder === 0) {
                //整数件
                result += '<span>' + minSumQty / hsNum + '</span>' + unitName;
            } else if (remainder === minSumQty) {
                //不足一件
                var minQty =   qwb.util.toString(minSumQty,'n2');//Math.floor(minSumQty*100)/100;
                result += '<span>' + minQty + '</span>' + data.minUnit;
            } else {
                //N件有余
                var minQty = qwb.util.toString(remainder,'n2');//Math.floor(remainder*100)/100;
                result += '<span>' + parseInt(minSumQty / hsNum) + '</span>' + unitName + '<span>' + minQty + '</span>' + data.minUnit;
            }
        }
        return result;
    }


    function funCellClick(o) {
        o.select();
    }

    function onWareTypeSelect(e, isType) {
        var node = this.dataItem(e.node);
        qwb.ui.get('#__ware_type').value(isType);
        if (node.id == 0) {
            qwb.ui.get('#__selector_ware_level2').k().dataSource.read();
            qwb.ui.get('#__selector_ware_level2').value('');
            qwb.ui.get('#__selector_ware_level3').k().dataSource.data([]);
            qwb.ui.get('#__selector_ware_level3').value('');
        } else if (node.pid == 0) {
            qwb.ui.get('#__selector_ware_level2').k().dataSource.read();
            qwb.ui.get('#__selector_ware_level2').value(node.id);
            qwb.ui.get('#__selector_ware_level3').k().dataSource.data([]);
            qwb.ui.get('#__selector_ware_level3').value('');
        } else if (node.pid > 0) {
            qwb.ui.get('#__selector_ware_level2').k().dataSource.read();
            qwb.ui.get('#__selector_ware_level2').value(node.pid);
            qwb.ui.get('#__selector_ware_level3').k().dataSource.read();
            qwb.ui.get('#__selector_ware_level3').value(node.id);
        }
        qwb.ui.get('.qwb-selector-container .qwb-grid').reload();
    }
</script>
