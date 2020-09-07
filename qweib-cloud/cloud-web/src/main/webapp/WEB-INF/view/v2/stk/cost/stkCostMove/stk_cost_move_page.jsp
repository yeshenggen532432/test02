<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>移库成本列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<style>
    .product-grid td {
        padding: 0;
    }
    .row-color-blue {
        color: blue;
        text-decoration: line-through;
        font-weight: bold;
    }

    .row-color-pink {
        color: #FF00FF !important;
        font-weight: bold;
    }

    .row-color-red {
        color: red!important;
        font-weight: bold;
    }
</style>
<tag:mask/>
<div class="layui-fluid page-list">
    <div class="layui-card header">
        <div class="lyaui-card-header actionbar btn-group">

        </div>
        <div class="layui-card-body full" style="padding-left: 5px;">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="成本单号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="往来对象">
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="商品名称" uglcw-model="wareNm">
                </li>
                <li>
                    <input type="hidden" uglcw-role="textbox" uglcw-model="isType" value="0" id="isType">
                    <input uglcw-role="gridselector" uglcw-model="wtypename,waretype" id="waretype" placeholder="资产类型"
                           uglcw-options="
                           value:'库存商品类',
                           click:function(){
                                    waretype()
                           }
                    ">
                </li>
                
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                <select uglcw-role="combobox" uglcw-model="status" placeholder="单据状态">
                    <option value="0">正常单</option>
                    <option value="3">被冲红单</option>
                    <option value="4">冲红单</option>
                </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>
                </li>
                <li style="width: 300px !important; padding-top: 5px" >
                    <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>
                    &nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                    responsive:['.header',20],
                    id:'id',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.form-horizontal',
                    dblclick: function(row){
                        uglcw.ui.openTab('销售成本'+row.id,'${base}manager/cost/stkCostMove/show?billId='+row.fdId);
                    },
                    url: '${base}manager/cost/stkCostMove/pages',
                    criteria: '.form-horizontal',
                     dataBound: function(){
                        var data = this.dataSource.view();
                        $(data).each(function(idx, row){
                            var clazz = ''
                            if(row.status == 2){
                                clazz = 'row-color-blue';
                            }else if(row.status == 3){
                                clazz = 'row-color-pink';
                            }else if(row.status == 4){
                                clazz = 'row-color-red';
                            }
                            $('#grid tr[data-uid='+row.uid+']').addClass(clazz);
                        })
                    }
                    }">
                <div data-field="billNo" uglcw-options="width:160,tooltip: true">成本单号</div>
                <div data-field="billType" uglcw-options="width:160,tooltip: true">移库类型</div>
                <div data-field="proName" uglcw-options="width:120,tooltip: true">往来对象</div>
                <div data-field="billTime" uglcw-options="width:160, template: uglcw.util.template($('#time-tpl').html())">成本日期</div>
                <div data-field="outAmt" uglcw-options="width:100">移库金额</div>
                <div data-field="inAmt" uglcw-options="width:100">成本金额</div>
                <div data-field="count" uglcw-options="width:500, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.subList);
                         }
                        ">商品信息
                </div>
                <div data-field="sourceBillNo" uglcw-options="width:140,
                                 template: function(dataItem){
                           return kendo.template($('#source-bill-no').html())(dataItem)}">关联移库单号</div>
                <div data-field="createName" uglcw-options="width:100">创建人</div>
            </div>
        </div>
    </div>
</div>


<script id="source-bill-no" type="text/x-kendo-template">
    <a href="javascript:showSourceBillNo(#=data.sourceBillId#);" style="color:red;font-size: 12px; font-weight: bold;">#=data.sourceBillNo#</a>
</script>

<script type="text/x-uglcw-template" id="time-tpl">
    <span>#= uglcw.util.toString(new Date(data.billTime), 'yyyy-MM-dd HH:mm')#</span>
</script>
<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 80px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 40px;">数量</td>
            <td style="width: 60px;">成本金额</td>
            <td style="width: 60px;">移库金额</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= uglcw.util.toString(data[i].outQty,'n2') #</td>
            <td>#= uglcw.util.toString(data[i].inAmt,'n2') #</td>
            <td>#= uglcw.util.toString(data[i].outAmt,'n2') #</td>
        </tr>
        # }#
        </tbody>
    </table>
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
        var grid = uglcw.ui.get('#grid');
        //显示商品明细
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();

            if (checked) {
                grid.showColumn('count');
            } else {
                grid.hideColumn('count');
            }
        });
        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })
        uglcw.ui.loaded()
    })

    function showSourceBillNo(id) {
        uglcw.ui.openTab('移库信息' + id, "${base}manager/stkMove/show?dataTp=1&billId=" + id)
    }
    function waretype() {
        var i = uglcw.ui.Modal.open({
            checkbox:true,
            selection:'single',
            title:false,
            maxmin:false,
            resizable:false,
            move:true,
            btns:['确定','取消'],
            area:['400','415px'],
            content:$('#product-type-selector-template').html(),
            success:function (c) {
                uglcw.ui.init(c);

            },
            yes:function (c) {
                uglcw.ui.get("#isType").value(uglcw.ui.get($(c).find('#_isType')).value())
                uglcw.ui.get("#waretype").value(uglcw.ui.get($(c).find('#wtypename')).value());
                uglcw.ui.get("#waretype").text(uglcw.ui.get($(c).find('#_type_id')).value());
                uglcw.ui.Modal.close(i);
                return false;

            }
        })
    }
</script>
</body>
</html>
