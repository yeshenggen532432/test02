package com.qweib.cloud.web.interceptor;


import com.google.common.collect.Lists;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.ViewContext;
import com.qweib.cloud.biz.system.auth.AuthManager;
import com.qweib.cloud.biz.system.auth.JwtPayload;
import com.qweib.cloud.biz.system.auth.JwtUtils;
import com.qweib.cloud.biz.system.controller.plat.SysLoginControl;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.service.plat.SysLoginService;
import com.qweib.cloud.biz.system.service.plat.SysMemberCompanyService;
import com.qweib.cloud.biz.system.utils.MemberUtils;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.SysMemberCompany;
import com.qweib.cloud.repository.plat.RoleMenus;
import com.qweib.cloud.service.basedata.domain.platform.SysUseLogSave;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyQuery;
import com.qweib.cloud.utils.HttpUtils;
import com.qweib.commons.exceptions.BizException;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import com.qweibframework.boot.datasource.tenancy.TenantContext;
import com.qweibframework.boot.datasource.tenancy.TenantInfo;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.exceptions.UnauthorizedException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@Slf4j
public class BaseInterceptor extends HandlerInterceptorAdapter {
    //    @Resource
//    private SysUseLogService useLogService;
    @Autowired
    private DataSourceContextAllocator dataSourceContextAllocator;
    @Value("${qweib.kafka.topic.user-log:topic-qweib-use-log}")
    private String useLogTopic;
    @Autowired
    private KafkaTemplate kafkaTemplate;
    @Autowired
    private AuthManager authManager;
    @Autowired
    @Qualifier("properties")
    private Properties properties;
    @Autowired
    private SysLoginService loginService;
    public static final String LAST_REQUEST_URL = "_LAST_REQUEST_URL";
    @Autowired
    private SysCorporationService corporationService;
    @Autowired
    private SysMemberCompanyService memberCompanyService;
    @Autowired
    private DataSourceContextAllocator dataSourceAllocator;
    @Value("${company.license}")
    private String license;

    @Autowired
    public RedisTemplate redisTemplate;

    public SysLoginInfo getLoginVo(String token)
    {
        String []str = token.split("-");
        if(str.length!= 2)
        {
            return null;
        }
        Long memId = Long.parseLong(str[1]);
        String keyName = "APILogin";

        Integer maxId = 999999;
        Set<Object> loginList = redisTemplate.opsForZSet().rangeByScore(keyName, memId, memId);
        for(Object obj: loginList)
        {
            SysLoginInfo vo = (SysLoginInfo)obj;
            if(vo.getToken().equals(token))
            {
                return vo;
            }
        }
        return null;
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response, Object handler) throws Exception {
        request.setCharacterEncoding("UTF-8");
        String url = request.getRequestURI();
        if (handler instanceof HandlerMethod) {
            HandlerMethod method = (HandlerMethod) handler;
            Object obj = method.getBean();
            if (obj instanceof SysLoginControl) {
                return super.preHandle(request, response, handler);
            }

            //服务端跳转至独立服务器用jwt校验直接登录
            String sign = request.getParameter("_jwt");
            if (StringUtils.isNotEmpty(sign)) {
                if (checkSign(sign, request)) {
                    response.sendRedirect("/");
                    return false;
                }
            }

            SysLoginInfo info = (SysLoginInfo) request.getSession().getAttribute("usr");

            if (setReturnLogin(request, response, info)) return false;
            SysLoginInfo vo2 = getLoginVo(info.getToken());
            if (setReturnLogin(request, response, vo2)) return false;

            if (null == info && request.getParameter("userId") == null) {
                if (HttpUtils.isAjax(request)) {
                    throw new BizException(413, "请登录");
                }
                String queryString = request.getQueryString();
                String lastRequestUrl = request.getRequestURL() + (StringUtils.isNotEmpty(queryString) ? "?" + request.getQueryString() : "");
                request.getSession().setAttribute(LAST_REQUEST_URL, lastRequestUrl);
                response.sendRedirect("/manager/login");
                return false;
            }
            UserContext.setLoginInfo(info);
            //设置数据源上下文
            UserContext.setDataSourceKey(request.getParameter("_uglcw_ds"));
            String scope = request.getParameter("_scope");
            if (StringUtils.equalsIgnoreCase(scope, "member")) {
                //个人空间请求优先走member数据源
                UserContext.setDataSourceKey("member");
                TenantContext.setTenant(TenantInfo.builder().tenantId(info.getIdKey()).build());
            }
            dataSourceContextAllocator.alloc(info.getDatasource(), info.getFdCompanyId());
            boolean permit = authManager.hasPermission(request.getRequestURI(), info.getDatasource(), Optional.ofNullable(info.getUsrRoleIds()).orElse(Lists.newArrayList()), info.getIdKey());
            if (!permit) {
                throw new UnauthorizedException("无访问权限");
            }
            Integer uiVersion = info.getPageVersion();
            if (uiVersion != null) {
                ViewContext.setVersion(uiVersion.equals(0) ? "v1" : "v2");
            }
            final String memberMobile = info.getFdMemberMobile();

            //TODO fixme
            if (!"admin".equals(info.getUsrNm())) {
                if (!(url.contains("manager/nextmenu") || url.contains("manager/getNewMunus"))) {
                    RoleMenus.getMenuByLink(url)
                            .ifPresent(e -> {
                                SysUseLogSave useLogSave = new SysUseLogSave();
                                useLogSave.setDbName(info.getDatasource());
                                useLogSave.setCompanyId(info.getFdCompanyId());
                                useLogSave.setCompanyName(info.getFdCompanyNm());
                                Optional.ofNullable(info.getIdKey())
                                        .ifPresent(memberId -> useLogSave.setMemberId(memberId.toString()));
                                useLogSave.setMemberName(info.getUsrNm());
                                useLogSave.setMemberMobile(memberMobile);
                                useLogSave.setFuncName(e.getName());
                                useLogSave.setFuncUrl(url);
                                useLogSave.setClientIp(getIpAddr(request));
                                //kafkaTemplate.send(useLogTopic, useLogSave.getCompanyId(), useLogSave);
                            });
                }
            }
            request.setAttribute("conf", properties);
            request.setAttribute("principal", info);
        }
        return super.preHandle(request, response, handler);
    }

