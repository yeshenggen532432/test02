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

        .xxzf-more {
            font-size: 8px;
            color: red;
        }

        .a {
            font-size: 12px;
            color: rebeccapurple;
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
                    <ul class="uglcw-query form-horizontal query">
                        <li>
                            <input uglcw-model="name" uglcw-role="textbox" placeholder="会员名称">
                        </li>
                        <li>
                            <input uglcw-model="mobile" uglcw-role="textbox" placeholder="手机号">
                        </li>
                        <li>
                            <tag:select2 name="spMemGradeId" id="spMemGradeId" tableName="shop_member_grade"
                                         whereBlock="status=1 ${source==3?'and is_jxc=1':' and (is_jxc is null or is_jxc =0)'}"
                                         headerKey=""
                                         headerValue="--会员等级--" displayKey="id"
                                         displayValue="grade_name"/>
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="isDel" placeholder="状态"
                                    uglcw-options="value: '0'">
                                <option value="0">有效</option>
                                <option value="1">无效</option>
                            </select>
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                        <c:if test="${empty isDistributor}">
                            <li>
                                <!--<a href="javascript: uglcw.ui.openTab('余额提现申请', '${base}/manager/shopMemberCash/toPage');"><label
                                        style="margin-top: 10px;color: blue">余额提现申请</label></a>-->
                            </li>
                        </c:if>
                        <c:if test="${isDistributor !=null}">
                            <li>
                                <a href="javascript:unDistributor();"><label style="margin-top: 10px;color: blue">取消分销</label></a>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>
            <%--表格：头部end--%>

            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                            responsive:['.header',40],
                            <%--进销存会员不可修改--%>
                            <c:if test="${source!=null && source !=4}">
						        toolbar: kendo.template($('#toolbar').html()),
                            </c:if>
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/shopMember/shopMemberPage?source=${source}&isDistributor=${isDistributor}&memberType=${memberType}',
                    		criteria: '.query',
                    		pageSize: 20,
                    	">
                        <div data-field="name" uglcw-options="width:100">会员名称</div>
                        <div data-field="mobile" uglcw-options="width:110">电话</div>
                        <div data-field="gradeName" uglcw-options="width:100">会员等级</div>
                        <div data-field="attestationTempl"
                             uglcw-options="width:100,template: uglcw.util.template($('#attestationTempl').html())">平台认证
                        </div>
                        <c:if test="${source=='3'}">
                            <div data-field="customerName" uglcw-options="width:100">关联客户</div>
                            <div data-field="khClose"
                                 uglcw-options="width:100,template: uglcw.util.template($('#khClose').html())">进销存价格关联
                            </div>
                        </c:if>
                        <c:if test="${source=='1'}">
                            <div data-field="customerName"
                                 uglcw-options="width:100,template: uglcw.util.template($('#customerNameTempl').html())">匹配进销存
                            </div>
                        </c:if>
                        <%-- <div data-field="status"
                              uglcw-options="width:100,template: uglcw.util.template($('#status').html())">状态
                         </div>--%>
                        <c:if test="${source=='1'}">
                            <div data-field="hySource" uglcw-options="width:100">会员来源</div>
                        </c:if>
                        <div data-field="isXxzf"
                             uglcw-options="width:100,template: uglcw.util.template($('#isXxzf').html())">线下支付
                        </div>

                        <div data-field="pic" uglcw-options="width:100,template: uglcw.util.template($('#pic').html())">
                            微信头像
                        </div>
                        <div data-field="nickname" uglcw-options="width:100">微信昵称</div>
                        <div data-field="remark" uglcw-options="width:100">备注</div>
                        <div data-field="regDate" uglcw-options="width:150">注册时间</div>
                        <div data-field="recommenderMemberName" uglcw-options="width:150">推广人</div>
                        <c:if test="${isDistributor !=null}">
                            <div data-field="recommenderMemberCount"
                                 uglcw-options="width:100,template: uglcw.util.template($('#recommenderMemberCount_oper').html())">
                                发展会员数
                            </div>
                        </c:if>
                        <div data-field="defaultAddress" uglcw-options="width:150,tooltop:true">地址</div>
                        <div data-field="inputCash" uglcw-options="width:100">剩余余额</div>
                        <div data-field="freeCost" uglcw-options="width:100">剩余赠送</div>
                        <div data-field="oper" uglcw-options="width:250,template: uglcw.util.template($('#oper').html())">
                            操作
                        </div>
                    </div>
                </div>
            </div>
            <%--表格：end--%>
        </div>
        <%--2右边：表格end--%>
    </div>
</div>

<%--启用操作--%>
<script id="recommenderMemberCount_oper" type="text/x-uglcw-template">
    #if(data.recommenderMemberCount){ #
    <button class="k-button k-success" type='button' onclick='shopRecommenderMemberForm(#= data.id#,"#=data.name#")'>
        #=data.recommenderMemberCount#
    </button>
    #}#
</script>

<script type="text/x-kendo-template" id="toolbar">
    <c:if test="${source==1}">
        <a role="button"
           href="javascript: uglcw.ui.openTab('新增会员', '${base}/manager/shopMember/edit?_sticky=v2&source=${source}');"
           class="k-button k-button-icontext">
            <span class="k-icon k-i-plus-outline"></span>新增
        </a>
    </c:if>
    <a role="button" href="javascript:update();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>修改
    </a>
    <%-- <c:if test="${source=='1'}">
         <a role="button" href="javascript:del();" class="k-button k-button-icontext">
             <span class="k-icon k-i-delete"></span>删除
         </a>
     </c:if>--%>
    <c:if test="${source=='3'}">
        <a role="button" href="javascript:openDialogXxzf();" class="k-button k-button-icontext">
            <span class="k-icon k-i-gear"></span>批量设置线下支付
        </a>
    </c:if>
    <a role="button" href="javascript:openDialogShopMemberGrade();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>批量设置会员等级
    </a>
    <c:if test="${source=='3'}">
        <%-- <a role="button" href="javascript:openDialogKhClose();" class="k-button k-button-icontext">
             <span class="k-icon k-i-gear"></span>批量关闭进销存客户
         </a>--%>
        <a role="button" href="javascript:changeKhClose(0);" class="k-button k-button-icontext">
            <span class="k-icon k-i-gear"></span>开启进销存价格关联
        </a>
        <a role="button" href="javascript:changeKhClose(1);" class="k-button k-button-icontext">
            <span class="k-icon k-i-gear"></span>关闭进销存价格关联
        </a>
    </c:if>
</script>
<%--启用状态--%>
<script id="status" type="text/x-uglcw-template">
    <c:choose>
        <c:when test="${source==4}">
            # if(data.status=='-2'){ #
            已取消关注
            # }else if(data.status=='-1'){ #
            退卡
            # }else if(data.status=='0'){ #
            不启用
            # }else if(data.status=='1'){ #
            启用
            # } #
        </c:when>
        <c:otherwise>
            # if(data.status=='-2'){ #
            已取消关注
            # }else if(data.status=='-1'){ #
            <button onclick="javascript:updateStatus(#= data.id#,1);" class="k-button k-info">退卡</button>
            # }else if(data.status=='0'){ #
            <button onclick="javascript:updateStatus(#= data.id#,1);" class="k-button k-info">不启用</button>
            # }else if(data.status=='1'){ #
            <button onclick="javascript:updateStatus(#= data.id#,0);" class="k-button k-info">启用</button>
            # } #
        </c:otherwise>
    </c:choose>
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
    # if(0 === data.khClose){ #
    开启
    # } else { #
    关闭
    # }#
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
    #if(!data.memId && !data.openId && !data.unionId){ #
    <button style="color: red" class="k-button k-success" type='button' onclick='del(#= data.id#,this)'>删除</button>
    #}else{#
    <a href="javascript:showAddressList(#= data.id#,'#=data.name#');" class="a">地址列表</a>
    #if(data.openId || data.unionId){#
    <button class="k-button k-success" type='button' onclick='unbindWx(#= data.id#,#= data.memId#,this)'>解绑微信</button>
    #}#
    #}#
    <button class="k-button k-success" type='button' onclick="showFavoriteList(#= data.id#,'#=data.name#');">会员收藏
    </button>
</script>
<%--是否认证--%>
<script id="attestationTempl" type="text/x-uglcw-template">
    #if(!data.memId){ #
    <span style="color: red">未认证</span>
    #}#
</script>
<script id="customerNameTempl" type="text/x-uglcw-template">
    #if(data.customerName){ #
        <span style="color: blue" onclick="searchCustomer('#=data.id#','#=data.customerName#')">#=data.customerName#</span>
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
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"不显示","value":"0"},{"text":"显示","value":"1"}]'></ul>
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
                        <tag:select2 name="gradeId" id="dialog-shopMemberGrade-gradeId" tableName="shop_member_grade"
                                     whereBlock="status=1 ${source==3?'and is_jxc=1':' and (is_jxc is null or is_jxc =0)'}"
                                     headerKey=""
                                     headerValue="--会员等级--" displayKey="id"
                                     displayValue="grade_name"/>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<%--<script type="text/x-uglcw-template" id="form-khClose">
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
</script>--%>

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
            uglcw.ui.openTab("修改会员_" + name, "${base}/manager/shopMember/edit?_sticky=v2&source=${source}&id=" + id);
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //删除
    function del(id) {
        uglcw.ui.confirm("确定删除会员吗？", function () {
            $.ajax({
                url: "${base}manager/shopMember/delete",
                data: {id: id},
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.success(response.msg);
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.msg);
                    }
                }
            });
        })
    }

    //-------------------------------修改：删除：end---------------------------------------------

    //-------------------------------grid：start---------------------------------------------
    //修改启用状态
    function updateStatus(id, status) {
        uglcw.ui.confirm("是否确定操作?", function () {
            $.ajax({
                url: '${base}manager/shopMember/updateStatus',
                data: {
                    id: id,
                    status: status
                },
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response == "1") {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error("操作失败");
                    }
                }
            })
        })
    }

    //地址列表
    function showAddressList(id, name) {
        uglcw.ui.openTab(name + '_地址列表', 'manager/shopMemberAddress/toPage?type=1&_sticky=v2&hyId=' + id)
    }

    function showFavoriteList(id, name) {
        uglcw.ui.openTab(name + '_收藏列表', 'manager/shopWareFavorite/toPage?_sticky=v2&shopMemberId=' + id)
    }

    //-------------------------------grid：end---------------------------------------------


    //-------------------------------对话框：start---------------------------------------------
    function getIds() {
        var ids = '';
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            for (var i = 0; i < selection.length; i++) {
                if (ids != '') {
                    ids = ids + ",";
                }
                ids += selection[i].id;
            }
        }
        return ids;
    }

    //对话框：线下支付
    function openDialogXxzf() {
        var ids = getIds();
        if (ids == '') {
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
                    data: {ids: ids, isXxzf: isXxzf},
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
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

    //对话框：会员等级
    function openDialogShopMemberGrade() {
        var ids = getIds();
        if (ids == '') {
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
                    data: {ids: ids, gradeId: gradeId},
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
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

    //对话框：关闭进销存客户
    /*    function openDialogKhClose() {
            var ids = getIds();
            if (ids == '') {
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
                    data: {ids: ids, khClose: khClose},
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
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
    }*/

    function changeKhClose(khClose) {
        var ids = getIds();
        if (ids == '') {
            uglcw.ui.toast("请勾选你要操作的行！")
            return;
        }
        uglcw.ui.confirm("是否确定操作?", function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/shopMember/batchKhClose',
                type: 'post',
                data: {ids: ids, khClose: khClose},
                async: false,
                success: function (resp) {
                    uglcw.ui.loaded();
                    if (resp === '1') {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                        uglcw.ui.Modal.close();
                    } else {
                        uglcw.ui.error('操作失败');
                    }
                }
            })
        });
    }

    //-------------------------------对话框：end---------------------------------------------


    //-------------------------------订阅：start---------------------------------------------
    //订阅
    uglcw.io.on('refreshShopMember-${source}', function (data) {
        uglcw.ui.get('#grid').reload();
    })
    //-------------------------------订阅：end---------------------------------------------

    //解绑微信
    function unbindWx(id, memId, th) {
        debugger
        var text = "你将解绑公众号和小程序绑定,用户订单将丢失,<br/>用户进入公众号或小程序时将重新创建新帐号?<br/>小程序或公众号帐号统一问题：如以公众号帐号为主时,后台解绑小程序后在通知用户进入公众号反之";
        if (!memId) text = "帐号未认证,解绑后帐号将无法登陆,所以系统自动删除此帐号";
        uglcw.ui.confirm("是否解绑操作?", function () {
            uglcw.ui.confirm(text, function () {
                $.ajax({
                    url: "manager/shopMember/unbindWx",
                    data: {"id": id, "name": name},
                    type: "post",
                    success: function (json) {
                        if (json == 1) {
                            //$(th).css('display', "none");
                            uglcw.ui.success("解绑成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error('解绑失败');
                        }
                    }
                });
            });

        });
    }

    //关联选择客户
    function searchCustomer(id,customerName) {
        if(customerName)customerName=customerName.split('，')[0];
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/customerPage?khTp=2&isDb=2',
            // query: function (params) {
            //     params.extra = new Date().getTime();
            // },
            closable:true,
            btns:[],
            checkbox: false,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入客户名称" uglcw-role="textbox" uglcw-model="khNm" value="'+customerName+'">',
            columns: [
                {field: 'id', title: '客户id', width: 50, hidden: true},
                {field: 'khCode', title: '编码', width: 160},
                {field: 'khNm', title: '客户名称', width: 160},
                {field: 'linkman', title: '联系人', width: 160, tooltip: true},
            ],
            success:function(c){
                $('<span style="color:red;">（双击选择）</span>').appendTo($(c).find('.criteria'))
            },
            yes: function (data) {
                // 一行的数据
                if (data) {
                    var khNm;
                    var cid;
                    $(data).each(function (i, row) {
                        khNm = row.khNm;
                        cid = row.id;
                    })
                    if(cid && khNm){
                        $.ajax({
                            url: "manager/shopMember/updateCustomer",
                            data: {id:id,customerId:cid,customerName:khNm},
                            type: "post",
                            success: function (data) {
                                if (data.state) {
                                    uglcw.ui.success("操作成功");
                                    setTimeout(function () {
                                        uglcw.ui.get('#grid').reload();
                                    },1000);
                                } else {
                                    uglcw.ui.error(data.message());
                                }
                            }
                        });
                    }
                    return true;
                }
            }
        })
    }
