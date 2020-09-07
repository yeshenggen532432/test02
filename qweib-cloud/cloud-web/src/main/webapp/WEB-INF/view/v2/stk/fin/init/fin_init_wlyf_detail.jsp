<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
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
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="bizType" uglcw-role="textbox" value="${bizType}">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单号">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" uglcw-options="value:uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm:ss')">
                </li>
                <li>
                    <select uglcw-role="combobox" placeholder="单据状态" uglcw-model="status" uglcw-options="value: ''">
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
                 uglcw-options="{
                    checkbox:'true',
                    responsive:['.header',40],
                    id:'id',
                     toolbar: kendo.template($('#toolbar').html()),
                    url: 'manager/finInitWlYwMain/page',
                    criteria: '.form-horizontal',
                    rowNumber: true,
                    query: function(params){
                        if(params.edate){
                            params.edate+=' 23:59:59';
                        }
                        return params;
                    },
                    pageable: true,
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


                    }">

                <div data-field="proName" uglcw-options="width:140">往来对象</div>
                <div data-field="billNo" uglcw-options="{width:170}">单号</div>
                <div data-field="billTime"
                     uglcw-options="width:160, template: uglcw.util.template($('#billTime').html())">单据日期
                </div>
                <div data-field="operator" uglcw-options="{width:100}">经办人</div>
                <div data-field="_operator"
                     uglcw-options="width:160, template: uglcw.util.template($('#formatterSt').html())">操作
                </div>
                <div data-field="amt" uglcw-options="{width:120}">初始化应付金额</div>
                <div data-field="payAmt" uglcw-options="{width:120}">已付金额</div>
                <div data-field="_unPayAmt"
                     uglcw-options="width:120,  template: '#= data.amt-data.payAmt-data.freeAmt #'">未付金额
                </div>
                <div data-field="status"
                     uglcw-options="width:120, template: uglcw.util.template($('#formatterStatus').html())">状态
                </div>
                <div data-field="_skStatus"
                     uglcw-options="width:120,template: uglcw.util.template($('#formatterSkStatus').html())">收款状态
                </div>
                <div data-field="remark" uglcw-options="width:160,tooltip: true">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:battchAudit();" class="k-button k-button-icontext">
        <span class="k-icon k-i-settings"></span>批量审批
    </a>
    <a role="button" href="javascript:toCustomerModel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-download"></span>下载模版
    </a>
    <a role="button" href="javascript:toUpCustomer();" class="k-button k-button-icontext">
        <span class="k-icon k-i-upload"></span>上传数据
    </a>
    <a role="button" href="javascript:toAdd();" class="k-button k-button-icontext">
        <span class="k-icon k-i-add"></span>添加
    </a>
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

<script type="text/x-kendo-template" id="formatterSkStatus">
    #if((data.payAmt+data.freeAmt)>0&&(data.payAmt+data.freeAmt)
    <data.amt){#
    部分付款
    #}else if(data.amt==(data.payAmt+data.freeAmt)){#
    已付完
    #}else{#
    未付款
    #}#
</script>

<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status==-2){#
    暂存
    #} else if(data.status==1){#
    已审批
    #} else if(data.status==2){#
    已作废
    #}#
</script>
<script type="text/x-kendo-template" id="formatterSt">
    # if(data.status =='-2'){ #
    <button class="k-button k-success" onclick="auditBill(#= data.id#)"><i class="k-icon"></i>审核</button>
    # } #
    # if(data.status != 2){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#)"><i class="k-icon"></i>作废</button>
    # } #

</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })


    function cancelBill(id) {
        uglcw.ui.confirm('您确认要作废吗？', function () {
            $.ajax({
                url: "manager/finInitWlYwMain/cancelBill",
                type: "post",
                data: "billId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success("作废成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败' + json.msg);
                        return;
                    }
                }
            });
        });
    }

    function auditBill(id) {
        uglcw.ui.confirm('您确认要审核吗？', function () {
            $.ajax({
                url: "manager/finInitWlYwMain/auditBatch",
                type: "post",
                data: "billId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(json.msg);
                        return;
                    }
                }
            });
        });
    }

    function toUpCustomer() {//上传数据
        uglcw.ui.Modal.showUpload({
            url: '${base}manager/finInitWlYwMain/toUpProviderInitAmt?bizType=${bizType}',
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
                if (e.response != '1') {
                    uglcw.ui.error(e.response);
                } else {
                    uglcw.ui.success('导入成功');
                    uglcw.ui.get('#grid').reload();
                }
            }
        })
    }

    function toCustomerModel() {
        uglcw.ui.confirm('是否下载模版?', function () {
            window.location.href = "manager/finInitWlYwMain/toProviderInitAmtTemplate";
        })
    }

    function battchAudit() {//批量审批
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('您确认要批量审核吗?', function () {
                $.ajax({
                    url: '${base}/manager/finInitWlYwMain/auditBatch',
                    data: {
                        ids: $.map(selection, function (row) {  //选中多行数据删除
                            return row.id
                        }).join(',')
                    },
                    type: 'post',
                    success: function (json) {
                        if (json.state) {
                            uglcw.ui.success('操作成功！');//
                            uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                        } else {
                            uglcw.ui.error('操作失败！' + json.msg);//
                            return;
                        }

                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择单据！');

        }
    }

    //添加
    function toAdd() {
        var bizType = '${bizType}';
        var proType = 1;
        var title = '员工应付账初始化录入';
        if (bizType == 'CSHYF') {
            title = '供应商应付初始化录入';
            proType = 0;
        } else if (bizType == 'CSHKHYF') {
            title = '客户应付账初始化录入';
            proType = 2;
        } else {
            title = '员工应付账初始化录入';
            proType = 1;
        }
        uglcw.ui.openTab(title, '${base}manager/finInitWlYwMain/add?bizType=${bizType}&proType=' + proType + '&ioMark=-1');
    }
</script>
</body>
</html>
