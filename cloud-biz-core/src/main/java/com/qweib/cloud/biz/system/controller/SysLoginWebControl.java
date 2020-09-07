package com.qweib.cloud.biz.system.controller;


import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.*;
import com.qweib.cloud.biz.system.*;
import com.qweib.cloud.biz.system.auth.JwtPayload;
import com.qweib.cloud.biz.system.auth.JwtUtils;
import com.qweib.cloud.biz.system.controller.plat.vo.SmsMessage;
import com.qweib.cloud.biz.system.controller.vo.MobileLoginRequest;
import com.qweib.cloud.biz.system.controller.vo.MobileLoginResponse;
import com.qweib.cloud.biz.system.service.member.MemberLoginService;
import com.qweib.cloud.biz.system.service.member.MemberLoginUtils;
import com.qweib.cloud.biz.system.service.plat.*;
import com.qweib.cloud.biz.system.service.ws.SysCorporationWebService;
import com.qweib.cloud.biz.system.service.ws.SysMemWebService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.biz.system.utils.MemberUtils;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.dto.MemberLoginShowDTO;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.common.DeviceEnum;
import com.qweib.cloud.service.member.common.LoginTypeEnum;
import com.qweib.cloud.service.member.domain.corporation.CorporationStandaloneDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyQuery;
import com.qweib.cloud.service.member.domain.member.login.MemberLoginQuery;
import com.qweib.cloud.service.member.domain.member.login.MemberLoginSave;
import com.qweib.cloud.service.member.retrofit.corporation.CorporationStandaloneRetrofitApi;
import com.qweib.cloud.utils.*;
import com.qweib.commons.DateUtils;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.mapper.JsonMapper;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import com.qweibframework.commons.IpUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Pageable;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.*;
import java.util.concurrent.TimeUnit;

import static com.qweib.cloud.biz.system.support.DevicePresenceHelper.DEVICE_MOBILE;

@Controller
@RequestMapping("/web")
public class SysLoginWebControl extends BaseWebService {
    public static Logger logger = LoggerFactory.getLogger(SysLoginWebControl.class);
    private static final String MEMBER_CERTIFY_CODE = "web_member_certify_code:";
    @Resource
    private SysMemberWebService memberWebService;
    @Autowired
    private SysLoginService loginService;
    @Resource
    private SysMemWebService sysMemWebService;
    @Resource
    private SysCorporationWebService corporationWebService;
    @Resource
    private SysCorporationService corporationService;
    @Resource
    private SysMemberService memberService;
    @Resource
    private SysCompanyRoleService companyRoleService;
    @Resource
    private SysMemberCompanyService memberCompanyService;
    @Qualifier("stringRedisTemplate")
    @Autowired
    private RedisTemplate redisTemplate;
    @Autowired
    private DataSourceContextAllocator dataSourceAllocator;
    @Autowired
    private MemberLoginService memberLoginService;
    //@Autowired
    //private CorporationStandaloneRetrofitApi companyExtApi;

