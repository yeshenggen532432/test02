<%@tag pageEncoding="UTF-8" %>
<%@ attribute name="type" type="java.lang.String" description="单据类型" required="true" %>
<%@ attribute name="collect" type="java.lang.String" description="搜集数据方法" required="true" %>
<%@ attribute name="load" type="java.lang.String" description="绑定数据方法" required="true" %>
<%@ attribute name="billId" type="java.lang.String" description="单据ID" required="true" %>
<%@ attribute name="title" type="java.lang.String" description="标题ID" required="true" %>
<script type="text/x-qwb-template" id="snapshot-tpl">
    <div qwb-role="grid" qwb-options="
            id: 'id',
            pageable: false,
            url: '${base}manager/common/bill/snapshot?billType=${type}',
            data: function(params){
                var billId = qwb.ui.get('#${billId}').value();
                if(billId && billId != '0'){
                    params.billId = billId;
                }
                return params;
            },
            loadFilter:{
                data: function(response){
                    return response.data || [];
                }
            }
        ">
        <div data-field="updateTime" qwb-options="schema:{type: 'timestamp',format: 'yyyy-MM-dd HH:mm:ss'}">更新时间</div>
        <div data-field="title" qwb-options="tooltip: true">客户</div>
        <div data-field="opts" qwb-options="template: qwb.util.template($('#snapshot-opt-tpl').html())">操作</div>
    </div>
</script>
<script type="text/x-qwb-template" id="snapshot-opt-tpl">
    <button class="k-button k-info ghost" onclick="snapshot.remove(this, '#= data.id#')">删除</button>
    <button class="k-button k-info ghost" onclick="snapshot.load('#= data.id#')">读取</button>
</script>
<script>
    (function(window, $, qwb){
        window.snapshot = {
            show: function () {
                qwb.ui.Modal.open({
                    title: '快照列表',
                    area: ['600px', '350px'],
                    content: $('#snapshot-tpl').html(),
                    success: function (c) {
                        qwb.ui.init(c);
                    },
                    btns: false
                })
            },
            load: function (id) {
                $.ajax({
                    url: CTX + 'manager/common/bill/snapshot/' + id,
                    type: 'get',
                    success: function (response) {
                        if (response.success) {
                            var bill = JSON.parse(response.data.data);
                            window['${load}'](bill);
                            qwb.ui.success('快照加载成功');
                            qwb.ui.Modal.close();
                        } else {
                            qwb.ui.error(response.message || '快照加载失败');
                        }
                    }
                })
            },
            remove: function (el, id) {
                var remove = function (e, id) {
                    $.ajax({
                        url: CTX + '/manager/common/bill/snapshot/' + id,
                        type: 'delete',
                        success: function (response) {
                            if (response.success) {
                                if (e) {
                                    qwb.ui.get($(e).closest('.qwb-grid')).reload();
                                    qwb.ui.success('快照删除成功');
                                    var snapshotId = qwb.ui.get('#snapshotId').value();
                                    if (snapshotId === id) {
                                        qwb.ui.get('#snapshotId').value('');
                                    }
                                }
                            } else {
                                qwb.ui.error(response.message || '快照删除失败');
                            }
                        }
                    })
                }
                if (el) {
                    qwb.ui.confirm('确定删除快照吗？', function () {
                        remove(el, id)
                    })
                } else {
                    remove(null, id);
                }
            },
            save: function () {
                window.clearTimeout(this.saveSnapshotDelay);
                this.saveSnapshotDelay = setTimeout(function () {
                    var bill = window['${collect}']();
                    if (!bill) {
                        return;
                    }
                    var billId = bill.master.billId;
                    billId = (billId && billId != '0') ? billId : undefined;
                    $.ajax({
                        url: CTX + '/manager/common/bill/snapshot',
                        contentType: 'application/json',
                        type: 'POST',
                        data: JSON.stringify({
                            title: qwb.ui.get('#${title}').value(),
                            id: qwb.ui.get('#snapshotId').value(),
                            billType: '${type}',
                            data: bill,
                            billId: billId
                        }),
                        success: function (response) {
                            if (response.success) {
                                $('.snapshot-badge-dot').show();
                                qwb.ui.get('#snapshotId').value(response.data)
                            }
                        }
                    })
                }, 1500);
            }
        };
    })(window, jQuery, qwb);
    $(function(){
        if($('#snapshot').length < 1){
            $('.bill-info').append('<div id="snapshot"' +
                '                     style="color:#38F;border:none;"' +
                '                     onclick="snapshot.show()">' +
                '                    快照<i class="k-icon k-i-clock"></i>' +
                '                    <sup class="snapshot-badge-dot"></sup>' +
                '                </div>')
        }
    })
</script>
