<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>优惠券使用情况</title>
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
            优惠券名称：${param.couponName}
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
                    		url: '${base}manager/mall/coupon/item?couponId=${param.id}',
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
                    		    return param;
                    		},
                    		dataBound: function(){
                    		    uglcw.ui.init('#grid')
                    		}
                    	">
                <div data-field="memberName"
                     uglcw-options="width:100, align: 'center', tooltip: true">
                    会员名称
                </div>
                <div data-field="used"
                     uglcw-options="width:150, template: uglcw.util.template($('#status-tpl').html())">状态
                </div>
                <div data-field="createTime"
                     uglcw-options="width:150, template: '#= uglcw.util.toString(new Date(data.receivedTime), \'yyyy-MM-dd HH:mm\')#'">
                    领取时间
                </div>
                <div data-field="failureTime"
                     uglcw-options="width:150, template: '#= data.failureTime ? uglcw.util.toString(new Date(data.failureTime), \'yyyy-MM-dd HH:mm\') : \'\'#'">
                    失效时间
                </div>
                <div data-field="usedTime"
                     uglcw-options="width:150, template: '#= data.usedTime ? uglcw.util.toString(new Date(data.usedTime), \'yyyy-MM-dd HH:mm\') : \'\'#'">
                    使用时间
                </div>
                <div data-field="createTime"
                     uglcw-options="width:150, template: '#= uglcw.util.toString(new Date(data.createdTime), \'yyyy-MM-dd HH:mm\')#'">
                    创建时间
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="status-tpl">
    #if(data.used){#
        已使用
    #}else{#
        未使用
    #}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.ui.loaded();
    })

</script>
</body>
</html>
