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
            <div class="col-xs-19" style="padding-left: 5px;padding-right: 5px;">
                <div class="criteria">
                    <select qwb-model="isType" qwb-role="combobox" id="__ware_type" placeholder="资产类型" qwb-options='value:"",
                         change:function(){
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

                         }
                        '>
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
                                qwb.ui.get('\\#__selector_ware_level3').k().dataSource.data([])
                                qwb.ui.get('\\#__selector_ware_level3').k().value('')
                                qwb.ui.get('\\#__selector_ware_level3').k().dataSource.read()
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
                    <input class="search-input" onclick="funCellClick(this)" qwb-role="textbox" qwb-model="wareNm" placeholder="商品名称"/>
                    <tag:select2 id="brandId" name="brandId" headerKey="" headerValue=""
                                 value="${ware.brandId}" displayKey="id"
                                 displayValue="name" tableName="sys_brand" placeholder="品牌名称">
                    </tag:select2>
                    <button class="k-info search-btn" qwb-role="button">搜索</button>
                </div>
                <div class="qwb-small" qwb-role="grid" qwb-options="
                        height: 300,
                        pageable: true,
                        autoBind: false,
                        criteria: '.qwb-selector-container .criteria',
                        url: '${base}manager/dialogWarePage',
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

                    <div data-field="wareCode" qwb-options="width:100">商品编码</div>
                    <div data-field="wareNm" qwb-options="width:180">商品名称</div>
                    <div data-field="wareGg" qwb-options="width:100">规格</div>
                    <div data-field="inPrice" qwb-options="width:80">采购价格</div>
                    <div data-field="stkQty" qwb-options="width:80">库存数量</div>
                    <div data-field="wareDw" qwb-options="width:70">大单位</div>
                    <div data-field="minUnit" qwb-options="width:70">小单位</div>
                    <div data-field="maxUnitCode" qwb-options="width:80,hidden:true">大单位代码</div>
                    <div data-field="minUnitCode" qwb-options="width:80, hidden:true">小单位代码</div>
                    <div data-field="hsNum" qwb-options="width:80, hidden:true">换算比例</div>
                    <div data-field="sunitFront" qwb-options="width:80, hidden:true">开单默认选中小单位</div>


                </div>
            </div>
        </div>
    </div>
</script>
<script>

    function _formatStkQty(row){
        var v = row.stkQty;
        var hsNum=row.hsNum;
        if(hsNum>1){
            var str = v+"";
            if(str.indexOf(".")!=-1){
                var nums = str.split(".");
                var num1 = nums[0];
                var num2 = nums[1];
                if(parseFloat(num2)>0){
                    var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);
                    minQty = minQty.toFixed(2);
                    return num1+""+row.wareDw+""+minQty+""+row.minUnit;
                }
            }
        }
        return v+row.wareDw;

    }

    function funCellClick(o){
        o.select();
    }
    function onWareTypeSelect(e, isType){
        var node = this.dataItem(e.node);
        qwb.ui.get('#__ware_type').value(isType);
        if(node.id == 0){
            qwb.ui.get('#__selector_ware_level2').k().dataSource.read();
            qwb.ui.get('#__selector_ware_level2').value('');
            qwb.ui.get('#__selector_ware_level3').k().dataSource.data([]);
            qwb.ui.get('#__selector_ware_level3').value('');
        }else if(node.pid == 0){
            qwb.ui.get('#__selector_ware_level2').k().dataSource.read();
            qwb.ui.get('#__selector_ware_level2').value(node.id);
            qwb.ui.get('#__selector_ware_level3').k().dataSource.data([]);
            qwb.ui.get('#__selector_ware_level3').value('');
        }else if(node.pid > 0){
            qwb.ui.get('#__selector_ware_level2').k().dataSource.read();
            qwb.ui.get('#__selector_ware_level2').value(node.pid);
            qwb.ui.get('#__selector_ware_level3').k().dataSource.read();
            qwb.ui.get('#__selector_ware_level3').value(node.id);
        }
        qwb.ui.get('.qwb-selector-container .qwb-grid').reload();
    }
</script>
