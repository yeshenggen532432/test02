package com.qweib.cloud.biz.system.controller;


import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.common.SessionContext;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.QiniuConfig;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.service.ws.*;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.service.member.domain.member.SysMemberInitial;
import com.qweib.cloud.utils.FileUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.pinyingTool;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import com.qweib.fs.FileService;
import com.qweib.fs.local.LocalFileService;
import jdk.nashorn.internal.ir.annotations.Reference;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
@RequestMapping("/web")
public class SysMemberWebControl extends BaseWebService {
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysMemWebService sysMemWebService;
    @Resource
    private BscTopicWebService bscTopicWebService;
    @Resource
    private SysMemBindService sysMemBindService;
    @Resource
    private SysDepartService sysDepartService;
    @Resource
    private SysCorporationWebService sysCorporationWebService;
    @Resource
    private SysMemberService memberService;

    private FileService fileService = new LocalFileService();

    /**
     * @param request
     * @param response
     * @param token
     * @param memberId(被查看人的Id)
     * @创建：作者:YYP 创建时间：2015-1-29
     * @see 获取用户信息
     */
    @RequestMapping("userinfo")
    public void userInfo(HttpServletRequest request, HttpServletResponse response, String token, Integer memberId) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            String database = null;
            Integer mid = null;
            if (!StrUtil.isNull(memberId)) {//查询bie人的个人信息
                SysCorporation sysCorporation = this.sysCorporationWebService.queryCorporationById(memberId);
                if (null != sysCorporation) {
                    database = sysCorporation.getDatasource();
                }
                mid = memberId;
            } else {//查询自己的个人信息
                if (!"".equals(onlineUser.getDatabase()) && null != onlineUser.getDatabase()) {//当前用户数据库
                    database = onlineUser.getDatabase();
                }
                mid = onlineUser.getMemId();
            }
            SysMember mem = memberWebService.queryMemAndDeptById(database, mid);
            JSONObject json = new JSONObject();
            json.put("sysMember", new JSONObject(mem));
            json.put("state", true);
            json.put("msg", "查询用户信息成功");
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    @ResponseBody
    @PostMapping("member/initial")
    public Response initialMember(SysMemberInitial input) {
        if (!MathUtils.valid(input.getId())) {
            return Response.createError("请填写会员 id");
        }
        if (StringUtils.isBlank(input.getName())) {
            return Response.createError("请填写姓名");
        }
        if (StringUtils.isBlank(input.getPassword())) {
            return Response.createError("请填写初始密码");
        }

        Boolean result = this.memberService.initialSysMember(input);
        if (result) {
            return Response.createSuccess().setMessage("更新成功");
        } else {
            return Response.createError("更新失败");
        }
    }

