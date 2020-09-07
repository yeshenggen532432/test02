<%@ page language="java" pageEncoding="UTF-8" %>
<div id="member_authority" class="easyui-window" style="width:520px;height:650px;"
     minimizable="false" modal="true" collapsible="false" closed="true">
    <div id="member_authority_tree" class="menuTree" data-options="region:'north'"
         style="width: 500px;height:605px;overflow: auto;padding-left: 5px;">
        <div id="member_authority_tree_content" class="dtree"></div>
    </div>
</div>
<script type="text/javascript">
    function showMemberAuthority(memberId, menuType) {
        $("#member_authority_tree_content").empty();
        var tl;
        if (menuType == '1') {
            tl = "菜单权限";
        } else {
            tl = "应用权限";
        }
        $.ajax({
            type: "get",
            url: "manager/member/authority",
            data: {member_id: memberId, menu_type: menuType},
            dataType: "json",
            success: function (data) {
                if (data) {
                    loadMemberAuthorityTree("member_authority_tree", "member_authority_tree_content", tl, data);
                }
            }
        });
        $("#member_authority").window('open');
    }

    //显示菜单树
    function loadMemberAuthorityTree(treeName, objDiv, title, data) {
        var treeName = treeName + "_d";
        objTree = new dTree(treeName);
        objTree.add(0, -1, title);
        if (data) {
            for (var i = 0; i < data.length; i++) {
                var nodeid = data[i].id;
                var nodevl = data[i].applyName;
                var parid = data[i].PId;
                var menuTp = data[i].menuTp;
                var menuSeq = data[i].applyNo;
                var tp = data[i].tp;
                var bindId = data[i].menuId;
                var dataTp = data[i].menuLeaf;
                var sgtjz = data[i].sgtjz;
                var mids = data[i].mids;
                var chosevalue = "<input type='checkbox' name='roleMenu[" + i + "].ifChecked' id='" + nodeid + "_" + parid + "_" + menuTp + "'";
                if (menuSeq == 0) {
                    chosevalue += " value='false'";
                } else {
                    chosevalue += " checked='checked' value='true'";
                }
                chosevalue += " disabled/>";

                var dataTpHtml = "";
                if (menuTp == '1') {//功能按钮即最后一级
                    dataTpHtml = "&nbsp;&nbsp;<input value='1' name='roleMenu[" + i + "].dataTp' type='radio'";
                    if (dataTp == '1') {
                        dataTpHtml += " checked";
                    }
                    dataTpHtml += " disabled/>全部";

                    dataTpHtml += "<input value='2' name='roleMenu[" + i + "].dataTp' type='radio'";
                    if (dataTp == '2') {
                        dataTpHtml += " checked";
                    }
                    dataTpHtml += " disabled/>部门及子部门";

                    dataTpHtml += "<input value='3' name='roleMenu[" + i + "].dataTp' type='radio'";
                    if (dataTp == '3') {
                        dataTpHtml += " checked";
                    }
                    dataTpHtml += " disabled/>个人";

                    dataTpHtml += "<input value='4' name='roleMenu[" + i + "].dataTp' type='radio'";
                    if (dataTp == '4') {
                        dataTpHtml += " checked";
                    }
                    dataTpHtml += " disabled/>自定义";
                }
                var dataTpHtml2 = "";
                if (nodevl == '报表统计') {
                    dataTpHtml2 += "</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    dataTpHtml2 += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    dataTpHtml2 += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

                    dataTpHtml2 += "<input name='roleMenu[" + i + "].sgtjz' type='checkbox' value='1'";
                    if (sgtjz.indexOf("1") >= 0) {
                        dataTpHtml2 += " checked";
                    }
                    dataTpHtml2 += " disabled/>业务执行";

                    dataTpHtml2 += "<input name='roleMenu[" + i + "].sgtjz'  type='checkbox' value='2'";
                    if (sgtjz.indexOf("2") >= 0) {
                        dataTpHtml2 += " checked";
                    }
                    dataTpHtml2 += " disabled/>客户拜访";

                    dataTpHtml2 += "<input name='roleMenu[" + i + "].sgtjz' type='checkbox' value='3'";
                    if (sgtjz.indexOf("3") >= 0) {
                        dataTpHtml2 += " checked";
                    }
                    dataTpHtml2 += " disabled/>产品订单";

                    dataTpHtml2 += "<input name='roleMenu[" + i + "].sgtjz'  type='checkbox' value='4'";
                    if (sgtjz.indexOf("4") >= 0) {
                        dataTpHtml2 += " checked";
                    }
                    dataTpHtml2 += " disabled/>销售订单";
                }
                objTree.add(nodeid, parid, nodevl + chosevalue + dataTpHtml + dataTpHtml2, "javascript:void();");
            }
            eval(treeName + "= objTree");
            document.getElementById(objDiv).innerHTML = objTree;
            objTree.openAll();
        }
    }
</script>