</script>

<script>
    function shopRecommenderMemberForm(id, name) {
        var win = uglcw.ui.Modal.open({
            title: name + ' 推广会员',
            btns: [],
            maxmin: false,
            area: ['700px', '600px'],
            content: uglcw.util.template($('#editForm_tpl').html())({recommenderMemberId: id}),
            success: function (container) {
                uglcw.ui.init($(container));
            }
        })
    }

    //取消分销
    function unDistributor(id, memId, th) {
        var rows = uglcw.ui.get('#grid').selectedRow();
        if (!rows || rows.length == 0) {
            uglcw.ui.error('请选择');
            return false;
        }
        var ids = [];
        $.map(rows, function (row) {
            ids.push(row.id);
        })

        uglcw.ui.confirm("是否确定取消分销资格?", function () {
            $.ajax({
                url: "manager/shopMember/unDistributor",
                data: {ids:ids.join(',')},
                type: "post",
                success: function (json) {
                    if (json >0) {
                        uglcw.ui.success("解绑成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('解绑失败');
                    }
                }
            });
        });
    }
</script>

<%--添加或修改--%>
<script type="text/x-uglcw-template" id="editForm_tpl">
    <%--表格：start--%>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                            responsive:['.header',40],
							id:'id',
							checkbox:false,
							pageable: true,
                    		url: '${base}manager/shopMember/shopMemberPage?recommenderMemberId=#=data.recommenderMemberId#',
                    		pageSize: 20,
                    	">
                <div data-field="name" uglcw-options="width:100">会员名称</div>
                <div data-field="mobile" uglcw-options="width:110">电话</div>
                <div data-field="gradeName" uglcw-options="width:100">会员等级</div>
                <div data-field="attestationTempl"
                     uglcw-options="width:100,template: uglcw.util.template($('\\#attestationTempl').html())">平台认证
                </div>
                <div data-field="pic" uglcw-options="width:100,template: uglcw.util.template($('\\#pic').html())">
                    微信头像
                </div>
                <div data-field="nickname" uglcw-options="width:100">微信昵称</div>
            </div>
        </div>
    </div>
    <%--表格：end--%>
</script>

</body>
</html>