    /**
     * 修改用户信息
     *
     * @param response
     * @param token          令牌（必选项）
     * @param memberNm       姓名
     * @param memberName     账号
     * @param memberMobile   手机号
     * @param sex            性别
     * @param memberJob      职业
     * @param branchName     所属部门
     * @param memberHometown 所在地
     * @param memberCompany  公司
     * @param memberDesc     简介
     * @param email          邮箱
     */
    @RequestMapping("updateinfo")
    public void updateinfo(HttpServletRequest request, HttpServletResponse response, String token, String memberName, String memberNm, String memberMobile, String sex
            , String memberJob, String branchName, String memberHometown, String memberGraduated, String memberCompany, String memberDesc, String email) {
        try {
            if (!checkParam(response, token))
                return;

            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
//            SysMember sysMember = memberWebService.queryAllById(onlineUser.getMemId().intValue());
//            if (!StrUtil.isNull(memberNm)) {
//                sysMember.setMemberNm(memberNm);
//                sysMember.setFirstChar(pinyingTool.getFirstLetter(sysMember.getMemberNm()).toUpperCase());
//            }
//            if (!StrUtil.isNull(memberName)) {
//                sysMember.setMemberName(memberName);
//            }
//            if (!StrUtil.isNull(memberMobile)) {
//                sysMember.setMemberMobile(memberMobile);
//            }
//            if (!StrUtil.isNull(sex)) {
//                sysMember.setSex(sex);
//            }
//            if (!StrUtil.isNull(memberJob)) {
//                sysMember.setMemberJob(memberJob);
//            }
//            if (!StrUtil.isNull(branchName)) {
//                Integer branchId = sysMember.getBranchId();
//                if (null != branchId) {
//                    this.sysDepartService.updateBranchNameByBid(onlineUser.getDatabase(), branchName, branchId);
//                }
//            }
//            if (!StrUtil.isNull(memberHometown)) {
//                sysMember.setMemberHometown(memberHometown);
//            }
//            if (!StrUtil.isNull(memberGraduated)) {
//                sysMember.setMemberGraduated(memberGraduated);
//            }
//            if (!StrUtil.isNull(memberDesc)) {
//                sysMember.setMemberDesc(memberDesc);
//            }
//            if (!StrUtil.isNull(email)) {
//                sysMember.setEmail(email);
//            }
//            this.memberWebService.updateMember(sysMember);
//            SysMember sysmember2 = this.memberWebService.queryMemById(onlineUser.getMemId().intValue());//查询修改后的记录
//            Integer uid = sysmember2.getUnitId();
//            if (uid != null) {//判断是否有所属单位
                SysMember sysMem = sysMemWebService.queryMemBypid(onlineUser.getMemId().intValue(), onlineUser.getDatabase());
                if (sysMem != null) {
                    if (!StrUtil.isNull(memberNm)) {
                        sysMem.setMemberNm(memberNm);
                        sysMem.setFirstChar(pinyingTool.getFirstLetter(sysMem.getMemberNm()).toUpperCase());
                    }
                    if (!StrUtil.isNull(memberName)) {
                        sysMem.setMemberName(memberName);
                        //修改首字母
                        String firstChar = pinyingTool.getFirstLetter(memberName).toUpperCase();
                        sysMem.setFirstChar(firstChar);
                    }
                    if (!StrUtil.isNull(memberMobile)) {
                        sysMem.setMemberMobile(memberMobile);
                    }
                    if (!StrUtil.isNull(sex)) {
                        sysMem.setSex(sex);
                    }
                    if (!StrUtil.isNull(memberJob)) {
                        sysMem.setMemberJob(memberJob);
                    }
                    if (!StrUtil.isNull(branchName)) {
                        Integer branchId = sysMem.getBranchId();
                        if (null != branchId) {
                            this.sysDepartService.updateBranchNameByBid(onlineUser.getDatabase(), branchName, branchId);
                        }
                    }
                    if (!StrUtil.isNull(memberHometown)) {
                        sysMem.setMemberHometown(memberHometown);
                    }
                    if (!StrUtil.isNull(memberGraduated)) {
                        sysMem.setMemberGraduated(memberGraduated);
                    }
                    if (!StrUtil.isNull(memberDesc)) {
                        sysMem.setMemberDesc(memberDesc);
                    }
                    if (!StrUtil.isNull(email)) {
                        sysMem.setEmail(email);
                    }
                    this.sysMemWebService.updateMem(sysMem, onlineUser.getDatabase());
                }
//            }
            if (!StrUtil.isNull(memberNm)) {//姓名变更
                TokenServer.updateToken(token, null, memberNm, null);//修改token中的姓名
            }
            sendSuccess(response, "修改成功");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 修改用户头像
     *
     * @param token(口令)
     */
    @RequestMapping("updateHead")
    public void updatePhoto(HttpServletResponse response, HttpServletRequest request, String token) {
        try {

            if (!checkParam(response, token))
                return;

            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysMember member = this.memberWebService.queryMember(onlineUser.getMemId());
//			String database = onlineUser.getDatabase();
//			if(StrUtil.isNull(database)){
//				database = "publicplat";
//			}
            //查询原头像文件名称
            //String basePath =request.getSession().getServletContext().getRealPath("/upload/publicplat/member/");
            String path = "";
            path = QiniuConfig.getValue("FILE_UPLOAD_URL");
            if (StrUtil.isNull(path)) {
                path = request.getSession().getServletContext().getRealPath("/upload/");
            }
            String basePath = path + "/publicplat/member/";
            //String basePath2 =request.getSession().getServletContext().getRealPath("/upload/");
            String basePath2 = path;
            MultipartHttpServletRequest imgRequest;
            try {
                imgRequest = (MultipartHttpServletRequest) request;
            } catch (Exception e) {
                sendWarm(response, "文件上传方式不正确");
                return;
            }
            MultipartFile file = imgRequest.getFile("file");
            //覆盖原头像文件
            String fileName = StrUtil.upLoadFile(file, basePath, null);
            String str = member.getMemberHead();
            if (!StrUtil.isNull(str)) {
                FileUtil.deleteFile(basePath2 + "/" + str);
            }
            memberWebService.updatePhoto("publicplat/member/" + fileName, null, onlineUser.getMemId());
            if (!StrUtil.isNull(onlineUser.getDatabase())) {
                SysMember mem = this.sysMemWebService.queryMember(onlineUser.getMemId(), onlineUser.getDatabase());
                Integer memberId = mem.getMemberId();
                if (memberId != null) {
                    sysMemWebService.updatePhoto("publicplat/member/" + fileName, null, onlineUser.getMemId(), onlineUser.getDatabase());
                }
            }
            sendSuccess(response, "修改成功");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 修改用户主题背景
     *
     * @param token(口令)
     */
    @RequestMapping("updateBg")
    public void updateBg(HttpServletResponse response, HttpServletRequest request, String token) {
        try {
            if (!checkParam(response, token))
                return;

            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysMember member = this.memberWebService.queryMember(onlineUser.getMemId());
//			String database = onlineUser.getDatabase();
//			if(StrUtil.isNull(database)){
//				database = "publicplat";
//			}
            //查询原头像文件名称
            //String basePath =request.getSession().getServletContext().getRealPath("/upload/publicplat/member/");
            String path = "";
            path = QiniuConfig.getValue("FILE_UPLOAD_URL");
            if (StrUtil.isNull(path)) {
                path = request.getSession().getServletContext().getRealPath("/upload/");
            }

            String basePath = path + "/publicplat/member/";
            String basePath2 = path;
            MultipartHttpServletRequest imgRequest;
            try {
                imgRequest = (MultipartHttpServletRequest) request;
            } catch (Exception e) {
                sendWarm(response, "文件上传方式不正确");
                return;
            }
            MultipartFile file = imgRequest.getFile("file");
            //覆盖原头像文件
//			String test = UploadFile.upLoadUserBg(file, basePath, null);
            String fileName = StrUtil.upLoadFile(file, basePath, null);
//			ImageUtil.compressImsg(basePath+"/"+test,basePath+"/"+"/small_"+photoName,300,0);
//			String fileName = System.currentTimeMillis()+".jpg";
//			UploadFile.zoomImage(basePath+"/"+test, basePath+"/"+fileName, 300,180);
//			UploadFile.cutCenterImage(basePath+"/"+test, basePath+"/"+fileName, 300,180);
            String str = member.getMemberGraduated();
            if (!StrUtil.isNull(str)) {
                FileUtil.deleteFile(basePath2 + "/" + str);
            }
            memberWebService.updatePhoto(null, "publicplat/member/" + fileName, onlineUser.getMemId());
            if (!StrUtil.isNull(onlineUser.getDatabase())) {
                SysMember mem = this.sysMemWebService.queryMember(onlineUser.getMemId(), onlineUser.getDatabase());
                Integer memberId = mem.getMemberId();
                if (memberId != null) {
                    sysMemWebService.updatePhoto(null, "publicplat/member/" + fileName, onlineUser.getMemId(), onlineUser.getDatabase());
                }
            }
            sendSuccess(response, "修改成功");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 激活用户
     *
     * @param response
     * @param token
     * @param mobile   需激活的手机号码(必填)
     */
    @RequestMapping("actuser")
    public void actuser(HttpServletResponse response, String token, String mobile) {
        try {
            if (!checkParam(response, mobile))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysMember sysmember = memberWebService.queryMemById(onlineUser.getMemId().intValue());
            if (sysmember.getIsAdmin() == "1" || "1".equals(sysmember.getIsAdmin())) {
                SysMember member = memberWebService.queryMemberByMobile(mobile);
                if (member != null) {
                    member.setMemberActivate("1");//激活状态 1:激活2：未激活
                    member.setMemberUse("1");//使用状态 1:使用2：禁用
                    this.memberWebService.updateMember(member);
                    sendSuccess(response, "激活成功");
                } else {
                    sendWarm(response, "没有该用户");
                }
            } else {
                sendWarm(response, "对不起,您不是超级管理员");
            }
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param request
     * @param token
     * @param memberId
     * @创建：作者:YYP 创建时间：2015-5-13
     * @see 查询员工圈-个人主页(个人信息)
     */
    @RequestMapping("memInfo")
    public void memInfo(HttpServletResponse response, HttpServletRequest request, String token, Integer memberId) {
        if (!checkParam(response, token))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysMember sysmem = null;
            Boolean isfriend = false;
            if (memberId != null) {
                sysmem = this.memberWebService.queryAllById(memberId);
                //TODO
                int bind = this.sysMemBindService.queryIsMyFriends(onlineUser.getMemId(), memberId, 1);
                if (bind != 0) {
                    isfriend = true;
                }
            } else {
                sysmem = this.memberWebService.queryAllById(onlineUser.getMemId());
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询成功");
            json.put("memberId", sysmem.getMemberId());
            json.put("memberNm", sysmem.getMemberNm());
            json.put("memberMobile", sysmem.getMemberMobile());
            json.put("memberDesc", sysmem.getMemberDesc());
            json.put("memberHead", sysmem.getMemberHead());
            json.put("memberGraduated", sysmem.getMemberGraduated());
            json.put("isfriend", isfriend);
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 查询员工圈-个人主页(主题列表)
     *
     * @param token(口令,必填)
     * @param memberId(被查看人Id)
     */
    @RequestMapping("tophomepage")
    public void tophomepage(HttpServletResponse response, HttpServletRequest request, String token, Integer memberId, Integer pageNo, Integer pageSize) {
        if (!checkParam(response, token))
            return;
        if (StrUtil.isNull(pageNo)) {
            pageNo = 1;
        }
        if (StrUtil.isNull(pageSize)) {
            pageSize = 10;
        }

        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            Page page = null;
            if (memberId != null) {//查看别人
                page = this.bscTopicWebService.page(memberId, pageNo, pageSize);
            } else {//查看自己
                page = this.bscTopicWebService.page(onlineUser.getMemId(), pageNo, pageSize);
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询成功");
            json.put("total", page.getTotalPage());
            json.put("rows", page.getRows());
            sendJsonResponse(response, json.toString());
        } catch (JSONException e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param topicId
     * @param memId    查看的
     * @创建：作者:YYP 创建时间：2015-4-24
     * @see 查询主题明细
     */
    @RequestMapping("topicDetail")
    public void topicDetail(HttpServletResponse response, String token, Integer topicId, Integer memId) {
        if (!checkParam(response, token, memId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysMemDTO sysmember = memberWebService.queryMemByMemId(memId);
            String datasource = sysmember.getDatasource();
            if (null == datasource || "".equals(datasource)) {
                sendWarm(response, "该主题没有对应公司");
                return;
            }
            BscTopic t = bscTopicWebService.queryTopicById(topicId, datasource);
            if (null == t) {
                sendWarm(response, "该主题已删除");
                return;
            }
            BscTopicFactoryDTO topic = bscTopicWebService.queryTopicDetail(topicId, onlineUser.getMemId(), datasource);
            JSONObject json = new JSONObject(topic);
            json.put("state", true);
            json.put("msg", "查询成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 根据用户查询名单
     */
    @RequestMapping("queryMemBind")
    public void queryMemBind(HttpServletResponse response, String token, Integer pageNo, Integer pageSize) {
        if (!checkParam(response, token, pageNo))
            return;
        if (StrUtil.isNull(pageSize)) {
            pageSize = 10;
        }
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser user = message.getOnlineMember();
            Page page = this.memberWebService.queryBlacklistByMid(user.getMemId(), pageNo, pageSize);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", page.getTotal());
            json.put("totalPage", page.getTotalPage());
            json.put("rows", page.getRows());
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 根据黑名单用户ID移除黑名单
     */
    @RequestMapping("delMemBind")
    public void delMemBind(HttpServletResponse response, String token, Integer bindId) {
        if (!checkParam(response, token, bindId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser user = message.getOnlineMember();
            this.memberWebService.deleteBlacklist(user.getMemId(), bindId);
            this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"移除成功\"}");
        } catch (Exception e) {
            this.sendWarm(response, "移除失败");
        }
    }

    /**
     * 消息免打扰
     * token 口令(必填)
     * state 免打扰状态 1:是 2: 否(必填)
     */
    @RequestMapping("newsNotBother")
    public void newsNotBother(HttpServletRequest request, HttpServletResponse response, String token, String state) {
        if (!checkParam(response, token, state))
            return;

        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser user = message.getOnlineMember();
            SysMember member = this.memberWebService.queryAllById(user.getMemId());
            member.setState(state);
            int i = this.memberWebService.updateMember(member);
            if (!"".equals(user.getDatabase()) && null != user.getDatabase()) {
                SysMember mem = this.sysMemWebService.queryMemBypid(user.getMemId(), user.getDatabase());
                if (!StrUtil.isNull(mem)) {
                    mem.setState(state);
                    int b = this.sysMemWebService.updateMem(mem, user.getDatabase());
                    if (b != 1) {
                        sendWarm(response, "设置失败");
                    }
                }
            }
            if (i == 1) {
                sendSuccess(response, "设置成功");
            } else {
                sendWarm(response, "设置失败");
            }
        } catch (Exception e) {
            this.sendWarm(response, "操作失败");
        }
    }

    /**
     * @param request
     * @param response
     * @param token
     * @param msgmodel 1 默认乱序 2 模块化
     * @创建：作者:YYP 创建时间：Sep 18, 2015
     */
    @RequestMapping("updateMsgmodel")
    public void updateMsgmodel(HttpServletRequest request, HttpServletResponse response, String token, String msgmodel) {
        if (!checkParam(response, token, msgmodel))
            return;
        String datasource = null;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser user = message.getOnlineMember();
            SysMember member = this.memberWebService.queryAllById(user.getMemId());
            member.setMsgmodel(msgmodel);
            if (null != user.getDatabase() && !"".equals(user.getDatabase())) {
                datasource = user.getDatabase();
            }
            this.memberWebService.updateMemberAndMem(member, datasource);
            sendSuccess(response, "设置消息模板成功");
        } catch (Exception e) {
            this.sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @创建：作者:YYP 创建时间：2015-4-21
     * @see 查询屏蔽状态
     */
    @RequestMapping("botherState")
    public void botherState(HttpServletResponse response, String token) {
        if (!checkParam(response, token))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser user = message.getOnlineMember();
            SysMember member = this.memberWebService.queryAllById(user.getMemId());
            this.sendJsonResponse(response, "{\"botherState\":\"" + member.getState() + "\",\"state\":true,\"msg\":\"查询屏蔽状态成功\"}");
        } catch (Exception e) {
            this.sendException(response, e);
        }
    }

    /**
     * 修改手机号
     *
     * @param response
     * @param token     令牌（必填项,登陆后获取）
     * @param newMobile 新手机号(必选项,MD5加密后的字符串)
     * @param code      验证码(必选项,通过手机方式验证)
     */
    @RequestMapping("changeMobile")
    public void changepwd(HttpServletResponse response, String token, String newMobile, String code, String sessionId) {
        try {
            if (!checkParam(response, newMobile, code))
                return;

            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            int info = memberService.querySysMemberByTel(newMobile);
            if (info > 0) {
                sendWarm(response, "手机号已被注册");
                return;
            }
            //验证短信验证码
            if (StrUtil.isNull(sessionId)) {//默认验证码
                if (!CnlifeConstants.SMSTR.equals(code)) {
                    sendWarm(response, "验证码错误");
                    return;
                }
            } else {
                SessionContext sessionContext = SessionContext.getInstance();
                HttpSession session = sessionContext.getSession(sessionId);
                if (null == session) {
                    sendWarm(response, "sessionId不正确");
                    return;
                }
                if (!newMobile.equals(session.getAttribute("mobile"))) {
                    sendWarm(response, "手机号码与获取验证码时不一致");
                }
                Date sendTime = (Date) session.getAttribute("sendTime");
                long time = new Date().getTime() - sendTime.getTime();
                long minutes = time / 60000;
                if (minutes > CnlifeConstants.CODE_OVERTIME) {
                    sendWarm(response, "验证码超时");
                    return;
                } else if (!code.equalsIgnoreCase(session.getAttribute("code").toString())) {
                    sendWarm(response, "验证码错误");
                    return;
                }
            }
            //验证短信验证码结束，修改密码开始/////
			/*if(!TokenServer.checkCode(code,onlineUser.getTel())){
				sendWarm(response, "验证码错误");
				return;
			}*/
            SysMember sysmember = memberWebService.queryAllById(onlineUser.getMemId().intValue());
            sysmember.setMemberMobile(newMobile);
            int i = memberWebService.updateMember(sysmember);
            if (!StrUtil.isNull(onlineUser.getDatabase())) {
                SysMember sysmem = sysMemWebService.queryMemBypid(sysmember.getMemberId(), onlineUser.getDatabase());
                if (sysmem != null) {
                    sysmem.setMemberMobile(newMobile);
                    int b = sysMemWebService.updateMem(sysmem, onlineUser.getDatabase());
                    if (b != 1) {
                        sendWarm(response, "修改失败!");
                    }
                }
            }
            if (i == 1) {
                TokenServer.updateToken(token, null, null, newMobile);//修改token中的手机号码
                sendSuccess(response, "修改成功!");
//				onlineUser.setCode(null);
            } else {
                sendWarm(response, "修改失败!");
            }
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 邀请人详细资料
     *
     * @param token    口令
     * @param memberId 会员id
     */
    @RequestMapping("inviterDetails")
    public void inviterDetails(HttpServletRequest request, HttpServletResponse response, String token, Integer memberId) {
        try {
            if (!checkParam(response, token, memberId))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            SysMember member = this.memberWebService.queryAllById(memberId);
            if (StrUtil.isNull(member)) {
                sendWarm(response, "找不到相应的资料");
                return;
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询成功");
            json.put("meberId", member.getMemberId());
            json.put("memberHead", member.getMemberHead());
            json.put("memberNm", member.getMemberNm());
            json.put("sex", member.getSex());
            json.put("memberCompany", member.getMemberCompany());
            json.put("memberDesc", member.getMemberDesc());
            sendJsonResponse(response, json.toString());
        } catch (JSONException e) {
            sendException(response, e);
        }
    }

}
