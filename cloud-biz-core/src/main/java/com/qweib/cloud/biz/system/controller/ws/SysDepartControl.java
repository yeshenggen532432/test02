package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.biz.common.MapGjTool;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.SysCompanyJoinService;
import com.qweib.cloud.biz.system.service.plat.*;
import com.qweib.cloud.biz.system.service.ws.*;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.DateUtils;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import org.apache.curator.shaded.com.google.common.collect.Lists;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/web")
public class SysDepartControl extends BaseWebService {
    @Resource
    private SysDepartService departService;
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysChatMsgService chatMsgService;
    @Resource
    private SysCorporationService corporationService;
    @Resource
    private SysMemberService memberService;
    @Resource
    private SysMemBindService memBindService;
    @Resource
    private PublicMsgWebService publicMsgWebService;
    @Resource
    private BscInvitationService invitationService;
    @Resource
    private SysOftenuserService sysOftenuserService;
    @Resource
    private JpushClassifies jpushClassifies;
    @Resource
    private JpushClassifies2 jpushClassifies2;
    @Resource
    private SysDeptmempowerService deptmempowerService;
    @Resource
    private SysMemberCompanyService memberCompanyService;
    @Resource
    private SysMemService sysMemService;
    @Resource
    private SysCompanyJoinService companyJoinService;
    @Autowired
    private DataSourceContextAllocator dataSourceContextAllocator;

