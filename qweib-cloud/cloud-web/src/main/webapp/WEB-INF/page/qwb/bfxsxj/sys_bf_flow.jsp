<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
</head>

<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       title="" url="manager/queryBfFlow" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="true" pagination="false"
        toolbar="#tb" data-options="">
    <thead>
    <tr>
        <th field="id" width="50" align="center" hidden="true">
            id
        </th>

        <th field="flowName" width="120" align="center">
            步骤名称
        </th>
        <th field="seqNo" width="120" align="center">
            序号
        </th>
        <th field="status" width="120" align="center" formatter="formatChoose">
            状态
        </th>

        <th field="ope" width="120" align="center" formatter="formatterSt3">
            操作
        </th>

    </tr>
    </thead>
</table>
<div id="tb" style="padding:5px;height:auto">
    <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toAddFlow();">添加</a>

</div>


<div id="dlg" closed="true" class="easyui-dialog" title="添加步骤" style="width:400px;height:200px;padding:10px"
     data-options="
				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						saveFlow();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
    <div class="box">
        <dd>
            步骤名称:<input type="text" id="flowName" name="flowName" />

        </select>
        </dd>
        <input type="hidden" id="id" value="0" />
        <input type="hidden" id="seqNo" value="0"/>
        <input type="hidden" id="status" value="1"/>
    </div>




</div>
<script type="text/javascript">


    function toAddFlow()
    {
        $('#dlg').dialog('open');
    }


    function saveFlow(){

        var flowName = $("#flowName").val();
        if(flowName == "")
        {
            alert("请输入名称");
            return;
        }
        $.ajax({
            url:"manager/saveBfFlow",
            type:"post",
            data:"id="+$("#id").val()+"&flowName=" + $("#flowName").val() + "&seqNo=" + $("#seqNo").val() + "&status=" + $("#status").val(),
            success:function(data){
                if(data == '1'){
                    alert("操作成功");
                    $('#dlg').dialog('close');
                    $("#datagrid").datagrid("reload");
                }else{
                    alert("操作失败");
                    return;
                }
            }
        });

    }




    function formatterSt3(val,row){
        if(row.id == 0)return "";
        return "<input style='width:60px;height:27px' type='button' value='删除' onclick='deleteFlow("+row.id+")'/>";
    }

    function formatChoose(val,row){
        if(row.id == 0)return "√";
        var str = "checked='checked'";
        if(val == 0)str = "";
        var html = "<input type='checkbox'  size='7'  onchange='chooseFlow(this," + row.id + ")' name='chkStatus' id='chkStatus"+row.id+"' " + str + "/>";
        return html;
    }

    function formatSeqNo(val,row){
        if(row.id == 0)return val;
        var seqNo = row.seqNo;
        if(seqNo == null || seqNo == undefined || seqNo == ''){
            seqNo = "";
        }
        return "<input type='text'  size='7'  onchange='chooseFlow(this," + row.id + ")' name='seqNo' id='seqNo_"+row.id+"' value='" + seqNo + "'/>";
    }

    function chooseFlow(obj, id) {
        var status = 0;
        if(document.getElementById("chkStatus" + id).checked)status = 1;
        $.ajax({
            url: "manager/chooseBfFlow",
            type: "post",
            data:{
                "id":id,
                "status":status

            },
            success: function (data) {
                if (data == "1") {
                    //alert("操作成功");

                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function deleteFlow(id)
    {
        $.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
            if (r) {
                $.ajax( {
                    url : "manager/deleteBfFlow",
                    data : "id=" + id,
                    type : "post",
                    success : function(json) {
                        if (json.state) {
                            showMsg("删除成功");
                            $("#datagrid").datagrid("reload");
                        }else{
                            showMsg("删除失败");
                        }
                    }
                });
            }
        });
    }

</script>
</body>
</html>
