<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .k-in {
            width: 100%;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card master">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <li onclick="add()" data-icon="add" class="k-info">新建</li>
                        <c:if test="${status eq 0}">
                            <li onclick="draftSave()" class="k-info" data-icon="save">暂存</li>
                            <c:if test="${billId ne 0}">
                                <li onclick="audit()" class="k-info" data-icon="track-changes-accept">审批</li>
                            </c:if>
                        </c:if>
                        <c:if test="${status eq 0 and billId eq 0}">
                            <li onclick="saveAudit()" class="k-info" data-icon="save">保存并审批</li>
                        </c:if>
                    </ul>
                    <div class="bill-info">
                        <span id="billStatus" class="status" style="color:red;">${billStatus}</span>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="proId" value="${proId}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="proType" value="${proType}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="accId" id="accId" value="${accId}"/>


                        <div class="form-group" style="margin-bottom: 0px;">
                            <label class="control-label col-xs-3">初始化时间</label>
                            <div class="col-xs-4">
                                <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                                       uglcw-model="inDate" value="${billTimeStr}">
                            </div>
                            <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${remarks}</textarea>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="layui-row layui-col-space15">
                <div class="layui-col-md7">
                    <div class="layui-card">
                        <div class="layui-card-body full">
                            <div id="grid" uglcw-role="grid"
                                 uglcw-options='
						  responsive:[".master",40],
						  autoSync: true,
                          memId: "memId",
                          editable: true,
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "inputCash", aggregate: "sum"},
                            {field: "freeCost", aggregate: "sum"}
                          ],
                          change: calTotalAmount,
                          dataSource:${fns:toJson(sublist)}
                        '
                            >
                                <div data-field="name"
                                     uglcw-options="width: 150, schema:{editable: false}, footerTemplate: '合计:'">会员姓名
                                </div>
                                <div data-field="mobile" uglcw-options="width: 150, schema:{editable: false}">
                                    电话
                                </div>
                                <div data-field="cardNo" uglcw-options="width: 150, schema:{editable: false}">
                                    卡号
                                </div>
                                <div data-field="inputCash"
                                     uglcw-options="width: 150, footerTemplate: '#= uglcw.util.toString(sum, \'n2\')#', format: '{0:n2}', schema:{type: 'number', validation:{min:0}}">
                                    充值金额
                                </div>
                                <div data-field="freeCost"
                                     uglcw-options="width: 150, footerTemplate: '#= uglcw.util.toString(sum, \'n2\')#', format: '{0:n2}', schema:{type: 'number', validation:{min:0}}">

                                    赠送金额
                                </div>
                                <div data-field="remarks" uglcw-options="width: 150,editable: true">备注</div>
                                <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md5">
                    <div class="layui-row layui-col-space5">
                        <div class="layui-col-md4">
                            <div class="layui-card">
                                <div class="layui-card-header">
                                    <span>会员等级</span>
                                </div>
                                <div class="layui-card-body full" uglcw-role="resizable" uglcw-options="responsive:['.master', 80]">
                                    <div id="tree" uglcw-role="tree" uglcw-options="
							url:'${base}manager/pos/queryMemberTypeList1',
							dataTextField:'typeName',
							dataValueField: 'id',
							loadFilter:function(response){
								return response.rows;
							},
							select: function(e){
							   var item = this.dataItem(e.node);
							   uglcw.ui.bind('.query',{cardType: item.id});
							   uglcw.ui.get('#grid2').k().setOptions({autoBind: true})
							},
							dataBound: function(){
                                this.select($('#tree .k-item:eq(0)'));
                                var data = this.dataSource.data().toJSON();
                                if(data&&data.length>0){
                                    uglcw.ui.bind('.query',{typeId: data[0].id});
                                    uglcw.ui.get('#grid2').k().setOptions({autoBind: true})
                                }
							}
					"></div>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md8">
                            <div class="layui-card">
                                <div class="layui-card-body full">
                                    <div class="query">
                                        <input type="hidden" uglcw-role="textbox" uglcw-model="cardType"/>
                                    </div>
                                    <div id="grid2" uglcw-role="grid" uglcw-options="
                                    responsive:['.master',40],
                                    url:'${base}manager/pos/queryMemberPage',
                                    criteria: '.query',pageable:true,
                                    dblclick: function(row){
                                        if(checkHaveMemId(row.memId))return;

                                        uglcw.ui.get('#grid').addRow({
                                             memId: row.memId,
                                            name: row.name,
                                            mobile: row.mobile,
                                            cardNo: row.cardNo,
                                            remarks:'',
                                            inputCash:0,
                                            freeCost:0
                                        })

                                    }
						">
                                        <div data-field="name">会员名称</div>
                                        <div data-field="mobile">电话</div>
                                        <div data-field="cardNo">卡号</div>
                                        <div data-field="typeName">会员类型</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<tag:compositive-selector-template/>