    @RequestMapping("/login")
    @ResponseBody
    public Response webLogin(HttpServletRequest httpServletRequest, @Valid MobileLoginRequest request) {
        String mobile = request.getMobile();
        String unId = request.getUnId();//设备识别码
        String memberUnId = null;//员工表存的设备识别码
        String tpNm = "快消";//公司类型
        Integer cid = 0, memId = null, companyId = null, rzState = 1;
        String datasource = null, memberNm = null, memberHead = null, companyName = null, companys = "", roles = null;
        List<Integer> roleIds = new ArrayList<>();

        //根据手机号-查询总平台会员
        SysMember sysMember = memberWebService.queryMemberByMobile(mobile);
        if (StrUtil.isNull(sysMember)) {
            throw new BizException("用户名不存在");
        } else if (!"1".equals(sysMember.getMemberUse())) {
            throw new BizException("该用户禁用");
        } else {
            String realPwd = sysMember.getMemberPwd();
            if (!Objects.equals(realPwd, request.getPwd())) {
                throw new BizException("密码不正确，请重新输入");
            }
        }

        //平台赋值
        rzState = sysMember.getRzState();
        memId = sysMember.getMemberId();
        memberNm = sysMember.getMemberNm();
        memberHead = sysMember.getMemberHead();
        datasource = sysMember.getDatasource();
        if (StrUtil.isNotNull(sysMember.getUnitId())) {
            companyId = sysMember.getUnitId();
        }


        //===========加载该会员有几家公司Start(TODO 获取 companyId,companyName,tpNm)================
        try {
            SysMemberCompany query = new SysMemberCompany();
            //query.setMemberMobile(request.getMobile());
            query.setMemberId(memId);
            query.setDimission(false);
            List<SysMemberCompany> smcList = this.memberCompanyService.querySysMemberCompanyList(query);
            //默认登录的公司可能被禁用或者删除了该用户(取第一条数据)
            List<Map<String, Object>> companyList = Lists.newArrayList();
            boolean selectFind = MemberUtils.transferMemberCompanies1(companyList, smcList, String.valueOf(companyId));//smcList--转companyList
            if (Collections3.isNotEmpty(companyList)) {
                companys = JsonMapper.getInstance().toJson(companyList);
            }
            if (!selectFind) {
                companyId = null;
                datasource = null;
                if (Collections3.isNotEmpty(companyList)) {
                    Map<String, Object> map = companyList.get(0);
                    Integer reCompanyId = StringUtils.toInteger(map.get("companyId"));
                    SysCorporation companyDTO = this.corporationService.queryCorporationById(reCompanyId);
                    if (companyDTO != null) {
                        companyId = reCompanyId;
                        datasource = companyDTO.getDatasource();
                    }
                }
            }
        } catch (Exception e) {
        }
        //===========加载该会员有几家公司 end================


        //对应公司表（平台）(TODO 获取 companyId,companyName,tpNm)
        try {
            if (StrUtil.isNotNull(datasource)) {
                SysCorporation corporation = this.corporationService.queryCorporationBydata(datasource);
                if (corporation != null) {
                    companyId = corporation.getDeptId().intValue();
                    companyName = corporation.getDeptNm();
                    tpNm = corporation.getTpNm();

                    //TODO check current domain 单机版要求跳转
//                    CorporationStandaloneDTO standaloneDTO = HttpResponseUtils.convertResponseNull(companyExtApi.get(corporation.getDeptId().intValue()));
//                    if (standaloneDTO != null) {
//                        String customDomain = standaloneDTO.getCustomDomain();
//                        if (StringUtils.isNotBlank(customDomain)) {
//                            return MobileLoginResponse.builder()
//                                    .jwt(JwtUtils.gen(JwtPayload.builder()
//                                            .userId(sysMember.getMemberId())
//                                            .companyId(corporation.getDeptId().intValue())
//                                            .mobile(request.getMobile())
//                                            .build(), standaloneDTO.getAppSecret()))
//                                    .domain(customDomain)
//                                    .build().state(true).msg("登录成功，正在跳转");
//                        }
//                    }
                }
            }
        } catch (Exception e) {
        }


        //查询对应员工表（企业）TODO 获取memberNm，memberHead，memberUnId
        try {
            if (StrUtil.isNotNull(datasource)) {
                this.dataSourceAllocator.alloc(datasource, String.valueOf(companyId));
                SysMember companyMember = this.loginService.querySysMemberById1(datasource, memId);
                if (companyMember != null) {
                    memberNm = companyMember.getMemberNm();
                    memberHead = companyMember.getMemberHead();
                    memberUnId = companyMember.getUnId();
                }
            }
        } finally {
            this.dataSourceAllocator.release();
        }

        //设备绑定开始-start
        try {
            if (!StrUtil.isNull(unId) && !StrUtil.isNull(memberUnId) && companyId != 0) {
                this.dataSourceAllocator.alloc(datasource, String.valueOf(companyId));
                SysMember sysMem = sysMemWebService.queryMemByMobile(mobile, datasource);
                SysMember sysMem2 = sysMemWebService.queryMemByUnid(unId, datasource);
                if (!StrUtil.isNull(sysMem2)) {
                    if (!StringUtils.equals(request.getMobile(), sysMem2.getMemberMobile())) {
                        throw new BizException("此设备已绑定" + sysMem2.getMemberMobile() + "账号，不能使用其他账号");
                    }
                }
                if (!StrUtil.isNull(sysMem.getUnId())) {
                    if (!sysMem.getUnId().equals("1")) {
                        if (!Objects.equals(unId, sysMem.getUnId())) {
                            throw new BizException("此账号已绑定其他设备，不能在此设备登录");
                        }
                    } else {
                        memberWebService.updateunId(datasource, unId, memId);
                    }
                }
            }
        } finally {
            this.dataSourceAllocator.release();
        }
        //设备绑定开始-end


        //角色start TODO 获取roleIds，roles
        try {
            if (StrUtil.isNotNull(datasource)) {
                this.dataSourceAllocator.alloc(datasource, String.valueOf(companyId));
                List<Integer> roleList = this.loginService.queryRoleIdByUsr(sysMember.getMemberId(), datasource);
                if (Collections3.isNotEmpty(roleList)) {
                    roleIds.addAll(roleList);
                }
                roles = companyRoleService.checkHasAdminRole(memId, datasource);
                TokenServer.checkLoginState(memId);//是否重复登录操作
            }
        } finally {
            this.dataSourceAllocator.release();
        }
        //角色--end

        //设置token
        OnlineUser onlineUser = new OnlineUser(memId, memberNm, mobile, datasource, tpNm, cid);
        if (StrUtil.isNotNull(String.valueOf(companyId))) {
            onlineUser.setFdCompanyId(String.valueOf(companyId));
            onlineUser.setFdCompanyNm(companyName);
        }
        String token = StrUtil.string2MD5(mobile + memberNm + new Date());
        onlineUser.setToken(token);


        //设置返回数据
        MobileLoginResponse.MobileLoginResponseBuilder builder = MobileLoginResponse.builder()
                .memId(memId)
                .memberNm(memberNm)
                .memberHead(memberHead)
                .memberMobile(mobile)
                .isUnitMng(roles)
                .datasource(datasource)
                .tpNm(tpNm)
                .cid(cid)
                .companyId(companyId)
                .rzState(rzState)
                .token(token);
        if (StrUtil.isNotNull(companys)) {
            builder.companyListStr(companys);
        }
        if (MathUtils.valid(companyId)) {
            DeviceEnum deviceType = DeviceEnum.MOBILE;
            if (MathUtils.valid(request.getDevice())) {
                deviceType = DeviceEnum.getByDevice(request.getDevice());
            }
            MemberLoginSave memberLoginInput = MemberLoginUtils.makeLoginDTO(memId, companyId, LoginTypeEnum.LOGIN, deviceType, IpUtils.getIpAddr(httpServletRequest));
            this.memberLoginService.pushMemberLogin(memberLoginInput);
        }
        TokenServer.tokenCreated(onlineUser, DEVICE_MOBILE);
        return builder.build().state(true).msg("登录成功");
    }

