<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>内部转存</title>
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
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="转存单号">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="单据状态" uglcw-options="value: ''">
                        <option value="1">已审核</option>
                        <option value="0">未审核</option>
                        <option value="2">作废</option>
                        <option value="3">被冲红单</option>
                        <option value="4">冲红单</option>
                    </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li style="width: 250px !important;padding-top: 5px">
                    <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>
                    &nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>
                    &nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                         toolbar: kendo.template($('#toolbar').html()),
                       dblclick:function(row){
                            newBill(row);
                       },
                    responsive:['.header',40],
                    id:'id',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.uglcw-query.form-horizontal',
                    url: 'manager/queryFinTransPage',
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
                    },
                    }">
                <div data-field="billNo" uglcw-options="width:160">转存单号</div>
                <div data-field="transTimeStr" uglcw-options="width:160">转移日期</div>
                <div data-field="accName1" uglcw-options="width:140">转出账户</div>

                <div data-field="accName2" uglcw-options="width:140">转入账户</div>
                <div data-field="operator" uglcw-options="width:120">操作员</div>
                <div data-field="transAmt" uglcw-options="width:120">转移金额</div>
                <div data-field="status"
                     uglcw-options="width:80, template: uglcw.util.template($('#formatterStatus').html())">状态
                </div>

                <div data-field="_operator"
                     uglcw-options="width:200, template: uglcw.util.template($('#formatterSt3').html())">操作
                </div>
                <div data-field="remarks" uglcw-options="width:140,tooltip: true">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:newBill();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>转存开单
    </a>
    <%--
    <a role="button" href="javascript:toZf();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>作废
    </a>
    --%>
