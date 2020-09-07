<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>库存预警</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<style>
    .row-color-blue {
        color: blue;
        text-decoration: line-through;
        font-weight: bold;
    }

    .row-color-pink {
        color: #FF00FF;
        font-weight: bold;
    }

    .row-color-red {
        color: red !important;
        font-weight: bold;
    }
</style>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">


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
                                       onWareTypeSelect.call(this, e, 0);
                                   },
                                   dataBound: function(){
                                   var tree = this;
                                   clearTimeout($('#tree1').data('_timer'));
                                   $('#tree1').data('_timer', setTimeout(function(){
                                       tree.select($('#tree1 .k-item:eq(0)'));
                                       var nodes = tree.dataSource.data().toJSON();
                                       if(nodes && nodes.length > 0){
                                           uglcw.ui.bind('.uglcw-query', {
                                               isType: 0
                                        });
                                           uglcw.ui.get('#grid').reload();
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
                                        onWareTypeSelect.call(this, e, 1);
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
                                    uglcw.ui.get('#type').value(2);
                                    uglcw.ui.get('#click-flag').value(0);
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
                                        uglcw.ui.get('#type').value(3);
                                        uglcw.ui.get('#click-flag').value(0);
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
                            <select uglcw-model="isType" uglcw-role="combobox" id="type" placeholder="资产类型"
                                    uglcw-options='value:"" ,change:function(){
                                      if(uglcw.ui.get("#type").value() == ""){
                                        uglcw.ui.get("#level2").k().text("");
                                        uglcw.ui.get("#level2").k().value("");
                                        uglcw.ui.get("#level2").k().dataSource.data([]);
                                        uglcw.ui.get("#level3").k().text("");
                                        uglcw.ui.get("#level3").k().value("");
                                        uglcw.ui.get("#level3").k().dataSource.data([]);
                                      }else{
                                        uglcw.ui.get("#level2").k().text("");
                                        uglcw.ui.get("#level2").k().value("");
                                        uglcw.ui.get("#level2").k().dataSource.read();
                                        uglcw.ui.get("#level3").k().text("");
                                        uglcw.ui.get("#level3").k().value("");
                                        uglcw.ui.get("#level3").k().dataSource.data([]);
                                        }

                                 }'
                            >
                                <option value="0">库存商品类</option>
                                <option value="1">原辅材料类</option>
                                <option value="2">低值易耗品类</option>
                                <option value="3">固定资产类</option>
                            </select>
                        </li>
                        <li>
                            <select uglcw-model="level2" id="level2" uglcw-role="combobox" placeholder="二级分类"
                                    uglcw-options="
                                    dataTextField: 'text',
                                    dataValueField: 'id',
                                    loadFilter: {
                                        data: function(response){
                                            return response[0].children||[]
                                        }
                                    },
                                    change: function(){
                                        uglcw.ui.get('#level3').k().dataSource.data([]);
                                        uglcw.ui.get('#level3').k().value('');
                                        uglcw.ui.get('#level3').k().dataSource.read();
                                    },
                                    data:function(){
                                        return {
                                            isType: uglcw.ui.get('#type').value(),
                                            id: 0
                                        }
                                    },
                                    url:'${base}manager/companyWaretypes'
                                ">

                            </select>
                        </li>
                        <li>
                            <select uglcw-model="level3" id="level3" uglcw-role="combobox" placeholder="三级分类"
                                    uglcw-options="
                                      dataTextField:'text',
                                      dataValueField:'id',
                                      loadFilter: {
                                        data: function(response){
                                            return response||[]
                                        }
                                       },
                                      data:function(){
                                          return{
                                              isType:uglcw.ui.get('#type').value(),
                                              id: uglcw.ui.get('#level2').value(),
                                          }
                                      },
                                      url:'${base}manager/companyWaretypes'
                                    ">

                            </select>
                        </li>
                        <li>
                            <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="stkId" uglcw-options="
                                    dataTextField: 'stkName',
                                    dataValueField: 'id',
                                    url: '${base}manager/queryBaseStorage',
                                    placeholder: '仓库'
                                "></select>
                        </li>
                        <li>
                            <uglcw:sys-brand-select base="${base}" id="brandId" name="brandId" status="1"/>
                        </li>
                        <li style="display: none">
                            <select uglcw-role="combobox" id="scope" uglcw-model="scope" uglcw-options="value: '', placeholder:'预警状态'">
                                <option value="1">正常</option>
                                <option value="2" selected="selected">预警</option>
                            </select>
                        </li>
                        <li style="width: 150px;">
                            <input type="checkbox" uglcw-options="type:'number'" uglcw-role="checkbox" id="ignoreZero"
                                   uglcw-model="flag">
                            <label style="margin-top: 10px;" class="k-checkbox-label" for="ignoreZero">忽略库存数量为0记录</label>
                        </li>
                        <li style="width: 150px;">
                            <input type="checkbox" uglcw-options="type:'number'" uglcw-role="checkbox" id="checkScope"
                                   uglcw-model="checkScope">
                            <label style="margin-top: 10px;" class="k-checkbox-label" for="checkScope">预警商品</label>
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
                         autoBind:false,
                         editable: true,
                         responsive:['.header',40],
                         id:'id',
                         query: function(params){
                           params.waretype = params.level3 || params.level2
                           return params;
                        },
                         pageable:{
                            pageSize: 20
                         },
                         url: '${base}manager/queryStorageWareWarnPage',
                        criteria: '.form-horizontal',
                          dataBound: function(){
                            var data = this.dataSource.view();
                            $(data).each(function(idx, row){
                                var clazz = ''
                                if(parseFloat(row.sumQty) < parseFloat(row.warnQty)){
                                    clazz = 'row-color-red';
                                    $('#grid tr[data-uid='+row.uid+']').addClass(clazz);
                                }

                            })
                        },
                        loadFilter: {
                          data: function (response) {
                            return response.rows || []
                          },
                          total: function (response) {
                            return response.total;
                          }
                         }
                    ">
                        <div data-field="wareNm">商品名称</div>
                        <div data-field="wareGg">规格</div>
                        <div data-field="unitName">单位</div>
                        <div data-field="sumQty" uglcw-options="format: '{0:n2}',titleAlign:'center',align:'right'">库存数量
                        </div>
                        <div data-field="warnQty"

                             uglcw-options="width: 100,
                            schema:{ type: 'number',decimals:10}"
                        >预警数量</div>
                        <div data-field="status" uglcw-options="template: uglcw.util.template($('#status-tpl').html()),hidden:true">状态
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script id="status-tpl" type="text/x-uglcw-template">
    #if(parseFloat(data.sumQty) >= parseFloat(data.warnQty)){#
    <span class="k-success k-button">正常</span>
    #}else {#
    <span class="k-error k-button">预警</span>
    #}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.layout.init();

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
                if ((e.field === 'warnQty')) {
                    saveData(item);
                }
                uglcw.ui.get('#grid').commit();
            }
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })



        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#ignoreZero').on('change', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#checkScope').on('change', function () {
            if ($("#checkScope").is(":checked") == true) {
                uglcw.ui.get('#scope').value(2);
                uglcw.ui.get('#grid').reload();
            }else{
                uglcw.ui.get('#scope').value("");
                uglcw.ui.get('#grid').reload();
            }
        })

        uglcw.ui.loaded()
    })
    function onWareTypeSelect(e, isType){
        var node = this.dataItem(e.node);
        uglcw.ui.get('#type').value(isType);
        if(node.id == 0){
            uglcw.ui.get('#level2').k().dataSource.read();
            uglcw.ui.get('#level2').value('');
            uglcw.ui.get('#level3').k().dataSource.data([]);
            uglcw.ui.get('#level3').value('');
        }else if(node.pid == 0){
            uglcw.ui.get('#level2').k().dataSource.read();
            uglcw.ui.get('#level2').value(node.id);
            uglcw.ui.get('#level3').k().dataSource.data([]);
            uglcw.ui.get('#level3').value('');
        }else if(node.pid > 0){
            uglcw.ui.get('#level2').k().dataSource.read();
            uglcw.ui.get('#level2').value(node.pid);
            uglcw.ui.get('#level3').k().dataSource.read();
            uglcw.ui.get('#level3').value(node.id);
        }
        uglcw.ui.get('#grid').reload();
    }

    function saveData(item){
        if(item.warnQty==''){
            item.warnQty=0;
        }
        var data = {
            "id":item.wareId,
            "field":'minWarnQty',
            "val":item.warnQty,
            'price':0
        };
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/updateWareSpec',
            type: 'post',
            data: data,
            async: false,
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp === 1) {
                    uglcw.ui.success('更新成功');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error('更新失败');
                }
            }
        })
    }

</script>
</body>
</html>
