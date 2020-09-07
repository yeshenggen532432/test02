<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%@ attribute name="query" type="java.lang.String" required="false" %>
<%@ attribute name="selection" type="java.lang.String" required="false" %>
<%@ attribute name="checkbox" type="java.lang.Boolean" required="false" %>
<c:set var="ck" value="${checkbox == null ? true: checkbox}"/>
<script type="text/x-qwb-template" id="product-out-selector-template">
    <div class="qwb-selector-container">
        <div>
            <div class="col-xs-5" style="padding: 2px;height: 344px;">
                <ul qwb-role="accordion">
                    <li>
                        <span>库存商品类</span>
                        <div>
                            <div qwb-role="tree" id="tree1"
                                qwb-options="
                                 url: '${base}manager/companyWaretypes?isType=0',
                                 model: 'waretype',
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
                                    var node = this.dataItem(e.node)
                                    qwb.ui.get('\\#click-flag').value(0);
                                    qwb.ui.bind('.qwb-selector-container .criteria',{
                                        isType: 0,
                                        type:0,
                                        waretype: node.id
                                    });
                                    qwb.ui.get('.qwb-selector-container .qwb-grid').reload();
                                 },
                                 dataBound: function(){
                                    var tree = this;
                                    clearTimeout($('\\#tree1').data('_timer'));
                                    $('\\#tree1').data('_timer', setTimeout(function(){
                                        tree.select($('\\#tree1 .k-item:eq(0)'));
                                        var nodes = tree.dataSource.data().toJSON();
                                        if(nodes && nodes.length > 0){
                                            qwb.ui.bind('.qwb-selector-container .criteria', {
                                                isType: 0,
                                                type:0,
                                                waretype: nodes[0].id
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
                                 model: 'waretype',
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
                                    var node = this.dataItem(e.node)
                                    qwb.ui.get('\\#click-flag').value(0);
                                    qwb.ui.bind('.qwb-selector-container .criteria',{
                                        isType: 1,
                                        type:1,
                                        waretype: node.id
                                    });
                                    qwb.ui.get('.qwb-selector-container .qwb-grid').reload();
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
                                 model: 'waretype',
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
                                    var node = this.dataItem(e.node)
                                    qwb.ui.get('\\#click-flag').value(2);
                                    qwb.ui.bind('.qwb-selector-container .criteria',{
                                        isType: 2,
                                        type:2,
                                        waretype: node.id
                                    });
                                    qwb.ui.get('.qwb-selector-container .qwb-grid').reload();
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
                                    var node = this.dataItem(e.node)
                                    qwb.ui.get('\\#click-flag').value(0);
                                    qwb.ui.bind('.qwb-selector-container .criteria',{
                                        isType: 3,
                                        type:3,
                                        waretype: node.id
                                    })
                                    qwb.ui.get('.qwb-selector-container .qwb-grid').reload();
                                 }
                                "
                            ></div>
                        </div>
                    </li>
                </ul>
            </div>
            <div class="col-xs-19" style="padding-left: 5px;padding-right: 5px;">
                <div class="criteria">
                    <input type="hidden" qwb-role="textbox" qwb-model="isType" value="0"/>
                    <input type="hidden" qwb-role="textbox" qwb-model="waretype"/>
                    <select qwb-model="type" qwb-role="combobox" id="type" placeholder="资产类型" qwb-options='value:""'>
                        <option value="0">库存商品类</option>
                        <option value="1">原辅材料类</option>
                        <option value="2">低值易耗品类</option>
                        <option value="3">固定资产类</option>
                    </select>
                    <input qwb-role="textbox" qwb-model="wareNm" class="search-input" placeholder="商品名称" />
                    <input type="hidden" qwb-role="textbox" id="click-flag" value="0"/>
                    <button class="k-info search-btn" qwb-role="button">搜索</button>
                </div>
                <div class="qwb-small" qwb-role="grid" qwb-options="
                        height: 300,
                        pageable: true,
                        autoBind: false,
                        criteria: '.qwb-selector-container .criteria',
                        url: '${base}manager/queryWarePage',
                        id: 'wareId',
                        checkbox: #= data.checkbox#,
                        persistSelection: true,
                        query: function (params) {
                        <c:if test="${not empty query}">
                            params = ${query}(params);
                        </c:if>
                         if(qwb.ui.get('\\#click-flag').value()==1){
                             delete params['isType']
                             delete params['waretype']
                         }
                         if(params.type != ''){
                            params.isType =params.type
                        }
                           return params;
                        },
                         click: function(row){
                           var _sort = this._sort || 1;
                           _sort += 10;
                           row._sort = _sort;
                           this._sort = _sort;
                        },
                         <c:if test="${not empty selection}">
                        selection: qwb.ui.get('${selection}').value(),
                        </c:if>
                    ">

                    <div data-field="wareCode" qwb-options="width:80" align="center" >
                        商品编码
                    </div>
                    <div data-field="wareNm" qwb-options="width:150" align="left">
                        商品名称
                    </div>
                    <div data-field="wareGg" qwb-options="width:80" align="center">
                        规格
                    </div>
                    <div data-field="wareDw" qwb-options="width:60" align="center">
                        大单位
                    </div>
                    <div data-field="minUnit" qwb-options="width:100" align="center">
                        小单位
                    </div>
                    <div data-field="hsNum" qwb-options="width:100, hidden:true">
                        换算比例
                    </div>
                    <div data-field="stkQty" qwb-options="width:100,hidden:true">
                        库存数量
                    </div>
                    <div data-field="minSumQty" qwb-options="width:100,hidden:true">
                        库存数量(小单位)
                    </div>
                    <div data-field="waretypePath" qwb-options="width:100">
                        商品类别
                    </div>
                    <div data-field="inPrice" qwb-options="width:100">
                        大单位价格
                    </div>
                    <div data-field="inPrice2" qwb-options="width:100, hidden:true">
                        大单位价格
                    </div>
                    <div data-field="sunitPrice" qwb-options="width:100, hidden:true">
                        小单位价格
                    </div>
                    <div data-field="productDate" qwb-options="width:100" >
                        生产日期
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