    @ResponseBody
    @PostMapping("member/certify/code")
    public Response<String> getCertifyCode(@RequestParam String token) {
        OnlineMessage onlineMessage = TokenServer.tokenCheck(token);
        if (onlineMessage.isSuccess() == false) {
            return Response.createError("token失效");
        }

        OnlineUser onlineUser = onlineMessage.getOnlineMember();

        final String code = StringUtils.randomNumber(6);
        final String text = "【驰用T3】您的验证码是" + code;
        try {
            String result = JavaSmsApi.sendSms(text, onlineUser.getTel());
            SmsMessage message = JsonMapper.getInstance().fromJson(result, SmsMessage.class);
            if (message.isSuccess()) {
                this.redisTemplate.opsForValue().set(MEMBER_CERTIFY_CODE + onlineUser.getTel(), code, 300, TimeUnit.SECONDS);
                return Response.createSuccess().setMessage("获取验证码成功");
            } else {
                return Response.createError("获取验证码失败");
            }
        } catch (Exception e) {
            log.error("获取验证码失败", e);
            e.printStackTrace();
            return Response.createError("获取验证码失败");
        }
    }


    @PostMapping("member/certify")
    public void memberCertify(HttpServletResponse response, @RequestParam String code, @RequestParam String token) {
        OnlineMessage onlineMessage = TokenServer.tokenCheck(token);
        if (onlineMessage.isSuccess() == false) {
            sendJsonResponse(response, "token失效");
        }

        OnlineUser onlineUser = onlineMessage.getOnlineMember();

        String validateCode = (String) this.redisTemplate.opsForValue().get(MEMBER_CERTIFY_CODE + onlineUser.getTel());
        if (StringUtils.isBlank(validateCode)) {
            sendJsonResponse(response, "请先获取验证码");
        }

        if (!Objects.equals(validateCode, code)) {
            sendJsonResponse(response, "验证码输入有误");
        }
        boolean b = this.memberService.updateMemberCertify(onlineUser.getMemId());
        if (b) {
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "认证成功");
            sendJsonResponse(response, json.toString());
        } else {
            sendJsonResponse(response, "认证失败");
        }
    }

    @RequestMapping("/changeCompany")
    public void changeCompany(@RequestParam Integer companyId,
                              String token, Integer device,
                              HttpServletRequest request, HttpServletResponse response) {

        if (!checkParam(response, token)) {
            return;
        }
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            sendWarm(response, message.getMessage());
            return;
        }
        OnlineUser loginDto = message.getOnlineMember();
        try {
            SysCorporation company = this.corporationService.queryCorporationById(companyId);
//            CorporationStandaloneDTO standalone = HttpResponseUtils.convertResponseNull(companyExtApi.get(companyId));
//            if (standalone != null && StringUtils.isNotBlank(standalone.getCustomDomain())) {
//                MobileLoginResponse resp = MobileLoginResponse.builder()
//                        .jwt(JwtUtils.gen(JwtPayload.builder()
//                                .userId(loginDto.getMemId())
//                                .companyId(companyId)
//                                .mobile(loginDto.getTel())
//                                .build(), standalone.getAppSecret()))
//                        .domain(standalone.getCustomDomain())
//                        .build().state(true).msg("登录成功，正在跳转");
//                sendJsonResponse(response, JsonMapper.toJsonString(resp));
//                return;
//            }
            // 当前公司数据库
            final String database = company.getDatasource();
            this.dataSourceAllocator.alloc(database, company.getDeptId().toString());
            //info.set
            //获取当前用户在这家公司的信息
            SysMember companyMember;
            try {
                companyMember = this.memberService.queryCompanySysMemberById(database, loginDto.getMemId());
            } catch (Exception ex) {
                JSONObject json = new JSONObject();
                json.put("state", false);
                json.put("msg", "切换失败,获取人员信息出错！");
                sendJsonResponse(response, json.toString());
                return;
            }

            //获取当前用户的平台信息；
            SysMember platMember = this.memberService.querySysMemberById(loginDto.getMemId());
            MemberUtils.copyMemberProperties(platMember, companyMember, companyId, company.getDeptNm(), database);
            //更新默认登录的企业
            this.memberService.updatePlatSysMember(platMember);
            loginDto.setMemberNm(companyMember.getMemberNm());
            loginDto.setDatabase(database);
            loginDto.setFdCompanyId(companyId.toString());
            loginDto.setFdCompanyNm(company.getDeptNm());
            loginDto.setCid(companyMember.getCid());
            //查询成员角色（多个，隔开），以最小的id作为值
            String roles = companyRoleService.checkHasAdminRole(loginDto.getMemId(), loginDto.getDatabase());

            JSONObject json = new JSONObject();
            json.put("memId", loginDto.getMemId());
            json.put("memberNm", loginDto.getMemberNm());
            json.put("memberHead", platMember.getMemberHead());
            json.put("memberMobile", loginDto.getTel());
            json.put("isUnitmng", roles);
            json.put("datasource", database);
            json.put("msgmodel", platMember.getMsgmodel());
            json.put("tpNm", loginDto.getTpNm());
            //json.put("cid",loginDto.getCid());
            json.put("companyId", platMember.getUnitId());
            json.put("token", token);
            if (!StrUtil.isNull(loginDto.getCompanys())) {
                json.put("companys", loginDto.getCompanys());
            }
            json.put("state", true);
            json.put("msg", "切换成功");
            TokenServer.tokenDestroyed(loginDto);
            TokenServer.tokenCreated(loginDto, DEVICE_MOBILE);
            Cookie cookie = new Cookie("QWEIB_TOKEN", token);
            cookie.setPath("/");
            response.addCookie(cookie);
            sendJsonResponse(response, json.toString());
            if (MathUtils.valid(platMember.getUnitId())) {
                DeviceEnum deviceType = DeviceEnum.MOBILE;
                if (MathUtils.valid(device)) {
                    deviceType = DeviceEnum.getByDevice(device);
                }
                MemberLoginSave memberLoginInput = MemberLoginUtils.makeLoginDTO(loginDto.getMemId(), platMember.getUnitId(), LoginTypeEnum.SWITCH, deviceType, IpUtils.getIpAddr(request));
                this.memberLoginService.pushMemberLogin(memberLoginInput);
            }
        } catch (Exception e) {
            log.error("登录出错：", e);
            sendException(response, e);
        } finally {
            this.dataSourceAllocator.release();
        }
    }


    /**
     * 注册  默认6012888
     */
    @RequestMapping("/reg")
    public void webReg(HttpServletRequest request, HttpServletResponse response, String mobile, String memberNm, String sendCode, String sessionId, String pwd, String deptNm, String tpNm) {
        if (!checkParam(response, mobile, memberNm, sendCode, pwd, deptNm)) {
            return;
        }
        try {
            String endDate = DateTimeUtil.dateTimeAddToStr(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"), 2, 1, "yyyy-MM-dd");
            SysMember sysMember = memberWebService.queryMemberByMobile(mobile);
            if (null != sysMember) {
                sendWarm(response, "手机号已被注册");
                return;
            }
            //验证短信验证码
            if (StrUtil.isNull(sessionId)) {//默认验证码
                if (!CnlifeConstants.SMSTR.equals(sendCode)) {
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
                if (!mobile.equals(session.getAttribute("mobile"))) {
                    sendWarm(response, "手机号码与注册验证码不一致");
                }
                Date sendTime = (Date) session.getAttribute("sendTime");
                long time = new Date().getTime() - sendTime.getTime();
                long minutes = time / 60000;
                if (minutes > CnlifeConstants.CODE_OVERTIME) {
                    sendWarm(response, "验证码超时");
                    return;
                } else if (!sendCode.equalsIgnoreCase(session.getAttribute("code").toString())) {
                    sendWarm(response, "验证码错误");
                    return;
                }
            }
            //验证短信验证码结束，注册开始/////
            //String pwd = "e10adc3949ba59abbe56e057f20f883e";//默认密码123456
            SysMember sys = new SysMember();
            sys.setMemberMobile(mobile);
            sys.setMemberNm(memberNm);
            sys.setFirstChar(pinyingTool.getFirstLetter(memberNm).toUpperCase());
            sys.setMemberPwd(pwd);
            sys.setMemberCreatime(DateUtils.getDateTime());
            sys.setMemberActivate("1");//激活状态 1：激活 2：未激活
            sys.setMemberUse("1");//使用状态 1:启用2：禁用
            logger.info("保存用户");
            int i = memberWebService.addMember(sys, "reg");
            logger.info("保存用户完成");
            String spellNm = pinyingTool.getAllFirstLetter(deptNm);
            Integer info = 0;
            if (i > 0) {
                OnlineUser onlineUser = new OnlineUser(i, mobile, mobile, sys.getDatasource(), tpNm, null);
                String token = StrUtil.string2MD5(onlineUser.getTel() + onlineUser.getMemberNm() + new Date());
                onlineUser.setToken(token);
                logger.info("创建登录用户用户");
                TokenServer.tokenCreated(onlineUser, DEVICE_MOBILE);
                Cookie cookie = new Cookie("QWEIB_TOKEN", token);
                cookie.setPath("/");
                response.addCookie(cookie);
                logger.info("创建登录用户用户完成");
                //创建轨迹员工
                logger.info("创建轨迹员工");
                String urls = "http://api.map.baidu.com/trace/v2/entity/add";
                String parameters = "ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_name=" + i + "";
                MapGjTool.postMapGjurl(urls, parameters);
                logger.info("创建轨迹员工完成");
                //创建公司
                logger.info("创建公司");
                SysCorporation company = new SysCorporation();
                logger.info("判断公司是否存在");
                Integer exit = corporationService.queryIsExit(deptNm);
                if (0 == exit) {
                    if (!spellNm.matches("^[a-zA-Z]*")) {
                        spellNm = "sjk" + System.currentTimeMillis();
                    }
                    String path = request.getSession().getServletContext().getRealPath("/exefile") + "/cnlifebase.sql";
                    company.setDeptNm(deptNm);
                    company.setAddTime(DateUtils.getDateTime());
                    company.setMemberId(i);
                    company.setEndDate(endDate);
                    company.setTpNm(tpNm);
                    logger.info("开始保存公司");
                    info = corporationService.addCompany(company, spellNm, company.getDeptNm(), i, "1", path);//添加公司
                    //=====================增加所属公司============================//
                    SysMemberCompany newSmc = new SysMemberCompany();
                    newSmc.setCompanyId(info);
                    newSmc.setMemberMobile(sys.getMemberMobile());
                    newSmc.setMemberCompany(company.getDeptNm());
                    newSmc.setInTime(DateUtils.getDate());
                    newSmc.setMemberId(i);
                    newSmc.setMemberNm(sys.getMemberNm());
                    this.memberCompanyService.addSysMemberCompany(newSmc);
                    //=====================增加所属公司============================//
                    if (info > 0) {
                        //创建轨迹员工2
                        final String gpsUrl = QiniuControl.GPS_SERVICE_URL + "/User/postLocation";
                        GpsUtils.createGpsMember(gpsUrl, info, i);
                        spellNm = spellNm + info;
                        TokenServer.updateToken(token, spellNm, null, null);//修改token中的database值
                    }
                } else {
                    sendWarm(response, "该公司已存在，不能重复创建");
                }
                this.sendJsonResponse(response, "{\"state\":true,\"token\":\"" + token + "\",\"memberId\":" + i + ",\"companyId\":" + info + ",\"datasource\":\"" + spellNm + "\",\"tpNm\":\"" + tpNm + "\",\"msg\":\"恭喜您，注册成功!\"}");
            } else {
                sendWarm(response, "失败了!请尝试重新注册");
            }
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 注册个人账号
     */
    @RequestMapping("/regnew")
    public void webRegNew(HttpServletRequest request, HttpServletResponse response, String mobile, String memberNm, String sendCode, String sessionId, String pwd) {
        if (!checkParam(response, mobile, memberNm, sendCode, pwd)) return;
        try {
            SysMember sysMember = memberWebService.queryMemberByMobile(mobile);
            if (null != sysMember) {
                sendWarm(response, "手机号已被注册");
                return;
            }
            //验证短信验证码
            if (StrUtil.isNull(sessionId)) {//默认验证码
                if (!CnlifeConstants.SMSTR.equals(sendCode)) {
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
                if (!mobile.equals(session.getAttribute("mobile"))) {
                    sendWarm(response, "手机号码与注册验证码不一致");
                }
                Date sendTime = (Date) session.getAttribute("sendTime");
                long time = new Date().getTime() - sendTime.getTime();
                long minutes = time / 60000;
                if (minutes > CnlifeConstants.CODE_OVERTIME) {
                    sendWarm(response, "验证码超时");
                    return;
                } else if (!sendCode.equalsIgnoreCase(session.getAttribute("code").toString())) {
                    sendWarm(response, "验证码错误");
                    return;
                }
            }
            //验证短信验证码结束，注册开始/////
            //String pwd = "e10adc3949ba59abbe56e057f20f883e";//默认密码123456
            SysMember sys = new SysMember();
            sys.setMemberMobile(mobile);
            sys.setMemberNm(memberNm);
            sys.setFirstChar(pinyingTool.getFirstLetter(memberNm).toUpperCase());
            sys.setMemberPwd(pwd);
            sys.setMemberCreatime(DateUtils.getDateTime());
            sys.setMemberActivate("1");//激活状态 1：激活 2：未激活
            sys.setMemberUse("1");//使用状态 1:启用2：禁用
            sys.setRzState(1);
            logger.info("保存用户");
            int i = memberWebService.addMember(sys, "regnew");
            logger.info("保存用户完成");
            if (i > 0) {
                OnlineUser onlineUser = new OnlineUser(i, mobile, mobile, sys.getDatasource(), null, null);
                String token = StrUtil.string2MD5(onlineUser.getTel() + onlineUser.getMemberNm() + new Date());
                onlineUser.setToken(token);
                logger.info("创建登录用户用户");
                TokenServer.tokenCreated(onlineUser, DEVICE_MOBILE);
                Cookie cookie = new Cookie("QWEIB_TOKEN", token);
                cookie.setPath("/");
                response.addCookie(cookie);
                logger.info("创建登录用户用户完成");
                //创建轨迹员工
                logger.info("创建轨迹员工");
                String urls = "http://api.map.baidu.com/trace/v2/entity/add";
                String parameters = "ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_name=" + i + "";
                MapGjTool.postMapGjurl(urls, parameters);
                logger.info("创建轨迹员工完成");
                this.sendJsonResponse(response, "{\"state\":true,\"token\":\"" + token + "\",\"memberId\":" + i + ",\"msg\":\"恭喜您，注册成功!\"}");
            } else {
                sendWarm(response, "失败了!请尝试重新注册");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendException(response, e);
        }
    }

    /**
     * @创建：作者:YYP 创建时间：2015-5-13
     */
    @RequestMapping("likeCompanys")
    public void likeCompanys(HttpServletResponse response, String content) {
        try {
            List<SysCorporation> companys = corporationWebService.queryCorporationByLikeNm(content);
            JSONObject json = new JSONObject();
            json.put("companys", companys);
            json.put("msg", "查询公司成功");
            json.put("state", true);
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 退出登录
     *
     * @param token 命令（必填项,登陆后获取）
     */
    @RequestMapping("quit")
    public void quit(HttpServletResponse response, String token) {
        try {
            if (!checkLoginState(response, token)) {
                sendSuccess(response, "注销完成");
                return;
            }
            if (!checkParam(response, token)) {
                return;
            }

            OnlineMessage message = TokenServer.tokenCheck(token);
            OnlineUser onlineUser = message.getOnlineMember();
            TokenServer.tokenDestroyed(onlineUser);
            sendSuccess(response, "注销完成");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 修改密码
     */
    @RequestMapping("changepwd")
    public void changepwd(HttpServletResponse response, String token, String newpwd, String oldpwd, String sendCode, String sessionId) {
        try {
            if (!checkParam(response, newpwd, oldpwd, sendCode)) {
                return;
            }

            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysMember sysmember = memberWebService.queryAllById(onlineUser.getMemId().intValue());
            if (!sysmember.getMemberPwd().equals(oldpwd)) {
                sendWarm(response, "旧密码错误");
                return;
            }
            //验证短信验证码
            if (StrUtil.isNull(sessionId)) {//默认验证码
                if (!CnlifeConstants.SMSTR.equals(sendCode)) {
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
                Date sendTime = (Date) session.getAttribute("sendTime");
                long time = new Date().getTime() - sendTime.getTime();
                long minutes = time / 60000;
                if (minutes > CnlifeConstants.CODE_OVERTIME) {
                    sendWarm(response, "验证码超时");
                    return;
                } else if (!sendCode.equalsIgnoreCase(session.getAttribute("code").toString())) {
                    sendWarm(response, "验证码错误");
                    return;
                }
            }
            //验证短信验证码结束，修改密码开始/////
            Boolean result = this.memberService.updatePwd(onlineUser.getMemId(), oldpwd, newpwd);
            if (BooleanUtils.isTrue(result) && !StrUtil.isNull(onlineUser.getDatabase())) {
                SysMember sysmem = sysMemWebService.queryMemBypid(sysmember.getMemberId(), onlineUser.getDatabase());
                if (null != sysmem) {
                    sysmem.setMemberPwd(newpwd);
                    int b = sysMemWebService.updateMem(sysmem, onlineUser.getDatabase());
                    if (b != 1) {
                        sendWarm(response, "修改失败!");
                    }
                }
            }
            if (BooleanUtils.isTrue(result)) {
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
     * 找回密码时验证码的验证
     *
     * @param request
     * @param sendCode
     * @param sessionId
     * @author YYP 2015-07-30
     */
    @RequestMapping("checkCode")
    public void checkCode(HttpServletRequest request, HttpServletResponse response, String sendCode, String sessionId, String mobile) {
        try {
            if (!checkParam(response, sendCode, mobile)) {
                return;
            }
            SysMember member = memberWebService.queryMemberByMobile(mobile);
            if (null == member) {
                sendWarm(response, "要找回密码的账号未注册或输入有误!");
                return;
            }
            //验证短信验证码
            if (StrUtil.isNull(sessionId)) {//默认验证码
                if (!CnlifeConstants.SMSTR.equals(sendCode)) {
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
                Date sendTime = (Date) session.getAttribute("sendTime");
                long time = System.currentTimeMillis() - sendTime.getTime();
                long minutes = time / 60000;
                if (minutes > CnlifeConstants.CODE_OVERTIME) {
                    sendWarm(response, "验证码超时");
                    return;
                } else if (!session.getAttribute("mobile").equals(mobile)) {
                    sendWarm(response, "手机号码不一致");
                    return;
                } else if (!sendCode.equalsIgnoreCase(session.getAttribute("code").toString())) {
                    sendWarm(response, "验证码错误");
                    return;
                }
            }
            sendSuccess(response, "验证码正确");
        } catch (Exception e) {
            sendException(response, e);
            sendWarm(response, "验证出错");
        }
    }

    /**
     * 找回密码时的修改密码
     */
    @RequestMapping("changepwdTo")
    @ResponseBody
    public Response changepwdTo(String mobile, String newpwd) {
        SysMember member = memberWebService.queryMemberByMobile(mobile);
        if (null != member) {
            Integer i = memberWebService.updateMemberPwd(member, newpwd);
            if (i > 0) {
                return Response.createSuccess().setMessage("修改成功");
            } else {
                throw new BizException("修改失败!");
            }
        } else {
            throw new BizException("手机号未注册过或输入有误");
        }

    }

    //获取验证码 type(1 注册 2 修改手机号码 3 修改密码 4 找回密码5余额重置支付密码6微信注册)
    @RequestMapping("getCode")
    public void sendCode(HttpServletResponse response, HttpServletRequest request, String mobile, String type) {
        if (!checkParam(response, mobile, type)) {
            return;
        }
        String text = "";
        try {
            SysMember sys = this.memberWebService.queryMemberByTel(mobile);
            if (("1".equals(type) || "2".equals(type)) && null != sys) {//注册，且号码已经存在
                sendWarm(response, "该号码已经注册过!");
                return;
            }
            if ("4".equals(type) && null == sys) {
                sendWarm(response, "要找回密码的账号未注册或输入有误!");
                return;
            }
            if ("5".equals(type) && null == sys) {
                sendWarm(response, "要重置密码的账号未注册或输入有误!");
                return;
            }
            int cnum = (int) (Math.random() * 999999 + 100000);

            text = "【驰用T3】您的验证码是" + cnum;
            //System.out.println(cnum);
            String str = JavaSmsApi.sendSms(text, mobile);
            net.sf.json.JSONObject result = net.sf.json.JSONObject.fromObject(str);
            Integer status = (Integer) result.get("code");
            if (status > 0) {//短信发送失败
                String error = "短信发送失败，错误信息:" + result.get("msg") + ",错误码：" + status + ",错误详情：" + result.get("detail") + ",号码：" + mobile;
                logger.error(error);
                sendWarm(response, error);
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("code", cnum);
            session.setAttribute("mobile", mobile);
            session.setAttribute("sendTime", new Date());
            SessionContext sessionContext = SessionContext.getInstance();
            sessionContext.AddSession(session);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "发送成功,6分钟有效");
            json.put("sessionId", session.getId());
            sendJsonResponse(response, json.toString());
            return;
        } catch (Exception e) {
            log.error("获取验证码出现错误", e);
            sendWarm(response, "获取验证码出现错误" + e.getMessage());
        }
    }


    @RequestMapping("checkSession")
    public void checkSession(HttpServletResponse response, HttpServletRequest request) {

        String text = "";
        try {

            int cnum = (int) (Math.random() * 999999 + 100000);

            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取验证码成功");
            sendJsonResponse(response, json.toString());
            return;
        } catch (Exception e) {
            log.error("检查Session", e);
            e.printStackTrace();
            sendWarm(response, "检查Session");
            return;
        }
    }


    /**
     * 发送验证码到邮箱
     *
     * @param request
     * @param response
     * @param token
     */
    @Deprecated
    @RequestMapping("sendEmail")
    public void sendEmailPwd(HttpServletRequest request, HttpServletResponse response, String token) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            String yzm = StrUtil.generateRandomString(6, 2);
            SysMember usr = this.memberWebService.queryAllById(onlineUser.getMemId());
            if (usr == null) {
                sendWarm(response, "账号错误");
                return;
            }
            if (!StrUtil.isNull(usr.getEmail())) {
                String[] sjr = new String[]{usr.getEmail()};
                Mail mail = new Mail();
                boolean flag = mail.sendMail(sjr, "您正在使用的邮箱进行手机或邮箱修改操作，验证码为：<font color='#7AC5CD'>" + yzm + "</font>", "手机，邮箱修改验证");
                if (flag) {
                    sendSuccess(response, "发送成功");
                    TokenServer.addCode(yzm, onlineUser.getTel());
                } else {
                    sendWarm(response, "发送失败");
                }
            } else {
                sendWarm(response, "邮箱不能为空");
            }
        } catch (Exception e) {
            log.error("检查Session", e);
            e.printStackTrace();
            sendException(response, e);
        }
    }

    /**
     * 新平台登陆----陈总
     */
    @Deprecated
    @RequestMapping("/loginNew")
    public void loginNew(HttpServletRequest request, HttpServletResponse response, String mobileNew, String tokenNew, String unId) {
        try {
            String url = PropertiesUtils.readProperties("/properties/jdbc.properties", "OURURL");
            if (!checkParam(response, mobileNew, tokenNew)) return;
            String reqJsonStr = "{\"user_id\":\"" + mobileNew + "\", \"token\":\"" + tokenNew + "\"}";
            String js = MapGjTool.postqq("http://" + url + "/index/checkUserToken", reqJsonStr);
            JSONObject dataJson = new JSONObject(js);
            if (dataJson.getInt("code") != 0) {
                sendWarm(response, dataJson.getString("msg"));
                return;
            }
            Integer cid = 0;
            SysMember sysMember = memberWebService.queryMemberByMobile(mobileNew);
            if (!StrUtil.isNull(sysMember)) {
                if (!StrUtil.isNull(sysMember.getCid())) {
                    cid = sysMember.getCid();
                }
                if (!StrUtil.isNull(unId)) {
                    SysMember sysMember2 = memberWebService.queryMemberByunId(unId);
                    if (!StrUtil.isNull(sysMember2)) {
                        if (!mobileNew.equals(sysMember2.getMemberMobile())) {
                            sendWarm(response, "此设备已绑定账号，不能使用其他账号");
                            return;
                        }
                    }
                    if (!StrUtil.isNull(sysMember.getUnId())) {
                        if (!sysMember.getUnId().equals("1")) {
                            if (!unId.equals(sysMember.getUnId())) {
                                sendWarm(response, "此账号已绑定其他设备，不能在此设备登录");
                                return;
                            }
                        }
                    } else {
                        if (sysMember.getDatasource().equals("sjk1460427117375139")) {
                            memberWebService.updateunId(sysMember.getDatasource(), unId, sysMember.getMemberId());
                        }
                    }
                }
            }
            if (StrUtil.isNull(sysMember)) {
                sendWarm(response, "用户名不存在");
                return;
            } else if (!"1".equals(sysMember.getMemberUse())) {
                sendWarm(response, "该用户禁用");
                return;
            } else {
                String datasource = "";
                String tpNm = "";
                String endDate = "";
                if (!"".equals(sysMember.getDatasource()) && null != sysMember.getDatasource()) {//没有对应公司(数据库)
                    datasource = sysMember.getDatasource();
                    SysCorporation corporation = this.corporationService.queryCorporationBydata(datasource);
                    endDate = corporation.getEndDate();
                    tpNm = corporation.getTpNm();
                }
                OnlineUser onlineUser = new OnlineUser(sysMember.getMemberId(), sysMember.getMemberNm(), sysMember.getMemberMobile(), datasource, tpNm, sysMember.getCid());
                String token = StrUtil.string2MD5(onlineUser.getTel() + onlineUser.getMemberNm() + new Date());
                onlineUser.setToken(token);
                TokenServer.checkLoginState(sysMember.getMemberId());//是否重复登录操作
                TokenServer.tokenCreated(onlineUser, DEVICE_MOBILE);
                Cookie cookie = new Cookie("QWEIB_TOKEN", token);
                cookie.setPath("/");
                response.addCookie(cookie);
                //查询成员角色（多个，隔开），以最小的id作为值
                String roles = companyRoleService.checkHasAdminRole(onlineUser.getMemId(), datasource);
                if (!StrUtil.isNull(endDate)) {
//						int dnum=DateTimeUtil.getDaysDiff(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"),endDate, "yyyy-MM-dd");
//						if(dnum>0){
                    JSONObject json = new JSONObject();
                    json.put("memId", onlineUser.getMemId());
                    json.put("memberNm", sysMember.getMemberNm());
                    json.put("memberHead", sysMember.getMemberHead());
                    json.put("memberMobile", onlineUser.getTel());
                    json.put("isUnitmng", roles);
                    json.put("datasource", onlineUser.getDatabase());
                    json.put("msgmodel", sysMember.getMsgmodel());
                    json.put("tpNm", tpNm);
                    json.put("cid", cid);
                    json.put("companyId", sysMember.getUnitId());
                    json.put("token", token);
                    json.put("state", true);
                    json.put("msg", "登录成功");
//							if(dnum<=5){
//								json.put("msg2","您还有"+dnum+"天到期，请及时续费");
//							}
                    sendJsonResponse(response, json.toString());
                    return;
//						}else{
//							sendWarm(response, "您已到期了，请及时续费才能正常使用");
//							return;
//						}
                } else {
                    JSONObject json = new JSONObject();
                    json.put("memId", onlineUser.getMemId());
                    json.put("memberNm", sysMember.getMemberNm());
                    json.put("memberHead", sysMember.getMemberHead());
                    json.put("memberMobile", onlineUser.getTel());
                    json.put("isUnitmng", roles);
                    json.put("datasource", onlineUser.getDatabase());
                    json.put("msgmodel", sysMember.getMsgmodel());
                    json.put("tpNm", tpNm);
                    json.put("cid", cid);
                    json.put("companyId", sysMember.getUnitId());
                    json.put("token", token);
                    json.put("state", true);
                    json.put("msg", "登录成功");
                    sendJsonResponse(response, json.toString());
                    return;
                }
            }
        } catch (Exception e) {
            log.error("登录出错", e);
            e.printStackTrace();
            sendException(response, e);
        }
    }

    @ResponseBody
    @GetMapping("member/login/page")
    public Response memberLoginPage(MemberLoginQuery query, @PageableDefault(size = 20) Pageable pageable) {
        final SysLoginInfo loginUser = UserContext.getLoginInfo();
        query.setMemberId(loginUser.getIdKey());
        com.qweibframework.commons.page.Page<MemberLoginShowDTO> page = this.memberLoginService.page(query, pageable.getPageNumber(), pageable.getPageSize());

        return Response.createSuccess(page);
    }
}
