<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员提现</title>
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
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input uglcw-model="cashNo" uglcw-role="textbox" placeholder="订单号">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="auditStatus" placeholder="状态">
                        <option value="">全部</option>
                        <option value="0" selected>申请</option>
                        <option value="1">通过</option>
                        <option value="2">拒绝</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="createTimeStart" uglcw-role="datepicker" value="${createTimeStart}">
                </li>
                <li>
                    <input uglcw-model="createTimeEnd" uglcw-role="datepicker" value="${createTimeEnd}">
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
                    <%--toolbar: kendo.template($('#toolbar').html()),--%>
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/shopMemberCash/pageList',
                    criteria: '.form-horizontal',
                    pageable: true
                    ">
                <div data-field="cashNo" uglcw-options="width:150,align:'center'">订单号</div>
                <div data-field="memberName" uglcw-options="width:100,align:'center'">会员</div>
                <div data-field="type" uglcw-options="width:100,align:'center',template: uglcw.util.template($('#type_templ').html())">类型</div>
                <div data-field="accounts" uglcw-options="width:150,align:'center'">帐号</div>
                <div data-field="cashMoney" uglcw-options="width:150,align:'center'">提现金额</div>
                <div data-field="createTime" uglcw-options="width:150,align:'center'">申请时间</div>
                <div data-field="auditStatus" uglcw-options="width:100,align:'center',template: uglcw.util.template($('#auditStatus_templ').html())">
                    审核状态
                </div>
                <div data-field="auditTime" uglcw-options="width:150,align:'center'">审核时间</div>
                <div data-field="auditRemarks" uglcw-options="width:150,align:'center'">审核说明</div>
                <div data-field="opt"
                     uglcw-options="width:160,align:'center',template: uglcw.util.template($('#oper_template').html())">操作
                </div>
            </div>
        </div>
    </div>
</div>

<script id="type_templ" type="text/x-uglcw-template">
    #=(data.type==1)?'微信':((data.type==2)?'支付宝':'银行')#
</script>

<script id="auditStatus_templ" type="text/x-uglcw-template">
    #=(data.auditStatus==0)?'未审核':((data.auditStatus==1)?'通过':'拒绝')#
</script>

<script id="oper_template" type="text/x-uglcw-template">
    #if(data.auditStatus==0){#
    <button class="k-button k-info" onclick="toAudit(#=data.id#)">审核</button>
    #}#
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<%--设置商品库存修改--%>
<script type="text/x-uglcw-template" id="audit_form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-xs-5">库存开关</label>
                    <div class="col-xs-6">
                        <input uglcw-role="combobox" id="auditStatus"
                               uglcw-options="value:1,dataSource:[{ text: '通过', value: 1 },{ text: '拒绝', value: 2}]"/>
                    </div>

                </div>
                <div class="form-group">
                    <label class="control-label col-xs-5">转帐记录编号</label>
                    <div class="col-xs-6">
                        <input id="transferNo" rows="5" cols="50"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-5">审核说明</label>
                    <div class="col-xs-6">
                        <textarea id="auditRemarks" rows="5" cols="40" maxlength="255"></textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>

<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })

    function toAudit(id) {
        uglcw.ui.Modal.open({
            title:'审核提现',
            content: $('#audit_form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var auditStatus = $('#auditStatus').val();
                var transferNo = $('#transferNo').val();
                var auditRemarks = $('#auditRemarks').val();
                if (auditStatus == 1 && !transferNo) {
                    uglcw.ui.info('转帐记录编号不能为空！');
                    return false;
                }else  if (auditStatus == 2 && !auditRemarks) {
                    uglcw.ui.info('请输入拒绝原因！');
                    return false;
                }

                $.ajax({
                    url: "${base}/manager/shopMemberCash/toAudit",
                    data: {id: id, auditStatus: auditStatus, transferNo: transferNo, auditRemarks: auditRemarks},
                    type: 'post',
                    success: function (json) {
                        uglcw.ui.loaded();
                        if (json.state) {
                            uglcw.ui.success('操作成功！');
                            uglcw.ui.get('#grid').reload();
                        }else{
                            uglcw.ui.error(json.message)
                        }
                    },
                    error: function () {
                        uglcw.ui.info('操作错误！');
                    }
                })
                return true;
            }
        })
    }
</script>
</body>
</html>