    private boolean setReturnLogin(HttpServletRequest request, HttpServletResponse response, SysLoginInfo info) throws IOException {
        if(info == null){
            request.getSession().invalidate();
            if (HttpUtils.isAjax(request)) {
                throw new BizException(413, "请登录");
            }
            String queryString = request.getQueryString();
            String lastRequestUrl = request.getRequestURL() + (StringUtils.isNotEmpty(queryString) ? "?" + request.getQueryString() : "");
            request.getSession().setAttribute(LAST_REQUEST_URL, lastRequestUrl);
            response.sendRedirect("/manager/login");
            return true;
        }
        return false;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        UserContext.clearLoginInfo();
        UserContext.clearDataSourceKey();
        dataSourceContextAllocator.release();
        super.afterCompletion(request, response, handler, ex);
    }

    private boolean checkSign(String sign, HttpServletRequest request) {
        if (StringUtils.isBlank(sign)) {
            return false;
        }
        JwtPayload payload = JwtUtils.decode(sign, license);
        Integer idKey = payload.getUserId();
        SysLoginInfo info = loginService.queryByMemberId(payload.getUserId());
        info.setFdCompanyId(payload.getCompanyId().toString());
        final Integer companyId = payload.getCompanyId();
        SysMember companyMember = null;
        if (MathUtils.valid(companyId)) {
            final SysCorporation companyDTO = this.corporationService.queryCorporationById(companyId);
            info.setDatasource(companyDTO.getDatasource());
            final String datasource = info.getDatasource();
            if (StringUtils.isNotBlank(datasource)) {
                try {
                    this.dataSourceAllocator.alloc(datasource, companyId.toString());
                    //验证软件狗
                    companyMember = this.loginService.querySysMemberById1(datasource, info.getIdKey());
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
        } else {
            throw new BizException("切换企业出错");
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

            info.setDatasource(null);
            info.setFdCompanyId(null);
            info.setFdCompanyNm(null);
            //=============================重新定位公司 begin=================================
            if (companyList != null && companyList.size() > 0) {
                Map<String, Object> map = companyList.get(0);
                Integer reCompanyId = com.qweibframework.commons.StringUtils.toInteger(map.get("companyId"));
                final SysCorporation companyDTO = this.corporationService.queryCorporationById(reCompanyId);
                info.setPageVersion(companyDTO.getPageVersion());
                final String datasource = companyDTO.getDatasource();
                if (com.qweibframework.commons.StringUtils.isNotBlank(datasource)) {
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
        request.getSession().setAttribute("usr", info);
        //默认登录到新版页面
        ViewContext.setVersion("v2");
        return true;
    }


    public String getIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }


}
