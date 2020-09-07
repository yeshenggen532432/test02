<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>其他往来应付账初始化-tab</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .row-color-blue {
            color: blue;
            text-decoration: line-through;
            font-weight: bold;
        }

        .row-color-pink {
            color: #FF00FF;
            font-weight: bold;
        }

        .row-color-red {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>

                    <input type="hidden" uglcw-model="jz" uglcw-role="textbox" value="1">
                    <input type="hidden" uglcw-model="bizType" uglcw-role="textbox" value="${bizType}">

                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单号">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="单据状态" uglcw-options="value: ''">
                        <option value="1">已审核</option>
                        <option value="-2">暂存</option>
                        <option value="2">已作废</option>
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
                    		url: '${base}manager/finInitQtJrMain/page',
                    		criteria: '.query',
                    		dataBound: function(){
								var data = this.dataSource.view();
								$(data).each(function(idx, row){
									var clazz = ''
									if(row.status == 2){
										clazz = 'row-color-blue';
									}else if(row.status == 3){
										clazz = 'row-color-pink';
									}else if(row.status == 4){
										clazz = 'row-color-red';
									}
									$('#grid tr[data-uid='+row.uid+']').addClass(clazz);
								})
							},
                    	">
                <div data-field="proName" uglcw-options="width:160,tooltip:true">往来对象</div>
                <div data-field="billNo" uglcw-options="width:200">单号</div>
                <div data-field="billTime" uglcw-options="width:180,template: uglcw.util.template($('#billTime').html())">
                    单据日期
                </div>
                <div data-field="operator" uglcw-options="width:100">经办人</div>
                <div data-field="oper" uglcw-options="width:160,template: uglcw.util.template($('#oper').html())">操作</div>
                <div data-field="amt" uglcw-options="width:130">借入初始化金额</div>
                <div data-field="payAmt" uglcw-options="width:100">已还金额</div>
                <div data-field="_unPayAmt" uglcw-options="width:100,template: uglcw.util.template($('#_unPayAmt').html())">
                    未还金额
                </div>
                <div data-field="itemName" uglcw-options="width:130">
                    明细科目名称
                </div>
                <div data-field="status" uglcw-options="width:100,template: uglcw.util.template($('#status').html())">状态
                </div>
                <div data-field="_skStatus" uglcw-options="width:100,template: uglcw.util.template($('#_skStatus').html())">
                    还款状态
                </div>
                <div data-field="remark" uglcw-options="width:160,tooltip: true">备注</div>
            </div>
        </div>
    </div>
    <%--表格：end--%>
</div>
<%--2右边：表格end--%>
</div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:battchAudit();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit-tools"></span>批量审批
    </a>
    <a role="button" href="javascript:download();" class="k-button k-button-icontext">
        <span class="k-icon k-i-download"></span>下载模版
    </a>
    <a role="button" href="javascript:upload();" class="k-button k-button-icontext">
        <span class="k-icon k-i-upload"></span>上传数据
    </a>
    <a role="button" href="javascript:toAdd();" class="k-button k-button-icontext">
        <span class="k-icon k-i-add"></span>添加
    </a>
</script>
<%--状态--%>
<script id="status" type="text/x-uglcw-template">
    # if(data.status==-2){ #
    暂存
    # }else if(data.status==1){ #
    已审批
    # }else if(data.status==2){ #
    已作废
    # } #
</script>
<%--状态--%>
<script id="_skStatus" type="text/x-uglcw-template">
    # var totalAmt = data.amt; #
    # var payAmt = data.payAmt; #
    # var freeAmt = data.freeAmt; #
    # var skStatus = "未还款"; #
    # if((payAmt+freeAmt) > 0 && ((payAmt+freeAmt) < totalAmt)){ #
    # skStatus = "部分还款"; #
    # }else if(totalAmt==(payAmt+freeAmt)){ #
    # skStatus = "已还完"; #
    # } #
    <span>#= skStatus #</span>
</script>
<script id="_unPayAmt" type="text/x-uglcw-template">
    # var totalAmt = data.amt; #
    # var payAmt = data.payAmt; #
    # var freeAmt = data.freeAmt; #
    <span> #= totalAmt-payAmt-freeAmt # </span>
</script>
<%--时间--%>
<script id="billTime" type="text/x-uglcw-template">
    # v = data.billTime + ""; #
    # var date = ""; #
    # var month = new Array(); #
    # month["Jan"] = 1; month["Feb"] = 2; month["Mar"] = 3; month["Apr"] = 4; month["May"] = 5; month["Jun"] = 6; #
    # month["Jul"] = 7; month["Aug"] = 8; month["Sep"] = 9; month["Oct"] = 10; month["Nov"] = 11; month["Dec"] = 12; #
    # var week = new Array(); #
    # week["Mon"] = "一"; week["Tue"] = "二"; week["Wed"] = "三"; week["Thu"] = "四"; week["Fri"] = "五"; week["Sat"] = "六"; week["Sun"] = "日"; #
    # str = v.split(" "); #
    # date = str[5] + "-"; #
    # date = date + month[str[1]] + "-" + str[2]+" "+str[3]; #
    <span> #= date #</span>
</script>
<%--启用操作--%>
<script id="oper" type="text/x-uglcw-template">
    # if(data.status == -2){ #
    <button onclick="auditBill(#= data.id#,1);" class="k-button k-info">审核</button>
    <button onclick="edit(this,#= data.id#);" class="k-button k-info">修改</button>
    # } #
    # if(data.status != 2){ #
    <button onclick="auditBill(#= data.id#,2);" class="k-button k-info">作废</button>
    # } #
</script>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6"></label>
                    <div class="col-xs-16">
                        <input type="hidden" uglcw-model="id" uglcw-role="textbox" value="#=data.id#">
                        <select uglcw-role="combobox" uglcw-model="itemId"
                                uglcw-options="
                                url: '${base}manager/queryUseIoItemList?typeName=其它应付款',
                                loadFilter:{
                                    data: function(response){return response.rows ||[];}
                                },
                                value: '#=data.itemId#',
                                dataTextField: 'itemName',
                                dataValueField: 'id'
                                "
                        >
                        </select>
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

    //-----------------------------------------------------------------------------------------
    //审批和作废
    function auditBill(id, type) {
        var title = '';
        var url = '';
        var data = '';
        if (type == 1) {
            title = '您确认要审核吗?';
            url = '${base}manager/finInitQtJrMain/auditBatch';
            data = "billId=" + id;
        } else if (type == 2) {
            title = '您确认要作废吗?';
            url = '${base}manager/finInitQtJrMain/cancelBill';
            data = "billId=" + id;
        }
        uglcw.ui.confirm(title, function () {
            $.ajax({
                url: url,
                data: data,
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error("操作失败");
                    }
                }
            })
        })
    }
    //修改
    function edit(e) {
        var btn = e;
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr'));
        uglcw.ui.Modal.open({
            area: '500px',
            content: uglcw.util.template($('#form').html())({data: row}),//初始化之前把值渲染好绑定到弹框
            success: function (container) {
                uglcw.ui.init($(container));

            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (valid) {
                    var data = uglcw.ui.bind($("form"))
                    $.ajax({
                        url: '${base}/manager/finInitQtJrMain/item',
                        data: data,
                        type: 'post',
                        success: function (response) {
                            if (response.state) {
                                uglcw.ui.success('修改成功');
                                uglcw.ui.get('#grid').reload();//刷新页面
                            } else {
                                uglcw.ui.error("修改失败");
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });

    }
    //添加
    function toAdd() {
        var bizType = '${bizType}';
        var proType = 1;
        var title = '员工借入初始化录入';
        if (bizType == 'CSHGYSJR') {
            title = '供应商借入初始化录入';
            proType = 0;
        } else if (bizType == 'CSHKHJR') {
            title = '客户借入初始化录入';
            proType = 2;
        } else {
            title = '员工借入初始化录入';
            proType = 1;
        }
        // parent.parent.closeWin(title);
        uglcw.ui.openTab(title, '${base}manager/finInitQtJrMain/add?bizType=${bizType}&proType=' + proType);
    }

    //批量审批
    function battchAudit() {
        var rows = uglcw.ui.get('#grid').selectedRow();
        if (rows) {
            var ids = "";
            for (var i = 0; i < rows.length; i++) {
                if (ids != "") {
                    ids += ",";
                }
                ids += rows[i].id;
            }
            if (ids == "") {
                uglcw.ui.toast('消息', '请选择单据', 'info');
                return;
            }
            uglcw.ui.confirm("您确认要批量审核吗？", function () {
                $.ajax({
                    url: "${base}manager/finInitQtJrMain/auditBatch",
                    data: "billId=&ids=" + ids,
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success("批量审批成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error("批量审批失败");
                        }
                    }
                });
            })
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //下载
    function download() {
        uglcw.ui.confirm('是否下载模版？', function () {
            window.location.href = '${base}manager/finInitQtJrMain/toWlJrInitAmtTemplate?bizType=${bizType}'
        })
    }

    //上传
    function upload() {
        uglcw.ui.Modal.showUpload({
            url: '${base}manager/finInitQtJrMain/toUpWljrInitAmt?bizType=${bizType}',
            field: 'upFile',
            error: function (e) {
                uglcw.ui.notice({
                    type: 'error',
                    title: '上传失败',
                    desc: e.XMLHttpRequest.responseText
                });
                console.log('error------------', arguments)
            },
            complete: function () {
                console.log('complete', arguments);
            },
            success: function (e) {
                if (e.response == '1') {
                    uglcw.ui.success('导入成功');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error(e.response);
                }
            }
        })
    }


    //-------------------------------订阅：start---------------------------------------------
    //订阅
    uglcw.io.on('refreshInitQtjr-${bizType}', function (data) {
        uglcw.ui.get('#grid').reload();
    })
    //-------------------------------订阅：end---------------------------------------------


</script>
</body>
</html>
