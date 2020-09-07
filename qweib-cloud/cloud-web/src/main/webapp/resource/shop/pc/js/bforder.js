//回车查询
function toQuery(e){
    var key = window.event?e.keyCode:e.which;
    if(key==13){
        queryorder();
    }
}

//商品信息
function formatterSt(v,row){
    var hl='<table>';
    if(row.list.length>0){
        hl +='<tr>';
        hl +='<td width="120px;"><b>商品名称</b></td>';
        hl +='<td width="80px;"><b>销售类型</b></td>';
        hl +='<td width="60px;"><b>单位</font></b></td>';
        hl +='<td width="80px;"><b>规格</font></b></td>';
        hl +='<td width="60px;"><b>数量</font></b></td>';
        hl +='<td width="60px;"><b>单价</font></b></td>';
        hl +='<td width="60px;"><b>总价</font></b></td>';
        hl +='</tr>';
    }
    for(var i=0;i < row.list.length;i++){
        hl +='<tr>';
        hl +='<td>'+row.list[i].wareNm+'</td>';
        hl +='<td>'+row.list[i].xsTp+'</td>';
        hl +='<td>'+row.list[i].wareDw+'</td>';
        //hl +='<td>'+row.list[i].wareGg+'</td>'; zzx使用快照
        hl +='<td>'+row.list[i].detailWareGg+'</td>';
        hl +='<td>'+row.list[i].wareNum+'</td>';
        hl +='<td>'+row.list[i].wareDj+'</td>';
        hl +='<td>'+row.list[i].wareZj+'</td>';
        hl +='</tr>';
    }
    hl +='</table>';
    return hl;
}

//订单状态
function formatOrderZt(val,row){
    if(val=='未审核'){
        if((row.isPay ||  row.payType==1)&&row.status)//只有线下支付和已支付订单才能审核功能
            return "<input style='width:60px;height:27px' type='button' value='未审核' onclick='updateOrderSh(this,"+row.id+","+row.payType+")'/>";
        else
            return "<span title='订单已支付或线下付款并未取消状态订单才能审核'>未审核</span>";
    }else{
        return val;
    }
}

//付款状态
function formatterIsPay(val,row){
    if("1"==val){
        return "已付款";
    }if("10"==val){
        return "<span style='color:red;'>已退款</span>";
    }
}


//进入“详情”ye
function todetail(title,id){
    window.parent.add(title,"manager/queryBforderDetailPage?orderId="+id);
}

//修改审核
function updateOrderSh(_this,id,payType){
    if(0==payType){
        alert("该订单没有支付类型，暂不能审核！！！");
        return;
    }
    $.messager.confirm('确认', '您确认要审核吗？', function(r) {
        if (r) {
            $.ajax({
                url:"manager/updateOrderSh",
                type:"post",
                data:{"id":id,"sh":"审核"},
                success:function(data){
                    if(data=='1'){
                        alert("操作成功");
                        queryorder();
                    }else{
                        alert("操作失败");
                        return;
                    }
                }
            });
        }
    });
}

//双击事件
function onDblClickRow(rowIndex, rowData){
    window.parent.add(rowData.orderNo+"销售订单","manager/showorder?id="+rowData.id);
}
//删除订单
function toDel() {
    var ids = [];
    var rows = $("#datagrid").datagrid("getSelections");
    for ( var i = 0;rows.length > i; i++) {
        ids.push(rows[i].id);
        if(rows[i].orderZt=='审核'){
            alert("该订单审核了，不能删除");
            return;
        }
    }
    if (ids.length > 0) {
        $.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
            if (r) {
                $.ajax( {
                    url : "manager/deleteOrder",
                    data : "id=" + ids,
                    type : "post",
                    success : function(json) {
                        if (json == 1) {
                            showMsg("删除成功");
                            $("#datagrid").datagrid("reload");
                        } else if (json == -1) {
                            showMsg("删除失败");
                        }
                    }
                });
            }
        });
    } else {
        showMsg("请选择要删除的数据");
    }
}
//作废订单
function toZf() {
    var ids = [];
    var rows = $("#datagrid").datagrid("getSelections");
    for (var i = 0; rows.length > i; i++) {
        /*if(rows[i].orderZt=='审核'){
            alert("该订单已审核，不能作废");
            return;
        }*/
        if(rows[i].orderZt=='已作废'){
            alert("该订单已作废，不能再作废");
            return;
        }
        if(rows[i].isPay ==1 && rows[i].payType != 1){
        //if (rows[i].payType !=0 && rows[i].payType != 1) {
            alert("未支付和线下支付订单才能作废");
            return;
        }
        ids.push(rows[i].id);
    }
    if (ids.length > 0) {
        $.messager.confirm('确认', '您确认想要作废该记录吗？', function(r) {
            if (r) {
                $.ajax( {
                    url : "manager/shopBforder/updateOrderZf",
                    data : "ids=" + ids,
                    type : "post",
                    success : function(data) {
                        if (data&&data.state) {
                            showMsg("作废成功");
                            $("#datagrid").datagrid("reload");
                        } else{
                            var orderNo="";
                            if(data.obj){
                                $(data.obj).each(function (i,item) {
                                    $.map(item,function(v,k){orderNo=v;})
                                });
                            }
                            showMsg(data.message+orderNo);
                        }
                    }
                });
            }
        });
    } else {
        showMsg("请选择要作废的数据");
    }
}

//修改支付类型
function updatePayType(id) {
    $.messager.confirm('确认', '是否确定修改支付类型为线下支付吗?', function(r) {
        if (r) {
            $.ajax( {
                url : "/manager/shopBforder/updatePayType",
                data : {"id":id,"payType":1},
                type : "post",
                success : function(data) {
                    showMsg(data.message);
                    if (data.state) {
                        $("#datagrid").datagrid("reload");
                    }
                }
            });
        }
    });
}

$(function () {
    queryorder();
});