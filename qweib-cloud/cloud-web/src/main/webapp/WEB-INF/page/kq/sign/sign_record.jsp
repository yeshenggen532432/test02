]<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>会员管理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="${base}resource/kqstyle/js/com.js" type="text/javascript"></script>
    <link href="${base}resource/kqstyle/css/style.css" rel="stylesheet" type="text/css" />
    <link href="${base}resource/kqstyle/css/pop.css" rel="stylesheet" type="text/css" />
    <style id="style1" rel="stylesheet">
        <!--
        .bgtable{
            background-color:#000000;
        }
        .printtd{
            background-color:#FFFFFF;
        }
        .rl_font1 {
            color: #C00000;
            font-weight: bold;
        }
        .rl_font2 {
            font-weight: bold;
        }
        .busi_penson{
            color : #0000FF;
        }
        .busi_bz{
            color : black;
        }
        .not_busi{
            color : red;
        }
        -->
    </style>
</head>

<body class="easyui-layout" fit="true" onload="initPage();">
<div data-options="region:'north'" style="height:45px">

    <table style="height:40px;margin-top: 1px;">
        <tr>
            <th style='width:80px;' >开始日期：</th>
            <td style='width:140px;'><label>&nbsp;<input type="text" id="sdate" style='width:130px;' class="Wdate"  onFocus="WdatePicker({isShowClear:false,readOnly:true})" value="${sdate}"  /></label></td>
            <th style='width:80px;' >结束日期：</th>
            <td style='width:140px;'><label>&nbsp;<input type="text" id="edate" style='width:130px;' class="Wdate"  onFocus="WdatePicker({isShowClear:false,readOnly:true})" value="${edate}"/></label></td>
            <th style='width:120px;' >查询(姓名/手机号码):</th>
            <td style='width:130px;'><label>&nbsp;<input type="text" name="memberNm" id="memberNm" style="width:120px;" onkeydown="queryEmpPage();"/></label></td>
            <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a></th>
            <th style='text-align:left;'><a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:showJia();">添加请假</a></th>
            <td></td>
            <th></th>
            <td></td>
        </tr>
    </table>


</div>
<div data-options="region:'west',split:true,title:'部门分类树'"
     style="width:150px;padding-top: 5px;">
    <div id="divHYGL" style="overflow: auto;">
        <ul id="departtree" class="easyui-tree" fit="true"
            data-options="url:'manager/departs?depart=${depart }&dataTp=1',animate:true,dnd:false,onClick: function(node){
						queryEmpPageByBranchId(node.id);
					},onDblClick:function(node){
						$(this).tree('toggle', node.target);
					}">
        </ul>
    </div>
</div>
<div id="empDiv" data-options="region:'center'" >
    <div class="easyui-layout" data-options="fit:true">

        <div data-options="region:'west',split:true" title="员工" style="width:200px;">
            <table id="datagrid1" class="easyui-datagrid" fit="true" singleSelect="false"
                   url="manager/kqrule/queryKqEmpRulePage" border="false"
                   rownumbers="true" fitColumns="true" pagination="false" pagePosition=3
                   pageSize=20 pageList="[10,20,50,100,200,500,1000]" data-options="onClickRow: onClickRow">
                <thead>
                <tr>
                    <th field="ck" checkbox="true"></th>
                    <th field="member_id" width="10" align="center" hidden="true">
                        memberid
                    </th>

                    <th field="memberNm" width="100" align="center">
                        姓名
                    </th>



                </tr>
                </thead>
            </table>
        </div>
        <div id="classDiv" data-options="region:'center'" >
            <table id="datagrid2" class="easyui-datagrid" fit="true" singleSelect="true"
                   url="manager/sign/querySignInPage" iconCls="icon-save" border="false"
                   rownumbers="true" fitColumns="true" pagination="true"
                   pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
                <thead>
                <tr>
                    <th field="ck" checkbox="true"></th>
                    <th field="id" width="50" align="center" hidden="true">
                        id
                    </th>
                    <th field="mid" width="50" align="center" hidden="true">
                        mid
                    </th>

                    <th field="memberNm" width="100" align="center">
                        姓名
                    </th>
                    <th field="address" width="150" align="center">
                        地址
                    </th>
                    <th field="signTime" width="120" align="center" >
                        签到时间
                    </th>
                    <th field="voiceTime" width="120" align="center" >
                        语音时间长
                    </th>
                    <th field="remarks" width="200" align="center" >
                        备注
                    </th>
                    <th field="listpic" width="400" align="center" formatter="formatterSt">
                        拜访拍照
                    </th>



                </tr>
                </thead>
            </table>



        </div>


    </div>
