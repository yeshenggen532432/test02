package com.qweib.cloud.biz.system.controller.plat;

import com.google.common.collect.Lists;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.ViewContext;
import com.qweib.cloud.biz.system.auth.JwtPayload;
import com.qweib.cloud.biz.system.auth.JwtUtils;
import com.qweib.cloud.biz.system.controller.plat.vo.LoginRequest;
import com.qweib.cloud.biz.system.security.MarkResult;
import com.qweib.cloud.biz.system.security.Platform;
import com.qweib.cloud.biz.system.security.SecurityManager;
import com.qweib.cloud.biz.system.service.member.MemberLoginService;
import com.qweib.cloud.biz.system.service.member.MemberLoginUtils;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.service.plat.SysLoginService;
import com.qweib.cloud.biz.system.service.plat.SysMemberCompanyService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.utils.MemberUtils;
import com.qweib.cloud.core.dao.DynamicDataSourceAction;
import com.qweib.cloud.core.dao.DynamicDataSourceTemplate;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.SysMemberCompany;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.common.CompanyStatusEnum;
import com.qweib.cloud.service.member.common.DeviceEnum;
import com.qweib.cloud.service.member.common.LoginTypeEnum;
import com.qweib.cloud.service.member.common.RemoteControlStatusEnum;
import com.qweib.cloud.service.member.domain.corporation.CorporationStandaloneDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyQuery;
import com.qweib.cloud.service.member.domain.member.login.MemberLoginSave;
import com.qweib.cloud.service.member.retrofit.corporation.CorporationStandaloneRetrofitApi;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.SoftKey;
import com.qweib.cloud.utils.Statics;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.exceptions.BizException;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import com.qweibframework.commons.IpUtils;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.StringUtils;
import com.wf.captcha.utils.CaptchaUtil;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.util.*;

import static com.qweib.cloud.service.member.common.CertifyStateEnum.CERTIFIED;


@Controller
@RequestMapping("/manager")
public class SysLoginControl extends GeneralControl {
    @Resource
    private SysLoginService loginService;
    @Resource
    private SysMemberService memberService;
    @Resource
    private SysMemberCompanyService memberCompanyService;
    @Resource
    private SysCorporationService corporationService;
    @Autowired
    private SecurityManager securityManager;
    @Autowired
    private DataSourceContextAllocator dataSourceAllocator;
    @Autowired
    private MemberLoginService memberLoginService;
    @Autowired
    private DynamicDataSourceTemplate dataSourceTemplate;
    @Qualifier("stringRedisTemplate")
    @Autowired
    private RedisTemplate redisTemplate;
    //@Autowired
    //private CorporationStandaloneRetrofitApi standaloneRetrofitApi;

