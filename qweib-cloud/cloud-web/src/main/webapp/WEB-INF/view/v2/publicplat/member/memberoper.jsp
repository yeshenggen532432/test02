<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>

</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <form class="form-horizontal " uglcw-role="validator">
                        <div class="form-group">
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberId" id="memberId" value="${member.memberId}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="oldPwd" id="oldPwd" value="${member.memberPwd }"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberHead" id="memberHead" value="${member.memberHead}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberFans" id="memberFans" value="${member.memberFans}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberAttentions" id="memberAttentions" value="${member.memberAttentions}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberBlacklist" id="memberBlacklist" value="${member.memberBlacklist}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberCompany" id="memberCompany" value="${member.memberCompany}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberActivate" id="memberActivate" value="${member.memberActivate}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberActivatime" id="memberActivatime" value="${member.memberActivatime}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberGraduated" id="memberGraduated" value="${member.memberGraduated}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberUse" id="memberUse" value="${member.memberUse}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberCreator" id="memberCreator" value="${member.memberCreator}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberCreatime" id="memberCreatime" value="${member.memberCreatime}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberLogintime" id="memberLogintime" value="${member.memberLogintime}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="memberLoginnum" id="memberLoginnum" value="${member.memberLoginnum}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="smsNo" id="smsNo" value="${member.smsNo}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="isAdmin" id="isAdmin" value="${member.isAdmin}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="unitId" id="unitId" value="${member.unitId}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="oldtel" id="oldtel" value="${member.memberMobile}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="state" id="state" value="${member.state}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="score" id="score" value="${member.score}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="branchId" id="branchId"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="oldisLead" value="${member.isLead }"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="msgmodel" value="${member.msgmodel }"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="unId" value="${member.unId }"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="useDog" value="${member.useDog }"/>
                            <label class="control-label col-xs-8">成员姓名:</label>
                            <div class="col-xs-16">
                                <input style="width: 200px;" uglcw-model="memberNm" uglcw-role="textbox"
                                       value="${member.memberNm}" uglcw-validate="required">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-8">手机号码:</label>
                            <div class="col-xs-16">
                                <input style="width: 200px;" uglcw-model="memberMobile" uglcw-role="textbox"
                                       value="${member.memberMobile}"  uglcw-validate="required">
                            </div>
                        </div>
                        <c:if test="${not empty member.memberId}">
                            <div class="form-group">
                                <label class="control-label col-xs-8">密码:</label>
                                <div class="col-xs-16">
                                    <input type="password" style="width: 200px;" uglcw-model="memberPwd" uglcw-role="textbox"
                                           value="${member.memberPwd}"  uglcw-validate="required">
                                </div>
                            </div>
                        </c:if>
                        <div class="form-group">
                            <label class="control-label col-xs-8">职位:</label>
                            <div class="col-xs-16">
                                <input style="width: 200px;" uglcw-model="memberJob" uglcw-role="textbox" value="${member.memberJob}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-8">行业:</label>
                            <div class="col-xs-16">
                                <input style="width: 200px;" uglcw-model="memberTrade" uglcw-role="textbox" value="${member.memberTrade}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-8">是否领导(VIP)：</label>
                            <div class="col-xs-16">
                                <ul uglcw-role="radio" uglcw-model="isLead"
                                    uglcw-value="2"
                                    uglcw-options='layout:"horizontal",
                                    change:function(v){ uglcw.ui.toast(v); },
                                    dataSource:[{"text":"是","value":"1"},{"text":"否","value":"2"}]
                                    '></ul>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-8">角色选择:</label>
                            <div class="col-xs-16">
                                <select style="width: 200px;" uglcw-role="dropdowntree" uglcw-model="roleIds"
                                        uglcw-validate="required"
                                        uglcw-options="
                                  checkboxes: true,
                                  checkAll: true,
                                  value:'4',
                                  url: '${base}manager/queryRoleList',
                                  loadFilter:{
                                    data: function(response){return response.row ||[];}
                                  },
                                  dataTextField: 'roleNm',
                                  dataValueField: 'idKey'
                                ">
                                </select>
                            </div>
                        </div>
                        <c:if test="${tpNm=='卖场'}">
                            <div class="form-group">
                                <input type="hidden" uglcw-model="cid" value="${member.cid}" uglcw-role="textbox">
                                <label class="control-label col-xs-8">所属客户:</label>
                                <div class="col-xs-16">
                                    <input style="width: 200px;" value="${khNm}" uglcw-model="khNm" uglcw-role="textbox">
                                </div>
                                <a href="javascript:choicecustomer()">查询</a>
                            </div>
                        </c:if>
                        <div class="form-group">
                            <label class="control-label col-xs-8">部门:</label>
                            <div class="col-xs-16">
                                <select style="width: 200px;" uglcw-role="dropdowntree" uglcw-model="branchId,branchName"
                                        uglcw-validate="required"
                                        uglcw-options="
                                value:'${member.branchId}',
                                url: '${base}manager/departs?dataTp=1',
                                ">
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-8">家乡:</label>
                            <div class="col-xs-16">
                                <input style="width: 200px;" uglcw-model="memberHometown" uglcw-role="textbox" value="${member.memberHometown}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-8">简介:</label>
                            <div class="col-xs-14">
                                <textarea style="width: 200px;" uglcw-model="memberDesc" uglcw-role="textbox">${member.memberDesc}</textarea>
                            </div>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    })
</script>
</body>
</html>
