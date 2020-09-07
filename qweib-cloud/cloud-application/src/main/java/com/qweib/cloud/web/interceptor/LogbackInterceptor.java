package com.qweib.cloud.web.interceptor;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.ViewContext;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.commons.Identities;
import com.qweib.commons.IpUtils;
import org.slf4j.MDC;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author: jimmy.lin
 * @time: 2019/2/25 11:54
 * @description:
 */
public class LogbackInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        SysLoginInfo info = UserContext.getLoginInfo();
        String ip = IpUtils.getIpAddr(request);
        String ds = "";
        String uname = "";
        String uid = "";
        String mobile = "";
        String company = "";
        MDC.put("req", request.getRequestURI());
        MDC.put("ip", ip);
        MDC.put("traceId", Identities.uuid());
        if (info != null) {
            ds = info.getDatasource();
            uname = info.getUsrNm();
            uid = String.valueOf(info.getIdKey());
            mobile = info.getFdMemberMobile();
            company = info.getFdCompanyNm();
        }
        MDC.put("ds", ds);
        MDC.put("uname", uname);
        MDC.put("uid", uid);
        MDC.put("mobile", mobile);
        MDC.put("company", company);
        MDC.put("v", ViewContext.getVersion());
        return super.preHandle(request, response, handler);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        MDC.clear();
        super.afterCompletion(request, response, handler, ex);
    }
}
