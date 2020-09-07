<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>桌号设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <%@include file="/WEB-INF/view/v2/include/edit-kendo.jsp" %>
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
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="名称关键字">
                    <input id="status" uglcw-model="status" uglcw-role="textbox" style="display:none;">
                </li>
                <%--<li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="状态" uglcw-options="value:''">
                        <option value="">全部</option>
                        <c:forEach items="${diningStatusMap}" var="item">
                            <option value="${item.key}">${item.value}</option>
                        </c:forEach>
                        <option value="-1">已删除</option>
                    </select>
                </li>--%>
                <li>
                    <button uglcw-role="button" class="k-info" id="btn-search">搜索</button>
                    <button uglcw-role="button" id="btn-reset">重置</button>
                </li>
               <%-- <li>
                    <input type="checkbox" uglcw-role="checkbox" uglcw-model="isDel"
                           uglcw-options="type:'number'"
                           uglcw-value="0"
                           class="k-checkbox" id="isDelId"/>
                    <label style="margin-bottom: 10px;" class="k-checkbox-label" for="isDelId">已删除</label>
                </li>--%>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
						    responsive:['.header',40],
                            toolbar: uglcw.util.template($('#toolbar').html()),
							pageable: false,
                    		url: '${base}manager/shopDiningTable/findList',
                    		loadFilter: {
                    		    data: function(response){
                    		        return response.state ? (response.obj || []) : [];
                    		    },
                    		    total: function(response){
                    		        return response.success ? response.data.totalElements : 0;
                    		    }
                    		},data: function(param){
                    		    uglcw.extend(param, uglcw.ui.bind('.query'))
                    		    return param;
                    		},
                    		dataBound: function(){
                    		    uglcw.ui.init('#grid')
                    		}
                    	">
                <div data-field="name" uglcw-options="
								width:100,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '名称',field:'name'}),
								template:function(row){
									return uglcw.util.template($('#data_edit_template').html())({value:row.name, id:row.id, field:'name',callback:'changeBean'})
								}
								">
                </div>
                <div data-field="no" uglcw-options="
								width:100,hidden:true,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '编号',field:'no'}),
								template:function(row){
									return uglcw.util.template($('#data_edit_template').html())({value:row.no, id:row.id, field:'no',callback:'changeBean'})
								}
								">
                </div>
                <div data-field="status"
                     uglcw-options="width:70,hidden:true, template: uglcw.util.template($('#status-tpl').html())">
                    当前状态
                </div>
                <div data-field="createTime"
                     uglcw-options="width:80">
                    创建时间
                </div>
                <div data-field="memo" uglcw-options="
								width:100,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '备注',field:'memo'}),
								template:function(row){
									return uglcw.util.template($('#data_edit_template').html())({value:row.memo, id:row.id, field:'memo',callback:'changeBean'})
								}
								">
                </div>
                <div data-field="qrCode"
                     uglcw-options="width:80,hidden:true,template: uglcw.util.template($('#qrCode-tpl').html())">
                    二维码
                </div>
                <div data-field="opt" uglcw-options="width:100,template: uglcw.util.template($('#opt-tpl').html())">操作</div>
            </div>
        </div>
    </div>
</div>
</div>
<script>
    var diningStatusMap = [];
    <c:forEach items="${diningStatusMap}" var="item">
    diningStatusMap.push({key:${item.key}, text: '${item.value}'});
    </c:forEach>

</script>
<script type="text/x-uglcw-template" id="status-tpl">
    #var statusText='',optionsType='';#
    #diningStatusMap.forEach(function(item){#
    #if(item.key==data.status){#
    #statusText=item.text;#
    #return;#
    #}});#
    #if (data.status==2){optionsType="uglcw-options=\"type:'success'\""}#
    #if (data.status==3){optionsType="uglcw-options=\"type:'danger'\""}#
    <span uglcw-role="tag" #=optionsType#>#=statusText #</span>

</script>


<script type="text/x-uglcw-template" id="opt-tpl">
    <span uglcw-role="tag" onclick="showQrCode(#=data.id#,'#=data.name#')">二维码</span>
    #if (data.isDel==1){#
    <span uglcw-role="tag" uglcw-options="type:'success'" onclick="del(#=data.id#,0)">恢复</span>
    #}#
    #if (data.isDel==0){#
    <span uglcw-role="tag" uglcw-options="type:'danger'" onclick="del(#=data.id#,1)">删除</span>
    #}#

