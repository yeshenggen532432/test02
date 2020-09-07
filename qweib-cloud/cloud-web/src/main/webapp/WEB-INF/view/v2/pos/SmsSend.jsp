<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>门店用户组设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        ul.uglcw-query>li .layui-textarea{
            width: 300px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
                <div class="layui-form-item layui-form-text">
                    <label class="layui-form-label">短信内容</label>
                    <div class="layui-input-block">
                        <textarea name="desc" placeholder="请输入内容" id="edtMsg" class="layui-textarea"></textarea>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button class="layui-btn" lay-submit lay-filter="formDemo" onclick="submitSend();">立即提交</button>
                        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                    </div>
                </div>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
						    responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,

                    		criteria: '.query',
                    	">

                <div data-field="cstName" uglcw-options="width:'auto',tooltip:true">姓名</div>

                <div data-field="tel" uglcw-options="width:'auto'">电话</div>
                <div data-field="dataType" uglcw-options="width:'auto'">类型</div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>

    <a role="button" href="javascript:del();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>删除
    </a>
</script>

<script id="isSupper" type="text/x-uglcw-template">
    # if(data.isSupper === 0){ #
    普通用户
    # }else if(data.isSupper === 1){ #
    超级用户
    # } #
</script>

<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <label class="control-label col-xs-6">*门店角色名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="groupName" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="remarks" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="remarks" uglcw-role="textbox">
                    </div>
                </div>

            </form>
        </div>
    </div>
</script>
<tag:compositive-mutiselector-template index="2"/>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        


        uglcw.ui.loaded();
    })


    //-----------------------------------------------------------------------------------------

    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            $(selection).each(function (j, item) {
                removeRow(item.id);
            });
        }


    }

    //添加
    function add() {
        //addRow('testl','13774659914','客户');
        showTelSelector();
    }

    //修改
    function update() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //添加或修改
    function edit(row) {
        uglcw.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                if (row) {
                    uglcw.ui.bind($(container), row);
                }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/pos/savePosGroup',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp == '1') {
                            uglcw.ui.success('保存成功');
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

    function addRow(cstName,tel,dataType) {
        uglcw.ui.get('#grid').addRow({
            id: kendo.guid(),
            cstName: cstName,
            tel: tel,
            dataType: dataType

        });
    }



    function removeRow(id) {
    var data1=uglcw.ui.get('#grid').k().dataSource.data();
    for(var i = 0;i<data1.length;i++)
    {
        if(data1[i].id == id)
        {
            data1.splice(i,1);
            break;
        }
    }

    uglcw.ui.get('#grid').data('_change', true);//.reload('aa',{data:data1});



    }

    var showCustomerDialog = false;
    function showTelSelector() {

        if ($('.consignee-selector').length > 0) {
            return
        }
        <tag:compositive-mutiselector-script  title="请选择客户" callback="onCustomerSelect1" />
        showCustomerDialog = true;

    }

    function onCustomerSelect(id, name, type, item) {

    }
    function onCustomerSelect1(data,type) {
        if (!data || data.length < 1) {
            return;
        }

        var rows = $.map(data, function(row){
            if(type ==0){
                return {
                    cstName: row.proName,
                    tel: row.tel,
                    type: '供应商'
                }
            }else if(type == 1){
                return {
                    cstName: row.memberNm,
                    tel: row.memberMobile,
                    type: '员工'
                }
            }else if(type == 2){
                return {
                    cstName: row.khNm,
                    tel: row.mobile,
                    type: '客户'
                }
            } else if (type == 3){
                return {
                    cstName: row.proName,
                    tel: row.mobile,
                    type: '往来单位'
                }
            }
        })
        var grid = uglcw.ui.get('#grid');
        grid.value(grid.value().concat(rows));
       /* for(var i = 0;i<data.length;i++)
        {
            if(type == 0) {
                var cstName = data[i].proName;
                var tel = data[i].tel;
                var type = '供应商';
                addRow(cstName, tel, type);
            }
            if(type == 1) {
                var cstName = data[i].memberNm;
                var tel = data[i].memberMobile;
                var type = '员工';
                addRow(cstName, tel, type);
            }

            if(type == 2) {
                var cstName = data[i].khNm;
                var tel = data[i].mobile;
                var type = '客户';
                addRow(cstName, tel, type);
            }
            if(type == 3) {
                var cstName = data[i].proName;
                var tel = data[i].mobile;
                var type = '往来单位';
                addRow(cstName, tel, type);
            }

        }*/
    }

        function submitSend() {
            var msg = $("#edtMsg").val();
            if(msg == '')
            {
                alert("请输入短信内容");
                return;
            }
            var data1=uglcw.ui.get('#grid').k().dataSource.data();
            $.ajax({
                url: "${base}manager/pos/sendSysMsg",
                type: "post",
                data: {
                    jsonStr: JSON.stringify(data1),
                    msg: msg

                },
                success: function (data) {
                    if (data == '1') {
                        alert("发送成功");
                    } else {
                        uglcw.ui.error("保存失败");
                    }
                }
            });

        }

        function resetMsg() {
            $("#edtMsg").val("");

        }



</script>
</body>
</html>
