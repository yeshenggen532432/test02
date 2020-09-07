<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>车销收款记录</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
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
            color: #FF00FF;
            font-weight: bold;
        }

        .row-color-red {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query" id="export">
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status">
                        <option value="">全部</option>
                        <option value="-2">暂存</option>
                        <option value="1" selected>未入账</option>
                        <option value="2">作废单</option>
                        <option value="3">已入账</option>
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="收款单号">
                </li>
                <li>
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="订单号">
                </li>

                <li>
                <tag:select2 name="stkId" id="stkId"
                             tableName="stk_storage"
                             whereBlock="sale_car=1"
                             headerKey="" headerValue="--请选择--"
                             placeholder="车销库"
                             displayKey="id" displayValue="stk_name"/>
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
                    align: 'center',
                    dblclick:function(row){
                      showDetail(row);
                    },
                    pageable: true,
                    url: 'manager/stkCarRecMast/page',
                    criteria: '.query',
                   ">
                <div data-field="billNo" uglcw-options="width:170">收款单号</div>
                <div data-field="stkNm" uglcw-options="width:160">车销仓库</div>
                <div data-field="orderNo" uglcw-options="width:170">订单号</div>
                <div data-field="proName" uglcw-options="width:160">往来对象</div>
                <div data-field="recTimeStr" uglcw-options="width:160">收款时间</div>
                <div data-field="staff" uglcw-options="width:100">车销人员</div>
                <div data-field="sumAmt"
                     uglcw-options="width:140, footerTemplate: '#= uglcw.util.toString(data.sumAmt,\'n2\')#'">收款金额
                </div>
                <div data-field="options"
                     uglcw-options="width:250, template: uglcw.util.template($('#op-tpl').html()) ">操作
                </div>
                <div data-field="status"
                     uglcw-options="width:80, template: uglcw.util.template($('#formatterStatus').html())">状态
                </div>
                <div data-field="remarks" uglcw-options="width:140">备注</div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="stk-rec-dialog">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6">收款账号</label>
                    <div class="col-xs-18">
                        <input uglcw-validate="required" uglcw-role="combobox" id="accId" uglcw-model="accId" uglcw-options="
                            url: '${base}manager/queryAccountList',
                            loadFilter: {
                                data: function(response){
                                    return response.rows || []
                                }
                            },
                            dataTextField: 'accName',
                            dataValueField: 'id'
                        "></input>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-18">
                        <textarea uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<script type="text/x-uglcw-template" id="op-tpl">
    # if(data.id){ #
    # if(data.status != 2&&data.status != 3){ #
    <a class="k-button k-info" onclick="cancelRec(#= data.id#)">作废
    </a>
    # } #

    # if(data.status==1){ #
    <a class="k-button k-info" onclick="toRec(#= data.id#)">确定入账</a>
    # } #

    #}#
</script>

<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status==-2){#
    暂存
    #}else if(data.status==2){#
    已作废
    #}else if(data.status==1){#
    未入账
    #}else if(data.status==3){#
    已入账
    #}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        });
        uglcw.ui.loaded()
    })

    function cancelRec(id) {
        uglcw.ui.confirm('是否确认作废收款单？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: "${base}manager/stkCarRecMast/cancelStatus",
                type: "post",
                data: {
                    billId:id
                },
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败：' + json.msg);
                    }
                },
                error: function () {
                    uglcw.ui.error('操作失败');
                    uglcw.ui.loaded();
                }
            });
        });
    }

    function toRec(billId) {
        var rtn = uglcw.ui.Modal.open({
            title: '车销收款入账',
            content: $('#stk-rec-dialog').html(),
            width: 350,
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var form = uglcw.ui.get($(container).find('.form-horizontal'));
                if (!form.validate()) {
                    return false;
                }
                var data = uglcw.ui.bind($(container));
                uglcw.ui.confirm('您确认入账吗', function () {
                    uglcw.ui.loading();
                    $.ajax({
                        url: '${base}manager/stkCarRecMast/saveRecMast',
                        data: {
                            billId:billId,
                            accId: data.accId,
                            remarks: data.remarks
                        },
                        type: 'post',
                        success: function (response) {
                            uglcw.ui.loaded();
                            if (response.state) {
                                uglcw.ui.Modal.close(rtn);
                                uglcw.ui.success(response.msg || '操作成功');
                                uglcw.ui.get('#grid').reload();
                            } else {
                                if(response.flag==3){
                                    uglcw.ui.error(response.msg+'》<a style="color:blue" href="javascript:showSaleBill('+response.billId+')">去审批</a>');
                                }else{
                                    uglcw.ui.error(response.msg || '操作失败');
                                }

                            }
                        },
                        error: function () {
                            uglcw.ui.loaded();
                        }
                    })
                })
                return false;
            }
        })


    }
    function showSaleBill(id) {
        uglcw.ui.openTab('销售发票', "${base}manager/showstkout?dataTp=1&billId=" + id)
    }


    function showDetail(row) {
        uglcw.ui.openTab('车销收款记录信息', '${base}manager/stkCarRecMast/show?billId=' + row.id);
    }
</script>
</body>
</html>