</script>

<script type="text/x-uglcw-template" id="qrCode-tpl">
    <span uglcw-role="tag" onclick="showQrCode(#=data.id#,'#=data.name#')">生成</span>
</script>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>营业桌位
    </a>
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

        $('#tabs li').on('click', function (item) {
            var value = $(this).attr("value");
            uglcw.ui.get("#status").value(value);
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#isDelId').on('change', function () {
            uglcw.ui.get('#grid').reload();
        });
    })

    function del(id, va) {
        var text = va == 1 ? '删除' : '恢复';
        uglcw.ui.confirm("是否确定" + text, function () {
            var data = {};
            data.id = id;
            data.isDel = va;
            $.ajax({
                url: '${base}manager/shopDiningTable/isDel',
                data: data,
                type: 'post',
                async: false,
                success: function (resp) {
                    uglcw.ui.loaded();
                    if (resp.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败');
                    }
                }
            })
        })
    }

    function changeBean(value, field, id, fun) {
        var data = {};
        data.id = id;
        data.field = field;
        data.value = value;
        $.ajax({
            url: '${base}manager/shopDiningTable/update',
            data: data,
            type: 'post',
            async: false,
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp.state) {
                    uglcw.ui.success('操作成功');
                    //uglcw.ui.get('#grid').reload();
                    //uglcw.ui.Modal.close();
                    callSuccessFun(value, field, id);
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })
    }

    //添加
    function add() {
        uglcw.ui.Modal.open({
            content: $('#autoForm_tpl').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var autoNumber = uglcw.ui.get("#autoNumber").value();
                if (!autoNumber || isNaN(autoNumber)) {
                    uglcw.ui.error('请输入正确数字');
                    return false;
                }
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/shopDiningTable/autoCreate',
                    data: {number: autoNumber},
                    type: 'post',
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp.state) {
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


    //显示二维码
    function showQrCode(id, name) {
        $.ajax({
            url: '${base}manager/shopDiningTable/base64',
            data: {str: id},
            type: 'post',
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp.state) {
                    //二维码生成规则,分享后跳转页面
                    var url = "${doMain}/web/shopDispatcherWid/wxDiningIndex?diningid=" + resp.obj + "&wid=${companyId}";
                    uglcw.ui.Modal.open({
                        content: uglcw.util.template($('#qrCode_tpl').html())({name: name}),
                        title: '二维码',
                        area: '250px',
                        btns:[],
                        shadeClose: true,
                        success: function (container) {
                            uglcw.ui.init($(container));
                            var qrcode = new QRCode(document.getElementById("qrcode"), {
                                width: 200,
                                height: 200,
                                correctLevel: 3
                            });
                            qrcode.clear(); // 清除代码
                            qrcode.makeCode(url);
                        },
                        yes: function (container) {
                        }
                    })
                } else {
                    uglcw.ui.error('加密操作失败');
                }
            }
        })


    }

    function downloadImg(name) {
        var url = $("#qrcode").find("img").attr("src");                            // 获取图片地址
        var a = document.createElement('a');          // 创建一个a节点插入的document
        var event = new MouseEvent('click')           // 模拟鼠标click点击事件
        a.download = name + "二维码"                  // 设置a节点的download属性值
        a.href = url;                                 // 将图片的src赋值给a节点的href
        a.dispatchEvent(event)                        // 触发鼠标点击事件
    }
</script>

<script type="text/x-uglcw-template" id="autoForm_tpl">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-xs-6">添加桌数</label>
                    <div class="col-xs-16">
                        <input uglcw-role="numeric" name="autoNumber" id="autoNumber" data-bind="value:autoNumber">
                    </div>
                </div>

            </form>
        </div>
    </div>
</script>

<%--二维码--%>
<script type="text/x-uglcw-template" id="qrCode_tpl">
    <div class="layui-card">
        <div class="layui-card-body">
            <button class="downloadBtn" type="button" onclick="downloadImg('#=name#')">下载</button>
            <div id="qrcode"/>
        </div>
    </div>
    </div>
</script>
<%--二维码--%>
<script src="<%=basePath%>/resource/shop/mobile/js/qrcode.js" type="text/javascript"></script>
</body>
</html>
