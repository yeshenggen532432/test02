<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>优惠券规则</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        #member-range-tabs .k-tabstrip-items {
            display: none;
        }

        .el-tag {
            margin-right: 3px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query query">
                <li>
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="请输入优惠券名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="优惠券状态" uglcw-options="value:'-5'">
                        <option value="">全部状态</option>
                        <option value="-5">有效优惠券</option>
                        <option value="-2">未启用</option>
                        <option value="0">未开始</option>
                        <option value="1">进行中</option>
                        <option value="2">已结束</option>
                        <option value="-1">已停用</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="type" placeholder="优惠券类型" uglcw-options="value:''">
                        <option value="">全部类型</option>
                        <option value="1">满减卷</option>
                        <option value="2">折扣券</option>
                    </select>
                </li>
                <li>
                    <button uglcw-role="button" class="k-info" id="btn-search">搜索</button>
                    <button uglcw-role="button" id="btn-reset">重置</button>
                </li>
                <li><button uglcw-role="button" class="k-info" onclick="add()">添加优惠券</button></li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
						    responsive:['.header',40],
							id:'id',
							rowNumber: true,
							checkbox: false,
							pageable: true,
							dblclick: function(row){
							    uglcw.ui.openTab(row.name, '${base}manager/mall/coupon/item/index?_sticky=v2&id='+row.id+'&couponName='+row.name);
							},
                    		url: '${base}manager/mall/coupon',
                    		loadFilter: {
                    		    data: function(response){
                    		        return response.success ? (response.data.data || []) : [];
                    		    },
                    		    total: function(response){
                    		        return response.success ? response.data.totalCount : 0;
                    		    }
                    		},
                    		data: function(param){
                    		    param.page = param.page - 1;
                    		    param.size = param.pageSize;
                    		    uglcw.extend(param, uglcw.ui.bind('.query'))
                    		    if(param.status == -5) {
                    		        param.status = null;
                    		        param.validStatus = true;
                    		    }
                    		    return param;
                    		},
                    		dataBound: function(){
                    		    uglcw.ui.init('#grid')
                    		}
                    	">
                <div data-field="name" uglcw-options="width:220, template: uglcw.util.template($('#name-tpl').html())">
                    优惠券名称
                </div>
                <div data-field="nameRemark" uglcw-options="width:130">
                    名称备注
                </div>
                <div data-field="type"
                     uglcw-options="width:100, align: 'center', tooltip: true, template: uglcw.util.template($('#type-tpl').html())">
                    类型
                </div>
                <div data-field="couponText"
                     uglcw-options="width:220, align: 'left', tooltip: true, template: uglcw.util.template($('#coupon-text-tpl').html())">
                    优惠内容
                </div>
                <div data-field="oper"
                     uglcw-options="width:150, template: uglcw.util.template($('#status-tpl').html())">状态
                </div>
                <div data-field="receivedNum"
                     uglcw-options="width:100, template: uglcw.util.template($('#received-num-tpl').html())">已领取/剩余
                </div>
                <div data-field="usedNum"
                     uglcw-options="width:100">已使用
                </div>
                <div data-field="createTime"
                     uglcw-options="width:150, template: '#= uglcw.util.toString(new Date(data.createdTime), \'yyyy-MM-dd HH:mm\')#'">
                    创建时间
                </div>
                <div data-field="member-setting"
                     uglcw-options="width:240, template: uglcw.util.template($('#oper-tpl').html())">操作
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="name-tpl">
    <%--<button class="k-button" onclick="show('#= data.id#','#= data.name#');">#= data.name#</button>--%>
    #= data.name#
</script>
<script type="text/x-uglcw-template" id="type-tpl">
    #if(data.type === 1){#
    <span uglcw-role="tag" uglcw-options="type:'success'">满减券</span>
    #}#
    #if(data.type === 2){#
    <span uglcw-role="tag" uglcw-options="type:'warning'">折扣券</span>
    #}#
</script>
<script type="text/x-uglcw-template" id="status-tpl">
    #var now = new Date().getTime()#
    #if(data.status == -2){#
        未启用
    #}else if(data.status == -1){#
        已停用
    #}else if(data.timeType == 1){#
        #if(data.timeRangeBegin > now){#
            未开始
        #}else if(data.timeRangeBegin < now && data.timeRangeEnd > now){#
            进行中
        #}else{#
            已结束
        #}#
    #}else{#
        #if(data.status == 0){#
            未开始
        #}else if(data.status == 1){#
            进行中
        #}else if(data.status == 2){#
            已结束
        #}#
    #}#
</script>
<script type="text/x-uglcw-template" id="coupon-text-tpl">
    #if(data.thresholdType == 1){#
        无门槛,
    #}else{#
        满#=data.moreThanAmount#元,
    #}#
    #if(data.type == 1){#
    减#=data.couponAmount#元
    #}else{#
    打#=data.couponAmount#折,
    #if(data.mostCouponAmountStatus){#
    最多减#=data.mostCouponAmount#元
    #}}#
</script>
<script type="text/x-uglcw-template" id="received-num-tpl">
    #=data.receivedNum# / #=data.quantity - data.receivedNum#
</script>
<script type="text/x-uglcw-template" id="oper-tpl">
    #var now = new Date().getTime()#
    #if(data.status == -2){#
    <button class="k-button" onclick="edit('#= data.id#', '#= data.name#')">编辑</button>
    <button class="k-button" onclick="enable('#= data.id#')">启用</button>
    #} else if(data.status == -1 || data.status == 2){#
    <button class="k-button" onclick="show('#= data.id#', '#= data.name#')">查看</button>
    <button class="k-button" onclick="del('#= data.id#', #=data.status#)">删除</button>
    #} else {#
        #if(data.timeType == 1 && data.timeRangeEnd < now) {#
    <button class="k-button" onclick="show('#= data.id#', '#= data.name#')">查看</button>
    <button class="k-button" onclick="del('#= data.id#', #=data.status#)">删除</button>
        #} else {#
    <button class="k-button" onclick="edit('#= data.id#', '#= data.name#')">编辑</button>
    <button class="k-button">推广</button>
    <button class="k-button" onclick="invalid('#= data.id#')">停用</button>
        #}#
    #}#
    <button class="k-button" onclick="copyData('#= data.id#')">复制</button>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        $('#btn-search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });
        $('#btn-reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        });
        uglcw.ui.loaded();
    })

    //添加
    function add() {
        uglcw.ui.openTab('添加优惠券', '${base}manager/mall/coupon/detail?_sticky=v2');
    }

    //修改
    function show(id, title) {
        if (!id) {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (!selection || selection.length < 1) {
                return uglcw.ui.toast("请勾选你要操作的行！");
            }
            id = selection[0].id;
            title = selection[0].title;
        }
        uglcw.ui.openTab(title + '查看', '${base}manager/mall/coupon/detail?_sticky=v2&id=' + id + '&oper=show');
    }

    //修改
    function edit(id, title) {
        if (!id) {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (!selection || selection.length < 1) {
                return uglcw.ui.toast("请勾选你要操作的行！");
            }
            id = selection[0].id;
            title = selection[0].title;
        }
        uglcw.ui.openTab(title, '${base}manager/mall/coupon/detail?_sticky=v2&id=' + id);
    }

    function copyData(id) {
        uglcw.ui.openTab('添加优惠券', '${base}manager/mall/coupon/detail?_sticky=v2&id=' + id + '&oper=copy');
    }

    //删除(单个)
    function del(id, status) {
        if (status !== 2 && status !== -1) {
            return uglcw.ui.error('请先失效优惠券');
        }
        uglcw.ui.confirm("确定删除所选优惠券吗？此操作会导致已领优惠券的客户无法使用该优惠券。", function () {
            $.ajax({
                url: "${base}manager/mall/coupon/" + id,
                type: 'delete',
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message || "操作失败");
                    }
                }
            });
        })
    }

    function enable(id) {
        uglcw.ui.confirm("确定启用该优惠券吗？", function () {
            $.ajax({
                url: "${base}manager/mall/coupon/enable/" + id,
                type: 'put',
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        uglcw.ui.success(response.message);
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message || "操作失败");
                    }
                }
            });
        });
    }

    function invalid(id) {
        uglcw.ui.confirm("停用后，买家之前领取的优惠券，也无法再继续使用。确定停用吗？", function () {
            $.ajax({
                url: "${base}manager/mall/coupon/invalid/" + id,
                type: 'put',
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        uglcw.ui.success(response.message);
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message || "操作失败");
                    }
                }
            });
        });
    }


</script>
</body>
</html>
