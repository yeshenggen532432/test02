<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>库存盘点</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .row-color-blue {
            color: blue !important;
            text-decoration: line-through;
            font-weight: bold;
        }

        .row-color-pink {
            color: #FF00FF !important;
            font-weight: bold;
        }

        .row-color-red {
            color: red !important;
            font-weight: bold;

        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid  page-list">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="单据号">
                    <input type="hidden"  uglcw-role="textbox" uglcw-model="type" value="${type}" >
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-model="status" uglcw-options="value: ''" placeholder="单据状态" uglcw-role="combobox"
                            id="status">
                        <option value="-2">暂存</option>
                        <option value="0">已审批</option>
                        <option value="2">已作废</option>
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                </li>
                <li>
                    <select uglcw-model="stkId" uglcw-role="combobox" placeholder="仓库名称" uglcw-options="dataBound:load,
                                    index:0,
									url: '${base}manager/queryBaseStorage',
									dataTextField:'stkName',
									dataValueField: 'id',
								"></select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li style="width: 250px !important; padding-top: 5px">
                    <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>
                    &nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>
                    &nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    autoBind: false,
                    responsive: ['.header', 40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    dblclick: function(row){
                        showDetail(row.id, row.billNo,row.type,row.isPc);
                    },
                    url: '${base}manager/stkCheckPage',
                    criteria: '.uglcw-query.form-horizontal.query',
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
                    }
                    ">

                <div data-field="_biztype"
                     uglcw-options="width:120, template: uglcw.util.template($('#type-template').html())">类型
                </div>
                <div data-field="billNo" uglcw-options="width:180">单据号</div>
                <div data-field="checkTimeStr" uglcw-options="width:160">
                <c:choose>
                    <c:when test="${type == 1}">
                    初始化
                    </c:when>
                    <c:when test="${type == 2}">
                       创建
                    </c:when>
                    <c:otherwise>
                    盘点
                    </c:otherwise>
                </c:choose>日期
                </div>
                <div data-field="submitTime" uglcw-options="
                            width:160,
                            template: function(dataItem){
                                return kendo.template($('#formateData-template').html())(dataItem);
                          }">
                    库存干预时间
                </div>
                <div data-field="stkName" uglcw-options="width:120">
                    <c:choose>
                    <c:when test="${type == 1}">
                        初始化
                    </c:when>
                    <c:when test="${type == 2}">
                        清盘
                    </c:when>
                    <c:otherwise>
                        盘点
                    </c:otherwise>
                    </c:choose>
                    仓库
                </div>
                <div data-field="staff" uglcw-options="width:120">
                <c:choose>
                    <c:when test="${type == 1}">
                        初始化
                    </c:when>
                    <c:when test="${type == 2}">
                        清盘
                    </c:when>
                    <c:otherwise>
                        盘点
                    </c:otherwise>
                </c:choose>
                    人员
                </div>
                <div data-field="status"
                     uglcw-options="width:120, template: uglcw.util.template($('#status-template').html())">单据状态
                </div>
                <div data-field="operation"
                     uglcw-options="width:220, template: uglcw.util.template($('#cancel-template').html())">操作
                </div>
            </div>
        </div>
    </div>
</div>
<script id="type-template" type="text/x-uglcw-template">
    #if(data.billNo.indexOf('CSHRK')!=-1){#
    初始化入库单
    #}else{#
        #if(data.type==2){#
        清算单
        #}else{#
        盘点单
        #}#
    #}#
</script>
<script id="status-template" type="text/x-uglcw-template">
    <span>
    # if(data.status == -2){ #
         暂存
    # } else if (data.status == 0) {#
        已审批
    # }else if(data.status == 2){ #
        已作废
      #}else if(data.status == 3){#
    被冲红单
    #}else if(data.status == 4){#
    冲红单
    #}#
    </span>
</script>

<script id="formateData-template" type="text/x-kendo-template">
    #if(data.submitTime){#
    #= uglcw.util.toString(new Date(data.submitTime + 'GMT+0800'), 'yyyy-MM-dd HH:mm:ss')#
    #}#
</script>

<script type="text/x-uglcw-template" id="toolbar">
    <div class="actionbar">
<c:choose>
    <c:when test="${type == 1}">
        <a role="button" class="k-button primary k-button-icontext" href="javascript:init();">
            <span class="k-icon k-i-gears"></span>初始化入库</a>
    </c:when>
    <c:when test="${type == 2}">
        <a role="button" href="javascript:addRevise();" class="k-button primary k-button-icontext">
            <span class="k-icon k-i-file-add"></span>库存清算
        </a>
    </c:when>
    <c:otherwise>
        <a role="button" href="javascript:add();" class="k-button k-button-icontext">
            <span class="k-icon k-i-file-add"></span>盘点开单
        </a>
    </c:otherwise>
</c:choose>
    </div>
</script>

<script type="text/x-uglcw-template" id="cancel-template">
    #if(data.status==-2 || data.status ==0){#
        #if(data.type==2||data.isPc==1){#
            #if(data.status==-2){#
            <button class="k-button k-error" onclick="cancel(#= data.id#, '#= data.billNo#')"><i class="k-icon k-i-cancel"></i>作废
            </button>
            #}#
        #} else{#
        <button class="k-button k-error" onclick="cancel(#= data.id#, '#= data.billNo#')"><i class="k-icon k-i-cancel"></i>作废
        </button>
         #}#
    #}#
    #if(data.status == -2){#
    <button class="k-button k-info" onclick="audit(#= data.id#, '#= data.billNo#', '#= data.type#')"><i class="k-icon k-i-check"></i>审批
    </button>
    #}#
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.io.on('onInventoryCheckSaved', function(){
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '$sdate', edate: '${edate}'});
        });
        uglcw.ui.loaded();
    })

    function load() {
        uglcw.ui.get('#grid').k().setOptions({autoBind: true})
    }

    function add() {
        uglcw.ui.openTab('库存盘点开单', '${base}manager/pcstkchecktype');
    }

    function init() {
        uglcw.ui.openTab('初始化入库', '${base}manager/pcstkcheckinittype');
    }

    function addRevise() {
        uglcw.ui.openTab('库存清算', '${base}manager/pcstkrevise');
    }

    function audit(id, no,type) {
        var msg = '确定审核' + no + '？';
        if(type==2){
            msg = msg+"清算表保存审批后，库存结存信息将以清算信息为准，并以清算数及金额成本为准参与后续库存运算!";
        }
        uglcw.ui.confirm(msg, function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/auditCheck',
                type: 'post',
                dataType: 'json',
                data: {billId: id},
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success(response.msg);
                        uglcw.ui.get("#grid").reload();
                    } else {
                        uglcw.ui.error(response.msg);
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function cancel(id, no) {
        uglcw.ui.confirm('是否确定作废' + no + '？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/cancelCheck',
                type: 'post',
                dataType: 'json',
                data: {billId: id},
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success(response.msg);
                        uglcw.ui.get("#grid").reload();
                    } else {
                        uglcw.ui.error(response.msg);
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function showDetail(id, no,type,isPc) {
        if (no.indexOf('CSHRK') !== -1) {
            uglcw.ui.openTab('初始化入库信息' + id, '${base}manager/showStkcheckInit?billId=' + id);
        } else {
            if(type==2){
                uglcw.ui.openTab('库存清算信息' + id, '${base}manager/showstkrevise?billId=' + id);
            }else{
                var title = "盘点开票信息";
                if(isPc==1){
                    title = "分批次盘点信息";
                }
            uglcw.ui.openTab(title + id, '${base}manager/showStkcheck?billId=' + id);
            }
        }
    }

    function fromatterDate(v){//单据日期
        if(v==undefined){
           return "";
        }
        v = v + "";
        var date = "";
        var month = new Array();
        console.log(v);
        month["Jan"] = 1; month["Feb"] = 2; month["Mar"] = 3; month["Apr"] = 4; month["May"] = 5; month["Jun"] = 6;
        month["Jul"] = 7; month["Aug"] = 8; month["Sep"] = 9; month["Oct"] = 10; month["Nov"] = 11; month["Dec"] = 12;
        var week = new Array();
        week["Mon"] = "一"; week["Tue"] = "二"; week["Wed"] = "三"; week["Thu"] = "四"; week["Fri"] = "五"; week["Sat"] = "六"; week["Sun"] = "日";
        str = v.split(" ");
        date = str[5] + "-";
        date = date + month[str[1]] + "-" + str[2]+" "+str[3];
        return date;
    }

</script>
</body>
</html>