</div>
<div id="dlg" closed="true" class="easyui-dialog" title="请假" style="width:500px;height:300px;padding:10px"
     data-options="
				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						saveJia();
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
        </dd>

        <dd>
            <span class="title" >开始日期：</span>
            <input type="text" id="startDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd'});" style="width: 100px;"   readonly="readonly" onchange="dateOnChange(this.value,0)"/>
            时间：<input type="text" id="startTime"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'HH:mm'});" style="width: 60px;"  readonly="readonly"/>
        </dd>
        <dd>
            <span class="title" >结束日期：</span>
            <input type="text" id="endDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd'});" style="width: 100px;" value=""  readonly="readonly" onchange="dateOnChange(this.value,1)"/>
            时间：<input type="text" id="endTime"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'HH:mm'});" style="width: 100px;" value=""  readonly="readonly"/>
        </dd>
        <dd>
            <span class="title">备注：</span>
            <input class="reg_input" name="remarks1" id="remarks1"  style="width: 220px"/>
        </dd>
    </div>
</div>

<div id="bigPicDiv"  class="easyui-window" title="图片" style="width:315px;top: 110px;overflow: hidden;"
     minimizable="false" maximizable="false" modal="true"  collapsible="false"
     closed="true">
    <img style="width: 300px;" id="photoImg" alt=""/>
</div>
<script type="text/javascript">
    var trunPageObj = null;
    var bm = null;
    var kh = null;

    var keyDownFlag = false;
    var kqfa1List = null;
    var selectTds = [];

    var beginRow = 0;
    var endRow = 0;
    var beginCol = 0;
    var endCol = 0;
    $(function(){

    });
    function queryData()
    {
        queryEmpPage();
        queryJiaPage();
    }
    function queryEmpPage()
    {
        $("#datagrid1").datagrid('load',{
            url:"manager/kqrule/queryKqEmpRulePage",
            memberNm:$("#memberNm").val(),
            ruleName:$("#ruleName").val(),
            memberUse:1


        });
    }
    function initPage()
    {

    }
    function formatterSt(v,row){
        var hl='<table>';
        hl +='<tr>';
        for(var i=0;i<v.length;i++){
            if((i+1)%4==0){
                hl +='<td>&nbsp;&nbsp;&nbsp;<a href="javascript:toBigPic(\''+v[i].pic+'\');"><img style="width: 85px;" src="${base}upload/'+v[i].picMin+'"/></a></br>&nbsp;&nbsp;&nbsp;</td>';
                hl +='</tr>';
                hl +='<tr>';
            }else{
                hl +='<td>&nbsp;&nbsp;&nbsp;<a href="javascript:toBigPic(\''+v[i].pic+'\');"><img style="width: 85px;" src="${base}upload/'+v[i].picMin+'"/></a></br>&nbsp;&nbsp;&nbsp;</td>';
            }
        }
        hl +='</tr>';
        hl +='</table>';
        return hl;
    }

    function queryEmpPageByBranchId(branchId){

        $("#datagrid1").datagrid('load',{
            url:"manager/kqrule/queryKqEmpRulePage",
            branchId:branchId,
            memberUse:1


        });




    }

    function queryKqJiaByEmpId(memberId)
    {
        $("#datagrid2").datagrid('load',{
            url:"manager/sign/querySignInPage",
            mid:memberId,
            sdate:$("#sdate").val(),
            edate:$("#edate").val() + " 23:59:59"


        });
    }




    function onClickRow(rowIndex, rowData) {

        queryKqJiaByEmpId(rowData.memberId);
    }



    function toBigPic(picurl){
        document.getElementById("photoImg").setAttribute("src","${base}upload/"+picurl);
        $("#bigPicDiv").window("open");
    }
    $('#bigPicDiv').window({
        onBeforeClose:function(){
            document.getElementById("photoImg").setAttribute("src","");
        }
    });




</script>
</body>
</html>
