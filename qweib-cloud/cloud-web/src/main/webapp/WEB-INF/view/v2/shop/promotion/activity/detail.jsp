<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>限时促销价设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-in {
            width: 100%;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card master">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">

                            <li onclick="saveAudit()" class="k-info" data-icon="save">保存</li>

                        <c:if test="${shopActivity.runStatus ==2}">
                            <li onclick="copyActivity(this)" class="k-info" data-icon="copy">复制</li>
                        </c:if>
                    </ul>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${shopActivity.id}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="sourceType" id="sourceType"
                               value="${sourceType}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">活动名称</label>
                            <div class="col-xs-16">
                                <input style="width: 200px;" uglcw-model="title" uglcw-role="textbox"
                                       uglcw-validate="required" value="${shopActivity.title}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">活动时间</label>
                            <div class="col-xs-20">

                                <input style="width: 150px;" uglcw-model="startTime"
                                       uglcw-options="format:'yyyy-MM-dd HH:mm'"
                                       uglcw-role="datetimepicker" uglcw-validate="required"
                                       value="${shopActivity.startTime}">
                                至
                                <input style="width: 150px;" uglcw-model="endTime"
                                       uglcw-options="format:'yyyy-MM-dd HH:mm'"
                                       uglcw-role="datetimepicker" uglcw-validate="required"
                                       value="${shopActivity.endTime}">

                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">备注</label>
                            <div class="col-xs-18">
                                <textarea uglcw-role="textbox" uglcw-model="description"
                                          style="width: 100%;">${shopActivity.description}</textarea>
                            </div>

                        </div>
                        <div class="form-group">
                            <!--<label class="control-label col-xs-3"> 说明</label>
                            <div class="col-xs-18">
                                1、在该促销方案启动后，方案所指定的会员或批发一律按这方案设定的促销价执行，其它个性设置的价格一律无效；<br/>
                                2、同一时间段，同一商品有设置秒杀，按秒杀执行。<br/>
                                3、同一时间段，同一商品有设置秒杀、拼团、组团，由会员选择，如选择按原价购买，则执行有效的促销价。<br/>
                            </div>-->

                        </div>
                    </form>
                </div>
            </div>
            <div class="layui-row layui-col-space15">
                <div class="layui-col-md12">
                    <div class="layui-card">
                        <div class="layui-card-body full">
                            <div id="grid" uglcw-role="grid"
                                 uglcw-options="
                                    id: 'id',
                                    responsive:['.master',40],
                                     height:400,
                                    toolbar: uglcw.util.template($('#toolbar').html()),
                                    pageable: false,
                                    editable: true,
                                    checkbox:true,
                                    <c:if test="${!empty shopActivity}">url: '${base}manager/mall/promotion/activity/findList?activityId=${shopActivity.id}',</c:if>
                                    loadFilter: {
                                        data: function(response){
                                            var data= response.state ? (response.rows || []) : [];
                                             data.map(function(row){
                                                row.originalShopLsPrice=row.shopBaseMaxLsPrice;
                                                row.originalShopPfPrice=row.shopBaseMaxPfPrice;
                                             });
                                            return data;
                                        }
                                    }
                    	         ">
                                <div data-field="wareNm" uglcw-options="width: 210">产品名称</div>
                                <c:if test="${sourceType==1}">
                                    <div data-field="originalLsPrice" uglcw-options="width: 100">原价(进)</div>
                                    <div data-field="originalShopLsPrice" uglcw-options="width: 150">商城零售价</div>
                                    <div data-field="discountLsRate" uglcw-options="hidden:true,width: 100,editable:true">
                                        折扣率(%)
                                    </div>
                                    <div data-field="activityLsPrice" uglcw-options="width: 150,editable:true">促销价（零）
                                    </div>
                                </c:if>

                                <div data-field="originalPfPrice" uglcw-options="width: 100">批发价(进)</div>
                                <div data-field="originalShopPfPrice" uglcw-options="width: 150">商城批发价</div>
                                <c:if test="${sourceType==3}">
                                    <div data-field="discountPfRate" uglcw-options="hidden:true,width: 100,editable:true">
                                        折扣率(%)
                                    </div>
                                    <div data-field="activityPfPrice" uglcw-options="width: 150,editable:true">促销价（批）
                                    </div>
                                </c:if>
                                <div data-field="options" uglcw-options="width: 120, command:'destroy'">操作</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:showAddWare();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加商品
    </a>
    <a role="button" href="javascript:batchRemove();" class="k-button k-button-icontext">
        <span class="k-icon k-i-trash"></span>批量删除
    </a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange') {
                var item = e.items[0];
                var commit = false;
                if (e.field == 'discountLsRate') {
                    //item.set('activityLsPrice', Number(item.originalShopLsPrice * (item.discountLsRate / 100)).toFixed(2));
                    //commit = true;
                } else if (e.field == 'discountPfRate') {
                    //item.set('activityPfPrice', Number(item.originalShopPfPrice * (item.discountPfRate / 100)).toFixed(2));
                    //commit = true;
                }
                if (commit) {
                    uglcw.ui.get('#grid').commit();
                }
            }
        });
    })

    //批量删除
    function batchRemove() {
        uglcw.ui.confirm("是否确定批量删除", function () {
            uglcw.ui.get('#grid').removeSelectedRow(true);
        })
    }

    function saveAudit() {//保存
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');

        //form.orderTp = form.orderTp || "销售订单";
        //form.orderLb = form.orderLb || "电话单";

        var rows = uglcw.ui.get('#grid').bind();//绑定表单数据
        if (rows.length == 0) {
            uglcw.ui.warning("请选择商品！");
            return false;
        }
        if (!form.id) {
            rows = rows.map(function (row) {
                row.id = '';
                return row;
            })
        }
        for(var i in rows){
            var item=rows[i];
            if(!item.activityLsPrice && !item.activityPfPrice){
                uglcw.ui.error("请输入"+(parseInt(i)+1)+"行促销价格！");
                return false;
            }
        }
        form.items = rows;
        uglcw.ui.confirm('是否确定保存?', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/mall/promotion/activity/save',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(form),
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.io.emit('shop_activity_chage',1);
                        uglcw.ui.success(json.message);
                        uglcw.ui.closeCurrentTab();
                    } else {
                        uglcw.ui.error(json.message || '保存失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded()
                }
            })
        })

    }

    function copyActivity(th) {
        uglcw.ui.loading();
        $('#id').val('');
        $(th).text('保存');
        $(th).on('click', function () {
            saveAudit();
        });
        setTimeout(function () {
            uglcw.ui.loaded();
            window.parent.$('.layui-this span').text('复制规则');
        }, 500)
    }

    function showAddWare() {
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                url: '${base}manager/shopWareNewType/shopWaretypesExists',
                lazy: false,
                model: 'waretype',
                id: 'id',
                expandable: function (node) {
                    return node.id == 0;
                },
                loadFilter: function (response) {
                    $(response).each(function (index, item) {
                        if (item.text == '根节点') {
                            item.text = '商品分类'
                        }
                    })
                    return response;
                },
            },
            title: "选择商品",
            width: 800,
            id: 'wareId',
            pageable: true,
            url: '${base}manager/shopWare/page?loadGlobalLsRate=1&loadGlobalPfRate=1',
            query: function (params) {
                //params.stkId = uglcw.ui.get('#stkId').value()
            },
            checkbox: true,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
            columns: [
                {field: 'wareCode', title: '编码', width: 70, tooltip: true},
                {field: 'wareNm', title: '商品名称', width: 150},
                /* {field: 'wareGg', title: '规格', width: 120},*/

                {field: 'lsPrice', title: '原价(进)', width: 100},
                {field: 'shopBaseMaxLsPrice', title: '商城零售价', width: 100},
                /*{field: 'wareDj', title: '批发价(进)', width: 100},*/
                {field: 'shopBaseMaxPfPrice', title: '商城批发价', width: 100}
            ],
            yes: addDetail
        })
    }

    //增加订单商品明细
    function addDetail(data) {
        if (data) {
            var addRows = [];
            var rows = uglcw.ui.get('#grid').bind();
            $(data).each(function (i, item) {
                item = item.toJSON();
                let exists = false;
                rows.forEach(function (row) {
                    if (row.activityWareId == item.wareId) {
                        exists = true;
                        return;
                    }
                })
                if (!exists) {
                    addRows.push(getWareExtract(item))
                }
            })
            if (addRows.length) {
                uglcw.ui.get('#grid').addRow(addRows);//添加到表单
                uglcw.ui.get('#grid').commit();
                uglcw.ui.get('#grid').scrollBottom();
            }
        }
    }

    function getWareExtract(ware) {
        var obj = {};
        obj.wareNm = ware.wareNm;
        obj.activityWareId = ware.wareId;

        obj.originalLsPrice = ware.lsPrice;
        obj.originalShopLsPrice = ware.shopBaseMaxLsPrice;

        obj.originalPfPrice = ware.wareDj;
        obj.originalShopPfPrice = ware.shopBaseMaxPfPrice;
        obj.wareId=ware.wareId;
        return obj;
    }
</script>
</body>
</html>
