<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>门店设置</title>
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
    <div class="layui-row layui-col-space15">
        <%--2右边：表格start--%>
        <div class="layui-col-md12">
            <%--&lt;%&ndash;表格：头部start&ndash;%&gt;--%>
            <div class="layui-card header">
                <div class="layui-card-body">
                    <div class="form-horizontal query">
                        <div class="form-group" style="margin-bottom: 10px;">
                            <div class="col-xs-4">
                                <input uglcw-model="shopName" uglcw-role="textbox" placeholder="门店名称">
                            </div>
                            <div class="col-xs-4">
                                <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                                <button id="reset" class="k-button" uglcw-role="button">重置</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%--表格：头部end--%>

            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
							 responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/pos/queryPosAccSet',
                    		criteria: '.query',
                    	">
                        <div data-field="shopNo" uglcw-options="width:100">店号</div>
                        <div data-field="shopName" uglcw-options="width:150,tooltip:true">店名</div>
                        <div data-field="cashAccName" uglcw-options="width:100">现金支付账号</div>
                        <div data-field="bankAccName" uglcw-options="width:150">银行支付账号</div>
                        <div data-field="memberAccName" uglcw-options="width:150">余额支付账号</div>
                        <div data-field="wxAccName" uglcw-options="width:120">微信支付账号</div>
                        <div data-field="zfbAccName" uglcw-options="width:120">支付宝支付账号</div>

                    </div>
                </div>
            </div>
            <%--表格：end--%>
        </div>
        <%--2右边：表格end--%>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">

    <a role="button" href="javascript:update();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>修改
    </a>

</script>
<%--启用状态--%>
<script id="formatterSt3" type="text/x-uglcw-template">
    # if(data.status == '2'){ #
    <button onclick="javascript:updateIsTy(#= data.id#,1);" class="k-button k-info">启用</button>
    # }else{ #
    <button onclick="javascript:updateIsTy(#= data.id#,2);" class="k-button k-info">停用</button>
    # } #
</script>
<script id="canInput" type="text/x-uglcw-template">
    # if(data.canInput === 0){ #
    不可充值
    # }else if(data.canInput === 1){ #
    可充值
    # } #
</script>
<script id="canCost" type="text/x-uglcw-template">
    # if(data.canCost === 0){ #
    不可消费
    # }else if(data.canCost === 1){ #
    可消费
    # } #
</script>

<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <%--<input uglcw-role="textbox" uglcw-model="canInput" id="canInput" type="hidden">--%>
                    <%--<input uglcw-role="textbox" uglcw-model="canCost" id="canCost" type="hidden">--%>
                    <label class="control-label col-xs-6">*店号</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="shopNo" uglcw-role="textbox" uglcw-validate="required" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">*店名</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="shopName" uglcw-role="textbox" uglcw-validate="required" >
                    </div>
                </div>


                <div class="form-group">
                    <label class="control-label col-xs-6">现金支付账号</label>
                    <div class="col-xs-11">
                        <tag:select2 name="cashAccId" id="cashAccId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--选择账号--" displayKey="id" displayValue="acc_no"/>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-xs-6">银行支付账号</label>
                    <div class="col-xs-11">
                        <tag:select2 name="bankAccId" id="bankAccId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--选择账号--" displayKey="id" displayValue="acc_no"/>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-xs-6">余额支付账号</label>
                    <div class="col-xs-11">
                        <tag:select2 name="memberAccId" id="memberAccId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--选择账号--" displayKey="id" displayValue="acc_no"/>
                    </div>
                </div>


                <div class="form-group">
                    <label class="control-label col-xs-6">微信支付账号</label>
                    <div class="col-xs-11">
                        <tag:select2 name="wxAccId" id="wxAccId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--选择账号--" displayKey="id" displayValue="acc_no"/>
                    </div>
                </div>


                <div class="form-group">
                    <label class="control-label col-xs-6">支付宝支付账号</label>
                    <div class="col-xs-11">
                        <tag:select2 name="zfbAccId" id="zfbAccId" tableName="fin_account" whereBlock="status=0" headerKey="" headerValue="--选择账号--" displayKey="id" displayValue="acc_no"/>
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


        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })


    //-----------------------------------------------------------------------------------------
    //修改启用状态
    function updateIsTy(id,status){
        <%--uglcw.ui.confirm("是否确定操作?", function () {--%>
        <%--$.ajax({--%>
        <%--url: '${base}manager/shopMemberGrade/updateStatus',--%>
        <%--data: {--%>
        <%--id:id,--%>
        <%--status:status--%>
        <%--},--%>
        <%--type: 'post',--%>
        <%--dataType: 'json',--%>
        <%--success: function (response) {--%>
        <%--if(response == "1"){--%>
        <%--uglcw.ui.success("操作成功");--%>
        <%--uglcw.ui.get('#grid').reload();--%>
        <%--}else{--%>
        <%--uglcw.ui.error("操作失败");--%>
        <%--}--%>
        <%--}--%>
        <%--})--%>
        <%--})--%>
    }

    //添加
    function add(){
        edit()
    }
    //修改
    function update(){
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        }else{
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm("确定删除所选记录吗？", function () {
                $.ajax({
                    url:"${base}manager/pos/deletePosShopInfo",
                    data: {
                        id:selection[0].id,
                    },
                    type: 'post',
                    success: function (response) {
                        if(response.state){
                            uglcw.ui.success("删除成功");
                            uglcw.ui.get('#grid').reload();
                        }else{
                            uglcw.ui.error("删除失败");
                        }
                    }
                });
            })
        }else{
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
                    url: '${base}manager/pos/savePosAccSet',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if(resp == '1'){
                            uglcw.ui.success('保存成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        }else{
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
