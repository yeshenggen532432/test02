package com.qweib.cloud.web.interceptor;

import com.qweib.cloud.biz.common.TokenContext;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.service.basedata.domain.platform.SysUseLogSave;
import com.qweib.cloud.utils.HttpUtils;
import com.qweib.commons.IpUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.mapper.BeanMapper;
import com.qweib.commons.mapper.JsonMapper;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import com.qweibframework.boot.datasource.tenancy.TenantContext;
import com.qweibframework.boot.datasource.tenancy.TenantInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Optional;
import java.util.Properties;

/**
 * @author: jimmy.lin
 * @time: 2019/4/26 17:22
 * @description: 系统访问情况拦截器
 */

public class AppUserAccessInterceptor extends AbstractLogCacheInterceptor {

    //    @Autowired
//    private SysUseLogService useLogService;
    @Value("${qweib.kafka.topic.user-log:topic-qweib-use-log}")
    private String useLogTopic;
    @Autowired
    private KafkaTemplate kafkaTemplate;
    @Autowired
    private DataSourceContextAllocator dataSourceContextAllocator;
    private static final String APP_LOG_NAME = "手机端访问";
    @Autowired
    @Qualifier("properties")
    private Properties properties;


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String token = getMainParam(request, "token", "QWEIB_TOKEN");
        String url = request.getRequestURI();
        if(url.indexOf("mainWeb")>0)
        {
            return super.preHandle(request, response, handler);
        }
        if(url.indexOf("mallShop")>0)
        {
            return super.preHandle(request, response, handler);
        }
        if(url.indexOf("shopWareMobile") > 0)
        {
            return super.preHandle(request, response, handler);
        }
        if(url.indexOf("shopWareGroupWeb")>0)
        {
            return super.preHandle(request, response, handler);
        }

        if(url.indexOf("shopWaretypeMobile")>0)
        {
            return super.preHandle(request, response, handler);
        }
        if (!isLogin(token)) {
            if (HttpUtils.isAjax(request)) {
                throw new BizException(413, "请先登录系统");
            }
        }
        request.setAttribute("conf", properties);
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            throw new BizException(413, message.getMessage());
//            return super.preHandle(request, response, handler);
        }
        /*if (url.indexOf("web/mainWeb") > 0 && message.getOnlineMember().getMemId() == null) {
            if (companyId == null) companyId = "";
            response.sendRedirect("/web/mainWeb/toWeixinRegister?companyId=" + companyId);
            return false;
        }*/

        //增加手机端登录上下文
        OnlineUser user = message.getOnlineMember();
        if (user != null) {
            SysLoginInfo principal = BeanMapper.map(user, SysLoginInfo.class);
            principal.setIdKey(user.getMemId());
            principal.setShopMemberId(user.getShopMemberId());
            principal.setUsrNm(user.getMemberNm());
            principal.setFdMemberMobile(user.getTel());
            principal.setDatasource(user.getDatabase());
            if (StringUtils.isNotEmpty(user.getCompanys())) {
                principal.setCompanyList(JsonMapper.fromJsonString(user.getCompanys(), List.class));
            }
            UserContext.setLoginInfo(principal);
            TokenContext.setToken(message);
            UserContext.setDataSourceKey(request.getParameter("_uglcw_ds"));
            String scope = request.getParameter("_scope");
            if (StringUtils.equalsIgnoreCase(scope, "member")) {
                //个人空间请求优先走member数据源
                UserContext.setDataSourceKey("member");
                TenantContext.setTenant(TenantInfo.builder().tenantId(user.getMemId()).build());
            }
            dataSourceContextAllocator.alloc(user.getDatabase(), user.getFdCompanyId());
        }

        //设置数据源上下文


        String memberMobile = Optional.ofNullable(user.getTel()).orElse(user.getToken());
        if (this.urlIsRepeatAccess(memberMobile, url)) {
            return super.preHandle(request, response, handler);
        }

        SysUseLogSave useLogSave = new SysUseLogSave();
        useLogSave.setDbName(user.getDatabase());
        useLogSave.setCompanyId(user.getFdCompanyId());
        useLogSave.setCompanyName(user.getFdCompanyNm());
        useLogSave.setMemberMobile(memberMobile);
        Optional.ofNullable(user.getMemId())
                .ifPresent(memberId -> useLogSave.setMemberId(memberId.toString()));
        useLogSave.setMemberName(user.getMemberNm());
        useLogSave.setFuncName(APP_LOG_NAME);
        useLogSave.setFuncUrl(url);
        useLogSave.setClientIp(IpUtils.getIpAddr(request));
        //kafkaTemplate.send(useLogTopic, useLogSave.getCompanyId(), useLogSave);
//        useLogService.addUseLog(useLog);

//        RoleMenus.getMenuByLink(url)
//                .ifPresent(e -> {
//                    OnlineUser info = message.getOnlineMember();
//                    SysUseLog useLog = new SysUseLog();
//                    useLog.setDataSource(info.getDatabase());
//                    useLog.setFdCompanyId(info.getFdCompanyId());
//                    useLog.setFdCompanyNm(info.getFdCompanyNm());
//                    useLog.setFdMemberMobile(info.getTel());
//                    useLog.setFdMemberId(info.getMemId() + "");
//                    useLog.setFdMemberNm(info.getMemberNm());
//                    useLog.setFdCreateTime(DateUtils.getDateTime());
//                    useLog.setFdUrl(url);
//                    useLog.setFdIp(IpUtils.getIpAddr(request));
//                    useLog.setFdMenuName(e.getName());
//                    useLogService.addUseLog(useLog);
//                });
        return super.preHandle(request, response, handler);
    }

//    private boolean isLogin(String token) {
//        if (token == null || token.length() == 0) {
//            return false;
//        }
//        OnlineMessage message = TokenServer.tokenCheck(token);
//        return message.isSuccess();
//    }

    private boolean isLogin(String token) {
        if (token == null || token.length() == 0) {
            return false;
        }
        OnlineMessage message = TokenServer.tokenCheck(token);
        return message.isSuccess();
    }

    private String getMainParam(HttpServletRequest request, String name, String cookieName) {
        String token = request.getHeader(name);
        /*if (StringUtils.isEmpty(token)) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (StringUtils.equals(cookieName, cookie.getName())) {
                        token = cookie.getValue();
                    }
                }
            }
        }*/
        return StringUtils.isEmpty(token) ? request.getParameter(name) : token;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        UserContext.clearLoginInfo();
        TokenContext.clear();
        dataSourceContextAllocator.release();
        super.afterCompletion(request, response, handler, ex);
    }
}
