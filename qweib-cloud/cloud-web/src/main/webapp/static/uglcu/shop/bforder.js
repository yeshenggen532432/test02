//修改审核状态
function updateOrderSh(id, payType) {
    if (0 === payType) {
        uglcw.ui.toast("该订单没有支付类型，暂不能审核！！！");
        return;
    }
    uglcw.ui.confirm("确认要审核吗？", function () {
        $.ajax({
            url: "manager/shopBforder/updateOrderSh",
            data: {
                id: id,
                sh: '审核',
            },
            type: 'post',
            dataType: 'json',
            success: function (response) {
                if (response.state) {
                    uglcw.ui.success(response.msg);
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error(response.msg);
                }
            }
        });
    })
}

//作废订单
function toZf() {
    var rows = uglcw.ui.get('#grid').selectedRow();
    if (rows) {
        var ids = "";
        for (var i = 0; i < rows.length; i++) {
            /*if(selection[i].orderZt=='审核'){
                uglcw.ui.toast("该订单已审核，不能作废");
                return;
            }*/
            if (rows[i].orderZt == '已作废') {
                uglcw.ui.toast("该订单已作废，不能再作废");
                return;
            }
            if(rows[i].isPay ==1 && rows[i].payType != 1){//未支付的订单
            //if (rows[i].payType != 0 && rows[i].payType != 1) {
                uglcw.ui.toast("未支付和线下支付订单才能作废");
                return;
            }
            if (ids) ids += ',';
            ids += rows[i].id;
        }
        uglcw.ui.confirm("确认想要作废该记录吗？", function () {
            $.ajax({
                url: "manager/shopBforder/updateOrderZf",
                data: {
                    ids: ids,
                },
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    if (data && data.state) {
                        uglcw.ui.success("作废成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(data.message);
                      /*没有发现有什么作用,暂时删除
                        if (data.obj) {
                            uglcw.ui.confirm(data.message + "是否自动去除", function () {
                                $(data.obj).each(function (i, item) {
                                    $.map(item, function (v, k) {
                                        $(rows).each(function (i, r) {
                                            if (r.id == k) {
                                                $('#grid tr[data-uid=' + r.uid + '] input.k-checkbox').click();
                                            }
                                        })
                                    });
                                });
                            });
                        } else {
                            uglcw.ui.error(data.message);
                        }*/
                    }
                }
            });
        })
    } else {
        uglcw.ui.toast("请勾选你要操作的行！")
    }
}

//删除订单
function toDel() {
    var id = "";
    var selection = uglcw.ui.get('#grid').selectedRow();
    if (selection) {
        id = selection[0].id;
        if (selection[0].orderZt == '审核') {
            uglcw.ui.toast("该订单审核了，不能删除");
            return;
        }
        uglcw.ui.confirm("确认想要删除记录吗？", function () {
            $.ajax({
                url: "manager/deleteOrder",
                data: {
                    id: id,
                },
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response == "1") {
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


function showDetail(id,shopDiningId) {
    var text="销售订单"+id;
    if(shopDiningId)
        text="餐饮订单"+id;
    uglcw.ui.openTab(text,'manager/shopBforder/detail?_sticky=v2&id=' + id);
}

//修改支付类型
function updatePayType(id) {
    uglcw.ui.confirm('是否确定修改支付类型为线下支付吗?', function () {
        $.ajax({
            url: "/manager/shopBforder/updatePayType",
            data: {"id": id, "payType": 1},
            type: "post",
            success: function (data) {
                if (data.state) {
                    uglcw.ui.success(data.message);
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error(data.message);
                }
            }
        });
    });
}

//弹出商品统计
function showProductGroupList() {
    var btns = [];
    var name=$(window.parent.$("#nav-tabs .layui-this span")).text()||'';
    uglcw.ui.Modal.open({
        title: name+'商品统计',
        maxmin: false,
        btns: btns,
        area: ['800px', '470px'],
        content: uglcw.util.template($('#product-group-list').html())({data: {}}),
        success: function (container) {
            uglcw.ui.init($(container));
        },
        yes: function (container) {//买单

        },
        btn2: function () {//离席买单

        }
    })
}