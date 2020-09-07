<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>月结记录</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li style="text-align: right;width: 40px;"><label style="margin-top: 5px;">年份:</label></li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="year" id="year" uglcw-options="value: '${year}',
                             allowInput: false"
                            placeholder="年份">
                        <option value="2020">2020</option>
                        <option value="2021">2021</option>
                        <option value="2022">2022</option>
                        <option value="2023">2023</option>
                        <option value="2024">2024</option>
                        <option value="2025">2025</option>
                        <option value="2026">2026</option>
                        <option value="2027">2027</option>
                        <option value="2028">2028</option>
                        <option value="2029">2029</option>
                        <option value="2030">2030</option>
                        <option value="2031">2031</option>
                        <option value="2032">2032</option>
                        <option value="2033">2033</option>
                        <option value="2034">2034</option>
                        <option value="2035">2035</option>
                    </select>
                </li>
                <li style="text-align: right;width: 40px;"><label style="margin-top: 5px;">状态:</label></li>
                <li>
                    <select uglcw-model="status" id="status" uglcw-role="combobox"  uglcw-options="tooltip: '状态'" placeholder="状态">
                    <option value="1">正常</option>
                    <option value="-1">作废</option>
                    <option value="0">全部</option>
                </select>
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
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/stkmonth/queryMonthPage',
                    		criteria: '.query',
                    	">
                <div data-field="id" uglcw-options="width:100,hidden:true">id</div>
                <div data-field="yymm" uglcw-options="width:100">年月</div>
                <div data-field="procDateStr" uglcw-options="width:150,tooltip:true">月结时间</div>
                <div data-field="startDate" uglcw-options="width:100">开始日期</div>
                <div data-field="endDate" uglcw-options="width:150">结束日期</div>
                <div data-field="status" uglcw-options="width:100,template: uglcw.util.template($('#formatterSt3').html())">
                    状态
                </div>
                <div data-field="ope" uglcw-options="width:100,template: uglcw.util.template($('#formatterSt4').html())">
                    作废
                </div>
                <div data-field="ope" uglcw-options="width:100,template: uglcw.util.template($('#formatterSt5').html())">
                    查看明细
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">

</script>
<%--启用状态--%>
<script id="formatterSt3" type="text/x-uglcw-template">
    # if(data.status == '-1'){ #
    作废
    # }else{ #
    正常
    # } #
</script>
<script id="formatterSt4" type="text/x-uglcw-template">
    # if(data.status == '1'){ #
    <button onclick="javascript:cancelBill(#= data.id#,1);" class="k-button k-info">作废</button>
    # }else{ #

    # } #
</script>
<script id="formatterSt5" type="text/x-uglcw-template">

    <button onclick="javascript:todetail('#= data.id #','#= data.yymm #','#=data.startDate#','#=data.endDate#');" class="k-button k-info">查看明细</button>

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
                        <input style="width: 200px;" uglcw-model="shopNo" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">*店名</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="shopName" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">联系人</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="contact" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">联系电话</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="tel" uglcw-role="textbox" uglcw-validate="mobile">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">地址</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="address" uglcw-role="textbox">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">仓库</label>
                    <div class="col-xs-11">
                        <tag:storage-select base="${base}" id="stkId" name="stkName" status="1" showHead="true"></tag:storage-select>

                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6" for="canInput2">可充值否</label>
                    <div class="col-xs-16">
                        <input type="checkbox" id="canInput2" uglcw-model="canInput" uglcw-role="checkbox"
                               uglcw-options="type:'number'">
                        <label for="canInput2"></label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6" for="canCost2">可消费否</label>
                    <div class="col-xs-16">
                        <input type="checkbox" id="canCost2" uglcw-model="canCost" uglcw-role="checkbox"
                               uglcw-options="type:'number'">
                        <label for="canCost2"></label>
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

        uglcw.ui.get('#year').on('change',function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded();
    })


    //-----------------------------------------------------------------------------------------
    function cancelBill(id) {
        uglcw.ui.confirm("是否确定作废？", function () {
            var path = "manager/stkmonth/cancelMonthProc";
            $.ajax({
                url: path,
                type: "POST",
                data: {"id": id},
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.state) {
                        alert('作废成功');
                        uglcw.ui.get('#grid').reload();

                    } else {
                        alert(json.msg);

                    }
                }
            });
        })
    }

    //添加
    function add() {
        edit()
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

    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm("确定删除所选记录吗？", function () {
                $.ajax({
                    url: "${base}manager/pos/deletePosShopInfo",
                    data: {
                        id: selection[0].id,
                    },
                    type: 'post',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success("删除成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error("删除失败");
                        }
                    }
                });
            })
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
                    url: '${base}manager/pos/savePosShopInfo',
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

    <%--function todetail(yymm) {--%>
        <%--uglcw.ui.openTab('月结明细', '${base}manager/stkmonth/toMonthDetail?yymm=' + yymm);--%>
    <%--}--%>

    function todetail(mastId,yymm,sdate,edate) {
        uglcw.ui.openTab(yymm+'_月结明细', '${base}manager/stkMonthBlance/toPage?mastId='+mastId+'&yymm=' + yymm);
    }


</script>
</body>
</html>