    /**
     * 生成随机数
     *
     * @return
     */
    public String getRnd() {
        int number_1 = (int) (Math.random() * 65535) + 1;
        int number_2 = (int) (Math.random() * 65535) + 1;
        String s_rnd = (new Integer(number_1)).toString() + (new Integer(number_2)).toString();
        return s_rnd;
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：到登录页面
     */

    @GetMapping("/login")
    public String toLogin(Model model, HttpServletRequest request) {
        SysLoginInfo info = (SysLoginInfo) request.getSession().getAttribute("usr");
        if (info != null) {
            //已登录回到首页
            return "redirect:/";
        }
        String usrNo = request.getParameter("usrNo");
        String rnd = getRnd();
        request.getSession().setAttribute("rnd", rnd);
        model.addAttribute("usrNo", usrNo);
        ViewContext.setSticky("v2");
        return "main/login/login";
    }

    @RequestMapping("/relogin")
    public String relogin(Model model, HttpServletRequest request) {
        String rnd = getRnd();
        request.getSession().setAttribute("rnd", rnd);
        return "main/login/relogin";
    }


    @RequestMapping("reDoLogin")
    public void reDoLogin(@RequestParam("usrNo") String username, @RequestParam("usrPwd") String password,
                          @RequestParam(value = "captcha", required = false) String captcha,
                          Model model, HttpServletRequest request, HttpServletResponse response) {
        JSONObject json = new JSONObject();
        if ("admin".equals(username)) {
            json.put("state", false);
            json.put("msg", "用户名错误");
            this.sendJsonResponse(response, json.toString());
        }
        String rnd = (String) request.getSession().getAttribute("rnd");
        final String EncData = request.getParameter("EncData");//客户端运算结果
        final String dogUser = request.getParameter("dogUser");
        final String idKey = request.getParameter("idKey");

        //String m_StrEnc = new SoftKey().StrEnc(rnd,Key);
        try {
            SysLoginInfo info = this.loginService.queryLoginInfo(username);
            //账号不存在
            if (null == info) {
                json.put("state", false);
                json.put("msg", "用户名错误");
                this.sendJsonResponse(response, json.toString());
            }

            //密码输入不正确
            String memberPwd = info.getUsrPwd().toUpperCase();
            if (!password.toUpperCase().equals(memberPwd)) {
                json.put("state", false);
                json.put("msg", "密码不正确");
                this.sendJsonResponse(response, json.toString());
            }

            final String datasource = info.getDatasource();
            //验证软件狗
            try {
                this.dataSourceAllocator.alloc(info.getDatasource(), info.getIdKey().toString());
                SysMember companyMember = this.loginService.querySysMemberById1(datasource, info.getIdKey());
                if (companyMember != null) {
                    // 使用软件狗验证
                    if (companyMember.getUseDog() != null &&
                            companyMember.getUseDog().intValue() == 1) {
                        boolean checkTicket = true;
                        if (!companyMember.getIdKey().equals(idKey)) {
                            checkTicket = false;
                        }
                        if (checkTicket &&
                                !companyMember.getMemberMobile().equals(dogUser)) {
                            checkTicket = false;
                        }
                        Integer comId = Integer.parseInt(info.getFdCompanyId());

                        SysCorporation com = this.corporationService.queryCorporationById(comId);
                        if (checkTicket && com != null) {
                            String dogKey = com.getDogKey();
                            if (dogKey == null) dogKey = "";
                            if (dogKey.length() == 0) dogKey = "F234567890ABCDEF1234567890ABCDEF";
                            String m_StrEnc = new SoftKey().StrEnc(rnd, dogKey);
                            if (!m_StrEnc.equals(EncData)) {
                                checkTicket = false;
                                //System.out.println("EncData=" + EncData);
                                //System.out.println("m_StrEnc=" + m_StrEnc);
                            }
                        }

                        // 验证失败
                        if (!checkTicket) {
                            json.put("state", false);
                            json.put("msg", "UKey验证错误");
                            this.sendJsonResponse(response, json.toString());
                        }
                    }
                }
                //查询角色
                try {
                    List<Integer> roleIds = this.loginService.queryRoleIdByUsr(info.getIdKey(), datasource);
                    info.setUsrRoleIds(roleIds);
                } catch (Exception ex) {
                    log.error("query roles error", ex);
                }
            } finally {
                this.dataSourceAllocator.release();
            }
            //===========加载该会员有几家公司 begin================
            SysMemberCompany query = new SysMemberCompany();
            query.setMemberId(info.getIdKey());
            query.setDimission(false);
            List<SysMemberCompany> smcList = this.memberCompanyService.querySysMemberCompanyList(query);

            List<Map<String, Object>> companyList = Lists.newArrayList();
            boolean selectFind = MemberUtils.transferMemberCompanies1(companyList, smcList, info.getFdCompanyId());
            info.setCompanyList(companyList);
            //===========加载该会员有几家公司 end  ================
            // 如果当前企业被禁用或不存在
            if (!selectFind) {
                info.setUsrRoleIds(null);
                info.setDatasource(null);
                info.setFdCompanyId(null);
                info.setFdCompanyNm(null);
            }
            String token = StrUtil.string2MD5(info.getUsrNo() + info.getUsrNm() + new Date());
            token = token + "-" + info.getIdKey().toString();
            info.setToken(token);
            setLoginInfo(request,info);
            //request.getSession().setAttribute("usr", info);
            rnd = getRnd();
            request.getSession().setAttribute("rnd", rnd);
            json.put("state", true);
            json.put("msg", "登录成功!");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("login error", e);
            json.put("state", false);
            json.put("msg", "登录出错");
            this.sendJsonResponse(response, json.toString());
        }
    }


    /**
     * 摘要：
     *
     * @return
     * @说明：去session过期登录
     * @创建：作者:yxy 创建时间：2013-4-27
     * @修改历史： [序号](yxy 2013 - 4 - 27)<修改说明>
     */
    @RequestMapping("/tologin")
    public String gologin() {
        return "redirect:/manager/login";
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：退出
     * @创建：作者:yxy 创建时间：2013-4-27
     * @修改历史： [序号](yxy 2013 - 4 - 27)<修改说明>
     */
    @RequestMapping({"/loginout", "logout"})
    public String loginout(HttpServletRequest request) {
        request.getSession().removeAttribute("usr");
        String rnd = getRnd();
        request.getSession().setAttribute("rnd", rnd);
        ViewContext.setSticky("v2");
        return "main/login/login";
    }


    @RequestMapping("checkLogin")
    public void checkLogin(HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        JSONObject json = new JSONObject();
        try {
            if (null == info && request.getParameter("userId") == null) {
                json.put("state", false);
                this.sendJsonResponse(response, json.toString());
                return;
            }
            json.put("state", true);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("检查登录是否出错", e);
            json.put("state", false);
            this.sendJsonResponse(response, json.toString());

        }
    }

    @ResponseBody
    @PostMapping("login")
    public Response login(@Valid @RequestBody LoginRequest form, HttpServletRequest request) {
        SysLoginInfo info = loginService.queryLoginInfo(form.getUsername());
        if (info == null) {
            throw new BizException("用户不存在");
        }
        if (!StringUtils.equalsIgnoreCase(form.getPassword(), info.getUsrPwd())) {
            throw new BizException("用户名或密码不正确");
        }
        info.setFdCompanyId(form.getCompany());
        //TODO 软件狗验证
        String datasource = info.getDatasource();
        //指定数据源
        dataSourceAllocator.alloc(datasource, info.getFdCompanyId());
        dataSourceTemplate.execute(info.getFdCompanyId(), ds -> {
            List<Integer> roleIds = loginService.queryRoleIdByUsr(info.getIdKey(), datasource);
            info.setUsrRoleIds(roleIds);
            //加载所在公司列表
            List<Map<String, Object>> companies = Lists.newArrayList();
            SysMemberCompany query = new SysMemberCompany();
            query.setDimission(false);
            query.setMemberId(info.getIdKey());
            List<SysMemberCompany> smcList = memberCompanyService.querySysMemberCompanyList(query);
            boolean found = true;//MemberUtils.transferMemberCompanies(companies, smcList, info.getFdCompanyId());
            info.setCompanyList(companies);
            //若当前企业被禁用或不存在
            if (!found) {
                info.setUsrRoleIds(null);
                info.setDatasource(null);
                info.setFdCompanyNm(null);
            }
            Integer pageVersion = info.getPageVersion();
            if (pageVersion != null) {
                ViewContext.setVersion(pageVersion.equals(0) ? "v1" : "v2");
            }
            String token = StrUtil.string2MD5(info.getUsrNo() + info.getUsrNm() + new Date());
            token = token + "-" + info.getIdKey().toString();
            info.setToken(token);
            setLoginInfo(request,info);
            //request.getSession().setAttribute("usr", info);
            return null;
        });
        return Response.createSuccess().setMessage("登录成功");
    }

    /**
     * 摘要：
     *
     * @param request
     * @return
     * @说明：登录
     * @创建：作者:yxy 创建时间：2013-4-10
     * @修改历史： [序号](yxy 2013 - 4 - 10)<修改说明>
     */
    @RequestMapping("/dologin")
    public String login(@RequestParam("usrNo") String username, @RequestParam("usrPwd") String password,
                        @RequestParam(required = false) String captcha,
                        Model model, HttpServletRequest request) {
        username = StringUtils.trimToEmpty(username);
        if ("admin".equals(username)) {
            return loginFailure(username, "11", model);
        }
        MarkResult result = securityManager.get(username, Platform.PC);
        //是否已被锁定
        /*if (result.locked()) {
            log.debug("account:[{}] has been locked", username);
            return loginFailure(username, "105", model);
        }*/
        //错误超过3次需要验证码
        /*if (result.captcha() && (StringUtils.isEmpty(captcha) || !CaptchaUtil.ver(captcha, request))) {
            CaptchaUtil.clear(request);
            model.addAttribute("locked", result.locked());
            model.addAttribute("captcha", result.captcha());
            return loginFailure(username, "101", model);
        }*/

        String rnd = (String) request.getSession().getAttribute("rnd");
        final String EncData = request.getParameter("EncData");//客户端运算结果
        final String dogUser = request.getParameter("dogUser");
        final String idKey = request.getParameter("idKey");

        //String m_StrEnc = new SoftKey().StrEnc(rnd,Key);
        try {
            SysLoginInfo info = this.loginService.queryLoginInfo(username);
            //账号不存在
            if (null == info) {
                return loginFailure(username, "11", model);
            }
            info.setCertifyState(CERTIFIED);

            //密码输入不正确
            String memberPwd = info.getUsrPwd().toUpperCase();
            if (!password.toUpperCase().equals(memberPwd)) {
                //错误计数
                result = securityManager.mark(username, Platform.PC);
                model.addAttribute("locked", result.locked());
                model.addAttribute("captcha", result.captcha());
                model.addAttribute("errorCount", result.getCount());
                if (result.getCount() > 2) {
                    model.addAttribute("extra", ",还剩" + result.remain() + "次机会,超过5次账号将被锁定");
                }
                return loginFailure(username, "12", model);
            }
            securityManager.reset(username, Platform.PC);
            final Integer companyId = StringUtils.toInteger(info.getFdCompanyId());
            SysMember companyMember = null;
            String customDomain = null;
//            ClusterNodeDTO nodeDTO = null;
            if (MathUtils.valid(companyId)) {
                final SysCorporation companyDTO = this.corporationService.queryCorporationById(companyId);

                /*CorporationStandaloneDTO standaloneConfig = HttpResponseUtils.convertResponseNull(standaloneRetrofitApi.get(companyId));
                if (standaloneConfig != null) {
                    customDomain = standaloneConfig.getCustomDomain();
                }
                info.setPageVersion(companyDTO.getPageVersion());

                if (StringUtils.isNotBlank(customDomain)) {
                    return "redirect:" + customDomain + "?_jwt=" + JwtUtils.gen(JwtPayload.builder()
                            .userId(info.getIdKey())
                            .companyId(companyId)
                            .build(), standaloneConfig.getAppSecret());
                }*/
//                nodeDTO = this.nodeRedisHandler.getCurrentNode(companyDTO.getNodeId());
                final String datasource = info.getDatasource();
                if (StringUtils.isNotBlank(datasource)) {
                    try {
                        this.dataSourceAllocator.alloc(datasource, companyId.toString());
                        //验证软件狗
                        companyMember = this.loginService.querySysMemberById1(datasource, info.getIdKey());
                        if (companyMember != null) {
                            // 使用软件狗验证
                            if (companyMember.getUseDog() != null &&
                                    companyMember.getUseDog().intValue() == 1) {
                                boolean checkTicket = true;
                                if (!companyMember.getIdKey().equals(idKey)) {
                                    checkTicket = false;
                                }
                                if (checkTicket &&
                                        !companyMember.getMemberMobile().equals(dogUser)) {
                                    checkTicket = false;
                                }

                                if (checkTicket && companyDTO != null) {
                                    String dogKey = companyDTO.getDogKey();
                                    if (StringUtils.isBlank(dogKey)) {
                                        dogKey = "F234567890ABCDEF1234567890ABCDEF";
                                    }
                                    String m_StrEnc = new SoftKey().StrEnc(rnd, dogKey);
                                    if (!m_StrEnc.equals(EncData)) {
                                        checkTicket = false;
                                        //System.out.println("EncData=" + EncData);
                                        //System.out.println("m_StrEnc=" + m_StrEnc);
                                    }
                                }

                                // 验证失败
                                if (!checkTicket) {
                                    return loginFailure(username, "21", model);
                                }
                            }
                        }

                        //查询角色
                        try {
                            List<Integer> roleIds = this.loginService.queryRoleIdByUsr(info.getIdKey(), datasource);
                            info.setUsrRoleIds(roleIds);
                        } catch (Exception ex) {
                            log.error("query roles error", ex);
                        }
                    } finally {
                        this.dataSourceAllocator.release();
                    }
                }
            }
            //===========加载该会员有几家公司 begin================
            SysMemberCompany smc = new SysMemberCompany();
            smc.setMemberMobile(info.getFdMemberMobile());
            smc.setMemberId(info.getIdKey());
            smc.setOutTime("1");
            List<SysMemberCompany> smcList = this.memberCompanyService.querySysMemberCompanyList(smc);
            int flag = 0;//判断默认登录企业是否禁用
            List<Map<String,Object>> companyList = new ArrayList<Map<String,Object>>();
            JsonArray jsonArr = new JsonArray();
            if(smcList!=null&&smcList.size()>0){
                for(int i=0;i<smcList.size();i++){
                    SysMemberCompany c = smcList.get(i);
                    Map<String,Object> map = new HashMap<String,Object>();
                    map.put("companyId", c.getCompanyId());
                    map.put("companyName", c.getMemberCompany());
                    companyList.add(map);
                    JsonObject json = new JsonObject();
                    json.addProperty("companyId", c.getCompanyId());
                    json.addProperty("companyName", c.getMemberCompany());
                    jsonArr.add(json);
                    //没有在正常企业里面说明该用户不在该企业
                    if((c.getCompanyId()+"").equals(info.getFdCompanyId())){
                        flag=1;
                    }
                }
            }

            boolean selectFind = MemberUtils.transferMemberCompanies1(companyList, smcList, info.getFdCompanyId());
            info.setCompanyList(companyList);
            //===========加载该会员有几家公司 end  ================
            // 如果当前企业被禁用或不存在
            if (!selectFind) {

                info.setDatasource(null);
                info.setFdCompanyId(null);
                info.setFdCompanyNm(null);
                //=============================重新定位公司 begin=================================
                if (companyList != null && companyList.size() > 0) {
                    Map<String, Object> map = companyList.get(0);
                    Integer reCompanyId = StringUtils.toInteger(map.get("companyId"));
                    final SysCorporation companyDTO = this.corporationService.queryCorporationById(reCompanyId);
                    info.setPageVersion(companyDTO.getPageVersion());
                    final String datasource = companyDTO.getDatasource();
                    if (StringUtils.isNotBlank(datasource)) {
                        try {
                            this.dataSourceAllocator.alloc(datasource, reCompanyId.toString());
                            //查询角色
                            try {
                                List<Integer> roleIds = this.loginService.queryRoleIdByUsr(info.getIdKey(), datasource);
                                info.setUsrRoleIds(roleIds);
                            } catch (Exception ex) {
                                log.error("query roles error", ex);
                            }
                            info.setDatasource(companyDTO.getDatasource());
                            info.setFdCompanyId(reCompanyId + "");
                            info.setFdCompanyNm(companyDTO.getDeptNm());
                            companyMember = this.loginService.querySysMemberById1(datasource, info.getIdKey());
                            info.setUsrNm(companyMember.getMemberNm());
                            info.setCid(companyMember.getCid());
                        } finally {
                            this.dataSourceAllocator.release();
                        }
                    }
                }
                //=============================重新定位公司 end=================================
            } else if (companyMember != null) {
                //获取当前用户在这家公司的信息
                info.setUsrNm(companyMember.getMemberNm());
                info.setCid(companyMember.getCid());
            }

//            if (nodeDTO != null) {
//                String redirectUrl = ClusterNodeRedisHandler.getRedirectUrl(nodeDTO.getDomainName());
//                if (!StringUtils.startsWith(request.getRequestURL(), redirectUrl)) {
//                    String key = this.nodeRedisHandler.putNodeKey(info);
//                    return "redirect:" + redirectUrl + "node_redirect?key=" + key;
//                }
//            }

            String token = StrUtil.string2MD5(info.getUsrNo() + info.getUsrNm() + new Date());
            token = token + "-" + info.getIdKey().toString();
            info.setToken(token);
            setLoginInfo(request,info);
            //request.getSession().setAttribute("usr", info);
            //默认登录到新版页面
            ViewContext.setVersion("v2");
            rnd = getRnd();
            request.getSession().setAttribute("rnd", rnd);

            if (StringUtils.isNotBlank(info.getFdCompanyId())) {
                MemberLoginSave memberLoginInput = MemberLoginUtils.makeLoginDTO(info.getIdKey(), StringUtils.toInteger(info.getFdCompanyId()), LoginTypeEnum.LOGIN, DeviceEnum.PC, IpUtils.getIpAddr(request));
                this.memberLoginService.pushMemberLogin(memberLoginInput);
            }

            String lastRequestUrl = (String) request.getSession().getAttribute("_LAST_REQUEST_URL");
            if (StringUtils.isNotEmpty(lastRequestUrl)) {
                //删除拦截前访问地址 并重定向至该地址
                request.getSession().removeAttribute("_LAST_REQUEST_URL");
                return "redirect:" + lastRequestUrl;
            } else {
                return "redirect:/";
            }
        } catch (Exception e) {
            log.error("login error", e);
            return loginFailure(username, "15", model);
        }
    }

    private String loginFailure(String username, String showMsg, Model model) {
        model.addAttribute("usrNo", username);
        model.addAttribute("showMsg", showMsg);
        return "main/login/login";
    }

    /**
     * 到修改用户密码信息页面
     *
     * @param model
     * @param request
     * @param usrId
     * @return
     * @创建：作者:YYP 创建时间：Aug 11, 2015
     */
    @RequestMapping("toUpdateUsr")
    public String toUpdateUsr(Model model, HttpServletRequest request, Integer usrId) {
        try {
            SysMember member = memberService.querySysMemberById(usrId);
            model.addAttribute("member", member);
        } catch (Exception e) {
            log.error("到修改admin页面失败");
        }
        return "main/adminoper";
    }

    /**
     * 摘要：
     *
     * @param model
     * @param request
     * @return
     * @说明：到地区页面
     * @创建：作者:yxy 创建时间：2013-4-30
     * @修改历史： [序号](yxy 2013 - 4 - 30)<修改说明>
     */
    @RequestMapping("/getmap")
    public String toMap(Model model, HttpServletRequest request) {
        String city = request.getParameter("city");
        if (!StrUtil.isNull(city)) {
            Double[] coordinates = Statics.getCoordinate(city);
            if (null != coordinates && coordinates.length == 2) {
                model.addAttribute("cityLng", coordinates[0]);
                model.addAttribute("cityLat", coordinates[1]);
                model.addAttribute("cityNm", city);
            }
        }

        //原有位置坐标
        String oldLng = request.getParameter("oldLng");
        if (!StrUtil.isNull(oldLng)) {
            model.addAttribute("oldLng", oldLng);
        }
        String oldLat = request.getParameter("oldLat");
        if (!StrUtil.isNull(oldLat)) {
            model.addAttribute("oldLat", oldLat);
        }

        //模糊地址
        String searchCondition = request.getParameter("searchCondition");
        if (!StrUtil.isNull(searchCondition)) {
            model.addAttribute("searchCondition", searchCondition);
        }
        return "/main/map";
    }


    /**
     * 切换公司
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("/changeCompany")
    public String changeCompany(@RequestParam Integer companyId, HttpServletRequest request, HttpServletResponse response, Model model) {
        SysLoginInfo info = this.getLoginInfo(request);
        String rnd = (String) request.getSession().getAttribute("rnd");
        String usrNo = request.getParameter("usrNo");
        String EncData = request.getParameter("EncData");//客户端运算结果
        String dogUser = request.getParameter("dogUser");
        String idKey = request.getParameter("idKey");
        try {
            SysCorporation company = this.corporationService.queryCorporationById(companyId);
            if (company == null && CompanyStatusEnum.DISABLED.equals(company.getStatus())) {
                return "main/login/login";
            }
            //平台可以跳独立版  独立版不允许跳回平台 TODO
            /*CorporationStandaloneDTO standaloneDTO = HttpResponseUtils.convertResponseNull(standaloneRetrofitApi.get(companyId));
            if (standaloneDTO != null && StringUtils.isNotBlank(standaloneDTO.getCustomDomain())) {
                return "redirect:" + standaloneDTO.getCustomDomain() + "?_jwt=" + JwtUtils.gen(JwtPayload.builder()
                        .userId(info.getIdKey())
                        .companyId(companyId)
                        .build(), standaloneDTO.getAppSecret());
            }*/
            final String database = company.getDatasource();
            //info.set
            //获取当前用户在这家公司的信息
            SysMember companyMember;
            List<Integer> roleIds = new ArrayList<Integer>();
            try {
                this.dataSourceAllocator.alloc(database, companyId.toString());
                try {
                    companyMember = this.memberService.queryCompanySysMemberById(database, info.getIdKey());
                    if (Objects.isNull(companyMember)) {
                        return "main/login/login";
                    }
                } catch (Exception ex) {
                    log.error("query company member error", ex);
                    return "main/login/login";
                }
                try {
                    roleIds = this.loginService.queryRoleIdByUsr(info.getIdKey(), database);
                } catch (Exception ex) {
                    log.error("query role error", ex);
                }
            } finally {
                this.dataSourceAllocator.release();
            }

            // 需要验证软件狗
            if (companyMember != null && companyMember.getUseDog() != null &&
                    companyMember.getUseDog().intValue() == 1) {
                Integer checkRet = 0;
                if (!companyMember.getIdKey().equals(idKey)) {
                    checkRet = 1;
                }
                if (!companyMember.getMemberMobile().equals(dogUser)) {
                    checkRet = 2;
                }

                String dogKey = company.getDogKey();
                if (dogKey == null) dogKey = "";
                if (dogKey.length() == 0) dogKey = "F234567890ABCDEF1234567890ABCDEF";
                String m_StrEnc = new SoftKey().StrEnc(rnd, dogKey);
                if (!m_StrEnc.equals(EncData)) {
                    checkRet = 3;
                }

                // 验证失败
                if (checkRet != 0) {
                    model.addAttribute("usrNo", usrNo);
                    model.addAttribute("showMsg", 21);
                    return "main/login/login";
                }
            }

            //获取当前用户的平台信息；
            SysMember platMember = this.memberService.querySysMemberById(info.getIdKey());
            MemberUtils.copyMemberProperties(platMember, companyMember, companyId, company.getDeptNm(), database);

            //更新默认登录的企业
            this.memberService.updatePlatSysMember(platMember);
            info.setPageVersion(company.getPageVersion());
            info.setUsrNm(companyMember.getMemberNm());
            info.setDatasource(database);
            info.setFdCompanyId(companyId.toString());
            info.setFdCompanyNm(company.getDeptNm());
            info.setCid(companyMember.getCid());
            info.setUsrRoleIds(roleIds);
            //===========加载该会员有几家公司 begin================
            SysMemberCompany query = new SysMemberCompany();
            query.setMemberId(info.getIdKey());
            query.setDimission(false);
            List<SysMemberCompany> smcList = this.memberCompanyService.querySysMemberCompanyList(query);

            List<Map<String, Object>> companyList = Lists.newArrayList();
            MemberUtils.transferMemberCompanies1(companyList, smcList, info.getFdCompanyId());
            info.setCompanyList(companyList);
            //info.setCompanysJson(jsonArr.getAsString());
            //===========加载该会员有几家公司 end  ================

//            final ClusterNodeDTO nodeDTO = this.nodeRedisHandler.getCurrentNode(company.getNodeId());
//            if (nodeDTO != null) {
//                String redirectUrl = ClusterNodeRedisHandler.getRedirectUrl(nodeDTO.getDomainName());
//                if (!StringUtils.startsWith(request.getRequestURL(), redirectUrl)) {
//                    String key = this.nodeRedisHandler.putNodeKey(info);
//                    request.getSession().removeAttribute("usr");
//                    return "redirect:" + redirectUrl + "node_redirect?key=" + key;
//                }
//            }
            MemberLoginSave memberLoginInput = MemberLoginUtils.makeLoginDTO(info.getIdKey(), companyId, LoginTypeEnum.SWITCH, DeviceEnum.PC, IpUtils.getIpAddr(request));
            //this.memberLoginService.pushMemberLogin(memberLoginInput);
            request.getSession().setAttribute("usr", info);


            return "redirect:/";
        } catch (Exception e) {
            e.printStackTrace();
            log.error("登录出错：", e);
        }
        return "main/login/login";
    }

