<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-header">
                    部门
                </div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:[75]">
                    <div id="tree" uglcw-role="tree"
                         uglcw-options="
                        url:'manager/departs?depart=${depart }&dataTp=1',
                        initLevel: 1,
                        select: function(e){
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#branchId').value(node.id);
                            uglcw.ui.get('#grid').reload();
                        }
                    "
                    >
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="branchId" id="branchId" uglcw-role="textbox"
                                   value="${branchId}">
                            <input type="hidden" uglcw-model="memberUse" id="memberUse" uglcw-role="textbox" value="1">
                            <input uglcw-role="textbox" uglcw-model="memberNm" placeholder="查询(姓名/手机号码)">
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="ruleName" placeholder="规则名称">
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
                          checkbox: true,
                         responsive:['.header',40],
                        toolbar: kendo.template($('#toolbar').html()),
                        id:'id',
                        url: '${base}manager/kqrule/queryKqEmpRulePage?memberUse=1',
                        criteria: '.form-horizontal',
                        pageable: true
                    ">
                        <div data-field="memberNm" uglcw-options="width:'auto'">姓名</div>
                        <div data-field="memberMobile" uglcw-options="width:'auto'">手机号码</div>
                        <div data-field="ruleName" uglcw-options="width:'auto'">考勤规则</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript: ruleclick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>分配规则
    </a>
</script>
<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="layui-card-body">
                <div class="form-horizontal" uglcw-role="validator" id="bind">
                    <div class="form-group">
                        <label class="control-label col-xs-8">考勤规则</label>
                        <div class="col-xs-14">
                            <select uglcw-role="combobox" uglcw-model="kqruleselect" id="kqruleselect"
                                    uglcw-options="
                                  url: '${base}manager/kqrule/queryKqRulePage',
                                  loadFilter:{
                                    data: function(response){return response.rows ||[];}
                                  },
                                  dataTextField: 'ruleName',
                                  dataValueField: 'id'
                                ">
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {
                sdate: '${sdate}', edate: '${edate}'
            });
        })
        uglcw.ui.loaded()
    })

    function ruleclick() {//分配规则
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#t').html(),
                success: function (container) {
                    uglcw.ui.init($(container));
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        var ruleId = uglcw.ui.get('#kqruleselect').value();
                        $.ajax({
                            url: '${base}/manager/kqrule/saveEmpKqRule',
                            data: {
                                ids: $.map(selection, function (row) {  //选中多行数据删除
                                    return row.memberId
                                }).join(','),
                                ruleId: ruleId
                            },
                            type: 'post',
                            success: function (json) {
                                if (json.state) {
                                    uglcw.ui.get('#grid').reload();//刷新页面
                                } else {
                                    uglcw.ui.error("保存失败");
                                }
                            }
                        })
                    } else {
                        uglcw.ui.error('失败');
                        return false;
                    }
                }
            });

        } else {
            uglcw.ui.warning('请选择要分配的员工');
        }
    }

</script>
</body>
</html>
