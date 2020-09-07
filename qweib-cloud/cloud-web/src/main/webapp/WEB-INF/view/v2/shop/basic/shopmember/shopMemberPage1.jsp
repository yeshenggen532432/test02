<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商城会员信息</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .xxzf-more{
            font-size: 8px;
            color: red;
        }
        .a{
            font-size: 12px;
            color:rebeccapurple;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <%--2右边：表格start--%>
        <div class="layui-col-md12">
            <%--表格：头部start--%>
            <div class="layui-card header">
                <div class="layui-card-body">
                    <div class="form-horizontal query">
                        <div class="form-group" style="margin-bottom: 10px;">
                            <div class="col-xs-4">
                                <input uglcw-model="name" uglcw-role="textbox" placeholder="会员名称">
                            </div>
                            <div class="col-xs-4">
                                <input uglcw-model="mobile" uglcw-role="textbox" placeholder="手机号">
                            </div>
                            <div class="col-xs-4">
                                <tag:select2 name="spMemGradeId" id="spMemGradeId" tableName="shop_member_grade" whereBlock="status=1" headerKey="" headerValue="--会员等级--" displayKey="id" displayValue="grade_name"/>
                            </div>
                            <c:if test="${source=='3'}">
                                <div class="col-xs-4">
                                    <select uglcw-role="combobox" uglcw-model="khClose" placeholder="关闭进销存客户">
                                        <option value="">--关闭进销存客户--</option>
                                        <option value="0">不关闭</option>
                                        <option value="1">关闭</option>
                                    </select>
                                </div>
                            </c:if>
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
                    		url: '${base}manager/shopMember/shopMemberPage?source=${source}',
                    		criteria: '.query',
                    		pageSize: 20,
                    	">
                        <div data-field="name" uglcw-options="width:100">会员名称</div>
                        <div data-field="mobile" uglcw-options="width:110">电话</div>
                        <div data-field="gradeName" uglcw-options="width:100">会员等级</div>
                        <div data-field="customerName" uglcw-options="width:100">关联客户</div>
                        <div data-field="status" uglcw-options="width:100,template: uglcw.util.template($('#status').html())">状态</div>
                        <div data-field="defaultAddress" uglcw-options="width:200,tooltop:true">地址</div>
                        <div data-field="oper" uglcw-options="width:200,template: uglcw.util.template($('#oper').html())">操作</div>
                        <c:if test="${source=='1'}">
                            <div data-field="hySource" uglcw-options="width:100">会员来源</div>
                        </c:if>
                        <div data-field="isXxzf" uglcw-options="width:100,template: uglcw.util.template($('#isXxzf').html())">线下支付</div>
                        <c:if test="${source=='3'}">
                            <div data-field="khClose" uglcw-options="width:100,template: uglcw.util.template($('#khClose').html())">关闭进销存客户</div>
                        </c:if>
                        <div data-field="pic" uglcw-options="width:100,template: uglcw.util.template($('#pic').html())">微信头像</div>
                        <div data-field="nickname" uglcw-options="width:100">微信昵称</div>
                        <div data-field="remark" uglcw-options="width:100">备注</div>
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
<c:if test="${source=='1'}">
    <a role="button" href="javascript:del();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>删除
    </a>
</c:if>
<c:if test="${source=='1' || source=='4'}">
    <a role="button" href="javascript:openDialogXxzf();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>批量设置线下支付
    </a>
</c:if>
    <a role="button" href="javascript:openDialogShopMemberGrade();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>批量设置会员等级
    </a>
<c:if test="${source=='3'}">
    <a role="button" href="javascript:openDialogKhClose();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>批量关闭进销存客户
    </a>
</c:if>
</script>
<%--启用状态--%>
<script id="status" type="text/x-uglcw-template">
    # if(data.status=='-2'){ #
    已取消关注
    # }else if(data.status=='-1'){ #
    <button onclick="javascript:updateStatus(#= data.id#,1);" class="k-button k-info">申请中</button>
    # }else if(data.status=='0'){ #
    <button onclick="javascript:updateStatus(#= data.id#,1);" class="k-button k-info">不启用</button>
    # }else if(data.status=='1'){ #
    <button onclick="javascript:updateStatus(#= data.id#,0);" class="k-button k-info">启用</button>
    # } #
</script>
<%--线下支付--%>
<script id="isXxzf" type="text/x-uglcw-template">
    # if(data.isXxzf === 0){ #
    不显示
    # }else if(1 === data.isXxzf){ #
    显示
    # } #
</script>
<%--关闭进销存客户--%>
<script id="khClose" type="text/x-uglcw-template">
    # if(1 === data.khClose){ #
    关闭
    # } #
</script>
<%--微信头像--%>
<script id="pic" type="text/x-uglcw-template">
    # if(data.pic != ''){ #
    <img src="#=data.pic#" style="width:25px;height: 25px;align:middle"/>
    # } #
</script>
<%--启用操作--%>
<script id="oper" type="text/x-uglcw-template">
    <%--<button onclick="javascript:showAddressList(#= data.id#,'#=data.name#');" class="k-button k-info">地址列表</button>--%>
    <a href="javascript:showAddressList(#= data.id#,'#=data.name#');" class="a">地址列表</a>
    #if(data.openId){#
    &nbsp;<button class="k-button k-success"  type='button' onclick='unbindWx(#= data.id#,this)'>解绑微信</button>
    #}#
</script>

<%--对话框：线下支付，会员等级；关闭进销存客户--%>
<script type="text/x-uglcw-template" id="form-xxzf">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6">线下支付</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="isXxzf" id="dialog-xxzf-isXxzf"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"无","value":""},{"text":"不显示","value":"0"},{"text":"显示","value":"1"}]'></ul>
                        <span class="xxzf-more">(备注:会员下单选择支付方式是否显示“线下支付”)</span>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="form-shopMemberGrade">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-8">会员等级</label>
                    <div class="col-xs-12">
                        <tag:select2 name="gradeId" id="dialog-shopMemberGrade-gradeId" tableName="shop_member_grade" whereBlock="status=1" headerKey="" headerValue="--会员等级--" displayKey="id" displayValue="grade_name"/>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="form-khClose">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6">关闭进销存客户</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="khClose" id="dialog-khClose-khClose"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"不关闭","value":"0"},{"text":"关闭","value":"1"}]'></ul>
                        <span class="xxzf-more">(说明:关闭之后只会享受'常规会员'的价格)</span>
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
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })


    //-------------------------------修改：删除：start---------------------------------------------
    //对话框：修改会员
    function update() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var id = selection[0].id;
            var name = selection[0].name;
            <%--top.layui.index.openTabsPage("${base}/manager/shopMember/edit?source=${source}&id="+id, "修改会员_"+name);--%>
            <%--window.location.href="${base}/manager/shopMember/edit?source=${source}&id="+id;--%>
            uglcw.ui.openTab("修改会员_"+name,"${base}/manager/shopMember/edit?source=${source}&id="+id);
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
                    url:"${base}manager/shopMember/delete",
                    data: {
                        id:selection[0].id,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if(response == "1"){
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
    //-------------------------------修改：删除：end---------------------------------------------

    //-------------------------------grid：start---------------------------------------------
    //修改启用状态
    function updateStatus(id,status){
        uglcw.ui.confirm("是否确定操作?", function () {
            $.ajax({
                url: '${base}manager/shopMember/updateStatus',
                data: {
                    id:id,
                    status:status
                },
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if(response == "1"){
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    }else{
                        uglcw.ui.error("操作失败");
                    }
                }
            })
        })
    }

    //地址列表
    function showAddressList(id,name){
        uglcw.ui.openTab(name+'_地址列表','manager/shopMemberAddress/toPage?hyId='+id)
    }
    //-------------------------------grid：end---------------------------------------------


    //-------------------------------对话框：start---------------------------------------------
    function getIds(){
        var ids = '';
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            for(var i=0;i<selection.length;i++){
                if(ids != ''){
                    ids = ids + ",";
                }
                ids += selection[i].id;
            }
        }
        return ids ;
    }

    //对话框：线下支付
    function openDialogXxzf() {
        var ids = getIds();
        if(ids == ''){
            uglcw.ui.toast("请勾选你要操作的行！")
            return;
        }

        uglcw.ui.Modal.open({
            content: $('#form-xxzf').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                // if (row) {
                //     uglcw.ui.bind($(container), row);
                // }
            },
            yes: function (container) {
                // var valid = uglcw.ui.get($(container).find('#form-xxzf')).validate();
                // if (!valid) {
                //     return false;
                // }
                var isXxzf = uglcw.ui.get("#dialog-xxzf-isXxzf").value();
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/shopMember/batchUpdateXxzf',
                    type: 'post',
                    data: { ids:ids,isXxzf:isXxzf},
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
                            uglcw.ui.success('操作成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        }else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })
    }

    //对话框：会员等级
    function openDialogShopMemberGrade() {
        var ids = getIds();
        if(ids == ''){
            uglcw.ui.toast("请勾选你要操作的行！")
            return;
        }

        uglcw.ui.Modal.open({
            content: $('#form-shopMemberGrade').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                // if (row) {
                //     uglcw.ui.bind($(container), row);
                // }
            },
            yes: function (container) {
                // var valid = uglcw.ui.get($(container).find('#form-xxzf')).validate();
                // if (!valid) {
                //     return false;
                // }
                var gradeId = uglcw.ui.get("#dialog-shopMemberGrade-gradeId").value();
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/shopMember/batchUpdateShopMemberGrade',
                    type: 'post',
                    data: { ids:ids,gradeId:gradeId},
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
                            uglcw.ui.success('操作成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        }else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })
    }

    //对话框：关闭进销存客户
    function openDialogKhClose() {
        var ids = getIds();
        if(ids == ''){
            uglcw.ui.toast("请勾选你要操作的行！")
            return;
        }

        uglcw.ui.Modal.open({
            content: $('#form-khClose').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var khClose = uglcw.ui.get("#dialog-khClose-khClose").value();
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/shopMember/batchKhClose',
                    type: 'post',
                    data: { ids:ids,khClose:khClose},
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
                            uglcw.ui.success('操作成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        }else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })
    }
    //-------------------------------对话框：end---------------------------------------------


    //-------------------------------订阅：start---------------------------------------------
    //订阅
    uglcw.io.on('refreshShopMember-${source}', function(data){
        uglcw.ui.get('#grid').reload();
    })
    //-------------------------------订阅：end---------------------------------------------

    //解绑微信
    function unbindWx(id,th) {
        uglcw.ui.confirm("是否解绑操作?", function () {
                $.ajax({
                    url:"manager/shopMember/unbindWx",
                    data:{"id":id,"name":name},
                    type:"post",
                    success:function(json){
                        if(json==1){
                            $(th).css('display',"none");
                        }else{
                            uglcw.ui.success('解绑失败');
                        }
                    }
                });
        });
    }
</script>
</body>
</html>
