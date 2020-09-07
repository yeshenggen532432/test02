<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
</head>

<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       url="manager/pos/queryMemberType" title="会员类型列表" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="true" pagination="false" pagePosition=3
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
    <thead>
    <tr>
        <th field="id" width="50" align="center" hidden="true">
            id
        </th>

        <th field="typeName" width="280" align="center">
            会员类型名称
        </th>
        <th field="cost" width="280" align="center">
            工本费
        </th>
        <th field="inputCash" width="80" align="center">
            充值金额
        </th>
        <th field="freeCost" width="80" align="center">
            赠送金额
        </th>
        <th field="cardDate" width="100" align="center">
            有效期
        </th>
        <th field="status" width="100" align="center" formatter="formatterStatus">
            状态
        </th>
        <th field="_operater" width="200" align="center" formatter="formatterOper">
            操作
        </th>
    </tr>
    </thead>
</table>
<div id="tb" style="padding:5px;height:auto">


    <a class="easyui-linkbutton" iconCls="icon-add"  href="javascript:toEditMemberType(0);">新增</a>


</div>

<div id="editdlg" closed="true" class="easyui-dialog" title="编辑" style="width:450px;height:550px;padding:10px"
    data-options="
    iconCls: 'icon-save',

    buttons: [{
    text:'确定',
    iconCls:'icon-ok',
    handler:function(){
    saveMemberType();
    }
    },{
    text:'取消',
    handler:function(){
    $('#editdlg').dialog('close');
    }
    }]
    ">
    <iframe  name="editfrm" id="editfrm" frameborder="0" marginheight="0" marginwidth="0" width="395px" height="450px"></iframe>
</div>

<%--选择会员对话框--%>
<div id="memberDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="会员选择" iconCls="icon-edit"></div>

<script type="text/javascript">

    function queryMemberType(){
        $("#datagrid").datagrid('load',{
            url:"manager/pos/queryMemberType"


        });
    }

    function formatterStatus(val,row){
        var html ="";
        if(row.status==0){
            html= "已停用<input value='启用' style='width:50px;' type='button' onclick='updateStatus("+row.id+",1)'/>";
        }else if(row.status==1){
            html="正常<input value='停用' style='width:50px;' type='button' onclick='updateStatus("+row.id+",0)'/>";
        }
        return html;
    }

    function formatterOper(val,row){
        var isJxc = 0;
        var html = "<button onclick='toEditMemberType("+row.id+")'>修改</button>";
        html += "<button onclick='dialogSelectMember("+row.id+","+isJxc+",1)'>添加</button>";
        html += "<button onclick='dialogSelectMember("+row.id+","+isJxc+",2)'>移除</button>";
        html += "<button onclick='queryShopMemberByGradeId("+row.id+",\""+row.typeName+"\")'>查看</button>";
       // html+="&nbsp;|"+"<a href='javascript:;;' onclick='deleteMemberType(\""+row.id+"\")'>删除<a/>";

        return html;
    }

    function updateStatus(id,status){
        if(confirm("是否确定操作?")){
            $.ajax({
                url:"manager/pos/updateMemberTypeStatus",
                data:"id="+id+"&status="+status,
                type:"post",
                success:function(json){
                    if(json=="1"){
                        alert("操作成功!");
                        $("#datagrid").datagrid("reload");
                    }else{
                        alert("操作失败");
                        return;
                    }
                }
            });
        }
    }


    //弹出“选择会员”对话框
    function dialogSelectMember(id,isJxc,type){
        gradeId = id;
        mType = type;
        if(isJxc!=null && isJxc!=undefined && isJxc=='1'){
            isJxc = 1;
        }else{
            isJxc = 0;
        }
        $('#memberDlg').dialog({
            title: '会员选择',
            iconCls:"icon-edit",
            width: 800,
            height: 400,
            modal: true,
            href: "${base}/manager/pos/toDialogShopMember2?cardType="+gradeId+"&isJxc="+isJxc+"&type="+type,
            onClose: function(){
            }
        });
        $('#memberDlg').dialog('open');
    }

    //按gradeId查询会员
    function queryShopMemberByGradeId(gradeId,gradeName){
        parent.closeWin(gradeName+"_会员列表");
        window.parent.add(gradeName+"_会员列表","manager/pos/toPosMember1?cardType="+gradeId);
    }


    function toEditMemberType(id){
        document.getElementById("editfrm").src="${base}/manager/pos/toPosMemberTypeEdit?id="+id;
        $('#editdlg').dialog('open');
    }

    function deleteMemberType(id){
        $.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
            if (r) {
                $.ajax( {
                    url : "manager/pos/deleteMemberType",
                    data : "id=" + id,
                    type : "post",
                    success : function(json) {
                        if (json == 1) {
                            showMsg("删除成功");
                            $("#datagrid").datagrid("reload");
                        }else{
                            showMsg("删除失败,可能该类型已经在使用");
                        }
                    }
                });
            }
        });
    }

    function saveMemberType() {
        document.getElementById("editfrm").contentWindow.toSubmit();

    }

    //选择会员-回调
    function callBackFunSelectMemeber(ids){
        if(mType==2){
            gradeId = 0;
        }
        $.ajax({
            url:"manager/pos/batUpdateMemberType",
            data:"ids="+ids+"&cardType="+gradeId,
            type:"post",
            success:function(json){
                if(json.state){
                    alert('操作成功');
                }else{
                    alert('操作失败');
                }
            }
        });
    }


</script>
</body>
</html>