</script>
<script id="wxdlg" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="transfer_order">
                #if(data.id){#
                <div class="form-group">
                    <label class="col-xs-8 control-label">转存单号</label>
                    <div class="col-xs-14" style="margin-top: 7px; font-weight: bold">
                        <span>#= data.billNo#<span> <span style="color:red;">#= data.billStatus#</span></div>
                </div>
                #}#
                <div class="form-group">
                    <input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="0">
                    <input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status" value="0">
                    <label class="control-label col-xs-8">转出账户</label>
                    <div class="col-xs-14">
                        <select uglcw-role="combobox" uglcw-model="saccId" uglcw-validate="required"
                                uglcw-options="
                                  url: '${base}manager/queryAccountList',
                                  loadFilter:{
                                    data: function(response){return response.rows ||[];}
                                  },
                                  dataTextField: 'accName',
                                  dataValueField: 'id'
                                "
                        >
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">转入账户</label>
                    <div class="col-xs-14">
                        <select uglcw-role="combobox" uglcw-validate="required" uglcw-model="taccId"
                                uglcw-options="
                                  url: '${base}manager/queryAccountList',
                                  loadFilter:{
                                    data: function(response){return response.rows ||[];}
                                  },
                                  dataTextField: 'accName',
                                  dataValueField: 'id'
                                "

                        >
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">转移金额</label>
                    <div class="col-xs-14">
                        <input uglcw-role="numeric" uglcw-validate="required" id="transAmt" uglcw-model="transAmt"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">收款时间</label>
                    <div class="col-xs-14">
                        <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="transTimeStr">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-14">
                        <textarea uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status==0){#
    未审批
    #}else if(data.status==1){#
    已审批
    #}else if(data.status==2){#
    作废
    #}else if(data.status==3){#
    被冲红单
    #}else if(data.status==4){#
    冲红单
    #}#
</script>
<script type="text/x-kendo-template" id="formatterSt3">
    # if(data.status =='1' || data.status ==0){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#, 1)"><i class="k-icon "></i>作废</button>
    # } #

    # if(data.status =='0'){ #
    <button class="k-button k-success" onclick="auditBill1(#= data.id#, 1)"><i class="k-icon"></i>审核</button>
    # } #

</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.uglcw-query.form-horizontal');
        })
        uglcw.ui.loaded()
    })


    function auditBill1(id) {
        uglcw.ui.confirm('您确认要审核吗？', function () {
            $.ajax({
                url: "manager/updateFinTransAudit",
                type: "post",
                data: "billId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败' + json.msg);
                        return;
                    }
                }
            });
        });
    }

    function cancelBill(id) {
        uglcw.ui.confirm('您确认要作废吗？', function () {
            $.ajax({
                url: "manager/cancelFinTrans",
                type: "post",
                data: "billId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败' + json.msg);
                        return;
                    }
                }
            });
        });
    }

    function newBill(data) {//收款开单
        var rtn = "";
        data = uglcw.extend({
            transAmt: "",
            transTimeStr: uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm'),
            remarks: "",
            status: 0
        }, data);
        var btns = [];
        var actions = []
        if (data.status == 0) {
            btns.push('暂存');
            actions.push(function (c) {
                //uglcw.ui.toast('暂存');
                var validator = uglcw.ui.get($(c).find('.form-horizontal'));
                if (validator.validate()) {
                    var form = uglcw.ui.bind($(c).find('.form-horizontal'));
                    if (form.status == 1) {
                        return uglcw.ui.warning('该单据已审批，不能操作！');
                    }
                    if (form.status == 2) {
                        return uglcw.ui.warning('该单据已作废，不能操作!');
                    }
                    if (form.transAmt == "" || form.transAmt == null) {
                        return uglcw.ui.warning('请输入转存金额');
                    }
                    console.log(form);
                    if (form.taccId == "" || form.saccId == "") {
                        return uglcw.ui.warning('请选择收款账户');
                    }
                    form.status = 0;
                    uglcw.ui.confirm('是否确定暂存？', function () {
                        uglcw.ui.loading();
                        $.ajax({
                            url: '${base}manager/addFinTrans',
                            type: 'post',
                            dataType: 'json',
                            data: form,
                            success: function (response) {
                                uglcw.ui.loaded()
                                if (response.state) {
                                    uglcw.ui.success('暂存成功');
                                    response.billId = response.id;
                                    $('#billStatus').text('暂存成功');
                                    uglcw.ui.get("#billId").value(response.id);
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                    uglcw.ui.Modal.close(rtn);
                                } else {
                                    uglcw.ui.error('提交失败');
                                }
                            },
                            error: function () {
                                uglcw.ui.loaded()
                            }
                        })
                    })
                }
            });
            if (data.id) {
                btns.push('审核');
                actions.push(function (container) {
                    var form = uglcw.ui.bind($(container).find('.form-horizontal'));
                    uglcw.ui.toast('审批')
                    var status = form.status;
                    if (status == 1) {
                        uglcw.ui.error('该单据已审批,不能操作!');
                        return;
                    }
                    if (status == 2) {
                        uglcw.ui.error('该单据已作废，不能操作！');
                        return;
                    }
                    uglcw.ui.confirm('是否确定审批？', function () {
                        uglcw.ui.loading();
                        $.ajax({
                            url: '${base}manager/updateFinTransAudit',
                            type: 'post',
                            data: {billId: form.id},
                            dataType: 'json',
                            success: function (response) {
                                uglcw.ui.loaded();
                                if (response.state) {
                                    uglcw.ui.success('审批成功');
                                    $('#billStatus').text('审批成功');
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                    uglcw.ui.Modal.close(rtn);
                                }
                            }
                        })

                    })

                })
            }

        }
        if (!data.status && !data.id) {
            btns.push('保存并审批')
            actions.push(function (container) {
                //uglcw.ui.toast('保存并审批')
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var form = uglcw.ui.bind($(container).find('.form-horizontal'));
                    if (form.status == 1) {
                        return uglcw.ui.warning('该单据已审批，不能操作！');
                    }
                    if (form.status == 2) {
                        return uglcw.ui.warning('该单据已作废，不能操作!');
                    }
                    if (form.transAmt == "" || form.transAmt == null) {
                        return uglcw.ui.warning('请输入转移金额');

                    }
                    if (form.taccId == "" || form.saccId == "") {
                        return uglcw.ui.warning('请选择收款账户');
                    }
                    form.status = 1;

                    uglcw.ui.confirm('是否确定保存并审批？', function () {
                        uglcw.ui.loading();
                        $.ajax({
                            url: '${base}manager/addFinTrans',
                            type: 'post',
                            dataType: 'json',
                            data: form,
                            success: function (response) {
                                uglcw.ui.loaded()
                                if (response.state) {
                                    uglcw.ui.success('提交成功');
                                    response.billId = response.id
                                    $('#billStatus').text('提交成功');
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                    uglcw.ui.Modal.close(rtn);
                                } else {
                                    uglcw.ui.error('提交失败');
                                }
                            },
                            error: function () {
                                uglcw.ui.loaded()
                            }
                        })
                    })
                } else {
                    uglcw.ui.error('校验失败');
                    return false;
                }
            })
        }

       rtn = uglcw.ui.Modal.open({
            area: '500px',
            okText: '',
            btns: btns,
            content: uglcw.util.template($('#wxdlg').html())(data),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), data);
                if (data.id) {
                    uglcw.ui.enable($(container), false);
                }
            },
            yes: function (container) {
                if (actions.length > 0) {
                    var t = actions[0](container);
                }
                return false;
            },
            btn2: function (c) {
                if (actions.length > 0) {
                    var t = actions[1](c);
                }
                return false;
            },
            btn3: function (c) {
                if (actions.length > 0) {
                    var t = actions[2](c);
                }
                return false;
            }
        });
    }


</script>
</body>
</html>
