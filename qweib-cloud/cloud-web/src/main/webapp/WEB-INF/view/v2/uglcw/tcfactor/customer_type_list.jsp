<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户类型商品提成系数操作</title>
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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="qdtpNm" uglcw-role="textbox" placeholder="客户类型名称">
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
						    responsive:['.header',40],
							id:'id',
							pageable: true,
                    		url: '${base}manager/toQdtypePage',
                    		criteria: '.query',
                    		dataBound:function(){
                    		    uglcw.ui.init('#grid');
                    		}
                    	">
                <div data-field="coding" uglcw-options="width:100">编码</div>
                <div data-field="qdtpNm" uglcw-options="width:100">客户类型名称</div>
                <div data-field="oper" uglcw-options="width:160, template: function(data){
                        data.type = 'Type'
                    return uglcw.util.template($('#oper1').html())({data: data});
                }">设置商品类别提成系数
                </div>
                <div data-field="oper" uglcw-options="width:160, template: function(data){
                        data.type = ''
                    return uglcw.util.template($('#oper1').html())({data: data});
                }">设置商品提成系数
                </div>
            </div>
        </div>
    </div>
</div>

<%--操作--%>
<script id="oper1" type="text/x-uglcw-template">
    #var dict = {'1': '业务提成按数量系数', '2':'业务提成按收入系数', '3': '业务提成按毛利系数'}#
    <%--<div class="factor-name">
        <a href="javascript:setWare#= data.type#Factor(#= data.id#, '#= dict[data.t||'1']#', #= data.t||1#);">#= dict[data.t||'1']#</a>
        <span class="k-icon k-i-arrow-chevron-down" onclick="showFactorSelector(this)"></span>
    </div>--%>
    <select uglcw-role="combobox" style="width: 80%;" class="factor-combo" id="factor-#= data.type##= data.id#"
            uglcw-options="
         value: '1',
         autoWidth: true,
         template: function(item){
            var id = #= data.id#, name = '#= data.qdtpNm#';
            item.id = id;
            item.name = name;
            item.type = '#= data.type#';
            return uglcw.util.template($('\\#combobox-template').html())({data: item});
         },
         #if(data.type){#
         change: function(){
            var row = uglcw.ui.get('\\#grid').k().dataItem($(this.element).closest('tr'));
            <%--$(this.element).closest('tr').find('.factor-combo').hide();--%>
            uglcw.ui.get($('\\#factor-#= data.id#')).value(this.value())
         }
         #}#
        ">
        <option value="1">业务提成按数量系数</option>
        <option value="2">业务提成按收入系数</option>
        <option value="3">业务提成按毛利系数</option>
    </select>
    <a onclick="setFactor(this, '#= data.type||''#', #= data.id#)">编辑</a>
</script>

<script type="text/x-uglcw-template" id="combobox-template">
    <div><span>#= data.text#</span><a style="float: right"
                                      href="javascript:setWare#= data.type#Factor(#= data.id#, '#= data.name#', #= data.value#);">立即查看</a>
    </div>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var options1 = {
        dataTextField: 'text',
        dataValueField: 'value',
        dataSource: {
            data: [
                {text: '业务提成按数量系数', value: 1},
                {text: '业务提成按收入系数', value: 2},
                {text: '业务提成按毛利系数', value: 3}
            ]
        },
        value: 0,
        template: uglcw.util.template($('#combobox-template').html())
    }

    function showFactorSelector(el) {
        $(el).closest('.factor-name').hide()
        $(el).closest('td').find('.k-widget.factor-combo').show()
        var combobox = uglcw.ui.get($(el).closest('td').find('select.factor-combo')).k();
        combobox.dataSource.read();
        //combobox.open();
    }

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })

    function setFactor(el, t, id) {
        var combobox = uglcw.ui.get($(el).closest('td').find('select.factor-combo'));
        var name = combobox.k().text();
        var type = combobox.k().value();
        window[('setWare' + (t || '') + 'Factor')](id, name, type);
    }

    function setWareTypeFactor(id, name, type) {
        uglcw.ui.openTab(name + "_设置商品类别提成系数", "${base}manager/customerTypeTcRatewaretype?_sticky=v2&type=" + type + "&relaId=" + id);
    }

    function setWareFactor(id, name, type) {
        uglcw.ui.openTab(name + "_设置商品提成系数", "${base}manager/toCustomerTypeTcFactorSetWareTree?_sticky=v2&type=" + type + "&relaId=" + id);
    }

</script>
</body>
</html>
