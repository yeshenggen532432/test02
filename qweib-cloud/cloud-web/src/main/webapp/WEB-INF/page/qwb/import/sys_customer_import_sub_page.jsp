<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
</head>
<body>
<table id="datagrid"  class="easyui-datagrid"  fit="true" singleSelect="false"
       url="manager/sysCustomerImportMain/subPage?mastId=${mastId}"
       iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" >
    <thead>
    <tr>
        <th field="ck" checkbox="true"></th>
        <th field="id" width="50" align="center" hidden="true">
            客户id
        </th>
        <th field="khCode" width="80" align="center" >
            客户编码
        </th>
        <th field="khNm" width="120" align="center" >
            客户名称
        </th>
        <th field="linkman" width="100" align="center" >
            负责人
        </th>
        <th field="tel" width="120" align="center" >
            负责人电话
        </th>
        <th field="mobile" width="120" align="center" >
            负责人手机
        </th>
        <th field="address" width="275" align="center" >
            地址
        </th>
        <th field="qdtpNm" width="80" align="center" >
            客户类型
        </th>
        <th field="memberNm" width="120" align="center" >
            业务员
        </th>
        <th field="memberMobile" width="120" align="center" >
            业务员手机号
        </th>
        <th field="longitude" width="100" align="center" >
            经度
        </th>
        <th field="latitude" width="100" align="center" >
            纬度
        </th>
    </tr>
    </thead>
</table>
<div id="tb" style="padding:5px;height:auto">
    客户类型： <select name="qdtpNm" id="qdtpNm" style="width: 125px;" ></select>
    客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    业务员: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
</div>

<script type="text/javascript">
    function query() {
        $("#datagrid").datagrid('load', {
            url: "manager/sysCustomerImportMain/toSubPage",
            khTp:2,
            dataTp:$("#dataTp").val(),
            qdtpNm:$("#qdtpNm").val(),
            khNm:$("#khNm").val(),
            memberNm:$("#memberNm").val(),
            isDb:2
        });
    }

    function formatterSt2(val,row){
        if(val=='1'){
            return "有效";
        }else{
            return "无效";
        }
    }
    //回车查询
    function toQuery(e){
        var key = window.event?e.keyCode:e.which;
        if(key==13){
            querycustomer();
        }
    }
    //获取客户类别
    function arealist1(){
        $.ajax({
            url:"manager/queryarealist1",
            type:"post",
            success:function(data){
                if(data){
                    var list = data.list1;
                    var img="";
                    img +='<option value="">--请选择--</option>';
                    for(var i=0;i<list.length;i++){
                        if(list[i].qdtpNm!=''){
                            if(list[i].qdtpNm==qdtpNm){
                                img +='<option value="'+list[i].qdtpNm+'" selected="selected">'+list[i].qdtpNm+'</option>';
                            }else{
                                img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
                            }
                        }
                    }
                    $("#qdtpNm").html(img);
                }
            }
        });
    }


</script>
</body>
</html>
