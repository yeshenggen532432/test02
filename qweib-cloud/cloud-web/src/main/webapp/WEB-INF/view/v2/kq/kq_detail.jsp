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
        <div class="uglcw-layout-fixed" style="width:200px">
            <div class="layui-card">
                <div class="layui-card-header">
                    部门-员工
                </div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">
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
                    <ul class="uglcw-query query form-horizontal">
                        <li>
                            <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <input type="hidden" uglcw-model="branchId" id="branchId" uglcw-role="textbox" value="">
                            <input uglcw-role="textbox" uglcw-model="memberNm" placeholder="员工姓名">
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
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/kqrpt/queryKqDetailPage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    checkbox: true
                    ">
                        <div data-field="memberNm" uglcw-options="width:80">姓名</div>
                        <div data-field="bcName" uglcw-options="width:140">班次</div>
                        <div data-field="kqDate" uglcw-options="width:120">日期</div>
                        <div data-field="tfrom1" uglcw-options="width:120">开始时间</div>
                        <div data-field="dto1" uglcw-options="width:120">结束时间</div>
                        <div data-field="tfrom2" uglcw-options="width:120">开始时间</div>
                        <div data-field="dto2" uglcw-options="width:120">结束时间</div>
                        <div data-field="kqStatus" uglcw-options="width:120">考勤状态</div>
                        <div data-field="remarks1" uglcw-options="width:120">备注</div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript: toProcData();" class="k-button k-button-icontext">
        <span class="k-icon k-i-pencil"></span>计算处理
    </a>
    <a role="button" href="javascript: showRemarks();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加备注
    </a>
    <a role="button" href="javascript: deleteRemarks();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>删除备注
    </a>
</script>
<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="layui-card-body">
                <div class="form-horizontal" uglcw-role="validator" id="bind">
                    <div class="form-group">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="memberId" id="memberId">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="kqDate" id="kqDate">

                        <label class="control-label col-xs-8">常用</label>
                        <div class="col-xs-14">
                            <select uglcw-role="combobox" uglcw-model="mkType" onchange="mkTypeChange(this)">
                                <option value=""></option>
                                <option value="漏打卡">漏打卡</option>
                                <option value="外出办事">外出办事</option>
                                <option value="临时调休">临时调休</option>
                                <option value="临时事假">临时事假</option>
                                <option value="病假">病假</option>
                                <option value="其它情况">其它情况</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-8">备注</label>
                        <div class="col-xs-14">
                            <textarea uglcw-model="remarks" id="remarks1" uglcw-role="textbox"></textarea>
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

    function deleteRemarks() {//删除备注
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            $.ajax({
                url: '${base}/manager/kqrpt/deleteKqRemarks',
                data: {
                    memberId: selection[0].memberId,
                    kqDate: selection[0].kqDate
                },
                type: 'post',
                dataType: 'json',
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('保存成功');//错误提示
                        uglcw.ui.get('#grid').reload();//刷新页面
                    } else {
                        uglcw.ui.error('保存失败');
                    }
                }
            })
        } else {
            uglcw.ui.warning('请选择要备注的记录');
        }

    }

    function mkTypeChange(sel) {
        $("#remarks1").val(sel.value);

    }

    function showRemarks() {//添加备注
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#t').html(),
                success: function (container) {
                    uglcw.ui.init($(container));
                    uglcw.ui.bind($(container).find('#bind'), selection[0]);
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        var data = uglcw.ui.bind($("#bind"))
                        $.ajax({
                            url: '${base}/manager/kqrpt/addKqRemarks',
                            data: data,
                            type: 'post',
                            success: function (json) {
                                if (json.state) {
                                    uglcw.ui.success('保存成功');
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
            uglcw.ui.warning('请选择要备注的记录');
        }
    }

    function toProcData() {//计算处理
        var data = uglcw.ui.bind('.query');
        uglcw.ui.confirm('计算考勤数据可能需要花费较长时间,请耐心等待？', function () {
            $.ajax({
                url: "manager/kqrpt/SumKqDetail",
                type: "post",
                data: data,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('计算成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('计算失败');
                        return;
                    }
                }
            });
        });
    }


</script>
</body>
</html>
