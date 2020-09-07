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
                            <input type="hidden" uglcw-model="cardType" id="cardType" uglcw-role="textbox">
                            <select uglcw-model="shopName" uglcw-role="combobox" placeholder="连锁店">
                                <option value="">全部</option>
                            </select>
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
                            <select uglcw-model="status" uglcw-role="combobox" placeholder="状态" uglcw-options="value: ''">
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
                            toolbar: uglcw.util.template($('#toolbar').html()),
							id:'id',
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
    <a role="button" href="javascript:openDialagIssue1();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>优惠券赠送会员
    </a>
    <a role="button" href="javascript:openDialagIssue2();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>发行优惠券
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

<script type="text/x-uglcw-template" id="form-issue1">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-8">选择券类型</label>
                    <div class="col-xs-12">
                        <select uglcw-role="combobox" id="dialog-ticketType1" uglcw-model="ticketTypeSelect"
                                uglcw-options="
                                  url: '${base}manager/pos/queryTicketType',
                                  loadFilter:{
                                    data: function(response){return response.rows ||[];}
                                  },
                                  dataTextField: 'ticketName',
                                  dataValueField: 'id'
                                "
                        >

                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">有效期</label>
                    <div class="col-xs-12">
                        <input uglcw-model="edate" uglcw-role="datepicker" id="dialog-endDate1">
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="form-issue2">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-8">选择券类型</label>
                    <div class="col-xs-12">
                        <select uglcw-role="combobox" id="dialog-ticketType2" uglcw-model="ticketTypeSelect2"
                                uglcw-options="
                                  url: '${base}manager/pos/queryTicketType',
                                  loadFilter:{
                                    data: function(response){return response.rows ||[];}
                                  },
                                  dataTextField: 'ticketName',
                                  dataValueField: 'id'
                                "
                        >

                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">发行数量</label>
                    <div class="col-xs-12">
                        <input uglcw-model="qty" id="dialog-qty2" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">有效期</label>
                    <div class="col-xs-12">
                        <input uglcw-model="edate" uglcw-role="datepicker" id="dialog-endDate2">
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

    //对话框：优惠券赠送会员
    function openDialagIssue1() {
        var ids = getIds();
        if (ids == '') {
            uglcw.ui.toast("请选择要赠送的会员！")
            return;
        }

        uglcw.ui.Modal.open({
            content: $('#form-issue1').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                // if (row) {
                //     uglcw.ui.bind($(container), row);
                // }
            },
            yes: function (container) {
                var ticketType = uglcw.ui.get("#dialog-ticketType1").value();
                var endDate = uglcw.ui.get("#dialog-endDate1").value();
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/pos/PosTicketIssue',
                    type: 'post',
                    data: {
                        memberIds: ids,
                        ticketType: ticketType,
                        endDate: endDate,
                    },
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp.state) {
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

    //对话框：发行优惠券
    function openDialagIssue2() {
        // var ids = getIds();
        // if(ids == ''){
        //     uglcw.ui.toast("请勾选你要操作的行！")
        //     return;
        // }

        uglcw.ui.Modal.open({
            content: $('#form-issue2').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                // if (row) {
                //     uglcw.ui.bind($(container), row);
                // }
            },
            yes: function (container) {
                var qty = uglcw.ui.get("#dialog-qty2").value();
                var ticketType = uglcw.ui.get("#dialog-ticketType2").value();
                var endDate = uglcw.ui.get("#dialog-endDate2").value();
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/pos/PosTicketIssue',
                    type: 'post',
                    data: {
                        qty: qty,
                        ticketType: ticketType,
                        endDate: endDate,
                    },
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp.state) {
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