<tag:costitem-selector-template/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange' && (e.field == 'amt')) {
                calTotalAmount();
            }

        })
        setTimeout(uglcw.ui.loaded, 210);
    })



    var c, m, s;

    function chooseItem(container, model, selector) {
        c = container;
        m = model;
        s = selector;
        <tag:costitem-selector-script callback="onCostItemChosen"/>
    }

    function onCostItemChosen(row) {
        s.value(row.itemName);
        m.set('itemId', row.id);
        m.set('itemName', row.itemName);
        m.set('typeName', row.typeName);
        saveChanges();
    }

    function selectConsignee() {
        <tag:compositive-selector-script callback="onItemChoose"/>
    }

    function onItemChoose(id, name, type) {
        uglcw.ui.bind('.master', {proName: name, proId: id, proType: type});
    }

    function add() {
        uglcw.ui.openTab('费用报销', '${base}manager/toFinInEdit?r=' + new Date().getTime());
    }


    function scrollToGridBottom() {
        uglcw.ui.get('#grid').scrollBottom()
    }

    function scrollToGridTop() {
        uglcw.ui.get('#grid').scrollTop()
    }

    function saveChanges() {
        uglcw.ui.get('#grid').commit();
    }

    function calTotalAmount() {
        var ds = uglcw.ui.get('#grid').k().dataSource;
        var data = ds.data().toJSON();
        var total = 0;
        var totalfree = 0;
        $(data).each(function (idx, item) {
            total += (Number(item.inputCash));
            totalfree += (Number(item.freeCost));
        })
       // uglcw.ui.get('#totalAmt').value(total);
    }

    function checkHaveMemId(memId)
    {
        var flag = 0;
        var items = uglcw.ui.get('#grid').bind();
        $(items).each(function(idx, item){
            if(item.memId == memId){
               alert('已添加会员' + item.name);
                flag = 1;

            }
        })
        if(flag == 0)
        return false;
        else return true;
    }
    function addRow() {
        uglcw.ui.get('#grid').addRow({
            id: kendo.guid(),
            inTypeCode: 10001,
            qty: 1,
            amt: 0,
        });
    }


    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }

    function draftSave() {
        uglcw.ui.get('#grid').commit();
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            return uglcw.ui.warning('该单据已审批，不能操作!')
        }
        if (status == 2) {
            return uglcw.ui.warning('该单据已作废，不能操作!')
        }
        if (!uglcw.ui.get('form').validate()) {
            return;
        }
        var data = uglcw.ui.bind('form');


        var items = uglcw.ui.get('#grid').bind();
        if (items.length < 1) {
            uglcw.ui.error('请选择费用');
            return;
        }

        var valid = true
       /* $(items).each(function(idx, item){
            if(!item.amt){
                uglcw.ui.warning('第['+(idx+1)+']请输入金额');
                valid =false;
                return false;
            }
        })
        if(!valid){
            return;
        }*/
        data.id = data.billId;
        data.billTimeStr = data.inDate;
        data.status = 0;
        data.subStr = JSON.stringify(items);

        uglcw.ui.confirm('是否确定暂存？', function () {

            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/pos/addPosCardInit',
                type: 'post',
                data: data,
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        $('#billStatus').text('暂存成功');
                        response.billId = response.id;
                        uglcw.ui.bind('form', response);
                        uglcw.ui.success('暂存成功');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function saveAudit() {//保存并审批
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');
        if (form.status == 1) {
            return uglcw.ui.warning('该单据已审批，不能操作！');
        }
        if (form.status == 2) {
            return uglcw.ui.warning('该单据已作废，不能操作!');
        }
        form.id = form.billId;
        form.status = 1;
        form.billTimeStr = form.inDate;
        form.subStr = JSON.stringify(uglcw.ui.get('#grid').bind());


        var items = uglcw.ui.get('#grid').bind();
        if (items.length < 1) {
            uglcw.ui.error('请选择会员');
            return;
        }

        var valid = true

        uglcw.ui.confirm('是否确定保存并提交', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/pos/addPosCardInit',
                type: 'post',
                dataType: 'json',
                data: form,
                success: function (response) {
                    uglcw.ui.loaded()
                    if (response.state) {
                        uglcw.ui.success('提交成功');
                        response.billId = response.id
                        $('#billStatus').text('提交成功');
                        uglcw.ui.bind('form', response);

                        //setTimeout(function () {
                        //    uglcw.ui.replaceCurrentTab('会员初始化' + response.id, '${base}/manager/showFinPreInEdit?billId=' + response.id);
                        //}, 1000);
                    } else {
                        uglcw.ui.error('提交失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded()
                }
            })
        })

    }

    function audit() {
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            uglcw.ui.error('该单据已审批,不能操作!');
            return;
        }
        if (status == 2) {
            uglcw.ui.error('该单据已作废，不能操作！');
            return;
        }
        uglcw.ui.confirm('是否确定审核？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/updateFinPreInAudit',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value(), costTerm: 1},
                dataType: 'json',
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.success('审批成功');
                        $('#billStatus').text('审批成功');
                        uglcw.ui.get('#status').value(1);
                    }else {
                        uglcw.ui.error('操作失败'+json.msg);
                        return;
                    }
                }
            })

        })
    }

    function toPrint() {
        top.layui.index.openTabsPage('${base}manager/showstkinprint?billId=${billId}', '采购开单${billId}打印');
    }

    function reAudit() {
        var billId = uglcw.ui.get('#billId').value();
        var billStatus = uglcw.ui.get('#status').value();
        if (billId == 0) {
            uglcw.ui.warning('没有可反审批的单据');
            return;
        }
        if (billStatus == 2) {
            uglcw.ui.error('该单据已作废');
            return;
        }
        uglcw.ui.confirm('确定反审批吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}/manager/reAuditStkIn',
                type: 'post',
                dataType: 'json',
                data: {billId: billId},
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('反审批成功！')
                        setTimeout(function () {
                            uglcw.ui.closeCurrentTab();
                            uglcw.ui.open('采购单', '${base}/manager/queryStkInPage')
                        }, 1500);
                    } else {
                        uglcw.ui.error(response.msg || '反审批失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })


    }

    function cancelClick() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.warning('没有可作废单据');
        }
        var billStatus = uglcw.ui.get('#billStatus').value();
        if (billStatus == 2) {
            return uglcw.ui.error('该单据已作废');
        }
        uglcw.ui.confirm('确定作废吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}/manager/cancelProc',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.get('#billStatus').value('作废成功');
                        uglcw.ui.get('#status').value(2);
                    } else {
                        uglcw.ui.error(response.msg || '作废失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })

    }

    function auditClick() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.info('请先保存');
        }
        var status = uglcw.ui.get('#billStatus').value();
        if (status == '已审') {
            return uglcw.ui.warning('该单据已审核');
        }
        if (status == '作废') {
            return uglcw.ui.warning('该单据已作废');
        }
        auditProc(billId);
    }

    function auditProc(billId) {

    }
</script>
</body>
</html>
