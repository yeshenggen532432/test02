<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
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
                    <select uglcw-role="combobox" uglcw-model="accType" uglcw-options="value:''" id="accType" placeholder="类型">
                        <option value="0">现金</option>
                        <option value="1">微信</option>
                        <option value="2">支付宝</option>
                        <option value="3">银行卡</option>
                        <option value="4">无卡账号</option>
                    </select>
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="status" value="${status}" uglcw-role="textbox">
                    <ul id="chkStatus" uglcw-role="radio" uglcw-model="status"
                        uglcw-value="0"
                        uglcw-options='layout:"horizontal",
                                    dataSource:[{"text":"正常","value":"0"},{"text":"停用","value":"1"}]
                                    '></ul>
                </li>
                <li style="width: 500px!important;display: inline-flex;">
                    <button uglcw-role="button" class="k-info ghost" onclick="updatePostAccount()">销售一键过账账户</button>
                    <button uglcw-role="button" class="k-info ghost" onclick="updatePayAccount()">默认付款账户</button>
                    <button uglcw-role="button" class="k-info ghost" onclick="toEdit()">修改</button>
                    <button uglcw-role="button" class="k-info ghost" onclick="updateAccountStatus(1)">禁用</button>
                    <button uglcw-role="button" class="k-info ghost" onclick="updateAccountStatus(0)">启用</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                            responsive:['.header',40],
                            toolbar: kendo.template($('#toolbar').html()),
                            id:'id',
                            editable: true,
                            url: '${base}manager/queryAccountLists',
                            criteria: '.query',
                    }">

                <div data-field="accName" uglcw-options="width:140,
                             editor: function(container, options){
                             var model = options.model;
                             if(model.accNo=='666'
                                ||model.accNo=='000'
                                ){
                                return;
                             }
                             var input = $('<input name=\'accType\' data-bind=\'value:accType\'>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.ComboBox(input);
                             widget.init({
                              clearButton:false,
                              value: model.accType,
                              change: function(){
                                //alert(this.text());
                                model.accName=this.text();
                                 $.ajax({
                                    url: '${base}manager/updateAccount',
                                            type: 'post',
                                            data: 'id=' + model.id +  '&value='+this.value()+'&field=accType',
                                            success: function (data) {
                                            if (data.state) {
                                            uglcw.ui.toast('更新成功');
                                            } else {
                                            uglcw.ui.toast('更新失败');
                                            }
                                            }
                                            });
                              },
                               dataSource:[
                                {text:'现金',value:0},
                                {text:'微信',value:1},
                                {text:'支付宝',value:2},
                                {text:'银行卡',value:3},
                                {text:'无卡账号',value:4}
                                ]
                             })
                             }
                        ">账号类型
                </div>
                <div data-field="accNo" uglcw-options="width:160">账号</div>
                <div data-field="bankName" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_bankName').html()),
								template:function(row){
									return uglcw.util.template($('#fieldTemplate').html())({val:row.bankName, data: row, field:'bankName'})
								}
								">
                </div>
                <div data-field="isPost"
                     uglcw-options="width:120,template: uglcw.util.template($('#formatterPost').html())">是否过账账户
                </div>
                <div data-field="isPay"
                     uglcw-options="width:140, template: uglcw.util.template($('#formatterPay').html())">是否默认付款账户
                </div>

                <div data-field="remarks" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_remarks').html()),
								template:function(row){
									return uglcw.util.template($('#fieldTemplate').html())({val:row.remarks, data: row, field:'remarks'})
								}
								">
                </div>
            </div>
        </div>
    </div>
</div>

<script id="header_bankName" type="text/x-uglcw-template">
    <span onclick="javascript:operateField('bankName');">银行名称✎</span>
</script>
<script id="header_remarks" type="text/x-uglcw-template">
    <span onclick="javascript:operateField('remarks');">备注✎</span>
</script>
<script id="fieldTemplate" type="text/x-uglcw-template">
    # var accId = data.id #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="text-box"
           style="height:25px;display:none" onchange="changeField(this,'#= field #',#= accId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=accId#">#= val #</span>
</script>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:addBankClick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-circle"></span>增加银行账号
    </a>
    <a role="button" href="javascript:addWxClick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-circle"></span>增加微信账号
    </a>
    <a role="button" href="javascript:addZfbClick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-circle"></span>增加支付账号
    </a>
    <a role="button" href="javascript:addWkClick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-circle"></span>增加无卡账号
    </a>
    <a role="button" href="javascript:showTemplate();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-circle"></span>数据参考
    </a>
</script>

<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="bankdlg">
                <div class="form-group">
                    <label class="control-label col-xs-8">账号</label>
                    <div class="col-xs-14">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="accType" value="3">
                        <input type="hidden" uglcw-model="id" uglcw-role="textbox"/>
                        <input uglcw-role="textbox" uglcw-model="accNo" value="${accNo}"
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">银行</label>
                    <div class="control-label col-xs-14">
                        <select uglcw-role="combobox" uglcw-model="bankName"
                                uglcw-options="
                                url: '${base}manager/queryBank',
                                loadFilter: {
                                data:function(response){
                                 var rows = response.rows || []
                                 var i = 0;
                                 return $.map(rows, function(row){
                                    return {
                                       text: row,
                                       value:row
                                    }
                                 })
                                }
                                }"
                        >

                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-14">
                        <textarea uglcw-role="textbox" uglcw-model="remarks" value="${remarks}"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<script id="wxdlg" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="wechat_account">
                <div class="form-group">
                    <label class="control-label col-xs-8">账号</label>
                    <div class="col-xs-14">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="accType" value="1">
                        <input uglcw-role="textbox" uglcw-model="accNo" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-14">
                        <textarea type="hidden" uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>


<script id="zfbdlg" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="alipay_account">
                <div class="form-group">
                    <label class="control-label col-xs-8">账号</label>
                    <div class="col-xs-14">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="accType" value="2">
                        <input uglcw-role="textbox" uglcw-model="accNo" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-14">
                        <textarea type="hidden" uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<script id="wkdlg" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="no_card">
                <div class="form-group">
                    <label class="control-label col-xs-8">账号</label>
                    <div class="col-xs-14">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="accType" value="4">
                        <input uglcw-role="textbox" uglcw-model="accNo" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-14">
                        <textarea type="hidden" uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/x-kendo-template" id="formatterPost">
    #if(data.isPost==1){#
    是
    #}else{#
    #}#
</script>
<script type="text/x-kendo-template" id="formatterPay">
    #if(data.isPay==1){#
    是
    #}else{#
    #}#
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#chkStatus').on('change', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.get('#accType').on('change', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded()
    })

    function operateField(field) {
        var display = $("." + field + "_input").css('display');
        if (display == 'none') {
            $("." + field + "_input").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").hide();
            $("." + field + "_span").show();
        }
    }

    function changeField(o, field, accId) {
        $.ajax({
            url: "${base}manager/updateAccount",
            type: "post",
            data: "id=" + accId + "&value=" + o.value + "&field=" + field,
            success: function (data) {
                if (data.state) {
                    uglcw.ui.toast("更新成功");
                    uglcw.ui.get('#grid').reload();
                    $("#" + field + "_span_" + accId).text(o.value);
                } else {
                    uglcw.ui.toast("更新失败");
                    uglcw.ui.get('#grid').reload();
                }
            }
        });
    }


    function updatePostAccount() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            $.ajax({
                url: "${base}manager/updatePostAccount",
                data: {id: selection[0].id},
                type: "post",
                success: function (json) {
                    if (json.state) {
                        alert("操作成功！");
                        uglcw.ui.get('#grid').reload();//刷新页面
                    } else {
                        alert(json.msg);
                    }
                }
            });
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function updatePayAccount() {//默认付款账户
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            $.ajax({
                url: "manager/updatePayAccount",
                data: {id: selection[0].id},
                type: "post",
                success: function (json) {
                    if (json.state) {
                        alert("操作成功！");
                        uglcw.ui.get('#grid').reload();//刷新页面
                    } else {
                        alert(json.msg);
                    }
                }
            });
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function showTemplate() {//数据参考
        uglcw.ui.openTab('账号参考数据', '${base}manager/toAccountTemplate');

    }

    function addBankClick() {//增加银行账号
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#t').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var id = $("#accId").val();
                    var data = uglcw.ui.bind($("#bankdlg"));
                    data.id = id;
                    $.ajax({
                        url: '${base}/manager/saveAccount',
                        data: data,
                        type: 'post',
                        success: function (json) {
                            if (json.state) {
                                uglcw.ui.success('保存成功');
                                uglcw.ui.get('#grid').reload();//刷新页面
                            } else {
                                uglcw.ui.error("保存失败" + json.msg);
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });
    }

    function addWxClick() {//增加微信支付
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#wxdlg').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var id = $("#accId").val();
                    var data = uglcw.ui.bind($("#wechat_account"))
                    data.id = id;
                    $.ajax({
                        url: '${base}/manager/saveAccount',
                        data: data,
                        type: 'post',
                        success: function (json) {
                            if (json.state) {
                                uglcw.ui.success('保存成功');
                                uglcw.ui.get('#grid').reload();//刷新页面
                            } else {
                                uglcw.ui.error("保存失败" + json.msg);
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });
    }

    function addZfbClick() {//增加支付账号
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#zfbdlg').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var id = $("#accId").val();
                    var data = uglcw.ui.bind($("#alipay_account"))
                    data.id = id;
                    $.ajax({
                        url: '${base}/manager/saveAccount',
                        data: data,
                        type: 'post',
                        success: function (json) {
                            if (json.state) {
                                uglcw.ui.success('保存成功');
                                uglcw.ui.get('#grid').reload();//刷新页面
                            } else {
                                uglcw.ui.error("保存失败" + json.msg);
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });
    }

    function addWkClick() {//增加无卡账号
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#wkdlg').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var id = $("#accId").val();
                    var data = uglcw.ui.bind($("#no_card"))
                    data.id = id;
                    $.ajax({
                        url: '${base}/manager/saveAccount',
                        data: data,
                        type: 'post',
                        success: function (json) {
                            if (json.state) {
                                uglcw.ui.success('保存成功');
                                uglcw.ui.get('#grid').reload();//刷新页面
                            } else {
                                uglcw.ui.error("保存失败" + json.msg);
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });
    }

    function validate(callback) {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            if (selection[0].accType == 0 || selection[0].bankName == "未指定系统默认收付款账户") {
                uglcw.ui.warning("系统默认账号不能修改")
                return;
            }
            callback(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的行数据');
        }

    }

    function toEdit() {//修改
        validate(function (row) {

            if(row.accNo=='666'
                ||row.accNo=='000'
            ){
                return;
            }

            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#t').html(),
                success: function (container) {
                    uglcw.ui.init($(container));
                    uglcw.ui.bind($(container), row);//把数据赋值给弹框
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        var data = uglcw.ui.bind($("#bankdlg"));
                        $.ajax({
                            url: '${base}/manager/saveAccount',
                            data: data,
                            type: 'post',
                            success: function (json) {
                                if (json.state) {
                                    uglcw.ui.success('保存成功');
                                    uglcw.ui.get('#grid').reload();//刷新页面
                                } else {
                                    uglcw.ui.error("保存失败" + json.msg);
                                }
                            }
                        })
                    } else {
                        uglcw.ui.error('失败');
                        return false;
                    }
                }
            });
        })

    }

    function updateAccountStatus(status) {
        validate(function (row) {
            $.ajax({
                url: "${base}manager/updateAccountStatus",
                data: {id: row.id, status: status},
                type: "post",
                success: function (json) {
                    if (json.state) {
                        alert("操作成功！");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        alert(json.msg);
                    }
                }
            })
        })
    }
</script>
</body>
</html>