    /**
     * @param ybs 1为易办事 其他或者为空时为通讯录
     * @return
     * @说明：1我的好友/2常用好友/3黑名单
     * @创建者： 作者：llp  创建时间：2015-2-6
     */
    @RequestMapping("queryMyMember")
    public void queryMyMember(HttpServletResponse response, String token, String tp, Integer pageSize, Integer pageNo, String ybs) {
        try {
            if (!checkParam(response, token, pageNo, tp)) {
                return;
            }
            if (StrUtil.isNull(pageSize)) {
                pageSize = 10;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            if ("2".equals(tp)) {
                List<SysMemBind> list = memBindService.queryCy(loginDto.getMemId(), loginDto.getDatabase(), ybs);
                JSONObject json = new JSONObject();
                json.put("state", true);
                json.put("msg", "获取常用常用联系人成功");
                json.put("rows", list);
                this.sendJsonResponse(response, json.toString());
            } else {
                Page p = this.memBindService.queryMyMember(pageNo, pageSize, loginDto.getMemId(), tp);
                JSONObject json = new JSONObject();
                json.put("state", true);
                json.put("msg", "获取我的好友成功");
                json.put("pageNo", pageNo);
                json.put("pageSize", pageSize);
                json.put("total", p.getTotal());
                json.put("totalPage", p.getTotalPage());
                json.put("rows", p.getRows());
                this.sendJsonResponse(response, json.toString());
            }
        } catch (Exception e) {
            this.sendWarm(response, "获取我的好友失败");
        }
    }

    /**
     * 1常用 2 不常用
     *
     * @return
     * @说明：设置好友常用状态
     * @创建者： 作者：llp  创建时间：2015-2-9
     */
    @RequestMapping("updateIsused")
    public void updateIsused(HttpServletResponse response, String token, String tp, Integer bindMemberId) {
        try {
            if (!checkParam(response, token, tp, bindMemberId)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            if (null != loginDto.getDatabase()) {
                this.memBindService.updateMemberbindByused(tp, loginDto.getMemId(), bindMemberId, loginDto.getDatabase());
            } else {
                this.memBindService.updateMemberbindByused(tp, loginDto.getMemId(), bindMemberId, null);
            }

            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "设置好友常用状态成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "设置好友常用状态失败");
        }

    }

    /**
     * @return
     * @说明：设置好友关系状态
     * @创建者： 作者：llp  创建时间：2015-2-11
     */
    @RequestMapping("updateBindtp")
    public void updateBindtp(HttpServletResponse response, String token, String tp, Integer bindMemberId) {
        try {
            if (!checkParam(response, token, tp, bindMemberId)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            this.memBindService.updateMemberbindByzt(tp, loginDto.getMemId(), bindMemberId);
            SysMember member = this.memberWebService.queryMemById(loginDto.getMemId());
            int count = member.getMemberBlacklist() + 1;
            this.memberService.updateMemberByBlacklist(loginDto.getDatabase(), loginDto.getMemId(), count);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "设置好友关系状态成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "设置好友关系状态失败");
        }
    }

    /**
     * @return
     * @说明：删除我的好友
     * @创建者： 作者：llp  创建时间：2015-2-11
     */
    @RequestMapping("deleteMyMember")
    public void deleteMyMember(HttpServletResponse response, String token, Integer bindMemberId) {
        try {
            if (!checkParam(response, token, bindMemberId)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            this.memBindService.deleteMemberAttention(loginDto.getMemId(), bindMemberId);
            SysMember member = this.memberWebService.queryMemById(loginDto.getMemId());
            int count = member.getMemberAttentions() - 1;
            this.memberService.updateMemberByAttentions(loginDto.getDatabase(), loginDto.getMemId(), count);
            //互相解除好友关系
            this.memBindService.deleteMemberAttention(bindMemberId, loginDto.getMemId());
            SysMember member2 = this.memberWebService.queryMemById(bindMemberId);
            int count2 = member2.getMemberAttentions() - 1;
            this.memberService.updateMemberByAttentions(loginDto.getDatabase(), bindMemberId, count2);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "删除我的好友成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "删除我的好友失败");
        }

    }

    /**
     * @param response
     * @param token
     * @param bindMemberId
     * @创建：作者:YYP 创建时间：2015-4-14
     */
    @RequestMapping("applyFriend")
    public void applyFriend(HttpServletResponse response, String token, Integer bindMemberId) {
        if (!checkParam(response, token, bindMemberId)) {
            return;
        }
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            Integer info = memBindService.queryIsMyFriends(loginDto.getMemId(), bindMemberId, 1);
            if (info > 0) {
                sendWarm(response, "已经为好友关系");
                return;
            }
            SysMemDTO member = this.memberWebService.queryMemByMemId(bindMemberId);
            String time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            //--------------保存邀请记录----------------
            List<BscInvitation> ivMsgs = new ArrayList<BscInvitation>();
            BscInvitation iv = new BscInvitation();
            iv.setMemberId(loginDto.getMemId());
            iv.setReceiveId(member.getMemberId());
            iv.setTp("2");
            iv.setContent("申请您为好友");
            iv.setIntime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            ivMsgs.add(iv);
            invitationService.addInvitationMsgs(ivMsgs);
            //-------------保存未读记录-------------
            SysChatMsg scm = new SysChatMsg();
            scm.setAddtime(time);
            scm.setMemberId(loginDto.getMemId());
            scm.setMsg("申请您为好友");
            scm.setReceiveId(member.getMemberId());
            scm.setTp("19");
            publicMsgWebService.addpublicMsg(scm);
            jpushClassifies.toJpush(member.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "邀请好友推送", null);
            jpushClassifies2.toJpush(member.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "邀请好友推送", null);
            sendSuccess(response, "成功邀请好友");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @return
     * @说明：同意或不同意添加好友
     * @创建者： 作者：llp  创建时间：2015-2-11
     * @agree 1 同意 其他不同意
     */
    @RequestMapping("addMemberAttention")
    public void addMemberAttention(HttpServletResponse response, String token, Integer bindMemberId, String agree) {
        try {
            String msg = null;
            Integer jude = null;
            if (!checkParam(response, token, bindMemberId)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            SysMember member2 = this.memberWebService.queryMemById(bindMemberId);
            if (null == member2) {
                sendWarm(response, "该成员不存在");
                return;
            }
            Integer info = memBindService.queryIsMyFriends(loginDto.getMemId(), bindMemberId, 1);
            if (info > 0) {
                sendWarm(response, "已经为好友关系");
                return;
            }
            if ("1".equals(agree)) {
                msg = "成为您的好友";
                SysMemBind sb = new SysMemBind();
                sb.setBindMemberId(bindMemberId);
                sb.setMemberId(loginDto.getMemId());
                sb.setBindTp("1");
                sb.setIsUsed("2");
                sb.setIsShield("0");
                this.memBindService.addMemberAttention(sb);
                SysMember member = this.memberWebService.queryMemById(loginDto.getMemId());
                int count = member.getMemberAttentions() + 1;
                this.memberService.updateMemberByAttentions(loginDto.getDatabase(), loginDto.getMemId(), count);
                //互相添加好友关系
                SysMemBind sb2 = new SysMemBind();
                sb2.setBindMemberId(loginDto.getMemId());
                sb2.setMemberId(bindMemberId);
                sb2.setBindTp("1");
                sb2.setIsUsed("2");
                sb2.setIsShield("0");
                this.memBindService.addMemberAttention(sb2);
                int count2 = member2.getMemberAttentions() + 1;
                jude = this.memberService.updateMemberByAttentions(loginDto.getDatabase(), bindMemberId, count2);
            } else {//不同意
                jude = invitationService.updateInAgree(loginDto.getMemId(), bindMemberId, null, agree, "4");
                msg = "拒绝您的好友申请";
            }
            //回推
            if (null != jude && jude > 0) {
                SysChatMsg scm = new SysChatMsg();
                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                scm.setMemberId(loginDto.getMemId());
                scm.setMsg(msg);
                scm.setReceiveId(bindMemberId);
                scm.setTp("20");
                publicMsgWebService.addpublicMsg(scm);
                jpushClassifies.toJpush(member2.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "同意或不同意好友申请推送", null);
                jpushClassifies2.toJpush(member2.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "同意或不同意好友申请推送", null);
            }
            sendSuccess(response, "处理好友邀请成功");
        } catch (Exception e) {
            this.sendWarm(response, "处理好友邀请失败");
        }

    }

    /**
     * @return
     * @说明：获取公司
     * @创建者： 作者：llp  创建时间：2015-3-11
     */
    @RequestMapping("queryCorporation")
    public void queryCorporation(HttpServletResponse response, String token) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            SysMemDTO memDTO = memberWebService.queryMemByMemId(loginDto.getMemId());
            JSONObject json = new JSONObject();
            String datasource = memDTO.getDatasource();
            if (null != datasource && !"".equals(datasource)) {
                SysCorporation corporation = this.corporationService.queryCorporationBydata(datasource);
                int num = this.memberWebService.queryMemCount(datasource);
                TokenServer.updateToken(token, datasource, null, null);//判断公司是否变化，变化的话更改公司datasource
                json.put("state", true);
                json.put("msg", "获取公司成功");
                json.put("deptNm", corporation.getDeptNm());
                json.put("deptId", corporation.getDeptId());
                json.put("deptHead", corporation.getDeptHead());
                json.put("datasource", corporation.getDatasource());
                json.put("num", num);
            } else {
                json.put("state", true);
                json.put("msg", "获取公司成功");
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * @return
     * @说明：公司底下部门和人员列表
     * @创建者： 作者：llp  创建时间：2015-2-2
     */
    @RequestMapping("queryDepartls")
    public void queryDepartlsweb(HttpServletResponse response, String token, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        List<SysDepart> departls = new ArrayList<SysDepart>();
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)){
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            OnlineUser loginDto = message.getOnlineMember();
//			SysMember member=this.memberWebService.queryAllById(loginDto.getMemId());
//			String tp="";
//			if(member.getIsUnitmng().equals("1")||member.getIsUnitmng().equals("2")){
//				tp="1";
//			}
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + loginDto.getMemId();
                departls = this.departService.queryDepartsForzdy(loginDto.getDatabase(), mids);
                for (int i = 0; i < departls.size(); i++) {
                    departls.get(i).setNum(this.departService.queryMemBmCountzdy(loginDto.getDatabase(), departls.get(i).getBranchId(), mids));
                }
            } else {
                departls = this.departService.queryDepartLs(loginDto, dataTp);
                for (int i = 0; i < departls.size(); i++) {
                    departls.get(i).setNum(this.departService.queryMemBmCount(loginDto.getDatabase(), departls.get(i).getBranchId()));
                }
            }
            List<SysMemDTO> memls = new ArrayList<SysMemDTO>();
            if ("1".equals(dataTp)) {
                memls = this.departService.querySysMemLs(loginDto.getDatabase(), loginDto.getMemId(), "1");
            }
//			SysDepart d = new SysDepart();
//			d.setBranchId(10);
//			departls.add(d);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取部门及成员成功");
            json.put("departls", departls);
            json.put("memls", memls);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取部门及成员失败");
        }

    }

    /**
     * @return
     * @说明：获取子部门或者成员
     * @创建者： 作者：llp  创建时间：2015-2-7
     */
    @RequestMapping("queryDepartlszOrcy")
    public void queryDepartlszOrcy(HttpServletResponse response, String token, Integer parentid, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        try {
            if (!checkParam(response, token, parentid)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)){
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            OnlineUser loginDto = message.getOnlineMember();
            SysMember member = this.memberWebService.queryAllById(loginDto.getMemId());
//			String tp="";
//			if(member.getIsUnitmng().equals("1")||member.getIsUnitmng().equals("2")){
//				tp="1";
//			}
            JSONObject json = new JSONObject();
            List<SysDepart> departls = new ArrayList<SysDepart>();
            List<SysMemDTO> memls = new ArrayList<SysMemDTO>();
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + loginDto.getMemId();
                memls = this.departService.queryMemByzdy(loginDto.getDatabase(), parentid, mids);
            } else {
                departls = this.departService.queryDepartLsz(loginDto, parentid, dataTp);
                for (int i = 0; i < departls.size(); i++) {
                    departls.get(i).setNum(this.departService.queryMemBmCount(loginDto.getDatabase(), departls.get(i).getBranchId()));
                }
                if ("1".equals(dataTp)) {//查询全部
                    memls = this.departService.querySysMemLsByBid(parentid, loginDto.getDatabase(), loginDto.getMemId(), "1", null);
                } else if ("2".equals(dataTp) && parentid == member.getBranchId()) {//查询部门及子部门
                    memls = departService.querySysMemLsForDepart(parentid, loginDto.getDatabase(), loginDto.getMemId(), member.getBranchId());
                } else if ("3".equals(dataTp) && parentid == member.getBranchId()) {
                    memls = this.departService.querySysMemLsByBid(parentid, loginDto.getDatabase(), loginDto.getMemId(), "1", "1");
                }
            }
            json.put("state", true);
            json.put("msg", "获取子部门或者成员成功");
            json.put("departls", departls);
            json.put("memls", memls);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取子部门或者成员失败");
        }
    }

    /**
     * @return
     * @说明：创建部门或者子部门
     * @创建者： 作者：llp  创建时间：2015-2-2
     */
    @RequestMapping("addDepart")
    public void addDepartweb(HttpServletResponse response, String token, String branchName, String branchMemo, Integer parentid, @RequestParam(defaultValue = "3") String dataTp) {
        try {
            if (!checkParam(response, token, branchName)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)) {
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            OnlineUser loginDto = message.getOnlineMember();
            SysMember member = memberWebService.queryAllById(loginDto.getMemId());
            //查询当前用户角色的数据类型
            if (!"1".equals(dataTp)) {
                sendWarm(response, "您没有权限");
                return;
            }
//			if(!"1".equals(member.getIsUnitmng()) && !"2".equals(member.getIsUnitmng())){
//				sendWarm(response, "您不是公司管理员，没有权限");
//				return;
//			}
            String database = loginDto.getDatabase();
            Integer info = departService.queryIsExistDeptNm(branchName, parentid, database);
            if (info > 0) {
                sendWarm(response, "该节点下已存在该部门");
                return;
            }
            SysDepart depart = new SysDepart();
            if (!StrUtil.isNull(parentid)) {
                SysDepart temp = this.departService.queryDepartById(parentid, database);
                String[] strs = temp.getBranchPath().split("-");
                if (strs.length >= 6) {
                    JSONObject json = new JSONObject();
                    json.put("state", false);
                    json.put("msg", "已经最后一级不能在添加下级");
                    this.sendJsonResponse(response, json.toString());
                    return;
                }
                depart.setParentId(parentid);
                depart.setBranchLeaf("1");
                //更新父节点的branch_leaf为0
                departService.updateDepartLeaf(parentid, "0", database);
            } else {
                depart.setParentId(0);
                depart.setBranchLeaf("1");
            }
            depart.setBranchName(branchName);
            depart.setBranchMemo(branchMemo);
            this.departService.addDepart(depart, database);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "创建部门成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "创建部门失败");
        }
    }

    /**
     * @return
     * @说明：邀请同事
     * @创建者： 作者：llp  创建时间：2015-2-5
     * @deptId 部门id 如果邀请到公司下不传，其他传要邀请加入的部门id
     */
    @RequestMapping("yqworkmate")
    public void yqworkmate(HttpServletResponse response, String token, String tel, Integer deptId) {
        Integer belongId = null;//部门或公司id
        String tp = null;//类型
        String chatTp = null;//未读类型
        String msgContent = "";
        try {
            if (!checkParam(response, token, tel)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            if (loginDto.getTel().equals(tel)) {
                sendWarm(response, "自己不能邀请自己");
                return;
            }
            SysMember member = this.memberWebService.queryMemberByTel(tel);//被邀请人成员信息
            if (null == member) {
                sendWarm(response, "您邀请的人还没注册加入云上");
                return;
            }
            int count = this.memberWebService.querySysMemberByTel(tel);//是否有所属公司
            SysMember member1 = this.memberWebService.querymemCompany(loginDto.getMemId());//邀请人成员信息
            if (null != member.getUnitId()) {//已经有所属公司
                if (!member1.getUnitId().equals(member.getUnitId())) {//不同公司
                    sendWarm(response, "该成员已有所属公司");
                    return;
                } else {//同一个公司
                    if (null == deptId) {//加入公司下
                        if (null == member.getBranchId() || "0".equals(member.getBranchId())) {//公司下又加入公司下提示
                            sendWarm(response, "该成员已经在该公司级下");
                            return;
                        }
                    } else {//加入部门下
                        if (null != member.getBranchId() && !"0".equals(member.getBranchId())) {
                            if (member.getBranchId().equals(deptId)) {
                                sendWarm(response, "该成员已经在该部门下");
                                return;
                            }
                        }
                    }
                }
            }
            SysCorporation company = corporationService.queryCorporationBydata(loginDto.getDatabase());
            if (StrUtil.isNull(deptId)) {//加入公司
                belongId = member1.getUnitId();
                tp = "3";
                chatTp = "16";
                msgContent = "邀请您加入 [" + member1.getBranchName() + "] 公司";
            } else {//部门
                SysDepart dept = departService.queryDepartByid(deptId, loginDto.getDatabase());//查询部门信息
                belongId = dept.getBranchId();
                tp = "4";
                chatTp = "18";
                msgContent = "邀请您加入 [" + dept.getBranchName() + "] 部门";
            }
            String time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            //--------------保存邀请记录----------------
            List<BscInvitation> ivMsgs = new ArrayList<BscInvitation>();
            BscInvitation iv = new BscInvitation();
            iv.setMemberId(loginDto.getMemId());
            iv.setReceiveId(member.getMemberId());
            iv.setTp(tp);
            iv.setContent(msgContent);
            iv.setBelongId(belongId);
            iv.setDatasource(loginDto.getDatabase());
            iv.setIntime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            ivMsgs.add(iv);
            invitationService.addInvitationMsgs(ivMsgs);
            //-------------保存未读记录-------------
            SysChatMsg scm = new SysChatMsg();
            scm.setAddtime(time);
            scm.setMemberId(loginDto.getMemId());
            scm.setMsg(msgContent);
            scm.setMsgTp("1");
            scm.setReceiveId(member.getMemberId());
            scm.setTp(chatTp);
            scm.setBelongId(belongId);//公司或部门id
            scm.setBelongNm(loginDto.getDatabase());//数据库名
            scm.setBelongMsg(company.getDeptHead());//公司头像
            if (count < 1) {//没有所属公司
                publicMsgWebService.addpublicMsg(scm);
            } else {
                this.chatMsgService.addChatMsg(scm, loginDto.getDatabase());
            }
            jpushClassifies.toJpush(tel, CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "邀请推送", null);
            jpushClassifies2.toJpush(tel, CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "邀请推送", null);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "邀请成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "邀请失败");
        }
    }

    /**
     * @param database 数据库名称
     * @param tp       1 同意 -1不同意
     * @param idTp     1公司 2 部门
     * @param belongId 公司id或者部门id
     * @param memId    发送人id
     * @return
     * @说明：同事同意或不同意加入
     * @创建者： 作者：llp  创建时间：2015-2-5
     */
    @RequestMapping("workmateagree")
    public void workmateagree(HttpServletResponse response, String token, String database, String tp, String idTp, Integer belongId, Integer memId) {
        try {
            String msg = null;
            Integer jude = null;
            if (!checkParam(response, token, database, tp, idTp)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            if (tp.equals("1")) {//同意
                SysMember member = this.memberWebService.queryAllById(loginDto.getMemId());//公共平台上用户信息
                if (null == member) {
                    sendWarm(response, "该成员不存在");
                    return;
                }
                if (null != member.getUnitId() && "1".equals(idTp)) {//已有所属公司且要加入公司
                    sendWarm(response, "您已有所属公司");
                    return;
                }
                SysCorporation corporation = this.corporationService.queryCorporationBydata(database);
                if ("1".equals(idTp)) {//公司
                    if (corporation.getDeptId() != (long) belongId) {
                        sendWarm(response, "要加入公司不是 [" + corporation.getDeptNm() + "] 公司");
                        return;
                    }
                    member.setUnitId(corporation.getDeptId().intValue());
                    member.setMemberCompany(corporation.getDeptNm());
                    jude = departService.addMemCompany(member, database, belongId, memId, tp, idTp);
                    TokenServer.updateToken(token, database, null, null);
                    msg = "接受您加入[" + corporation.getDeptNm() + "]公司的邀请";
                } else {//部门
//					SysMemDTO m=this.memberWebService.queryMemByMemId(memId);//公共平台上用户信息
//					if(null!=m.getDatasource() && !m.getDatasource().equals(database)){
//						sendWarm(response, "要加入公司不是 ["+corporation.getDeptNm()+"] 公司");
//						return;
//					}
                    SysDepart dept = departService.queryDepartByid(belongId, database);
                    if (null == dept) {
                        sendWarm(response, "要加入的部门不存在或已删除");
                        return;
                    }
                    if (null == member.getUnitId()) {//无所属公司先加入公司再加入部门
                        member.setUnitId(corporation.getDeptId().intValue());
                        member.setMemberCompany(corporation.getDeptNm());
                        member.setBranchId(belongId);//部门
                        jude = departService.addMemCompany(member, database, belongId, memId, tp, idTp);
                        TokenServer.updateToken(token, database, null, null);
                    } else {//有所属公司加入部门判断是否是该公司的部门
                        if (!database.equals(loginDto.getDatabase())) {
                            sendWarm(response, "您要加入的部门不在您所属公司下");
                            return;
                        }
                        jude = departService.updateMemDept(belongId, database, null, null, loginDto.getMemId(), memId, tp, idTp);
                    }
                    msg = "接受您加入[" + dept.getBranchName() + "]部门邀请";
                }
            } else {//不同意
                msg = loginDto.getMemberNm() + "拒绝您的组织邀请";
                jude = invitationService.updateInAgree(loginDto.getMemId(), memId, belongId, tp, idTp);
            }
            //回推
            if (null != jude && jude > 0) {
                SysChatMsg scm = new SysChatMsg();
                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                scm.setMemberId(loginDto.getMemId());
                scm.setMsg(msg);
                scm.setReceiveId(memId);
                scm.setTp("21");
                publicMsgWebService.addpublicMsg(scm);
                SysMemDTO mem = this.memberWebService.queryMemByMemId(memId);
                jpushClassifies.toJpush(mem.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "同意或不同意组织申请推送", null);
                jpushClassifies2.toJpush(mem.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "同意或不同意组织申请推送", null);
            }
            sendSuccess(response, "操作成功");
        } catch (Exception e) {
            this.sendWarm(response, "操作失败");
        }
    }

    /**
     * @return
     * @说明：成员加入部门
     * @创建者： 作者：llp  创建时间：2015-3-13
     */
    @RequestMapping("joinDepart")
    public void joinDepart(HttpServletResponse response, String token, Integer unitId, Integer branchId) {
        try {
            if (!checkParam(response, token, unitId, branchId)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            int count = this.memberWebService.queryMemberByBmAndId(loginDto.getMemId());
            if (count >= 1) {
                JSONObject json = new JSONObject();
                json.put("state", false);
                json.put("msg", "您已加入了部门，不能再加入");
                this.sendJsonResponse(response, json.toString());
                return;
            } else {
                SysMember member = this.memberWebService.queryMemById(loginDto.getMemId());
                SysCorporation corporation = this.corporationService.queryCorporationById(unitId);
                if (!StrUtil.isNull(loginDto.getDatabase())) {
                    this.memberWebService.updateMemBycompanyAndBm1(corporation.getDeptNm(), corporation.getDeptId(), branchId, loginDto.getMemId(), corporation.getDatasource());
                } else {
                    member.setUnitId(corporation.getDeptId().intValue());
                    member.setMemberCompany(corporation.getDeptNm());
                    member.setBranchId(branchId);
                    this.memberService.addSysMem(member, corporation.getDatasource());
                }
                this.memberWebService.updateMemBycompanyAndBm(corporation.getDeptNm(), corporation.getDeptId(), branchId, loginDto.getMemId());
                JSONObject json = new JSONObject();
                json.put("state", true);
                json.put("msg", "成员加入部门成功");
                this.sendJsonResponse(response, json.toString());
            }
        } catch (Exception e) {
            this.sendWarm(response, "成员加入部门失败");
        }

    }

    /**
     * 组织设置常用联系人
     *
     * @param memberId 被设置常用联系人的ID
     * @param cy       1:常用0:不常用
     */
    @RequestMapping("setcy")
    public void addcy(HttpServletRequest request, HttpServletResponse response, String token, Integer memberId, Integer cy) {
        try {
            if (!checkParam(response, token, memberId))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            if (memberId.equals(loginDto.getMemId())) {//自己不能设置自己为常用
                sendWarm(response, "自己不能设置自己为常用");
                return;
            }
            if (1 == cy) {
                SysOftenuser oftenuser = new SysOftenuser();
                oftenuser.setMemberId(loginDto.getMemId());
                oftenuser.setBindMemberId(memberId);
                this.sysOftenuserService.addCyuser(loginDto.getDatabase(), oftenuser);
            } else if (0 == cy) {
                this.sysOftenuserService.deleteCyuser(loginDto.getDatabase(), loginDto.getMemId(), memberId);
            }
            this.sendSuccess(response, "设置成功");
        } catch (Exception e) {
            this.sendWarm(response, "设置失败");
        }
    }

    /**
     * @param request
     * @param response
     * @param token
     * @param memId
     * @创建：作者:YYP 创建时间：2015-4-7
     * 组织删除成员
     */
    @RequestMapping("delMem")
    public void delMem(HttpServletRequest request, HttpServletResponse response, String token, Integer memId, String dataTp) {
        if (!checkParam(response, token, memId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            String datasource = loginDto.getDatabase();
            SysMember member = memberWebService.queryAllById(loginDto.getMemId());
            SysMember mem = memberWebService.queryAllById(memId);
            if (!"1".equals(dataTp)) {
                sendWarm(response, "您没有删除功能");
                return;
            }
//			if(!"1".equals(member.getIsUnitmng()) && !"2".equals(member.getIsUnitmng())){
//				sendWarm(response, "您不是公司管理员，没有删除功能");
//				return;
//			}
//			if(!StrUtil.isNull(mem.getIsUnitmng()) && !"0".equals(mem.getIsUnitmng())){
//				if(Integer.parseInt(mem.getIsUnitmng())<=Integer.parseInt(member.getIsUnitmng())){//只能修改操作自己下级
//					sendWarm(response, "没有权限");
//					return;
//				}
//			}
            memberWebService.updateMemberCompany(memId, datasource);
            //-------------保存未读记录-------------
            SysChatMsg scm = new SysChatMsg();
            scm.setAddtime(new DateTimeUtil().getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            scm.setMemberId(loginDto.getMemId());
            scm.setMsg("您已被管理员移出 [" + member.getMemberCompany() + "] 公司");
            scm.setReceiveId(memId);
            scm.setTp("28");
			/*scm.setBelongId(belongId);//公司或部门id
			scm.setBelongNm(loginDto.getDatabase());//数据库名
			scm.setBelongMsg(company.getDeptHead());//公司头像*/
//			chatMsgService.addChatMsg(scm, datasource);
            publicMsgWebService.addpublicMsg(scm);
            TokenServer.updateDatasource("", memId);
            sendSuccess(response, "删除成功");
        } catch (Exception e) {
            this.sendWarm(response, "组织删除成员失败");
        }
    }

    /**
     * @param response
     * @param token
     * @param companyId
     * @创建：作者:YYP 创建时间：2015-5-23
     * 申请加入公司
     */
    @RequestMapping("applyInCompany")
    public void applyInCompany(HttpServletResponse response, String token, Integer companyId) {
        if (!checkParam(response, token, companyId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            //根据角色ids查询角色下的全部成员
            SysCorporation corporation = this.corporationService.queryCorporationById(companyId);
            if (StrUtil.isNull(corporation)) {
                sendWarm(response, "找不到该公司");
                return;
            }
            //指定数据源
            dataSourceContextAllocator.alloc(corporation.getDatasource(), String.valueOf(companyId));
            //查询是否已在该公司
            SysMember member = memberService.querySysMemberById1(corporation.getDatasource(), loginDto.getMemId());
            if (!StrUtil.isNull(member)) {
                sendWarm(response, "已加入公司");
                return;
            }
            //------表sys_company_join添加一条数据：用于pc端审批----------------------
            SysCompanyJoin companyJoin = new SysCompanyJoin();
            companyJoin.setMemberId(loginDto.getMemId());
            companyJoin.setMemberName(loginDto.getMemberNm());
            companyJoin.setMemberMobile(loginDto.getTel());
            companyJoin.setCreateTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));

            int id = companyJoinService.addCompanyJoin(companyJoin, corporation.getDatasource());

            List<SysMemDTO> memList = this.sysMemService.queryCompanyMemByRoleCodes(Lists.newArrayList(CompanyRoleEnum.COMPANY_CREATOR.getRole(), CompanyRoleEnum.COMPANY_ADMIN.getRole()), corporation.getDatasource());
            List<SysChatMsg> msgs = new ArrayList<>();
            StringBuffer str = new StringBuffer();
            for (SysMemDTO sysMemDTO : memList) {
                SysChatMsg scm = new SysChatMsg();
                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
//                scm.setMemberId(loginDto.getMemId());//不要：会关联员工表；但是还没加入公司
                scm.setMsg("申请加入公司");
                scm.setReceiveId(sysMemDTO.getMemberId());
                scm.setTp("26");
                scm.setBelongId(id);//sys_company_join的id,用来修改同意状态
                scm.setBelongNm(loginDto.getMemberNm());
                msgs.add(scm);
                str.append(sysMemDTO.getMemberMobile()).append(",");
            }
//            publicMsgWebService.addPublicChatMsg(msgs);
            chatMsgService.addChatMsg(msgs, corporation.getDatasource());
            String tels = str.toString();
            jpushClassifies.toJpush(tels.substring(0, tels.length() - 1), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "申请加入推送", null);
            jpushClassifies2.toJpush(tels.substring(0, tels.length() - 1), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "申请加入推送", null);
            sendSuccess(response, "申请发送成功");

        } catch (Exception e) {
            e.printStackTrace();
            log.error("申请加入公司失败", e);
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param agree    1 同意 2 不同意
     * @param deptId   0为加入公司本级
     * @param memId
     * @创建：作者:YYP 创建时间：2015-5-23
     * 同意或不同意成员申请加入公司请求(加入部门或公司)
     */
    @RequestMapping("inCompanyAgree")
    public void inCompanyAgree(HttpServletResponse response, String token, String agree, Integer memId, Integer deptId, Integer id) {
        if (!checkParam(response, token, agree, memId))
            return;
        try {
            String msg = null;
            Integer jude = null;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            String datasource = loginDto.getDatabase();
            SysCorporation corporation = this.corporationService.queryCorporationBydata(datasource);
            SysMember member = this.memberWebService.queryAllById(memId);//公共平台上用户信息
            if ("1".equals(agree)) {//同意
                member.setUnitId(corporation.getDeptId().intValue());
                member.setMemberCompany(corporation.getDeptNm());
                if (0 == deptId) {//加入公司
                    //判断是否已加入公司
                    SysMember member2 = memberService.querySysMemberById1(corporation.getDatasource(), member.getMemberId());
                    if (member2 == null) {
                        member.setBranchId(null);
                        jude = departService.addMemCompany(member, datasource, deptId, memId, null, "1");
                        msg = "接受您加入[" + corporation.getDeptNm() + "]公司的邀请,并加入公司本级下";
                    } else {
                        JSONObject json = new JSONObject();
                        json.put("state", false);
                        json.put("msg", "已加入该公司");
                        sendJsonResponse(response, json.toString());
                        return;
                    }
                } else {//加入部门
                    SysDepart dept = departService.queryDepartByid(deptId, datasource);
                    member.setBranchId(deptId);//部门
                    jude = departService.addMemCompany(member, datasource, deptId, memId, null, "2");
                    msg = "接受您加入[" + corporation.getDeptNm() + "]公司的邀请,并加入" + dept.getBranchName() + "部门";
                }

                //平台添加该企业的会员信息
                SysMemberCompany newSmc = new SysMemberCompany();
                newSmc.setCompanyId(Integer.valueOf(loginDto.getFdCompanyId()));
                newSmc.setMemberCompany(loginDto.getFdCompanyNm());

                newSmc.setMemberMobile(member.getMemberMobile());
                newSmc.setEmail(member.getEmail());
                newSmc.setMemberGraduated(member.getMemberGraduated());
                newSmc.setInTime(DateUtils.getDate());
                newSmc.setMemberId(memId);
                newSmc.setMemberNm(member.getMemberNm());
                this.memberCompanyService.addSysMemberCompany(newSmc);
            } else {//不同意
                //判断是否已加入公司
                SysMember member2 = memberService.querySysMemberById1(corporation.getDatasource(), member.getMemberId());
                if (member2 == null) {
                    msg = "拒绝您加入[" + corporation.getDeptNm() + "]公司的邀请";
                    jude = 1;
                } else {
                    JSONObject json = new JSONObject();
                    json.put("state", false);
                    json.put("msg", "已加入该公司");
                    sendJsonResponse(response, json.toString());
                    return;
                }
            }
            //回推
            if (null != jude && jude > 0) {
                SysChatMsg scm = new SysChatMsg();
                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                scm.setMemberId(loginDto.getMemId());
                scm.setMsg(msg);
                scm.setReceiveId(memId);
                scm.setTp("27");
                scm.setBelongNm(datasource);
                publicMsgWebService.addpublicMsg(scm);
                SysMemDTO mem = this.memberWebService.queryMemByMemId(memId);
                jpushClassifies.toJpush(mem.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "同意或不同意加入公司申请推送", null);
                jpushClassifies2.toJpush(mem.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "同意或不同意加入公司申请推送", null);
            }
            //修改对方的token信息
            TokenServer.updateDatasource(datasource, memId);
            //修改轨迹员工信息
            String urls = "http://api.map.baidu.com/trace/v2/entity/update";
            String parameters = "ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_name=" + memId + "&entitydatabase=" + datasource + "";
            MapGjTool.postMapGjurl(urls, parameters);

            //修改sys_company_join是否同意状态
            companyJoinService.updateStatusCompanyJoin(datasource, id, agree, loginDto.getMemId());

            JSONObject json = new JSONObject();
            json.put("datasource", datasource);
            json.put("state", true);
            json.put("msg", "操作成功");
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param deptId
     * @param deptNm
     * @创建：作者:YYP 创建时间：2015-5-23
     * 修改部门名称
     */
    @RequestMapping("updateDeptNm")
    public void updateDeptNm(HttpServletResponse response, String token, Integer deptId, String deptNm) {
        if (!checkParam(response, token, deptId, deptNm))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			OnlineUser loginDto = message.getOnlineMember();
            departService.updateDeptNm(deptId, deptNm, message.getOnlineMember().getDatabase());
            sendSuccess(response, "修改部门名称成功");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param deptId
     * @创建：作者:YYP 创建时间：2015-5-23
     * 删除部门
     */
    @RequestMapping("delDept")
    public void delDept(HttpServletResponse response, String token, Integer deptId) {
        if (!checkParam(response, token, deptId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            departService.deleteDepartId(deptId, message.getOnlineMember().getDatabase());
            sendSuccess(response, "删除部门成功");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param deptId   为空时表示查询一级部门
     * @创建：作者:YYP 创建时间：2015-5-25
     * 查询部门列表
     */
    @RequestMapping("deptList")
    public void deptList(HttpServletResponse response, String token, Integer deptId) {
        if (!checkParam(response, token))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            List<SysDepart> deptList = new ArrayList<SysDepart>();
            if (null == deptId) {
                SysDepart dePart = new SysDepart();
                dePart.setBranchId(0);
                dePart.setBranchName("公司本级");
                dePart.setIschild("2");
                deptList.add(dePart);
            }
            List<SysDepart> dList = departService.queryDeptList(deptId, message.getOnlineMember().getDatabase());
            deptList.addAll(dList);
            JSONObject json = new JSONObject();
            json.put("deptList", deptList);
            json.put("msg", "部门列表查询成功");
            json.put("state", true);
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param deptId   0 为加入公司本级
     * @param memId
     * @创建：作者:YYP 创建时间：2015-5-25
     * 移动成员
     */
    @RequestMapping("moveDept")
    public void moveDept(HttpServletResponse response, String token, Integer deptId, Integer memId) {
        if (!checkParam(response, token, deptId, memId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            departService.updateBranchId(deptId, memId, message.getOnlineMember().getDatabase());
            sendSuccess(response, "已成功加入该部门");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：获取部门以及成员信息
     * @创建：作者:llp 创建时间：2016-5-27
     * @修改历史： [序号](llp 2016 - 5 - 27)<修改说明>
     */
    @RequestMapping("queryDepartMemLs")
    public void queryDepartMemLs(HttpServletResponse response, String token) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            List<SysDepart> list = this.departService.queryDepartAllLs(loginDto.getDatabase(), loginDto.getMemId());
            for (SysDepart depart : list) {
                depart.setMemls2(this.departService.queryMemByDepart(loginDto.getDatabase(), depart.getBranchId(), loginDto.getMemId()));
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取部门以及成员信息成功");
            json.put("list", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取部门以及成员信息失败");
        }

    }

    /**
     * 查询公司员工列表
     */
    @ResponseBody
    @RequestMapping("queryCompanyMemberList")
    public Map<String, Object> queryCompanyMemberList(String token, SysMember member) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();

        if(StrUtil.isNull(member.getMemberUse())){
            member.setMemberUse("1");
        }
        List<SysMember> list = memberService.queryCompanyMemberList(member, loginInfo.getDatasource());
        Map<String, Object> map = new HashMap<>();
        map.put("state", true);
        map.put("msg", "获取员工列表成功");
        map.put("list", list);
        return map;
    }



    /**
     * 获取部门以及成员信息（增加角色判断）
     *
     * @param response
     * @param token
     * @param dataTp
     */
    @RequestMapping("queryDepartMemLsForRole")
    public void queryDepartMemLsForRole(HttpServletResponse response, String token, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)) {
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            OnlineUser loginDto = message.getOnlineMember();
            SysMember member = memberWebService.queryAllById(loginDto.getMemId());
            List<SysDepart> list = new ArrayList<SysDepart>();
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + loginDto.getMemId();
                list = this.departService.queryDepartsForzdy(loginDto.getDatabase(), mids);
                for (SysDepart depart : list) {
                    depart.setMemls2(this.departService.queryMemByzdy(loginDto.getDatabase(), depart.getBranchId(), mids));
                }
            } else {
                list = this.departService.queryDepartAllLsForRole(loginDto, dataTp, member.getBranchId());
                for (SysDepart depart : list) {
                    if ("3".equals(dataTp) && member.getBranchId().equals(depart.getBranchId())) {//查询个人部门角色数据，并且部门为当前用户部门
                        //查询可见部门
                        String visibleDepts = "," + deptmempowerService.queryPowerDepts(loginDto.getMemId(), "1", loginDto.getDatabase()) + ",";
                        if (!visibleDepts.contains("," + depart.getBranchId() + ",")) {//可见部门不包含当前部门，则只查询当前用户的信息(如果包含则查询整个部门成员信息)
                            SysMemDTO memberDTO = new SysMemDTO(member.getMemberId(), member.getMemberNm());
                            List<SysMemDTO> memList = new ArrayList<SysMemDTO>();
                            memList.add(memberDTO);
                            depart.setMemls2(memList);
                            continue;
                        }
                    }
                    List<SysMemDTO> sysMemDTOList = this.departService.queryMemByDepartForRole(loginDto.getDatabase(), depart.getBranchId());
                    depart.setMemls2(sysMemDTOList);
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取部门以及成员信息成功");
            json.put("list", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取部门以及成员信息失败");
        }

    }

}
