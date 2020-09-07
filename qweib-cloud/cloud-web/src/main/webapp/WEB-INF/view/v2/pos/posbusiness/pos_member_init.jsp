<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>会员余额初始化</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                            id:'id',
                            url: 'manager/pos/queryMemberTypeList?dataTp=1',
                            click: function(row){
                                uglcw.ui.bind('.query', {cardType: row.id});//绑定id
                                uglcw.ui.get('#itemgrid').k().setOptions({
                                    autoBind: true
                                })
                            }
                         }">
                        <div data-field="typeName">卡类型名称</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal query" id="export">
                        <li>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="cardType">
                                <tag:select2 id="shopName" name="shopNo" displayKey="shop_no" headerKey=""
                                             headerValue="全部门店" onchange="queryShopWare(0)" displayValue="shop_name"
                                             tableName="pos_shopinfo"/>
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="name" placeholder="姓名">
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="mobile" placeholder="电话">
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="cardNo" placeholder="卡号">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="status" uglcw-options="value: ''" placeholder="状态">
                                <option value="1">正常</option>
                                <option value="0">挂失</option>
                            </select>
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
                    <div id="itemgrid" uglcw-role="grid"
                         uglcw-options="{
                            responsive:['.header',40],
                            toolbar: kendo.template($('#toolbar').html()),
                            id:'id',
                            url: 'manager/pos/queryMemberPage',
                            criteria: '.query',
                            pageable: true,
                            autoBind: false,
                    }">
                        <div data-field="inDate" uglcw-options="
                        width:50, selectable: true, type: 'checkbox', locked: true,
                        headerAttributes: {'class': 'uglcw-grid-checkbox'}
                        "></div>

                        <div data-field="name" uglcw-options="width:160">会员名称</div>
                        <div data-field="cardNo" uglcw-options="width:120">卡号</div>
                        <div data-field="mobile" uglcw-options="width:120">电话</div>

                        <div data-field="typeName" uglcw-options="width:120">会员类型</div>

                        <div data-field="inputCash"
                             uglcw-options="width:120,template: '#= data.inputCash ? uglcw.util.toString(data.inputCash,\'n2\'): \' \'#'">
                            剩余金额
                        </div>

                        <div data-field="freeCost" uglcw-options="width:120">剩余赠送</div>
                        <div data-field="status"
                             uglcw-options="width:120, template: uglcw.util.template($('#formatterSt2').html())">状态
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:initclick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-pencil"></span>余额初始化
    </a>
    <a role="button" href="javascript:toInitQuery();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>初始化记录
    </a>
</script>
<script type="text/x-kendo-template" id="formatterSt2">
    #if(data.status ==-1){#
    退卡
    #}#
    #if(data.status ==0){#
    挂失
    #}#
    #if(data.status ==1){#
    正常
    #}#

</script>
<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="dlg">
                <div class="form-group">
                    <label class="control-label col-xs-8">充值金额</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="inputCash" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">赠送金额</label>
                    <div class="col-xs-14">
                        <input uglcw-model="freeCost" uglcw-role="textbox">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        //搜索
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#itemgrid').reload();
            ;
        })

        uglcw.ui.loaded()

    })

    function initclick() {//余额初始化
        var selection = uglcw.ui.get('#itemgrid').selectedRow();//选中当前行数据
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#t').html(),
                success: function (container) {
                    uglcw.ui.init($(container));
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        var data = uglcw.ui.bind($("#dlg"))
                        if (data.freeCost == "") {
                            data.freeCost = 0;
                        }

                        var ids = selection[0].id;
                        data.ids = ids;
                        $.ajax({
                            url: '${base}manager/pos/posMemberAmtInit',
                            data: data,
                            type: 'post',
                            success: function (json) {
                                if (json.state) {
                                    uglcw.ui.success('操作成功');
                                    uglcw.ui.get('#itemgrid').reload();//刷新页面
                                } else {
                                    uglcw.ui.error("操作失败");
                                }
                            }
                        })
                    } else {
                        uglcw.ui.error('失败');
                        return false;
                    }
                }
            });
        } else {
            uglcw.ui.warning('请选择会员！');
        }
    }

    //初始化记录
    function toInitQuery() {
        uglcw.ui.openTab("余额初始化记录", "${base}manager/pos/toPosMemberInitQuery");
    }
</script>
</body>
</html>