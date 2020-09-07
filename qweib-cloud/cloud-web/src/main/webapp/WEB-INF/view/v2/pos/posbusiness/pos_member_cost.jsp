<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>优惠券发行</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-header">卡类型名称</div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">
                    <div uglcw-role="tree" id="wareGroupTree"
                         uglcw-options="
							url: '${base}manager/pos/queryMemberTypeTree',
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#cardType').value(node.id);
								uglcw.ui.get('#grid').reload();
                       		}
                    	">
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="cardType" id="cardType" value="0" uglcw-role="textbox">
                            <tag:select2 id="shopName" name="shopName" displayKey="shop_no" headerKey=""
                                         headerValue="全部门店" onchange="queryShopWare(0)" displayValue="shop_name"
                                         tableName="pos_shopinfo"/>
                        </li>
                        <li>
                            <input uglcw-model="name" uglcw-role="textbox" placeholder="姓名">
                        </li>
                        <li>
                            <input uglcw-model="cardNo" uglcw-role="textbox" placeholder="卡号">
                        </li>
                        <li>
                            <input uglcw-model="mobile" uglcw-role="textbox" placeholder="电话">
                        </li>
                        <li>
                            <select uglcw-model="status" uglcw-role="combobox" placeholder="状态">
                                <option value="-2">全部</option>
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
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                            responsive:['.header',40],
							id:'id',
							toolbar: uglcw.util.template($('#toolbar').html()),
							checkbox:true,
							pageable:{
								pageSize: 20
							},
                    		url: '${base}manager/pos/queryMemberPage',
                    		criteria: '.form-horizontal',
                    	">
                        <div data-field="name" uglcw-options="width:100,tooltip: true">会员名称</div>
                        <div data-field="cardNo" uglcw-options="width:150">卡号</div>
                        <div data-field="mobile" uglcw-options="width:130">电话</div>
                        <div data-field="typeName" uglcw-options="width:100">会员类型</div>
                        <div data-field="inputCash" uglcw-options="width:100,format: '{0:n2}'">剩余金额</div>
                        <div data-field="freeCost" uglcw-options="width:100">剩余赠送</div>
                        <div data-field="status"
                             uglcw-options="width:100,template: uglcw.util.template($('#status').html())">状态
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:initclick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-dollar"></span>扣款
    </a>
</script>
<script id="status" type="text/x-uglcw-template">
    # if(data.status == -1){ #
    退卡
    # }else if(data.status == 0){ #
    退卡
    # }else if(data.status == 1){ #
    正常
    # } #
</script>

<script type="text/x-uglcw-template" id="top_up">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-8">消费金额:</label>
                    <div class="col-xs-12">
                        <input uglcw-model="costAmt" id="costAmt" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">手工单号:</label>
                    <div class="col-xs-12">
                        <input uglcw-model="docNo" uglcw-role="textbox" id="docNo">
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })


    //=======================================================================
    function getIds() {
        var ids = '';
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            for (var i = 0; i < selection.length; i++) {
                if (ids != '') {
                    ids = ids + ",";
                }
                ids += selection[i].memId;
            }

        }
        return ids;
    }

    function initclick() {
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (!selection || selection.length == 0) {
            return uglcw.ui.warning("请选择会员");
        }
        if (selection.length > 1) {
            return uglcw.ui.warning("只能选择一个会员");
        }
        uglcw.ui.Modal.open({
            content: $('#top_up').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var data = uglcw.ui.bind($(container).find('form'));
                data.id=selection[0].id;
                data.shopNo = uglcw.ui.get('#shopName').value();
                data.shopNo=9999;
                if(data.costAmt == 0){
                    return uglcw.ui.warning('请输入金额');
                }
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/pos/cardConsumeProc',
                    type: 'post',
                    data: data,
                    success: function (data) {
                        uglcw.ui.loaded();
                        if (data.state) {
                            uglcw.ui.success('操作成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })
    }
</script>
</body>
</html>