    /**
     * 远程控制生成管理员帐号
     *
     * @return
     */
    @GetMapping("remote_control")
    public String controlCompany(@RequestParam String token, HttpServletRequest request) {
        String key = "remote_control:" + token;
        Map<String, Object> entries = this.redisTemplate.opsForHash().entries(key);
        if (Collections3.isEmpty(entries)) {
            return "main/login/login";
        }

        Integer companyId = null;
        String database = null;
        RemoteControlStatusEnum status = RemoteControlStatusEnum.UNKNOWN;
        for (Map.Entry<String, Object> entry : entries.entrySet()) {
            String hashKey = entry.getKey();
            switch (hashKey) {
                case "companyId": {
                    companyId = StringUtils.toInteger(entry.getValue());
                    break;
                }
                case "database": {
                    database = StringUtils.trimToNull((String) entry.getValue());
                    break;
                }
                case "status": {
                    status = RemoteControlStatusEnum.getByStatus((String) entry.getValue());
                    break;
                }
            }
        }

        if (!status.hasUnused()) {
            throw new BizException("该 token 已被使用");
        }

        if (!MathUtils.valid(companyId) || StringUtils.isBlank(database)) {
            throw new BizException("token 出错");
        }

        final String tmpDatabase = database;
        final Integer tmpCompanyId = companyId;
        SysLoginInfo loginInfo = this.dataSourceTemplate.execute(companyId.toString(), tmpDatabase, (DynamicDataSourceAction<SysLoginInfo>) datasource -> {
            Integer adminMemberId = this.memberService.queryAdminMemberId(tmpDatabase);
            if (!MathUtils.valid(adminMemberId)) {
                throw new BizException("该企业无管理员帐号");
            }

            SysCorporation company = this.corporationService.queryCorporationById(tmpCompanyId);
            SysMember companyMember = this.memberService.queryCompanySysMemberById(tmpDatabase, adminMemberId);
            List<Integer> roleIds = this.loginService.queryRoleIdByUsr(adminMemberId, tmpDatabase);

            SysLoginInfo info = this.loginService.queryLoginInfo(companyMember.getMemberMobile());
            info.setPageVersion(company.getPageVersion());
            info.setUsrNm(companyMember.getMemberNm());
            info.setDatasource(tmpDatabase);
            info.setFdCompanyId(tmpCompanyId.toString());
            info.setFdCompanyNm(company.getDeptNm());
            info.setCid(companyMember.getCid());
            info.setUsrRoleIds(roleIds);

            return info;
        });

        if (Objects.nonNull(loginInfo)) {
            final String sessionId = request.getSession().getId();
            Map<String, String> dataMap = new HashMap<>();
            dataMap.put("sessionId", sessionId);
            dataMap.put("status", RemoteControlStatusEnum.USED.getStatus());
            this.redisTemplate.opsForHash().putAll(key, dataMap);
            request.getSession().setAttribute("usr", loginInfo);

            return "redirect:/";
        } else {
            return "main/login/login";
        }
    }
}
